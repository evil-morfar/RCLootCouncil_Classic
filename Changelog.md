## Changes

`/rc test` now uses WOTLK items in WOTLK.

Warnings about `v3.0` has been removed for good.

Added `itemName` to JSON export (CurseClassic#137).

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
