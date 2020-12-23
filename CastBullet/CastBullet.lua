local Cast = {}
local RS = game:GetService("RunService")

function Cast.newBullet (Velocity, MaxDistance, BasePart)
	local bullet = {		
		Velocity = Velocity or 100;
		MaxDistance = MaxDistance or 300;
		
		Origin = Vector3.new();
		Direction = Vector3.new();
		Position = Vector3.new();
		
		Hit = Instance.new("BindableEvent");
		BasePart = BasePart
	}
	
	function bullet.Destroy(self)
		if self.run then self.run:Disconnect() end
		self = nil
	end
	
	function bullet.Fire(self, rayParams)
		local t, lastPos = os.clock(), self.Origin
		self.Position = self.Origin

		bullet.run = RS.Heartbeat:Connect(function()
			local deltaT = os.clock()-t
			local deltaD = deltaT*self.Velocity
			local newPos = self.Position + deltaD*self.Direction
			self.Position = newPos
			if self.BasePart then self.BasePart.Position = newPos end
			
			local Results = workspace:Raycast(lastPos,(newPos-lastPos), rayParams)
			t, lastPos = os.clock(), self.Position
			if Results then self.Hit:Fire(Results) end
			if (self.Origin-self.Position).magnitude > self.MaxDistance then self.Hit:Fire() end
		end)
	end
	
	return bullet
end

return Cast
