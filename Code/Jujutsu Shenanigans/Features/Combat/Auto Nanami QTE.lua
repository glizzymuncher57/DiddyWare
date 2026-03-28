local Combat = {
	CurrentRatio = nil,
	PressedR = false,
}

-- << Imports >>
local Environment = require("@core/Environment")
local Callbacks = require("@utility/Callbacks")
local Configuration = require("@utility/Configuration")
local Offsets = require("@game/Offsets")
local DebugMode = require("@core/DebugMode")

-- << Cached Globals >>
local GetPlayers = entity.GetPlayers
local Read = memory.Read
local Abs = math.abs
local PressKey = keyboard.Click

-- << Constants >>
local GUI_ENABLED = Offsets.ScreenGui.Enabled
local GUI_POSITION = Offsets.GuiObject.Position

-- << Functions >>
local function SendDebugInfo(Message)
	if not Configuration.GetValue("Debug Mode") then
		return
	end

	DebugMode.AddDebugMessage(Message, "info", 1000)
end

local function Ratio(Entity)
	local HumanoidRootPart = Entity:GetBoneInstance("HumanoidRootPart")
	if not HumanoidRootPart then
		return
	end

	local RatioObject = HumanoidRootPart:FindFirstChild("Ratio")
	if not RatioObject then
		return
	end

	local RatioAddress = RatioObject.Address
	if not Read(GUI_ENABLED.Type, RatioAddress + GUI_ENABLED.Offset) then
		return
	end

	local CurrentRatio = Combat.CurrentRatio
	if not CurrentRatio or CurrentRatio ~= RatioAddress then
		Combat.CurrentRatio = RatioAddress
		Combat.PressedR = false
	end

	local Cursor = RatioObject.Bar.Cursor
	local CursorScale = Read(GUI_POSITION.Type, Cursor.Address + GUI_POSITION.Y)
	local TargetScale = Configuration.GetValue("Auto Nanami Ratio GUI Scale")
	local Current = Abs(CursorScale - TargetScale)
	SendDebugInfo("Nanami Ratio Current Distance: " .. tostring(Current))
	if Current <= 0.03 and not Combat.PressedR then
		Combat.PressedR = true
		PressKey("r")
		SendDebugInfo("Completed Nanami Ratio")
	end
end

local function OnRuntime()
	if not Configuration.GetValue("Auto Nanami Ratio") then
		return
	end

	if Environment.LocalPlayer.Data.Character ~= "Nanami" then
		return
	end

	local EntityList = GetPlayers(false)
	for i = 1, #EntityList do
		local Entity = EntityList[i]
		Ratio(Entity)
	end
end

function Combat:Initialise()
	Callbacks.Add("onUpdate", OnRuntime)
end

return Combat
