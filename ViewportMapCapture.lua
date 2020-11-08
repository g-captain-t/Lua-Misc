local CamPosX, CamPosZ = 0, 0
local range = 1000  -- How wide the map will cover
local vFrame = script.Parent

for i,d in pairs (workspace:GetDescendants()) do      -- Clone permanent workspace parts & optimize
  if d:IsA("BasePart") and d.Transparency < 1 and d.Anchored then
    local dC = d:Clone()
    dC.Transparency (dC.Transparency > 0 and 0 or dC.Transparency)
    if dC:IsA("UnionOperation") or dC:IsA("MeshPart") then dC.RenderFidelity = Enum.RenderFidelity.Automatic end
    dC.CanCollide = false
    dC.Parent = vFrame
  end
end

local vCam = Instance.new("Camera", vFrame)
vCam.Parent = vFrame
vFrame.CurrentCamera = vCam

vCam.Position = Vector3.new(CamPosX, range/2, CamPosZ)  -- in theory(or "my assumptions") range/2=height or adjacent=height because FOV is flat 0
vCam.CFrame = CFrame.new(vCam.Position, vCam.Position-Vector3.new(0,-10,0))
vCam.FieldOfView = 0


-- Since setup is done, this is the optional bind to render for the player:

local player = game.Players.LocalPlayer
local character = player.Character or player.CharacterAdded

local function toBind()
  local PosX, PosZ = character.HumanoidRootPart.Position.X, character.HumanoidRootPart.Position.Z
  vCam.Position = Vector3.new(PosX, range, posZ)
end

game:GetService("RunService").RenderStepped:Connect(toBind)
