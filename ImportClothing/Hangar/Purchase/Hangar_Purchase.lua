local hangar = script.Parent.Parent
local shirtbutton = script.Parent.Shirt
local pantsbutton = script.Parent.Pants
local Marketplace = game:GetService("MarketplaceService")

local function Buy(player, Class)
	local item = hangar:FindFirstChildOfClass(Class)
	if not item then return end
	Marketplace:PromptPurchase(player,tonumber(item.Name)) 
	-- Uses the clothing item name to point to the catalog ID
end

shirtbutton.ClickDetector.MouseClick:Connect(function(player)
	Buy(player, "Shirt")
end)
pantsbutton.ClickDetector.MouseClick:Connect(function(player)
	Buy(player, "Pants")
end)
