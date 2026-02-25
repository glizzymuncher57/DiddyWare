local PerfectSwap = {
	Enabled = false,
	BindPressed = false,
	MaxWorldDistance = 50,
	MaxScreenDistance = 195,

	StandingDelay = 500,
	RagdollDelay = 250,

	_Waiting = false,
	_NextPressTime = 0,
	_WasDown = false,
}

local EntityLocalPlayer = entity.GetLocalPlayer()
local Environment = require("@modules/core/Environment")
local PlayerTracker = require("@modules/core/PlayerTracker")

local function GetClosestEntityToMouse()
	local MousePosition = utility.GetMousePos()

	local ClosestCharacter, ClosestDistance = nil, math.huge
	for _, Entity in pairs(entity.GetPlayers(false)) do
		local ScreenX, ScreenY, OnScreen = utility.WorldToScreen(Entity.Position)
		if OnScreen then
			local DX = ScreenX - MousePosition[1]
			local DY = ScreenY - MousePosition[2]
			local Distance = math.sqrt(DX * DX + DY * DY)
			if Distance < ClosestDistance then
				ClosestCharacter = Entity
				ClosestDistance = Distance
			end
		end
	end

	return ClosestCharacter, ClosestDistance
end

function PerfectSwap.Runtime()
	if not PerfectSwap.Enabled then
		return
	end

	if not PerfectSwap.BindPressed then
		return
	end

	if Environment.LocalInfo.SelectedCharacter ~= "Todo" then
		return
	end

	local Now = utility.GetTickCount()
	local IsDown = keyboard.IsPressed("r")

	if IsDown and not PerfectSwap._WasDown and not PerfectSwap._Waiting then
		if PlayerTracker:GetPlayerUltimate(EntityLocalPlayer) < 4 then
			return
		end

		local Target, Distance = GetClosestEntityToMouse()
		if Distance > PerfectSwap.MaxScreenDistance then
			if Environment.DebugMode then
				print("Target Out Of Screen Distance Range: " .. tostring(PerfectSwap.MaxScreenDistance))
			end
			return
		end

		if Target then
			local WorldDistance = (EntityLocalPlayer.Position - Target.Position).Magnitude
			if WorldDistance > PerfectSwap.MaxWorldDistance then
				if Environment.DebugMode then
					print("Target Out Of World Distance Range: " .. tostring(PerfectSwap.MaxWorldDistance))
				end
				return
			end

			local HasUltimate = PlayerTracker:DoesPlayerHaveMove(EntityLocalPlayer, "Brothers")
			local Ragdolled = PlayerTracker:GetPlayerRagdollState(Target)
			local DelayMs = Ragdolled and PerfectSwap.RagdollDelay or PerfectSwap.StandingDelay
			local Ping = Environment.LocalInfo.Ping or 0
			DelayMs = DelayMs - Ping
			if DelayMs < 0 then
				DelayMs = 0
			end

			if HasUltimate then
				DelayMs = 250
			end

			if Environment.DebugMode then
				print(
					"Executing Todo Perfect Swap, Ragdolled: "
						.. tostring(Ragdolled)
						.. "Delay: "
						.. tostring(Now + DelayMs)
				)
			end

			PerfectSwap._NextPressTime = Now + DelayMs
			PerfectSwap._Waiting = true
		end
	end

	if PerfectSwap._Waiting and Now >= PerfectSwap._NextPressTime then
		mouse.Click("leftmouse")
		PerfectSwap._Waiting = false

		if Environment.DebugMode then
			print("Executed Todo Perfect Swap.")
		end
	end

	PerfectSwap._WasDown = IsDown
end

function PerfectSwap.Initialise(
	Container: typeof(require("@modules/ui/UIWrapper").NewTab(nil, nil):Container(nil, nil, nil))
)
	local Enabled = Container:Checkbox("Todo Perfect Swap", false)
	local Hotkey = Container:KeyPicker("Todo Perfect Swap Hotkey", true)
	local StandingDelay = Container:SliderInt("Target Standing Delay", 1, 1000, 500)
	local RagdollDelay = Container:SliderInt("Target Ragdolled Delay", 1, 1000, 250)
	local MaxWorldDistance = Container:SliderInt("Max World Distance", 1, 200, 50)
	local MaxScreenDistance = Container:SliderInt("Max Screen Distance", 1, 300, 195)
	cheat.Register("onUpdate", function()
		PerfectSwap.Runtime()
		PerfectSwap.Enabled = Enabled:Get()
		PerfectSwap.BindPressed = Hotkey:Get() == true
		PerfectSwap.StandingDelay = StandingDelay:Get()
		PerfectSwap.RagdollDelay = RagdollDelay:Get()
		PerfectSwap.MaxWorldDistance = MaxWorldDistance:Get()
		PerfectSwap.MaxScreenDistance = MaxScreenDistance:Get()

		MaxWorldDistance:Visible(PerfectSwap.Enabled)
		MaxScreenDistance:Visible(PerfectSwap.Enabled)
		StandingDelay:Visible(PerfectSwap.Enabled)
		RagdollDelay:Visible(PerfectSwap.Enabled)
	end)
end

return PerfectSwap
