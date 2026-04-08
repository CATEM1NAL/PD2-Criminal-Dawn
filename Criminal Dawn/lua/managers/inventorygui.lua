Hooks:PostHook(PlayerInventoryGui, "init", "CrimDawn_InventoryGUI", function(self)
  if Global.CrimDawn.data.game.seed then CrimDawnClient:PollData() end
end)

Hooks:OverrideFunction(PlayerInventoryGui, "open_skilltree_menu", function()
  dofile(CrimDawn.ModPath .. "lua/upgrade_menu.lua")
  CrimDawn.DisplaySkills()
end)

Hooks:OverrideFunction(PlayerInventoryGui, "open_specialization_menu", function()
  dofile(CrimDawn.ModPath .. "lua/upgrade_menu.lua")
  CrimDawn.DisplayPerks()
end)