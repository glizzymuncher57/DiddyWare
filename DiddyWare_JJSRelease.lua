--!nocheck
--!nolint

_P = {
	genDate = "2026-03-04T17:37:23.143364800+00:00",
	cfg = "Release",
	vers = "",
}

local a a={cache={},load=function(b)if not a.cache[b]then a.cache[b]={c=a[b]()}
end return a.cache[b].c end}do function a.a()return{Font='ConsolasBold',
DebugMode=false,LocalInfo={Player=nil,PlayerGui=nil,Character=nil,MinigameUI=nil
,SelectedCharacter=nil,Ping=0},Players={},Folders={Items={},Domains={}},
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
return b end function a.c()local b={DoubleConstrainedValue={Value={Type='double'
,Offset=0xe0}},ScreenGui={Enabled={Type='bool',Offset=0x4bc}},GuiObject={
AbsolutePosition={Type='float',X=0x110,Y=0x114},Rotation={Type='float',Offset=
0x188},Position={Type='float',X=0x508,Y=0x510},Visible={Type='bool',Offset=0x5a1
},Size={Type='float',X=0x528,Y=0x530},AbsoluteSize={Type='float',X=0x118,Y=0x11c
}},Animator={AnimationTrackList=0x650},Animation={AnimationId=0xd0},
AnimationTrack={Animation=0xd0,WeightTarget=0xf0,Speed=0xe4,TimePosition=0xe8,
Looped=0xf5}}return b end function a.d()local b,c,d={Enabled=false,
CurrentAddress=nil,PressedR=false},a.load'c',a.load'a'function b.Runtime()if d.
LocalInfo.SelectedCharacter~='Nanami'then return end if not b.Enabled then
return end local e=entity.GetPlayers(false)for f,g in pairs(e)do coroutine.
resume(coroutine.create(function()local h=g:GetBoneInstance'HumanoidRootPart'if
not h then return end local i=h:FindFirstChild'Ratio'if not i then return end if
not memory.read('bool',i.Address+c.ScreenGui.Enabled)then return end if not b.
CurrentAddress or b.CurrentAddress~=i.Address then b.CurrentAddress=i.Address b.
PressedR=false end local j=i:FindFirstChild'Bar'if not j then return end local k
,l=j:FindFirstChild'Bar',j:FindFirstChild'Cursor'if not k or not l then return
end local m=memory.Read('float',l.Address+c.GuiObject.Size.Y)if math.abs(m-0.3)
<=0.03 and not b.PressedR then keyboard.Click'r'b.PressedR=true end end))end end
function b.Initialise(e)local f=e:Checkbox'Nanami QTE'cheat.Register('onPaint',b
.Runtime)cheat.Register('onUpdate',function()b.Enabled=f:Get()end)end return b
end function a.e()local b,c,d,e,f,g,h={LastRebuild=0,LastCooldownUpdate=0},game.
GetService'Players',a.load'a',entity.GetLocalPlayer(),{},{},function(b,c,d)local
e=b:GetAttribute(c)return e and e.Value or d end local i=function(i,j)if not i
or not i.Name then return end local k,l=c:FindFirstChild(i.Name),i:
GetBoneInstance'HumanoidRootPart'if not l then return end local m=l.Parent if
not m then return end local n,o=m:FindFirstChildOfClass'Humanoid',m:
FindFirstChild'Moveset'if not o then return end local p=d.Players[i.Name]local q
,r,s=p and p.Moves or nil,{},{}for t,u in pairs(o:GetChildren())do local v,w,x=u
.Name,h(u,'Key',1),u.Value or 0 local y,z=q and q[v],i.UserId..':'..v local A={
Name=v,Key=w,Cooldown=x,Instance=u,MoveKey=z,IsOnCooldown=y and y.IsOnCooldown
or false,Remaining=y and y.Remaining or 0}r[#r+1]=A s[v]=A end table.sort(r,
function(t,u)return t.Key<u.Key end)j[i.Name]={Player=i,Character=m,Humanoid=n,
SelectedMoveset=h(m,'Moveset','[???]'),Evade=h(m,'Evade',50),Ultimate=k and h(k,
'Ultimate',0)or 0,Ragdolled=h(m,'Ragdoll',0),Moves=s,OrderedMoves=r,Animations=p
and p.Animations or{}}end local j,k=function()local j,k={},entity.
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
end)end return b end function a.f()local b,c={},{}c.__index=c function c:Get()
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
return setmetatable({Ref=g},f)end return b end function a.g()local b,c,d,e={
Enabled=false,HotkeyEnabled=false,Timings={Itadori=0.285,Mahito=0.285},_Waiting=
false,_NextPressTime=0,_WasDown=false},entity.GetLocalPlayer(),a.load'a',a.load
'e'function b.Runtime()if not b.Enabled then return end if not b.HotkeyEnabled
then return end local f=d.LocalInfo.SelectedCharacter if f~='Mahito'and f~=
'Itadori'then return end local g,h=utility.GetTickCount(),keyboard.IsPressed(
0x33)if not e:DoesPlayerHaveMove(c,'Focus Strike')and not e:DoesPlayerHaveMove(c
,'Divergent Fist')then return end if h and not b._WasDown and not b._Waiting
then local i=b.Timings[f]or 0 local j,k=i*1000,d.LocalInfo.Ping or 0 j=j-k if j<
0 then j=0 end if d.DebugMode then print('Executing Blackflash Delay: '..
tostring(g+j))end b._NextPressTime=g+j b._Waiting=true end if b._Waiting and g>=
b._NextPressTime then keyboard.Click(0x33)b._Waiting=false if d.DebugMode then
print'Executed Blackflash'end end b._WasDown=h end function b.Initialise(f)local
g,h=f:Checkbox('Auto Blackflash',false),f:KeyPicker('Auto Blackflash Hotkey',
true)cheat.Register('onPaint',function()b.Runtime()end)cheat.Register('onUpdate'
,function()b.Enabled=g:Get()b.HotkeyEnabled=h:Get()==true end)end return b end
function a.h()local b,c,d,e,f={Enabled=false,BindPressed=false,_Waiting=false,
_WasClapping=false},entity.GetLocalPlayer(),a.load'a',a.load'e',{Clap1=true,
Clap2=true,Clap3=true}local g=function()local g=e:ReturnLocalPlayer()local h=g.
Animations for i=1,#h do local j=h[i]if f[j.Animation.Name]then return j end end
return nil end function b.Runtime()if not b.Enabled then return end if not b.
BindPressed then return end if d.LocalInfo.SelectedCharacter~='Todo'then return
end local h=g()if e:GetPlayerUltimate(c)<4 and not h and not b._Waiting then
return end if h and not b._WasClapping and not b._Waiting then b._Waiting=true
end if b._Waiting then if not h then b._Waiting=false elseif h.TimePosition>=
0.65 then mouse.Click'leftmouse'b._Waiting=false end end b._WasClapping=h~=nil
end function b.Initialise(h)local i,j=h:Checkbox('Todo Perfect Swap',false),h:
KeyPicker('Todo Perfect Swap Hotkey',true)cheat.Register('onUpdate',function()b.
Runtime()b.Enabled=i:Get()b.BindPressed=j:Get()==true end)end return b end
function a.i()local b,c,d,e,f={Enabled=false,BindEnabled=false,WasSliding=false,
Waiting=false,BrutForceStarted=false},entity.GetLocalPlayer(),a.load'a',a.load
'e',{Slide={AnimationID='rbxassetid://100081544058065'},['Brute Force']={
AnimationID='rbxassetid://123167492985370',TimePosition=2.9}}local g=function(g)
local h=e:ReturnLocalPlayer()local i=h.Animations if not i then return nil end
for j=1,#i do if i[j].Animation.AnimationId==g then return i[j]end end return
nil end function b.Runtime()if not b.Enabled then return end if not b.
BindEnabled then return end if d.LocalInfo.SelectedCharacter~='Todo'or not e:
DoesPlayerHaveMove(c,'Brute Force')then return end local h=g(f.Slide.AnimationID
)if h and not b.WasSliding and not b.Waiting then b.Waiting=true end if b.
Waiting then local i=g(f['Brute Force'].AnimationID)if not h and not i then b.
Waiting=false b.BruteForceStarted=false elseif i then b.BruteForceStarted=true
if i.TimePosition>=f['Brute Force'].TimePosition then keyboard.Click(0x32)b.
Waiting=false b.BruteForceStarted=false end end end b.WasSliding=h end function
b.Initialise(h)local i,j=h:Checkbox('Todo Blackflash',false),h:KeyPicker(
'Todo Blackflash Hotkey',true)cheat.Register('onUpdate',function()b.Enabled=i:
Get()b.BindEnabled=j:Get()==true b.Runtime()end)end return b end function a.j()
local b,c,d,e,f={Enabled=false,DrawCooldowns=false,DrawEvasiveBar=false,
CooldownFillColour=Color3.fromRGB(255,0,0),CooldownFillAlpha=180,
CooldownBackgroundColour=Color3.fromRGB(0,0,0),CooldownBackgroundAlpha=0,
EvasiveBarColour=Color3.fromRGB(121,74,148)},a.load'a',Color3.new(0,0,0),Color3.
new(1,1,1),function(b)if type(b)~='table'then return Color3.fromRGB(255,255,255)
end local c,d,e=b.R or b.r or 255,b.G or b.g or 255,b.B or b.b or 255 return
Color3.fromRGB(c,d,e)end function b.DrawPlayer(g,h)if not g.IsAlive then return
end local i,j,k=utility.WorldToScreen(g.Position)if not k then return end local
l=g.BoundingBox if not l then return end if b.DrawEvasiveBar and h.Evade then
local m=math.clamp(h.Evade/50,0,1)local n,o,p,q=l.h*m,l.x-8,l.y,l.h draw.
RectFilled(o-1,p-1,7,q+2,d,0,255)draw.RectFilled(o,p+q-n,5,n,b.EvasiveBarColour,
0,255)local r=tostring(math.floor(m*100))..'%'local s=draw.GetTextSize(r,c.Font)
draw.TextOutlined(r,o-s-2,p,e,c.Font)end if b.DrawCooldowns and#h.OrderedMoves>0
then local m=#h.OrderedMoves local n,o,p=l.h/m,l.x+l.w+2,l.y for q=1,#h.
OrderedMoves do local r=h.OrderedMoves[q]local s,t=r.Remaining,p+(q-1)*n draw.
RectFilled(o,t,n,n,b.CooldownBackgroundColour,0,b.CooldownBackgroundAlpha)if s>0
then local u=s/r.Cooldown local v=n*u draw.RectFilled(o+n-v,t,v,n,b.
CooldownFillColour,0,b.CooldownFillAlpha)end draw.Rect(o,t,n,n,e)local u,v=r.
Name,c.Font local w=u if n<40 then v='SmallestPixel'end if n<25 then w=string.
sub(u,1,1)elseif n<40 then w=string.sub(u,1,3)end if n>=15 then local x,y=draw.
GetTextSize(w,v)local z,A=o+(n-x)/2,t+(n-y)/2 draw.TextOutlined(w,z,A,e,v)end
end end end function b.Draw()if not b.Enabled then return end for g,h in pairs(
entity.GetPlayers(false))do local j=c.Players[h.Name]if j then b.DrawPlayer(h,j)
end end end function b.Initialise(g)local h,j,k,l,m,n=g:Checkbox(
'Character Info',false),g:Checkbox('Cooldowns',false),g:Colorpicker(
'Cooldown Fill Color',{r=255,g=0,b=0,a=180},true),g:Colorpicker(
'Cooldown Background Color',{r=0,g=0,b=0,a=200},true),g:Checkbox('Evasive Bar',
false),g:Colorpicker('Evasive Fill Color',{r=121,g=74,b=148,a=255},true)cheat.
Register('onPaint',function()b.Draw()end)cheat.Register('onSlowUpdate',function(
)b.Enabled=h:Get()b.DrawCooldowns=j:Get()b.DrawEvasiveBar=m:Get()local o=k:Get()
b.CooldownFillColour=f(o)b.CooldownFillAlpha=o.a local p=l:Get()b.
CooldownBackgroundColour=f(p)b.CooldownBackgroundAlpha=o.a b.EvasiveBarColour=n:
Get'rgb'end)end return b end function a.k()local b,c,d={Enabled=false,TextColor=
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
Get()b.TextColor=d(h)b.TextAlpha=h.A end)end return b end function a.l()local b,
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
function a.m()local b,c={},a.load'a'function b.Initialise(d)local e,f=d:
Dropdown('Font Selection',{'ConsolasBold','SmallestPixel','Verdana','Tahoma'},1)
,d:Checkbox('Debug Mode',false)cheat.Register('onUpdate',function()c.Font=e:Get(
)c.DebugMode=f:Get()end)end return b end function a.n()local b={}b.__index=b
function b.New()local c=setmetatable({},b)c.Queues={}c.Indexes={}c.Caches={}c.
Callbacks={}c.Rates={}c.LastUpdate={}return c end function b:AddCategory(c,d,e,f
)self.Queues[c]=d or{}self.Indexes[c]=1 self.Caches[c]={}self.Rates[c]=e or 50
self.LastUpdate[c]=0 self.Selectors=self.Selectors or{}self.Selectors[c]=f end
function b:SetCallback(c,d)self.Callbacks[c]=d end function b:Update()local c=
utility.GetTickCount()for d,e in pairs(self.Queues)do local f,g=self.Rates[d]or
50,self.LastUpdate[d]or 0 if c-g>=f then local h=self.Indexes[d]local j=e[h]if j
then local k,l,m=j:GetChildren(),self.Selectors and self.Selectors[d],{}for n=1,
#k do local o=k[n]if l then o=l(o)end if o then m[o.Name]=o end end self.Caches[
d]=m local n=self.Callbacks[d]if n then n(d,j,k)end end h=h+1 if h>#e then h=1
end self.Indexes[d]=h self.LastUpdate[d]=c end end end function b:GetCached(c)
local d=self.Caches[c]if not d then return{}end local e={}for f,g in pairs(d)do
e[#e+1]=g end return e end function b:ClearCache(c)self.Caches[c]={}end function
b:SetInterval(c,d)self.Rates[c]=d end return b end function a.o()local b,c,d,e,f
={},game.GetService'Workspace',game.GetService'Stats',game.LocalPlayer,entity.
GetLocalPlayer()local g,h,j=c:FindFirstChild'Domains',c:FindFirstChild'Items',d:
FindFirstChild'Network'local k=j.ServerStatsItem local l,m,n,o=k['Data Ping'],a.
load'a',a.load'n'.New(),function(l,m,n)local o=l:GetAttribute(m)return o and o.
Value or n end local p=function()m.LocalInfo.SelectedCharacter=o(m.LocalInfo.
Player,'Moveset','[???}')m.LocalInfo.Ping=l.Value end function b.Initialise(q)m.
LocalInfo.Player=e m.LocalInfo.PlayerGui=m.LocalInfo.Player and m.LocalInfo.
Player:FindFirstChild'PlayerGui'n:AddCategory('Domains',{g},2000)n:AddCategory(
'Items',{h},2000)n:SetCallback('Domains',function(r,s,t)local u,v=(math.huge)for
w,x in pairs(t)do local y=x:FindFirstChildOfClass'MeshPart'local z=(y.Position-f
.Position).Magnitude if z<u then v=x u=z end end m.ClosestDomain.Instance=v m.
ClosestDomain.Distance=u end)cheat.Register('onUpdate',function()p()n:Update()m.
Folders.Domains=n:GetCached'Domains'm.Folders.Items=n:GetCached'Items'end)end
return b end function a.p()local b,c,d,e,f,g,h=a.load'a',a.load'e',a.load'c',
memory.read,math.floor,math.min,math.max local j,k={__index=function(j,k)local l
=j.track if k=='TimePosition'then return f(e('float',l+d.AnimationTrack.
TimePosition)*100)/100 elseif k=='Speed'then return f(e('float',l+d.
AnimationTrack.Speed)*100)/100 elseif k=='Looped'then return e('bool',l+d.
AnimationTrack.Looped)elseif k=='WeightTarget'then return h(0,g(1,e('float',l+d.
AnimationTrack.WeightTarget)))else return nil end end},{Animators={},Tracks={},
Animations={}}local l=function(l)local m=k.Animators[l]if m then return m end
local n=l:find_first_child_of_class'Animator'if not n then return 0 end m=n.
Address k.Animations[l]=m return m end local m,n=function(m)local n,o={},l(m)if
o==0 then return n end local p=e('ptr',o+d.Animator.AnimationTrackList)if p==0
then return n end local q=e('ptr',p)while q~=0 and q~=p do local r=e('ptr',q+
0x10)if r~=0 then local s=k.Tracks[r]if not s then local t=e('ptr',r+d.
AnimationTrack.Animation)if t~=0 then local u=e('string',t+d.Animation.
AnimationId)if u~=''then s={track=r,Animation={AnimationId=u,Name=k.Animations[u
]or'Unknown'}}setmetatable(s,j)k.Tracks[r]=s end end end if s then n[#n+1]=s end
end q=e('ptr',q)end return n end,function()local m=game.DataModel:
GetDescendants()for n=1,#m do local o=m[n]if o:is_a'Animation'then local p=e(
'string',o.Address+d.Animation.AnimationId)if p~=''then k.Animations[p]=o.Name
end end end end function k.Initialise(o)local p=getmetatable(game.DataModel)
local q=p.__index p.__index=function(r,s)if s=='get_animator'or s=='GetAnimator'
then return l elseif s=='get_playing_animation_tracks'or s==
'GetPlayingAnimationTracks'then return m elseif s=='get_animations'or s==
'GetAnimations'then return n end return q(r,s)end n()cheat.register('onUpdate',
function()local r=c:ReturnLocalPlayer()if not r then return end local s=r.
Humanoid if not s then return end r.Animations=s:get_playing_animation_tracks()
end)end return k end function a.q()local b,c,d=a.load'c',memory.read,{}function
d.Read(e,f)return c(f.Type,e.Address+(f.Offset or 0x0))end function d.
GetFramePosition(e)return d.ReadVector2(e,b.GuiObject.AbsolutePosition)end
function d.GetFrameSize(e)return d.ReadVector2(e,b.GuiObject.AbsoluteSize)end
function d.GetFrameCenter(e)local f,g=d.ReadVector2(e,b.GuiObject.
AbsolutePosition),d.ReadVector2(e,b.GuiObject.AbsoluteSize)return f+(g/2)end
function d.ReadVector2(e,f)local g=e.Address return Vector3.new(c(f.Type,g+f.X),
c(f.Type,g+f.Y),0)end function d.GetFrameRotation(e)return d.Read(e,b.GuiObject.
Rotation)end function d.IsFrameVisible(e)return d.Read(e,b.GuiObject.Visible)end
return d end function a.r()local b,c=a.load'q',0 local d=function(d,e,f)local g,
h,j=math.huge,(f.X*0.05)for k,l in pairs(d:GetChildren())do local m,n=b.
GetFrameCenter(l),b.GetFrameSize(l.Top)local o=m.X+(n.X/2)local p=o+h>e.X if p
then local q=m.X-e.X if q<g then j=l g=q end end end return j end return
function(e)if not e then return end local f=e.Screen.Game local g,h=f.Guy,
utility.GetTickCount()if b.IsFrameVisible(g.Explode)then return end local j,k=b.
GetFrameSize(f),b.GetFrameCenter(g)local l=d(f.Walls,k,j)if not l then return
end local m,n=l.Top,l.Bottom local o,p,q=b.GetFramePosition(m),b.GetFrameSize(m)
,b.GetFramePosition(n)local r,s=o.Y+p.Y,q.Y local t=s-r local u,v=r+t*0.5,t*0.1
local w=u+v if k.Y>w and h-c>25 then mouse.Click'leftmouse'c=h end end end
function a.s()local b=a.load'q'local c=function(c,d)local e,f=c.BG1.Floor,c.Food
if not e or not f then print
"Minigame Critical Error | Couldn't find floor or food!"return nil end local g,h
=b.GetFramePosition(e),b.GetFrameSize(e)local j,k,l,m=h.X*0.15,(math.huge)for n,
o in pairs(f:GetChildren())do local p=b.GetFrameCenter(o)local q,r=math.abs(p.X-
d.X),g.Y-p.Y local s=o.Name=='Speed'and q>j if not s then if r<k then l=o m=p k=
r end end end return l,m end return function(d)if not d then return end local e=
d.Screen.Game local f=e.Guy if b.IsFrameVisible(f.Explode)then return end local
g=b.GetFrameCenter(f)local h,j=c(e,g)if not h or not j then return end local k=j
.X-g.X if math.abs(k)>=20 then if k<0 then keyboard.click'a'else keyboard.click
'd'end end end end function a.t()local b,c,d={Enabled=false,FlightGame=false,
CatchGame=false,GameUI=nil,GameType=nil},a.load'a',{FlightGame=a.load'r',
CatchGame=a.load's'}local e,f=function(e)local f=d[b.GameType]return f and f(e)
or nil end,function(e,f,g)local h=e:Get()b.Enabled=h if h then b.FlightGame=f:
Get()b.CatchGame=g:Get()end f:Visible(h)g:Visible(h)end function b.Initialise(g)
local h,j,k=g:Checkbox('Minigames Enabled',false),g:Checkbox('Flight Game',false
),g:Checkbox('Catch Game',false)cheat.Register('onUpdate',function()f(h,j,k)if
not utility.GetMenuState()and b.Enabled and b.GameUI and b.GameType and b[b.
GameType]==true then e(b.GameUI)end end)cheat.Register('onSlowUpdate',function()
if not b.Enabled then return end b.GameUI=c.LocalInfo.PlayerGui:FindFirstChild
'DeviceUI'if b.GameUI then local l=b.GameUI:FindFirstChild'DeviceSystem'local m=
l:FindFirstChild'Wall'and'FlightGame'or l:FindFirstChild'Food'and'CatchGame'or
nil b.GameType=m else b.GameType=nil end end)end return b end function a.u()
return function()function math.floor(b)return b-(b%1)end function math.clamp(b,c
,d)return math.max(c,math.min(d,b))end end end end local b,c,d,e,f,g,h,j,k,l,m,n
,o,p,q=a.load'b',a.load'd',a.load'g',a.load'h',a.load'i',a.load'j',a.load'k',a.
load'l',a.load'm',a.load'o',a.load'e',a.load'p',a.load't',a.load'f',a.load'u'
local r=function()local r=p.NewTab('DiddyWare_JJS','DiddyWare')local s,t,u,v=r:
Container('DiddyWare_JJSC1','Main',{autosize=true,next=true}),r:Container(
'DiddyWare_JJSC2','Visuals',{autosize=true}),r:Container('DiddyWare_JJSC3',
'Settings',{autosize=true,next=true}),r:Container('DiddyWare_JJSC4','Misc',{
autosize=true})q()m.Initialise(u)n.Initialise(u)l.Initialise(u)d.Initialise(s)f.
Initialise(s)e.Initialise(s)c.Initialise(s)b.Initialise(s)g.Initialise(t)j.
Initialise(t)h.Initialise(t)k.Initialise(u)o.Initialise(v)end r()
