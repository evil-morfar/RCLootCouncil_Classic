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
