local NEURO = require(script.Parent.neuralnetworks)
local gALGO = require(script.Parent.geneticalgorithm)

local Zombie = script.Parent.Workspace .Zombie
local startCFrame = CFrame.new(-200.465, 3.112, -96.773)

local function sig(x)
	return  1 / (1 + math.exp(-x))
end

local function ExportNN(NN, number)
	local HTTPS = game:GetService("HttpService")
	local src = Instance.new("TextLabel", game.StarterGui)
	src.Name = "Best NN of Gen "..tostring(number)
	src.Text = HTTPS:JSONEncode(NN)
end

local pastGeneration
for generation=1, math.huge do
	local currentGeneration = generation==1 and gALGO.newgeneration(25) or gALGO.newgeneration(0)
	
	if pastGeneration then
		local sortednns = pastGeneration:sortnns()
		ExportNN(sortednns[1], generation-1)
		
		--// Breed the top 5 with the first
		for multiple=1,8 do
			for i=1, 2 do
				local newnn = gALGO.meiosis(sortednns[1],sortednns[i])
				currentGeneration:insert(newnn)
			end
		end
		--// Add the best from last generation
		currentGeneration:insert(sortednns[1])
	end
	
	for i, NN in pairs (currentGeneration.NNs) do
		print("Zombie number",i)
		local skip = false
		Zombie.Humanoid.WalkSpeed = 25
		Zombie.Torso.CFrame = startCFrame
		Zombie.Torso.Touched:Connect(function()
			skip = true
		end)
		local lasttime = os.time()
		while not skip do 
			game:GetService("RunService").Heartbeat:Wait()
			local Rayparams = RaycastParams.new()
			Rayparams.FilterDescendantsInstances = {Zombie}
			Rayparams.FilterType = Enum.RaycastFilterType.Blacklist
			
			local rayfn = workspace:Raycast(Zombie.Head.Position, Zombie.Head.CFrame.LookVector*200,Rayparams)
			local rayr = workspace:Raycast(Zombie.Head.Position, Zombie.Head.CFrame:vectorToWorldSpace(Vector3.new(1,0,-1)).unit*200,Rayparams)
			local rayl = workspace:Raycast(Zombie.Head.Position, Zombie.Head.CFrame:vectorToWorldSpace(Vector3.new(-1,0,-1)).unit*200,Rayparams)
			local rayrr = workspace:Raycast(Zombie.Head.Position, Zombie.Head.CFrame:vectorToWorldSpace(Vector3.new(1,0,0)).unit*200,Rayparams)
			local rayll = workspace:Raycast(Zombie.Head.Position, Zombie.Head.CFrame:vectorToWorldSpace(Vector3.new(-1,0,0)).unit*200,Rayparams)
			
			local distfn = (rayfn.Position - Zombie.Head.Position).magnitude
			local distr = (rayr.Position - Zombie.Head.Position).magnitude
			local distl = (rayl.Position - Zombie.Head.Position).magnitude
			local distrr = (rayrr.Position - Zombie.Head.Position).magnitude
			local distll = (rayll.Position - Zombie.Head.Position).magnitude
			
			local output = NN.evaluate({distfn,distr,distrr,distl,distll})
			Zombie.Torso.CFrame = Zombie.Torso.CFrame * CFrame.Angles(0,output[1]/5 ,0)
			--print(output[1]/5)
			Zombie.Humanoid:MoveTo(Zombie.Torso.Position + Zombie.Head.CFrame.LookVector*10)
			skip = os.time()-lasttime >= 10 or skip
		end
		NN.Fitness = (startCFrame.Position-Zombie.Torso.Position).magnitude
		print(NN.Fitness)
	end
	
	print("Generation end")
	
	pastGeneration = currentGeneration
end
