return {
	Font = "ConsolasBold",
	DebugMode = false,

	LocalInfo = {
		Player = nil,
		PlayerGui = nil,
		Character = nil,
		MinigameUI = nil,
		SelectedCharacter = nil,
		Ping = 0,
	},

	Players = {},

	Folders = {
		Items = {},
		Domains = {},
	},

	ClosestDomain = {
		Instance = nil,
		Distance = math.huge,
	},
}
