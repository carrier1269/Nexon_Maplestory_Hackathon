--@ BeginProperty
--@ SyncDirection=None
table Messages = "{}"
--@ EndProperty

--@ BeginProperty
--@ SyncDirection=None
number duration = "15"
--@ EndProperty

--@ BeginMethod
--@ MethodExecSpace=ClientOnly
void OnBeginPlay()
{
table.insert(self.Messages,"탈의실에서 입고 있는 코스튬을 벗을 수 있어요.")
table.insert(self.Messages,"B1층에 성형외과, 피부 관리실, 헤어샵이 있어요.")
table.insert(self.Messages,"월드를 리메이크해서 나만의 패션샵 월드를 꾸며보세요!")
table.insert(self.Messages,"월드를 리메이크해서 직접 제작한 코스튬을 다른 친구들과 공유해보세요.")

local showMessage = function()
	local index = _UtilLogic:RandomIntegerRange(1,#self.Messages)
	self.Entity.TextComponent.Text = self.Messages[index]	
end

_TimerService:SetTimerRepeat(showMessage,15)

}
--@ EndMethod

