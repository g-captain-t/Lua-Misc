local GunName = "GunModule"
local Gun = require(game.ReplicatedStorage:WaitForChild(GunName))
local FireEv = Gun.Fire
local ReloadEv = Gun.Reload
local RenderEv = Gun.RenderCient
local InitialEv = Gun.Initial

local Tool = script.Parent
local Main = Tool.Main
local player = game.Players.LocalPlayer
local Mouse = player:GetMouse()
 
InitialEv:FireServer(Tool, player)

local function Effects(MainPart)
  MainPart.Sound_Fire:Play()
  MainPart.Effect_Flash.Enabled = true
  MainPart.Effect_Light.Enabled = true
  wait(.1)
  MainPart.Effect_Flash.Enabled = false
  MainPart.Effect_Light.Enabled = false
end

local function onFire()
  local Hit = mouse.Hit
  if not Gun.Check(Tool, player) then return end
  Gun.Fire:FireServer(Tool, Hit)
  Gun.Bullet(Tool, Hit.p)
  Main.Sound_Fire:Play()
  coroutine.wrap(Effects)(Main)
end

local function reload()
  if not Gun.Check(Tool, player) then return end
  ReloadEv:FireServer(Tool)
  Main.Sound_Reload:Play()
end

local function renderClient(renderTool, renderHitPos)
  coroutine.wrap(Effects)(renderTool.Main)

  local distCheckMain = ((renderTool.Main.Position-Main.Position).magnitude > 9999)
  local distCheckHit = ((renderHitPos-Main.Position).magnitude > 9999)
  if distCheckMain or distCheckHit then return end
  Gun.Bullet(renderTool, renderHitPos)
end 

-- On mouse Held, fire onFire

local Held = false
UserInputService.InputBegan:Connect(function(inputObject)
	if inputObject.UserInputType == Enum.UserInputType.MouseButton1 then Held = true end
  if inputObject.KeyKode = Enum.KeyCode.R then reload () end
end)
UserInputService.InputEnded:Connect(function(inputObject)
	if inputObject.UserInputType == Enum.UserInputType.MouseButton1 then Held = false end
end)

RenderEv.OnClientEvent:Connect(renderClient)
while true do wait(.1) if Held then onFire() end
