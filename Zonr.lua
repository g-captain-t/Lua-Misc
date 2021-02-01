--[[

Zonr
Author: g_captain
Last updated: 02/01/2021 (DD/MM/YYYY)
A quick Heartbeat-based zone library. Zones can be created by passing on either a BasePart or a Region3.

API

Zonr.newZone(instance BasePart or Region3)
Zonr:GetPlayerZones(player)

zone.BasePart
zone.Region
zone.Players
zone.Parts

zone.PlayerExited
zone.PlayerEntered
zone:GetPlayers()
zone:GetParts()
zone:GetActiveParts()
zone:FindPlayer(player)
zone:FindPart(part)

]]

local RS = game:GetService("RunService")
local Players = game:GetService("Players")

-- Libraries

local Signal = {} -- Just in case I want to customize my signals 
function Signal.new()
	return Instance.new("BindableEvent")
end

-- Private functions 

local function tablevaluetokey (t)
	local valuesaskeys = {}
	for i,v in pairs (t) do 
		-- Assuming v isn't a table or nil 
		valuesaskeys[v] = true
	end
	return valuesaskeys
end

local function tablefind(t,v)
	for i, value in pairs (t) do 
		if value==v then 
			return i,v end
	end
end

-- Zonr
local Zonr = {}
local zone = {}
Zonr.zones = {}

function Zonr.newZone(zonebase)
	local self = {}
	setmetatable(self,zone)

	self.Players = {}
	self.Parts = {}

	local zonebaseType = typeof(zonebase)

	if zonebaseType == "Instance" and zonebase:IsA("BasePart") then 
		local basepart = zonebase
		self.BasePart = basepart-- :Clone()
		self.BasePart.Transparency, self.BasePart.Anchored, self.BasePart.CanCollide = 1, true, false
		self._touch = basepart.Touched:Connect(function()end)
		self.BasePart.Parent = workspace
	elseif zonebaseType == "Region3" then 
		local region = zonebase
		self.Region = region
	else
		warn("Zone base is nil or an invalid type! Check if it's a BasePart or a Region3.")
	end

	--self._lastframedata

	self._playerexited = Signal.new()
	self._playerentered = Signal.new()

	self.PlayerExited = self._playerexited.Event
	self.PlayerEntered = self._playerentered.Event

	table.insert(Zonr.zones, self)
	self._zoneindex, _ = tablefind(Zonr.zones, self)

	--	self._run = RS.Heartbeat:Connect(function()
	--		self:_Run()
	--	end)

	return self
end

function Zonr:GetPlayerZones(player)
	local playerzones = {}
	for _, zone in pairs (Zonr.zones) do 
		if zone:FindPlayer(player) then 
			table.insert(playerzones,zone)
		end
	end
	return playerzones
end

-- Zones
zone.__index = zone 

function zone:Destroy()
	self._playerexited:Destroy()
	self._playerentered:Destroy()
	--self._run:Disconnect()
	if self._touch then 
		self._touch:Disconnect()
	end
	self._lastframedata = nil
	self.BasePart = nil 
	self.Region = nil 
	self.Players = nil 
	self.Parts = nil
	setmetatable(self)
	table.remove(Zonr.zones, self._zoneindex)
	self = nil
end

function zone:_Run()
	-- Update this frame's data
	local thisframe = {}
	thisframe.parts = self:GetParts()
	self.Parts = thisframe.parts

	thisframe.players = self:GetPlayers()
	self.Players = thisframe.players

	-- Compare and set
	local lastframe = self._lastframedata
	if lastframe and #thisframe.players >0 then 
		-- Players
		-- Change into value-true for easy indexing
		local playersAsKeys = tablevaluetokey(thisframe.players)
		local oldplayersAsKeys = tablevaluetokey(lastframe.players)
		local newplayers = {}
		local missingplayers = {}
		-- Find missing and new players
		for _, player in ipairs (thisframe.players) do 
			if not oldplayersAsKeys[player] then 	
				table.insert(newplayers, player)
			end
		end
		for _, player in ipairs (lastframe.players) do 
			if not playersAsKeys[player] then 
				table.insert(missingplayers, player)
			end
		end
		-- Fire the events
		for _,player in ipairs (newplayers) do			self._playerentered:Fire(player)
		end
		for _, player in ipairs(missingplayers) do 
			self._playerexited:Fire(player)
		end
	end
	self._lastframedata = thisframe
end

function zone:GetParts()
	local parts
	if self.BasePart then 
		parts = self.BasePart:GetTouchingParts()
	elseif self.Region then 
		parts = workspace:FindPartsInRegion3(self.Region)
	end
	return parts
end

function zone:GetPlayers()
	local players = {}
	local parts = self.Parts
	

	for _, part in ipairs(parts) do 
		if 
			part.Name == "HumanoidRootPart"
			and part.Parent:IsA("Model")
		then 
			local player = Players:GetPlayerFromCharacter(part.Parent)
			table.insert(players,player)
		end
	end

	return players
end

function zone:GetActiveParts()
	local active = {}
	for _, part in ipairs (self.Parts) do 
		if not part.Anchored then 
			table.insert(active,part)
		end
	end
	return active
end

function zone:FindPlayer(player)
	if tablefind(self.Players, player) then 
		return player
	end
end

function zone:FindPart(part)
	if tablefind(self.Parts, part) then 
		return part
	end
end

-- Run everything in one heartbeat connection

RS.Heartbeat:Connect(function()
	for _, zone in pairs (Zonr.zones) do 
		zone:_Run()
	end
end)

return Zonr
