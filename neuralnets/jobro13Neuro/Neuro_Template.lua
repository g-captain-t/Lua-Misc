local neuro = require(script.Parent.Neuro)
hint = Instance.new("Hint", script.Parent)
population = neuro.new("population")

for i = 1 , 40 do
	population:AddBrain(neuro.new("network",5,1,1,5))
end

local input_Record = {}
local output_Record = {}




for generation = 1, math.huge do
	
	for numBrain, brain in pairs(population.Brains) do
		local time_Start = tick()
		local skip = false
		--hint.Text = "Generation: "..generation.." Zombie: " .. numBrain

		while not skip do game:GetService("RunService").Heartbeat:Wait()
			
			local inputs = {}
			outputs = brain:evaluate(inputs)

		end
		brain:IncreaseFitness(--[[ fitness score here ]])
	end

	population:Evolve()
    print("Generation " .. generation .. " : Total fitness " .. population:GetTotalFitness() .. " : Best Fitness " .. population:GetBest().fitness)
    population:resetFitness()
    wait()
end
