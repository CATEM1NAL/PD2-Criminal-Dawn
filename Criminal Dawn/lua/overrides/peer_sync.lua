Hooks:PostHook(BaseNetworkSession, "on_peer_sync_complete", "CrimDawn_PeerSync", function(self, _, peer_id)
  if not NetworkHelper:IsHost() then return end

  -- PONR timer disabled
  local TotalTimeItems = ((Global.CrimDawn.data.game.run_length * 15) / Global.CrimDawn.data.game.timer_strength) - 1
  if Global.CrimDawn.data.x.time_upgrades > TotalTimeItems then
    CrimDawn.Log("disable_ponr", "Disabling PONR timer")
    CrimDawn.state.ponr = true
    NetworkHelper:SendToPeer(peer_id, "CrimDawn_DisablePONR", true)
  end
end)