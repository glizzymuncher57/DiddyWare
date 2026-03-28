local PlayerTracker = {
	LastUpdate = 0,
	UpdateInterval = 50,
}

local Players = game.GetService("Players")
local EntityLocalPlayer = entity.GetLocalPlayer()

local LocalPlayer = game.LocalPlayer
local PlayerGui = LocalPlayer.PlayerGui

local Environment = require("@modules/core/Environment")
local MemoryFunctions = require("@modules/game/Memory")

-- Priv Funcs
local function GetAttribute(Instance, AttributeName, DefaultValue)
	local Attribute = Instance:GetAttribute(AttributeName)
	return Attribute and Attribute.Value or DefaultValue
end

local function UpdatePlayer(EntityPlayer)
	if not EntityPlayer then
		return
	end

	if not Environment.TrackedPlayers[EntityPlayer.Name] then
		local Player = Players:FindFirstChild(EntityPlayer.Name)
		if not Player then
			return
		end

		Environment.TrackedPlayers[EntityPlayer.Name] = {
			EntityInstance = EntityPlayer,
			PlayerInstance = Player,
			IsAlive = nil,
		}
	end

	local Data = Environment.TrackedPlayers[EntityPlayer.Name]
	if not Data then
		return
	end

	local HumanoidRootPart = EntityPlayer:GetBoneInstance("HumanoidRootPart")
	local Character = HumanoidRootPart and HumanoidRootPart.Parent or nil
	local Backpack = Data.PlayerInstance.Backpack

	Data.IsAlive = GetAttribute(Data.PlayerInstance, "Alive", false)
	Data.IsMurderer = (Backpack and Backpack:FindFirstChild("Knife"))
		or (Character and Character:FindFirstChild("Knife")) and true
		or false

	Data.IsSheriff = (Backpack and Backpack:FindFirstChild("Gun"))
		or (Character and Character:FindFirstChild("Gun")) and true
		or false

	Data.IsInnocent = not Data.IsMurderer and not Data.IsSheriff

	if Data.IsSheriff then
		Environment.CurrentSheriff = EntityPlayer
	end

	if Data.IsMurderer then
		Environment.CurrentMurderer = EntityPlayer
	end

	if EntityPlayer.Name == EntityLocalPlayer.Name then
		local MainUI = PlayerGui:FindFirstChild("MainGUI")
		if not MainUI then
			Data.IsFullCoins = false
			return
		end

		local CoinBagContainer = MainUI.Game.CoinBags.Container
		local BagFull = false
		for _, Container in pairs(CoinBagContainer:GetChildren()) do
			if Container:IsA("Frame") then
				local IsBagFull = MemoryFunctions.IsFrameVisible(Container.Full)
				if IsBagFull then
					BagFull = IsBagFull
					break
				end
			end
		end

		Data.IsFullCoins = BagFull
	end
end

--- return @boolean - is the player alive?
function PlayerTracker:IsPlayerAlive(Entity)
	Entity = Entity ~= nil and Entity or EntityLocalPlayer
	local Data = Environment.TrackedPlayers[Entity.Name]
	if not Data then
		return false
	end

	return Data.IsAlive
end

--- return @string - whats the player's role?
function PlayerTracker:GetPlayerRole(Entity)
	Entity = Entity or EntityLocalPlayer

	local Data = Environment.TrackedPlayers[Entity.Name]
	if not Data then
		return nil
	end

	if Data.IsMurderer and Data.IsAlive then
		return "Murderer"
	elseif Data.IsSheriff and Data.IsAlive then
		return "Sheriff"
	elseif Data.IsInnocent and Data.IsAlive then
		return "Innocent"
	else
		return "Spectator"
	end
end

function PlayerTracker:GetPlayerStored(Entity)
	Entity = Entity or EntityLocalPlayer

	local Data = Environment.TrackedPlayers[Entity.Name]
	if not Data then
		return nil
	end

	return Data
end

function PlayerTracker:GetAlivePlayers(OnlyEnemies)
	local Alive = {}
	local LocalRole = self:GetPlayerRole()

	for EntityName, Player in pairs(Environment.TrackedPlayers) do
		if EntityName ~= EntityLocalPlayer.Name and Player.IsAlive then
			if not OnlyEnemies then
				table.insert(Alive, Player)
			else
				if LocalRole == "Murderer" then
					table.insert(Alive, Player)
				elseif LocalRole == "Sheriff" then
					if self:GetPlayerRole(Player) == "Murderer" then
						table.insert(Alive, Player)
					end
				end
			end
		end
	end

	return Alive
end

function PlayerTracker.Initialise(
	Container: typeof(require("@modules/ui/UIWrapper").NewTab(nil, nil):Container(nil, nil, nil))
)
	local IntervalSlider = Container:SliderInt("Player Tracker Update Interval", 1, 100, 50)

	cheat.Register("onUpdate", function()
		PlayerTracker.UpdateInterval = IntervalSlider:Get()

		local Now = utility.GetTickCount()
		if Now - PlayerTracker.LastUpdate >= PlayerTracker.UpdateInterval then
			UpdatePlayer(EntityLocalPlayer)
			for _, Entity in pairs(entity.GetPlayers(false)) do
				UpdatePlayer(Entity)
			end
		end
	end)

	cheat.Register("onSlowUpdate", function()
		local EntityNames = {}

		EntityNames[EntityLocalPlayer.Name] = true
		for _, PlayerEntity in pairs(entity.GetPlayers(false)) do
			EntityNames[PlayerEntity.Name] = true
		end

		for EntityName, _ in pairs(Environment.TrackedPlayers) do
			if not EntityNames[EntityName] then
				Environment.TrackedPlayers[EntityName] = nil
			end
		end
	end)
end

return PlayerTracker
