local MemoryFunctions = require("@modules/game/Memory")

local function GetClosestFoodToFloor(Interface, GuyCenter)
	local Floor = Interface.BG1.Floor
	local Food = Interface.Food

	if not Floor or not Food then
		print("Minigame Critical Error | Couldn't find floor or food!")
		return nil
	end

	local FloorPosition = MemoryFunctions.GetFramePosition(Floor)
	local FloorSize = MemoryFunctions.GetFrameSize(Floor)
	local SpeedThreshold = FloorSize.X * 0.15
	local ClosestFood, ClosestFoodPosition, ClosestDistance = nil, nil, math.huge

	for _, Child in pairs(Food:GetChildren()) do
		local Position = MemoryFunctions.GetFrameCenter(Child)
		local DistanceX = math.abs(Position.X - GuyCenter.X)
		local DistanceY = FloorPosition.Y - Position.Y

		local ValidSpeed = Child.Name == "Speed" and DistanceX > SpeedThreshold
		if not ValidSpeed then
			if DistanceY < ClosestDistance then
				ClosestFood = Child
				ClosestFoodPosition = Position
				ClosestDistance = DistanceY
			end
		end
	end

	return ClosestFood, ClosestFoodPosition
end

return function(Interface)
	if not Interface then
		return
	end

	local GameUI = Interface.Screen.Game
	local Guy = GameUI.Guy

	if MemoryFunctions.IsFrameVisible(Guy.Explode) then
		return
	end

	local GuyCenter = MemoryFunctions.GetFrameCenter(Guy)
	local ClosestFood, FoodPosition = GetClosestFoodToFloor(GameUI, GuyCenter)
	if not ClosestFood or not FoodPosition then
		return
	end

	local dx = FoodPosition.X - GuyCenter.X
	if math.abs(dx) >= 20 then
		if dx < 0 then
			keyboard.click("a")
		else
			keyboard.click("d")
		end
	end
end
