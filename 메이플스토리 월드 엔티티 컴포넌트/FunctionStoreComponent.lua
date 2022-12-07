--@ BeginProperty
--@ SyncDirection=All
string FunctionTag = """"
--@ EndProperty

--@ BeginMethod
--@ MethodExecSpace=ServerOnly
void OnBeginPlay()
{
local tags = self.Entity.TagComponent.Tags
local bodyParts = _GameLogic.StringBodyPartCategories

for i = 1 , #bodyParts do
	
	for j = 1, #tags do
		
		if #tags < 1 then
			log_error("FunctionStore에 Tag가 없습니다.")
			break

		else
			
			if bodyParts[i] == tags[j] then
				self.FunctionTag = bodyParts[i]
				break
			end
			
		end
	end
	
	if self.FunctionTag ~= "" then
		break
	end
	
	if i == #bodyParts then	
		
		if self.FunctionTag == "" then
			log_error("FunctionStore에 BodyParts와 일치하는 Tag가 없습니다.")
		end
	end	
end
}
--@ EndMethod

--@ BeginEntityEventHandler
--@ Scope=Client
--@ Target=self
--@ EventName=InteractionEvent
HandleInteractionEvent
{
-- Parameters
local InteractionEntity = event.InteractionEntity
--------------------------------------------------------

_GameLogic.UiFunctionStore:GetStoreInfo(self.FunctionTag)
}
--@ EndEntityEventHandler

