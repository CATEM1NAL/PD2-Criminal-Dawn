local FileIdent = "heist_selector"

function CrimDawn:NextHeist(HeistsWon)
  if Global.CrimDawn.data.game.campaign then self:CampaignHeist(HeistsWon) return end

  local TierIndex = (6 - Global.CrimDawn.data.game.run_length) + (HeistsWon or 0) + 1
  
  local ValidHeists = deep_clone(Global.CrimDawn.tables.heists)
  local CurrentTier

  for tier, heists in pairs(ValidHeists) do
    for i = #heists, 1, -1 do
      if CrimDawn.SettingsData[heists[i]] == false then table.remove(heists, i) end
    end
  end

  -- Conditional heists
  local PeerTable = managers.network and managers.network:session() and managers.network:session():peers()

  if #PeerTable == 0 then
    if not StealthTutorial and Global.CrimDawn.data.x.permaskills > 1 then table.insert(ValidHeists.tier1, "short1") end
    if not LoudTutorial and Global.CrimDawn.data.x.bots > 1 then table.insert(ValidHeists.tier1, "short2") end
  end

  -- If we haven't won yet, prevent duplicate heists and pick from next tier
  if ValidHeists["tier" .. TierIndex] then

    -- Remove already played heists from heist pool
    local PlayedHeists = {}

    for _, heist in ipairs(Global.CrimDawn.data.game.heists) do PlayedHeists[heist] = true end

    for tier, heistTable in pairs(ValidHeists) do
      local NewTable = {}

      for _, heist in ipairs(heistTable) do
        if not PlayedHeists[heist] then table.insert(NewTable, heist) end
      end

      ValidHeists[tier] = NewTable
    end

    -- 28 Stores replaces final heist with 27+ minutes
    if not (Global.CrimDawn.data.x.time_upgrades > self.MaxTimeItems()) and Global.CrimDawn.data.game.ponr >= 1620 then
      ValidHeists.tier6 = {"cd_28stores"}
    end

    CurrentTier = ValidHeists["tier" .. TierIndex]

  -- If we HAVE won then allow duplicate heists and ignore heist tiering
  else CurrentTier = ValidHeists["tier" .. math.random(1, 6)] end

  Utils.PrintTable(CurrentTier)
  log(#ValidHeists)

  local NextHeist = CurrentTier[math.random(#CurrentTier)]
  assert(NextHeist ~= nil, "no available heists, are they all disabled?")

  table.insert(Global.CrimDawn.data.game.heists, NextHeist)
  NextHeist = Global.CrimDawn.data.game.heists[#Global.CrimDawn.data.game.heists]

  self.Log(FileIdent, NextHeist)
  self:WriteSave(FileIdent, "next heist selected")
end

local campaigns = {
  ["Return Of The Rat"] = { "watchdogs_wrapper", "cd_firestarter1", "alex", "cd_hox2", "hox_3" },
  ["Murky Day"] = { "kosugi", "shoutout_raid", "pbr", "des" },
  ["I Need My Payday Too"] = { "big", "mus", "mia", "cd_hox1", "kenaz" },
  ["Greatest Heist Of All"] = { "rvd", "brb", "sah", "tag", "bph", "vit" },
  ["Silk Road"] = { "mex", "bex", "pex", "fex" },
  ["City Of Gold"] = { "chas", "chca", "pent" },
  ["Texas Heat"] = { "ranc", "corp", "deep" },
  ["Night Of Frights"] = { "hvh", "help", "nail", "haunted" },
  ["Christmas Special"] = {  },
  ["Classics"] = { "red2", "run", "flat", "glace", "dah", "dinner" },
}

function CrimDawn:CampaignHeist(HeistsWon)
  local NextHeist
  if HeistsWon <= #campaigns[Global.CrimDawn.data.game.goal] then
    NextHeist = campaigns[Global.CrimDawn.data.game.goal][HeistsWon + 1]
    log(NextHeist)
    -- DLC check...
    local FoundHeist
    for tier, _ in pairs(Global.CrimDawn.tables.heists) do
      for _, heist in ipairs(Global.CrimDawn.tables.heists[tier]) do
        if heist == NextHeist then FoundHeist = true break end
      end
    if FoundHeist then break end end
    assert(FoundHeist, "You don't own the next heist (" .. managers.localization:text("heist_" .. NextHeist) .. ")")
    table.insert(Global.CrimDawn.data.game.heists, NextHeist)

  else table.insert(Global.CrimDawn.data.game.heists, math.random(1, #campaigns[Global.CrimDawn.data.game.goal])) end
  self.Log(FileIdent, NextHeist)
  self:WriteSave(FileIdent, "next heist selected")
end