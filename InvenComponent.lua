--@ BeginMethod
--@ MethodExecSpace=All
void Function1()
{
local UIgroup_1 = _EntityService:GetEntityByPath("/ui/DefaultGroup/Inventory_1")
UIgroup_1:SetEnable(true)

}
--@ EndMethod

--@ BeginMethod
--@ MethodExecSpace=All
void Function2()
{
local UIgroup_2 = _EntityService:GetEntityByPath("/ui/DefaultGroup/Inventory_1")
UIgroup_2:SetEnable(false)

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
local UIgroup_1 = _EntityService:GetEntityByPath("/ui/DefaultGroup/Inventory_1")
--------------------------------------------------------
if UIgroup_1:Enable() then
	self:Function2()
end
else self:Function1()


}
--@ EndEntityEventHandler
