--@ BeginProperty
--@ SyncDirection=All
number totalTime = "0"
--@ EndProperty

--@ BeginMethod
--@ MethodExecSpace=ServerOnly
void OnUpdate(number delta)
{
     self.totalTime = self.totalTime + delta
     if self.totalTime > 0 and self.totalTime <= 5.0 then
        self.Entity.TransformComponent:Translate(0.013,0)
     elseif self.totalTime > 5.0 and self.totalTime <= 10.0 then
        self.Entity.TransformComponent:Translate(-0.013,0)
     elseif self.totalTime > 10 then
          self.totalTime = 0
     end
}
--@ EndMethod
