--@ BeginProperty
--@ SyncDirection=All
boolean SkillDelay = "false"
--@ EndProperty

--@ BeginProperty
--@ SyncDirection=All
number Delay = "3"
--@ EndProperty

--@ BeginProperty
--@ SyncDirection=All
Component MonsterFindPlayer = ":MonsterFindPlayers"
--@ EndProperty

--@ BeginMethod
--@ MethodExecSpace=ServerOnly
void OnBeginPlay()
{
self:ResetSkillDelay(self.Delay)
self.MonsterFindPlayer = self.Entity.MonsterFindPlayers
}
--@ EndMethod

--@ BeginMethod
--@ MethodExecSpace=ServerOnly
void OnUpdate(number delta)
{
if self.SkillDelay or self.Entity.Monster.IsDead then
	return
endif #self.MonsterFindPlayer.Players ~= 0 then -- 한명이라도 사람이 트리거안에 들어옴
	self.SkillDelay = true
	--플레이어 랜덤 선택
	--local targetPlayer = self.MonsterFindPlayer.Players[_UtilLogic:RandomIntegerRange(1,#self.MonsterFindPlayer.Players)]
	--print("mmmmm")
	self.Entity.StateComponent:ChangeState("MOVE")
	_SoundService:PlaySound("4b3cf6f747c94b5c8a6e3902f8c2462c",0.5)
	wait(0.9)
	self:SpawnFireBall()
	self:ResetSkillDelay(2)
end
}
--@ EndMethod

--@ BeginMethod
--@ MethodExecSpace=All
void ResetSkillDelay(number timer)
{
self.SkillDelay = true
self.Entity.StateComponent:ChangeState("IDLE")
self.MonsterFindPlayer = self.Entity.MonsterFindPlayers
local callback = function()
	if not self.Entity.Enable then
		return
	end
	self.SkillDelay = false
end
_TimerService:SetTimerOnce(callback,timer)
}
--@ EndMethod

--@ BeginMethod
--@ MethodExecSpace=All
void SpawnFireBall()
{
local num = 0
local bullet = _SpawnService:SpawnByModelId("2dcb8aa0-9f7e-46e2-b611-a44cc3aad12f"
,self.Entity.Name.. "bullet" .. tostring(num),
self.Entity.TransformComponent.Position + Vector3(-0.5,0.01,0),
self.Entity.Parent,
nil,true,true,true)
if bullet then
	bullet.Bullet.Direction = Vector2(-1,0)
	bullet.Bullet.Power = 4
	bullet.Bullet.Time = 4
end

num = num + 1
bullet = _SpawnService:SpawnByModelId("2dcb8aa0-9f7e-46e2-b611-a44cc3aad12f"
,self.Entity.Name.. "bullet" .. tostring(num),
self.Entity.TransformComponent.Position + Vector3(0.5,0.01,0),
self.Entity.Parent,
nil,true,true,true)
if bullet then
	bullet.Bullet.Direction = Vector2(1,0)
	bullet.Bullet.Power = 4
	bullet.Bullet.Time = 4
end
}
--@ EndMethod

--@ BeginEntityEventHandler
--@ Scope=All
--@ Target=self
--@ EventName=TriggerEnterEvent
HandleTriggerEnterEvent
{
-- Parameters
local TriggerBodyEntity = event.TriggerBodyEntity
--------------------------------------------------------

}
--@ EndEntityEventHandler

--@ BeginEntityEventHandler
--@ Scope=All
--@ Target=self
--@ EventName=TriggerStayEvent
HandleTriggerStayEvent
{
-- Parameters
local TriggerBodyEntity = event.TriggerBodyEntity
--------------------------------------------------------

}
--@ EndEntityEventHandler

--@ BeginEntityEventHandler
--@ Scope=All
--@ Target=self
--@ EventName=TriggerLeaveEvent
HandleTriggerLeaveEvent
{
-- Parameters
local TriggerBodyEntity = event.TriggerBodyEntity
--------------------------------------------------------

}
--@ EndEntityEventHandler

