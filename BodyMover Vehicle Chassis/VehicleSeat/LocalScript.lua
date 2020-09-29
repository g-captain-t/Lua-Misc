local UserInputService = game:GetService("UserInputService")

local gyroEv = script.Parent.MainScript.GyroEv

game:GetService("UserInputService").InputBegan:Connect(function(input, gp)
	-- Gyro
	if input.KeyCode == Enum.KeyCode.G then 
		gyroEv:FireServer() 
		
	end
end)
