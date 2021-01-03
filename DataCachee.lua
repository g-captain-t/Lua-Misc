--// Cache "datastore"
--// 
--[[ Structure:
    Kills= 0,
    BattlesFought = 0,
    Awards = { 
        ["MVP"] = 1
    },
    Fighters={
        "StandardJet","F-16"
    },
]]

local SaveToDataStore = true

local DS = game:GetService("DataStoreService")
local RS = game:GetService("RunService")
local Players = game:GetService("Players")

local DSS = {}
local Cache = {}

local function getTableLength(Table)
	local count = 0
	for _, _ in pairs (Table) do  count=count+1 end
	return count
end

function DSS.Get(key, storename, defaultdata)
	--// Retrieve data from the cache or the datastore

	if not Cache[storename] then Cache[storename]={} end
	local pData = Cache[storename][key]
	if not pData then 
		--// Get from the datastore
		local Store = DS:GetDataStore(storename)
		local s, storedData = pcall(function() return Store:GetAsync(key) end)
		pData = storedData
		Cache[storename][key] = storedData
	end
	if (not pData) and defaultdata then
		--// Set the data to default
		Cache[storename][key] = defaultdata
		pData = defaultdata
	end
	--// Save any new indexes
	if defaultdata and pData then
		for i,v in pairs (defaultdata) do
			if pData[i]==nil then pData[i] = v end
		end
	end
	return pData
end

function DSS.Save(key,storename,data)
	--// Save to cache
	if not Cache[storename] then Cache[storename]={} end
	Cache[storename][key] = data
	return data
end

function DSS.SaveStore(key, storename, data)
	--// Save a given data or the cached data to datastore
	local Store = DS:GetDataStore(storename)
	data = data or DSS.Get(key, storename)
	local s,v = pcall(function() return Store:SetAsync(key, data) end)
	return s,v
end

function DSS.SaveAllToStore(storename)
	--// Save a store in the cache to datastore
	local Errors = {}
	local Store = DS:GetDataStore(storename)
	for key, data in pairs(Cache[storename]) do
		RS.Heartbeat:Wait()
		local s,v = pcall (function() return Store:SetAsync(key,data)  end)
		if not s then warn(v) table.insert(Errors,v) end
	end
	for _,err in pairs (Errors) do print(err) end
	return Errors
end

function DSS.SaveCacheToStore()
	--// Save all caches to store
	for Store, Storage in pairs (Cache) do
		DSS.SaveAllToStore(Store)
	end
end

game:BindToClose(function()
	print("Savingggg")
	local isDataSaved = false
	--// Save all player data
	for _, player in pairs(Players:GetPlayers()) do
		player:Kick()
	end
	--// Save the cache's stores 
	
	DSS.SaveCacheToStore()
	isDataSaved = true
	
	repeat RS.Heartbeat:Wait() until isDataSaved
	print("SAVED!!")
end)

return DSS
