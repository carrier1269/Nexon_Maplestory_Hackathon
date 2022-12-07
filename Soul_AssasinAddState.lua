--@ BeginMethod
--@ MethodExecSpace=All
void OnBeginPlay()
{
self.Entity.StateComponent:AddState("ATTACK")
self.Entity.StateComponent:AddState("REGEN")
}
--@ EndMethod