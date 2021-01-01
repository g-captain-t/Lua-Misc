--// Planes, but transferred to this library so I can export the networks.

local module=require(script.Parent.KNNLibrary)

--2 inputs, 2 hidden layers, 2 nodes per hidden layer, 1 output node, and with ReLU as the activation function
local nets = module.createGenNet(script.Parent.Networks,25,5,2,3,3,"Sigmoid") 	

--local vis = module.getVisual(nets[1]) vis.Parent = game.StarterGui

hint = Instance.new("Hint", script.Parent)
local PlaneTemplate = script.Parent.Plane
local startpos = CFrame.new(573.5, 54.75, 173)

for g=1, math.huge do 			
	print("Generation: "..g)	
	local scores = {}			--Array storing the scores for every network
	local step = 8		--step value used for lowering the resolution of the scoring. Lower step means higher resolution but far slower
	local tim=tick()	
	local skips = 0
	
	for z=1,#nets do	
		local brain = module.loadNet(nets[z])			-- Load the network's stringvalue
		local wins=0
		
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
					(script.Parent.Goal.Position-main.Position).magnitude,
				}
				local outputs = module.forwardNet(brain,inputs)
				main.BVelocity.Velocity = 100* main.CFrame.LookVector
				main.BGyro.CFrame = main.CFrame*CFrame.Angles(math.rad((outputs[1]-0.5)*80),0,math.rad((outputs[3]-0.5)*80))

				wins = 1/(script.Parent.Goal.Position-main.Position).magnitude*100
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
				scores[z] = wins
				con:Disconnect()
			end
		end
		con= main.Touched:Connect(ontouch)					-- Insert wins as scores
	end
	
	
	repeat game:GetService("RunService").Heartbeat:Wait() until skips == #nets
	local best = module.runGenNet(nets,scores) 			-- With all of the networks scored, we run the next generation
	--module.updateVisualState(nets[best],vis)			-- Visualize the best


	table.sort(scores)									--Purely for demo purposes, I sort the scores to find the best one
	print("Best network success rate: "..scores[#scores]/(800/step)^2*(100).."%")
end
