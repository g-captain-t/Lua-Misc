--[[

API

tweens.update(dt: number) : void
tweens.new(
	value: number or table,
	target: same type as value,
	info: table {
		["time"]: number,
		["direction"]: string = "in",
		["style"] = string = "linear"
	}
) : tween_object

tween_object:play() : void
tween_object:complete() : void

]]

local tweens = {}

local tweens._running = {} -- running tweens
local tweens._lastid = 0; -- tween identifiers

local functions = {
	["linear"] = {
		["in"] = function(x) return x end;
		["out"] = function(x) return x end;
		["in_out"] = function(x) return x end;
	["sine"] = {
		["in"] = function(x) return 1 - math.cos((x * math.pi) / 2)  end;
		["out"] = function(x) return math.sin((x * math.pi) / 2) end;
		["in_out"] = function(x) return -(math.cos(math.pi * x) - 1) / 2 end;
	};
	["quad"] = {
		["in"] = function(x) return x*x end;
		["out"] = function(x) return  1 - (1 - x) * (1 - x) end;
		["in_out"] = function(x) return x<0.5 and 2*x*x or 1-math.pow(-2*x+2, 2) / 2 end;
	};
	["cubic"] = {
		["in"] = function(x) return x*x*x end;
		["out"] = function(x) 1-math.pow(1-x,3) end;
		["in_out"] = function(x) return x<0.5 and 4*x*x*x or 1 - math.pow(-2*x + 2, 3) / 2 end;
	};
	["quart"] = {
		["in"] = function(x) return x*x*x*x end;
		["out"] = function(x) return 1 - math.pow(1 - x, 4) end;
		["in_out"] = function(x) return x < 0.5 and 8 * x * x * x * x or 1 - math.pow(-2 * x + 2, 4) / 2 end;
	};
	["quint"] = {
		["in"] = function(x) return x*x*x*x*x end;
		["out"] = function(x) return 1 - math.pow(1 - x, 5) end;
		["in_out"] = function(x) return x < 0.5 and 16 * x * x * x * x * x or 1 - pow(-2 * x + 2, 5) / 2 end;
	};
--	[" "] = {
--		["in"] = function(x) end;
--		["out"] = function(x) end;
--		["in_out"] = function(x) end;
--	};
}

local function shallowcopy(t)
	local nt = {}
	for i, v in pairs(t) do 
		nt[i] = v
	end
	return nt
end

local tween_object = {}
tween_object.__index = tween_object

function tween_object.new(_type, value, target, info)
	local self = {
		type = _type;
		initial = value;
		target = target;
		delta = nil;
		value = value;
		time = info.time;
		y = 0;
		x = 0;
		func = functions[info.style][info.direction];
	}
	
	if _type == "Table" then 
		self.delta = {}
		for i, v in pairs (target) do 
			self.delta[i] = v - self.value[i]
		end
		self.initial = shallowcopy(value)
	else 
		self.delta = target - value
	end
	
	return setmetatable(self, tween_object)
end

function tween_object:play()
	-- Add it to the running queue
	self._id = tweens._lastid + 1
	tweens._lastid = tweens._lastid + 1
	tweens._running[self._id] = self
end

function tween_object:_update(dt)
	self.x = math.min(self.x + self.time/dt, 1)
	self.y = self.func(self.x)
	-- update based on y
	if self.type == "table" then 
		for i, v in pairs (self.target) do 
			self.value[i] = self.initial[i] + self.y * self.delta[i]
		end
	else
		self.value = self.initial + self.y * self.delta
	end
	-- Auto complete when x is 1
	if self.x == 1 then
		coroutine.wrap(self.complete)(self)
	end
end

function tween_object:complete()
	-- Remove and delete the tween
	-- Will be called once complete
	tweens._running[self._id] = nil
	self.initial = nil
	self.delta = nil
	self.value = nil
	self.target = nil
	setmetatable (self, nil)
end

-- Module

function tweens.new (value, target, info)
	local Type = type(value)
	
	assert(Type=="table" or Type=="number", "Tweens: Expected a table or number for the given value, got "..Type)
	assert(type(target)==Type, "Tweens: Expected the value and target to be the same type, got "..type(target))
	if Type == "table" then 
		for i, v in pairs (target) do 
			local v_type = type(v)
			assert(v_type=="number", "Tweens: Expected a number for target property "..i..", got "..v_type)
		end
	end
	
	info.style = info.style or "linear"
	info.direction = info.direction or "in"
	
	assert(type(info.style)=="string", "Tweens: Expected a string name for a tween style, got "..type(info.style))
	assert(type(info.direction)=="string", "Tweens: Expected a string name for a tween direction, got "..Type)
	
	assert(info.style and functions[info.style], "Tweens: Got invalid style "..tostring(info.direction))
	assert(info.direction and functions[info.style][info.direction], "Tweens: Got invalid direction "..tostring(info.direction))
	
	assert(type(info.time)=="number", "Tweens: Expected a number for tween duration, got "..type(info.time))
	
	return tween_object.new(Type, value, target, info)
end

function tweens.update(dt)
	-- This updates all the running tweens
	-- Should be called every step
	for _, tween in pairs (tweens._running) do 
		tween:_update(dt)
	end
end

return tweens

----[[

Example

local tweens = require "tweens"

function love.update(dt)
	tweens.update(dt)
end


-- Tween a number

local num_tween = tweens.new(
	5, 
	25, 
	{time = 1; style = "quart"; direction = "in_out"}
)

num_tween:play()


-- Tween an object

local player = {
	x = 0;
	y = 0
}

local obj_tween = tweens.new(
	player, 
	{y = 25}, 
	{time = 1; style = "quart"}
)

obj_tween:play()

]]
