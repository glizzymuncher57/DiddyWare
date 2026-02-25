local MemoryFunctions = require("@modules/game/Memory")
local LastClick = 0

local function GetClosestWall(Walls, GuyCenter, GameSize)
	local ClosestWall, ClosestDistance = nil, math.huge
	local Buffer = GameSize.X * 0.05

	for _, Wall in pairs(Walls:GetChildren()) do
		local WallCenter = MemoryFunctions.GetFrameCenter(Wall)
		local WallSize = MemoryFunctions.GetFrameSize(Wall.Top)
		local WallRightEdge = WallCenter.X + (WallSize.X / 2)

		local IsWallAhead = WallRightEdge + Buffer > GuyCenter.X

		if IsWallAhead then
			local Distance = WallCenter.X - GuyCenter.X
			if Distance < ClosestDistance then
				ClosestWall = Wall
				ClosestDistance = Distance
			end
		end
	end

	return ClosestWall
end

return function(Interface)
	if not Interface then
		return
	end

	local GameUI = Interface.Screen.Game
	local Guy = GameUI.Guy
	local Now = utility.GetTickCount()

	if MemoryFunctions.IsFrameVisible(Guy.Explode) then
		return
	end

	local GameSize = MemoryFunctions.GetFrameSize(GameUI)
	local GuyCenter = MemoryFunctions.GetFrameCenter(Guy)

	local ClosestWall = GetClosestWall(GameUI.Walls, GuyCenter, GameSize)
	if not ClosestWall then
		return
	end

	local Top, Bottom = ClosestWall.Top, ClosestWall.Bottom

	local TopPosition, TopSize = MemoryFunctions.GetFramePosition(Top), MemoryFunctions.GetFrameSize(Top)
	local BottomPosition = MemoryFunctions.GetFramePosition(Bottom)

	local Bottom_TopPipe = TopPosition.Y + TopSize.Y
	local Top_BottomPipe = BottomPosition.Y
	local Gap = Top_BottomPipe - Bottom_TopPipe

	local GapCenterY = Bottom_TopPipe + Gap * 0.5
	local Threshold = Gap * 0.1
	local TargetY = GapCenterY + Threshold

	if GuyCenter.Y > TargetY and Now - LastClick > 25 then
		mouse.Click("leftmouse")
		LastClick = Now
	end
end
