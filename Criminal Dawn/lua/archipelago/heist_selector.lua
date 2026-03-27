local FileIdent = "heist_selector"

function CrimDawn:NextHeist(HeistsWon)
  local TierIndex = (6 - Global.CrimDawn.data.game.run_length) + (HeistsWon or 0) + 1
  local CurrentTier
  local ValidHeists = deep_clone(Global.CrimDawn.tables.heists)

  for tier, heists in pairs(ValidHeists) do
    for i = #heists, 1, -1 do
      if CrimDawn.SettingsData[heists[i]] == false then table.remove(heists, i) end
    end
  end

  -- Try to add conditional heists
  local PeerTable = managers.network and managers.network:session() and managers.network:session():peers()
  local PeerCount = Global.CrimDawn.data.x.bots + table.size(PeerTable or {})
  local StealthTutorial, LoudTutorial

  for _, heist in ipairs(Global.CrimDawn.tables.heists.tier1) do
        if heist == "short1" then StealthTutorial = true
    elseif heist == "short2" then LoudTutorial = true
    end
  end

  -- Tutorials: only valid if softlock impossible (bodybags/player count)
  if not StealthTutorial and Global.CrimDawn.data.x.permaskills > 1 then table.insert(Global.CrimDawn.tables.heists.tier1, "short1") end
  if not LoudTutorial and PeerCount > 1 then table.insert(Global.CrimDawn.tables.heists.tier1, "short2") end

  -- If we haven't won yet, prevent duplicate heists and pick from next tier
  if Global.CrimDawn.tables.heists["tier" .. TierIndex] then

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

    -- 28 Stores replaces final heist with 30+ minutes
    if Global.CrimDawn.data.game.ponr >= 1800 then ValidHeists.tier6 = {"cd_28stores"} end

    CurrentTier = ValidHeists["tier" .. TierIndex]

  -- If we HAVE won then allow duplicate heists and ignore heist tiering
  else CurrentTier = ValidHeists["tier" .. math.random(#ValidHeists)] end

  local NextHeist = CurrentTier[math.random(#CurrentTier)]
  assert(NextHeist ~= nil, "no available heists, are they all disabled?")

  table.insert(Global.CrimDawn.data.game.heists, NextHeist)
  NextHeist = Global.CrimDawn.data.game.heists[#Global.CrimDawn.data.game.heists]

  self.Log(FileIdent, NextHeist)
  self:WriteSave(FileIdent, "next heist selected")
end