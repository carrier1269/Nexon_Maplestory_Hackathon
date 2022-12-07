--@ BeginProperty
--@ SyncDirection=All
table<Entity> Players = "Entity"
--@ EndProperty

--@ BeginProperty
--@ SyncDirection=All
Entity ChasingPlayer = "nil"
--@ EndProperty

--@ BeginProperty
--@ SyncDirection=All
boolean Timer1 = "false"
--@ EndProperty

--@ BeginProperty
--@ SyncDirection=All
boolean SkillDelay = "false"
--@ EndProperty

--@ BeginProperty
--@ SyncDirection=All
boolean IsHalfHP = "false"
--@ EndProperty

--@ BeginProperty
--@ SyncDirection=All
boolean IsSummoned = "false"
--@ EndProperty

--@ BeginMethod
--@ MethodExecSpace=All
void OnBeginPlay()
{
self.Entity.StateComponent:AddState("ATTACK")
self.Entity.StateComponent:AddState("ATTACK2")
self.Entity.StateComponent:AddState("ATTACK3")
self.Entity.StateComponent:AddState("SKILL")
self.Entity.StateComponent:AddState("SKILL2")
local callback = function()
	self:ChangeChasingPlayer()
end
local cb = function()
	self.Timer1 = true
end
_TimerService:SetTimerOnce(cb,2)
_TimerService:SetTimerRepeat(callback,20,1)
}
--@ EndMethod

--@ BeginMethod
--@ MethodExecSpace=ServerOnly
void OnUpdate(number delta)
{

if self.SkillDelay or self.Entity.Monster.IsDead then
	--스킬 딜레이 중에는 아무것도 안함
	return
end
if #self.Players == 0 then
	--플레이어 범위에 없음
	self.ChasingPlayer = nil
else
	--플레이어 범위에 있음
	self.Entity.AIWanderComponent.Enable = false
	self:ChasePlayer()
	wait(0.5)
	local HPRatio = self.Entity.Monster.Hp / self.Entity.Monster.MaxHp * 100
	
	--시작
	--ATTACK 바닥찍기
	--ATTACK2 포효
	--ATTACK3 유령소환
	--SKILL 파란 빛
	--SKILL2 노란 빛
	if HPRatio > 70 then
		self:Until50()
	else		self:Until0()
	end
end
}
--@ EndMethod

