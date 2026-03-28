local WorldScanning = {}

-- << Imports >>
local Environment = require("@core/Environment")
local Callbacks = require("@utility/Callbacks")
local Queue = require("@utility/Queue").New()

-- << Services >>
local Workspace = game.GetService("Workspace")

-- << Variables >>
local Items = Workspace.Items
local Domains = Workspace.Domains

function WorldScanning:Initialise()
	Queue:AddCategory("Domains", { Domains }, 2000)
	Queue:AddCategory("Items", { Items }, 2000)
	Queue:SetCallback("Domains", function(CategoryName, Folder, Children)
		local LocalPosition = Environment.LocalPlayer.Entity.Position
		local ClosestDomain, ClosestPosition, ClosestDistance = nil, nil, math.huge
		for _, Domain in pairs(Children) do
			local Inner = Domain:FindFirstChildOfClass("MeshPart")
			local Position = Inner.Position
			local Distance = (Position - LocalPosition).Magnitude
			if Distance < ClosestDistance then
				ClosestPosition = Position
				ClosestDomain = Domain
				ClosestDistance = Distance
			end
		end

		Environment.ClosestDomain.Instance = ClosestDomain
		Environment.ClosestDomain.Distance = ClosestDistance
		Environment.ClosestDomain.Position = ClosestPosition
	end)

	Callbacks.Add("onUpdate", function()
		Queue:Update()
		Environment.Objects.Items = Queue:GetCached("Items")
		Environment.Objects.Domains = Queue:GetCached("Domains")
	end)
end

return WorldScanning
