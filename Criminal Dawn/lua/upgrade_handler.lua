local FileIdent = "upgrade_handler"

local function PermaUpgrade(upg_name, count)
  if upg_name == "permaskills" or upg_name == "permaperks" then
    for i = 1, Global.CrimDawn.data.x[upg_name] do
      for _, currentUpgrade in ipairs(Global.CrimDawn.tables.upgrades[upg_name][i]) do
        managers.upgrades:aquire(currentUpgrade)
      end
    end

  else managers.upgrades:aquire(upg_name .. count) end
end

Hooks:PreHook(PlayerManager, "aquire_default_upgrades", "CrimDawn_UpgradeHandler", function(self)
  tweak_data.skilltree.default_upgrades = {
    "player_hostage_trade", "player_special_enemy_highlight", "player_sec_camera_highlight", "cable_tie",
    "temporary_first_aid_damage_reduction", "temporary_passive_revive_damage_reduction_2",
    "passive_player_xp_multiplier", "player_flashbang_multiplier_2", "trip_mine_can_switch_on_off"
  }

  -- Nuke current upgrades
  for key, _ in pairs(Global.upgrades_manager.aquired) do
    if key ~= "amcar" and key ~= "glock_17" and key ~= "weapon" and key ~= "second_deployable_1" then
      if not Global.CrimDawn.data.unlocks[key] then managers.upgrades:unaquire(key) end
    elseif key == "second_deployable_1" then Global.upgrades_manager.aquired.second_deployable_1 = nil end
    -- Removing Jack of all Trades using unaquire causes it to reset the second deployable
  end

  Global.player_manager.upgrades = {}
  Global.player_manager.team_upgrades = {}
  Global.player_manager.cooldown_upgrades = { cooldown = {} }
  -- When I tried using managers.upgrades:unaquire it wouldn't clear playermanager upgrades correctly,
  -- leading to persistent upgrades that won't disappear until you restart the game.
  -- Only practical issue with current approach is the game forces you to equip consumables every load.

  -- Apply permaupgrades
  if Global.CrimDawn.data.x.permaskills > 0 then PermaUpgrade("permaskills") end
  if Global.CrimDawn.data.x.lives > 0 then PermaUpgrade("player_additional_lives_", Global.CrimDawn.data.x.lives) end
  if Global.CrimDawn.data.x.drill > 0 then PermaUpgrade("player_drill_speed_multiplier", Global.CrimDawn.data.x.drill) end
  if Global.CrimDawn.data.x.permaperks > 0 then PermaUpgrade("permaperks") end

  -- Pull upgrades from save file
  for _, upgrade in ipairs(Global.CrimDawn.data.upgrades) do
    local tableName, upgradeName = upgrade:match("([^%-]+)%-(.+)")
    for _, currentUpgrade in ipairs(Global.CrimDawn.tables.upgrades[tableName][upgradeName]) do
      managers.upgrades:aquire(currentUpgrade)
    end
  end

  -- Pull unlocks from save file
  for key, _ in pairs(Global.CrimDawn.data.unlocks) do
    if not Global.upgrades_manager.aquired[key] then
      CrimDawn.Log(FileIdent, "Unlocking " .. key)
      managers.upgrades:aquire(key)
    end
  end
end)

Hooks:PostHook(UpgradesTweakData, "init", "CrimDawn_LevelTree", function(self)
  -- local no_level_lock = { "s552","scar","spas12","rpk","usp","ppk","p226","m45","mp7" }
  -- I thought adding the weapons with no level lock to the level table would work, it doesn't

  local all_levels = { upgrades = {} }
  for _, level in pairs(self.level_tree) do
    if level.upgrades then
      for _, upgrade in ipairs(level.upgrades) do table.insert(all_levels.upgrades, upgrade) end
    end
  end
  self.level_tree = { [193] = all_levels }
end)