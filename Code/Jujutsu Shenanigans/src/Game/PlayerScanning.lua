-- << Imports >>
local AnimationManager = require("@game/AnimationManager")
local Table = require("@utility/Table")
local Environment = require("@core/Environment")
local Callbacks = require("@utility/Callbacks")
local Configuration = require("@utility/Configuration")
local DebugMode = require("@core/DebugMode")

-- << Services >>
local Players = game.GetService("Players")
local Stats = game.GetService("Stats")

-- << Variables >>
local Network = Stats:FindFirstChild("Network")
local ServerStatsItem = Network.ServerStatsItem
local Ping = ServerStatsItem["Data Ping"]

local LastUseCache = Table:Register("LastUse_PlayerScanner", {})
local CooldownStarts = Table:Register("CooldownStarts_PlayerScanner", {})

local PlayerScanning = {
	LastCooldownUpdate = 0,
	LastAnimationUpdate = 0,
	LastLocalUpdate = 0,
	LastRebuild = 0,
}

-- << Functions >>
local function GetAttribute(Instance, AttributeName, DefaultValue)
	local Attribute = Instance:GetAttribute(AttributeName)
	return Attribute and Attribute.Value or DefaultValue
end

local function ProcessPlayer(Player, NewPlayers)
	if not Player or not Player.Name or Player.Name == "" then
		DebugMode.AddDebugMessage("[PlayerScanner]: Invalid Player", "warning", 1000)
		return
	end

	local Head = Player:GetBoneInstance("Head")
	local RootPart = Player:GetBoneInstance("HumanoidRootPart")
	if not Head or not RootPart then
		DebugMode.AddDebugMessage("[PlayerScanner]: Aborted " .. Player.Name .. ", Missing Bodyparts", "warning", 1000)
		return
	end

	local Character = RootPart.Parent
	if not Character then
		DebugMode.AddDebugMessage("[PlayerScanner]: Aborted " .. Player.Name .. ", Character is nil", "warning", 1000)
		return
	end

	local Humanoid = Character:FindFirstChild("Humanoid")
	local Moveset = Character:FindFirstChild("Moveset")
	if not Humanoid or not Moveset then
		DebugMode.AddDebugMessage(
			"[PlayerScanner]: Aborted " .. Player.Name .. ", Missing Humanoid or Moveset",
			"warning",
			1000
		)
		return
	end

	local PlayerName = Player.Name
	local OldData = Environment.Players[PlayerName]
	local OldMoves = OldData and OldData.Moves or nil

	local Ordered = {}
	local Lookup = {}

	local Moves = Moveset:GetChildren()
	for i = 1, #Moves do
		local Move = Moves[i]
		local MoveName = Move.Name
		local OldMove = OldMoves and OldMoves[MoveName]

		local MoveData = {
			Name = MoveName,
			Key = GetAttribute(Move, "Key", i),
			Cooldown = Move.Value or 0,
			Instance = Move,
			MoveKey = PlayerName .. MoveName,
			IsOnCooldown = OldMove and OldMove.IsOnCooldown or false,
			Remaining = OldMove and OldMove.Remaining or 0,
		}

		Ordered[i] = MoveData
		Lookup[MoveName] = MoveData
	end

	table.sort(Ordered, function(a, b)
		return a.Key < b.Key
	end)

	local Exploiting = (RootPart.Position - Head.Position).Magnitude > 20
	local PlayerInstance = Players:FindFirstChild(PlayerName)

	NewPlayers[PlayerName] = {
		Player = Player,
		Character = Character,
		Humanoid = Humanoid,
		RootPart = RootPart,
		Head = Head,
		Exploiting = Exploiting,

		SelectedMoveset = GetAttribute(Character, "Moveset", "[???]"),
		Evade = GetAttribute(Character, "Evade", 50),
		Ultimate = PlayerInstance and GetAttribute(PlayerInstance, "Ultimate", 0) or 0,
		Ragdolled = GetAttribute(Character, "Ragdoll", 0),
		Moves = Lookup,
		OrderedMoves = Ordered,
		Animations = AnimationManager:GetPlayingAnimationTracks(Humanoid),
	}
end

