local CoinESP = {
	Flags = {
		Enabled = false,
		ShowDistance = false,
		Color = Color3.fromRGB(255, 255, 255),
		Alpha = 255,
	},

	CachedTextSizes = {},
	LastFont = nil,
}

local ESP_TEXT = "Coin"
local TEXT_WIDTH, TEXT_HEIGHT = nil
local COLOUR_WHITE = Color3.fromRGB(255, 255, 255)

local Environment = require("@modules/core/Environment")
local PlayerTracker = require("@modules/core/PlayerTracker")
local GetDistanceSqrt = require("@modules/utility/GetDistanceSqrt")
local EntityLocalPlayer = entity.GetLocalPlayer()

local function GetTextSize(Text)
	local TextSize = CoinESP.CachedTextSizes[Text .. Environment.Font]
	if TextSize then
		return TextSize.W, TextSize.H
	end

	local TextWidth, TextHeight = draw.GetTextSize(Text, Environment.Font)
	CoinESP.CachedTextSizes[Text .. Environment.Font] = {
		W = TextWidth,
		H = TextHeight,
	}

	return TextWidth, TextHeight
end

local function TableToRGB(Table)
	if type(Table) ~= "table" then
		return Color3.fromRGB(255, 255, 255)
	end

	local R = Table.R or Table.r or 255
	local G = Table.G or Table.g or 255
	local B = Table.B or Table.b or 255
	return Color3.fromRGB(R, G, B)
end

function CoinESP.Runtime()
	if not CoinESP.Flags.Enabled then
		return
	end

	if not PlayerTracker:IsPlayerAlive() then
		return
	end

	local ShowDistance = CoinESP.Flags.ShowDistance
	local Color = CoinESP.Flags.Color
	local Alpha = CoinESP.Flags.Alpha

	for _, CoinPosition in pairs(Environment.ActiveCoins) do
		local ScreenX, ScreenY, OnScreen = utility.WorldToScreen(CoinPosition)
		if OnScreen then
			local DistanceText = ""

			if ShowDistance then
				local Distance = GetDistanceSqrt(EntityLocalPlayer.Position, CoinPosition)
				DistanceText = " [" .. tostring(Distance) .. "]"
			end

			local TotalWidth = TEXT_WIDTH
			if ShowDistance and DistanceText ~= "" then
				TotalWidth = TotalWidth + GetTextSize(DistanceText)
			end

			local StartX = ScreenX - (TotalWidth / 2)
			local StartY = ScreenY - (TEXT_HEIGHT / 2)

			draw.TextOutlined(ESP_TEXT, StartX, StartY, Color, Environment.Font, Alpha)

			if ShowDistance and DistanceText ~= "" then
				draw.TextOutlined(DistanceText, StartX + TEXT_WIDTH, StartY, COLOUR_WHITE, Environment.Font, Alpha)
			end
		end
	end
end

function CoinESP.Initialise(
	Container: typeof(require("@modules/ui/UIWrapper").NewTab(nil, nil):Container(nil, nil, nil))
)
	local Enabled = Container:Checkbox("Coin ESP", false)
	local ColorPicker = Container:Colorpicker("Coin ESP Color", { r = 255, g = 255, b = 255, a = 255 }, true)
	local ShowDistance = Container:Checkbox("Show Distance", false)

	cheat.Register("onPaint", CoinESP.Runtime)
	cheat.Register("onUpdate", function()
		local ColorRGBA = ColorPicker:Get()

		CoinESP.Flags.Enabled = Enabled:Get()
		CoinESP.Flags.Color = TableToRGB(ColorRGBA)
		CoinESP.Flags.Alpha = ColorRGBA.a
		CoinESP.Flags.ShowDistance = ShowDistance:Get()
		ShowDistance:Visible(CoinESP.Flags.Enabled)

		local SelectedFont = Environment.Font
		CoinESP.LastFont = SelectedFont
		if SelectedFont ~= CoinESP.LastFont or CoinESP.LastFont == nil then
			TEXT_WIDTH, TEXT_HEIGHT = GetTextSize(ESP_TEXT)
		end
	end)
end

return CoinESP
