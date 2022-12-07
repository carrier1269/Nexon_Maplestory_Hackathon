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
end
--print("AAA")
--딜레이 끝난 후
if #self.MonsterFindPlayer.Players ~= 0 then -- 한명이라도 사람이 트리거안에 들어옴
	self.SkillDelay = true
	self.Entity.AIWanderComponent.Enable = false
	self.Entity.MovementComponent:Stop()
	--플레이어 랜덤 선택
	local targetPlayer = self.MonsterFindPlayer.Players[_UtilLogic:RandomIntegerRange(1,#self.MonsterFindPlayer.Players)]
	local targetDirection = -1
	if targetPlayer.TransformComponent.Position.x - self.Entity.TransformComponent.Position.x < 0 then
		targetDirection = 1
	end
	self.Entity.RigidbodyComponent:SetForce(Vector2(0,0))
	self.Entity.TransformComponent.Scale.x = targetDirection
	self.Entity.StateComponent:ChangeState("ATTACK")
	wait(1.0)
	_SoundService:PlaySound("18f5c872c1154f83bc88d9510a3cd1ea", 0.5)	self.Entity.StoneRhinocerosAttack:AttackFloatIntheAir()
	
	wait(0.9)
	self:ResetSkillDelay(2)
	self.Entity.AIWanderComponent.Enable = true
	self:Idle()
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
void Idle()
{
self.Entity.AIWanderComponent.Enable = true
if self.Entity.MovementComponent:IsFaceLeft() then
	self.Entity.TransformComponent.Scale = Vector3(1,1,1)
else
	self.Entity.TransformComponent.Scale = Vector3(-1,1,1)
end
}
--@ EndMethod

