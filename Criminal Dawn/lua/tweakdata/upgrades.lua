Hooks:PostHook(UpgradesTweakData, "init", "CrimDawn_LevelTree", function(self)
  local all_levels = { upgrades = {
    "s552", "scar", "spas12", "rpk", "usp", "ppk", "p226", "m45", "mp7", "x_packrat", "x_sr2",
    "brass_knuckles", "toothbrush", "kabar", "briefcase", "swagger", "spoon_gold", "fists" }
  }
  for _, level in pairs(self.level_tree) do
    if level.upgrades then
      for _, upgrade in ipairs(level.upgrades) do
        if upgrade ~= "wpn_prj_ace" then table.insert(all_levels.upgrades, upgrade) end
      end
    end
  end
  self.level_tree = { [193] = all_levels }
end)