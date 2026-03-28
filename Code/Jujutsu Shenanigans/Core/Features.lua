local Features = {}

local AutoBlackFlash = require("@features/Combat/Auto Black Flash")
local AutoLawyerQTE = require("@features/Combat/Auto Lawyer QTE")
local AutoMahoragaEarthquake = require("@features/Combat/Auto Mahoraga Earthquake")
local AutoNanamiQTE = require("@features/Combat/Auto Nanami QTE")
local AutoTodoBlackFlash = require("@features/Combat/Auto Todo Black Flash")
local AutoTodoPerfectSwap = require("@features/Combat/Auto Todo Perfect Swap")
local AutoReturnM1 = require("@features/Combat/Auto Return M1")
local PlayerVisuals = require("@features/Visuals/Player Visuals")
local WorldVisuals = require("@features/Visuals/World Visuals")
local MinigameModule = require("@features/Minigames/Minigame Module")

function Features:Initialise()
	AutoBlackFlash:Initialise()
	AutoLawyerQTE:Initialise()
	AutoMahoragaEarthquake:Initialise()
	AutoNanamiQTE:Initialise()
	AutoTodoBlackFlash:Initialise()
	AutoTodoPerfectSwap:Initialise()
	AutoReturnM1:Initialise()
	PlayerVisuals:Initialise()
	WorldVisuals:Initialise()
	MinigameModule:Initialise()
end

return Features
