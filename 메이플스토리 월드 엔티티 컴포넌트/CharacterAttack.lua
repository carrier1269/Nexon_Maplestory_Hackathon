--@ BeginMethod
--@ MethodExecSpace=All
void NormalAttack()
{
local attackSize = Vector2(1, 1)
local attackOffset = Vector2(0,0)

self:Attack(attackSize, attackOffset, nil)
}
--@ EndMethod

--@ BeginMethod
--@ MethodExecSpace=All
override int CalcDamage(Entity attacker,Entity defender,string attackInfo)
{
return 1000;
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
if ActionName == "Attack" then
self:NormalAttack()
end


}
--@ EndEntityEventHandler

