local Table = require("@utility/Table")

local Configuration = {}
local Elements = Table:Register("Configuration.Elements", {})
local Values = Table:Register("Configuration.Values", {})

function Configuration.Register(name, element)
	Elements[name] = element
end

function Configuration.GetValue(name)
	return Values[name]
end

function Configuration.SetValue(name, value)
	Values[name] = value
end

return Configuration
