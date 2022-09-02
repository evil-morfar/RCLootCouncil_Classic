local _, addon = ...

local Classic = addon:GetModule("RCClassic")
local VotingFrame = addon:GetModule("RCVotingFrame")
local SessionFrame = addon:GetModule("RCSessionFrame")
local HistoryFrame = addon:GetModule("RCLootHistory")
local hooks = {}

function Classic:DoHooks ()
   for _, data in pairs(hooks) do
      if data.type == "raw" then
         Classic:RawHook(data.object, data.ref, data.func)
      --elseif data.type == "script" then
      elseif data.type == "secure" then
         Classic:SecureHook(data.object, data.ref, data.func)
      else
         Classic:Hook(data.object, data.ref, data.func)
      end
   end
end

tinsert(hooks, {
   object = HistoryFrame,
   ref = "OnEnable",
   type = "post",
   func = function()
      if WOW_PROJECT_WRATH_CLASSIC == WOW_PROJECT_ID then
         HistoryFrame.wowheadBaseUrl = "https://wowhead.com/wotlk/item="
      elseif WOW_PROJECT_BURNING_CRUSADE_CLASSIC == WOW_PROJECT_ID then
         HistoryFrame.wowheadBaseUrl = "https://tbc.wowhead.com/item="
      elseif WOW_PROJECT_CLASSIC == WOW_PROJECT_ID then
         HistoryFrame.wowheadBaseUrl = "https://classic.wowhead.com/item="
      end
   end
})

tinsert(hooks, {
   object = SessionFrame,
   ref = "GetFrame",
   type = "raw",
   func = function()
      local frame = Classic.hooks[SessionFrame].GetFrame(SessionFrame)
      if frame.lootStatus then
         frame.lootStatus:Hide()
         frame.lootStatus = nil
      end
      return frame
   end,
})

tinsert(hooks, {
   object = VotingFrame,
   ref = "OnEnable",
   type = "raw",
   func = function()
      -- Call original
      Classic.hooks[VotingFrame].OnEnable(VotingFrame)
      VotingFrame.frame.lootStatus:Hide()
      VotingFrame.frame.lootStatus = nil
   end,
})

tinsert(hooks, {
   object = addon,
   ref = "GetInstalledModulesFormattedData",
   type = "raw",
   func = function()
      local modules = Classic.hooks[addon].GetInstalledModulesFormattedData(addon)
      -- Insert core RCLootCouncil version
      local coreVersion = "RCLootCouncil Core - "..Classic.RCLootCouncil.version
      if Classic.RCLootCouncil.tVersion then
         coreVersion = coreVersion .. "-" .. Classic.RCLootCouncil.tVersion
      end
      tinsert(modules, coreVersion)
      return modules
   end,
})

tinsert(hooks, {
   object = addon,
   ref = "InitClassIDs",
   type = "raw",
   func = function ()
      -- Class tags needs updated as druids are number 11 and we have 9 classes
      local info = C_CreatureInfo.GetClassInfo(11)
      addon.classDisplayNameToID[info.className] = 11
      addon.classTagNameToID[info.classFile] = 11
      addon.classIDToDisplayName = tInvert(addon.classDisplayNameToID)
      addon.classIDToFileName = tInvert(addon.classTagNameToID)
   end
})

tinsert(hooks, {
   object = addon,
   ref = "OnMLDBReceived",
   type = "post",
   func = function(self)
      if self.mldb.observe and not self:GetActiveModule("votingframe"):IsEnabled() then
         self:CallModule("votingframe")
      end
   end
})

local rclootcoucnilCoreVersionsToIgnore = {
   ["2.14.0"] = true,
   ["2.15.0"] = true,
   ["2.15.1"] = true,
   ["2.18.1"] = true,
   ["2.18.2"] = true,
}

tinsert(hooks, {
   object = addon,
   ref = "PrintOutdatedVersionWarning",
   type = "raw",
   func = function(self, newVersion, ourVersion)
      -- Fix issue with pre 0.3.0 that reported it's RCLootCouncil version.
      -- v0.4.1: Core version was also sent from RCLootCouncil:OnEnable to guild members.
      if newVersion and not rclootcoucnilCoreVersionsToIgnore[newVersion] then
         -- Call original
         Classic.hooks[addon].PrintOutdatedVersionWarning(addon, newVersion, ourVersion)
      end
   end,
})

-- Fix for Blizzard screwing up DropDowns when using ML.
tinsert(hooks, {
   type = "secure",
   object = _G.MasterLooterFrame,
   ref = "Hide",
   func = function(self)
      self:ClearAllPoints()
   end
})
