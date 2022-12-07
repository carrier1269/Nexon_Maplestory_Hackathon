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
if self.SkillDelay then
	return
end
if not self.MonsterFindPlayer.Players or self.Entity.Monster.IsDead then
	return
endif #self.MonsterFindPlayer.Players ~= 0 then -- 한명이라도 사람이 트리거안에 들어옴
	self.SkillDelay = true
	--플레이어 랜덤 선택
	local targetPlayer = self.MonsterFindPlayer.Players[_UtilLogic:RandomIntegerRange(1,#self.MonsterFindPlayer.Players)]
	local targetDirection = -1
	if targetPlayer.TransformComponent.Position.x - self.Entity.TransformComponent.Position.x < 0 then
		targetDirection = 1
	end
	self.Entity.TransformComponent.Scale.x = targetDirection
	self.Entity.StateComponent:ChangeState("ATTACK")
	wait(1.6)
	_SoundService:PlaySound("d081f8d249704acd96f9d27bc858d98e", 0.5)
	wait(0.4)
	self:SpawnBullet(targetPlayer)
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
void SpawnBullet(Entity target)
{
if self.AttackNum < 0 then
	self.AttackNum = 0
end

for i=1,3 do
	local targetDirection = -1
	if target.TransformComponent.Position.x - self.Entity.TransformComponent.Position.x < 0 then
		targetDirection = 1
	end
	self.Entity.TransformComponent.Scale.x = targetDirection
	local bullet = _SpawnService:SpawnByModelId("bc53fa8a-5192-4472-b2e1-3b66f85516e5"
	,self.Entity.Name.. "bullet" .. tostring(self.AttackNum),
	self.Entity.TransformComponent.Position + Vector3(-0.5*targetDirection,0.5,0),
	self.Entity.Parent,
	nil,true,true,true)
	if bullet then
		bullet.Bullet.Direction = self:CalcAngle(target.TransformComponent.Position)
		bullet.Bullet.Power = 4
		bullet.Bullet.Time = 3
	end
	self.AttackNum = self.AttackNum + 1
	wait(0.1)
end
}
--@ EndMethod

--@ BeginMethod
--@ MethodExecSpace=All
Vector2 CalcAngle(Vector3 targetPos)
{

local thisPos = self.Entity.TransformComponent.Position

--캐릭터 발쪽으로 오프셋이 잡히돟록 y좌표를 낮춰줌
local relativePos = Vector2(targetPos.x-thisPos.x, targetPos.y -thisPos.y - 0.4)
local distance = relativePos.x * relativePos.x + relativePos.y * relativePos.y
distance = math.sqrt(distance)
local ans = Vector2(relativePos.x/distance,relativePos.y/distance)
return ans
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

