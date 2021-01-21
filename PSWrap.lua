--[[

PSWrap
A bridge between my current data interface (DataCache) and loleris' ProfileService

]]

local PSWrap = {}
local ProfileService = require(script.ProfileService)
local DS = game:GetService("DataStoreService")
local RS = game:GetService("RunService")
local Cache = {}

local function rwait() RS.Heartbeat:Wait() end

function PSWrap.Get(key, storename, default)
	default = default or {}
	local store = ProfileService.GetProfileStore(storename, default)
	--// Cache the store
	Cache[storename] = Cache[storename] or {}
	profile = Cache[storename][key] or store:LoadProfileAsync(key,"ForceLoad")
	if profile then 
		--// Profile found, fill in missing
		profile:Reconcile()
	else 
		--// Check if a datastore of the same name exists, and if it does, migrate
		local dstore = DS:GetDataStore(storename)
		local s, data = pcall(function()return dstore:GetAsync(key)end)
		if s and data then 
			profile.Data = data
		end
	end
	--// Cache it if it doesn't exist
	Cache[storename][key] = Cache[storename][key] or profile
	return profile.Data, profile
end

function PSWrap.Save(key, storename, newvalue)
	Cache[storename] = Cache[storename] or {}
	local profile = Cache[storename][key]
	if not profile then warn("Profile doesn't exist yet!") return end 
	local Type = type(newvalue)
	if Type=="function" then 
		local nv = newvalue(profile.Data)
		profile.Data = nv or profile.Data 
	else 
		profile.Data = newvalue
	end
	return profile.Data, profile
end

function PSWrap.Clear(key, storename)
	Cache[storename] = Cache[storename] or {}
	local profile = Cache[storename][key]
	if not profile then warn("Profile doesn't exist yet!") return end 
	Cache[storename][key] = nil
	return profile
end


function PSWrap.SaveStore(key, storename)
	local profile = PSWrap.Clear(key, storename)
	if profile then profile:Release() end
end

function PSWrap.UpdateIndex(key, storename, index, newvalue)
	Cache[storename] = Cache[storename] or {}
	local profile = Cache[storename][key]
	if not profile then warn("Profile doesn't exist yet!") return end 
	local Type = type(newvalue)
	if Type=="function" then 
		local nv = newvalue(profile.Data[index])
		profile.Data[index] = nv or profile.Data[index]
	else
		profile.Data[index] = newvalue
	end
	return profile.Data, profile
end


--// Migration API

function PSWrap.ProfileToDataStore(key, storename)
	--// Transfers a profile back to DataStore
	local pstore = ProfileService.GetProfileStore(storename, {})
	local profile = pstore:LoadProfileAsync(key,"ForceLoad")
	local dstore = DS:GetDataStore(storename)
	local s, err = pcall(function()
		return dstore:UpdateAsync(key, function()
			return profile.Data
		end)
	end)
	if s then 
		warn("Finished migrating profile "..storename.."/"..key.." to DataStore!")
	else 
		error("Error occurred while migrating to DataStore: "..err)
	end
end

function PSWrap.DataStoreToProfile(key, storename)
	--// loads and sets (which .Get already does), then immediately release
	--// Meant to NOT be used in-game, as .Get already looks up saved keys
	local _, profile = PSWrap.Get(key, storename, {})
	profile:Release()
	warn("Finished migrating data key "..storename.."/"..key.." to ProfileStore!")
end

--// BindToClose

game:BindToClose(function()
	local finished
	coroutine.wrap(function()
		for storename,store in pairs (Cache) do 
			for key, profile in pairs (store) do 
				pcall(function() PSWrap.Clear(key, storename) end)
			end
		end
		finished = true
	end)()
	repeat rwait() until finished
end)

return PSWrap
