local Combat = {}

-- << Imports >>
local Callbacks = require("@utility/Callbacks")
local Table = require("@utility/Table")
local Configuration = require("@utility/Configuration")
local PlayerScanner = require("@game/PlayerScanning")
local DebugMode = require("@core/DebugMode")

-- << Variables >>
local TrackedItems = Table:Register("PunishM1Items", {})

-- << Functions >>
local function SendDebugInfo(Message, Level)
	if not Configuration.GetValue("Debug Mode") then
		return
	end

	DebugMode.AddDebugMessage(Message, Level, 1000)
end

local function GetClosestPlayer(LocalData)
    local ClosestData, ClosestDistance = nil, math.huge

    for _, StoredData in pairs(PlayerScanner:GetPlayers()) do
        if StoredData ~= LocalData then
            local Distance = (LocalData.Player.Position - StoredData.Player.Position).Magnitude
            if Distance < ClosestDistance then
                ClosestData = StoredData
                ClosestDistance = Distance
            end
        end
    end

    return ClosestData, ClosestDistance
end

local function Runtime()
	if not Configuration.GetValue("Auto Return M1") then
		return
	end

    local LocalPlayer = PlayerScanner:GetLocalPlayer()
    local RootPart = LocalPlayer and LocalPlayer.RootPart
    if not RootPart then
        SendDebugInfo("Aborted Auto Return M1, No HRP.", "error")
        return
    end

    local BlockHit = RootPart:FindFirstChild("BlockHit")
    if not BlockHit or TrackedItems[BlockHit.Address] then return end

    TrackedItems[BlockHit.Address] = utility.GetTickCount()

    local ClosestPlayer, ClosestDistance = GetClosestPlayer(LocalPlayer)
    if not ClosestPlayer or not ClosestDistance or ClosestDistance > 8 then
        return
    end

    keyboard.release("f")
    mouse.click("leftmouse")
end

function Combat:Initialise()
	Callbacks.Add("onUpdate", function()
        Runtime()
    end)

	Callbacks.Add("onSlowUpdate", function()
		if TrackedItems and type(TrackedItems) == "table" and next(TrackedItems) then
			local Now = utility.GetTickCount()
			for Address, TimeStored in pairs(TrackedItems) do
				if (Now - TimeStored) > 1000 then
					TrackedItems[Address] = nil
				end
			end
		end
	end)
end

return Combat
