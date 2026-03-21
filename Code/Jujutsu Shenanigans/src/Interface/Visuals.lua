local Container = {}

local ContainerReference = "VisualsTab_DiddyWare"
local ContainerName = "Visuals"

function Container:Initialise(Tab: typeof(require("@utility/UIWrapper").NewTab(nil, nil)))
	local Container = Tab:Container(ContainerReference, ContainerName, { autosize = true })
	Container:Checkbox("Visuals Enabled")
	local MainPage = Container:Page("Visual Types", { "Player", "World" })
	local PlayerPage = MainPage:For("Player")
	local WorldPage = MainPage:For("World")
	PlayerPage:Checkbox("Draw Cooldowns")
	PlayerPage:Colorpicker("Cooldown Fill Color", { r = 255, g = 0, b = 0, a = 180 }, true)
	PlayerPage:Colorpicker("Cooldown Background Color", { r = 0, g = 0, b = 0, a = 200 }, true)
	PlayerPage:Checkbox("Draw Evasive Bar")
	PlayerPage:Colorpicker("Evasive Fill Color", { r = 121, g = 74, b = 148, a = 255 }, true)
	PlayerPage:Checkbox("Draw Animation Desync Guides", false)
	PlayerPage:Colorpicker("Animation Desync Flagged Outline", { r = 0, g = 0, b = 0, a = 180 }, true)
	PlayerPage:Colorpicker("Animation Desync Flagged Fill", { r = 255, g = 0, b = 0, a = 100 }, true)

	WorldPage:Checkbox("Item ESP", false)
	WorldPage:Colorpicker("Item ESP Color", { r = 255, g = 255, b = 255, a = 255 }, true)

	WorldPage:Checkbox("Domain Health ESP", false)
	WorldPage:Colorpicker("Domain Health ESP Color", { r = 255, g = 255, b = 255, a = 255 }, true)
end

return Container
