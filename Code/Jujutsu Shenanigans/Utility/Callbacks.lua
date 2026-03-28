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
