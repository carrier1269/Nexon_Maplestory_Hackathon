--@ BeginProperty
--@ SyncDirection=None
string ShowFxRUID = ""dc634a4849014939ade2de24c5538ac2""
--@ EndProperty

--@ BeginProperty
--@ SyncDirection=None
Entity ClickShowFx = "b4513991-e5ea-4267-8c8a-583abdb95fb4"
--@ EndProperty

--@ BeginMethod
--@ MethodExecSpace=ClientOnly
void OnBeginPlay()
{
self.ClickShowFx = self.Entity:GetChildByName("ClickShowFx")

_ResourceService:LoadAnimationClipAndWait(self.ShowFxRUID)
self.ClickShowFx.SpriteGUIRendererComponent.ImageRUID = ""
self.ClickShowFx.Enable = false

local buttonTextEntity = self.Entity:GetChildByName("Text")
local buttonTextComponent = buttonTextEntity.TextComponent
if Environment:IsPCPlatform() then
	buttonTextComponent.Text = "탈의실[I]"
	
elseif Environment:IsMobilePlatform() then
	buttonTextComponent.Text = "탈의실"	
end

}
--@ EndMethod

--@ BeginMethod
--@ MethodExecSpace=ClientOnly
void PlayShow()
{
self.ClickShowFx.SpriteGUIRendererComponent.ImageRUID = self.ShowFxRUID
self.ClickShowFx.Enable = true

local initShow = function()
	self:InitShow()
end

_TimerService:SetTimerOnce(initShow,1)
}
--@ EndMethod

--@ BeginMethod
--@ MethodExecSpace=ClientOnly
void InitShow()
{
self.ClickShowFx.SpriteGUIRendererComponent.ImageRUID = ""
self.ClickShowFx.Enable = false
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
self:PlayShow()

}
--@ EndEntityEventHandler

