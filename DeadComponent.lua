--@ BeginEntityEventHandler
--@ Scope=All
--@ Target=self
--@ EventName=TriggerEnterEvent
HandleTriggerEnterEvent
{
-- Parameters
local TriggerBodyEntity = event.TriggerBodyEntity
--------------------------------------------------------
if PlayerComponent.hp <=0 then
	TriggerBodyEntity.StateComponent:ChangeState("DEAD")
end

}
--@ EndEntityEventHandler