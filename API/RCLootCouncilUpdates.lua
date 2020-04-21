--- Fixed for retail RCLootCouncil function that doesn't function properly in Classic
local _, addon = ...
local private = {}
local RCClassic = addon:GetModule("RCClassic")
local L = LibStub("AceLocale-3.0"):GetLocale("RCLootCouncil")
local LC = LibStub("AceLocale-3.0"):GetLocale("RCLootCouncil_Classic")

----------------------------------------------
-- Core
----------------------------------------------
addon.coreEvents["ENCOUNTER_LOOT_RECEIVED"] = nil -- Doens't exist in Classic
addon.coreEvents["BONUS_ROLL_RESULT"] = nil -- Doens't exist in Classic
addon.coreEvents["LOOT_CLOSED"] = nil -- We have our own
-- Defaults updates:
-- -- Auto pass disabled:
addon.defaults.profile.autoPassBoE = false
-- -- Removed:
addon.defaults.profile.ignoredItems = {} -- Remove all retail ignores
addon.defaults.profile.printCompletedTrades = nil
addon.defaults.profile.rejectTrade = nil
-- -- Usage options:
addon.defaults.profile.usage = {
   never = false,
   ml = false,
   ask_ml = true,
   state = "ask_ml"
}

-- Some Main Hand weapons are "Ranged" in Classic
addon.INVTYPE_Slots.INVTYPE_RANGED = "RangedSlot"
addon.INVTYPE_Slots.INVTYPE_RANGEDRIGHT = "RangedSlot"
addon.INVTYPE_Slots.INVTYPE_THROWN = "RangedSlot"

-- Update logo location
addon.LOGO_LOCATION = "Interface\\AddOns\\RCLootCouncil_Classic\\RCLootCouncil\\Media\\rc_logo"

function addon:IsCorrectVersion ()
   return WOW_PROJECT_CLASSIC == WOW_PROJECT_ID
end

function addon:UpdatePlayersData()
   self:DebugLog("UpdatePlayersData()")
   -- GetSpecialization doesn't exist, and there's no real need for it in classic
	--playersData.specID = GetSpecialization() and GetSpecializationInfo(GetSpecialization())
   self.playersData.specID = 0
	self.playersData.ilvl = private.GetAverageItemLevel()

	self:UpdatePlayersGears()
end

function addon:GetLootStatusData ()
   -- Do nothing
end

function addon:RegisterComms ()
   -- Handled in Core/Module.lua
end

-- fullTest is used with Dungeon Journal, and thus is ignored
function addon:Test (num, fullTest, trinketTest)
   self:Debug("Test", num, fullTest, trinketTest)
   num = num or 3
   local testItems = {
      17076,12590,14555,11684,22691,871, -- Weapons
      12640,14551,14153,12757, -- Armor
      18821,19140,19148,1980,942,18813,13143 -- Rings
   }
   local trinkets = {
      19406,17064,18820,19395,19289, -- Trinkets
   }

   if not trinketTest then
		for _, t in ipairs(trinkets) do
			tinsert(testItems, t)
		end
	end

   local items = {}
   for i = 1, num do
		local j = math.random(1, #testItems)
		tinsert(items, testItems[j])
	end
	if trinketTest then -- Always test all trinkets.
		items = trinkets
	end
   self.testMode = true;
	self.isMasterLooter, self.masterLooter = self:GetML()
	-- We must be in a group and not the ML
	if not self.isMasterLooter then
		self:Print(L.error_test_as_non_leader)
		self.testMode = false
		return
	end
	-- Call ML module and let it handle the rest
	self:CallModule("masterlooter")
	self:GetActiveModule("masterlooter"):NewML(self.masterLooter)
	self:GetActiveModule("masterlooter"):Test(items)

	self:ScheduleTimer(function()
		self:SendCommand("group", "looted", 1234)
	end, 5)
end

local enchanting_localized_name = nil
function addon:GetPlayerInfo ()
   local enchant, lvl = nil, 0
   if not enchanting_localized_name then
      enchanting_localized_name = GetSpellInfo(7411)
   end
   if GetSpellBookItemInfo(enchanting_localized_name) then
      -- We know enchanting, thus are an enchanter. We don't know our lvl though.
      enchant = true
      lvl = "< 300"
   end
   -- GetAverageItemLevel() isn't implemented
   local ilvl = private.GetAverageItemLevel()
   return self.playerName, self.playerClass, self.Utils:GetPlayerRole(), self.guildRank, enchant, lvl, ilvl, nil--self.playersData.specID
end

-- Class tags needs updated as druids are number 11 and we have 8 classes
do
   local info = C_CreatureInfo.GetClassInfo(11)
   addon.classDisplayNameToID[info.className] = 11
   addon.classTagNameToID[info.classFile] = 11
   addon.classIDToDisplayName = tInvert(addon.classDisplayNameToID)
   addon.classIDToFileName = tInvert(addon.classTagNameToID)
end

function addon:UpdateAndSendRecentTradableItem()
   -- Intentionally left empty
end
----------------------------------------------
-- Utils
----------------------------------------------
function addon.Utils:GetPlayerRole ()
   return "NONE" -- GetRaidRosterInfo returns "NONE"
end

----------------------------------------------
-- Private helper functions
----------------------------------------------
--- Recreates functionality of GetAverageItemLevel()
function private.GetAverageItemLevel()
   local sum, count = 0, 0
   for i=_G.INVSLOT_FIRST_EQUIPPED, _G.INVSLOT_LAST_EQUIPPED do
      local iLink = _G.GetInventoryItemLink("player", i)
      if iLink and iLink ~= "" then
         local ilvl = select(4, _G.GetItemInfo(iLink)) or 0
         sum = sum + ilvl
         count = count + 1
      end
   end
   return addon.round(sum / count, 2)
end
