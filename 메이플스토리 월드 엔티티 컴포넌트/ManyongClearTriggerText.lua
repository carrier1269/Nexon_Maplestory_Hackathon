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
--@ SyncDirection=All
boolean CollisionState = "false"
--@ EndProperty

--@ BeginProperty
--@ SyncDirection=All
EntityRef BossState = "b32ca0bc-24dc-4033-b0ef-e59dc4773592"
--@ EndProperty

--@ BeginProperty
--@ SyncDirection=None
number newcount = "0"
--@ EndProperty

--@ BeginProperty
--@ SyncDirection=None
Entity quest = "aff5705e-7a1b-4d81-b240-3b46e257b129"
--@ EndProperty

--@ BeginProperty
--@ SyncDirection=None
Entity portal = "78316186-4573-4f0b-8f47-1bd635664f24"
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
self.npcTalkData = _DataService:GetTable("skilltalk3")
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
if leftMap.Name == "map08" then
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
if key == KeyboardKey.Z and self.CollisionState == true and  self.BossState == false then
	self:ShowNextText()
end
if self.BossState == false then
	self.quest.Enable = true
	self.portal.Enable = true
end


}
--@ EndEntityEventHandler

--@ BeginEntityEventHandler
--@ Scope=Client
--@ Target=self
--@ EventName=TriggerEnterEvent
HandleTriggerEnterEvent
{
-- Parameters
local TriggerBodyEntity = event.TriggerBodyEntity
--------------------------------------------------------
if TriggerBodyEntity.Id == _UserService.LocalPlayer.Id then
	self.CollisionState = true
end
}
--@ EndEntityEventHandler

--@ BeginEntityEventHandler
--@ Scope=All
--@ Target=self
--@ EventName=TriggerLeaveEvent
HandleTriggerLeaveEvent
{
-- Parameters
local TriggerBodyEntity = event.TriggerBodyEntity
--------------------------------------------------------
if TriggerBodyEntity.Id == _UserService.LocalPlayer.Id then
	self.CollisionState = false
end

}
--@ EndEntityEventHandler

