--!nocheck
--!nolint

_P = {
	genDate = "2026-04-03T14:51:28.767760400+00:00",
	cfg = "Release",
	vers = "",
}

local a
a = {
	cache = {},
	load = function(b)
		if not a.cache[b] then
			a.cache[b] = { c = a[b]() }
		end
		return a.cache[b].c
	end,
}
do
	function a.a()
		local b, c, d = {}, {}, { "onPaint", "onUpdate", "onSlowUpdate", "shutdown" }
		for e, f in ipairs(d) do
			c[f] = {}
		end
		function b.Add(e, f)
			if type(e) ~= "string" or type(f) ~= "function" then
				return nil
			end
			if not c[e] then
				return nil
			end
			local g = #c[e] + 1
			c[e][g] = f
			return g
		end
		function b.Remove(e, f)
			if c[e] then
				c[e][f] = nil
			end
		end
		function b.ClearAll()
			for e, f in pairs(c) do
				c[e] = {}
			end
		end
		local e = function(e, ...)
			for f, g in pairs(c[e]) do
				g(...)
			end
		end
		function b:Initialise()
			for f, g in ipairs(d) do
				cheat.Register(g, function(...)
					e(g, ...)
				end)
			end
		end
		return b
	end
	function a.b()
		local b = {}
		b.__index = b
		local c = {}
		function b:Register(d, e)
			e = e or {}
			if type(d) ~= "string" or type(e) ~= "table" then
				return
			end
			c[d] = e
			return e
		end
		function b:Get(d)
			return c[d]
		end
		function b:Clear(d)
			local e = c[d]
			if not e then
				return
			end
			for f in next, e do
				e[f] = nil
			end
		end
		function b:Unload(d)
			local e = c[d]
			if not e then
				return
			end
			for f in next, e do
				e[f] = nil
			end
			c[d] = nil
		end
		function b:UnloadAll()
			for d, e in next, c do
				for f in next, e do
					e[f] = nil
				end
				c[d] = nil
			end
		end
		return b
	end
	function a.c()
		local b, c = a.load("b"), {}
		local d, e = b:Register("Configuration.Elements", {}), b:Register("Configuration.Values", {})
		function c.Register(f, g)
			d[f] = g
		end
		function c.GetValue(f)
			return e[f]
		end
		function c.SetValue(f, g)
			e[f] = g
		end
		return c
	end
	function a.d()
		local b = a.load("b")
		return {
			cached_generators = {},
			cached_fuseboxes = {},
			cached_items = {},
			killer = { name = nil, character = nil, root_part = nil, position = Vector3.new(0, 0, 0) },
			local_player = nil,
			player_gui = nil,
			local_position = Vector3.new(0, 0, 0),
			colour_cache = b:Register("env_colour_cache", {}),
			text_size_cache = b:Register("env_text_size_cache", {}),
			offsets_loaded = false,
		}
	end
	function a.e()
		local b, c, d, e, f =
			game.GetService("Workspace"), a.load("a"), a.load("c"), a.load("d"), entity.get_local_player()
		local g, h, i, j, k, l =
			b:find_first_child("MAPS"),
			b:find_first_child("IGNORE"),
			b:find_first_child("PLAYERS"),
			0,
			0,
			function(g, h, i)
				local j = g:GetAttribute(h)
				return j and j.Value or i
			end
		local m, n =
			function()
				local m = {}
				for n, o in pairs(h:get_children()) do
					local p, q = o.Name
					if p == "Battery" then
						q = o
					elseif p == "Trap" then
						q = o:find_first_child_of_class("MeshPart")
					elseif p == "Minion" then
						q = o:find_first_child("RootPart")
					end
					if q then
						local r
						if p ~= "Minion" then
							r = q.Position
						end
						table.insert(m, { name = p, render_part = q, position = r })
					end
				end
				e.cached_items = m
			end, function()
				local m, n = { generators = {}, fuse_boxes = {} }, g:find_first_child("GAME MAP")
				if not n then
					e.cached_generators = {}
					e.cached_fuseboxes = {}
					e.cached_items = {}
					return false
				end
				local o, p = n:find_first_child("Generators"), n:find_first_child("FuseBoxes")
				if o then
					for q, r in pairs(o:get_children()) do
						local s, t, u = r.Name, r.RootPart, l(r, "Progress", 0)
						local v = t.Position
						table.insert(m.generators, { model = r, progress = u, name = s, position = v })
					end
					e.cached_generators = m.generators
				end
				if p then
					for q, r in pairs(p:get_children()) do
						local s, t, u = "Fuse Box", r:find_first_child("Position"), l(r, "Inserted", false)
						local v = t.Position
						table.insert(m.fuse_boxes, { model = r, inserted = u, name = s, position = v })
					end
					e.cached_fuseboxes = m.fuse_boxes
				end
				return true
			end
		local o, p, q =
			function()
				if e.killer and e.killer.root_part then
					e.killer.position = e.killer.root_part.Position
				end
				local o, p = (d.GetValue("Update Map Every (s)") or 1) * 1000, utility.get_tick_count()
				if (p - j) > o then
					local q = n()
					if q then
						j = p
					end
				end
				if (p - k) > o then
					m()
					k = p
				end
				e.local_position = f.Position
			end, function()
				local o = game.LocalPlayer
				e.local_player = o
				e.player_gui = o:find_first_child("PlayerGui")
				local p = i:find_first_child("KILLER")
				if p then
					local q = p:find_first_child_of_class("Model")
					if not q then
						e.killer = { name = nil, character = nil, root_part = nil, position = Vector3.new(0, 0, 0) }
						return
					end
					local r = q.Name
					if e.killer and e.killer.name == r then
						return
					end
					local s = q:find_first_child("HumanoidRootPart")
					if not s then
						return
					end
					local t = q:find_first_child_of_class("Humanoid")
					if not t then
						return
					end
					local u = t:find_first_child_of_class("Animator")
					if not u then
						return
					end
					e.killer = { name = r, character = q, root_part = s }
				end
			end, {}
		function q:create_colour(r, s, t)
			local u = r .. s .. t
			local v = e.colour_cache[u]
			if v then
				return v
			end
			local w = Color3.fromRGB(r, s, t)
			e.colour_cache[u] = w
			return w
		end
		function q:get_text_size(r, s)
			local t = r .. s
			local u = e.text_size_cache[t]
			if u then
				return u[1], u[2]
			end
			local v, w = draw.get_text_size(r, s)
			e.text_size_cache[t] = { v, w }
			return v, w
		end
		function q:Initialise()
			c.Add("onUpdate", o)
			c.Add("onSlowUpdate", p)
		end
		return q
	end
	function a.f()
		local b, c, d = a.load("d"), {}, memory.read
		function c.read(e, f)
			if not b.offsets_loaded then
				return
			end
			return d(f.Type, e + f.Offset)
		end
		function c.read_vector2(e, f)
			if not b.offsets_loaded then
				return Vector3.new(0, 0, 0)
			end
			local g, h = d(f.Type, e + f.X), d(f.Type, e + f.Y)
			return Vector3.new(g, h, 0)
		end
		return c
	end
	function a.g()
		local b, c =
			{
				version = "version-689e359b09ad43b0",
				ImageButton = { Image = { Type = "string", Offset = 0xcc8 } },
				Path2D = { Visible = { Type = "bool", Offset = 0x115 } },
				Animator = { AnimationTrackList = { Type = "pointer", Offset = 0x850 } },
				ScreenGui = { Enabled = { Type = "bool", Offset = 0x4cc } },
				AnimationTrack = { Speed = { Type = "float", Offset = 0xe4 }, TimePosition = { Type = "float", Offset = 0xe8 }, Looped = { Type = "bool", Offset = 0xf5 }, Animation = { Type = "pointer", Offset = 0xd0 } },
				Animation = { AnimationId = { Type = "string", Offset = 0xd0 } },
				GuiObject = { Size = { Type = "float", X = 0x538, Y = 0x540 }, Position = { Type = "float", X = 0x518, Y = 0x520 }, Visible = { Type = "bool", Offset = 0x5b5 }, AbsolutePosition = { Type = "float", X = 0x110, Y = 0x114 }, Rotation = {
					Type = "float",
					Offset = 0x188,
				}, AbsoluteSize = { Type = "float", X = 0x118, Y = 0x11c } },
			}, a.load("d")
		function b:Initialise(d)
			http.Get(
				[[https://raw.githubusercontent.com/glizzymuncher57/DiddyWare/refs/heads/main/shared_offsets.lua]],
				{},
				function(e)
					if not e then
						print("no response")
						return
					end
					local f = loadstring(e)
					f = f()
					for g in pairs(b) do
						if g ~= "Initialise" then
							b[g] = nil
						end
					end
					for g, h in pairs(f) do
						b[g] = h
					end
					c.offsets_loaded = true
					if d then
						d()
					end
				end
			)
		end
		return b
	end
	function a.h()
		local b, c, d, e, f = a.load("d"), a.load("a"), a.load("c"), a.load("f"), a.load("g")
		local g = function()
			for g, h in pairs(b.player_gui:get_children()) do
				if h.Name == "Dot" then
					local i = e.read(h.Address, f.ScreenGui.Enabled)
					if i then
						return h
					end
				end
			end
			return nil
		end
		local h = function()
			if not b.offsets_loaded then
				return
			end
			if not d.GetValue("Auto Door Hold") or d.GetValue("Auto Door Hold Hotkey") ~= true then
				return
			end
			if utility.get_menu_state() then
				return
			end
			if not b.player_gui then
				return
			end
			local h = g()
			if not h then
				return
			end
			local i, j = d.GetValue("Auto Door Hold Speed"), h:find_first_child("Container")
			local k, l = j:find_first_child("Frame"), utility.get_mouse_pos()
			local m, n =
				e.read_vector2(k.Address, f.GuiObject.AbsolutePosition),
				e.read_vector2(k.Address, f.GuiObject.AbsoluteSize)
			local o = m + (n / 2)
			local p, q = (l[1] - o.X) * (i / 100), (l[2] - o.Y) * (i / 100)
			utility.move_mouse(p, q)
		end
		return function()
			c.Add("onUpdate", h)
		end
	end
	function a.i()
		local b, c, d = a.load("f"), a.load("g"), a.load("c")
		return function(e)
			local f = e:find_first_child("Wires")
			if not f then
				return false
			end
			local g, h = f:find_first_child("WiresEnd"), f:find_first_child("WireBoxes")
			if not g or not h then
				return false
			end
			local i = d.GetValue("Auto Generator Mouse Speed")
			for j = 1, 4 do
				local k, l, m =
					g:find_first_child(tostring(j)).Hitbox,
					h:find_first_child(tostring(j)),
					f:find_first_child(tostring(j))
				if k and l and m then
					local n, o, p =
						l.ConnectHitbox,
						b.read_vector2(k.Address, c.GuiObject.AbsolutePosition),
						b.read_vector2(k.Address, c.GuiObject.AbsoluteSize)
					local q, r, s =
						b.read_vector2(n.Address, c.GuiObject.AbsolutePosition),
						b.read_vector2(n.Address, c.GuiObject.AbsoluteSize),
						o + (p / 2)
					local t, u, v =
						q.X + r.X, q.Y + r.Y / 2, (s.X >= q.X and s.X <= q.X + r.X and s.Y >= q.Y and s.Y <= q.Y + r.Y)
					if not v then
						local w, x = b.read(m.Address, c.Path2D.Visible), utility.get_mouse_pos()
						if not w then
							local y, z = math.clamp(s.X - x[1], -i, i), math.clamp(s.Y - x[2], -i, i)
							utility.move_mouse(y, z)
							x = utility.get_mouse_pos()
							local A = (x[1] >= o.X and x[1] <= o.X + p.X and x[2] >= o.Y and x[2] <= o.Y + p.Y)
							if A then
								mouse.click("leftmouse")
							end
							return false
						end
						local y, z = math.clamp(t - x[1], -i, i), math.clamp(u - x[2], -i, i)
						utility.move_mouse(y, z)
						local A = utility.get_mouse_pos()
						local B = (math.abs(A[1] - t) <= 7.5 and math.abs(A[2] - u) <= 7.5)
						if not B then
							return false
						end
						if j == 4 then
							return true
						end
					end
				end
			end
			return true
		end
	end
	function a.j()
		local b, c, d = a.load("f"), a.load("g"), a.load("c")
		return function(e)
			local f = e:find_first_child("Switch")
			if not f then
				return false
			end
			local g, h = f:find_first_child("Switches"), d.GetValue("Auto Generator Mouse Speed")
			for i, j in pairs(g:get_children()) do
				local k = b.read(j.Address, c.ImageButton.Image)
				if k == "rbxassetid://133499480186899" then
					local l, m =
						b.read_vector2(j.Address, c.GuiObject.AbsolutePosition),
						b.read_vector2(j.Address, c.GuiObject.AbsoluteSize)
					local n, o = l + (m / 2), utility.get_mouse_pos()
					local p, q = math.clamp(n.X - o[1], -h, h), math.clamp(n.Y - o[2], -h, h)
					utility.move_mouse(p, q)
					o = utility.get_mouse_pos()
					local r = (o[1] >= l.X and o[1] <= l.X + m.X and o[2] >= l.Y and o[2] <= l.Y + m.Y)
					if r then
						mouse.click("leftmouse")
						return false
					end
					return false
				end
			end
			return true
		end
	end
	function a.k()
		local b, c, d = a.load("f"), a.load("g"), a.load("c")
		return function(e)
			local f = e:find_first_child("Lever")
			if not f then
				mouse.release("leftmouse")
				return false
			end
			local g = f:find_first_child("ProgressBar")
			if not g then
				mouse.release("leftmouse")
				return false
			end
			local h = g.Fill
			local i = h and h.Bar
			if not i then
				mouse.release("leftmouse")
				return false
			end
			local j = memory.read("float", i.Address + c.GuiObject.Size.X)
			if j > 0.9 then
				mouse.release("leftmouse")
				return true
			end
			local k = f:find_first_child("Rope")
			local l = k and k:find_first_child("Button")
			if not l then
				mouse.release("leftmouse")
				return false
			end
			local m = d.GetValue("Auto Generator Mouse Speed")
			local n, o, p =
				m * 3,
				b.read_vector2(l.Address, c.GuiObject.AbsolutePosition),
				b.read_vector2(l.Address, c.GuiObject.AbsoluteSize)
			local q, r = o + (p / 2), utility.get_mouse_pos()
			local s = math.sqrt((r[1] - q.X) ^ 2 + (r[2] - q.Y) ^ 2)
			if s > 15 then
				local t, u = math.clamp(q.X - r[1], -n, n), math.clamp(q.Y - r[2], -n, n)
				utility.move_mouse(t, u)
				mouse.release("leftmouse")
				return true
			end
			if not keyboard.is_pressed("leftmouse") then
				mouse.press("leftmouse")
			end
			local t = utility.get_tick_count()
			local u, v = q.Y + math.sin(t * 1.3) * 40 + math.sin(t * 4.2) * 20, utility.get_mouse_pos()
			local w = math.clamp(u - v[2], -n, n)
			utility.move_mouse(0, w)
			return true
		end
	end
	function a.l()
		local b, c, d, e =
			a.load("d"), a.load("a"), a.load("c"), { Wires = a.load("i"), Switches = a.load("j"), Pull = a.load("k") }
		local f = function()
			if utility.get_menu_state() then
				return
			end
			if not d.GetValue("Auto Generator") then
				return
			end
			if not b.player_gui then
				return
			end
			local f = b.player_gui:find_first_child("Gen")
			if not f then
				return
			end
			local g = f:find_first_child("MainFrame")
			if not g then
				return
			end
			local h = g:find_first_child("Generator")
			if h then
				local i = e.Wires(h)
				if not i then
					return
				end
				local j = e.Switches(h)
				if j then
					e.Pull(h)
				end
			end
		end
		return function()
			c.Add("onUpdate", f)
		end
	end
	function a.m()
		local b, c, d, e, f =
			a.load("d"), a.load("a"), a.load("c"), a.load("e"), function(b, c)
				if not b or not c then
					return 0
				end
				return (b - c).Magnitude
			end
		local g = function()
			local g, h, i, j, k, l =
				d.GetValue("Visuals Enabled"),
				d.GetValue("Show Distance"),
				d.GetValue("Distance Colour"),
				d.GetValue("Killer ESP"),
				d.GetValue("Killer Colour"),
				d.GetValue("ESP Font Selection")
			if not g or not j then
				return
			end
			local m = b.killer
			if not b.killer.character then
				return
			end
			if b.killer.name == b.local_player.Name then
				return
			end
			local n, o, p = utility.world_to_screen(m.position)
			if p then
				local q = m.name
				local r, s, t = e:get_text_size(q, l), "", 0
				if h then
					local u = b.local_position
					local v = f(u, m.position)
					s = "[" .. tostring(math.floor(v)) .. "m]"
					t = e:get_text_size(s, l)
				end
				local u = r + t
				local v = n - (u / 2)
				draw.text_outlined(q, v, o, e:create_colour(k.r, k.g, k.b), l, k.a)
				if h then
					draw.text_outlined(s, v + r, o, e:create_colour(i.r, i.g, i.b), l, i.a)
				end
			end
		end
		return function()
			c.Add("onPaint", g)
		end
	end
	function a.n()
		local b, c, d, e, f =
			a.load("d"), a.load("a"), a.load("c"), a.load("e"), function(b, c)
				if not b or not c then
					return 0
				end
				return (b - c).Magnitude
			end
		local g = function()
			local g, h, i, j, k, l, m, n =
				d.GetValue("Visuals Enabled"),
				d.GetValue("Show Distance"),
				d.GetValue("Distance Colour"),
				d.GetValue("Generator ESP"),
				d.GetValue("Generator Colour"),
				d.GetValue("Generator Progress"),
				d.GetValue("Generator Progress Colour"),
				d.GetValue("ESP Font Selection")
			if not g or not j then
				return
			end
			for o = 1, #b.cached_generators do
				local p = b.cached_generators[o]
				local q = p.progress or 0
				if q < 100 then
					local r, s, t = utility.world_to_screen(p.position)
					if t then
						local u = p.name
						local v, w = e:get_text_size(u, n)
						local x, y = "", 0
						if h then
							local z = b.local_position
							local A = f(z, p.position)
							x = "[" .. tostring(math.floor(A)) .. "m]"
							y = e:get_text_size(x, n)
						end
						local z = v + y
						local A = r - (z / 2)
						draw.text_outlined(u, A, s, e:create_colour(k.r, k.g, k.b), n, k.a)
						if h then
							draw.text_outlined(x, A + v, s, e:create_colour(i.r, i.g, i.b), n, i.a)
						end
						if l then
							local B = tostring(q) .. "%"
							local C = draw.get_text_size(B, n)
							local D, E = r - (C / 2), s + w
							draw.text_outlined(B, D, E, e:create_colour(m.r, m.g, m.b), n, m.a)
						end
					end
				end
			end
		end
		return function()
			c.Add("onPaint", g)
		end
	end
	function a.o()
		local b, c, d, e, f =
			a.load("d"), a.load("a"), a.load("c"), a.load("e"), function(b, c)
				if not b or not c then
					return 0
				end
				return (b - c).Magnitude
			end
		local g = function()
			local g, h, i, j, k, l =
				d.GetValue("Visuals Enabled"),
				d.GetValue("Show Distance"),
				d.GetValue("Distance Colour"),
				d.GetValue("Fuse Box ESP"),
				d.GetValue("Fuse Box Colour"),
				d.GetValue("ESP Font Selection")
			if not g or not j then
				return
			end
			for m = 1, #b.cached_fuseboxes do
				local n = b.cached_fuseboxes[m]
				local o = n.inserted
				if not o then
					local p, q, r = utility.world_to_screen(n.position)
					if r then
						local s = n.name
						local t, u = e:get_text_size(s, l)
						local v, w = "", 0
						if h then
							local x = b.local_position
							local y = f(x, n.position)
							v = "[" .. tostring(math.floor(y)) .. "m]"
							w = e:get_text_size(v, l)
						end
						local x = t + w
						local y = p - (x / 2)
						draw.text_outlined(s, y, q, e:create_colour(k.r, k.g, k.b), l, k.a)
						if h then
							draw.text_outlined(v, y + t, q, e:create_colour(i.r, i.g, i.b), l, i.a)
						end
					end
				end
			end
		end
		return function()
			c.Add("onPaint", g)
		end
	end
	function a.p()
		local b, c, d, e, f =
			a.load("d"), a.load("a"), a.load("c"), a.load("e"), function(b, c)
				if not b or not c then
					return 0
				end
				return (b - c).Magnitude
			end
		local g = function()
			local g, h, i, j, k, l =
				d.GetValue("Visuals Enabled"),
				d.GetValue("Show Distance"),
				d.GetValue("Distance Colour"),
				d.GetValue("Item ESP"),
				d.GetValue("Item Colour"),
				d.GetValue("ESP Font Selection")
			if not g or not j then
				return
			end
			for m = 1, #b.cached_items do
				local n = b.cached_items[m]
				local o, p, q = utility.world_to_screen(n.position or n.render_part.position)
				if q then
					local r = n.name
					local s, t, u = e:get_text_size(r, l), "", 0
					if h then
						local v = b.local_position
						local w = f(v, n.position)
						t = "[" .. tostring(math.floor(w)) .. "m]"
						u = e:get_text_size(t, l)
					end
					local v = s + u
					local w = o - (v / 2)
					draw.text_outlined(r, w, p, e:create_colour(k.r, k.g, k.b), l, k.a)
					if h then
						draw.text_outlined(t, w + s, p, e:create_colour(i.r, i.g, i.b), l, i.a)
					end
				end
			end
		end
		return function()
			c.Add("onPaint", g)
		end
	end
	function a.q()
		local b, c, d, e, f, g, h = {}, a.load("h"), a.load("l"), a.load("m"), a.load("n"), a.load("o"), a.load("p")
		function b:Initialise()
			d()
			c()
			e()
			f()
			g()
			h()
		end
		return b
	end
	function a.r()
		local b, c, d, e = a.load("a"), a.load("c"), a.load("b"), {}
		e.DebugMode = false
		local f, g, h = d:Register("UI.Elements", {}), d:Register("UI.DebugElements", {}), {}
		h.__index = h
		function h:Get()
			return c.GetValue(self.Name)
		end
		function h:Set(i)
			ui.setValue(self.TabRef, self.ContainerRef, self.Name, i)
			c.SetValue(self.Name, i)
		end
		function h:Visible(i)
			ui.setVisibility(self.TabRef, self.ContainerRef, self.Name, i)
		end
		function h:OnChange(i)
			self._onChange = i
			return self
		end
		function h:_Read()
			return ui.getValue(self.TabRef, self.ContainerRef, self.Name)
		end
		function h:_Poll()
			local i, j = self:_Read(), c.GetValue(self.Name)
			if i == j then
				return
			end
			c.SetValue(self.Name, i)
			if self._onChange then
				self._onChange(i, j)
			end
		end
		local i, j =
			function(i, j, k, l)
				local m = setmetatable({
					TabRef = i,
					ContainerRef = j,
					Name = k,
					Debug = l and l.Debug,
				}, h)
				c.Register(k, m)
				f[k] = m
				if m.Debug then
					m:Visible(false)
					g[#g + 1] = m
				end
				return m
			end, {}
		j.__index = j
		function j:Checkbox(k, l, m)
			ui.newCheckbox(self.TabRef, self.Ref, k, l)
			return i(self.TabRef, self.Ref, k, m)
		end
		function j:SliderInt(k, l, m, n, o)
			ui.newSliderInt(self.TabRef, self.Ref, k, l, m, n)
			return i(self.TabRef, self.Ref, k, o)
		end
		function j:SliderFloat(k, l, m, n, o)
			ui.newSliderFloat(self.TabRef, self.Ref, k, l, m, n)
			return i(self.TabRef, self.Ref, k, o)
		end
		function j:Dropdown(k, l, m, n)
			ui.newDropdown(self.TabRef, self.Ref, k, l, m)
			local o = i(self.TabRef, self.Ref, k, n)
			o._Read = function(p)
				local q = ui.getValue(p.TabRef, p.ContainerRef, k)
				return l[q + 1]
			end
			return o
		end
		function j:Multiselect(k, l, m)
			ui.newMultiselect(self.TabRef, self.Ref, k, l)
			local n = i(self.TabRef, self.Ref, k, m)
			n._Read = function(o)
				local p, q = ui.getValue(o.TabRef, o.ContainerRef, k), {}
				for r, s in ipairs(p) do
					if s then
						q[l[r]] = true
					end
				end
				return q
			end
			n._Poll = function(o)
				local p, q = o:_Read(), c.GetValue(o.Name)
				local r = type(q) ~= "table"
				if not r then
					for s, t in ipairs(l) do
						if p[t] ~= q[t] then
							r = true
							break
						end
					end
				end
				if not r then
					return
				end
				c.SetValue(o.Name, p)
				if o._onChange then
					o._onChange(p, q)
				end
			end
			return n
		end
		function j:Colorpicker(k, l, m, n)
			ui.newColorpicker(self.TabRef, self.Ref, k, l, m)
			local o = i(self.TabRef, self.Ref, k, n)
			o._Read = function(p)
				return ui.getValue(p.TabRef, p.ContainerRef, k)
			end
			o.Get = function(p, q)
				local r = c.GetValue(p.Name)
				if not r then
					return nil
				end
				q = (tostring(q) or "table"):lower()
				return q == "rgb" and Color3.fromRGB(r.r, r.g, r.b) or r
			end
			o._Poll = function(p)
				local q, r = p:_Read(), c.GetValue(p.Name)
				if r and q.r == r.r and q.g == r.g and q.b == r.b and q.a == r.a then
					return
				end
				c.SetValue(p.Name, q)
				if p._onChange then
					p._onChange(q, r)
				end
			end
			return o
		end
		function j:InputText(k, l, m)
			ui.newInputText(self.TabRef, self.Ref, k, l)
			return i(self.TabRef, self.Ref, k, m)
		end
		function j:Button(k, l, m)
			ui.newButton(self.TabRef, self.Ref, k, l)
			local n = i(self.TabRef, self.Ref, k, m)
			n.Get = nil
			n.Set = nil
			n._Poll = function() end
			return n
		end
		function j:Listbox(k, l, m, n)
			ui.newListbox(self.TabRef, self.Ref, k, l, function()
				local o = ui.getValue(self.TabRef, self.Ref, k)
				local p = l[o + 1]
				c.SetValue(k, p)
				if m then
					m(p)
				end
			end)
			local o = i(self.TabRef, self.Ref, k, n)
			o._Poll = function() end
			return o
		end
		function j:KeyPicker(k, l, m)
			ui.newHotkey(self.TabRef, self.Ref, k, l)
			local n = i(self.TabRef, self.Ref, k, m)
			n._Read = function(o)
				return ui.getValue(o.TabRef, o.ContainerRef, k)
			end
			n.Get = function(o, p)
				if p == "Hotkey" then
					return ui.getHotkey(o.TabRef, o.ContainerRef, k)
				end
				return c.GetValue(o.Name)
			end
			return n
		end
		function j:Page(k, l)
			local m, n = self:Dropdown(k, l, 1), {}
			for o, p in ipairs(l) do
				n[p] = {}
			end
			local o, p, q =
				l[1], self, function(o, p)
					local q = n[o]
					if not q then
						return
					end
					for r = 1, #q do
						q[r]:Visible(p)
					end
				end
			for r, s in ipairs(l) do
				q(s, r == 1)
			end
			m:OnChange(function(r)
				q(o, false)
				o = r
				q(o, true)
			end)
			local r = {}
			function r:For(s)
				assert(n[s], "[UI.Page]: Unknown page '" .. tostring(s) .. "'")
				return setmetatable({}, {
					__index = function(t, u)
						local v = j[u]
						if type(v) ~= "function" or u == "Page" then
							return nil
						end
						return function(w, ...)
							local x = v(p, ...)
							n[s][#n[s] + 1] = x
							if s ~= o then
								x:Visible(false)
							end
							return x
						end
					end,
				})
			end
			return r
		end
		local k = {}
		k.__index = k
		function k:Container(l, m, n)
			ui.newContainer(self.Ref, l, m, n or {})
			return setmetatable({ TabRef = self.Ref, Ref = l }, j)
		end
		function e.NewTab(l, m)
			ui.newTab(l, m)
			return setmetatable({ Ref = l }, k)
		end
		function e:SetDebugMode(l)
			self.DebugMode = l
			for m = 1, #g do
				g[m]:Visible(l)
			end
		end
		function e:Initialise()
			b.Add("onUpdate", function()
				for l, m in next, f do
					m:_Poll()
				end
			end)
		end
		return e
	end
	function a.s()
		local b, c, d = {}, "Features_DiddyWare", "Features"
		function b:Initialise(e)
			local f = e:Container(c, d, { autosize = true, next = true })
			f:Checkbox("Auto Door Hold")
			f:KeyPicker("Auto Door Hold Hotkey", true)
			f:SliderInt("Auto Door Hold Speed", 1, 25, 15)
			f:Checkbox("Auto Generator")
			f:SliderInt("Auto Generator Mouse Speed", 1, 25, 15)
		end
		return b
	end
	function a.t()
		local b, c, d = {}, "VisualsTab_DiddyWare", "Visuals"
		function b:Initialise(e)
			local f = e:Container(c, d, { autosize = true, next = true })
			f:Checkbox("Visuals Enabled")
			f:Checkbox("Show Distance")
			f:Colorpicker("Distance Colour", { r = 255, g = 255, b = 255, a = 255 }, true)
			f:Checkbox("Killer ESP")
			f:Colorpicker("Killer Colour", { r = 255, g = 0, b = 0, a = 255 }, true)
			f:Checkbox("Generator ESP")
			f:Colorpicker("Generator Colour", { r = 255, g = 255, b = 255, a = 255 }, true)
			f:Checkbox("Generator Progress")
			f:Colorpicker("Generator Progress Colour", { r = 255, g = 255, b = 255, a = 255 }, true)
			f:Checkbox("Fuse Box ESP", false)
			f:Colorpicker("Fuse Box Colour", { r = 255, g = 255, b = 255, a = 255 }, true)
			f:Checkbox("Item ESP", false)
			f:Colorpicker("Item Colour", { r = 255, g = 255, b = 255, a = 255 }, true)
		end
		return b
	end
	function a.u()
		local b, c, d = {}, "Settings_DiddyWare", "Settings"
		function b:Initialise(e)
			local f = e:Container(c, d, { autosize = true })
			f:SliderFloat("Update Map Every (s)", 1, 5, 1)
			f:Dropdown("ESP Font Selection", { "ConsolasBold", "SmallestPixel", "Verdana", "Tahoma" }, 1)
		end
		return b
	end
	function a.v()
		local b, c, d, e, f = {}, a.load("r"), a.load("s"), a.load("t"), a.load("u")
		function b:Initialise()
			local g = c.NewTab("DiddyWare_JB", "DiddyWare")
			d:Initialise(g)
			e:Initialise(g)
			f:Initialise(g)
		end
		return b
	end
	function a.w()
		return function()
			function math.floor(b)
				return b - (b % 1)
			end
			function math.clamp(b, c, d)
				return math.max(c, math.min(d, b))
			end
		end
	end
end
local b, c, d, e, f, g, h, i =
	a.load("e"), a.load("q"), a.load("v"), a.load("g"), a.load("a"), a.load("b"), a.load("w"), a.load("r")
local j = function()
	h()
	f:Initialise()
	i:Initialise()
	b:Initialise()
	c:Initialise()
	d:Initialise()
	f.Add("shutdown", function()
		f.ClearAll()
		g:UnloadAll()
		entity.clear_models()
	end)
end
e:Initialise(j)
