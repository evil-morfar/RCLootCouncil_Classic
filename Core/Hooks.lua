local _, addon = ...

---@class RCLootCouncil_ClassicModule
local Classic = addon:GetModule("RCClassic")
local HistoryFrame = addon:GetModule("RCLootHistory")
local hooks = {}

function Classic:DoHooks()
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
		if WOW_PROJECT_MISTS_CLASSIC == WOW_PROJECT_ID then
			HistoryFrame.wowheadBaseUrl = "https://www.wowhead.com/mop-classic/item="
		elseif WOW_PROJECT_WRATH_CLASSIC == WOW_PROJECT_ID then
			HistoryFrame.wowheadBaseUrl = "https://wowhead.com/wotlk/item="
		elseif WOW_PROJECT_BURNING_CRUSADE_CLASSIC == WOW_PROJECT_ID then
			HistoryFrame.wowheadBaseUrl = "https://tbc.wowhead.com/item="
		elseif WOW_PROJECT_CLASSIC == WOW_PROJECT_ID then
			HistoryFrame.wowheadBaseUrl = "https://classic.wowhead.com/item="
		end
	end,
})


tinsert(hooks, {
	object = addon,
	ref = "GetInstalledModulesFormattedData",
	type = "raw",
	func = function()
		local modules = Classic.hooks[addon].GetInstalledModulesFormattedData(addon)
		-- Insert core RCLootCouncil version
		local coreVersion = "RCLootCouncil Core - " .. Classic.RCLootCouncil.version
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
	func = function()
		-- Class tags needs updated as druids are number 11 and we have 9 classes
		local info = C_CreatureInfo.GetClassInfo(11)
		addon.classDisplayNameToID[info.className] = 11
		addon.classTagNameToID[info.classFile] = 11
		addon.classIDToDisplayName = tInvert(addon.classDisplayNameToID)
		addon.classIDToFileName = tInvert(addon.classTagNameToID)
	end,
})
