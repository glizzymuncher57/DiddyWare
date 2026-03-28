return function(VectorA, VectorB)
	local dx, dy, dz
	dx = VectorA.X - VectorB.X
	dy = VectorA.Y - VectorB.Y
	dz = VectorA.Z - VectorB.Z

	return math.floor(math.sqrt(dx * dx + dy * dy + dz * dz))
end
