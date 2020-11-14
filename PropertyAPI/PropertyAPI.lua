-- A hastily made property API so I can transfer properties between instances real quick

local HttpService = game:GetService("HttpService")
local Data = HttpService:JSONDecode(require(script.latest_json)) 
local Properties = {}

function Properties:Get(instanceName)
	local ClassProperties do
		ClassProperties = {} 

		for i = 1, #Data do
			local Table = Data[i]
			local Type = Table.type

			if Type == "Class" then
				local ClassData = {}
				local Superclass = ClassProperties[Table.Superclass]
				if Superclass then
					for j = 1, #Superclass do ClassData[j] = Superclass[j]
					end
				end
				ClassProperties[Table.Name] = ClassData

			elseif Type == "Property" then
				if not next(Table.tags) then
					local Class = ClassProperties[Table.Class]
					local Property = Table.Name
					local Inserted
					for j = 1, #Class do
						if Property < Class[j] then -- Determine whether `Property` precedes `Class[j]` alphabetically
							Inserted = true
							table.insert(Class, j, Property)
							break
						end
					end
					if not Inserted then table.insert(Class, Property)
					end
				end
			end
		end
	end
	return ClassProperties[instanceName]
end




function Properties:Transfer(instance1, instance2, propertiesTable)
	for i=1, #propertiesTable do
		local property = propertiesTable[i]
		pcall (function() instance2[property] = instance1[property] 
		end)
	end
end

local function isInTable (Table, Value)
	for i,v in pairs (Table) do if v == Value then return true end end
	return false
end

function Properties:TransferAll(instance1, instance2, ignoredPropertiesTable)
	local I1Properties = Properties:Get(instance1.ClassName)
	for i=1, #I1Properties do
		local property = I1Properties[i]
		pcall (function() 
			if isInTable(ignoredPropertiesTable, property) then return end
			instance2[property] = instance1[property] 
		end)
	end
end


return Properties

-- REFERENCES

-- https://anaminus.github.io/rbx/json/api/latest.json
-- https://scriptinghelpers.org/questions/50784/



-- table Properties:Get("ClassName") 
-- Returns the table of a class's properties
-- Properties:Get("Part")

-- void Properties:Transfer(instance1, instance2, propertiesTable)
-- Sets instance2's properties in propertiesTable to instance1
-- Properties:Transfer(Part, PartTwo, {"Position", "Size", "Color"})

-- void Properties:TransferAll(instance1, instance2, ignoredPropertiesTable)
-- Sets instance2's properties to instance1, except for properties in ignoredPropertiesTable
-- Properties:TransferAll(Part, PartTwo, {"Name", "CFrame", "Position", "Orientation"})


--[[ Test in command line:

local Properties = require(workspace.PropertyAPI) 
Properties:TransferAll(workspace.Part, workspace.Part2, {"Name", "CFrame", "Position", "Orientation"})

]]
