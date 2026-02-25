local AutoBlackFlash = {
	Enabled = false,
	HotkeyEnabled = false,

	Timings = {
		Itadori = 0.285,
		Mahito = 0.285,
	},

	_Waiting = false,
	_NextPressTime = 0,
	_WasDown = false,
}

local EntityLocalPlayer = entity.GetLocalPlayer()
local Environment = require("@modules/core/Environment")
local PlayerTracker = require("@modules/core/PlayerTracker")

function AutoBlackFlash.Runtime()
	if not AutoBlackFlash.Enabled then
		return
	end

	if not AutoBlackFlash.HotkeyEnabled then
		return
	end

	local SelectedCharacter = Environment.LocalInfo.SelectedCharacter
	if SelectedCharacter ~= "Mahito" and SelectedCharacter ~= "Itadori" then
		return
	end

	local Now = utility.GetTickCount()
	local IsDown = keyboard.IsPressed(0x33)

	if
		not PlayerTracker:DoesPlayerHaveMove(EntityLocalPlayer, "Focus Strike")
		and not PlayerTracker:DoesPlayerHaveMove(EntityLocalPlayer, "Divergent Fist")
	then
		return
	end

	if IsDown and not AutoBlackFlash._WasDown and not AutoBlackFlash._Waiting then
		local BaseDelaySeconds = AutoBlackFlash.Timings[SelectedCharacter] or 0
		local DelayMs = BaseDelaySeconds * 1000

		local Ping = Environment.LocalInfo.Ping or 0
		DelayMs = DelayMs - Ping
		if DelayMs < 0 then
			DelayMs = 0
		end

		if Environment.DebugMode then
			print("Executing Blackflash Delay: " .. tostring(Now + DelayMs))
		end

		AutoBlackFlash._NextPressTime = Now + DelayMs
		AutoBlackFlash._Waiting = true
	end

	if AutoBlackFlash._Waiting and Now >= AutoBlackFlash._NextPressTime then
		keyboard.Click(0x33)
		AutoBlackFlash._Waiting = false

		if Environment.DebugMode then
			print("Executed Blackflash")
		end
	end

	AutoBlackFlash._WasDown = IsDown
end

function AutoBlackFlash.Initialise(
	Container: typeof(require("@modules/ui/UIWrapper")
		.NewTab(nil, nil)
		:Container(nil, nil, nil))
)
	local Enabled = Container:Checkbox("Auto Blackflash", false)
	local Hotkey = Container:KeyPicker("Auto Blackflash Hotkey", true)
	cheat.Register("onPaint", function()
		AutoBlackFlash.Runtime()
	end)

	cheat.Register("onUpdate", function()
		AutoBlackFlash.Enabled = Enabled:Get()
		AutoBlackFlash.HotkeyEnabled = Hotkey:Get() == true
	end)
end

return AutoBlackFlash
