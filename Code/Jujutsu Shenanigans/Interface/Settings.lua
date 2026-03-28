local Container = {}

local UIWrapper = require("@utility/UIWrapper")

local ContainerReference = "Settings_DiddyWare"
local ContainerName = "Settings"

function Container:Initialise(Tab: typeof(require("@utility/UIWrapper").NewTab(nil, nil)))
	local Container = Tab:Container(ContainerReference, ContainerName, { autosize = true })
	local MainPage = Container:Page("Settings Menu", { "Debug", "Performance", "Customisation" })
	local DebugPage = MainPage:For("Debug")
	local PerformancePage = MainPage:For("Performance")
	local CustomisationPage = MainPage:For("Customisation")

	local DebugCheckbox = DebugPage:Checkbox("Debug Mode", false)

	DebugCheckbox:OnChange(function(State)
		UIWrapper:SetDebugMode(State)
	end)

	DebugPage:Multiselect("Show Debug Info", { "ok", "info", "warning", "error" })
	PerformancePage:SliderFloat("Update Local Info Interval (s)", 1, 3, 1)
	PerformancePage:SliderFloat("Rebuild Player Cache Interval (s)", 0.05, 1, 0.15)
	PerformancePage:SliderInt("Update Player Cooldowns Interval (ms)", 1, 50, 5)
	PerformancePage:SliderInt("Update Player Animations Interval (ms)", 1, 50, 5)
	CustomisationPage:Dropdown("Font Selection", {
		"ConsolasBold",
		"SmallestPixel",
		"Verdana",
		"Tahoma",
	}, 1)
end

return Container
