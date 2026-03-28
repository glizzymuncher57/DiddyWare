local Customisation = {}

local Environment = require("@modules/core/Environment")

function Customisation.Initialise(Container)
	local FontSelection = Container:Dropdown("Font Selection", {
		"ConsolasBold",
		"SmallestPixel",
		"Verdana",
		"Tahoma",
	}, 1)

	cheat.Register("onUpdate", function()
		Environment.Font = FontSelection:Get()
	end)
end

return Customisation
