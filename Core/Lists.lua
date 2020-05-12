--- Lists.lua Contains various lists used within the addon.

local _, addon = ...
local Classic = addon:GetModule("RCClassic")

local List = {}
Classic.Lists = List

---------------------------------------------------
-- Zul'Gurub
---------------------------------------------------
List.ZG_Coins = {
   [19698] = "Zulian Coin",
   [19699] = "Razzashi Coin",
   [19700] = "Hakkari Coin",
   [19701] = "Gurubashi Coin",
   [19702] = "Vilebranch Coin",
   [19703] = "Witherbark Coin",
   [19704] = "Sandfury Coin",
   [19705] = "Skullsplitter Coin",
   [19706] = "Bloodscalp Coin",
}

List.ZG_Bijous = {
   [19707] = "Red Hakkari Bijou",
   [19708] = "Blue Hakkari Bijou",
   [19709] = "Yellow Hakkari Bijou",
   [19710] = "Orange Hakkari Bijou",
   [19711] = "Green Hakkari Bijou",
   [19712] = "Purple Hakkari Bijou",
   [19713] = "Bronze Hakkari Bijou",
   [19714] = "Silver Hakkari Bijou",
   [19715] = "Gold Hakkari Bijou",
}
