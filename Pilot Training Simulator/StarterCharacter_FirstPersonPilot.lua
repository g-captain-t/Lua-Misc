local player = game.Players.LocalPlayer
local character = player.Character or player.CharactedAdded:Wait()
local RS = game:GetService("RunService")
local RENDER_PRIORITY = Enum.RenderPriority.Character.Value - 5
local plane

local function planeInCharacter()
	for i, d in pairs(plane:GetDescendants()) do
		if d:IsA("BasePart") then 
			d.LocalTransparencyModifier = 0 end
	end
end

character.ChildAdded:Connect(function(child)
	if child.Name ~= "Plane" then return end
	plane = child 
	RS:BindToRenderStep("PlaneTransparency", RENDER_PRIORITY, planeInCharacter)
end)

character.ChildRemoved:Connect(function(child)
	if child~= plane then return end
	plane = nil
	RS:UnbindFromRenderStep("PlaneTransparency")
end)
