--@ BeginProperty
--@ SyncDirection=None
number count = "0"
--@ EndProperty

--@ BeginProperty
--@ SyncDirection=None
any npcTalkData = "nil"
--@ EndProperty

--@ BeginProperty
--@ SyncDirection=None
Entity uiNameEntity = "nil"
--@ EndProperty

--@ BeginProperty
--@ SyncDirection=None
Entity uiMessageEntity = "nil"
--@ EndProperty

--@ BeginProperty
--@ SyncDirection=None
Entity uiTalkPanel = "cb9d6619-8125-4991-8b9d-54bf71e86322"
--@ EndProperty

--@ BeginProperty
--@ SyncDirection=None
Entity uiPortraitEntity = "nil"
--@ EndProperty

--@ BeginProperty
--@ SyncDirection=All
string player1 = """"
--@ EndProperty

--@ BeginProperty
--@ SyncDirection=None
number newcount = "0"
--@ EndProperty

--@ BeginProperty
--@ SyncDirection=None
EntityRef royalnpc = "a0eac8d9-c9db-4fb6-b893-a5cd5249d5a9"
--@ EndProperty

--@ BeginProperty
--@ SyncDirection=None
EntityRef lastendportal = "fd91e1f6-6c2b-46ca-92d4-25e929e4aa48"
--@ EndProperty

--@ BeginProperty
--@ SyncDirection=None
boolean s = "false"
--@ EndProperty

--@ BeginProperty
--@ SyncDirection=None
EntityRef will = "975e7f9e-2f01-4d6c-a5c4-9425be464663"
--@ EndProperty

--@ BeginProperty
--@ SyncDirection=None
number talkcount = "0"
--@ EndProperty

--@ BeginMethod
--@ MethodExecSpace=All
void ShowNextText()
{

local isNameEnable = false
local isPortraitEnable = false

local message = self.npcTalkData:GetCell(self.count, "text")

if message == nil then
	self.uiTalkPanel.Enable = false
	return
else
	self.uiTalkPanel.Enable = true
	self.uiMessageEntity.TextComponent.Text = message
end
	



local name = self.npcTalkData:GetCell(self.count, "name")
local portrait = self.npcTalkData:GetCell(self.count, "portrait")


if name ~= "" then
	isNameEnable = true
	if name == "player1" then
		self.player1 = _UserService.LocalPlayer.NameTagComponent.Name
		name = self.player1
	end
	self.uiNameEntity.TextComponent.Text = name
end


if portrait ~= "" then
isPortraitEnable = true
self.uiPortraitEntity.SpriteGUIRendererComponent.ImageRUID = portrait
end

self.uiNameEntity.Enable = isNameEnable
self.uiPortraitEntity.Enable = isPortraitEnable

self.count = self.count + 1


}
--@ EndMethod

--@ BeginMethod
--@ MethodExecSpace=ClientOnly
void OnBeginPlay()
{
self.count = 1
self.npcTalkData = _DataService:GetTable("lasttalk2")
self.uiNameEntity = _EntityService:GetEntityByPath("/ui/UIGroup/TalkPanel/Name")
self.uiMessageEntity = _EntityService:GetEntityByPath("/ui/UIGroup/TalkPanel/Text")
self.uiTalkPanel = _EntityService:GetEntityByPath("/ui/UIGroup/TalkPanel")
self.uiPortraitEntity = _EntityService:GetEntityByPath("/ui/UIGroup/TalkPanel/Portrait")


}
--@ EndMethod

--@ BeginMethod
--@ MethodExecSpace=ClientOnly
void OnMapLeave(any leftMap)
{
if leftMap.Name == "map03" then
        self.uiTalkPanel.Enable = false
end
}
--@ EndMethod

--@ BeginEntityEventHandler
--@ Scope=All
--@ Target=service:InputService
--@ EventName=KeyDownEvent
HandleKeyDownEvent
{
-- Parameters
local key = event.key
--------------------------------------------------------
if _UserService.LocalPlayer.StateComponent.CurrentStateName == "DEAD" then
	self.s = true
end
if self.s == true and key == KeyboardKey.Z then
	self:ShowNextText()
	self.newcount = self.newcount + 1
	self.talkcount = self.talkcount + 1
end
if self.newcount >= 3 then
	self.royalnpc.Enable = true
end
if self.newcount == 23 then
	self.lastendportal.Enable = true
	_UserService.LocalPlayer.StateComponent:ChangeState("IDLE")
	_UserService.LocalPlayer.MovementComponent:SetPosition(Vector2(-1.636, -1.17))	
	_UserService.LocalPlayer.PlayerComponent.Hp = _UserService.LocalPlayer.PlayerComponent.MaxHp
	_UserService.LocalPlayer.MovementComponent.InputSpeed = 1.2
	_UserService.LocalPlayer.MovementComponent.JumpForce = 1
	self.newcount = 24
end

}
--@ EndEntityEventHandler

