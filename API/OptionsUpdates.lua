--- Includes all changes to the options menu for Classic
local _, addon = ...
local RCClassic = addon:GetModule("RCClassic")
local L = LibStub("AceLocale-3.0"):GetLocale("RCLootCouncil")
local LC = LibStub("AceLocale-3.0"):GetLocale("RCLootCouncil_Classic")

local old_options_func = addon.OptionsTable
function addon:OptionsTable ()
   local options = old_options_func(addon)
   -- Inject RCClassic version in the description
   options.args.settings.args.version.name = function ()
      local desc = "Classic: "
      -- Classic version
      if RCClassic.tVersion then
         desc = desc .. "|cFFff9100v"..RCClassic.version.."|r-"..RCClassic.tVersion
      else
         desc = desc .. "|cFFff9100v"..RCClassic.version.."|r"
      end
      -- Core version
      desc = desc .. "\nCore: "
      if RCClassic.RCLootCouncil.tVersion then
         desc = desc .. "|cFF87CEFAv"..RCClassic.RCLootCouncil.version.."|r-"..RCClassic.RCLootCouncil.tVersion
      else
         desc = desc .. "|cFF87CEFAv"..RCClassic.RCLootCouncil.version.."|r"
      end
      return desc
   end
   -- Usage options
   options.args.mlSettings.args.generalTab.args.usageOptions.args.usage.values = {
      	ml 			= LC["opt_usage_ml"],
			ask_ml		= LC["opt_usage_ask_ml"],
		--	leader 		= "Always use RCLootCouncil when I'm the group leader and enter a raid",
		--	ask_leader	= "Ask me every time I'm the group leader and enter a raid",
			never			= L["Never use RCLootCouncil"],
   }
   options.args.mlSettings.args.generalTab.args.usageOptions.args.leaderUsage = { -- Add leader options here since we can only make a single select dropdown
		order = 3,
		name = function() return self.db.profile.usage.ml and LC["opt_usage_leader_always"] or LC["opt_usage_leader_ask"] end,
		desc = LC["leaderUsage_desc"],
		type = "toggle",
		get = function() return self.db.profile.usage.leader or self.db.profile.usage.ask_leader end,
		set = function(_, val)
			self.db.profile.usage.leader, self.db.profile.usage.ask_leader = false, false -- Reset for zzzzz
			if self.db.profile.usage.ml then self.db.profile.usage.leader = val end
			if self.db.profile.usage.ask_ml then self.db.profile.usage.ask_leader = val end
		end,
		disabled = function() return self.db.profile.usage.never end,
	}

   -- Disable "Allow Keeping" and "Trade Messages" options
   options.args.mlSettings.args.generalTab.args.lootingOptions.args.printCompletedTrades = nil
   options.args.mlSettings.args.generalTab.args.lootingOptions.args.rejectTrade = nil

   -- Remove "Spec Icon" as there's no clear definition of a spec
   options.args.settings.args.generalSettingsTab.args.frameOptions.args.showSpecIcon = nil

   -- Update "Patch" values in delete history
   options.args.settings.args.generalSettingsTab.args.lootHistoryOptions.args.deletePatch.values =
   {
      [1566900000] = "Phase 1 (Classic Launch)",
      [1571097600] = "Diremaul Release",
      [1576029600] = "Patch 1.13.3"
   }
   -- "_G.INSTANCE" isn't available for localization - use our own
   options.args.settings.args.generalSettingsTab.args.lootHistoryOptions.args.deleteRaid.name = LC["Instance"]

   -- Remove "Bonus Rolls" option
   options.args.mlSettings.args.generalTab.args.lootingOptions.args.saveBonusRolls = nil

   return options
end
