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
