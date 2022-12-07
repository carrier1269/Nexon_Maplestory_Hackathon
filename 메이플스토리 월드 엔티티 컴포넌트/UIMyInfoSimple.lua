--@ BeginProperty
--@ SyncDirection=None
Component myName = ":52"
--@ EndProperty

--@ BeginProperty
--@ SyncDirection=None
Component myHP = ":43"
--@ EndProperty

--@ BeginMethod
--@ MethodExecSpace=ClientOnly
void OnBeginPlay()
{
local currentPath = self.Entity.Path
self.myName = _EntityService:GetEntityByPath(currentPath .. "/Text_name").TextComponent
self.myHP = _EntityService:GetEntityByPath(currentPath .. "/HP_bar").SliderComponent
}
--@ EndMethod

--@ BeginMethod
--@ MethodExecSpace=ClientOnly
void OnUpdate(number delta)
{
if _UserService.LocalPlayer == nil then
	return
end
local player = _UserService.LocalPlayer.PlayerComponent
if player == nil then
	return
end
self.myName.Text = player.Nickname
self.myHP.Value = player.Hp / player.MaxHp
}
--@ EndMethod