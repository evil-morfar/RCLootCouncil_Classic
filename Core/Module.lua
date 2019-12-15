local _, addon = ...

local ClassicModule = addon:NewModule("RCClassic", "AceHook-3.0", "AceEvent-3.0", "AceTimer-3.0")
local LibDialog = LibStub("LibDialog-1.0")
local L = LibStub("AceLocale-3.0"):GetLocale("RCLootCouncil")
local LC = LibStub("AceLocale-3.0"):GetLocale("RCLootCouncil_Classic")
local db

function ClassicModule:OnInitialize()
   self.version = GetAddOnMetadata("RCLootCouncil_Classic", "Version")
   self.tVersion = "Beta.1"
   self.debug = false
   self.nnp = false

   self:DoHooks()
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

   -- Remove "role" column
   local vf = addon:GetModule("RCVotingFrame")
   vf:RemoveColumn("role")

   -- Quest items can be looted in Classic
   addon.blacklistedItemClasses[12] = nil

   self:RegisterEvent("LOOT_OPENED", "LootOpened")
   self:RegisterEvent("LOOT_CLOSED", "LootClosed")
end

function ClassicModule:LootOpened (...)
   addon:DebugLog("LootOpened")
   addon.lootOpen = true

   if addon.isMasterLooter then
      -- Rebuild the items that wasn't registered in "LOOT_READY"
      for i = 1,  GetNumLootItems() do
   		if (not addon.lootSlotInfo[i] and LootSlotHasItem(i))
         or (addon.lootSlotInfo[i] and not addon:ItemIsItem(addon.lootSlotInfo[i].link, GetLootSlotLink(i))) then
            addon:DebugLog("Rebuilding lootSlot", i, "in ClassicModule:LoopOpened")
   			local texture, name, quantity, currencyID, quality, _, isQuestItem = GetLootSlotInfo(i)
   			local guid = addon.Utils:ExtractCreatureID((GetLootSourceInfo(i)))
   			if guid and addon.lootGUIDToIgnore[guid] then return addon:Debug("Ignoring loot from ignored source", guid) end
   			if texture then
   				local link = GetLootSlotLink(i)
   				if currencyID then
   					addon:DebugLog("Ignoring", link, "as it's a currency")
   				elseif not addon.Utils:IsItemBlacklisted(link) then
   					addon:Debug("Adding to self.lootSlotInfo",i,link, quality,quantity, GetLootSourceInfo(i))
   					addon.lootSlotInfo[i] = {
   						name = name,
   						link = link, -- This could be nil, if the item is money.
   						quantity = quantity,
   						quality = quality,
   						guid = guid, -- Boss GUID
   						boss = (GetUnitName("target")),
   						autoloot = select(1,...),
   					}
   				end
   			else -- It's possible that item in the loot window is uncached. Retry in the next frame.
   				addon:Debug("Loot uncached when the loot window is opened. Retry in the next frame.", name)
   				-- Must offer special argument as 2nd argument to indicate this is run from scheduler.
   				-- REVIEW: 20/12-18: This actually hasn't been used for a long while - removing "scheduled" arg
   				return self:ScheduleTimer("LootOpened", 0)
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
	self.isMasterLooter, self.masterLooter = self:GetML()
	if self.masterLooter and self.masterLooter ~= "" and strfind(self.masterLooter, "Unknown") then
		-- ML might be unknown for some reason
		self:Debug("NewMLCheck","Unknown ML")
		return self:ScheduleTimer("NewMLCheck", 2)
	end
	if self:UnitIsUnit(old_ml, "player") and not self.isMasterLooter then
		-- We were ML, but no longer, so disable masterlooter module
		self:GetActiveModule("masterlooter"):Disable()
	end
	if self:UnitIsUnit(old_ml, self.masterLooter) then return self:DebugLog("NewMLCheck", "No ML Change") end -- no change
   if db.usage.never then return self:DebugLog("NewMLCheck","db.usage.never") end
	if self.masterLooter == nil then return end -- We're not using ML
	-- At this point we know the ML has changed, so we can wipe the council
	self:Debug("NewMLCheck","Resetting council as we have a new ML!")
	self.council = {}
	if not self.isMasterLooter and self.masterLooter then return end -- Someone else has become ML

	-- Check if we can use in party
	if not IsInRaid() and db.onlyUseInRaids then return end

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
	if GetNumGroupMembers() == 0 and (self.testMode or self.nnp) then -- always the player when testing alone
		self:ScheduleTimer("Timer", 5, "MLdb_check")
		return true, self.playerName
	end
	local lootMethod, mlPartyID, mlRaidID = GetLootMethod()
	self:Debug("LootMethod = ", lootMethod)
	if lootMethod == "master" then
		local name;
		if mlRaidID then 				-- Someone in raid
			name = self:UnitName("raid"..mlRaidID)
		elseif mlPartyID == 0 then -- Player in party
			name = self.playerName
		elseif mlPartyID then		-- Someone in party
			name = self:UnitName("party"..mlPartyID)
		end
		self:Debug("MasterLooter = ", name)
		-- Check to see if we have recieved mldb within 15 secs, otherwise request it
		self:ScheduleTimer("Timer", 15, "MLdb_check")
		return IsMasterLooter(), name
	end
	return false, nil;
end

function addon:StartHandleLoot()
   local lootMethod = GetLootMethod()
   if lootMethod ~= "master" and GetNumGroupMembers() > 0 then
      self:Print(L["Changing LootMethod to Master Looting"])
      SetLootMethod("master", self.Ambiguate(self.playerName)) -- activate ML
   end
   if db.autoAward and GetLootThreshold() ~= 2 and GetLootThreshold() > db.autoAwardLowerThreshold  then
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
	wipe(addon.modules.RCLootCouncilML.lootQueue)
	if addon.handleLoot then
		if not InCombatLockdown() then
			addon.modules.RCLootCouncilML:LootOpened() -- REVIEW Consider porting this function.
		else
			addon:Print(L["You can't start a loot session while in combat."])
		end
	end
end
