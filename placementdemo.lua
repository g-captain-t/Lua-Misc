local mouse = game.Players.LocalPlayer:GetMouse()

local function weld(part, part1)
	local wc = Instance.new("WeldConstraint")
	wc.Part0 = part wc.Part1 = part1
	wc.Parent = part
	return wc
end

local weldcache = {}

local function WeldGroup(group)
	local welds = {
		welds = {};
		anchored = {};
		cancollide = {};
	}
	local primarypart = group._root
	for i, v in ipairs(group:GetDescendants()) do 
		if v:IsA("BasePart") and v~=primarypart then 
			local wc = weld(primarypart,v)
			table.insert(welds.welds, wc)
			if v.Anchored then table.insert(welds.anchored,v) end
			if v.CanCollide then table.insert(welds.cancollide,v) end
			v.CanCollide = false
			v.Anchored = false
		end
	end
	weldcache[group] = welds
end

local function UnweldGroup(group)
	for i, v in ipairs(weldcache[group].anchored) do 
		v.Anchored = true
	end
	for i, v in ipairs(weldcache[group].cancollide) do 
		v.CanCollide = true
	end
	for i, v in ipairs(weldcache[group].welds) do 
		v:Destroy()
	end
	weldcache[group] = nil
end

local model = script.Model
model.Parent = workspace
model.PrimaryPart = model._root
WeldGroup(model)

local function rayhit(blacklist)
	local Cam = workspace.Camera
	local direction = -(Cam.CFrame.Position - mouse.Hit.Position).Unit
	local magnitude = (Cam.CFrame.Position - mouse.Hit.Position).Magnitude + 1
	local rayparams = RaycastParams.new()
	rayparams.FilterType = Enum.RaycastFilterType.Blacklist
	rayparams.FilterDescendantsInstances = blacklist
	return workspace:Raycast(Cam.CFrame.Position, direction*magnitude, rayparams)
end

local SnapSize = 1

local function round(n,near)
	return math.floor(n/near) * near
end

local function snap(vector, cellsize)
	if not cellsize or cellsize == 0 then return vector end
	return Vector3.new(
		round(vector.X, cellsize),
		round(vector.Y, cellsize),
		round(vector.Z, cellsize)
	)
end

game:GetService("RunService").RenderStepped:Connect(function()
	local results = rayhit({model, game.Players.LocalPlayer.Character})
	if not results then return end
	mouse.TargetFilter = model
	local snapped = snap(mouse.Hit.p, SnapSize)
	model._root.CFrame = CFrame.new(snapped + model._root.Size*results.Normal/2) 
	-- Think +(0,Size.Y/2,0), but applies to any surface
end)
