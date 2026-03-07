export type DrawPoint = { number: number }

export type Draw = {
	-- Line
	Line: (
		x1: number,
		y1: number,
		x2: number,
		y2: number,
		color: Color3,
		thickness: number?,
		alpha: number?
	) -> (),
	line: (
		x1: number,
		y1: number,
		x2: number,
		y2: number,
		color: Color3,
		thickness: number?,
		alpha: number?
	) -> (),

	-- Rect
	Rect: (
		x: number,
		y: number,
		w: number,
		h: number,
		color: Color3,
		thickness: number?,
		rounding: number?,
		alpha: number?
	) -> (),
	rect: (
		x: number,
		y: number,
		w: number,
		h: number,
		color: Color3,
		thickness: number?,
		rounding: number?,
		alpha: number?
	) -> (),

	-- RectFilled
	RectFilled: (
		x: number,
		y: number,
		w: number,
		h: number,
		color: Color3,
		rounding: number?,
		alpha: number?
	) -> (),
	rect_filled: (
		x: number,
		y: number,
		w: number,
		h: number,
		color: Color3,
		rounding: number?,
		alpha: number?
	) -> (),

	-- Circle
	Circle: (
		x: number,
		y: number,
		radius: number,
		color: Color3,
		thickness: number?,
		segments: number?,
		alpha: number?
	) -> (),
	circle: (
		x: number,
		y: number,
		radius: number,
		color: Color3,
		thickness: number?,
		segments: number?,
		alpha: number?
	) -> (),

	-- CircleFilled
	CircleFilled: (
		x: number,
		y: number,
		radius: number,
		color: Color3,
		segments: number?,
		alpha: number?
	) -> (),
	circle_filled: (
		x: number,
		y: number,
		radius: number,
		color: Color3,
		segments: number?,
		alpha: number?
	) -> (),

	-- Triangle
	Triangle: (
		x1: number,
		y1: number,
		x2: number,
		y2: number,
		x3: number,
		y3: number,
		color: Color3,
		thickness: number?,
		alpha: number?
	) -> (),
	triangle: (
		x1: number,
		y1: number,
		x2: number,
		y2: number,
		x3: number,
		y3: number,
		color: Color3,
		thickness: number?,
		alpha: number?
	) -> (),

	-- TriangleFilled
	TriangleFilled: (
		x1: number,
		y1: number,
		x2: number,
		y2: number,
		x3: number,
		y3: number,
		color: Color3,
		alpha: number?
	) -> (),
	triangle_filled: (
		x1: number,
		y1: number,
		x2: number,
		y2: number,
		x3: number,
		y3: number,
		color: Color3,
		alpha: number?
	) -> (),

	-- Gradient
	Gradient: (
		x: number,
		y: number,
		w: number,
		h: number,
		startColor: Color3,
		endColor: Color3,
		isHorizontal: boolean,
		startAlpha: number?,
		endAlpha: number?
	) -> (),
	gradient: (
		x: number,
		y: number,
		w: number,
		h: number,
		startColor: Color3,
		endColor: Color3,
		isHorizontal: boolean,
		startAlpha: number?,
		endAlpha: number?
	) -> (),

	-- Image
	Image: (
		textureId: number,
		x: number,
		y: number,
		w: number,
		h: number,
		r: number,
		g: number,
		b: number,
		a: number
	) -> (),
	image: (
		textureId: number,
		x: number,
		y: number,
		w: number,
		h: number,
		r: number,
		g: number,
		b: number,
		a: number
	) -> (),

	-- Text
	Text: (
		text: string,
		x: number,
		y: number,
		color: Color3,
		font: string?,
		alpha: number?
	) -> (),
	text: (
		text: string,
		x: number,
		y: number,
		color: Color3,
		font: string?,
		alpha: number?
	) -> (),

	-- TextOutlined
	TextOutlined: (
		text: string,
		x: number,
		y: number,
		color: Color3,
		font: string?,
		alpha: number?
	) -> (),
	text_outlined: (
		text: string,
		x: number,
		y: number,
		color: Color3,
		font: string?,
		alpha: number?
	) -> (),

	-- GetTextSize
	GetTextSize: (
		text: string,
		font: string?
	) -> (number, number),
	get_text_size: (
		text: string,
		font: string?
	) -> (number, number),

	-- ComputeConvexHull
	ComputeConvexHull: (
		points: { any }
	) -> { any }?,
	compute_convex_hull: (
		points: { any }
	) -> { any }?,

	-- Polyline
	Polyline: (
		points: { any },
		color: Color3,
		closed: boolean,
		thickness: number,
		alpha: number?
	) -> (),
	polyline: (
		points: { any },
		color: Color3,
		closed: boolean,
		thickness: number,
		alpha: number?
	) -> (),

	-- ConvexPolyFilled
	ConvexPolyFilled: (
		points: { any },
		color: Color3,
		alpha: number?
	) -> (),
	convex_poly_filled: (
		points: { any },
		color: Color3,
		alpha: number?
	) -> (),

	-- GetPartCorners
	GetPartCorners: (
		part: Instance
	) -> { Vector3 }?,
	get_part_corners: (
		part: Instance
	) -> { Vector3 }?,
}

