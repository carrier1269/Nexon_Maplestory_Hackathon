--@ BeginProperty
--@ SyncDirection=None
Component guideText = "39d5b301-15b8-4c03-9965-0aeb49f1439b:TextComponent"
--@ EndProperty

--@ BeginProperty
--@ SyncDirection=None
EntityRef Cat = "8c294c47-b845-465d-8a13-cee1cb83e284"
--@ EndProperty

--@ BeginProperty
--@ SyncDirection=None
EntityRef supi = "0379fce1-fa2e-4d5a-b524-814bc36319ac"
--@ EndProperty

--@ BeginProperty
--@ SyncDirection=None
EntityRef Cat2 = "4f63a4e9-8c92-4ce9-b16d-559c61485a9a"
--@ EndProperty

--@ BeginProperty
--@ SyncDirection=None
EntityRef Cat3 = "6672e329-d739-4dff-8f7e-0b427bf0e174"
--@ EndProperty

--@ BeginProperty
--@ SyncDirection=None
EntityRef mush = "7bba6414-c5aa-47c1-ad0b-b08c61b58ccd"
--@ EndProperty

--@ BeginProperty
--@ SyncDirection=None
EntityRef m = "09da2696-5722-4026-b366-4bec2789884b"
--@ EndProperty

--@ BeginProperty
--@ SyncDirection=None
EntityRef arrow = "993986c3-fc17-4bb6-8ba5-b658165b4737"
--@ EndProperty

--@ BeginProperty
--@ SyncDirection=None
EntityRef map03 = "9a20652d-c555-4977-9a09-56c4f814a91e"
--@ EndProperty

--@ BeginProperty
--@ SyncDirection=None
boolean chatenable = "false"
--@ EndProperty

--@ BeginEntityEventHandler
--@ Scope=All
--@ Target=service:InputService
--@ EventName=KeyDownEvent
HandleKeyDownEvent
{
-- Parameters
local key = event.key
--------------------------------------------------------
local bosschip =_UserService.LocalPlayer.InventoryComponent:GetItemList()

if self.Cat.TriggerText.cattalk == nil then
	log("error")
	self.arrow.Enable = false
end

if self.Cat.TriggerText.cattalk <= 11 then
	self.guideText.Text = "포탈로 이동하여 고양이와 대화하기"
	self.arrow.Enable = false
	end
if self.Cat.TriggerText.cattalk > 11 then
self.guideText.Text = "슈피겔만과 대화하기"
	self.arrow.Enable = false
	end
if self.supi.SupiTriggerText.supicount > 18 then
	self.guideText.Text = "첫 번째 보스몬스터 퇴치"
	self.arrow.Enable = true
	end
if #bosschip == 1 then
	self.guideText.Text = "두 번째 보스몬스터 퇴치"
	self.arrow.Enable = false
	end
if #bosschip == 2 then
	self.guideText.Text = "탈리에게 가서 대화하기"
	self.arrow.Enable = false
	end
if self.Cat2.cattalkstumpyclear.cattalk > 15 then
	self.guideText.Text = "세 번째 보스몬스터 퇴치"
	self.arrow.Enable = false
	end
if #bosschip == 3 then
	self.guideText.Text = "네 번째 보스몬스터 퇴치"
	self.arrow.Enable = false
	end
if #bosschip == 4 then
	self.guideText.Text = "탈리와 대화하기"
	self.arrow.Enable = false
	end
if  self.Cat3.cattalklastclear.cattalk > 11 then
	self.guideText.Text = "죽은 이후 : Z키를 누르세요"
	self.arrow.Enable = false
end
if self.map03.whendeadtalk.talkcount > 22 then
	self.guideText.Text = "Z키를 눌러주세요"
	self.arrow.Enable = false
	self.chatenable = true
end
}
--@ EndEntityEventHandler

