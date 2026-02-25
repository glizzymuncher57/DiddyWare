local CharacterInfo = {
	Enabled = false,
	DrawCooldowns = false,
	DrawEvasiveBar = false,

	CooldownFillColour = Color3.fromRGB(255, 0, 0),
	CooldownFillAlpha = 180,
	CooldownBackgroundColour = Color3.fromRGB(0, 0, 0),
	CooldownBackgroundAlpha = 0,
	EvasiveBarColour = Color3.fromRGB(121, 74, 148),
}

local Environment = require("@modules/core/Environment")
local COLOUR_BLACK = Color3.new(0, 0, 0)
local COLOUR_WHITE = Color3.new(1, 1, 1)

local function TableToRGB(Table)
	if type(Table) ~= "table" then
		return Color3.fromRGB(255, 255, 255)
	end

	local r = Table.R or Table.r or 255
	local g = Table.G or Table.g or 255
	local b = Table.B or Table.b or 255
	return Color3.fromRGB(r, g, b)
end

function CharacterInfo.DrawPlayer(Player, Data)
	if not Player.IsAlive then
		return
	end

	local _, _, OS = utility.WorldToScreen(Player.Position)
	if not OS then
		return
	end

	local BoundingBox = Player.BoundingBox
	if not BoundingBox then
		return
	end

	if CharacterInfo.DrawEvasiveBar and Data.Evade then
		local EvasivePct = math.clamp(Data.Evade / 50, 0, 1)
		local BarH = BoundingBox.h * EvasivePct
		local BarX = BoundingBox.x - 8
		local BarY = BoundingBox.y
		local Height = BoundingBox.h

		draw.RectFilled(BarX - 1, BarY - 1, 7, Height + 2, COLOUR_BLACK, 0, 255)
		draw.RectFilled(BarX, BarY + Height - BarH, 5, BarH, CharacterInfo.EvasiveBarColour, 0, 255)

		local Text = tostring(math.floor(EvasivePct * 100)) .. "%"
		local TextW = draw.GetTextSize(Text, Environment.Font)
		draw.TextOutlined(Text, BarX - TextW - 2, BarY, COLOUR_WHITE, Environment.Font)
	end

	if CharacterInfo.DrawCooldowns and #Data.OrderedMoves > 0 then
		local NumMoves = #Data.OrderedMoves
		local BoxSize = BoundingBox.h / NumMoves
		local StartX = BoundingBox.x + BoundingBox.w + 2
		local StartY = BoundingBox.y
		for i = 1, #Data.OrderedMoves do
			local Move = Data.OrderedMoves[i]
			local RemainingTime = Move.Remaining
			local BoxY = StartY + (i - 1) * BoxSize
			draw.RectFilled(
				StartX,
				BoxY,
				BoxSize,
				BoxSize,
				CharacterInfo.CooldownBackgroundColour,
				0,
				CharacterInfo.CooldownBackgroundAlpha
			)
			if RemainingTime > 0 then
				local Percent = RemainingTime / Move.Cooldown
				local OverlayWidth = BoxSize * Percent
				draw.RectFilled(
					StartX + BoxSize - OverlayWidth,
					BoxY,
					OverlayWidth,
					BoxSize,
					CharacterInfo.CooldownFillColour,
					0,
					CharacterInfo.CooldownFillAlpha
				)
			end
			draw.Rect(StartX, BoxY, BoxSize, BoxSize, COLOUR_WHITE)

			local Name = Move.Name
			local FontToUse = Environment.Font
			local TextToDraw = Name

			if BoxSize < 40 then
				FontToUse = "SmallestPixel"
			end

			if BoxSize < 25 then
				TextToDraw = string.sub(Name, 1, 1)
			elseif BoxSize < 40 then
				TextToDraw = string.sub(Name, 1, 3)
			end

			if BoxSize >= 15 then
				local TextWidth, TextHeight = draw.GetTextSize(TextToDraw, FontToUse)
				local TextX = StartX + (BoxSize - TextWidth) / 2
				local TextY = BoxY + (BoxSize - TextHeight) / 2
				draw.TextOutlined(TextToDraw, TextX, TextY, COLOUR_WHITE, FontToUse)
			end
		end
	end
end

function CharacterInfo.Draw()
	if not CharacterInfo.Enabled then
		return
	end

	for _, Entity in pairs(entity.GetPlayers(false)) do
		local Data = Environment.Players[Entity.Name]
		if Data then
			CharacterInfo.DrawPlayer(Entity, Data)
		end
	end
end

function CharacterInfo.Initialise(
	Container: typeof(require("@modules/ui/UIWrapper").NewTab(nil, nil):Container(nil, nil, nil))
)
	local Enabled = Container:Checkbox("Character Info", false)
	local DrawCooldowns = Container:Checkbox("Cooldowns", false)
	local CooldownFillColour = Container:Colorpicker("Cooldown Fill Color", { r = 255, g = 0, b = 0, a = 180 }, true)
	local CooldownBackgroundColour =
		Container:Colorpicker("Cooldown Background Color", { r = 0, g = 0, b = 0, a = 200 }, true)
	local DrawEvasiveBar = Container:Checkbox("Evasive Bar", false)
	local EvasiveBarColour = Container:Colorpicker("Evasive Fill Color", { r = 121, g = 74, b = 148, a = 255 }, true)

	cheat.Register("onPaint", function()
		CharacterInfo.Draw()
	end)

	cheat.Register("onSlowUpdate", function()
		CharacterInfo.Enabled = Enabled:Get()
		CharacterInfo.DrawCooldowns = DrawCooldowns:Get()
		CharacterInfo.DrawEvasiveBar = DrawEvasiveBar:Get()

		local CooldownFillRGBA = CooldownFillColour:Get()
		CharacterInfo.CooldownFillColour = TableToRGB(CooldownFillRGBA)
		CharacterInfo.CooldownFillAlpha = CooldownFillRGBA.a

		local CooldownBackgroundRGBA = CooldownBackgroundColour:Get()
		CharacterInfo.CooldownBackgroundColour = TableToRGB(CooldownBackgroundRGBA)
		CharacterInfo.CooldownBackgroundAlpha = CooldownFillRGBA.a

		CharacterInfo.EvasiveBarColour = EvasiveBarColour:Get("rgb")
	end)
end

return CharacterInfo
