--@ BeginProperty
--@ SyncDirection=None
EntityRef up1 = "d1f18b38-21dc-4cad-b90f-9f60d47901fb"
--@ EndProperty

--@ BeginProperty
--@ SyncDirection=None
EntityRef up2 = "2f5a62bb-dc4d-4dd4-866c-87ef4a14437c"
--@ EndProperty

--@ BeginProperty
--@ SyncDirection=None
EntityRef up3 = "c6b09ee2-af19-4123-92a0-c6d8636da64b"
--@ EndProperty

--@ BeginProperty
--@ SyncDirection=None
EntityRef up4 = "25c2888c-ff27-4906-874d-982a5851cf3d"
--@ EndProperty

--@ BeginProperty
--@ SyncDirection=None
EntityRef down1 = "55b6f017-9a1c-4e27-a6d5-6e4fd0f90b85"
--@ EndProperty

--@ BeginProperty
--@ SyncDirection=None
EntityRef down2 = "44788704-8bbe-4570-b7a5-2ac89c25b4a5"
--@ EndProperty

--@ BeginProperty
--@ SyncDirection=None
EntityRef down3 = "a14e94f3-cade-4e40-a3b6-4fb180d813b5"
--@ EndProperty

--@ BeginProperty
--@ SyncDirection=None
EntityRef ft1 = "fb7c3b62-1f3d-4dc8-b726-7e666b7e97c4"
--@ EndProperty

--@ BeginProperty
--@ SyncDirection=None
EntityRef ft2 = "11bbd34c-3cc0-493b-b342-1182f720ab3c"
--@ EndProperty

--@ BeginProperty
--@ SyncDirection=None
EntityRef ft3 = "dd1587fc-38cb-4519-a1ab-37832a0bbc6e"
--@ EndProperty

--@ BeginProperty
--@ SyncDirection=None
EntityRef ft4 = "10649940-6658-47ce-aafe-a486c9189dd4"
--@ EndProperty

--@ BeginProperty
--@ SyncDirection=None
EntityRef ft5 = "8c9413af-67eb-4847-93c7-811ca70d48b3"
--@ EndProperty

--@ BeginProperty
--@ SyncDirection=None
EntityRef ft6 = "4076e6f5-a701-43ce-88bb-eb21d13e0434"
--@ EndProperty

--@ BeginProperty
--@ SyncDirection=None
EntityRef ft7 = "57b072a4-e24e-4244-866f-58e195e11c61"
--@ EndProperty

--@ BeginMethod
--@ MethodExecSpace=ClientOnly
void OnBeginPlay()
{
local bosschip =_UserService.LocalPlayer.InventoryComponent:GetItemList()
if #bosschip == 0 then 
	self.up1.Enable = false
	self.up2.Enable = false
	self.up3.Enable = false
	self.up4.Enable = false
	self.down1.Enable = false
	self.down2.Enable = false
	self.down3.Enable = false
	self.ft1.Enable = true
	self.ft2.Enable = true
	self.ft3.Enable = true
	self.ft4.Enable = true
	self.ft5.Enable = true
	self.ft6.Enable = true
	self.ft7.Enable = true
elseif #bosschip == 1 then 
	self.up1.Enable = true
	self.up2.Enable = false
	self.up3.Enable = false
	self.up4.Enable = false
	self.down1.Enable = true
	self.down2.Enable = false
	self.down3.Enable = false
	self.ft1.Enable = false
	self.ft2.Enable = true
	self.ft3.Enable = true
	self.ft4.Enable = true
	self.ft5.Enable = false
	self.ft6.Enable = true
	self.ft7.Enable = true
elseif #bosschip == 2 then 
	self.up1.Enable = true
	self.up2.Enable = true
	self.up3.Enable = false
	self.up4.Enable = false
	self.down1.Enable = true
	self.down2.Enable = true
	self.down3.Enable = false
	self.ft1.Enable = false
	self.ft2.Enable = false
	self.ft3.Enable = true
	self.ft4.Enable = true
	self.ft5.Enable = false
	self.ft6.Enable = false
	self.ft7.Enable = true
elseif #bosschip == 3 then 
	self.up1.Enable = true
	self.up2.Enable = true
	self.up3.Enable = true
	self.up4.Enable = false
	self.down1.Enable = true
	self.down2.Enable = true
	self.down3.Enable = true
	self.ft1.Enable = false
	self.ft2.Enable = false
	self.ft3.Enable = false
	self.ft4.Enable = true
	self.ft5.Enable = false
	self.ft6.Enable = false
	self.ft7.Enable = false
elseif #bosschip >= 4 then 
	self.up1.Enable = true
	self.up2.Enable = true
	self.up3.Enable = true
	self.up4.Enable = true
	self.down1.Enable = true
	self.down2.Enable = true
	self.down3.Enable = true
	self.ft1.Enable = false
	self.ft2.Enable = false
	self.ft3.Enable = false
	self.ft4.Enable = false
	self.ft5.Enable = false
	self.ft6.Enable = false
	self.ft7.Enable = false
end
}
--@ EndMethod

