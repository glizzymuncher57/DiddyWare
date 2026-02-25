local ItemESP = {
	Enabled = false,
	TextColor = Color3.fromRGB(255, 255, 255),
	TextAlpha = 255,
}

local Environment = require("@modules/core/Environment")

local function TableToRGB(Table)
	if type(Table) ~= "table" then
		return Color3.fromRGB(255, 255, 255)
	end

	local r = Table.R or Table.r or 255
	local g = Table.G or Table.g or 255
	local b = Table.B or Table.b or 255
	return Color3.fromRGB(r, g, b)
end

function ItemESP.Draw()
	if not ItemESP.Enabled then
		return
	end

	for _, Item in pairs(Environment.Folders.Items) do
		local SX, SY, OS = utility.WorldToScreen(Item.Position)
		if SX and SY and OS then
			local Text = Item.Name
			local TextWidth, TextHeight = draw.GetTextSize(Text, Environment.Font)
			local FinalX, FinalY = SX - (TextWidth / 2), SY - (TextHeight / 2)
			if Text ~= "" then
				draw.TextOutlined(Text, FinalX, FinalY, ItemESP.TextColor, Environment.Font, ItemESP.TextAlpha)
			end
		end
	end
end

function ItemESP.Initialise(Container)
	local Enabled = Container:Checkbox("Item ESP", ItemESP.Enabled)
	local TextColor = Container:Colorpicker("Item ESP Text Color", {
		r = 255,
		g = 255,
		b = 255,
		a = ItemESP.TextAlpha,
	}, true)

	cheat.Register("onPaint", ItemESP.Draw)
	cheat.Register("onUpdate", function()
		local TextRGBA = TextColor:Get()
		ItemESP.Enabled = Enabled:Get()
		ItemESP.TextColor = TableToRGB(TextRGBA)
		ItemESP.TextAlpha = TextRGBA.A
	end)
end

return ItemESP
