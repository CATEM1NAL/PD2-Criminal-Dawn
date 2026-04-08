Hooks:PostHook(DLCTweakData, "init", "CrimDawn_DLCTweakInit", function(self)
  for _, data in pairs(self) do
    if data.content and data.content.upgrades then
      data.content.upgrades = nil
      if data.content.loot_global_value == "mxm" then
        data.content.upgrades = { "grenade_crate" }
      end
    end
  end
end)