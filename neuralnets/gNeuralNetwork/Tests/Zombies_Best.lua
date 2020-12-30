--// This is one of the best zombie neural networks generated from my tests, who found its way to the end.

local brain = '{"evaluate":null,"Layers":[[{"Weights":[7,10,18,-5],"Bias":4},{"Weights":[1,4,11,12],"Bias":5},{"Weights":[-7,-3,6,-14],"Bias":6},{"Weights":[12,10,9,18],"Bias":-8},{"Weights":[-11,-1,14,-14],"Bias":10}],[{"Weights":[20,-10,14,1,8],"Bias":-8},{"Weights":[18,20,-15,20,3],"Bias":6},{"Weights":[13,5,-8,-9,-14],"Bias":3},{"Weights":[-19,9,6,15,13],"Bias":-8},{"Weights":[2,0,8,16,0],"Bias":4}],[{"Weights":[8,-5,-7,17,-12],"Bias":-2}]],"HiddenLayers":2,"newneuron":null,"OutputNeurons":1,"LayerNeurons":5,"MaxBias":10,"feedforward":null,"InputNeurons":4,"Fitness":66.07239532470703125}'
local HTTPS = game:GetService("HttpService")
return HTTPS:JSONDecode(brain)
