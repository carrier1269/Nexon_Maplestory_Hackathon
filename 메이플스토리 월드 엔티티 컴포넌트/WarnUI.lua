--@ BeginProperty
--@ SyncDirection=None
table Messages = "{}"
--@ EndProperty

--@ BeginProperty
--@ SyncDirection=None
number duration = "0"
--@ EndProperty

--@ BeginMethod
--@ MethodExecSpace=ClientOnly
void OnBeginPlay()
{
table.insert(self.Messages, "※보스 몬스터 처치 후 칩은 하나만 획득해야 합니다※")
table.insert(self.Messages, "※두 개 이상 획득 시 보스로비 우측 끝 나무상자에 충돌하세요※")

local showMessage = function()
	local index = _UtilLogic:RandomIntegerRange(1, #self.Messages)
	self.Entity.TextComponent.Text = self.Messages[index]
end
_TimerService:SetTimerRepeat(showMessage, 4)
}
--@ EndMethod
