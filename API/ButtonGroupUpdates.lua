--- Adds and changes button groups for Classic
local _, addon = ...
local LC = LibStub("AceLocale-3.0"):GetLocale("RCLootCouncil_Classic")

addon.OPT_MORE_BUTTONS_VALUES.CATALYST = nil
addon.OPT_MORE_BUTTONS_VALUES.SPECIAL = nil
addon.OPT_MORE_BUTTONS_VALUES.RARE = nil
addon.OPT_MORE_BUTTONS_VALUES.DECOR = nil

-- Add "Set Pieces" as a group
addon.OPT_MORE_BUTTONS_VALUES.SETS = LC["Set Pieces"]
tinsert(addon.RESPONSE_CODE_GENERATORS, 2, function(item, db)
	local set = select(16, C_Item.GetItemInfo(item))
   if db.enabledButtons.SETS and set and set > 0 then
      return "SETS"
   end
end)
