local FileIdent = "gameover"

Hooks:PostHook(GameOverState, "at_enter", "CrimDawn_HeistFailed", function(self)
  Global.CrimDawn.data.upgrades = {}

  -- Generate new random upgrades
  CrimDawn:RandomUpgrade(Global.CrimDawn.data.x.skills, "skills")
  CrimDawn:RandomUpgrade(Global.CrimDawn.data.x.perks, "perks")
  CrimDawn:RandomUpgrade(Global.CrimDawn.data.x.stats, "stats")
  
  local DeployableUpgrades = 0
  for _, deployable in ipairs(Global.CrimDawn.tables.etc.deployables) do
    if Global.CrimDawn.data.unlocks[deployable] then DeployableUpgrades = DeployableUpgrades + 1 end
  end

  CrimDawn:RandomUpgrade(DeployableUpgrades, "deployable")

  -- Prevent deathlink loopback, setup next run
  Global.CrimDawn.data.game.deathlink = os.time() + 10
  if NetworkHelper:IsHost() then
    Global.CrimDawn.data.game.run = Global.CrimDawn.data.game.run + 1
    Global.CrimDawn.data.game.ponr = false
    Global.CrimDawn.data.game.heists = {}
  end

  CrimDawn:WriteSave(FileIdent, "run failed")
end)