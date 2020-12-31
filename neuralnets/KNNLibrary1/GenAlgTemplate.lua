local module=require(workspace.KNNLibrary)

--2 inputs, 2 hidden layers, 2 nodes per hidden layer, 1 output node, and with ReLU as the activation function
local nets = module.createGenNet(workspace.Networks,20,2,2,3,1,"LeakyReLU") 	

--local vis = module.getVisual(nets[1]) vis.Parent = game.StarterGui

for g=1, 1000000 do 			
	print("Generation: "..g)	
	local scores = {}			--Array storing the scores for every network
	local step = 8		--step value used for lowering the resolution of the scoring. Lower step means higher resolution but far slower
	local tim=tick()			
	for z=1,#nets do	
		local network = module.loadNet(nets[z])			-- Load the network's stringvalue
		local wins=0
		local answer=module.forwardNet(network,{--[[input here]]})[1] 
		
		table.insert(scores,wins)						-- Insert wins as scores
	end
	local best = module.runGenNet(nets,scores) 			-- With all of the networks scored, we run the next generation
	--module.updateVisualState(nets[best],vis)			-- Visualize the best


	table.sort(scores)									--Purely for demo purposes, I sort the scores to find the best one
	print("Best network success rate: "..scores[#scores]/(800/step)^2*(100).."%")
end
