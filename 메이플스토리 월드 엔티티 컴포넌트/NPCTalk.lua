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
string tableName = ""NPCTalk""
--@ EndProperty

--@ BeginMethod
--@ MethodExecSpace=All
void ShowNextText()
{
self.count = 1
--self.npcTalkData = _DataService:GetTable("NPCTalk")
self.npcTalkData = _DataService:GetTable(self.tableName)
self.uiNameEntity = _EntityService:GetEntityByPath("/ui/UIGroup/TalkPanel/Name")
self.uiMessageEntity = _EntityService:GetEntityByPath("/ui/UIGroup/TalkPanel/Text")
self.uiTalkPanel = _EntityService:GetEntityByPath("/ui/UIGroup/TalkPanel")
self.uiPortraitEntity = _EntityService:GetEntityByPath("/ui/UIGroup/TalkPanel/Portrait")
if _DataService:GetTable(self.tableName) == nil then
	log("올바른 테이블명이 아닙니다. 다시 확인해주세요. 입력된 테이블 명 : "..self.tableName)
	return
end

local isNameEnable = false
local isPortraitEnable = false

-- GetRowCount() 함수는 테이블의 Row(행) 갯수를 가져옴
local rowCount = self.npcTalkData:GetRowCount()

if rowCount < self.count then
	-- rowCount 보다 self.count가 큰 경우 -> 대화가 끝남
	-- 대화가 끝나면 대화창을 닫아주고 self.count를 1로 리셋시켜줌
	-- self.count 1로 초기화 안해주면 대화 프로세스 한번 끝나면 다시 대화창 안열림
	self.uiTalkPanel.Enable = false
	self.count = 1
	return
end

local message = self.npcTalkData:GetCell(self.count, "text")
log("엔피씨 대사 : "..message)

if message == nil then
	-- 테이블에 'text' Column이 없는 경우 
	-- 대화창 강제로 닫음
	self.uiTalkPanel.Enable = false
	self.count = 1
	return
else
	self.uiTalkPanel.Enable = true
	self.uiMessageEntity.TextComponent.Text = message
end

local name = self.npcTalkData:GetCell(self.count, "name")
local portrait = self.npcTalkData:GetCell(self.count, "portrait")

if name ~= "" then
	isNameEnable = true
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
-- OnBeginPlay() [Client only]
self.count = 1
self.npcTalkData = _DataService:GetTable("NPCTalk")
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
if leftMap.Name == "map02" then
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
if (key == KeyboardKey.Z) then
		self:ShowNextText()
	
end
}
--@ EndEntityEventHandler
