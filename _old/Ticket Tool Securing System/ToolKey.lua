local key = game:GetService("ServerScriptService")["Hub"].GetKey:Invoke()
local BF = Instance.new("BindableFunction", script)
BF.Name = "GetKey"
BF.OnInvoke = function() return key end
