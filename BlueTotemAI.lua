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

--@ BeginProperty
--@ SyncDirection=All
number AttackNum = "0"
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
	self.Entity.StateComponent:ChangeState("MOVE")
	_SoundService:PlaySound("4b3cf6f747c94b5c8a6e3902f8c2462c",0.5)
	wait(0.9)
	self:SpawnBlueBall()
	self:ResetSkillDelay(self.Delay)
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
--@ MethodExecSpace=Server
void SpawnBlueBall()
{
local num = 0
if self.AttackNum < 0 then
	self.AttackNum = 0
end
if self.AttackNum %2 == 0 then
	local bullet = _SpawnService:SpawnByModelId("1f4336ae-8a75-4446-98f4-2ff342bf3635"
	,self.Entity.Id .. tostring(num).. tostring(self.AttackNum),
	self.Entity.TransformComponent.Position + Vector3(-0.5,0.01,0),
	self.Entity.Parent,
	nil,true,true,true)
	if bullet then
		bullet.Bullet.Direction = Vector2(-1,0)
		bullet.Bullet.Power = 2
		--bullet.Bullet.Time = 3
	end

	num = num + 1
	local bullet2 = _SpawnService:SpawnByModelId("1f4336ae-8a75-4446-98f4-2ff342bf3635"
	,self.Entity.Id .. tostring(num).. tostring(self.AttackNum),
	self.Entity.TransformComponent.Position + Vector3(0.5,0.01,0),
	self.Entity.Parent,
	nil,true,true,true)
	if bullet2 then
		bullet2.Bullet.Direction = Vector2(1,0)
		bullet2.Bullet.Power = 2
		--bullet2.Bullet.Time = 3
	end
else
	local bullet3 = _SpawnService:SpawnByModelId("1f4336ae-8a75-4446-98f4-2ff342bf3635"
	,self.Entity.Id .. tostring(num).. tostring(self.AttackNum),
	self.Entity.TransformComponent.Position + Vector3(-0.5,0.01,0),
	self.Entity.Parent,
	nil,true,true,true)
	if bullet3 then
		bullet3.RigidbodyComponent.Gravity = 0.8
		bullet3.Bullet.Direction = Vector2(-1,0.5)
		bullet3.Bullet.Power = 6
		--bullet3.Bullet.Time = 3
	end

	num = num + 1
	local bullet4 = _SpawnService:SpawnByModelId("1f4336ae-8a75-4446-98f4-2ff342bf3635"
	,self.Entity.Id .. tostring(num).. tostring(self.AttackNum),
	self.Entity.TransformComponent.Position + Vector3(0.5,0.01,0),
	self.Entity.Parent,
	nil,true,true,true)
	if bullet4 then
		bullet4.RigidbodyComponent.Gravity = 0.8
		bullet4.Bullet.Direction = Vector2(1,0.5)
		bullet4.Bullet.Power = 6
		--bullet4.Bullet.Time = 3
	end
end
self.AttackNum = self.AttackNum +1
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

