--@ BeginMethod
--@ MethodExecSpace=ServerOnly
void OnBeginPlay()
{
self.Entity.SpriteRendererComponent.SpriteRUID="10281dfdd0e044ef92ca4ea24389c1bb"
wait(3)
self.Entity.SpriteRendererComponent.SpriteRUID="32bdb3c46d2d4a4f9db2a74890615cfb"
local size = Vector2(1.25,3)
local offset = Vector2(0.029,0.495)
_SoundService:PlaySound("fc77c4002719456981b850013cae1a56",0.3)
self:Attack(size,offset,nil)
wait(0.9)
self.Entity:Destroy()
}
--@ EndMethod

--@ BeginMethod
--@ MethodExecSpace=ServerOnly
void OnUpdate(number delta)
{

}
--@ EndMethod

--@ BeginMethod
--@ MethodExecSpace=All
override int CalcDamage(Entity attacker,Entity defender,string attackInfo)
{
return 25
}
--@ EndMethod

--@ BeginMethod
--@ MethodExecSpace=All
override boolean IsAttackTarget(Entity defender,string attackInfo)
{
if not defender.PlayerComponent then
	return false
end

return __base:IsAttackTarget(defender)
}
--@ EndMethod

