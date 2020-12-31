--[[
Planes #2, 31/12/2020
This one trains an entire generation at once, and the only outputs are the velocity, pitch and roll.
I still have trouble figuring out how to have the NNs output negative numbers, so the planes learned
to regulate their pitch by rolling.
]]

local neuro = require(script.Parent.Neuro)
hint = Instance.new("Hint", script.Parent)
population = neuro.new("population")

for i = 1 , 25 do
	population:AddBrain(neuro.new("network",5,3,1,5))
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
local startpos = CFrame.new(573.5, 54.75, 173)

for generation = 1, math.huge do
	local skips = 0
	local startpos = CFrame.new(573.5, 54.75, 173)
	
	for _, brain in pairs (population.Brains) do
		brain.Plane = PlaneTemplate:Clone()
		brain.Plane.Parent = script.Parent
		game:GetService("RunService").Heartbeat:Wait()
		brain.Plane.Main.CFrame = startpos
		brain.Plane.Weld.Disabled = false
		local main = brain.Plane:FindFirstChild("Main")
		local skip = false
		local t = tick()
		
		coroutine.wrap(function()
			while (not skip) and (brain.Plane~=nil) do 
				if not brain.Plane then break end
				game:GetService("RunService").Heartbeat:Wait()
				main = brain.Plane:FindFirstChild("Main")
				if not main then break end
				if not main:FindFirstChild("BVelocity") then break end
				local inputs = {
					main.BVelocity.Velocity.magnitude,
					main.Orientation.X,
					main.Orientation.Y,
					main.Orientation.Z,
					(script.Parent.Goal.Position-main.Position).magnitude
				}
				local outputs = brain:evaluate(inputs)
				main.BVelocity.Velocity = 150* main.CFrame.LookVector*outputs[1] --+ Vector3.new(0,-10,0)
				main.BGyro.CFrame = main.CFrame*CFrame.Angles(math.rad(outputs[2]*80),0,math.rad(outputs[3]*80))

				hint.Text = tostring(outputs[1]).." "..tostring(outputs[2]).." "..tostring(outputs[3])
				
				brain.fitness = (script.Parent.Start.Position-main.Position).magnitude
			end
		end)()
		local con, debounce
		local function ontouch(part)
			if part:IsDescendantOf(script.Parent.Parts) then 
				if debounce then return end
				debounce = true
				skip = true
				skips = skips+1	print(skips)
				brain.Plane:Destroy()  
				con:Disconnect()
			end
		end
		con= main.Touched:Connect(ontouch)
	end
	
	repeat game:GetService("RunService").Heartbeat:Wait() until skips == #population.Brains 
	population:Evolve()
    print("Generation " .. generation .. " : Total fitness " .. population:GetTotalFitness() .. " : Best Fitness " .. population:GetBest().fitness)
    population:resetFitness()
    wait()
end
