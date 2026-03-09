apd2_heist_tables = {

  -- Small jobs, loot and leave
  tier1 = { "jewelry_store", "ukrainian_job_prof", "four_stores", "mallcrasher",
            "branchbank_prof", "nightclub", "cage", "moon",
            "hvh", "cane" },
  -- Jewelry Store, Ukrainian Job, Four Stores, Mallcrasher,
  -- Bank Heist, Nightclub, Car Shop, Stealing Xmas
  -- ENDLESS: Cursed Kill Room, Santa's Workshop


  -- Small jobs with some extra steps
  tier2 = { "gallery", "family", "watchdogs_wrapper", "roberts", "dinner", "wwh",
            "cane", "help" },
  -- Art Gallery, Diamond Store, Watchdogs, GO Bank, Slaughterhouse, Alaskan Deal
  -- ENDLESS: Santa's Workshop, Prison Nightmare


  -- Medium jobs
  tier3 = { "brb", "sah", "jolly", "alex", "kosugi", "run", "hox_3", "election_day",
            "help", "rat" },
  -- Brooklyn Bank, Shacklethorne, Aftershock, Rats, Shadow Raid, Heat Street,
  -- Hoxton Revenge, Election Day
  -- ENDLESS: Prison Nightmare, Cook Off


  -- Medium jobs with a bigger scale
  tier4 = { "flat", "red2", "glace", "firestarter", "shoutout_raid", "framing_frame",
            "rat", "pines" },
  -- Panic Room, First World Bank, Green Bridge, Firestarter, Meltdown, Framing Frame
  -- ENDLESS: Cook Off, White Xmas


  -- Big jobs
  tier5 = { "dah", "nmh", "bph", "welcome_to_the_jungle", "hox", "tag", "des",
            "pines", "nail" },
  -- Diamond Heist, No Mercy, Hell's Island, Big Oil, Hoxton Breakout, Breakin' Feds, Henry's Rock
  -- ENDLESS: White Xmas, Lab Rats


  -- Final heist
  tier6 = { "vit" }
  -- White House
}

local UnlockedUpgrade = apd2_data.upgrades
-- Add tutorials if conditions are met to not softlock
if apd2_data.x.bots > 1 and UnlockedUpgrade.cable_tie then
  table.insert(apd2_heist_tables.tier1, "short2")
end

if UnlockedUpgrade.player_corpse_dispose and UnlockedUpgrade.player_extra_corpse_dispose_amount then
  table.insert(apd2_heist_tables.tier1, "short1")
end

if apd2_data.game.ponr >= 1800 then
  table.insert(apd2_heist_tables.tier1, "apd2_28stores")
end