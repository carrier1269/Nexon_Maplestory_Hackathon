--@ BeginProperty
--@ SyncDirection=None
Entity itemUI = "nil"
--@ EndProperty

--@ BeginProperty
--@ SyncDirection=None
Entity scrollView = "nil"
--@ EndProperty

--@ BeginProperty
--@ SyncDirection=None
table<string,Entity> SlotItems = "string|Entity"
--@ EndProperty

--@ BeginProperty
--@ SyncDirection=None
string inventoryBtnPath = ""/ui/DefaultGroup/RPGButtons/btn_inventory""
--@ EndProperty

--@ BeginMethod
--@ MethodExecSpace=ClientOnly
void OnBeginPlay()
{
self.itemUI =_EntityService:GetEntityByPath(self.Entity.Path .. "/InventoryPanel/Inventory_ScrollView/item_slot")
self.itemUI:SetEnable(false)
self.scrollView = _EntityService:GetEntityByPath(self.Entity.Path .. "/InventoryPanel/Inventory_ScrollView")

-- add UI Preset/Buttons
local inventoryButton = _EntityService:GetEntityByPath(self.inventoryBtnPath)
if inventoryButton ~= nil then
	local openFunc = function()
		self.Entity.Enable = true
	end
	if inventoryButton.ButtonComponent == nil then
		inventoryButton:AddComponent("MOD.Core.ButtonComponent", false)
	end
	inventoryButton:ConnectEvent(ButtonClickEvent, openFunc)
end


local closeButton = _EntityService:GetEntityByPath(self.Entity.Path .. "/InventoryPanel/CloseButton")
local closeFunc = function()
	self.Entity.Enable = false
end

closeButton:ConnectEvent(ButtonClickEvent, closeFunc)
}
--@ EndMethod

--@ BeginEntityEventHandler
--@ Scope=All
--@ Target=localPlayer
--@ EventName=InventoryItemInitEvent
HandleInventoryItemInitEvent
{
-- Parameters
local Entity = event.Entity
local Items = event.Items
--------------------------------------------------------

for i, item in pairs(Items) do
	local itemslot =_SpawnService:Clone("Item", self.itemUI, self.scrollView)
	itemslot.UIItemSlot:SetData(item)
	self.SlotItems[item.GUID] = itemslot
end
}
--@ EndEntityEventHandler

--@ BeginEntityEventHandler
--@ Scope=All
--@ Target=localPlayer
--@ EventName=InventoryItemAddedEvent
HandleInventoryItemAddedEvent
{
-- Parameters
local Entity = event.Entity
local Items = event.Items
--------------------------------------------------------
for i, item in pairs(Items) do
	local itemslot =_SpawnService:Clone("Item", self.itemUI, self.scrollView)
	itemslot.UIItemSlot:SetData(item)
	self.SlotItems[item.GUID] = itemslot
end
}
--@ EndEntityEventHandler

--@ BeginEntityEventHandler
--@ Scope=All
--@ Target=localPlayer
--@ EventName=InventoryItemRemovedEvent
HandleInventoryItemRemovedEvent
{
-- Parameters
local Entity = event.Entity
local Items = event.Items
--------------------------------------------------------
for	i,item in pairs(Items) do
	if self.SlotItems[item.GUID] ~= nil then
		self.SlotItems[item.GUID]:Destroy()
	end
end
}
--@ EndEntityEventHandler

--@ BeginEntityEventHandler
--@ Scope=All
--@ Target=localPlayer
--@ EventName=InventoryItemModifiedEvent
HandleInventoryItemModifiedEvent
{
-- Parameters
local Entity = event.Entity
local Items = event.Items
--------------------------------------------------------
for	i,item in pairs(Items) do
	if self.SlotItems[item.GUID] ~= nil then
		self.SlotItems[item.GUID].UIItemSlot:SetData(item)
	end
end
}
--@ EndEntityEventHandler