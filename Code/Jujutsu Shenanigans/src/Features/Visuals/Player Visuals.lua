local Visuals = {}

-- << Imports >>
local Callbacks = require("@utility/Callbacks")
local Table = require("@utility/Table")
local Configuration = require("@utility/Configuration")
local Environment = require("@core/Environment")

-- << Variables >>
local TextSizeCache = Table:Register("PV_TextSizeCache", {})
local NameCache = Table:Register("PV_NameCache", {})
local ColorCache = Table:Register("PV_ColorCache", {})

-- << Constants >>
local COLOUR_BLACK = Color3.new(0, 0, 0)
local COLOUR_WHITE = Color3.new(1, 1, 1)

-- << Cached Globals
local NewColorRGB = Color3.fromRGB
local Rect = draw.Rect
local RectFilled = draw.RectFilled
local ComputeConvexHull = draw.ComputeConvexHull
local Polyline = draw.Polyline
local ConvexPolyFilled = draw.ConvexPolyFilled
local TextOutlined = draw.TextOutlined
local TextSize = draw.GetTextSize
local PartCorners = draw.GetPartCorners
local WorldToScreen = utility.WorldToScreen

-- << Functions >>
local function TableToRGB(Table)
	if type(Table) ~= "table" then
		return NewColorRGB(255, 255, 255)
	end

	local r = Table.R or Table.r or 255
	local g = Table.G or Table.g or 255
	local b = Table.B or Table.b or 255

	local key = r .. "," .. g .. "," .. b
	local cached = ColorCache[key]

	if cached then
		return cached
	end

	local color = NewColorRGB(r, g, b)
	ColorCache[key] = color

	return color
end

local function GetTextSize(Text, Font)
	local Key = Text .. tostring(Font)
	local Cached = TextSizeCache[Key]
	if Cached then
		return Cached[1], Cached[2]
	end
	local W, H = TextSize(Text, Font)
	TextSizeCache[Key] = { W, H }
	return W, H
end

local function GetNameSlice(Name, Len)
	local Cache = NameCache[Name]
	if not Cache then
		Cache = {}
		NameCache[Name] = Cache
	end

	local Cached = Cache[Len]
	if Cached then
		return Cached
	end

	local Result = string.sub(Name, 1, Len)
	Cache[Len] = Result
	return Result
end

