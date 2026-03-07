--!nocheck
--!nolint

_P = {
	genDate = "2026-03-07T22:48:23.698894300+00:00",
	cfg = "Release",
	vers = "",
}

local a a={cache={},load=function(b)if not a.cache[b]then a.cache[b]={c=a[b]()}
end return a.cache[b].c end}do function a.a()local b,c=game.GetService
'ReplicatedStorage',game.LocalPlayer.PlayerGui local d,e=c:FindFirstChild
'ScreenGui',b:FindFirstChild'DoubleConstrainedValue'local f,g,h,i=d:
FindFirstChild'Frame1',d:FindFirstChild'Frame2',d:FindFirstChild'Rotation',
function(f)return function(g)return{X=string.format('0x%X',g),Y=string.format(
'0x%X',g+f)}end end return{DoubleConstrainedValue={Value={e,'double',7812.938}},
GuiObject={Position={g,'float',4232,i(8)},Size={g,'float',5462,i(8)},
AbsoluteSize={f,'float',213,i(4)},AbsolutePosition={f,'float',232,i(4)},Rotation
={h,'float',43432.523}}}end function a.b()local b,c,d,e={Callbacks={}},a.load'a'
,10000,0.025 function b:GetOffsets()local f={}for g,h in pairs(c)do f[g]={}for i
,j in pairs(h)do local k,l,m,n=j[1],j[2],j[3],j[4]local o=type(k)=='number'and k
or k.Address for p=0,d do local q=memory.read(l,o+p)local r=q==m or(type(m)==
'number'and q>m-e and q<m+e)or(l~='string'and string.match(tostring(q),
'^(%d+%.%d%d)')==tostring(m))if r then if type(n)=='function'then local s=n(p)s.
Type=l f[g][i]=s else f[g][i]={Offset=string.format('0x%X',p),Type=l}end print(
string.format('[%s.%s] offset: 0x%X',g,i,p))break end end end end b:Finished(f)
end function b:Initialise()print'--- SCANNING PROPERTIES ---'b:GetOffsets()end
function b:Finished(f)for g,h in pairs(b.Callbacks)do h(f)end end function b:
OnFinished(f)table.insert(b.Callbacks,f)end return b end function a.c()local b=
game.LocalPlayer.PlayerGui local c=b:FindFirstChild'VisUI'local d=c:
FindFirstChild'VisFrame'return{ScreenGui={Enabled={c,'bool'}},GuiObject={Visible
={d,'bool'}}}end function a.d()local b,c,d={},{},{'onPaint','onUpdate',
'onSlowUpdate','shutdown'}for e,f in ipairs(d)do c[f]={}end function b.Add(e,f)
if type(e)~='string'or type(f)~='function'then return nil end if not c[e]then
return nil end local g=#c[e]+1 c[e][g]=f return g end function b.Remove(e,f)if c
[e]then c[e][f]=nil end end function b.ClearAll()for e,f in pairs(c)do c[e]={}
end end local e=function(e,...)for f,g in pairs(c[e])do g(...)end end function b
:Initialise()for f,g in ipairs(d)do cheat.Register(g,function(...)e(g,...)end)
end end return b end function a.e()local b,c,d,e,f={Callbacks={}},a.load'c',a.
load'd',10000,function(b)local c=0 for d in pairs(b)do c=c+1 end return c end
function b:GetOffsets()local g,h,i={},{},game.LocalPlayer.PlayerGui local j,k,l=
i:FindFirstChild'StateFrame',false for m,n in pairs(c)do for o,p in pairs(n)do
local q=p[1]local r,s=type(q)=='number'and q or q.Address,m..'.'..o h[s]={
address=r,class_name=m,prop_name=o,candidates=nil,found=false,rounds=0}end end
local m m=d.Add('onUpdate',function()if k then d.Remove('onUpdate',m)return end
local n=tonumber(j.Value)if n==nil or n==l then return end l=n local o=true for
p,q in pairs(h)do if not q.found then o=false if q.candidates==nil then q.
candidates={}for r=0,e do if memory.read('byte',q.address+r)==n then q.
candidates[r]=true end end q.rounds=1 else for r in pairs(q.candidates)do if
memory.read('byte',q.address+r)~=n then q.candidates[r]=nil end end q.rounds=q.
rounds+1 if f(q.candidates)==1 then for r in pairs(q.candidates)do g[q.
class_name]=g[q.class_name]or{}g[q.class_name][q.prop_name]={Offset=string.
format('0x%X',r),Type='bool'}q.found=true print(string.format(
'[%s.%s] offset: %s (found in %d rounds)',q.class_name,q.prop_name,string.
format('0x%X',r),q.rounds))end end end end end if o then k=true b:Finished(g)end
end)end function b:Initialise()print'--- SCANNING BOOLS ---'b:GetOffsets()end
function b:Finished(g)for h,i in pairs(b.Callbacks)do i(g)end end function b:
OnFinished(g)table.insert(b.Callbacks,g)end return b end function a.f()local b,c
=game.GetService'ReplicatedStorage',entity.GetLocalPlayer()local d=c and c:
GetBoneInstance'HumanoidRootPart'local e=d and d.Parent local f=e and e:
FindFirstChildOfClass'Humanoid'local g,h=f and f:FindFirstChildOfClass'Animator'
,b:FindFirstChild'AnimationData'local i,j,k,l,m=h and h:FindFirstChild'Speed',h
and h:FindFirstChild'TimePosition',h and h:FindFirstChild'Looped',h and h:
FindFirstChild'AnimationId'return{Animator={AnimationTrackList={g,'pointer'}},
AnimationTrack={Speed={m,'float',i},TimePosition={m,'float',j},Looped={m,'byte',
k},AnimationId={m,'string',l}}}end function a.g()local b,c,d,e,f,g,h,i,j,k,l,m={
Callbacks={}},a.load'f',a.load'd',10000,0.025,0x2000,0x500,0x2000,0x2000,3,
function(b,c)if b and b.Value then return c and tonumber(b.Value)or b.Value end
return nil end,function(b)local c=0 for d in pairs(b)do c=c+1 end return c end
local n=function(n)local o,p=l(c.AnimationTrack.Speed[3],true),l(c.
AnimationTrack.TimePosition[3],true)if not o or not p then return false,nil,nil
end local q,r for s=0,h,4 do local t=memory.Read('float',n+s)if t then if not q
and math.abs(t-o)<f then q=s end if not r and math.abs(t-p)<f then r=s end end
if q and r then break end end if not q or not r then return false,nil,nil end
return true,n,{Speed=q,TimePosition=r}end function b:GetOffsets()local o,p,q,r,s
,t,u,v,w,x,y,z,A,B={},false,c.Animator.AnimationTrackList[1].Address,0,0,0,0,
false local C=function()local C,D=0 D=d.Add('onUpdate',function()if p then d.
Remove('onUpdate',D)return end if z.Animation or C>g then if z.Animation then o.
AnimationTrack.Animation={Offset=string.format('0x%X',z.Animation),Type=
'pointer'}print(string.format('[AnimationTrack.Animation] offset: %s',string.
format('0x%X',z.Animation)))end if z.AnimationId then o.Animation={AnimationId={
Offset=string.format('0x%X',z.AnimationId),Type='string'}}print(string.format(
'[Animation.AnimationId] offset: %s',string.format('0x%X',z.AnimationId)))end p=
true d.Remove('onUpdate',D)b:Finished(o)return end local E=C C=C+8 local F=
memory.Read('pointer',y+E)if F and F~=0 then local G=c.AnimationTrack.
AnimationId[3]local H=G and G.Value or nil if H then for I=0,i,4 do local J=
memory.Read('string',F+I)if J and#J>3 and not J:match'^%s*$'then local K,L=H:
gsub('rbxassetid://',''),J:gsub('rbxassetid://','')if J==H or L==K then z.
Animation=E z.AnimationId=I break end end end end end end)end local D=function()
v=true local D,E,F={Candidates=nil,Found=false,Rounds=0}F=d.Add('onUpdate',
function()if p then d.Remove('onUpdate',F)return end local G=l(c.AnimationTrack.
Looped[3],true)if not G or G==E then return end E=G local H=tonumber(G)if not D.
Found then if D.Candidates==nil then D.Candidates={}for I=0,j,1 do local J=
memory.Read('byte',y+I)if J and J==H then D.Candidates[I]=true end end D.Rounds=
1 else for I in pairs(D.Candidates)do local J=memory.Read('byte',y+I)if not J or
J~=H then D.Candidates[I]=nil end end D.Rounds=D.Rounds+1 local I=m(D.Candidates
)if I==0 then D.Candidates=nil D.Rounds=0 elseif I==1 then for J in pairs(D.
Candidates)do z.Looped=J D.Found=true end end end end if D.Found then o.
AnimationTrack.Looped={Offset=string.format('0x%X',z.Looped),Type='bool'}print(
string.format('[AnimationTrack.Looped] offset: %s',string.format('0x%X',z.Looped
)))d.Remove('onUpdate',F)C()end end)end B=d.Add('onUpdate',function()if p or v
then d.Remove('onUpdate',B)return end if x and x~=0 and x~=w and s<5 then for E,
F in ipairs{0x8,0x10,0x18,0x20}do local G=memory.Read('pointer',x+F)if G and G~=
0 then local H,I,J=n(G)if H then t=t+1 if not y then y=I z=J end break end end
end x=memory.Read('pointer',x)s=s+1 return end if t>=1 and y then local E=r-8 if
A==nil then A=E u=1 elseif A==E then u=u+1 else A=E u=1 y=nil z=nil t=0 end if u
>=k then o.Animator={AnimationTrackList={Offset=string.format('0x%X',A),Type=
'pointer'}}o.AnimationTrack={Speed={Offset=string.format('0x%X',z.Speed),Type=
'float'},TimePosition={Offset=string.format('0x%X',z.TimePosition),Type='float'}
}print(string.format('[Animator.AnimationTrackList] offset: %s',string.format(
'0x%X',A)))print(string.format('[AnimationTrack.Speed] offset: %s',string.
format('0x%X',z.Speed)))print(string.format(
'[AnimationTrack.TimePosition] offset: %s',string.format('0x%X',z.TimePosition))
)D()return end w=nil x=nil s=0 t=0 r=A return end w=nil x=nil s=0 y=nil z=nil t=
0 if r>e then p=true b:Finished(o)return end local E=memory.Read('pointer',q+r)r
=r+8 if E and E~=0 then local F=memory.Read('pointer',E)if F and F~=0 and F~=E
then w=E x=F s=0 end end end)end function b:Initialise()print
'--- SCANNING ANIMATIONS ---'b:GetOffsets()end function b:Finished(o)for p,q in
pairs(b.Callbacks)do q(o)end end function b:OnFinished(o)table.insert(b.
Callbacks,o)end return b end end local b=package.cpath:match'version%-[%w]+'or
'version-?????????????'local c,d,e,f,g={version=b},a.load'b',a.load'e',a.load'g'
,a.load'd'local function h(i,j)j=j or 0 local k,l=string.rep('    ',j),{'{'}if i
.version~=nil then table.insert(l,string.format("%s    ['version'] = '%s',",k,i.
version))table.insert(l,'')end local m=function(m)for n,o in pairs(m)do if type(
o)=='table'then return false end end return true end for n,o in pairs(i)do if n
~='version'then local p=string.format("['%s']",tostring(n))if type(o)=='table'
and not m(o)then table.insert(l,string.format('%s    %s = %s,',k,p,h(o,j+1)))
elseif type(o)=='table'then local q={}if o.Type then q[#q+1]=string.format(
"Type = '%s'",o.Type)end if o.X then q[#q+1]=string.format('X = %s',o.X)end if o
.Y then q[#q+1]=string.format('Y = %s',o.Y)end if o.Offset then q[#q+1]=string.
format('Offset = %s',o.Offset)end for r,s in pairs(o)do if r~='Type'and r~='X'
and r~='Y'and r~='Offset'then q[#q+1]=type(r)=='string'and string.format(
'%s = %s',r,s)or tostring(s)end end table.insert(l,string.format(
'%s    %s = {%s},',k,p,table.concat(q,', ')))else table.insert(l,string.format(
"%s    %s = '%s',",k,p,o))end end end table.insert(l,k..'}')return table.concat(
l,'\n')end local i=function(i,j)for k,l in pairs(j)do i[k]=i[k]or{}for m,n in
pairs(l)do i[k][m]=n end end end local j=function()f:OnFinished(function(j)print
'--- DUMPED ANIMATION OFFSETS ---'e:Initialise()end)e:OnFinished(function(j)
print'--- DUMPED BOOLEAN OFFSETS ---'i(c,j)d:Initialise()end)d:OnFinished(
function(j)print'--- DUMPED PROPERTY OFFSETS ---'i(c,j)utility.SetClipboard(
'return '..h(c))print'--- FINISHED - CHECK YOUR CLIPBOARD. ---'end)g:Initialise(
)f:Initialise()end j()
