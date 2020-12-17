--[[ 
Firer
This is the bot's gun handling brain.
A feature I'd like to point out here is the target leeway. This simulates the bot as a real player with inaccuracy instead of pure aimbot.
The target leeway, combined with the distance from target and wanderRadius can be modified for fighting difficulty levels.
]]

local FireEvent = script.Parent.FireEvent
local ReloadEvent = script.Parent.ReloadEvent
local Settings = require(script.Parent.GunSettings)
local Tool = script.Parent
local Ammo = script.Parent.Ammo
local IsEquipped = script.Parent.IsEquipped
local Handle = script.Parent.Handle
local BulletSpawn = Handle
local FireSound = Handle.Fire
local ReloadSound = Handle.Reload


local AIFolder = Tool.Parent.AI
local TargetVal = AIFolder.Target
local isFiringVal = AIFolder.Firing
local leeway = AIFolder.FireLeeway.Value

local mr = math.random
local function newDirectionXYZ()
	return Vector3.new( mr(-100,100)/100, mr(-100,100)/100, mr(-100,100)/100 ).Unit
end

local function Firing()
	while isFiringVal.Value do
		wait(Settings.Delay)
		FireEvent:Fire(Tool.Parent, TargetVal.Value.Position + newDirectionXYZ()*leeway)
	end
end

isFiringVal:GetPropertyChangedSignal("Value"):Connect(function()
	if not isFiringVal.Value then return end
	Firing()
end)

wait()
isFiringVal.Value = true

Tool.Parent.Humanoid.Died:Connect(function()
	Tool.Parent:Destroy()
end)