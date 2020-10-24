local Players = game:GetService("Players")
local Bottom = script.Parent.Bottom
local Top = script.Parent.Top
local Owner = script.Parent.Owner
local Events = script.Parent.Events

Bottom.ClickDetector.MouseClick:Connect(function(player)
	if Owner.Value ~= nil then
		Bottom.PromptGUI:Clone().Parent = player.PlayerGui
	elseif Owner.Value and Owner.Value == player then
		Bottom.OwnerGUI:Clone().Parent = player.PlayerGui
	end
end)

local Modify = script.Parent.Events.Modify
local Claim = script.Parent.Events.Claim
local Abandon = script.Parent.Events.Abandon

local BottomText = Bottom.SurfaceGui.TextLabel
local TopGUI = Top.SurfaceGui

Claim.OnServerEvent:Connect(function(player)
	if Owner.Value ~= nil then
		Owner.Value = player
		BottomText.Text = tostring(player).."'s Booth"
	end
end)

Modify.OnServerEvent:Connect(function(player, category, content)
	if player ~= Owner.Value then return end
	
	if category == "TEXT" then
		Top.SurfaceGui.TextLabel.Text = content
	elseif category == "THUMBNAIL" then
		Top.SurfaceGui.Thumbnail.Image = "rbxassetid://"..content
	elseif category == "COLOR" then
		for _, v in pairs (script.Parent:GetDescendants()) do 
			if v:IsA("BasePart") then v.Color = content end end
	elseif category == "TEXTCOLOR" then
		for _, v in pairs (script.Parent:GetDescendants()) do 
			if v:IsA("BasePart") then v.Color = content end end
	end
end)


local function Abandon(player)
	if player ~= Owner.Value then return end
	for _, v in pairs (script.Parent:GetDescendants()) do 
		if v:IsA("BasePart") then v.Color = Color3.fromRGB(231, 231, 236) 
		elseif v:IsA("TextLabel") then v.TextColor = Color3.new(0,0,0) v.Text = ""
		elseif v:IsA("ImageLabel") then v.Image = "rbxasset://textures/ui/GuiImagePlaceholder.png" end 
	end
	BottomText = "Unoccupied Booth"
	TopGUI.TextLabel.Text = ""
	TopGUI.Thumbnail.Image = ""
	Owner.Value = nil
end
Abandon.OnServerEvent:Connect(Abandon)
Players.PlayerRemoving:Connect(Abandon)


