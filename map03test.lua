--@ BeginEntityEventHandler
--@ Scope=All
--@ Target=service:InputService
--@ EventName=KeyDownEvent
HandleKeyDownEvent
{
-- Parameters
local key = event.key
--------------------------------------------------------
local inven =_UserService.LocalPlayer.InventoryComponent:GetItemList()
if key == KeyboardKey.B then
	

	log(#inven)
	
end
}
--@ EndEntityEventHandler