local player = game.Players.LocalPlayer
local character = player.Character or player.CharactedAdded:Wait()
local RS = game:GetService("RunService")
local RENDER_PRIORITY = Enum.RenderPriority.Camera.Value - 5
local cam = workspace.CurrentCamera

local FOVDifference = 15
local FullSpeed = 300
local ratio = FOVDifference/FullSpeed

local function FOVAndSpeed()
	local HRPVelocity = character.HumanoidRootPart.Velocity.magnitude
	local newFOV = HRPVelocity*ratio
	cam.FieldOfView = newFOV
end

RS:BindToRenderStep("PlaneTransparency", RENDER_PRIORITY, FOVAndSpeed)
