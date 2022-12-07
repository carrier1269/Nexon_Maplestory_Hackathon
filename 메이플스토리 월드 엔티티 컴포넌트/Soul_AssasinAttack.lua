--@ BeginProperty
--@ SyncDirection=None
Component Monster = ":Monster"
--@ EndProperty

--@ BeginProperty
--@ SyncDirection=All
number BulletDamage = "0"
--@ EndProperty

--@ BeginProperty
--@ SyncDirection=All
number BasicDamage = "0"
--@ EndProperty

--@ BeginProperty
--@ SyncDirection=All
number SlashDamage = "0"
--@ EndProperty

--@ BeginMethod
--@ MethodExecSpace=ServerOnly
void OnBeginPlay()
{
self.Monster = self.Entity:GetComponent("Monster")
wait(0.1)
self.Entity.StateComponent:ChangeState("REGEN")
wait(1)
self.Entity.StateComponent:ChangeState("ATTACK")
wait(0.7)
_SoundService:PlaySound("d2c52869df1444bab6a943a5568ef6a0",0.5)
self:AttackAndSpawn()
wait(0.6)
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
void AttackNear()
{
local attackSize = Vector2(1,1)
local attackOffset = Vector2(0,0)
local hitComponent = self.Entity.HitComponent
-- 현재 sprite 사이즈를 알수 없어서 우선 hit것이 있다면 그것을 가져온다.
if hitComponent then
	attackSize = hitComponent.BoxSize
	attackOffset = hitComponent.BoxOffset
end

self:Attack(attackSize, attackOffset, nil)
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

--@ BeginMethod
--@ MethodExecSpace=All
override int CalcDamage(Entity attacker,Entity defender,string attackInfo)
{
if attackInfo == "slash" then
	return self.SlashDamage
else
	return self.BasicDamage
end

}
--@ EndMethod

--@ BeginMethod
--@ MethodExecSpace=All
void AttackAndSpawn()
{
local attackSize = Vector2(3.3,2)
local x = self.Entity.TransformComponent.Scale.x
local offset = Vector2(-x*1.6,1)

self:Attack(attackSize,offset,nil)

local bullet = _SpawnService:SpawnByModelId(
"96b30ed8-97b5-4631-a3d0-5a6b553fb708",
self.Entity.Name .. "bullet", 
self.Entity.TransformComponent.Position + Vector3(-x*0.8,0.3,0), 
self.Entity.Parent,
nil,
true,true,true)

if bullet then
	bullet.Bullet.Direction = Vector2(-x,0)
	bullet.Bullet.Power = 5
	bullet.BulletAttack.BasicDamage = self.BulletDamage
end

}
--@ EndMethod

