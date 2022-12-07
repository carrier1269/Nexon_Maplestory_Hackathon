--@ BeginMethod
--@ MethodExecSpace=ServerOnly
void OnUpdate(number delta)
{
if self._T.destination == nil then 
self._T.destination = Vector3(1,0,-2)
end
if self._T.accTime == nil then self._T.accTime = 0 end
if self._T.teleportCnt == nil then self._T.teleportCnt = 0 end

if self.Entity.CurrentMapName== "/maps/map07" then
	if self._T.accTime >= 5 then
		self._T.accTime = 0
		_TeleportService:TeleportToEntityPath(self.Entity, "/maps/map02")
	end
	
end
}
--@ EndMethod
