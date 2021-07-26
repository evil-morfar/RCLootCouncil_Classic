--- Fixed for retail RCLootCouncil function that doesn't function properly in Classic
local _,
--- @type RCLootCouncil
addon = ...
---@type RCLootCouncil_Classic
local Classic = addon:GetModule("RCClassic")
local private = {}
local L = LibStub("AceLocale-3.0"):GetLocale("RCLootCouncil")
local LC = LibStub("AceLocale-3.0"):GetLocale("RCLootCouncil_Classic")
local LibDialog = LibStub("LibDialog-1.0")

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
addon.defaults.profile.printCompletedTrades = nil
addon.defaults.profile.rejectTrade = nil
-- -- Usage options:
addon.defaults.profile.usage = {
   never = false,
   ml = false,
   ask_ml = true,
   state = "ask_ml"
}

-- Rep Items defaults:
addon.defaults.profile.autoAwardRepItems = false
addon.defaults.profile.autoAwardRepItemsReason = 1
addon.defaults.profile.autoAwardRepItemsMode = "person" -- or RR
addon.defaults.profile.autoAwardRepItemsTo = ""
addon.defaults.profile.autoAwardRepItemsModeOptions = {
   person   = LC["opt_autoAwardRepItemsMode_personal"],
   RR       = LC["opt_autoAwardRepItemsMode_roundrobin"]
}

addon.defaults.profile.useWithGroupLoot = false

-- Some Main Hand weapons are "Ranged" in Classic
addon.INVTYPE_Slots.INVTYPE_RANGED = "RangedSlot"
addon.INVTYPE_Slots.INVTYPE_RANGEDRIGHT = "RangedSlot"
addon.INVTYPE_Slots.INVTYPE_THROWN = "RangedSlot"

-- Update logo location
addon.LOGO_LOCATION = "Interface\\AddOns\\RCLootCouncil_Classic\\RCLootCouncil\\Media\\rc_logo"

-- Ignored Items
addon.defaults.profile.ignoredItems = {} -- Remove the retail ones
addon.defaults.profile.ignoredItems[22726] = true -- Splinter of Atiesh

function addon:IsCorrectVersion ()
   return (WOW_PROJECT_CLASSIC == WOW_PROJECT_ID) or (WOW_PROJECT_BURNING_CRUSADE_CLASSIC == WOW_PROJECT_ID)
end

function addon:UpdatePlayersData()
   Classic.Log:D("UpdatePlayersData()")
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
   Classic.Log:D("Test", num, fullTest, trinketTest)
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
   for i = 1, num do --luacheck: ignore
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
   for i = 1, GetNumSkillLines() do
      -- Cycle through all lines under "Skill" tab on char
      local skillName, _, _, skillRank, _, _, _, _, _, _, _, _, _ = GetSkillLineInfo(i)
      if skillName == enchanting_localized_name then
         -- We know enchanting, thus are an enchanter. And will return your lvl.
         enchant = true
         lvl = skillRank
      end
   end
   -- GetAverageItemLevel() isn't implemented
   local ilvl = private.GetAverageItemLevel()
   return self.playerName, self.playerClass, self.Utils:GetPlayerRole(), self.guildRank, enchant, lvl, ilvl, nil--self.playersData.specID
end

function addon:UpdateAndSendRecentTradableItem()
   -- Intentionally left empty
end

local function getGearForAQTokens (itemID)
   local entry = Classic.Lists.Specials[itemID]
   if #entry > 1 then
      local items = {true, true}
      for i = 1, 2 do
         items[i] = GetInventoryItemLink("player", GetInventorySlotInfo(entry[i]))
      end
      if not items[1] then return items[2] end
      return unpack(items)
   elseif entry[1] == "Weapon" then
      return GetInventoryItemLink("player", GetInventorySlotInfo("MainHandSlot")), GetInventoryItemLink("player", GetInventorySlotInfo("SecondaryHandSlot"))
   else
      return GetInventoryItemLink("player", GetInventorySlotInfo(entry[1]))
   end
end

-- AQ Tokens handling
-- AQ Tokens are quest items that fits multiple slots.
-- We need to do a bit of a hack to handle these.
function addon:GetGear(link, equipLoc)
   local itemID = self.Utils:GetItemIDFromLink(link)
   if Classic.Lists.Specials[itemID] then
      return getGearForAQTokens(itemID)
   else
	   return self:GetPlayersGear(link, equipLoc, addon.playersData.gears) -- Use gear info we stored before
   end
end

