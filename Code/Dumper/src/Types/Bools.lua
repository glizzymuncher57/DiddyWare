local Dumper = {
	Callbacks = {},
}

local BoolList = require("@InstanceList/Bools")
local Callbacks = require("@Utility/Callbacks")

local ScanRange = 10000

local function CountTable(t)
	local n = 0
	for _ in pairs(t) do
		n = n + 1
	end
	return n
end

function Dumper:GetOffsets()
	local Offsets = {}
	local ScanState = {}
	local ReplicatedStorage = game.GetService("ReplicatedStorage");
	local BoolState = ReplicatedStorage.BoolState

	local LastValue = nil
	local Finished = false

	for ClassName, Properties in pairs(BoolList) do
		for PropertyName, Property in pairs(Properties) do
			local obj = Property[1]
			local address = type(obj) == "number" and obj or obj.Address
			local key = ClassName .. "." .. PropertyName
			ScanState[key] = {
				address = address,
				class_name = ClassName,
				prop_name = PropertyName,
				candidates = nil,
				found = false,
				rounds = 0,
			}
		end
	end

	local CallbackIndex = nil

	CallbackIndex = Callbacks.Add("onUpdate", function()
		if Finished then
			Callbacks.Remove("onUpdate", CallbackIndex)
			return
		end

		local CurrentValue = tonumber(BoolState.Value)
		if CurrentValue == nil or CurrentValue == LastValue then
			return
		end

		LastValue = CurrentValue

		local AllDone = true

		for _, state in pairs(ScanState) do
			if not state.found then
				AllDone = false
				if state.candidates == nil then
					state.candidates = {}
					for i = 0, ScanRange do
						if memory.read("byte", state.address + i) == CurrentValue then
							state.candidates[i] = true
						end
					end
					state.rounds = 1
				else
					for i in pairs(state.candidates) do
						if memory.read("byte", state.address + i) ~= CurrentValue then
							state.candidates[i] = nil
						end
					end
					state.rounds = state.rounds + 1
					if CountTable(state.candidates) == 1 then
						for offset in pairs(state.candidates) do
							Offsets[state.class_name] = Offsets[state.class_name] or {}
							Offsets[state.class_name][state.prop_name] = {
								Offset = string.format("0x%X", offset),
								Type = "bool",
							}
							state.found = true
							print(
								string.format(
									"[%s.%s] offset: %s (found in %d rounds)",
									state.class_name,
									state.prop_name,
									string.format("0x%X", offset),
									state.rounds
								)
							)
						end
					end
				end
			end
		end

		if AllDone then
			Finished = true
			Dumper:Finished(Offsets)
		end
	end)
end

function Dumper:Initialise()
	print("--- SCANNING BOOLS ---")
	Dumper:GetOffsets()
end

function Dumper:Finished(Finished)
	for _, callback in pairs(Dumper.Callbacks) do
		callback(Finished)
	end
end

function Dumper:OnFinished(Callback)
	table.insert(Dumper.Callbacks, Callback)
end

return Dumper
