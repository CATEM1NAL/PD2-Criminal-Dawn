# PAYDAY 2: Criminal Dawn
PAYDAY 2 mod that turns the game into a multiworld roguelite, powered by [Archipelago](https://archipelago.gg).

[APWorld Repo](https://github.com/CATEM1NAL/Archipelago/tree/payday2/worlds/pd2_crimdawn) • [Trello Board](https://trello.com/b/iiMFiVjE/payday-2-criminal-dawn-apworld) • [FAQ & Common Issues](https://github.com/CATEM1NAL/PD2-Criminal-Dawn/blob/main/FAQ.md)

## Why?
Because Archipelago is fucking awesome and deserves more implementations.
PAYDAY 2 is a game that I have put 3000 hours into since 2014. Makes a lot of sense that I'd do this, right?

As for why the mod is a roguelite - PAYDAY 2 is a game without a structure so I figured trying to make a standard
implementation would be a bit hellish (especially when trying to factor in DLCs). Additionally I just don't have much fun with the
game having played it to death and having squeezed the game dry. Randomised builds and loadouts that you are forced
to use creates an interesting player experience where I'm actually excited to see if the fucked up skill/perk combo I
got is actually viable. Turning the game into a roguelite also provides a solution to the number one problem: what's the goal?

## So what *is* the goal?
To beat 6 (or 4) heists in a row without failing. The heists are grouped into tiers that loosely follow heist complexity/story progress,
so later heists tend to be heists that are grander in scale or concept than those that come before. Jewelry Store and Ukrainian Job are
only valid in the 1st of 6 heist tiers for example (and you literally won't play them in 4 heist mode!).

Beating 6 heists in a row sounds easy, right?

## How is this hard?
At the very beginning the game starts on normal difficulty with one random mutator active. Every heist the difficulty
increases, and you get another random mutator. You can choose the difficulty cap in the APWorld YAML, but the minimum is Overkill.
As you receive more items, the starting difficulty and number of mutators gradually increase to keep the game balanced.

If you think you can beat White House or Crude Awakening on Overkill with no skills, no perks, no bots, no deployable, an AMCAR and Chimano,
and 5 active mutators on Overkill, I would like to see proof. Oh yeah, you also have to finish the entire run in under **10 minutes total**.

## Wait, what?
At the start of the game, each run has a 10 minute point of no return timer that begins counting down after masking up. This timer
persists between heists, effectively capping the length of each run. You can receive items that increase the timer by 10 minutes up
to a cap of 90 minutes (60 minutes in 4 heist mode).

There are some APWorld settings that tweak the timer for different use cases (shorter games and longer games). There's also a setting
that adds an additional time bonus, and after obtaining every time bonus the timer is permanently disabled. This is the default setting,
but if you're okay with potentially failing due to running out of time even after unlocking everything you can, I would recommend turning
it off. The pressure the timer gives you during the final few heists is *extremely* exhilarating.

## How do I send checks?
Score! Pretty much everything you do gives points that progress towards sending a check. Securing bags and Gage packages gives a point,
stealing 100 loose cash or getting 100 kills gives a point, finishing a day of a heist gives a point, and finishing a full heist gives
double points. The number of points you get scales with how far through the run you are and how many items you have received, and
there's also a hard score cap that is increased through the time upgrades - this means you can't just slowly and painfully grind out *every
single check* from the very first heist before receiving any items. Even if that *was* possible, the later checks require so many points
that you'd legitimately be better off just playing the game normally anyway.

There are additional checks locked behind upgrading the safe house. THESE ones legitimately are a concern for Archipelago's logic, so right
now they are forced to only include filler items. This does mean your item unlocks can be behind the safe house so it's still worth going
for them, with coin bundles to upgrade the safe house being a pretty common item in the multiworld. There are always enough coin bundles
to fully upgrade the safe house with 132 coins left over to spend on 22 weapon mods.

Finally, there are checks for finishing each heist number for the first time. Right now these are set to always be progression items.

## Is this multiplayer compatible?
There wouldn't be much point if it wasn't! Ignoring the obvious argument I could make about how Archipelago is inherently multiplayer
(which is a bullshit non-answer), the mod was built to support multiplayer *almost* from the start. There are a few things you need to make
sure of if you want to play this way:

**How many slots?** Each player can use their own YAML and player slot. Playing in the same lobby like this means you will send checks
in tandem, multiplying the number of checks per location. This also means you can play more strategically, for example changing lobby host
based on which player has the most time upgrades. Playing this way requires a bit more preparation, as it works best with all players using
the same gameplay YAML settings.

Alternatively you can just use same-slot coop, with only a single YAML and player slot being used for world generation. Everyone playing
Criminal Dawn connects to the same slot, and they will remain perfectly in sync - only one set of checks for the entire game, and no score cap
shenanigans. This is the simplest and most foolproof way of setting up the APWorld.

**^ Note that this does not mean everyone will have the same upgrades and unlocks!** These are still random per player, it simply means everyone
gets their own upgrades and unlocks *at the same time*.

## I don't like you and this APWorld concept sucks.
Thank you for your constructive criticism. I will not take this into account.
