local Gun = {}

Gun.Properties = {
  ["range"] = 100 ;
  ["ammo"]  = 25 ;
  ["reloadTime"] = 1;
  ["delay"] = 0.1 ;
  ["damageHead"]  = 20 ;
  ["damageTorso"] = 15 ;
  ["damage"] = 5;
}

Gun.Debounces = {}

function Gun.Initiate(Tool, player)
  -- When a gun's localscript first exists. Can insert checks
  if Gun.Debounces[Tool] == nil then table.insert(Gun.Debounces, Tool, false) end
end


function Gun.Bullet(GunTool, EndPos)
  local gunMain = GunTool.Main
  local distance = (gunMain.Position - EndPos).magnitude
  local bullet = Instance.new("Part")
  bullet.Size = Vector3.new(0.05, 0.05, 1)
  bullet.Material = Enum.Material.Neon
  bullet.CFrame = CFrame.new(gunMain.Position, EndPos)
  bullet.Position = gunMain.Position

  local velocity = distance / Gun.Properties.delay
  local bVelocity = Instance.new("BodyVelocity")
  bVelocity.Velocity = bullet.CFrame.LookVector * velocity
  bVelocity.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
  bVelocity.Parent = bullet
  bullet.Parent = workspace

  coroutine.wrap(function() wait(Gun.Properties.delay) bullet:Destroy() end)()
end

function Gun.PlayerOfTool(Tool)
  if Tool.Parent:IsA("Model") and pcall(function () Players:GetPlayerFromCharacter(Tool.Parent) end) then return Players:GetPlayerFromCharacter(Tool.Parent)
  elseif Tool.Parent:IsA("Backpack") then return Tool.Parent.Parent end
end

function Gun.Check(GunTool, firer)
  local gunMain = GunTool.Main
  local AmmoVal = gunMain.AmmoVal
  local checks = {
    (AmmoVal.Value < 0);
    (AmmoVal.Value > Gun.Properties.ammo);
    (Gun.Debounces[GunTool] == false);
    (Gun.PlayerOfTool(Tool) == firer)
  }
  for i, c in pairs (checks) do if not c then return false end
  return true
end

function Gun.ShotResult(result)
  if not result.Parent:FindFirstChildOfClass("Humanoid") then return end

  local Humanoid = result.Parent:FindFirstChildOfClass("Humanoid")
  if result.Name == "Head" then Humanoid:TakeDamage(Gun.Properties.damageHead) 
  elseif result.Name == ("Torso" or "LowerTorso" or "UpperTorso") then Humanoid:TakeDamage(Gun.Properties.damageHead) 
  else Humanoid:TakeDamage(Gun.Properties.damage) 
  end
end

return Gun
