local PerfectSwap = {
	Enabled = false,
	BindPressed = false,

	_Waiting = false,
	_WasClapping = false,
}

local EntityLocalPlayer = entity.GetLocalPlayer()
local Environment = require("@modules/core/Environment")
local PlayerTracker = require("@modules/core/PlayerTracker")

local WhitelistedAnimations = {
	["Clap1"] = true,
	["Clap2"] = true,
	["Clap3"] = true,
}

local function IsClapping()
	local Player = PlayerTracker:ReturnLocalPlayer()
	local Animations = Player.Animations

	for i = 1, #Animations do
		local Track = Animations[i]
		if WhitelistedAnimations[Track.Animation.Name] then
			return Track
		end
	end

	return nil
end

function PerfectSwap.Runtime()
	if not PerfectSwap.Enabled then
		return
	end

	if not PerfectSwap.BindPressed then
		return
	end

	if Environment.LocalInfo.SelectedCharacter ~= "Todo" then
		return
	end

	local CurrentClap = IsClapping()
	if PlayerTracker:GetPlayerUltimate(EntityLocalPlayer) < 4 and not CurrentClap and not PerfectSwap._Waiting then
		return
	end

	if CurrentClap and not PerfectSwap._WasClapping and not PerfectSwap._Waiting then
		PerfectSwap._Waiting = true
	end

	if PerfectSwap._Waiting then
		if not CurrentClap then
			PerfectSwap._Waiting = false
		elseif CurrentClap.TimePosition >= 0.65 then
			mouse.Click("leftmouse")
			PerfectSwap._Waiting = false
		end
	end

	PerfectSwap._WasClapping = CurrentClap ~= nil
end

function PerfectSwap.Initialise(
	Container: typeof(require("@modules/ui/UIWrapper").NewTab(nil, nil):Container(nil, nil, nil))
)
	local Enabled = Container:Checkbox("Todo Perfect Swap", false)
	local Hotkey = Container:KeyPicker("Todo Perfect Swap Hotkey", true)
	cheat.Register("onUpdate", function()
		PerfectSwap.Runtime()
		PerfectSwap.Enabled = Enabled:Get()
		PerfectSwap.BindPressed = Hotkey:Get() == true
	end)
end

return PerfectSwap
