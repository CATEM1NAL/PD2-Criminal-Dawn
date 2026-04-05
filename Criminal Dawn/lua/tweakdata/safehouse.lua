Hooks:PostHook(CustomSafehouseTweakData, "init", "CrimDawn_SafehouseTweakData", function(self)
  self.prices = {
    rooms = { 0, 1, 1, 1, 1, 1, 1 },
    weapon_mod = 0,
    event_weapon_mod = 0,
    crew_boost = 0,
    crew_ability = 0
  }
  self.rewards = {
    initial = 0,
    challenge = 0,
    daily_complete = 0,
    raid = 0,
    experience_ratio = 2147483647
  }
  self.level_limit = 193
end)

Hooks:PostHook(CustomSafehouseTweakData, "_init_safehouse_rooms", "CrimDawn_SafehouseRoomInit", function(self)
  for _, data in ipairs(self.rooms) do
    data.tier_max = 2
    data.dlc = nil
    for i = 1, 4 do table.insert(data.images, data.images[3]) end
  end
end)

Hooks:PostHook(CustomSafehouseTweakData, "_init_map", "CrimDawn_SafehouseFrames", function(self)
  self.map.frame_texture = {
    "crimdawn/safehouse0",
    "crimdawn/safehouse1",
		"crimdawn/safehouse2",
		"crimdawn/safehouse3",
		"crimdawn/safehouse4",
		"crimdawn/safehouse5",
		"crimdawn/safehouse6"
  }
end)