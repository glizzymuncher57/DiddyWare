local PlayerTracker = {
	LastRebuild = 0,
	LastCooldownUpdate = 0,
}

local Players = game.GetService("Players")
local Environment = require("@modules/core/Environment")
local EntityLocalPlayer = entity.GetLocalPlayer()

local LastUseCache = {}
local CooldownStarts = {}

local function GetAttribute(Instance, AttributeName, DefaultValue)
	local Attribute = Instance:GetAttribute(AttributeName)
	return Attribute and Attribute.Value or DefaultValue
end

local function ProcessPlayer(Player, NewPlayers)
	if not Player or not Player.Name then
		return
	end

	local PlayerInstance = Players:FindFirstChild(Player.Name)
	local RootPart = Player:GetBoneInstance("HumanoidRootPart")
	if not RootPart then
		return
	end

	local Character = RootPart.Parent
	if not Character then
		return
	end

	local Humanoid = Character:FindFirstChildOfClass("Humanoid")

	local Moveset = Character:FindFirstChild("Moveset")
	if not Moveset then
		return
	end

	local OldPlayerData = Environment.Players[Player.Name]
	local OldMoves = OldPlayerData and OldPlayerData.Moves or nil

	local OrderedMoves = {}
	local MoveLookup = {}

	for _, MoveInstance in pairs(Moveset:GetChildren()) do
		local MoveName = MoveInstance.Name
		local Key = GetAttribute(MoveInstance, "Key", 1)
		local Cooldown = MoveInstance.Value or 0

		local OldMove = OldMoves and OldMoves[MoveName]
		local MoveKey = Player.UserId .. ":" .. MoveName

		local MoveData = {
			Name = MoveName,
			Key = Key,
			Cooldown = Cooldown,

			Instance = MoveInstance,
			MoveKey = MoveKey,

			IsOnCooldown = OldMove and OldMove.IsOnCooldown or false,
			Remaining = OldMove and OldMove.Remaining or 0,
		}

		OrderedMoves[#OrderedMoves + 1] = MoveData
		MoveLookup[MoveName] = MoveData
	end

	table.sort(OrderedMoves, function(a, b)
		return a.Key < b.Key
	end)

	NewPlayers[Player.Name] = {
		Player = Player,
		Character = Character,
		Humanoid = Humanoid,
		SelectedMoveset = GetAttribute(Character, "Moveset", "[???]"),
		Evade = GetAttribute(Character, "Evade", 50),
		Ultimate = PlayerInstance and GetAttribute(PlayerInstance, "Ultimate", 0) or 0,
		Ragdolled = GetAttribute(Character, "Ragdoll", 0),
		Moves = MoveLookup,
		OrderedMoves = OrderedMoves,
		Animations = OldPlayerData and OldPlayerData.Animations or {},
	}
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

local function UpdateCooldownState()
	local Now = utility.GetTickCount() / 1000

	for _, PlayerData in pairs(Environment.Players) do
		for _, Move in pairs(PlayerData.Moves) do
			local Instance = Move.Instance
			if Instance then
				local RobloxLastUse = GetAttribute(Instance, "LastUse", 0)
				local Key = Move.MoveKey

				if RobloxLastUse ~= LastUseCache[Key] then
					LastUseCache[Key] = RobloxLastUse
					CooldownStarts[Key] = Now
				end

				local Start = CooldownStarts[Key]
				if Start then
					local Elapsed = Now - Start
					if Elapsed < Move.Cooldown then
						Move.IsOnCooldown = true
						Move.Remaining = Move.Cooldown - Elapsed
					else
						Move.IsOnCooldown = false
						Move.Remaining = 0
					end
				else
					Move.IsOnCooldown = false
					Move.Remaining = 0
				end
			end
		end
	end
end

function PlayerTracker:ReturnLocalPlayer()
	return Environment.Players[EntityLocalPlayer.Name]
end

function PlayerTracker:GetPlayerRagdollState(Player)
	if not Player then
		return
	end

	local Data = Environment.Players[Player.Name]
	if not Data then
		return false
	end

	local Ragdolled = Data.Ragdolled
	return Ragdolled and Ragdolled ~= 0 or false
end

function PlayerTracker:GetPlayerUltimate(Player)
	if not Player then
		return
	end

	local Data = Environment.Players[Player.Name]
	if not Data then
		return 0
	end

	return Data.Ultimate or 0
end

function PlayerTracker:DoesPlayerHaveMove(Player, MoveName)
	if not Player or not MoveName then
		return false, nil
	end

	local Data = Environment.Players[Player.Name]
	if not Data or not Data.Moves then
		return false, nil
	end

	local Move = Data.Moves[MoveName]
	if not Move then
		return false, nil
	end

	return true, Move
end

function PlayerTracker:IsMoveUsable(Player, MoveName)
	local HasMove, Move = PlayerTracker:DoesPlayerHaveMove(Player, MoveName)
	if not HasMove then
		return false
	end

	return not Move.IsOnCooldown
end

function PlayerTracker.Initialise(Container)
	local IntervalSlider = Container:SliderFloat("Rebuild Player Cache Interval (s)", 0.05, 1, 0.15)
	local CooldownUpdateInterval = Container:SliderFloat("Update Cooldowns every (ms)", 1, 50, 5)

	cheat.Register("onUpdate", function()
		local Now = utility.GetTickCount()
		local IntervalMs = IntervalSlider:Get() * 1000

		if (Now - PlayerTracker.LastCooldownUpdate) >= CooldownUpdateInterval:Get() then
			UpdateCooldownState()
			PlayerTracker.LastCooldownUpdate = Now
		end

		if (Now - PlayerTracker.LastRebuild) >= IntervalMs then
			PlayerTracker.LastRebuild = Now
			RebuildCache()
		end
	end)
end

return PlayerTracker
