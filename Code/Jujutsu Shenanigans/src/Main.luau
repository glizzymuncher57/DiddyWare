local LawyerQTE = require("@features/combat/LawyerQTE")
local NanamiRatio = require("@features/combat/NanamiRatio")
local AutoBlackFlash = require("@features/combat/AutoBlackFlash")
local PerfectSwap = require("@features/combat/PerfectSwap")
local TodoBlackflash = require("@features/combat/TodoBlackFlash")

local CharacterVisuals = require("@features/visuals/CharacterInfo")
local Items = require("@features/visuals/Items")
local DomainHealth = require("@features/visuals/DomainHealth")

local Customisation = require("@modules/ui/Customisation")
local Cache = require("@modules/core/Cache")
local PlayerTracker = require("@modules/core/PlayerTracker")
local AnimationTracker = require("@modules/core/AnimationTracker")

local Minigames = require("@features/misc/Minigames/Main")

local UIWrapper = require("@modules/ui/UIWrapper")
local Math = require("@modules/utility/math")

local function Initialise()
	local Tab = UIWrapper.NewTab("DiddyWare_JJS", "DiddyWare")
	local Main = Tab:Container("DiddyWare_JJSC1", "Main", { autosize = true, next = true })
	local Visuals = Tab:Container("DiddyWare_JJSC2", "Visuals", { autosize = true })
	local Settings = Tab:Container("DiddyWare_JJSC3", "Settings", { autosize = true, next = true })
	local Misc = Tab:Container("DiddyWare_JJSC4", "Misc", { autosize = true })

	Math()
	PlayerTracker.Initialise(Settings)
	AnimationTracker.Initialise(Settings)
	Cache.Initialise(Settings)
	AutoBlackFlash.Initialise(Main)
	TodoBlackflash.Initialise(Main)
	PerfectSwap.Initialise(Main)
	NanamiRatio.Initialise(Main)
	LawyerQTE.Initialise(Main)
	CharacterVisuals.Initialise(Visuals)
	DomainHealth.Initialise(Visuals)
	Items.Initialise(Visuals)
	Customisation.Initialise(Settings)
	Minigames.Initialise(Misc)
end

Initialise()
