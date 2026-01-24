---@class RCLootCouncil : AceAddon-3.0, AceConsole-3.0, AceEvent-3.0, AceHook-3.0, AceTimer-3.0, AceBucket-3.0
local addon = select(2, ...)

---@class RCLootCouncil_Classic : AceModule, AceHook-3.0, AceEvent-3.0, AceTimer-3.0
local ClassicModule = addon:NewModule("RCClassic", "AceHook-3.0", "AceEvent-3.0", "AceTimer-3.0")
local L = LibStub("AceLocale-3.0"):GetLocale("RCLootCouncil")

local Council = addon.Require "Data.Council"
function ClassicModule:OnInitialize()
   self.version = C_AddOns.GetAddOnMetadata("RCLootCouncil_Classic", "Version")
   self.tVersion = nil
   self.debug = false
   self.nnp = false
   addon.isClassic = true

   self.Log = addon.Require "Utils.Log":New("Classic")

   self:ScheduleTimer("Enable", 0) -- Enable just after RCLootCouncil has had the chance to be enabled
end

function ClassicModule:OnEnable ()
   self.Log:D("ClassicModule enabled", self.version, self.tVersion)

   -- Store RCLootCouncil Variables
   self.RCLootCouncil = {}
   self.RCLootCouncil.version = addon.version
   self.RCLootCouncil.tVersion = addon.tVersion
   addon.version = self.version
   addon.tVersion = self.tVersion or addon.tVersion -- Use our test version to benefit from test code
   addon.debug = self.debug
   addon.nnp = self.nnp

   if addon.db.global.Classic_version then
      self.Log:D("Running compat")
      self.Compat:Run()
   end

   addon.db.global.Classic_oldVersion = addon.db.global.Classic_version
   addon.db.global.Classic_version = self.version
   addon.db.global.Classic_game = WOW_PROJECT_ID
   -- Bump logMaxEntries
   addon.db.global.logMaxEntries = 4000

   self:DoHooks()
   addon:InitClassIDs()

   -- Remove "role" column (Pre Mists and Classic only)
   if self:IsPreMists()() then
	local vf = addon:GetActiveModule("votingframe")
	vf:RemoveColumn("role")
end

   self:UpdateBlacklist()

   self:RegisterEvent("LOOT_OPENED", "LootOpened")
   self:RegisterEvent("LOOT_CLOSED", "LootClosed")

   -- Version checker should handle Classic Module, as it's lifted to be the main version.
   -- Not doing this would result in both `RCLootCouncil` and `module RCLootCouncil_Classic` is outdated prints.
   addon:GetActiveModule("version").moduleVerCheckDisplayed[self.baseName] = true
end
function ClassicModule:LootOpened (...)
	addon.lootOpen = true
	
	if addon.isMasterLooter then
		self.Log:D("LootOpened")
      -- Rebuild the items that wasn't registered in "LOOT_READY"
      for i = 1, GetNumLootItems() do
         if (not addon.lootSlotInfo[i] and LootSlotHasItem(i))
         or (addon.lootSlotInfo[i] and not addon:ItemIsItem(addon.lootSlotInfo[i].link, GetLootSlotLink(i))) then
            self.Log:D("Rebuilding lootSlot", i)
            local texture, name, quantity, currencyID, quality = GetLootSlotInfo(i)
            local guid = addon.Utils:ExtractCreatureID((GetLootSourceInfo(i)))
				if guid and addon.lootGUIDToIgnore[guid] then return self.Log:D("Ignoring loot from ignored source", guid) end
            if texture then
               local link = GetLootSlotLink(i)
               if currencyID then
                  self.Log:D("Ignoring", link, "as it's a currency")
               elseif not addon.Utils:IsItemBlacklisted(link) then
						self.Log:D("Adding to self.lootSlotInfo", i, link, quality, quantity, GetLootSourceInfo(i))
                  addon.lootSlotInfo[i] = {
                     name = name,
                     link = link, -- This could be nil, if the item is money.
                     quantity = quantity,
                     quality = quality,
                     guid = guid, -- Boss GUID
                     boss = (GetUnitName("target")),
                     autoloot = select(1, ...),
                  }
               end
            else -- It's possible that item in the loot window is uncached. Retry in the next frame.
               local _, autoloot, count = ...
					self.Log:D("Loot uncached when the loot window is opened. Retry in the next frame.", name, count or 0)
               if not count then
                  count = 1
               else
                  count = count + 1
               end
               -- NOTE: 21/3-20 Add some diminishing returns on this, as we apparently can't rely on it being ready in the next frame
               -- according to recent issues
               return self:ScheduleTimer("LootOpened", count / 10, "LOOT_OPENED", autoloot, count)
            end
         end
      end

      self:OnLootOpen()
   end
end

function ClassicModule:LootClosed ()
	addon.lootOpen = false
	if addon.isMasterLooter then
		self.Log:D("LootClosed")
	end
end

-- Retail has a check for 'lootMethod' which isn't feasible.
-- Most of those functions might get removed in retail anyway, so just reimplement it.
function ClassicModule:OnLootOpen()
   if addon.handleLoot then
      local db = addon:Getdb()
	  ---@type RCLootCouncilML
	  local ML = addon:GetActiveModule("masterlooter")
      wipe(ML.lootQueue)
      -- Only proceed if we're not in combat, or our settings means we won't be creating any frames.
      if not InCombatLockdown() or (db.autoStart and db.awardLater and Council:Contains(addon.player) and Council.GetNum() > 0) or db.skipCombatLockdown then
         ML:LootOpened()
      else
         addon:Print(L["You can't start a loot session while in combat."])
      end
   end
end

function ClassicModule:UpdateBlacklist()
   -- Quest items can be looted in Classic
   addon.blacklistedItemClasses[12] = nil

   -- Add our "Lists" to blacklist override
   for _,list in pairs(self.Lists) do
      for id in pairs(list) do
         addon.blackListOverride[id] = true
      end
   end

   -- Add "always auto award" items to blacklist override
   for id in pairs(addon.db.profile.alwaysAutoAwardItems) do
      addon.blackListOverride[id] = true
   end
end

---@return boolean #True if running Classic Era game
function ClassicModule:IsClassicEra()
   return WOW_PROJECT_CLASSIC == WOW_PROJECT_ID
end

function ClassicModule:IsSeasonOfDiscovery()
	return self:IsPreWrath() and C_Seasons.GetActiveSeason() == Enum.SeasonID.SeasonOfDiscovery
end

function ClassicModule:IsPreWrath()
	return LE_EXPANSION_LEVEL_CURRENT < LE_EXPANSION_WRATH_OF_THE_LICH_KING
end

function ClassicModule:IsPreCata()
	return LE_EXPANSION_LEVEL_CURRENT < LE_EXPANSION_CATACLYSM
end

function ClassicModule:IsPreMists()
	return LE_EXPANSION_LEVEL_CURRENT < LE_EXPANSION_MISTS_OF_PANDARIA
end