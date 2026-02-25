local Customisation = {}

local Environment = require("@modules/core/Environment")

function Customisation.Initialise(Container)
	local FontSelection = Container:Dropdown("Font Selection", {
		"ConsolasBold",
		"SmallestPixel",
		"Verdana",
		"Tahoma",
	}, 1)

	local DebugMode = Container:Checkbox("Debug Mode", false)

	cheat.Register("onUpdate", function()
		Environment.Font = FontSelection:Get()
		Environment.DebugMode = DebugMode:Get()
	end)
end

return Customisation
