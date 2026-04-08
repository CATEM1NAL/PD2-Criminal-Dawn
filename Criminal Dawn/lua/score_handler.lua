if not NetworkHelper:IsHost() or not CrimDawn then return end
local FileIdent = "score_handler"

local HeistCount = #Global.CrimDawn.data.game.heists or 1
if Global.CrimDawn.data.game.run_length < 6 then
  HeistCount = HeistCount + (6 - Global.CrimDawn.data.game.run_length)
end

local ScoreAmount = HeistCount * (1 + CrimDawn.DiffScale(true))
local xPerPoint = math.ceil(100 / ScoreAmount)

local function GainPoints(points, xPerPoint, reason)
  if CrimDawn.state.cap_reached then CrimDawnClient:PollTimeUpgrades() -- Cap reached, check for upgrades
    if CrimDawn.state.cap_reached then return end
  end

  if xPerPoint == -1 then -- Full points
    if not CrimDawn.ScoreCap(points) then
      CrimDawn.ChatNotify(" " .. Global.CrimDawn.data.game.score
        .. "\n+" .. points .. " from " .. reason .. ".\n"
        .. CrimDawn.ScoreNeeded() .. " more for next check.")
    end CrimDawn:WriteSave(FileIdent, reason)

  else -- Fractional points
    if not CrimDawn.ScoreCap(points) then
      CrimDawn.ChatNotify(" " .. Global.CrimDawn.data.game.score
        .. "\n+1 per " .. xPerPoint .. " " .. reason .. ".\n"
        .. CrimDawn.ScoreNeeded() .. " more for next check.")
    end CrimDawn:WriteSave(FileIdent, reason .. " milestone")
  end
end

if LootManager then Hooks:PostHook(LootManager, "secure", "CrimDawn_LootSecured", function(self)
  if not tweak_data.carry.small_loot[self._global.secured[#self._global.secured].carry_id] then
    local reason = "loot secured"
    NetworkHelper:SendToPeers("CrimDawn_SendPoints", ScoreAmount .. "," .. -1 .. "," .. reason)
    GainPoints(ScoreAmount, -1, reason)

  else -- Loose cash
    Global.CrimDawn.data.game.f_score = Global.CrimDawn.data.game.f_score + ScoreAmount

    if Global.CrimDawn.data.game.f_score >= 100 then
      local points = math.floor(Global.CrimDawn.data.game.f_score / 100)
      local reason = "loose cash"

      NetworkHelper:SendToPeers("CrimDawn_SendPoints", points .. "," .. xPerPoint .. "," .. reason)
      GainPoints(points, xPerPoint, reason)
      Global.CrimDawn.data.game.f_score = Global.CrimDawn.data.game.f_score % 100
    end
  end
end) end

local function IsPlayerKill(unit)
  if not alive(unit) or not unit:base() then return false end
  local base = unit:base()
  if base.is_local_player or base.is_husk_player then return true end
return false end

if CopDamage then Hooks:PostHook(CopDamage, "die", "CrimDawn_EnemyKilled", function(self, attack_data)
  local unit = attack_data and attack_data.attacker_unit
  if IsPlayerKill(unit) then
    Global.CrimDawn.data.game.f_score = Global.CrimDawn.data.game.f_score + ScoreAmount

    if Global.CrimDawn.data.game.f_score >= 100 then
      local points = math.floor(Global.CrimDawn.data.game.f_score / 100)
      local reason = "enemies killed"

      NetworkHelper:SendToPeers("CrimDawn_SendPoints", points .. "," .. xPerPoint .. "," .. reason)
      GainPoints(points, xPerPoint, reason)
      Global.CrimDawn.data.game.f_score = Global.CrimDawn.data.game.f_score % 100
    end
  end
end) end

if ObjectivesManager then Hooks:PostHook(ObjectivesManager, "complete_objective", "CrimDawn_ObjectiveCompleted", function(self)
  local reason = "objective completed"
  NetworkHelper:SendToPeers("CrimDawn_SendPoints", ScoreAmount .. "," .. -1 .. "," .. reason)
  GainPoints(ScoreAmount, -1, reason)
end) end

if GageAssignmentManager then Hooks:PostHook(GageAssignmentManager, "on_unit_interact", "CrimDawn_PackagePickup", function(self)
  local reason = "Gage package secured"
  NetworkHelper:SendToPeers("CrimDawn_SendPoints", ScoreAmount .. "," .. -1 .. "," .. reason)
  GainPoints(ScoreAmount, -1, reason)
end) end