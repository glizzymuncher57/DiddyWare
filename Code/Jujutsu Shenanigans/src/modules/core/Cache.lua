local Cache = {}

local Workspace = game.GetService("Workspace")
local Stats = game.GetService("Stats")
local Player = game.LocalPlayer
local EntityLocalPlayer = entity.GetLocalPlayer()

local Domains = Workspace:FindFirstChild("Domains")
local Items = Workspace:FindFirstChild("Items")

local Network = Stats:FindFirstChild("Network")
local ServerStatsItem = Network.ServerStatsItem
local Ping = ServerStatsItem["Data Ping"]

local Environment = require("@modules/core/Environment")
local Queue = require("@modules/game/Queue").New()

local function GetAttribute(Instance, AttributeName, DefaultValue)
	local Attribute = Instance:GetAttribute(AttributeName)
	return Attribute and Attribute.Value or DefaultValue
end

local function GetLocalInfo()
	Environment.LocalInfo.SelectedCharacter = GetAttribute(Environment.LocalInfo.Player, "Moveset", "[???}")
	Environment.LocalInfo.Ping = Ping.Value
end

function Cache.Initialise(Container)
	Environment.LocalInfo.Player = Player
	Environment.LocalInfo.PlayerGui = Environment.LocalInfo.Player
		and Environment.LocalInfo.Player:FindFirstChild("PlayerGui")

	Queue:AddCategory("Domains", { Domains }, 2000)
	Queue:AddCategory("Items", { Items }, 2000)
	Queue:SetCallback("Domains", function(CategoryName, Folder, Children)
		local ClosestDomain, ClosestDistance = nil, math.huge
		for _, Domain in pairs(Children) do
			local Inner = Domain:FindFirstChildOfClass("MeshPart")
			local Distance = (Inner.Position - EntityLocalPlayer.Position).Magnitude
			if Distance < ClosestDistance then
				ClosestDomain = Domain
				ClosestDistance = Distance
			end
		end

		Environment.ClosestDomain.Instance = ClosestDomain
		Environment.ClosestDomain.Distance = ClosestDistance
	end)

	cheat.Register("onUpdate", function()
		GetLocalInfo()
		Queue:Update()
		Environment.Folders.Domains = Queue:GetCached("Domains")
		Environment.Folders.Items = Queue:GetCached("Items")
	end)
end

return Cache
