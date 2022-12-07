--@ BeginProperty
--@ SyncDirection=None
EntityRef bossportal1 = "0f699d3e-7017-40bb-b7f1-12ec8d6393a5"
--@ EndProperty

--@ BeginProperty
--@ SyncDirection=None
EntityRef bossportal2 = "038af773-6ef4-40bc-a2e0-530bfa33df51"
--@ EndProperty

--@ BeginProperty
--@ SyncDirection=None
EntityRef bossportal3 = "d71557aa-8138-43b9-84c9-dc815184e268"
--@ EndProperty

--@ BeginProperty
--@ SyncDirection=None
EntityRef bossportal4 = "7c21d835-3c65-4a9d-b8fe-ffba0a69060a"
--@ EndProperty

--@ BeginProperty
--@ SyncDirection=None
EntityRef ft1 = "8600f9ab-78b0-49ed-ba41-ebb617f90c2a"
--@ EndProperty

--@ BeginProperty
--@ SyncDirection=None
EntityRef ft2 = "b38b6c1a-4abd-473f-b8c6-81f7b366e45d"
--@ EndProperty

--@ BeginProperty
--@ SyncDirection=None
EntityRef ft3 = "956ebf48-7edb-4d65-806f-53b1b326ea5e"
--@ EndProperty

--@ BeginProperty
--@ SyncDirection=None
EntityRef ft4 = "296e94a6-adba-4323-8779-34a552fea0bc"
--@ EndProperty

--@ BeginMethod
--@ MethodExecSpace=ClientOnly
void OnBeginPlay()
{
local bosschip =_UserService.LocalPlayer.InventoryComponent:GetItemList()
if #bosschip == 0 then 
	self.bossportal1.Enable = true
	self.bossportal2.Enable = false
	self.bossportal3.Enable = false
	self.bossportal4.Enable = false
	self.ft1.Enable = false
	self.ft2.Enable = true
	self.ft3.Enable = true
	self.ft4.Enable = true
elseif #bosschip == 1 then
	self.bossportal1.Enable = false
	self.bossportal2.Enable = true
	self.bossportal3.Enable = false
	self.bossportal4.Enable = false
	self.ft1.Enable = true
	self.ft2.Enable = false
	self.ft3.Enable = true
	self.ft4.Enable = true
elseif #bosschip == 2 then
	self.bossportal1.Enable = false
	self.bossportal2.Enable = false
	self.bossportal3.Enable = true
	self.bossportal4.Enable = false
	self.ft1.Enable = true
	self.ft2.Enable = true
	self.ft3.Enable = false
	self.ft4.Enable = true
elseif #bosschip == 3 then
	self.bossportal1.Enable = false
	self.bossportal2.Enable = false
	self.bossportal3.Enable = false
	self.bossportal4.Enable = true
	self.ft1.Enable = true
	self.ft2.Enable = true
	self.ft3.Enable = true
	self.ft4.Enable = false
elseif #bosschip >= 4 then
	self.bossportal1.Enable = false
	self.bossportal2.Enable = false
	self.bossportal3.Enable = false
	self.bossportal4.Enable = false
	self.ft1.Enable = true
	self.ft2.Enable = true
	self.ft3.Enable = true
	self.ft4.Enable = true
end
}
--@ EndMethod