declare draw: Draw

type Audio = {
	PlaySound: (
		wavData: string,
		loop: boolean?,
		volume: number?,
		pitch: number?
	) -> (),
	playSound: (
		wavData: string,
		loop: boolean?,
		volume: number?,
		pitch: number?
	) -> (),
	play_sound: (
		wavData: string,
		loop: boolean?,
		volume: number?,
		pitch: number?
	) -> (),

	Beep: (
		frequency: number,
		duration: number
	) -> (),
	beep: (
		frequency: number,
		duration: number
	) -> (),

	StopAll: () -> (),
	stopAll: () -> (),
	stop_all: () -> (),
}

declare audio: Audio

type BoundingBox2D = {
	x: number,
	y: number,
	w: number,
	h: number,
}

type BoneRotationMatrix = { number }

type EntityPlayer = {
	Name: string,
	DisplayName: string,
	UserId: number,
	Team: string,
	Weapon: string,
	Position: Vector3,
	Velocity: Vector3,
	Health: number,
	MaxHealth: number,
	IsAlive: boolean,
	IsEnemy: boolean,
	IsVisible: boolean,
	IsWhitelisted: boolean,
	BoundingBox: BoundingBox2D,
	TeamColor: Color3,

	GetBonePosition: (self: EntityPlayer, boneName: string) -> Vector3?,
	getBonePosition: (self: EntityPlayer, boneName: string) -> Vector3?,
	get_bone_position: (self: EntityPlayer, boneName: string) -> Vector3?,

	GetBoneInstance: (self: EntityPlayer, boneName: string) -> Instance?,
	getBoneInstance: (self: EntityPlayer, boneName: string) -> Instance?,
	get_bone_instance: (self: EntityPlayer, boneName: string) -> Instance?,

	GetBoneSize: (self: EntityPlayer, boneName: string) -> Vector3?,
	getBoneSize: (self: EntityPlayer, boneName: string) -> Vector3?,
	get_bone_size: (self: EntityPlayer, boneName: string) -> Vector3?,

	GetBoneRotation: (self: EntityPlayer, boneName: string) -> BoneRotationMatrix?,
	getBoneRotation: (self: EntityPlayer, boneName: string) -> BoneRotationMatrix?,
	get_bone_rotation: (self: EntityPlayer, boneName: string) -> BoneRotationMatrix?,
}

type EntityModelData = {
	Character: Instance,
	PrimaryPart: Instance,
	Name: string,
	DisplayName: string?,
	Team: string?,
	Weapon: string?,
	Humanoid: Humanoid?,
	HealthInstance: Instance?,
	Health: number?,
	MaxHealth: number?,
}

type Entity = {
	GetPlayers: (onlyEnemies: boolean?) -> { EntityPlayer },
	getPlayers: (onlyEnemies: boolean?) -> { EntityPlayer },
	get_players: (onlyEnemies: boolean?) -> { EntityPlayer },

	GetLocalPlayer: () -> EntityPlayer?,
	getLocalPlayer: () -> EntityPlayer?,
	get_local_player: () -> EntityPlayer?,

	GetParts: () -> { number },
	getParts: () -> { number },
	get_parts: () -> { number },

	GetPartPosition: (index: number) -> (number, number, number),
	getPartPosition: (index: number) -> (number, number, number),
	get_part_position: (index: number) -> (number, number, number),

	GetPartSize: (index: number) -> (number, number, number),
	getPartSize: (index: number) -> (number, number, number),
	get_part_size: (index: number) -> (number, number, number),

	GetPartRotation: (index: number) -> { number },
	getPartRotation: (index: number) -> { number },
	get_part_rotation: (index: number) -> { number },

	AddModel: (key: string, data: EntityModelData) -> boolean,
	addModel: (key: string, data: EntityModelData) -> boolean,
	add_model: (key: string, data: EntityModelData) -> boolean,

	RemoveModel: (key: string) -> boolean,
	removeModel: (key: string) -> boolean,
	remove_model: (key: string) -> boolean,

	ClearModels: () -> boolean,
	clearModels: () -> boolean,
	clear_models: () -> boolean,
}

