- Range: FogEnd
- Region3: Pos - Range/2,Range/2,Range/2, Pos + Range/2, Range/2, Range/2 

LimitRender: 
- CastShadow disable 
- CollisionFidelity Auto 
- CanCollide disable 
- RenderFidelity auto 
- Castshadow disable 
- Transparency 1 
- Material SmoothPlastic

Rerender: 
- Part’s final property will be (ActualProperty is not currentProperty and Actualproperty) or (currentProperty)

Every renderstep, invoke region3 
- Server returns all the parts in region3 and not in region3 
- LimitRender all the parts not in region3 
- ReRender all the parts in region3

```lua
local OptimizedProperties = {
  ["CastShadow"] = false
  ["CollisionFidelity"] = Enum.CollisionFidelity.Automatic
  ["CanCollide"] = false
  ["RenderFidelity"] = Enum.RenderFidelity.Automatic
  ["CastShadow"] = false
  ["Transparency"] = 1
  ["Material"] = Enum.Material.SmoothPlastic
}
```
