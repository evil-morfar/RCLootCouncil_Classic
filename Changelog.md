# v0.0.1-Alpha.3

## Overview
Initial barebones of the Classic port. Basic functionality such as testing, version syncing etc. is all working. Master Looting and awarding is working to some extent, although mostly untested.

I'll continue to increment this alpha version as more features are getting ported before launch.

### Missing

#### Auto Pass
Lots of API for handling this are missing in Classic, and will need some extensive work to recreate.
Auto Pass is disabled by default until resolved.

#### Roles
Didn't exist in Classic, thus there's no API for it. I still want to bring it back.

#### Player's Gear
Currently not implemented due to lacking spec API's.

#### Proper Testing
Haven't done any real raid/instance testing as I probably won't be leveling that much.


## Changes
#### Versioning
In the version checker ("/rc v") the version of this module will show up. The Core RCLootCouncil version is shown when mousing over a player.

#### Master Loot
The options menu have been updated with settings of old regarding Master Looting.


## Removed
#### Loot Status
Not used with Master Looting.

#### Personal Loot
Removed everything related to personal loot.

#### Azerite Armor
No longer an option in the "More Buttons" options.
