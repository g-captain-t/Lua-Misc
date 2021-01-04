--[[

Cached datastore
My personal datastore wrapper with caching to stop throttling

function DSS.Get(key, storename, defaultdata)
function DSS.Save(key, storename, data)
function DSS.SaveStore(key, storename, data)
function DSS.SaveAllToStore(storename)
function DSS.SaveCacheToStore()

function DSS.UpdateAsync(Store, key, data, [optional] defaultdata) 			--// To replace setasync

]]


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

local function rwait() RS.Heartbeat:Wait() end

--// From ForeverHD's PSA on why not to use SetAsync https://devforum.roblox.com/t/276457

function DSS.UpdateAsync(Store, key, data, defaultdata)
	if not data then return end
	local updateddata
	Store:UpdateAsync(key, function(oldValue)
		--// Retrieve the DataID
		local previousData = oldValue or defaultdata or {DataId = 0}
		previousData.DataId = previousData.DataId or 0
		data.DataId = data.DataId or 0
		--// Validate the DataID
		if data.DataId == previousData.DataId then
			data.DataId = data.DataId + 1
			updateddata = data
			return data
		else
			return nil
		end
	end)
	return updateddata
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
	local s,v = pcall(function() return DSS.UpdateAsync(Store, key, data) end)
	return s,v
end

function DSS.SaveAllToStore(storename)
	--// Save a store in the cache to datastore
	local Errors = {}
	local Store = DS:GetDataStore(storename)
	for key, data in pairs(Cache[storename]) do
		rwait()
		local s,v = pcall (function() 
			return DSS.UpdateAsync(Store, key, data)
		end)
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
	print("Saving...")
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
	repeat rwait() until isDataSaved
	print("Saved!")
end)

return DSS
