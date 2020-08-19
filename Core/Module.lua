local _, addon = ...

local ClassicModule = addon:NewModule("RCClassic", "AceHook-3.0", "AceEvent-3.0", "AceTimer-3.0")
local LibDialog = LibStub("LibDialog-1.0")
local L = LibStub("AceLocale-3.0"):GetLocale("RCLootCouncil")
local db

function ClassicModule:OnInitialize()
   self.version = GetAddOnMetadata("RCLootCouncil_Classic", "Version")
   self.tVersion = nil
   self.debug = false
   self.nnp = false
   addon.isClassic = true
   db = addon:Getdb()


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
   -- Bump logMaxEntries
   addon.db.global.logMaxEntries = 4000

   self:RegisterAddonComms()
   self:DoHooks()
   addon:InitClassIDs()

   -- Remove "role" and corruption column
   local vf = addon:GetModule("RCVotingFrame")
   vf:RemoveColumn("role")
   vf:RemoveColumn("corruption")

   -- Quest items can be looted in Classic
   addon.blacklistedItemClasses[12] = nil

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

----------------------------------------------
-- ML Functionality
----------------------------------------------
function addon:NewMLCheck()
   local old_ml = self.masterLooter
   local old_lm = self.lootMethod
   self.isMasterLooter, self.masterLooter = self:GetML()
   self.lootMethod = GetLootMethod()
   if self.masterLooter and self.masterLooter ~= "" and (self.masterLooter == "Unknown" or Ambiguate(self.masterLooter, "short"):lower() == _G.UNKNOWNOBJECT:lower()) then
      -- ML might be unknown for some reason
      self:Debug("NewMLCheck", "Unknown ML")
      return self:ScheduleTimer("NewMLCheck", 1)
   end
   if self:UnitIsUnit(old_ml, "player") and not self.isMasterLooter then
      -- We were ML, but no longer, so disable masterlooter module
      self:GetActiveModule("masterlooter"):Disable()
   end
   if self:UnitIsUnit(old_ml, self.masterLooter) and old_lm == self.lootMethod then
      return self:DebugLog("NewMLCheck", "No ML Change") -- no change
   end
   if db.usage.never then return self:DebugLog("NewMLCheck", "db.usage.never") end
   if self.masterLooter == nil then return end -- We're not using ML
   -- At this point we know the ML has changed, so we can wipe the council
   self:Debug("NewMLCheck", "Resetting council as we have a new ML!")
   self.council = {}
   -- Check to see if we have recieved mldb within 15 secs, otherwise request it
   self:ScheduleTimer("Timer", 15, "MLdb_check")
   if not self.isMasterLooter and self.masterLooter then return end -- Someone else has become ML

   -- Check if we can use in party
   if not IsInRaid() and db.onlyUseInRaids then return end

   -- Don't do popups if we're already handling loot
	if self.handleLoot then return end

	-- Don't do pop-ups in pvp
	local _, type = IsInInstance()
	if type == "arena" or type == "pvp" then return end

   -- Check for group loot
   if addon.lootMethod == "group" and not db.useWithGroupLoot then return end

   -- We are ML and shouldn't ask the player for usage
   if self.isMasterLooter and db.usage.ml then -- addon should auto start
      self:StartHandleLoot()

      -- We're ML and must ask the player for usage
   elseif self.isMasterLooter and db.usage.ask_ml then
      return LibDialog:Spawn("RCLOOTCOUNCIL_CONFIRM_USAGE")
   end
end

function addon:OnRaidEnter()
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
   self:DebugLog("GetML()")
   local lootMethod, mlPartyID, mlRaidID = GetLootMethod()
   addon.lootMethod = lootMethod
   self:Debug("LootMethod = ", lootMethod)
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
      self:Debug("MasterLooter = ", name)
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
   self:Debug("Start handle loot.")
   self.handleLoot = true
   self:SendCommand("group", "StartHandleLoot")
   if #db.council == 0 then -- if there's no council
      self:Print(L["You haven't set a council! You can edit your council by typing '/rc council'"])
   end
   self:CallModule("masterlooter")
   self:GetActiveModule("masterlooter"):NewML(self.masterLooter)
end

-- Retail has a check for 'lootMethod' which isn't feasible.
-- Most of those functions might get removed in retail anyway, so just reimplement it.
function ClassicModule:OnLootOpen()
   if addon.handleLoot then
      wipe(addon.modules.RCLootCouncilML.lootQueue)
      if not InCombatLockdown() then
         addon.modules.RCLootCouncilML:LootOpened()
      else
         addon:Print(L["You can't start a loot session while in combat."])
      end
   end
end
