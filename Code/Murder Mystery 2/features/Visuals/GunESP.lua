local GunDrop = {
	Flags = {
		Enabled = false,
		ShowDistance = false,
		Color = Color3.fromRGB(255, 255, 255),
		Alpha = 255,
	},

	CachedTextSizes = {},
}

local ESP_TEXT = "Gun"
local COLOUR_WHITE = Color3.fromRGB(255, 255, 255)
local GetDistanceSqrt = require("@modules/utility/GetDistanceSqrt")

local Environment = require("@modules/core/Environment")
local PlayerTracker = require("@modules/core/PlayerTracker")
local EntityLocalPlayer = entity.GetLocalPlayer()

local function GetTextSize(Text)
	local TextSize = GunDrop.CachedTextSizes[Text .. Environment.Font]
	if TextSize then
		return TextSize.W, TextSize.H
	end

	local TextWidth, TextHeight = draw.GetTextSize(Text, Environment.Font)
	GunDrop.CachedTextSizes[Text .. Environment.Font] = {
		W = TextWidth,
		H = TextHeight,
	}

	return TextWidth, TextHeight
end

local function TableToRGB(Table)
	if type(Table) ~= "table" then
		return COLOUR_WHITE
	end

	local R = Table.R or Table.r or 255
	local G = Table.G or Table.g or 255
	local B = Table.B or Table.b or 255
	return Color3.fromRGB(R, G, B)
end

function GunDrop.Runtime()
	if not GunDrop.Flags.Enabled then
		return
	end

	if not PlayerTracker:IsPlayerAlive() then
		return
	end

	local ShowDistance = GunDrop.Flags.ShowDistance
	local Color = GunDrop.Flags.Color
	local Alpha = GunDrop.Flags.Alpha

	local GunDrop = Environment.CachedGunDrop
	if not GunDrop then
		return
	end

	local GunDropPosition = GunDrop.Position
	local ScreenX, ScreenY, OnScreen = utility.WorldToScreen(GunDropPosition)
	if OnScreen then
		local TextWidth, TextHeight = GetTextSize(ESP_TEXT)

		local DistanceText = ""
		if ShowDistance then
			local Distance = GetDistanceSqrt(EntityLocalPlayer.Position, GunDropPosition)
			DistanceText = " [" .. tostring(Distance) .. "]"
		end

		local TotalWidth = TextWidth
		if ShowDistance and DistanceText ~= "" then
			TotalWidth = TotalWidth + GetTextSize(DistanceText)
		end

		local StartX = ScreenX - (TotalWidth / 2)
		local StartY = ScreenY - (TextHeight / 2)

		draw.TextOutlined(ESP_TEXT, StartX, StartY, Color, Environment.Font, Alpha)

		if ShowDistance and DistanceText ~= "" then
			draw.TextOutlined(DistanceText, StartX + TextWidth, StartY, COLOUR_WHITE, Environment.Font, Alpha)
		end
	end
end

function GunDrop.Initialise(
	Container: typeof(require("@modules/ui/UIWrapper").NewTab(nil, nil):Container(nil, nil, nil))
)
	local Enabled = Container:Checkbox("Gun Drop ESP", false)
	local ColorPicker = Container:Colorpicker("Gun Drop ESP Color", { r = 255, g = 255, b = 255, a = 255 }, true)
	local ShowDistance = Container:Checkbox("Show Gun Distance", false)

	cheat.Register("onPaint", GunDrop.Runtime)
	cheat.Register("onUpdate", function()
		local ColorRGBA = ColorPicker:Get()

		GunDrop.Flags.Enabled = Enabled:Get()
		GunDrop.Flags.Color = TableToRGB(ColorRGBA)
		GunDrop.Flags.Alpha = ColorRGBA.a
		GunDrop.Flags.ShowDistance = ShowDistance:Get()
		ShowDistance:Visible(GunDrop.Flags.Enabled)
	end)
end

return GunDrop
