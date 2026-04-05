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