--@ BeginProperty
--@ SyncDirection=All
string Name = """"
--@ EndProperty

--@ BeginProperty
--@ SyncDirection=All
number MaxStackCount = "0"
--@ EndProperty

--@ BeginProperty
--@ SyncDirection=All
number EffectAmount = "0"
--@ EndProperty

--@ BeginMethod
--@ MethodExecSpace=All
void OnCreate()
{
self.Name = self.ItemTableData:GetItem("Name")
self.MaxStackCount = tonumber(self.ItemTableData:GetItem("MaxStackCount"))
self.EffectAmount = tonumber(self.ItemTableData:GetItem("EffectAmount"))
}
--@ EndMethod