local __DIST __DIST={cache={}, load=function(m)if not __DIST.cache[m]then __DIST.cache[m]={c=__DIST[m]()}end return __DIST.cache[m].c end}do function __DIST.a()local Library = {}

-- ============= Element Object =============
local Element = {}
Element.__index = Element

function Element:Get()
	return ui.getValue(self.TabRef, self.ContainerRef, self.Name)
end

function Element:Set(value)
	ui.setValue(self.TabRef, self.ContainerRef, self.Name, value)
end

function Element:Visible(state)
	ui.setVisibility(self.TabRef, self.ContainerRef, self.Name, state)
end

-- ============= Container Object =============
local Container = {}
Container.__index = Container

local function MakeElement(tabRef, containerRef, name)
	return setmetatable({
		TabRef = tabRef,
		ContainerRef = containerRef,
		Name = name,
	}, Element)
end

function Container:Checkbox(name, inLine)
	ui.newCheckbox(self.TabRef, self.Ref, name, inLine)
	return MakeElement(self.TabRef, self.Ref, name)
end

function Container:SliderInt(name, min, max, default)
	ui.newSliderInt(self.TabRef, self.Ref, name, min, max, default)
	return MakeElement(self.TabRef, self.Ref, name)
end

function Container:SliderFloat(name, min, max, default)
	ui.newSliderFloat(self.TabRef, self.Ref, name, min, max, default)
	return MakeElement(self.TabRef, self.Ref, name)
end

function Container:Dropdown(name, options, defaultIndex)
	ui.newDropdown(self.TabRef, self.Ref, name, options, defaultIndex)
	local element = MakeElement(self.TabRef, self.Ref, name)
	element.Get = function()
		local index = ui.getValue(self.TabRef, self.Ref, name)
		return options[index + 1]
	end
	return element
end

function Container:Multiselect(name, options)
	ui.newMultiselect(self.TabRef, self.Ref, name, options)
	local element = MakeElement(self.TabRef, self.Ref, name)

	element.Get = function()
		local states = ui.getValue(self.TabRef, self.Ref, name)
		local selected = {}
		for i, state in ipairs(states) do
			if state then
				selected[options[i] ] = true
			end
		end
		return selected
	end

	return element
end

function Container:Colorpicker(name, defaultColor, inLine)
	ui.newColorpicker(self.TabRef, self.Ref, name, defaultColor, inLine)
	local Element = MakeElement(self.TabRef, self.Ref, name)
	Element.Get = function(_, Type)
		Type = (tostring(Type) or "table"):lower()
		if Type == "rgb" then
			local color = ui.getValue(self.TabRef, self.Ref, name)
			return Color3.fromRGB(color.r, color.g, color.b)
		end

		return ui.getValue(self.TabRef, self.Ref, name)
	end
	return Element
end

function Container:InputText(name, defaultText)
	ui.newInputText(self.TabRef, self.Ref, name, defaultText)
	return MakeElement(self.TabRef, self.Ref, name)
end

function Container:Button(name, callback)
	ui.newButton(self.TabRef, self.Ref, name, callback)
	local element = MakeElement(self.TabRef, self.Ref, name)
	element.Get = nil
	element.Set = nil
	return element
end

function Container:Listbox(name, options, callback)
	ui.newListbox(self.TabRef, self.Ref, name, options, function()
		if callback then
			local index = ui.getValue(self.TabRef, self.Ref, name)
			local selected = options[index + 1]
			callback(selected)
		end
	end)
	return MakeElement(self.TabRef, self.Ref, name)
end

function Container:KeyPicker(name, inLine, ...)
	ui.newHotkey(self.TabRef, self.Ref, name, inLine)
	local Element = MakeElement(self.TabRef, self.Ref, name)
	Element.Get = function(_, ReturnType)
		if not ReturnType then
			ReturnType = "Value"
		end

		local Args = { self.TabRef, self.Ref, name }
		return ReturnType == "Value" and ui.getValue(unpack(Args)) or ui.getHotkey(unpack(Args))
	end

	return Element
end

-- ============= Tab Object =============
local Tab = {}
Tab.__index = Tab

function Tab:Container(containerRef, displayName, options)
	ui.newContainer(self.Ref, containerRef, displayName, options or {})
	return setmetatable({
		TabRef = self.Ref,
		Ref = containerRef,
	}, Container)
end

-- ============= Root =============
function Library.NewTab(tabRef, displayName)
	ui.newTab(tabRef, displayName)
	return setmetatable({ Ref = tabRef }, Tab)
end

function Library.NewReference(tabRef, containerRef, name)
	return MakeElement(tabRef, containerRef, name)
