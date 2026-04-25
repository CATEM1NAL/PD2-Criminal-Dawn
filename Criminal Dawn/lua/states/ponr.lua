local FileIdent = "PONR"

-- Mask up hook
Hooks:PostHook(IngameStandardState, "at_enter", "CrimDawn_ForcePONR", function(self)
  if NetworkHelper:IsHost() and CrimDawn.InfiniteTime() then
    CrimDawn.Log(FileIdent, "disabling PONR timer")
    CrimDawn.state.maskup_time = -1
  end

  if CrimDawn.state.maskup_time then return end
  CrimDawn.Log(FileIdent, "Time remaining: " .. Global.CrimDawn.data.game.ponr)
  NetworkHelper:SendToPeers("CrimDawn_StartPONR", true)
  managers.groupai:state():set_point_of_no_return_timer(Global.CrimDawn.data.game.ponr, "crimdawn_ponr", "crimdawn_ponr_tweak")
  CrimDawn.state.maskup_time = TimerManager:game():time()
end)