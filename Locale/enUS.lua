-- Translate RCLootCouncil Classic to your language at:
-- https://www.curseforge.com/wow/addons/rclootcouncil-classic/localization

-- Default english translation
local L = LibStub("AceLocale-3.0"):NewLocale("RCLootCouncil_Classic", "enUS", true)
if not L then return end

L["Auto Award Reputation Items"] = true
L["Instance"] = "Instance"
L["leaderUsage_desc"] = "Use the same setting when entering an instance as the leader?"
L["Personal"] = true
L["Set Pieces"] = true

L.opt_advancedAutoPass_name = "Advanced Auto Pass"
L.opt_advancedAutoPass_desc = "Check each slot to always auto pass items of that type."
L.opt_advancedAutoPassSlot_desc = "Check to always auto pass %s items."

L["opt_autoAwardRepItemsMode_personal"] = "Personal"
L["opt_autoAwardRepItemsMode_roundrobin"] = "Round Robin"

L["opt_autoAwardRepItems_desc"] = "Enables auto awarding of rep items such as Coins and Bijous in Zul'Gurub."
L["opt_autoAwardRepItemsMode_desc"] = "Choose the mode to award rep items. Personal works like normal auto awards, and round robin evenly distributes items to all players."
L["opt_groupLoot_desc"] = "Enable this to have RCLootCouncil work with group loot when you're the group leader."
L["opt_groupLoot_name"] = "Use with Group Loot"
L["opt_usage_ask_ml"] = "Ask me every time I become Master Looter"
L["opt_usage_leader_always"] = "Always use when leader"
L["opt_usage_leader_ask"] = "Ask me when leader"
L["opt_usage_ml"] = "Always use RCLootCouncil when I'm Master Looter"

L.ALWAYS_AUTO_AWARD_OPTION = "Always Auto Award"
L.ALWAYS_AUTO_AWARD_OPTION_DESC = "List of items that should always be auto awarded, regardless of other settings."
L.ALWAYS_AUTO_AWARD_OPTION_INPUT_DESC = "Enter the link, name or id of the item you want to add to the always auto award list."
L.ALWAYS_AUTO_AWARD_OPTION_LIST = "Always auto award list"
L.ALWAYS_AUTO_AWARD_OPTION_LIST_DESC = "Items that are always auto awarded. Click to remove an item."
L.ALWAYS_AUTO_AWARD_OPTION_LIST_NONE = "No items in list."