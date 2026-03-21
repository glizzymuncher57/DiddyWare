-- Game Modules
local PlayerScanning = require("@game/PlayerScanning")
local WorldScanning = require("@game/WorldScanning")
local AnimationManager = require("@game/AnimationManager")

-- Core Modules
local DebugMode = require("@core/DebugMode")
local Features = require("@core/Features")
local Menu = require("@core/Menu")

-- Utility Modules
local Callbacks = require("@utility/Callbacks")
local Table = require("@utility/Table")
local Math = require("@utility/Math")
local Library = require("@utility/UIWrapper")

local function Initialise()
	Math()
	Callbacks:Initialise()
	Library:Initialise()
	PlayerScanning:Initialise()
	WorldScanning:Initialise()
	AnimationManager:Initialise()
	DebugMode:Initialise()
	Menu:Initialise()
	Features:Initialise()

	Callbacks.Add("shutdown", function()
		Callbacks.ClearAll()
		Table:UnloadAll()
	end)
end

Initialise()
