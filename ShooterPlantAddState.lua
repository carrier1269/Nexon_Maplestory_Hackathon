--@ BeginMethod
--@ MethodExecSpace=All
void OnBeginPlay()
{
self.Entity.StateComponent:AddState("ATTACK")
}
--@ EndMethod