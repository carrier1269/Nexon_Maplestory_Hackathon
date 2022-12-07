--@ BeginProperty
--@ SyncDirection=None
Component Monster = ":Monster"
--@ EndProperty

--@ BeginProperty
--@ SyncDirection=All
number SpinDamage = "20"
--@ EndProperty

--@ BeginProperty
--@ SyncDirection=All
number BasicDamage = "10"
--@ EndProperty

--@ BeginMethod
--@ MethodExecSpace=All
void OnBeginPlay()
{
self.Monster = self.Entity:GetComponent("Monster")
self.Entity.StateComponent:AddState("SKILL")
self.Entity.StateComponent:AddState("SKILL2")
self.Entity.StateComponent:AddState("SKILLAFTER2")
self.Entity.StateComponent:AddState("ATTACK")
self.Entity.StateComponent:AddState("REGEN")
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
void AttackThrowFeather()
{
local attackOffset = Vector2(0.5 * -self.Entity.TransformComponent.Scale.x, 0.5)
local attackSize = Vector2(3.8,2)
self:Attack(attackSize, attackOffset, "breath")
}
--@ EndMethod

--@ BeginMethod
--@ MethodExecSpace=All
override int CalcDamage(Entity attacker,Entity defender,string attackInfo)
{
if attackInfo == "spin" then
	return self.SpinDamage
else
	return self.BasicDamage
end

}
--@ EndMethod

--@ BeginMethod
--@ MethodExecSpace=All
void AttackSpin()
{
local attackOffset = Vector2(0,1)
local attackSize = Vector2(5,2.7)

self:Attack(attackSize,attackOffset,"spin")
}
--@ EndMethod

