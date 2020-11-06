local GunName = "GunModule"
local Gun = require(game.ReplicatedStorage:WaitForChild(GunName))
local FireEv = Gun.Fire
local ReloadEv = Gun.Reload
local RenderEv = Gun.RenderClient
local InitialEv = Gun.Initial

local function onFire (player, Tool, Hit)
  if Gun.Debounces[Tool] == nil then table.insert(Gun.Debounces, Tool, false) end
  if not Gun.Check(Tool) then return end
  Gun.Debounces[Tool] = true

  local result = workspace:RayCast(Tool.Main.Position, Hit.LookVector*Gun.Properties.range)
  if result then Gun.ShotResult(result) end
  for i, p in pairs (Players:GetPlayers()) do Gun.RenderClient:FireClient(p, Tool, Hit.p)

  Tool.Main.AmmoVal = Tool.Main.AmmoVal - 1
  coroutine.wrap(function() wait(Gun.Properties.delay) Gun.Debounces[Tool] = false end)
end

local function onReload(player, Tool)
  if Gun.Debounces[Tool] == nil then table.insert(Gun.Debounces, Tool, false) end
  if Gun.Debounces[GunTool] == true then return end
  if not Gun.Check(Tool, player) then return end
  Gun.Debounces[Tool] = true
  local AmmoVal = Tool.Main.AmmoVal
  AmmoVal.Value = Gun.Properties.ammo
  coroutine.wrap(function() wait(Gun.Properties.reloadTime) Gun.Debounces[Tool] = false end)
end


Gun.Fire.OnServerEvent:Connect(onFire)
InitialEv.OnServerEvent:Connect(Gun.Initiate)
