--@ BeginProperty
--@ SyncDirection=All
EntityRef NewValue1 = "299b8aba-b61e-4ada-a0b9-662e26f0dda5"
--@ EndProperty

--@ BeginEntityEventHandler
--@ Scope=All
--@ Target=self
--@ EventName=PortalUseEvent
HandlePortalUseEvent
{
-- Parameters
local PortalUser = event.PortalUser
--------------------------------------------------------


}
--@ EndEntityEventHandler
