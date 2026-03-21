local Container = {}

local ContainerReference = "Minigame_DiddyWare"
local ContainerName = "Minigames"

function Container:Initialise(Tab: typeof(require("@utility/UIWrapper").NewTab(nil, nil)))
	local Container = Tab:Container(ContainerReference, ContainerName, { autosize = true, next = true })
	Container:Checkbox("Minigames Enabled")
	Container:Checkbox("Flight Game")
	Container:Checkbox("Catch Game")
end

return Container
