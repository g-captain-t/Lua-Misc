local neuro = require(script.Parent.Neuro)
hint = Instance.new("Hint", script.Parent)
population = neuro.new("population")

for i = 1 , 25 do
	population:AddBrain(neuro.new("network",5,4,1,5))
end
local PlaneTemplate = script.Parent.Plane
local input_Record = {}
local output_Record = {}

--[[

Inputs:
Velocity Magnitude



Outputs:
BVelocity Magnitude
BGyro Angle X
BGyro Angle Y
BGyro Angle Z

]]


for generation = 1, math.huge do
	
	for i=1, #population.Brains, 3  do
		local start = tick()
		local skip = false
		--hint.Text = "Generation: "..generation.." Zombie: " .. numBrain
		local brains = {
			population.Brains[i],
			population.Brains[i+1],
			population.Brains[i+2]
		}
		
		local startpos = CFrame.new(573.5, 54.75, 173)
		
		for _, brain in pairs (brains) do
			brain.Plane = PlaneTemplate:Clone()
			brain.Plane.Parent = script.Parent
			game:GetService("RunService").Heartbeat:Wait()
			brain.Plane.Main.CFrame = startpos
			brain.Plane.Weld.Disabled = false
		end
		

		while not skip do 
			game:GetService("RunService").Heartbeat:Wait()
			for _, brain in pairs (brains) do
				local main = brain.Plane:FindFirstChild("Main")
				if not main then continue end
				local inputs = {
					main.BVelocity.Velocity.magnitude,
					main.Orientation.X,
					main.Orientation.Y,
					main.Orientation.Z,
					(script.Parent.Goal.Position-main.Position).magnitude
				}
				outputs = brain:evaluate(inputs)
				main.BVelocity.Velocity = 150* main.CFrame.LookVector*outputs[1] --+ Vector3.new(0,-10,0)
				main.BGyro.CFrame = main.CFrame*CFrame.Angles(outputs[2]*(outputs[3]>0.5 and -1 or 1)/5,0,0)
				brain.fitness = 1/(script.Parent.Goal.Position-main.Position).magnitude
			end
			skip = tick()-start >=15  or skip
		end
		
		for _, brain in pairs (brains) do
			brain.Plane:Destroy()
		end
		
	end

	population:Evolve()
    print("Generation " .. generation .. " : Total fitness " .. population:GetTotalFitness() .. " : Best Fitness " .. population:GetBest().fitness)
    population:resetFitness()
    wait()
end
