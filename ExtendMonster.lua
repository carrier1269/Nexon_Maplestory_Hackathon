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
Entity uiTalkPanel = "nil"
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
--@ SyncDirection=All
boolean deadchat = "false"
--@ EndProperty

--@ BeginProperty
--@ SyncDirection=All
number MaxHp = "100"
--@ EndProperty

--@ BeginProperty
--@ SyncDirection=All
number Hp = "0"
--@ EndProperty

--@ BeginProperty
--@ SyncDirection=All
boolean RespawnOn = "false"
--@ EndProperty

--@ BeginProperty
--@ SyncDirection=All
number RespawnDelay = "5"
--@ EndProperty

--@ BeginProperty
--@ SyncDirection=All
boolean IsDead = "false"
--@ EndProperty

--@ BeginProperty
--@ SyncDirection=All
number DestroyDelay = "0.6"
--@ EndProperty

--@ BeginMethod
--@ MethodExecSpace=All
override void OnBeginPlay()
{
__base:OnBeginPlay()
self.count = 1
self.npcTalkData = _DataService:GetTable("skilltalk")
self.uiNameEntity = _EntityService:GetEntityByPath("/ui/UIGroup/TalkPanel/Name")
self.uiMessageEntity = _EntityService:GetEntityByPath("/ui/UIGroup/TalkPanel/Text")
self.uiTalkPanel = _EntityService:GetEntityByPath("/ui/UIGroup/TalkPanel")
self.uiPortraitEntity = _EntityService:GetEntityByPath("/ui/UIGroup/TalkPanel/Portrait")
}
--@ EndMethod

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
--@ MethodExecSpace=ServerOnly
override void Dead()
{
__base:Dead()
self.deadchat = true
}
--@ EndMethod

--@ BeginMethod
--@ MethodExecSpace=ServerOnly
override void Respawn()
{
__base:Respawn()
}
--@ EndMethod

--@ BeginMethod
--@ MethodExecSpace=ServerOnly
void OnMapLeave(any leftMap)
{
if leftMap.Name == "머쉬맘-보스" then
	self.uiTalkPanel.Enable = false
end
}
--@ EndMethod

--@ BeginEntityEventHandler
--@ Scope=All
--@ Target=self
--@ EventName=HitEvent
HandleHitEvent
{
-- Parent handler call
__base:HandleHitEvent(event)

-- Parameters
local AttackCenter = event.AttackCenter
local AttackerEntity = event.AttackerEntity
local Damages = event.Damages
local Extra = event.Extra
local FeedbackAction = event.FeedbackAction
local IsCritical = event.IsCritical
local TotalDamage = event.TotalDamage
--------------------------------------------------------

}
--@ EndEntityEventHandler

--@ BeginEntityEventHandler
--@ Scope=All
--@ Target=service:InputService
--@ EventName=KeyDownEvent
HandleKeyDownEvent
{
-- Parameters
local key = event.key
--------------------------------------------------------

if key == KeyboardKey.Z and self.deadchat == true then
	self:ShowNextText()
end

}
--@ EndEntityEventHandler

