local RunService = game:GetService("RunService")
local Main = script.Parent.Main.Value 
local Seat = Main.Parent.VehicleSeat
local Settings = Seat.SETTINGS

local maxThrottle = Settings.MaxThrottle.Value
local maxYawSpeed = Settings.MaxYawSpeed.Value
local throttleDiff = Settings.ThrottleDifferential.Value

local bVelocity = Instance.new("BodyVelocity")
bVelocity.MaxForce = Vector3.new(99999,999999,99999)
bVelocity.Velocity = Vector3.new(0,0,0)
bVelocity.Parent = Main 


local bAngularVYaw = Instance.new("BodyAngularVelocity")
bAngularVYaw.AngularVelocity = Vector3.new(0,0,0)
bAngularVYaw.Parent = Main

local bGyro = Instance.new("BodyGyro")
--local GyroBlock = Main.GyroBlock
function heightFromGround()
	local result = workspace:Raycast(Main.Position, Vector3.new(0,-100,0))
	if result then return Main.Position.Y - result.Position.Y else return 10 end
end

local regularYHeight = heightFromGround() + 0.5


function correctMax(valInstance, max)
	valInstance:GetPropertyChangedSignal("Value"):Connect(function()
		if valInstance.Value > max then valInstance.Value = max
		elseif valInstance.Value < -max then valInstance.Value = -max end
	end)
end


--- THROTTLE UP/DOWN

local throttle = script.Throttle
correctMax(throttle, maxThrottle)


Seat:GetPropertyChangedSignal("Throttle"):Connect(function()
	repeat wait()
		if Seat.Throttle == 1 and throttle.Value < maxThrottle then
			wait() throttle.Value = throttle.Value + throttleDiff
		elseif  Seat.Throttle == -1 and throttle.Value >  -maxThrottle then
			wait() throttle.Value = throttle.Value - throttleDiff
		end
	until Seat.Throttle == 0
	throttle.Value = 0 
end)


--- YAW


local yaw = script.Yaw

Seat:GetPropertyChangedSignal("Steer"):Connect(function()

	repeat wait()
		if Seat.Steer == -1 and yaw.Value < maxYawSpeed then	
			wait(.1) yaw.Value = yaw.Value + 2 
		elseif  Seat.Steer == 1 and yaw.Value >  -maxYawSpeed then
			wait(.1) yaw.Value = yaw.Value - 2
		end
	until Seat.Steer == 0 
	if Seat.Steer == 0 then 
		yaw.Value = 0 bAngularVYaw.AngularVelocity = Vector3.new(0,0,0)  
	end
end)

correctMax(yaw, maxYawSpeed)



-- GYRO

script.GyroEv.OnServerEvent:Connect(function()
	bGyro.Parent = Main wait(1)
	bGyro.Parent = nil 

end)


---- FUNCTIONS ---

function correctMax(valInstance, max)
	valInstance:GetPropertyChangedSignal("Value"):Connect(function()
		print (valInstance.Name, valInstance.Value)
		if valInstance.Value > max then valInstance.Value = max
		elseif valInstance.Value < -max then valInstance.Value = -max end
	end)
end



RunService.Heartbeat:Connect(function() 
	local velZ = Main.CFrame.lookVector.Z*throttle.Value
	local velX = Main.CFrame.LookVector.X*throttle.Value
	local velY =  Main.CFrame.LookVector.Y*throttle.Value
	if heightFromGround() > regularYHeight then velY =  Main.CFrame.LookVector.Y*throttle.Value -3 end
	
	bVelocity.Velocity = Vector3.new(velX,velY,velZ)--Vector3.new(0,throttle.Value,0)
	bAngularVYaw.AngularVelocity = Vector3.new(0,yaw.Value,0) 
	
	
end)
