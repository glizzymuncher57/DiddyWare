local Feature = {
	Enabled = false,
	LastClick = 0,
	Delay = 200,
}

local Environment = require("@modules/core/Environment")
local PlayerGui = Environment.LocalInfo.PlayerGui

function Feature.Runtime()
	if not Feature.Enabled then
		return
	end

	local Now = utility.GetTickCount()
	if (Now - Feature.LastClick) < Feature.Delay then
		return
	end

	if not PlayerGui then
		PlayerGui = Environment.LocalInfo.Player.PlayerGui
		return
	end

	local QTE = PlayerGui:FindFirstChild("QTE")
	if not QTE then
		return
	end

	local QTE_PC = QTE:FindFirstChild("QTE_PC")
	if not QTE_PC then
		return
	end

	local Text = QTE_PC.Value
	if not Text or Text == "" then
		return
	end

	local Key = tostring(Text):lower()
	keyboard.click(Key)
	Feature.LastClick = Now
end

function Feature.Initialise(Container)
	local Enabled = Container:Checkbox("Lawyer QTE")
	local Delay = Container:SliderInt("QTE Delay (ms)", 1, 200, 200)
	cheat.register("onUpdate", function()
		Feature.Runtime()
		Feature.Enabled = Enabled:Get()
		Feature.Delay = Delay:Get()
		Delay:Visible(Feature.Enabled)
	end)
end

return Feature
