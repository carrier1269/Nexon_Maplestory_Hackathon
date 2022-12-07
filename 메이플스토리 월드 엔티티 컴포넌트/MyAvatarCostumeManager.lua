--@ BeginProperty
--@ SyncDirection=None
Component CostumeManager = ":CostumeManagerComponent"
--@ EndProperty

--@ BeginProperty
--@ SyncDirection=None
table CostumeCategories = "{}"
--@ EndProperty

--@ BeginProperty
--@ SyncDirection=All
table<string,string> WorldCostumeInfo = "string|string"
--@ EndProperty

--@ BeginProperty
--@ SyncDirection=All
table<string,string> PreviewCostumeInfo = "string|string"
--@ EndProperty

--@ BeginProperty
--@ SyncDirection=None
boolean EnablePreview = "false"
--@ EndProperty

--@ BeginProperty
--@ SyncDirection=None
boolean IsPlayFX = "false"
--@ EndProperty

--@ BeginProperty
--@ SyncDirection=None
string ShowPreviewFX = ""0109a413d5fe4f94b03dc80341675506""
--@ EndProperty

--@ BeginProperty
--@ SyncDirection=None
string ShowSaveFX = ""db8b5334ddfb40d18fb4254e034a528c""
--@ EndProperty

--@ BeginProperty
--@ SyncDirection=None
string SoundPreviewFX = ""013b506924354c5f82bc43cdc7646d66""
--@ EndProperty

--@ BeginProperty
--@ SyncDirection=None
string SoundSaveFX = ""796e54a35d2d46de9fdd11b57dabcb87""
--@ EndProperty

--@ BeginProperty
--@ SyncDirection=None
table avatarItemCategoriesForClient = "{}"
--@ EndProperty

--@ BeginProperty
--@ SyncDirection=None
table<string,string> CurrentCostumeInfo = "string|string"
--@ EndProperty

--@ BeginProperty
--@ SyncDirection=All
boolean IsInitiating = "true"
--@ EndProperty

--@ BeginProperty
--@ SyncDirection=All
boolean EnableRemove = "false"
--@ EndProperty

--@ BeginMethod
--@ MethodExecSpace=ServerOnly
void OnBeginPlay()
{
self.IsInitiating = true

self.IsPlayFX = false
self.EnablePreview = false
self.EnableRemove = false

local uiCameraEntity = _SpawnService:SpawnByModelId("model://4104331d-b8e4-4440-80d5-1aaf1ebe137c","UiCameraComponent",Vector3(1.05,0,0),self.Entity)
uiCameraEntity.Visible = false

self.CostumeManager = self.Entity.CostumeManagerComponent
self.CostumeManager.Enable = true
self.CostumeManager.UseCustomEquipOnly = true

for i, category in ipairs(_GameLogic.StringCostumeCategories) do 
	table.insert(self.CostumeCategories, category)
end

local userId = self.Entity.PlayerComponent.UserId
self:OnBeginByClient(userId)

self:ResetCostumeInfo(self.WorldCostumeInfo)
self:ResetCostumeInfo(self.PreviewCostumeInfo)

local userData =_DataStorageService:GetUserDataStorage(userId)

local checkhasVisited = function(errorCode,key,value)
	
	if errorCode ~= 0 then return end 

	if value == nil then
		self:MakeBasicCostume()
	else
		self:LoadWorldCostume()
	end
	userData:SetAsync("hasVisited","true",nil)
end
	
userData:GetAsync("hasVisited",checkhasVisited)
}
--@ EndMethod

--@ BeginMethod
--@ MethodExecSpace=Client
void OnBeginByClient()
{
local uiMyItem = _GameLogic.UiMyItem
uiMyItem:SetMyItemSlots()

self.avatarItemCategoriesForClient = _GameUILogic:GetAvatarItemCategoriesForUi()
}
--@ EndMethod

--@ BeginMethod
--@ MethodExecSpace=ServerOnly
void ResetCostumeInfo(table<string,string> costumeInfo)
{
for i = 1 , #self.CostumeCategories do
	local category = self.CostumeCategories[i]
	costumeInfo[category]=""
end
}
--@ EndMethod

