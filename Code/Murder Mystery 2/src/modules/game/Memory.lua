local Offsets = require("@modules/game/Offsets")

local MemoryFunctions = {}

function MemoryFunctions.GetFramePosition(Frame)
	local Address = Frame.Address
	return Vector3.new(
		memory.read("float", Address + Offsets.FramePosition.X_Offset),
		memory.read("float", Address + Offsets.FramePosition.Y_Offset),
		0
	)
end

function MemoryFunctions.GetFrameSize(Frame)
	local Address = Frame.Address
	return Vector3.new(
		memory.read("float", Address + Offsets.FrameSize.X_Offset),
		memory.read("float", Address + Offsets.FrameSize.Y_Offset),
		0
	)
end

function MemoryFunctions.GetFrameCenter(Frame)
	local Position = MemoryFunctions.GetFramePosition(Frame)
	local Size = MemoryFunctions.GetFrameSize(Frame)
	return Position + (Size / 2)
end

function MemoryFunctions.GetFrameRotation(Frame)
	return memory.read("float", Frame.Address + Offsets.FrameRotation)
end

function MemoryFunctions.IsFrameVisible(Frame)
	return memory.read("bool", Frame.Address + Offsets.Frame_Visible)
end

return MemoryFunctions
