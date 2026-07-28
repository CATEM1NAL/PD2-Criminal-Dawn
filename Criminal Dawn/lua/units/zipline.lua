Hooks:OverrideFunction(ZipLine, "set_speed", function(self, speed)
  if not speed then return end

  local SpeedMult = math.min(Global.CrimDawn.data.game.progression_items * 2, 100)
  self._speed = 1 + (SpeedMult / 100) * speed

  self:_update_total_time()
end)