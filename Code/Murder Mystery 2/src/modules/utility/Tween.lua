local Tween = {}
Tween.__index = Tween

local SetPosition = require("@modules/utility/SetPosition")

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
