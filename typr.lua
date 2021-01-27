--[[ 
tpyr, a quick type checker
Usage

assert(typr(
	{"string", {"number","string"}, "any", "Instance", "Player"}, 
	"HelloWorld", 1, nil, Instance.new("Part"), game.Players.g_captain
))

]]

local function checkclass(v,class)	
	-- just return the boolean so i can use a tri conditional
	local s,v = pcall(function()return v:IsA(class) end)
	assert(s, "Unknown class "..class)
	return s and v or false
end

local function tablefind(t,value)
	for _,v in pairs(t) do
		if v==value then return true end
	end
end

return function (types, ...)
	local pass, firsterror = true, ""
	for i, v in ipairs ({...}) do 
		if types[i] or types[i]~="any" then 
			local Type =  typeof(v)
			local allgood = true
			local checks = {
				(Type ~= types[i]),								-- Is that specified type,
				(type(types[i])=="table" and tablefind(types, Type) or true),			-- Is either one of the types in an array,
				(Type=="Instance" and types[i]~="Instance" and checkclass(v,types[i]) or true)	-- Use :IsA() if it's an instance
			}
			for _, check in ipairs (checks) do 
				if not check then 
					allgood = false
					break
				end
			end
			if not allgood then 
				pass = false
				firsterror = "Expected "..types[i].." for argument #"..i..", got "..Type
			end
		end
	end
	return pass, firsterror
end
