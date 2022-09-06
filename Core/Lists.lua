--- Lists.lua Contains various lists used within the addon.

local _, addon = ...
local Classic = addon:GetModule("RCClassic")

local List = {}
Classic.Lists = List

List.RepItems = {
   -- Zul'Gurub
   -- Coins
   [19698] = "Zulian Coin",
   [19699] = "Razzashi Coin",
   [19700] = "Hakkari Coin",
   [19701] = "Gurubashi Coin",
   [19702] = "Vilebranch Coin",
   [19703] = "Witherbark Coin",
   [19704] = "Sandfury Coin",
   [19705] = "Skullsplitter Coin",
   [19706] = "Bloodscalp Coin",
   -- Bijous
   [19707] = "Red Hakkari Bijou",
   [19708] = "Blue Hakkari Bijou",
   [19709] = "Yellow Hakkari Bijou",
   [19710] = "Orange Hakkari Bijou",
   [19711] = "Green Hakkari Bijou",
   [19712] = "Purple Hakkari Bijou",
   [19713] = "Bronze Hakkari Bijou",
   [19714] = "Silver Hakkari Bijou",
   [19715] = "Gold Hakkari Bijou",
   [7074] = "Cipped",
   [4865] = "Pelt",

   -- Ahn'Qiraj
   -- Scarabs
   [20858] = "Stone Scarab",
   [20859] = "Gold Scarab",
   [20860] = "Silver Scarab",
   [20861] = "Bronze Scarab",
   [20862] = "Crystal Scarab",
   [20863] = "Clay Scarab",
   [20864] = "Bone Scarab",
   [20865] = "Ivory Scarab",

   -- Naxx
   [22376] = "Wartorn Cloth Scrap",
   [22373] = "Wartorn Leather Scrap",
   [22375] = "Wartorn Plate Scrap",
   [22374] = "Wartorn Chain Scrap",
   [23055] = "Word of Thawing",

   -- TBC
   -- Black Temple
   [32428] = "Heart of Darkness",
   [32897] = "Mark of the Illidari",

   -- Sunwell Plateau
   [34664] = "Sunmote",
}

List.Specials = {
   -- AQ Tier 2.5 tokens
   -- AQ20
   [20884] = {"Finger0Slot", "Finger1Slot"}, -- Magisterial Ring
   [20885] = {"BackSlot"}, -- Martial Drape
   [20886] = {"Weapon"}, -- Spiked Hilt
   [20888] = {"Finger0Slot", "Finger1Slot"}, -- Ceremonial Ring
   [20889] = {"BackSlot"}, -- Regal Drape
   [20890] = {"Weapon"}, -- Ornate Hilt
   -- AQ40
   [20926] = {"HeadSlot"}, -- Vek'nilash's Circlet
   [20927] = {"LegsSlot"}, -- Ouro's Intact Hide
   [20928] = {"ShoulderSlot", "FeetSlot"}, -- Bindings of Command
   [20929] = {"HeadSlot"}, -- Veklors Diadem
   [20930] = {"ChestSlot"}, -- Carapace of the Old God
   [20931] = {"LegsSlot"}, -- Skin of the Great Sandworm
   [20932] = {"ShoulderSlot", "FeetSlot"}, -- Bindings of Dominance
   [20933] = {"ChestSlot"}, -- Husk of the Old God

}
