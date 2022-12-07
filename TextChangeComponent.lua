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
table.insert(self.Messages, "Z키를 사용하여 NPC와 대화할 수 있습니다.")
table.insert(self.Messages, "Alt키를 사용하여 점프할 수 있습니다.")
table.insert(self.Messages, "Alt키를 두 번 입력하여 더블 점프 할 수 있습니다.")
table.insert(self.Messages, "Ctrl키를 사용하여 몬스터를 공격할 수 있습니다.")
table.insert(self.Messages, "왼쪽 Shift키를 사용하여 물약을 사용할 수 있습니다.")
table.insert(self.Messages, "모든 보스 몬스터는 15초마다 재생성됩니다.")
table.insert(self.Messages, "탈리가 있는 맵에서 ToDo List를 갱신할 수 있습니다.")

local showMessage = function()
	local index = _UtilLogic:RandomIntegerRange(1,#self.Messages)
	self.Entity.TextComponent.Text = self.Messages[index]
end
_TimerService:SetTimerRepeat(showMessage, 5)
}
--@ EndMethod