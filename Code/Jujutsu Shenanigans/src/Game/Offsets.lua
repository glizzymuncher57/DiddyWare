return {
	["GuiObject"] = {
		["Position"] = { Type = "float", X = 0x508, Y = 0x510 },
		["Rotation"] = { Type = "float", Offset = 0x188 },
		["Size"] = { Type = "float", X = 0x528, Y = 0x530 },
		["AbsoluteSize"] = { Type = "float", X = 0x118, Y = 0x11C },
		["AbsolutePosition"] = { Type = "float", X = 0x110, Y = 0x114 },
		["Visible"] = { Type = "bool", Offset = 0x5A5 },
	},

	["ScreenGui"] = {
		["Enabled"] = { Type = "bool", Offset = 0x4BC },
	},

	["DoubleConstrainedValue"] = {
		["Value"] = { Type = "double", Offset = 0xE0 },
	},

	["Animator"] = {
		["AnimationTrackList"] = { Type = "pointer", Offset = 0x620 },
	},

	["Animation"] = {
		["AnimationId"] = { Type = "string", Offset = 0xD0 },
	},

	["AnimationTrack"] = {
		Animation = { Type = "pointer", Offset = 0xD0 },
		WeightTarget = { Type = "float", Offset = 0xF0 },
		Speed = { Type = "float", Offset = 0xE4 },
		TimePosition = { Type = "float", Offset = 0xE8 },
		Looped = { Type = "bool", Offset = 0xF5 },
	},
}
