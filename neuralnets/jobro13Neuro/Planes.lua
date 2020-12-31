--[[
Planes
- The best planes are the ones that get the closest to a goal position.
- The planes can control their pitch and roll to direct themselves.

Ways I might improve this:
- I only realized late that I didn't even input the position of the goal. Or the position of the planes.
- Maybe if the brains have more data to connect and find a pattern, they could learn faster.
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
			for i=1,500 do
				if not ((not skip) and (brain.Plane~=nil)) then break end
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
				--main.BVelocity.Velocity = 150* main.CFrame.LookVector*outputs[1] --+ Vector3.new(0,-10,0)
				main.BVelocity.Velocity = 100* main.CFrame.LookVector
				main.BGyro.CFrame = main.CFrame*CFrame.Angles(math.rad((outputs[1]-0.5)*80),0,math.rad((outputs[3]-0.5)*80))
				
				brain.fitness = 1/(script.Parent.Goal.Position-main.Position).magnitude
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
