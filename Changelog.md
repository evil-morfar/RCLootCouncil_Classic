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
