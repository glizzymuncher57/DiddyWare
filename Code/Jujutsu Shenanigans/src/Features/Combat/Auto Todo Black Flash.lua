local Combat = {}

-- << Imports >>
local Callbacks = require("@utility/Callbacks")
local Table = require("@utility/Table")
local Configuration = require("@utility/Configuration")
local PlayerScanner = require("@game/PlayerScanning")
local DebugMode = require("@core/DebugMode")

-- << Variables >>
local LocalPlayer = entity.GetLocalPlayer()
local State = Table:Register("TodoBlackflashState", {
	WasSliding = false,
	Waiting = false,
	BruteForceStarted = false,
})
local Animations = Table:Register("TodoBlackflashAnimationsTable", {
	["Slide"] = "rbxassetid://100081544058065",
	["Brute Force"] = "rbxassetid://123167492985370",
})

-- << Cached Globals
local PressKey = keyboard.Click

-- << Functions >>
local function SendDebugInfo(Message)
	if not Configuration.GetValue("Debug Mode") then
		return
	end

	DebugMode.AddDebugMessage(Message, "info", 1000)
end

local function GetAnimationByID(AnimationId)
	if not AnimationId then
		return
	end

	local LocalTracker = PlayerScanner:GetLocalPlayer()
	local Tracks = LocalTracker.Animations
	if not Tracks then
		return nil
	end

	for i = 1, #Tracks do
		if Tracks[i].Animation.AnimationId == AnimationId then
			return Tracks[i]
		end
	end
	return nil
end

local function Runtime()
	if not Configuration.GetValue("Auto Todo Blackflash") then
		return
	end

	if Configuration.GetValue("Auto Todo Blackflash Hotkey") ~= true then
		return
	end

	if not PlayerScanner:DoesPlayerHaveMove(LocalPlayer, "Brute Force") then
		return
	end

	local IsSliding = GetAnimationByID(Animations.Slide)
	if IsSliding and not State.WasSliding and not State.Waiting then
		SendDebugInfo("Queued Todo Blackflash - Waiting for brute force")
		State.Waiting = true
	end

	if State.Waiting then
		local Brute_Force = GetAnimationByID(Animations["Brute Force"])
		if not IsSliding and not Brute_Force then
			SendDebugInfo("Cancelled Blackflash, Animation Ended.")
			State.Waiting = false
			State.BruteForceStarted = false
		elseif Brute_Force then
			State.BruteForceStarted = true
			local TimePosition = Brute_Force.TimePosition
			local StringPosition = tostring(TimePosition)
			SendDebugInfo("Brute Force Time Position: " .. StringPosition)
			if TimePosition >= Configuration.GetValue("Auto Todo Blackflash Time Position") then
				SendDebugInfo("Triggered Todo Blackflash at: " .. StringPosition)
				PressKey(0x32)
				State.Waiting = false
				State.BruteForceStarted = false
			end
		end
	end

	State.WasSliding = IsSliding
end

function Combat:Initialise()
	Callbacks.Add("onUpdate", Runtime)
end

return Combat
