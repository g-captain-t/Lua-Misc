local OtherParts = script.Parent
local seats = {}
local toClone = script:WaitForChild("View")

for _, descendant in pairs (OtherParts:GetDescendants()) do
	if descendant:IsA("Seat") then
		seats[#seats+1] = descendant
	end
end

OtherParts.DescendantAdded:Connect(function(descendant)
	if descendant:IsA("Seat") then
		seats[#seats+1] = descendant
	end
end)

for _, seat in pairs (seats) do
	local viewScript
	
	seat.ChildAdded:Connect(function(weldchild)
		local findhuman = weldchild.Part1.Parent:FindFirstChild("Humanoid")
		if (findhuman ~= nil) then
			local player = game.Players:GetPlayerFromCharacter(findhuman.Parent)
			if (player ~=nil) then
				viewScript = toClone:Clone()
				viewScript.Parent = player.PlayerGui
				viewScript.Disabled = false
			end
		end
	end)
	
	seat.ChildRemoved:Connect(function()
		viewScript:Destroy()
	end)
	
end
