local FileIdent = "victory"

Hooks:PostHook(VictoryState, "at_enter", "CrimDawn_HeistWon", function(self)
  CrimDawn.state.ponr = false
  if not NetworkHelper:IsHost() then return end

  -- Determine points for victory
  local Difficulty = Global.game_settings and Global.game_settings.difficulty or "normal"
  local DifficultyIndex = tweak_data:difficulty_to_index(Difficulty) - 1

  local ActiveMutators = {}
  if Global.mutators and Global.mutators.active_on_load and not next(ActiveMutators) then
    for key, _ in pairs(Global.mutators.active_on_load) do table.insert(ActiveMutators, key) end
  end

  local HeistCount = #Global.CrimDawn.data.game.heists or 1
  local VictoryScore = (HeistCount + DifficultyIndex) * #ActiveMutators

  -- Calculate time for next PONR
  if level_id ~= "hvh" then -- Cursed Kill Room is special because the timer counts backwards
    local MaskupDuration = TimerManager:game():time() - CrimDawn.state.maskup_time
    Global.CrimDawn.data.game.ponr = Global.CrimDawn.data.game.ponr - MaskupDuration

  else Global.CrimDawn.data.game.ponr = managers.groupai:state():get_point_of_no_return_timer() end
  -- Doesn't work globally - heists like Shadow Raid can overwrite the timer, but works for Cursed Kill Room

  CrimDawnClient:PollTimeUpgrades()

  -- Heist completion score handling
  if managers.job:on_last_stage() then -- Heist completed, give more points
    NetworkHelper:SendToPeers(
      "CrimDawn_SendPoints",
      VictoryScore * 2 .. "," ..
      -1 .. "," ..
      "heist completion"
    )

    if not CrimDawn.ScoreCap(VictoryScore) then
      CrimDawn.ChatNotify(" " .. Global.CrimDawn.data.game.score
        .. "\n+" .. VictoryScore * 2 .. " from heist completion.\n"
        .. CrimDawn.ScoreNeeded() .. " more for next check.") end

    CrimDawn:NextHeist(#Global.CrimDawn.data.game.heists)
    if #Global.CrimDawn.data.game.heists - 1 > Global.CrimDawn.data.game.heists_won then
      Global.CrimDawn.data.game.heists_won = #Global.CrimDawn.data.game.heists - 1
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
    end CrimDawn:WriteSave(FileIdent, "day completed")
  end
end)