end

return Library
end function __DIST.b()
return {
	Font = "ConsolasBold",

	CachedMap = nil,
	CachedCoinContainer = nil,
	CachedGunDrop = nil,

	ActiveCoins = {},
	TrackedPlayers = {},
	CurrentMurderer = nil,
	CurrentSheriff = nil,
}
end function __DIST.c()
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
}end function __DIST.d()
local Offsets = __DIST.load('c')

local MemoryFunctions = {}

function MemoryFunctions.GetFramePosition(Frame)
	local Address = Frame.Address
	return Vector3.new(
		memory.read("float", Address + Offsets.GuiObject.Position.X),
		memory.read("float", Address + Offsets.GuiObject.Position.Y),
		0
	)
end

function MemoryFunctions.GetFrameSize(Frame)
	local Address = Frame.Address
	return Vector3.new(
		memory.read("float", Address + Offsets.GuiObject.Size.X),
		memory.read("float", Address + Offsets.GuiObject.Size.Y),
		0
	)
end

function MemoryFunctions.GetFrameCenter(Frame)
	local Position = MemoryFunctions.GetFramePosition(Frame)
	local Size = MemoryFunctions.GetFrameSize(Frame)
	return Position + (Size / 2)
end

function MemoryFunctions.GetFrameRotation(Frame)
	return memory.read("float", Frame.Address + Offsets.GuiObject.Rotation.Offset)
end

function MemoryFunctions.IsFrameVisible(Frame)
	return memory.read("bool", Frame.Address + Offsets.GuiObject.Visible.Offset)
end

return MemoryFunctions
end function __DIST.e()
local PlayerTracker = {
	LastUpdate = 0,
	UpdateInterval = 50,
}

local Players = game.GetService("Players")
local EntityLocalPlayer = entity.GetLocalPlayer()

local LocalPlayer = game.LocalPlayer
local PlayerGui = LocalPlayer.PlayerGui

local Environment = __DIST.load('b')
local MemoryFunctions = __DIST.load('d')

-- Priv Funcs
local function GetAttribute(Instance, AttributeName, DefaultValue)
	local Attribute = Instance:GetAttribute(AttributeName)
	return Attribute and Attribute.Value or DefaultValue
end

local function UpdatePlayer(EntityPlayer)
	if not EntityPlayer then
		return
	end

	if not Environment.TrackedPlayers[EntityPlayer.Name] then
		local Player = Players:FindFirstChild(EntityPlayer.Name)
		if not Player then
			return
		end

		Environment.TrackedPlayers[EntityPlayer.Name] = {
			EntityInstance = EntityPlayer,
			PlayerInstance = Player,
			IsAlive = nil,
		}
	end

	local Data = Environment.TrackedPlayers[EntityPlayer.Name]
	if not Data then
		return
	end

	local HumanoidRootPart = EntityPlayer:GetBoneInstance("HumanoidRootPart")
	local Character = HumanoidRootPart and HumanoidRootPart.Parent or nil
	local Backpack = Data.PlayerInstance.Backpack

	Data.IsAlive = GetAttribute(Data.PlayerInstance, "Alive", false)
	Data.IsMurderer = (Backpack and Backpack:FindFirstChild("Knife"))
		or (Character and Character:FindFirstChild("Knife")) and true
		or false

	Data.IsSheriff = (Backpack and Backpack:FindFirstChild("Gun"))
		or (Character and Character:FindFirstChild("Gun")) and true
		or false

	Data.IsInnocent = not Data.IsMurderer and not Data.IsSheriff

	if Data.IsSheriff then
		Environment.CurrentSheriff = EntityPlayer
	end

	if Data.IsMurderer then
		Environment.CurrentMurderer = EntityPlayer
	end

	if EntityPlayer.Name == EntityLocalPlayer.Name then
		local MainUI = PlayerGui:FindFirstChild("MainGUI")
		if not MainUI then
			Data.IsFullCoins = false
			return
		end

		local CoinBagContainer = MainUI.Game.CoinBags.Container
		local BagFull = false
		for _, Container in pairs(CoinBagContainer:GetChildren()) do
			if Container:IsA("Frame") then
				local IsBagFull = MemoryFunctions.IsFrameVisible(Container.Full)
				if IsBagFull then
					BagFull = IsBagFull
					break
				end
			end
		end

		Data.IsFullCoins = BagFull
	end
end

--- return @boolean - is the player alive?
function PlayerTracker:IsPlayerAlive(Entity)
	Entity = Entity ~= nil and Entity or EntityLocalPlayer
	local Data = Environment.TrackedPlayers[Entity.Name]
	if not Data then
		return false
	end

	return Data.IsAlive
