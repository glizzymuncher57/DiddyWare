local Offsets = require("@modules/game/Offsets")

local read = memory.read
local MemoryFunctions = {}

function MemoryFunctions.Read(Object, Offset)
	return read(Offset.Type, Object.Address + (Offset.Offset or 0x00))
end

function MemoryFunctions.GetFramePosition(Frame)
	return MemoryFunctions.ReadVector2(Frame, Offsets.GuiObject.AbsolutePosition)
end

function MemoryFunctions.GetFrameSize(Frame)
	return MemoryFunctions.ReadVector2(Frame, Offsets.GuiObject.AbsoluteSize)
end

function MemoryFunctions.GetFrameCenter(Frame)
	local Position = MemoryFunctions.ReadVector2(Frame, Offsets.GuiObject.AbsolutePosition)
	local Size = MemoryFunctions.ReadVector2(Frame, Offsets.GuiObject.AbsoluteSize)
	return Position + (Size / 2)
end

function MemoryFunctions.ReadVector2(Object, Offset)
	local Address = Object.Address
	return Vector3.new(read(Offset.Type, Address + Offset.X), read(Offset.Type, Address + Offset.Y), 0)
end

function MemoryFunctions.GetFrameRotation(Frame)
	return MemoryFunctions.Read(Frame, Offsets.GuiObject.Rotation)
end

function MemoryFunctions.IsFrameVisible(Frame)
	return MemoryFunctions.Read(Frame, Offsets.GuiObject.Visible)
end

return MemoryFunctions
