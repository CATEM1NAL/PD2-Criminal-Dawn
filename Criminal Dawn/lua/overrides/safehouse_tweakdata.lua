Hooks:PostHook(CustomSafehouseTweakData, "init", "CrimDawn_SafehouseTweakData", function(self)
  self.prices = {
    rooms = { 0, 12, 12, 12, 12, 12 },
    weapon_mod = 0,
    event_weapon_mod = 0,
    crew_boost = 0,
    crew_ability = 0
  }
  self.rewards = {
    initial = self.prices.rooms[2],
    challenge = 0,
    daily_complete = 0,
    raid = 0,
    experience_ratio = -1
  }
  self.level_limit = 193
end)

Hooks:PostHook(CustomSafehouseTweakData, "_init_map", "CrimDawn_SafehouseFrames", function(self)
  self.map.frame_texture = {
    "crimdawn/safehouse1",
		"crimdawn/safehouse2",
		"crimdawn/safehouse3",
		"crimdawn/safehouse4",
		"crimdawn/safehouse5",
		"crimdawn/safehouse6"
  }
end)