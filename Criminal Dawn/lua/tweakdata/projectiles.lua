Hooks:PostHook(BlackMarketTweakData, "_init_projectiles", "CrimDawn_ProjectileTweakInit", function(self)
  self.projectiles.wpn_prj_ace.max_amount = 1

  local throwables = {
    [12] = { laser_watch = 10, xmas_snowball = 2 },
    [30] = { wpn_gre_electric = 1, concussion = 2, fir_com = 2 },
    [45] = { frag_com = 2, frag = 1, dada_com = 1 },
    [60] = { sticky_grenade = 1, dynamite = 1 },
    [75] = { molotov = 1, poison_gas_grenade = 1 }
  }

  self.projectiles.damage_control.ignore_auto_equip = true
  self.projectiles.tag_team.ignore_auto_equip = true
  self.projectiles.copr_ability.ignore_auto_equip = true
  self.projectiles.pocket_ecm_jammer.ignore_auto_equip = true
  self.projectiles.chico_injector.ignore_auto_equip = true
  self.projectiles.smoke_screen_grenade.ignore_auto_equip = true

  for regen, category in pairs(throwables) do
    for weapon, count in pairs(category) do
      self.projectiles[weapon].base_cooldown = regen
      self.projectiles[weapon].max_amount = count
      self.projectiles[weapon].ignore_auto_equip = true
    end
  end
end)