function addon:NewMLCheck()
   local old_ml = self.masterLooter
   local old_lm = self.lootMethod
   self.isMasterLooter, self.masterLooter = self:GetML()
   self.lootMethod = GetLootMethod()
   if self.masterLooter and self.masterLooter ~= "" and (self.masterLooter == "Unknown" or Ambiguate(self.masterLooter, "short"):lower() == _G.UNKNOWNOBJECT:lower()) then
      -- ML might be unknown for some reason
      Classic.Log:W("NewMLCheck", "Unknown ML")
      return self:ScheduleTimer("NewMLCheck", 1)
   end
   if self:UnitIsUnit(old_ml, "player") and not self.isMasterLooter then
      -- We were ML, but no longer, so disable masterlooter module
      self:GetActiveModule("masterlooter"):Disable()
   end
   if self:UnitIsUnit(old_ml, self.masterLooter) and old_lm == self.lootMethod then
      return Classic.Log("NewMLCheck", "No ML Change") -- no change
   end
   local db = self:Getdb()
   if db.usage.never then return Classic.Log:m("NewMLCheck", "db.usage.never") end
   if self.masterLooter == nil then return end -- We're not using ML
   -- At this point we know the ML has changed, so we can wipe the council
   Classic.Log:D("NewMLCheck", "Resetting council as we have a new ML!")
   self.council = {}
   -- Check to see if we have recieved mldb within 15 secs, otherwise request it
   self:ScheduleTimer("Timer", 15, "MLdb_check")
   if not self.isMasterLooter and self.masterLooter then return Classic.Log:D("Some else is ML") end -- Someone else has become ML

   -- Check if we can use in party
   if not IsInRaid() and db.onlyUseInRaids then return Classic.Log:D("Not in raid group") end

   -- Don't do popups if we're already handling loot
	if self.handleLoot then return Classic.Log:D("Already handling loot") end

	-- Don't do pop-ups in pvp
	local _, type = IsInInstance()
	if type == "arena" or type == "pvp" then return Classic.Log:D("PVP isntance") end

   -- Check for group loot
   if addon.lootMethod == "group" and not db.useWithGroupLoot then return Classic.Log:D("lootMethod == group and useWithGroupLoot == false") end

   -- We are ML and shouldn't ask the player for usage
   if self.isMasterLooter and db.usage.ml then -- addon should auto start
      self:StartHandleLoot()

      -- We're ML and must ask the player for usage
   elseif self.isMasterLooter and db.usage.ask_ml then
      return LibDialog:Spawn("RCLOOTCOUNCIL_CONFIRM_USAGE")
   end
end

function addon:OnRaidEnter()
   local db = self:Getdb()
   -- NOTE: We shouldn't need to call GetML() as it's most likely called on "LOOT_METHOD_CHANGED"
   -- There's no ML, and lootmethod ~= ML, but we are the group leader
   -- Check if we can use in party
   if not IsInRaid() and db.onlyUseInRaids then return end
   if not self.masterLooter and UnitIsGroupLeader("player") then
      -- We don't need to ask the player for usage, so change loot method to master, and make the player ML
      if db.usage.leader then
         self.isMasterLooter, self.masterLooter = true, self.playerName
         self:StartHandleLoot()
         -- We must ask the player for usage
      elseif db.usage.ask_leader then
         return LibDialog:Spawn("RCLOOTCOUNCIL_CONFIRM_USAGE")
      end
   end
end

function addon:GetML()
   Classic.Log:D("GetML()")
   local lootMethod, mlPartyID, mlRaidID = GetLootMethod()
   Classic.Log:M("LootMethod = ", lootMethod)
   if GetNumGroupMembers() == 0 and (self.testMode or self.nnp) then -- always the player when testing alone
      self:ScheduleTimer("Timer", 5, "MLdb_check")
      return true, self.playerName
   end
   if lootMethod == "master" then
      local name;
      if mlRaidID then -- Someone in raid
         name = self:UnitName("raid"..mlRaidID)
      elseif mlPartyID == 0 then -- Player in party
         name = self.playerName
      elseif mlPartyID then -- Someone in party
         name = self:UnitName("party"..mlPartyID)
      end
      Classic.Log:M("MasterLooter = ", name)
      return IsMasterLooter(), name
   elseif lootMethod == "group" then
      -- Set the Group leader as the ML
	   local name
      for i=1, GetNumGroupMembers() or 0 do
	      local name2, rank = GetRaidRosterInfo(i)
         if not name2 then -- Group info is not completely ready
            return false, "Unknown"
         end
         if rank == 2 then -- Group leader. Btw, name2 can be nil when rank is 2.
            name = self:UnitName(name2)
         end
      end
      if name then
         return UnitIsGroupLeader("player"), name
      end
   end
   return false, nil;
end

function addon:StartHandleLoot()
   local db = self:Getdb()
   local lootMethod = GetLootMethod()
   if lootMethod == "group" and db.useWithGroupLoot then -- luacheck: ignore
      -- Do nothing.
   elseif lootMethod ~= "master" and GetNumGroupMembers() > 0 then
      self:Print(L["Changing LootMethod to Master Looting"])
      SetLootMethod("master", self.Ambiguate(self.playerName)) -- activate ML
   end
   if db.autoAward and GetLootThreshold() ~= 2 and GetLootThreshold() > db.autoAwardLowerThreshold then
      self:Print(L["Changing loot threshold to enable Auto Awarding"])
      SetLootThreshold(db.autoAwardLowerThreshold >= 2 and db.autoAwardLowerThreshold or 2)
   end

   self:Print(L["Now handles looting"])
   Classic.Log:M("Start handle loot.")
   self.handleLoot = true
   self:SendCommand("group", "StartHandleLoot")
   if #db.council == 0 then -- if there's no council
      self:Print(L["You haven't set a council! You can edit your council by typing '/rc council'"])
   end
   self:CallModule("masterlooter")
   self:GetActiveModule("masterlooter"):NewML(self.masterLooter)
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