--@ BeginMethod
--@ MethodExecSpace=All
number AddToArrayPlayer(Entity player)
{
if #self.Players == 0 then
	--아무것도 안들어 있으면 무조건 넣음
	self.Players[1] = player
	return 1
end
for i = 1, #self.Players do
	--배열 전체 확인하면서 이미 들어있는 플레이어인지 확인
	if self.Players[i].Name == player.Name then
		self.Players[#self.Players+1] = player
		return #self.Players+1
	end
end
return #self.Players
}
--@ EndMethod

--@ BeginMethod
--@ MethodExecSpace=All
number RemoveToArrayPlayer(Entity player)
{
if #self.Players == 0 then
	--아무것도 안들어 있으면 무조건 반환
	return 0
end
for i = 1, #self.Players do
	--배열 전체 확인하면서 이미 들어있는 플레이어인지 확인
	if self.Players[i].Name == player.Name then
		for j=i+1,#self.Players do
			self.Players[j-1] = self.Players[j]
		end
		self.Players[#self.Players] = nil
		return #self.Players
	end
end

return #self.Players
}
--@ EndMethod

--@ BeginMethod
--@ MethodExecSpace=All
void ChangeChasingPlayer()
{

if #self.Players == 0 then
	return
end
local num = _UtilLogic:RandomIntegerRange(1,#self.Players)
self.ChasingPlayer = self.Players[num]
log("Chasing Player ".. tostring(self.ChasingPlayer.Name))
}
--@ EndMethod

--@ BeginMethod
--@ MethodExecSpace=All
void ChasePlayer()
{
if self.Entity.Monster.IsDead or self.ChasingPlayer == nil then
	return
end
local PlayerPosition = self.ChasingPlayer.TransformComponent.Position
local MonsterPosition = self.Entity.TransformComponent.Position
--local probabilityOfAttack = _UtilLogic:RandomDouble()
self.Entity.AIWanderComponent.Enable = false
self.Entity.StateComponent:ChangeState("MOVE")

if math.abs(PlayerPosition.x - MonsterPosition.x) < 1 then
	--self.Entity.AIWanderComponent.Enable=true
	return
end
self.Entity.AIWanderComponent.Enable = false
if PlayerPosition.x < MonsterPosition.x then
	--player가 왼쪽
	self.Entity.MovementComponent:MoveToDirection(Vector2(-1,0),1)
	self.Entity.TransformComponent.Scale = Vector3(1,1,1)
else
	--player가 오른쪽
	self.Entity.MovementComponent:MoveToDirection(Vector2(1,0),1)
	self.Entity.TransformComponent.Scale = Vector3(-1,1,1)
end
}
--@ EndMethod

--@ BeginMethod
--@ MethodExecSpace=All
void Until50()
{
if self.Timer1 then
	self.Timer1 = false
	local callback = function()
		self.Timer1 = true
		print("now Timer1 true")
	end
	
	local targetPosition = self.ChasingPlayer.TransformComponent.Position
	local selfPostition = self.Entity.TransformComponent.Position
	
	self.SkillDelay = true
	self.Entity.MovementComponent:Stop()

	if math.abs(targetPosition.x - selfPostition.x) > 4 then--바닥찍기 or 이동
		if _UtilLogic:RandomIntegerRange(1,2) == 1 then
			self:DemonWall()
		else
			self:ChasePlayer()
		end
	else --포효 or 바닥찍기
		if _UtilLogic:RandomIntegerRange(1,2) ==1 then
			self:Roar()
		else
			self:DemonWall()
		end
	
	end
	
	if _UtilLogic:RandomIntegerRange(1,2) == 1 then--자연스러운 움직임을 위해 추가함
		self.Entity.MovementComponent:MoveToDirection(Vector2(-1,0),1)
		self.Entity.TransformComponent.Scale = Vector3(1,1,1)
	else
		self.Entity.MovementComponent:MoveToDirection(Vector2(1,0),1)
		self.Entity.TransformComponent.Scale = Vector3(-1,1,1)
	end
	self.SkillDelay = false
	_TimerService:SetTimerOnce(callback,_UtilLogic:RandomIntegerRange(1,2))
end
}
--@ EndMethod

--@ BeginMethod
--@ MethodExecSpace=All
void Until0()
{
if self.Timer1 then
	if not self.IsSummoned then
		self.SkillDelay = true
		
		
		self.Entity.RigidbodyComponent:SetForce(Vector2(0,0))
		self.Entity.StateComponent:ChangeState("ATTACK3")
		wait(2.5)
		self.SkillDelay = false
		self.IsSummoned = true
	else
		local playerPosition = self.ChasingPlayer.TransformComponent.Position
		local lookDirectionX = self.ChasingPlayer.PlayerControllerComponent.LookDirectionX
		local x = -1 -- 왼쪽
		if lookDirectionX > 0 then --오른쪽
			x=1
		end
		local pos = Vector3(playerPosition.x - 2*x, self.Entity.TransformComponent.Position.y,playerPosition.z)
		if _UtilLogic:RandomDouble() < 0.5 then-- 어새신
			
			local soul = _SpawnService:SpawnByModelId("99523b84-32c9-4d03-9c8d-a5d926c91763",
			self.Entity.Name .. "assassin",
			pos,
			self.Entity.Parent,nil,true,true,true)
			if soul then
				soul.TransformComponent.Scale.x = -x
			end
		else
			local soul = _SpawnService:SpawnByModelId("03900e89-5fdc-4a01-afbc-56c63d45292c",
			self.Entity.Name .. "warrior",
			pos,
			self.Entity.Parent,nil,true,true,true)
			if soul then
				soul.TransformComponent.Scale.x = -x
		 	end
		end
	
		self:Until50()
	end
end
}
--@ EndMethod

--@ BeginMethod
--@ MethodExecSpace=All
void DemonWall()
{
_SoundService:PlaySound("94c0bae0a1634193b99db142c11a57c1",0.5)
self.Entity.StateComponent:ChangeState("ATTACK")
wait(1)
_SoundService:PlaySound("e085d7ff139a4a0ca2db231e29cdf9c0",0.5)
wait(0.2)
self.Entity.SoulCollectorAttack:AttackSpawnWall()
}
--@ EndMethod

--@ BeginMethod
--@ MethodExecSpace=All
void Roar()
{
self.Entity.StateComponent:ChangeState("ATTACK2")
_SoundService:PlaySound("eec2f5d35c6f4f6ebe8f19bb52dbf1d1",0.6)
wait(1)
self.Entity.SoulCollectorAttack:AttackRoar()
wait(1.2)
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
local tags = TriggerBodyEntity.TagComponent.Tags
--------------------------------------------------------
for i=1, #tags do
	if tags[i] == "player" then
		--print("find player")
		local playerNum = self:AddToArrayPlayer(TriggerBodyEntity)
		if playerNum ==1  then
			self.ChasingPlayer = TriggerBodyEntity
			--self.Entity.AIChaseComponent.Enable = true
			--self.Entity.AIWanderComponent.Enable = false
		end
		return
	end
	
end
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
local tags = TriggerBodyEntity.TagComponent.Tags
--------------------------------------------------------
if not TriggerBodyEntity.TagComponent then
	return
end
for i=1, #tags do
	if tags[i] == "player" then
		--print("lost player")
		local playerNum = self:RemoveToArrayPlayer(TriggerBodyEntity)
		if playerNum == 0 then
			--self.Entity.AIChaseComponent.Enable = false
			--self.Entity.AIWanderComponent.Enable = true
		end
		return
	end
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
if CurrentStateName == "HIT" then
	if PrevStateName == "ATTACK" then
		self.Entity.StateComponent:ChangeState("ATTACK")
	elseif PrevStateName == "ATTACK2" then
		self.Entity.StateComponent:ChangeState("ATTACK2")
	elseif PrevStateName == "ATTACK3" then
		self.Entity.StateComponent:ChangeState("ATTACK3")
	end

end
}
--@ EndEntityEventHandler

