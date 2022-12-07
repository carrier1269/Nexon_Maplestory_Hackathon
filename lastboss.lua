--@ BeginProperty
--@ SyncDirection=All
number MaxHp = "10000"
--@ EndProperty

--@ BeginProperty
--@ SyncDirection=All
number Hp = "0"
--@ EndProperty

--@ BeginProperty
--@ SyncDirection=All
boolean RespawnOn = "true"
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
EntityRef lastportal = "93c8decb-f6c3-4181-8eba-20f1ba375bc1"
--@ EndProperty

--@ BeginProperty
--@ SyncDirection=None
EntityRef soulHpBar = "09f6f992-13cb-4b78-aad4-e061051afc82"
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
_SpawnService:SpawnByModelId("model://41321324-06a2-49b7-a057-cef8cad9ce34", "S등급", self.Entity.TransformComponent.Position, _EntityService:GetEntityByPath("/maps/LastBossMap"), nil)
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
self.soulHpBar.SliderComponent.Value = self.Hp / self.MaxHp
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
	self.lastportal.Enable = true
else
	self.lastportal.Enable = false
end
}
--@ EndEntityEventHandler

