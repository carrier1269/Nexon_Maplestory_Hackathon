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

--@ BeginProperty
--@ SyncDirection=All
EntityRef mushmomportal = "926f0025-fc1a-41ea-8c53-e301719c4b96"
--@ EndProperty

--@ BeginProperty
--@ SyncDirection=None
EntityRef mushhpbar = "6b2d69ef-fed4-47bf-ae44-def2a1711cdd"
--@ EndProperty

--@ BeginMethod
--@ MethodExecSpace=ClientOnly
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
_SpawnService:SpawnByModelId("model://f57f38f3-24c4-4f30-a30c-c81978300fe9", "B등급", self.Entity.TransformComponent.Position, _EntityService:GetEntityByPath("/maps/map06"), nil)
local stateComponent = self.Entity.StateComponent
if stateComponent then
	stateComponent:ChangeState("DEAD")
	log("monster change state to DEAD")
end

local delayHide = function()
	self.Entity:SetVisible(false)
	self.Entity:SetEnable(false)
	--self.Entity:Destroy()
	
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
self.mushhpbar.SliderComponent.Value = self.Hp / self.MaxHp
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
	self.mushmomportal.Enable = true
else
	self.mushmomportal.Enable = false
end
}
--@ EndEntityEventHandler

