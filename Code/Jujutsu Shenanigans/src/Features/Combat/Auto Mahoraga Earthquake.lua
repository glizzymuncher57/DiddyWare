local Combat = {}

-- << Imports >>
local Callbacks = require("@utility/Callbacks")
local Table = require("@utility/Table")
local Configuration = require("@utility/Configuration")
local PlayerScanner = require("@game/PlayerScanning")
local DebugMode = require("@core/DebugMode")

-- << Variables >>
local LocalPlayer = entity.GetLocalPlayer()

local Timings = Table:Register("MahoragaTimingTable", {
	AnimationId = "rbxassetid://85024950165903",
})

local State = Table:Register("MahoragaState", {
	WasEarthquaking = false,
	Waiting = false,
})

-- << Functions >>
local function SendDebugInfo(Message)
	if not Configuration.GetValue("Debug Mode") then
		return
	end

	DebugMode.AddDebugMessage(Message, "info", 1000)
end

local function GetAnimationByID(AnimationID)
	local LocalTracker = PlayerScanner:GetLocalPlayer()
	local Tracks = LocalTracker.Animations
	if not Tracks then
		return nil
	end

	for i = 1, #Tracks do
		if Tracks[i].Animation.AnimationId == AnimationID then
			return Tracks[i]
		end
	end
	return nil
end

local function Runtime()
	if not Configuration.GetValue("Auto Mahoraga Earthquake") then
		return
	end

	if not PlayerScanner:DoesPlayerHaveMove(LocalPlayer, "Earthquake") then
		return
	end

	local IsEarthquaking = GetAnimationByID(Timings.AnimationId)
	if IsEarthquaking and not State.WasEarthquaking and not State.Waiting then
		State.Waiting = true
	end

	if State.Waiting then
		if not IsEarthquaking then
			State.Waiting = false
			return
		end

		local TimePosition = IsEarthquaking.TimePosition
		SendDebugInfo("Current Mahoraga Earthquake Time:" .. TimePosition)
		if TimePosition >= Configuration.GetValue("Auto Mahoraga Earthquake Time Position") then
			keyboard.Release(0x33)
			State.Waiting = false
			SendDebugInfo("Completed Mahoraga Earthquake")
		end
	end

	State.WasEarthquaking = IsEarthquaking ~= nil
end

function Combat:Initialise()
	Callbacks.Add("onUpdate", Runtime)
end

return Combat