end

--- return @string - whats the player's role?
function PlayerTracker:GetPlayerRole(Entity)
	Entity = Entity or EntityLocalPlayer

	local Data = Environment.TrackedPlayers[Entity.Name]
	if not Data then
		return nil
	end

	if Data.IsMurderer and Data.IsAlive then
		return "Murderer"
	elseif Data.IsSheriff and Data.IsAlive then
		return "Sheriff"
	elseif Data.IsInnocent and Data.IsAlive then
		return "Innocent"
	else
		return "Spectator"
	end
end

function PlayerTracker:GetPlayerStored(Entity)
	Entity = Entity or EntityLocalPlayer

	local Data = Environment.TrackedPlayers[Entity.Name]
	if not Data then
		return nil
	end

	return Data
end

function PlayerTracker:GetAlivePlayers(OnlyEnemies)
	local Alive = {}
	local LocalRole = self:GetPlayerRole()

	for EntityName, Player in pairs(Environment.TrackedPlayers) do
		if EntityName ~= EntityLocalPlayer.Name and Player.IsAlive then
			if not OnlyEnemies then
				table.insert(Alive, Player)
			else
				if LocalRole == "Murderer" then
					table.insert(Alive, Player)
				elseif LocalRole == "Sheriff" then
					if self:GetPlayerRole(Player) == "Murderer" then
						table.insert(Alive, Player)
					end
				end
			end
		end
	end

	return Alive
end

function PlayerTracker.Initialise(
	Container: typeof(__DIST.load('a')
.NewTab(nil, nil):Container(nil, nil, nil))
)
	local IntervalSlider = Container:SliderInt("Player Tracker Update Interval", 1, 100, 50)

	cheat.Register("onUpdate", function()
		PlayerTracker.UpdateInterval = IntervalSlider:Get()

		local Now = utility.GetTickCount()
		if Now - PlayerTracker.LastUpdate >= PlayerTracker.UpdateInterval then
			UpdatePlayer(EntityLocalPlayer)
			for _, Entity in pairs(entity.GetPlayers(false)) do
				UpdatePlayer(Entity)
			end
		end
	end)

	cheat.Register("onSlowUpdate", function()
		local EntityNames = {}

		EntityNames[EntityLocalPlayer.Name] = true
		for _, PlayerEntity in pairs(entity.GetPlayers(false)) do
			EntityNames[PlayerEntity.Name] = true
		end

		for EntityName, _ in pairs(Environment.TrackedPlayers) do
			if not EntityNames[EntityName] then
				Environment.TrackedPlayers[EntityName] = nil
			end
		end
	end)
end

return PlayerTracker
end function __DIST.f()return function(Instance, NewPosition)
	for i = 1, 1000 do
		Instance.Position = NewPosition
	end
end
end function __DIST.g()
local Tween = {}
Tween.__index = Tween

local SetPosition = __DIST.load('f')

Tween.Easing = {
	Linear = function(t)
		return t
	end,
}

local function Apply(Target, Property, Value)
	if Property == "Position" then
		SetPosition(Target, Value)
	else
		Target[Property] = Value
	end
end

function Tween.new(Target, Property, Goal, Duration, Easing)
	return setmetatable({
		Target = Target,
		Property = Property,

		Start = Target[Property],
		Goal = Goal,

		Duration = Duration * 1000,
		StartTime = utility.GetTickCount(),

		Easing = Easing or Tween.Easing.Linear,
		Finished = false,
	}, Tween)
end

function Tween:Step()
	if self.Finished then
		return true
	end

	local now = utility.GetTickCount()
	local elapsed = now - self.StartTime

	local Alpha = elapsed / self.Duration
	if Alpha >= 1 then
		Apply(self.Target, self.Property, self.Goal)
		self.Finished = true
		return true
	end

	Alpha = self.Easing(Alpha)

	local Start = self.Start
	local Goal = self.Goal

	local Value
	if type(Start) == "number" then
		Value = Start + (Goal - Start) * Alpha
	else
		Value = Start:Lerp(Goal, Alpha)
	end

	Apply(self.Target, self.Property, Value)
	return false
end

function Tween:Cancel()
	self.Finished = true
end

return Tween
end function __DIST.h()
local CoinFarm = {
	SAFE_POSITION = nil,

	Flags = {
		Enabled = false,
		SafetyOnFullBag = false,
		MurdererSafezone = 35,
		DelayPerCoin = 0.75,
		TweenSpeed = 35,
	},

	State = {
		GoingToCoin = false,
		CoinTween = nil,

		LastCoinGrab = 0,
		LastPositionBeforeTeleport = nil,
		LastTeleport = 0,

		Target = nil,
	},
}

