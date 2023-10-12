# 0.20.0

## Changes

Updated for patch 3.4.3 and 1.14.4.


# 0.19.0

## Changes

Updated for patch 3.4.2.

### Roll column

Switched to a new system that's much lighter on comms for propergating the automatic random rolls. This should fix the issues some people have with the last few sessions not receiving random rolls.

This change is not backwards compatible, once the ML upgrades, everyone will have to in order to see the random rolls.

### Trophy of the Crusade

Is now considered an armor token for buttons and responses. Also added ilvl data.

### Voting Frame session buttons

Selecting an awarded session now shows a yellow checkmark instead of nothing on the session button.

## Bugfixes

- *History now records the correct response instead of "Awarded" when awarding multiple copies of the same item to a player.*
- *Voting frame rows should no longer be jumping around excessively.*


# 0.18.4

Updated Ace3.

## Bugfixes

- *Removed creation of `C_Container` namespace which clashes with other addons (#53).*


# 0.18.3

## Bugfixes

- *Fixed issue with Bagnon (#53)*

# 0.18.2

## Bugfixes

- *Fixed issue with outdated libraries causing history frame to not show.*


# 0.18.1


## Bugfixes

- *Fixed error related to warning about tradeable items becoming non-tradeable.*


# 0.18.0

## Changes

Updated for patch 3.4.1.

Add `/rc start` command which either shows the usage pop-up or starts the addon depending on your usage settings.

### Voting Frame More Info

Now shows the equip location of recently awarded items.

### Export items in session

Added new chat command `/rc export` which will export a csv formatted list of the items currently in session.

### Additional Buttons

Added button groups for mounts and bags.

### Auto pass specific slots

Added option to always auto pass specific equip slots - credit to Loogosh.

## Bugfixes

- *Date selection in delete history options now again shows the chosen value.*
- *Fixed invisible header on TradeUI obstructing the title frame, making it unclickable.*
- *Removed empty space on top of session frame.*
- *Fixed error when changing a response in the history to a non default category response.*


# 0.17.1

## Changes

## Bugfixes

- *Closing the TradeUI would make it stop functioning properly (Curse#182, Curse#183, #47).*
- *If an error occured when doing award later, last item would cause a lua error.*


# 0.17.0

## Changes

### Checkmark

Awarded items now also has a checkmark overlay on their session button.

### Esc closing frames

All RCLootCouncil frames except `Loot-` and `Voting Frame` can now be closed by pressing `Escape`.

### TradeUI and ItemStorage

Made several fixes to the ItemStorage which should eliminate outstanding issues with wrong warnings about trade timers and items staying in the award later list forever.

Furthermore added a delete button to the TradeUI allowing one to remove items from it.

## Bugfixes

- *Frames will no longer intercept mouse scrolls when hidden (CurseClassic#181).*
- *Items registered for "award_later", "to_trade", etc will now properly be removed on relog if  they no longer exists in players bags.*
- *Test versions will no longer be listed as newer if you're not running a test version yourself.*
- *Fixed potential nil error (#46).*


# 0.16.1

### Bugfixes

- *Revamped last update's changes to ML detection - a few specific settings would cause canidates to ignore messages from the ML when they shouldn't.*
- *Classic Era: Fixed login error related to auto pass.*


# 0.16.0

## Changes

`/rc test` now uses WOTLK items in WOTLK.

Warnings about `v3.0` has been removed for good.

Added `itemName` to JSON export (CurseClassic#137).

Award Later looting in combat is now possible if settings dictates no frames would be created.

### Add all tradeable items to session

It's now possible to add all items from your bags with a trade timer on them to a session at once.
Simply use `/rc add bags` or `/rc add all` to do so. You must obviously still be ML/group leader to do so, and have the addon active.

### Bugfixes

- *Changed ML detection logic to match the logic of when to actually use the addon. This fixes issues with the player being registered as ML, but the ML interface not being setup e.g. when being in a party but using the setting "Only use in raids" (along with a few other scenarios), which in turn leads to errors when trying to use ML commands - basically all errors related to `lootXXXX being nil`.*
- *Average item level calculation no longer includes shirts and tabards.*
- *Fixed issue with tokens not showing intended item type info in Voting Frame.*
- *Fixed issue with adding items to a session not always being parsed correctly.*
- *Druids no longer auto passes on polearms (CurseClassic#174).*
- *Deathknights now auto passes librams, idols, and totems.*
- *Fixed issue with responses not updating their sort order when moving them around.*
- *Fixed issues with TradeUI removing wrong items after trading.*

# 0.15.1

## Changes

Added option for restoring `/rc` to its ready check functionality (#215, Curse#495).

### Dev

- *Added itemLink and responseText to `RCMLAwardSuccess` and `RCMLAwardFailed` AceEvents allowing for integration with Classic Loot Manager.*

### Bugfixes

- *Added `id` to json export (#43).*
- *Award Later items now remembers which boss they where dropped by (#43).*


# 0.15.0

## Changes

Updated for Wrath of the Lich King Classic.  
This includes adding Death Knights to the auto pass table, but there might be other stuff I've forgotten - feel free to reach out if you find anything.


### Bugfixes

* *TradeUI should now properly handle reawards.*
* *Doing a `/reload` should no longer incorrectly remove items marked for "award later" or "trade".*
* *When using the `Observe` feature, voting frame could throw an error if certain comms was received out of order (CurseClassic#169).*

# 0.14.1
### Bugfixes

* *Heart of Darkness should now actually be autolootable.*
* *Selected round robin candidate is now truly random.*



# 0.14.0

## Changes

### Always auto award list

Added an option to choose items that should always be auto awarded. Located in the 'Awards' tab of the Master Looter options. Items can be added by itemID, name or item link.

### TradeUI

Implemented hotfix for handling duplicate items.
Not as robust as I would like, but it should get the job done for now.

### Burning Crusade Classic

Updated .toc for patch 2.5.3.

Added `Heart of Darkness` and `Mark of the Illidari` to the rep items loot list.

### Bugfixes

* *Fixed issue with `/rc remove` command.*

# 0.13.2

## Changes

### Classic

Updated for patch 1.14.1.

### Burning Crusade Classic

Updated for patch 2.5.2.

# 0.13.1

## Changes

Added a fix for Blizzard breaking Dropdowns when using Master Loot.

### Burning Crusade

Wowhead links now points to `tbc.wowhead.com` (CurseClassic#144).

## Bugfixes

* *Using the observe feature could occasionally cause errors after `/reload`ing (CurseClassic#146).*

# 0.13.0

## Changes

Updated for Classic Era and Burning Crusade Classic.

Frame z-level issues are no longer a thing. Credits to enajork (#206).

# v0.12.1

## Changes 

### Naxxramas 

Added Wartorn Scraps and Word of Thawing to the round robin distributon list (#34).  
Splinter of Atiesh is now ignored by default as it's not tradeable.

# v0.12.0

Updated .toc for patch 1.13.6.  
Added patch 1.13.6 to history mass deletion.

## Bugfixes

* *Fixed issue with `Award Later` when running with `Auto Start` (CurseClassic#116).*
* *Clicking cancel on the Session Frame while a session was running could break the addon (CurseClassic#123).*

# v0.11.2
## Bugfixes
* *Fixed Druid related issues causing all kinds of trouble in the latest version (CurseClassic#112,#113,#114).*
* *Fixed error on Guild Council Members options page.*


# v0.11.1
## Updated RCLootCouncil to v2.19.3
### Bugfixes
* *`/rc v 1` correctly prints a numbered list again.*
* *History entries containing quotes are now properly escaped for JSON export.*

## Changes
### AQ Tokens
RCLootCouncil now displays a candidates currently equipped items for AQ Tier 2.5 tokens - including those that can be awarded for multiple slots.

Imperial Qiraji items has been removed from the Rep Item auto award list.


# v0.11.0
## Changes
### Comms
Comms are now limited to a max of 10 per second in an attempt to fix the remaining comms issues. This change is fully backwards compatible.

### Ahn'Qiraj
Added Imperial Qiraji and scarab items to the round robin list.

## Bugfixes
*Druids will now autopass polearms.*
*Fixed 'lootQueue nil' errors. (CurseClassic #105, #106)*


# v0.10.1
*Note: Just a reminder that this is not compatible with pre v0.10 versions.*

## Upgraded to RCLootCouncil v2.19.2
### Changes
#### Council comms
Council comms is now throttled to avoid sending unnecessary comms.

### Bugfixes
*Bumped threshold for detecting ML awards for instability in Classic.*
*Increased stability of ML/GL detection.*
*Suppressed and logged occasional `lootQueue` error for future inspection.*

## Changes
### Comms
Removed errors when receiving messages from pre v0.10 versions.
Pre v0.10 version will again show up in the Version Checker instead of `Not Installed`.

## Bugfixes
*Syncing (/rc sync) is now also compressed.*
*Sessions will no longer error out if candidates hadn't cached the items.*


# v0.10.0
## Changes
### Comms
Due to recent changes from Blizzard side, all comms in WoW are now much more restricted. I've had an update for this in mind for a long time, but they decided to just do an undocumented edit, which limits my options.

This update should be compatible with the new limits, but at the cost of backwards compatibility - i.e. any pre v0.10 version of the addon no longer works with v0.10 and up.

### Sync
Syncing history will most likely not be working due to the changes stated above, unless your history is very small. For various reasons I won't do a fix for that anytime soon, but remember you can always do `Player Export` and import that in the history, which does the same as the sync does.

## Additions
### Auto Award Reputation Items
Added a new auto award section for reputation items. These currently includes Coins and Bijous from Zul'Gurub.
They can be auto awarded two ways:
1. To a specified player, just as the other auto awards.
2. In a round robin fashion, in which all players will get one before anyone getting a second.

Note that the Master Looter will still have to loot the mobs in either case.

### Group Loot
Added support for usage with group loot.
The group leader must enable this in the `Usage Options`.
When enabled, the group leader is treated as the Master Looter for all intents and purposes.
The group leader will still need to loot all mobs to have items added to a session, but doesn't need to keep the loot list open to award items.
**Note:** This addition only facilitates the use of RCLootCouncil with group loot, but does nothing to circumvent the limitations of said loot method.


# v0.9.3
## Bugfixes
*Fixed issues on 'LootOpened' introduced in the last version (Curse#64,Curse#65,Curse#66).*

# v0.9.2
## Bugfixes
*Fixed desync issue when ML reloaded in groups (#21, Curse#61, Curse#62).*
*Fixed issue with occasional "Unknown" Master Looter (Curse#60).*
*Detecting 'Award Later' items after a /reload should be more reliable.*

# v0.9.1
## Updated RCLootCouncil to v2.19.1
### Changes
#### History Deletion
Prefer using id time stamp when deleting history entries by date (CurseClassic#57).
Should be more precise until a planend overhaul of the time keeping is implemented.

### Bugfixes
*Fixed issue with the disenchant button introduced in v2.19.0.*

## Bugfixes
*Fixed issue with occasional uncached loot.*

# v0.9.0
## Updated RCLootCouncil to v2.19.0
*Only Classic relevant changes listed here-*
### Changes

#### Award Later
When `Award Later` and `Auto Start` both are enabled, all items are automatically awarded to the Master Looter/Group Leader for award later.

I generally don't recommend enabling `Auto Start` as you will have no control over what happens before setting the addon free to do its thing.
This is especially dangerous with `Award Later`, as ALL eligible items will be awarded automatically.  
**You have been warned.**

#### Boss Name in History
The boss name is now directly attached to items, meaning no matter when you award items the boss name should be correct in the Loot History.
This would not be the case earlier if another boss was pulled before awarding registered items.

#### Classic
The retail version will now show a chat message if installed in the Classic client and vice versa, before disabling itself.

#### Error Handler
RCLootCouncil will now log any lua errors caused by it.
This will help in debugging errors as users are no longer required to turn on scriptErrors to register them.

#### Voting Frame
When `Hide Votes` is enabled, the Voting Frame will no longer sort the list when receiving votes from other councilmembers.
Once the player has voted, the list is sorted as normal.

### Bugfixes
* *Fixed another issue with EQdkp Plus XML export introduced with v2.18.3.*
* *Loot should no longer linger in the Session Frame after leaving the instance (CurseClassic#41).*
* *Multiple items can be automatically added to a pending trade at once.*
* *Moving responses up/down in the options menu now properly updates their sorting position (Classic#18).*
* *Deleting history older than a specified number of days now works correctly.*

## Additions
* Added patch 1.13.4 to history delete options.

### Enchant Level
The disenchant menu now includes the exact level of the (dis)enchanter. Thanks to Keionu for the addition (#20).


## Bugfixes
* *The Classic Module is no longer listed as outdated with other modules.*
* *Added another fix for the occasional report of the classic module being out of date (Curse#43).*
* *Fixed issue with detecting the Master Looter after doing a /reload in raid (Curse#36).*


# v0.8.0
## Updated RCLootCouncil to v2.18.3
### Bugfixes
* *Fixed rare error when award later items have no trade time remaining. (CurseClassic#37)*
* *Fixed issues with EQdkp Plus XML export (CurseClassic#35).*
* *Fixed issue with Award Later when items aren't available in the ML's bags when expected.*

## Changes
Updated TOC to 1.13.4

## Bugfixes
* *Added extra delay when receiving uncached loot on `LOOT_READY`.*
* *Fixed issue with wowhead links (#14).*
* *Fixed issues with Auto Awards (Curse#38).*



# v0.7.2
## Updated RCLootCouncil to v2.18.2
### Changes
#### Allow Keeping
The pop-up for keeping items now shows "Keep"/"Trade" instead of yes/no. (Git#183).

### Bugfixes
* *Passes no longer require a note with 'Require Notes' enabled. (Git#184)*
* *Fixes issue with receiving votes outside an instance (Curse#413).*
* *Fixed issues with TSV Export hyperlinks.*

## Changes
### Wowhead Links
All exports with WowHead links now points to the Classic version of the site (#12).


# v0.7.0
## Updated RCLootCouncil to v2.18.0
*Only Classic relevant changes are included here.*
### Additions
#### Auto Award BoE's
Added a new system allowing for auto awarding BoE's.
Only Epic, Equippable, non-bags items qualify.
This is checked before the normal auto award, so if both is enabled, this will have priority.

#### Class Filter
Added class filters to the Loot History.
Unlike the normal filters, these are active when enabled, i.e. checking 'Warrior' and 'Priest' will only show warriors and priests.

#### Require Notes
Added a new option for ML's that will require a note to be added to all responses.
When enabled, if no note is supplied, the response is blocked, and the candidate shown a message to why that happened.
Note: This is not backwards compatible with older version of the addon.

#### Winners of item
Added all the winners of the selected item to the More Info tooltip in the Loot History.
Note: Different versions of an item is not included in the count.

### Changes
#### Auto Award
Apparently Auto Awards never worked with Personal Loot - this has now been rectified.

#### History Exports
All exports will now respect all currently active filters, i.e. only export what you're currently able to see.

#### Out of Raid Support
An "Out of Raid" response is no longer automatically sent if you're outside an instance while in a group of 8 or more.
Instead, the Master Looter will now have to specifically enable it in the "Master Looter > Usage Options" options.
When enabled, it functions exactly as it did before.
*DevNote: I decided to make this change now, as I've seen an increasingly amount of confusion as to why people didn't get Loot pop-ups when out of an instance. I expect the few that actually use this feature will figure out how to turn it on.*

### Bugfixes
* *Candidate info no longer has the potential to wait a long time before being sync, i.e. guild rank not showing up in the voting frame.*
* *2.18.1: Previous version would error out when awarding during tests.*


## Bugfixes
* *Fixed lua error when declining usage (Classic#10).*


# v0.6.2
## Updated RCLootCouncil to v2.17.2
### Bugfixes
* *Characters with Non-ascii names that have a lower-case by WoW lua's definition can now be council members (CurseClassic#31).*
* *Fixed issue regarding adding items to a session could potentially cause an error (Curse#406).*

## Bugfixes
* *Fixed occasional error on login/reload (CurseClassic#29).*



# v0.6.1
## Updated RCLootCouncil to v2.17.1
*Only Classic relevant changes are included here*
### Changes
#### Item Registration
Changed the detection of looted items to ensure better reliability with high latencies (#9).



# v0.6.0
## Updated RCLootCouncil to v2.17.0
*Only Classic relevant changes are included here*

### Additions
#### JSON Export
Sebastianbassen kindly created a JSON export which is now included (#180).

### Bugfixes
* *Fixed issue with CSV importing responses without button groups (CurseClassic#25).*


# v0.5.1

## Updated RCLootCouncil to v2.16.1
### Changes

#### Chat Frame
`/rc reset` now also resets the chosen chat frame.
The chat frame is also automatically reset to default if the selected chat frame becomes invalid.


### Bugfixes
* *Time calculations with raid members in different timezones now works properly (CurseClassic#22).*
* *The TradeUI now detects reawards when a session has ended.*
* *Bags are now properly ignored by the Auto Award system.*


# v0.5.0

## Updated RCLootCouncil to v2.16.0
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
Updated TOC to patch 1.13.3.  
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
