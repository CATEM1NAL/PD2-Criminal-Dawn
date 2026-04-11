local FileIdent = "moneymanager"

Hooks:PostHook(MoneyManager, "save", "CrimDawn_MoneySave", function(self, data)
  if Global.CrimDawn.data.game.cash ~= Application:digest_value(data.MoneyManager.total, false) then
    Global.CrimDawn.data.game.cash = Application:digest_value(data.MoneyManager.total, false)
    CrimDawn:WriteSave(FileIdent, "cash changed")
  end
end)

Hooks:PostHook(MoneyManager, "load", "CrimDawn_MoneyLoad", function()
  Global.money_manager.total = Application:digest_value(Global.CrimDawn.data.game.cash or 0, true)
end)