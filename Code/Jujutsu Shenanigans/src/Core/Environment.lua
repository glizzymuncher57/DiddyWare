local Table = require("@utility/Table")

return {
	LocalPlayer = Table:Register("EnviromentLocalPlayer", {
		Player = game.LocalPlayer,
		Entity = entity.GetLocalPlayer(),
		PlayerGui = game.LocalPlayer.PlayerGui,

		Data = {
			Character = nil,
			Ping = 0,
		},
	}),

	Players = Table:Register("EnvironmentPlayerData", {}),
	Objects = Table:Register("EnvironmentObjects", {
		Items = {},
		Domains = {},
	}),

	ClosestDomain = Table:Register("EnvironmentClosestDomain", {
		Instance = nil,
		Distance = math.huge,
	}),
}
