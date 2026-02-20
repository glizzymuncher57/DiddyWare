--!nocheck
--!nolint

_P = {
	genDate = "2026-02-20T12:34:05.766834500+00:00",
	cfg = "Release",
	vers = "",
}

local a a={cache={},load=function(b)if not a.cache[b]then a.cache[b]={c=a[b]()}
end return a.cache[b].c end}do function a.a()return{Font='ConsolasBold',
DistanceFade=false,LocalInfo={Player=nil,PlayerGui=nil,Character=nil,MinigameUI=
nil,CurrentLevel=nil},Structures={InternalStructures={},ExternalStructures={}},
CurrentHouse=nil}end function a.b()return{ScreenGui_Enabled=0x4cc,Frame_Visible=
0x5b1,FramePosition={X_Scale=0x518,X_Offset=0x110,Y_Scale=0x520,Y_Offset=0x114},
FrameSize={X_Scale=0x538,X_Offset=0x118,Y_Scale=0x540,Y_Offset=0x11c},
FrameRotation=0x188}end function a.c()local b,c=a.load'b',{}function c.
GetFramePosition(d)local e=d.Address return Vector3.new(memory.read('float',e+b.
FramePosition.X_Offset),memory.read('float',e+b.FramePosition.Y_Offset),0)end
function c.GetFrameSize(d)local e=d.Address return Vector3.new(memory.read(
'float',e+b.FrameSize.X_Offset),memory.read('float',e+b.FrameSize.Y_Offset),0)
end function c.GetFrameCenter(d)local e,f=c.GetFramePosition(d),c.GetFrameSize(d
)return e+(f/2)end function c.GetFrameRotation(d)return memory.read('float',d.
Address+b.FrameRotation)end function c.IsFrameVisible(d)return memory.read(
'bool',d.Address+b.Frame_Visible)end return c end function a.d()local b,c={},{}c
.__index=c function c:Get()return ui.getValue(self.TabRef,self.ContainerRef,self
.Name)end function c:Set(d)ui.setValue(self.TabRef,self.ContainerRef,self.Name,d
)end function c:Visible(d)ui.setVisibility(self.TabRef,self.ContainerRef,self.
Name,d)end local d={}d.__index=d local e=function(e,f,g)return setmetatable({
TabRef=e,ContainerRef=f,Name=g},c)end function d:Checkbox(f,g)ui.newCheckbox(
self.TabRef,self.Ref,f,g)return e(self.TabRef,self.Ref,f)end function d:
SliderInt(f,g,h,i)ui.newSliderInt(self.TabRef,self.Ref,f,g,h,i)return e(self.
TabRef,self.Ref,f)end function d:SliderFloat(f,g,h,i)ui.newSliderFloat(self.
TabRef,self.Ref,f,g,h,i)return e(self.TabRef,self.Ref,f)end function d:Dropdown(
f,g,h)ui.newDropdown(self.TabRef,self.Ref,f,g,h)local i=e(self.TabRef,self.Ref,f
)i.Get=function()local j=ui.getValue(self.TabRef,self.Ref,f)return g[j+1]end
return i end function d:Multiselect(f,g)ui.newMultiselect(self.TabRef,self.Ref,f
,g)local h=e(self.TabRef,self.Ref,f)h.Get=function()local i,j=ui.getValue(self.
TabRef,self.Ref,f),{}for k,l in ipairs(i)do if l then j[g[k] ]=true end end
return j end return h end function d:Colorpicker(f,g,h)ui.newColorpicker(self.
TabRef,self.Ref,f,g,h)local i=e(self.TabRef,self.Ref,f)i.Get=function(j,k)k=(
tostring(k)or'table'):lower()if k=='rgb'then local l=ui.getValue(self.TabRef,
self.Ref,f)return Color3.fromRGB(l.r,l.g,l.b)end return ui.getValue(self.TabRef,
self.Ref,f)end return i end function d:InputText(f,g)ui.newInputText(self.TabRef
,self.Ref,f,g)return e(self.TabRef,self.Ref,f)end function d:Button(f,g)ui.
newButton(self.TabRef,self.Ref,f,g)local h=e(self.TabRef,self.Ref,f)h.Get=nil h.
Set=nil return h end function d:Listbox(f,g,h)ui.newListbox(self.TabRef,self.Ref
,f,g,function()if h then local i=ui.getValue(self.TabRef,self.Ref,f)local j=g[i+
1]h(j)end end)return e(self.TabRef,self.Ref,f)end function d:KeyPicker(f,g,...)
ui.newHotkey(self.TabRef,self.Ref,f,g)local h=e(self.TabRef,self.Ref,f)h.Get=
function(i,j)if not j then j='Value'end local k={self.TabRef,self.Ref,f}return j
=='Value'and ui.getValue(unpack(k))or ui.getHotkey(unpack(k))end return h end
local f={}f.__index=f function f:Container(g,h,i)ui.newContainer(self.Ref,g,h,i
or{})return setmetatable({TabRef=self.Ref,Ref=g},d)end function b.NewTab(g,h)ui.
newTab(g,h)return setmetatable({Ref=g},f)end return b end function a.e()local b,
c,d,e,f={Enabled=false},a.load'a',a.load'c',a.load'b',function(b,c,d,e)return d
>=b.X and d<=b.X+c.X and e>=b.Y and e<=b.Y+c.Y end function b.Initialise(g)local
h=g:Checkbox'Auto Lockpick'cheat.Register('onUpdate',function()b.Enabled=h:Get()
if not PlayerGui then PlayerGui=c.LocalInfo.Player.PlayerGui end if b.Enabled
then local i=PlayerGui:FindFirstChild'UnlockMinigame'if not i then return end
local j=i.Frame.Bar if not d.IsFrameVisible(j)then print'bar is not visible'
return end local k,l,m=j.Zone.Red.Orange.LightGreen.Green,j.Zone.Slider,j.
TextButton if k and l and m then local n,o,p,q,r,s,t=utility.GetMousePos(),d.
GetFrameCenter(k),d.GetFrameCenter(l),d.GetFrameSize(k),d.GetFrameSize(l),d.
GetFramePosition(m),d.GetFrameSize(m)if not f(s,t,n[1],n[2])then print
'mosie not in bounds'return end if math.abs(p.X-o.X)<=(q.X-r.X)*0.5 then mouse.
Click'leftmouse'end end end end)end return b end function a.f()local b,c={},a.
load'a'function b.Runtime()for d,e in pairs(c.Structures.InternalStructures)do
local f=e.Prompts if f then for g,h in pairs(f)do h.HoldDuration=0 end end end
end function b.Initialise(d)local e=d:Checkbox'Instant Prompt'cheat.Register(
'onUpdate',function()if not e:Get()then return end b.Runtime()end)end return b
end function a.g()return{[20]=60,[10]=45,[8]=40,[6]=30,[4.5]=20,[3]=10,[2]=5,[1]
=1}end function a.h()local b,c,d,e,f={Enabled=false,ShowClosestLevel=false,
ShowDistance=false,NameColour=Color3.fromRGB(255,255,255),NameAlpha=255,
DistanceColour=Color3.fromRGB(255,255,255),DistanceAlpha=255},entity.
GetLocalPlayer(),a.load'g',a.load'a',function(b)if type(b)~='table'then return
Color3.fromRGB(255,255,255)end local c,d,e=b.R or b.r or 255,b.G or b.g or 255,b
.B or b.b or 255 return Color3.fromRGB(c,d,e)end local g=function(g)local h for
i,j in pairs(d)do if j<=tonumber(g)then if not h or j>h then h=j end end end
return h end function b.RenderObject(h,i)local j=h.RenderPart if not j then
return end local k,l,m=utility.WorldToScreen(j.Position)if not m then return end
local n,o=e.Font,h.Name local p,q=draw.GetTextSize(o,n)local r,s=0 if i.
ShowDistance then local t=math.floor((c.Position-j.Position).Magnitude)s='['..
tostring(t)..'m]'r=draw.GetTextSize(s,n)end local t=p+r local u,v=k-t/2,l-q/2
draw.TextOutlined(o,u,v,i.NameColour,n,i.NameAlpha)if i.ShowDistance then draw.
TextOutlined(s,u+p,v,i.DistanceColour,n,i.DistanceAlpha)end end function b.
Runtime()local h,i,j,k,l,m={},b.NameColour,b.NameAlpha,b.DistanceColour,b.
DistanceAlpha,b.ShowDistance if b.ShowClosestLevel then local n=g(e.LocalInfo.
CurrentLevel)for o,p in pairs(e.Structures.ExternalStructures)do if p.
RequiredLevel==n then h[#h+1]=p end end else h=e.Structures.ExternalStructures
end for n,o in pairs(h)do b.RenderObject(o,{NameColour=i,NameAlpha=j,
DistanceColour=k,DistanceAlpha=l,ShowDistance=m})end end function b.Initialise(h
)local i,j,k,l,m=h:Checkbox'External Structures',h:Colorpicker('Text Color',{r=
255,g=255,b=255,a=255},true),h:Checkbox'Building Distance',h:Colorpicker(
'Distance Color',{r=255,g=255,b=255,a=255},true),h:Checkbox
'Show Closest Level Buildings'cheat.Register('onUpdate',function()b.Enabled=i:
Get()b.ShowClosestLevel=m:Get()b.ShowDistance=k:Get()local n,o=j:Get(),l:Get()b.
NameColour=f(n)b.NameAlpha=n.A b.DistanceColour=f(o)b.DistanceAlpha=o.A k:
Visible(b.Enabled)m:Visible(b.Enabled)end)cheat.Register('onPaint',function()if
not b.Enabled then return end b.Runtime()end)end return b end function a.i()
return{Common=Color3.fromRGB(220,215,207),Uncommon=Color3.fromRGB(83,255,57),
Rare=Color3.fromRGB(70,200,255),Epic=Color3.fromRGB(117,54,243),Legendary=Color3
.fromRGB(255,208,38),Mythic=Color3.fromRGB(255,83,241),Secret=Color3.fromRGB(0,0
,0),Tool=Color3.fromRGB(114,255,232)}end function a.j()local b,c,d,e,f={Enabled=
false,ShowDistance=false,ShowValue=false,ShowRarity=false,NameColour=Color3.
fromRGB(255,255,255),NameAlpha=255,DistanceColour=Color3.fromRGB(255,255,255),
DistanceAlpha=255,ValueColour=Color3.fromRGB(255,255,255),ValueAlpha=255,
RarityColour=Color3.fromRGB(255,255,255),RarityAlpha=255},entity.GetLocalPlayer(
),a.load'a',a.load'i',function(b)if type(b)~='table'then return Color3.fromRGB(
255,255,255)end local c,d,e=b.R or b.r or 255,b.G or b.g or 255,b.B or b.b or
255 return Color3.fromRGB(c,d,e)end function b.RenderObject(g,h)local i=g.
RenderPart if not i then return end local j,k,l=utility.WorldToScreen(i.Position
)if not l then return end local m,n=d.Font,g.Name local o,p=draw.GetTextSize(n,m
)local q,r=0 if h.DistanceEnabled then local s=math.floor((c.Position-i.Position
).Magnitude)r='['..tostring(s)..'m]'q=draw.GetTextSize(r,m)end local s=o+q local
t,u=j-s/2,k-p/2 draw.TextOutlined(n,t,u,h.NameColour,m,h.NameAlpha)if r then
draw.TextOutlined(r,t+o,u,h.DistanceColour,m,h.DistanceAlpha)end local v,w,x,y=u
+p+2,j,0 if h.RarityEnabled and g.Rarity then y=tostring(g.Rarity)x=draw.
GetTextSize(y,m)end local z,A=0 if h.ValueEnabled and g.Value~=nil then A='[$'..
tostring(g.Value)..']'z=draw.GetTextSize(A,m)end local B=x+z local C=j-B/2 w=C
if y then draw.TextOutlined(y,w,v,e[y]or Color3.new(1,1,1),m,h.RarityAlpha)w=w+x
end if A then draw.TextOutlined(A,w,v,h.ValueColour,m,h.ValueAlpha)end end
function b.Runtime()local g,h,i,j,k,l,m,n,o,p=b.NameColour,b.NameAlpha,b.
DistanceColour,b.DistanceAlpha,b.ShowDistance,b.ValueColour,b.ValueAlpha,b.
ShowValue,b.RarityAlpha,b.ShowRarity for q,r in pairs(d.Structures.
InternalStructures)do local s=r.Objects for t,u in pairs(s)do b.RenderObject(u,{
NameColour=g,NameAlpha=h,DistanceEnabled=k,DistanceColour=i,DistanceAlpha=j,
ValueEnabled=n,ValueColour=l,ValueAlpha=m,RarityEnabled=p,RarityAlpha=o})end end
end function b.Initialise(g)local h,i,j,k,l,m,n,o=g:Checkbox
'Internal Structures',g:Colorpicker('Name Color',{r=255,g=255,b=255,a=255},true)
,g:Checkbox'Object Distance',g:Colorpicker('Distance Color',{r=255,g=255,b=255,a
=255},true),g:Checkbox'Object Value',g:Colorpicker('Value Color',{r=0,g=255,b=0,
a=255},true),g:Checkbox'Object Rarity',g:Colorpicker('Rarity Color',{r=255,g=255
,b=255,a=255},true)cheat.Register('onUpdate',function()b.Enabled=h:Get()b.
ShowDistance=j:Get()b.ShowValue=l:Get()b.ShowRarity=n:Get()local p,q,r,s=i:Get()
,k:Get(),m:Get(),o:Get()b.NameColour=f(p)b.NameAlpha=p.A b.ValueColour=f(r)b.
ValueAlpha=r.A b.DistanceColour=f(q)b.DistanceAlpha=q.A b.RarityAlpha=s.A j:
Visible(b.Enabled)l:Visible(b.Enabled)n:Visible(b.Enabled)end)cheat.Register(
'onPaint',function()if not b.Enabled then return end b.Runtime()end)end return b
end function a.k()local b,c={},a.load'a'function b.Initialise(d)local e=d:
Dropdown('Font Selection',{'ConsolasBold','SmallestPixel','Verdana','Tahoma'},1)
cheat.Register('onUpdate',function()c.Font=e:Get()end)end return b end function
a.l()local b,c,d={TempObjectStorage={ExternalStructures={},InternalStructures={}
},IsScanning=false,CurrentContainers=nil,CurrentContainer=1,LastRescanFinished=0
,RescanInterval=1},game.GetService'Workspace',game.LocalPlayer local e,f,g,h,i=c
.EnterableStructure,c.PlotSpawn,a.load'a',a.load'g',function(e,f,g)local h=e:
GetAttribute(f)return h and h.Value or g end local j=function()g.LocalInfo.
CurrentLevel=d.leaderstats.Level.Value end function b.CacheObject(k,l,m)if not k
or not l or not m then return end if m=='External Structure'then local n=l:
FindFirstChild'Door'local o=n and n:FindFirstChild'Main'if not o then return end
local p=i(l,'Difficulty',0)local q=h[p]or 1 local r={Name=l.Name,RenderPart=o,
RequiredLevel=q}k.ExternalStructures[l.Address]=r elseif m=='Internal Structure'
then local n={Objects={},Prompts={}}for o,p in pairs(l:GetDescendants())do if p:
IsA'ProximityPrompt'then table.insert(n.Prompts,p)end local q=p:GetAttribute
'Value'if q then local r=p:FindFirstChildOfClass'Part'or p:FindFirstChildOfClass
'UnionOperation'or p:FindFirstChildOfClass'MeshPart'if r then local s,t=i(p,
'Value',0),i(p,'Rarity','Common')n.Objects[p.Address]={Name=p.Name,RenderPart=r,
Value=math.floor(s),Rarity=t}end end end k.InternalStructures[l.Address]=n end
end function b.ProcessScan()local k,l=b.CurrentContainers,b.CurrentContainer if
not k or l>#k then g.Structures=b.TempObjectStorage b.TempObjectStorage={
ExternalStructures={},InternalStructures={}}b.IsScanning=false b.
CurrentContainers=nil b.CurrentContainer=1 b.LastRescanFinished=utility.
GetTickCount()return end local m=k[l]local n=m.Container:GetChildren()for o=1,#n
do b.CacheObject(b.TempObjectStorage,n[o],m.Type)end b.CurrentContainer=b.
CurrentContainer+1 end function b.StartScan()b.IsScanning=true b.
CurrentContainer=1 local k={}for l,m in pairs(e:GetChildren())do table.insert(k,
{Container=m,Type='External Structure'})end for l,m in pairs(f:GetChildren())do
table.insert(k,{Container=m,Type='Internal Structure'})end b.CurrentContainers=k
b.TempObjectStorage={ExternalStructures={},InternalStructures={}}end function b.
OnUpdateCache()local k=utility.GetTickCount()if not b.IsScanning then if k-b.
LastRescanFinished>=(b.RescanInterval*1000)then b.StartScan()end return end b.
ProcessScan()end function b.Initialise(k)local l=k:SliderInt(
'Rescan Interval (s)',1,10,2)g.LocalInfo.Player=d g.LocalInfo.PlayerGui=g.
LocalInfo.Player and g.LocalInfo.Player:FindFirstChild'PlayerGui'cheat.Register(
'onUpdate',function()b.OnUpdateCache()j()b.RescanInterval=l:Get()end)end return
b end function a.m()return function()function math.floor(b)return b-(b%1)end
function math.clamp(b,c,d)return math.max(c,math.min(d,b))end end end end local
b,c,d,e,f,g,h,i=a.load'e',a.load'f',a.load'h',a.load'j',a.load'k',a.load'l',a.
load'd',a.load'm'local j=function()local j=h.NewTab('DiddyWare_Feef','DiddyWare'
)local k,l,m=j:Container('DiddyWare_FeefC1','Main',{autosize=true,next=true}),j:
Container('DiddyWare_FeefC2','Visuals',{autosize=true}),j:Container(
'DiddyWare_FeefC3','Settings',{autosize=true,next=true})i()g.Initialise(m)f.
Initialise(m)b.Initialise(k)c.Initialise(k)d.Initialise(l)e.Initialise(l)end j()
