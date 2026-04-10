local FileIdent = "network"

-- Assign matchmaking key
if Global.CrimDawn.data.game.seed then
  NetworkMatchMakingSTEAM._BUILD_SEARCH_INTEREST_KEY = Global.CrimDawn.data.game.seed
  NetworkMatchMakingEPIC._BUILD_SEARCH_INTEREST_KEY = Global.CrimDawn.data.game.seed
else
  NetworkMatchMakingSTEAM._BUILD_SEARCH_INTEREST_KEY = "NO ARCHIPELAGO SEED FOUND"
  NetworkMatchMakingEPIC._BUILD_SEARCH_INTEREST_KEY = "NO ARCHIPELAGO SEED FOUND"
end

CrimDawn.Log(FileIdent, "Matchmaking key: " .. NetworkMatchMakingEPIC._BUILD_SEARCH_INTEREST_KEY)


-- SETTING UP NETWORK HOOKS
NetworkHelper:AddReceiveHook("CrimDawn_HeistCount", "CrimDawn_SyncHeistCount", function(data, sender)
  local HostHeistsWon = tonumber(data - 1)

  if HostHeistsWon > Global.CrimDawn.data.game.heists_won then
    Global.CrimDawn.data.game.heists_won = HostHeistsWon
    if Global.CrimDawn.data.game.heists_won == Global.CrimDawn.data.game.run_length then
      CrimDawn.Log("Conglaturation !!!\nYou have completed a great game.\nAnd prooved the justice of our culture.\nNow go and rest our heroes !")
    end
  end

  CrimDawn:WriteSave(FileIdent, "received heist number [" .. data .. "] from host")
end)

-- PONR time remaining chat message (archipelago/client_bridge.lua)
NetworkHelper:AddReceiveHook("CrimDawn_TimeUpdate", "CrimDawn_SyncTimeUpdate", function(data, sender)
  if CrimDawn.state.maskup_time ~= 0 then CrimDawn.ChatNotify(data .. " minutes remaining.")
  else CrimDawn.ChatNotify("Next heist will start with " .. data .. " more minutes.") end
end)

-- Sync PONR (ponr.lua)
NetworkHelper:AddReceiveHook("CrimDawn_StartPONR", "CrimDawn_SyncPONR", function(data, sender)
  CrimDawn.Log(FileIdent, "Received PONR sync")
  if CrimDawn.state.maskup_time ~= 0 then return end

  managers.groupai:state():set_point_of_no_return_timer(Global.CrimDawn.data.game.ponr, "crimdawn_ponr", "crimdawn_ponr_tweak")
  CrimDawn.state.maskup_time = TimerManager:game():time()
end)

-- Peer specific hooks
if not NetworkHelper:IsHost() then -- Disable PONR (overrides/peer_sync.lua)
  NetworkHelper:AddReceiveHook("CrimDawn_DisablePONR", "CrimDawn_PeerDisablePONR", function(data, sender)
    CrimDawn.Log(FileIdent, "Disabling PONR timer")
    CrimDawn.state.maskup_time = -1
  end)

-- Syncing score (score_handler.lua)
  NetworkHelper:AddReceiveHook("CrimDawn_SendPoints", "CrimDawn_ReceivePoints", function(data, sender)
    if CrimDawn.state.cap_reached then CrimDawnClient:PollTimeUpgrades()
      if Global.CrimDawn.data.game.score < Global.CrimDawn.data.game.score_cap then
        CrimDawn.state.cap_reached = false
      else return end
    end

    CrimDawn.Log(FileIdent, "Received score from host")
    local points, xPerPoint, reason = data:match("([^,]+),([^,]+),([^,]+)")

    -- Give points
    if xPerPoint == "-1" and not CrimDawn.ScoreCap(tonumber(points)) then
      CrimDawn.ChatNotify(" " .. Global.CrimDawn.data.game.score
        .. "\n+" .. tonumber(points) .. " from " .. reason .. ".\n"
        .. CrimDawn.ScoreNeeded() .. " more for next check.")

    elseif not CrimDawn.ScoreCap(tonumber(points)) then
      CrimDawn.ChatNotify(" " .. Global.CrimDawn.data.game.score
        .. "\n+1 per " .. xPerPoint .. " " .. reason .. ".\n"
        .. CrimDawn.ScoreNeeded() .. " more for next check.")
    end

    CrimDawn:WriteSave(FileIdent, "received score [" .. points .. "] from host")
  end)
end
-- FINISHED NETWORK HOOK SETUP

CrimDawn.Log(FileIdent, "Established network hooks")