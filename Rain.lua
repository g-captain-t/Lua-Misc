--// Rain by g_captain
--// A raycast-based particle rain class I wrote at 1 AM

local mr = math.random
local RS = game:GetService("RunService")
local Rain = {}
Rain.__index = Rain

local function invispart(size,pos)
   local p = Instance.new("Part")
p.Transparency=1
p.Anchored=true
p.CanCollide=false
p.Size=size or Vector3.new(.1,.1,.1)
p.Position = pos or p.Position
return p
end

function Rain.new(position, props)
  local self = {
     Height=props.Height or 100,
     Range=props.Range or 200,
     Rate=props.Rate or 50,
     Speed=props.Speed or 40,
     ParticleId=props.ParticleId or "rbxassetid://0"
     Position = position or Vector3.new()
}
self._ceilingpart=invispart(Vector3.new(self.Range,1,self.Range),self.Position+Vector3.new(0,self.Height,0))
  setmetatable(self,Rain)
  return self
end

function Rain:Destroy()
  self:Stop()
  if self._ceilingpart then self._ceilingpart:Destroy() end 
  for i,v in pairs (self) do 
    self[i]=nil
  end
  setmetatable(self,nil)
end

function Rain:Start()
  if self._running then return end
  local function randomrelposXZ()
    local sz=self._ceilingpart.Size
    return Vector3.new(mr(-sz.X,sz.X),0,mr(-sz.Z,sz.Z))
  end
  local function raydownheight(pos)
    local heightdown=self.Height*2
    local results = workspace:Raycast(pos, Vector3.new(0,-heightdown,0))
    return results and (results.Position-pos).magnitude or self.Height
  end 
  local function particle()
    local attach = Instance.new("Attachment")
    attach.Position = randomrelposXZ()
    local downheight = raydownheight(attach.WorldPosition)
    local particle = Instance.new("ParticleEmitter")
    particle.Texture = self.ParticleId
    particle.Speed=self.Speed
    particle.Rate=downheight/self.Speed
    particle.Parent=attach
    wait(downheight/self.Speed)
    attach:Destroy()
  end
  self._running=true
  coroutine.wrap(function()
    while self._running do 
      wait(1/self.Rate)
      coroutine.wrap(particle)()
    end
  end)()
end

function Rain:Stop()
  self._running=false
  if self._updaterun then 
    self._updaterun:Disconnect()
  end
  self._followedpart=nil
end

function Rain:FollowBasePart(part)
  self._followedpart = part
  self._updaterun = RS.Stepped:Connect(function()
    if not self._followedpart then self._updaterun:Disconnect() end
    self.Position= self._followedpart.Position
  end)
end

function Rain:UnfollowBasePart()
  if self._updaterun then 
    self._updaterun:Disconnect()
  end
  self._followedpart=nil
end

return Rain
