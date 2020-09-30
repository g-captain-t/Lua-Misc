--Roblox took down Align Tool. This is the script I use to align two parts. Select two parts, modify Axis and paste in console.

local Axis = "Y"

local Selection = game:GetService("Selection")
local ChangeHistoryService = game:GetService("ChangeHistoryService")
local currentSelections = Selection:Get()

local sOne = currentSelections[1]
local sTwo = currentSelections[2]

-- Functions
function GetBoundingBox(model, orientation)
	if typeof(model) == "Instance" then
		model = model:GetDescendants()
	end
	if not orientation then
		orientation = CFrame.new()
	end
	local abs = math.abs
	local inf = math.huge
	
	local minx, miny, minz = inf, inf, inf
	local maxx, maxy, maxz = -inf, -inf, -inf
	
	for _, obj in pairs(model) do
		if obj:IsA("BasePart") then
			local cf = obj.CFrame
			cf = orientation:toObjectSpace(cf)
			local size = obj.Size
			local sx, sy, sz = size.X, size.Y, size.Z
			
			local x, y, z, R00, R01, R02, R10, R11, R12, R20, R21, R22 = cf:components()
			
			local wsx = 0.5 * (abs(R00) * sx + abs(R01) * sy + abs(R02) * sz)
			local wsy = 0.5 * (abs(R10) * sx + abs(R11) * sy + abs(R12) * sz)
			local wsz = 0.5 * (abs(R20) * sx + abs(R21) * sy + abs(R22) * sz)
			
			if minx > x - wsx then
				minx = x - wsx
			end
			if miny > y - wsy then
				miny = y - wsy
			end
			if minz > z - wsz then
				minz = z - wsz
			end
			
			if maxx < x + wsx then
				maxx = x + wsx
			end
			if maxy < y + wsy then
				maxy = y + wsy
			end
			if maxz < z + wsz then
				maxz = z + wsz
			end
		end
	end
	
	local omin, omax = Vector3.new(minx, miny, minz), Vector3.new(maxx, maxy, maxz)
	local omiddle = (omax+omin)/2
	local wCf = orientation - orientation.p + orientation:pointToWorldSpace(omiddle)
	local size = (omax-omin)
	return wCf, size
end -- From Devforum post by XAXA. https://devforum.roblox.com/t/216581/8
function classifyCFrame(instance)
	if instance:IsA("Model") then return instance:GetModelCFrame() 
	elseif instance:IsA("BasePart") then local CF, size = GetBoundingBox (instance)return CF end
end

-- Actual thing
local sOneCFrame = classifyCFrame(sOne)
local sTwoCFrame = classifyCFrame(sTwo)
local posX, posY, posZ

if Axis == "Y" then posX, posY, posZ = sOneCFrame.X, sTwoCFrame[Axis], sOneCFrame.Z 
elseif Axis == "X" then posX, posY, posZ = sTwoCFrame[Axis], sOneCFrame.Y, sOneCFrame.Z 
elseif Axis == "Z" then posX, posY, posZ = sOneCFrame.X, sOneCFrame.Y, sTwoCFrame[Axis] end

sOne:MoveTo(Vector3.new(posX, posY, posZ))

print(sTwoCFrame[Axis], sOneCFrame[Axis])

local logMessage = "[Align] "..sOne.Name.." moved to "..sTwo.Name.." Axis "..Axis
ChangeHistoryService:SetWaypoint(logMessage) print(logMessage)
