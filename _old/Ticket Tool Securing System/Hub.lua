script.Parent = game:GetService("ServerScriptService")
local BindF = Instance.new("BindableFunction")
BindF.Name = "GetKey"
BindF.Parent = script

local key = ""
for i=1,24 do key = key..tostring(math.random(0,9)) end
key = tonumber(key)

BindF.OnInvoke = function() return key end
