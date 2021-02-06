-- GENETIC ALGORITHM
-- Meant to be in the same file as NNL, but separated so I can review everything individually

NNL.genalg = {}
local genalg = NNL.genalg
--[[ 
	From Jobro13's Neuro (https://github.com/jobro13/Neuro/blob/master/Neuro/src/genetics.lua)
	For glossary: 
	Weight -> Gene
	Node -> Chromosome
]]
genalg.Settings = {
	CrossoverChance = 0.7;
	MutateChance = 0.3;
	MaxMutateChange = 0.2;
	BestNetworksCount = 4;
}

function genalg.Crossover(node1, node2)
	if not random01() <= genalg.Settings.CrossoverChance then
		return node1, node2
	end
	local newnode = blanknode()
	local nweights = #node1.w
	local crossoverpoint = math.random(2, nweights-1)	-- At what point do the weights switch
	for i=1, nweights do
		if i < crossoverpoint then -- Use node1's weights
			newnode.w[i] = node1.w[i]
		else -- Use node2's weights
			newnode.w[i] = node2.w[i]
		end
	end
	return newnode
end

function genalg.Mutate(node)
	local newnode = blanknode()
	for i, weight in ipairs (node.w) do
		if random01() <= genalg.Settings.MutateChance then
			newnode.w[i] = genalg.Settings.MaxMutateChange * random01()
		else
			newnode.w[i] = weight
		end
	end
	return newnode
end

function genalg.Meiosis(node1, node2)
	-- Crossover, then mutate
	local newnode1, newnode2 = genalg.Crossover(node1, node2), genalg.Crossover(node1, node2)
	newnode1, newnode2 = genalg.Mutate(newnode1), genalg.Mutate(newnode2)
	return newnode1, newnode2
end

function genalg.Breed(network1, network2)
	for i, layer1 in ipairs (network1.layers) do
		local layer2 = network2.layers[i]
		for i2, node1 in ipairs(layer1) do
			local node2 = layer2[i2]
			local newnode1, newnode2 = genalg.Meiosis(node1, node2)
			layer1[i2] = newnode1;
			layer2[i2] = newnode2
		end
	end
end

genalg.population = {}
local population = genalg.population

function population.new(networks, networksettings)
	local self = {
		Networks = {};
		Size = 0;
	}
	local Type = type(networks)
	if Type=="number" then
		local t = {}
		for i=1, networks do 
			table.insert(t, NNL.nn.new(networksettings))
		end
		networks = t
		self.Size = #networks
	end
	for _, network in pairs (networks) do 
		network.Fitness = network.Fitness or 0;	-- Add a new network property for fitness
	end

end

function population:Insert(network)
	table.insert(self.Networks, network)
end

function population:GetTotalFitness()
	local total = 0
	for i, network in ipairs (self.Networks) do
		total = total + network.Fitness
	end
	return total
end

function population:GetBestNetworks(n)
	n = n or genalg.Settings.BestNetworkCount
	table.sort(self.Networks, function(a,b)
		return a.Fitness >= b.Fitness
	end)
	local best = {}
	for i=1, n do 
		best[i] = self.Networks[i]
	end
	return best
end

function population:Evolve(bestnetworks)
	local newbrains = {}
	table.sort(self.Networks, function(a,b)
		return a.Fitness >= b.Fitness
	end)
	table.insert(newbrains, tdeepcopy(self.Networks[1]))
	for i=1, #self.Networks-1, 2 do
		local network1, network2 = bestnetworks[i], bestnetworks[i+2]
		if not network2 then 
			table.insert(newbrains, network1)
			break
		end
		genalg.Breed(network1, network2)
		table.insert(newbrains, network1)
		table.insert(newbrains, network2)
	end
	self.Networks = newbrains
end

--[[ Test this

]]
