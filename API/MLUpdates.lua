--- Fixed for retail RCLootCouncilML functions that doesn't function properly in Classic or otherwise needs editing
local _, addon = ...
local MLModule = addon:GetModule("RCLootCouncilML")
local Classic = addon:GetModule("RCClassic")
local L = LibStub("AceLocale-3.0"):GetLocale("RCLootCouncil")

function MLModule:HandleReceivedTradeable ()
   -- Do nothing
end

function MLModule:HandleNonTradeable ()
   -- Do nothing
end

-----------------------------------------
-- Rep Items auto award
-----------------------------------------
local orig_ShouldAutoAward = MLModule.ShouldAutoAward
local orig_AutoAward = MLModule.AutoAward
local rrCandidates = {}
local function getNextRRCandidate (args)
   -- Check all candidates are included:
   for name in pairs(MLModule.candidates) do
      if not rrCandidates[name] then rrCandidates[name] = 0 end
   end
   -- Check noone has left
   for name in pairs(rrCandidates) do
      if not MLModule.candidates[name] then rrCandidates[name] = nil end
   end
   -- Get min number of awards
   local min = 1000000
   for _,v in pairs(rrCandidates) do
      if v < min then min = v end
   end

   -- Produce a list of eligible candidates
   local eligible = {}
   for name, count in pairs(rrCandidates) do
      if count == min then
         tinsert(eligible, name)
      end
   end

   -- pick a random one
   local name = eligible[math.random(1, #eligible)]
   rrCandidates[name] = rrCandidates[name] + 1
   return name
end

function MLModule:ShouldAutoAward (item, quality)
   if not item then return false end
   local itemid = addon:GetItemIDFromLink(item)
   local db = addon:Getdb()

   -- Check always list first
   if itemid and db.autoAward and db.alwaysAutoAwardItems[itemid] then
      if UnitInRaid(db.autoAwardTo) or UnitInParty(db.autoAwardTo) then -- TEST perhaps use self.group?
         return true, "normal", db.autoAwardTo
      else
         addon:Print(L["Cannot autoaward:"])
         addon:Print(format(L["Could not find 'player' in the group."], db.autoAwardTo))
      end
   end

   -- Check for rep item auto award
   if not db.autoAwardRepItems then
      return orig_ShouldAutoAward(MLModule, item, quality)
   end

   if not (itemid and Classic.Lists.RepItems[itemid]) then
      -- We shouldn't handle this
      return orig_ShouldAutoAward(MLModule, item, quality)
   end

   local person = db.autoAwardRepItemsTo
   if db.autoAwardRepItemsMode == "RR" then
      person = getNextRRCandidate()
   end

   for name in pairs(MLModule.candidates) do
      if addon:UnitIsUnit(name, person) then
         return true, "rep_item", person
      end
   end
   -- Unit not in group
   addon:Print(L["Cannot autoaward:"])
   addon:Print(format(L["Could not find 'player' in the group."], person))
   return false
end

function MLModule:AutoAward (lootIndex, item, quality, name, mode, boss, owner)
   addon:DebugLog("ML_Classic:AutoAward", lootIndex, item, quality, name, mode, boss, owner)
   local db = addon:Getdb()
   -- Special case for group loot:
   if addon.lootMethod == "group" then
      local reason = mode == "boe" and db.autoAwardBoEReason
      or mode == "rep_item" and db.autoAwardRepItemsReason
      or db.autoAwardReason
      addon:Print(format(L["Auto awarded 'item'"], item))
		self:AnnounceAward(name, item, db.awardReasons[reason].text, nil, nil, nil, owner)
		self:TrackAndLogLoot(name, item, reason, boss, db.awardReasons[reason],nil,nil, owner)
		return true
   end

   if mode ~= "rep_item" then
      return orig_AutoAward(MLModule, lootIndex, item, quality, name, mode, boss, owner)
   elseif mode == "rep_item" then
      name = addon:UnitName(name)
      local canGiveLoot, cause = self:CanGiveLoot(lootIndex, item, name)

      if not canGiveLoot then
         addon:Print(L["Cannot autoaward:"])
         MLModule:PrintLootErrorMsg(cause, lootIndex, item, name)
         return false
      else
         MLModule:GiveLoot(lootIndex, name, function(awarded, cause)
            if awarded then
               local reason = db.autoAwardRepItemsReason
               addon:Print(format(L["Auto awarded 'item'"], item))
               MLModule:AnnounceAward(name, item, db.awardReasons[reason].text)
               MLModule:TrackAndLogLoot(name, item, reason, boss, db.awardReasons[reason])
               return true
            else
               addon:Print(L["Cannot autoaward:"])
               MLModule:PrintLootErrorMsg(cause, lootIndex, item, name)
               return false
            end
         end)
         return true
      end
   end
end

function MLModule:LootOpened()
   local db = addon:Getdb()
	local sessionframe = addon:GetActiveModule("sessionframe")
	if addon.isMasterLooter and GetNumLootItems() > 0 then
		if self.running or sessionframe:IsRunning() then -- Check if an update is needed
			self:UpdateLootSlots()
		else -- Otherwise add the loot
			for i = 1, GetNumLootItems() do
				if addon.lootSlotInfo[i] then
					local item = addon.lootSlotInfo[i].link -- This can be nil, if this is money(a coin).
					local quantity = addon.lootSlotInfo[i].quantity
					local quality = addon.lootSlotInfo[i].quality
					if db.altClickLooting then self:ScheduleTimer("HookLootButton", 0.5, i) end -- Delay lootbutton hooking to ensure other addons have had time to build their frames

					local autoAward, mode, winner = self:ShouldAutoAward(item, quality)

					if autoAward and quantity > 0 then
                  self:AutoAward(i, item, quality, winner, mode, addon.bossName)

					elseif item and self:CanWeLootItem(item, quality) and quantity > 0 then -- check if our options allows us to loot it
                  if addon.lootMethod == "master" then
						   self:AddItem(item, false, i)
                  else
                     self:AddUserItem(item) -- No owner, not in bags
                  end

					elseif quantity == 0 then -- it's coin, just loot it
						LootSlot(i)
					end
				end
			end
		end
		if #self.lootTable > 0 and not self.running then
			if db.autoStart and addon.candidates[addon.playerName] and #addon.council > 0 then -- Auto start only if data is ready
				if db.awardLater then
					self:DoAwardLater(self.lootTable)
				else
					self:StartSession()
				end
			else
				addon:CallModule("sessionframe")
				sessionframe:Show(self.lootTable)
			end
		end
	end
end

function MLModule:HookLootButton(i)
	local lootButton = getglobal("LootButton"..i)
	if _G.XLoot then -- hook XLoot
		lootButton = getglobal("XLootButton"..i)
	end
	if _G.XLootFrame then -- if XLoot 1.0
		lootButton = getglobal("XLootFrameButton"..i)
	end
	if getglobal("ElvLootSlot"..i) then -- if ElvUI
		lootButton = getglobal("ElvLootSlot"..i)
	end
	local hooked = self:IsHooked(lootButton, "OnClick")
	if lootButton and not hooked then
		addon:DebugLog("ML:HookLootButton", i)
		self:HookScript(lootButton, "OnClick", "LootOnClick")
	end
end

function MLModule:LootOnClick(button)
   local db = addon:Getdb()
	if not IsAltKeyDown() or not db.altClickLooting or IsShiftKeyDown() or IsControlKeyDown() then return; end
	addon:DebugLog("LootAltClick()", button)

	if getglobal("ElvLootFrame") then
		button.slot = button:GetID() -- ElvUI hack
	end

	-- Check we're not already looting that item
	for _, v in ipairs(self.lootTable) do
		if button.slot == v.lootSlot then
			addon:Print(L["The loot is already on the list"])
			return
		end
	end
   if addon.lootMethod == "master" then
	   self:AddItem(GetLootSlotLink(button.slot), false, button.slot)
      addon:CallModule("sessionframe")
      addon:GetActiveModule("sessionframe"):Show(self.lootTable)
   else
      self:AddUserItem(GetLootSlotLink(button.slot))
      -- AddUserItem already calls sessionframe:Show()
   end
end
