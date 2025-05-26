--- Lists.lua Contains various lists used within the addon.

---@type RCLootCouncil
local addon = select(2, ...)
---@class RCLootCouncil_Classic
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

-- SoD Gnomeregan
RCTokenTable[217007] = "FeetSlot"  -- Power Depleted Boots
RCTokenTable[217008] = "ChestSlot" -- Power Depleted Chest
RCTokenTable[217009] = "LegsSlot"  -- Power Depleted Legs

-- SoD Sunken Temple
RCTokenTable[220636] = "MultiSlots" -- Atal'ai Blood Icon
RCTokenTable[220637] = "MultiSlots" -- Atal'ai Ritual Token

-- SoD Molten Core
RCTokenTable[227530] = "WaistSlot" -- Incandescent Belt
RCTokenTable[227531] = "WristSlot" -- Incandescent Bindings
RCTokenTable[227536] = "FeetSlot" -- Incandescent Boots
RCTokenTable[227533] = "HandsSlot" -- Incandescent Gloves
RCTokenTable[227532] = "HeadSlot" -- Incandescent Hood
RCTokenTable[227534] = "LegsSlot" -- Incandescent Leggings
RCTokenTable[227535] = "ChestSlot" -- Incandescent Robe
RCTokenTable[227537] = "ShoulderSlot" -- Incandescent Shoulderpads

RCTokenTable[227751] = "WaistSlot" -- Molten Scaled Belt
RCTokenTable[227750] = "WristSlot" -- Molten Scaled Bindings
RCTokenTable[227757] = "FeetSlot" -- Molten Scaled Boots
RCTokenTable[227758] = "ChestSlot" -- Molten Scaled Chest
RCTokenTable[227756] = "HandsSlot" -- Molten Scaled Gloves
RCTokenTable[227755] = "HeadSlot" -- Molten Scaled Helm
RCTokenTable[227754] = "LegsSlot" -- Molten Scaled Leggings
RCTokenTable[227752] = "ShoulderSlot" -- Molten Scaled Shoulderpads

RCTokenTable[227761] = "WaistSlot" -- Scorched Core Belt
RCTokenTable[227760] = "WristSlot" -- Scorched Core Bindings
RCTokenTable[227765] = "FeetSlot" -- Scorched Core Boots
RCTokenTable[227766] = "ChestSlot" -- Scorched Core Chest
RCTokenTable[227759] = "HandsSlot" -- Scorched Core Gloves
RCTokenTable[227764] = "HeadSlot" -- Scorched Core Helm
RCTokenTable[227763] = "LegsSlot" -- Scorched Core Leggings
RCTokenTable[227762] = "ShoulderSlot" -- Scorched Core Shoulderpads

-- SoD Blackwing Lair
RCTokenTable[231724] = "WristSlot" -- Ancient Bindings
RCTokenTable[231725] = "WaistSlot" -- Ancient Belt
RCTokenTable[231726] = "ShoulderSlot" -- Ancient Shoulderpads
RCTokenTable[231727] = "LegsSlot" -- Ancient Leggings
RCTokenTable[231728] = "HeadSlot" -- Ancient Helm
RCTokenTable[231729] = "HandsSlot" -- Ancient Gloves
RCTokenTable[231730] = "FeetSlot" -- Ancient Boots
RCTokenTable[231731] = "ChestSlot" -- Ancient Chest

RCTokenTable[231707] = "WristSlot" -- Draconian Bindings
RCTokenTable[231708] = "WaistSlot" -- Draconian Belt
RCTokenTable[231709] = "ShoulderSlot" -- Draconian Shoulderpads
RCTokenTable[231710] = "LegsSlot" -- Draconian Leggings
RCTokenTable[231711] = "HeadSlot" -- Draconian Hood
RCTokenTable[231712] = "HandsSlot" -- Draconian Gloves
RCTokenTable[231713] = "FeetSlot" -- Draconian Boots
RCTokenTable[231714] = "ChestSlot" -- Draconian Robe

RCTokenTable[231715] = "WristSlot" -- Primeval Bindings
RCTokenTable[231716] = "WaistSlot" -- Primeval Belt
RCTokenTable[231717] = "ShoulderSlot" -- Primeval Shoulderpads
RCTokenTable[231718] = "LegsSlot" -- Primeval Leggings
RCTokenTable[231719] = "HeadSlot" -- Primeval Helm
RCTokenTable[231720] = "HandsSlot" -- Primeval Gloves
RCTokenTable[231721] = "FeetSlot" -- Primeval Boots
RCTokenTable[231723] = "ChestSlot" -- Primeval Chest

-- SoD Naxxramas
RCTokenTable[236244] = "WaistSlot"    -- Desecrated Belt
RCTokenTable[236245] = "WristSlot"    -- Desecrated Bindings
RCTokenTable[236240] = "ShoulderSlot" -- Desecrated Shoulderpads
RCTokenTable[236246] = "LegsSlot"     -- Desecrated Leggings
RCTokenTable[236241] = "HeadSlot"     -- Desecrated Circlet
RCTokenTable[236243] = "HandsSlot"    -- Desecrated Gloves
RCTokenTable[236239] = "FeetSlot"     -- Desecrated Sandals
RCTokenTable[236242] = "ChestSlot"    -- Desecrated Robe

RCTokenTable[236252] = "WaistSlot"    -- Desecrated Girdle
RCTokenTable[236247] = "WristSlot"    -- Desecrated Wristguards
RCTokenTable[236254] = "ShoulderSlot" -- Desecrated Spaulders
RCTokenTable[236253] = "LegsSlot"     -- Desecrated Legguards
RCTokenTable[236249] = "HeadSlot"     -- Desecrated Headpiece
RCTokenTable[236250] = "HandsSlot"    -- Desecrated Handguards
RCTokenTable[236248] = "FeetSlot"     -- Desecrated Boots
RCTokenTable[236251] = "ChestSlot"    -- Desecrated Tunic

RCTokenTable[236232] = "WaistSlot"    -- Desecrated Waistguard
RCTokenTable[236235] = "WristSlot"    -- Desecrated Bracers
RCTokenTable[236237] = "ShoulderSlot" -- Desecrated Pauldrons
RCTokenTable[236238] = "LegsSlot"     -- Desecrated Legplates
RCTokenTable[236236] = "HeadSlot"     -- Desecrated Helmet
RCTokenTable[236233] = "HandsSlot"    -- Desecrated Gauntlets
RCTokenTable[236234] = "FeetSlot"     -- Desecrated Sabatons
RCTokenTable[236231] = "ChestSlot"    -- Desecrated Breastplate
