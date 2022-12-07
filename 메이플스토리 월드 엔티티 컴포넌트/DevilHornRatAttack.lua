--@ BeginProperty
--@ SyncDirection=None
Component Monster = ":Monster"
--@ EndProperty

--@ BeginProperty
--@ SyncDirection=None
number BreathDamage = "15"
--@ EndProperty

--@ BeginProperty
--@ SyncDirection=None
number BasicDamage = "5"
--@ EndProperty

--@ BeginMethod
--@ MethodExecSpace=All
void OnBeginPlay()
{
self.Monster = self.Entity:GetComponent("Monster")
}
--@ EndMethod

--@ BeginMethod
--@ MethodExecSpace=ServerOnly
void OnUpdate(number delta)
{
if self.Monster and self.Monster.IsDead == false then
	--self:AttackNear()
end
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
void AttackBreath()
{
local attackOffset = Vector2(1.2 * -self.Entity.TransformComponent.Scale.x, 0.5)
local attackSize = Vector2(2.6,1.8)
self:Attack(attackSize, attackOffset, "breath")
}
--@ EndMethod

--@ BeginMethod
--@ MethodExecSpace=All
override int CalcDamage(Entity attacker,Entity defender,string attackInfo)
{
if attackInfo == "breath"then
	return 15
else
	return 5
end 
}
--@ EndMethod

