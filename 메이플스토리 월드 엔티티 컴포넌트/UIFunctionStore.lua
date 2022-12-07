--@ BeginProperty
--@ SyncDirection=None
Component TitleText = "cc709206-f4b5-4886-962a-19925458849c:TextComponent"
--@ EndProperty

--@ BeginProperty
--@ SyncDirection=None
Component ChangeButtonText = "92979a44-12d9-4e7e-bba8-e25911aefd91:TextComponent"
--@ EndProperty

--@ BeginProperty
--@ SyncDirection=None
string CurrentFunctionTag = """"
--@ EndProperty

--@ BeginProperty
--@ SyncDirection=None
Entity RandomImage = "e6150741-0b6b-4da8-8595-129f1608e286"
--@ EndProperty

--@ BeginMethod
--@ MethodExecSpace=ClientOnly
void OnBeginPlay()
{
self.CurrentFunctionTag = ""
self.Entity.Parent.UIGroupComponent.DefaultShow = false
self.Entity.Parent.Enable = false
}
--@ EndMethod

--@ BeginMethod
--@ MethodExecSpace=ClientOnly
void GetStoreInfo(string functionTag)
{
self.CurrentFunctionTag = functionTag

if functionTag == "body" then
	self.TitleText.Text = "피부 관리실"
	self.ChangeButtonText.Text = "랜덤 피부색 바꾸기"
	
elseif functionTag == "face" then
	self.TitleText.Text = "얼굴 전문 성형외과"
	self.ChangeButtonText.Text = "랜덤 얼굴 성형하기"
	
elseif functionTag == "hair" then
	self.TitleText.Text = "헤어샵"
	self.ChangeButtonText.Text = "랜덤 헤어 바꾸기" 
	
elseif functionTag == "ear" then
	self.TitleText.Text = "귀 전문 성형외과" 
	self.ChangeButtonText.Text = "랜덤 귀 성형하기"
	
end

_GameUILogic:OpneUI(self.Entity)
}
--@ EndMethod

--@ BeginMethod
--@ MethodExecSpace=ClientOnly
void ChangeAvatarBodyPart()
{
if self.CurrentFunctionTag == "body" then
	_UserService.LocalPlayer.MyAvatarCostumeManager:ChangeAvatarBody()
	
elseif self.CurrentFunctionTag == "face" then
	_UserService.LocalPlayer.MyAvatarCostumeManager:ChangeAvatarFace()
	
elseif self.CurrentFunctionTag == "hair" then
	_UserService.LocalPlayer.MyAvatarCostumeManager:ChangeAvatarHair()
	
elseif self.CurrentFunctionTag == "ear" then
	_UserService.LocalPlayer.MyAvatarCostumeManager:ChangeAvatarEar()

end
}
--@ EndMethod

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
	
	
	if not player.MyAvatarCostumeManager.EnablePreview then return end
	_GameUILogic:CloseUI(self.Entity)
	
elseif key == KeyboardKey.Return then

	if player.MyAvatarCostumeManager.EnablePreview then 
		self:ChangeAvatarBodyPart()
		return	
	end	
	
elseif key == KeyboardKey.KeypadEnter then

	if player.MyAvatarCostumeManager.EnablePreview then 
		self:ChangeAvatarBodyPart()	
		return
	end	

end
}
--@ EndEntityEventHandler

