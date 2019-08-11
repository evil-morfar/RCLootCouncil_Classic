# v0.0.1-Alpha1
---
## Overview
Initial barebones of the Classic port. Basic functionality such as testing, version syncing etc. is all working. Master Looting and awarding is working to some extent, although mostly untested.

I'll continue to increment this alpha version as more features are getting ported before launch.

### Missing
#### Auto Pass
Lots of API for handling this are missing in Classic, and will need some extensive work to recreate.

#### Roles
Didn't exist in Classic, thus there's no API for it. I still want to bring it back.

#### Player's Gear
Currently not implemented due to lacking spec API's.

#### Settings
No work done in the options menu yet.

#### Proper Testing
While I was able to test most things during the stress test, I still need to test things out in a proper group setting.


## Changes
#### Versioning
In the version checker ("/rc v") the version of this module will show up. The Core RCLootCouncil version is shown when mousing over a player.


## Removed
#### Loot Status
Not used with Master Looting.