local Workspace = game.GetService("Workspace")

local EntityLocalPlayer = entity.GetLocalPlayer()

local UIWrapper = __DIST.load('a')
local Environment = __DIST.load('b')
local PlayerTracker = __DIST.load('e')
local Tween = __DIST.load('g')

local function GetClosestCoin(LocalRole)
	local ClosestCoin, ClosestDistance = nil, math.huge

	local IsNotMurderer = LocalRole ~= "Murderer"
	local Murderer = Environment.CurrentMurderer
	local MurdererPosition = nil

	if IsNotMurderer and Murderer then
		MurdererPosition = Murderer.Position
	end

	for Address, CoinPosition in pairs(Environment.ActiveCoins) do
		local Distance = (EntityLocalPlayer.Position - CoinPosition).Magnitude
		local MurdererDistance = nil

		if MurdererPosition then
			MurdererDistance = (MurdererPosition - CoinPosition).Magnitude
		end

		local SafeToGrab = true
		if MurdererDistance then
			SafeToGrab = MurdererDistance > CoinFarm.Flags.MurdererSafezone
		end

		if SafeToGrab and Distance < ClosestDistance then
			ClosestCoin = { Address = Address, Position = CoinPosition }
			ClosestDistance = Distance
		end
	end

	return ClosestCoin, ClosestDistance
end

local function ValidateCoin(Coin)
	return Environment.ActiveCoins[Coin]
end

function CoinFarm.Runtime()
	if not CoinFarm.Flags.Enabled then
		return
	end

	if not PlayerTracker:IsPlayerAlive() then
		return
	end

	local RootPart = EntityLocalPlayer:GetBoneInstance("HumanoidRootPart")
	if not RootPart then
		return
	end

	local Now = utility.GetTickCount()

	local CoinTween = CoinFarm.State.CoinTween
	if CoinTween then
		local Finished = CoinTween:Step()

		if Finished then
			CoinFarm.State.CoinTween = nil
			CoinFarm.State.GoingToCoin = false
			CoinFarm.State.LastCoinGrab = Now
		end

		return
	end

	local PlayerData = PlayerTracker:GetPlayerStored()
	local PlayerRole = PlayerTracker:GetPlayerRole()

	local SafetyOnFullBag = CoinFarm.Flags.SafetyOnFullBag

	local GoingForCoin = CoinFarm.State.GoingToCoin
	local LastCoinGrab = CoinFarm.State.LastCoinGrab

	local WantsSafety = SafetyOnFullBag and PlayerData.IsFullCoins

	if WantsSafety then
		RootPart.Position = CoinFarm.SAFE_POSITION
		return
	end

	if
		not GoingForCoin
		and not PlayerData.IsFullCoins
		and (Now - LastCoinGrab) >= CoinFarm.Flags.DelayPerCoin * 1000
	then
		local CoinData, Distance = GetClosestCoin(PlayerRole)
		if not CoinData or not ValidateCoin(CoinData.Address) then
			return
		end

		local Duration = Distance / CoinFarm.Flags.TweenSpeed
		CoinFarm.State.GoingToCoin = true
		CoinFarm.State.CoinTween = Tween.new(RootPart, "Position", CoinData.Position, Duration, Tween.Easing.Linear)
		return
	end
end

function CoinFarm.Initialise(
	Container: typeof(__DIST.load('a')
.NewTab(nil, nil):Container(nil, nil, nil))
)
	local Enabled = Container:Checkbox("Coin Farm", false)
	local ReturnToSafetyOnBagFull = Container:Checkbox("Return to Safety when Bag is Full", false)
	local MurdererSafezone = Container:SliderInt("Murderer Safezne", 1, 100, 20)
	local DelayPerCoin = Container:SliderFloat("Delay Per Coin (s)", 0, 3, 0.55)
	local TweenSpeed = Container:SliderInt("Tween Speed", 1, 100, 25)
	local SlowFall = UIWrapper.NewReference("Exploits", "Misc", "Slow Fall")
	local SlowFallSpeed = UIWrapper.NewReference("Exploits", "Misc", "Fall Speed")

	local function UpdateFlags()
		local Settings = CoinFarm.Flags
		Settings.Enabled = Enabled:Get()
		Settings.SafetyOnFullBag = ReturnToSafetyOnBagFull:Get()
		Settings.MurdererSafezone = MurdererSafezone:Get()
		Settings.DelayPerCoin = DelayPerCoin:Get()
		Settings.TweenSpeed = TweenSpeed:Get()

		ReturnToSafetyOnBagFull:Visible(Settings.Enabled)
		MurdererSafezone:Visible(Settings.Enabled)
		DelayPerCoin:Visible(Settings.Enabled)
		TweenSpeed:Visible(Settings.Enabled)
		SlowFall:Set(Settings.Enabled)
		SlowFallSpeed:Set(1)
	end

	CoinFarm.SAFE_POSITION = Workspace.Lobby.Spawns.SpawnLocation.Position

	cheat.Register("onUpdate", function()
		CoinFarm.Runtime()
		UpdateFlags()
	end)
