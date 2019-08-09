--- Fixed for retail RCLootCouncil function that doesn't function properly in Classic
local _, addon = ...
local private = {}

----------------------------------------------
-- Core
----------------------------------------------
function addon:UpdatePlayersData()
   -- Nil on purpose
end

-- fullTest is used with Dungeon Journal, and thus is ignored
function addon:Test (num, fullTest, trinketTest)
   self:Debug("Test", num, fullTest, trinketTest)
   num = num or 3
   local testItems = {
      17076,12590,14555,11684,22691,871,18719, -- Weapons
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

function addon:GetPlayerInfo ()
   local enchant, lvl = nil, 0
   -- TODO GetProfessions() doesn't work
   -- local profs = {GetProfessions()}
	-- for i = 1, 2 do
	-- 	if profs[i] then
	-- 		local _, _, rank, _, _, _, id = GetProfessionInfo(profs[i])
	-- 		if id and id == 333 then -- NOTE: 333 should be enchanting, let's hope that holds...
	-- 			self:Debug("I'm an enchanter")
	-- 			enchant, lvl = true, rank
	-- 			break
	-- 		end
	-- 	end
	-- end

   -- GetAverageItemLevel() isn't implemented
   local ilvl = private.GetAverageItemLevel()
   return self.playerName, self.playerClass, self:GetPlayerRole(), self.guildRank, enchant, lvl, ilvl, self.playersData.specID
end


----------------------------------------------
-- Utils
----------------------------------------------
function addon.Utils:GetPlayerRole ()
   return "NONE" -- FIXME Needs fixing
end



----------------------------------------------
-- Private helper functions
----------------------------------------------
--- Recreates functionality of GetAverageItemLevel()
function private.GetAverageItemLevel()
   local sum, count = 0, 0
   for i=_G.INVSLOT_FIRST_EQUIPPED, _G.INVSLOT_LAST_EQUIPPED do
      local iLink = _G.GetInventoryItemLink("player", i)
      if iLink then
         local ilvl = select(4, _G.GetItemInfo(iLink))
         sum = sum + ilvl
         count = count + 1
      end
   end
   return sum / count
end
