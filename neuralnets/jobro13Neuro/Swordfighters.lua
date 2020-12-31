--[[
Swordfighters
- The bots know their position, their health, their enemy's position, and the enemy's health.
- The outputs are their next direction,their rotation, and previously, whether to swing their weapons
- Two bots are put up against each other at a time. Only the winner has a score based on their win time.

The bots quickly learned to walk to their enemy, and some of them spun like a spinning top to make sure their
sword hit wherever the enemy came from.
]]
local neuro = require(script.Parent.Neuro)
hint = Instance.new("Hint", script.Parent)
population = neuro.new("population")

for i = 1 , 20 do
	population:AddBrain(neuro.new("network",6,4,2,8))
end

local input_Record = {}
local output_Record = {}


for generation = 1, math.huge do
	print("Generation"..generation)
	for i=1, #population.Brains, 2 do
		local brain1 = population.Brains[i]
		local brain2 = population.Brains[i+1]
		local winnerbrain
		local time_Start = tick()
		local skip = false
		--hint.Text = "Generation: "..generation.." Zombie: " .. numBrain
		
		script.Parent.Arena1.Start1.Position = Vector3.new(math.random(-131,-109),4,math.random(-201,-177))
		script.Parent.Arena1.Start2.Position = Vector3.new(math.random(-131,-109),4,math.random(-201,-177))
		
		local dummy1 = script.Parent.Arena1.Dummy1
		local dummy2 = script.Parent.Arena1.Dummy2
		dummy1.HealthVal.Value = 100
		dummy2.HealthVal.Value = 100
		dummy1.HumanoidRootPart.CFrame = CFrame.new(script.Parent.Arena1.Start1.Position)
		dummy2.HumanoidRootPart.CFrame = CFrame.new(script.Parent.Arena1.Start2.Position)

		while not skip do game:GetService("RunService").Heartbeat:Wait()
			local inputs1 = {
				dummy1.Torso.Position.X,
				dummy1.Torso.Position.Z,
				dummy1.HealthVal.Value,
				dummy2.Torso.Position.X,
				dummy2.Torso.Position.Z,
				dummy2.HealthVal.Value
			}
			outputs1 = brain1:evaluate(inputs1)
			dummy1.HumanoidRootPart.CFrame = dummy1.HumanoidRootPart.CFrame * CFrame.Angles(0,outputs1[4]-0.5/5,0)
			dummy1.Humanoid:MoveTo(Vector3.new(
				dummy2.Torso.Position.X+ outputs1[1]-0.5, 
				dummy2.Torso.Position.Y,
				dummy2.Torso.Position.Z+ outputs1[2]-0.5
				))
			if outputs1[3] > 0 then dummy1.Sword:Activate() end
			
			local inputs2 = {
				dummy2.Torso.Position.X,
				dummy2.Torso.Position.Z,
				dummy2.HealthVal.Value,
				dummy1.Torso.Position.X,
				dummy1.Torso.Position.Z,
				dummy1.HealthVal.Value
			}
			outputs2 = brain2:evaluate(inputs2)
			dummy2.HumanoidRootPart.CFrame = dummy2.HumanoidRootPart.CFrame * CFrame.Angles(0,outputs2[4]-0.5/5,0)
			dummy2.Humanoid:MoveTo(Vector3.new(
				dummy2.Torso.Position.X + outputs2[1]-0.5, 
				dummy2.Torso.Position.Y,
				dummy2.Torso.Position.Z + outputs2[2]-0.5
				))
			if outputs2[3] > 0 then dummy2.Sword:Activate() end
			if dummy1.HealthVal.Value <=0 then
				winnerbrain = brain2
				print("brain"..(i+1).."won")
				skip = true
			elseif dummy2.HealthVal.Value <=0 then
				winnerbrain = brain1
				print("brain"..(i).."won")
				skip = true
			end
		end
		local dt = tick()-time_Start
		winnerbrain:IncreaseFitness(1/dt)
	end

	population:Evolve()
    print("Generation " .. generation .. " : Total fitness " .. population:GetTotalFitness() .. " : Best Fitness " .. population:GetBest().fitness)
    population:resetFitness()
    wait()
end
