repeat wait() until game.Loaded

--[[
Import table
for each group, find all of the models in workspace that matches the name
for each hangar in group: find the hangar character. 
      --- If hangar has an i and i is a string, find the hangar character with the string i name.
set the shirt and pants for the hangar character.
]]

local HTTP = game:GetService("HttpService")
local InsertService = game:GetService("InsertService")
local Settings = require(script.Parent.ImportClothing_Settings)
local ClothingTable = 
	Settings.UseHTTP and HTTP:JSONDecode(HTTP:GetAsync(Settings.URL)) or
	Settings.UseModule and require(Settings.Module) or
	{}

print("Importing assets...")

local function FindGroup(Name)
	for i,v in pairs (workspace:GetDescendants()) do
		if v.Name == Name and v:IsA("Model") then return v end
	end
end

for ClothingGroup, Hangars in pairs (ClothingTable) do
	local GroupModel = FindGroup(ClothingGroup)
	if not GroupModel then warn(ClothingGroup,"not found.") continue end

	local hangarModels = GroupModel:GetChildren()

	for i, hangarData in pairs (Hangars) do
		local currentModel = typeof(i)=="number" and hangarModels[i] or typeof(i)== "string" and GroupModel:FindFirstChild(i)
		if not currentModel then warn("Hangar not found.") continue end
		if not currentModel:FindFirstChildOfClass("Humanoid") then continue end

		for class, catalogLink in pairs (hangarData) do
			local catalogID = tonumber(string.match(catalogLink, "%d+"))
			local s, inserted = pcall(function() return InsertService:LoadAsset(catalogID):FindFirstChildWhichIsA("Clothing") end)
			if s and inserted then 
				inserted.Name = tostring(catalogID)
				inserted.Parent = currentModel
				print("Inserted", inserted) 
			else
				warn(inserted)
			end
		end

		print("Loaded", i)
	end

	print("Loaded", ClothingGroup)
end

print("Imported assets.")
