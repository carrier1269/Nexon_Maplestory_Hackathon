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
number ChaseMovementSpeed = "1.5"
--@ EndProperty

--@ BeginProperty
--@ SyncDirection=All
boolean IsAttacking = "false"
--@ EndProperty

--@ BeginMethod
--@ MethodExecSpace=ServerOnly
void OnUpdate(number delta)
{
if self.IsAttacking and not self.Entity.Monster.IsDead then
	self.Entity.StateComponent:ChangeState("ATTACK")
elseif self.IsFoundPlayer then
	self:ChasePlayer()
	local playerX = self.PlayerEntity.TransformComponent.Position.x 
	local selfX = self.Entity.TransformComponent.Position.x

	if math.abs(playerX - selfX) < 2.5 then
		
		self.Entity.MovementComponent:Stop()
		self.Entity.MovementComponent.InputSpeed = 5
		local direction = self.Entity.TransformComponent.Scale.x
		self.IsAttacking = true
		if not self.Entity.Monster.IsDead then
			_SoundService:PlaySound("e3b680e6eba149c4acc5e700c3087b74",0.5)
		end
		
		wait(1)
		self.Entity.MovementComponent:MoveToDirection(Vector2(-direction,0),0.5)
		for i = 1,11 do
			self.Entity.BlackFeatherAttack:AttackSpin()
			wait(0.1)
		end
		
		wait(0.1)
		self.IsAttacking = false
	end
else
	self:Idle()
end
}
--@ EndMethod

--@ BeginMethod
--@ MethodExecSpace=All
void ChasePlayer()
{
if self.Entity.Monster.IsDead then
	return
end
local PlayerPosition = self.PlayerEntity.TransformComponent.Position
local MonsterPosition = self.Entity.TransformComponent.Position
self.Entity.AIWanderComponent.Enable = false
self.Entity.StateComponent:ChangeState("MOVE")
self.Entity.MovementComponent.InputSpeed = self.ChaseMovementSpeed

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
self.Entity.MovementComponent.InputSpeed = self.InitialMovementSpeed
if self.Entity.MovementComponent:IsFaceLeft() then
	self.Entity.TransformComponent.Scale = Vector3(1,1,1)
else
	self.Entity.TransformComponent.Scale = Vector3(-1,1,1)
end

}
--@ EndMethod

--@ BeginMethod
--@ MethodExecSpace=ServerOnly
void OnBeginPlay()
{
--self:EffectLoad()
}
--@ EndMethod

--@ BeginMethod
--@ MethodExecSpace=All
void EffectLoad()
{
local effectArray = {
"a728c41b57694f50a0bdf8ca1219acb9",
"fa116d46bc8b44a1aa6146da4ea3e762",
"4646210303024fb6a671fa59089fa727",
"8427b9ee8d3541dcbf3f149a2bd4cd36",
"cd6e06b5dc8f4e2eab82ea6ec7d7033c",
"ae2ebd13bfc04c518831b4574bef81bd",
"ba1872fe7b014d04a65685fb6ecfb783",
"5e14c16ec32346b0851691839a31def8",
"1aadb73ddd8f4f1a9d9ca46c7846353e"
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
--@ EventName=TriggerLeaveEvent
HandleTriggerLeaveEvent
{
-- Parameters
local TriggerBodyEntity = event.TriggerBodyEntity
--------------------------------------------------------
local tagNum = #TriggerBodyEntity.TagComponent.Tags
local i = 1
while tagNum >= i do
	if TriggerBodyEntity.TagComponent.Tags[i] == "player" then
		
		self.PlayerEntity = TriggerBodyEntity
		self.IsFoundPlayer = false
	end
	i = i+1
end
}
--@ EndEntityEventHandler

--@ BeginEntityEventHandler
--@ Scope=Server
--@ Target=self
--@ EventName=TriggerEnterEvent
HandleTriggerEnterEvent
{
-- Parameters
local TriggerBodyEntity = event.TriggerBodyEntity
--------------------------------------------------------
local tagNum = #TriggerBodyEntity.TagComponent.Tags
local i = 1
while tagNum >= i do
	if TriggerBodyEntity.TagComponent.Tags[i] == "player" then
		self.PlayerEntity = TriggerBodyEntity
		self.IsFoundPlayer = true
	end
	i=i+1
end
}
--@ EndEntityEventHandler

--@ BeginEntityEventHandler
--@ Scope=Server
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
		self.IsFoundPlayer = true
	end
	i=i+1
end
}
--@ EndEntityEventHandler

