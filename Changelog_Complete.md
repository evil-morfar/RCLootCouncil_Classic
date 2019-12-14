# v0.5.0

## Updated RCLootCouncil to v2.16.0-Beta.1
### Additions

#### Alt-click Awarding
ML's can now Award items by Alt-clicking a candidate row, saving you a right-click.

#### CSV Import/Export
Added support for importing custom history through CSV.  
See the wiki for more info.  
*Note: The CSV export has changed fields to comply with the new import system. This also means old CSV exports cannot be imported!*

#### Frame Options
Added an option to select which chat frame RCLootCouncil will print to.

#### Loot History
Added "Send to guild" option.  
Checking this will send history entries to your guild instead of your group.

#### Looting Options
Added "Award Later" option.  
When enabled, this option will automatically check "Award Later" in the Session Frame.

### Changes

#### Loot History
The history is now sortable by class. Just click the class icon header.

#### Options

##### Council
Current Council list is now sorted alphabetically.

#### Voting Frame

##### Awarding
When Master Looter, awarding an item will now switch session to the first unawarded session instead of simply the next numerical session (i.e. session + 1).

##### Vote Status
The list is now sorted alphabetically and colored according to the candidates' class.  
Added councilmembers that haven't yet voted to the list.  
The names now respects the "Append realm name" option.

##### Votes Column
Voter names are now class colored.  
The names now respects the "Append realm name" option.


### Bugfixes
* *Added a potential fix to the occasional false "Full bags" blame.*
* *Added a history patch for broken "Award Reasons".*

## Changes
Added patch 1.13.3 to history delete options.


# v0.4.2

## Bugfixes
* *Fixed error when looting certain types of items (Curse#15).*
* *RCLootCouncil Core reported wrong version in last update (#8).*


# v0.4.1

## Bugfixes
* *Guild ranks not showing up should be fixed for good. Only works for those that have updated. (Curse#11,13).*
* *Another fix for RCLootCouncil_Core version triggering update messages. (#7, Curse#14)*


# v0.4.0

## Updated RCLootCouncil to v2.15.1.

##### Bugfixes
* *Fixed error when council members reconnect during session (Curse#398).*
* *Fixed error with 'whisper guide' being too long to send in some locales (#177).*
* *The 'Keep Loot' popup is now only used in raids to avoid it unintentionally popping up in dungeons. This is a temporary fix, as a proper fix needs way more work (Curse#396).*
* *Adding items to a session will no longer reset rolls on existing items when "Add Rolls" is enabled.*
* *Adding more than one item to a session could sometimes mess up and make a session switch button disappear.*
* *Items awarded with "Award Reasons" would retain their original response when filtering the Loot History (CurseClassic#9).*


## Changes
#### Quest Items
Removed quest items from the blacklist, allowing them to automatically being added to a session as long as "Loot Everything" is enabled.

## Bugfixes
* *Added potential fix to issues with guild ranks not showing up. Note: Not backwards compatible, and will only be fixed for those that has updated. (Curse#11)*
* *Fixed issues with some items refusing to be awarded (Curse#9).*
* *Warnings about v2.14.0 being the most recent version are now supressed.*


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
