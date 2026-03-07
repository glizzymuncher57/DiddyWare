local Dumper = {
	Callbacks = {},
}

local InstanceList = require("@InstanceList/Properties")

local ScanRange = 10000
local FloatMargin = 0.025

function Dumper:GetOffsets()
	local Offsets = {}

	for ClassName, Properties in pairs(InstanceList) do
		Offsets[ClassName] = {}
		for PropertyName, Property in pairs(Properties) do
			local obj, DataType, TargetValue, OffsetFunc = Property[1], Property[2], Property[3], Property[4]
			local Address = type(obj) == "number" and obj or obj.Address

			for i = 0, ScanRange do
				local MemVal = memory.read(DataType, Address + i)
				local Match = MemVal == TargetValue
					or (type(TargetValue) == "number" and MemVal > TargetValue - FloatMargin and MemVal < TargetValue + FloatMargin)
					or (
						DataType ~= "string"
						and string.match(tostring(MemVal), "^(%d+%.%d%d)") == tostring(TargetValue)
					)

				if Match then
					if type(OffsetFunc) == "function" then
						local Result = OffsetFunc(i)
						Result.Type = DataType
						Offsets[ClassName][PropertyName] = Result
					else
						Offsets[ClassName][PropertyName] = {
							Offset = string.format("0x%X", i),
							Type = DataType,
						}
					end
					print(string.format("[%s.%s] offset: 0x%X", ClassName, PropertyName, i))
					break
				end
			end
		end
	end

	Dumper:Finished(Offsets)
end

function Dumper:Initialise()
	print("--- SCANNING PROPERTIES ---")
	Dumper:GetOffsets()
end

function Dumper:Finished(Finished)
	for _, Callback in pairs(Dumper.Callbacks) do
		Callback(Finished)
	end
end

function Dumper:OnFinished(Callback)
	table.insert(Dumper.Callbacks, Callback)
end

return Dumper
