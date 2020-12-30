--[[
Swordfighters Neural Network Experiment
> The fighters only travelled on the positive axis. Not sure why, but this is the code I played with.
]]

local neuro = require(script.Parent.Neuro)
hint = Instance.new("Hint", script.Parent)
population = neuro.new("population")

for i = 1 , 2 do
	population:AddBrain(neuro.new("network",2,6,2,8))
end

local input_Record = {}
local output_Record = {}




for generation = 1, math.huge do
	
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
				--dummy1.Torso.Position.X,
				--dummy1.Torso.Position.Z,
				--dummy1.HealthVal.Value,
				dummy2.Torso.Position.X,
				dummy2.Torso.Position.Z,
				--dummy2.HealthVal.Value
			}
			outputs1 = brain1:evaluate(inputs1)
			dummy1.HumanoidRootPart.CFrame = dummy1.HumanoidRootPart.CFrame * CFrame.Angles(0,outputs1[4]/5,0)
			dummy1.Humanoid:MoveTo(dummy1.Torso.Position + dummy1.Torso.CFrame.LookVector*5*outputs1[5]
				--[[Vector3.new(
				outputs1[1]*(outputs1[5]>0.5 and -1 or 1), 
				dummy2.Torso.Position.Y,
				outputs1[2]*(outputs1[6]>0.5 and -1 or 1)
				)]])
			if outputs1[3] > 0.2 then dummy1.Sword:Activate() end
			
			local inputs2 = {
				--dummy2.Torso.Position.X,
				--dummy2.Torso.Position.Z,
				--dummy2.HealthVal.Value,
				dummy1.Torso.Position.X,
				dummy1.Torso.Position.Z,
				--dummy1.HealthVal.Value
			}
			outputs2 = brain2:evaluate(inputs2)
			dummy2.HumanoidRootPart.CFrame = dummy2.HumanoidRootPart.CFrame * CFrame.Angles(0,outputs2[4]/5,0)
			dummy2.Humanoid:MoveTo(dummy2.Torso.Position + dummy2.Torso.CFrame.LookVector*5*outputs2[5]
			--[[Vector3.new(
				outputs2[1]*(outputs2[5]>0.2 and -1 or 1), 
				dummy2.Torso.Position.Y,
				outputs2[2]*(outputs2[6]>0.2 and -1 or 1)
				))]]
				)
			if outputs2[3] > 0.2 then dummy2.Sword:Activate() end
			if dummy1.HealthVal.Value <=0 then
				winnerbrain = brain2
				skip = true
			elseif dummy2.HealthVal.Value <=0 then
				winnerbrain = brain1
				skip = true
			end
		end
		local dt = tick()-time_Start
		winnerbrain:IncreaseFitness(dt)
	end

	population:Evolve()
    print("Generation " .. generation .. " : Total fitness " .. population:GetTotalFitness() .. " : Best Fitness " .. population:GetBest().fitness)
    population:resetFitness()
    wait()
end
