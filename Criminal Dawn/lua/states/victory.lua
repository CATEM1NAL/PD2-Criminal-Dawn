local FileIdent = "victory"

Hooks:PostHook(VictoryState, "at_enter", "CrimDawn_HeistWon", function(self)
  if NetworkHelper:IsClient() then CrimDawn.state.maskup_time = false return end

  -- Determine points for victory
  local HeistCount = #Global.CrimDawn.data.game.heists or 1
  if Global.CrimDawn.data.game.run_length < 6 then
    HeistCount = HeistCount + (6 - Global.CrimDawn.data.game.run_length)
  end

  local VictoryScore = (HeistCount + CrimDawn.DiffScale(true)) * (1 + CrimDawn.DiffScale(true))

  if CrimDawn.state.maskup_time ~= -1 then -- Calculate time for next PONR
    if level_id ~= "hvh" then -- Cursed Kill Room is special because the timer counts backwards
      local MaskupDuration = TimerManager:game():time() - CrimDawn.state.maskup_time
      Global.CrimDawn.data.game.ponr = Global.CrimDawn.data.game.ponr - MaskupDuration

    -- Doesn't work globally - heists like Shadow Raid can overwrite the timer, but works for Cursed Kill Room
    else Global.CrimDawn.data.game.ponr = managers.groupai:state():get_point_of_no_return_timer() end

    CrimDawn.state.maskup_time = false
    CrimDawnClient:PollTimeUpgrades()
  end

  -- Heist completion score handling
  if managers.job:on_last_stage() then -- Heist completed, give more points
    NetworkHelper:SendToPeers(
      "CrimDawn_SendPoints",
      VictoryScore * 2 .. "," ..
      -1 .. "," ..
      "heist completion"
    )

    if not CrimDawn.ScoreCap(VictoryScore * 2) then
      CrimDawn.ChatNotify(" " .. Global.CrimDawn.data.game.score
        .. "\n+" .. VictoryScore * 2 .. " from heist completion.\n"
        .. CrimDawn.ScoreNeeded() .. " more for next check.") end

    CrimDawn:NextHeist(#Global.CrimDawn.data.game.heists)
    if #Global.CrimDawn.data.game.heists - 1 > Global.CrimDawn.data.game.heists_won then
      Global.CrimDawn.data.game.heists_won = #Global.CrimDawn.data.game.heists - 1
      CrimDawn.Log(FileIdent, "Heists won: " .. Global.CrimDawn.data.game.heists_won)
      if Global.CrimDawn.data.game.heists_won == Global.CrimDawn.data.game.run_length then
        CrimDawn.ChatNotify("Conglaturation !!!\nYou have completed a great game.\nAnd prooved the justice of our culture.\nNow go and rest our heroes !")
      end
    end

    NetworkHelper:SendToPeers(
      "CrimDawn_HeistCount",
      #Global.CrimDawn.data.game.heists
    )

  else -- Heist isn't finished (multiday or escape), give less points
    NetworkHelper:SendToPeers(
      "CrimDawn_SendPoints",
      VictoryScore .. "," ..
      -1 .. "," ..
      "day completion"
    )

    if not CrimDawn.ScoreCap(VictoryScore) then
      CrimDawn.ChatNotify(" " .. Global.CrimDawn.data.game.score
        .. "\n+" .. VictoryScore .. " from day completion.\n"
        .. CrimDawn.ScoreNeeded() .. " more for next check.")
    end

    CrimDawn:WriteSave(FileIdent, "day completed")
  end
end)