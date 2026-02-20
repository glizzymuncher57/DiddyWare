--!nocheck
--!nolint

_P = {
	genDate = "2026-02-20T12:33:31.045640800+00:00",
	cfg = "Release",
	vers = "",
}

local a a={cache={},load=function(b)if not a.cache[b]then a.cache[b]={c=a[b]()}
end return a.cache[b].c end}do function a.a()local b,c={},{}c.__index=c function
c:Get()return ui.getValue(self.TabRef,self.ContainerRef,self.Name)end function c
:Set(d)ui.setValue(self.TabRef,self.ContainerRef,self.Name,d)end function c:
Visible(d)ui.setVisibility(self.TabRef,self.ContainerRef,self.Name,d)end local d
={}d.__index=d local e=function(e,f,g)return setmetatable({TabRef=e,ContainerRef
=f,Name=g},c)end function d:Checkbox(f,g)ui.newCheckbox(self.TabRef,self.Ref,f,g
)return e(self.TabRef,self.Ref,f)end function d:SliderInt(f,g,h,i)ui.
newSliderInt(self.TabRef,self.Ref,f,g,h,i)return e(self.TabRef,self.Ref,f)end
function d:SliderFloat(f,g,h,i)ui.newSliderFloat(self.TabRef,self.Ref,f,g,h,i)
return e(self.TabRef,self.Ref,f)end function d:Dropdown(f,g,h)ui.newDropdown(
self.TabRef,self.Ref,f,g,h)local i=e(self.TabRef,self.Ref,f)i.Get=function()
local j=ui.getValue(self.TabRef,self.Ref,f)return g[j+1]end return i end
function d:Multiselect(f,g)ui.newMultiselect(self.TabRef,self.Ref,f,g)local h=e(
self.TabRef,self.Ref,f)h.Get=function()local i,j=ui.getValue(self.TabRef,self.
Ref,f),{}for k,l in ipairs(i)do if l then j[g[k] ]=true end end return j end
return h end function d:Colorpicker(f,g,h)ui.newColorpicker(self.TabRef,self.Ref
,f,g,h)local i=e(self.TabRef,self.Ref,f)i.Get=function(j,k)k=(tostring(k)or
'table'):lower()if k=='rgb'then local l=ui.getValue(self.TabRef,self.Ref,f)
return Color3.fromRGB(l.r,l.g,l.b)end return ui.getValue(self.TabRef,self.Ref,f)
end return i end function d:InputText(f,g)ui.newInputText(self.TabRef,self.Ref,f
,g)return e(self.TabRef,self.Ref,f)end function d:Button(f,g)ui.newButton(self.
TabRef,self.Ref,f,g)local h=e(self.TabRef,self.Ref,f)h.Get=nil h.Set=nil return
h end function d:Listbox(f,g,h)ui.newListbox(self.TabRef,self.Ref,f,g,function()
if h then local i=ui.getValue(self.TabRef,self.Ref,f)local j=g[i+1]h(j)end end)
return e(self.TabRef,self.Ref,f)end function d:KeyPicker(f,g,...)ui.newHotkey(
self.TabRef,self.Ref,f,g)local h=e(self.TabRef,self.Ref,f)h.Get=function(i,j)if
not j then j='Value'end local k={self.TabRef,self.Ref,f}return j=='Value'and ui.
getValue(unpack(k))or ui.getHotkey(unpack(k))end return h end local f={}f.
__index=f function f:Container(g,h,i)ui.newContainer(self.Ref,g,h,i or{})return
setmetatable({TabRef=self.Ref,Ref=g},d)end function b.NewTab(g,h)ui.newTab(g,h)
return setmetatable({Ref=g},f)end function b.NewReference(g,h,i)return e(g,h,i)
end return b end function a.b()return{Font='ConsolasBold',CachedMap=nil,
CachedCoinContainer=nil,CachedGunDrop=nil,ActiveCoins={},TrackedPlayers={},
CurrentMurderer=nil,CurrentSheriff=nil}end function a.c()return{
ScreenGui_Enabled=0x4cc,Frame_Visible=0x5b1,FramePosition={X_Scale=0x518,
X_Offset=0x110,Y_Scale=0x520,Y_Offset=0x114},FrameSize={X_Scale=0x538,X_Offset=
0x118,Y_Scale=0x540,Y_Offset=0x11c},FrameRotation=0x188}end function a.d()local
b,c=a.load'c',{}function c.GetFramePosition(d)local e=d.Address return Vector3.
new(memory.read('float',e+b.FramePosition.X_Offset),memory.read('float',e+b.
FramePosition.Y_Offset),0)end function c.GetFrameSize(d)local e=d.Address return
Vector3.new(memory.read('float',e+b.FrameSize.X_Offset),memory.read('float',e+b.
FrameSize.Y_Offset),0)end function c.GetFrameCenter(d)local e,f=c.
GetFramePosition(d),c.GetFrameSize(d)return e+(f/2)end function c.
GetFrameRotation(d)return memory.read('float',d.Address+b.FrameRotation)end
function c.IsFrameVisible(d)return memory.read('bool',d.Address+b.Frame_Visible)
end return c end function a.e()local b,c,d,e={LastUpdate=0,UpdateInterval=50},
game.GetService'Players',entity.GetLocalPlayer(),game.LocalPlayer local f,g,h,i=
e.PlayerGui,a.load'b',a.load'd',function(f,g,h)local i=f:GetAttribute(g)return i
and i.Value or h end local j=function(j)if not j then return end if not g.
TrackedPlayers[j.Name]then local k=c:FindFirstChild(j.Name)if not k then return
end g.TrackedPlayers[j.Name]={EntityInstance=j,PlayerInstance=k,IsAlive=nil}end
local k=g.TrackedPlayers[j.Name]if not k then return end local l=j:
GetBoneInstance'HumanoidRootPart'local m,n=l and l.Parent or nil,k.
PlayerInstance.Backpack k.IsAlive=i(k.PlayerInstance,'Alive',false)k.IsMurderer=
(n and n:FindFirstChild'Knife')or(m and m:FindFirstChild'Knife')and true or
false k.IsSheriff=(n and n:FindFirstChild'Gun')or(m and m:FindFirstChild'Gun')
and true or false k.IsInnocent=not k.IsMurderer and not k.IsSheriff if k.
IsSheriff then g.CurrentSheriff=j end if k.IsMurderer then g.CurrentMurderer=j
end if j.Name==d.Name then local o=f:FindFirstChild'MainGUI'if not o then k.
IsFullCoins=false return end local p,q=o.Game.CoinBags.Container,false for r,s
in pairs(p:GetChildren())do if s:IsA'Frame'then local t=h.IsFrameVisible(s.Full)
if t then q=t break end end end k.IsFullCoins=q end end function b:IsPlayerAlive
(k)k=k~=nil and k or d local l=g.TrackedPlayers[k.Name]if not l then return
false end return l.IsAlive end function b:GetPlayerRole(k)k=k or d local l=g.
TrackedPlayers[k.Name]if not l then return nil end if l.IsMurderer and l.IsAlive
then return'Murderer'elseif l.IsSheriff and l.IsAlive then return'Sheriff'elseif
l.IsInnocent and l.IsAlive then return'Innocent'else return'Spectator'end end
function b:GetPlayerStored(k)k=k or d local l=g.TrackedPlayers[k.Name]if not l
then return nil end return l end function b:GetAlivePlayers(k)local l,m={},self:
GetPlayerRole()for n,o in pairs(g.TrackedPlayers)do if n~=d.Name and o.IsAlive
then if not k then table.insert(l,o)else if m=='Murderer'then table.insert(l,o)
elseif m=='Sheriff'then if self:GetPlayerRole(o)=='Murderer'then table.insert(l,
o)end end end end end return l end function b.Initialise(k)local l=k:SliderInt(
'Player Tracker Update Interval',1,100,50)cheat.Register('onUpdate',function()b.
UpdateInterval=l:Get()local m=utility.GetTickCount()if m-b.LastUpdate>=b.
UpdateInterval then j(d)for n,o in pairs(entity.GetPlayers(false))do j(o)end end
end)cheat.Register('onSlowUpdate',function()local m={}m[d.Name]=true for n,o in
pairs(entity.GetPlayers(false))do m[o.Name]=true end for n,o in pairs(g.
TrackedPlayers)do if not m[n]then g.TrackedPlayers[n]=nil end end end)end return
b end function a.f()return function(b,c)for d=1,1000 do b.Position=c end end end
function a.g()local b={}b.__index=b local c=a.load'f'b.Easing={Linear=function(d
)return d end}local d=function(d,e,f)if e=='Position'then c(d,f)else d[e]=f end
end function b.new(e,f,g,h,i)return setmetatable({Target=e,Property=f,Start=e[f]
,Goal=g,Duration=h*1000,StartTime=utility.GetTickCount(),Easing=i or b.Easing.
Linear,Finished=false},b)end function b:Step()if self.Finished then return true
end local e=utility.GetTickCount()local f=e-self.StartTime local g=f/self.
Duration if g>=1 then d(self.Target,self.Property,self.Goal)self.Finished=true
return true end g=self.Easing(g)local h,i,j=self.Start,(self.Goal)if type(h)==
'number'then j=h+(i-h)*g else j=h:Lerp(i,g)end d(self.Target,self.Property,j)
return false end function b:Cancel()self.Finished=true end return b end function
a.h()local b,c,d,e,f,g={SAFE_POSITION=Vector3.new(14,505,-45),Flags={Enabled=
false,SafetyOnFullBag=false,MurdererSafezone=35,DelayPerCoin=0.75,TweenSpeed=35}
,State={GoingToCoin=false,CoinTween=nil,LastCoinGrab=0,
LastPositionBeforeTeleport=nil,LastTeleport=0,Target=nil}},entity.
GetLocalPlayer(),a.load'a',a.load'b',a.load'e',a.load'g'local h,i=function(h)
local i,j,k,l,m=math.huge,h~='Murderer',(e.CurrentMurderer)if j and k then m=k.
Position end for n,o in pairs(e.ActiveCoins)do local p,q=((c.Position-o).
Magnitude)if m then q=(m-o).Magnitude end local r=true if q then r=q>b.Flags.
MurdererSafezone end if r and p<i then l=n i=p end end return l,i end,function(h
)return table.find(e.ActiveCoins,h)end function b.Runtime()if not b.Flags.
Enabled then return end if not f:IsPlayerAlive()then return end local j=c:
GetBoneInstance'HumanoidRootPart'if not j then return end local k,l=utility.
GetTickCount(),b.State.CoinTween if l then local m=l:Step()if m then b.State.
CoinTween=nil b.State.GoingToCoin=false b.State.LastCoinGrab=k end return end
local m,n,o,p,q=f:GetPlayerStored(),f:GetPlayerRole(),b.Flags.SafetyOnFullBag,b.
State.GoingToCoin,b.State.LastCoinGrab local r=o and m.IsFullCoins and n~=
'Sheriff'and n~='Murderer'if r then j.Position=b.SAFE_POSITION return end if not
p and not m.IsFullCoins and(k-q)>=b.Flags.DelayPerCoin*1000 then local s,t=h(n)
if not s or not i(s)then return end local u=t/b.Flags.TweenSpeed b.State.
GoingToCoin=true b.State.CoinTween=g.new(j,'Position',s.Position,u,g.Easing.
Linear)return end end function b.Initialise(j)local k,l,m,n,o,p,q=j:Checkbox(
'Coin Farm',false),j:Checkbox('Return to Safety when Bag is Full',false),j:
SliderInt('Murderer Safezne',1,100,20),j:SliderFloat('Delay Per Coin (s)',0,3,
0.55),j:SliderInt('Tween Speed',1,100,25),d.NewReference('Exploits','Misc',
'Slow Fall'),d.NewReference('Exploits','Misc','Fall Speed')local r=function()
local r=b.Flags r.Enabled=k:Get()r.SafetyOnFullBag=l:Get()r.MurdererSafezone=m:
Get()r.DelayPerCoin=n:Get()r.TweenSpeed=o:Get()l:Visible(r.Enabled)m:Visible(r.
Enabled)n:Visible(r.Enabled)o:Visible(r.Enabled)p:Set(r.Enabled)q:Set(1)end
cheat.Register('onUpdate',function()b.Runtime()r()end)end return b end function
a.i()local b,c,d,e,f={Flags={Enabled=false}},a.load'b',a.load'e',a.load'f',
entity.GetLocalPlayer()local g=function()local g=f:GetBoneInstance
'HumanoidRootPart'if not g then return end local h=c.CachedGunDrop if not h then
return end local i=g.Position e(g,h.Position)e(g,i)end function b.Runtime()if
not b.Flags.Enabled then return end if not d:IsPlayerAlive()then return end if d
:GetPlayerRole()=='Murderer'then return end g()end function b.Initialise(h)local
i=h:Checkbox('Auto Teleport To Gun',false)h:Button('Grab Gun',g)cheat.Register(
'onUpdate',function()b.Flags.Enabled=i:Get()b.Runtime()end)end return b end
function a.j()return function(b,c)local d,e,f d=b.X-c.X e=b.Y-c.Y f=b.Z-c.Z
return math.floor(math.sqrt(d*d+e*e+f*f))end end function a.k()local b,c,d,e={
Flags={Enabled=false,ShowDistance=false,Color=Color3.fromRGB(255,255,255),Alpha=
255},CachedTextSizes={},LastFont=nil},'Coin'local f,g,h,i,j=Color3.fromRGB(255,
255,255),a.load'b',a.load'e',a.load'j',entity.GetLocalPlayer()local k,l=function
(k)local l=b.CachedTextSizes[k..g.Font]if l then return l.W,l.H end local m,n=
draw.GetTextSize(k,g.Font)b.CachedTextSizes[k..g.Font]={W=m,H=n}return m,n end,
function(k)if type(k)~='table'then return Color3.fromRGB(255,255,255)end local l
,m,n=k.R or k.r or 255,k.G or k.g or 255,k.B or k.b or 255 return Color3.
fromRGB(l,m,n)end function b.Runtime()if not b.Flags.Enabled then return end if
not h:IsPlayerAlive()then return end local m,n,o=b.Flags.ShowDistance,b.Flags.
Color,b.Flags.Alpha for p,q in pairs(g.ActiveCoins)do local r,s,t=utility.
WorldToScreen(q)if t then local u=''if m then local v=i(j.Position,q)u=' ['..
tostring(v)..']'end local v=e if m and u~=''then v=v+k(u)end local w,x=r-(v/2),s
-(d/2)draw.TextOutlined(c,w,x,n,g.Font,o)if m and u~=''then draw.TextOutlined(u,
w+e,x,f,g.Font,o)end end end end function b.Initialise(m)local n,o,p=m:Checkbox(
'Coin ESP',false),m:Colorpicker('Coin ESP Color',{r=255,g=255,b=255,a=255},true)
,m:Checkbox('Show Distance',false)cheat.Register('onPaint',b.Runtime)cheat.
Register('onUpdate',function()local q=o:Get()b.Flags.Enabled=n:Get()b.Flags.
Color=l(q)b.Flags.Alpha=q.a b.Flags.ShowDistance=p:Get()p:Visible(b.Flags.
Enabled)local r=g.Font b.LastFont=r if r~=b.LastFont or b.LastFont==nil then e,d
=k(c)end end)end return b end function a.l()local b,c,d,e,f,g,h={Flags={Enabled=
false,ShowDistance=false,Color=Color3.fromRGB(255,255,255),Alpha=255},
CachedTextSizes={}},'Gun',Color3.fromRGB(255,255,255),a.load'j',a.load'b',a.load
'e',entity.GetLocalPlayer()local i,j=function(i)local j=b.CachedTextSizes[i..f.
Font]if j then return j.W,j.H end local k,l=draw.GetTextSize(i,f.Font)b.
CachedTextSizes[i..f.Font]={W=k,H=l}return k,l end,function(i)if type(i)~=
'table'then return d end local j,k,l=i.R or i.r or 255,i.G or i.g or 255,i.B or
i.b or 255 return Color3.fromRGB(j,k,l)end function b.Runtime()if not b.Flags.
Enabled then return end if not g:IsPlayerAlive()then return end local k,l,m,n=b.
Flags.ShowDistance,b.Flags.Color,b.Flags.Alpha,f.CachedGunDrop if not n then
return end local o=n.Position local p,q,r=utility.WorldToScreen(o)if r then
local s,t=i(c)local u=''if k then local v=e(h.Position,o)u=' ['..tostring(v)..
']'end local v=s if k and u~=''then v=v+i(u)end local w,x=p-(v/2),q-(t/2)draw.
TextOutlined(c,w,x,l,f.Font,m)if k and u~=''then draw.TextOutlined(u,w+s,x,d,f.
Font,m)end end end function b.Initialise(k)local l,m,n=k:Checkbox('Gun Drop ESP'
,false),k:Colorpicker('Gun Drop ESP Color',{r=255,g=255,b=255,a=255},true),k:
Checkbox('Show Distance',false)cheat.Register('onPaint',b.Runtime)cheat.
Register('onUpdate',function()local o=m:Get()b.Flags.Enabled=l:Get()b.Flags.
Color=j(o)b.Flags.Alpha=o.a b.Flags.ShowDistance=n:Get()n:Visible(b.Flags.
Enabled)end)end return b end function a.m()local b,c,d,e,f={Flags={Enabled=false
,UseRoleColor=false,Color=Color3.new(255,255,255),Alpha=255,SelectedRoleTypes={
Innocent=false,Sheriff=false,Murderer=false}},CachedTextSizes={}},Color3.
fromRGB(255,255,255),{Innocent=Color3.new(0.117647,0.858824,0.117647),Murderer=
Color3.new(0.72549,0.101961,0.101961),Sheriff=Color3.new(0.070588,0.517647,
0.811765)},a.load'b',a.load'e'local g,h=function(g)local h=b.CachedTextSizes[g..
e.Font]if h then return h.W,h.H end local i,j=draw.GetTextSize(g,e.Font)b.
CachedTextSizes[g..e.Font]={W=i,H=j}return i,j end,function(g)if type(g)~=
'table'then return c end local h,i,j=g.R or g.r or 255,g.G or g.g or 255,g.B or
g.b or 255 return Color3.fromRGB(h,i,j)end local i=function(i)local j=f:
IsPlayerAlive(i)if not j then return end local k=f:GetPlayerRole(i)local l=b.
Flags.SelectedRoleTypes[k]~=nil if not l then return end local m,n,o=utility.
WorldToScreen(i.Position)if not o then return end local p=i.BoundingBox if not p
then return end local q,r=g(k)local s,t,u,v=p.x+(p.w/2)-(q/2),p.y+(p.h/2)-(r/2),
b.Flags.UseRoleColor and d[k]or b.Flags.Color,b.Flags.Alpha draw.TextOutlined(k,
s,t,u,e.Font,v)end function b.Runtime()if not b.Flags.Enabled then return end if
not f:IsPlayerAlive()then return end for j,k in pairs(entity.GetPlayers(false))
do i(k)end end function b.Initialise(j)local k,l,n,o=j:Checkbox
'Role ESP Enabled',j:Colorpicker('Role ESP Color',{r=255,g=255,b=255,a=255},true
),j:Checkbox('Use Role Color',false),j:Multiselect('Draw Roles',{'Innocent',
'Sheriff','Murderer'})cheat.Register('onPaint',b.Runtime)cheat.Register(
'onUpdate',function()b.Flags.Enabled=k:Get()local p=l:Get()b.Flags.Color=h(p)b.
Flags.Alpha=p.a b.Flags.UseRoleColor=n:Get()b.Flags.SelectedRoleTypes=o:Get()n:
Visible(b.Flags.Enabled)o:Visible(b.Flags.Enabled)end)end return b end function
a.n()local b,c,d={LastUpdate=0,UpdateInterval=50},game.GetService'Workspace',a.
load'b'local e,f,g,h=function()local e for f,g in pairs(c:GetChildren())do local
h=g:GetAttribute'MapID'if h then e=g break end end return e end,function()local
e=d.CachedMap if not e then return nil end return e:FindFirstChild
'CoinContainer'end,function()local e=d.CachedMap if not e then return nil end
return e:FindFirstChild'GunDrop'end,function()local e=d.CachedCoinContainer if
not e then return end local f={}for g,h in pairs(e:GetChildren())do local i=h:
FindFirstDescendant'MainCoin'if i and i.Transparency==0 then f[h.Address]=h.
Position end end d.ActiveCoins=f end function b.Initialise(i)local j=i:
SliderInt('Game Tracker Update Interval',1,100,50)cheat.Register('onUpdate',
function()b.UpdateInterval=j:Get()local k=utility.GetTickCount()if k-b.
LastUpdate>=b.UpdateInterval then h()end end)cheat.Register('onSlowUpdate',
function()coroutine.resume(coroutine.create(function()local k=e()if not k then d
.CachedMap=nil return end if not d.CachedMap or d.CachedMap~=k.Address then d.
CachedMap=k end end))coroutine.resume(coroutine.create(function()local k=f()if
not k then d.CachedCoinContainer=nil return end if not d.CachedCoinContainer or
d.CachedCoinContainer.Address~=k.Address then d.CachedCoinContainer=k end end))
coroutine.resume(coroutine.create(function()local k=g()if not k then d.
CachedGunDrop=nil return end if not d.CachedGunDrop or d.CachedGunDrop.Address~=
k.Address then d.CachedGunDrop=k end end))end)end return b end function a.o()
local b,c={},a.load'b'function b.Initialise(d)local e=d:Dropdown(
'Font Selection',{'ConsolasBold','SmallestPixel','Verdana','Tahoma'},1)cheat.
Register('onUpdate',function()c.Font=e:Get()end)end return b end function a.p()
return function()function math.floor(b)return b-(b%1)end function math.clamp(b,c
,d)return math.max(c,math.min(d,b))end end end function a.q()return function()
table.find=function(b,c)for d,e in pairs(b)do if e==c then return d end end
return nil end end end end local b,c,d,e,f,g,h,i,j,k,l=a.load'h',a.load'i',a.
load'k',a.load'l',a.load'm',a.load'e',a.load'n',a.load'o',a.load'a',a.load'p',a.
load'q'local n=function()local n=j.NewTab('DiddyWare_MM2','DiddyWare')local o,p,
q=n:Container('DiddyWare_MM2C1','Main',{autosize=true,next=true}),n:Container(
'DiddyWare_MM2C2','Visuals',{autosize=true}),n:Container('DiddyWare_MM2C3',
'Settings',{autosize=true,next=true})k()l()b.Initialise(o)c.Initialise(o)d.
Initialise(p)f.Initialise(p)e.Initialise(p)g.Initialise(q)h.Initialise(q)i.
Initialise(q)end n()
