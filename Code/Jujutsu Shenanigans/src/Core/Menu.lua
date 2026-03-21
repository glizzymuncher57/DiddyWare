local Menu = {}

local UIWrapper = require("@utility/UIWrapper")

local CombatTab = require("@interface/Combat")
local VisualsTab = require("@interface/Visuals")
local MinigamesTab = require("@interface/Minigames")
local SettingsTab = require("@interface/Settings")

function Menu:Initialise()
	local Tab = UIWrapper.NewTab("DiddyWare_JJS", "DiddyWare")
	CombatTab:Initialise(Tab)
	VisualsTab:Initialise(Tab)
	MinigamesTab:Initialise(Tab)
	SettingsTab:Initialise(Tab)
end

return Menu
