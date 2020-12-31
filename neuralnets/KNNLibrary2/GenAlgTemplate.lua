local Package = game:GetService("ReplicatedStorage").NNLibrary
local Base = require(Package.BaseRedirect)
local FeedforwardNetwork = require(Package.NeuralNetwork.FeedforwardNetwork)
local ParamEvo = require(Package.GeneticAlgorithm.ParamEvo)
local Momentum = require(Package.Optimizer.Momentum)


--// Set the settings for generations
local generations = 30
local population = 20

local setting = {
	HiddenActivationName = "LeakyReLU";
	OutputActivationName = "Sigmoid";
}

local geneticSetting = {
	ScoreFunction = function(net)
		local score = 0

		local output = net({--[[input array here]]})

		return score
	end;
	
	PostFunction = function(geneticAlgo)
		local info = geneticAlgo:GetInfo()
		print("Generation "..info.Generation..", Best Score: "..info.BestScore/(100)^2*(100).."%")
	end;
}

--// Run the generations and get the best
local tempNet = FeedforwardNetwork.new({"x","y"},2,3,{"out"},setting)
local geneticAlgo = ParamEvo.new(tempNet,population,geneticSetting)
geneticAlgo:ProcessGenerations(generations)
local net = geneticAlgo:GetBestNetwork()



--// Test the best network
--[[local totalRuns
local wins = 0

local coords = {}
local output = net(coords)
local correctAnswer -- = isAboveFunction(coords.x,coords.y)
if math.abs(output.out - correctAnswer) <= 0.3 then
	wins += 1
end

print(wins/totalRuns*(100).."% correct!")
]]
