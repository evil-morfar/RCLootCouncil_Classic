--- Fixed for retail RCLootCouncilML functions that doesn't function properly in Classic or otherwise needs editing
local _, addon = ...
local MLModule = addon:GetModule("RCLootCouncilML")
local L = LibStub("AceLocale-3.0"):GetLocale("RCLootCouncil")

function MLModule:HandleReceivedTradeable ()
   -- Do nothing
end

function MLModule:HandleNonTradeable ()
   -- Do nothing
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
					self:DoAwardLater()
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
