--@ BeginProperty
--@ SyncDirection=None
number damage = "250"
--@ EndProperty

--@ BeginProperty
--@ SyncDirection=None
number potionmaxcount = "20"
--@ EndProperty

--@ BeginProperty
--@ SyncDirection=None
Component potioncount = "511c20eb-9c9a-4051-b732-a5e4d963435d:TextComponent"
--@ EndProperty

--@ BeginMethod
--@ MethodExecSpace=ClientOnly
void OnMapLeave(any leftMap)
{
if leftMap.Name == "map06" then
	self.potionmaxcount = self.potionmaxcount + 10
end
}
--@ EndMethod

--@ BeginEntityEventHandler
--@ Scope=All
--@ Target=service:InputService
--@ EventName=KeyDownEvent
HandleKeyDownEvent
{
-- Parameters
local key = event.key
--------------------------------------------------------
self.potioncount.Text = string.format("%01d", self.potionmaxcount)

if key == KeyboardKey.LeftShift and self.potionmaxcount > 0 then
	if _UserService.LocalPlayer.PlayerComponent.Hp + self.damage <= 1000 then
		_UserService.LocalPlayer.PlayerComponent.Hp = _UserService.LocalPlayer.PlayerComponent.Hp + self.damage
	else
		_UserService.LocalPlayer.PlayerComponent.Hp = 1000 
	end
	
	self.potionmaxcount = self.potionmaxcount - 1
end


}
--@ EndEntityEventHandler

