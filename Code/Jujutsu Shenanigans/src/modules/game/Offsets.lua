local offsets = {
	["DoubleConstrainedValue"] = {
		["Value"] = { Type = "double", Offset = 0xE0 },
	},
	["ScreenGui"] = {
		["Enabled"] = { Type = "bool", Offset = 0x4BC },
	},
	["GuiObject"] = {
		["AbsolutePosition"] = { Type = "float", X = 0x110, Y = 0x114 },
		["Rotation"] = { Type = "float", Offset = 0x188 },
		["Position"] = { Type = "float", X = 0x508, Y = 0x510 },
		["Visible"] = { Type = "bool", Offset = 0x5A1 },
		["Size"] = { Type = "float", X = 0x528, Y = 0x530 },
		["AbsoluteSize"] = { Type = "float", X = 0x118, Y = 0x11C },
	},
	["Animator"] = {
		["AnimationTrackList"] = 0x650,
	},
	["Animation"] = {
		["AnimationId"] = 0xD0,
	},
	["AnimationTrack"] = {
		Animation = 0xD0,
		WeightTarget = 0xF0,
		Speed = 0xE4,
		TimePosition = 0xE8,
		Looped = 0xF5,
	},
}

return offsets
