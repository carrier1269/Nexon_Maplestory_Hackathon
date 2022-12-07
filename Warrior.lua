--@ BeginProperty
--@ SyncDirection=All
boolean JumpState = "false"
--@ EndProperty

--@ BeginProperty
--@ SyncDirection=All
boolean DoubleJump = "true"
--@ EndProperty

--@ BeginProperty
--@ SyncDirection=None
boolean MyEnable = "true"
--@ EndProperty

--@ BeginEntityEventHandler
--@ Scope=All
--@ Target=service:InputService
--@ EventName=KeyDownEvent
HandleKeyDownEvent
{
-- Parameters
local key = event.key
--------------------------------------------------------
if self.MyEnable == true then
	if key == KeyboardKey.LeftAlt and self.JumpState == false then
		wait(0.1)
		self.JumpState = true
	elseif key == KeyboardKey.LeftAlt and self.JumpState == true and self.DoubleJump == true then
		self.DoubleJump = false
		self.Entity.RigidbodyComponent:SetForce(Vector2(4 * self.Entity.PlayerControllerComponent.LookDirectionX, 4))
	end
end

}
--@ EndEntityEventHandler

--@ BeginEntityEventHandler
--@ Scope=All
--@ Target=self
--@ EventName=FootholdCollisionEvent
HandleFootholdCollisionEvent
{
-- Parameters
local FootholdNormal = event.FootholdNormal
local ImpactDir = event.ImpactDir
local ImpactForce = event.ImpactForce
local ReflectDir = event.ReflectDir
local Rigidbody = event.Rigidbody
--------------------------------------------------------
if self.MyEnable == true then
	self.DoubleJump = true
	self.JumpState = false
end

}
--@ EndEntityEventHandler

