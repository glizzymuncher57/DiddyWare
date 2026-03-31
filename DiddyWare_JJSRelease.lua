local __DIST __DIST={cache={}, load=function(m)if not __DIST.cache[m]then __DIST.cache[m]={c=__DIST[m]()}end return __DIST.cache[m].c end}do function __DIST.a()local TableManager = {}
TableManager.__index = TableManager

local _registry = {}

function TableManager:Register(name, tbl)
	tbl = tbl or {}
	if type(name) ~= "string" or type(tbl) ~= "table" then
		return
	end

	_registry[name] = tbl
	return tbl
end

function TableManager:Get(name)
	return _registry[name]
end

function TableManager:Clear(name)
	local tbl = _registry[name]
	if not tbl then
		return
	end

	for k in next, tbl do
		tbl[k] = nil
	end
end

function TableManager:Unload(name)
	local tbl = _registry[name]
	if not tbl then
		return
	end

	for k in next, tbl do
		tbl[k] = nil
	end

	_registry[name] = nil
end

function TableManager:UnloadAll()
	for name, tbl in next, _registry do
		for k in next, tbl do
			tbl[k] = nil
		end
		_registry[name] = nil
	end
end

return TableManager
end function __DIST.b()
local Table = __DIST.load('a')

local Configuration = {}
local Elements = Table:Register("Configuration.Elements", {})
local Values = Table:Register("Configuration.Values", {})

function Configuration.Register(name, element)
	Elements[name] = element
end

function Configuration.GetValue(name)
	return Values[name]
end

function Configuration.SetValue(name, value)
	Values[name] = value
end

return Configuration
end function __DIST.c()
local Callbacks = {}
local Registry = {}

local EVENTS = { "onPaint", "onUpdate", "onSlowUpdate", "shutdown" }

for _, event in ipairs(EVENTS) do
	Registry[event] = {}
end

function Callbacks.Add(EventName, CallbackFunction)
	if type(EventName) ~= "string" or type(CallbackFunction) ~= "function" then
		return nil
	end

	if not Registry[EventName] then
		return nil
	end

	local Index = #Registry[EventName] + 1
	Registry[EventName][Index] = CallbackFunction
	return Index
end

function Callbacks.Remove(EventName, Index)
	if Registry[EventName] then
		Registry[EventName][Index] = nil
	end
end

function Callbacks.ClearAll()
	for EventName, _ in pairs(Registry) do
		Registry[EventName] = {}
	end
end

local function Fire(EventName, ...)
	for _, Callback in pairs(Registry[EventName]) do
		Callback(...)
	end
end

function Callbacks:Initialise()
	for _, EventName in ipairs(EVENTS) do
		cheat.Register(EventName, function(...)
			Fire(EventName, ...)
		end)
	end
end

return Callbacks
end function __DIST.d()
local Memory = {}

local Read = memory.Read

function Memory.Read(Address, Offset)
	return Read(Offset.Type, Address + Offset.Offset)
end

function Memory.ReadVector2(Address, Offset: { Type: string, X: number, Y: number })
	local X = Read(Offset.Type, Address + Offset.X)
	local Y = Read(Offset.Type, Address + Offset.Y)
	return Vector3.new(X, Y, 0)
end

return Memory
end function __DIST.e()
return {
    ['version'] = 'version-6776addb8fbc4d17',

    ['DoubleConstrainedValue'] = {
        ['Value'] = {Type = 'double', Offset = 0xE0},
    },
    ['Animator'] = {
        ['AnimationTrackList'] = {Type = 'pointer', Offset = 0x848},
    },
    ['Animation'] = {
        ['AnimationId'] = {Type = 'string', Offset = 0xD0},
    },
    ['GuiObject'] = {
        ['Size'] = {Type = 'float', X = 0x538, Y = 0x540},
        ['AbsoluteSize'] = {Type = 'float', X = 0x118, Y = 0x11C},
        ['AbsolutePosition'] = {Type = 'float', X = 0x110, Y = 0x114},
        ['Visible'] = {Type = 'bool', Offset = 0x5B5},
        ['Position'] = {Type = 'float', X = 0x518, Y = 0x520},
        ['Rotation'] = {Type = 'float', Offset = 0x188},
    },
    ['ScreenGui'] = {
        ['Enabled'] = {Type = 'bool', Offset = 0x4CC},
    },
    ['AnimationTrack'] = {
        ['TimePosition'] = {Type = 'float', Offset = 0xE8},
        ['Speed'] = {Type = 'float', Offset = 0xE4},
        ['Looped'] = {Type = 'bool', Offset = 0xF5},
        ['Animation'] = {Type = 'pointer', Offset = 0xD0},
    },
}end function __DIST.f()-- << Imports >>

local Table = __DIST.load('a')
local Callbacks = __DIST.load('c')
local Configuration = __DIST.load('b')

-- << Locals >>
local GetTickCount = utility.getTickCount
local GetMousePos = utility.getMousePos

-- << State >>
local DebugMode = {
	Messages = Table:Register("DM.Messages", {}),
}

local MAX_MESSAGES = 20
local Drag = {
	Active = false,
	OffsetX = 0,
	OffsetY = 0,
}

-- << Constants >>
local LEVELS = {
	info = { label = "INFO", color = Color3.new(0.4, 0.8, 1.0) },
	warn = { label = "WARN", color = Color3.new(1.0, 0.85, 0.2) },
	error = { label = "ERROR", color = Color3.new(1.0, 0.3, 0.3) },
	ok = { label = "OK", color = Color3.new(0.3, 1.0, 0.5) },
}
local WHITE = Color3.new(1, 1, 1)
local GREY = Color3.new(0.5, 0.5, 0.5)
local HEADER = Color3.new(0.12, 0.12, 0.14)
local BG = Color3.new(0.08, 0.08, 0.10)
local BORDER = Color3.new(0.25, 0.25, 0.3)
local ROW_BG = Color3.new(0.15, 0.15, 0.18)

local PANEL_X = 10
local PANEL_Y = 10
local PANEL_W = 600
local LINE_H = 16
local PADDING = 8

local FADE_DURATION = 50

-- << Variables >>
local TextSizeCache = Table:Register("DM.TextSizeCache", {})

-- << Private >>
local function GetTextSize(Text, Font)
	local Key = Text .. tostring(Font)
	local Cached = TextSizeCache[Key]
	if Cached then
		return Cached[1], Cached[2]
	end
	local W, H = draw.GetTextSize(Text, Font)
	TextSizeCache[Key] = { W, H }
	return W, H
end

local function IsLevelVisible(Level, DebugInfo)
	if type(DebugInfo) ~= "table" then
		return true
	end
	return DebugInfo[Level] == true
end

local function PruneMessages()
	local Now = GetTickCount()
	local Messages = DebugMode.Messages

	for i = #Messages, 1, -1 do
		if Now >= Messages[i].Expiry then
			table.remove(Messages, i)
		end
	end

	table.sort(Messages, function(A, B)
		return A.Expiry > B.Expiry
	end)
end

local function IsMouseInHeader()
	local Mouse = GetMousePos()
	return Mouse[1] >= PANEL_X
		and Mouse[1] <= PANEL_X + PANEL_W
		and Mouse[2] >= PANEL_Y
		and Mouse[2] <= PANEL_Y + (LINE_H + PADDING * 2)
end

local function UpdateDrag(MousePressed)
	if not Drag.Active then
		if not (IsMouseInHeader() and MousePressed) then
			return
		end
		Drag.Active = true
		local Mouse = GetMousePos()
		Drag.OffsetX = Mouse[1] - PANEL_X
		Drag.OffsetY = Mouse[2] - PANEL_Y
	else
		if MousePressed then
			local Mouse = GetMousePos()
			PANEL_X = Mouse[1] - Drag.OffsetX
			PANEL_Y = Mouse[2] - Drag.OffsetY
		else
			Drag.Active = false
		end
	end
end

local function DrawPanel()
	if not Configuration.GetValue("Debug Mode") then
		return
	end

	local SelectedDebugInfo = Configuration.GetValue("Show Debug Info")
	local Font = Configuration.GetValue("Font Selection")
	local Messages = DebugMode.Messages

	if #Messages == 0 then
		return
	end

	local VisibleCount = 0
	for _, Message in ipairs(Messages) do
		if IsLevelVisible(Message.Level, SelectedDebugInfo) then
			VisibleCount = VisibleCount + 1
		end
	end

	if VisibleCount == 0 then
		return
	end

	UpdateDrag(keyboard.IsPressed("leftmouse"))

	local Now = GetTickCount()
	local HeaderH = LINE_H + PADDING * 2
	local H = PADDING + LINE_H + PADDING + (VisibleCount * LINE_H) + PADDING

	draw.RectFilled(PANEL_X, PANEL_Y, PANEL_W, H, BG, 4, 200)
	draw.RectFilled(PANEL_X, PANEL_Y, PANEL_W, HeaderH, HEADER, 4, 230)
	draw.Rect(PANEL_X, PANEL_Y, PANEL_W, H, BORDER, 1, 4, 180)

	local HeaderText = "[ DEBUG ]"
	local HeaderTH = select(2, GetTextSize(HeaderText, Font))
	draw.TextOutlined("[ DEBUG ]", PANEL_X + PADDING, PANEL_Y + (HeaderH / 2) - (HeaderTH / 2), WHITE, Font)

	local RowY = PANEL_Y + HeaderH

	for _, Message in ipairs(Messages) do
		if IsLevelVisible(Message.Level, SelectedDebugInfo) then
			local Level = LEVELS[Message.Level]
			local Tag = "[" .. Level.label .. "]"
			local TagW, TagH = GetTextSize(Tag, Font)
			local RowCY = RowY + (LINE_H / 2) - (TagH / 2)
			local Remaining = Message.Expiry - Now

			local T = Remaining < FADE_DURATION and math.max(0, Remaining / FADE_DURATION) or 1
			local Alpha = math.floor(T * T * 255)

			draw.RectFilled(PANEL_X + 1, RowY, PANEL_W - 2, LINE_H, ROW_BG, 0, math.floor(Alpha * 0.35))

			draw.TextOutlined(Tag, PANEL_X + PADDING, RowCY, Level.color, Font, Alpha)
			draw.TextOutlined(Message.Text, PANEL_X + PADDING + TagW + 6, RowCY, WHITE, Font, Alpha)

			if Message.Count > 1 then
				local Badge = "x" .. Message.Count
				local BadgeW, BadgeH = GetTextSize(Badge, Font)
				draw.TextOutlined(
					Badge,
					PANEL_X + PANEL_W - BadgeW - PADDING,
					RowY + (LINE_H / 2) - (BadgeH / 2),
					GREY,
					Font,
					Alpha
				)
			end

			RowY = RowY + LINE_H
		end
	end
