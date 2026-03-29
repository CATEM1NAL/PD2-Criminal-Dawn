if not NetworkHelper:IsHost() or not CrimDawn then return end
local FileIdent = "score_handler"

-- To calculate multipliers properly in multiplayer session
local Difficulty = Global.game_settings and Global.game_settings.difficulty or "normal"
local DifficultyIndex = tweak_data:difficulty_to_index(Difficulty) - 2

local ActiveMutators = {}
if Global.mutators and Global.mutators.active_on_load and not next(ActiveMutators) then
  for key, _ in pairs(Global.mutators.active_on_load) do table.insert(ActiveMutators, key) end
end

local HeistCount = #Global.CrimDawn.data.game.heists or 1

local ScorePerThing = (HeistCount + DifficultyIndex) * #ActiveMutators
local ScorePerPackage = HeistCount * #ActiveMutators
local xPerPoint = math.ceil(100 / ScorePerThing)

local function GainPoints(points, xPerPoint, reason)
  if CrimDawn.state.cap_reached then CrimDawnClient:PollTimeUpgrades() -- Cap reached, check for upgrades
    if CrimDawn.state.cap_reached then return end
  end

  if xPerPoint == -1 then -- Full points
    if not CrimDawn.ScoreCap(points) then
      CrimDawn.ChatNotify(" " .. Global.CrimDawn.data.game.score
        .. " (+" .. points .. " from " .. reason .. ").\n"
        .. CrimDawn.ScoreNeeded() .. " more for next check.")
    end CrimDawn:WriteSave(FileIdent, reason .. " secured")

  else -- Fractional points
    if not CrimDawn.ScoreCap(points) then
      CrimDawn.ChatNotify(" " .. Global.CrimDawn.data.game.score
        .. " (+1 per " .. xPerPoint .. " " .. reason .. ").\n"
        .. CrimDawn.ScoreNeeded() .. " more for next check.")
    end CrimDawn:WriteSave(FileIdent, reason .. " milestone")
  end
end

if LootManager then Hooks:PostHook(LootManager, "secure", "CrimDawn_LootSecured", function(self)
  if not tweak_data.carry.small_loot[self._global.secured[#self._global.secured].carry_id] then
    NetworkHelper:SendToPeers(
      "CrimDawn_SendPoints",
      ScorePerThing .. "," ..
      -1 .. "," ..
      "loot secured"
    )

    GainPoints(ScorePerThing, -1, "loot")

  else -- Loose cash
    Global.CrimDawn.data.game.f_score = Global.CrimDawn.data.game.f_score + ScorePerThing

    if Global.CrimDawn.data.game.f_score >= 100 then
      local points = math.floor(Global.CrimDawn.data.game.f_score / 100)

      NetworkHelper:SendToPeers(
        "CrimDawn_SendPoints",
        points .. "," ..
        xPerPoint .. "," ..
        "loose cash"
      )

      GainPoints(points, xPerPoint, "loose cash")
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
    Global.CrimDawn.data.game.f_score = Global.CrimDawn.data.game.f_score + ScorePerThing

    if Global.CrimDawn.data.game.f_score >= 100 then
      local points = math.floor(Global.CrimDawn.data.game.f_score / 100)

      NetworkHelper:SendToPeers(
        "CrimDawn_SendPoints",
        points .. "," ..
        xPerPoint .. "," ..
        "enemies killed"
      )

      GainPoints(points, xPerPoint, "enemies killed")
      Global.CrimDawn.data.game.f_score = Global.CrimDawn.data.game.f_score % 100
    end
  end
end) end

-- On package pickup, gain points equal to heists * mutators (more spawn on higher difficulties anyway)
if GageAssignmentManager then Hooks:PostHook(GageAssignmentManager, "on_unit_interact", "CrimDawn_PackagePickup", function(self)
  NetworkHelper:SendToPeers(
    "CrimDawn_SendPoints",
    ScorePerPackage .. "," ..
    -1 .. "," ..
    "Gage package secured"
  )

  GainPoints(ScorePerPackage, -1, "Gage package")
end) end