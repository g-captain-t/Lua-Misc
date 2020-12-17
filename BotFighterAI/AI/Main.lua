--[[
Main
This is the main moving logic, controlling the jumps and walks. 
The function RandomChoice returns one value in an array, which will be used a lot here.
The function newDirectionXZ returns a unit direction in two decimal points.
The chances of the bot jumping is 3 in 4 in RandomJump.
For the walking, this decides the RootPos, a constant, where the bot will stand relative to the target (RootPos, the blue brick)
The bot needs to wander around the RootPos. For that, we calculate another relative position to the root (FinalPos, the white brick), 
which will regularly change.
]]

local humanoid = script.Parent.Parent.Humanoid
local TargetVal = script.Parent.Target
local rangeFromTarget = 50
local wanderRadius = 20
local mr = math.random

local function RandomChoice(choicesArray)
	return choicesArray[mr(1,#choicesArray)]
end
local function newDirectionXZ()
	return Vector3.new( mr(-100,100)/100, 0, mr(-100,100)/100 ).Unit
end

local function RandomJump()
	local Action = RandomChoice({"JUMP","JUMP","JUMP",""})
	if Action == "JUMP" then humanoid.Jump = true end
	wait() humanoid.Jump = false
end

local directionFromTarget = newDirectionXZ()

local function RandomWalk()
	local s, targetPos = pcall(function() return TargetVal.Value.Position end)
	local LRangeFromTarget = rangeFromTarget
	if not s or not targetPos then 
		targetPos = humanoid.Parent:FindFirstChild("HumanoidRootPart").Position
		LRangeFromTarget = 0
	end
	directionFromTarget = not directionFromTarget and newDirectionXZ() or directionFromTarget
	local rootPos = targetPos + directionFromTarget*rangeFromTarget
	
	local wanderDirections = {
		Vector3.new( mr(-100,100)/100, 0, mr(-100,100)/100 ).Unit;
		Vector3.new( mr(-100,100)/100, 0, mr(-100,100)/100 ).Unit;
	}
	local finalPos = rootPos + RandomChoice(wanderDirections)*wanderRadius
	coroutine.wrap(function()humanoid:MoveTo(finalPos)end)()
	
	--Visualize
	script.Parent.RootPos.Position = rootPos
	script.Parent.FinalPos.Position = finalPos
end

coroutine.wrap(function()while humanoid do
	wait(.1)
	RandomJump()
end end)()
while humanoid do
	wait(.5)
	RandomWalk()
end