--@ BeginMethod
--@ MethodExecSpace=Server
void PreviewCostume(string category,string ruid)
{
self:PlayPreviewFX()

self.PreviewCostumeInfo[category] = ruid
if category == "coat" or category == "pants" then
	
	self.CostumeManager.CustomLongcoatEquip = ""
	self.PreviewCostumeInfo["longcoat"] = ""
	self.CostumeManager:SetEquip(_GameLogic:StringToCategory("longcoat"),"")
		
elseif category == "longcoat" then
	
	self.CostumeManager.CustomCoatEquip = ""
	self.CostumeManager.CustomPantsEquip = ""
	self.PreviewCostumeInfo["coat"] = ""
	self.PreviewCostumeInfo["pants"] = ""
	self.CostumeManager:SetEquip(_GameLogic:StringToCategory("coat"),"")
	self.CostumeManager:SetEquip(_GameLogic:StringToCategory("pants"),"")

elseif category == "oneHandedWp" or category == "subWp" then
	
	self.CostumeManager.CustomTwoHandedWeaponEquip = ""
	self.PreviewCostumeInfo["twoHandedWp"] = ""
	self.CostumeManager:SetEquip(_GameLogic:StringToCategory("twoHandedWp"),"")

elseif category == "twoHandedWp" then
	
	self.CostumeManager.CustomOneHandedWeaponEquip = ""
	self.CostumeManager.CustomSubWeaponEquip = ""
	self.PreviewCostumeInfo["oneHandedWp"] = ""
	self.PreviewCostumeInfo["subWp"] = ""
	self.CostumeManager:SetEquip(_GameLogic:StringToCategory("oneHandedWp"),"")
	self.CostumeManager:SetEquip(_GameLogic:StringToCategory("subWp"),"")

end

self.CostumeManager:SetEquip(_GameLogic:StringToCategory(category),ruid)
}
--@ EndMethod

