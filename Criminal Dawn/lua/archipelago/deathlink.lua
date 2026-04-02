local FileIdent = "deathlink"

Hooks:PreHook(PlayerDamage, "damage_bullet", "CrimDawn_DamageBullet", function(self)  
  CrimDawnClient:LoadData()
  CrimDawnClient.data.deathlink = CrimDawnClient.data.deathlink or 0

  if CrimDawnClient.data.deathlink > Global.CrimDawn.data.game.deathlink then
    self._revives = Application:digest_value(math.max(Application:digest_value(self._revives, false) - 1, 1), true)
    managers.environment_controller:set_last_life(Application:digest_value(self._revives, false) <= 1)
    -- reduce downs remaining by 1. sidenote: this fucking sucks ass

    self:_send_set_revives()
    CrimDawn.ChatNotify("Death link received!")

    Global.CrimDawn.data.game.deathlink = CrimDawnClient.data.deathlink
    CrimDawn:WriteSave(FileIdent, "deathlink")
  end
end)