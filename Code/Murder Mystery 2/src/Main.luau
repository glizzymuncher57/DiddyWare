local CoinFarm = require("@features/Automation/CoinFarm")
local GetGun = require("@features/Exploits/TeleportToGun")

local CoinESP = require("@features/Visuals/CoinESP")
local GunDropESP = require("@features/Visuals/GunESP")
local RoleESP = require("@features/Visuals/RoleESP")

local PlayerTracker = require("@modules/core/PlayerTracker")
local GameTracker = require("@modules/core/GameTracker")

local Customisation = require("@modules/ui/Customisation")
local UIWrapper = require("@modules/ui/UIWrapper")

local Math = require("@modules/utility/math")
local Table = require("@modules/utility/table")

local function Initialise()
	local Tab = UIWrapper.NewTab("DiddyWare_MM2", "DiddyWare")
	local Main = Tab:Container("DiddyWare_MM2C1", "Main", { autosize = true, next = true })
	local Visuals = Tab:Container("DiddyWare_MM2C2", "Visuals", { autosize = true })
	local Settings = Tab:Container("DiddyWare_MM2C3", "Settings", { autosize = true, next = true })

	Math()
	Table()
	CoinFarm.Initialise(Main)
	GetGun.Initialise(Main)
	CoinESP.Initialise(Visuals)
	RoleESP.Initialise(Visuals)
	GunDropESP.Initialise(Visuals)
	PlayerTracker.Initialise(Settings)
	GameTracker.Initialise(Settings)
	Customisation.Initialise(Settings)
end

Initialise()
