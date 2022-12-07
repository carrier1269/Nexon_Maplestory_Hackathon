--@ BeginProperty
--@ SyncDirection=All
table<Entity> Players = "Entity"
--@ EndProperty

--@ BeginMethod
--@ MethodExecSpace=All
number AddToArrayPlayer(Entity player)
{
if #self.Players == 0 then
	--아무것도 안들어 있으면 무조건 넣음
	self.Players[1] = player
	return 1
end
for i = 1, #self.Players do
	--배열 전체 확인하면서 이미 들어있는 플레이어인지 확인
	if self.Players[i].Name == player.Name then
		self.Players[#self.Players+1] = player
		return #self.Players+1
	end
end
return #self.Players
}
--@ EndMethod

--@ BeginMethod
--@ MethodExecSpace=All
number RemoveToArrayPlayer(Entity player)
{
if #self.Players == 0 then
	--아무것도 안들어 있으면 무조건 반환
	return 0
end
for i = 1, #self.Players do
	--배열 전체 확인하면서 이미 들어있는 플레이어인지 확인
	if self.Players[i].Name == player.Name then
		for j=i+1,#self.Players do
			self.Players[j-1] = self.Players[j]
		end
		self.Players[#self.Players] = nil
		return #self.Players
	end
end

return #self.Players
}
--@ EndMethod

--@ BeginEntityEventHandler
--@ Scope=All
--@ Target=self
--@ EventName=TriggerEnterEvent
HandleTriggerEnterEvent
{
-- Parameters
local TriggerBodyEntity = event.TriggerBodyEntity
local tags = TriggerBodyEntity.TagComponent.Tags
--------------------------------------------------------
for i=1, #tags do
	if tags[i] == "player" then
		--print("find player")
		local playerNum = self:AddToArrayPlayer(TriggerBodyEntity)
		
		return
	end
	
end
}
--@ EndEntityEventHandler

--@ BeginEntityEventHandler
--@ Scope=All
--@ Target=self
--@ EventName=TriggerStayEvent
HandleTriggerStayEvent
{
local TriggerBodyEntity = event.TriggerBodyEntity

}
--@ EndEntityEventHandler

--@ BeginEntityEventHandler
--@ Scope=All
--@ Target=self
--@ EventName=TriggerLeaveEvent
HandleTriggerLeaveEvent
{
-- Parameters
local TriggerBodyEntity = event.TriggerBodyEntity
local tags = TriggerBodyEntity.TagComponent.Tags
--------------------------------------------------------
if not TriggerBodyEntity.TagComponent then
	return
end
for i=1, #tags do
	if tags[i] == "player" then
		--print("lost player")
		local playerNum = self:RemoveToArrayPlayer(TriggerBodyEntity)
		return
	end
end
}
--@ EndEntityEventHandler

