--@ BeginProperty
--@ SyncDirection=None
any item = "nil"
--@ EndProperty

--@ BeginProperty
--@ SyncDirection=None
string itemGUID = """"
--@ EndProperty

--@ BeginMethod
--@ MethodExecSpace=All
void SetData(any item)
{
self.item = item

local imageEntity = self.Entity:GetChildByName("img_slot")
imageEntity.SpriteGUIRendererComponent.ImageRUID = item.IconRUID

imageEntity:GetChildByName("item_count").TextComponent.Text = tostring(item.ItemCount)
self.itemGUID = item.GUID
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

if self.item == nil then
	return
end

-- TODO: item logic
}
--@ EndEntityEventHandler

