local CoinFarm = {
	SAFE_POSITION = Vector3.new(14, 505, -45),

	Flags = {
		Enabled = false,
		SafetyOnFullBag = false,
		MurdererSafezone = 35,
		DelayPerCoin = 0.75,
		TweenSpeed = 35,
	},

	State = {
		GoingToCoin = false,
		CoinTween = nil,

		LastCoinGrab = 0,
		LastPositionBeforeTeleport = nil,
		LastTeleport = 0,

		Target = nil,
	},
}

local EntityLocalPlayer = entity.GetLocalPlayer()

local UIWrapper = require("@modules/ui/UIWrapper")
local Environment = require("@modules/core/Environment")
local PlayerTracker = require("@modules/core/PlayerTracker")
local Tween = require("@modules/utility/Tween")

local function GetClosestCoin(LocalRole)
	local ClosestCoin, ClosestDistance = nil, math.huge

	local IsNotMurderer = LocalRole ~= "Murderer"
	local Murderer = Environment.CurrentMurderer
	local MurdererPosition = nil

	if IsNotMurderer and Murderer then
		MurdererPosition = Murderer.Position
	end

	for Coin, CoinPosition in pairs(Environment.ActiveCoins) do
		local Distance = (EntityLocalPlayer.Position - CoinPosition).Magnitude
		local MurdererDistance = nil

		if MurdererPosition then
			MurdererDistance = (MurdererPosition - CoinPosition).Magnitude
		end

		local SafeToGrab = true
		if MurdererDistance then
			SafeToGrab = MurdererDistance > CoinFarm.Flags.MurdererSafezone
		end

		if SafeToGrab and Distance < ClosestDistance then
			ClosestCoin = Coin
			ClosestDistance = Distance
		end
	end

	return ClosestCoin, ClosestDistance
end

local function ValidateCoin(Coin)
	return table.find(Environment.ActiveCoins, Coin)
end

function CoinFarm.Runtime()
	if not CoinFarm.Flags.Enabled then
		return
	end

	if not PlayerTracker:IsPlayerAlive() then
		return
	end

	local RootPart = EntityLocalPlayer:GetBoneInstance("HumanoidRootPart")
	if not RootPart then
		return
	end

	local Now = utility.GetTickCount()

	local CoinTween = CoinFarm.State.CoinTween
	if CoinTween then
		local Finished = CoinTween:Step()

		if Finished then
			CoinFarm.State.CoinTween = nil
			CoinFarm.State.GoingToCoin = false
			CoinFarm.State.LastCoinGrab = Now
		end

		return
	end

	local PlayerData = PlayerTracker:GetPlayerStored()
	local PlayerRole = PlayerTracker:GetPlayerRole()

	local SafetyOnFullBag = CoinFarm.Flags.SafetyOnFullBag

	local GoingForCoin = CoinFarm.State.GoingToCoin
	local LastCoinGrab = CoinFarm.State.LastCoinGrab

	local WantsSafety = SafetyOnFullBag
		and PlayerData.IsFullCoins
		and PlayerRole ~= "Sheriff"
		and PlayerRole ~= "Murderer"

	if WantsSafety then
		RootPart.Position = CoinFarm.SAFE_POSITION
		return
	end

	if
		not GoingForCoin
		and not PlayerData.IsFullCoins
		and (Now - LastCoinGrab) >= CoinFarm.Flags.DelayPerCoin * 1000
	then
		local Coin, Distance = GetClosestCoin(PlayerRole)
		if not Coin or not ValidateCoin(Coin) then
			return
		end

		local Duration = Distance / CoinFarm.Flags.TweenSpeed
		CoinFarm.State.GoingToCoin = true
		CoinFarm.State.CoinTween = Tween.new(RootPart, "Position", Coin.Position, Duration, Tween.Easing.Linear)
		return
	end
end

function CoinFarm.Initialise(
	Container: typeof(require("@modules/ui/UIWrapper").NewTab(nil, nil):Container(nil, nil, nil))
)
	local Enabled = Container:Checkbox("Coin Farm", false)
	local ReturnToSafetyOnBagFull = Container:Checkbox("Return to Safety when Bag is Full", false)
	local MurdererSafezone = Container:SliderInt("Murderer Safezne", 1, 100, 20)
	local DelayPerCoin = Container:SliderFloat("Delay Per Coin (s)", 0, 3, 0.55)
	local TweenSpeed = Container:SliderInt("Tween Speed", 1, 100, 25)
	local SlowFall = UIWrapper.NewReference("Exploits", "Misc", "Slow Fall")
	local SlowFallSpeed = UIWrapper.NewReference("Exploits", "Misc", "Fall Speed")

	local function UpdateFlags()
		local Settings = CoinFarm.Flags
		Settings.Enabled = Enabled:Get()
		Settings.SafetyOnFullBag = ReturnToSafetyOnBagFull:Get()
		Settings.MurdererSafezone = MurdererSafezone:Get()
		Settings.DelayPerCoin = DelayPerCoin:Get()
		Settings.TweenSpeed = TweenSpeed:Get()

		ReturnToSafetyOnBagFull:Visible(Settings.Enabled)
		MurdererSafezone:Visible(Settings.Enabled)
		DelayPerCoin:Visible(Settings.Enabled)
		TweenSpeed:Visible(Settings.Enabled)
		SlowFall:Set(Settings.Enabled)
		SlowFallSpeed:Set(1)
	end

	cheat.Register("onUpdate", function()
		CoinFarm.Runtime()
		UpdateFlags()
	end)
end

return CoinFarm
