--// Cache "datastore"
--// A cached datastore system

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
		print(Store)
		local s, storedData = pcall(function() return Store:GetAsync(key) end)
		pData = storedData
		print(storedData)
	end
	if (not pData) and defaultdata then
		--// Set the data to default
		Cache[storename][key] = defaultdata
		pData = defaultdata
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
		local s,v = pcall (function() return Store:SetAsync(key,data)  end)
		if not s then warn(v) table.insert(Errors,v) end
	end
	return Errors
end

function DSS.SaveCacheToStore()
	--// Save all caches to store
	for Store, Storage in pairs (Cache) do
		DSS.SaveAllToStore(Store)
	end
end

game:BindToClose(function()
	local isDataSaved = false
	--// Save all player data
	for _, player in pairs(Players:GetPlayers()) do
		player:Kick()
	end
	--// Save the cache's stores 
	coroutine.wrap(function()
		DSS.SaveCacheToStore()
		isDataSaved = true
	end)()
	repeat RS.Heartbeat:Wait() until isDataSaved
end)

return DSS
