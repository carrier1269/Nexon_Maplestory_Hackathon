--@ BeginMethod
--@ MethodExecSpace=ServerOnly
void OnBeginPlay()
{
wait(1)
local cam = self.Entity.CameraComponent
cam:SetZoomTo(150, 0.2)
}
--@ EndMethod

