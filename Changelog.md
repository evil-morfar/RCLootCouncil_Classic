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


## Bugfixes
* *Fixed lua error when declining usage (Classic#10).*
