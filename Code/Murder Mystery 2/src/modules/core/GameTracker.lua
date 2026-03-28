local GameTracker = {
	LastUpdate = utility.GetTickCount() + 3000, -- if ur code is shit make counter measures heh.
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
			Environment.CachedGunDrop = GetGunDrop()
			GameTracker.LastUpdate = Now
		end
	end)

	cheat.Register("onSlowUpdate", function()
		Environment.CachedMap = GetCurrentMap()
		Environment.CachedCoinContainer = GetCoinContainer()
	end)
end

return GameTracker
