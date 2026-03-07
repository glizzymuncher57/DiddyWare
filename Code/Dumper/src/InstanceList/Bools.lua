local player_gui = game.LocalPlayer.PlayerGui
local sgui = player_gui:FindFirstChild("VisUI")
local frame = sgui:FindFirstChild("VisFrame")

return {
	ScreenGui = {
		Enabled = { sgui, "bool" },
	},

	GuiObject = {
		Visible = { frame, "bool" },
	},
}
