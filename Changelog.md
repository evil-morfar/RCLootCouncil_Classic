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
