--@ BeginMethod
--@ MethodExecSpace=ServerOnly
void OnUpdate(number delta)
{
if self.Entity.TransformComponent.Position.y <= -5 then
	self.Entity.MovementComponent:SetPosition(Vector2(math.random(-10, 2), 4.5))
	self.Entity.RigidbodyComponent.Gravity = 0
	wait(math.random(0,3))
	self.Entity.RigidbodyComponent.Gravity = 0.2
end
}
--@ EndMethod

