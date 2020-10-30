local TweenService = game:GetService("TweenService")
local function tweenpart(movingPart, targetPart, speed)                   												-- Uses speed in studs/second
	local distance = (movingPart.Position - targetPart.Position).magnitude
	local goal = {}
	goal.CFrame = targetPart.CFrame
	local tInfo = TweenInfo.new(distance/speed, Enum.EasingStyle.Linear)
	local tween = TweenService:Create(movingPart, tInfo, goal)
	return tween
end

local function play()
	local pointsFolder = workspace.MovingModel_Points
	local points = {}
	for i=1,#pointsFolder:GetChildren() do points[#points+1] = pointsFolder[tostring(i)]  end       -- Part names are numbers. Contains an IntValue for the speed
	local modelRoot = workspace.MovingModel_ModelRoot

	for i, point in ipairs(points) do
		local tween = tweenpart(modelRoot, point, point.Speed.Value)
		tween:Play()
		tween.Completed:Wait()
	end
end

local Button = workspace.MovingModel_Button.ClickDetector
Button.MouseClick:Connect(play)
