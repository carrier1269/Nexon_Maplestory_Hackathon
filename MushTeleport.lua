--@ BeginProperty
--@ SyncDirection=None
number Duration = "0"
--@ EndProperty

--@ BeginProperty
--@ SyncDirection=None
Entity royal = "5666bbdb-fd7e-4e77-a2b1-de6ebffa1a29"
--@ EndProperty

--@ BeginMethod
--@ MethodExecSpace=ServerOnly
void OnUpdate(number delta)
{
--local bosschip =_UserService.LocalPlayer.InventoryComponent:GetItemList()
--local royal = _EntityService:GetEntitiesByTag("royal")

if self.Duration == nil then
	self.Duration = 0
end
self.Duration = self.Duration + delta

if self.Duration >= 2 then
	_TeleportService:TeleportToMapPosition(_UserService.LocalPlayer, Vector3(-1, 0, 2))
end
}
--@ EndMethod