--@ BeginMethod
--@ MethodExecSpace=Server
void CanclePreviewCostume(string category)
{
local costumeId = self.WorldCostumeInfo[category]
self.PreviewCostumeInfo[category] = ""

self.CostumeManager:SetEquip(_GameLogic:StringToCategory(category),"")

if category == "longcoat" then
	self.CostumeManager.CustomCoatEquip = ""
	self.CostumeManager.CustomPantsEquip = ""
	self.PreviewCostumeInfo["coat"] = ""
	self.PreviewCostumeInfo["pants"] = ""

	if _UtilLogic:IsNilorEmptyString(costumeId) then
		
		local savedCoatId = self.WorldCostumeInfo["coat"]
		local savedPantsId = self.WorldCostumeInfo["pants"]	
		self.CostumeManager:SetEquip(_GameLogic:StringToCategory("coat"),savedCoatId)
		self.CostumeManager:SetEquip(_GameLogic:StringToCategory("pants"),savedPantsId)

	else
		self.CostumeManager:SetEquip(_GameLogic:StringToCategory(category),costumeId)	
	end	
	
elseif category == "coat" or category == "pants"	then
	
	if _UtilLogic:IsNilorEmptyString(costumeId) then
		
		local savedCoatId = self.WorldCostumeInfo["coat"]
		local savedPantsId = self.WorldCostumeInfo["pants"] 
		
		if _UtilLogic:IsNilorEmptyString(savedCoatId) and _UtilLogic:IsNilorEmptyString(savedPantsId) then
			
			local savedLongcoatId = self.WorldCostumeInfo["longcoat"]
			if not _UtilLogic:IsNilorEmptyString(savedLongcoatId) then
				self.CostumeManager.CustomCoatEquip = ""
				self.CostumeManager.CustomPantsEquip = ""
				self.CostumeManager.CustomLongcoatEquip = ""
				self.CostumeManager:SetEquip(_GameLogic:StringToCategory("longcoat"),savedLongcoatId)
				self.CostumeManager:SetEquip(_GameLogic:StringToCategory("coat"),"")
				self.CostumeManager:SetEquip(_GameLogic:StringToCategory("pants"),"")
				self.PreviewCostumeInfo["longcoat"] = savedLongcoatId
				self.PreviewCostumeInfo["coat"] = ""
				self.PreviewCostumeInfo["pants"] = ""
			end
		end
	else
		self.CostumeManager:SetEquip(_GameLogic:StringToCategory(category),costumeId)
	end
	
elseif category == "twoHandedWp" then 
	
	self.CostumeManager.CustomOneHandedWeaponEquip = ""
	self.CostumeManager.CustomSubWeaponEquip = ""
	self.PreviewCostumeInfo["oneHandedWp"] = ""
	self.PreviewCostumeInfo["subWp"] = ""

	if _UtilLogic:IsNilorEmptyString(costumeId) then
		
		local savedOneHandedWpId = self.WorldCostumeInfo["oneHandedWp"]
		local savedSubWpId = self.WorldCostumeInfo["subWp"]	
		self.CostumeManager:SetEquip(_GameLogic:StringToCategory("oneHandedWp"),savedOneHandedWpId)
		self.CostumeManager:SetEquip(_GameLogic:StringToCategory("subWp"),savedSubWpId)

	else
		self.CostumeManager:SetEquip(_GameLogic:StringToCategory(category),costumeId)	
	end
	
elseif category == "oneHandedWp" or category == "subWp" then
	
	if _UtilLogic:IsNilorEmptyString(costumeId) then
		
		local savedOneHandedWpId = self.WorldCostumeInfo["oneHandedWp"]
		local savedSubWpId = self.WorldCostumeInfo["subWp"]	
		
		if _UtilLogic:IsNilorEmptyString(savedOneHandedWpId) and _UtilLogic:IsNilorEmptyString(savedSubWpId) then
			
			local savedTwoHandedWpId = self.WorldCostumeInfo["twoHandedWp"]
			if not _UtilLogic:IsNilorEmptyString(savedTwoHandedWpId) then
				self.CostumeManager.CustomOneHandedWeaponEquip = ""
				self.CostumeManager.CustomSubWeaponEquip = ""
				self.CostumeManager.CustomTwoHandedWeaponEquip = ""
				self.CostumeManager:SetEquip(_GameLogic:StringToCategory("twoHandedWp"),savedTwoHandedWpId)
				self.CostumeManager:SetEquip(_GameLogic:StringToCategory("oneHandedWp"),"")
				self.CostumeManager:SetEquip(_GameLogic:StringToCategory("subWp"),"")
				self.PreviewCostumeInfo["twoHandedWp"] = savedTwoHandedWpId
				self.PreviewCostumeInfo["oneHandedWp"] = ""
				self.PreviewCostumeInfo["subWp"] = ""
			end
		end
	else
		self.CostumeManager:SetEquip(_GameLogic:StringToCategory(category),costumeId)
	end

else	
	
	self.CostumeManager:SetEquip(_GameLogic:StringToCategory(category),costumeId)	
end
}
--@ EndMethod

--@ BeginMethod
--@ MethodExecSpace=Server
void PreviewMyItemRemove(string category)
{
self:PlayPreviewFX()

local costumeId = ""
self.PreviewCostumeInfo[category] = costumeId
self.CostumeManager:SetEquip(_GameLogic:StringToCategory(category),costumeId)
}
--@ EndMethod

--@ BeginMethod
--@ MethodExecSpace=Server
void CanclePreviewMyItemRemove(string category)
{
local costumeId = self.WorldCostumeInfo[category]
self.PreviewCostumeInfo[category] = costumeId

self.CostumeManager:SetEquip(_GameLogic:StringToCategory(category),costumeId)
}
--@ EndMethod

--@ BeginMethod
--@ MethodExecSpace=Server
void QuitPreview()
{
for i , category in ipairs(self.CostumeCategories) do
	
	local ruid = self.WorldCostumeInfo[category]
	self.CostumeManager:SetEquip(_GameLogic:StringToCategory(category),ruid)
end

self:ResetCostumeInfo(self.PreviewCostumeInfo)
}
--@ EndMethod