end

return CoinFarm
end function __DIST.i()local GetGunDrop = {
	Flags = {
		Enabled = false,
	},
}

local Environment = __DIST.load('b')
local PlayerTracker = __DIST.load('e')
local SetPosition = __DIST.load('f')

local EntityLocalPlayer = entity.GetLocalPlayer()

local function GrabGun()
	local HumanoidRootPart = EntityLocalPlayer:GetBoneInstance("HumanoidRootPart")
	if not HumanoidRootPart then
		return
	end

	local GunDrop = Environment.CachedGunDrop
	if not GunDrop then
		return
	end

	local OriginalPosition = HumanoidRootPart.Position
	SetPosition(HumanoidRootPart, GunDrop.Position)
	SetPosition(HumanoidRootPart, OriginalPosition)
end

function GetGunDrop.Runtime()
	if not GetGunDrop.Flags.Enabled then
		return
	end

	if not PlayerTracker:IsPlayerAlive() then
		return
	end

	if PlayerTracker:GetPlayerRole() == "Murderer" then
		return
	end

	GrabGun()
end

function GetGunDrop.Initialise(
	Container: typeof(__DIST.load('a')
.NewTab(nil, nil):Container(nil, nil, nil))
)
	local Enabled = Container:Checkbox("Auto Teleport To Gun", false)
	Container:Button("Grab Gun", GrabGun)

	cheat.Register("onUpdate", function()
		GetGunDrop.Flags.Enabled = Enabled:Get()
		GetGunDrop.Runtime()
	end)
end

return GetGunDrop
end function __DIST.j()return function(VectorA, VectorB)
	local dx, dy, dz
	dx = VectorA.X - VectorB.X
	dy = VectorA.Y - VectorB.Y
	dz = VectorA.Z - VectorB.Z

	return math.floor(math.sqrt(dx * dx + dy * dy + dz * dz))
end
end function __DIST.k()
local CoinESP = {
	Flags = {
		Enabled = false,
		ShowDistance = false,
		Color = Color3.fromRGB(255, 255, 255),
		Alpha = 255,
	},

	CachedTextSizes = {},
	LastFont = nil,
}

local ESP_TEXT = "Coin"
local TEXT_WIDTH, TEXT_HEIGHT = nil
local COLOUR_WHITE = Color3.fromRGB(255, 255, 255)

local Environment = __DIST.load('b')
local PlayerTracker = __DIST.load('e')
local GetDistanceSqrt = __DIST.load('j')
local EntityLocalPlayer = entity.GetLocalPlayer()

local function GetTextSize(Text)
	local TextSize = CoinESP.CachedTextSizes[Text .. Environment.Font]
	if TextSize then
		return TextSize.W, TextSize.H
	end

	local TextWidth, TextHeight = draw.GetTextSize(Text, Environment.Font)
	CoinESP.CachedTextSizes[Text .. Environment.Font] = {
		W = TextWidth,
		H = TextHeight,
	}

	return TextWidth, TextHeight
end

local function TableToRGB(Table)
	if type(Table) ~= "table" then
		return Color3.fromRGB(255, 255, 255)
	end

	local R = Table.R or Table.r or 255
	local G = Table.G or Table.g or 255
	local B = Table.B or Table.b or 255
	return Color3.fromRGB(R, G, B)
end

function CoinESP.Runtime()
	if not CoinESP.Flags.Enabled then
		return
	end

	if not PlayerTracker:IsPlayerAlive() then
		return
	end

	local ShowDistance = CoinESP.Flags.ShowDistance
	local Color = CoinESP.Flags.Color
	local Alpha = CoinESP.Flags.Alpha

	for _, CoinPosition in pairs(Environment.ActiveCoins) do
		local ScreenX, ScreenY, OnScreen = utility.WorldToScreen(CoinPosition)
		if OnScreen then
			local DistanceText = ""

			if ShowDistance then
				local Distance = GetDistanceSqrt(EntityLocalPlayer.Position, CoinPosition)
				DistanceText = " [" .. tostring(Distance) .. "]"
			end

			local TotalWidth = TEXT_WIDTH
			if ShowDistance and DistanceText ~= "" then
				TotalWidth = TotalWidth + GetTextSize(DistanceText)
			end

			local StartX = ScreenX - (TotalWidth / 2)
			local StartY = ScreenY - (TEXT_HEIGHT / 2)

			draw.TextOutlined(ESP_TEXT, StartX, StartY, Color, Environment.Font, Alpha)

			if ShowDistance and DistanceText ~= "" then
				draw.TextOutlined(DistanceText, StartX + TEXT_WIDTH, StartY, COLOUR_WHITE, Environment.Font, Alpha)
			end
		end
	end
