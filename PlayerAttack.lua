--@ BeginMethod
--@ MethodExecSpace=ServerOnly
void OnBeginPlay()
{
self._T.shape = BoxShape(Vector2.zero, Vector2.one, 0)
}
--@ EndMethod

--@ BeginMethod
--@ MethodExecSpace=ServerOnly
void AttackNormal()
{
local playerController = self.Entity.PlayerControllerComponent
local transform = self.Entity.TransformComponent
if playerController and transform then
	local worldPosition = transform.WorldPosition
	local attackOffset = Vector2(worldPosition.x + 0.5 * playerController.LookDirectionX, worldPosition.y + 0.5)
	self._T.shape.Position = attackOffset
	
	self:AttackFast(self._T.shape, nil, CollisionGroups.Monster)
end
}
--@ EndMethod

--@ BeginMethod
--@ MethodExecSpace=All
override int CalcDamage(Entity attacker,Entity defender,string attackInfo)
{
return 50
}
--@ EndMethod

--@ BeginMethod
--@ MethodExecSpace=All
override boolean CalcCritical(Entity attacker,Entity defender,string attackInfo)
{
return _UtilLogic:RandomDouble() < 0.3
}
--@ EndMethod

--@ BeginMethod
--@ MethodExecSpace=All
override number GetCriticalDamageRate()
{
return 2
}
--@ EndMethod

--@ BeginEntityEventHandler
--@ Scope=All
--@ Target=self
--@ EventName=PlayerActionEvent
HandlePlayerActionEvent
{
-- Parameters
local ActionName = event.ActionName
local PlayerEntity = event.PlayerEntity
--------------------------------------------------------
if self:IsClient() then return end

if ActionName == "Attack" then
	self:AttackNormal()
end
}
--@ EndEntityEventHandler
