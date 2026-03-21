-- << Imports >>
local Configuration = require("@utility/Configuration")
local Table = require("@utility/Table")
local Callbacks = require("@utility/Callbacks")
local Memory = require("@game/Memory")
local Offsets = require("@game/Offsets")
local DebugMode = require("@core/DebugMode")

-- << Variables >>
local Read = memory.read
local Floor = math.floor

local AnimationManager = {
	Animators = Table:Register("AMAnimators", {}),
	Animations = Table:Register("AMAnimations", {}),
	Tracks = Table:Register("AMTracks", {}),

	_ScanState = {
		Queue = {},
		Index = 1,
		Done = false,
		StoredCallback = nil,
	},
}

local TrackMetatable = {
	__index = function(self, key)
		local track = self.Track
		--
		if key == "TimePosition" then
			return Floor(Memory.Read(track, Offsets.AnimationTrack.TimePosition) * 100) / 100
		elseif key == "Speed" then
			return Floor(Memory.Read(track + Offsets.AnimationTrack.Speed) * 100) / 100
		elseif key == "Looped" then
			return Memory.Read(track, Offsets.AnimationTrack.Looped)
		else
			return nil
		end
	end,
}

-- << Functions >>
local function DebugLog(Message, Level, Duration)
	if Configuration.GetValue("Debug Mode") then
		if not Message then
			return
		end

		Message = tostring(Message)
		DebugMode.AddDebugMessage("[AM]:" .. Message, Level, Duration)
	end
end
local function StartScan()
	if AnimationManager._ScanState.Done then
		return
	end

	AnimationManager._ScanState.Queue = { game.DataModel }
	AnimationManager._ScanState.Index = 1
end

local function ProcessAnimationScan()
	local queue = AnimationManager._ScanState.Queue
	local index = AnimationManager._ScanState.Index
	local animations = AnimationManager.Animations

	for i = 1, 250 do
		local obj = queue[index]
		if not obj then
			Callbacks.Remove("onUpdate", AnimationManager._ScanState.StoredCallback)
			DebugLog("Finished Caching Animations.", "info", 3000)
			return
		end

		if obj:IsA("Animation") then
			local AnimationId = Memory.Read(obj.Address, Offsets.Animation.AnimationId)
			if AnimationId ~= "" then
				animations[AnimationId] = obj.Name
				DebugLog("Cached Animation " .. tostring(AnimationId), "info", 3000)
			end
		end

		local children = obj:GetChildren()
		for j = 1, #children do
			queue[#queue + 1] = children[j]
		end

		index = index + 1
	end

	AnimationManager._ScanState.Index = index
end

local function GetAnimator(Humanoid)
	local StoredAnimator = AnimationManager.Animators[Humanoid]
	if StoredAnimator then
		return StoredAnimator
	end

	local Animator = Humanoid:FindFirstChildOfClass("Animator")
	if not Animator then
		return 0
	end

	StoredAnimator = Animator.Address
	AnimationManager.Animators[Humanoid] = StoredAnimator

	return StoredAnimator
end

function AnimationManager:GetPlayingAnimationTracks(Humanoid)
	local Tracks = {}
	local Animator = GetAnimator(Humanoid)

	if Animator == 0 then
		DebugLog("Animator doesn't exist for " .. Humanoid, "warning", 1000)
		return Tracks
	end

	local List = Memory.Read(Animator, Offsets.Animator.AnimationTrackList)
	if List == 0 then
		DebugLog("Potentially Wrong Animation Track List Offset.", "warning", 1000)
		return Tracks
	end

	local Iterator = Read("pointer", List)

	while Iterator ~= 0 and Iterator ~= List do
		local Track = Read("pointer", Iterator + 0x10)
		if Track ~= 0 then
			local StoredTrack = AnimationManager.Tracks[Track]
			--
			if not StoredTrack then
				local Animation = Memory.Read(Track, Offsets.AnimationTrack.Animation)
				--
				if Animation ~= 0 then
					local AnimationId = Memory.Read(Animation, Offsets.Animation.AnimationId)
					--
					if AnimationId ~= "" then
						StoredTrack = {
							Track = Track,
							Animation = {
								AnimationId = AnimationId,
								Name = AnimationManager.Animations[AnimationId] or "Unknown",
							},
						}
						--
						setmetatable(StoredTrack, TrackMetatable)
						AnimationManager.Tracks[Track] = StoredTrack
					end
				end
			end
			--
			if StoredTrack then
				Tracks[#Tracks + 1] = StoredTrack
			end
		end
		--
		Iterator = Read("pointer", Iterator)
	end
	--
	return Tracks
end

function AnimationManager:Initialise()
	StartScan()
	AnimationManager._ScanState.StoredCallback = Callbacks.Add("onUpdate", ProcessAnimationScan)
end

return AnimationManager
