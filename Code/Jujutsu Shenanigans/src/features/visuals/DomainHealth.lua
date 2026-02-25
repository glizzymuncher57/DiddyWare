local DomainHealth = {
	Enabled = false,
	TextColor = Color3.fromRGB(255, 255, 255),
	TextAlpha = 255,
}

local Environment = require("@modules/core/Environment")

local function GetAttribute(Instance, AttributeName, DefaultValue)
	local Attribute = Instance:GetAttribute(AttributeName)
	return Attribute and Attribute.Value or DefaultValue
end

local function TableToRGB(Table)
	if type(Table) ~= "table" then
		return Color3.fromRGB(255, 255, 255)
	end

	local r = Table.R or Table.r or 255
	local g = Table.G or Table.g or 255
	local b = Table.B or Table.b or 255
	return Color3.fromRGB(r, g, b)
end

function DomainHealth.Draw()
	if not DomainHealth.Enabled then
		return
	end

	local ScreenWidth, _ = cheat.GetWindowSize()

	for _, Domain in pairs(Environment.Folders.Domains) do
		local Health = GetAttribute(Domain, "Health", 0)
		local HealthText = "Domain Health: " .. tostring(math.floor(Health))
		local TextWidth, TextHeight = draw.GetTextSize(HealthText, Environment.Font)

		local ClosestDomain = Environment.ClosestDomain
		local FinalX, FinalY, FinalOnScreen = nil, nil, false

		if ClosestDomain.Instance and Domain == ClosestDomain.Instance and ClosestDomain.Distance <= 40 then
			FinalX = (ScreenWidth / 2) - (TextWidth / 2)
			FinalY = 50
			FinalOnScreen = true
		else
			local X, Y, OnScreen = utility.WorldToScreen(Domain.Position)
			if X and Y and OnScreen then
				FinalX = X - TextWidth / 2
				FinalY = Y - TextHeight / 2
				FinalOnScreen = OnScreen
			end
		end

		if FinalOnScreen and HealthText ~= "" then
			draw.TextOutlined(
				HealthText,
				FinalX,
				FinalY,
				DomainHealth.TextColor,
				Environment.Font,
				DomainHealth.TextAlpha
			)
		end
	end
end

function DomainHealth.Initialise(Container)
	local Enabled = Container:Checkbox("Visualise Domain Health", DomainHealth.Enabled)
	local TextColor = Container:Colorpicker("Domain Health Text Color", {
		r = 255,
		g = 255,
		b = 255,
		a = DomainHealth.TextAlpha,
	}, true)

	cheat.Register("onPaint", DomainHealth.Draw)
	cheat.Register("onUpdate", function()
		local TextRGBA = TextColor:Get()
		DomainHealth.Enabled = Enabled:Get()
		DomainHealth.TextColor = TableToRGB(TextRGBA)
		DomainHealth.TextAlpha = TextRGBA.A
	end)
end

return DomainHealth
