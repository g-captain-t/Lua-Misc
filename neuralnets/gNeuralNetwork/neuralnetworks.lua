local NEURALNETWORK = {}

local function sigmoid(x)
	return  1 / (1 + math.exp(-x))
end
local function sumarray(array)
	local sum = 0
	for _, v in pairs (array) do sum=sum+v end
	return sum
end
local function printarray(array)
	for i,v in pairs (array) do print (i,v) end
end

function NEURALNETWORK.new(InputNeurons, HiddenLayers, LayerNeurons, OutputNeurons)
	local nn = {
		InputNeurons = InputNeurons or 4,
		HiddenLayers = HiddenLayers or 2,
		LayerNeurons = LayerNeurons or 5,
		OutputNeurons = OutputNeurons or 1,

		MaxBias = 10;
		Layers = {--[[ {{Weights={},Bias=0},{Weights={},Bias=0}}, {{Weights={},Bias=0},{Weights={},Bias=0}} ]]}
	}

	function nn.newneuron(inputamount)
		local neuron = {Weights={}, Bias=0}
		for i=1, inputamount do
			neuron.Weights[i] = math.random(-20,20)
		end
		neuron.Bias = math.random(-nn.MaxBias,nn.MaxBias)
		return neuron
	end

	--// Generate the synapses
	for i=1, nn.HiddenLayers do
		local newsynapse = {}
		local inputneurons = i==1 and nn.InputNeurons or nn.LayerNeurons
		--// Add neurons
		for i2=1, nn.LayerNeurons do
			newsynapse[i2] = nn.newneuron(inputneurons)
		end
		--// finish the hidden layer
		table.insert(nn.Layers, newsynapse)
	end

	local outputsynapse = {}
	for i=1, nn.OutputNeurons do
		outputsynapse[i] = nn.newneuron(nn.LayerNeurons)
	end
	table.insert(nn.Layers, outputsynapse)


	--// Synapse an input array with a layer
	function nn.feedforward(input, layer)
		local output = {}
		for i, neuron in pairs (layer) do
			local results = {}

			--// input weights * respective neuron's weight
			for i=1,nn.InputNeurons do 
				table.insert(results, input[i]*neuron.Weights[i])
			end
			local sum = sumarray(results)

			--// Add bias
			sum=sum+neuron.Bias
			table.insert(output, sigmoid(sum))
		end
		return output
	end


	function nn.evaluate(activationLayer)
		local nextinput = activationLayer
		--// go through the layers
		for i=1, nn.HiddenLayers+1 do
			nextinput = nn.feedforward(nextinput,nn.Layers[i])
			--printarray(nextinput)
		end
		return nextinput
	end

	return nn
end

return NEURALNETWORK
