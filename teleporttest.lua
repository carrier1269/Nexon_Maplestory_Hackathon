--@ BeginEntityEventHandler
--@ Scope=All
--@ Target=service:InputService
--@ EventName=KeyDownEvent
HandleKeyDownEvent
{
-- Parameters
local key = event.key
--------------------------------------------------------
if key == KeyboardKey.K then
	_TeleportService:TeleportToMapPosition(_UserService.LocalPlayer, Vector3(-1, 0, 2))
end

}
--@ EndEntityEventHandler
