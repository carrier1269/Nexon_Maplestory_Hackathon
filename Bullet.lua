--@ BeginProperty
--@ SyncDirection=All
Vector2 Direction = "Vector2(0,0)"
--@ EndProperty

--@ BeginProperty
--@ SyncDirection=All
number Power = "0"
--@ EndProperty

--@ BeginProperty
--@ SyncDirection=All
number Time = "0"
--@ EndProperty

--@ BeginProperty
--@ SyncDirection=All
Vector3 PrevPosition = "Vector3(0,0,0)"
--@ EndProperty

--@ BeginProperty
--@ SyncDirection=All
boolean PosChecker = "false"
--@ EndProperty

--@ BeginProperty
--@ SyncDirection=All
number RepeatCallbackID = "0"
--@ EndProperty

--@ BeginMethod
--@ MethodExecSpace=ServerOnly
void OnBeginPlay()
{
wait(0.05)
self.Entity.RigidbodyComponent:SetForce(self.Direction * self.Power)
self.PrevPosition = self.Entity.TransformComponent.Position
local callback = function()
	
	self.Entity:Destroy()
end
local TimerCallback = function()
	if not self.Entity.Enable then
		return
	end
	self.PosChecker = true
end
_TimerService:SetTimerOnce(callback,self.Time)
local tt =_TimerService:SetTimerRepeat(TimerCallback,0.05,0.05)
self.RepeatCallbackID = tt
}
--@ EndMethod

--@ BeginMethod
--@ MethodExecSpace=ServerOnly
void OnUpdate(number delta)
{
if not self.Entity then
	return
end
if self.Entity.RigidbodyComponent.Gravity <= 0 then
	self.Entity.RigidbodyComponent:SetForce(self.Direction * self.Power)
end
if not self.Entity.TransformComponent then
	return
end

--위치 체크하는데 딜레이 줘서 정확하게 체크하게함
if not self.PosChecker then
	return
end

self.PosChecker = false
--x나 y좌표가 변하다가 안변하게되면 부딪힌걸로 확인
if math.abs(self.Direction.x) > 0.001 and math.abs(self.PrevPosition.x - self.Entity.TransformComponent.Position.x) < 0.002 then
	--wait(0.2)
	self.Entity.BulletAttack.Enable = false
	self.Entity.Visible = false
	_TimerService:ClearTimer(math.tointeger(self.RepeatCallbackID))
elseif math.abs(self.Direction.y) > 0.001 and math.abs(self.PrevPosition.y - self.Entity.TransformComponent.Position.y) < 0.002 then
	--wait(0.2)
	self.Entity.BulletAttack.Enable = false
	self.Entity.Visible = false
	_TimerService:ClearTimer(math.tointeger(self.RepeatCallbackID))
end
self.PrevPosition = self.Entity.TransformComponent.Position
}
--@ EndMethod

