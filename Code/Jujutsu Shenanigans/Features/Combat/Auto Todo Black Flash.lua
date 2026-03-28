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
	Waiting = false,
	BruteForceFired = false,
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
	local Tracks = LocalTracker and LocalTracker.Animations or nil
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
	if not Configuration.GetValue("Auto Blackflash") then
		return
	end

	if Configuration.GetValue("Auto Blackflash Hotkey") ~= true then
		return
	end

	if not PlayerScanner:DoesPlayerHaveMove(LocalPlayer, "Brute Force") then
		return
	end

	local IsSliding = GetAnimationByID(Animations.Slide)
	local BruteForce = GetAnimationByID(Animations["Brute Force"])

	if State.BruteForceFired and not BruteForce then
		State.BruteForceFired = false
	end

	if IsSliding and not State.Waiting and not State.BruteForceFired then
		SendDebugInfo("Queued Todo Blackflash - Waiting for Brute Force")
		State.Waiting = true
	end

	if State.Waiting and not IsSliding and not BruteForce then
		State.Waiting = false
		State.BruteForceFired = false
		SendDebugInfo("Cancelled Blackflash, Animation Ended.")
	end

	if State.Waiting and BruteForce and not State.BruteForceFired then
		local TimePosition = BruteForce.TimePosition
		local TargetTime = Configuration.GetValue("Auto Todo Blackflash Time Position")
		if TimePosition >= TargetTime then
			PressKey(0x32)
			SendDebugInfo("Triggered Todo Blackflash at TimePosition: "..tostring(TimePosition))
			State.BruteForceFired = true
			State.Waiting = false
		end
	end
end

function Combat:Initialise()
	Callbacks.Add("onUpdate", Runtime)
end

return Combat