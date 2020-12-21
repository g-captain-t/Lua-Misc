--// Motor (with Values)
local pV = {
	Part0V = script.Part0;
	Part1V = script.Part1;
	AxisV = script.Axis;
	MaxVelocityV = script.MaxVelocity;				-- Degrees per second
	DesiredAngleV = script.DesiredAngle;			-- Degrees 
	CurrentAngleV = script.CurrentAngle
}
local RS = game:GetService("RunService")
local TS = game:GetService("TweenService")
local motor

local function SetupMotor(p)
	motor = Instance.new("Weld")
	motor.Part0 = p.Part0
	motor.Part1 = p.Part1
	motor.Name = "WeldMotor"
	motor.Parent = motor.Part0
	return motor
end

local function Significance(n1,n2,a)
	return math.abs(math.abs(n1)-math.abs(n2)) < a
end

local function toAxis(Axis,N)
	local a = {X=0;Y=0;Z=0}
	a[Axis] = N
	return a.X,a.Y,a.Z
end

local t = tick()
RS.Heartbeat:Connect(function()
	local p = {
		Part0 = pV.Part0V.Value;
		Part1 = pV.Part1V.Value;
		Axis = pV.AxisV.Value;
		MaxVelocity = pV.MaxVelocityV.Value;
		DesiredAngle = pV.DesiredAngleV.Value;
		CurrentAngle = pV.CurrentAngleV.Value;
	}
	if not p.Part0 or not p.Part1 then return end
	p.Axis = p.Axis or "X"
	motor = motor or SetupMotor(p)
	if p.CurrentAngle == p.DesiredAngle then return end
	if Significance(p.CurrentAngle,p.DesiredAngle,0.05) then 
		p.CurrentAngle = p.DesiredAngle 
		motor.C1 = p.Part1.CFrame:ToObjectSpace(p.Part0.CFrame)*CFrame.Angles(toAxis(p.Axis,math.rad(p.DesiredAngle)))
		return 
	end
	
	local direction = -((p.CurrentAngle-p.DesiredAngle)/math.abs(p.CurrentAngle-p.DesiredAngle))
	--// Determines if the direction is 1 or -1
	
	local dt = tick()-t
	t = tick()
	local degreestravelled = p.MaxVelocity*dt*direction
	--// Calculate how much the motor travelled. d = v*t

	motor.C1 = p.Part1.CFrame:ToObjectSpace(p.Part0.CFrame)*CFrame.Angles(toAxis(p.Axis,math.rad(degreestravelled)))
	pV.CurrentAngleV.Value = p.CurrentAngle+degreestravelled
end)