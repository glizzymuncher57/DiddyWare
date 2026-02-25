local Minigames = {
	Enabled = false,
	FlightGame = false,
	CatchGame = false,

	GameUI = nil,
	GameType = nil,
}

local Environment = require("@modules/core/Environment")
local GameModules = {
	FlightGame = require("@features/misc/Minigames/Types/FlightGame"),
	CatchGame = require("@features/misc/Minigames/Types/CatchGame"),
}

local function MinigamePlayer(Interface)
	local Function = GameModules[Minigames.GameType]
	return Function and Function(Interface) or nil
end

local function UpdateUIComponents(MinigameEnabled, FlightGameEnabled, CatchGameEnabled)
	local MasterEnabled = MinigameEnabled:Get()
	Minigames.Enabled = MasterEnabled
	if MasterEnabled then
		Minigames.FlightGame = FlightGameEnabled:Get()
		Minigames.CatchGame = CatchGameEnabled:Get()
	end

	FlightGameEnabled:Visible(MasterEnabled)
	CatchGameEnabled:Visible(MasterEnabled)
end

function Minigames.Initialise(
	Container: typeof(require("@modules/ui/UIWrapper").NewTab(nil, nil):Container(nil, nil, nil))
)
	local MinigameEnabled = Container:Checkbox("Minigames Enabled", false)
	local FlightGameEnabled = Container:Checkbox("Flight Game", false)
	local CatchGameEnabled = Container:Checkbox("Catch Game", false)

	cheat.Register("onUpdate", function()
		UpdateUIComponents(MinigameEnabled, FlightGameEnabled, CatchGameEnabled)

		if
			not utility.GetMenuState()
			and Minigames.Enabled
			and Minigames.GameUI
			and Minigames.GameType
			and Minigames[Minigames.GameType] == true
		then
			MinigamePlayer(Minigames.GameUI)
		end
	end)

	cheat.Register("onSlowUpdate", function()
		if not Minigames.Enabled then
			return
		end

		Minigames.GameUI = Environment.LocalInfo.PlayerGui:FindFirstChild("DeviceUI")
		if Minigames.GameUI then
			local System = Minigames.GameUI:FindFirstChild("DeviceSystem")
			local GameType = System:FindFirstChild("Wall") and "FlightGame"
				or System:FindFirstChild("Food") and "CatchGame"
				or nil
			Minigames.GameType = GameType
		else
			Minigames.GameType = nil
		end
	end)
end

return Minigames
