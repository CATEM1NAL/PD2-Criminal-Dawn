Hooks:PostHook(PlayerInventoryGui, "init", "CrimDawn_InventoryGUI", function(self)
  if Global.CrimDawn.data.game.seed then CrimDawnClient:PollData() end
end)