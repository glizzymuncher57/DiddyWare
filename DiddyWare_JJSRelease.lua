--!nocheck
--!nolint

_P = {
	genDate = "2026-01-29T20:00:42.392883900+00:00",
	cfg = "Release",
	vers = "",
}

local a a={cache={},load=function(b)if not a.cache[b]then a.cache[b]={c=a[b]()}
end return a.cache[b].c end}do function a.a()return{Font='ConsolasBold',
LocalInfo={Player=nil,PlayerGui=nil,Character=nil,SelectedCharacter=nil,Ping=0},
Players={},Folders={Items={},Domains={}},ClosestDomain={Instance=nil,Distance=
math.huge}}end function a.b()local b,c={Enabled=false,LastClick=0,Delay=200},a.
load'a'local d=c.LocalInfo.PlayerGui function b.Runtime()if not b.Enabled then
return end local e=utility.GetTickCount()if(e-b.LastClick)<b.Delay then return
end if not d then d=c.LocalInfo.Player.PlayerGui return end local f=d:
FindFirstChild'QTE'if not f then return end local g=f:FindFirstChild'QTE_PC'if
not g then return end local h=g.Value if not h or h==''then return end local i=
tostring(h):lower()keyboard.click(i)b.LastClick=e end function b.Initialise(e)
local f,g=e:Checkbox'Lawyer QTE',e:SliderInt('QTE Delay (ms)',1,200,200)cheat.
register('onUpdate',function()b.Runtime()b.Enabled=f:Get()b.Delay=g:Get()end)end
return b end function a.c()return{ScreenGui_Enabled=0x654,Frame_PositionX=0x528,
Frame_PositionY=0x530,Frame_SizeX=0x548,Frame_SizeY=0x54c,Frame_Rotation=0x188}
end function a.d()local b,c=a.load'c',{}function c.GetFramePosition(d)local e=d.
Address return Vector3.new(memory.read('float',e+b.Frame_PositionX),memory.read(
'float',e+b.Frame_PositionY),0)end function c.GetFrameSize(d)local e=d.Address
return Vector3.new(memory.read('float',e+b.Frame_SizeX),memory.read('float',e+b.
Frame_SizeY),0)end function c.GetFrameCenter(d)local e,f=c.GetFramePosition(d),c
.GetFrameSize(d)return e+(f/2)end function c.GetFrameRotation(d)return memory.
read('float',d.Address+b.Frame_Rotation)end return c end function a.e()local b,c
,d,e={Enabled=false,Tolerance=0.03,CurrentAddress=nil,PressedR=false},a.load'c',
a.load'd',a.load'a'function b.Runtime()if e.LocalInfo.SelectedCharacter~=
'Nanami'then return end if not b.Enabled then return end local f=entity.
GetPlayers(false)for g,h in pairs(f)do coroutine.resume(coroutine.create(
function()local i=h:GetBoneInstance'HumanoidRootPart'if not i then return end
local j=i:FindFirstChild'Ratio'if not j then return end if not memory.read(
'bool',j.Address+c.ScreenGui_Enabled)then return end if not b.CurrentAddress or
b.CurrentAddress~=j.Address then b.CurrentAddress=j.Address b.PressedR=false end
local k=j:FindFirstChild'Bar'if not k then return end local l,m=k:FindFirstChild
'Bar',k:FindFirstChild'Cursor'if not l or not m then return end local n,o,p,q=d.
GetFrameCenter(l),d.GetFrameSize(l),d.GetFrameRotation(l),d.GetFrameCenter(m)
local r,s=p>0,math.rad(p)local t,u,v,w=math.cos(s),(math.sin(s))if r then v=n.X-
t*(o.X/2)w=n.Y-u*(o.X/2)else v=n.X+t*(o.X/2)w=n.Y+u*(o.X/2)end local x,y,z=q.X-v
,q.Y-w,r and 1 or-1 local A=(x*t+y*u)*z local B=A/o.X B=math.clamp(B,0,1)if math
.abs(B-0.3)<=b.Tolerance and not b.PressedR then keyboard.click'r'b.PressedR=
true end end))end end function b.Initialise(f)local g,h=f:Checkbox'Nanami QTE',f
:SliderFloat('Nanami QTE Tolerance',0,0.1,0.03)cheat.Register('onPaint',b.
Runtime)cheat.Register('onUpdate',function()b.Enabled=g:Get()b.Tolerance=h:Get()
end)end return b end function a.f()local b,c,d,e,f,g={LastRebuild=0},a.load'a',
entity.GetLocalPlayer(),{},{},function(b,c,d)local e=b:GetAttribute(c)return e
and e.Value or d end local h=function(h,i)if not h or not h.Name then return end
local j=h:GetBoneInstance'HumanoidRootPart'if not j then return end local k=j.
Parent if not k then return end local l=k:FindFirstChild'Moveset'if not l then
return end local m=c.Players[h.Name]local n,o,p=m and m.Moves or nil,{},{}for q,
r in pairs(l:GetChildren())do local s,t,u=r.Name,g(r,'Key',1),r.Value or 0 local
v,w=n and n[s],h.UserId..':'..s local x={Name=s,Key=t,Cooldown=u,Instance=r,
MoveKey=w,IsOnCooldown=v and v.IsOnCooldown or false,Remaining=v and v.Remaining
or 0}o[#o+1]=x p[s]=x end table.sort(o,function(q,r)return q.Key<r.Key end)i[h.
Name]={Player=h,Character=k,SelectedMoveset=g(k,'Moveset','[???]'),Evade=g(k,
'Evade',50),Moves=p,OrderedMoves=o}end local i,j=function()local i,j={},entity.
GetLocalPlayer()if j then h(j,i)end for k,l in pairs(entity.GetPlayers(false))do
h(l,i)end c.Players=i end,function()local i=utility.GetTickCount()/1000 for j,k
in pairs(c.Players)do for l,m in pairs(k.Moves)do local n=m.Instance if n then
local o,p=g(n,'LastUse',0),m.MoveKey if o~=e[p]then e[p]=o f[p]=i end local q=f[
p]if q then local r=i-q if r<m.Cooldown then m.IsOnCooldown=true m.Remaining=m.
Cooldown-r else m.IsOnCooldown=false m.Remaining=0 end else m.IsOnCooldown=false
m.Remaining=0 end end end end end function b:ReturnLocalPlayer()return c.Players
[d.Name]end function b:DoesPlayerHaveMove(k,l)if not k or not l then return
false,nil end local m=c.Players[k.Name]if not m or not m.Moves then return false
,nil end local n=m.Moves[l]if not n then return false,nil end return true,n end
function b:IsMoveUsable(k,l)local m,n=b:DoesPlayerHaveMove(k,l)if not m then
return false end return not n.IsOnCooldown end function b.Initialise(k)local l=k
:SliderFloat('Rebuild Player Cache Interval (s)',0.05,1,0.15)cheat.Register(
'onUpdate',function()local m,n=utility.GetTickCount(),l:Get()*1000 j()if(m-b.
LastRebuild)>=n then b.LastRebuild=m i()end end)end return b end function a.g()
local b,c,d,e={Enabled=false,Timings={Itadori=0.285,Mahito=0.285},_Waiting=false
,_NextPressTime=0,_WasDown=false},entity.GetLocalPlayer(),a.load'a',a.load'f'
function b.Runtime()if not b.Enabled then return end local f=d.LocalInfo.
SelectedCharacter if f~='Mahito'and f~='Itadori'then return end local g,h=
utility.GetTickCount(),keyboard.IsPressed(0x33)if not e:DoesPlayerHaveMove(c,
'Focus Strike')and not e:DoesPlayerHaveMove(c,'Divergent Fist')then return end
if h and not b._WasDown and not b._Waiting then local i=b.Timings[f]or 0 local j
,k=i*1000,d.LocalInfo.Ping or 0 j=j-k if j<0 then j=0 end b._NextPressTime=g+j b
._Waiting=true end if b._Waiting and g>=b._NextPressTime then keyboard.Click(
0x33)b._Waiting=false end b._WasDown=h end function b.Initialise(f)local g=f:
Checkbox('Auto Blackflash',false)cheat.Register('onPaint',function()b.Runtime()
end)cheat.Register('onUpdate',function()b.Enabled=g:Get()end)end return b end
function a.h()local b,c={},{}c.__index=c function c:Get()return ui.getValue(self
.TabRef,self.ContainerRef,self.Name)end function c:Set(d)ui.setValue(self.TabRef
,self.ContainerRef,self.Name,d)end function c:Visible(d)ui.setVisibility(self.
TabRef,self.ContainerRef,self.Name,d)end local d={}d.__index=d local e=function(
e,f,g)return setmetatable({TabRef=e,ContainerRef=f,Name=g},c)end function d:
Checkbox(f,g)ui.newCheckbox(self.TabRef,self.Ref,f,g)return e(self.TabRef,self.
Ref,f)end function d:SliderInt(f,g,h,i)ui.newSliderInt(self.TabRef,self.Ref,f,g,
h,i)return e(self.TabRef,self.Ref,f)end function d:SliderFloat(f,g,h,i)ui.
newSliderFloat(self.TabRef,self.Ref,f,g,h,i)return e(self.TabRef,self.Ref,f)end
function d:Dropdown(f,g,h)ui.newDropdown(self.TabRef,self.Ref,f,g,h)local i=e(
self.TabRef,self.Ref,f)i.Get=function()local j=ui.getValue(self.TabRef,self.Ref,
f)return g[j+1]end return i end function d:Multiselect(f,g)ui.newMultiselect(
self.TabRef,self.Ref,f,g)local h=e(self.TabRef,self.Ref,f)h.Get=function()local
i,j=ui.getValue(self.TabRef,self.Ref,f),{}for k,l in ipairs(i)do if l then j[g[k
] ]=true end end return j end return h end function d:Colorpicker(f,g,h)ui.
newColorpicker(self.TabRef,self.Ref,f,g,h)local i=e(self.TabRef,self.Ref,f)i.Get
=function(j,k)k=(tostring(k)or'table'):lower()if k=='rgb'then local l=ui.
getValue(self.TabRef,self.Ref,f)return Color3.fromRGB(l.r,l.g,l.b)end return ui.
getValue(self.TabRef,self.Ref,f)end return i end function d:InputText(f,g)ui.
newInputText(self.TabRef,self.Ref,f,g)return e(self.TabRef,self.Ref,f)end
function d:Button(f,g)ui.newButton(self.TabRef,self.Ref,f,g)local h=e(self.
TabRef,self.Ref,f)h.Get=nil h.Set=nil return h end function d:Listbox(f,g,h)ui.
newListbox(self.TabRef,self.Ref,f,g,function()if h then local i=ui.getValue(self
.TabRef,self.Ref,f)local j=g[i+1]h(j)end end)return e(self.TabRef,self.Ref,f)end
function d:KeyPicker(f,g,...)ui.newHotkey(self.TabRef,self.Ref,f,g)local h=e(
self.TabRef,self.Ref,f)h.Get=function(i,j)if not j then j='Value'end local k={
self.TabRef,self.Ref,f}return j=='Value'and ui.getValue(unpack(k))or ui.
getHotkey(unpack(k))end return h end local f={}f.__index=f function f:Container(
g,h,i)ui.newContainer(self.Ref,g,h,i or{})return setmetatable({TabRef=self.Ref,
Ref=g},d)end function b.NewTab(g,h)ui.newTab(g,h)return setmetatable({Ref=g},f)
end return b end function a.i()local b,c,d,e,f={Enabled=false,DrawCooldowns=
false,DrawEvasiveBar=false,CooldownFillColour=Color3.fromRGB(255,0,0),
CooldownFillAlpha=180,CooldownBackgroundColour=Color3.fromRGB(0,0,0),
CooldownBackgroundAlpha=0,EvasiveBarColour=Color3.fromRGB(121,74,148)},a.load'a'
,Color3.new(0,0,0),Color3.new(1,1,1),function(b)if type(b)~='table'then return
Color3.fromRGB(255,255,255)end local c,d,e=b.R or b.r or 255,b.G or b.g or 255,b
.B or b.b or 255 return Color3.fromRGB(c,d,e)end function b.DrawPlayer(g,h)if
not g.IsAlive then return end local i,j,k=utility.WorldToScreen(g.Position)if
not k then return end local l=g.BoundingBox if not l then return end if b.
DrawEvasiveBar and h.Evade then local m=math.clamp(h.Evade/50,0,1)local n,o,p,q=
l.h*m,l.x-8,l.y,l.h draw.RectFilled(o-1,p-1,7,q+2,d,0,255)draw.RectFilled(o,p+q-
n,5,n,b.EvasiveBarColour,0,255)local r=tostring(math.floor(m*100))..'%'local s=
draw.GetTextSize(r,c.Font)draw.TextOutlined(r,o-s-2,p,e,c.Font)end if b.
DrawCooldowns and#h.OrderedMoves>0 then local m=#h.OrderedMoves local n,o,p=l.h/
m,l.x+l.w+2,l.y for q=1,#h.OrderedMoves do local r=h.OrderedMoves[q]local s,t=r.
Remaining,p+(q-1)*n draw.RectFilled(o,t,n,n,b.CooldownBackgroundColour,0,b.
CooldownBackgroundAlpha)if s>0 then local u=s/r.Cooldown local v=n*u draw.
RectFilled(o+n-v,t,v,n,b.CooldownFillColour,0,b.CooldownFillAlpha)end draw.Rect(
o,t,n,n,e)local u=r.Name local v,w=draw.GetTextSize(u,c.Font)local x,y=o+(n-v)/2
,t+(n-w)/2 draw.TextOutlined(u,x,y,e,c.Font)end end end function b.Draw()if not
b.Enabled then return end for g,h in pairs(entity.GetPlayers(false))do local j=c
.Players[h.Name]if j then b.DrawPlayer(h,j)end end end function b.Initialise(g)
local h,j,k,l,m,n=g:Checkbox('Character Info',false),g:Checkbox('Cooldowns',
false),g:Colorpicker('Cooldown Fill Color',{r=255,g=0,b=0,a=180},true),g:
Colorpicker('Cooldown Background Color',{r=0,g=0,b=0,a=200},true),g:Checkbox(
'Evasive Bar',false),g:Colorpicker('Evasive Fill Color',{r=121,g=74,b=148,a=255}
,true)cheat.Register('onPaint',function()b.Draw()end)cheat.Register(
'onSlowUpdate',function()b.Enabled=h:Get()b.DrawCooldowns=j:Get()b.
DrawEvasiveBar=m:Get()local o=k:Get()b.CooldownFillColour=f(o)b.
CooldownFillAlpha=o.a local p=l:Get()b.CooldownBackgroundColour=f(p)b.
CooldownBackgroundAlpha=o.a b.EvasiveBarColour=n:Get'rgb'end)end return b end
function a.j()local b,c,d={Enabled=false,TextColor=Color3.fromRGB(255,255,255),
TextAlpha=255},a.load'a',function(b)if type(b)~='table'then return Color3.
fromRGB(255,255,255)end local c,d,e=b.R or b.r or 255,b.G or b.g or 255,b.B or b
.b or 255 return Color3.fromRGB(c,d,e)end function b.Draw()if not b.Enabled then
return end for e,f in pairs(c.Folders.Items)do local g,h,j=utility.
WorldToScreen(f.Position)if g and h and j then local k=f.Name local l,m=draw.
GetTextSize(k,c.Font)local n,o=g-(l/2),h-(m/2)if k~=''then draw.TextOutlined(k,n
,o,b.TextColor,c.Font,b.TextAlpha)end end end end function b.Initialise(e)local
f,g=e:Checkbox('Item ESP',b.Enabled),e:Colorpicker('Item ESP Text Color',{r=255,
g=255,b=255,a=b.TextAlpha},true)cheat.Register('onPaint',b.Draw)cheat.Register(
'onUpdate',function()local h=g:Get()b.Enabled=f:Get()b.TextColor=d(h)b.TextAlpha
=h.A end)end return b end function a.k()local b,c,d,e={Enabled=false,TextColor=
Color3.fromRGB(255,255,255),TextAlpha=255},a.load'a',function(b,c,d)local e=b:
GetAttribute(c)return e and e.Value or d end,function(b)if type(b)~='table'then
return Color3.fromRGB(255,255,255)end local c,d,e=b.R or b.r or 255,b.G or b.g
or 255,b.B or b.b or 255 return Color3.fromRGB(c,d,e)end function b.Draw()if not
b.Enabled then return end local f,g=cheat.GetWindowSize()for h,j in pairs(c.
Folders.Domains)do local k=d(j,'Health',0)local l='Domain Health: '..tostring(
math.floor(k))local m,n=draw.GetTextSize(l,c.Font)local o,p,q,r=c.ClosestDomain,
false if o.Instance and j==o.Instance and o.Distance<=40 then q=(f/2)-(m/2)r=50
p=true else local s,t,u=utility.WorldToScreen(j.Position)if s and t and u then q
=s-m/2 r=t-n/2 p=u end end if p and l~=''then draw.TextOutlined(l,q,r,b.
TextColor,c.Font,b.TextAlpha)end end end function b.Initialise(f)local g,h=f:
Checkbox('Visualise Domain Health',b.Enabled),f:Colorpicker(
'Domain Health Text Color',{r=255,g=255,b=255,a=b.TextAlpha},true)cheat.
Register('onPaint',b.Draw)cheat.Register('onUpdate',function()local j=h:Get()b.
Enabled=g:Get()b.TextColor=e(j)b.TextAlpha=j.A end)end return b end function a.l
()local b,c={},a.load'a'function b.Initialise(d)local e=d:Dropdown(
'Font Selection',{'ConsolasBold','SmallestPixel','Verdana','Tahoma'},1)cheat.
Register('onUpdate',function()c.Font=e:Get()end)end return b end function a.m()
local b={}b.__index=b function b.New()local c=setmetatable({},b)c.Queues={}c.
Indexes={}c.Caches={}c.Callbacks={}c.Rates={}c.LastUpdate={}return c end
function b:AddCategory(c,d,e,f)self.Queues[c]=d or{}self.Indexes[c]=1 self.
Caches[c]={}self.Rates[c]=e or 50 self.LastUpdate[c]=0 self.Selectors=self.
Selectors or{}self.Selectors[c]=f end function b:SetCallback(c,d)self.Callbacks[
c]=d end function b:Update()local c=utility.GetTickCount()for d,e in pairs(self.
Queues)do local f,g=self.Rates[d]or 50,self.LastUpdate[d]or 0 if c-g>=f then
local h=self.Indexes[d]local j=e[h]if j then local k,l,m=j:GetChildren(),self.
Selectors and self.Selectors[d],{}for n=1,#k do local o=k[n]if l then o=l(o)end
if o then m[o.Name]=o end end self.Caches[d]=m local n=self.Callbacks[d]if n
then n(d,j,k)end end h=h+1 if h>#e then h=1 end self.Indexes[d]=h self.
LastUpdate[d]=c end end end function b:GetCached(c)local d=self.Caches[c]if not
d then return{}end local e={}for f,g in pairs(d)do e[#e+1]=g end return e end
function b:ClearCache(c)self.Caches[c]={}end function b:SetInterval(c,d)self.
Rates[c]=d end return b end function a.n()local b,c,d,e,f={},game.GetService
'Workspace',game.GetService'Stats',game.LocalPlayer,entity.GetLocalPlayer()local
g,h,j=c:FindFirstChild'Domains',c:FindFirstChild'Items',d:FindFirstChild
'Network'local k=j.ServerStatsItem local l,m,n,o=k['Data Ping'],a.load'a',a.load
'm'.New(),function(l,m,n)local o=l:GetAttribute(m)return o and o.Value or n end
local p=function()m.LocalInfo.SelectedCharacter=o(m.LocalInfo.Player,'Moveset',
'[???}')m.LocalInfo.Ping=l.Value end function b.Initialise(q)m.LocalInfo.Player=
e m.LocalInfo.PlayerGui=m.LocalInfo.Player and m.LocalInfo.Player:FindFirstChild
'PlayerGui'n:AddCategory('Domains',{g},2000)n:AddCategory('Items',{h},2000)n:
SetCallback('Domains',function(r,s,t)local u,v=(math.huge)for w,x in pairs(t)do
local y=x:FindFirstChildOfClass'MeshPart'local z=(y.Position-f.Position).
Magnitude if z<u then v=x u=z end end m.ClosestDomain.Instance=v m.ClosestDomain
.Distance=u end)cheat.Register('onUpdate',function()p()n:Update()m.Folders.
Domains=n:GetCached'Domains'm.Folders.Items=n:GetCached'Items'end)end return b
end function a.o()return function()function math.floor(b)return b-(b%1)end
function math.clamp(b,c,d)return math.max(c,math.min(d,b))end end end end local
b,c,d,e,f,g,h,j,k,l,m=a.load'b',a.load'e',a.load'g',a.load'i',a.load'j',a.load
'k',a.load'l',a.load'n',a.load'f',a.load'h',a.load'o'local n=function()local n=l
.NewTab('DiddyWare_JJS','DiddyWare')local o,p,q=n:Container('DiddyWare_JJSC1',
'Main',{autosize=true,next=true}),n:Container('DiddyWare_JJSC2','Visuals',{
autosize=true}),n:Container('DiddyWare_JJSC3','Settings',{autosize=true})m()k.
Initialise(q)j.Initialise(q)d.Initialise(o)b.Initialise(o)c.Initialise(o)e.
Initialise(p)g.Initialise(p)f.Initialise(p)h.Initialise(q)end n()
