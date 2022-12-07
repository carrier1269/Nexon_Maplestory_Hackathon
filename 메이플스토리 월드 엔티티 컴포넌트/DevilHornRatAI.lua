--@ BeginProperty
--@ SyncDirection=All
boolean IsFoundPlayer = "false"
--@ EndProperty

--@ BeginProperty
--@ SyncDirection=All
Entity PlayerEntity = "nil"
--@ EndProperty

--@ BeginProperty
--@ SyncDirection=All
number InitialMovementSpeed = "1"
--@ EndProperty

--@ BeginProperty
--@ SyncDirection=All
number ChaseMovementSpeed = "2"
--@ EndProperty

--@ BeginProperty
--@ SyncDirection=All
boolean IsAttacking = "false"
--@ EndProperty

--@ BeginMethod
--@ MethodExecSpace=All
void OnBeginPlay()
{
self.Entity.StateComponent:AddState("ATTACK")
self:EffectLoad()
}
--@ EndMethod

--@ BeginMethod
--@ MethodExecSpace=ServerOnly
void OnUpdate(number delta)
{
if self.Entity.Monster.IsDead then
	return
end
if self.IsAttacking and not self.Entity.Monster.IsDead then
	self.Entity.StateComponent:ChangeState("ATTACK")
elseif self.IsFoundPlayer then
	self:ChasePlayer()
	local playerX = self.PlayerEntity.TransformComponent.Position.x 
	local selfX = self.Entity.TransformComponent.Position.x

	if math.abs(playerX - selfX) < 2 then
			
		self.Entity.MovementComponent:Stop()
		self.IsAttacking = true
		_SoundService:PlaySound("9f090d01e8fc4ec99b9741557fcae61c",0.6)
		wait(1)
		self.Entity.DevilHornRatAttack:AttackBreath()
		wait(0.1)
		self.Entity.DevilHornRatAttack:AttackBreath()
		wait(0.1)
		self.Entity.DevilHornRatAttack:AttackBreath()
		wait(0.1)
		self.Entity.DevilHornRatAttack:AttackBreath()
		wait(0.1)
		self.Entity.DevilHornRatAttack:AttackBreath()
		wait(0.1)
		self.Entity.DevilHornRatAttack:AttackBreath()
		wait(0.1)
		self.Entity.DevilHornRatAttack:AttackBreath()
		wait(0.1)
		self.Entity.DevilHornRatAttack:AttackBreath()
		wait(0.1)
		self.Entity.DevilHornRatAttack:AttackBreath()
		wait(0.1)
		wait(0.4)
		self.IsAttacking = false
	end
else
	self:Idle()
end
}
--@ EndMethod

--@ BeginMethod
--@ MethodExecSpace=All
void ChasePlayer(Entity player)
{
if self.Entity.Monster.IsDead or not self.Entity.TransformComponent then
	return
end
local PlayerPosition = self.PlayerEntity.TransformComponent.Position
local MonsterPosition = self.Entity.TransformComponent.Position
self.Entity.AIWanderComponent.Enable = false
self.Entity.StateComponent:ChangeState("MOVE")

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

--@ BeginMethod
--@ MethodExecSpace=All
void EffectLoad()
{
local effectArray = {
"3738eadcf4c343f3b2b43f526824ef45",
"5c9c3403a434464191c708fd470a79cb",
"71feea7d90644d52ad622a51b61da117",
"fdf832ff96eb416e8502d1cb4ca6720f"
}
for i=1,#effectArray do
	_EffectService:PlayEffect(effectArray[i],
	self.Entity,
	Vector3(-1000,-1000,-1000),
	0,
	Vector3(0.01,0.01,0.01),
	false)
end
}
--@ EndMethod

--@ BeginEntityEventHandler
--@ Scope=Server
--@ Target=self
--@ EventName=TriggerEnterEvent
HandleTriggerEnterEvent
{
-- Parameters
local TriggerBodyEntity = event.TriggerBodyEntity
--------------------------------------------------------
if TriggerBodyEntity.TagComponent.Tags[1] == "player" then
	self.PlayerEntity = TriggerBodyEntity
	self.Entity.MovementComponent.InputSpeed = 2.5
	self.IsFoundPlayer = true
	--print("Chase")
end
}
--@ EndEntityEventHandler

--@ BeginEntityEventHandler
--@ Scope=Server
--@ Target=self
--@ EventName=TriggerLeaveEvent
HandleTriggerLeaveEvent
{
-- Parameters
local TriggerBodyEntity = event.TriggerBodyEntity
--------------------------------------------------------
if TriggerBodyEntity.TagComponent.Tags[1] == "player" then
	self.Entity.MovementComponent.InputSpeed = 1
	self.IsFoundPlayer = false
	--print("lost")
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
local tagNum = #TriggerBodyEntity.TagComponent.Tags
local i = 1
while tagNum >= i do
	if TriggerBodyEntity.TagComponent.Tags[i] == "player" then
		self.PlayerEntity = TriggerBodyEntity
		self.Entity.MovementComponent.InputSpeed = 2.5
		self.IsFoundPlayer = true
	end
	i=i+1
end
}
--@ EndEntityEventHandler

