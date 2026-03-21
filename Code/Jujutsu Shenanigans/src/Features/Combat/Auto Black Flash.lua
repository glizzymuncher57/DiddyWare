-- << Imports >>
local DebugMode = require("@core/DebugMode")
local Table = require("@utility/Table")
local Callbacks = require("@utility/Callbacks")
local Configuration = require("@utility/Configuration")
local Environment = require("@core/Environment")
local PlayerScanner = require("@game/PlayerScanning")

-- << Variables >>
local EntityLocalPlayer = Environment.LocalPlayer.Entity

-- << Cached Globals
local GetTickCount = utility.GetTickCount
local IsPressed = keyboard.IsPressed
local Click = keyboard.Click

local Combat = {
	Delay = 0.285,
	CombatState = Table:Register("AutoBlackFlashState", {
		Waiting = false,
		WasDown = false,
		NextPressTime = 0,
	}),
}

-- << Functions >>
local function SendDebugInfo(Message)
	if not Configuration.GetValue("Debug Mode") then
		return
	end

	DebugMode.AddDebugMessage(Message, "info", 1000)
end

local function Runtime()
	local Now = GetTickCount()
	local IsDown = IsPressed(0x33)
	local CombatState = Combat.CombatState

	if IsDown and not CombatState.WasDown and not CombatState.Waiting then
		local BaseDelaySeconds = Configuration.GetValue("Auto Blackflash Timing")
		local DelayMs = BaseDelaySeconds * 1000

		CombatState.NextPressTime = Now + DelayMs
		CombatState.Waiting = true
	end

	if CombatState.Waiting and Now >= CombatState.NextPressTime then
		Click(0x33)
		CombatState.Waiting = false
		SendDebugInfo("Completed Yuji/Mahito Blackflash.")
	end

	Combat.WasDown = IsDown
end

function Combat:Initialise()
	Callbacks.Add("onUpdate", function(...): ...any
		if not Configuration.GetValue("Auto Blackflash") then
			return
		end

		if Configuration.GetValue("Auto Blackflash Hotkey") ~= true then
			return
		end

		if
			not PlayerScanner:DoesPlayerHaveMove(EntityLocalPlayer, "Focus Strike")
			and not PlayerScanner:DoesPlayerHaveMove(EntityLocalPlayer, "Divergent Fist")
		then
			return
		end

		Runtime()
	end)
end

return Combat
