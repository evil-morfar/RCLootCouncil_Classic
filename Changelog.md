## Changes
Updated for patch 1.15.6 and 4.4.2.


Added `servertime` field to JSON export.

### Comms optimization

Removed comms queuing in favor of relying on the Ace3 Comms implementation.  
Should speed up comms a bit.

### Time handling

All time stamps are now based off server time instead of the group leader's local time.

- This will reduce accuracy as local server time is only updated once a minute.

All date formats now follows the ISO standard of `YYYY/MM/DD`.

- This includes importing - they must now be of the new format. *Note: if you have a backup in either `Player Export` or `CSV` (with `id` field) those will import into the new format.*
- Existing history will be updated to the new format, but the timestamps will not, and are assumed to be server time going forwards.

Voting Frame more info tooltip showing time since award has been changed to just show the number of days.

## Bugfixes

- *Loot table is now properly sent on reloads.*