--@ BeginMethod
--@ MethodExecSpace=Client
void GetCurrentCostume()
{
local playerCostume = self.Entity.CostumeManagerComponent
table.clear(self.CurrentCostumeInfo)

local costumeCategoriesForClient = _GameLogic.StringCostumeCategories
local stringTocategoriesForClient = _GameUILogic:GetAvatarItemCategoriesForUi()

local currentCostumeInfo = {}

for i , category in ipairs(costumeCategoriesForClient) do	
	local ruid = playerCostume:GetEquip(stringTocategoriesForClient[category])
	
	if _UtilLogic:IsNilorEmptyString(ruid) then
		ruid = "empty"
	end
	currentCostumeInfo[category] = ruid
end
self:SaveCostume(currentCostumeInfo)
}
--@ EndMethod

--@ BeginMethod
--@ MethodExecSpace=Server
void SaveCostume(table currentCostume)
{
self:PlaySaveFX()

for category , ruid in pairs(currentCostume) do
	
	if ruid == "empty" then
		currentCostume[category] = ""
	end
	self.WorldCostumeInfo[category] = currentCostume[category]
	self.CostumeManager:SetEquip(_GameLogic:StringToCategory(category),currentCostume[category])

end

local userId = self.Entity.PlayerComponent.UserId
local userData =_DataStorageService:GetUserDataStorage(userId)

local checkSave = function(errorCode,values)
end
userData:BatchSetAsync(currentCostume,checkSave)

self:UpdateMyItemUi(userId)
self:ResetCostumeInfo(self.PreviewCostumeInfo)
}
--@ EndMethod

--@ BeginMethod
--@ MethodExecSpace=Server
void LoadWorldCostume()
{
local userId = self.Entity.PlayerComponent.UserId
local userData =_DataStorageService:GetUserDataStorage(userId)

local loadFace = function(errorCode,key,value)
	wait(0.5)
	self.CostumeManager:SetEquip(MapleAvatarItemCategory.Face,value)
end
userData:GetAsync("face",loadFace)

wait(1)

local loadHair = function(errorCode,key,value)
	self.CostumeManager:SetEquip(MapleAvatarItemCategory.Hair,value)
end
userData:GetAsync("hair",loadHair)

local loadear = function(errorCode,key,value)
	self.CostumeManager:SetEquip(MapleAvatarItemCategory.Ear,value)
end
userData:GetAsync("ear",loadear)

local loadBody = function(errorCode,key,value)
	self.CostumeManager:SetEquip(MapleAvatarItemCategory.Body,value)
end
userData:GetAsync("body",loadBody)


local errorCode , pages = userData:BatchGetAndWait(self.CostumeCategories)

if errorCode == 0  then

	while true do
		local items = pages:GetCurrentPageDatas()
		for i, v in ipairs(items) do
			local category = v.KeyInfo.Key
			local ruid = v.Value
			self.WorldCostumeInfo[category] = ruid
		end
		if pages.IsLastPage == true then
			break
		end
		pages:MoveToNextPageAndWait()
	end
	
elseif errorCode ~= 0  then
	log_error("DataStorage Get Failed")
end

self.IsInitiating = false

for category , ruid in pairs(self.WorldCostumeInfo) do
	
	self.CostumeManager:SetEquip(_GameLogic:StringToCategory(category),ruid)
end

self:UpdateMyItemUi(userId)
}
--@ EndMethod

--@ BeginMethod
--@ MethodExecSpace=Server
void MakeBasicCostume()
{
self:ChangeAvatarFace()

wait(0.5)

self:ChangeAvatarHair()
self:ChangeAvatarBody()
self:ChangeAvatarEar()

self.IsInitiating = false

wait(0.5)

local userId = self.Entity.PlayerComponent.UserId
self:SetBasicCoat(userId)
self:SetBasicPants(userId)

wait(1)


self:GetCurrentCostume(userId)
self:UpdateMyItemUi(userId)

}
--@ EndMethod

--@ BeginMethod
--@ MethodExecSpace=Server
void ChangeAvatarFace()
{
local userId = self.Entity.PlayerComponent.UserId
local userData =_DataStorageService:GetUserDataStorage(userId)

local faceRUIDs = _DataService:GetTable("FaceRUIDs")
local faceIndex = _UtilLogic:RandomIntegerRange(1,faceRUIDs:GetRowCount())
local faceRUID = faceRUIDs:GetCell(faceIndex,"ruid")

self.CostumeManager:SetEquip(MapleAvatarItemCategory.Face,faceRUID)

userData:SetAsync("face",faceRUID,nil)
self:PlayPreviewFX()

}
--@ EndMethod

