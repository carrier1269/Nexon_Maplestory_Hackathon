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
number RespawnDelay = "15"
--@ EndProperty

--@ BeginProperty
--@ SyncDirection=All
number DestroyDelay = "0.6"
--@ EndProperty

--@ BeginProperty
--@ SyncDirection=All
EntityRef stumpyportal = "eb030b0a-0a0f-4a9a-931b-fc769528d54d"
--@ EndProperty

--@ BeginProperty
--@ SyncDirection=None
EntityRef ballockHpBar = "90b7ec97-683d-4a1b-b2f5-f24b5c2f91d4"
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
_SpawnService:SpawnByModelId("model://79f3f493-9a0c-4ded-8f13-b49568ae0d0d", "SS등급", self.Entity.TransformComponent.Position, _EntityService:GetEntityByPath("/maps/map09"), nil)
local stateComponent = self.Entity.StateComponent
if stateComponent then
	stateComponent:ChangeState("DEAD")
	log("monster change state to DEAD")
end

local delayHide = function()
	self.Entity:SetVisible(false)
	self.Entity:SetEnable(false)
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

--@ BeginMethod
--@ MethodExecSpace=ClientOnly
void OnUpdate(number delta)
{
self.ballockHpBar.SliderComponent.Value = self.Hp / self.MaxHp
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

--@ BeginEntityEventHandler
--@ Scope=All
--@ Target=self
--@ EventName=StateChangeEvent
HandleStateChangeEvent
{
-- Parameters
local CurrentStateName = event.CurrentStateName
local PrevStateName = event.PrevStateName
--------------------------------------------------------
if CurrentStateName == "DEAD" then
	self.stumpyportal.Enable = true
else
	self.stumpyportal.Enable = false
end
}
--@ EndEntityEventHandler