declare entity: Entity

type Vector2 = {
	x: number,
	y: number,
}

type Utility = {
	-- Random
	RandomInt: (min: number, max: number) -> number,
	randomInt: (min: number, max: number) -> number,
	random_int: (min: number, max: number) -> number,

	RandomFloat: (min: number, max: number) -> number,
	randomFloat: (min: number, max: number) -> number,
	random_float: (min: number, max: number) -> number,

	-- Time
	GetTickCount: () -> number,
	getTickCount: () -> number,
	get_tick_count: () -> number,

	GetDeltaTime: () -> number,
	getDeltaTime: () -> number,
	get_delta_time: () -> number,

	-- System / Hardware
	GetFingerprint: () -> string,
	getFingerprint: () -> string,
	get_fingerprint: () -> string,

	-- Clipboard
	SetClipboard: (content: string) -> (),
	setClipboard: (content: string) -> (),
	set_clipboard: (content: string) -> (),

	GetClipboard: () -> string,
	getClipboard: () -> string,
	get_clipboard: () -> string,

	-- Mouse
	MoveMouse: (dx: number, dy: number) -> (),
	moveMouse: (dx: number, dy: number) -> (),
	move_mouse: (dx: number, dy: number) -> (),

	GetMousePos: () -> Vector2,
	getMousePos: () -> Vector2,
	get_mouse_pos: () -> Vector2,

	-- Menu
	GetMenuState: () -> boolean,
	getMenuState: () -> boolean,
	get_menu_state: () -> boolean,

	-- World / Screen
	WorldToScreen: (position: Vector3) -> (number, number, boolean),
	worldToScreen: (position: Vector3) -> (number, number, boolean),
	world_to_screen: (position: Vector3) -> (number, number, boolean),

	-- Images / Textures
	LoadImage: (image_data: string) -> number?,
	loadImage: (image_data: string) -> number?,
	load_image: (image_data: string) -> number?,
}

declare utility: Utility

type Mouse = {
	-- Click
	Click: (button: string | number) -> (),
	click: (button: string | number) -> (),

	-- IsClicked
	IsClicked: (button: string | number) -> boolean,
	isClicked: (button: string | number) -> boolean,
	is_clicked: (button: string | number) -> boolean,

	-- Scroll
	Scroll: (delta: number) -> (),
	scroll: (delta: number) -> (),
}

type Keyboard = {
	-- Press
	Press: (key: string | number) -> (),
	press: (key: string | number) -> (),

	-- Release
	Release: (key: string | number) -> (),
	release: (key: string | number) -> (),

	-- Click
	Click: (key: string | number, delay: number?) -> (),
	click: (key: string | number, delay: number?) -> (),

	-- IsPressed
	IsPressed: (key: string | number) -> boolean,
	isPressed: (key: string | number) -> boolean,
	is_pressed: (key: string | number) -> boolean,
}

declare mouse: Mouse
declare keyboard: Keyboard

type Cheat = {
	-- Event registration
	Register: (eventName: string, callback: () -> ()) -> (),
	register: (eventName: string, callback: () -> ()) -> (),

	-- Window info
	getWindowSize: () -> (number, number),
	GetWindowSize: () -> (number, number),
}

declare cheat: Cheat

type MemoryType =
	"float" | "double"
	| "int" | "uint"
	| "bool" | "byte"
	| "short" | "ushort"
	| "int64" | "uint64"
	| "pointer" | "ptr"
	| "string"
	| "vector2" | "vector3"
	| "color3"
	| "cframe"

type Memory = {
	-- Read
	Read: (type: MemoryType, address: number) -> any,
	read: (type: MemoryType, address: number) -> any,

	-- Write
	Write: (type: MemoryType, address: number, value: any) -> (),
	write: (type: MemoryType, address: number, value: any) -> (),

	-- Base
	GetBase: () -> number,
	getBase: () -> number,
	get_base: () -> number,

	-- Rebase
	Rebase: (offset: number) -> number,
	rebase: (offset: number) -> number,
}

