--@ BeginProperty
--@ SyncDirection=None
table<string,string> MannequinItemInfo = "string|string"
--@ EndProperty

--@ BeginProperty
--@ SyncDirection=None
string MannequinFaceRuid = ""8c61cb446a674728b9457b17869fc487""
--@ EndProperty

--@ BeginMethod
--@ MethodExecSpace=ClientOnly
void OnBeginPlay()
{
-- 마네킹 추가 방법 : Model_MannequinEntity 모델을 배치하고 원하는 의상을 입힌 다음 플레이 해보세요. 

table.clear(self.MannequinItemInfo)

wait(1)

local mannequinCostume = self.Entity.CostumeManagerComponent
mannequinCostume.UseCustomEquipOnly = true
mannequinCostume.CustomFaceEquip = self.MannequinFaceRuid

wait(1)

local stringCostumeCategories = _GameLogic:GetStringCostumeCategories()
local avatarItemCategories = _GameUILogic:GetAvatarItemCategoriesForUi()

for i , category in pairs(stringCostumeCategories) do
	
	local ruid = mannequinCostume:GetEquip(avatarItemCategories[category])
	self.MannequinItemInfo[category] = ruid
end
}
--@ EndMethod

--@ BeginMethod
--@ MethodExecSpace=ClientOnly
void DeliverItemInfo()
{
local player = _UserService.LocalPlayer
if player.MyAvatarCostumeManager.EnablePreview then 
	_UIToast:ShowMessage("지금은 다른 일을 하고 있어요.")
	return 
end

_UIToast:ShowMessage("미리보기 모드 입니다.")

local uiSelectItem = _GameLogic.UiSelectItem
uiSelectItem:GetItemInfo(self.MannequinItemInfo)
}
--@ EndMethod

--@ BeginEntityEventHandler
--@ Scope=Client
--@ Target=self
--@ EventName=InteractionEvent
HandleInteractionEvent
{
-- Parameters
local InteractionEntity = event.InteractionEntity
--------------------------------------------------------
log("E pressed")
self:DeliverItemInfo()
}
--@ EndEntityEventHandler

