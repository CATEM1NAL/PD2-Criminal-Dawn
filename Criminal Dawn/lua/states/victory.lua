local FileIdent = "Victory"

Hooks:PostHook(VictoryState, "at_enter", "CrimDawn_HeistWon", function(self)
  Global.CrimDawn.data.x.lives = math.min(math.max(Global.CrimDawn.data.x.lives + 1, 1), Global.CrimDawn.data.x.max_lives)
  if NetworkHelper:IsClient() then CrimDawn.state.maskup_time = false return end

  -- Determine points for victory
  local HeistCount = #Global.CrimDawn.data.game.heists or 1
  if Global.CrimDawn.data.game.run_length < 6 and Global.CrimDawn.data.game.run_length ~= 0 then
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
    CrimDawnClient:PollProgression()
  end

  -- Heist completion score handling
  if managers.job:on_last_stage() then -- Heist completed, give more points
    NetworkHelper:SendToPeers(
      "CrimDawn_SendPoints",
      VictoryScore * 2 .. "," ..
      -1 .. "," ..
      "heist_completed"
    )

    if not CrimDawn.IsScoreCapped(VictoryScore * 2) then
      CrimDawn.ChatNotify(managers.localization:text("crimdawn_chat_score_gain", {
        SCORE_ICON = "",
        SCORE = Global.CrimDawn.data.game.score,
        POINTS = VictoryScore,
        REASON = managers.localization:text("crimdawn_score_heist_completed"),
        TO_NEXT = CrimDawn.ScoreNeeded()
      }))
    end

    CrimDawn:NextHeist(#Global.CrimDawn.data.game.heists)
    if #Global.CrimDawn.data.game.heists - 1 > Global.CrimDawn.data.game.heists_won then
      Global.CrimDawn.data.game.heists_won = #Global.CrimDawn.data.game.heists - 1
      CrimDawn.Log(FileIdent, "Heists won: " .. Global.CrimDawn.data.game.heists_won)

      if Global.CrimDawn.data.game.heists_won == Global.CrimDawn.data.game.run_length then
        CrimDawn:WriteSave(FileIdent, "run completed")
        CrimDawn.ChatNotify(managers.localization:text("crimdawn_chat_victory"))
        DelayedCalls:Add("CrimDawn_VictoryTease", 3, function()
          CrimDawn.ChatNotify(managers.localization:text("crimdawn_chat_victory2"))
        end)
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
      "day_completed"
    )

    if not CrimDawn.IsScoreCapped(VictoryScore) then
      CrimDawn.ChatNotify(managers.localization:text("crimdawn_chat_score_gain", {
        SCORE_ICON = "",
        SCORE = Global.CrimDawn.data.game.score,
        POINTS = VictoryScore,
        REASON = managers.localization:text("crimdawn_score_day_completed"),
        TO_NEXT = CrimDawn.ScoreNeeded()
      }))
    end

    CrimDawn:WriteSave(FileIdent, "day completed")
  end
end)