local FileIdent = "mutator_table"

for _, mutator in ipairs(managers.mutators:mutators()) do managers.mutators:set_enabled(mutator, false) end
Global.mutators._peers_notified = {}
Global.mutators._peers_ready = {}

local MutatorTable = { "EnemyDamage", "EnemyHealth", "ShotgunTweak", "ZealSniper", "Heavies" }

local DefaultMutators = { CloakerArrest = true }
managers.mutators:set_enabled("MutatorCloakerArrest")

local Mutators = #Global.CrimDawn.data.game.heists + CrimDawn.DiffIndex() - 2

if CrimDawn.DiffIndex() >= 3 then -- Hard
  table.insert(MutatorTable, "TaserOvercharge")
  managers.mutators:set_enabled("MutatorFriendlyFire")
end

if CrimDawn.DiffIndex() >= 4 then -- Very Hard
  table.insert(MutatorTable, "CloakerEffect")
  table.insert(MutatorTable, "CloakerArrest")
  table.insert(MutatorTable, "MedicDozer")
  table.insert(MutatorTable, "DozerRage")
end

if CrimDawn.DiffIndex() >= 5 then -- Overkill
  table.insert(MutatorTable, "MedicAdrenaline")
  table.insert(MutatorTable, "MedicRage")
end

if CrimDawn.DiffIndex() >= 7 then -- Death Wish
  managers.mutators:set_enabled("MutatorShieldPhalanx")
end

if CrimDawn.SettingsData and CrimDawn.SettingsData.mutator_mode then
  MutatorMode = CrimDawn.SettingsData.mutator_mode
  CrimDawn.Log(FileIdent, "Mutator Mode: " .. MutatorMode)

  if MutatorMode == 1 then Mutators = 0
  elseif MutatorMode == 2 then Mutators = #Global.CrimDawn.data.game.heists
  elseif MutatorMode == 4 then Mutators = Global.CrimDawn.data.game.max_diff - CrimDawn.DiffScale() - 3
  end
end

CrimDawn.Log(FileIdent, "Generating " .. Mutators .. " mutators:")

for i = 1, Mutators do
  if next(MutatorTable) then
    local CurrentIndex = math.random(#MutatorTable)
    local CurrentMutator = MutatorTable[CurrentIndex]
    local state = true

    if CurrentMutator then
      if DefaultMutators[CurrentMutator] then activate = false end
      managers.mutators:set_enabled("Mutator" .. CurrentMutator, state)
      CrimDawn.Log(FileIdent, CurrentMutator)
      table.remove(MutatorTable, CurrentIndex)
    end

  end
end

-- Assign random properties!
managers.mutators:get_mutator_from_id("MutatorEnemyHealth"):set_value("health_multiplier", 1.5)
managers.mutators:get_mutator_from_id("MutatorEnemyDamage"):set_value("damage_multiplier", 1.75)
managers.mutators:get_mutator_from_id("MutatorCloakerEffect"):set_value("kick_effect", "random")
managers.mutators:get_mutator_from_id("MutatorShotgunTweak"):set_value("pull_strength", 1 + math.random() * (5 - 1))
managers.mutators:get_mutator_from_id("MutatorShotgunTweak"):set_value("mothership", math.random() < 0.5)
managers.mutators:get_mutator_from_id("MutatorFriendlyFire"):set_value("damage_multiplier", math.min(CrimDawn.DiffIndex() - 2, 3))

MenuCallbackHandler:update_matchmake_attributes()