end

function CoinESP.Initialise(
	Container: typeof(__DIST.load('a')
.NewTab(nil, nil):Container(nil, nil, nil))
)
	local Enabled = Container:Checkbox("Coin ESP", false)
	local ColorPicker = Container:Colorpicker("Coin ESP Color", { r = 255, g = 255, b = 255, a = 255 }, true)
	local ShowDistance = Container:Checkbox("Show Coin Distance", false)

	cheat.Register("onPaint", CoinESP.Runtime)
	cheat.Register("onUpdate", function()
		local ColorRGBA = ColorPicker:Get()

		CoinESP.Flags.Enabled = Enabled:Get()
		CoinESP.Flags.ShowDistance = ShowDistance:Get()
		CoinESP.Flags.Color = TableToRGB(ColorRGBA)
		CoinESP.Flags.Alpha = ColorRGBA.a
		ShowDistance:Visible(CoinESP.Flags.Enabled)

		local SelectedFont = Environment.Font
		if CoinESP.LastFont ~= SelectedFont then
			CoinESP.LastFont = SelectedFont
			TEXT_WIDTH, TEXT_HEIGHT = GetTextSize(ESP_TEXT)
		end
	end)
end

return CoinESP
end function __DIST.l()local GunDrop = {
	Flags = {
		Enabled = false,
		ShowDistance = false,
		Color = Color3.fromRGB(255, 255, 255),
		Alpha = 255,
	},

	CachedTextSizes = {},
}

local ESP_TEXT = "Gun"
local COLOUR_WHITE = Color3.fromRGB(255, 255, 255)
local GetDistanceSqrt = __DIST.load('j')

local Environment = __DIST.load('b')
local PlayerTracker = __DIST.load('e')
local EntityLocalPlayer = entity.GetLocalPlayer()

local function GetTextSize(Text)
	local TextSize = GunDrop.CachedTextSizes[Text .. Environment.Font]
	if TextSize then
		return TextSize.W, TextSize.H
	end

	local TextWidth, TextHeight = draw.GetTextSize(Text, Environment.Font)
	GunDrop.CachedTextSizes[Text .. Environment.Font] = {
		W = TextWidth,
		H = TextHeight,
	}

	return TextWidth, TextHeight
end

local function TableToRGB(Table)
	if type(Table) ~= "table" then
		return COLOUR_WHITE
	end

	local R = Table.R or Table.r or 255
	local G = Table.G or Table.g or 255
	local B = Table.B or Table.b or 255
	return Color3.fromRGB(R, G, B)
end

function GunDrop.Runtime()
	if not GunDrop.Flags.Enabled then
		return
	end

	if not PlayerTracker:IsPlayerAlive() then
		return
	end

	local ShowDistance = GunDrop.Flags.ShowDistance
	local Color = GunDrop.Flags.Color
	local Alpha = GunDrop.Flags.Alpha

	local GunDrop = Environment.CachedGunDrop
	if not GunDrop then
		return
	end

	local GunDropPosition = GunDrop.Position
	local ScreenX, ScreenY, OnScreen = utility.WorldToScreen(GunDropPosition)
	if OnScreen then
		local TextWidth, TextHeight = GetTextSize(ESP_TEXT)

		local DistanceText = ""
		if ShowDistance then
			local Distance = GetDistanceSqrt(EntityLocalPlayer.Position, GunDropPosition)
			DistanceText = " [" .. tostring(Distance) .. "]"
		end

		local TotalWidth = TextWidth
		if ShowDistance and DistanceText ~= "" then
			TotalWidth = TotalWidth + GetTextSize(DistanceText)
		end

		local StartX = ScreenX - (TotalWidth / 2)
		local StartY = ScreenY - (TextHeight / 2)

		draw.TextOutlined(ESP_TEXT, StartX, StartY, Color, Environment.Font, Alpha)

		if ShowDistance and DistanceText ~= "" then
			draw.TextOutlined(DistanceText, StartX + TextWidth, StartY, COLOUR_WHITE, Environment.Font, Alpha)
		end
	end
end

