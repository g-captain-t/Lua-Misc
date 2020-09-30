--Roblox took down Align Tool. This is the script I use to align two parts. Select two parts, modify Axis and paste in console.
local Axis = "X"

local Selection = game:GetService("Selection")
local ChangeHistoryService = game:GetService("ChangeHistoryService")
local currentSelections = Selection:Get()

local sOne = currentSelections[1]
local sTwo = currentSelections[2]


-- Functions
-- Generates a temporary primary part in the very center
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




-- Actual thing. One: moving object, Two: target object
local sOneCFrame = classifyCFrame(sOne)
local sTwoCFrame = classifyCFrame(sTwo)

	-- Generating new CFrame, updating current with the new axis value
local x, y, z, m11, m12, m13, m21, m22, m23, m31, m32, m33 = sOneCFrame:components()
print("SONE",x, y, z, m11, m12, m13, m21, m22, m23, m31, m32, m33)
if Axis == "Y" then y = sTwoCFrame[Axis]
elseif Axis == "X" then x = sTwoCFrame[Axis]
elseif Axis == "Z" then z = sTwoCFrame[Axis] end
local newCFrame = CFrame.new(x, y, z, m11, m12, m13, m21, m22, m23, m31, m32, m33)

moveModelCFrame(sOne,newCFrame)

local logMessage = "[Align] "..sOne.Name.." moved to "..sTwo.Name.." Axis "..Axis
ChangeHistoryService:SetWaypoint(logMessage) print(logMessage)
