local Offsets = require("@modules/game/Offsets")

local MemoryFunctions = {}

function MemoryFunctions.GetFramePosition(Frame)
	local Address = Frame.Address
	return Vector3.new(
		memory.read("float", Address + Offsets.GuiObject.Position.X),
		memory.read("float", Address + Offsets.GuiObject.Position.Y),
		0
	)
end

function MemoryFunctions.GetFrameSize(Frame)
	local Address = Frame.Address
	return Vector3.new(
		memory.read("float", Address + Offsets.GuiObject.Size.X),
		memory.read("float", Address + Offsets.GuiObject.Size.Y),
		0
	)
end

function MemoryFunctions.GetFrameCenter(Frame)
	local Position = MemoryFunctions.GetFramePosition(Frame)
	local Size = MemoryFunctions.GetFrameSize(Frame)
	return Position + (Size / 2)
end

function MemoryFunctions.GetFrameRotation(Frame)
	return memory.read("float", Frame.Address + Offsets.GuiObject.Rotation.Offset)
end

function MemoryFunctions.IsFrameVisible(Frame)
	return memory.read("bool", Frame.Address + Offsets.GuiObject.Visible.Offset)
end

return MemoryFunctions
