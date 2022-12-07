--@ BeginMethod
--@ MethodExecSpace=ServerOnly
void OnMapEnter(any enteredMap)
{
if enteredMap.Name == "map07" then
	self._T.ui.StumpyGroup.Enable()
end 

}
--@ EndMethod

--@ BeginMethod
--@ MethodExecSpace=ServerOnly
void OnMapLeave(any leftMap)
{
if leftMap.Name == "map07" then
	self._T.ui.StumpyGroup = false
end
}
--@ EndMethod
