--@ BeginProperty
--@ SyncDirection=None
Component message = "7af9e538-1713-49f7-a83e-711c0f4b4a3c:52"
--@ EndProperty

--@ BeginProperty
--@ SyncDirection=None
Entity toastGroup = "0bc398f9-29cb-4d89-a78d-f24742b117e8"
--@ EndProperty

--@ BeginProperty
--@ SyncDirection=None
number duration = "2"
--@ EndProperty

--@ BeginProperty
--@ SyncDirection=None
number tweenDuration = "0.1"
--@ EndProperty

--@ BeginProperty
--@ SyncDirection=None
number tweenEventId = "0"
--@ EndProperty

--@ BeginProperty
--@ SyncDirection=None
boolean isTweenPlaying = "false"
--@ EndProperty

--@ BeginProperty
--@ SyncDirection=None
boolean inited = "false"
--@ EndProperty

--@ BeginProperty
--@ SyncDirection=None
number offset = "0"
--@ EndProperty

--@ BeginMethod
--@ MethodExecSpace=Client
void ShowMessage(string message)
{
if self.inited == false then
	self.inited = true
	self.offset = -self.message.Entity.UITransformComponent.anchoredPosition.y
end
self.message.Text = message
self:StartTween()
}
--@ EndMethod

--@ BeginMethod
--@ MethodExecSpace=All
void StartTween()
{
local canvasGroup = self.message.Entity.CanvasGroupComponent
local transform = self.message.Entity.UITransformComponent
if self.tweenEventId > 0 then
	_TimerService:ClearTimer(self.tweenEventId)
	self.tweenEventId = 0
else
	canvasGroup.GroupAlpha = 0
end
self.toastGroup.Enable = true
local time = 0

local preTime = _UtilLogic.ElapsedSeconds

local tween = function()
	local delta = _UtilLogic.ElapsedSeconds - preTime
	time = time + delta
	preTime = _UtilLogic.ElapsedSeconds

	local alpha = canvasGroup.GroupAlpha 
	if time >= (self.duration + self.tweenDuration) then		
		self.toastGroup.Enable = false
		_TimerService:ClearTimer(self.tweenEventId)
		self.tweenEventId = 0
		alpha = 0
	else
		if time > self.duration then			
			alpha = alpha - delta / self.tweenDuration
		else
			alpha = alpha + delta / self.tweenDuration
		end			
	end	
	alpha = math.min(1,math.max(alpha,0))
	
	canvasGroup.GroupAlpha = alpha
	local tweenValue = _MODTweenLogic.Ease(EaseType.SineEaseIn,0,1,alpha,1)	
	transform.anchoredPosition = Vector2(0,-self.offset * tweenValue)
end

self.tweenEventId = _TimerService:SetTimerRepeat(tween,1/60)


}
--@ EndMethod

