-- << Imports >>
local Callbacks = require("@utility/Callbacks")
local Configuration = require("@utility/Configuration")
local Table = require("@utility/Table")

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
				Selected[Options[i]] = true
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
