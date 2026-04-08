if CrimDawnClient then return end
local FileIdent = "client_bridge"
CrimDawnClient = { DataPath = CrimDawn.SavePath .. "crimdawn_client.txt" }

function CrimDawnClient:LoadData()
  self.data = io.load_as_json(self.DataPath) or {}

  -- Set default values if they don't exist
  self.data["Time Bonus"] = self.data["Time Bonus"] or 0
  self.data["Drill Sawgeant"] = self.data["Drill Sawgeant"] or 0
  self.data["Nine Lives"] = self.data["Nine Lives"] or 0
  self.data["Perma-Skill"] = self.data["Perma-Skill"] or 0
  self.data["Perma-Perk"] = self.data["Perma-Perk"] or 0
  self.data["Extra Bot"] = self.data["Extra Bot"] or 0
  self.data["Primary Weapon"] = self.data["Primary Weapon"] or 0
  self.data["Akimbo"] = self.data["Akimbo"] or 0
  self.data["Secondary Weapon"] = self.data["Secondary Weapon"] or 0
  self.data["Melee Weapon"] = self.data["Melee Weapon"] or 0
  self.data["Throwable"] = self.data["Throwable"] or 0
  self.data["Armor"] = self.data["Armor"] or 0
  self.data["Deployable"] = self.data["Deployable"] or 0
  self.data["Skill"] = self.data["Skill"] or 0
  self.data["Perk"] = self.data["Perk"] or 0
  self.data["Stat Boost"] = self.data["Stat Boost"] or 0
  self.data["Coins"] = self.data["Coins"] or 0
end CrimDawnClient:LoadData()

-- Timer upgrades need to be checked between heists and when score cap is reached
function CrimDawnClient:PollTimeUpgrades()
  if not Global.CrimDawn.data.game.timer_strength then return end

  if not Global.CrimDawn.data.game.ponr then Global.CrimDawn.data.game.ponr =
    Global.CrimDawn.data.game.timer_strength * (1 + Global.CrimDawn.data.x.time_upgrades)
  end

  if Global.CrimDawn.data.x.time_upgrades > CrimDawn.MaxTimeItems() then return end

  CrimDawnClient:LoadData()
  if Global.CrimDawn.data.game.seed ~= self.data.seed then return end

  local TimeRemaining = math.floor(Global.CrimDawn.data.game.ponr / 60)

  if self.data["Time Bonus"] > Global.CrimDawn.data.x.time_upgrades then -- Get time upgrades
    local ExtraTime = Global.CrimDawn.data.game.timer_strength * (self.data["Time Bonus"] - Global.CrimDawn.data.x.time_upgrades)
    Global.CrimDawn.data.game.ponr = Global.CrimDawn.data.game.ponr + ExtraTime
    TimeRemaining = TimeRemaining + math.floor(ExtraTime / 60)
    Global.CrimDawn.data.x.time_upgrades = self.data["Time Bonus"]
    Global.CrimDawn.data.game.score_cap = self.data.score_cap
    CrimDawn:WriteSave(FileIdent, "Time Bonus received from multiworld")
    if NetworkHelper:IsHost() then NetworkHelper:SendToPeers("CrimDawn_TimeUpdate", TimeRemaining) end

    if CrimDawn.state.ponr then -- Mid-game timer update (increase score cap)
      CrimDawn.state.cap_reached = false
      CrimDawn.ChatNotify("Next heist will start with " .. Global.CrimDawn.data.game.timer_strength / 60 .. " more minutes."
                       .. "\nScore cap increased to " .. Global.CrimDawn.data.game.score_cap .. "!")
    return end

    if NetworkHelper:IsHost() then -- Send timer update to peers
      DelayedCalls:Add("CrimDawn_ChatPONR", 1, function()
        CrimDawn.ChatNotify(TimeRemaining .. " (+" .. math.floor(ExtraTime / 60) .. " from Time Bonus) minutes remaining.")
      end)
    end

  else if CrimDawn.state.ponr then return end
    if NetworkHelper:IsHost() then -- No time upgrades received, send current time to peers
      DelayedCalls:Add("CrimDawn_ChatPONR", 1, function()
        if TimeRemaining < 0 then
          CrimDawn.ChatNotify("Remaining time is less than 1 minute!")
          NetworkHelper:SendToPeers("CrimDawn_TimeUpdate", 0)
        else CrimDawn.ChatNotify(TimeRemaining .. " minutes remaining.")
          NetworkHelper:SendToPeers("CrimDawn_TimeUpdate", TimeRemaining)
        end
      end)
    end
  end