declare memory: Memory

-- ---------- Attributes ----------

type Attribute = {
	Name: string,
	TypeName: string,
	Value: any,
}

-- ---------- Instance extensions (additive) ----------

type InstanceEx = {
	GetChildren: (self: Instance) -> { Instance },
	GetDescendants: (self: Instance) -> { Instance },

	FindFirstChild: (self: Instance, name: string) -> Instance?,
	FindFirstChildOfClass: (self: Instance, className: string) -> Instance?,

	FindFirstAncestor: (self: Instance, name: string) -> Instance?,
	FindFirstAncestorOfClass: (self: Instance, className: string) -> Instance?,

	FindFirstDescendant: (self: Instance, name: string) -> Instance?,
	FindFirstDescendantOfClass: (self: Instance, className: string) -> Instance?,

	IsA: (self: Instance, className: string) -> boolean,
	IsDescendantOf: (self: Instance, ancestor: Instance) -> boolean,
	IsAncestorOf: (self: Instance, descendant: Instance) -> boolean,

	SetHighlightOnTop: (self: Instance) -> (),
	SetHighlightTransparency: (self: Instance, transparency: number) -> (),

	GetAttributes: (self: Instance) -> { Attribute },
	GetAttribute: (self: Instance, name: string) -> Attribute?,
	GetFirstAttributeOfType: (self: Instance, typeName: string) -> Attribute?,
}


-- Types for UI values
type Color = { r: number, g: number, b: number, a: number }
type MultiselectValue = { [number]: boolean }

-- Optional table for container options
type ContainerOptions = {
	autosize: boolean?,
	next: boolean?,
	halfsize: boolean?,
	visible: boolean?
}

-- The main ui table
type UI = {
	-- Core
	getValue: (tab_ref: string, container_ref: string, name: string) -> any?,
	getHotkey: (tab_ref: string, container_ref: string, name: string) -> any?,
	setValue: (tab_ref: string, container_ref: string, name: string, new_value: any) -> (),
	setVisibility: (tab_ref: string, container_ref: string, name: string, is_visible: boolean) -> (),

	-- Layout
	newTab: (tab_ref: string, display_name: string) -> (),
	newContainer: (tab_ref: string, container_ref: string, display_name: string, options: ContainerOptions?) -> (),

	-- Widgets
	newCheckbox: (tab_ref: string, container_ref: string, name: string, in_line: boolean?) -> (),
	newSliderInt: (tab_ref: string, container_ref: string, name: string, min: number, max: number, default: number?) -> (),
	newSliderFloat: (tab_ref: string, container_ref: string, name: string, min: number, max: number, default: number?) -> (),
	newDropdown: (tab_ref: string, container_ref: string, name: string, options_table: {string}, default_index: number?) -> (),
	newMultiselect: (tab_ref: string, container_ref: string, name: string, options_table: {string}) -> (),
	newColorpicker: (tab_ref: string, container_ref: string, name: string, default_color: Color?, in_line: boolean?) -> (),
	newInputText: (tab_ref: string, container_ref: string, name: string, default_text: string?) -> (),
	newButton: (tab_ref: string, container_ref: string, name: string, callback_function: () -> ()) -> (),
	newListbox: (tab_ref: string, container_ref: string, name: string, options_table: {string}, callback_function: (() -> ())?) -> (),

	-- Undocumented
	newHotkey: (tab_ref: string, container_ref: string, name: string, in_line: boolean?) -> (),
}

declare ui: UI

-- ---------- Game extensions ----------

type FFlagType = "bool" | "int" | "float" | "double"

type Player = {
	PlayerGui: PlayerGui,
}

type GameEx = {
	-- Core objects (do NOT override Roblox ones)
	Workspace: Workspace,
	Players: Players,
	DataModel: DataModel,
	LocalPlayer: Player,

	PlaceID: number,

	-- Camera
	CameraPosition: Vector3,

	-- Services
	GetService: (serviceName: string) -> Instance,

	-- Exploit-only
	SilentAim: (x: number, y: number) -> (),
	PlayerWhitelist: (name: string) -> (),

	-- FFlags
	GetFFlag: (name: string, type: FFlagType) -> any?,
	SetFFlag: (name: string, value: any, type: FFlagType) -> boolean,
}

-- ---------- Final safe declarations ----------

declare game: GameEx
declare Instance: InstanceEx
