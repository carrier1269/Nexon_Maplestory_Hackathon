--@ BeginProperty
--@ SyncDirection=None
Component Monster = ":Monster"
--@ EndProperty

--@ BeginProperty
--@ SyncDirection=All
number Damage = "0"
--@ EndProperty

--@ BeginProperty
--@ SyncDirection=All
number RoarDamage = "0"
--@ EndProperty

--@ BeginProperty
--@ SyncDirection=All
number FireWallDamage = "0"
--@ EndProperty

--@ BeginMethod
--@ MethodExecSpace=ServerOnly
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
void AttackSpawnWall()
{
local stdPos = self.Entity.TransformComponent.Position
for i=1,7 do
	local pos = Vector3(stdPos.x + (-self.Entity.TransformComponent.Scale.x*i*2),stdPos.y,stdPos.z)
	_SpawnService:SpawnByModelId("24343bb7-95ab-4c87-9be1-f0daedd5a3a9",
	self.Entity.Name .. "wall" .. i,
	pos,
	self.Entity.Parent,nil,true,true,true)
	wait(0.15)
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

--@ BeginMethod
--@ MethodExecSpace=All
void AttackRoar()
{
local attackSize = Vector2(1,1)
local attackOffset = Vector2(0,0)
local hitComponent = self.Entity.HitComponent
if hitComponent then
	attackOffset = hitComponent.BoxOffset
end
attackSize = Vector2(4,2)
attackOffset = attackOffset + Vector2(-2*self.Entity.TransformComponent.Scale.x,0)
local options = {["PlayRate"] = 2}
_EffectService:PlayEffectAttached("e9bed821d42041668679799b9b31b173",self.Entity,Vector3(0,0,0),0,Vector3(1,1,1),false,options)
self:Attack(attackSize, attackOffset, "roar")
}
--@ EndMethod

--@ BeginMethod
--@ MethodExecSpace=All
override int CalcDamage(Entity attacker,Entity defender,string attackInfo)
{
--ATTACK 바닥찍기
--ATTACK2 포효
--ATTACK3 유령소환
--SKILL 파란 빛
--SKILL2 노란 빛
if attackInfo == "fireWall" then
	return self.FireWallDamage
elseif attackInfo == "roar" then
	if defender.PlayerComponent then
		print("is player!")
		local x = defender.TransformComponent.Position.x - self.Entity.TransformComponent.Position.x
		if x >0 then
			x = 1
		else
			x = -1
		end
		
		defender.RigidbodyComponent:AddForce(Vector2(8*x,0))
	end
	return self.RoarDamage
else
	return self.Damage
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