end

-- Check if anything other than timer was updated (main menu only)
function CrimDawnClient:PollData()
  if not managers.blackmarket then return end -- Can't save if blackmarket doesn't exist

  CrimDawnClient:LoadData()
  local DataChanged

  -- Pull game config from client if we don't have it
  if not Global.CrimDawn.data.game.seed and self.data.seed then
    CrimDawn.Log(FileIdent, "Writing game config")
    Global.CrimDawn.data.game.seed = self.data.seed
    Global.CrimDawn.data.game.slot = self.data.slot
    Global.CrimDawn.data.game.timer_strength = 60 * self.data.timer_strength
    Global.CrimDawn.data.game.max_diff = self.data.max_diff
    Global.CrimDawn.data.game.score_cap = self.data.score_cap
    Global.CrimDawn.data.game.max_diff_items = self.data.max_diff_items
    Global.CrimDawn.data.game.run_length = self.data.run_length
    DataChanged = true

  elseif not CrimDawn.CorrectSaveLoaded() then return end

  math.randomseed(os.time() + (os.clock() * 1000))

  -- Add drill speed upgrades
  if self.data["Drill Sawgeant"] > Global.CrimDawn.data.x.drill then
    CrimDawn.Log(FileIdent, "Drill Sawgeant Lv" .. self.data["Drill Sawgeant"])
    Global.CrimDawn.data.x.drill = self.data["Drill Sawgeant"]
    CrimDawn.ChatNotify("Received Drill Sawgeant Lv" .. self.data["Drill Sawgeant"] .. "!")
    DataChanged = true
  end

  -- Add Nine Lives upgrades
  if self.data["Nine Lives"] > Global.CrimDawn.data.x.lives then
    CrimDawn.Log(FileIdent, "Nine Lives Lv" .. self.data["Nine Lives"])
    Global.CrimDawn.data.x.lives = self.data["Nine Lives"]
    CrimDawn.ChatNotify("Received Nine Lives Lv" .. self.data["Nine Lives"] .. "!")
    DataChanged = true
  end

  -- Get Perma-Skills
  if self.data["Perma-Skill"] > Global.CrimDawn.data.x.permaskills then
    CrimDawn.Log(FileIdent, "Permaskills: " .. self.data["Perma-Skill"])
    Global.CrimDawn.data.x.permaskills = self.data["Perma-Skill"]
    CrimDawn.ChatNotify("Now have " .. self.data["Perma-Skill"] .. " Perma-Skills!")
    DataChanged = true
  end

  -- Get Perma-Perks
  if self.data["Perma-Perk"] > Global.CrimDawn.data.x.permaperks then
    CrimDawn.Log(FileIdent, "Permaperks: " .. self.data["Perma-Perk"])
    Global.CrimDawn.data.x.permaperks = self.data["Perma-Perk"]
    CrimDawn.ChatNotify("Now have " .. self.data["Perma-Perk"] .. " Perma-Perks!")
    DataChanged = true
  end

  -- Add extra bots
  if self.data["Extra Bot"] > Global.CrimDawn.data.x.bots then
    CrimDawn.Log(FileIdent, self.data["Extra Bot"] .. " bots")
    Global.CrimDawn.data.x.bots = self.data["Extra Bot"]
    CrimDawn.ChatNotify("Received extra bot (" .. self.data["Extra Bot"] .. " total)!")
    DataChanged = true
  end

  if managers.custom_safehouse then -- Safehouse coins
    if self.data["Coins"] > Global.CrimDawn.data.x.coins then
      CrimDawn.Log(FileIdent, "Giving " .. 2 * (self.data["Coins"] - Global.CrimDawn.data.x.coins) .. " coins")
      managers.custom_safehouse:add_coins(2 * (self.data["Coins"] - Global.CrimDawn.data.x.coins))
      CrimDawn.ChatNotify("Received " .. 2 * (self.data["Coins"] - Global.CrimDawn.data.x.coins) .. " coins!")
      Global.CrimDawn.data.x.coins = self.data["Coins"]
      DataChanged = true
    end
  end

  -- Unlock saws
  if Global.CrimDawn.data.x.saws == 0 and self.data["OVE9000 Saw"] then
    CrimDawn.Log(FileIdent, "Unlocking first saw")
    local saw = ({ "saw", "saw_secondary" })[math.random(2)]
    Global.CrimDawn.data.unlocks[saw] = true
    managers.upgrades:aquire(saw)
    Global.CrimDawn.data.x.saws = 1
    CrimDawn.ChatNotify("Unlocked an OVE9000 saw!")
    DataChanged = true
  end

  if Global.CrimDawn.data.x.saws == 1 and self.data["OVE9000 Saw"] == 2 then
    CrimDawn.Log(FileIdent, "Unlocking second saw")
    Global.CrimDawn.data.unlocks.saw = true
    if not Global.upgrades_manager.aquired.saw then managers.upgrades:aquire("saw") end
    Global.CrimDawn.data.unlocks.saw_secondary = true
    if not Global.upgrades_manager.aquired.saw_secondary then managers.upgrades:aquire("saw_secondary") end
    Global.CrimDawn.data.x.saws = 2
    CrimDawn.ChatNotify("Unlocked second OVE9000 saw!")
    DataChanged = true
  end

  -- Unlock random deployables
  local UnlockObtained = 0
  for _, deployable in ipairs(Global.CrimDawn.tables.etc.deployables) do
    if Global.CrimDawn.data.unlocks[deployable] then UnlockObtained = UnlockObtained + 1 end
  end

  for _, key in ipairs(CrimDawn.state.upg_queue) do
    if key == "deployables" then UnlockObtained = UnlockObtained + 1 end
  end

  if self.data["Deployable"] > UnlockObtained then
    local UnlockNeeded = self.data["Deployable"] - UnlockObtained
    for i = 1, UnlockNeeded do
      table.insert(CrimDawn.state.upg_queue, {BaseTable = "etc", TableName = "deployables" })
    end

    DataChanged = true
  end

  -- Unlock random armours
  local UnlockObtained = 0
  for _, armour in ipairs(Global.CrimDawn.tables.etc.armour) do
    if Global.CrimDawn.data.unlocks[armour] then UnlockObtained = UnlockObtained + 1 end
  end

  for _, key in ipairs(CrimDawn.state.upg_queue) do
    if key == "armour" then UnlockObtained = UnlockObtained + 1 end
  end

  if self.data["Armor"] > UnlockObtained then
    local UnlockNeeded = self.data["Armor"] - UnlockObtained
    for i = 1, UnlockNeeded do
      table.insert(CrimDawn.state.upg_queue, {BaseTable = "etc", TableName = "armour" })
    end

    DataChanged = true
  end

  -- Unlock random primaries
  local UnlockObtained = 0
  for _, weapon in ipairs(Global.CrimDawn.tables.weapons.primaries) do
    if Global.CrimDawn.data.unlocks[weapon] then UnlockObtained = UnlockObtained + 1 end
  end

  for _, key in ipairs(CrimDawn.state.upg_queue) do
    if key == "primaries" then UnlockObtained = UnlockObtained + 1 end
  end

  if self.data["Primary Weapon"] > UnlockObtained then
    local UnlockNeeded = self.data["Primary Weapon"] - UnlockObtained
    for i = 1, UnlockNeeded do
      table.insert(CrimDawn.state.upg_queue, {BaseTable = "weapons", TableName = "primaries" })
    end

    DataChanged = true
  end
  
  -- Unlock random akimbos
  local UnlockObtained = 0
  for _, weapon in ipairs(Global.CrimDawn.tables.weapons.akimbos) do
    if Global.CrimDawn.data.unlocks[weapon] then UnlockObtained = UnlockObtained + 1 end
  end

  for _, key in ipairs(CrimDawn.state.upg_queue) do
    if key == "akimbos" then UnlockObtained = UnlockObtained + 1 end
  end

  if self.data["Akimbo"] > UnlockObtained then
    local UnlockNeeded = self.data["Akimbo"] - UnlockObtained
    for i = 1, UnlockNeeded do
      table.insert(CrimDawn.state.upg_queue, {BaseTable = "weapons", TableName = "akimbos" })
    end

    DataChanged = true
  end

  -- Unlock random secondaries
  local UnlockObtained = 0
  for _, weapon in ipairs(Global.CrimDawn.tables.weapons.secondaries) do
    if Global.CrimDawn.data.unlocks[weapon] then UnlockObtained = UnlockObtained + 1 end
  end

  for _, key in ipairs(CrimDawn.state.upg_queue) do
    if key == "secondaries" then UnlockObtained = UnlockObtained + 1 end
  end

  if self.data["Secondary Weapon"] > UnlockObtained then
    local UnlockNeeded = self.data["Secondary Weapon"] - UnlockObtained
    for i = 1, UnlockNeeded do
      table.insert(CrimDawn.state.upg_queue, {BaseTable = "weapons", TableName = "secondaries" })
    end

    DataChanged = true
  end

  -- Unlock random melees
  local UnlockObtained = 0
  for _, weapon in ipairs(Global.CrimDawn.tables.weapons.melee) do
    if Global.CrimDawn.data.unlocks[weapon] then UnlockObtained = UnlockObtained + 1 end
  end

  for _, key in ipairs(CrimDawn.state.upg_queue) do
    if key == "melee" then UnlockObtained = UnlockObtained + 1 end
  end

  if self.data["Melee Weapon"] > UnlockObtained then
    local UnlockNeeded = self.data["Melee Weapon"] - UnlockObtained
    for i = 1, UnlockNeeded do
      table.insert(CrimDawn.state.upg_queue, {BaseTable = "weapons", TableName = "melee" })
    end

    DataChanged = true
  end

  -- Unlock random throwables
  local UnlockObtained = 0
  for _, weapon in ipairs(Global.CrimDawn.tables.weapons.throwables) do
    if Global.CrimDawn.data.unlocks[weapon] then UnlockObtained = UnlockObtained + 1 end
  end

  for _, key in ipairs(CrimDawn.state.upg_queue) do
    if key == "throwables" then UnlockObtained = UnlockObtained + 1 end
  end

  if self.data["Throwable"] > UnlockObtained then
    local UnlockNeeded = self.data["Throwable"] - UnlockObtained
    for i = 1, UnlockNeeded do
      table.insert(CrimDawn.state.upg_queue, {BaseTable = "weapons", TableName = "throwables" })
    end

    DataChanged = true
  end

  -- Unlock random skills
  if self.data["Skill"] > Global.CrimDawn.data.x.skills then
    local SkillsNeeded = self.data["Skill"] - Global.CrimDawn.data.x.skills
    CrimDawn:RandomUpgrade(SkillsNeeded, "skills")

    Global.CrimDawn.data.x.skills = self.data["Skill"]
    CrimDawn.ChatNotify("Received new skills!")
    DataChanged = true
  end

  -- Unlock random perks
  if self.data["Perk"] > Global.CrimDawn.data.x.perks then
    local PerksNeeded = self.data["Perk"] - Global.CrimDawn.data.x.perks
    CrimDawn:RandomUpgrade(PerksNeeded, "perks")

    Global.CrimDawn.data.x.perks = self.data["Perk"]
    CrimDawn.ChatNotify("Received new perks!")
    DataChanged = true
  end

  -- Unlock random stat boosts
  if self.data["Stat Boost"] > Global.CrimDawn.data.x.stats then
    local StatsNeeded = self.data["Stat Boost"] - Global.CrimDawn.data.x.stats
    CrimDawn:RandomUpgrade(StatsNeeded, "stats")

    Global.CrimDawn.data.x.stats = self.data["Stat Boost"]
    CrimDawn.ChatNotify("Received new stat boosts!")
    DataChanged = true
  end

  if DataChanged then -- Pull upgrades from save file and split them into a table/index pair
    for _, upgrade in pairs(Global.CrimDawn.data.upgrades) do
      local tableName, upgradeName = upgrade:match("([^%-]+)%-(.+)")
      if tonumber(upgradeName) then upgradeName = tonumber(upgradeName) end -- Permaupgrades

      if tableName == nil then -- If the table is nil it's an actual upgrade ID, we can just add it
        if not Global.upgrades_manager.aquired[upgrade] then managers.upgrades:aquire(upgrade) end

      else -- On a table/index pair, look it up and add all upgrades it encompasses
        for _, currentUpgrade in ipairs(Global.CrimDawn.tables.upgrades[tableName][upgradeName]) do
          if not Global.upgrades_manager.aquired[currentUpgrade] then managers.upgrades:aquire(currentUpgrade) end
        end
      end
    end
  CrimDawn:RandomUnlock()
  CrimDawn:WriteSave(FileIdent, "received client update")
  end
end