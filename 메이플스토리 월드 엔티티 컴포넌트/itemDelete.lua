--@ BeginEntityEventHandler
--@ Scope=All
--@ Target=self
--@ EventName=TriggerEnterEvent
HandleTriggerEnterEvent
{
-- Parameters
local TriggerBodyEntity = event.TriggerBodyEntity
--------------------------------------------------------
local inventory = TriggerBodyEntity.InventoryComponent
local items = inventory:GetItemList()

for index, item in pairs(items) do
	_ItemService:RemoveItem(item)
end

}
--@ EndEntityEventHandler
