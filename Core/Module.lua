local _, addon = ...

local ClassicModule = addon:NewModule("RCClassic", "AceHook-3.0", "AceEvent-3.0", "AceTimer-3.0")

function ClassicModule:OnInitialize()
   self.version = GetAddOnMetadata("RCLootCouncil_Classic", "Version")
   self.tVersion = "Alpha.3"
   self.debug = true
   self.nnp = false

   -- Store RCLootCouncil Variables
   self.RCLootCouncil = {}
   self.RCLootCouncil.version = addon.version
   self.RCLootCouncil.tVersion = addon.tVersion
   addon.version =  self.version
   addon.tVersion = self.tVersion
   addon.debug = self.debug
   addon.nnp = self.nnp

   self:Enable()
end

function ClassicModule:OnEnable ()
   addon:DebugLog("ClassicModule enabled", self.version, self.tVersion)

   addon.db.global.Classic_oldVersion = addon.db.global.Classic_oldVersion
	addon.db.global.Classic_version = self.version

   self:DoHooks()

   self:RegisterEvent("LOOT_OPENED", "LootOpened")
end


function ClassicModule:LootOpened (...)
   addon:DebugLog("LootOpened")
   addon.lootOpen = true
   -- Rebuild the items that wasn't registered in "LOOT_READY"
   for i = 1,  GetNumLootItems() do
		if not addon.lootSlotInfo[i] and LootSlotHasItem(i) then
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



   if addon.isMasterLooter then
		addon:GetActiveModule("masterlooter"):OnLootOpen()
	end
end
