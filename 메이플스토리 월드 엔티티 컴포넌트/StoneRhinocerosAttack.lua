--@ BeginProperty
--@ SyncDirection=None
Component Monster = ":Monster"
--@ EndProperty

--@ BeginProperty
--@ SyncDirection=All
number FloatingDamage = "15"
--@ EndProperty

--@ BeginProperty
--@ SyncDirection=All
number BasicDamage = "5"
--@ EndProperty

--@ BeginMethod
--@ MethodExecSpace=All
void OnBeginPlay()
{
self.Monster = self.Entity:GetComponent("Monster")
self.Entity.StateComponent:AddState("ATTACK")
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
void AttackFloatIntheAir()
{
local attackOffset = Vector2(1.2 * -self.Entity.TransformComponent.Scale.x, 0.5)
local attackSize = Vector2(2.8,1.5)
self:Attack(attackSize, attackOffset, "float")
}
--@ EndMethod

--@ BeginMethod
--@ MethodExecSpace=All
override int CalcDamage(Entity attacker,Entity defender,string attackInfo)
{
if attackInfo == "float"then
	if defender.PlayerComponent then
		local x = defender.TransformComponent.Position.x - self.Entity.TransformComponent.Position.x
		if x >0 then
			x = 1
		else
			x = -1
		end
		
		defender.RigidbodyComponent:AddForce(Vector2(5*x,5))
	end
	return self.FloatingDamage
else
	return self.BasicDamage
end 
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

