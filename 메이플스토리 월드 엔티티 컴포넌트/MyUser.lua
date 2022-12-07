--@ BeginEntityEventHandler
--@ Scope=All
--@ Target=self
--@ EventName=TriggerEnterEvent
HandleTriggerEnterEvent
{
-- Parameters
local TriggerBodyEntity = event.TriggerBodyEntity
--------------------------------------------------------
self.Entity.RigidbodyComponent:AddForce(Vector2(5,0))

self.Entity.PlayerComponent.Hp = self.Entity.PlayerComponent.Hp - 100
}
--@ EndEntityEventHandler