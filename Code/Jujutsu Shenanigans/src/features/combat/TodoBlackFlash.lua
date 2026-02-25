local TodoBlackflash = {
	Enabled = false,
	BindEnabled = false,
	Delay = 0.575,

	_WasWoosh = false,
	_Waiting = true,
	_NextPressTime = 0,
}

local EntityLocalPlayer = entity.GetLocalPlayer()
local Environment = require("@modules/core/Environment")
local PlayerTracker = require("@modules/core/PlayerTracker")

function TodoBlackflash.Runtime()
	if not TodoBlackflash.Enabled then
		return
	end

	if not TodoBlackflash.BindEnabled then
		return
	end

	if
		Environment.LocalInfo.SelectedCharacter ~= "Todo"
		or not PlayerTracker:DoesPlayerHaveMove(EntityLocalPlayer, "Brute Force")
	then
		return
	end

	local HumanoidRootPart = EntityLocalPlayer:GetBoneInstance("HumanoidRootPart")
	if not HumanoidRootPart then
		return
	end

	local Woosh = HumanoidRootPart:FindFirstChild("Woosh")
	local Now = utility.GetTickCount()

	if Woosh and not TodoBlackflash._WasWoosh and not TodoBlackflash._Waiting then
		local BaseDelaySeconds = TodoBlackflash.Delay or 0
		local DelayMs = BaseDelaySeconds * 1000
		TodoBlackflash._NextPressTime = Now + DelayMs
		TodoBlackflash._Waiting = true

		if Environment.DebugMode then
			print("Executing Todo Blackflash Delay: " .. tostring(TodoBlackflash._NextPressTime))
		end
	end

	if TodoBlackflash._Waiting and Now >= TodoBlackflash._NextPressTime then
		keyboard.Click(0x32)
		TodoBlackflash._Waiting = false
		if Environment.DebugMode then
			print("Executed Todo Blackflash.")
		end
	end

	TodoBlackflash._WasWoosh = Woosh ~= nil
end

function TodoBlackflash.Initialise(
	Container: typeof(require("@modules/ui/UIWrapper")
		.NewTab(nil, nil)
		:Container(nil, nil, nil))
)
	local Checkbox = Container:Checkbox("Todo Blackflash", false)
	local Hotkey = Container:KeyPicker("Todo Blackflash Hotkey", true)
	local TimingSlider = Container:SliderFloat("Todo Blackflash Timing (s)", 0, 1, 0.575)

	cheat.Register("onUpdate", function()
		TodoBlackflash.Enabled = Checkbox:Get()
		TodoBlackflash.BindEnabled = Hotkey:Get() == true
		TodoBlackflash.Delay = TimingSlider:Get()

		TodoBlackflash.Runtime()
		TimingSlider:Visible(TodoBlackflash.Enabled)
	end)
end

return TodoBlackflash
