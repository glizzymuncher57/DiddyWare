local Version = package.cpath:match("version%-[%w]+") or "version-?????????????"
local Offsets = {
	version = Version,
}

local Properties = require("@Types/Properties")
local Booleans = require("@Types/Bools")
local Animations = require("@Types/Animations")
local Callbacks = require("@Utility/Callbacks")

local function TableToLua(Table, Indent)
	Indent = Indent or 0
	local pad = string.rep("    ", Indent)
	local lines = { "{" }

	if Table.version ~= nil then
		table.insert(lines, string.format("%s    ['version'] = '%s',", pad, Table.version))
		table.insert(lines, "")
	end

	local function is_leaf(t)
		for _, v in pairs(t) do
			if type(v) == "table" then
				return false
			end
		end
		return true
	end

	for k, v in pairs(Table) do
		if k ~= "version" then
			local key = string.format("['%s']", tostring(k))
			if type(v) == "table" and not is_leaf(v) then
				table.insert(lines, string.format("%s    %s = %s,", pad, key, TableToLua(v, Indent + 1)))
			elseif type(v) == "table" then
				local parts = {}
				if v.Type then
					parts[#parts + 1] = string.format("Type = '%s'", v.Type)
				end

				if v.X then
					parts[#parts + 1] = string.format("X = %s", v.X)
				end
				if v.Y then
					parts[#parts + 1] = string.format("Y = %s", v.Y)
				end
				if v.Offset then
					parts[#parts + 1] = string.format("Offset = %s", v.Offset)
				end

				for k2, v2 in pairs(v) do
					if k2 ~= "Type" and k2 ~= "X" and k2 ~= "Y" and k2 ~= "Offset" then
						parts[#parts + 1] = type(k2) == "string" and string.format("%s = %s", k2, v2) or tostring(v2)
					end
				end
				table.insert(lines, string.format("%s    %s = {%s},", pad, key, table.concat(parts, ", ")))
			else
				table.insert(lines, string.format("%s    %s = '%s',", pad, key, v))
			end
		end
	end

	table.insert(lines, pad .. "}")
	return table.concat(lines, "\n")
end

local function MergeOffsets(Target, Source)
	for class, props in pairs(Source) do
		Target[class] = Target[class] or {}

		for prop, data in pairs(props) do
			Target[class][prop] = data
		end
	end
end

local function Init()
	Animations:OnFinished(function(Returned)
		print("--- DUMPED ANIMATION OFFSETS ---")
		Booleans:Initialise()
	end)

	Booleans:OnFinished(function(Returned)
		print("--- DUMPED BOOLEAN OFFSETS ---")
		MergeOffsets(Offsets, Returned)
		Properties:Initialise()
	end)

	Properties:OnFinished(function(Returned)
		print("--- DUMPED PROPERTY OFFSETS ---")
		MergeOffsets(Offsets, Returned)
		utility.SetClipboard("return " .. TableToLua(Offsets))
		print("--- FINISHED - CHECK YOUR CLIPBOARD. ---")
	end)

	Callbacks:Initialise()
	Animations:Initialise()
end

Init()
