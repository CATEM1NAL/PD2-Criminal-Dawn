# FAQ
This page contains simple answers to common issues or questions you might have.

## What mods is this compatible with?
As long as it isn't a total overhaul or a mod that adds new content (new weapons, new heists, etc)
it should work fine! Custom weapons will probably be available from the start, and custom heists just
won't appear at all.

This mod does have built in support for BigLobby, but in my testing it seemed a little unstable.
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
same items/upgrades, though!).

Each player using their own YAML gives more freedom for people to choose their own item limits,
but works best if everyone is using the same gameplay settings (run length/timer settings). This
requires some coordination to set up and can lead to some weirdness such as one player hitting
the score cap while the others have a higher score cap, but also allows for some more complex
decision making (such as changing host based on who has the most time upgrades).

Due to how flexible the multiplayer system is, you can do some pretty cool stuff. For example if
someone gets BKd and they own PAYDAY 2, they can set up the mod, connect to a Criminal Dawn slot,
and hop into the lobby until they get unstuck! You could also do a sync where everyone has their
own games, but periodically you all join a Criminal Dawn slot to get a few checks. You can be as
creative with this game's inclusion in a multiworld as you want to be.

## Why do I have hundreds of coins?
After installing the mod for the first time you get given coins for achievement milestones.
You can either roll with it and take the one time bonus for your first multiworld, or reset the
save file to fix it (`Options > Advanced > Reset Account Progression`).

## How do I send checks?
Just play the game! Basically anything you do will give you points that contribute to getting checks,
with the number of points scaling as your run progresses and you receive more items.

There are also checks locked behind the safehouse, with **138** on 6 heist mode or **92** on
4 heist mode. The coins needed to unlock these are multiworld items. To move on to the next tier you
need to fully upgrade the previous tier and finish the next heist (heist 1 completed for tier 2,
heist 2 completed for tier 3, etc).

Finally, you also send checks when you reach a new heist milestone (heist 1 completed, heist 2
completed, etc). These are always progression items.

## How do I join an in-game lobby?
1. Connect to the multiworld using the Criminal Dawn client in the Archipelago launcher.
2. Launch PAYDAY 2 (if you haven't already) and click "Initialise Multiworld".
3. You can now connect to any other lobby in the same multiworld!

## How do I see my current skills/perks/stat boosts?
Go to `Options > Mod Keybinds > Criminal Dawn Upgrades`. Set the key to whatever you want, and now you
can see a list of your upgrades at any time!

## How many upgrades do I get in a playthrough?
7 Perma-Skills, 7 Perma-Perks, 13 Skills, 13 Perks, and at least 13 Stat Boosts.

There are also 2 Drill Sawgeant upgrades and 2 Nine Lives upgrades.

### The fuck is a Perma-Skill/Perk?
Basically a progressive line of upgrades. The Perma-Perks are the universal perk cards (with the
final one being an upgraded Walk-In Closet (which is actually just Fully Loaded)). The skills
are organised in such a way that they give you generally useful abilities, for example the second
skill allows you to bag bodies and the third skill allows you to intimidate cops.

### Those are some weird numbers.
I was leaning into PAYDAY 2's playing card motif, so the perks and skills add up to 21.
There are more references like this, for example the YAML setting for the number of score checks;
386 is the max value of all cards in a deck plus 22 jokers.

### Two Nine Lives upgrades?
Yes! It turns out there's a second upgrade for Nine Lives in the base game which gives you 3 more
downs instead of 1. Makes sense as to why it was never used, but it makes my life more convenient.

### So all the upgrades in the mod are vanilla?
Yep! Everything currently in the mod is something that already exists within the game. I haven't
looked into making custom upgrades yet, but it is something I want to do eventually. There are a
decent number of unused upgrades in the game's code that I've enabled though, so you'll probably
see some stuff you've never seen before.

## I keep getting [heist] and it sucks.
Go to `Options > Mod Options > Criminal Dawn` and you can disable any heist in the game.
You can do this at any time, but if the game has already picked a heist you need to play it first.

I'd recommend only disabling the heists you *really* don't like, as disabling too many may
negatively impact the experience.

## I'm trying to connect to a multiworld, but it disconnects instantly.
Check the client! If it's failing and popping an error box, something is going horribly wrong -
otherwise there should be a message that explains the issue. Most likely you haven't wiped your
old multiworld data from the game yet; the client provides a step-by-step guide to doing this
correctly.

## Can I use multiple save files to play multiple multiworlds at once?
No. I have a concept for an automated save switching system that will allow you
to jump between multiworlds without having to reset your multiworld data, but it will take a bit
of time to figure out and implement. Due to this it's a low priority feature,
however I can bump it up the queue if enough people want this to happen!
