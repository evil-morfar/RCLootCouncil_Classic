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

   -- Get the name of the first person to equal min awards
   for name, count in pairs(rrCandidates) do
      if count == min then
         rrCandidates[name] = count + 1
         return name
      end
   end
end

function MLModule:ShouldAutoAward (item, quality)
   if not item then return false end
   -- Check for rep item auto award
   local db = addon:Getdb()
   if not db.autoAwardRepItems then
      return orig_ShouldAutoAward(MLModule, item, quality)
   end

   local itemid = addon:GetItemIDFromLink(item)
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
   if mode ~= "rep_item" then
      return orig_AutoAward(MLModule, lootIndex, item, quality, name, mode, boss, owner)
   elseif mode == "rep_item" then
      name = addon:UnitName(name)
      addon:DebugLog("ML_Classic:AutoAward", lootIndex, item, quality, name, mode, boss, owner)
      local canGiveLoot, cause = self:CanGiveLoot(lootIndex, item, name)

      if not canGiveLoot then
         addon:Print(L["Cannot autoaward:"])
         MLModule:PrintLootErrorMsg(cause, lootIndex, item, name)
         return false
      else
         MLModule:GiveLoot(lootIndex, name, function(awarded, cause)
            if awarded then
               local db = addon:Getdb()
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
