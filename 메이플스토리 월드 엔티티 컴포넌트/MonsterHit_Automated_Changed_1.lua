--@ BeginMethod
--@ MethodExecSpace=All
override void OnHit(Entity attacker,int damage,boolean isCritical,string attackInfo,int hitCount)
{
__base:OnHit(attacker,damage,isCritical,attackInfo,hitCount)
}
--@ EndMethod

--@ BeginMethod
--@ MethodExecSpace=All
override boolean IsHitTarget(string attackInfo)
{
return __base:IsHitTarget()
}
--@ EndMethod

--@ BeginEntityEventHandler
--@ Scope=All
--@ Target=self
--@ EventName=HitEvent
HandleHitEvent
{
-- Parameters
local AttackCenter = event.AttackCenter
local AttackerEntity = event.AttackerEntity
local Damages = event.Damages
local Extra = event.Extra
local FeedbackAction = event.FeedbackAction
local IsCritical = event.IsCritical
local TotalDamage = event.TotalDamage
--------------------------------------------------------

}
--@ EndEntityEventHandler
