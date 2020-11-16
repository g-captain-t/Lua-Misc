--[[ AntiTeleport
constants:
Humanoid, HRP, player, character, leeway

variables: 
lastpos XZ — we’re measuring from walkspeed which doesn’t affect the Y axis

- Calculate reasonable radius from last spot: (disp = vel*time = WalkSpeed+leeway * 1 second)
- Find magnitude from lastposition to currentposition
- If magnitude is greater than reasonable radius, teleport them back

Extra Checks
- If player is seated on a seatpart, as in a vehicle
]]

local AntiTeleport = {}
local leeway = 2

local function Check(char, player, lasttime, lastposXZ)

local Humanoid = char.Humanoid
local HRP = char.HumanoidRootPart

if Humanoid.SeatPart then return end

local maxMagnitude = (Humanoid.WalkSpeed+leeway)
local PosXZ = Vector3.new(HRP.Position.X, 0, HRP.Position.Z)
local Magnitude = (PosXZ- lastposXZ).magnitude

if not Magnitude > maxMagnitude then return end
HRP.Position = lastposXZ


end

function AntiTeleport.BindCheck(char, player)
coroutine.wrap(function()
while char do 

local PosHRP = char:WaitForChild(“HumanoidRootPart”).Position
local lastPosXZ = Vector3.new(PosHRP.X, 0, PosHRP.Z)
wait(1)
Check(char, player, lastPosXZ) 

end
end)()
end

return AntiTeleport 
