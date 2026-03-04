local TodoBlackflash = {
	Enabled = false,
	BindEnabled = false,

	WasSliding = false,
	Waiting = false,
	BrutForceStarted = false,
}

local EntityLocalPlayer = entity.GetLocalPlayer()
local Environment = require("@modules/core/Environment")
local PlayerTracker = require("@modules/core/PlayerTracker")

local Animations = {
	["Slide"] = {
		["AnimationID"] = "rbxassetid://100081544058065",
	},

	["Brute Force"] = {
		["AnimationID"] = "rbxassetid://123167492985370",
		["TimePosition"] = 2.9,
	},
}

local function GetAnimationByID(AnimationID)
	local LocalTracker = PlayerTracker:ReturnLocalPlayer()
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

function TodoBlackflash.Runtime()
	if not TodoBlackflash.Enabled then
		return
	end

	if not TodoBlackflash.BindEnabled then
		return
	end

	if
		Environment.LocalInfo.SelectedCharacter ~= "Todo"
		or not PlayerTracker:DoesPlayerHaveMove(EntityLocalPlayer, "Brute Force")
	then
		return
	end

	local IsSliding = GetAnimationByID(Animations.Slide.AnimationID)

	if IsSliding and not TodoBlackflash.WasSliding and not TodoBlackflash.Waiting then
		TodoBlackflash.Waiting = true
	end

	if TodoBlackflash.Waiting then
		local BruteForce = GetAnimationByID(Animations["Brute Force"].AnimationID)

		if not IsSliding and not BruteForce then
			TodoBlackflash.Waiting = false
			TodoBlackflash.BruteForceStarted = false
		elseif BruteForce then
			TodoBlackflash.BruteForceStarted = true
			if BruteForce.TimePosition >= Animations["Brute Force"].TimePosition then
				keyboard.Click(0x32)
				TodoBlackflash.Waiting = false
				TodoBlackflash.BruteForceStarted = false
			end
		end
	end

	TodoBlackflash.WasSliding = IsSliding
end

function TodoBlackflash.Initialise(
	Container: typeof(require("@modules/ui/UIWrapper")
		.NewTab(nil, nil)
		:Container(nil, nil, nil))
)
	local Checkbox = Container:Checkbox("Todo Blackflash", false)
	local Hotkey = Container:KeyPicker("Todo Blackflash Hotkey", true)

	cheat.Register("onUpdate", function()
		TodoBlackflash.Enabled = Checkbox:Get()
		TodoBlackflash.BindEnabled = Hotkey:Get() == true
		TodoBlackflash.Runtime()
	end)
end

return TodoBlackflash
