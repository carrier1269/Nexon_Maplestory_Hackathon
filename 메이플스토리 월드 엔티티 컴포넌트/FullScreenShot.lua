--@ BeginMethod
--@ MethodExecSpace=All
void CaptureFullScreen()
{
    -- 전체 화면 스크린샷을 "FullScreen"이란 이름으로 저장하고 에러 코드와 저장 경로를 반환합니다.
    local error, fullPath = _ScreenshotService:CaptureFullScreenAsFileAndWait("FullScreen")

    if error == ScreenshotError.Success then
        -- 스크린샷이 저장되었다는 정보와 함께 이미지 저장 경로를 로그로 남겨줍니다.
        log("스크린샷이 저장되었습니다. "..fullPath)
    end
}
--@ EndMethod

--@ BeginEntityEventHandler
--@ Scope=All
--@ Target=self
--@ EventName=ButtonClickEvent
HandleButtonClickEvent
{
-- Parameters
local Entity = event.Entity
--------------------------------------------------------
    -- 버튼을 클릭하면 CaptureFullScreen 함수를 호출합니다.
    self:CaptureFullScreen()

}
--@ EndEntityEventHandler
