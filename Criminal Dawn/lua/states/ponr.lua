local FileIdent = "ponr"

-- Mask up hook
Hooks:PostHook(IngameStandardState, "at_enter", "CrimDawn_ForcePONR", function(self)
  local TotalTimeItems = ((Global.CrimDawn.data.game.run_length * 15) / (Global.CrimDawn.data.game.timer_strength / 60)) - 1
  if NetworkHelper:IsHost() then -- Disable timer when all time upgrades + 1 are collected
    if Global.CrimDawn.data.x.time_upgrades > TotalTimeItems then
      CrimDawn.Log(FileIdent, "disabling PONR timer")
      CrimDawn.state.ponr = true
    end
  end

  if CrimDawn.state.ponr then return end
  CrimDawn.Log(FileIdent, "Time remaining: " .. Global.CrimDawn.data.game.ponr)

  NetworkHelper:SendToPeers("CrimDawn_StartPONR", true)
  managers.groupai:state():set_point_of_no_return_timer(Global.CrimDawn.data.game.ponr, "crimdawn_ponr", "crimdawn_ponr_tweak")
  CrimDawn.state.maskup_time = TimerManager:game():time()
  CrimDawn.state.ponr = true
end)