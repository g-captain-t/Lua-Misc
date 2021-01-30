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

local function deepcompare(t1,t2,ignore_mt)
	--// Thanks stackoverflow https://stackoverflow.com/questions/20325332/
	local ty1 = type(t1)
	local ty2 = type(t2)
	if ty1 ~= ty2 then return false end
	-- non-table types can be directly compared
	if ty1 ~= 'table' and ty2 ~= 'table' then return t1 == t2 end
	-- as well as tables which have the metamethod __eq
	local mt = getmetatable(t1)
	if not ignore_mt and mt and mt.__eq then return t1 == t2 end
	for k1,v1 in pairs(t1) do
		local v2 = t2[k1]
		if v2 == nil or not deepcompare(v1,v2) then return false end
	end
	for k2,v2 in pairs(t2) do
		local v1 = t1[k2]
		if v1 == nil or not deepcompare(v1,v2) then return false end
	end
	return true
end

function PSWrap.Get(key, storename, default)
	default = default or {}
	key = tostring(key)
	local store = ProfileService.GetProfileStore(storename, default)
	-- require(game.Selection:Get()[1]).GetProfileStore("MainStore", {}):WipeProfileAsync("161502352")

	--// check the cache
	Cache[storename] = Cache[storename] or {}
	local profile = Cache[storename][key]
	local iscached = profile~=nil
	profile = profile or store:LoadProfileAsync(key,"ForceLoad")
	
	if profile and not iscached then 
		--// It's not loaded yet
		local issame = deepcompare(profile.Data,default,true)
		if issame or not profile.Data then 
			--// It's a new profile
			--// Check if a datastore entry of the same name already exists, load from it
			local dstore = DS:GetDataStore(storename)
			local s, data = pcall(function()return dstore:GetAsync(key)end)
			if s and data then 
				profile.Data = data
			end
		end
		--// Profile found, fill in missing
		profile:Reconcile()
	end
	
	--// Cache it if it doesn't exist
	Cache[storename][key] = Cache[storename][key] or profile
	return profile and profile.Data, profile
end

function PSWrap.Save(key, storename, newvalue)
	key = tostring(key)
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
	return profile and profile.Data, profile
end

function PSWrap.Clear(key, storename)
	key = tostring(key)
	Cache[storename] = Cache[storename] or {}
	local profile = Cache[storename][key]
	if not profile then warn("Profile doesn't exist yet!") return end 
	Cache[storename][key] = nil
	return profile
end

function PSWrap.UpdateIndex(key, storename, index, newvalue)
	key = tostring(key)
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
	return profile and profile.Data, profile
end

function PSWrap.SaveStore(key, storename)
	key = tostring(key)
	Cache[storename] = Cache[storename] or {}
	local profile = Cache[storename][key]
	if profile then profile:Release() end
	PSWrap.Clear(key, storename)
end

function PSWrap.ClearStore(key, storename)
	--// Removes a key completely
	key = tostring(key)
	local profile = PSWrap.Clear(key, storename)
	local pstore = ProfileService.GetProfileStore(storename)
	pstore:WipeProfileAsync(key)
	return profile
end


--// Migration API

function PSWrap.ProfileToDataStore(key, storename)
	--// Transfers a profile back to DataStore
	key = tostring(key)
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
	key = tostring(key)
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
				pcall(function() PSWrap.SaveStore(key, storename) end)
			end
		end
		finished = true
	end)()
	repeat rwait() until finished
end)

return PSWrap
