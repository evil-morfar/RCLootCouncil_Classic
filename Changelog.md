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


## Bugfixes
* *The Classic Module is no longer listed as outdated with other modules.*
* *Added another fix for the occasional report of the classic module being out of date (Curse#43).*
* *Fixed issue with detecting the Master Looter after doing a /reload in raid (Curse#36).*
