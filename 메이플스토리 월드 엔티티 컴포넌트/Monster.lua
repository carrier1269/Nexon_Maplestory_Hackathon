--@ BeginProperty
--@ SyncDirection=All
number MaxHp = "100"
--@ EndProperty

--@ BeginProperty
--@ SyncDirection=All
number Hp = "0"
--@ EndProperty

--@ BeginProperty
--@ SyncDirection=All
boolean RespawnOn = "false"
--@ EndProperty

--@ BeginProperty
--@ SyncDirection=All
boolean IsDead = "false"
--@ EndProperty

--@ BeginProperty
--@ SyncDirection=All
number RespawnDelay = "5"
--@ EndProperty

--@ BeginProperty
--@ SyncDirection=All
number DestroyDelay = "0.6"
--@ EndProperty

--@ BeginMethod
--@ MethodExecSpace=All
void OnBeginPlay()
{
self.Hp = self.MaxHp
}
--@ EndMethod

--@ BeginMethod
--@ MethodExecSpace=ServerOnly
void Dead()
{
self.IsDead = true
local stateComponent = self.Entity.StateComponent
if stateComponent then
	stateComponent:ChangeState("DEAD")
	log("monster change state to DEAD")
end

local delayHide = function()
	self.Entity:SetVisible(false)
	self.Entity:SetEnable(false)
	
	if self.RespawnOn == false then
		self.Entity:Destroy()
	end
end

_TimerService:SetTimerOnce(delayHide, self.DestroyDelay)
}
--@ EndMethod

--@ BeginMethod
--@ MethodExecSpace=ServerOnly
void Respawn()
{
log("Respawn")
self.IsDead = false
self.Entity:SetVisible(true)
self.Entity:SetEnable(true)

self.Hp = self.MaxHp
local stateComponent = self.Entity.StateComponent
if stateComponent then
	stateComponent:ChangeState("IDLE")
end
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
if self:IsClient() then return end

local originalHp = self.Hp
self.Hp = self.Hp - TotalDamage

if self.Hp > 0 or originalHp <= 0 then
	return	
end

self:Dead()
local timerFunc = function() self:Respawn() end

if self.RespawnOn then
	_TimerService:SetTimerOnce(timerFunc, self.RespawnDelay)
end
}
--@ EndEntityEventHandler
