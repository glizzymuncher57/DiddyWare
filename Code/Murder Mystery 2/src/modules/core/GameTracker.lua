local GameTracker = {
	LastUpdate = 0,
	UpdateInterval = 50,
}

local Workspace = game.GetService("Workspace")

local Environment = require("@modules/core/Environment")

local function GetCurrentMap()
	local Map = nil
	for _, Child in pairs(Workspace:GetChildren()) do
		local Attribute = Child:GetAttribute("MapID")
		if Attribute then
			Map = Child
			break
		end
	end

	return Map
end

local function GetCoinContainer()
	local Map = Environment.CachedMap
	if not Map then
		return nil
	end

	return Map:FindFirstChild("CoinContainer")
end

local function GetGunDrop()
	local Map = Environment.CachedMap
	if not Map then
		return nil
	end

	return Map:FindFirstChild("GunDrop")
end

local function UpdateCoins()
	local Container = Environment.CachedCoinContainer
	if not Container then
		return
	end

	local Coins = {}
	for _, Coin in pairs(Container:GetChildren()) do
		local MainCoin = Coin:FindFirstDescendant("MainCoin")
		if MainCoin and MainCoin.Transparency == 0 then
			Coins[Coin.Address] = Coin.Position
		end
	end

	Environment.ActiveCoins = Coins
end

function GameTracker.Initialise(
	Container: typeof(require("@modules/ui/UIWrapper").NewTab(nil, nil):Container(nil, nil, nil))
)
	local IntervalSlider = Container:SliderInt("Game Tracker Update Interval", 1, 100, 50)

	cheat.Register("onUpdate", function()
		GameTracker.UpdateInterval = IntervalSlider:Get()

		local Now = utility.GetTickCount()
		if Now - GameTracker.LastUpdate >= GameTracker.UpdateInterval then
			UpdateCoins()
		end
	end)

	cheat.Register("onSlowUpdate", function()
		coroutine.resume(coroutine.create(function()
			local Map = GetCurrentMap()
			if not Map then
				Environment.CachedMap = nil
				return
			end

			if not Environment.CachedMap or Environment.CachedMap ~= Map.Address then
				Environment.CachedMap = Map
			end
		end))

		coroutine.resume(coroutine.create(function()
			local CoinContainer = GetCoinContainer()
			if not CoinContainer then
				Environment.CachedCoinContainer = nil
				return
			end

			if
				not Environment.CachedCoinContainer
				or Environment.CachedCoinContainer.Address ~= CoinContainer.Address
			then
				Environment.CachedCoinContainer = CoinContainer
			end
		end))

		coroutine.resume(coroutine.create(function()
			local GunDrop = GetGunDrop()
			if not GunDrop then
				Environment.CachedGunDrop = nil
				return
			end

			if not Environment.CachedGunDrop or Environment.CachedGunDrop.Address ~= GunDrop.Address then
				Environment.CachedGunDrop = GunDrop
			end
		end))
	end)
end

return GameTracker
