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
Entity EmptyText = "nil"
--@ EndProperty

--@ BeginProperty
--@ SyncDirection=None
table<string,string> ItemInfo = "string|string"
--@ EndProperty

--@ BeginProperty
--@ SyncDirection=None
number ItemCount = "0"
--@ EndProperty

--@ BeginProperty
--@ SyncDirection=None
table<Entity> SlotClones = "Entity"
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
self.Entity.Parent.UIGroupComponent.DefaultShow = false
self.Entity.Parent.Enable = false

self.IsSelectedAllItem = false

local path = self.Entity.Path
self.ItemScrollView = _EntityService:GetEntityByPath(path.."/ItemScrollView")
self.ItemSlotOrigin = _EntityService:GetEntityByPath(path.."/ItemScrollView/ItemSlot")
self.ItemSlotOrigin.Enable = false

--self.EmptyText = _EntityService:GetEntityByPath(path.."/EmptyText") 
--self.EmptyText.Enable = false

--self.SelectAllButton = _EntityService:GetEntityByPath(path.."/SelectAllButton") 
--self:SwitchSelectAllButonState(false)

self.SaveButton = _EntityService:GetEntityByPath(path.."/SaveButton")
self.SaveButton.ButtonComponent.Enable = false
self:SetSaveButtonState(false)

table.clear(self.SlotClones)
table.clear(self.ItemInfo)
table.clear(self.SelectedItems)
}
--@ EndMethod

--@ BeginMethod
--@ MethodExecSpace=ClientOnly
void GetItemInfo(table<string,string> itemInfo)
{
local slotCount = 0

for k , v in pairs(itemInfo) do
	self.ItemInfo[k]=v
	slotCount = slotCount + 1
end

self.ItemCount = slotCount

--if slotCount <= 0 then
--	self.EmptyText.Enable = true
--	
--else	
--	self.EmptyText.Enable = false
--end

for i = 1 , slotCount do 
	local slotClone = _SpawnService:SpawnByEntity(self.ItemSlotOrigin,"ItemSlot"..tostring(i),Vector3(0,0,0),self.ItemScrollView,true)
	table.insert(self.SlotClones,slotClone)
end

local slotNum = 1
for key , ruid in pairs(self.ItemInfo) do
	if self.SlotClones[slotNum] ~= nil then
		self.SlotClones[slotNum].SelectItemButtonComponent:SetItemSlotInfo(key,ruid)	
		slotNum = slotNum + 1
	else
		break
	end
end
self:SetSaveButtonState(false)
self.SaveButton.ButtonComponent.Enable = true
_GameUILogic:OpneUI(self.Entity)
}
--@ EndMethod

--@ BeginMethod
--@ MethodExecSpace=ClientOnly
void ClearUiInfo()
{
_GameUILogic:CloseUI(self.Entity)

for k , slot in pairs(self.SlotClones) do
	slot:Destroy()
end

table.clear(self.SlotClones)
table.clear(self.ItemInfo)
table.clear(self.SelectedItems)

--self:SwitchSelectAllButonState(false)
self.SaveButton.ButtonComponent.Enable = false
self:SetSaveButtonState(false)
}
--@ EndMethod

--@ BeginMethod
--@ MethodExecSpace=ClientOnly
void SelectItem(string category,string ruid)
{
if ruid == nil then return end

self.SelectedItems[category] = ruid

local selectedItemCount = 0
for k , v in pairs(self.SelectedItems) do
	selectedItemCount = selectedItemCount + 1
end

if selectedItemCount <= 0 then
	self:SetSaveButtonState(false)

else
	self:SetSaveButtonState(true)
end

if self.ItemCount == 0 then return end

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

if self.ItemCount == 0 then return end

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

for i , slot in pairs(self.SlotClones) do
	slot.SelectItemButtonComponent:ChangeButtonState(true)
end
self:SwitchSelectAllButonState(true)
}
--@ EndMethod

--@ BeginMethod
--@ MethodExecSpace=ClientOnly
void UnselectAllItem()
{
if self.ItemCount == 0 then return end

for i , slot in pairs(self.SlotClones) do
	slot.SelectItemButtonComponent:ChangeButtonState(false)
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
void SetSaveButtonState(boolean enable)
{
if enable then
	self.SaveButton.TextComponent.Text = "결정했어요!" 
	self.SaveButton.TextComponent.FontSize = 38
	self.SaveButton.TextComponent.FontColor = Color.FromHexCode("#f0b348")	-- yellow
else
	self.SaveButton.TextComponent.Text = "입고 싶은 아이템을 선택해서\n미리보기 하세요."
	self.SaveButton.TextComponent.FontSize = 26
	self.SaveButton.TextComponent.FontColor = Color.FromHexCode("#c8c8c8")	-- gray
end	
}
--@ EndMethod

--@ BeginMethod
--@ MethodExecSpace=ClientOnly
void AskChangeCostumeOrNot(table selectedItems)
{
local itemCount = 0

for k , v in pairs(selectedItems) do
	itemCount = itemCount + 1
end

if itemCount == 0 then
	_UIToast:ShowMessage("선택한 아이템이 없어요.")
	
else
	
	local message = string.format("%d",itemCount).."개의 아이템을 선택했어요.\n선택한 아이템을 입을래요?"

	local onOK = function()
		_GameLogic.UiSelectItem:ClearUiInfo()
		
		local player = _UserService.LocalPlayer
		player.MyAvatarCostumeManager:GetCurrentCostume()
	end
	
	local onCancel = function() 
		
	end	
	
	_UIPopup:Open(message,onOK,onCancel)
end
}
--@ EndMethod

--@ BeginEntityEventHandler
--@ Scope=Client
--@ Target=entity:3268ae8b-f0ec-41f9-af22-ec9b637e43be
--@ EventName=ButtonClickEvent
HandleButtonClickEvent3
{
-- Parameters
local Entity = event.Entity
--------------------------------------------------------
if self.IsSelectedAllItem then
	self:UnselectAllItem()

else	
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
if not self.Entity.Parent.Enable then return end	

local player = _UserService.LocalPlayer
if not isvalid(player) then return end

if key == KeyboardKey.Escape then

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

	if not isvalid(player) then return end
	if player.MyAvatarCostumeManager.EnablePreview then 
		self:AskChangeCostumeOrNot(self.SelectedItems)	
		return	
	end	
	
elseif key == KeyboardKey.KeypadEnter then

	if not isvalid(player) then return end
	if player.MyAvatarCostumeManager.EnablePreview then 
		self:AskChangeCostumeOrNot(self.SelectedItems)		
		return
	end	

end
}
--@ EndEntityEventHandler

