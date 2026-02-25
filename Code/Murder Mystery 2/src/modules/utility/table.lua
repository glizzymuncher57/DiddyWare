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