function GunDrop.Initialise(
	Container: typeof(__DIST.load('a')
.NewTab(nil, nil):Container(nil, nil, nil))
)
	local Enabled = Container:Checkbox("Gun Drop ESP", false)
	local ColorPicker = Container:Colorpicker("Gun Drop ESP Color", { r = 255, g = 255, b = 255, a = 255 }, true)
	local ShowDistance = Container:Checkbox("Show Gun Distance", false)

	cheat.Register("onPaint", GunDrop.Runtime)
	cheat.Register("onUpdate", function()
		local ColorRGBA = ColorPicker:Get()

		GunDrop.Flags.Enabled = Enabled:Get()
		GunDrop.Flags.Color = TableToRGB(ColorRGBA)
		GunDrop.Flags.Alpha = ColorRGBA.a
		GunDrop.Flags.ShowDistance = ShowDistance:Get()
		ShowDistance:Visible(GunDrop.Flags.Enabled)
	end)
end

return GunDrop
end function __DIST.m()local RoleESP = {
	Flags = {
		Enabled = false,
		UseRoleColor = false,
		Color = Color3.new(255, 255, 255),
		Alpha = 255,
		SelectedRoleTypes = {
			Innocent = false,
			Sheriff = false,
			Murderer = false,
		},
	},
	CachedTextSizes = {},
}

local COLOUR_WHITE = Color3.fromRGB(255, 255, 255)

local RoleColors = {
	Innocent = Color3.new(0.117647, 0.858824, 0.117647),
	Murderer = Color3.new(0.72549, 0.101961, 0.101961),
	Sheriff = Color3.new(0.070588, 0.517647, 0.811765),
}

local Environment = __DIST.load('b')
local PlayerTracker = __DIST.load('e')

local function GetTextSize(Text)
	local TextSize = RoleESP.CachedTextSizes[Text .. Environment.Font]
	if TextSize then
		return TextSize.W, TextSize.H
	end

	local TextWidth, TextHeight = draw.GetTextSize(Text, Environment.Font)
	RoleESP.CachedTextSizes[Text .. Environment.Font] = {
		W = TextWidth,
		H = TextHeight,
	}

	return TextWidth, TextHeight
end

local function TableToRGB(Table)
	if type(Table) ~= "table" then
		return COLOUR_WHITE
	end

	local R = Table.R or Table.r or 255
	local G = Table.G or Table.g or 255
	local B = Table.B or Table.b or 255
	return Color3.fromRGB(R, G, B)
end

local function ProcessPlayer(Entity)
	local IsAlive = PlayerTracker:IsPlayerAlive(Entity)
	if not IsAlive then
		return
	end

	local Role = PlayerTracker:GetPlayerRole(Entity)
	local IsSelected = RoleESP.Flags.SelectedRoleTypes[Role] ~= nil
	if not IsSelected then
		return
	end

	local _, _, OnScreen = utility.WorldToScreen(Entity.Position)
	if not OnScreen then
		return
	end

	local BoundingBox = Entity.BoundingBox
	if not BoundingBox then
		return
	end

	local TextWidth, TextHeight = GetTextSize(Role)
	local FinalX = BoundingBox.x + (BoundingBox.w / 2) - (TextWidth / 2)
	local FinalY = BoundingBox.y + (BoundingBox.h / 2) - (TextHeight / 2)

	local Color = RoleESP.Flags.UseRoleColor and RoleColors[Role] or RoleESP.Flags.Color
	local Alpha = RoleESP.Flags.Alpha

	draw.TextOutlined(Role, FinalX, FinalY, Color, Environment.Font, Alpha)
end

function RoleESP.Runtime()
	if not RoleESP.Flags.Enabled then
		return
	end

	if not PlayerTracker:IsPlayerAlive() then
		return
	end

	for _, EntityObject in pairs(entity.GetPlayers(false)) do
		ProcessPlayer(EntityObject)
	end
end

function RoleESP.Initialise(
	Container: typeof(__DIST.load('a')
.NewTab(nil, nil):Container(nil, nil, nil))
)
	local Enabled = Container:Checkbox("Role ESP Enabled")
	local Color = Container:Colorpicker("Role ESP Color", { r = 255, g = 255, b = 255, a = 255 }, true)
	local UseRoleColor = Container:Checkbox("Use Role Color", false)
	local RoleTypes = Container:Multiselect("Draw Roles", {
		"Innocent",
		"Sheriff",
		"Murderer",
	})

	cheat.Register("onPaint", RoleESP.Runtime)
	cheat.Register("onUpdate", function()
		RoleESP.Flags.Enabled = Enabled:Get()
		local ColorRGBA = Color:Get()
		RoleESP.Flags.Color = TableToRGB(ColorRGBA)
		RoleESP.Flags.Alpha = ColorRGBA.a
		RoleESP.Flags.UseRoleColor = UseRoleColor:Get()
		RoleESP.Flags.SelectedRoleTypes = RoleTypes:Get()

		UseRoleColor:Visible(RoleESP.Flags.Enabled)
		RoleTypes:Visible(RoleESP.Flags.Enabled)
	end)
