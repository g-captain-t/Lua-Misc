local RangeStuds = 300

local RS = game:GetService("RunService")
local LocationPoint = script.Parent.LocationPoint
local PlayerPoint = script.Parent.PlayerPoint
local points = workspace.MapPoints:GetChildren()
local APoint = game.Players.LocalPlayer.Character:WaitForChild("HumanoidRootPart")
local MapSizeX, MapSizeY = script.Parent.Size.X.Offset, script.Parent.Size.Y.Offset
local a = math.abs

LocationPoint.Visible = false
PlayerPoint.Visible = false

local function createPoint (Point, Pos, Frame) 
	if Point.Name == "MAP_Location" then 
		local cl = LocationPoint:Clone()
		cl.TextLabel.Text = Point.LName.Value
		cl.Position = Pos
		cl.Visible = true
		cl.Parent = Frame
	elseif Point.Name == "MAP_Player" then
		local cl = PlayerPoint:Clone()
		cl.Position = Pos
		cl.Visible = true
		cl.Parent = Frame
	end 
end 

local function Scan () 	
	local startpos = APoint.Position

	local minX = startpos.X - RangeStuds/2
	local maxX = startpos.X + RangeStuds/2
	local minZ = startpos.Z - RangeStuds/2
	local maxZ = startpos.Z + RangeStuds/2

	for i, point in pairs (points) do if point then
		local TotalSizeX = a(maxX-minX)
		local TotalSizeZ = a(maxZ-minZ) -- Distance between max and min
		local MinPosSizeX = a(minX-point.Position.X)  -- distance between min and pos
		local MinPosSizeZ = a(minZ-point.Position.Z) 
		
		local ratioX = MinPosSizeX / TotalSizeX
		local ratioZ = MinPosSizeZ / TotalSizeZ
			
		if  point.Position.Z > minZ and 
			point.Position.Z < maxZ and 
			point.Position.X > minX and 
			point.Position.X  < maxX --Is within range
		then
			local newpos = UDim2.new(ratioX, 0, ratioZ, 0)
			createPoint(point, newpos, script.Parent.MapPoints)
		end
	end end
end 

--[[  Example problem
myposX = -5
LposX = -10
minX = -20
maxX = 30

ScaleSizeX = abs(-20 - 30) = 50
ScaleLposX = abs(-20 - (-10)) = 10
10:50 = 0.2 <-- This is the final X Scale position
]]

local function Orient() 
	script.Parent.MePoint.Rotation = APoint.Orientation.Y*-1
end
	
RS:BindToRenderStep("Radar", 350, function()
	script.Parent.MapPoints:ClearAllChildren()
	Scan() Orient()
end)
