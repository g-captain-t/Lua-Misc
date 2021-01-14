local HubKey = game:GetService("ServerScriptService")["Hub"].GetKey:Invoke()

local function onTouch (part)
  if not part.Parent:IsA("Tool") then return end
  local ToolKey = part.Parent:FindFirstChild("ToolKey")
  if not ToolKey or not ToolKey:IsA("Script") or not ToolKey:FindFirstChildOfClass("BindableFunction") then return end
  local key = ToolKey:FindFirstChildOfClass("BindableFunction"):Invoke()
  if key == HubKey then return true end 
end

script.Parent.Touched:Connect(function(part)
  local valid = onTouch(part)
  if not valid then return end
end
