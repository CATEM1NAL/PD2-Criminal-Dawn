local FileIdent = "safehouse"

Hooks:OverrideFunction(CustomSafehouseManager, "give_upgrade_points", function() end)

local function UpdateDescriptions(tier)
  managers.localization:load_localization_file(CrimDawn.SavePath .. "crimdawn_rooms.txt")

  for _, data in ipairs(tweak_data.safehouse.rooms) do
    local CurrentRoom = Global.custom_safehouse_manager.rooms[data.room_id]

    for i = tier, Global.CrimDawn.data.game.run_length + 1 do
      managers.localization:add_localized_strings({ -- Future items use the description of the current item
        [data.help_id .. "_" .. i] = managers.localization:text(data.help_id .. "_" .. i - 1):gsub("#", "")
      })
    end

    if #CurrentRoom.unlocked_tiers == Global.CrimDawn.data.game.run_length + 1 then
      managers.localization:add_localized_strings({ -- Final tier description to let you know you're done
        [data.help_id .. "_" .. Global.CrimDawn.data.game.run_length + 1] = managers.localization:text("menu_cs_fully_upgraded")
      })
    end
  end
end

local function SetTierCap()
  local UnlockedRooms, SafehouseTier = 0, 0
  local MaxTier = math.min(Global.CrimDawn.data.game.heists_won + 2, Global.CrimDawn.data.game.run_length + 1)

  for _, data in ipairs(tweak_data.safehouse.rooms) do
    local CurrentRoom = Global.custom_safehouse_manager.rooms[data.room_id]
    UnlockedRooms = UnlockedRooms + #CurrentRoom.unlocked_tiers
    if CurrentRoom.tier_max > SafehouseTier then SafehouseTier = CurrentRoom.tier_max end
  end

  if UnlockedRooms > 23 and MaxTier > SafehouseTier then
    for _, data in ipairs(tweak_data.safehouse.rooms) do
      local CurrentRoom = Global.custom_safehouse_manager.rooms[data.room_id]
      CurrentRoom.tier_max = 1 + (1 * math.floor(UnlockedRooms / 23))
    end
    SafehouseTier = 1 + (1 * math.floor(UnlockedRooms / 23))
  end

  UpdateDescriptions(SafehouseTier)
end

Hooks:PostHook(CustomSafehouseManager, "purchase_room_tier", "CrimDawn_SafehouseUpgrade", function(self, room_id, tier)
  CrimDawn.Log(FileIdent, "Upgraded room: " .. room_id .. " to tier " .. tier)
  Global.CrimDawn.data.safehouse[room_id] = tier
  CrimDawn:WriteSave(FileIdent, "safehouse upgraded")
  SetTierCap()
end)

Hooks:PostHook(CustomSafehouseManager, "init_finalize", "CrimDawn_SafehouseCap", function(self)
  SetTierCap()
end)

Hooks:OverrideFunction(CustomSafehouseManager, "attempt_give_initial_coins", function() end)