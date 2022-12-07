--@ BeginProperty
--@ SyncDirection=None
boolean IsSelected = "false"
--@ EndProperty

--@ BeginProperty
--@ SyncDirection=None
Entity SelectPanel = "2902a194-ab2b-42db-923e-4c929472718d"
--@ EndProperty

--@ BeginProperty
--@ SyncDirection=None
string Category = """"
--@ EndProperty

--@ BeginProperty
--@ SyncDirection=None
string RUID = """"
--@ EndProperty

--@ BeginProperty
--@ SyncDirection=None
Color SelectedColor = "Color(0,0,0,0)"
--@ EndProperty

--@ BeginProperty
--@ SyncDirection=None
Entity IsSelectedText = "nil"
--@ EndProperty

--@ BeginProperty
--@ SyncDirection=None
Entity PlzSelecText = "nil"
--@ EndProperty

--@ BeginProperty
--@ SyncDirection=None
Entity ThumbnailImage = "nil"
--@ EndProperty

--@ BeginMethod
--@ MethodExecSpace=ClientOnly
void OnBeginPlay()
{
self.IsSelected = false

self.SelectedColor = Color(255/255,236/255,0,1)

self.IsSelectedText = self.Entity:GetChildByName("IsSelectedText")
self.IsSelectedText.Enable = false
self.PlzSelecText = self.Entity:GetChildByName("PlzSelectText")
self.PlzSelecText.Enable = false
self.ThumbnailImage = self.Entity:GetChildByName("ThumbnailImange")
}
--@ EndMethod

--@ BeginMethod
--@ MethodExecSpace=ClientOnly
void SetItemSlotCategory(string category)
{
self.IsSelected = false
self.Category = category 

self.IsSelectedText.Enable = false
self.PlzSelecText.Enable = true

local categoryText = self.Entity:GetChildByName("CategoryText")
categoryText.TextComponent.Text = _GameUILogic:GetCategoryUiText(category)

self.Entity.Enable = false
}
--@ EndMethod

--@ BeginMethod
--@ MethodExecSpace=ClientOnly
void UpdateItemSlot(string ruid)
{
self.RUID = ruid
if _UtilLogic:IsNilorEmptyString(ruid) then
	self.Entity.Enable = false
else	
	self.Entity.Enable = true
end

self.ThumbnailImage.SpriteGUIRendererComponent.ImageRUID = "thumbnail://"..tostring(ruid)
}
--@ EndMethod

--@ BeginMethod
--@ MethodExecSpace=ClientOnly
void ChangeButtonState(boolean nextState)
{
local player = _UserService.LocalPlayer
if nextState then
	if self.RUID == _GameLogic.BasicCoat or self.RUID == _GameLogic.BasicPants then
		_UIToast:ShowMessage("기본 아이템은 벗을 수 없어요.")
		return
	end 	

	self.IsSelected = true
	self.SelectPanel.UIMyItem:SelectItem(self.Category)
	player.MyAvatarCostumeManager:PreviewMyItemRemove(self.Category)
	self.Entity.SpriteGUIRendererComponent.Color = self.SelectedColor
	self.IsSelectedText.Enable = true
	self.PlzSelecText.Enable = false	
	
	if self.Category == "coat" or self.Category == "pants" or self.Category == "longcoat" then
		_UIToast:ShowMessage("옷을 벗으면, 기본 아이템으로 갈아 입어요.")
	end
	
else
	self.IsSelected = false
	self.SelectPanel.UIMyItem:UnselectItem(self.Category)
	player.MyAvatarCostumeManager:CanclePreviewMyItemRemove(self.Category)
	self.Entity.SpriteGUIRendererComponent.Color = Color.white
	self.IsSelectedText.Enable = false
	self.PlzSelecText.Enable = true
end
}
--@ EndMethod

--@ BeginEntityEventHandler
--@ Scope=Client
--@ Target=self
--@ EventName=ButtonClickEvent
HandleButtonClickEvent
{
-- Parameters
local Entity = event.Entity
--------------------------------------------------------
if self.IsSelected then
	self:ChangeButtonState(false)
else
	self:ChangeButtonState(true)
end
}
--@ EndEntityEventHandler

