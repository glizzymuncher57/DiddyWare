local Visuals = {}

-- << Imports >>
local Callbacks = require("@utility/Callbacks")
local Configuration = require("@utility/Configuration")
local Table = require("@utility/Table")
local Environment = require("@core/Environment")

-- << Variables >>
local TextSizeCache = Table:Register("WV_TextSizeCache", {})
local ColorCache = Table:Register("WV_ColorCache", {})
local FloorCache = Table:Register("WV_FloorCache", {})

-- << Cached Globals
local NewColorRGB = Color3.fromRGB
local TextOutlined = draw.TextOutlined
local TextSize = draw.GetTextSize
local WorldToScreen = utility.WorldToScreen
local GetWindowSize = cheat.GetWindowSize
local MathFloor = math.floor

-- << Functions >>
local function GetAttribute(Instance, AttributeName, DefaultValue)
	local Attribute = Instance:GetAttribute(AttributeName)
	return Attribute and Attribute.Value or DefaultValue
end

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

local function CachedFloor(n)
	local v = FloorCache[n]
	if v then
		return v
	end

	v = MathFloor(n)
	FloorCache[n] = v
	return v
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

local function RenderDomains(Settings)
	if not Settings.Enabled then
		return
	end

	local Font = Settings.Font
	local Color = Settings.Color
	local ColorRGB = TableToRGB(Color)
	--
	local ScreenWidth = GetWindowSize()
	local ClosestDomain = Environment.ClosestDomain
	local Domains = Environment.Objects.Domains
	--
	for i = 1, #Domains do
		local Domain = Domains[i]
		if Domain then
			local Health = GetAttribute(Domain, "Health", 0)
			local HealthText = "Domain Health: " .. tostring(CachedFloor(Health))
			local TextWidth, TextHeight = GetTextSize(HealthText, Font)

			local FinalX, FinalY, FinalOnScreen = nil, nil, false

			if ClosestDomain.Instance and Domain == ClosestDomain.Instance and ClosestDomain.Distance <= 40 then
				FinalX = (ScreenWidth / 2) - (TextWidth / 2)
				FinalY = 50
				FinalOnScreen = true
			else
				local ScreenX, ScreenY, OnScreen = utility.WorldToScreen(Domain.Position)
				if OnScreen then
					FinalX = ScreenX - TextWidth / 2
					FinalY = ScreenY - TextHeight / 2
					FinalOnScreen = OnScreen
				end
			end

			if FinalOnScreen and HealthText ~= "" then
				TextOutlined(HealthText, FinalX, FinalY, ColorRGB, Font, Color.a)
			end
		end
	end
end

local function RenderItems(Settings)
	if not Settings.Enabled then
		return
	end

	local Font = Settings.Font
	local Color = Settings.Color
	local ColorRGB = TableToRGB(Color)

	local Items = Environment.Objects.Items
	for i = 1, #Items do
		local Item = Items[i]
		if Item then
			local ScreenX, ScreenY, OnScreen = WorldToScreen(Item.Position)
			if OnScreen then
				local Text = Item.Name
				local TextWidth, TextHeight = GetTextSize(Text, Font)
				local FinalX, FinalY = ScreenX - (TextWidth / 2), ScreenY - (TextHeight / 2)
				if Text ~= "" then
					TextOutlined(Text, FinalX, FinalY, ColorRGB, Font, Color.a)
				end
			end
		end
	end
end

local function Render()
	if not Configuration.GetValue("Visuals Enabled") then
		return
	end

	local Font = Configuration.GetValue("Font Selection")

	RenderDomains({
		Enabled = Configuration.GetValue("Domain Health ESP"),
		Color = Configuration.GetValue("Domain Health ESP Color"),
		Font = Font,
	})

	RenderItems({
		Enabled = Configuration.GetValue("Item ESP"),
		Color = Configuration.GetValue("Item ESP Color"),
		Font = Font,
	})
end

function Visuals:Initialise()
	Callbacks.Add("onPaint", Render)
end

return Visuals
