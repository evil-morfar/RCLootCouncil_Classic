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
