if NetworkHelper:IsClient() or not CrimDawn then return end
local FileIdent = "ScoreHandler"

local HeistCount = #Global.CrimDawn.data.game.heists or 1
if Global.CrimDawn.data.game.run_length < 6 and Global.CrimDawn.data.game.run_length ~= 0 then
  HeistCount = HeistCount + (6 - Global.CrimDawn.data.game.run_length)
end

local ScoreAmount = HeistCount * (1 + CrimDawn.DiffScale(true))
local xPerPoint = math.ceil(100 / ScoreAmount)

local function GainPoints(points, xPerPoint, reason)
  if CrimDawn.state.cap_reached then CrimDawnClient:PollProgression()
    if CrimDawn.state.cap_reached then return end
  end

  if xPerPoint == -1 then -- Full points
    if not CrimDawn.IsScoreCapped(points) then
      CrimDawn.ChatNotify(managers.localization:text("crimdawn_chat_score_gain", {
        SCORE_ICON = "",
        SCORE = Global.CrimDawn.data.game.score,
        POINTS = points,
        REASON = managers.localization:text("crimdawn_score_" .. reason),
        TO_NEXT = CrimDawn.ScoreNeeded()
      }))
    end CrimDawn:WriteSave(FileIdent, reason)

  else -- Fractional points
    if not CrimDawn.IsScoreCapped(points) then
      CrimDawn.ChatNotify(managers.localization:text("crimdawn_chat_fscore_gain", {
        SCORE_ICON = "",
        SCORE = Global.CrimDawn.data.game.score,
        POINTS = xPerPoint,
        REASON = managers.localization:text("crimdawn_score_" .. reason),
        TO_NEXT = CrimDawn.ScoreNeeded()
      }))
    end CrimDawn:WriteSave(FileIdent, reason .. " milestone")
  end
end

Hooks:PostHook(LootManager, "secure", "CrimDawn_LootSecured", function(self)
  if not tweak_data.carry.small_loot[self._global.secured[#self._global.secured].carry_id] then
    local reason = "bag_secured"
    NetworkHelper:SendToPeers("CrimDawn_SendPoints", ScoreAmount .. "," .. -1 .. "," .. reason)
    GainPoints(ScoreAmount, -1, reason)

  else -- Loose cash
    Global.CrimDawn.data.game.f_score = Global.CrimDawn.data.game.f_score + ScoreAmount

    if Global.CrimDawn.data.game.f_score >= 100 then
      local points = math.floor(Global.CrimDawn.data.game.f_score / 100)
      local reason = "loose_cash"

      NetworkHelper:SendToPeers("CrimDawn_SendPoints", points .. "," .. xPerPoint .. "," .. reason)
      GainPoints(points, xPerPoint, reason)
      Global.CrimDawn.data.game.f_score = Global.CrimDawn.data.game.f_score % 100
    end
  end
end)

local function IsPlayerKill(unit)
  if not alive(unit) or not unit:base() then return false end
  local base = unit:base()
  if base.is_local_player or base.is_husk_player then return true end
return false end

Hooks:PostHook(CopDamage, "die", "CrimDawn_EnemyKilled", function(self, attack_data)
  local unit = attack_data and attack_data.attacker_unit
  if IsPlayerKill(unit) then
    Global.CrimDawn.data.game.f_score = Global.CrimDawn.data.game.f_score + ScoreAmount

    if Global.CrimDawn.data.game.f_score >= 100 then
      local points = math.floor(Global.CrimDawn.data.game.f_score / 100)
      local reason = "enemies_killed"

      NetworkHelper:SendToPeers("CrimDawn_SendPoints", points .. "," .. xPerPoint .. "," .. reason)
      GainPoints(points, xPerPoint, reason)
      Global.CrimDawn.data.game.f_score = Global.CrimDawn.data.game.f_score % 100
    end
  end
end)

Hooks:PostHook(ObjectivesManager, "complete_objective", "CrimDawn_ObjectiveCompleted", function(self)
  local reason = "obj_completed"
  NetworkHelper:SendToPeers("CrimDawn_SendPoints", ScoreAmount .. "," .. -1 .. "," .. reason)
  GainPoints(ScoreAmount, -1, reason)
end)

Hooks:PostHook(GageAssignmentManager, "on_unit_interact", "CrimDawn_PackagePickup", function(self)
  local reason = "package_secured"
  NetworkHelper:SendToPeers("CrimDawn_SendPoints", ScoreAmount .. "," .. -1 .. "," .. reason)
  GainPoints(ScoreAmount, -1, reason)
end)