--!nocheck
--!nolint

_P = {
	genDate = "2026-04-09T15:26:44.145881400+00:00",
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
	function a.b()
		local b = a.load("a")
		return {
			cached_generators = {},
			cached_fuseboxes = {},
			cached_items = {},
			killer = { name = nil, character = nil, root_part = nil, position = Vector3.new(0, 0, 0), stamina = nil, max_stamina = nil },
			players = {},
			local_data = {
				player = nil,
				character = nil,
				humanoid = nil,
				player_gui = nil,
				player_position = nil,
				selected_class = nil,
			},
			colour_cache = b:Register("env_colour_cache", {}),
			text_size_cache = b:Register("env_text_size_cache", {}),
			offsets_loaded = false,
		}
	end
	function a.c()
		local b, c = a.load("b"), {}
		c.__index = c
		local d, e, f, g = {}, {}, 1, function(d)
			if type(d) == "table" then
				return {}
			end
			return d
		end
		local h, i =
			function(h)
				if not e[h] then
					e[h] = {}
				end
				return e[h]
			end, function(h)
				local i = utility.get_tick_count()
				if (i - h.last) < h.interval then
					return
				end
				local j = h.back
				if type(j) == "table" then
					for k in pairs(j) do
						j[k] = nil
					end
				end
				local k = pcall(h.run, j, b, h)
				if k then
					h.front, h.back = j, h.front
					b[h.target] = h.front
					h.last = i
				end
			end
		function c:Register(j, k)
			local l, m, n = k.priority or 3, k.target or j, k.default ~= nil and k.default or {}
			d[j] =
				{ name = j, run = k.run, interval = k.interval or 1000, priority = l, target = m, last = 0, front = n, back = g(
					n
				) }
			b[m] = d[j].front
			table.insert(h(l), j)
		end
		function c:Unregister(j)
			local k = d[j]
			if not k then
				return
			end
			local l = e[k.priority]
			if l then
				for m, n in ipairs(l) do
					if n == j then
						table.remove(l, m)
						break
					end
				end
			end
			d[j] = nil
		end
		function c:Invalidate(j)
			if d[j] then
				d[j].last = 0
			end
		end
		function c:Get(j)
			return d[j] and d[j].front
		end
		function c:Update()
			for j = 1, 2 do
				local k = e[j]
				if k then
					for l, m in ipairs(k) do
						i(d[m])
					end
				end
			end
			local j = {}
			for k, l in pairs(e) do
				if k >= 3 then
					for m, n in ipairs(l) do
						table.insert(j, n)
					end
				end
			end
			if #j > 0 then
				if f > #j then
					f = 1
				end
				i(d[j[f]])
				f = f + 1
			end
		end
		function c:create_colour(j, k, l)
			local m = j .. k .. l
			local n = b.colour_cache[m]
			if n then
				return n
			end
			local o = Color3.fromRGB(j, k, l)
			b.colour_cache[m] = o
			return o
		end
		function c:get_text_size(j, k)
			local l = j .. k
			local m = b.text_size_cache[l]
			if m then
				return m[1], m[2]
			end
			local n, o = draw.get_text_size(j, k)
			b.text_size_cache[l] = { n, o }
			return n, o
		end
		return c
	end
	function a.d()
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
	function a.e()
		local b = game.GetService("Workspace")
		local c = b:find_first_child("IGNORE")
		return {
			{
				name = "ignore_items",
				target = "cached_items",
				interval = 1000,
				priority = 3,
				default = {},
				run = function(d, e, f)
					for g, h in pairs(c:get_children()) do
						local i, j = h.Name
						if i == "Battery" then
							j = h
						elseif i == "Trap" then
							j = h:find_first_child_of_class("MeshPart")
						elseif i == "Minion" then
							j = h:find_first_child_of_class("MeshPart")
						end
						if j then
							table.insert(
								d,
								{ name = i, render_part = j, position = (i ~= "Minion") and j.Position or nil }
							)
						end
					end
				end,
			},
			{
				name = "ignore_items_update",
				interval = 75,
				priority = 1,
				run = function(d, e, f)
					local g = e.cached_items
					if not g then
						return
					end
					for h, i in ipairs(g) do
						if i.name == "Minion" then
							i.position = i.render_part.Position
						end
					end
				end,
			},
		}
	end
	function a.f()
		local b = game.GetService("Workspace")
		local c, d =
			b:find_first_child("PLAYERS").KILLER, function(c, d, e)
				local f = c:GetAttribute(d)
				return f and f.Value or e
			end
		return {
			{
				name = "killer_data_gathering",
				target = "killer",
				interval = 2000,
				priority = 3,
				default = {
					name = nil,
					character = nil,
					hitbox_part = nil,
					position_part = nil,
					position = nil,
					stamina = nil,
					max_stamina = nil,
				},
				run = function(e, f, g)
					local h = c:find_first_child_of_class("Model")
					if not h then
						return
					end
					local i = h:find_first_child("Hitbox")
					if not i then
						return
					end
					e.name = h.Name
					e.character = h
					e.position_part = i
					e.hitbox_part = i
					e.position = e.position_part.Position
					e.stamina = d(h, "Stamina", 70)
				end,
			},
			{
				name = "killer_data_updating",
				interval = 50,
				priority = 1,
				run = function(e, f, g)
					local h = f.killer
					if not h or not h.position_part then
						return
					end
					h.stamina = d(h.character, "Stamina", 70)
					h.max_stamina = d(h.character, "MaxStamina", 100)
					h.position = h.position_part.Position
				end,
			},
		}
	end
	function a.g()
		local b = game.GetService("Workspace")
		local c, d =
			b:find_first_child("MAPS"), function(c, d, e)
				local f = c:get_attribute(d)
				return f and f.Value or e
			end
		return {
			{
				name = "map_generators",
				target = "cached_generators",
				interval = 2000,
				priority = 3,
				default = {},
				run = function(e, f, g)
					local h = c:find_first_child("GAME MAP")
					if not h then
						return
					end
					local i = h:find_first_child("Generators")
					if not i then
						return
					end
					for j, k in pairs(i:get_children()) do
						local l = k.RootPart
						if l then
							table.insert(
								e,
								{ model = k, name = k.Name, position = l.Position, progress = d(k, "Progress", 0) }
							)
						end
					end
				end,
			},
			{
				name = "map_fuse_boxes",
				target = "cached_fuseboxes",
				interval = 2000,
				priority = 3,
				default = {},
				run = function(e, f, g)
					local h = c:find_first_child("GAME MAP")
					if not h then
						return
					end
					local i = h:find_first_child("FuseBoxes")
					if not i then
						return
					end
					for j, k in pairs(i:get_children()) do
						local l = k:find_first_child("Position")
						if l then
							table.insert(
								e,
								{ model = k, name = "Fuse Box", position = l.Position, inserted = d(
									k,
									"Inserted",
									false
								) }
							)
						end
					end
				end,
			},
			{
				name = "map_generators_update",
				interval = 1000,
				priority = 3,
				run = function(e, f, g)
					local h = f.cached_generators
					if not h then
						return
					end
					for i, j in ipairs(h) do
						j.progress = d(j.model, "Progress", 0)
					end
				end,
			},
			{
				name = "map_fuse_boxes_update",
				interval = 1000,
				priority = 3,
				run = function(e, f, g)
					local h = f.cached_fuseboxes
					if not h then
						return
					end
					for i, j in ipairs(h) do
						j.inserted = d(j.Model, "Inserted", false)
					end
				end,
			},
		}
	end
	function a.h()
		local b = game.GetService("Workspace")
		local c, d, e =
			b:find_first_child("PLAYERS").ALIVE, entity.get_local_player(), function(c, d, e)
				local f = c:GetAttribute(d)
				return f and f.Value or e
			end
		return {
			{
				name = "player_data_gathering",
				target = "players",
				interval = 2000,
				priority = 3,
				default = {
					name = nil,
					player = nil,
					character = nil,
					hitbox_part = nil,
					position_part = nil,
					position = nil,
					stamina = nil,
				},
				run = function(f, g, h)
					local i = entity.get_players()
					for j, k in ipairs(i) do
						local l = c:find_first_child(k.Name)
						if l then
							table.insert(
								f,
								{
									name = k.Name,
									character = l,
									humanoid = k,
									position_part = k,
									hitbox_part = l:find_first_child("Hitbox"),
									health = k.Health,
									max_health = k.MaxHealth,
									position = k.Position,
									role = e(l, "Character", "Survivor-Customer"),
									stamina = e(l, "Stamina", 100),
									max_stamina = e(l, "MaxStamina", 100),
								}
							)
						end
					end
				end,
			},
			{
				name = "player_data_updating",
				interval = 75,
				priority = 1,
				run = function(f, g, h)
					local i = g.players
					if not i then
						return
					end
					for j, k in ipairs(i) do
						k.health = k.humanoid.Health
						k.max_health = k.humanoid.MaxHealth
						k.position = k.position_part.Position
						k.role = e(k.character, "Character", "Survivor-Customer")
						k.stamina = e(k.character, "Stamina", 100)
						k.max_stamina = e(k.character, "MaxStamina", 100)
					end
				end,
			},
			{
				name = "local_data_gathering",
				target = "local_data",
				interval = 2500,
				priority = 3,
				default = {
					player = nil,
					character = nil,
					humanoid = nil,
					player_gui = nil,
					player_position = nil,
					selected_class = nil,
				},
				run = function(f, g, h)
					local i = game.LocalPlayer
					if i then
						local j = i.PlayerGui
						f.player = d
						f.player_gui = j
						f.player_position = d.Position
						local k = d:get_bone_instance("HumanoidRootPart")
						if k then
							f.character = k.Parent
							f.humanoid = f.character:find_first_child_of_class("Humanoid")
						end
					end
				end,
			},
			{
				name = "local_data_updating",
				interval = 150,
				priority = 1,
				run = function(f, g, h)
					local i = g.local_data
					if not i then
						print("couldn't find local data")
						return
					end
					i.player_position = i.player.Position
					i.selected_class = e(i.character, "Character", "Survivor-Customer")
				end,
			},
		}
	end
	function a.i()
		local b, c, d = a.load("c"), a.load("d"), { a.load("e"), a.load("f"), a.load("g"), a.load("h") }
		return function()
			for e, f in ipairs(d) do
				for g, h in ipairs(f) do
					b:Register(h.name, h)
				end
			end
			c.Add("onUpdate", function()
				b:Update()
			end)
		end
	end
	function a.j()
		local b, c = a.load("a"), {}
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
	function a.k()
		local b, c, d, e = a.load("b"), a.load("d"), a.load("j"), function(b, c)
			return (b - c).Magnitude
		end
		local f = function()
			if utility.get_menu_state() then
				return
			end
			if not d.GetValue("Auto Parry") then
				return
			end
			local f, g = d.GetValue("Auto Parry Distance"), b.killer
			if not g.character then
				return
			end
			if g.name == b.local_data.player.Name or b.local_data.selected_class ~= "Survivor-Fighter" then
				return
			end
			local h = e(g.position, b.local_data.player_position)
			if h > f then
				return
			end
			local i = g.character:find_first_child_of_class("Highlight")
			if i then
				keyboard.click("e")
			end
		end
		return function()
			c.Add("onUpdate", f)
		end
	end
	function a.l()
		local b, c, d, e = a.load("b"), a.load("d"), a.load("j"), 0
		local f = function()
			if utility.get_menu_state() then
				return
			end
			if not d.GetValue("Auto Attack") then
				return
			end
			local f, g, h = d.GetValue("Auto Attack Distance"), b.killer, utility.get_tick_count()
			if g.name ~= b.local_data.player.Name then
				return
			end
			if h - e < 1000 then
				return
			end
			for i = 1, #b.players do
				local j = b.players[i]
				if j.name ~= b.local_data.player.Name and j.health > 0 then
					local k = (j.position - b.killer.position).Magnitude
					if k <= f then
						mouse.click("leftmouse")
						e = h
					end
				end
			end
		end
		return function()
			c.Add("onUpdate", f)
		end
	end
	function a.m()
		local b, c = {}, a.load("b")
		function b:Initialise(d)
			http.Get(
				[[https://raw.githubusercontent.com/glizzymuncher57/DiddyWare/refs/heads/main/shared_offsets.lua]],
				{},
				function(e)
					if not e then
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
	function a.n()
		local b, c, d = a.load("m"), a.load("d"), function(b, c, d, e)
			return b(d.Type, c + d.Offset, e)
		end
		return function(e, f, g, h)
			if not e or not f or not g or not h then
				return
			end
			local i, j, k, l =
				b.Instance.AttributeContainer,
				b.Instance.AttributeList,
				b.Instance.AttributeToValue,
				b.Instance.AttributeToNext
			local m = d(memory.read, f.Address, i)
			if m == 0 then
				return false
			end
			local n = d(memory.read, m, j)
			if n == 0 then
				return false
			end
			local o
			o = c.Add("onUpdate", function()
				if n == 0 or n == m then
					c.Remove("onUpdate", o)
					return
				end
				local p = d(memory.read, n, { Type = "pointer", Offset = 0 })
				local q = d(memory.read, p, { Type = "string", Offset = 0 })
				if q == g then
					d(memory.write, n, { Type = e, Offset = k.Offset }, h)
					c.Remove("onUpdate", o)
					return
				end
				n = n + l.Offset
			end)
			return true
		end
	end
	function a.o()
		local b, c, d, e, f =
			a.load("b"), a.load("d"), a.load("j"), a.load("n"), function(b, c, d)
				return math.max(c, math.min(d, b))
			end
		local g = function()
			if not b.offsets_loaded then
				return
			end
			local g = entity.get_local_player()
			local h = g:get_bone_instance("HumanoidRootPart")
			local i = h and h.Parent
			if i then
				local j, k = d.GetValue("Speed Modifier"), d.GetValue("Speed Modifier Hotkey") == true
				local l, m =
					(j and k) and d.GetValue("WalkSpeed Modifier Amount") or 1,
					(j and k) and d.GetValue("RunSpeed Modifier Amount") or 1
				local n, o = f(12 * l, 0, 30), f(24 * m, 0, 50)
				e("double", i, "WalkSpeed", n)
				e("double", i, "RunSpeed", o)
			end
		end
		return function()
			c.Add("onUpdate", g)
		end
	end
	function a.p()
		local b, c, d, e = a.load("b"), a.load("d"), a.load("j"), a.load("n")
		local f = function()
			if not b.offsets_loaded then
				return
			end
			if not d.GetValue("Infinite Stamina") then
				return
			end
			local f = entity.get_local_player()
			local g = f:get_bone_instance("HumanoidRootPart")
			local h = g and g.Parent
			if h then
				e("double", h, "Stamina", 100)
			end
		end
		return function()
			c.Add("onUpdate", f)
		end
	end
	function a.q()
		local b, c, d, e = a.load("b"), {}, memory.read, memory.write
		function c.read(f, g)
			if not b.offsets_loaded then
				return
			end
			return d(g.Type, f + g.Offset)
		end
		function c.write(f, g, h)
			if not b.offsets_loaded then
				return
			end
			return e(g.Type, f + g.Offset, h)
		end
		function c.read_vector2(f, g)
			if not b.offsets_loaded then
				return Vector3.new(0, 0, 0)
			end
			local h, i = d(g.Type, f + g.X), d(g.Type, f + g.Y)
			return Vector3.new(h, i, 0)
		end
		return c
	end
	function a.r()
		local b, c, d, e, f, g, h, i =
			a.load("b"), a.load("d"), a.load("j"), a.load("m"), a.load("q"), 2.8, function(b, c)
				local d = math.huge
				for e = 1, #b do
					local f = b[e]
					if f.name == "Trap" then
						local g = (c - f.position).Magnitude
						if g < d then
							d = g
						end
					end
				end
				return d
			end
		local j = function()
			if not b.offsets_loaded then
				return
			end
			local j = b.local_data.humanoid
			if not j then
				i = nil
				return
			end
			if b.local_data.player.Name == b.killer.name then
				return
			end
			if not d.GetValue("Auto Avoid Traps") then
				if i then
					f.write(j.Address, e.Humanoid.HipHeight, i)
					i = nil
				end
				return
			end
			local k, l, m = d.GetValue("Auto Avoid Traps Distance"), b.cached_items, b.local_data.player_position
			local n = h(l, m)
			if n == math.huge then
				return
			end
			if not i then
				i = f.read(j.Address, e.Humanoid.HipHeight)
			end
			local o
			if n <= k then
				o = g
			else
				o = i or 0
			end
			f.write(j.Address, e.Humanoid.HipHeight, o)
		end
		return function()
			c.Add("onUpdate", j)
		end
	end
	function a.s()
		local b, c, d, e, f = a.load("b"), a.load("d"), a.load("j"), a.load("q"), a.load("m")
		local g = function()
			for g, h in pairs(b.local_data.player_gui:get_children()) do
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
			if not b.local_data.player_gui then
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
			c.Add("onPaint", h)
		end
	end
	function a.t()
		local b, c, d = a.load("q"), a.load("m"), a.load("j")
		return function(e)
			local f = e:find_first_child("Wires")
			if not f then
				return false
			end
			local g, h = f:find_first_child("WiresEnd"), f:find_first_child("WireBoxes")
			if not g or not h then
				return false
			end
			local i = d.GetValue("Auto Generator Mouse Speed") * 2
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
							local y, z = s.X - x[1], s.Y - x[2]
							local A = (y * y + z * z)
							if A >= 1 then
								local B = i / 100
								utility.move_mouse(y * B, z * B)
							else
								utility.move_mouse(y, z)
							end
							x = utility.get_mouse_pos()
							local B = (x[1] >= o.X and x[1] <= o.X + p.X and x[2] >= o.Y and x[2] <= o.Y + p.Y)
							if B then
								mouse.click("leftmouse")
							end
							return false
						end
						local y, z = t - x[1], u - x[2]
						local A = (y * y + z * z)
						if A >= 1 then
							local B = i / 100
							utility.move_mouse(y * B, z * B)
						else
							utility.move_mouse(y, z)
						end
						local B = utility.get_mouse_pos()
						local C = (math.abs(B[1] - t) <= 7.5 and math.abs(B[2] - u) <= 7.5)
						if not C then
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
	function a.u()
		local b, c, d = a.load("q"), a.load("m"), a.load("j")
		return function(e)
			local f = e:find_first_child("Switch")
			if not f then
				return false
			end
			local g, h = f:find_first_child("Switches"), d.GetValue("Auto Generator Mouse Speed") * 2
			for i, j in pairs(g:get_children()) do
				local k = b.read(j.Address, c.ImageButton.Image)
				if k == "rbxassetid://133499480186899" then
					local l, m =
						b.read_vector2(j.Address, c.GuiObject.AbsolutePosition),
						b.read_vector2(j.Address, c.GuiObject.AbsoluteSize)
					local n, o = l + (m / 2), utility.get_mouse_pos()
					local p, q = n.X - o[1], n.Y - o[2]
					local r = (p * p + q * q)
					if r >= 1 then
						local s = h / 100
						utility.move_mouse(p * s, q * s)
					else
						utility.move_mouse(p, q)
					end
					o = utility.get_mouse_pos()
					local s = (o[1] >= l.X and o[1] <= l.X + m.X and o[2] >= l.Y and o[2] <= l.Y + m.Y)
					if s then
						mouse.click("leftmouse")
						return false
					end
					return false
				end
			end
			return true
		end
	end
	function a.v()
		local b, c, d, e, f, g =
			a.load("q"), a.load("m"), a.load("j"), 1, function(b, c, d, e)
				return b >= d.X and b <= d.X + e.X and c >= d.Y and c <= d.Y + e.Y
			end
		local h = function()
			e = 1
			g = nil
			mouse.release("leftmouse")
		end
		return function(i)
			local j = i:find_first_child("Lever")
			local k = j and j:find_first_child("ProgressBar")
			if not k then
				h()
				return false
			end
			local l = k.Fill and k.Fill.Bar
			if not l then
				h()
				return false
			end
			local m = memory.read(c.GuiObject.Size.Type, l.Address + c.GuiObject.Size.X)
			if m > 0.9 then
				h()
				return true
			end
			local n = j:find_first_child("Rope")
			local o = n and n:find_first_child("Button")
			if not o then
				h()
				return false
			end
			local p, q, r, s =
				utility.get_mouse_pos(),
				(d.GetValue("Auto Generator Mouse Speed") or 10) * 3,
				b.read_vector2(o.Address, c.GuiObject.AbsolutePosition),
				b.read_vector2(o.Address, c.GuiObject.AbsoluteSize)
			local t = r + (s / 2)
			if not g then
				g = t
			end
			local u, v =
				b.read_vector2(j.Address, c.GuiObject.AbsolutePosition),
				b.read_vector2(j.Address, c.GuiObject.AbsoluteSize)
			local w = (e == 1) and Vector3.new(t.X, u.Y + v.Y, 0) or Vector3.new(t.X, g.Y, 0)
			if not keyboard.IsPressed("leftmouse") then
				local x, y = (t.X - p[1]), (t.Y - p[2])
				local z = math.sqrt(x * x + y * y)
				if z <= 6 and f(p[1], p[2], r, s) then
					mouse.press("leftmouse")
				else
					local A = q / 100
					utility.move_mouse(x * A, y * A)
				end
				return false
			end
			local x, y = (w.X - p[1]), (w.Y - p[2])
			local z = math.sqrt(x * x + y * y)
			if z >= 1 then
				local A = q / 100
				utility.move_mouse(x * A, y * A)
			else
				utility.move_mouse(x * 0.5, y * 0.5)
			end
			p = utility.get_mouse_pos()
			local A = math.abs(p[2] - w.Y) <= 5
			if A then
				e = -e
			end
			return false
		end
	end
	function a.w()
		local b, c, d, e =
			a.load("b"), a.load("d"), a.load("j"), { Wires = a.load("t"), Switches = a.load("u"), Pull = a.load("v") }
		local f = function()
			if utility.get_menu_state() then
				return
			end
			if not d.GetValue("Auto Generator") then
				return
			end
			local f = b.local_data.player_gui
			if not f then
				return
			end
			local g = f:find_first_child("Gen")
			if not g then
				return
			end
			local h = g:find_first_child("MainFrame")
			if not h then
				return
			end
			local i = h:find_first_child("Generator")
			if i then
				local j = e.Wires(i)
				if j then
					local k = e.Switches(i)
					if k then
						e.Pull(i)
					end
				end
			end
		end
		return function()
			c.Add("onUpdate", f)
		end
	end
	function a.x()
		local b, c, d, e = a.load("b"), a.load("d"), a.load("j"), a.load("c")
		local f, g, h =
			function()
				local f = (b.local_data.player.Name == b.killer.name)
				return f and b.killer.position or b.local_data.player_position
			end, function(f)
				local g = draw.get_part_corners(f)
				if g then
					local h = {}
					for i, j in ipairs(g) do
						local k, l, m = utility.world_to_screen(j)
						if m then
							table.insert(h, { k, l })
						end
					end
					if #h >= 3 then
						local i = draw.compute_convex_hull(h)
						if i and #i >= 2 then
							return i
						end
					end
				end
				return nil
			end, function(f)
				local g = draw.get_part_corners(f)
				if not g then
					return nil
				end
				local h, i, j, k = math.huge, math.huge, -math.huge, -math.huge
				for l, m in ipairs(g) do
					local n, o, p = utility.world_to_screen(m)
					if p then
						if n < h then
							h = n
						end
						if o < i then
							i = o
						end
						if n > j then
							j = n
						end
						if o > k then
							k = o
						end
					end
				end
				if h == math.huge then
					return nil
				end
				return { x = h, y = i, w = (j - h), h = (k - i) }
			end
		local i = function()
			local i, j = d.GetValue("Visuals Enabled"), d.GetValue("Player ESP")
			if not i or not j then
				return
			end
			local k, l, m, n, o, p, q, r, s, t, u, v, w, x, y, z, A =
				d.GetValue("Player Name"),
				d.GetValue("Player Box"),
				d.GetValue("Player Filled Box"),
				d.GetValue("Player Stamina Bar"),
				d.GetValue("Player Health Bar"),
				d.GetValue("Show Distance"),
				d.GetValue("Box Type"),
				d.GetValue("Player Name Colour"),
				d.GetValue("Player Box Colour"),
				d.GetValue("Player Filled Box Colour A"),
				d.GetValue("Player Filled Box Colour B"),
				d.GetValue("Player Stamina Bar Colour A"),
				d.GetValue("Player Stamina Bar Colour B"),
				d.GetValue("Player Health Bar Colour A"),
				d.GetValue("Player Health Bar Colour B"),
				d.GetValue("Distance Colour"),
				b.players
			if not A or #A < 1 then
				return
			end
			for B = 1, #A do
				local C = A[B]
				if C.name ~= b.local_data.player.Name then
					local D, E, F = utility.world_to_screen(C.position)
					if F then
						if C.hitbox_part and C.health > 0 then
							local G = h(C.hitbox_part)
							if G then
								if l or m then
									if q == "3D" then
										local H = g(C.hitbox_part)
										draw.polyline(H, e:create_colour(s.r, s.g, s.b), true, 1.5, s.a)
										if m then
											draw.ConvexPolyFilled(H, e:create_colour(t.r, t.g, t.b), t.a)
										end
									else
										draw.rect(G.x, G.y, G.w, G.h, e:create_colour(s.r, s.g, s.b), nil, nil, s.a)
										draw.rect(
											G.x - 1,
											G.y - 1,
											G.w + 2,
											G.h + 2,
											e:create_colour(0, 0, 0),
											1,
											0,
											s.a
										)
										draw.rect(
											G.x + 1,
											G.y + 1,
											G.w - 2,
											G.h - 2,
											e:create_colour(0, 0, 0),
											1,
											0,
											s.a
										)
										if m then
											draw.gradient(
												G.x,
												G.y,
												G.w,
												G.h,
												e:create_colour(t.r, t.g, t.b),
												e:create_colour(u.r, u.g, u.b),
												false,
												t.a,
												u.a
											)
										end
									end
								end
								if k then
									local H, I = e:get_text_size(C.name, "Tahoma")
									local J, K = G.x + (G.w / 2) - (H / 2), G.y - I - 2
									draw.text_outlined(C.name, J, K, e:create_colour(r.r, r.g, r.b), "Tahoma", r.a)
								end
								if p then
									local H = (C.position - f()).Magnitude
									local I = "" .. tostring(math.floor(H)) .. "m"
									local J, K = e:get_text_size(I, "SmallestPixel")
									local L, M = G.x + (G.w / 2) - (J / 2), G.y + G.h + 2
									draw.text_outlined(I, L, M, e:create_colour(z.r, z.g, z.b), "SmallestPixel", z.a)
								end
								if o then
									local H, I, J, K = 6, G.h, C.health, C.max_health
									local L = math.clamp(J / K, 0, 1)
									local M, N, O = I * L, G.x - H - 2, G.y
									draw.rect_filled(N, O, H, I, e:create_colour(0, 0, 0), nil, 255)
									local P = math.max(H - 2, 1)
									if M > 0 then
										draw.gradient(
											N + 1,
											O + (I - M) + 1,
											P,
											M,
											e:create_colour(x.r, x.g, x.b),
											e:create_colour(y.r, y.g, y.b),
											false,
											x.a,
											y.a
										)
									end
									local Q = tostring(math.floor(J))
									local R = e:get_text_size(Q, "SmallestPixel")
									draw.TextOutlined(
										Q,
										N - R - 2,
										O + (I - M),
										e:create_colour(255, 255, 255),
										"SmallestPixel",
										255
									)
								end
								if n then
									local H, I, J, K = 6, G.h, C.stamina, 100
									local L = math.clamp(J / K, 0, 1)
									local M, N, O = I * L, G.x + G.w + 2, G.y
									draw.rect_filled(N, O, H, I, e:create_colour(0, 0, 0), nil, 255)
									draw.gradient(
										N + 1,
										O + (I - M) + 1,
										math.max(H - 2, 1),
										M,
										e:create_colour(v.r, v.g, v.b),
										e:create_colour(w.r, w.g, w.b),
										false,
										v.a,
										w.a
									)
									draw.TextOutlined(
										tostring(math.floor(J)),
										N + H + 2,
										O + (I - M),
										e:create_colour(255, 255, 255),
										"SmallestPixel",
										255
									)
								end
							end
						end
					end
				end
			end
		end
		return function()
			c.Add("onPaint", i)
		end
	end
	function a.y()
		local b, c, d, e, f, g =
			a.load("b"), a.load("d"), a.load("j"), a.load("c"), function(b)
				local c = draw.get_part_corners(b)
				if c then
					local d = {}
					for e, f in ipairs(c) do
						local g, h, i = utility.world_to_screen(f)
						if i then
							table.insert(d, { g, h })
						end
					end
					if #d >= 3 then
						local e = draw.compute_convex_hull(d)
						if e and #e >= 2 then
							return e
						end
					end
				end
				return nil
			end, function(b)
				local c = draw.get_part_corners(b)
				if not c then
					return nil
				end
				local d, e, f, g = math.huge, math.huge, -math.huge, -math.huge
				for h, i in ipairs(c) do
					local j, k, l = utility.world_to_screen(i)
					if l then
						if j < d then
							d = j
						end
						if k < e then
							e = k
						end
						if j > f then
							f = j
						end
						if k > g then
							g = k
						end
					end
				end
				if d == math.huge then
					return nil
				end
				return { x = d, y = e, w = (f - d), h = (g - e) }
			end
		local h = function()
			local h, i = d.GetValue("Visuals Enabled"), d.GetValue("Killer ESP")
			if not h or not i then
				return
			end
			local j, k, l, m, n, o, p, q, r, s, t, u, v, w =
				d.GetValue("Killer Name"),
				d.GetValue("Killer Box"),
				d.GetValue("Killer Filled Box"),
				d.GetValue("Killer Stamina Bar"),
				d.GetValue("Show Distance"),
				d.GetValue("Box Type"),
				d.GetValue("Killer Name Colour"),
				d.GetValue("Killer Box Colour"),
				d.GetValue("Killer Filled Box Colour A"),
				d.GetValue("Killer Filled Box Colour B"),
				d.GetValue("Killer Stamina Bar Colour A"),
				d.GetValue("Killer Stamina Bar Colour B"),
				d.GetValue("Distance Colour"),
				b.killer
			if not w.character then
				return
			end
			if b.local_data.player.Name == w.name then
				return
			end
			local x, y, z = utility.world_to_screen(w.position)
			if z then
				local A = g(w.hitbox_part)
				if A then
					if k or l then
						if o == "3D" then
							local B = f(w.hitbox_part)
							draw.polyline(B, e:create_colour(q.r, q.g, q.b), true, 1.5, q.a)
							if l then
								draw.ConvexPolyFilled(B, e:create_colour(r.r, r.g, r.b), r.a)
							end
						else
							draw.rect(A.x, A.y, A.w, A.h, e:create_colour(q.r, q.g, q.b), nil, nil, q.a)
							draw.rect(A.x - 1, A.y - 1, A.w + 2, A.h + 2, e:create_colour(0, 0, 0), 1, 0, q.a)
							draw.rect(A.x + 1, A.y + 1, A.w - 2, A.h - 2, e:create_colour(0, 0, 0), 1, 0, q.a)
							if l then
								draw.gradient(
									A.x,
									A.y,
									A.w,
									A.h,
									e:create_colour(r.r, r.g, r.b),
									e:create_colour(s.r, s.g, s.b),
									false,
									r.a,
									s.a
								)
							end
						end
					end
					if j then
						local B, C = e:get_text_size(w.name, "Tahoma")
						local E, F = A.x + (A.w / 2) - (B / 2), A.y - C - 2
						draw.text_outlined(w.name, E, F, e:create_colour(p.r, p.g, p.b), "Tahoma", p.a)
					end
					if n then
						local B = (w.position - b.local_data.player_position).Magnitude
						local C = tostring(math.floor(B)) .. "m"
						local E, F = e:get_text_size(C, "SmallestPixel")
						local G, H = A.x + (A.w / 2) - (E / 2), A.y + A.h + 2
						draw.text_outlined(C, G, H, e:create_colour(v.r, v.g, v.b), "SmallestPixel", v.a)
					end
					if m then
						local B, C, E, F = 6, A.h, w.stamina, 70
						local G = math.clamp(E / F, 0, 1)
						local H, I, J = C * G, A.x + A.w + 2, A.y
						draw.rect_filled(I, J, B, C, e:create_colour(0, 0, 0), nil, 255)
						draw.gradient(
							I + 1,
							J + (C - H) + 1,
							math.max(B - 2, 1),
							H,
							e:create_colour(t.r, t.g, t.b),
							e:create_colour(u.r, u.g, u.b),
							false,
							t.a,
							u.a
						)
						draw.TextOutlined(
							tostring(math.floor(E)),
							I + B + 2,
							J + (C - H),
							e:create_colour(255, 255, 255),
							"SmallestPixel",
							255
						)
					end
				end
			end
		end
		return function()
			c.Add("onPaint", h)
		end
	end
	function a.z()
		local b, c, d, e = a.load("b"), a.load("d"), a.load("j"), a.load("c")
		local f, g =
			function()
				local f = (b.local_data.player.Name == b.killer.name)
				return f and b.killer.position or b.local_data.player_position
			end, function(f, g)
				if not f or not g then
					return 0
				end
				return (f - g).Magnitude
			end
		local h = function()
			local h, i, j, k, l, m, n, o =
				d.GetValue("Visuals Enabled"),
				d.GetValue("Show Distance"),
				d.GetValue("Distance Colour"),
				d.GetValue("Generator ESP"),
				d.GetValue("Generator Colour"),
				d.GetValue("Generator Progress"),
				d.GetValue("Generator Progress Colour"),
				d.GetValue("ESP Font Selection")
			if not h or not k then
				return
			end
			for p = 1, #b.cached_generators do
				local q = b.cached_generators[p]
				local r = q.progress or 0
				if r < 100 then
					local s, t, u = utility.world_to_screen(q.position)
					if u then
						local v = q.name
						local w, y = e:get_text_size(v, o)
						local z, A = "", 0
						if i then
							local B = f()
							local C = g(B, q.position)
							z = "[" .. tostring(math.floor(C)) .. "m]"
							A = e:get_text_size(z, o)
						end
						local B = w + A
						local C = s - (B / 2)
						draw.text_outlined(v, C, t, e:create_colour(l.r, l.g, l.b), o, l.a)
						if i then
							draw.text_outlined(z, C + w, t, e:create_colour(j.r, j.g, j.b), o, j.a)
						end
						if m then
							local E = tostring(r) .. "%"
							local F = draw.get_text_size(E, o)
							local G, H = s - (F / 2), t + y
							draw.text_outlined(E, G, H, e:create_colour(n.r, n.g, n.b), o, n.a)
						end
					end
				end
			end
		end
		return function()
			c.Add("onPaint", h)
		end
	end
	function a.A()
		local b, c, d, e = a.load("b"), a.load("d"), a.load("j"), a.load("c")
		local f, g =
			function()
				local f = (b.local_data.player.Name == b.killer.name)
				return f and b.killer.position or b.local_data.player_position
			end, function(f, g)
				if not f or not g then
					return 0
				end
				return (f - g).Magnitude
			end
		local h = function()
			local h, i, j, k, l, m =
				d.GetValue("Visuals Enabled"),
				d.GetValue("Show Distance"),
				d.GetValue("Distance Colour"),
				d.GetValue("Fuse Box ESP"),
				d.GetValue("Fuse Box Colour"),
				d.GetValue("ESP Font Selection")
			if not h or not k then
				return
			end
			for n = 1, #b.cached_fuseboxes do
				local o = b.cached_fuseboxes[n]
				local p = o.inserted
				if not p then
					local q, r, s = utility.world_to_screen(o.position)
					if s then
						local t = o.name
						local u, v = e:get_text_size(t, m)
						local w, y = "", 0
						if i then
							local z = f()
							local A = g(z, o.position)
							w = "[" .. tostring(math.floor(A)) .. "m]"
							y = e:get_text_size(w, m)
						end
						local z = u + y
						local A = q - (z / 2)
						draw.text_outlined(t, A, r, e:create_colour(l.r, l.g, l.b), m, l.a)
						if i then
							draw.text_outlined(w, A + u, r, e:create_colour(j.r, j.g, j.b), m, j.a)
						end
					end
				end
			end
		end
		return function()
			c.Add("onPaint", h)
		end
	end
	function a.B()
		local b, c, d, e = a.load("b"), a.load("d"), a.load("j"), a.load("c")
		local f, g =
			function()
				local f = (b.local_data.player.Name == b.killer.name)
				return f and b.killer.position or b.local_data.player_position
			end, function(f, g)
				if not f or not g then
					return 0
				end
				return (f - g).Magnitude
			end
		local h = function()
			local h, i, j, k, l, m =
				d.GetValue("Visuals Enabled"),
				d.GetValue("Show Distance"),
				d.GetValue("Distance Colour"),
				d.GetValue("Item ESP"),
				d.GetValue("Item Colour"),
				d.GetValue("ESP Font Selection")
			if not h or not k then
				return
			end
			for n = 1, #b.cached_items do
				local o = b.cached_items[n]
				local p, q, r = utility.world_to_screen(o.position or o.render_part.position)
				if r then
					local s = o.name
					local t, u, v = e:get_text_size(s, m), "", 0
					if i then
						local w = f()
						local y = g(w, o.position)
						u = "[" .. tostring(math.floor(y)) .. "m]"
						v = e:get_text_size(u, m)
					end
					local w = t + v
					local y = p - (w / 2)
					draw.text_outlined(s, y, q, e:create_colour(l.r, l.g, l.b), m, l.a)
					if i then
						draw.text_outlined(u, y + t, q, e:create_colour(j.r, j.g, j.b), m, j.a)
					end
				end
			end
		end
		return function()
			c.Add("onPaint", h)
		end
	end
	function a.C()
		local b, c, d, e, f, g, h, i, j, k, l, m, n =
			{},
			a.load("k"),
			a.load("l"),
			a.load("o"),
			a.load("p"),
			a.load("r"),
			a.load("s"),
			a.load("w"),
			a.load("x"),
			a.load("y"),
			a.load("z"),
			a.load("A"),
			a.load("B")
		function b:Initialise()
			c()
			d()
			e()
			f()
			g()
			i()
			h()
			j()
			k()
			l()
			m()
			n()
		end
		return b
	end
	function a.D()
		local b, c, d, e = a.load("d"), a.load("j"), a.load("a"), {}
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
				local m = setmetatable({ TabRef = i, ContainerRef = j, Name = k, Debug = l and l.Debug }, h)
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
							local y = v(p, ...)
							n[s][#n[s] + 1] = y
							if s ~= o then
								y:Visible(false)
							end
							return y
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
			return setmetatable({
				Ref = l,
			}, k)
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
	function a.E()
		local b, c, d = {}, "Features_DiddyWare", "Features"
		function b:Initialise(e)
			local f = e:Container(c, d, {
				autosize = true,
				next = true,
			})
			local g = f:Page("Feature Menu", { "Combat", "Automation", "Movement" })
			local h, i, j = g:For("Combat"), g:For("Automation"), g:For("Movement")
			local k, l, m, n, o =
				h:Checkbox("Auto Parry"),
				h:SliderInt("Auto Parry Distance", 1, 20, 10),
				h:Checkbox("Auto Attack"),
				h:SliderInt("Auto Attack Distance", 1, 20, 5),
				i:Checkbox("Auto Door Hold")
			i:KeyPicker("Auto Door Hold Hotkey", true)
			local p, q, r, s, t, u =
				i:SliderInt("Auto Door Hold Speed", 1, 5, 5),
				i:Checkbox("Auto Generator"),
				i:SliderInt("Auto Generator Mouse Speed", 1, 25, 15),
				j:Checkbox("Auto Avoid Traps"),
				j:SliderInt("Auto Avoid Traps Distance", 1, 10, 10),
				j:Checkbox("Speed Modifier")
			j:KeyPicker("Speed Modifier Hotkey", true)
			local v, w =
				j:SliderFloat("WalkSpeed Modifier Amount", 1, 3, 1), j:SliderFloat("RunSpeed Modifier Amount", 1, 2, 1)
			j:Checkbox("Infinite Stamina")
			k:OnChange(function(y)
				l:Visible(y)
			end)
			m:OnChange(function(y)
				n:Visible(y)
			end)
			o:OnChange(function(y)
				p:Visible(y)
			end)
			q:OnChange(function(y)
				r:Visible(y)
			end)
			u:OnChange(function(y)
				v:Visible(y)
				w:Visible(y)
			end)
			s:OnChange(function(y)
				t:Visible(y)
			end)
		end
		return b
	end
	function a.F()
		local b, c, d = {}, "VisualsTab_DiddyWare", "Visuals"
		function b:Initialise(e)
			local f = e:Container(c, d, { autosize = true, next = true })
			local g = f:Page("Visuals Page", { "Main", "Players", "Killer", "World" })
			local h, i, j, k = g:For("Main"), g:For("Players"), g:For("Killer"), g:For("World")
			h:Checkbox("Visuals Enabled")
			h:Checkbox("Show Distance")
			h:Colorpicker("Distance Colour", { r = 255, g = 255, b = 255, a = 255 }, true)
			h:Dropdown("Box Type", { "2D", "3D" }, 1)
			i:Checkbox("Player ESP")
			i:Checkbox("Player Name")
			i:Colorpicker("Player Name Colour", { r = 255, g = 255, b = 255, a = 255 }, true)
			i:Checkbox("Player Box")
			i:Colorpicker("Player Box Colour", { r = 0, g = 255, b = 120, a = 255 }, true)
			i:Checkbox("Player Filled Box")
			i:Colorpicker("Player Filled Box Colour A", { r = 0, g = 255, b = 120, a = 140 }, true)
			i:Colorpicker("Player Filled Box Colour B", { r = 0, g = 200, b = 90, a = 140 }, true)
			i:Checkbox("Player Stamina Bar")
			i:Colorpicker("Player Stamina Bar Colour A", {
				r = 0,
				g = 170,
				b = 255,
				a = 255,
			}, true)
			i:Colorpicker("Player Stamina Bar Colour B", { r = 0, g = 90, b = 200, a = 255 }, true)
			i:Checkbox("Player Health Bar")
			i:Colorpicker("Player Health Bar Colour A", { r = 0, g = 255, b = 0, a = 255 }, true)
			i:Colorpicker("Player Health Bar Colour B", { r = 255, g = 0, b = 0, a = 255 }, true)
			j:Checkbox("Killer ESP")
			j:Checkbox("Killer Name")
			j:Colorpicker("Killer Name Colour", { r = 255, g = 220, b = 220, a = 255 }, true)
			j:Checkbox("Killer Box")
			j:Colorpicker("Killer Box Colour", { r = 255, g = 0, b = 0, a = 255 }, true)
			j:Checkbox("Killer Filled Box")
			j:Colorpicker("Killer Filled Box Colour A", { r = 255, g = 60, b = 60, a = 160 }, true)
			j:Colorpicker("Killer Filled Box Colour B", { r = 180, g = 0, b = 0, a = 160 }, true)
			j:Checkbox("Killer Stamina Bar")
			j:Colorpicker("Killer Stamina Bar Colour A", { r = 80, g = 140, b = 255, a = 255 }, true)
			j:Colorpicker("Killer Stamina Bar Colour B", { r = 20, g = 80, b = 200, a = 255 }, true)
			k:Checkbox("Generator ESP")
			k:Colorpicker("Generator Colour", { r = 255, g = 140, b = 0, a = 255 }, true)
			k:Checkbox("Generator Progress")
			k:Colorpicker("Generator Progress Colour", { r = 255, g = 255, b = 255, a = 255 }, true)
			k:Checkbox("Fuse Box ESP", false)
			k:Colorpicker("Fuse Box Colour", { r = 0, g = 120, b = 255, a = 255 }, true)
			k:Checkbox("Item ESP", false)
			k:Colorpicker("Item Colour", { r = 120, g = 120, b = 120, a = 255 }, true)
		end
		return b
	end
	function a.G()
		local b, c, d = {}, "Settings_DiddyWare", "Settings"
		function b:Initialise(e)
			local f = e:Container(c, d, { autosize = true })
			f:Dropdown("ESP Font Selection", { "ConsolasBold", "SmallestPixel", "Verdana", "Tahoma" }, 1)
		end
		return b
	end
	function a.H()
		local b, c, d, e, f = {}, a.load("D"), a.load("E"), a.load("F"), a.load("G")
		function b:Initialise()
			local g = c.NewTab("DiddyWare_JB", "DiddyWare")
			d:Initialise(g)
			e:Initialise(g)
			f:Initialise(g)
		end
		return b
	end
	function a.I()
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
	a.load("i"), a.load("C"), a.load("H"), a.load("m"), a.load("d"), a.load("a"), a.load("I"), a.load("D")
local j = function()
	h()
	f:Initialise()
	i:Initialise()
	c:Initialise()
	d:Initialise()
	b()
	f.Add("shutdown", function()
		f.ClearAll()
		g:UnloadAll()
		entity.clear_models()
	end)
end
e:Initialise(j)
