--@ BeginProperty
--@ SyncDirection=None
Entity ItemSlotOrigin = "nil"
--@ EndProperty

--@ BeginProperty
--@ SyncDirection=None
Entity ItemScrollView = "nil"
--@ EndProperty

--@ BeginProperty
--@ SyncDirection=None
number ItemCount = "0"
--@ EndProperty

--@ BeginProperty
--@ SyncDirection=None
table<string,string> MyItemInfo = "string|string"
--@ EndProperty

--@ BeginProperty
--@ SyncDirection=None
table<string,Entity> MyItemSlot = "string|Entity"
--@ EndProperty

--@ BeginProperty
--@ SyncDirection=None
table SelectedItems = "{}"
--@ EndProperty

--@ BeginProperty
--@ SyncDirection=None
boolean IsSelectedAllItem = "false"
--@ EndProperty

--@ BeginProperty
--@ SyncDirection=None
Entity SelectAllButton = "nil"
--@ EndProperty

--@ BeginProperty
--@ SyncDirection=None
Entity SaveButton = "nil"
--@ EndProperty

--@ BeginMethod
--@ MethodExecSpace=ClientOnly
void OnBeginPlay()
{
self.IsSelectedAllItem = false

local path = self.Entity.Path
self.ItemScrollView = _EntityService:GetEntityByPath(path.."/ItemScrollView")
self.ItemSlotOrigin = _EntityService:GetEntityByPath(path.."/ItemScrollView/ItemSlot")
self.ItemSlotOrigin.Enable = false

self.SelectAllButton = _EntityService:GetEntityByPath(path.."/SelectAllButton") 
self:SwitchSelectAllButonState(false)

self.SaveButton = _EntityService:GetEntityByPath(path.."/SaveButton")  
self.SaveButton.ButtonComponent.Enable = false
self:SetSaveButtonState(false)
}
--@ EndMethod

--@ BeginMethod
--@ MethodExecSpace=ClientOnly
void SetMyItemSlots()
{
table.clear(self.MyItemInfo)
table.clear(self.MyItemSlot)

local stringCostumeCategories = _GameLogic:GetStringCostumeCategories()

self.ItemCount = #stringCostumeCategories

for i = 1 ,  self.ItemCount do
	local category = stringCostumeCategories[i]
	self.MyItemInfo[category] = ""
	
	local slotClone = _SpawnService:SpawnByEntity(self.ItemSlotOrigin,"ItemSlot_"..category,Vector3(0,0,0),self.ItemScrollView,true)
	slotClone.MyItemButtonComponent:SetItemSlotCategory(category)
	
	self.MyItemSlot[category] = slotClone
end
	
}
--@ EndMethod

--@ BeginMethod
--@ MethodExecSpace=ClientOnly
void UpdateMyItem(string category,string ruid)
{
self:SwitchSelectAllButonState(false)

self.MyItemInfo[category] = ruid
local slotEntity = self.MyItemSlot[category]
slotEntity.MyItemButtonComponent:UpdateItemSlot(ruid)

local count = 0
for k , v in pairs (self.MyItemInfo) do
	
	if v ~= "" then
		count = count + 1 
	end
end

self.ItemCount = count
}
--@ EndMethod

--@ BeginMethod
--@ MethodExecSpace=ClientOnly
void ClearUiInfo()
{
_UserService.LocalPlayer:SendEvent(EnableRemoveSwitchEvent(false))
self.SaveButton.ButtonComponent.Enable = false
_GameUILogic:CloseUI(self.Entity)
self:UnselectAllItem()
table.clear(self.SelectedItems)
}
--@ EndMethod

--@ BeginMethod
--@ MethodExecSpace=ClientOnly
void SelectItem(string category)
{
if self.MyItemInfo[category] == "" then return end

local subRUID = ""

if category == "longcoat" then
	self.SelectedItems[category] = subRUID
	self.SelectedItems[category]  = _GameLogic.BasicCoat
	self.SelectedItems[category]  = _GameLogic.BasicPants

else

	if category == "coat" then
		subRUID = _GameLogic.BasicCoat
	
	elseif category == "pants" then		
		subRUID = _GameLogic.BasicPants
	end

	self.SelectedItems[category] = subRUID	
end

local selectedItemCount = 0
for k , v in pairs(self.SelectedItems) do
	selectedItemCount = selectedItemCount + 1
end

if selectedItemCount <= 0 then
	self:SetSaveButtonState(false)

else
	self:SetSaveButtonState(true)
end

if selectedItemCount < self.ItemCount then 
	return 
elseif selectedItemCount >= self.ItemCount then
	self:SwitchSelectAllButonState(true)
end
}
--@ EndMethod

--@ BeginMethod
--@ MethodExecSpace=ClientOnly
void UnselectItem(string category)
{
if self.SelectedItems[category] == nil then return end

local index = 0
for k , v in pairs(self.SelectedItems) do
	
	index = index + 1
	if k == category then
		self.SelectedItems[category] = nil
		break		
	end	
end

local selectedItemCount = 0
for k , v in pairs(self.SelectedItems) do
	selectedItemCount = selectedItemCount + 1
end

if selectedItemCount <= 0 then
	self:SetSaveButtonState(false)

else
	self:SetSaveButtonState(true)
end

if selectedItemCount < self.ItemCount then 
	self:SwitchSelectAllButonState(false) 
end
}
--@ EndMethod

