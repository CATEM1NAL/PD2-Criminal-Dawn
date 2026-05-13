# FAQ
This page contains simple answers to common issues or questions you might have.

### Index:
1. [World Fails To Generate / Can't Find The Client](https://github.com/CATEM1NAL/PD2-Criminal-Dawn/blob/main/FAQ.md#the-world-doesnt-generatei-cant-find-the-client)
2. [Installation](https://github.com/CATEM1NAL/PD2-Criminal-Dawn/blob/main/FAQ.md#how-do-i-install-thisthe-mod-isnt-working)
   - [Recommended Goal Settings](https://github.com/CATEM1NAL/PD2-Criminal-Dawn/blob/main/FAQ.md#recommended-settings-for-each-goal)
3. [When To Update](https://github.com/CATEM1NAL/PD2-Criminal-Dawn/blob/main/FAQ.md#is-it-safe-for-me-to-update-the-mod-in-the-middle-of-a-multiworld)
4. [DLC Compatibility](https://github.com/CATEM1NAL/PD2-Criminal-Dawn/blob/main/FAQ.md#does-this-include-dlc)
5. [Mod Compatibility](https://github.com/CATEM1NAL/PD2-Criminal-Dawn/blob/main/FAQ.md#what-mods-is-this-compatible-with)
   - [HUD Compatibility](https://github.com/CATEM1NAL/PD2-Criminal-Dawn/blob/main/FAQ.md#which-custom-huds-are-compatible)
6. [VR Compatibility](https://github.com/CATEM1NAL/PD2-Criminal-Dawn/blob/main/FAQ.md#does-this-work-in-vr)
7. [Multiplayer Compatibility](https://github.com/CATEM1NAL/PD2-Criminal-Dawn/blob/main/FAQ.md#is-this-multiplayer)
8. [How To Send Checks](https://github.com/CATEM1NAL/PD2-Criminal-Dawn/blob/main/FAQ.md#how-do-i-send-checks)
9. [Upgrade Menu](https://github.com/CATEM1NAL/PD2-Criminal-Dawn/blob/main/FAQ.md#how-do-i-see-my-current-skillsperksstat-boosts)
10. [Upgrade Details / Perma-Perks & Perma-Skills](https://github.com/CATEM1NAL/PD2-Criminal-Dawn/blob/main/FAQ.md#how-many-upgrades-do-i-get-in-a-playthrough)
11. [Gameplay Changes From Vanilla](https://github.com/CATEM1NAL/PD2-Criminal-Dawn/blob/main/FAQ.md#are-there-any-core-gameplay-changes-i-should-know-about)
12. [Difficulty Scaling](https://github.com/CATEM1NAL/PD2-Criminal-Dawn/blob/main/FAQ.md#the-mod-is-too-easyhard)
13. [Mutator Modes](https://github.com/CATEM1NAL/PD2-Criminal-Dawn/blob/main/FAQ.md#i-dont-like-the-mutators)
14. [Heist Whitelist](https://github.com/CATEM1NAL/PD2-Criminal-Dawn/blob/main/FAQ.md#i-keep-getting-heist-and-it-sucks)
15. [Misc. Issues](https://github.com/CATEM1NAL/PD2-Criminal-Dawn/blob/main/FAQ.md#i-keep-getting-heist-and-it-sucks)

## The world doesn't generate/I can't find the client.
Make sure you have the [0.6.7 launcher](https://github.com/ArchipelagoMW/Archipelago/releases/latest)!
If you're trying to generate a solo world and it's failing, try it a couple of times. It sometimes
fails when generating alone, but if you can't get it to generate at all then your YAML settings might
be incompatible.

## How do I install this/the mod isn't working?
Make sure you have [SuperBLT](https://superblt.znix.xyz/) installed, and then extract
`BLT-Criminal_Dawn.zip` into `PAYDAY 2/mods`. There are a few dependencies which BLT will prompt you
to install after launching the game with Criminal Dawn. Download them, restart the game, and you should
be good to go. You'll know if the mod is working because you will have a fresh save file and the game
will have an orange/pink colour palette (instead of blue). After verifying that the mod is loading
correctly, you need to restart the game before you can start playing.

If you're comfortable modifying YAMLs directly and don't use the options creator, I'd recommend starting
from one of the presets found in `Players/Templates/Presets`. If you use the options creator, the default
settings are the same as the standard 4 heist preset. If you want to try one of the other modes with options creator,
the recommended settings will be below.

When it comes to connecting to the multiworld, always make sure you connect *before* launching the game.
The client automatically handles switching between different save files (if they exist), but the mod only
loads saves on launch. If you connect while the game is open nothing bad will happen, but you will have to
restart for the mod to work again.

### Recommended settings for each goal:
**Original (6 Heists, ~8 hours):**  
Run Length / Safe House Tiers: 6  
Score Checks: 72

**Score (3240 Points):**  
Safe House Tiers: 2  
Score Checks: 64

**Campaign (~4 hours):**  
Safe House Tiers: 1  
Score Checks: 77

## Is it safe for me to update the mod in the middle of a multiworld?
Hotfixes will always be safe to download, but minor releases will be incompatible (e.g.
updating to 0.6.x while playing a world created on 0.5.x will likely crash).

## Does this include DLC?
All DLC that you verifiably own is accounted for by the mod, and it automatically adds the corresponding
content into the appropriate pools.

## What mods is this compatible with?
As long as it isn't a gameplay overhaul or a mod that adds new content (new weapons, new heists, etc)
it should work fine! Custom weapons will probably be available from the start, and custom heists just
won't appear at all.

The world has built in support for BigLobby, but in my testing it seemed a little unstable.
I left it in as an option in the YAML since it *is* pretty neat, even if a little broken. I don't
recommend it as a serious option though.

### Which custom HUDs are compatible?
If a HUD adds a stamina bar, you will probably want to turn it off (stamina is disabled in Criminal Dawn).

The main issues you might come across are related to the assault ticker and hostage counters, as this mod
makes some changes to them. If a HUD uses the default assault panel (or gives you an option to use the default
assault panel), it will probably be fine!

Any info HUD will likely show incorrect values for certain stats as the mod uses some upgrades that are inaccessible in vanilla.

Below is a list of every HUD mod that I've tested, how well they work, and any additional steps needed.

**[MUI](https://modworkshop.net/mod/46681):** Works perfectly.  
**[HopHUD](https://modworkshop.net/mod/31306?tab=description):** Works perfectly.  
**[BL2HUD](https://modworkshop.net/mod/23623):** Works perfectly.  
**[Minimalist HUD Ultimate](https://modworkshop.net/mod/36309):** Works perfectly.

**[Enhanced Vanilla Hud](https://modworkshop.net/mod/43776):** Works perfectly, stamina circle can be disabled at `HUD > Player HUD > Stamina Display`.  
**[HEVHUD](https://modworkshop.net/mod/27954):** Works perfectly, but can't disable stamina bar.

**[Warframe HUD](https://modworkshop.net/mod/36010):** Works perfectly, but some buffs may show incorrect values.  
**[PocoHud3](https://modworkshop.net/mod/40870):** Works perfectly, but some buffs may show incorrect values.  
**[VanillaHUD+](https://modworkshop.net/mod/25629):** Works perfectly, but some hudlist buffs may show incorrect values.  
Stamina circle can be disabled at `General HUD Panel Options > Player Panel > Show Stamina`.  

**[Void UI](https://modworkshop.net/mod/20997):** Works perfectly after disabling assault panel.  
**[CS HUD](https://modworkshop.net/mod/29734):** Works perfectly after disabling assault panel (`Components > Assault Panel`).  
**[Hotline Miami Hud](https://modworkshop.net/mod/27294):** Works perfectly after disabling assault panel (`Hud Options > Assault Panel > Flashing Assault Panel`).  
**[Restoration HUD](https://modworkshop.net/mod/28118):** Works perfectly after disabling assault panel, but first you have to turn the HUD on (why is it off by default???).  
Enable "Alpha HUD On/Off". Disable "Debug Stamina Indicator" and "Alpha Assault Tape".

**[PDTH HUD](https://modworkshop.net/mod/19900):** Works, but no assault indicator. Fixed by disabling "PDTH Style HUD Assault Corner", but ruins the aesthetic.  
**[Sora's HUD Reborn](https://modworkshop.net/mod/22152):** Works, but no assault indicator. Stamina bar can be disabled at `HUD Options > Activate the Stamina Bar`.  
**[HoloUI](https://modworkshop.net/mod/12501):** Works, but assault panel is broken. Easiest fix is disabling "Assault HUD" on the "Main" tab, though this looks out of place.  
Through various settings it's possible to replace the heist timer with the PONR timer, but it's a little jank.

**[Better Assault Indicator](https://modworkshop.net/mod/22712):** Doesn't work - hides hostage counter and no assault indicator.

## Does this work in VR?
No idea! Feel free to give it a shot and tell me how it goes, but realistically it *should* work?
The VR exclusive skill/perk bonuses are not part of this mod, but if QuickMenu works in the VR version
then the mod should be fully playable.

## Is this multiplayer?
Yes! As long as everyone that wants to play together connects to the same multiworld slot, you
can play multiplayer just fine. Players on different slots can't crossplay due to potential issues
with goal conflicts.

Because all it takes is connecting to the slot to play multiplayer, this means anyone else in the
multiworld can join your game at any time if they wish! Get BKd and don't know what to do? Join the
Payday lobby and help out!

## How do I send checks?
Just play the game! Basically anything you do will give you points that contribute to getting checks,
with the number of points scaling as your run progresses and you receive more items. You can check
various score related stats by typing `/score` into the client.

There are also up to **138** checks locked behind the safehouse, depending on how many tiers you pick.
The coins needed to unlock these are multiworld items. To move on to the next tier you need to fully
upgrade the previous tier and finish the next heist (heist 1 completed for tier 2, heist 2 completed for
tier 3, etc).

Finally, you also send checks when you reach a new heist milestone (heist 1 completed, heist 2
completed, etc). These are always progression items.

## How do I see my current skills/perks/stat boosts?
Clicking skills or perks in the inventory will open the upgrade menu.

You can also see this menu in game by going to `Options > Mod Keybinds > Criminal Dawn Upgrades`.
Set the key to whatever you want, and now you can see the full list at any time!

## How many upgrades do I get in a playthrough?
7 Perma-Skills, 7 Perma-Perks, 13 Skills, 13 Perks, at least 7 Stat Boosts, and 8 Extra Lives.
You also get a deployable upgrade for each deployable you have unlocked (up to 9 upgrades).

### The fuck is a Perma-Skill/Perk?
A progressive line of upgrades, giving you generally applicable bonuses:

**Perma-Skills** / **Perma-Perks**
1. **Cat Burglar**: Falls inflict armor damage. / **Blending-In**: +1 concealment.
2. **Cleaner**: Bag bodies. / **Second Skin**: 15% reduced armor speed penalty.
3. **Dominator**: Intimidate non-special enemies. / **Aggressor**: 5% damage bonus.
4. **Drop Cloth**: Enemy death alert range reduced by 95%. / **Walk-in Closet Lv1**: Ammo pickup increased by 35%.
5. **Toolkit**: Repair drills and saws 25% faster. / **Helmet Popping**: 25% headshot damage bonus.
6. **Die Hard**: 50% damage reduction while interacting. / **Triage**: 20% faster doctor bag interactions.
7. **Jack of all Trades**: Hold two deployables. Interact with them twice as fast. / **Walk-in Closet Lv2**: Ammo pickup increased by 75%.

### Those are some weird numbers.
I was leaning into PAYDAY 2's playing card motif, so the perks and skills add up to 21 each.

## Are there any core gameplay changes I should know about?
- **Kickstarter** is guaranteed to repair drills on melee (50% chance in vanilla).
- If you get the associated skill, all drills are guaranteed to be auto restarters (max 30% chance in vanilla).
- Stamina has been removed.
- Remaining downs now persist between heists. You restore one between heists.
- You come out of custody with no extra downs (all downs in vanilla).
- Doctor bags only restore one down (all downs in vanilla).
- Player base health has been slightly reduced to 200 (230 in vanilla).
- Lighter armours recover faster, while heavier armours take longer to recover:
  - **Two-Piece Suit:** 1s regen (affected by suppression).
  - **Lightweight Ballistic Vest:** 1.5s regen (affected by suppression).
  - **Ballistic Vest:** 2.5s regen (affected by suppression).
  - **Heavy Ballistic Vest:** 3.5s regen (affected by suppression).
  - **Flak Jacket:** 4.5s regen (ignores suppression).
  - **Combined Tactical Vest:** 6s regen (ignores suppression).
  - **Improved Combined Tactical Vest:** 7.5s regen (ignores suppression).
- **Tooth and Claw** (Hitman 9) isn't a fixed 1.5s armour regen on armour break - it's now half of your normal regen time, to a minimum of 1.5s.
- Enemy health is locked at **Overkill** values on all difficulties, with a lower headshot/crit multiplier (same as vanilla Normal/Hard).
- Enemy base damage is locked at **Hard** values, with some tweaks for problematic enemies to bring them in line.
  - Enemy damage fall-off/ramp-up values are based on **Overkill**/**Mayhem**.
- Friendly fire is enabled on Hard+, with the damage multiplier increasing by 100% on Very Hard and Overkill (total of 300% team damage).
- Cloaker cuffing is enabled by default, with a chance to be disabled on Very Hard+.
- Snipers don't have lasers on Mayhem+, and now fire tracers.
- Shields are replaced with Winters shields on Death Wish+.
- Enemies cannot penetrate player armour.
- Enemies cannot pick up bags.
- Damage grace period only applies on armour break and duration varies with difficulty. Additionally, revive health is different per difficulty:
  - **Normal:** 2 second grace period, revived with 50% health (10% more than vanilla).
  - **Hard:** 1.5 second grace period, revived with 40% health (same as vanilla).
  - **Very Hard:** 1 second grace period, revived with 30% health (10% less than vanilla).
  - **Overkill:** 0.75 second grace period, revived with 25% health (15% less than vanilla).
  - **Mayhem:** 0.5 second grace period, revived with 20% health (10% more than vanilla).
  - **Death Wish:** 0.25 second grace period, revived with 15% health (5% more than vanilla).
  - **Death Sentence:** No grace period, revived with 10% health (same as vanilla).
- Dodge is no longer random, instead stacking for each shot you take until it exceeds 100%. With 25% dodge you will take 3 shots and then dodge 1, for example.
  - Each consecutive dodge also adds a stack of **entropy** (5% dodge penalty) to prevent insane dodge values from being untouchable. Entropy is reset upon taking damage.
- Sicario's smoke bomb now provides a fixed +50% dodge (unaffected by entropy and works with armour).
- **Agility Shield** (Sicario 7) recovers 10% of your armour on dodge (all armour in vanilla).
- Damage taken cannot be reduced below 1.

It's worth noting that the early game *will* be harder than vanilla PAYDAY 2 due to how the mod is designed,
and even with a strong build you can die very fast if you are caught too heavily out of position. If that
doesn't sound like something that appeals to you and you want to run around carefree from the very beginning,
then this is not the game for you (it's only in the late-game where you semi-consistently get builds that
allow you to completely turn your brain off).

## The mod is too easy/hard!
Go to `Options > Mod Options > Criminal Dawn` in-game and you can change the difficulty cap. The difficulty
increases towards the cap as you progress through a run and receive items.

## I don't like the mutators.
Go to `Options > Mod Options > Criminal Dawn` in-game and you can change the mutator mode. There are
four options:
- **Off:** No random mutators will generate. Cloaker Arrest, Friendly Fire (Hard+), and Winters' Shields (Death Wish+) will still be enabled.
- **On:** Number of mutators will scale with heist number (1 mutator for first heist, 2 for second heist, etc).
- **On + Scaling (default):** Number of mutators will also scale with items received in the same way as difficulty.
- **Inverted Scaling:** Number of mutators will start maxed out (based on difficulty setting), but _decrease_ as you receive items.

## I keep getting [heist] and it sucks.
Go to `Options > Mod Options > Criminal Dawn` in-game and you can stop any heist from appearing in a run.
You can do this at any time, but if the game has already picked a heist you need to play it first.

I'd recommend only disabling the heists you *really* don't like, as disabling too many will limit
the available pool which may negatively impact the experience. Disabling every heist will also cause
the game to crash on heist generation, so uh... don't do that.

Disabling heists has no effect during campaign runs.

### What tiers are the stealth only heists in?
**Tier 1:** Car Shop.  
**Tier 3:** Shadow Raid.  
**Tier 4:** Murky Station & Yacht Heist.  
**Tier 5:** Breakin' Feds.

## I'm playing but nothing is happening.
Did you connect to a different multiworld while in a lobby? In this case the game will allow you
to keep playing, but you won't be able to make any progress or receive any items. Always restart
the game after connecting to a new multiworld.

## I'm trying to connect to a multiworld, but it disconnects instantly.
Check the client! If something is going horribly wrong, it should tell you the reason. If nothing
is happening then something is going *horribly* wrong.
