--@ BeginProperty
--@ SyncDirection=None
number ImmuneCooldown = "1"
--@ EndProperty

--@ BeginProperty
--@ SyncDirection=None
number LastHitTime = "0"
--@ EndProperty

--@ BeginMethod
--@ MethodExecSpace=All
override boolean IsHitTarget(string attackInfo)
{
local currentTime = _UtilLogic.ElapsedSeconds
if self.LastHitTime + self.ImmuneCooldown < currentTime then
	self.LastHitTime = _UtilLogic.ElapsedSeconds
	return true
end

return false
}
--@ EndMethod
