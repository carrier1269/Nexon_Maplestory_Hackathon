--@ BeginProperty
--@ SyncDirection=None
number damage = "200"
--@ EndProperty

--@ BeginMethod
--@ MethodExecSpace=All
void PlayerDead()
{

_UserService.LocalPlayer.MovementComponent.InputSpeed = 0
_UserService.LocalPlayer.MovementComponent.JumpForce = 0
}
--@ EndMethod

--@ BeginMethod
--@ MethodExecSpace=All
void PlayerAlive()
{
_UserService.LocalPlayer.MovementComponent.InputSpeed = 1.2
_UserService.LocalPlayer.MovementComponent.JumpForce = 1
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
if TriggerBodyEntity.Id == _UserService.LocalPlayer.Id then
	if TriggerBodyEntity.Take_Damage_Component.Take_Damage_Period == true and TriggerBodyEntity.PlayerComponent.Hp - self.damage <=0 then
	TriggerBodyEntity.Take_Damage_Component.Take_Damage_Period = false
	TriggerBodyEntity.StateComponent:ChangeState("DEAD")
	self:PlayerDead()
	wait(5)
	TriggerBodyEntity.StateComponent:ChangeState("IDLE")
	TriggerBodyEntity.MovementComponent:SetPosition(Vector2(3.4,-4))
	TriggerBodyEntity.PlayerComponent.Hp = TriggerBodyEntity.PlayerComponent.MaxHp
	self:PlayerAlive()
	elseif TriggerBodyEntity.Take_Damage_Component.Take_Damage_Period == true then
	TriggerBodyEntity.Take_Damage_Component.Take_Damage_Period = false
	TriggerBodyEntity.PlayerComponent.Hp = TriggerBodyEntity.PlayerComponent.Hp - self.damage
	TriggerBodyEntity.RigidbodyComponent:SetForce(Vector2(-2 * _UserService.LocalPlayer.PlayerControllerComponent.LookDirectionX, 4))
	wait(0.75)
	TriggerBodyEntity.Take_Damage_Component.Take_Damage_Period = true
	end
end

}
--@ EndEntityEventHandler

