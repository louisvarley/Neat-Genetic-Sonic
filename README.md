# NEAT Sonic the Headgehog 2

Update to [Seth Bling's Mar I/O][1] lua code, forked from [mam91/Neat-Genetic-Mario][2].

Original https://github.com/wts42/Neat-Genetic-Mario/
Updated https://github.com/mam91/Neat-Genetic-Mario

This lua code originally written for Mario on the SNES / NES. This implementation is coded
to use the same underlying NEAT lua code with tweaks for Sonic the Hedgehog 2 on the Megadrive / Genesis. 

## Additions & changes ##
* [x] Added sonic 2 sprites with simple good, bad, neutral types
* [x] Joined the files back together as easier to debug on Bizhawk
* [x] Removed code not needed for sonic and renamed others.
* [x] Custom JoyPad function so AI doesnt hold down buttons *
* [x] Added a more defined bonus / reward config for powerups, rings, scores.
* [x] Can deal with finishing a level to continue onto the next on the same run by checking for locked controls.
* [x] Basic reward system when fighting a boss so it continues as long as is still hitting the boss
* [x] Jump checking so we can reward jumping vs just running forward
* [x] Getting hit now causes instant restart, this increases generation progress but better long term performance.
* [x] Console now outputs information from previous run including fitness, bonuses, rightmost, etc. 

## Instructions
1. Install [BizHawk](https://github.com/TASVideos/BizHawk) prerequesites & emulator:
2. Download run.lua, place into BizHawk/Lua/Genesis/Neat
3. Create 2 folders, pool and state in the Neat folder
4. Get the rom of [Sonic 2] any build works providing the RAM locations are the same. 
5. Load sonic and created a Named Save State called S2.State on the level you want to start from and put into state 
5. Run the script from Tools / Lua Console / finally click start

I, in no way claim to have written any of the LUA Neat implementation in this script other than some minor tweaks to weighting and generation. 

## Observations

In most instances, it takes around 19 generations to get past the first level, after 25 generations mine was getting to
robonik every time. Time to this generation is around 3 days. 

## Notes

* Notice that in Mario, holding the A button will cause many jumps, on sonic, this causes 1 jump. Instantly putting the AI
into some bad habbits that continue into later generations taking many more runs to stop. The new JoyPad function will, should the A button
be held by the AI, will set itself to false regardless every 5th frame, this has the same affect as holding down A causing many jumps. 
This speeds up generation and progress by a huge degree. 


