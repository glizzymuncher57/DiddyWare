local Container = {}

local ContainerReference = "Combat_DiddyWare"
local ContainerName = "Combat"

function Container:Initialise(Tab: typeof(require("@utility/UIWrapper").NewTab(nil, nil)))
	local Container = Tab:Container(ContainerReference, ContainerName, { autosize = true, next = true })
	Container:Checkbox("Auto Blackflash")
	Container:KeyPicker("Auto Blackflash Hotkey", true)
	Container:SliderFloat("Auto Blackflash Timing", 0, 1, 0.285, { Debug = true })

	Container:Checkbox("Auto Todo Blackflash")
	Container:KeyPicker("Auto Todo Blackflash Hotkey", true)
	Container:SliderFloat("Auto Todo Blackflash Time Position", 0, 5, 2.9, { Debug = true })

	Container:Checkbox("Auto Todo Perfect Swap")
	Container:KeyPicker("Auto Todo Perfect Swap Hotkey", true)
	Container:SliderFloat("Auto Todo Perfect Swap Time Position", 0, 1, 0.65, { Debug = true })

	Container:Checkbox("Auto Mahoraga Earthquake")
	Container:SliderFloat("Auto Mahoraga Earthquake Time Position", 0, 1, 0.8, { Debug = true })

	Container:Checkbox("Auto Nanami Ratio")
	Container:SliderFloat("Auto Nanami Ratio GUI Scale", 0, 1, 0.3, { Debug = true })

	Container:Checkbox("Auto Lawyer QTE")
	Container:SliderInt("Auto Lawyer QTE Delay (ms)", 1, 200, 75)
end

return Container
