local Memory = {}

local Read = memory.Read

function Memory.Read(Address, Offset)
	return Read(Offset.Type, Address + Offset.Offset)
end

function Memory.ReadVector2(Address, Offset: { Type: string, X: number, Y: number })
	local X = Read(Offset.Type, Address + Offset.X)
	local Y = Read(Offset.Type, Address + Offset.Y)
	return Vector3.new(X, Y, 0)
end

return Memory
