local Axis = "X"

local Selection = game:GetService("Selection")
local ChangeHistoryService = game:GetService("ChangeHistoryService")
local currentSelections = Selection:Get()

local sTwo = currentSelections[#currentSelections]
local movingSelections = {}
for i=1, #currentSelections do
	if i < #currentSelections then print(currentSelections[i].Name)
	movingSelections[#movingSelections+1] = currentSelections[i] end
end


-- Functions

function getModelCFrame(model)
	local tempPrimaryPart = Instance.new("Part", workspace)
	tempPrimaryPart.CFrame = model:GetBoundingBox()
	local modelCFrame = tempPrimaryPart.CFrame
	tempPrimaryPart:Destroy()
	return modelCFrame
end

function moveModelCFrame(model,CF) -- Creates primary part 
	local primaryPart = nil; local tempPrimaryPart
	if model.PrimaryPart then  primaryPart = model.PrimaryPart end
	
	local tempPrimaryPart = Instance.new("Part", workspace)
	tempPrimaryPart.CFrame = model:GetBoundingBox()
	local modelCFrame = tempPrimaryPart.CFrame
	tempPrimaryPart.Parent = model
	model.PrimaryPart = tempPrimaryPart 
	model:SetPrimaryPartCFrame(CF)
	
	if primaryPart then model.PrimaryPart = primaryPart end
	tempPrimaryPart:Destroy()
end


function classifyCFrame(instance)
	if instance:IsA("Model") then return getModelCFrame(instance)
	elseif instance:IsA("BasePart") then return instance.CFrame end
end

function classifyMove (instance, CF)
	if instance:IsA("Model") then moveModelCFrame(instance,CF)
	elseif instance:IsA("BasePart") then instance.CFrame = CF end
end


-- Actual thing. One: moving object, Two: target object
local sTwoCFrame = classifyCFrame(sTwo)
for i, sOne in pairs(movingSelections) do
	local sOneCFrame = classifyCFrame(sOne)

	local x, y, z, m11, m12, m13, m21, m22, m23, m31, m32, m33 = sOneCFrame:components()
	if Axis == "Y" then y = sTwoCFrame[Axis]
	elseif Axis == "X" then x = sTwoCFrame[Axis]
	elseif Axis == "Z" then z = sTwoCFrame[Axis] end
	local newCFrame = CFrame.new(x, y, z, m11, m12, m13, m21, m22, m23, m31, m32, m33)

	classifyMove(sOne,newCFrame)

	local logMessage = "[Align] "..sOne.Name.." moved to "..sTwo.Name.." Axis "..Axis
	print(logMessage)
	
end
ChangeHistoryService:SetWaypoint("Align Objects") 
