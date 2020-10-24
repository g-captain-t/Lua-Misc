wait(.2)
local plr = game.Players.LocalPlayer
local camera = workspace.CurrentCamera



local char = plr.Character or plr.CharacterAdded
local humanoid = char:WaitForChild("Humanoid")
if humanoid.Sit then -- and humanoid.SeatPart:IsADescendantOf() then
	camera.CameraSubject = char.Head
	wait (0.5) 
	camera.CameraSubject = humanoid
end

	local debounce = false
	humanoid:GetPropertyChangedSignal("Sit"):Connect(function()
		if not debounce then
			debounce = true
			---
			if humanoid.Sit then -- and humanoid.SeatPart:IsADescendantOf() then
				camera.CameraSubject = char.Head 
				wait (0.2) 
				camera.CameraSubject = humanoid
			elseif humanoid.Sit == false then
				camera.CameraSubject = humanoid
			end
			---
			wait(.2)
			debounce = false
			
		end
	end)