--@ BeginMethod
--@ MethodExecSpace=Server
void ChangeAvatarHair()
{
local userId = self.Entity.PlayerComponent.UserId
local userData =_DataStorageService:GetUserDataStorage(userId)

local hairRUIDs=_DataService:GetTable("HairRUIDs")
local hairIndex = _UtilLogic:RandomIntegerRange(1,hairRUIDs:GetRowCount())
local hairRUID = hairRUIDs:GetCell(hairIndex,"ruid")

self.CostumeManager:SetEquip(MapleAvatarItemCategory.Hair,hairRUID)
userData:SetAsync("hair",hairRUID,nil)
self:PlayPreviewFX()

}
--@ EndMethod

--@ BeginMethod
--@ MethodExecSpace=Server
void ChangeAvatarBody()
{
local userId = self.Entity.PlayerComponent.UserId
local userData =_DataStorageService:GetUserDataStorage(userId)

local bodyRUIDs=_DataService:GetTable("BodyRUIDs")
local bodyIndex = _UtilLogic:RandomIntegerRange(1,bodyRUIDs:GetRowCount())
local bodyRUID = bodyRUIDs:GetCell(bodyIndex,"ruid")

self.CostumeManager:SetEquip(MapleAvatarItemCategory.Body,bodyRUID)
userData:SetAsync("body",bodyRUID,nil)
self:PlayPreviewFX()
}
--@ EndMethod

--@ BeginMethod
--@ MethodExecSpace=Server
void ChangeAvatarEar()
{
local userId = self.Entity.PlayerComponent.UserId
local userData =_DataStorageService:GetUserDataStorage(userId)

local earRUIDs=_DataService:GetTable("EarRUIDs")
local earIndex = _UtilLogic:RandomIntegerRange(1,earRUIDs:GetRowCount())
local earRUID = earRUIDs:GetCell(earIndex,"ruid")

self.CostumeManager:SetEquip(MapleAvatarItemCategory.Ear,earRUID)
userData:SetAsync("ear",earRUID,nil)
self:PlayPreviewFX()
}
--@ EndMethod

--@ BeginMethod
--@ MethodExecSpace=Server
void PlayPreviewFX()
{
if self.IsPlayFX then return end

self.IsPlayFX = true

local player = self.Entity
local userId = self.Entity.PlayerComponent.UserId
local pos = self.Entity.TransformComponent.Position
_SoundService:PlaySoundAtPos(self.SoundPreviewFX,pos,player,1)
_EffectService:PlayEffectAttached(self.ShowPreviewFX,player,Vector3(0,0,0),0,Vector3(1,1,1),false)

local quitPlayFX = function()
	self.IsPlayFX = false
end
_TimerService:SetTimerOnce(quitPlayFX,0.5)

}
--@ EndMethod

--@ BeginMethod
--@ MethodExecSpace=Server
void PlaySaveFX()
{
local player = self.Entity
local pos = self.Entity.TransformComponent.Position
_SoundService:PlaySoundAtPos(self.SoundSaveFX,pos,player,1)

local options = {}
options["PlayRate"] = 2

local playShow = function()
	_EffectService:PlayEffectAttached(self.ShowSaveFX,player,Vector3(0,0,0),0,Vector3(1,1,1),false,options)	
end

_TimerService:SetTimerOnce(playShow,0.3)
}
--@ EndMethod

--@ BeginMethod
--@ MethodExecSpace=Client
void UpdateMyItemUi()
{
local uiMyItem = _GameLogic.UiMyItem

wait(1)

for category , ruid in pairs(self.WorldCostumeInfo) do	
	uiMyItem:UpdateMyItem(category,ruid)
end
}
--@ EndMethod

