--@ BeginProperty
--@ SyncDirection=None
EntityRef n1 = "8c294c47-b845-465d-8a13-cee1cb83e284"
--@ EndProperty

--@ BeginProperty
--@ SyncDirection=None
EntityRef n2 = "4f63a4e9-8c92-4ce9-b16d-559c61485a9a"
--@ EndProperty

--@ BeginProperty
--@ SyncDirection=None
EntityRef n3 = "6672e329-d739-4dff-8f7e-0b427bf0e174"
--@ EndProperty

--@ BeginMethod
--@ MethodExecSpace=ClientOnly
void OnBeginPlay()
{
local inven =_UserService.LocalPlayer.InventoryComponent:GetItemList()
if #inven == 2 then
	self.n2.Enable = true
	self.n1.Enable = false
	self.n3.Enable = false
elseif #inven == 4 then
	self.n2.Enable = false
	self.n3.Enable = true
	self.n1.Enable = false
end
}
--@ EndMethod