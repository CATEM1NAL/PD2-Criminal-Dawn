local DefaultUnlocks = {
  esp = { "spy_camera" },
}

Hooks:PostHook(DLCTweakData, "init", "CrimDawn_DLCTweakInit", function(self)
  for _, data in pairs(self) do
    if data.content and data.content.upgrades then
      for dlcID, UnlockTable in pairs(DefaultUnlocks) do
        if data.content.loot_global_value == dlcID then
          data.content.upgrades = UnlockTable
          break
        else data.content.upgrades = nil end
      end
    end
  end
end)