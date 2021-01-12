local Tool = script.Parent
local Handle = Tool:WaitForChild("Handle")

local Character = Tool.Parent
local RaycastHitbox = require(game:GetService("ReplicatedStorage").RaycastHitboxV3)
local Hitbox --- to be initialized when equipped

local Players = game:GetService("Players")
local Debris = game:GetService("Debris")
local RunService = game:GetService("RunService")

ToolEquipped = false
Tool.Enabled = true

function Attack()
	wait(0.2)
	Hitbox:HitStop()
end

function Activated()
	if not Tool.Enabled or not ToolEquipped then return end
	Tool.Enabled = false
	Hitbox:HitStart()
	Tool.Enabled = true
end

function Equipped()
	Character = Tool.Parent
	ToolEquipped = true
	Hitbox = RaycastHitbox:Initialize(Tool, {Character})
	Hitbox:PartMode(true) --- Makes it so OnHit connection line will fire for every part hit similar to how normal Touched works
	Hitbox:DebugMode(true)
	Hitbox.OnHit:Connect(Blow)
end

Tool.Activated:Connect(Activated)
Tool.Equipped:Connect(Equipped)
