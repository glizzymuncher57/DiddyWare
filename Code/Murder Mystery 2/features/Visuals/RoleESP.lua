local RoleESP = {
	Flags = {
		Enabled = false,
		UseRoleColor = false,
		Color = Color3.new(255, 255, 255),
		Alpha = 255,
		SelectedRoleTypes = {
			Innocent = false,
			Sheriff = false,
			Murderer = false,
		},
	},
	CachedTextSizes = {},
}

local COLOUR_WHITE = Color3.fromRGB(255, 255, 255)

local RoleColors = {
	Innocent = Color3.new(0.117647, 0.858824, 0.117647),
	Murderer = Color3.new(0.72549, 0.101961, 0.101961),
	Sheriff = Color3.new(0.070588, 0.517647, 0.811765),
}

local Environment = require("@modules/core/Environment")
local PlayerTracker = require("@modules/core/PlayerTracker")

local function GetTextSize(Text)
	local TextSize = RoleESP.CachedTextSizes[Text .. Environment.Font]
	if TextSize then
		return TextSize.W, TextSize.H
	end

	local TextWidth, TextHeight = draw.GetTextSize(Text, Environment.Font)
	RoleESP.CachedTextSizes[Text .. Environment.Font] = {
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

local function ProcessPlayer(Entity)
	local IsAlive = PlayerTracker:IsPlayerAlive(Entity)
	if not IsAlive then
		return
	end

	local Role = PlayerTracker:GetPlayerRole(Entity)
	local IsSelected = RoleESP.Flags.SelectedRoleTypes[Role] ~= nil
	if not IsSelected then
		return
	end

	local _, _, OnScreen = utility.WorldToScreen(Entity.Position)
	if not OnScreen then
		return
	end

	local BoundingBox = Entity.BoundingBox
	if not BoundingBox then
		return
	end

	local TextWidth, TextHeight = GetTextSize(Role)
	local FinalX = BoundingBox.x + (BoundingBox.w / 2) - (TextWidth / 2)
	local FinalY = BoundingBox.y + (BoundingBox.h / 2) - (TextHeight / 2)

	local Color = RoleESP.Flags.UseRoleColor and RoleColors[Role] or RoleESP.Flags.Color
	local Alpha = RoleESP.Flags.Alpha

	draw.TextOutlined(Role, FinalX, FinalY, Color, Environment.Font, Alpha)
end

function RoleESP.Runtime()
	if not RoleESP.Flags.Enabled then
		return
	end

	if not PlayerTracker:IsPlayerAlive() then
		return
	end

	for _, EntityObject in pairs(entity.GetPlayers(false)) do
		ProcessPlayer(EntityObject)
	end
end

function RoleESP.Initialise(
	Container: typeof(require("@modules/ui/UIWrapper").NewTab(nil, nil):Container(nil, nil, nil))
)
	local Enabled = Container:Checkbox("Role ESP Enabled")
	local Color = Container:Colorpicker("Role ESP Color", { r = 255, g = 255, b = 255, a = 255 }, true)
	local UseRoleColor = Container:Checkbox("Use Role Color", false)
	local RoleTypes = Container:Multiselect("Draw Roles", {
		"Innocent",
		"Sheriff",
		"Murderer",
	})

	cheat.Register("onPaint", RoleESP.Runtime)
	cheat.Register("onUpdate", function()
		RoleESP.Flags.Enabled = Enabled:Get()
		local ColorRGBA = Color:Get()
		RoleESP.Flags.Color = TableToRGB(ColorRGBA)
		RoleESP.Flags.Alpha = ColorRGBA.a
		RoleESP.Flags.UseRoleColor = UseRoleColor:Get()
		RoleESP.Flags.SelectedRoleTypes = RoleTypes:Get()

		UseRoleColor:Visible(RoleESP.Flags.Enabled)
		RoleTypes:Visible(RoleESP.Flags.Enabled)
	end)
end

return RoleESP
