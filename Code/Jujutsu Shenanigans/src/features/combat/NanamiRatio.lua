local Feature = {
	Enabled = false,
	CurrentAddress = nil,
	PressedR = false,
}

local Offsets = require("@modules/game/Offsets")
local Env = require("@modules/core/Environment")

function Feature.Runtime()
	if Env.LocalInfo.SelectedCharacter ~= "Nanami" then
		return
	end

	if not Feature.Enabled then
		return
	end

	local Players = entity.GetPlayers(false)
	for _, Player in pairs(Players) do
		coroutine.resume(coroutine.create(function()
			local HumanoidRootPart = Player:GetBoneInstance("HumanoidRootPart")
			if not HumanoidRootPart then
				return
			end

			local Ratio = HumanoidRootPart:FindFirstChild("Ratio")
			if not Ratio then
				return
			end

			if not memory.read("bool", Ratio.Address + Offsets.ScreenGui_Enabled) then
				return
			end

			if not Feature.CurrentAddress or Feature.CurrentAddress ~= Ratio.Address then
				Feature.CurrentAddress = Ratio.Address
				Feature.PressedR = false
			end

			local OuterBar = Ratio:FindFirstChild("Bar")
			if not OuterBar then
				return
			end

			local Bar = OuterBar:FindFirstChild("Bar")
			local Cursor = OuterBar:FindFirstChild("Cursor")
			if not Bar or not Cursor then
				return
			end

			local CursorScale = memory.Read("float", Cursor.Address + Offsets.FramePosition.Y_Scale)
			if math.abs(CursorScale - 0.3) <= 0.03 and not Feature.PressedR then
				keyboard.Click("r")
				Feature.PressedR = true
			end
		end))
	end
end

function Feature.Initialise(Container)
	local Enabled = Container:Checkbox("Nanami QTE")

	cheat.Register("onPaint", Feature.Runtime)
	cheat.Register("onUpdate", function()
		Feature.Enabled = Enabled:Get()
	end)
end

return Feature
