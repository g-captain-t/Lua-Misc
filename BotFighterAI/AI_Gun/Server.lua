--[[
Server
My demonstration raycast gun server logic. This is originally the server handler for remote events, modified
to treat the bot as a 'client'.
]]

local Players = game:GetService("Players")
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

local canFire = true
local reloading = false
Ammo.Value = Settings.UseAmmo and Settings.Ammo or 0

local function CreateBullet(hitPosition)
	local Bullet = Instance.new("Part")
	Bullet.Anchored = true
	Bullet.CanCollide = false
	Bullet.Material = Enum.Material.Neon
	Bullet.Size = Vector3.new(0.2,0.2,(BulletSpawn.Position-hitPosition).magnitude)
	Bullet.CFrame = CFrame.new(BulletSpawn.Position, hitPosition)
	Bullet.Position = BulletSpawn.Position:lerp(hitPosition, 0.5)
	Bullet.Parent = workspace
	
	coroutine.wrap(function() 
		wait(Settings.BulletAirTime)
		Bullet:Destroy()
	end)()
end

local function PlaySound(SoundObject)
	local ClonedSound = SoundObject:Clone()
	ClonedSound.Parent = Handle
	ClonedSound:Play()
	coroutine.wrap(function()
		ClonedSound.Ended:Wait()
		ClonedSound:Destroy()
	end)()
end

local function findHumanoid (part)
	local success, humanoid = pcall(function() return part.Parent:FindFirstChildOfClass("Humanoid") end)
	return success and humanoid or nil
end

local function TakeDamage(bodyPart,humanoid)
	if bodyPart.Name == "Head" then
		humanoid:TakeDamage(Settings.Damage.Head)
	elseif bodyPart.Name == "HumanoidRootPart" then
		humanoid:TakeDamage(Settings.Damage.HumanoidRootPart)
	else
		humanoid:TakeDamage(Settings.Damage.Others)
	end
end

local function OnReload()
	if not IsEquipped.Value then return end
	if reloading then return end
	reloading = true
	
	canFire = false
	PlaySound(ReloadSound)
	wait(Settings.ReloadTime)
	Ammo.Value = Settings.Ammo
	
	canFire = true
	reloading = false
end

local function OnFire (firerChar, Hit)
	if not canFire then return end
	if Settings.UseAmmo and Ammo.Value == 0 then OnReload() return end
	if not IsEquipped.Value then return end
	canFire = true
	
	local RayParams = RaycastParams.new()
	RayParams.FilterDescendantsInstances = {
		table.unpack(Tool:GetDescendants());
		table.unpack(firerChar:GetDescendants())
	}
	RayParams.FilterType = Enum.RaycastFilterType.Blacklist
	local Results = workspace:Raycast(BulletSpawn.Position, 
		-(BulletSpawn.Position-Hit).Unit*Settings.Range, 
		RayParams
	)
	
	if Results then
		CreateBullet(Results.Position)
		local humanoid = findHumanoid(Results.Instance)
		if humanoid then TakeDamage(Results.Instance.Name,humanoid) end
	else
		CreateBullet(-(BulletSpawn.Position-Hit).Unit*Settings.Range)
	end
	
	PlaySound(FireSound)
	Ammo.Value = Settings.UseAmmo and Ammo.Value-1 or Ammo.Value
	wait(Settings.Delay)
	canFire = true
end

FireEvent.Event:Connect(OnFire)
ReloadEvent.Event:Connect(OnReload)

Tool.Equipped:Connect(function()
	IsEquipped.Value = true
end)
Tool.Unequipped:Connect(function()
	IsEquipped.Value = false
end)