--@ BeginEntityEventHandler
--@ Scope=All
--@ Target=self
--@ EventName=TriggerEnterEvent
HandleTriggerEnterEvent
{
-- Parameters
local TriggerBodyEntity = event.TriggerBodyEntity
--------------------------------------------------------
local player = self.Entity.PlayerComponent

if TriggerBodyEntity.Name = "monster-10" then
	self.Entity.PlayerComponent:ProcessDead()
end 

}
--@ EndEntityEventHandler
