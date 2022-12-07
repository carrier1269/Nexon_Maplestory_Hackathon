--@ BeginProperty
--@ SyncDirection=None
number Duration = "0"
--@ EndProperty

--@ BeginMethod
--@ MethodExecSpace=ServerOnly
void OnUpdate(number delta)
{
if self.Duration == nil then self.Duration = 0 end
self.Duration = self.Duration + delta

if self.Duration >= 5 then
	self.Entity.SpriteRendererComponent.FlipX = true
end

if self.Duration >= 20 then
	self.Entity.SpriteRendererComponent.FlipX = false
end

if self.Duration >= 10 then
	self.Entity.SpriteRendererComponent.FlipX = false
	self.Duration = 0
end
}
--@ EndMethod

--@ BeginMethod
--@ MethodExecSpace=ServerOnly
void OnMapLeave(any leftMap)
{
if leftMap.Name == "map07" then
	self.Duration = 20
end
}
--@ EndMethod