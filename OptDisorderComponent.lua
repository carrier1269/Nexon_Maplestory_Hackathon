--@ BeginProperty
--@ SyncDirection=None
number ODDuration = "5"
--@ EndProperty

--@ BeginProperty
--@ SyncDirection=None
Entity Lucid = "0f7b3f88-a186-4637-8395-ef247826a05a"
--@ EndProperty

--@ BeginMethod
--@ MethodExecSpace=Client
void OptDisOn(string UserId)
{
if self._T.OD ~= nil or _UserService.LocalPlayer.PlayerComponent.UserId ~= UserId then
	return
end
self._T.OD = _SpawnService:SpawnByModelId("model://51c7f5ff-b395-48ec-90a2-78a9dc61378a","OD",Vector3.zero,_UserService.LocalPlayer)

if self._T.OT ~= nil then
	_TimerService:ClearTimer(self._T.OT)
	self._T.OT = nil
end

local tf = function()
	self:OptDisOff()
	self._T.OT = nil
end
self._T.OT = _TimerService:SetTimerOnce(tf,self.ODDuration)
}
--@ EndMethod

--@ BeginMethod
--@ MethodExecSpace=ClientOnly
void OptDisOff()
{
if self._T.OD == nil then
	return
end
self._T.OD:Destroy()
self._T.OD = nil
}
--@ EndMethod

--@ BeginMethod
--@ MethodExecSpace=ClientOnly
void OnUpdate(number delta)
{
local lucidside = self.Lucid.SpriteRendererComponent.FlipX
if lucidside == true then
	self:OptDisOff()
else self:OptDisOn(_UserService.LocalPlayer.PlayerComponent.UserId)
end
}
--@ EndMethod

--@ BeginMethod
--@ MethodExecSpace=ClientOnly
void OnMapLeave(any leftMap)
{
self:OptDisOff()
}
--@ EndMethod

