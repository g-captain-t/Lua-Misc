--[[An old version of the chassis, which I attempted to design using BodyForces. 
This calculates the exact force using Newtonian physics.]]



local RunService = game:GetService("RunService")
local Main = script.Parent.Main.Value 
local Settings = Main.Parent.SETTINGS

local maxThrottle = Settings.MaxThrottle.Value
local maxYawSpeed = Settings.MaxYawSpeed.Value
local gSpeedDiv = Settings.HorizSpeedQuotient.Value
local throttleDiff = Settings.ThrottleDifferential.Value

local bVelocity = Instance.new("BodyThrust")
--bVelocity.MaxForce = Vector3.new(99999,999999,99999)
--bVelocity.Velocity = Vector3.new(0,0,0)
bVelocity.Parent = Main 

local bAngularVYaw = Instance.new("BodyAngularVelocity")
bAngularVYaw.AngularVelocity = Vector3.new(0,0,0)
bAngularVYaw.Parent = Main

local bGyro = Instance.new("BodyGyro")
--local GyroBlock = Main.GyroBlock



function hasMass(part)
	local success = pcall(function() local t = part['Massless'] end)
	if success then return success end
end

function getForce ()
	-- Force = Mass x Acceleration. Acceleration = Distance / Time. Distance / time == throttle.Value (studs per second)
	local mass = 1
	local parts = Main.Parent:GetDescendants()
	for _, part in pairs (parts) do
		if part:IsA("Seat")or part:IsA("VehicleSeat")then local bodyParts = part.Occupant.Parent:GetDescendants() for _, bodypart in pairs(bodyParts) do if hasMass(bodypart)then 
					mass = mass + bodypart:GetMass() end 
			if hasMass(part) then mass = mass + part:GetMass()end end 
		elseif hasMass(part) then mass = mass + part:GetMass()end
	end
	local force = mass * script.Throttle.Value 
	return force
end






function correctMax(valInstance, max)
	valInstance:GetPropertyChangedSignal("Value"):Connect(function()
		if valInstance.Value > max then valInstance.Value = max
		elseif valInstance.Value < -max then valInstance.Value = -max end
	end)
end


--- THROTTLE UP/DOWN

local throttleHeld = false
local throttle = script.Throttle

correctMax(throttle, maxThrottle)

script.ThrottleEv.OnServerEvent:Connect(function(player, bool, direction)
	throttleHeld = bool 
	if direction == "CUT" then throttle.Value = 0 end
	repeat wait()
		if throttleHeld == true and throttle.Value < maxThrottle and direction == "UP" then
			wait() throttle.Value = throttle.Value + 1
		elseif  throttleHeld == true and throttle.Value >  -maxThrottle and direction == "DOWN" then
			wait() throttle.Value = throttle.Value - 1 
		end
	until throttleHeld == false
	throttle.Value = 0 
end)


--- YAW

local yawHeld = false
local yaw = script.Yaw

script.YawEv.OnServerEvent:Connect(function(player, bool, direction)
	yawHeld = bool 
	repeat wait()
		if yawHeld == true and yaw.Value < maxYawSpeed and direction == "LEFT" then
				
			wait(.1) yaw.Value = yaw.Value + 1 
		elseif  yawHeld == true and yaw.Value >  -maxYawSpeed and direction == "RIGHT" then
			wait(.1) yaw.Value = yaw.Value - 1
		end
	until yawHeld == false 
	if yawHeld == false then 
		yaw.Value = 0 bAngularVYaw.AngularVelocity = Vector3.new(0,0,0)  
	end
end)

correctMax(yaw, maxYawSpeed)



-- GYRO

script.GyroEv.OnServerEvent:Connect(function()
	bGyro.Parent = Main wait(1)
	bGyro.Parent = nil 

end)

-- ALTITUDE LOCK

---- FUNCTIONS ---

function correctMax(valInstance, max)
	valInstance:GetPropertyChangedSignal("Value"):Connect(function()
		print (valInstance.Name, valInstance.Value)
		if valInstance.Value > max then valInstance.Value = max
		elseif valInstance.Value < -max then valInstance.Value = -max end
	end)
end



RunService.Heartbeat:Connect(function() 
	local force = getForce()
	local velZ = Main.CFrame.lookVector.Z*force
	local velX = Main.CFrame.LookVector.X*force
	local velY = 0
	
	bVelocity.Force = Vector3.new(velX, velY, velZ)--Vector3.new(0,throttle.Value,0)

	
	
	bAngularVYaw.AngularVelocity = Vector3.new(0,yaw.Value,0) 
	
	
end)


