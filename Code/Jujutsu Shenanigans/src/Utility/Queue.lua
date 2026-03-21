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