end

-- << Public >>
function DebugMode.AddDebugMessage(Text, Level: "ok" | "error" | "warning" | "info", Duration)
	Level = (Level and LEVELS[Level]) and Level or "info"
	Duration = Duration or 3000
	Text = tostring(Text)

	local Now = GetTickCount()
	local Messages = DebugMode.Messages

	for i = 1, #Messages do
		local M = Messages[i]
		if M.Text == Text and M.Level == Level then
			M.Count = M.Count + 1
			M.Expiry = Now + Duration
			return
		end
	end

	if #Messages >= MAX_MESSAGES then
		table.remove(Messages, 1)
	end

	Messages[#Messages + 1] = {
		Text = Text,
		Level = Level,
		Count = 1,
		Expiry = Now + Duration,
	}
end

function DebugMode.Clear()
	local Messages = DebugMode.Messages
	for k in next, Messages do
		Messages[k] = nil
	end
end

function DebugMode:Initialise()
	Callbacks.Add("onSlowUpdate", PruneMessages)
	Callbacks.Add("onPaint", DrawPanel)
end

return DebugMode
end function __DIST.g()-- << Imports >>

local Configuration = __DIST.load('b')
local Table = __DIST.load('a')
local Callbacks = __DIST.load('c')
local Memory = __DIST.load('d')
local Offsets = __DIST.load('e')
local DebugMode = __DIST.load('f')

-- << Variables >>
local Read = memory.read
local Floor = math.floor

local AnimationManager = {
    Animations = Table:Register("AMAnimations", {}), 
    _ScanState = {
        Queue = {},
        Index = 1,
        Done = false,
        StoredCallback = nil,
    },
}

local TrackMetatable = {
    __index = function(self, key)
        local track = self.Track
        if key == "TimePosition" then
            return Floor(Memory.Read(track, Offsets.AnimationTrack.TimePosition) * 100) / 100
        elseif key == "Speed" then
            return Floor(Memory.Read(track, Offsets.AnimationTrack.Speed) * 100) / 100
        elseif key == "Looped" then
            return Memory.Read(track, Offsets.AnimationTrack.Looped)
        else
            return nil
        end
    end,
}

-- << Functions >>
local function DebugLog(Message, Level, Duration)
    if Configuration.GetValue("Debug Mode") and Message then
        DebugMode.AddDebugMessage("[AM]:" .. tostring(Message), Level, Duration)
    end
end

local function StartScan()
    if AnimationManager._ScanState.Done then return end
    AnimationManager._ScanState.Queue = { game.DataModel }
    AnimationManager._ScanState.Index = 1
end

