# FAQ
This page contains simple answers to common issues or questions you might have.

## The world doesn't generate/I can't find the client.
Make sure you have the [0.6.7 launcher](https://github.com/ArchipelagoMW/Archipelago/releases/latest)!

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
**Original (4 Heists, ~8 hours):**  
Run Length / Safe House Tiers: 4  
Score Checks: 68

**Original (6 Heists, ~12 hours):**  
Run Length / Safe House Tiers: 6  
Score Checks: 72

**Score (80 checks, ~? hours):**  
Safe House Tiers: 2  
Score Checks: 64

**Campaigns:**  
Safe House Tiers: 1  
Score Checks: 77

## What mods is this compatible with?
As long as it isn't a total overhaul or a mod that adds new content (new weapons, new heists, etc)
it should work fine! Custom weapons will probably be available from the start, and custom heists just
won't appear at all.

The world has built in support for BigLobby, but in my testing it seemed a little unstable.
I left it in as an option in the YAML since it *is* pretty neat, even if a little broken. I don't
recommend it as a serious option though.

Due to this mod adding a persistent point of no return timer, some HUDs might be a bit fucky.
From my testing there won't be any major issues but most HUDs *won't* tell you if an assault is
currently in progress, and some HUDs may potentially hide the hostage counter too. Out of all the
custom HUDs I tried only MUI and VanillaHUD+ work exactly as intended.

## Does this work in VR?
No idea! Feel free to give it a shot and tell me how it goes, but realistically it *should* work?
The VR exclusive skill/perk bonuses are not part of this mod and I don't know if VR supports BLT's
custom keybinds - if it does and QuickMenu works, then the mod should be fully playable.

## Is this multiplayer?
Yes! Same slot coop is the preferred way to play syncs, with everyone that wants to play together
connecting to the same player slot. This means only one YAML is needed and everyone gets the same
items at the same time, creating a more cohesive experience (this doesn't mean you all get the
same unlocks/upgrades, though!).

Each player using their own YAML also works, but will be kinda weird unless everyone is using the
same gameplay settings. This requires some coordination to set up and can lead to some weirdness
such as one player hitting the score cap while the others have a higher score cap.

Due to how flexible the multiplayer system is, you can do some pretty cool stuff. For example if
someone gets BKd and they own PAYDAY 2, they can set up the mod, connect to a Criminal Dawn slot,
and help out until they get unstuck!

## How do I send checks?
Just play the game! Basically anything you do will give you points that contribute to getting checks,
with the number of points scaling as your run progresses and you receive more items. You can check
various score related stats by typing `/score` into the client.

There are also checks locked behind the safehouse, with **138** on 6 heist mode or **92** on
4 heist mode. The coins needed to unlock these are multiworld items. To move on to the next tier you
need to fully upgrade the previous tier and finish the next heist (heist 1 completed for tier 2,
heist 2 completed for tier 3, etc).

Finally, you also send checks when you reach a new heist milestone (heist 1 completed, heist 2
completed, etc). These are always progression items.

## How do I join an in-game lobby?
1. Connect to the multiworld using the Criminal Dawn client in the Archipelago launcher.
2. Launch PAYDAY 2 (or restart it if it was already open) and click "Load Client Data".
3. You can now connect to any other lobby in the same multiworld!

## How do I see my current skills/perks/stat boosts?
In the inventory clicking on skills or perks will open the upgrade menu.

You can also see this menu in game by going to `Options > Mod Keybinds > Criminal Dawn Upgrades`.
Set the key to whatever you want, and now you can see the full list at any time!

## How many upgrades do I get in a playthrough?
7 Perma-Skills, 7 Perma-Perks, 13 Skills, 13 Perks, and at least 7 Stat Boosts.

There are also 2 Drill Sawgeant upgrades and 2 Nine Lives upgrades.

### The fuck is a Perma-Skill/Perk?
Basically a progressive line of upgrades. The Perma-Perks are the universal perk cards (with the
final one being an upgraded Walk-In Closet (which is actually just Fully Loaded)). The Perma-Skills
are organised in such a way that they give you generally useful abilities, for example the second
Perma-Skill allows you to bag bodies and the third Perma-Skill allows you to intimidate cops.

### Those are some weird numbers.
I was leaning into PAYDAY 2's playing card motif, so the perks and skills add up to 21 each (52 total).

### Two Nine Lives upgrades?
Yes! It turns out there's a second upgrade for Nine Lives in the base game which gives you 3 more
downs instead of 1. Makes sense as to why it was never used, but it makes my life more convenient.

### So all the upgrades in the mod are vanilla?
Yep! Everything currently in the mod is something that already exists within the game. I haven't
looked into making custom upgrades yet, but it is something I want to do eventually. There are a
decent number of unused upgrades in the game's code that I've enabled though, so you'll probably
see some stuff you've never seen before.

## The mod is too hard!
Go to `Options > Mod Options > Criminal Dawn` and you can change the difficulty cap. The difficulty
increases towards the cap as you progress through a run and receive items.

## I don't like the mutators.
Go to `Options > Mod Options > Criminal Dawn` and you can change the mutator mode. There are
four options:
- **Off:** No random mutators will generate. Friendly Fire (Hard+) and Winters' Shields (Death Wish+) will still be enabled.
- **On:** Number of mutators will scale with heist number (1 mutator for first heist, 2 for second heist, etc).
- **On + Scaling (default):** Number of mutators will also scale with items received in the same way as difficulty.
- **Inverted Scaling:** Number of mutators will start maxed out (based on difficulty setting), but decrease as you receive items.

## I keep getting [heist] and it sucks.
Go to `Options > Mod Options > Criminal Dawn` and you can disable any heist in the game.
You can do this at any time, but if the game has already picked a heist you need to play it first.

I'd recommend only disabling the heists you *really* don't like, as disabling too many will limit
the available pool which may negatively impact the experience. Disabling every heist will also cause
the game to crash on heist generation, so uh... don't do that.

Disabling heists has no effect during campaign runs.

## I'm playing but nothing is happening.
Did you connect to a different multiworld while in a lobby? In this case the game will allow you
to keep playing, but you won't be able to make any progress or receive any items. Always restart
the game after connecting to a multiworld.

## I'm trying to connect to a multiworld, but it disconnects instantly.
Check the client! If something is going horribly wrong, it should tell you the reason. If nothing
is happening then something is going *horribly* wrong.
