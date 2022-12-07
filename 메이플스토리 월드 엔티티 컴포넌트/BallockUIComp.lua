--@ BeginProperty
--@ SyncDirection=None
Entity BallockUI_1 = "4386063e-dcf4-45e0-9f1c-7c2877ffd48e"
--@ EndProperty

--@ BeginProperty
--@ SyncDirection=None
Entity MainBallockUI = "c692b227-1bc0-4756-8a2b-dbc8a107b68c"
--@ EndProperty

--@ BeginMethod
--@ MethodExecSpace=ClientOnly
void OnMapEnter(any enteredMap)
{
if enteredMap.Name == "map09" then
	self.MainBallockUI.Enable = true
	self.BallockUI_1.Enable = true
	wait(5)
	self.BallockUI_1.Enable = false
	
end
}
--@ EndMethod

--@ BeginMethod
--@ MethodExecSpace=ServerOnly
void OnMapLeave(any leftMap)
{
if leftMap.Name == "map09" then
	self.MainBallockUI.Enable = false
end
}
--@ EndMethod