local function UpdateLocalInfo()
	local LocalInfo = Environment.LocalPlayer
	local LocalPlayer = game.LocalPlayer

	LocalInfo.Entity = entity.GetLocalPlayer()
	LocalInfo.Player = LocalPlayer
	LocalInfo.PlayerGui = LocalPlayer and LocalInfo.PlayerGui or nil
	LocalInfo.MinigameInterface = LocalInfo.PlayerGui and LocalInfo.PlayerGui:FindFirstChild("DeviceUI") or nil
	LocalInfo.Data.Character = GetAttribute(LocalPlayer, "Moveset", "[???]")
	LocalInfo.Data.Ping = Ping.Value
end

local function UpdateAnimations()
	for _, Data in pairs(Environment.Players) do
		Data.Animations = AnimationManager:GetPlayingAnimationTracks(Data.Humanoid)
	end
end

local function ProcessMove(MoveData, Now)
	local Instance = MoveData.Instance
	if not Instance then
		MoveData.IsOnCooldown = false
		MoveData.Remaining = 0
		return
	end

	local Key = MoveData.MoveKey
	local RobloxLastUse = GetAttribute(Instance, "LastUse", 0)

	if RobloxLastUse ~= LastUseCache[Key] then
		LastUseCache[Key] = RobloxLastUse
		CooldownStarts[Key] = Now
	end

	local Start = CooldownStarts[Key]
	if Start then
		local Elapsed = Now - Start
		if Elapsed < MoveData.Cooldown then
			MoveData.IsOnCooldown = true
			MoveData.Remaining = MoveData.Cooldown - Elapsed
		else
			MoveData.IsOnCooldown = false
			MoveData.Remaining = 0
		end
	else
		MoveData.IsOnCooldown = false
		MoveData.Remaining = 0
	end
end

local function UpdateCooldownState()
	local Now = utility.GetTickCount() / 1000

	for _, Data in pairs(Environment.Players) do
		for _, MoveData in pairs(Data.Moves) do
			ProcessMove(MoveData, Now)
		end
	end
end

local function RebuildCache()
	local NewPlayers = {}
	local LocalPlayer = entity.GetLocalPlayer()

	if LocalPlayer then
		ProcessPlayer(LocalPlayer, NewPlayers)
	end

	for _, Player in pairs(entity.GetPlayers(false)) do
		ProcessPlayer(Player, NewPlayers)
	end

	Environment.Players = NewPlayers
end

local function Runtime()
	local RescanEvery = (Configuration.GetValue("Rebuild Player Cache Interval (s)") or 1) * 1000
	local UpdateCooldownsEvery = Configuration.GetValue("Update Player Cooldowns Interval (ms)") or 50
	local UpdateAnimationsEvery = Configuration.GetValue("Update Player Animations Interval (ms)") or 10
	local UpdateLocalInfoEvery = (Configuration.GetValue("Update Local Info Interval (s)") or 1) * 1000

	local Now = utility.GetTickCount()

	if (Now - PlayerScanning.LastCooldownUpdate) >= UpdateCooldownsEvery then
		UpdateCooldownState()
		PlayerScanning.LastCooldownUpdate = Now
	end

	if (Now - PlayerScanning.LastRebuild) >= RescanEvery then
		RebuildCache()
		PlayerScanning.LastRebuild = Now
	end

	if (Now - PlayerScanning.LastAnimationUpdate) >= UpdateAnimationsEvery then
		UpdateAnimations()
		PlayerScanning.LastAnimationUpdate = Now
	end

	if (Now - PlayerScanning.LastLocalUpdate) >= UpdateLocalInfoEvery then
		UpdateLocalInfo()
		PlayerScanning.LastLocalUpdate = Now
	end
end

-- << Public API >>
function PlayerScanning:DoesPlayerHaveMove(Player, MoveName)
	if not Player or not MoveName then
		return false
	end

	local Data = Environment.Players[Player.Name]
	if not Data or not Data.Moves then
		return false
	end

	local Move = Data.Moves[MoveName]
	if not Move then
		return false
	end

	return true
end

function PlayerScanning:GetLocalPlayer()
	return Environment.Players[Environment.LocalPlayer.Entity.Name]
end

function PlayerScanning:Initialise()
	Callbacks.Add("onUpdate", function()
		Runtime()
	end)
end

return PlayerScanning
