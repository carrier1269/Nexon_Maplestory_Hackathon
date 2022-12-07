--@ BeginProperty
--@ SyncDirection=None
boolean IsSelected = "false"
--@ EndProperty

--@ BeginProperty
--@ SyncDirection=None
Entity SelectPanel = "08e300a8-bba0-4313-b5a3-33c9a7f174cf"
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
}
--@ EndMethod

--@ BeginMethod
--@ MethodExecSpace=ClientOnly
void SetItemSlotInfo(string category,string ruid)
{
self.IsSelected = false 
self.Category = category
self.RUID = ruid

self.IsSelectedText.Enable = false
self.PlzSelecText.Enable = true

local categoryText = self.Entity:GetChildByName("CategoryText")
local thumbnailImage = self.Entity:GetChildByName("ThumbnailImage")

thumbnailImage.SpriteGUIRendererComponent.ImageRUID = "thumbnail://"..tostring(ruid)

categoryText.TextComponent.Text = _GameUILogic:GetCategoryUiText(category)
	
}
--@ EndMethod

--@ BeginMethod
--@ MethodExecSpace=ClientOnly
void ChangeButtonState(boolean nextState)
{
local player = _UserService.LocalPlayer

if nextState then
	self.IsSelected = true
	self.SelectPanel.UISelectItem:SelectItem(self.Category,self.RUID)
	player.MyAvatarCostumeManager:PreviewCostume(self.Category,self.RUID)
	self.Entity.SpriteGUIRendererComponent.Color = self.SelectedColor
	self.IsSelectedText.Enable = true
	self.PlzSelecText.Enable = false	

else
	self.IsSelected = false
	self.SelectPanel.UISelectItem:UnselectItem(self.Category)
	player.MyAvatarCostumeManager:CanclePreviewCostume(self.Category)
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

