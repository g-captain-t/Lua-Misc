local module=require(game.ReplicatedStorage.KNNLibrary)
--2 inputs, 2 hidden layers, 2 nodes per hidden layer, 1 output node, and with ReLU as the activation function
local nets = module.createGenNet(script.Parent.Networks,20,6,2,3,4,"Sigmoid") 	

--local vis = module.getVisual(nets[1]) vis.Parent = game.StarterGui

for g=1, 1000000 do 			
	print("Generation: "..g)	
	local scores = {}			--Array storing the scores for every network
	local step = 8		--step value used for lowering the resolution of the scoring. Lower step means higher resolution but far slower
	local tim=tick()			
	for z=1,#nets, 2 do	
		
		local brain1 = nets[z]
		local brain2 = nets[z+1]
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
			outputs1 = module.forwardNet(brain1,inputs1) 
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
			outputs2 = module.forwardNet(brain2,inputs2) 
			dummy2.HumanoidRootPart.CFrame = dummy2.HumanoidRootPart.CFrame * CFrame.Angles(0,outputs2[4]-0.5/5,0)
			dummy2.Humanoid:MoveTo(Vector3.new(
				dummy2.Torso.Position.X + outputs2[1]-0.5, 
				dummy2.Torso.Position.Y,
				dummy2.Torso.Position.Z + outputs2[2]-0.5
				))
			if outputs2[3] > 0 then dummy2.Sword:Activate() end
			if dummy1.HealthVal.Value <=0 then
				winnerbrain = brain2
				print("brain"..(z).."won")
				local dt = tick()-time_Start
				scores[z] = 1/dt
				scores[z+1] = 1/dt/2
				skip = true
			elseif dummy2.HealthVal.Value <=0 then
				winnerbrain = brain1
				print("brain"..(z+1).."won")
				local dt = tick()-time_Start
				scores[z+1] = 1/dt
				scores[z] = 1/dt/2
				skip = true
			end
		end
							-- Insert wins as scores
	end
	local best = module.runGenNet(nets,scores) 			-- With all of the networks scored, we run the next generation
	--module.updateVisualState(nets[best],vis)			-- Visualize the best


	table.sort(scores)									--Purely for demo purposes, I sort the scores to find the best one
	print("Best network success rate: "..scores[#scores]/(800/step)^2*(100).."%")
end
