local FileIdent = "Gameover"

Hooks:PostHook(GameOverState, "at_enter", "CrimDawn_HeistFailed", function(self)
  if CrimDawn.SettingsData.deathlink > 1 then
    local TimeRemaining
    if level_id ~= "hvh" then
      local MaskupDuration = TimerManager:game():time() - CrimDawn.state.maskup_time
      TimeRemaining = Global.CrimDawn.data.game.ponr - MaskupDuration
    else TimeRemaining = managers.groupai:state():get_point_of_no_return_timer() end

    if TimeRemaining > 0.1 then
      local DeathLinkTime = os.time() + 15
      Global.CrimDawn.data.game.deathlink_in = DeathLinkTime
      if NetworkHelper:IsHost() then Global.CrimDawn.data.game.deathlink_out = DeathLinkTime end
    end
  end

  CrimDawn:RunReset(FileIdent)
end)