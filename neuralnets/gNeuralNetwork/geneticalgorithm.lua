--// Genetic Algorithm
--// Note: this is experimental.
local NN = require(script.Parent.neuralnetworks)
local ga = {}
--[[

	1. Randomly generate a population of possible brains
	2a. Calculate the fitness of the brain
	2b. Select the best brains
	3. Crossover - select random neurons in the brain and transplant it to a new child brain
	4. Each child neuron has a chance to mutate
	5. Repeat

]]

--[[
	crossover the neurons in each layer
	NN.Layers = {
		{{Weights={},Bias=0},{Weights={},Bias=0}}, 
		{{Weights={},Bias=0},{Weights={},Bias=0}},
	}
	Layers > Layer > Neuron > Weights & Biases
]]


function ga.meiosis (nn1, nn2)
	--// Child is NN1 but inherit some neurons from NN2
	local childnn = nn1
	
	--// Crossover the neurons by orders (either 1 or 2)
	local childlayers = {}
	for i, layer in pairs (childnn.Layers) do
		local newlayer = {}
		for i2, neuron in pairs (layer) do 
			local which = math.random(1,2)
			if which==1 then
				--// Get from  NN1
				local nn1neuron = nn1.Layers[i][i2]
				table.insert(newlayer,nn1neuron)
			elseif which==2 then
				--// Get from NN2
				local nn2neuron = nn2.Layers[i][i2]
				table.insert(newlayer,nn2neuron)
			end
		end
		table.insert(childlayers, newlayer)
	end
	childnn.Layers = childlayers
	
	--// Mutate all the neuron weights
	for i, layer in pairs(childnn.Layers) do
		for i2, neuron in pairs (layer) do
			for i3, weight in pairs (neuron.Weights) do
				if math.random(1,100) < 35 then  --// 5 in 100 chance
					print("mutate!")
					weight = math.random(-50,50)
				end
			end
		end
	end
	
	return childnn
end

function ga.newgeneration(Size)
	local generation = {
		Size = Size or 0;
		
		NNs = {},
		BestNN = nil,
		BestFitness = 0,
		TotalFitness = 0,
	}
	
	--// Generate the brains
	for i=1, generation.Size do
		local nn = NN.new()
		nn.Fitness = 0
		table.insert(generation.NNs,nn)
	end
	
	--// Insert a custom brain
	function generation:insert(nn)
		generation.Size = generation.Size+1
		table.insert(generation.NNs, nn)
	end
	
	--// Sort from best to worst
	function generation:sortnns(f)
		table.sort(generation.NNs,f or function(a,b) return a.Fitness>b.Fitness  end)
		return generation.NNs
	end
	
	return generation
end

return ga
