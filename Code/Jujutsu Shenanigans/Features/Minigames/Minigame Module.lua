local Minigames = {
	GameUI = nil,
	GameType = nil,
}

local Environment = require("@core/Environment")
local Callbacks = require("@utility/Callbacks")
local Configuration = require("@utility/Configuration")
local DebugMode = require("@core/DebugMode")

local GameModules = {
	["Flight Game"] = require("@features/Minigames/Minigame Support/Flight Game"),
	["Catch Game"] = require("@features/Minigames/Minigame Support/Catch Game"),
}

local function DebugPrint(Message)
	if not Configuration.GetValue("Debug Mode") then
		return
	end

	DebugMode.AddDebugMessage(Message, "info", 1200)
end

local function MinigamePlayer(Interface)
	local Function = GameModules[Minigames.GameType]

	if not Function then
		DebugPrint("No module found for game type: " .. tostring(Minigames.GameType))
		return nil
	end

	return Function(Interface)
end

function Minigames.Initialise(
	Container: typeof(require("@utility/UIWrapper").NewTab(nil, nil):Container(nil, nil, nil))
)
	Callbacks.Add("onUpdate", function()
		if utility.GetMenuState() then
			return
		end

		if not Configuration.GetValue("Minigames Enabled") then
			return
		end

		if not Minigames.GameUI then
			return
		end

		if not Minigames.GameType then
			return
		end

		if Configuration.GetValue(Minigames.GameType) ~= true then
			return
		end

		MinigamePlayer(Minigames.GameUI)
	end)

	Callbacks.Add("onSlowUpdate", function()
		if not Configuration.GetValue("Minigames Enabled") then
			return
		end

		local PlayerGui = Environment.LocalPlayer.PlayerGui
		if not PlayerGui then
			return
		end

		local DeviceUI = PlayerGui:FindFirstChild("DeviceUI")
		Minigames.GameUI = DeviceUI

		if DeviceUI then
			local System = DeviceUI:FindFirstChild("DeviceSystem")
			if not System then
				Minigames.GameType = nil
				return
			end

			local GameType = System:FindFirstChild("Wall") and "Flight Game"
				or System:FindFirstChild("Food") and "Catch Game"
				or nil

			Minigames.GameType = GameType
		else
			Minigames.GameType = nil
		end
	end)
end

return Minigames
