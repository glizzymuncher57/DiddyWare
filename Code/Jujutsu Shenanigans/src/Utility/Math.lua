return function()
	function math.floor(x)
		return x - (x % 1)
	end

	function math.clamp(n, min, max)
		return math.max(min, math.min(max, n))
	end
end
