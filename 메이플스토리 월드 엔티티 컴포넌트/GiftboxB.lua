--@ BeginEntityEventHandler
--@ Scope=All
--@ Target=self
--@ EventName=TriggerEnterEvent
HandleTriggerEnterEvent
{
-- Parameters
local TriggerBodyEntity = event.TriggerBodyEntity
--------------------------------------------------------
--아이템 엔티티와 충돌한 엔티티의 인벤토리를 받고, 인벤토리가 없으면 리턴합니다.
local iventory = TriggerBodyEntity.InventoryComponent
if iventory == nil then return end

--UserItemDataSet에 추가되어 있는 아이템들의 이름과 아이템 타입 명을 Table로 만들어 줍니다.
local itemNames = {{"Bchip",Chip},
{"Achip",Chip},
{"Schip",Chip},
{"SSchip",Chip}}

--아이템들 중 획득할 아이템을 랜덤으로 선정합니다.
local getItemName = itemNames[1]

--아이템을 생성하여 충돌한 엔티티의 인벤토리에 넣어줍니다.
_ItemService:CreateItem(getItemName[2],getItemName[1],iventory)
 
--충돌한 엔티티의 인벤토리에 아이템이 생성되면, 해당 아이템을 없앤 뒤 5초 후 다시 나타나도록 예약을 걸어둡니다.
 
self.Entity:SetEnable(false)

}
--@ EndEntityEventHandler
