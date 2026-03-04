-- << start >>

-- << variables >>
local environment = require("@modules/core/Environment")
local player_tracker = require("@modules/core/PlayerTracker")
local offsets = require("@modules/game/Offsets")

-- << globals >>
local read = memory.read
local floor = math.floor
local min = math.min
local max = math.max

-- << mt's >>
local track_metatable = {
	__index = function(self, key)
		local track = self.track
		--
		if key == "TimePosition" then
			return floor(read("float", track + offsets.AnimationTrack.TimePosition) * 100) / 100
		elseif key == "Speed" then
			return floor(read("float", track + offsets.AnimationTrack.Speed) * 100) / 100
		elseif key == "Looped" then
			return read("bool", track + offsets.AnimationTrack.Looped)
		elseif key == "WeightTarget" then
			return max(0, min(1, read("float", track + offsets.AnimationTrack.WeightTarget)))
		else
			return nil
		end
	end,
}

local Tracker = {
	Animators = {},
	Tracks = {},
	Animations = {},
}

-- << internal functions >>
local function get_animator(humanoid)
	local stored_animator = Tracker.Animators[humanoid]

	if stored_animator then
		return stored_animator
	end

	local animator = humanoid:find_first_child_of_class("Animator")
	if not animator then
		return 0
	end

	stored_animator = animator.Address
	Tracker.Animations[humanoid] = stored_animator

	return stored_animator
end

local function get_playing_animation_tracks(humanoid)
	local tracks = {}
	local animator = get_animator(humanoid)
	--
	if animator == 0 then
		return tracks
	end
	--
	local list = read("ptr", animator + offsets.Animator.AnimationTrackList)
	--
	if list == 0 then
		return tracks
	end
	--
	local iterator = read("ptr", list)
	--
	while iterator ~= 0 and iterator ~= list do
		local track = read("ptr", iterator + 0x10)
		--
		if track ~= 0 then
			local stored = Tracker.Tracks[track]
			--
			if not stored then
				local animation = read("ptr", track + offsets.AnimationTrack.Animation)
				--
				if animation ~= 0 then
					local animation_id = read("string", animation + offsets.Animation.AnimationId)
					--
					if animation_id ~= "" then
						stored = {
							track = track,
							Animation = {
								AnimationId = animation_id,
								Name = Tracker.Animations[animation_id] or "Unknown",
							},
						}
						--
						setmetatable(stored, track_metatable)
						Tracker.Tracks[track] = stored
					end
				end
			end
			--
			if stored then
				tracks[#tracks + 1] = stored
			end
		end
		--
		iterator = read("ptr", iterator)
	end
	--
	return tracks
end

local function get_animations()
	local descendants = game.DataModel:GetDescendants()

	for i = 1, #descendants do
		local instance = descendants[i]

		if instance:is_a("Animation") then
			local animation_id = read("string", instance.Address + offsets.Animation.AnimationId)
			if animation_id ~= "" then
				Tracker.Animations[animation_id] = instance.Name
			end
		end
	end
end

-- << init >>
function Tracker.Initialise(
	Container: typeof(require("@modules/ui/UIWrapper").NewTab(nil, nil):Container(nil, nil, nil))
)
	local metatable = getmetatable(game.DataModel)
	local index = metatable.__index
	--
	metatable.__index = function(self, key)
		if key == "get_animator" or key == "GetAnimator" then
			return get_animator
		elseif key == "get_playing_animation_tracks" or key == "GetPlayingAnimationTracks" then
			return get_playing_animation_tracks
		elseif key == "get_animations" or key == "GetAnimations" then
			return get_animations
		end
		--
		return index(self, key)
	end

	get_animations()

	cheat.register("onUpdate", function()
		local local_player = player_tracker:ReturnLocalPlayer()
		if not local_player then
			return
		end

		local humanoid = local_player.Humanoid
		if not humanoid then
			return
		end

		local_player.Animations = humanoid:get_playing_animation_tracks()
	end)
end

return Tracker
