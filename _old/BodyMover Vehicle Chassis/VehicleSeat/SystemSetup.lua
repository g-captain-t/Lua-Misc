function giveTool(weldchild)
	local findhuman = weldchild.Part1.Parent:FindFirstChild("Humanoid")
	if (findhuman ~= nil) then
		local player = game.Players:GetPlayerFromCharacter(findhuman.Parent)
		if (player ~=nil) then
			gui = script.Parent["System"]:Clone() -- Change toolname to what tool you want to be given
			gui.Parent = player.PlayerGui
			gui.Main.Value = script.Parent.Parent.Main
			gui.MainScript.Disabled = false
			gui.LocalScript.Disabled = false
		end
	end
end

function removeTool()
	if (gui ~= nil) then
		for _, descendant in pairs(gui.Main.Value:GetDescendants()) do
			if descendant:IsA("BodyAngularVelocity") or descendant:IsA("BodyVelocity") or descendant:IsA("BodyGyro") then
				descendant:Destroy() end
		end
		gui:Destroy()
	end
end

script.Parent.ChildAdded:connect(giveTool)
script.Parent.ChildRemoved:connect(removeTool)
