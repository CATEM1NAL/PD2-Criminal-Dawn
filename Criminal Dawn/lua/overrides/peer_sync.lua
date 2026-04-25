if NetworkHelper:IsClient() then return end

Hooks:PostHook(BaseNetworkSession, "on_peer_sync_complete", "CrimDawn_PeerSync", function(self, _, peer_id)
  if CrimDawn.InfiniteTime() then
    NetworkHelper:SendToPeer(peer_id, "CrimDawn_DisablePONR", true)
  end
end)