local Cast = require(script.Parent.CastBullet)
local Button = script.Parent.FireButton.ClickDetector
local Cannon = script.Parent.Cannon

local function CreateBullet()
	local p = Instance.new("Part")
	p.Size = Vector3.new(0.1,0.1,5)
	p.Anchored = true p.CanCollide = false
	p.Material = Enum.Material.Neon
	p.Parent = workspace
	return p
end

Button.MouseClick:Connect(function()
	local bullet = Cast.newBullet(300,300,CreateBullet())
	bullet.Origin = Cannon.Position
	bullet.Direction = Cannon.CFrame.LookVector
	
	local rayParams = RaycastParams.new()
	rayParams.FilterDescendantsInstances = {script.Parent, bullet.BasePart}
	rayParams.FilterType = Enum.RaycastFilterType.Blacklist
	
	bullet.Fire(bullet, rayParams)
	
	bullet.Hit.Event:Connect(function(Hit)
		bullet.BasePart:Destroy()
		bullet.Destroy(bullet)
		if Hit then print(Hit.Instance) end
	end)
end)
