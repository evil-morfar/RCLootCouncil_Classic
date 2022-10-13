local _, addon = ...

local ClassicModule = addon:NewModule("RCClassic", "AceHook-3.0", "AceEvent-3.0", "AceTimer-3.0")
local L = LibStub("AceLocale-3.0"):GetLocale("RCLootCouncil")

function ClassicModule:OnInitialize()
   self.version = GetAddOnMetadata("RCLootCouncil_Classic", "Version")
   self.tVersion = nil
   self.debug = false
   self.nnp = false
   addon.isClassic = true

   self:ScheduleTimer("Enable", 0) -- Enable just after RCLootCouncil has had the chance to be enabled
end

function ClassicModule:OnEnable ()
   addon:DebugLog("ClassicModule enabled", self.version, self.tVersion)

   -- Store RCLootCouncil Variables
   self.RCLootCouncil = {}
   self.RCLootCouncil.version = addon.version
   self.RCLootCouncil.tVersion = addon.tVersion
   addon.version = self.version
   addon.tVersion = self.tVersion or addon.tVersion -- Use our test version to benefit from test code
   addon.debug = self.debug
   addon.nnp = self.nnp

   addon.db.global.Classic_oldVersion = addon.db.global.Classic_version
   addon.db.global.Classic_version = self.version
   addon.db.global.Classic_game = WOW_PROJECT_ID
   -- Bump logMaxEntries
   addon.db.global.logMaxEntries = 4000

   self:RegisterAddonComms()
   self:DoHooks()
   addon:InitClassIDs()

   -- Remove "role" and corruption column
   local vf = addon:GetModule("RCVotingFrame")
   vf:RemoveColumn("role")
   vf:RemoveColumn("corruption")

   self:UpdateBlacklist()

   self:RegisterEvent("LOOT_OPENED", "LootOpened")
   self:RegisterEvent("LOOT_CLOSED", "LootClosed")
   self:CandidateCheck()

   -- Version checker should handle Classic Module, as it's lifted to be the main version.
   -- Not doing this would result in both `RCLootCouncil` and `module RCLootCouncil_Classic` is outdated prints.
   addon.moduleVerCheckDisplayed[self.baseName] = true
end

function ClassicModule:RegisterAddonComms ()
   self:DoCommsCompressFix()
   addon:RegisterComm("RCLootCouncil")
   addon:RegisterComm("RCLCv")
end

-- v0.9.x: Due to the change in registering comms, a /reload can cause
-- candidates to be sent, but not received locally as comms are not yet
-- registered, which MLModule relies on.
-- This function is run after comms initialization and simply resends
-- candidates if needed.
function ClassicModule:CandidateCheck ()
   local ML = addon:GetActiveModule("masterlooter")
   if ML.timers and ML.timers.candidates_cooldown then
      ML.timers.candidates_cooldown = nil
      ML:SendCandidates()
   end
end

function ClassicModule:LootOpened (...)
   addon:DebugLog("LootOpened")
   addon.lootOpen = true

   if addon.isMasterLooter then
      -- Rebuild the items that wasn't registered in "LOOT_READY"
      for i = 1, GetNumLootItems() do
         if (not addon.lootSlotInfo[i] and LootSlotHasItem(i))
         or (addon.lootSlotInfo[i] and not addon:ItemIsItem(addon.lootSlotInfo[i].link, GetLootSlotLink(i))) then
            addon:DebugLog("Rebuilding lootSlot", i, "in ClassicModule:LoopOpened")
            local texture, name, quantity, currencyID, quality = GetLootSlotInfo(i)
            local guid = addon.Utils:ExtractCreatureID((GetLootSourceInfo(i)))
            if guid and addon.lootGUIDToIgnore[guid] then return addon:Debug("Ignoring loot from ignored source", guid) end
            if texture then
               local link = GetLootSlotLink(i)
               if currencyID then
                  addon:DebugLog("Ignoring", link, "as it's a currency")
               elseif not addon.Utils:IsItemBlacklisted(link) then
                  addon:Debug("Adding to self.lootSlotInfo", i, link, quality, quantity, GetLootSourceInfo(i))
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
               addon:Debug("Loot uncached when the loot window is opened. Retry in the next frame.", name, count or 0)
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
   addon:DebugLog("LootClosed")
   addon.lootOpen = false
end

-- Retail has a check for 'lootMethod' which isn't feasible.
-- Most of those functions might get removed in retail anyway, so just reimplement it.
function ClassicModule:OnLootOpen()
   if addon.handleLoot then
      local db = addon:Getdb()
      wipe(addon.modules.RCLootCouncilML.lootQueue)
      -- Only proceed if we're not in combat, or our settings means we won't be creating any frames.
      if not InCombatLockdown() or (db.autoStart and db.awardLater and addon.candidates[addon.playerName] and #addon.council > 0) or db.skipCombatLockdown then
         addon.modules.RCLootCouncilML:LootOpened()
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