local function AddPartPoints(part, t)
	local corners = PartCorners(part)
	if not corners then
		return
	end

	for _, WorldPosition in ipairs(corners) do
		local X, Y, OnScreen = WorldToScreen(WorldPosition)
		if OnScreen then
			t[#t + 1] = { X, Y }
		end
	end
end

local function Clear(t)
	for i = #t, 1, -1 do
		t[i] = nil
	end
end

local function DrawPlayer(Player, PlayerData, Settings, ScreenPoints)
	if not Player or not PlayerData or not Settings then
		return
	end

	if not Player.IsAlive then
		return
	end

	local Position = Player.Position

	local EvasiveBarColor = Settings.EvasiveBarColor
	local EvasiveBarRGB = TableToRGB(EvasiveBarColor)
	local CooldownFillColor = Settings.CooldownFillColor
	local CooldownFillRGB = TableToRGB(CooldownFillColor)
	local CooldownBackgroundColor = Settings.CooldownBackgroundColor
	local CooldownBackgroundRGB = TableToRGB(CooldownBackgroundColor)
	local AnimationDesyncOutlineColor = Settings.AnimationDesyncOutlineColor
	local AnimationDesyncOutlineRGB = TableToRGB(AnimationDesyncOutlineColor)
	local AnimationDesyncFillColor = Settings.AnimationDesyncFillColor
	local AnimationDesyncFillRGB = TableToRGB(AnimationDesyncFillColor)

	if Settings.AnimationDesyncGuides and PlayerData.Exploiting then
		local RootPart = PlayerData.RootPart
		if not RootPart then
			return
		end

		AddPartPoints(RootPart, ScreenPoints)

		if #ScreenPoints >= 3 then
			local Hull = ComputeConvexHull(ScreenPoints)
			if Hull then
				Polyline(Hull, AnimationDesyncOutlineRGB, true, 2, AnimationDesyncOutlineColor.a)
				ConvexPolyFilled(Hull, AnimationDesyncFillRGB, AnimationDesyncFillColor.a)
			end
		end

		Clear(ScreenPoints)
	end

	local _, _, OnScreen = WorldToScreen(Position)
	if not OnScreen then
		return
	end

	local BoundingBox = Player.BoundingBox
	if not BoundingBox then
		return
	end

	local Font = Settings.Font

	local Evade = PlayerData.Evade

	if Settings.DrawEvasiveBar and Evade then
		local EvasivePct = math.clamp(Evade / 50, 0, 1)
		local BarH = BoundingBox.h * EvasivePct
		local BarX = BoundingBox.x - 8
		local BarY = BoundingBox.y
		local Height = BoundingBox.h

		RectFilled(BarX - 1, BarY - 1, 7, Height + 2, COLOUR_BLACK, 0, 255)
		RectFilled(BarX, BarY + Height - BarH, 5, BarH, EvasiveBarRGB, 0, 255)

		local Text = tostring(math.floor(EvasivePct * 100)) .. "%"
		local TextW = GetTextSize(Text, Font)
		TextOutlined(Text, BarX - TextW - 2, BarY, COLOUR_WHITE, Settings.Font)
	end

	local OrderedMoves = PlayerData.OrderedMoves
	if Settings.DrawCooldowns and OrderedMoves then
		local NumberOfMoves = #OrderedMoves
		local BoxSize = BoundingBox.h / NumberOfMoves
		local StartX, StartY = BoundingBox.x + BoundingBox.w + 2, BoundingBox.y

		for i = 1, NumberOfMoves do
			local Move = OrderedMoves[i]
			local RemainingTime = Move.Remaining
			local BoxY = StartY + (i - 1) * BoxSize

			RectFilled(StartX, BoxY, BoxSize, BoxSize, CooldownBackgroundRGB, 0, CooldownBackgroundColor.a)
			--
			if RemainingTime > 0 then
				local Percent = RemainingTime / Move.Cooldown
				local OverlayWidth = BoxSize * Percent
				--
				RectFilled(
					StartX + BoxSize - OverlayWidth,
					BoxY,
					OverlayWidth,
					BoxSize,
					CooldownFillRGB,
					0,
					CooldownFillColor.a
				)
			end
			Rect(StartX, BoxY, BoxSize, BoxSize, COLOUR_WHITE)
			--

			local Name = Move.Name
			local TextToDraw = Name
			local FontToUse = Font

			if BoxSize < 40 then
				FontToUse = "SmallestPixel"
			end

			if BoxSize < 25 then
				TextToDraw = GetNameSlice(Name, 1)
			elseif BoxSize < 40 then
				TextToDraw = GetNameSlice(Name, 3)
			end

			if BoxSize >= 15 then
				local TextWidth, TextHeight = GetTextSize(TextToDraw, FontToUse)
				local TextX = StartX + (BoxSize - TextWidth) / 2
				local TextY = BoxY + (BoxSize - TextHeight) / 2
				TextOutlined(TextToDraw, TextX, TextY, COLOUR_WHITE, FontToUse)
			end
		end
	end
end

local function Runtime()
	if not Configuration.GetValue("Visuals Enabled") then
		return
	end

	local Settings = {
		DrawCooldowns = Configuration.GetValue("Draw Cooldowns"),
		CooldownFillColor = Configuration.GetValue("Cooldown Fill Color"),
		CooldownBackgroundColor = Configuration.GetValue("Cooldown Background Color"),
		DrawEvasiveBar = Configuration.GetValue("Draw Evasive Bar"),
		EvasiveBarColor = Configuration.GetValue("Evasive Fill Color"),
		AnimationDesyncGuides = Configuration.GetValue("Draw Animation Desync Guides"),
		AnimationDesyncOutlineColor = Configuration.GetValue("Animation Desync Flagged Outline"),
		AnimationDesyncFillColor = Configuration.GetValue("Animation Desync Flagged Fill"),
		Font = Configuration.GetValue("Font Selection"),
	}

	local ScreenPoints = {}

	local EntityList = entity.GetPlayers(false)
	for i = 1, #EntityList do
		local Entity = EntityList[i]
		local Data = Environment.Players[Entity.Name]
		DrawPlayer(Entity, Data, Settings, ScreenPoints)
	end
end

function Visuals:Initialise()
	Callbacks.Add("onPaint", function(...): ...any
		Runtime()
	end)
end

return Visuals
