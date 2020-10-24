for i, v in pairs (game.ServerStorage:GetDescendants()) do
	----- CameraFix
	if v:IsA("Model") and v.Name == "OtherParts" then
		local cs = script.CameraFix:Clone()
		cs.Parent = v
		cs.Disabled = false
	end
	----- ClearPlane
	if v:IsA("Model") and v.Name == "MainParts" and v.Parent.Name == "Plane" then
		local cs = script.ClearPlane:Clone()
		cs.Parent = v
		cs.Disabled = false
	end
	-----
end
