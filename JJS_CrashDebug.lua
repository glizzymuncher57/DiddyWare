--!nocheck
--!nolint

_P = {
	genDate = "2026-03-22T00:11:07.567520800+00:00",
	cfg = "Release",
	vers = "",
}

local a a={cache={},load=function(b)if not a.cache[b]then a.cache[b]={c=a[b]()}
end return a.cache[b].c end}do function a.a()local b={}b.__index=b local c={}
function b:Register(d,e)e=e or{}if type(d)~='string'or type(e)~='table'then
return end c[d]=e return e end function b:Get(d)return c[d]end function b:Clear(
d)local e=c[d]if not e then return end for f in next,e do e[f]=nil end end
function b:Unload(d)local e=c[d]if not e then return end for f in next,e do e[f]
=nil end c[d]=nil end function b:UnloadAll()for d,e in next,c do for f in next,e
do e[f]=nil end c[d]=nil end end return b end function a.b()local b,c=a.load'a',
{}local d,e=b:Register('Configuration.Elements',{}),b:Register(
'Configuration.Values',{})function c.Register(f,g)d[f]=g end function c.GetValue
(f)return e[f]end function c.SetValue(f,g)e[f]=g end return c end function a.c()
local b,c,d={},{},{'onPaint','onUpdate','onSlowUpdate','shutdown'}for e,f in
ipairs(d)do c[f]={}end function b.Add(e,f)if type(e)~='string'or type(f)~=
'function'then return nil end if not c[e]then return nil end local g=#c[e]+1 c[e
][g]=f return g end function b.Remove(e,f)if c[e]then c[e][f]=nil end end
function b.ClearAll()for e,f in pairs(c)do c[e]={}end end local e=function(e,...
)for f,g in pairs(c[e])do g(...)end end function b:Initialise()for f,g in
ipairs(d)do cheat.Register(g,function(...)e(g,...)end)end end return b end
function a.d()local b,c={},memory.Read function b.Read(d,e)return c(e.Type,d+e.
Offset)end function b.ReadVector2(d,e)local f,g=c(e.Type,d+e.X),c(e.Type,d+e.Y)
return Vector3.new(f,g,0)end return b end function a.e()return{version=
'version-ae421f0582e54718',Animation={AnimationId={Type='string',Offset=0xd0}},
ScreenGui={Enabled={Type='bool',Offset=0x4cc}},DoubleConstrainedValue={Value={
Type='double',Offset=0xe0}},Animator={AnimationTrackList={Type='pointer',Offset=
0x868}},GuiObject={Position={Type='float',X=0x518,Y=0x520},Rotation={Type=
'float',Offset=0x188},Size={Type='float',X=0x538,Y=0x540},AbsoluteSize={Type=
'float',X=0x118,Y=0x11c},AbsolutePosition={Type='float',X=0x110,Y=0x114},Visible
={Type='bool',Offset=0x5b5}},AnimationTrack={Looped={Type='bool',Offset=0xf5},
Animation={Type='pointer',Offset=0xd0},Speed={Type='float',Offset=0xe4},
TimePosition={Type='float',Offset=0xe8}}}end function a.f()local b,c,d,e,f=a.
load'a',a.load'c',a.load'b',utility.getTickCount,utility.getMousePos local g,h,i
,j,k,l,m,n,o,p,q,r,s,t,u,v,w={Messages=b:Register('DM.Messages',{})},20,{Active=
false,OffsetX=0,OffsetY=0},{info={label='INFO',color=Color3.new(0.4,0.8,1)},warn
={label='WARN',color=Color3.new(1,0.85,0.2)},error={label='ERROR',color=Color3.
new(1,0.3,0.3)},ok={label='OK',color=Color3.new(0.3,1,0.5)}},Color3.new(1,1,1),
Color3.new(0.5,0.5,0.5),Color3.new(0.12,0.12,0.14),Color3.new(0.08,0.08,0.1),
Color3.new(0.25,0.25,0.3),Color3.new(0.15,0.15,0.18),10,10,600,16,8,50,b:
Register('DM.TextSizeCache',{})local x,y,z,A=function(x,y)local z=x..tostring(y)
local A=w[z]if A then return A[1],A[2]end local B,C=draw.GetTextSize(x,y)w[z]={B
,C}return B,C end,function(x,y)if type(y)~='table'then return true end return y[
x]==true end,function()local x,y=e(),g.Messages for z=#y,1,-1 do if x>=y[z].
Expiry then table.remove(y,z)end end table.sort(y,function(z,A)return z.Expiry>A
.Expiry end)end,function()local x=f()return x[1]>=q and x[1]<=q+s and x[2]>=r
and x[2]<=r+(t+u*2)end local B=function(B)if not i.Active then if not(A()and B)
then return end i.Active=true local C=f()i.OffsetX=C[1]-q i.OffsetY=C[2]-r else
if B then local C=f()q=C[1]-i.OffsetX r=C[2]-i.OffsetY else i.Active=false end
end end local C=function()if not d.GetValue'Debug Mode'then return end local C,D
,E=d.GetValue'Show Debug Info',d.GetValue'Font Selection',g.Messages if#E==0
then return end local F=0 for G,H in ipairs(E)do if y(H.Level,C)then F=F+1 end
end if F==0 then return end B(keyboard.IsPressed'leftmouse')local G,H,I=e(),t+u*
2,u+t+u+(F*t)+u draw.RectFilled(q,r,s,I,n,4,200)draw.RectFilled(q,r,s,H,m,4,230)
draw.Rect(q,r,s,I,o,1,4,180)local J='[ DEBUG ]'local K=select(2,x(J,D))draw.
TextOutlined('[ DEBUG ]',q+u,r+(H/2)-(K/2),k,D)local L=r+H for M,N in ipairs(E)
do if y(N.Level,C)then local O=j[N.Level]local P='['..O.label..']'local Q,R=x(P,
D)local S,T=L+(t/2)-(R/2),N.Expiry-G local U=T<v and math.max(0,T/v)or 1 local V
=math.floor(U*U*255)draw.RectFilled(q+1,L,s-2,t,p,0,math.floor(V*0.35))draw.
TextOutlined(P,q+u,S,O.color,D,V)draw.TextOutlined(N.Text,q+u+Q+6,S,k,D,V)if N.
Count>1 then local W='x'..N.Count local X,Y=x(W,D)draw.TextOutlined(W,q+s-X-u,L+
(t/2)-(Y/2),l,D,V)end L=L+t end end end function g.AddDebugMessage(D,E,F)E=(E
and j[E])and E or'info'F=F or 3000 D=tostring(D)local G,H=e(),g.Messages for I=1
,#H do local J=H[I]if J.Text==D and J.Level==E then J.Count=J.Count+1 J.Expiry=G
+F return end end if#H>=h then table.remove(H,1)end H[#H+1]={Text=D,Level=E,
Count=1,Expiry=G+F}end function g.Clear()local D=g.Messages for E in next,D do D
[E]=nil end end function g:Initialise()c.Add('onSlowUpdate',z)c.Add('onPaint',C)
end return g end function a.g()local b,c,d,e,f,g,h,i=a.load'b',a.load'a',a.load
'c',a.load'd',a.load'e',a.load'f',memory.read,math.floor local j,k,l={Animators=
c:Register('AMAnimators',{}),Animations=c:Register('AMAnimations',{}),Tracks=c:
Register('AMTracks',{}),_ScanState={Queue={},Index=1,Done=false,StoredCallback=
nil}},{__index=function(j,k)local l=j.Track if k=='TimePosition'then return i(e.
Read(l,f.AnimationTrack.TimePosition)*100)/100 elseif k=='Speed'then return i(e.
Read(l+f.AnimationTrack.Speed)*100)/100 elseif k=='Looped'then return e.Read(l,f
.AnimationTrack.Looped)else return nil end end},function(j,k,l)if b.GetValue
'Debug Mode'then if not j then return end j=tostring(j)g.AddDebugMessage('[AM]:'
..j,k,l)end end local m,n,o=function()if j._ScanState.Done then return end j.
_ScanState.Queue={game.DataModel}j._ScanState.Index=1 end,function()local m,n,o=
j._ScanState.Queue,j._ScanState.Index,j.Animations for p=1,250 do local q=m[n]if
not q then d.Remove('onUpdate',j._ScanState.StoredCallback)l(
'Finished Caching Animations.','info',3000)return end if q:IsA'Animation'then
local r=e.Read(q.Address,f.Animation.AnimationId)if r~=''then o[r]=q.Name l(
'Cached Animation '..tostring(r),'info',3000)end end local r=q:GetChildren()for
s=1,#r do m[#m+1]=r[s]end n=n+1 end j._ScanState.Index=n end,function(m)local n=
j.Animators[m]if n then return n end local o=m:FindFirstChildOfClass'Animator'if
not o then return 0 end n=o.Address j.Animators[m]=n return n end function j:
GetPlayingAnimationTracks(p)local q,r={},o(p)if r==0 then l(
"Animator doesn't exist for "..p,'warning',1000)return q end local s=e.Read(r,f.
Animator.AnimationTrackList)if s==0 then l(
'Potentially Wrong Animation Track List Offset.','warning',1000)return q end
local t=h('pointer',s)while t~=0 and t~=s do local u=h('pointer',t+0x10)if u~=0
then local v=j.Tracks[u]if not v then local w=e.Read(u,f.AnimationTrack.
Animation)if w~=0 then local x=e.Read(w,f.Animation.AnimationId)if x~=''then v={
Track=u,Animation={AnimationId=x,Name=j.Animations[x]or'Unknown'}}setmetatable(v
,k)j.Tracks[u]=v end end end if v then q[#q+1]=v end end t=h('pointer',t)end
return q end function j:Initialise()m()j._ScanState.StoredCallback=d.Add(
'onUpdate',n)end return j end function a.h()local b=a.load'a'return{LocalPlayer=
b:Register('EnviromentLocalPlayer',{Player=game.LocalPlayer,Entity=entity.
GetLocalPlayer(),PlayerGui=game.LocalPlayer.PlayerGui,Data={Character=nil,Ping=0
}}),Players=b:Register('EnvironmentPlayerData',{}),Objects=b:Register(
'EnvironmentObjects',{Items={},Domains={}}),ClosestDomain=b:Register(
'EnvironmentClosestDomain',{Instance=nil,Distance=math.huge})}end function a.i()
local b,c,d,e,f,g,h,i=a.load'g',a.load'a',a.load'h',a.load'c',a.load'b',a.load
'f',game.GetService'Players',game.GetService'Stats'local j=i:FindFirstChild
'Network'local k=j.ServerStatsItem local l,m,n,o,p=k['Data Ping'],c:Register(
'LastUse_PlayerScanner',{}),c:Register('CooldownStarts_PlayerScanner',{}),{
LastCooldownUpdate=0,LastAnimationUpdate=0,LastLocalUpdate=0,LastRebuild=0},
function(l,m,n)local o=l:GetAttribute(m)return o and o.Value or n end local q,r,
s,t=function(q,r)if not q or not q.Name or q.Name==''then g.AddDebugMessage(
'[PlayerScanner]: Invalid Player','warning',1000)return end local s,t=q:
GetBoneInstance'Head',q:GetBoneInstance'HumanoidRootPart'if not s or not t then
g.AddDebugMessage('[PlayerScanner]: Aborted '..q.Name..', Missing Bodyparts',
'warning',1000)return end local u=t.Parent if not u then g.AddDebugMessage(
'[PlayerScanner]: Aborted '..q.Name..', Character is nil','warning',1000)return
end local v,w=u:FindFirstChild'Humanoid',u:FindFirstChild'Moveset'if not v or
not w then g.AddDebugMessage('[PlayerScanner]: Aborted '..q.Name..
', Missing Humanoid or Moveset','warning',1000)return end local x=q.Name local y
=d.Players[x]local z,A,B,C=y and y.Moves or nil,{},{},w:GetChildren()for D=1,#C
do local E=C[D]local F=E.Name local G=z and z[F]local H={Name=F,Key=p(E,'Key',D)
,Cooldown=E.Value or 0,Instance=E,MoveKey=x..F,IsOnCooldown=G and G.IsOnCooldown
or false,Remaining=G and G.Remaining or 0}A[D]=H B[F]=H end table.sort(A,
function(D,E)return D.Key<E.Key end)local D,E=(t.Position-s.Position).Magnitude>
20,h:FindFirstChild(x)r[x]={Player=q,Character=u,Humanoid=v,RootPart=t,Head=s,
Exploiting=D,SelectedMoveset=p(u,'Moveset','[???]'),Evade=p(u,'Evade',50),
Ultimate=E and p(E,'Ultimate',0)or 0,Ragdolled=p(u,'Ragdoll',0),Moves=B,
OrderedMoves=A,Animations=b:GetPlayingAnimationTracks(v)}end,function()local q,r
=d.LocalPlayer,game.LocalPlayer q.Entity=entity.GetLocalPlayer()q.Player=r q.
PlayerGui=r and q.PlayerGui or nil q.MinigameInterface=q.PlayerGui and q.
PlayerGui:FindFirstChild'DeviceUI'or nil q.Data.Character=p(r,'Moveset','[???]')
q.Data.Ping=l.Value end,function()for q,r in pairs(d.Players)do r.Animations=b:
GetPlayingAnimationTracks(r.Humanoid)end end,function(q,r)local s=q.Instance if
not s then q.IsOnCooldown=false q.Remaining=0 return end local t,u=q.MoveKey,p(s
,'LastUse',0)if u~=m[t]then m[t]=u n[t]=r end local v=n[t]if v then local w=r-v
if w<q.Cooldown then q.IsOnCooldown=true q.Remaining=q.Cooldown-w else q.
IsOnCooldown=false q.Remaining=0 end else q.IsOnCooldown=false q.Remaining=0 end
end local u,v=function()local u=utility.GetTickCount()/1000 for v,w in pairs(d.
Players)do for x,y in pairs(w.Moves)do t(y,u)end end end,function()local u,v={},
entity.GetLocalPlayer()if v then q(v,u)end for w,x in pairs(entity.GetPlayers(
false))do q(x,u)end d.Players=u end local w=function()local w,x,y,z,A=(f.
GetValue'Rebuild Player Cache Interval (s)'or 1)*1000,f.GetValue
'Update Player Cooldowns Interval (ms)'or 50,f.GetValue
'Update Player Animations Interval (ms)'or 10,(f.GetValue
'Update Local Info Interval (s)'or 1)*1000,utility.GetTickCount()if(A-o.
LastCooldownUpdate)>=x then u()o.LastCooldownUpdate=A end if(A-o.LastRebuild)>=w
then v()o.LastRebuild=A end if(A-o.LastAnimationUpdate)>=y then s()o.
LastAnimationUpdate=A end if(A-o.LastLocalUpdate)>=z then r()o.LastLocalUpdate=A
end end function o:DoesPlayerHaveMove(x,y)if not x or not y then return false
end local z=d.Players[x.Name]if not z or not z.Moves then return false end local
A=z.Moves[y]if not A then return false end return true end function o:
GetLocalPlayer()return d.Players[d.LocalPlayer.Entity.Name]end function o:
GetPlayers()return d.Players end function o:Initialise()e.Add('onUpdate',
function()w()end)end return o end function a.j()local b={}b.__index=b function b
.New()local c=setmetatable({},b)c.Queues={}c.Indexes={}c.Caches={}c.Callbacks={}
c.Rates={}c.LastUpdate={}return c end function b:AddCategory(c,d,e,f)self.Queues
[c]=d or{}self.Indexes[c]=1 self.Caches[c]={}self.Rates[c]=e or 50 self.
LastUpdate[c]=0 self.Selectors=self.Selectors or{}self.Selectors[c]=f end
function b:SetCallback(c,d)self.Callbacks[c]=d end function b:Update()local c=
utility.GetTickCount()for d,e in pairs(self.Queues)do local f,g=self.Rates[d]or
50,self.LastUpdate[d]or 0 if c-g>=f then local h=self.Indexes[d]local i=e[h]if i
then local j,k,l=i:GetChildren(),self.Selectors and self.Selectors[d],{}for m=1,
#j do local n=j[m]if k then n=k(n)end if n then l[n.Name]=n end end self.Caches[
d]=l local m=self.Callbacks[d]if m then m(d,i,j)end end h=h+1 if h>#e then h=1
end self.Indexes[d]=h self.LastUpdate[d]=c end end end function b:GetCached(c)
local d=self.Caches[c]if not d then return{}end local e={}for f,g in pairs(d)do
e[#e+1]=g end return e end function b:ClearCache(c)self.Caches[c]={}end function
b:SetInterval(c,d)self.Rates[c]=d end return b end function a.k()local b,c,d,e,f
={},a.load'h',a.load'c',a.load'j'.New(),game.GetService'Workspace'local g,h=f.
Items,f.Domains function b:Initialise()e:AddCategory('Domains',{h},2000)e:
AddCategory('Items',{g},2000)e:SetCallback('Domains',function(i,j,k)local l,m,n,
o=c.LocalPlayer.Entity.Position,(math.huge)for p,q in pairs(k)do local r=q:
FindFirstChildOfClass'MeshPart'local s=r.Position local t=(s-l).Magnitude if t<m
then o=s n=q m=t end end c.ClosestDomain.Instance=n c.ClosestDomain.Distance=m c
.ClosestDomain.Position=o end)d.Add('onUpdate',function()e:Update()c.Objects.
Items=e:GetCached'Items'c.Objects.Domains=e:GetCached'Domains'end)end return b
end function a.l()local b,c,d,e,f,g=a.load'f',a.load'a',a.load'c',a.load'b',a.
load'h',a.load'i'local h,i,j,k,l,m=f.LocalPlayer.Entity,utility.GetTickCount,
keyboard.IsPressed,keyboard.Click,{Delay=0.285,CombatState=c:Register(
'AutoBlackFlashState',{Waiting=false,WasDown=false,NextPressTime=0})},function(h
)if not e.GetValue'Debug Mode'then return end b.AddDebugMessage(h,'info',1000)
end local n=function()local n,o,p=i(),j(0x33),l.CombatState if o and not p.
WasDown and not p.Waiting then local q=e.GetValue'Auto Blackflash Timing'local r
=q*1000 p.NextPressTime=n+r p.Waiting=true end if p.Waiting and n>=p.
NextPressTime then k(0x33)p.Waiting=false m'Completed Yuji/Mahito Blackflash.'
end l.WasDown=o end function l:Initialise()d.Add('onUpdate',function(...)if not
e.GetValue'Auto Blackflash'then return end if e.GetValue'Auto Blackflash Hotkey'
~=true then return end if not g:DoesPlayerHaveMove(h,'Focus Strike')and not g:
DoesPlayerHaveMove(h,'Divergent Fist')then return end n()end)end return l end
function a.m()local b,c,d,e,f,g={LastClick=0},a.load'h',a.load'b',a.load'c',
utility.GetTickCount,keyboard.Click local h,i,j,k,l=c.LocalPlayer.PlayerGui,
'Auto Lawyer QTE','Auto Lawyer QTE Delay (ms)','QTE','QTE_PC'local m=function()
if not d.GetValue(i)then return end local m=f()if(m-b.LastClick)<d.GetValue(j)
then return end if not h then h=c.LocalPlayer.Player.PlayerGui return end local
n=h:FindFirstChild(k)local o=n and n:FindFirstChild(l)if not o then return end
local p=o.Value if not p or p==''then return end g(tostring(p):lower())b.
LastClick=m end function b:Initialise()e.Add('onUpdate',m)end return b end
function a.n()local b,c,d,e,f,g,h={},a.load'c',a.load'a',a.load'b',a.load'i',a.
load'f',entity.GetLocalPlayer()local i,j,k,l=d:Register('MahoragaTimingTable',{
AnimationId='rbxassetid://85024950165903'}),d:Register('MahoragaState',{
WasEarthquaking=false,Waiting=false}),function(i)if not e.GetValue'Debug Mode'
then return end g.AddDebugMessage(i,'info',1000)end,function(i)local j=f:
GetLocalPlayer()local k=j.Animations if not k then return nil end for l=1,#k do
if k[l].Animation.AnimationId==i then return k[l]end end return nil end local m=
function()if not e.GetValue'Auto Mahoraga Earthquake'then return end if not f:
DoesPlayerHaveMove(h,'Earthquake')then return end local m=l(i.AnimationId)if m
and not j.WasEarthquaking and not j.Waiting then j.Waiting=true end if j.Waiting
then if not m then j.Waiting=false return end local n=m.TimePosition k(
'Current Mahoraga Earthquake Time:'..n)if n>=e.GetValue
'Auto Mahoraga Earthquake Time Position'then keyboard.Release(0x33)j.Waiting=
false k'Completed Mahoraga Earthquake'end end j.WasEarthquaking=m~=nil end
function b:Initialise()c.Add('onUpdate',m)end return b end function a.o()local b
,c,d,e,f,g,h,i,j,k={CurrentRatio=nil,PressedR=false},a.load'h',a.load'c',a.load
'b',a.load'e',a.load'f',entity.GetPlayers,memory.Read,math.abs,keyboard.Click
local l,m,n=f.ScreenGui.Enabled,f.GuiObject.Position,function(l)if not e.
GetValue'Debug Mode'then return end g.AddDebugMessage(l,'info',1000)end local o=
function(o)local p=o:GetBoneInstance'HumanoidRootPart'if not p then return end
local q=p:FindFirstChild'Ratio'if not q then return end local r=q.Address if not
i(l.Type,r+l.Offset)then return end local s=b.CurrentRatio if not s or s~=r then
b.CurrentRatio=r b.PressedR=false end local t=q.Bar.Cursor local u,v=i(m.Type,t.
Address+m.Y),e.GetValue'Auto Nanami Ratio GUI Scale'local w=j(u-v)n(
'Nanami Ratio Current Distance: '..tostring(w))if w<=0.03 and not b.PressedR
then b.PressedR=true k'r'n'Completed Nanami Ratio'end end local p=function()if
not e.GetValue'Auto Nanami Ratio'then return end if c.LocalPlayer.Data.Character
~='Nanami'then return end local p=h(false)for q=1,#p do local r=p[q]o(r)end end
function b:Initialise()d.Add('onUpdate',p)end return b end function a.p()local b
,c,d,e,f,g,h={},a.load'c',a.load'a',a.load'b',a.load'i',a.load'f',entity.
GetLocalPlayer()local i,j,k,l,m=d:Register('TodoBlackflashState',{WasSliding=
false,Waiting=false,BruteForceStarted=false}),d:Register(
'TodoBlackflashAnimationsTable',{Slide='rbxassetid://100081544058065',[
'Brute Force']='rbxassetid://123167492985370'}),keyboard.Click,function(i)if not
e.GetValue'Debug Mode'then return end g.AddDebugMessage(i,'info',1000)end,
function(i)if not i then return end local j=f:GetLocalPlayer()local k=j.
Animations if not k then return nil end for l=1,#k do if k[l].Animation.
AnimationId==i then return k[l]end end return nil end local n=function()if not e
.GetValue'Auto Blackflash'then return end if e.GetValue'Auto Blackflash Hotkey'
~=true then return end if not f:DoesPlayerHaveMove(h,'Brute Force')then return
end local n=m(j.Slide)if n and not i.WasSliding and not i.Waiting then l
'Queued Todo Blackflash - Waiting for brute force'i.Waiting=true end if i.
Waiting then local o=m(j['Brute Force'])if not n and not o then l
'Cancelled Blackflash, Animation Ended.'i.Waiting=false i.BruteForceStarted=
false elseif o then i.BruteForceStarted=true local p=o.TimePosition local q=
tostring(p)l('Brute Force Time Position: '..q)if p>=e.GetValue
'Auto Todo Blackflash Time Position'then l('Triggered Todo Blackflash at: '..q)
k(0x32)i.Waiting=false i.BruteForceStarted=false end end end i.WasSliding=n end
function b:Initialise()c.Add('onUpdate',n)end return b end function a.q()local b
,c,d,e,f,g,h={},a.load'c',a.load'a',a.load'b',a.load'i',a.load'h',a.load'f'local
i,j,k,l=d:Register('TodoSwapState',{Waiting=false,WasClapping=false}),d:
Register('TodoSwapWhitelistedAnimations',{Clap1=true,Clap2=true,Clap3=true}),
mouse.Click,function(i)if not e.GetValue'Debug Mode'then return end h.
AddDebugMessage(i,'info',1000)end local m=function()local m=f:GetLocalPlayer()
local n=m.Animations if not n then return nil end for o=1,#n do local p=n[o]if j
[p.Animation.Name]then return p end end return nil end local n=function()if not
e.GetValue'Auto Todo Perfect Swap'then return end if e.GetValue
'Auto Todo Perfect Swap Hotkey'~=true then return end if g.LocalPlayer.Data.
Character~='Todo'then return end local n=m()if f:GetLocalPlayer().Ultimate<4 and
not n and not i.Waiting then return end if n and not i.WasClapping and not i.
Waiting then l'Detected Clap, Waiting.'i.Waiting=true end if i.Waiting then if
not n then i.Waiting=false l'Cancelled Perfect Swap, Animation Stopped.'elseif n
.TimePosition>=e.GetValue'Auto Todo Perfect Swap Time Position'then l
'Completed Todo Perfect Swap'k'leftmouse'i.Waiting=false end end i.WasClapping=n
~=nil end function b:Initialise()c.Add('onUpdate',n)end return b end function a.
r()local b,c,d,e,f,g={},a.load'c',a.load'a',a.load'b',a.load'i',a.load'f'local h
,i,j=d:Register('PunishM1Items',{}),function(h,i)if not e.GetValue'Debug Mode'
then return end g.AddDebugMessage(h,i,1000)end,function(h)local i,j=(math.huge)
for k,l in pairs(f:GetPlayers())do if l~=h then local m=(h.Player.Position-l.
Player.Position).Magnitude if m<i then j=l i=m end end end return j,i end local
k=function()if not e.GetValue'Auto Return M1'then return end local k=f:
GetLocalPlayer()local l=k and k.RootPart if not l then i(
'Aborted Auto Return M1, No HRP.','error')return end local m=l:FindFirstChild
'BlockHit'if not m or h[m.Address]then return end h[m.Address]=utility.
GetTickCount()local n,o=j(k)if not n or not o or o>8 then return end keyboard.
release'f'mouse.click'leftmouse'end function b:Initialise()c.Add('onUpdate',
function()k()local l=utility.GetTickCount()for m,n in pairs(h)do if(l-n)>1000
then h[m]=nil end end end)end return b end function a.s()local b,c,d,e,f={},a.
load'c',a.load'a',a.load'b',a.load'h'local g,h,i,j,k,l,m,n,o,p,q,r,s,t,u=d:
Register('PV_TextSizeCache',{}),d:Register('PV_NameCache',{}),d:Register(
'PV_ColorCache',{}),Color3.new(0,0,0),Color3.new(1,1,1),Color3.fromRGB,draw.Rect
,draw.RectFilled,draw.ComputeConvexHull,draw.Polyline,draw.ConvexPolyFilled,draw
.TextOutlined,draw.GetTextSize,draw.GetPartCorners,utility.WorldToScreen local v
,w,x,y,z=function(v)if type(v)~='table'then return l(255,255,255)end local w,x,y
=v.R or v.r or 255,v.G or v.g or 255,v.B or v.b or 255 local z=w..','..x..','..y
local A=i[z]if A then return A end local B=l(w,x,y)i[z]=B return B end,function(
v,w)local x=v..tostring(w)local y=g[x]if y then return y[1],y[2]end local z,A=s(
v,w)g[x]={z,A}return z,A end,function(v,w)local x=h[v]if not x then x={}h[v]=x
end local y=x[w]if y then return y end local z=string.sub(v,1,w)x[w]=z return z
end,function(v,w)local x=t(v)if not x then return end for y,z in ipairs(x)do
local A,B,C=u(z)if C then w[#w+1]={A,B}end end end,function(v)for w=#v,1,-1 do v
[w]=nil end end local aa=function(A,B,C,D)if not A or not B or not C then return
end if not A.IsAlive then return end local E,F=A.Position,C.EvasiveBarColor
local G,H=v(F),C.CooldownFillColor local I,J=v(H),C.CooldownBackgroundColor
local K,L=v(J),C.AnimationDesyncOutlineColor local M,N=v(L),C.
AnimationDesyncFillColor local O=v(N)if C.AnimationDesyncGuides and B.Exploiting
then local P=B.RootPart if not P then return end y(P,D)if#D>=3 then local Q=o(D)
if Q then p(Q,M,true,2,L.a)q(Q,O,N.a)end end z(D)end local P,Q,R=u(E)if not R
then return end local S=A.BoundingBox if not S then return end local T,U=C.Font,
B.Evade if C.DrawEvasiveBar and U then local V=math.clamp(U/50,0,1)local W,X,Y,Z
=S.h*V,S.x-8,S.y,S.h n(X-1,Y-1,7,Z+2,j,0,255)n(X,Y+Z-W,5,W,G,0,255)local _=
tostring(math.floor(V*100))..'%'local aa=w(_,T)r(_,X-aa-2,Y,k,C.Font)end local
aa=B.OrderedMoves if C.DrawCooldowns and aa then local V=#aa local W,X,Y=S.h/V,S
.x+S.w+2,S.y for Z=1,V do local _=aa[Z]local ab,ac=_.Remaining,Y+(Z-1)*W n(X,ac,
W,W,K,0,J.a)if ab>0 then local ad=ab/_.Cooldown local ae=W*ad n(X+W-ae,ac,ae,W,I
,0,H.a)end m(X,ac,W,W,k)local ad=_.Name local ae,af=ad,T if W<40 then af=
'SmallestPixel'end if W<25 then ae=x(ad,1)elseif W<40 then ae=x(ad,3)end if W>=
15 then local ag,ah=w(ae,af)local ai,aj=X+(W-ag)/2,ac+(W-ah)/2 r(ae,ai,aj,k,af)
end end end end local ab=function()if not e.GetValue'Visuals Enabled'then return
end local ab,ac,ad={DrawCooldowns=e.GetValue'Draw Cooldowns',CooldownFillColor=e
.GetValue'Cooldown Fill Color',CooldownBackgroundColor=e.GetValue
'Cooldown Background Color',DrawEvasiveBar=e.GetValue'Draw Evasive Bar',
EvasiveBarColor=e.GetValue'Evasive Fill Color',AnimationDesyncGuides=e.GetValue
'Draw Animation Desync Guides',AnimationDesyncOutlineColor=e.GetValue
'Animation Desync Flagged Outline',AnimationDesyncFillColor=e.GetValue
'Animation Desync Flagged Fill',Font=e.GetValue'Font Selection'},{},entity.
GetPlayers(false)for ae=1,#ad do local af=ad[ae]local ag=f.Players[af.Name]aa(af
,ag,ab,ac)end end function b:Initialise()c.Add('onPaint',function(...)ab()end)
end return b end function a.t()local aa,ab,ac,ad,ae={},a.load'c',a.load'b',a.
load'a',a.load'h'local af,ag,ah,ai,aj,b,c,d,e,f=ad:Register('WV_TextSizeCache',{
}),ad:Register('WV_ColorCache',{}),ad:Register('WV_FloorCache',{}),Color3.
fromRGB,draw.TextOutlined,draw.GetTextSize,utility.WorldToScreen,cheat.
GetWindowSize,math.floor,function(af,ag,ah)local ai=af:GetAttribute(ag)return ai
and ai.Value or ah end local g,h,i=function(g)if type(g)~='table'then return ai(
255,255,255)end local h,i,j=g.R or g.r or 255,g.G or g.g or 255,g.B or g.b or
255 local k=h..','..i..','..j local l=ag[k]if l then return l end local m=ai(h,i
,j)ag[k]=m return m end,function(g)local h=ah[g]if h then return h end h=e(g)ah[
g]=h return h end,function(g,h)local i=g..tostring(h)local j=af[i]if j then
return j[1],j[2]end local k,l=b(g,h)af[i]={k,l}return k,l end local j,k=function
(j)if not j.Enabled then return end local k,l=j.Font,j.Color local m,n,o,p=g(l),
d(),ae.ClosestDomain,ae.Objects.Domains for q=1,#p do local r=p[q]if r then
local s=f(r,'Health',0)local t='Domain Health: '..tostring(h(s))local u,v=i(t,k)
local w,x,y=false if o.Instance and r==o.Instance and o.Distance<=40 then x=(n/2
)-(u/2)y=50 w=true else local z,A,B=utility.WorldToScreen(r.Position)if B then x
=z-u/2 y=A-v/2 w=B end end if w and t~=''then aj(t,x,y,m,k,l.a)end end end end,
function(j)if not j.Enabled then return end local k,l=j.Font,j.Color local m,n=
g(l),ae.Objects.Items for o=1,#n do local p=n[o]if p then local q,r,s=c(p.
Position)if s then local t=p.Name local u,v=i(t,k)local w,x=q-(u/2),r-(v/2)if t
~=''then aj(t,w,x,m,k,l.a)end end end end end local l=function()if not ac.
GetValue'Visuals Enabled'then return end local l=ac.GetValue'Font Selection'j{
Enabled=ac.GetValue'Domain Health ESP',Color=ac.GetValue
'Domain Health ESP Color',Font=l}k{Enabled=ac.GetValue'Item ESP',Color=ac.
GetValue'Item ESP Color',Font=l}end function aa:Initialise()ab.Add('onPaint',l)
end return aa end function a.u()local aa,ab,ac=a.load'd',a.load'e',0 local ad,ae
=function(ad)local ae=ad.Address return aa.ReadVector2(ae,ab.GuiObject.
AbsoluteSize)end,function(ad)local ae=ad.Address return aa.ReadVector2(ae,ab.
GuiObject.AbsolutePosition)end local af=function(af)local ag,ah=ae(af),ad(af)
return ag+(ah/2)end local ag=function(ag,ah,ai)local aj,b,c=math.huge,(ai.X*0.05
)for d,e in pairs(ag:GetChildren())do local f,g=af(e),ad(e.Top)local h=f.X+(g.X/
2)local i=h+b>ah.X if i then local j=f.X-ah.X if j<aj then c=e aj=j end end end
return c end return function(ah)if not ah then return end local ai=ah.Screen.
Game local aj,b=ai.Guy,utility.GetTickCount()if aa.Read(aj.Explode.Address,ab.
GuiObject.Visible)then return end local c,d=ad(ai),af(aj)local e=ag(ai.Walls,d,c
)if not e then return end local f,g=e.Top,e.Bottom local h,i,j=ae(f),ad(f),ae(g)
local k,l=h.Y+i.Y,j.Y local m=l-k local n,o=k+m*0.5,m*0.1 local p=n+o if d.Y>p
and b-ac>25 then mouse.Click'leftmouse'ac=b end end end function a.v()local aa,
ab=a.load'd',a.load'e'local ac,ad=function(ac)local ad=ac.Address return aa.
ReadVector2(ad,ab.GuiObject.AbsoluteSize)end,function(ac)local ad=ac.Address
return aa.ReadVector2(ad,ab.GuiObject.AbsolutePosition)end local ae=function(ae)
local af,ag=ad(ae),ac(ae)return af+(ag/2)end local af=function(af,ag)local ah,ai
=af.BG1.Floor,af.Food if not ah or not ai then print
"Minigame Critical Error | Couldn't find floor or food!"return nil end local aj,
b=ad(ah),ac(ah)local c,d,e,f=b.X*0.15,(math.huge)for g,h in pairs(ai:
GetChildren())do local i=ae(h)local j,k=math.abs(i.X-ag.X),aj.Y-i.Y local l=h.
Name=='Speed'and j>c if not l then if k<d then e=h f=i d=k end end end return e,
f end return function(ag)if not ag then return end local ah=ag.Screen.Game local
ai=ah.Guy if aa.Read(ai.Explode.Address,ab.GuiObject.Visible)then return end
local aj=ae(ai)local b,c=af(ah,aj)if not b or not c then return end local d=c.X-
aj.X if math.abs(d)>=20 then if d<0 then keyboard.click'a'else keyboard.click'd'
end end end end function a.w()local aa,ab,ac,ad=a.load'c',a.load'b',a.load'a',{}
ad.DebugMode=false local ae,af,ag=ac:Register('UI.Elements',{}),ac:Register(
'UI.DebugElements',{}),{}ag.__index=ag function ag:Get()return ab.GetValue(self.
Name)end function ag:Set(ah)ui.setValue(self.TabRef,self.ContainerRef,self.Name,
ah)ab.SetValue(self.Name,ah)end function ag:Visible(ah)ui.setVisibility(self.
TabRef,self.ContainerRef,self.Name,ah)end function ag:OnChange(ah)self._onChange
=ah return self end function ag:_Read()return ui.getValue(self.TabRef,self.
ContainerRef,self.Name)end function ag:_Poll()local ah,ai=self:_Read(),ab.
GetValue(self.Name)if ah==ai then return end ab.SetValue(self.Name,ah)if self.
_onChange then self._onChange(ah,ai)end end local ah,ai=function(ah,ai,aj,b)
local c=setmetatable({TabRef=ah,ContainerRef=ai,Name=aj,Debug=b and b.Debug},ag)
ab.Register(aj,c)ae[aj]=c if c.Debug then c:Visible(false)af[#af+1]=c end return
c end,{}ai.__index=ai function ai:Checkbox(aj,b,c)ui.newCheckbox(self.TabRef,
self.Ref,aj,b)return ah(self.TabRef,self.Ref,aj,c)end function ai:SliderInt(aj,b
,c,d,e)ui.newSliderInt(self.TabRef,self.Ref,aj,b,c,d)return ah(self.TabRef,self.
Ref,aj,e)end function ai:SliderFloat(aj,b,c,d,e)ui.newSliderFloat(self.TabRef,
self.Ref,aj,b,c,d)return ah(self.TabRef,self.Ref,aj,e)end function ai:Dropdown(
aj,b,c,d)ui.newDropdown(self.TabRef,self.Ref,aj,b,c)local e=ah(self.TabRef,self.
Ref,aj,d)e._Read=function(f)local g=ui.getValue(f.TabRef,f.ContainerRef,aj)
return b[g+1]end return e end function ai:Multiselect(aj,b,c)ui.newMultiselect(
self.TabRef,self.Ref,aj,b)local d=ah(self.TabRef,self.Ref,aj,c)d._Read=function(
e)local f,g=ui.getValue(e.TabRef,e.ContainerRef,aj),{}for h,i in ipairs(f)do if
i then g[b[h] ]=true end end return g end d._Poll=function(e)local f,g=e:_Read()
,ab.GetValue(e.Name)local h=type(g)~='table'if not h then for i,j in ipairs(b)do
if f[j]~=g[j]then h=true break end end end if not h then return end ab.SetValue(
e.Name,f)if e._onChange then e._onChange(f,g)end end return d end function ai:
Colorpicker(aj,b,c,d)ui.newColorpicker(self.TabRef,self.Ref,aj,b,c)local e=ah(
self.TabRef,self.Ref,aj,d)e._Read=function(f)return ui.getValue(f.TabRef,f.
ContainerRef,aj)end e.Get=function(f,g)local h=ab.GetValue(f.Name)if not h then
return nil end g=(tostring(g)or'table'):lower()return g=='rgb'and Color3.
fromRGB(h.r,h.g,h.b)or h end e._Poll=function(f)local g,h=f:_Read(),ab.GetValue(
f.Name)if h and g.r==h.r and g.g==h.g and g.b==h.b and g.a==h.a then return end
ab.SetValue(f.Name,g)if f._onChange then f._onChange(g,h)end end return e end
function ai:InputText(aj,b,c)ui.newInputText(self.TabRef,self.Ref,aj,b)return
ah(self.TabRef,self.Ref,aj,c)end function ai:Button(aj,b,c)ui.newButton(self.
TabRef,self.Ref,aj,b)local d=ah(self.TabRef,self.Ref,aj,c)d.Get=nil d.Set=nil d.
_Poll=function()end return d end function ai:Listbox(aj,b,c,d)ui.newListbox(self
.TabRef,self.Ref,aj,b,function()local e=ui.getValue(self.TabRef,self.Ref,aj)
local f=b[e+1]ab.SetValue(aj,f)if c then c(f)end end)local e=ah(self.TabRef,self
.Ref,aj,d)e._Poll=function()end return e end function ai:KeyPicker(aj,b,c)ui.
newHotkey(self.TabRef,self.Ref,aj,b)local d=ah(self.TabRef,self.Ref,aj,c)d._Read
=function(e)return ui.getValue(e.TabRef,e.ContainerRef,aj)end d.Get=function(e,f
)if f=='Hotkey'then return ui.getHotkey(e.TabRef,e.ContainerRef,aj)end return ab
.GetValue(e.Name)end return d end function ai:Page(aj,b)local c,d=self:Dropdown(
aj,b,1),{}for e,f in ipairs(b)do d[f]={}end local e,f,g=b[1],self,function(e,f)
local g=d[e]if not g then return end for h=1,#g do g[h]:Visible(f)end end for h,
i in ipairs(b)do g(i,h==1)end c:OnChange(function(h)g(e,false)e=h g(e,true)end)
local h={}function h:For(i)assert(d[i],"[UI.Page]: Unknown page '"..tostring(i)
.."'")return setmetatable({},{__index=function(j,k)local l=ai[k]if type(l)~=
'function'or k=='Page'then return nil end return function(m,...)local n=l(f,...)
d[i][#d[i]+1]=n if i~=e then n:Visible(false)end return n end end})end return h
end local aj={}aj.__index=aj function aj:Container(b,c,d)ui.newContainer(self.
Ref,b,c,d or{})return setmetatable({TabRef=self.Ref,Ref=b},ai)end function ad.
NewTab(b,c)ui.newTab(b,c)return setmetatable({Ref=b},aj)end function ad:
SetDebugMode(b)self.DebugMode=b for c=1,#af do af[c]:Visible(b)end end function
ad:Initialise()aa.Add('onUpdate',function()for b,c in next,ae do c:_Poll()end
end)end return ad end function a.x()local aa,ab,ac,ad,ae,af={GameUI=nil,GameType
=nil},a.load'h',a.load'c',a.load'b',a.load'f',{['Flight Game']=a.load'u',[
'Catch Game']=a.load'v'}local ag=function(ag)if not ad.GetValue'Debug Mode'then
return end ae.AddDebugMessage(ag,'info',1200)end local ah=function(ah)local ai=
af[aa.GameType]if not ai then ag('No module found for game type: '..tostring(aa.
GameType))return nil end return ai(ah)end function aa.Initialise(ai)ac.Add(
'onUpdate',function()if utility.GetMenuState()then return end if not ad.GetValue
'Minigames Enabled'then return end if not aa.GameUI then return end if not aa.
GameType then return end if ad.GetValue(aa.GameType)~=true then return end ah(aa
.GameUI)end)ac.Add('onSlowUpdate',function()if not ad.GetValue
'Minigames Enabled'then return end local aj=ab.LocalPlayer.PlayerGui if not aj
then return end local b=aj:FindFirstChild'DeviceUI'aa.GameUI=b if b then local c
=b:FindFirstChild'DeviceSystem'if not c then aa.GameType=nil return end local d=
c:FindFirstChild'Wall'and'Flight Game'or c:FindFirstChild'Food'and'Catch Game'or
nil aa.GameType=d else aa.GameType=nil end end)end return aa end function a.y()
local aa,ab,ac,ad,ae,af,ag,ah,ai,aj,b={},a.load'l',a.load'm',a.load'n',a.load'o'
,a.load'p',a.load'q',a.load'r',a.load's',a.load't',a.load'x'function aa:
Initialise()ab:Initialise()ac:Initialise()ad:Initialise()ae:Initialise()af:
Initialise()ag:Initialise()ai:Initialise()aj:Initialise()b:Initialise()end
return aa end function a.z()local aa,ab,ac={},'Combat_DiddyWare','Combat'
function aa:Initialise(ad)local ae=ad:Container(ab,ac,{autosize=true,next=true})
ae:Checkbox'Auto Blackflash'ae:KeyPicker('Auto Blackflash Hotkey',true)ae:
SliderFloat('Auto Blackflash Timing',0,1,0.285,{Debug=true})ae:SliderFloat(
'Auto Todo Blackflash Time Position',0,5,2.9,{Debug=true})ae:Checkbox
'Auto Todo Perfect Swap'ae:KeyPicker('Auto Todo Perfect Swap Hotkey',true)ae:
SliderFloat('Auto Todo Perfect Swap Time Position',0,1,0.65,{Debug=true})ae:
Checkbox'Auto Mahoraga Earthquake'ae:SliderFloat(
'Auto Mahoraga Earthquake Time Position',0,1,0.8,{Debug=true})ae:Checkbox
'Auto Nanami Ratio'ae:SliderFloat('Auto Nanami Ratio GUI Scale',0,1,0.3,{Debug=
true})ae:Checkbox'Auto Lawyer QTE'ae:SliderInt('Auto Lawyer QTE Delay (ms)',1,
200,75)ae:Checkbox'Auto Return M1'end return aa end function a.A()local aa,ab,ac
={},'VisualsTab_DiddyWare','Visuals'function aa:Initialise(ad)local ae=ad:
Container(ab,ac,{autosize=true})ae:Checkbox'Visuals Enabled'local af=ae:Page(
'Visual Types',{'Player','World'})local ag,ah=af:For'Player',af:For'World'ag:
Checkbox'Draw Cooldowns'ag:Colorpicker('Cooldown Fill Color',{r=255,g=0,b=0,a=
180},true)ag:Colorpicker('Cooldown Background Color',{r=0,g=0,b=0,a=200},true)ag
:Checkbox'Draw Evasive Bar'ag:Colorpicker('Evasive Fill Color',{r=121,g=74,b=148
,a=255},true)ag:Checkbox('Draw Animation Desync Guides',false)ag:Colorpicker(
'Animation Desync Flagged Outline',{r=0,g=0,b=0,a=180},true)ag:Colorpicker(
'Animation Desync Flagged Fill',{r=255,g=0,b=0,a=100},true)ah:Checkbox(
'Item ESP',false)ah:Colorpicker('Item ESP Color',{r=255,g=255,b=255,a=255},true)
ah:Checkbox('Domain Health ESP',false)ah:Colorpicker('Domain Health ESP Color',{
r=255,g=255,b=255,a=255},true)end return aa end function a.B()local aa,ab,ac={},
'Minigame_DiddyWare','Minigames'function aa:Initialise(ad)local ae=ad:Container(
ab,ac,{autosize=true,next=true})ae:Checkbox'Minigames Enabled'ae:Checkbox
'Flight Game'ae:Checkbox'Catch Game'end return aa end function a.C()local aa,ab,
ac,ad={},a.load'w','Settings_DiddyWare','Settings'function aa:Initialise(ae)
local af=ae:Container(ac,ad,{autosize=true})local ag=af:Page('Settings Menu',{
'Debug','Performance','Customisation'})local ah,ai,aj=ag:For'Debug',ag:For
'Performance',ag:For'Customisation'local b=ah:Checkbox('Debug Mode',false)b:
OnChange(function(c)ab:SetDebugMode(c)end)ah:Multiselect('Show Debug Info',{'ok'
,'info','warning','error'})ai:SliderFloat('Update Local Info Interval (s)',1,3,1
)ai:SliderFloat('Rebuild Player Cache Interval (s)',0.05,1,0.15)ai:SliderInt(
'Update Player Cooldowns Interval (ms)',1,50,5)ai:SliderInt(
'Update Player Animations Interval (ms)',1,50,5)aj:Dropdown('Font Selection',{
'ConsolasBold','SmallestPixel','Verdana','Tahoma'},1)end return aa end function
a.D()local aa,ab,ac,ad,ae,af={},a.load'w',a.load'z',a.load'A',a.load'B',a.load
'C'function aa:Initialise()local ag=ab.NewTab('DiddyWare_JJS','DiddyWare')ac:
Initialise(ag)ad:Initialise(ag)ae:Initialise(ag)af:Initialise(ag)end return aa
end function a.E()return function()function math.floor(aa)return aa-(aa%1)end
function math.clamp(aa,ab,ac)return math.max(ab,math.min(ac,aa))end end end end
local aa,ab,ac,ad,ae,af,ag,ah,ai,aj=a.load'i',a.load'k',a.load'g',a.load'f',a.
load'y',a.load'D',a.load'c',a.load'a',a.load'E',a.load'w'local b=function()ai()
ag:Initialise()aj:Initialise()aa:Initialise()ab:Initialise()ac:Initialise()ad:
Initialise()af:Initialise()ae:Initialise()ag.Add('shutdown',function()ag.
ClearAll()ah:UnloadAll()end)end b()