local function ProcessAnimationScan()
    local queue = AnimationManager._ScanState.Queue
    local index = AnimationManager._ScanState.Index
    local animations = AnimationManager.Animations

    for i = 1, 250 do
        local obj = queue[index]
        if not obj then
            Callbacks.Remove("onUpdate", AnimationManager._ScanState.StoredCallback)
            DebugLog("Finished Caching Animations.", "info", 3000)
            return
        end

        if obj:IsA("Animation") then
            local AnimationId = Memory.Read(obj.Address, Offsets.Animation.AnimationId)
            if AnimationId ~= "" then
                animations[AnimationId] = obj.Name
            end
        end

        local children = obj:GetChildren()
        for j = 1, #children do
            queue[#queue + 1] = children[j]
        end

        index = index + 1
    end

    AnimationManager._ScanState.Index = index
end

function AnimationManager:GetPlayingAnimationTracks(Humanoid, PlayerData)
    if not PlayerData or not PlayerData.Player.Name or not Humanoid then return {} end

    local Tracks = {}
    local Animator = PlayerData.Animator
    if not Animator then
        DebugLog("Animator missing for " .. PlayerData.Player.Name, "warning", 1000)
        return Tracks
    end

    local List = Memory.Read(Animator.Address, Offsets.Animator.AnimationTrackList)
    if List == 0 then
        DebugLog("Wrong AnimationTrackList offset for " .. PlayerData.Player.Name, "warning", 1000)
        return Tracks
    end

    local Iterator = Read("pointer", List)
    while Iterator ~= 0 and Iterator ~= List do
        local Track = Read("pointer", Iterator + 0x10)
        if Track ~= 0 then
            local AnimationPtr = Memory.Read(Track, Offsets.AnimationTrack.Animation)
            if AnimationPtr ~= 0 then
                local AnimationId = Memory.Read(AnimationPtr, Offsets.Animation.AnimationId)
                if AnimationId ~= "" then
                    local StoredTrack = {
                        Track = Track,
                        Animation = {
                            AnimationId = AnimationId,
                            Name = AnimationManager.Animations[AnimationId] or "Unknown",
                        },
                    }
                    setmetatable(StoredTrack, TrackMetatable)
                    Tracks[#Tracks + 1] = StoredTrack
                end
            end
        end
        Iterator = Read("pointer", Iterator)
    end
	
    return Tracks
end

function AnimationManager:Initialise()
    StartScan()
    AnimationManager._ScanState.StoredCallback = Callbacks.Add("onUpdate", ProcessAnimationScan)
end

return AnimationManager end function __DIST.h()
local Table = __DIST.load('a')

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
end function __DIST.i()-- << Imports >>

local AnimationManager = __DIST.load('g')
local Table = __DIST.load('a')
local Environment = __DIST.load('h')
local Callbacks = __DIST.load('c')
local Configuration = __DIST.load('b')
local DebugMode = __DIST.load('f')

-- << Services >>
local Players = game.GetService("Players")
local Stats = game.GetService("Stats")

-- << Variables >>
local Network = Stats:FindFirstChild("Network")
local ServerStatsItem = Network.ServerStatsItem
local Ping = ServerStatsItem["Data Ping"]

local LastUseCache = Table:Register("LastUse_PlayerScanner", {})
local CooldownStarts = Table:Register("CooldownStarts_PlayerScanner", {})

local PlayerScanning = {
	LastCooldownUpdate = 0,
	LastAnimationUpdate = 0,
	LastLocalUpdate = 0,
	LastRebuild = 0,
}

-- << Functions >>
local function GetAttribute(Instance, AttributeName, DefaultValue)
	local Attribute = Instance:GetAttribute(AttributeName)
	return Attribute and Attribute.Value or DefaultValue
end

local function ProcessPlayer(Player, NewPlayers)
	if not Player or not Player.Name or Player.Name == "" then
		DebugMode.AddDebugMessage("[PlayerScanner]: Invalid Player", "warning", 1000)
		return
	end

	local Head = Player:GetBoneInstance("Head")
	local RootPart = Player:GetBoneInstance("HumanoidRootPart")
	if not Head or not RootPart then
		DebugMode.AddDebugMessage("[PlayerScanner]: Aborted " .. Player.Name .. ", Missing Bodyparts", "warning", 1000)
		return
	end

	local Character = RootPart.Parent
	if not Character then
		DebugMode.AddDebugMessage("[PlayerScanner]: Aborted " .. Player.Name .. ", Character is nil", "warning", 1000)
		return
	end

	local Humanoid = Character:FindFirstChild("Humanoid")
	local Moveset = Character:FindFirstChild("Moveset")
	if not Humanoid or not Moveset then
		DebugMode.AddDebugMessage(
			"[PlayerScanner]: Aborted " .. Player.Name .. ", Missing Humanoid or Moveset",
			"warning",
			1000
		)
		return
	end

	local Animator = Humanoid:FindFirstChildOfClass("Animator")
	local PlayerName = Player.Name
	local OldData = Environment.Players[PlayerName]
	local OldMoves = OldData and OldData.Moves or nil

	local Ordered = {}
	local Lookup = {}

	local Moves = Moveset:GetChildren()
	for i = 1, #Moves do
		local Move = Moves[i]
		local MoveName = Move.Name
		local OldMove = OldMoves and OldMoves[MoveName]

		local MoveData = {
			Name = MoveName,
			Key = GetAttribute(Move, "Key", i),
			Cooldown = Move.Value or 0,
			Instance = Move,
			MoveKey = PlayerName .. MoveName,
			IsOnCooldown = OldMove and OldMove.IsOnCooldown or false,
			Remaining = OldMove and OldMove.Remaining or 0,
		}

		Ordered[i] = MoveData
		Lookup[MoveName] = MoveData
	end

	table.sort(Ordered, function(a, b)
		return a.Key < b.Key
	end)

	local Exploiting = (RootPart.Position - Head.Position).Magnitude > 20
	local PlayerInstance = Players:FindFirstChild(PlayerName)

	local PlayerData = {
		Player = Player,
		Character = Character,
		Humanoid = Humanoid,
		Animator = Animator,
		RootPart = RootPart,
		Head = Head,
		Exploiting = Exploiting,

		SelectedMoveset = GetAttribute(Character, "Moveset", "[???]"),
		Evade = GetAttribute(Character, "Evade", 50),
		Ultimate = PlayerInstance and GetAttribute(PlayerInstance, "Ultimate", 0) or 0,
		Ragdolled = GetAttribute(Character, "Ragdoll", 0),
		Moves = Lookup,
		OrderedMoves = Ordered,
	}

	NewPlayers[PlayerName] = PlayerData
	PlayerData.Animations = AnimationManager:GetPlayingAnimationTracks(Humanoid, PlayerData)
end

local function UpdateLocalInfo()
	local LocalInfo = Environment.LocalPlayer
	local LocalPlayer = game.LocalPlayer

	LocalInfo.Entity = entity.GetLocalPlayer()
	LocalInfo.Player = LocalPlayer
	LocalInfo.PlayerGui = LocalPlayer and LocalInfo.PlayerGui or nil
	LocalInfo.MinigameInterface = LocalInfo.PlayerGui and LocalInfo.PlayerGui:FindFirstChild("DeviceUI") or nil
	LocalInfo.Data.Character = GetAttribute(LocalPlayer, "Moveset", "[???]")
	LocalInfo.Data.Ping = Ping.Value
end

local function UpdateAnimations()
	for _, Data in pairs(Environment.Players) do
		Data.Animations = AnimationManager:GetPlayingAnimationTracks(Data.Humanoid, Data)
	end
end

local function ProcessMove(MoveData, Now)
	local Instance = MoveData.Instance
	if not Instance then
		MoveData.IsOnCooldown = false
		MoveData.Remaining = 0
		return
	end

	local Key = MoveData.MoveKey
	local RobloxLastUse = GetAttribute(Instance, "LastUse", 0)

	if RobloxLastUse ~= LastUseCache[Key] then
		LastUseCache[Key] = RobloxLastUse
		CooldownStarts[Key] = Now
	end

	local Start = CooldownStarts[Key]
	if Start then
		local Elapsed = Now - Start
		if Elapsed < MoveData.Cooldown then
			MoveData.IsOnCooldown = true
			MoveData.Remaining = MoveData.Cooldown - Elapsed
		else
			MoveData.IsOnCooldown = false
			MoveData.Remaining = 0
		end
	else
		MoveData.IsOnCooldown = false
		MoveData.Remaining = 0
	end
end

local function UpdateCooldownState()
	local Now = utility.GetTickCount() / 1000

	for _, Data in pairs(Environment.Players) do
		for _, MoveData in pairs(Data.Moves) do
			ProcessMove(MoveData, Now)
		end
	end
end

local function RebuildCache()
	local NewPlayers = {}
	local LocalPlayer = entity.GetLocalPlayer()

	if LocalPlayer then
		ProcessPlayer(LocalPlayer, NewPlayers)
	end

	for _, Player in pairs(entity.GetPlayers(false)) do
		ProcessPlayer(Player, NewPlayers)
	end

	Environment.Players = NewPlayers
end

local function Runtime()
	local RescanEvery = (Configuration.GetValue("Rebuild Player Cache Interval (s)") or 1) * 1000
	local UpdateCooldownsEvery = Configuration.GetValue("Update Player Cooldowns Interval (ms)") or 50
	local UpdateAnimationsEvery = Configuration.GetValue("Update Player Animations Interval (ms)") or 10
	local UpdateLocalInfoEvery = (Configuration.GetValue("Update Local Info Interval (s)") or 1) * 1000

	local Now = utility.GetTickCount()

	if (Now - PlayerScanning.LastCooldownUpdate) >= UpdateCooldownsEvery then
		UpdateCooldownState()
		PlayerScanning.LastCooldownUpdate = Now
	end

	if (Now - PlayerScanning.LastRebuild) >= RescanEvery then
		RebuildCache()
		PlayerScanning.LastRebuild = Now
	end

	if (Now - PlayerScanning.LastAnimationUpdate) >= UpdateAnimationsEvery then
		UpdateAnimations()
		PlayerScanning.LastAnimationUpdate = Now
	end

	if (Now - PlayerScanning.LastLocalUpdate) >= UpdateLocalInfoEvery then
		UpdateLocalInfo()
		PlayerScanning.LastLocalUpdate = Now
	end
end

-- << Public API >>
function PlayerScanning:DoesPlayerHaveMove(Player, MoveName)
	if not Player or not MoveName then
		return false
	end

	local Data = Environment.Players[Player.Name]
	if not Data or not Data.Moves then
		return false
	end

	local Move = Data.Moves[MoveName]
	if not Move then
		return false
	end

	return true
end

function PlayerScanning:GetLocalPlayer()
	return Environment.Players[Environment.LocalPlayer.Entity.Name]
end

function PlayerScanning:GetPlayers()
	return Environment.Players
end

function PlayerScanning:Initialise()
	Callbacks.Add("onUpdate", function()
		Runtime()
	end)
end

return PlayerScanning
end function __DIST.j()
local FolderScanSystem = {}
FolderScanSystem.__index = FolderScanSystem

function FolderScanSystem.New()
	local self = setmetatable({}, FolderScanSystem)
	self.Queues = {}
	self.Indexes = {}
	self.Caches = {}
	self.Callbacks = {}
	self.Rates = {}
	self.LastUpdate = {}
	return self
end

function FolderScanSystem:AddCategory(CategoryName, Folders, UpdateIntervalMs, Selector)
	self.Queues[CategoryName] = Folders or {}
	self.Indexes[CategoryName] = 1
	self.Caches[CategoryName] = {}
	self.Rates[CategoryName] = UpdateIntervalMs or 50
	self.LastUpdate[CategoryName] = 0
	self.Selectors = self.Selectors or {}
	self.Selectors[CategoryName] = Selector
end

function FolderScanSystem:SetCallback(CategoryName, Fn)
	self.Callbacks[CategoryName] = Fn
end

function FolderScanSystem:Update()
	local Now = utility.GetTickCount()
	for CategoryName, Folders in pairs(self.Queues) do
		local Interval = self.Rates[CategoryName] or 50
		local Last = self.LastUpdate[CategoryName] or 0
		if Now - Last >= Interval then
			local Idx = self.Indexes[CategoryName]
			local Folder = Folders[Idx]
			if Folder then
				local Children = Folder:GetChildren()
				local Selector = self.Selectors and self.Selectors[CategoryName]
				local Cache = {}
				for i = 1, #Children do
					local Obj = Children[i]
					if Selector then
						Obj = Selector(Obj)
					end
					if Obj then
						Cache[Obj.Name] = Obj
					end
				end
				self.Caches[CategoryName] = Cache
				local Cb = self.Callbacks[CategoryName]
				if Cb then
					Cb(CategoryName, Folder, Children)
				end
			end
			Idx = Idx + 1
			if Idx > #Folders then
				Idx = 1
			end
			self.Indexes[CategoryName] = Idx
			self.LastUpdate[CategoryName] = Now
		end
	end
end

function FolderScanSystem:GetCached(CategoryName)
	local Cache = self.Caches[CategoryName]
	if not Cache then
		return {}
	end
	local List = {}
	for _, Obj in pairs(Cache) do
		List[#List + 1] = Obj
	end
	return List
end

function FolderScanSystem:ClearCache(CategoryName)
	self.Caches[CategoryName] = {}
end

function FolderScanSystem:SetInterval(CategoryName, IntervalMs)
	self.Rates[CategoryName] = IntervalMs
end

return FolderScanSystem
end function __DIST.k()
local WorldScanning = {}

-- << Imports >>
local Environment = __DIST.load('h')
local Callbacks = __DIST.load('c')
local Queue = __DIST.load('j').New()

-- << Services >>
local Workspace = game.GetService("Workspace")

-- << Variables >>
local Items = Workspace.Items
local Domains = Workspace.Domains

function WorldScanning:Initialise()
	Queue:AddCategory("Domains", { Domains }, 2000)
	Queue:AddCategory("Items", { Items }, 2000)
	Queue:SetCallback("Domains", function(CategoryName, Folder, Children)
		local LocalPosition = Environment.LocalPlayer.Entity.Position
		local ClosestDomain, ClosestPosition, ClosestDistance = nil, nil, math.huge
		for _, Domain in pairs(Children) do
			local Inner = Domain:FindFirstChildOfClass("MeshPart")
			local Position = Inner.Position
			local Distance = (Position - LocalPosition).Magnitude
			if Distance < ClosestDistance then
				ClosestPosition = Position
				ClosestDomain = Domain
				ClosestDistance = Distance
			end
		end

		Environment.ClosestDomain.Instance = ClosestDomain
		Environment.ClosestDomain.Distance = ClosestDistance
		Environment.ClosestDomain.Position = ClosestPosition
	end)

	Callbacks.Add("onUpdate", function()
		Queue:Update()
		Environment.Objects.Items = Queue:GetCached("Items")
		Environment.Objects.Domains = Queue:GetCached("Domains")
	end)
end

return WorldScanning
end function __DIST.l()-- << Imports >>

local DebugMode = __DIST.load('f')
local Table = __DIST.load('a')
local Callbacks = __DIST.load('c')
local Configuration = __DIST.load('b')
local Environment = __DIST.load('h')
local PlayerScanner = __DIST.load('i')

-- << Variables >>
local EntityLocalPlayer = Environment.LocalPlayer.Entity

-- << Cached Globals
local GetTickCount = utility.GetTickCount
local IsPressed = keyboard.IsPressed
local Click = keyboard.Click

local Combat = {
	Delay = 0.285,
	CombatState = Table:Register("AutoBlackFlashState", {
		Waiting = false,
		WasDown = false,
		NextPressTime = 0,
	}),
}

-- << Functions >>
local function SendDebugInfo(Message)
	if not Configuration.GetValue("Debug Mode") then
		return
	end

	DebugMode.AddDebugMessage(Message, "info", 1000)
end

local function Runtime()
	local Now = GetTickCount()
	local IsDown = IsPressed(0x33)
	local CombatState = Combat.CombatState

	if IsDown and not CombatState.WasDown and not CombatState.Waiting then
		local BaseDelaySeconds = Configuration.GetValue("Auto Blackflash Timing")
		local DelayMs = BaseDelaySeconds * 1000

		CombatState.NextPressTime = Now + DelayMs
		CombatState.Waiting = true
	end

	if CombatState.Waiting and Now >= CombatState.NextPressTime then
		Click(0x33)
		CombatState.Waiting = false
		SendDebugInfo("Completed Yuji/Mahito Blackflash.")
	end

	Combat.WasDown = IsDown
end

function Combat:Initialise()
	Callbacks.Add("onUpdate", function(...): ...any
		if not Configuration.GetValue("Auto Blackflash") then
			return
		end

		if Configuration.GetValue("Auto Blackflash Hotkey") ~= true then
			return
		end

		if
			not PlayerScanner:DoesPlayerHaveMove(EntityLocalPlayer, "Focus Strike")
			and not PlayerScanner:DoesPlayerHaveMove(EntityLocalPlayer, "Divergent Fist")
		then
			return
		end

		Runtime()
	end)
end

return Combat
end function __DIST.m()
local Combat = {
	LastClick = 0,
}
-- << Imports >>
local Environment = __DIST.load('h')
local Configuration = __DIST.load('b')
local Callbacks = __DIST.load('c')

-- << Cached Globals >>
local GetTickCount = utility.GetTickCount
local Click = keyboard.Click

-- << Variables >>
local PlayerGui = Environment.LocalPlayer.PlayerGui

-- << Constants >>
local CONFIG_KEY = "Auto Lawyer QTE"
local CONFIG_DELAY_KEY = "Auto Lawyer QTE Delay (ms)"
local QTE_GUI = "QTE"
local QTE_PC = "QTE_PC"

local function Runtime()
	if not Configuration.GetValue(CONFIG_KEY) then
		return
	end

	local Now = GetTickCount()
	if (Now - Combat.LastClick) < Configuration.GetValue(CONFIG_DELAY_KEY) then
		return
	end

	if not PlayerGui then
		PlayerGui = Environment.LocalPlayer.Player.PlayerGui
		return
	end

	local QuickTime = PlayerGui:FindFirstChild(QTE_GUI)
	local QuickTimePC = QuickTime and QuickTime:FindFirstChild(QTE_PC)
	if not QuickTimePC then
		return
	end

	local Text = QuickTimePC.Value
	if not Text or Text == "" then
		return
	end

	Click(tostring(Text):lower())
	Combat.LastClick = Now
end

function Combat:Initialise()
	Callbacks.Add("onUpdate", Runtime)
end

return Combat end function __DIST.n()
local Combat = {}

-- << Imports >>
local Callbacks = __DIST.load('c')
local Table = __DIST.load('a')
local Configuration = __DIST.load('b')
local PlayerScanner = __DIST.load('i')
local DebugMode = __DIST.load('f')

-- << Variables >>
local LocalPlayer = entity.GetLocalPlayer()

local Timings = Table:Register("MahoragaTimingTable", {
	AnimationId = "rbxassetid://85024950165903",
})

local State = Table:Register("MahoragaState", {
	WasEarthquaking = false,
	Waiting = false,
})

-- << Functions >>
local function SendDebugInfo(Message)
	if not Configuration.GetValue("Debug Mode") then
		return
	end

	DebugMode.AddDebugMessage(Message, "info", 1000)
end

local function GetAnimationByID(AnimationID)
	local LocalTracker = PlayerScanner:GetLocalPlayer()
	local Tracks = LocalTracker.Animations
	if not Tracks then
		return nil
	end

	for i = 1, #Tracks do
		if Tracks[i].Animation.AnimationId == AnimationID then
			return Tracks[i]
		end
	end
	return nil
end

local function Runtime()
	if not Configuration.GetValue("Auto Mahoraga Earthquake") then
		return
	end

	if not PlayerScanner:DoesPlayerHaveMove(LocalPlayer, "Earthquake") then
		return
	end

	local IsEarthquaking = GetAnimationByID(Timings.AnimationId)
	if IsEarthquaking and not State.WasEarthquaking and not State.Waiting then
		State.Waiting = true
	end

	if State.Waiting then
		if not IsEarthquaking then
			State.Waiting = false
			return
		end

		local TimePosition = IsEarthquaking.TimePosition
		SendDebugInfo("Current Mahoraga Earthquake Time:" .. TimePosition)
		if TimePosition >= Configuration.GetValue("Auto Mahoraga Earthquake Time Position") then
			keyboard.Release(0x33)
			State.Waiting = false
			SendDebugInfo("Completed Mahoraga Earthquake")
		end
	end

	State.WasEarthquaking = IsEarthquaking ~= nil
end

function Combat:Initialise()
	Callbacks.Add("onUpdate", Runtime)
end

return Combat
end function __DIST.o()
local Combat = {
	CurrentRatio = nil,
	PressedR = false,
}

-- << Imports >>
local Environment = __DIST.load('h')
local Callbacks = __DIST.load('c')
local Configuration = __DIST.load('b')
local Offsets = __DIST.load('e')
local DebugMode = __DIST.load('f')

-- << Cached Globals >>
local GetPlayers = entity.GetPlayers
local Read = memory.Read
local Abs = math.abs
local PressKey = keyboard.Click

-- << Constants >>
local GUI_ENABLED = Offsets.ScreenGui.Enabled
local GUI_POSITION = Offsets.GuiObject.Position

-- << Functions >>
local function SendDebugInfo(Message)
	if not Configuration.GetValue("Debug Mode") then
		return
	end

	DebugMode.AddDebugMessage(Message, "info", 1000)
end

local function Ratio(Entity)
	local HumanoidRootPart = Entity:GetBoneInstance("HumanoidRootPart")
	if not HumanoidRootPart then
		return
	end

	local RatioObject = HumanoidRootPart:FindFirstChild("Ratio")
	if not RatioObject then
		return
	end

	local RatioAddress = RatioObject.Address
	if not Read(GUI_ENABLED.Type, RatioAddress + GUI_ENABLED.Offset) then
		return
	end

	local CurrentRatio = Combat.CurrentRatio
	if not CurrentRatio or CurrentRatio ~= RatioAddress then
		Combat.CurrentRatio = RatioAddress
		Combat.PressedR = false
	end

	local Cursor = RatioObject.Bar.Cursor
	local CursorScale = Read(GUI_POSITION.Type, Cursor.Address + GUI_POSITION.Y)
	local TargetScale = Configuration.GetValue("Auto Nanami Ratio GUI Scale")
	local Current = Abs(CursorScale - TargetScale)
	SendDebugInfo("Nanami Ratio Current Distance: " .. tostring(Current))
	if Current <= 0.03 and not Combat.PressedR then
		Combat.PressedR = true
		PressKey("r")
		SendDebugInfo("Completed Nanami Ratio")
	end
end

local function OnRuntime()
	if not Configuration.GetValue("Auto Nanami Ratio") then
		return
	end

	if Environment.LocalPlayer.Data.Character ~= "Nanami" then
		return
	end

	local EntityList = GetPlayers(false)
	for i = 1, #EntityList do
		local Entity = EntityList[i]
		Ratio(Entity)
	end
end

function Combat:Initialise()
	Callbacks.Add("onUpdate", OnRuntime)
end

return Combat
end function __DIST.p()
local Combat = {}

-- << Imports >>
local Callbacks = __DIST.load('c')
local Table = __DIST.load('a')
local Configuration = __DIST.load('b')
local PlayerScanner = __DIST.load('i')
local DebugMode = __DIST.load('f')

-- << Variables >>
local LocalPlayer = entity.GetLocalPlayer()
local State = Table:Register("TodoBlackflashState", {
	Waiting = false,
	BruteForceFired = false,
})

local Animations = Table:Register("TodoBlackflashAnimationsTable", {
	["Slide"] = "rbxassetid://100081544058065",
	["Brute Force"] = "rbxassetid://123167492985370",
})

-- << Cached Globals
local PressKey = keyboard.Click

-- << Functions >>
local function SendDebugInfo(Message)
	if not Configuration.GetValue("Debug Mode") then
		return
	end

	DebugMode.AddDebugMessage(Message, "info", 1000)
end

local function GetAnimationByID(AnimationId)
	if not AnimationId then
		return
	end

	local LocalTracker = PlayerScanner:GetLocalPlayer()
	local Tracks = LocalTracker and LocalTracker.Animations or nil
	if not Tracks then
		return nil
	end

	for i = 1, #Tracks do
		if Tracks[i].Animation.AnimationId == AnimationId then
			return Tracks[i]
		end
	end
	return nil
end

local function Runtime()
	if not Configuration.GetValue("Auto Blackflash") then
		return
	end

	if Configuration.GetValue("Auto Blackflash Hotkey") ~= true then
		return
	end

	if not PlayerScanner:DoesPlayerHaveMove(LocalPlayer, "Brute Force") then
		return
	end

	local IsSliding = GetAnimationByID(Animations.Slide)
	local BruteForce = GetAnimationByID(Animations["Brute Force"])

	if State.BruteForceFired and not BruteForce then
		State.BruteForceFired = false
	end

	if IsSliding and not State.Waiting and not State.BruteForceFired then
		SendDebugInfo("Queued Todo Blackflash - Waiting for Brute Force")
		State.Waiting = true
	end

	if State.Waiting and not IsSliding and not BruteForce then
		State.Waiting = false
		State.BruteForceFired = false
		SendDebugInfo("Cancelled Blackflash, Animation Ended.")
	end

	if State.Waiting and BruteForce and not State.BruteForceFired then
		local TimePosition = BruteForce.TimePosition
		local TargetTime = Configuration.GetValue("Auto Todo Blackflash Time Position")
		if TimePosition >= TargetTime then
			PressKey(0x32)
			SendDebugInfo("Triggered Todo Blackflash at TimePosition: "..tostring(TimePosition))
			State.BruteForceFired = true
			State.Waiting = false
		end
	end
end

function Combat:Initialise()
	Callbacks.Add("onUpdate", Runtime)
end

return Combat end function __DIST.q()
local Combat = {}

-- << Imports >>
local Callbacks = __DIST.load('c')
local Table = __DIST.load('a')
local Configuration = __DIST.load('b')
local PlayerScanner = __DIST.load('i')
local Environment = __DIST.load('h')
local DebugMode = __DIST.load('f')

-- << Variables >>
local State = Table:Register("TodoSwapState", {
	Waiting = false,
	Fired = false,
	StoredClap = nil,
})

local Animations = Table:Register("TodoSwapWhitelistedAnimations", {
	["Clap1"] = true,
	["Clap2"] = true,
	["Clap3"] = true,
})

-- << Cached Globals
local MouseClick = mouse.Click

-- << Functions >>
local function SendDebugInfo(Message)
	if not Configuration.GetValue("Debug Mode") then
		return
	end

	DebugMode.AddDebugMessage(Message, "info", 1000)
end

local function IsClapping()
	local LocalTracker = PlayerScanner:GetLocalPlayer()
	local Tracks = LocalTracker and LocalTracker.Animations or nil
	if not Tracks then
		return nil
	end

	local confirmed_animations = {}
	for i = 1, #Tracks do
		local Track = Tracks[i]
		if Animations[Track.Animation.Name] then
			confirmed_animations[#confirmed_animations + 1] = Track
		end
	end

	local animation_instance, lowest_time_position = nil, math.huge;
	for _, confirmed_animation in pairs(confirmed_animations) do
		if confirmed_animation.TimePosition < lowest_time_position then
			animation_instance = confirmed_animation;
			lowest_time_position = confirmed_animation.TimePosition;
		end;
	end;

	return animation_instance
end

local function Runtime()
	if not Configuration.GetValue("Auto Todo Perfect Swap") then return end
	if Configuration.GetValue("Auto Todo Perfect Swap Hotkey") ~= true then return end
	if Environment.LocalPlayer.Data.Character ~= "Todo" then return end

	local CurrentClap = IsClapping()
	if not CurrentClap then
		State.StoredClap = nil
		State.Waiting = false
		State.Fired = false
		return
	end

	print(CurrentClap.Track, State.StoredClap and State.StoredClap.Track or "0xFart")
	if State.StoredClap ~= nil and CurrentClap.Track ~= State.StoredClap.Track then
		MouseClick("leftmouse");
		return	
end;

	State.StoredClap = CurrentClap;

	if not State.Waiting and not State.Fired then
		SendDebugInfo("Detected Clap, Waiting.")
		State.Waiting = true
	end

	if State.Waiting and not State.Fired then
		local TargetTime = Configuration.GetValue("Auto Todo Perfect Swap Time Position")
		if CurrentClap.TimePosition >= TargetTime then
			MouseClick("leftmouse")
			State.Waiting = false
			State.Fired = true
			SendDebugInfo("Completed Todo Perfect Swap")
		end
	end
end
function Combat:Initialise()
	Callbacks.Add("onUpdate", Runtime)
end

return Combat end function __DIST.r()
local Combat = {}

-- << Imports >>
local Callbacks = __DIST.load('c')
local Table = __DIST.load('a')
local Configuration = __DIST.load('b')
local PlayerScanner = __DIST.load('i')
local DebugMode = __DIST.load('f')

-- << Variables >>
local TrackedItems = Table:Register("PunishM1Items", {})

-- << Functions >>
local function SendDebugInfo(Message, Level)
	if not Configuration.GetValue("Debug Mode") then
		return
	end

	DebugMode.AddDebugMessage(Message, Level, 1000)
end

local function GetClosestPlayer(LocalData)
    local ClosestData, ClosestDistance = nil, math.huge

    for _, StoredData in pairs(PlayerScanner:GetPlayers()) do
        if StoredData ~= LocalData then
            local Distance = (LocalData.Player.Position - StoredData.Player.Position).Magnitude
            if Distance < ClosestDistance then
                ClosestData = StoredData
                ClosestDistance = Distance
            end
        end
    end

    return ClosestData, ClosestDistance
end

local function Runtime()
	if not Configuration.GetValue("Auto Return M1") then
		return
	end

    local LocalPlayer = PlayerScanner:GetLocalPlayer()
    local RootPart = LocalPlayer and LocalPlayer.RootPart
    if not RootPart then
        SendDebugInfo("Aborted Auto Return M1, No HRP.", "error")
        return
    end

    local BlockHit = RootPart:FindFirstChild("BlockHit")
    if not BlockHit or TrackedItems[BlockHit.Address] then return end

    TrackedItems[BlockHit.Address] = utility.GetTickCount()

    local ClosestPlayer, ClosestDistance = GetClosestPlayer(LocalPlayer)
    if not ClosestPlayer or not ClosestDistance or ClosestDistance > 8 then
        return
    end

    keyboard.release("f")
    mouse.click("leftmouse")
    keyboard.press("f")
end

function Combat:Initialise()
	Callbacks.Add("onUpdate", function()
        Runtime()
    end)

	Callbacks.Add("onSlowUpdate", function()
		if TrackedItems and type(TrackedItems) == "table" and next(TrackedItems) then
			local Now = utility.GetTickCount()
			for Address, TimeStored in pairs(TrackedItems) do
				if (Now - TimeStored) > 1000 then
					TrackedItems[Address] = nil
				end
			end
		end
	end)
end

return Combat
end function __DIST.s()
local Visuals = {}

-- << Imports >>
local Callbacks = __DIST.load('c')
local Table = __DIST.load('a')
local Configuration = __DIST.load('b')
local Environment = __DIST.load('h')

-- << Variables >>
local TextSizeCache = Table:Register("PV_TextSizeCache", {})
local NameCache = Table:Register("PV_NameCache", {})
local ColorCache = Table:Register("PV_ColorCache", {})

-- << Constants >>
local COLOUR_BLACK = Color3.new(0, 0, 0)
local COLOUR_WHITE = Color3.new(1, 1, 1)

-- << Cached Globals
local NewColorRGB = Color3.fromRGB
local Rect = draw.Rect
local RectFilled = draw.RectFilled
local ComputeConvexHull = draw.ComputeConvexHull
local Polyline = draw.Polyline
local ConvexPolyFilled = draw.ConvexPolyFilled
local TextOutlined = draw.TextOutlined
local TextSize = draw.GetTextSize
local PartCorners = draw.GetPartCorners
local WorldToScreen = utility.WorldToScreen

-- << Functions >>
local function TableToRGB(Table)
	if type(Table) ~= "table" then
		return NewColorRGB(255, 255, 255)
	end

	local r = Table.R or Table.r or 255
	local g = Table.G or Table.g or 255
	local b = Table.B or Table.b or 255

	local key = r .. "," .. g .. "," .. b
	local cached = ColorCache[key]

	if cached then
		return cached
	end

	local color = NewColorRGB(r, g, b)
	ColorCache[key] = color

	return color
end

local function GetTextSize(Text, Font)
	local Key = Text .. tostring(Font)
	local Cached = TextSizeCache[Key]
	if Cached then
		return Cached[1], Cached[2]
	end
	local W, H = TextSize(Text, Font)
	TextSizeCache[Key] = { W, H }
	return W, H
end

local function GetNameSlice(Name, Len)
	local Cache = NameCache[Name]
	if not Cache then
		Cache = {}
		NameCache[Name] = Cache
	end

	local Cached = Cache[Len]
	if Cached then
		return Cached
	end

	local Result = string.sub(Name, 1, Len)
	Cache[Len] = Result
	return Result
end

local function AddPartPoints(part, t)
	local corners = PartCorners(part)
	if not corners then
		return
	end

	for _, WorldPosition in ipairs(corners) do
		local X, Y, OnScreen = WorldToScreen(WorldPosition)
		if OnScreen then
			t[#t + 1] = { X, Y }
		end
	end
end

local function Clear(t)
	for i = #t, 1, -1 do
		t[i] = nil
	end
end

local function DrawPlayer(Player, PlayerData, Settings, ScreenPoints)
	if not Player or not PlayerData or not Settings then
		return
	end

	if not Player.IsAlive then
		return
	end

	local Position = Player.Position

	local EvasiveBarColor = Settings.EvasiveBarColor
	local EvasiveBarRGB = TableToRGB(EvasiveBarColor)
	local CooldownFillColor = Settings.CooldownFillColor
	local CooldownFillRGB = TableToRGB(CooldownFillColor)
	local CooldownBackgroundColor = Settings.CooldownBackgroundColor
	local CooldownBackgroundRGB = TableToRGB(CooldownBackgroundColor)
	local AnimationDesyncOutlineColor = Settings.AnimationDesyncOutlineColor
	local AnimationDesyncOutlineRGB = TableToRGB(AnimationDesyncOutlineColor)
	local AnimationDesyncFillColor = Settings.AnimationDesyncFillColor
	local AnimationDesyncFillRGB = TableToRGB(AnimationDesyncFillColor)

	if Settings.AnimationDesyncGuides and PlayerData.Exploiting then
		local RootPart = PlayerData.RootPart
		if not RootPart then
			return
		end

		AddPartPoints(RootPart, ScreenPoints)

		if #ScreenPoints >= 3 then
			local Hull = ComputeConvexHull(ScreenPoints)
			if Hull then
				Polyline(Hull, AnimationDesyncOutlineRGB, true, 2, AnimationDesyncOutlineColor.a)
				ConvexPolyFilled(Hull, AnimationDesyncFillRGB, AnimationDesyncFillColor.a)
			end
		end

		Clear(ScreenPoints)
	end

	local _, _, OnScreen = WorldToScreen(Position)
	if not OnScreen then
		return
	end

	local BoundingBox = Player.BoundingBox
	if not BoundingBox then
		return
	end

	local Font = Settings.Font

	local Evade = PlayerData.Evade

	if Settings.DrawEvasiveBar and Evade then
		local EvasivePct = math.clamp(Evade / 50, 0, 1)
		local BarH = BoundingBox.h * EvasivePct
		local BarX = BoundingBox.x - 8
		local BarY = BoundingBox.y
		local Height = BoundingBox.h

		RectFilled(BarX - 1, BarY - 1, 7, Height + 2, COLOUR_BLACK, 0, 255)
		RectFilled(BarX, BarY + Height - BarH, 5, BarH, EvasiveBarRGB, 0, 255)

		local Text = tostring(math.floor(EvasivePct * 100)) .. "%"
		local TextW = GetTextSize(Text, Font)
		TextOutlined(Text, BarX - TextW - 2, BarY, COLOUR_WHITE, Settings.Font)
	end

	local OrderedMoves = PlayerData.OrderedMoves
	if Settings.DrawCooldowns and OrderedMoves then
		local NumberOfMoves = #OrderedMoves
		local BoxSize = BoundingBox.h / NumberOfMoves
		local StartX, StartY = BoundingBox.x + BoundingBox.w + 2, BoundingBox.y

		for i = 1, NumberOfMoves do
			local Move = OrderedMoves[i]
			local RemainingTime = Move.Remaining
			local BoxY = StartY + (i - 1) * BoxSize

			RectFilled(StartX, BoxY, BoxSize, BoxSize, CooldownBackgroundRGB, 0, CooldownBackgroundColor.a)
			--
			if RemainingTime > 0 then
				local Percent = RemainingTime / Move.Cooldown
				local OverlayWidth = BoxSize * Percent
				--
				RectFilled(
					StartX + BoxSize - OverlayWidth,
					BoxY,
					OverlayWidth,
					BoxSize,
					CooldownFillRGB,
					0,
					CooldownFillColor.a
				)
			end
			Rect(StartX, BoxY, BoxSize, BoxSize, COLOUR_WHITE)
			--

			local Name = Move.Name
			local TextToDraw = Name
			local FontToUse = Font

			if BoxSize < 40 then
				FontToUse = "SmallestPixel"
			end

			if BoxSize < 25 then
				TextToDraw = GetNameSlice(Name, 1)
			elseif BoxSize < 40 then
				TextToDraw = GetNameSlice(Name, 3)
			end

			if BoxSize >= 15 then
				local TextWidth, TextHeight = GetTextSize(TextToDraw, FontToUse)
				local TextX = StartX + (BoxSize - TextWidth) / 2
				local TextY = BoxY + (BoxSize - TextHeight) / 2
				TextOutlined(TextToDraw, TextX, TextY, COLOUR_WHITE, FontToUse)
			end
		end
	end
end

local function Runtime()
	if not Configuration.GetValue("Visuals Enabled") then
		return
	end

	local Settings = {
		DrawCooldowns = Configuration.GetValue("Draw Cooldowns"),
		CooldownFillColor = Configuration.GetValue("Cooldown Fill Color"),
		CooldownBackgroundColor = Configuration.GetValue("Cooldown Background Color"),
		DrawEvasiveBar = Configuration.GetValue("Draw Evasive Bar"),
		EvasiveBarColor = Configuration.GetValue("Evasive Fill Color"),
		AnimationDesyncGuides = Configuration.GetValue("Draw Animation Desync Guides"),
		AnimationDesyncOutlineColor = Configuration.GetValue("Animation Desync Flagged Outline"),
		AnimationDesyncFillColor = Configuration.GetValue("Animation Desync Flagged Fill"),
		Font = Configuration.GetValue("Font Selection"),
	}

	local ScreenPoints = {}

	local EntityList = entity.GetPlayers(false)
	for i = 1, #EntityList do
		local Entity = EntityList[i]
		local Data = Environment.Players[Entity.Name]
		DrawPlayer(Entity, Data, Settings, ScreenPoints)
	end
end

function Visuals:Initialise()
	Callbacks.Add("onPaint", function(...): ...any
		Runtime()
	end)
end

return Visuals
end function __DIST.t()
local Visuals = {}

-- << Imports >>
local Callbacks = __DIST.load('c')
local Configuration = __DIST.load('b')
local Table = __DIST.load('a')
local Environment = __DIST.load('h')

-- << Variables >>
local TextSizeCache = Table:Register("WV_TextSizeCache", {})
local ColorCache = Table:Register("WV_ColorCache", {})
local FloorCache = Table:Register("WV_FloorCache", {})

-- << Cached Globals
local NewColorRGB = Color3.fromRGB
local TextOutlined = draw.TextOutlined
local TextSize = draw.GetTextSize
local WorldToScreen = utility.WorldToScreen
local GetWindowSize = cheat.GetWindowSize
local MathFloor = math.floor

-- << Functions >>
local function GetAttribute(Instance, AttributeName, DefaultValue)
	local Attribute = Instance:GetAttribute(AttributeName)
	return Attribute and Attribute.Value or DefaultValue
end

local function TableToRGB(Table)
	if type(Table) ~= "table" then
		return NewColorRGB(255, 255, 255)
	end

	local r = Table.R or Table.r or 255
	local g = Table.G or Table.g or 255
	local b = Table.B or Table.b or 255

	local key = r .. "," .. g .. "," .. b
	local cached = ColorCache[key]

	if cached then
		return cached
	end

	local color = NewColorRGB(r, g, b)
	ColorCache[key] = color

	return color
end

local function CachedFloor(n)
	local v = FloorCache[n]
	if v then
		return v
	end

	v = MathFloor(n)
	FloorCache[n] = v
	return v
end

local function GetTextSize(Text, Font)
	local Key = Text .. tostring(Font)
	local Cached = TextSizeCache[Key]
	if Cached then
		return Cached[1], Cached[2]
	end
	local W, H = TextSize(Text, Font)
	TextSizeCache[Key] = { W, H }
	return W, H
end

local function RenderDomains(Settings)
	if not Settings.Enabled then
		return
	end

	local Font = Settings.Font
	local Color = Settings.Color
	local ColorRGB = TableToRGB(Color)
	--
	local ScreenWidth = GetWindowSize()
	local ClosestDomain = Environment.ClosestDomain
	local Domains = Environment.Objects.Domains
	--
	for i = 1, #Domains do
		local Domain = Domains[i]
		if Domain then
			local Health = GetAttribute(Domain, "Health", 0)
			local HealthText = "Domain Health: " .. tostring(CachedFloor(Health))
			local TextWidth, TextHeight = GetTextSize(HealthText, Font)

			local FinalX, FinalY, FinalOnScreen = nil, nil, false

			if ClosestDomain.Instance and Domain == ClosestDomain.Instance and ClosestDomain.Distance <= 40 then
				FinalX = (ScreenWidth / 2) - (TextWidth / 2)
				FinalY = 50
				FinalOnScreen = true
			else
				local ScreenX, ScreenY, OnScreen = utility.WorldToScreen(Domain.Position)
				if OnScreen then
					FinalX = ScreenX - TextWidth / 2
					FinalY = ScreenY - TextHeight / 2
					FinalOnScreen = OnScreen
				end
			end

			if FinalOnScreen and HealthText ~= "" then
				TextOutlined(HealthText, FinalX, FinalY, ColorRGB, Font, Color.a)
			end
		end
	end
end

local function RenderItems(Settings)
	if not Settings.Enabled then
		return
	end

	local Font = Settings.Font
	local Color = Settings.Color
	local ColorRGB = TableToRGB(Color)

	local Items = Environment.Objects.Items
	for i = 1, #Items do
		local Item = Items[i]
		if Item then
			local ScreenX, ScreenY, OnScreen = WorldToScreen(Item.Position)
			if OnScreen then
				local Text = Item.Name
				local TextWidth, TextHeight = GetTextSize(Text, Font)
				local FinalX, FinalY = ScreenX - (TextWidth / 2), ScreenY - (TextHeight / 2)
				if Text ~= "" then
					TextOutlined(Text, FinalX, FinalY, ColorRGB, Font, Color.a)
				end
			end
		end
	end
end

local function Render()
	if not Configuration.GetValue("Visuals Enabled") then
		return
	end

	local Font = Configuration.GetValue("Font Selection")

	RenderDomains({
		Enabled = Configuration.GetValue("Domain Health ESP"),
		Color = Configuration.GetValue("Domain Health ESP Color"),
		Font = Font,
	})

	RenderItems({
		Enabled = Configuration.GetValue("Item ESP"),
		Color = Configuration.GetValue("Item ESP Color"),
		Font = Font,
	})
end

function Visuals:Initialise()
	Callbacks.Add("onPaint", Render)
end

return Visuals
end function __DIST.u()
local MemoryFunctions = __DIST.load('d')
local Offsets = __DIST.load('e')
local LastClick = 0

local function GetFrameSize(Frame)
	local Address = Frame.Address
	return MemoryFunctions.ReadVector2(Address, Offsets.GuiObject.AbsoluteSize)
end

local function GetFramePosition(Frame)
	local Address = Frame.Address
	return MemoryFunctions.ReadVector2(Address, Offsets.GuiObject.AbsolutePosition)
end

local function GetFrameCenter(Frame)
	local Position, Size = GetFramePosition(Frame), GetFrameSize(Frame)
	return Position + (Size / 2)
end

local function GetClosestWall(Walls, GuyCenter, GameSize)
	local ClosestWall, ClosestDistance = nil, math.huge
	local Buffer = GameSize.X * 0.05

	for _, Wall in pairs(Walls:GetChildren()) do
		local WallCenter = GetFrameCenter(Wall)
		local WallSize = GetFrameSize(Wall.Top)
		local WallRightEdge = WallCenter.X + (WallSize.X / 2)

		local IsWallAhead = WallRightEdge + Buffer > GuyCenter.X

		if IsWallAhead then
			local Distance = WallCenter.X - GuyCenter.X
			if Distance < ClosestDistance then
				ClosestWall = Wall
				ClosestDistance = Distance
			end
		end
	end

	return ClosestWall
end

return function(Interface)
	if not Interface then
		return
	end

	local GameUI = Interface.Screen.Game
	local Guy = GameUI.Guy
	local Now = utility.GetTickCount()

	if MemoryFunctions.Read(Guy.Explode.Address, Offsets.GuiObject.Visible) then
		return
	end

	local GameSize = GetFrameSize(GameUI)
	local GuyCenter = GetFrameCenter(Guy)

	local ClosestWall = GetClosestWall(GameUI.Walls, GuyCenter, GameSize)
	if not ClosestWall then
		return
	end

	local Top, Bottom = ClosestWall.Top, ClosestWall.Bottom

	local TopPosition, TopSize = GetFramePosition(Top), GetFrameSize(Top)
	local BottomPosition = GetFramePosition(Bottom)

	local Bottom_TopPipe = TopPosition.Y + TopSize.Y
	local Top_BottomPipe = BottomPosition.Y
	local Gap = Top_BottomPipe - Bottom_TopPipe

	local GapCenterY = Bottom_TopPipe + Gap * 0.5
	local Threshold = Gap * 0.1
	local TargetY = GapCenterY + Threshold

	if GuyCenter.Y > TargetY and Now - LastClick > 25 then
		mouse.Click("leftmouse")
		LastClick = Now
	end
end
end function __DIST.v()
local MemoryFunctions = __DIST.load('d')
local Offsets = __DIST.load('e')

local function GetFrameSize(Frame)
	local Address = Frame.Address
	return MemoryFunctions.ReadVector2(Address, Offsets.GuiObject.AbsoluteSize)
end

local function GetFramePosition(Frame)
	local Address = Frame.Address
	return MemoryFunctions.ReadVector2(Address, Offsets.GuiObject.AbsolutePosition)
end

local function GetFrameCenter(Frame)
	local Position, Size = GetFramePosition(Frame), GetFrameSize(Frame)
	return Position + (Size / 2)
end

local function GetClosestFoodToFloor(Interface, GuyCenter)
	local Floor = Interface.BG1.Floor
	local Food = Interface.Food

	if not Floor or not Food then
		print("Minigame Critical Error | Couldn't find floor or food!")
		return nil
	end

	local FloorPosition = GetFramePosition(Floor)
	local FloorSize = GetFrameSize(Floor)
	local SpeedThreshold = FloorSize.X * 0.15
	local ClosestFood, ClosestFoodPosition, ClosestDistance = nil, nil, math.huge

	for _, Child in pairs(Food:GetChildren()) do
		local Position = GetFrameCenter(Child)
		local DistanceX = math.abs(Position.X - GuyCenter.X)
		local DistanceY = FloorPosition.Y - Position.Y

		local ValidSpeed = Child.Name == "Speed" and DistanceX > SpeedThreshold
		if not ValidSpeed then
			if DistanceY < ClosestDistance then
				ClosestFood = Child
				ClosestFoodPosition = Position
				ClosestDistance = DistanceY
			end
		end
	end

	return ClosestFood, ClosestFoodPosition
end

return function(Interface)
	if not Interface then
		return
	end

	local GameUI = Interface.Screen.Game
	local Guy = GameUI.Guy

	if MemoryFunctions.Read(Guy.Explode.Address, Offsets.GuiObject.Visible) then
		return
	end

	local GuyCenter = GetFrameCenter(Guy)
	local ClosestFood, FoodPosition = GetClosestFoodToFloor(GameUI, GuyCenter)
	if not ClosestFood or not FoodPosition then
		return
	end

	local dx = FoodPosition.X - GuyCenter.X
	if math.abs(dx) >= 20 then
		if dx < 0 then
			keyboard.click("a")
		else
			keyboard.click("d")
		end
	end
end
end function __DIST.w()-- << Imports >>

local Callbacks = __DIST.load('c')
local Configuration = __DIST.load('b')
local Table = __DIST.load('a')

-- << State >>
local Library = {}
Library.DebugMode = false
local Elements = Table:Register("UI.Elements", {})
local DebugElements = Table:Register("UI.DebugElements", {})

-- << Element Object >>
local Element = {}
Element.__index = Element

function Element:Get()
	return Configuration.GetValue(self.Name)
end

function Element:Set(value)
	ui.setValue(self.TabRef, self.ContainerRef, self.Name, value)
	Configuration.SetValue(self.Name, value)
end

function Element:Visible(state)
	ui.setVisibility(self.TabRef, self.ContainerRef, self.Name, state)
end

function Element:OnChange(Callback)
	self._onChange = Callback
	return self
end

function Element:_Read()
	return ui.getValue(self.TabRef, self.ContainerRef, self.Name)
end

function Element:_Poll()
	local New = self:_Read()
	local Old = Configuration.GetValue(self.Name)

	if New == Old then
		return
	end

	Configuration.SetValue(self.Name, New)

	if self._onChange then
		self._onChange(New, Old)
	end
end

-- << Private >>
local function MakeElement(TabRef, ContainerRef, Name, Options)
	local Elem = setmetatable({
		TabRef = TabRef,
		ContainerRef = ContainerRef,
		Name = Name,
		Debug = Options and Options.Debug,
	}, Element)

	Configuration.Register(Name, Elem)
	Elements[Name] = Elem

	if Elem.Debug then
		Elem:Visible(false)
		DebugElements[#DebugElements + 1] = Elem
	end

	return Elem
end

-- << Container Object >>
local Container = {}
Container.__index = Container

function Container:Checkbox(Name, InLine, Options)
	ui.newCheckbox(self.TabRef, self.Ref, Name, InLine)
	return MakeElement(self.TabRef, self.Ref, Name, Options)
end

function Container:SliderInt(Name, Min, Max, Default, Options)
	ui.newSliderInt(self.TabRef, self.Ref, Name, Min, Max, Default)
	return MakeElement(self.TabRef, self.Ref, Name, Options)
end

function Container:SliderFloat(Name, Min, Max, Default, Options)
	ui.newSliderFloat(self.TabRef, self.Ref, Name, Min, Max, Default)
	return MakeElement(self.TabRef, self.Ref, Name, Options)
end

function Container:Dropdown(Name, Options, DefaultIndex, UIOptions)
	ui.newDropdown(self.TabRef, self.Ref, Name, Options, DefaultIndex)
	local Elem = MakeElement(self.TabRef, self.Ref, Name, UIOptions)
	Elem._Read = function(self)
		local Index = ui.getValue(self.TabRef, self.ContainerRef, Name)
		return Options[Index + 1]
	end
	return Elem
end

function Container:Multiselect(Name, Options, UIOptions)
	ui.newMultiselect(self.TabRef, self.Ref, Name, Options)
	local Elem = MakeElement(self.TabRef, self.Ref, Name, UIOptions)
	Elem._Read = function(self)
		local States = ui.getValue(self.TabRef, self.ContainerRef, Name)
		local Selected = {}
		for i, State in ipairs(States) do
			if State then
				Selected[Options[i] ] = true
			end
		end
		return Selected
	end

	Elem._Poll = function(self)
		local New = self:_Read()
		local Old = Configuration.GetValue(self.Name)
		local Changed = type(Old) ~= "table"

		if not Changed then
			for _, Option in ipairs(Options) do
				if New[Option] ~= Old[Option] then
					Changed = true
					break
				end
			end
		end

		if not Changed then
			return
		end

		Configuration.SetValue(self.Name, New)

		if self._onChange then
			self._onChange(New, Old)
		end
	end
	return Elem
end

function Container:Colorpicker(Name, DefaultColor, InLine, Options)
	ui.newColorpicker(self.TabRef, self.Ref, Name, DefaultColor, InLine)
	local Elem = MakeElement(self.TabRef, self.Ref, Name, Options)
	Elem._Read = function(self)
		return ui.getValue(self.TabRef, self.ContainerRef, Name)
	end
	Elem.Get = function(self, Type)
		local Color = Configuration.GetValue(self.Name)
		if not Color then
			return nil
		end
		Type = (tostring(Type) or "table"):lower()
		return Type == "rgb" and Color3.fromRGB(Color.r, Color.g, Color.b) or Color
	end

	Elem._Poll = function(self)
		local New = self:_Read()
		local Old = Configuration.GetValue(self.Name)
		if Old and New.r == Old.r and New.g == Old.g and New.b == Old.b and New.a == Old.a then
			return
		end
		Configuration.SetValue(self.Name, New)
		if self._onChange then
			self._onChange(New, Old)
		end
	end
	return Elem
end

function Container:InputText(Name, DefaultText, Options)
	ui.newInputText(self.TabRef, self.Ref, Name, DefaultText)
	return MakeElement(self.TabRef, self.Ref, Name, Options)
end

function Container:Button(Name, Callback, Options)
	ui.newButton(self.TabRef, self.Ref, Name, Callback)
	local Elem = MakeElement(self.TabRef, self.Ref, Name, Options)
	Elem.Get = nil
	Elem.Set = nil
	Elem._Poll = function() end
	return Elem
end

function Container:Listbox(Name, Options, Callback, UIOptions)
	ui.newListbox(self.TabRef, self.Ref, Name, Options, function()
		local Index = ui.getValue(self.TabRef, self.Ref, Name)
		local Selected = Options[Index + 1]
		Configuration.SetValue(Name, Selected)
		if Callback then
			Callback(Selected)
		end
	end)
	local Elem = MakeElement(self.TabRef, self.Ref, Name, UIOptions)
	Elem._Poll = function() end
	return Elem
end

function Container:KeyPicker(Name, InLine, Options)
	ui.newHotkey(self.TabRef, self.Ref, Name, InLine)
	local Elem = MakeElement(self.TabRef, self.Ref, Name, Options)
	Elem._Read = function(self)
		return ui.getValue(self.TabRef, self.ContainerRef, Name)
	end
	Elem.Get = function(self, ReturnType)
		if ReturnType == "Hotkey" then
			return ui.getHotkey(self.TabRef, self.ContainerRef, Name)
		end
		return Configuration.GetValue(self.Name)
	end
	return Elem
end

function Container:Page(Name, Pages)
	local Dropdown = self:Dropdown(Name, Pages, 1)

	local PageElements = {}
	for _, PageName in ipairs(Pages) do
		PageElements[PageName] = {}
	end

	local ActivePage = Pages[1]
	local RealContainer = self

	local function ApplyVisibility(PageName, State)
		local Elems = PageElements[PageName]
		if not Elems then
			return
		end
		for i = 1, #Elems do
			Elems[i]:Visible(State)
		end
	end

	for i, PageName in ipairs(Pages) do
		ApplyVisibility(PageName, i == 1)
	end

	Dropdown:OnChange(function(New)
		ApplyVisibility(ActivePage, false)
		ActivePage = New
		ApplyVisibility(ActivePage, true)
	end)

	local PageObject = {}

	function PageObject:For(PageName)
		assert(PageElements[PageName], "[UI.Page]: Unknown page '" .. tostring(PageName) .. "'")

		return setmetatable({}, {
			__index = function(_, Key)
				local Method = Container[Key]
				if type(Method) ~= "function" or Key == "Page" then
					return nil
				end

				return function(_, ...)
					local Elem = Method(RealContainer, ...)
					PageElements[PageName][#PageElements[PageName] + 1] = Elem
					if PageName ~= ActivePage then
						Elem:Visible(false)
					end
					return Elem
				end
			end,
		})
	end

	return PageObject
end

-- << Tab Object >>
local Tab = {}
Tab.__index = Tab

function Tab:Container(ContainerRef, DisplayName, Options)
	ui.newContainer(self.Ref, ContainerRef, DisplayName, Options or {})
	return setmetatable({
		TabRef = self.Ref,
		Ref = ContainerRef,
	}, Container)
end

-- << Root >>

function Library.NewTab(TabRef, DisplayName)
	ui.newTab(TabRef, DisplayName)
	return setmetatable({ Ref = TabRef }, Tab)
end

function Library:SetDebugMode(State)
	self.DebugMode = State
	for i = 1, #DebugElements do
		DebugElements[i]:Visible(State)
	end
end

function Library:Initialise()
	Callbacks.Add("onUpdate", function()
		for _, Elem in next, Elements do
			Elem:_Poll()
		end
	end)
end

return Library
end function __DIST.x()
local Minigames = {
	GameUI = nil,
	GameType = nil,
}

local Environment = __DIST.load('h')
local Callbacks = __DIST.load('c')
local Configuration = __DIST.load('b')
local DebugMode = __DIST.load('f')

local GameModules = {
	["Flight Game"] = __DIST.load('u'),
	["Catch Game"] = __DIST.load('v'),
}

local function DebugPrint(Message)
	if not Configuration.GetValue("Debug Mode") then
		return
	end

	DebugMode.AddDebugMessage(Message, "info", 1200)
end

local function MinigamePlayer(Interface)
	local Function = GameModules[Minigames.GameType]

	if not Function then
		DebugPrint("No module found for game type: " .. tostring(Minigames.GameType))
		return nil
	end

	return Function(Interface)
end

function Minigames.Initialise(
	Container: typeof(__DIST.load('w').NewTab(nil, nil):Container(nil, nil, nil))
)
	Callbacks.Add("onUpdate", function()
		if utility.GetMenuState() then
			return
		end

		if not Configuration.GetValue("Minigames Enabled") then
			return
		end

		if not Minigames.GameUI then
			return
		end

		if not Minigames.GameType then
			return
		end

		if Configuration.GetValue(Minigames.GameType) ~= true then
			return
		end

		MinigamePlayer(Minigames.GameUI)
	end)

	Callbacks.Add("onSlowUpdate", function()
		if not Configuration.GetValue("Minigames Enabled") then
			return
		end

		local PlayerGui = Environment.LocalPlayer.PlayerGui
		if not PlayerGui then
			return
		end

		local DeviceUI = PlayerGui:FindFirstChild("DeviceUI")
		Minigames.GameUI = DeviceUI

		if DeviceUI then
			local System = DeviceUI:FindFirstChild("DeviceSystem")
			if not System then
				Minigames.GameType = nil
				return
			end

			local GameType = System:FindFirstChild("Wall") and "Flight Game"
				or System:FindFirstChild("Food") and "Catch Game"
				or nil

			Minigames.GameType = GameType
		else
			Minigames.GameType = nil
		end
	end)
end

return Minigames
end function __DIST.y()
local Features = {}

local AutoBlackFlash = __DIST.load('l')
local AutoLawyerQTE = __DIST.load('m')
local AutoMahoragaEarthquake = __DIST.load('n')
local AutoNanamiQTE = __DIST.load('o')
local AutoTodoBlackFlash = __DIST.load('p')
local AutoTodoPerfectSwap = __DIST.load('q')
local AutoReturnM1 = __DIST.load('r')
local PlayerVisuals = __DIST.load('s')
local WorldVisuals = __DIST.load('t')
local MinigameModule = __DIST.load('x')

function Features:Initialise()
	AutoBlackFlash:Initialise()
	AutoLawyerQTE:Initialise()
	AutoMahoragaEarthquake:Initialise()
	AutoNanamiQTE:Initialise()
	AutoTodoBlackFlash:Initialise()
	AutoTodoPerfectSwap:Initialise()
	AutoReturnM1:Initialise()
	PlayerVisuals:Initialise()
	WorldVisuals:Initialise()
	MinigameModule:Initialise()
end

return Features
end function __DIST.z()
local Container = {}

local ContainerReference = "Combat_DiddyWare"
local ContainerName = "Combat"

function Container:Initialise(Tab: typeof(__DIST.load('w').NewTab(nil, nil)))
	local Container = Tab:Container(ContainerReference, ContainerName, { autosize = true, next = true })
	Container:Checkbox("Auto Blackflash")
	Container:KeyPicker("Auto Blackflash Hotkey", true)
	Container:SliderFloat("Auto Blackflash Timing", 0, 1, 0.285, { Debug = true })
	Container:SliderFloat("Auto Todo Blackflash Time Position", 0, 5, 2.8, { Debug = true })

	Container:Checkbox("Auto Todo Perfect Swap")
	Container:KeyPicker("Auto Todo Perfect Swap Hotkey", true)
	Container:SliderFloat("Auto Todo Perfect Swap Time Position", 0, 1, 0.55, { Debug = true })

	Container:Checkbox("Auto Mahoraga Earthquake")
	Container:SliderFloat("Auto Mahoraga Earthquake Time Position", 0, 1, 0.8, { Debug = true })

	Container:Checkbox("Auto Nanami Ratio")
	Container:SliderFloat("Auto Nanami Ratio GUI Scale", 0, 1, 0.3, { Debug = true })

	Container:Checkbox("Auto Lawyer QTE")
	Container:SliderInt("Auto Lawyer QTE Delay (ms)", 1, 200, 75)

	Container:Checkbox("Auto Return M1")
end

return Container
end function __DIST.A()
local Container = {}

local ContainerReference = "VisualsTab_DiddyWare"
local ContainerName = "Visuals"

function Container:Initialise(Tab: typeof(__DIST.load('w').NewTab(nil, nil)))
	local Container = Tab:Container(ContainerReference, ContainerName, { autosize = true })
	Container:Checkbox("Visuals Enabled")
	local MainPage = Container:Page("Visual Types", { "Player", "World" })
	local PlayerPage = MainPage:For("Player")
	local WorldPage = MainPage:For("World")
	PlayerPage:Checkbox("Draw Cooldowns")
	PlayerPage:Colorpicker("Cooldown Fill Color", { r = 255, g = 0, b = 0, a = 180 }, true)
	PlayerPage:Colorpicker("Cooldown Background Color", { r = 0, g = 0, b = 0, a = 200 }, true)
	PlayerPage:Checkbox("Draw Evasive Bar")
	PlayerPage:Colorpicker("Evasive Fill Color", { r = 121, g = 74, b = 148, a = 255 }, true)
	PlayerPage:Checkbox("Draw Animation Desync Guides", false)
	PlayerPage:Colorpicker("Animation Desync Flagged Outline", { r = 0, g = 0, b = 0, a = 180 }, true)
	PlayerPage:Colorpicker("Animation Desync Flagged Fill", { r = 255, g = 0, b = 0, a = 100 }, true)

	WorldPage:Checkbox("Item ESP", false)
	WorldPage:Colorpicker("Item ESP Color", { r = 255, g = 255, b = 255, a = 255 }, true)

	WorldPage:Checkbox("Domain Health ESP", false)
	WorldPage:Colorpicker("Domain Health ESP Color", { r = 255, g = 255, b = 255, a = 255 }, true)
end

return Container
end function __DIST.B()
local Container = {}

local ContainerReference = "Minigame_DiddyWare"
local ContainerName = "Minigames"

function Container:Initialise(Tab: typeof(__DIST.load('w').NewTab(nil, nil)))
	local Container = Tab:Container(ContainerReference, ContainerName, { autosize = true, next = true })
	Container:Checkbox("Minigames Enabled")
	Container:Checkbox("Flight Game")
	Container:Checkbox("Catch Game")
end

return Container
end function __DIST.C()
local Container = {}

local UIWrapper = __DIST.load('w')

local ContainerReference = "Settings_DiddyWare"
local ContainerName = "Settings"

function Container:Initialise(Tab: typeof(__DIST.load('w').NewTab(nil, nil)))
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
end function __DIST.D()
local Menu = {}

local UIWrapper = __DIST.load('w')

local CombatTab = __DIST.load('z')
local VisualsTab = __DIST.load('A')
local MinigamesTab = __DIST.load('B')
local SettingsTab = __DIST.load('C')

function Menu:Initialise()
	local Tab = UIWrapper.NewTab("DiddyWare_JJS", "DiddyWare")
	CombatTab:Initialise(Tab)
	VisualsTab:Initialise(Tab)
	MinigamesTab:Initialise(Tab)
	SettingsTab:Initialise(Tab)
end

return Menu
end function __DIST.E()
return function()
	function math.floor(x)
		return x - (x % 1)
	end

	function math.clamp(n, min, max)
		return math.max(min, math.min(max, n))
	end
end
end end-- Game Modules

local PlayerScanning = __DIST.load('i')
local WorldScanning = __DIST.load('k')
local AnimationManager = __DIST.load('g')

-- Core Modules
local DebugMode = __DIST.load('f')
local Features = __DIST.load('y')
local Menu = __DIST.load('D')

-- Utility Modules
local Callbacks = __DIST.load('c')
local Table = __DIST.load('a')
local Math = __DIST.load('E')
local Library = __DIST.load('w')

local function Initialise()
	Math()
	Callbacks:Initialise()
	Library:Initialise()
	PlayerScanning:Initialise()
	WorldScanning:Initialise()
	AnimationManager:Initialise()
	DebugMode:Initialise()
	Menu:Initialise()
	Features:Initialise()

	Callbacks.Add("shutdown", function()
		Callbacks.ClearAll()
		Table:UnloadAll()
	end)
end

Initialise()
