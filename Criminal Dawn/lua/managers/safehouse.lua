local FileIdent = "safehouse"

local function IncreaseCap()
  local UnlockedRooms, SafehouseTier = 0, 0
  local MaxTier = math.min(Global.CrimDawn.data.game.heists_won + 2, Global.CrimDawn.data.game.run_length)

  for index, data in ipairs(tweak_data.safehouse.rooms) do
    local CurrentRoom = Global.custom_safehouse_manager.rooms[data.room_id]
    UnlockedRooms = UnlockedRooms + #CurrentRoom.unlocked_tiers
    CrimDawn.Log(FileIdent, UnlockedRooms)
    if CurrentRoom.tier_max > SafehouseTier then SafehouseTier = CurrentRoom.tier_max end
  end

  CrimDawn.Log(FileIdent, "if " .. UnlockedRooms .. " > 23 and " .. UnlockedRooms .. " % 23 == 0 and " .. MaxTier .. " > " .. SafehouseTier)
  if UnlockedRooms > 23 and UnlockedRooms % 23 == 0 and MaxTier > SafehouseTier then
    for index, data in ipairs(tweak_data.safehouse.rooms) do
      local CurrentRoom = Global.custom_safehouse_manager.rooms[data.room_id]
      CurrentRoom.tier_max = CurrentRoom.tier_max + 1
    end
  end
end

Hooks:PostHook(CustomSafehouseManager, "purchase_room_tier", "CrimDawn_SafehouseUpgrade", function(self, room_id, tier)
  CrimDawn.Log(FileIdent, "Upgraded room: " .. room_id .. " to tier " .. tier)
  Global.CrimDawn.data.safehouse[room_id] = tier
  CrimDawn:WriteSave(FileIdent, "safehouse upgraded")
  IncreaseCap()
  -- Wait so client has time to read and write
  DelayedCalls:Add("CrimDawn_SafehousePoll", 1.5, function() CrimDawnClient:PollData() end)
end)

Hooks:PostHook(CustomSafehouseManager, "_setup", "CrimDawn_SafehouseCap", function(self)
  for index, data in ipairs(tweak_data.safehouse.rooms) do
    local CurrentRoom = Global.custom_safehouse_manager.rooms[data.room_id]
    CurrentRoom.tier_max = 2
  end
  IncreaseCap()
end)