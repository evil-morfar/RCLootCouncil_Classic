# v0.0.1-Alpha.4

## Overview
Initial barebones of the Classic port. Basic functionality such as testing, version syncing etc. is all working. Master Looting and awarding is working to some extent, although mostly untested.

I'll continue to increment this alpha version as more features are getting ported.

## Missing

#### Proper Testing
Haven't done any real raid/instance testing as I probably won't be leveling that much.


## Changes
#### Versioning
In the version checker ("/rc v") the version of this module will show up. The Core RCLootCouncil version is shown when mousing over a player.

#### Master Loot
The options menu have been updated with settings of old regarding Master Looting.

#### Auto Pass
Updated for Classic. For now, Hunters and Shamans doesn't auto pass leather, and Warriors and Paladins doesn't auto pass mail. I haven't decided if it should stay this way, so let me now what you think.

#### Enchanting Level
I haven't found a good way to precisely get a candidate's Enchanting level, so for now it will be displayed as "< 300".


## Removed
#### Loot Status
Not used with Master Looting.

#### Personal Loot
Removed everything related to personal loot.

#### Azerite Armor
No longer an option in the "More Buttons" options.

#### Spec Icon
As there's no clear definition of a spec (nor really the need to have it) the spec icon option has been removed.

#### Role Column
There's no concept of roles in Classic, and no clear cut way of determining a candidate's role based on their talents, so I decided to remove it completely.
