local player = game.Players.LocalPlayer

function teleportButton(instButton)
	instButton.MouseButton1Click:Connect(function()
		local location = workspace:FindFirstChild(instButton.Name)
		if location and player.Character.Humanoid.Sit == false then
			player.Character.HumanoidRootPart.CFrame = location.CFrame
		end
	end)
end

teleportButton(script.Parent.LocationTarmac)
teleportButton(script.Parent.LocationCruise)
teleportButton(script.Parent.LocationDescent)
