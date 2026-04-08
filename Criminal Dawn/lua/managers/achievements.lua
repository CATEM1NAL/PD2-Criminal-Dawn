local FileIdent = "achievementmanager"

Hooks:PostHook(AchievmentManager, "load", "CrimDawn_AchievementLoad", function(self)
  local melee = Global.CrimDawn.tables.weapons.melee
  local throwable = Global.CrimDawn.tables.weapons.throwables

  local achievements = {
    -- Freed Hoxton
    bulldog_1 = { toothbrush = melee },

    -- Viper Grenade
    pxp1_1 = { poison_gas_grenade = throwable },

    -- Golden Spoon
    gsu_01 = { spoon_gold = melee },

    -- Wrench
    sah_11 = { shock = melee }
  }

  for achievement, _ in pairs(achievements) do
    if self:get_info(achievement).awarded then
      CrimDawn.Log(FileIdent, "Found achievement " .. achievement)
      for achievement_item, achievement_target in pairs(achievements[achievement]) do
        table.insert(achievement_target, achievement_item)
      end
    end
  end
end)