--@ BeginMethod
--@ MethodExecSpace=ClientOnly
void SelectAllItem()
{
if self.ItemCount == 0 then return end

for category , slot in pairs(self.MyItemSlot) do
	slot.MyItemButtonComponent:ChangeButtonState(true)
end
self:SwitchSelectAllButonState(true)
}
--@ EndMethod

--@ BeginMethod
--@ MethodExecSpace=ClientOnly
void UnselectAllItem()
{
if self.ItemCount == 0 then return end

for category , slot in pairs(self.MyItemSlot) do
	slot.MyItemButtonComponent:ChangeButtonState(false)
end
self:SwitchSelectAllButonState(false)
}
--@ EndMethod

--@ BeginMethod
--@ MethodExecSpace=ClientOnly
void SwitchSelectAllButonState(boolean isSelectedAll)
{
if isSelectedAll then
	self.SelectAllButton.TextComponent.Text = "모든 아이템 선택 취소" 
	self.SelectAllButton.TextComponent.FontColor = Color.FromHexCode("#ff5700")	-- orange
else
	self.SelectAllButton.TextComponent.Text = "모든 아이템 선택" 
	self.SelectAllButton.TextComponent.FontColor = Color.FromHexCode("#007c69")	-- green
end	
	
self.IsSelectedAllItem = isSelectedAll
}
--@ EndMethod

--@ BeginMethod
--@ MethodExecSpace=ClientOnly
void AskRemoveCostumeOrNot(table selectedItems)
{
local itemCount = 0
for k , v in pairs(self.SelectedItems) do
	itemCount = itemCount + 1
end

if itemCount == 0 then
	_UIToast:ShowMessage("선택한 아이템이 없어요.")
	
else
	
	local message = string.format("%d",itemCount).."개의 아이템을 선택했어요.\n선택한 아이템을 벗을래요?"

	local onOK = function()		
		
		self:ClearUiInfo()
		
		local player = _UserService.LocalPlayer
		player.MyAvatarCostumeManager:GetCurrentCostume()		
	
	end
	
	local onCancel = function() 
	end	
	
	_UIPopup:Open(message,onOK,onCancel)
end
}
--@ EndMethod

--@ BeginMethod
--@ MethodExecSpace=ClientOnly
void SetSaveButtonState(boolean enable)
{
if enable then
	self.SaveButton.TextComponent.Text = "결정했어요!" 
	self.SaveButton.TextComponent.FontSize = 38
	self.SaveButton.TextComponent.FontColor = Color.FromHexCode("#f0b348")	-- yellow
else
	self.SaveButton.TextComponent.Text = "벗고 싶은 아이템을 선택해서\n미리보기 하세요."
	self.SaveButton.TextComponent.FontSize = 26
	self.SaveButton.TextComponent.FontColor = Color.FromHexCode("#c8c8c8")	-- gray
end	
}
--@ EndMethod

--@ BeginEntityEventHandler
--@ Scope=Client
--@ Target=entity:8803ef83-fd52-4747-8c8e-e56408f08284
--@ EventName=ButtonClickEvent
HandleButtonClickEvent
{
-- Parameters
local Entity = event.Entity
--------------------------------------------------------

if self.IsSelectedAllItem then
	log("버튼이벤트 모두 선택 취소")
	self:UnselectAllItem()

else	
	log("버튼이벤트 모두 선택")
	self:SelectAllItem()
end
}
--@ EndEntityEventHandler

--@ BeginEntityEventHandler
--@ Scope=Client
--@ Target=service:InputService
--@ EventName=KeyDownEvent
HandleKeyDownEvent
{
-- Parameters
local key = event.key
--------------------------------------------------------

local player = _UserService.LocalPlayer
if not isvalid(player) then return end

if key == KeyboardKey.I then

	if not isvalid(player) then return end
	
	if player.MyAvatarCostumeManager.EnablePreview then 
		_UIToast:ShowMessage("지금은 다른 일을 하고 있어요.")
		return 
	end
	
	if not self.Entity.Parent.Enable then		
		self:SetSaveButtonState(false)
		_UserService.LocalPlayer:SendEvent(EnableRemoveSwitchEvent(true))
		_UIToast:ShowMessage("미리보기 모드 입니다.")
		self.SaveButton.ButtonComponent.Enable = true
		_GameUILogic:OpneUI(self.Entity)
	end

elseif key == KeyboardKey.Escape then
	
	if not self.Entity.Parent.Enable then return end	
	if not isvalid(player) then return end
	if not player.MyAvatarCostumeManager.EnablePreview then return end
	
	local popup = _UIPopup.popupGroup
	if popup.Enable == true then
		_UIPopup:OnClickOk()
		return
	end
	
	player.MyAvatarCostumeManager:QuitPreview()
	self:ClearUiInfo()
	
elseif key == KeyboardKey.Return then
	
	if not self.Entity.Parent.Enable then return end	

	if not isvalid(player) then return end
	if player.MyAvatarCostumeManager.EnablePreview then 
		self:AskRemoveCostumeOrNot(self.SelectedItems)	
		return	
	end	
	
elseif key == KeyboardKey.KeypadEnter then
	
	if not self.Entity.Parent.Enable then return end	

	if not isvalid(player) then return end
	if player.MyAvatarCostumeManager.IsPreview then 
		self:AskRemoveCostumeOrNot(self.SelectedItems)	
		return
	end	

end
}
--@ EndEntityEventHandler

