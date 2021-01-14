--// Signal by g_captain
--// Is this it??

local signal = {}
signal.__index = signal

function signal.new()
	local self = {}
	self._bindable = Instance.new("BindableEvent")
	self._args = {}
	setmetatable(self,signal)
	return self
end

function signal:Connect(f)
	return self._bindable.Event:Connect(function()
		f(table.unpack(self._args))
	end)
end

function signal:Fire(...)
	self._args={...}
	self._bindable:Fire()
end

function signal:Destroy()
	if self._bindable then
		self._bindable:Destroy()
		self._bindable=nil
	end
	self._args=nil
	setmetatable(self,nil)
end

return signal
