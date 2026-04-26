local FileIdent = "Network"

-- Assign matchmaking key
if Global.CrimDawn.data.game.seed then
  local key = Global.CrimDawn.data.game.seed .. "_" .. Global.CrimDawn.data.game.slot
  NetworkMatchMakingSTEAM._BUILD_SEARCH_INTEREST_KEY = key
  NetworkMatchMakingEPIC._BUILD_SEARCH_INTEREST_KEY = key
else
  NetworkMatchMakingSTEAM._BUILD_SEARCH_INTEREST_KEY = "NO SEED FOUND"
  NetworkMatchMakingEPIC._BUILD_SEARCH_INTEREST_KEY = "NO SEED FOUND"
end

CrimDawn.Log(FileIdent, "Matchmaking key: " .. NetworkMatchMakingEPIC._BUILD_SEARCH_INTEREST_KEY)


-- SETTING UP NETWORK HOOKS
NetworkHelper:AddReceiveHook("CrimDawn_HeistCount", "CrimDawn_SyncHeistCount", function(data, sender)
  local HostHeistsWon = tonumber(data - 1)

  if HostHeistsWon > Global.CrimDawn.data.game.heists_won then
    Global.CrimDawn.data.game.heists_won = HostHeistsWon
  else return end

  if Global.CrimDawn.data.game.heists_won == Global.CrimDawn.data.game.run_length then
    CrimDawn.ChatNotify(managers.localization:text("crimdawn_chat_victory"))
    DelayedCalls:Add("CrimDawn_VictoryTease", 3, function()
      CrimDawn.ChatNotify(managers.localization:text("crimdawn_chat_victory2"))
    end)
  end

  CrimDawn:WriteSave(FileIdent, "received heist number [" .. data .. "] from host")
end)

-- PONR time remaining chat message (archipelago/client_bridge.lua)
NetworkHelper:AddReceiveHook("CrimDawn_TimeUpdate", "CrimDawn_SyncTimeUpdate", function(data, sender)
  if CrimDawn.state.maskup_time then CrimDawn.ChatNotify(data .. " minutes remaining.")
  else CrimDawn.ChatNotify("Next heist will start with " .. data .. " more minutes.") end
end)

-- Sync PONR (ponr.lua)
NetworkHelper:AddReceiveHook("CrimDawn_StartPONR", "CrimDawn_SyncPONR", function(data, sender)
  CrimDawn.Log(FileIdent, "Received PONR sync")
  if CrimDawn.state.maskup_time then return end

  managers.groupai:state():set_point_of_no_return_timer(Global.CrimDawn.data.game.ponr, "crimdawn_ponr", "crimdawn_ponr_tweak")
  CrimDawn.state.maskup_time = TimerManager:game():time()
end)

-- Peer specific hooks
if NetworkHelper:IsClient() then -- Disable PONR (overrides/peer_sync.lua)
  NetworkHelper:AddReceiveHook("CrimDawn_DisablePONR", "CrimDawn_PeerDisablePONR", function(data, sender)
    CrimDawn.Log(FileIdent, "Disabling PONR timer")
    CrimDawn.state.maskup_time = -1
  end)

  NetworkHelper:AddReceiveHook("CrimDawn_ResetRun", "CrimDawn_PeerResetRun", function(data, sender)
    CrimDawn.Log(FileIdent, "Host abandoned run")
    CrimDawn:RunReset(FileIdent)
  end)

  -- Syncing score (score_handler.lua)
  NetworkHelper:AddReceiveHook("CrimDawn_SendPoints", "CrimDawn_ReceivePoints", function(data, sender)
    if CrimDawn.state.cap_reached then CrimDawnClient:PollProgression()
      if CrimDawn.state.cap_reached then return end
    end

    CrimDawn.Log(FileIdent, "Received score from host")
    local points, xPerPoint, reason = data:match("([^,]+),([^,]+),([^,]+)")

    -- Give points
    if xPerPoint == "-1" and not CrimDawn.IsScoreCapped(tonumber(points)) then
      CrimDawn.ChatNotify(managers.localization:text("crimdawn_chat_score_gain", {
        SCORE_ICON = "",
        SCORE = Global.CrimDawn.data.game.score,
        POINTS = tonumber(points),
        REASON = managers.localization:text("crimdawn_score_" .. reason),
        TO_NEXT = CrimDawn.ScoreNeeded()
      }))

    elseif not CrimDawn.IsScoreCapped(tonumber(points)) then
      CrimDawn.ChatNotify(managers.localization:text("crimdawn_chat_fscore_gain", {
        SCORE_ICON = "",
        SCORE = Global.CrimDawn.data.game.score,
        POINTS = xPerPoint,
        REASON = managers.localization:text("crimdawn_score_" .. reason),
        TO_NEXT = CrimDawn.ScoreNeeded()
      }))
    end

    CrimDawn:WriteSave(FileIdent, "received score [" .. points .. "] from host")
  end)
end
-- FINISHED NETWORK HOOK SETUP

CrimDawn.Log(FileIdent, "Established network hooks")