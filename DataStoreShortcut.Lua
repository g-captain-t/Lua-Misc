local module = {}
local DataStoreService = game:GetService("DataStoreService")

function module:Get(key)
    local success, value  = pcall(function()
	  return self:GetAsync(key) end)
    return success, value 
end

function module:Set(key, value)
    local success, err  = pcall(function()
	  return self:SetAsync(key, value) end)
    return success, err 
end

function module:Update(key, funct)
    local success, value  = pcall(function()
	  return self:UpdateAsync(key, funct) end)
    return success, value 
end

function module:Increment(key, amount)
    local success, value  = pcall(function()
	  return self:IncrementAsync(key, amount) end)
    return success, value 
end

function module:Remove(key)
    local success, value  = pcall(function()
	  return self:RemoveAsync(key) end)
    return success, value 
end

return module
