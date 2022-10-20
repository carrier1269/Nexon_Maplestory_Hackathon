--@ BeginProperty
--@ SyncDirection=None
Component hpBar = ":62"
--@ EndProperty

--@ BeginProperty
--@ SyncDirection=None
number maxWidth = "0"
--@ EndProperty

--@ BeginProperty
--@ SyncDirection=None
Component hpText = ":52"
--@ EndProperty

--@ BeginMethod
--@ MethodExecSpace=ClientOnly
void OnBeginPlay()
{
local currentPath = self.Entity.Path

local nameText = _EntityService:GetEntityByPath(currentPath .. "/info_top/text_name")
nameText.TextComponent.Text = _UserService.LocalPlayer.PlayerComponent.Nickname
self.hpText = _EntityService:GetEntityByPath(currentPath .. "/info_bottom/Hp/text_value").TextComponent

self.hpBar = _EntityService:GetEntityByPath(currentPath .. "/info_bottom/Hp/img_bar").UITransformComponent
self.maxWidth = self.hpBar.RectSize.x

}
--@ EndMethod

--@ BeginMethod
--@ MethodExecSpace=ClientOnly
void OnUpdate(number delta)
{
if self.hpBar ~= nil then
	local hp = _UserService.LocalPlayer.PlayerComponent.Hp
	local maxhp = _UserService.LocalPlayer.PlayerComponent.MaxHp
	self.hpBar.RectSize = Vector2(hp / maxhp * self.maxWidth,self.hpBar.RectSize.y)
	self.hpText.Text = string.format("%d / %d", hp,maxhp)
end
}
--@ EndMethod