--@ BeginMethod
--@ MethodExecSpace=Server
void SetBasicCoat(string playerId)
{
local userId = self.Entity.PlayerComponent.UserId
if playerId ~= userId then return end

local savedCoatId = self.WorldCostumeInfo["coat"]
local savedLongcoatId = self.WorldCostumeInfo["Longcoat"]

if _UtilLogic:IsNilorEmptyString(savedCoatId) then
	
	if _UtilLogic:IsNilorEmptyString(savedLongcoatId) then
		
		local previewCoatId = self.PreviewCostumeInfo["coat"]
		
		if _UtilLogic:IsNilorEmptyString(previewCoatId) then 
			self.CostumeManager.CustomCoatEquip = ""
			self.CostumeManager:SetEquip(_GameLogic:StringToCategory("coat") ,_GameLogic.BasicCoat)	
		end
	else	
		self.CostumeManager:SetEquip(_GameLogic:StringToCategory("longcoat") ,savedLongcoatId)	

	end
	
else	
	if self.EnableRemove then
		self.CostumeManager:SetEquip(_GameLogic:StringToCategory("coat") ,_GameLogic.BasicCoat)		
	end
end
}
--@ EndMethod

--@ BeginMethod
--@ MethodExecSpace=Server
void SetBasicPants(string playerId)
{
local userId = self.Entity.PlayerComponent.UserId
if playerId ~= userId then return end

local savedPantsId = self.WorldCostumeInfo["pants"] 
local savedLongcoatId = self.WorldCostumeInfo["Longcoat"]

if _UtilLogic:IsNilorEmptyString(savedPantsId) then
	
	if _UtilLogic:IsNilorEmptyString(savedLongcoatId) then
		
		local previewPants = self.PreviewCostumeInfo["pants"]
		
		if _UtilLogic:IsNilorEmptyString(previewPants) then
			self.CostumeManager.CustomPantsEquip = ""
			self.CostumeManager:SetEquip(_GameLogic:StringToCategory("pants") ,_GameLogic.BasicPants)
		end
	else	
		self.CostumeManager:SetEquip(_GameLogic:StringToCategory("longcoat") ,savedLongcoatId)	
	end

else
	if self.EnableRemove then
		self.CostumeManager:SetEquip(_GameLogic:StringToCategory("pants") ,_GameLogic.BasicPants)
	end	
	
end
}
--@ EndMethod

--@ BeginMethod
--@ MethodExecSpace=Server
void SwitchEnableRemove(boolean enable)
{
self.EnableRemove = enable
}
--@ EndMethod

--@ BeginEntityEventHandler
--@ Scope=Client
--@ Target=localPlayer
--@ EventName=InitMapleCostumeEvent
HandleInitMapleCostumeEvent
{
-- Parameters
local AvartarItems = event.AvartarItems
--------------------------------------------------------
local hasCoat = false
local hasPants = false
local hasLongcoat = false

for i , item in ipairs(AvartarItems) do
	
	local categoryText = tostring(item.Category)

	if categoryText == "Coat" then
		hasCoat = true
	end
	if categoryText == "Pants" then
		hasPants = true
	end
	if categoryText == "Longcoat" then
		hasLongcoat = true
	end	
	
end

if self.IsInitiating == false then 

if hasLongcoat == true then return end

if hasLongcoat == false then
		
	if hasCoat == false then
		local playerId = _UserService.LocalPlayer.PlayerComponent.UserId
		self:SetBasicCoat(playerId)
	elseif hasPants == false then
		local playerId = _UserService.LocalPlayer.PlayerComponent.UserId
		self:SetBasicPants(playerId)
		
	end
end

end
}
--@ EndEntityEventHandler

--@ BeginEntityEventHandler
--@ Scope=Client
--@ Target=localPlayer
--@ EventName=EnableRemoveSwitchEvent
HandleEnableRemoveSwitchEvent
{
-- Parameters
local enable = event.enable
--------------------------------------------------------
self:SwitchEnableRemove(enable)
}
--@ EndEntityEventHandler

--@ BeginEntityEventHandler
--@ Scope=Client
--@ Target=localPlayer
--@ EventName=EnablePreviewSwitchEvent
HandleEnablePreviewSwitchEvent2
{
-- Parameters
local enable = event.enable
--------------------------------------------------------
self.EnablePreview = enable

if enable then
	self.Entity.MovementComponent.InputSpeed = 0
	self.Entity.RigidbodyComponent.DownJumpSpeed = 0
	
else	
	self.Entity.MovementComponent.InputSpeed = 1.2
	self.Entity.RigidbodyComponent.DownJumpSpeed = 1.2
end
}
--@ EndEntityEventHandler