end

return RoleESP
end function __DIST.n()local GameTracker = {
	LastUpdate = utility.GetTickCount() + 3000, -- if ur code is shit make counter measures heh.
	UpdateInterval = 50,
}

local Workspace = game.GetService("Workspace")

local Environment = __DIST.load('b')

local function GetCurrentMap()
	local Map = nil
	for _, Child in pairs(Workspace:GetChildren()) do
		local Attribute = Child:GetAttribute("MapID")
		if Attribute then
			Map = Child
			break
		end
	end

	return Map
end

local function GetCoinContainer()
	local Map = Environment.CachedMap
	if not Map then
		return nil
	end

	return Map:FindFirstChild("CoinContainer")
end

local function GetGunDrop()
	local Map = Environment.CachedMap
	if not Map then
		return nil
	end

	return Map:FindFirstChild("GunDrop")
end

local function UpdateCoins()
	local Container = Environment.CachedCoinContainer
	if not Container then
		return
	end

	local Coins = {}
	for _, Coin in pairs(Container:GetChildren()) do
		local MainCoin = Coin:FindFirstDescendant("MainCoin")
		if MainCoin and MainCoin.Transparency == 0 then
			Coins[Coin.Address] = Coin.Position
		end
	end

	Environment.ActiveCoins = Coins
end

function GameTracker.Initialise(
	Container: typeof(__DIST.load('a')
.NewTab(nil, nil):Container(nil, nil, nil))
)
	local IntervalSlider = Container:SliderInt("Game Tracker Update Interval", 1, 100, 50)

	cheat.Register("onUpdate", function()
		GameTracker.UpdateInterval = IntervalSlider:Get()

		local Now = utility.GetTickCount()
		if Now - GameTracker.LastUpdate >= GameTracker.UpdateInterval then
			UpdateCoins()
			Environment.CachedGunDrop = GetGunDrop()
			GameTracker.LastUpdate = Now
		end
	end)

	cheat.Register("onSlowUpdate", function()
		Environment.CachedMap = GetCurrentMap()
		Environment.CachedCoinContainer = GetCoinContainer()
	end)
end

return GameTracker
end function __DIST.o()local Customisation = {}

local Environment = __DIST.load('b')

function Customisation.Initialise(Container)
	local FontSelection = Container:Dropdown("Font Selection", {
		"ConsolasBold",
		"SmallestPixel",
		"Verdana",
		"Tahoma",
	}, 1)

	cheat.Register("onUpdate", function()
		Environment.Font = FontSelection:Get()
	end)
end

return Customisation
end function __DIST.p()
return function()
	function math.floor(x)
		return x - (x % 1)
	end

	function math.clamp(n, min, max)
		return math.max(min, math.min(max, n))
	end
end
end function __DIST.q()
return function()
	table.find = function(t, val)
		for i, v in pairs(t) do
			if v == val then
				return i
			end
		end
		return nil
	end
end
end end
local CoinFarm = __DIST.load('h')
local GetGun = __DIST.load('i')

local CoinESP = __DIST.load('k')
local GunDropESP = __DIST.load('l')
local RoleESP = __DIST.load('m')

local PlayerTracker = __DIST.load('e')
local GameTracker = __DIST.load('n')

local Customisation = __DIST.load('o')
local UIWrapper = __DIST.load('a')

local Math = __DIST.load('p')
local Table = __DIST.load('q')

local function Initialise()
	local Tab = UIWrapper.NewTab("DiddyWare_MM2", "DiddyWare")
	local Main = Tab:Container("DiddyWare_MM2C1", "Main", { autosize = true, next = true })
	local Visuals = Tab:Container("DiddyWare_MM2C2", "Visuals", { autosize = true })
	local Settings = Tab:Container("DiddyWare_MM2C3", "Settings", { autosize = true, next = true })

	Math()
	Table()
	CoinFarm.Initialise(Main)
	GetGun.Initialise(Main)
	CoinESP.Initialise(Visuals)
	RoleESP.Initialise(Visuals)
	GunDropESP.Initialise(Visuals)
	PlayerTracker.Initialise(Settings)
	GameTracker.Initialise(Settings)
	Customisation.Initialise(Settings)
end

Initialise()
