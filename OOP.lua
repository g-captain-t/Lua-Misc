--// With metatables

local MyObject = {}

MyObject.__index = MyObject

function MyObject:Print()
	print(self.Property1)
end

function MyObject:Destroy()
	for property, _ in pairs (self) do
		self[property]=nil
	end
	setmetatable(self,nil)
end

function MyObject.new (Property1, Property2)
	local myobj = {
		Property1 = Property1 or "Bar"
		Property2 = Property2 or 1
	}
	return setmetatable(myobj, MyObject)
end

return MyObject



--// No metatables

local MyObject = {}

function MyObject.new(Property1, Property2)
	local myobj = {
		Property1 = Property1 or "Bar"
		Property2 = Property2 or 1
	}

	function myobj:Print()
		print(self.Property1)
	end

	function myobj:Destroy()
		for property, _ in pairs (self) do
			self[property]=nil
		end
		setmetatable(self,nil)
	end

	return myobj
end

return MyObject
