local Combat = {
	LastClick = 0,
}
-- << Imports >>
local Environment = require("@core/Environment")
local Configuration = require("@utility/Configuration")
local Callbacks = require("@utility/Callbacks")

-- << Cached Globals >>
local GetTickCount = utility.GetTickCount
local Click = keyboard.Click

-- << Variables >>
local PlayerGui = Environment.LocalPlayer.PlayerGui

-- << Constants >>
local CONFIG_KEY = "Auto Lawyer QTE"
local CONFIG_DELAY_KEY = "Auto Lawyer QTE Delay (ms)"
local QTE_GUI = "QTE"
local QTE_PC = "QTE_PC"

local function Runtime()
	if not Configuration.GetValue(CONFIG_KEY) then
		return
	end

	local Now = GetTickCount()
	if (Now - Combat.LastClick) < Configuration.GetValue(CONFIG_DELAY_KEY) then
		return
	end

	if not PlayerGui then
		PlayerGui = Environment.LocalPlayer.Player.PlayerGui
		return
	end

	local QuickTime = PlayerGui:FindFirstChild(QTE_GUI)
	local QuickTimePC = QuickTime and QuickTime:FindFirstChild(QTE_PC)
	if not QuickTimePC then
		return
	end

	local Text = QuickTimePC.Value
	if not Text or Text == "" then
		return
	end

	Click(tostring(Text):lower())
	Combat.LastClick = Now
end

function Combat:Initialise()
	Callbacks.Add("onUpdate", Runtime)
end

return Combat