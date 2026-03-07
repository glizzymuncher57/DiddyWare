local Combat = {}

-- << Imports >>
local Callbacks = require("@utility/Callbacks")
local Table = require("@utility/Table")
local Configuration = require("@utility/Configuration")
local PlayerScanner = require("@game/PlayerScanning")
local Environment = require("@core/Environment")
local DebugMode = require("@core/DebugMode")

-- << Variables >>
local State = Table:Register("TodoSwapState", {
	Waiting = false,
	WasClapping = false,
})
local Animations = Table:Register("TodoSwapWhitelistedAnimations", {
	["Clap1"] = true,
	["Clap2"] = true,
	["Clap3"] = true,
})

-- << Cached Globals
local MouseClick = mouse.Click

-- << Functions >>
local function SendDebugInfo(Message)
	if not Configuration.GetValue("Debug Mode") then
		return
	end

	DebugMode.AddDebugMessage(Message, "info", 1000)
end

local function IsClapping()
	local LocalTracker = PlayerScanner:GetLocalPlayer()
	local Tracks = LocalTracker.Animations
	if not Tracks then
		return nil
	end

	for i = 1, #Tracks do
		local Track = Tracks[i]
		if Animations[Track.Animation.Name] then
			return Track
		end
	end

	return nil
end

local function Runtime()
	if not Configuration.GetValue("Auto Todo Perfect Swap") then
		return
	end

	if Configuration.GetValue("Auto Todo Blackflash Hotkey") ~= true then
		return
	end

	if Environment.LocalPlayer.Data.Character ~= "Todo" then

		return
	end

	local CurrentClap = IsClapping()
	if PlayerScanner:GetLocalPlayer().Ultimate < 4 and not CurrentClap and not State.Waiting then
		return
	end

	if CurrentClap and not State.WasClapping and not State.Waiting then
		SendDebugInfo("Detected Clap, Waiting.")
		State.Waiting = true
	end

	if State.Waiting then
		if not CurrentClap then
			State.Waiting = false
			SendDebugInfo("Cancelled Perfect Swap, Animation Stopped.")
		elseif CurrentClap.TimePosition >= Configuration.GetValue("Auto Todo Perfect Swap Time Position") then
			SendDebugInfo("Completed Todo Perfect Swap")
			MouseClick("leftmouse")
			State.Waiting = false
		end
	end

	State.WasClapping = CurrentClap ~= nil
end

function Combat:Initialise()
	Callbacks.Add("onUpdate", Runtime)
end

return Combat
