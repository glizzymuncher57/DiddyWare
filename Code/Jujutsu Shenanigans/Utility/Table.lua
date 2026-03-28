local TableManager = {}
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
