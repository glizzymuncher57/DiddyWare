local storage = game.GetService("ReplicatedStorage")
local player_gui = game.LocalPlayer.PlayerGui
local screen_gui = player_gui:FindFirstChild("ScreenGui")

local double_cv = storage:FindFirstChild("DoubleConstrainedValue")
local frame1 = screen_gui:FindFirstChild("Frame1")
local frame2 = screen_gui:FindFirstChild("Frame2")
local frame3 = screen_gui:FindFirstChild("Rotation")

local function xy_pair(delta)
	return function(offset)
		return {
			X = string.format("0x%X", offset),
			Y = string.format("0x%X", offset + delta),
		}
	end
end

return {
	DoubleConstrainedValue = {
		Value = { double_cv, "double", 7812.938 },
	},

	GuiObject = {
		Position = { frame2, "float", 4232, xy_pair(8) },
		Size = { frame2, "float", 5462, xy_pair(8) },
		AbsoluteSize = { frame1, "float", 213, xy_pair(4) },
		AbsolutePosition = { frame1, "float", 232, xy_pair(4) },
		Rotation = { frame3, "float", 43432.523 },
	},
}
