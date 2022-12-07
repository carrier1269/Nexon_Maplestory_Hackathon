--@ BeginProperty
--@ SyncDirection=None
Entity StumpyUI = "efd9c485-b3a4-4766-990d-f177f08876b3"
--@ EndProperty

--@ BeginMethod
--@ MethodExecSpace=ClientOnly
void OnMapEnter(any enteredMap)
{
if enteredMap.Name == "map07" then
	self.StumpyUI.Enable = true
end
}
--@ EndMethod

--@ BeginMethod
--@ MethodExecSpace=ClientOnly
void OnMapLeave(any leftMap)
{
if leftMap.Name == "map07" then
	self.StumpyUI.Enable = false
end
}
--@ EndMethod
