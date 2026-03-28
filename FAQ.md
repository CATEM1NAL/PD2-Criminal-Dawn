# FAQ & Common Issues
This page contains simple answers to common issues or questions you might have.

## What mods is this compatible with?
As long as it isn't a total overhaul or a mod that adds new content (new weapons, new heists, etc)
it should work fine! Custom weapons will probably be available from the start, and custom heists just
won't appear at all.

This mod does have built in support for BigLobby, but in my testing it seemed a little unstable.
I left it in as an option in the YAML since it *is* pretty neat, even if a little broken. I don't
recommend it as a serious option though.

## Does this work in VR?
No idea! Feel free to give it a shot and tell me how it goes, but realistically it *should* work?
The VR exclusive skill/perk bonuses are not part of this mod and I don't know if VR supports BLT's
custom keybinds - if it does and QuickMenu works, then the mod should be fully playable.

## How do I join an in-game lobby?
1. Connect to the multiworld using the Criminal Dawn client in the Archipelago launcher.
2. Launch PAYDAY 2 (if you haven't already) and click "Create Lobby".
3. You can now connect to any other lobby in the same multiworld!

## I'm trying to connect to a multiworld, but it disconnects instantly.
Check the client! If it's failing and popping an error box, something is going horribly wrong -
otherwise there should be a message that explains the issue. Most likely you haven't wiped your
old multiworld data from the game yet; the client provides a step-by-step guide to doing this
correctly.

## Why do I have hundreds of coins?
After installing the mod for the first time you get given coins for achievement milestones.
You can either roll with it and take the one time bonus for your first multiworld, or reset the
save file to fix it (Options > Advanced > Reset Account Progression).

## How do I see my current skills/perks/stat boosts?
Go to Options > Mod Keybinds > Criminal Dawn Upgrades. Set the key to whatever you want, and now you
can see a list of your upgrades at any time!

## I keep getting [heist] and it sucks.
Go to Options > Mod Options > Criminal Dawn and you can disable literally any heist in the game.
You can do this at any time, but if the game has already picked a heist you need to play it first.
The heists are grouped by tier (heist 1, 2, 3, 4, 5) - make sure you don't disable an entire tier
at once, or the game **will** crash. You need to own DLC heists for them to be in the pool, even if
they're enabled.

## How many upgrades are there?
7 Perma-Skills, 7 Perma-Perks, 13 Skills, 13 Perks, and between 13 and 52 Stat Boosts.

There are also 2 Drill Sawgeant upgrades and 2 Nine Lives upgrades.

### Those are some weird numbers.
I was leaning into PAYDAY 2's playing card motif, so the perks and skills add up to 21.
There are more references like this, for example the YAML setting for the number of score checks;
368 is the max value of all cards in a deck plus four jokers (clowns).

### Two Nine Lives upgrades?
Yes! It turns out there's a second upgrade for Nine Lives in the base game which gives you 3 more
downs instead of 1. Makes sense as to why it was never used, but it makes my life more convenient.

### So all the upgrades in the mod are vanilla (even if unused)?
Yep! Everything currently in the mod is something that already exists within the game. I haven't
looked into making custom upgrades yet, but it is something I want to do eventually.

## Can I use multiple save files to play multiple multiworlds at once?
No. I have a concept for an automated save switching system that will allow you
to jump between multiworlds without having to reset your multiworld data, but due to how PAYDAY 2
works it will take a bit of time to figure out and implement. Due to this it's a low priority feature,
however I can bump it up the queue if enough people want this to happen!
