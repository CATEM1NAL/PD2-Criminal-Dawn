local FileIdent = "safehouse"

Hooks:OverrideFunction(CustomSafehouseManager, "give_upgrade_points", function() end)

local function UpdateDescriptions()
  for _, data in ipairs(tweak_data.safehouse.rooms) do
    local CurrentRoom = Global.custom_safehouse_manager.rooms[data.room_id]

    for i = 1, Global.CrimDawn.data.game.run_length + 1 do
      managers.localization:add_localized_strings({ -- Make next tier description same as current tier
        [data.help_id .. "_" .. #CurrentRoom.unlocked_tiers + 1] = managers.localization:text(data.help_id .. "_" .. #CurrentRoom.unlocked_tiers)
      })
    end

    if #CurrentRoom.unlocked_tiers == Global.CrimDawn.data.game.run_length + 1 then
      managers.localization:add_localized_strings({ -- Final tier description to let you know you're done
        [data.help_id .. "_" .. Global.CrimDawn.data.game.run_length + 1] = managers.localization:text("menu_cs_fully_upgraded")
      })
    end
  end
end

local function IncreaseCap()
  local UnlockedRooms, SafehouseTier = 0, 0
  local MaxTier = math.min(Global.CrimDawn.data.game.heists_won + 2, Global.CrimDawn.data.game.run_length + 1)

  for _, data in ipairs(tweak_data.safehouse.rooms) do
    local CurrentRoom = Global.custom_safehouse_manager.rooms[data.room_id]
    UnlockedRooms = UnlockedRooms + #CurrentRoom.unlocked_tiers
    CrimDawn.Log(FileIdent, UnlockedRooms)
    if CurrentRoom.tier_max > SafehouseTier then SafehouseTier = CurrentRoom.tier_max end
  end

  CrimDawn.Log(FileIdent, "if " .. UnlockedRooms .. " > 23 and " .. MaxTier .. " > " .. SafehouseTier)
  if UnlockedRooms > 23 and MaxTier > SafehouseTier then
    for _, data in ipairs(tweak_data.safehouse.rooms) do
      local CurrentRoom = Global.custom_safehouse_manager.rooms[data.room_id]
      CurrentRoom.tier_max = 1 + (1 * math.floor(UnlockedRooms / 23))
    end
  end
  UpdateDescriptions()
end

Hooks:PostHook(CustomSafehouseManager, "purchase_room_tier", "CrimDawn_SafehouseUpgrade", function(self, room_id, tier)
  managers.custom_safehouse:add_coins(2)
  CrimDawn.Log(FileIdent, "Upgraded room: " .. room_id .. " to tier " .. tier)
  Global.CrimDawn.data.safehouse[room_id] = tier
  CrimDawn:WriteSave(FileIdent, "safehouse upgraded")
  IncreaseCap()
  -- Wait so client has time to read and write
  DelayedCalls:Add("CrimDawn_SafehousePoll", 1.5, function() CrimDawnClient:PollData() end)
end)

Hooks:PostHook(CustomSafehouseManager, "load", "CrimDawn_SafehouseCap", function(self)
  for _, data in ipairs(tweak_data.safehouse.rooms) do
    local CurrentRoom = Global.custom_safehouse_manager.rooms[data.room_id]
    CurrentRoom.tier_max = 2
    for i = 1, 4 do table.insert(data.images, data.images[3]) end
  end

  IncreaseCap()
end)