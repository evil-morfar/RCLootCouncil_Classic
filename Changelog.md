## Changes



### Bugfixes

- *Changed ML detection logic to match the logic of when to actually use the addon. This fixes issues with the player being registered as ML, but the ML interface not being setup e.g. when being in a party but using the setting "Only use in raids" (along with a few other scenarios), which in turn leads to errors when trying to use ML commands - basically all errors related to `lootXXXX being nil`.*
- *Average item level calculation no longer includes shirts and tabards.*
