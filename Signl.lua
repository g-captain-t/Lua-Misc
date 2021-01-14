--// Signl by g_captain
--// Version without bindables
--// Is this it??

local signal = {}
signal.__index = signal

function signal.new()
	local self = {connections={}}
	setmetatable(self,signal)
	return self
end

function signal:Connect(f)
	table.insert(self.connections,f)
end

function signal:Fire(...)
	for _, f in pairs (self.connections) do 
		coroutine.wrap(f)(...)
	end
end

function signal:Destroy()
	for i_, in pairs (self.connections) do 
		self.connections[i]=nil
	end
	self.connections=nil
	setmetatable(self,nil)
end

return signal
