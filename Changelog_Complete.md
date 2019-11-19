## Bugfixes
* *Added potential fix to issues with guild ranks not showing up. Note: Not backwards compatible, and will only be fixed for those that has updated. (Curse#11)*

# v0.3.1
## Bugfixes
* *RCLootCouncil core version was bugged in the options menu.*
* *Fixed issue from 0.3.0 in voting frame causing client crash.*


# v0.3.0
## Updated RCLootCouncil to v2.15.0.
Most of these changes are background stuff, and/or not related to classic, and thus redacted from here.

* **Auto Award**  
Auto Awards can now only happen on equip able items.


## Changes
#### Tier Tokens / Set Pieces
Reenabled auto pass, item type and item level for all tier token pieces and set pieces.

Added separate button categories for both tier tokens and set pieces.  
In this context, tier tokens are the actual armor tokens usable by specific classes.  
Set Pieces are any wearable items that are part of a set, i.e. "Tier 0, 0.5, 1, 2" and other sets.

#### Trinkets
Reenabled auto passing and item type of trinkets.

Note the trinket auto passing is based on Blizzard's class list from the retail dungeon journal.
You can always disable trinket auto passing in the options menu.

#### History Deletion
Added Diremaul release to patch mass delete.

## Bugfixes
* *The version frame incorrectly showed the core RCLootCouncil version in the list.*


# v0.2.0
## Changes
#### Auto Pass
I hear your complaints - auto passing based on item type doesn't make sense in Classic.
All auto pass rules have been laxed to only include items you can't wear.
Furthermore BoE and trinket (has no effect) have been disabled by default.

## Bugfixes
* *Fixed issues with sorting on the voting frame. (#3, Curse#3)*


# v0.1.1
## Bugfixes
* *Reworked the entire whisper system to be functional again.*


# v0.1.0
## Updated RCLootCouncil to v2.14.0

* ### Voting Frame
The ML can now right click candidates after a session has ended.
This basically allows for an entire redo of the session, particularly changing awards later than usual.
As a reminder you can always reopen the voting frame with "/rc open".

* ### Bugfixes
Reawarding an item to the original owner will now remove the old trade entry from the TradeUI.


## Bugfixes
* *RCLootCouncil v2.14.0 fixes the issue with "Award Later".*


# v0.0.3
## Changes
#### Auto pass
Warriors and Paladins no longer auto pass on leather items.

## Bugfixes
* *Auto pass no longer breaks the addon for druids.*


# v0.0.2

## Added
#### Version Display
The options menu now includes the version of this addon as well as the core RCLootCouncil version.

## Bugfixes
* *A candidate's main hand weapon is no longer shown in the voting frame when rolling for ranged weapons (#1).*



# RCLootCouncil Classic v0.0.1

Below follows a list of missing, changed and removed features compared to [RCLootCouncil](https://www.curseforge.com/wow/addons/rclootcouncil). I might have missed something, or maybe something doesn't work the way you'd like - in both cases, feel free to reach out either in [Curse](https://www.curseforge.com/wow/addons/rclootcouncil-classic/) or on the [RCLootCouncil Discord](https://discord.gg/WfYhCx9).

This version is marked as release as the Twitch Client won't otherwise sync it, but treat it as a pre-release due to lack of proper testing.

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
