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

--@ BeginMethod
--@ MethodExecSpace=ClientOnly
void OnBeginPlay()
{
self.count = 1
self.npcTalkData = _DataService:GetTable("starttalk")
self.uiNameEntity = _EntityService:GetEntityByPath("/ui/UIGroup/TalkPanel/Name")
self.uiMessageEntity = _EntityService:GetEntityByPath("/ui/UIGroup/TalkPanel/Text")
self.uiTalkPanel = _EntityService:GetEntityByPath("/ui/UIGroup/TalkPanel")
self.uiPortraitEntity = _EntityService:GetEntityByPath("/ui/UIGroup/TalkPanel/Portrait")
self:ShowNextText()
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
--@ MethodExecSpace=ClientOnly
void OnMapLeave(any leftMap)
{
if leftMap.Name == "map01" then
        self.uiTalkPanel.Enable = false
end
}
--@ EndMethod

--@ BeginEntityEventHandler
--@ Scope=All
--@ Target=self
--@ EventName=ButtonClickEvent
HandleButtonClickEvent
{
-- Parameters
local Entity = event.Entity
--------------------------------------------------------
self:ShowNextText();

}
--@ EndEntityEventHandler

