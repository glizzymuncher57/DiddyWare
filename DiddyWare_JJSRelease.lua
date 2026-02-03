--!nocheck
--!nolint

_P = {
	genDate = "2026-02-03T23:44:00.206537800+00:00",
	cfg = "Release",
	vers = "",
}

local a a={cache={},load=function(b)if not a.cache[b]then a.cache[b]={c=a[b]()}
end return a.cache[b].c end}do function a.a()return{Font='ConsolasBold',
LocalInfo={Player=nil,PlayerGui=nil,Character=nil,MinigameUI=nil,
SelectedCharacter=nil,Ping=0},Players={},Folders={Items={},Domains={}},
ClosestDomain={Instance=nil,Distance=math.huge}}end function a.b()local b,c={
Enabled=false,LastClick=0,Delay=200},a.load'a'local d=c.LocalInfo.PlayerGui
function b.Runtime()if not b.Enabled then return end local e=utility.
GetTickCount()if(e-b.LastClick)<b.Delay then return end if not d then d=c.
LocalInfo.Player.PlayerGui return end local f=d:FindFirstChild'QTE'if not f then
return end local g=f:FindFirstChild'QTE_PC'if not g then return end local h=g.
Value if not h or h==''then return end local i=tostring(h):lower()keyboard.
click(i)b.LastClick=e end function b.Initialise(e)local f,g=e:Checkbox
'Lawyer QTE',e:SliderInt('QTE Delay (ms)',1,200,200)cheat.register('onUpdate',
function()b.Runtime()b.Enabled=f:Get()b.Delay=g:Get()g:Visible(b.Enabled)end)end
return b end function a.c()return{ScreenGui_Enabled=0x644,Frame_Visible=0x5b1,
Frame_PositionX=0x518,Frame_PositionY=0x520,Frame_SizeX=0x538,Frame_SizeY=0x53c,
Frame_AnchorPoint=0x560,Frame_Rotation=0x188}end function a.d()local b,c=a.load
'c',{}function c.GetFramePosition(d)local e=d.Address return Vector3.new(memory.
read('float',e+b.Frame_PositionX),memory.read('float',e+b.Frame_PositionY),0)end
function c.GetFrameSize(d)local e=d.Address return Vector3.new(memory.read(
'float',e+b.Frame_SizeX),memory.read('float',e+b.Frame_SizeY),0)end function c.
GetFrameCenter(d)local e,f=c.GetFramePosition(d),c.GetFrameSize(d)return e+(f/2)
end function c.GetFrameRotation(d)return memory.read('float',d.Address+b.
Frame_Rotation)end function c.GetFrameAnchorPoint(d)local e=d.Address+b.
Frame_AnchorPoint return Vector3.new(memory.read('float',e),memory.read('float',
e+0x4),0)end function c.IsFrameVisible(d)return memory.read('bool',d.Address+b.
Frame_Visible)end return c end function a.e()local b,c,d,e={Enabled=false,
Tolerance=0.03,CurrentAddress=nil,PressedR=false},a.load'c',a.load'd',a.load'a'
function b.Runtime()if e.LocalInfo.SelectedCharacter~='Nanami'then return end if
not b.Enabled then return end local f=entity.GetPlayers(false)for g,h in pairs(f
)do coroutine.resume(coroutine.create(function()local i=h:GetBoneInstance
'HumanoidRootPart'if not i then return end local j=i:FindFirstChild'Ratio'if not
j then return end if not memory.read('bool',j.Address+c.ScreenGui_Enabled)then
return end if not b.CurrentAddress or b.CurrentAddress~=j.Address then b.
CurrentAddress=j.Address b.PressedR=false end local k=j:FindFirstChild'Bar'if
not k then return end local l,m=k:FindFirstChild'Bar',k:FindFirstChild'Cursor'if
not l or not m then return end local n,o,p,q=d.GetFrameCenter(l),d.GetFrameSize(
l),d.GetFrameRotation(l),d.GetFrameCenter(m)local r,s=p>0,math.rad(p)local t,u,v
,w=math.cos(s),(math.sin(s))if r then v=n.X-t*(o.X/2)w=n.Y-u*(o.X/2)else v=n.X+t
*(o.X/2)w=n.Y+u*(o.X/2)end local x,y,z=q.X-v,q.Y-w,r and 1 or-1 local A=(x*t+y*u
)*z local B=A/o.X B=math.clamp(B,0,1)if math.abs(B-0.3)<=b.Tolerance and not b.
PressedR then keyboard.click'r'b.PressedR=true end end))end end function b.
Initialise(f)local g,h=f:Checkbox'Nanami QTE',f:SliderFloat(
'Nanami QTE Tolerance',0,0.1,0.03)cheat.Register('onPaint',b.Runtime)cheat.
Register('onUpdate',function()b.Enabled=g:Get()b.Tolerance=h:Get()h:Visible(b.
Enabled)end)end return b end function a.f()local b,c,d,e,f,g,h={LastRebuild=0,
LastCooldownUpdate=0},game.GetService'Players',a.load'a',entity.GetLocalPlayer()
,{},{},function(b,c,d)local e=b:GetAttribute(c)return e and e.Value or d end
local i=function(i,j)if not i or not i.Name then return end local k,l=c:
FindFirstChild(i.Name),i:GetBoneInstance'HumanoidRootPart'if not l then return
end local m=l.Parent if not m then return end local n=m:FindFirstChild'Moveset'
if not n then return end local o=d.Players[i.Name]local p,q,r=o and o.Moves or
nil,{},{}for s,t in pairs(n:GetChildren())do local u,v,w=t.Name,h(t,'Key',1),t.
Value or 0 local x,y=p and p[u],i.UserId..':'..u local z={Name=u,Key=v,Cooldown=
w,Instance=t,MoveKey=y,IsOnCooldown=x and x.IsOnCooldown or false,Remaining=x
and x.Remaining or 0}q[#q+1]=z r[u]=z end table.sort(q,function(s,t)return s.Key
<t.Key end)j[i.Name]={Player=i,Character=m,SelectedMoveset=h(m,'Moveset','[???]'
),Evade=h(m,'Evade',50),Ultimate=k and h(k,'Ultimate',0)or 0,Ragdolled=h(m,
'Ragdoll',0),Moves=r,OrderedMoves=q}end local j,k=function()local j,k={},entity.
GetLocalPlayer()if k then i(k,j)end for l,m in pairs(entity.GetPlayers(false))do
i(m,j)end d.Players=j end,function()local j=utility.GetTickCount()/1000 for k,l
in pairs(d.Players)do for m,n in pairs(l.Moves)do local o=n.Instance if o then
local p,q=h(o,'LastUse',0),n.MoveKey if p~=f[q]then f[q]=p g[q]=j end local r=g[
q]if r then local s=j-r if s<n.Cooldown then n.IsOnCooldown=true n.Remaining=n.
Cooldown-s else n.IsOnCooldown=false n.Remaining=0 end else n.IsOnCooldown=false
n.Remaining=0 end end end end end function b:ReturnLocalPlayer()return d.Players
[e.Name]end function b:GetPlayerRagdollState(l)if not l then return end local m=
d.Players[l.Name]if not m then return false end local n=m.Ragdolled return n and
n~=0 or false end function b:GetPlayerUltimate(l)if not l then return end local
m=d.Players[l.Name]if not m then return 0 end return m.Ultimate or 0 end
function b:DoesPlayerHaveMove(l,m)if not l or not m then return false,nil end
local n=d.Players[l.Name]if not n or not n.Moves then return false,nil end local
o=n.Moves[m]if not o then return false,nil end return true,o end function b:
IsMoveUsable(l,m)local n,o=b:DoesPlayerHaveMove(l,m)if not n then return false
end return not o.IsOnCooldown end function b.Initialise(l)local m,n=l:
SliderFloat('Rebuild Player Cache Interval (s)',0.05,1,0.15),l:SliderFloat(
'Update Cooldowns every (ms)',1,50,5)cheat.Register('onUpdate',function()local o
,p=utility.GetTickCount(),m:Get()*1000 if(o-b.LastCooldownUpdate)>=n:Get()then
k()b.LastCooldownUpdate=o end if(o-b.LastRebuild)>=p then b.LastRebuild=o j()end
end)end return b end function a.g()local b,c={},{}c.__index=c function c:Get()
return ui.getValue(self.TabRef,self.ContainerRef,self.Name)end function c:Set(d)
ui.setValue(self.TabRef,self.ContainerRef,self.Name,d)end function c:Visible(d)
ui.setVisibility(self.TabRef,self.ContainerRef,self.Name,d)end local d={}d.
__index=d local e=function(e,f,g)return setmetatable({TabRef=e,ContainerRef=f,
Name=g},c)end function d:Checkbox(f,g)ui.newCheckbox(self.TabRef,self.Ref,f,g)
return e(self.TabRef,self.Ref,f)end function d:SliderInt(f,g,h,i)ui.
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
return setmetatable({Ref=g},f)end return b end function a.h()local b,c,d,e={
Enabled=false,HotkeyEnabled=false,Timings={Itadori=0.285,Mahito=0.285},_Waiting=
false,_NextPressTime=0,_WasDown=false},entity.GetLocalPlayer(),a.load'a',a.load
'f'function b.Runtime()if not b.Enabled then return end if not b.HotkeyEnabled
then return end local f=d.LocalInfo.SelectedCharacter if f~='Mahito'and f~=
'Itadori'then return end local g,h=utility.GetTickCount(),keyboard.IsPressed(
0x33)if not e:DoesPlayerHaveMove(c,'Focus Strike')and not e:DoesPlayerHaveMove(c
,'Divergent Fist')then return end if h and not b._WasDown and not b._Waiting
then local i=b.Timings[f]or 0 local j,k=i*1000,d.LocalInfo.Ping or 0 j=j-k if j<
0 then j=0 end b._NextPressTime=g+j b._Waiting=true end if b._Waiting and g>=b.
_NextPressTime then keyboard.Click(0x33)b._Waiting=false end b._WasDown=h end
function b.Initialise(f)local g,h=f:Checkbox('Auto Blackflash',false),f:
KeyPicker('Auto Blackflash Hotkey',true)cheat.Register('onPaint',function()b.
Runtime()end)cheat.Register('onUpdate',function()b.Enabled=g:Get()b.
HotkeyEnabled=h:Get()==true end)end return b end function a.i()local b,c,d,e,f={
Enabled=false,BindPressed=false,StandingDelay=500,RagdollDelay=250,_Waiting=
false,_NextPressTime=0,_WasDown=false},entity.GetLocalPlayer(),a.load'a',a.load
'f',function()local b,c,d=utility.GetMousePos(),(math.huge)for e,f in pairs(
entity.GetPlayers(false))do local g,h,i=utility.WorldToScreen(f.Position)if i
then local j,k=g-b[1],h-b[2]local l=math.sqrt(j*j+k*k)if l<c then d=f c=l end
end end return d,c end function b.Runtime()if not b.Enabled then return end if
not b.BindPressed then return end if d.LocalInfo.SelectedCharacter~='Todo'then
return end local g,h=utility.GetTickCount(),keyboard.IsPressed'r'if h and not b.
_WasDown and not b._Waiting then if e:GetPlayerUltimate(c)<4 then return end
local i,j=f()if j>195 then return end if i then local k=(c.Position-i.Position).
Magnitude if k>50 then return end local l,m=e:DoesPlayerHaveMove(c,'Brothers'),e
:GetPlayerRagdollState(i)local n,o=m and b.RagdollDelay or b.StandingDelay,d.
LocalInfo.Ping or 0 n=n-o if n<0 then n=0 end if l then n=250 end b.
_NextPressTime=g+n b._Waiting=true end end if b._Waiting and g>=b._NextPressTime
then mouse.Click'leftmouse'b._Waiting=false end b._WasDown=h end function b.
Initialise(g)local h,i=g:Checkbox('Todo Perfect Swap',false),g:KeyPicker(
'Todo Perfect Swap Hotkey',true)cheat.Register('onUpdate',function()b.Runtime()b
.Enabled=h:Get()b.BindPressed=i:Get()==true end)end return b end function a.j()
local b,c,d,e={Enabled=false,BindEnabled=false,Delay=0.65,_WasWoosh=false,
_Waiting=true,_NextPressTime=0},entity.GetLocalPlayer(),a.load'a',a.load'f'
function b.Runtime()if not b.Enabled then return end if not b.BindEnabled then
return end if d.LocalInfo.SelectedCharacter~='Todo'or not e:DoesPlayerHaveMove(c
,'Brute Force')then return end local f=c:GetBoneInstance'HumanoidRootPart'if not
f then return end local g,h=f:FindFirstChild'Woosh',utility.GetTickCount()if g
and not b._WasWoosh and not b._Waiting then local i=b.Delay or 0 local j,k=i*
1000,d.LocalInfo.Ping or 0 j=j-k if j<0 then j=0 end b._NextPressTime=h+j b.
_Waiting=true end if b._Waiting and h>=b._NextPressTime then keyboard.Click(0x32
)b._Waiting=false end b._WasWoosh=g~=nil end function b.Initialise(f)local g,h=f
:Checkbox('Todo Blackflash',false),f:KeyPicker('Todo Blackflash Hotkey',true)
cheat.Register('onUpdate',function()b.Enabled=g:Get()b.BindEnabled=h:Get()==true
b.Runtime()end)end return b end function a.k()local b,c,d,e,f={Enabled=false,
DrawCooldowns=false,DrawEvasiveBar=false,CooldownFillColour=Color3.fromRGB(255,0
,0),CooldownFillAlpha=180,CooldownBackgroundColour=Color3.fromRGB(0,0,0),
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
o,t,n,n,e)local u,v=r.Name,c.Font local w=u if n<40 then v='SmallestPixel'end if
n<25 then w=string.sub(u,1,1)elseif n<40 then w=string.sub(u,1,3)end if n>=15
then local x,y=draw.GetTextSize(w,v)local z,A=o+(n-x)/2,t+(n-y)/2 draw.
TextOutlined(w,z,A,e,v)end end end end function b.Draw()if not b.Enabled then
return end for g,h in pairs(entity.GetPlayers(false))do local j=c.Players[h.Name
]if j then b.DrawPlayer(h,j)end end end function b.Initialise(g)local h,j,k,l,m,
n=g:Checkbox('Character Info',false),g:Checkbox('Cooldowns',false),g:
Colorpicker('Cooldown Fill Color',{r=255,g=0,b=0,a=180},true),g:Colorpicker(
'Cooldown Background Color',{r=0,g=0,b=0,a=200},true),g:Checkbox('Evasive Bar',
false),g:Colorpicker('Evasive Fill Color',{r=121,g=74,b=148,a=255},true)cheat.
Register('onPaint',function()b.Draw()end)cheat.Register('onSlowUpdate',function(
)b.Enabled=h:Get()b.DrawCooldowns=j:Get()b.DrawEvasiveBar=m:Get()local o=k:Get()
b.CooldownFillColour=f(o)b.CooldownFillAlpha=o.a local p=l:Get()b.
CooldownBackgroundColour=f(p)b.CooldownBackgroundAlpha=o.a b.EvasiveBarColour=n:
Get'rgb'end)end return b end function a.l()local b,c,d={Enabled=false,TextColor=
Color3.fromRGB(255,255,255),TextAlpha=255},a.load'a',function(b)if type(b)~=
'table'then return Color3.fromRGB(255,255,255)end local c,d,e=b.R or b.r or 255,
b.G or b.g or 255,b.B or b.b or 255 return Color3.fromRGB(c,d,e)end function b.
Draw()if not b.Enabled then return end for e,f in pairs(c.Folders.Items)do local
g,h,j=utility.WorldToScreen(f.Position)if g and h and j then local k=f.Name
local l,m=draw.GetTextSize(k,c.Font)local n,o=g-(l/2),h-(m/2)if k~=''then draw.
TextOutlined(k,n,o,b.TextColor,c.Font,b.TextAlpha)end end end end function b.
Initialise(e)local f,g=e:Checkbox('Item ESP',b.Enabled),e:Colorpicker(
'Item ESP Text Color',{r=255,g=255,b=255,a=b.TextAlpha},true)cheat.Register(
'onPaint',b.Draw)cheat.Register('onUpdate',function()local h=g:Get()b.Enabled=f:
Get()b.TextColor=d(h)b.TextAlpha=h.A end)end return b end function a.m()local b,
c,d,e={Enabled=false,TextColor=Color3.fromRGB(255,255,255),TextAlpha=255},a.load
'a',function(b,c,d)local e=b:GetAttribute(c)return e and e.Value or d end,
function(b)if type(b)~='table'then return Color3.fromRGB(255,255,255)end local c
,d,e=b.R or b.r or 255,b.G or b.g or 255,b.B or b.b or 255 return Color3.
fromRGB(c,d,e)end function b.Draw()if not b.Enabled then return end local f,g=
cheat.GetWindowSize()for h,j in pairs(c.Folders.Domains)do local k=d(j,'Health',
0)local l='Domain Health: '..tostring(math.floor(k))local m,n=draw.GetTextSize(l
,c.Font)local o,p,q,r=c.ClosestDomain,false if o.Instance and j==o.Instance and
o.Distance<=40 then q=(f/2)-(m/2)r=50 p=true else local s,t,u=utility.
WorldToScreen(j.Position)if s and t and u then q=s-m/2 r=t-n/2 p=u end end if p
and l~=''then draw.TextOutlined(l,q,r,b.TextColor,c.Font,b.TextAlpha)end end end
function b.Initialise(f)local g,h=f:Checkbox('Visualise Domain Health',b.Enabled
),f:Colorpicker('Domain Health Text Color',{r=255,g=255,b=255,a=b.TextAlpha},
true)cheat.Register('onPaint',b.Draw)cheat.Register('onUpdate',function()local j
=h:Get()b.Enabled=g:Get()b.TextColor=e(j)b.TextAlpha=j.A end)end return b end
function a.n()local b,c={},a.load'a'function b.Initialise(d)local e=d:Dropdown(
'Font Selection',{'ConsolasBold','SmallestPixel','Verdana','Tahoma'},1)cheat.
Register('onUpdate',function()c.Font=e:Get()end)end return b end function a.o()
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
Rates[c]=d end return b end function a.p()local b,c,d,e,f={},game.GetService
'Workspace',game.GetService'Stats',game.LocalPlayer,entity.GetLocalPlayer()local
g,h,j=c:FindFirstChild'Domains',c:FindFirstChild'Items',d:FindFirstChild
'Network'local k=j.ServerStatsItem local l,m,n,o=k['Data Ping'],a.load'a',a.load
'o'.New(),function(l,m,n)local o=l:GetAttribute(m)return o and o.Value or n end
local p=function()m.LocalInfo.SelectedCharacter=o(m.LocalInfo.Player,'Moveset',
'[???}')m.LocalInfo.Ping=l.Value end function b.Initialise(q)m.LocalInfo.Player=
e m.LocalInfo.PlayerGui=m.LocalInfo.Player and m.LocalInfo.Player:FindFirstChild
'PlayerGui'n:AddCategory('Domains',{g},2000)n:AddCategory('Items',{h},2000)n:
SetCallback('Domains',function(r,s,t)local u,v=(math.huge)for w,x in pairs(t)do
local y=x:FindFirstChildOfClass'MeshPart'local z=(y.Position-f.Position).
Magnitude if z<u then v=x u=z end end m.ClosestDomain.Instance=v m.ClosestDomain
.Distance=u end)cheat.Register('onUpdate',function()p()n:Update()m.Folders.
Domains=n:GetCached'Domains'm.Folders.Items=n:GetCached'Items'end)end return b
end function a.q()local b=a.load'd'local c=function(c,d)if not c or not d then
return end local e,f=(math.huge)for g,h in pairs(c:GetChildren())do local j=b.
GetFrameCenter(h)local k,l=math.abs(j.X-d.X),h.Pass.Value==1 if not l then if k<
e then f=h e=k end end end return f end return function(d)if not d then return
end local e=d.Screen.Game local f=e.Guy if b.IsFrameVisible(f.Explode)then
return end local g,h=e.Walls,b.GetFrameCenter(f)local j=c(g,h)if not j then
print'No closest'return end local k,l=j.Top,j.Bottom local m,n=b.
GetFrameAnchorPoint(k),b.GetFrameAnchorPoint(l)print(m.X,m.Y)print(n.X,n.Y)end
end function a.r()local b=a.load'd'local c=function(c,d)local e,f=c.BG1.Floor,c.
Food if not e or not f then print
"Minigame Critical Error | Couldn't find floor or food!"return nil end local g,h
,j,k,l=b.GetFramePosition(e),b.GetFrameSize(e),(math.huge)for m,n in pairs(f:
GetChildren())do local o=b.GetFrameCenter(n)local p,q=math.abs(o.X-d.X),g.Y-o.Y
local r=n.Name=='Speed'and p>(h.X*0.45)if not r then if q<j then k=n l=o j=q end
end end return k,l end return function(d)if not d then return end local e=d.
Screen.Game local f=e.Guy if b.IsFrameVisible(f.Explode)then return end local g=
b.GetFrameCenter(f)local h,j=c(e,g)if not h or not j then return end local k=j.X
-g.X if math.abs(k)<0.03 then k=0 end if k<0 then keyboard.click'a'elseif k>0
then keyboard.click'd'end end end function a.s()local b,c,d={Enabled=false,
FlightGame=false,CatchGame=false,GameUI=nil,GameType=nil},a.load'a',{FlightGame=
a.load'q',CatchGame=a.load'r'}local e,f=function(e)local f=d[b.GameType]return f
and f(e)or nil end,function(e,f,g)local h=e:Get()b.Enabled=h if h then b.
FlightGame=f:Get()b.CatchGame=g:Get()end f:Visible(h)g:Visible(h)end function b.
Initialise(g)local h,j,k=g:Checkbox('Minigames Enabled',false),g:Checkbox(
'Flight Game',false),g:Checkbox('Catch Game',false)cheat.Register('onUpdate',
function()f(h,j,k)if not utility.GetMenuState()and b.Enabled and b.GameUI and b.
GameType and b[b.GameType]==true then e(b.GameUI)end end)cheat.Register(
'onSlowUpdate',function()if not b.Enabled then return end b.GameUI=c.LocalInfo.
PlayerGui:FindFirstChild'DeviceUI'if b.GameUI then local l=b.GameUI:
FindFirstChild'DeviceSystem'local m=l:FindFirstChild'Wall'and'FlightGame'or l:
FindFirstChild'Food'and'CatchGame'or nil b.GameType=m else b.GameType=nil end
end)end return b end function a.t()return function()function math.floor(b)return
b-(b%1)end function math.clamp(b,c,d)return math.max(c,math.min(d,b))end end end
end local b,c,d,e,f,g,h,j,k,l,m,n,o,p=a.load'b',a.load'e',a.load'h',a.load'i',a.
load'j',a.load'k',a.load'l',a.load'm',a.load'n',a.load'p',a.load'f',a.load's',a.
load'g',a.load't'local q=function()local q=o.NewTab('DiddyWare_JJS','DiddyWare')
local r,s,t,u=q:Container('DiddyWare_JJSC1','Main',{autosize=true,next=true}),q:
Container('DiddyWare_JJSC2','Visuals',{autosize=true}),q:Container(
'DiddyWare_JJSC3','Settings',{autosize=true,next=true}),q:Container(
'DiddyWare_JJSC4','Misc',{autosize=true})p()m.Initialise(t)l.Initialise(t)d.
Initialise(r)f.Initialise(r)e.Initialise(r)c.Initialise(r)b.Initialise(r)g.
Initialise(s)j.Initialise(s)h.Initialise(s)k.Initialise(t)n.Initialise(u)end q()
