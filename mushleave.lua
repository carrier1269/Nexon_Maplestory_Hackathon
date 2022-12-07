--@ BeginProperty
--@ SyncDirection=All
Entity mush = "09da2696-5722-4026-b366-4bec2789884b"
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
if key == KeyboardKey.X then
	self.mush.MushBoss.RespawnOn = true
	log("ononoo")
end
}
--@ EndEntityEventHandler

