local DSS = {}
local DataStoreService = game:GetService("DataStoreService")

function DSS.Set(store, key, value)
	local success, err  = pcall(function()
		return store:SetAsync(key, value) end)
	return success, err 
end

function DSS.Get(store, key)
	local success, value  = pcall(function()
		return store:GetAsync(key) end)
	return success, value 
end

function DSS.Update(store, key, funct)
	local success, value  = pcall(function()
		return store:UpdateAsync(key, funct) end)
	return success, value 
end

function DSS.Increment(store, key, amount)
	local success, value  = pcall(function()
		return store:IncrementAsync(key, amount) end)
	return success, value 
end

function DSS.Remove(store, key)
	local success, value  = pcall(function()
		return store:RemoveAsync(key) end)
	return success, value 
end

function DSS.GetDataStore(store) return DataStoreService:GetDataStore(store) end
function DSS.GetSorted(store, isAscending, pageSize) return store:GetSortedAsync(isAscending, pageSize) end


--- Custom Functions

function DSS.Print(store, pageSize)
	local pages = DSS.GetSorted(store, true, pageSize)
	local result 
	while true do
		local data = pages:GetCurrentPage()
		for _, entry in pairs(data) do
			result = result.."/n".. entry.key..": "..tostring(entry.value)
		end
		if pages.IsFinished then break
		else result = result.."/n".."----------------" pages:AdvanceToNextPageAsync()
		end 
	end
	print(result)
	return result
end

return DSS
