local ReplicatedStorage = game.GetService("ReplicatedStorage")

local player = entity.GetLocalPlayer()
local root = player and player:GetBoneInstance("HumanoidRootPart")
local character = root and root.Parent
local humanoid = character and character:FindFirstChildOfClass("Humanoid")
local animator = humanoid and humanoid:FindFirstChildOfClass("Animator")

local animation_data = ReplicatedStorage:FindFirstChild("AnimationData")
local speed_label = animation_data and animation_data:FindFirstChild("Speed")
local time_label = animation_data and animation_data:FindFirstChild("TimePosition")
local looped_label = animation_data and animation_data:FindFirstChild("Looped")
local animationid_label = animation_data and animation_data:FindFirstChild("AnimationId")

local AnimationTrackList = nil
return {
	Animator = {
		AnimationTrackList = { animator, "pointer" },
	},

	AnimationTrack = {
		Speed = { AnimationTrackList, "float", speed_label },
		TimePosition = { AnimationTrackList, "float", time_label },
		Looped = { AnimationTrackList, "byte", looped_label },
		AnimationId = { AnimationTrackList, "string", animationid_label },
	},
}