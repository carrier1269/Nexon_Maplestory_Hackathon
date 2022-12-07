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
_EffectService:PlayEffectAttached("0fc31382e453414998478d8de3d563fb",self.Entity,Vector3(0,0.5,0), 0, Vector3(1,1,1), false)
_SoundService:PlaySound("0556b2224c57422c9065490fcf50dabc",0.14)
}
--@ EndEntityEventHandler
