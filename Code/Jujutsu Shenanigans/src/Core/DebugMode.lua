-- << Imports >>
local Table = require("@utility/Table")
local Callbacks = require("@utility/Callbacks")
local Configuration = require("@utility/Configuration")

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
