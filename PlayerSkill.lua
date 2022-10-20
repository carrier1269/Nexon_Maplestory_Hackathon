--@ BeginProperty
--@ SyncDirection=None
number SkillCooldown = "0"
--@ EndProperty

--@ BeginProperty
--@ SyncDirection=None
number LastSkillUseTime = "0"
--@ EndProperty

--@ BeginProperty
--@ SyncDirection=None
Component SkillButtonImage = "8705e648-c52a-4744-b52e-6ed7b80acc75:25"
--@ EndProperty

--@ BeginMethod
--@ MethodExecSpace=All
void OnBeginPlay()
{
if self.Entity ~= _UserService.LocalPlayer then
	return
end

local conditionFunc = function()
	if self.Entity.StateComponent.CurrentStateName == "DEAD" then
		return false
	end
	local current = _UtilLogic.ElapsedSeconds
	if self.LastSkillUseTime + self.SkillCooldown < current then
		return true
	end
	return false
end

self.Entity.PlayerControllerComponent:SetActionKey(KeyboardKey.Q, "Skill", conditionFunc)
}
--@ EndMethod

--@ BeginMethod
--@ MethodExecSpace=Server
void UseSkill()
{
-- Effect
local position = self.Entity.TransformComponent.Position
position = Vector2(position.x, position.y)

local playerController = self.Entity.PlayerControllerComponent
local lookDirectionX = playerController.LookDirectionX
position = position + Vector2(lookDirectionX * 0.2, 0)

local length = 0

local flipX = false
if lookDirectionX == 1 then flipX = true end
local args = { ["FlipX"] = flipX }
	
_EffectService:PlayEffect("a0ed97b38ce04e0ba8c2b6141a859d31",
self.Entity, position, 0, Vector2(1.5, 1.5), length, args)
self:PlaySkillUseSound()

local attackPosition = position + Vector2(lookDirectionX * 1.75, 0)
-- Delay Attack
local delayAttack = function()
	local size = Vector2(3.5, 1.5) 
	local defenderComponents = self:AttackFrom(size, attackPosition, nil)
	
	for i, component in pairs(defenderComponents) do
		local defenderEntity = component.Entity
		local position = defenderEntity.TransformComponent.Position
		position = Vector2(position.x, position.y)
		_EffectService:PlayEffect("2e438afe70924bc1a6ae02d5f8a97444",
defenderEntity, position, 0, Vector2(1, 1))
		
		self:PlaySkillHitSound()
	end
end

_TimerService:SetTimerOnce(delayAttack, 0.6)
}
--@ EndMethod

--@ BeginMethod
--@ MethodExecSpace=All
override int GetDisplayHitCount(string attackInfo)
{
return _UtilLogic:RandomIntegerRange(3, 6)
}
--@ EndMethod

--@ BeginMethod
--@ MethodExecSpace=All
override int CalcDamage(Entity attacker,Entity defender,string attackInfo)
{
return 100
}
--@ EndMethod

--@ BeginMethod
--@ MethodExecSpace=Client
void PlaySkillUseSound()
{
_SoundService:PlaySound("afbb81b51fed47eaaee26cc403d59ccf")
}
--@ EndMethod

--@ BeginMethod
--@ MethodExecSpace=Client
void PlaySkillHitSound()
{
_SoundService:PlaySound("ca35cb7d0652411395a5bb90a5beecd3")
}
--@ EndMethod

--@ BeginMethod
--@ MethodExecSpace=ClientOnly
void OnUpdate(number delta)
{
if self.SkillButtonImage then
	local ratio = (_UtilLogic.ElapsedSeconds - self.LastSkillUseTime) / self.SkillCooldown
	ratio = math.min(ratio, 1)
	self.SkillButtonImage.FillAmount = ratio
end
}
--@ EndMethod

--@ BeginEntityEventHandler
--@ Scope=All
--@ Target=self
--@ EventName=PlayerActionEvent
HandlePlayerActionEvent
{
-- Parameters
local ActionName = event.ActionName
local PlayerEntity = event.PlayerEntity
--------------------------------------------------------
if ActionName == "Skill" then
	self.LastSkillUseTime = _UtilLogic.ElapsedSeconds
	self.Entity.StateComponent:ChangeState("ATTACK", true)
	self:UseSkill()
end
}
--@ EndEntityEventHandler

