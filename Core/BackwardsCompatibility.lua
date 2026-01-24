--- BackwardsCompatibility.lua See RCLootCouncil/Utils/BackwardsCompat.lua

--- @type RCLootCouncil
local addon = select(2, ...)
---@class RCLootCouncil_Classic
local Classic = addon:GetModule("RCClassic")
local Compat = {}
Classic.Compat = Compat

local ItemUtils = addon.Require "Utils.Item"

--- Runs all compability changes registered.
--- Initially called in `Classic:OnEnable()`
--- Note: Nothing is run on first installs.
--- Each compat can only be run once per login, so feel free to call it again.
function Compat:Run()
    for k, v in ipairs(self.list) do
        if v.version == "always"
			or ((v.tVersion
					and addon.Utils:CheckOutdatedVersion(addon.db.global.Classic_version, v.version,
						addon.db.global.tVersion, v.tVersion)
					== addon.VER_CHECK_CODES[3])
				or (addon.Utils:CheckOutdatedVersion(addon.db.global.Classic_version, v.version,
						addon.db.global.tVersion, v.tVersion)
					== addon.VER_CHECK_CODES[2] or not addon.db.global.Classic_version))
            and not v.executed then
            Classic.Log:D("<ClassicCompat>", "Executing:", k, v.name or "no_name")
            local check, err = pcall(v.func, addon, Classic.version, addon.db.global.Classic_version,
                addon.db.global.Classic_oldVersion)
            v.executed = true
            if not check then
				Classic.Log:D("<ClassicCompat>", "<ERROR>", err)
            end
        end
    end
end

-- List of backwards compatibility. Each entry is executed numerically, if allowed.
-- Fields:
--    name:    Optional - name that gets logged if the function is run.
--    version: If the user's last version is older than this, then the function is run.
--             `always` will always run the function.
--              Directly compared in `addon:VersionCompare(db.global.version, version_field)`
--    func:    The function to execute if the version predicate is met. Called with the following parameters:
--             (addon, addon.version, addon.db.global.version, addon.db.global.oldVersion)
Compat.list = {
	{
		name = "Remove transmog options pre Cata",
		version = "1.2.1",
		func = function()
			if Classic:IsPreCata() then
				addon.db.profile.autoPassTransmog = addon.defaults.profile.autoPassTransmog
				addon.db.profile.autoPassTransmogSource = addon.defaults.profile.autoPassTransmogSource
			end
		end,
	},
    {
        name = "History Color fix",
        version = "0.22.4",
        func = function()
            local count = 0
            for _, a in pairs(_G.RCLootCouncilLootDB["factionrealm"]) do
                for _, b in pairs(a) do
                    for _, c in pairs(b) do
                        if #c.color < 3 then
                            for i = #c.color + 1, 3 do
                                c.color[i] = 1
                            end
                            count = count + 1
                        end
                    end
                end
            end
			Classic.Log:D("Fixed", count, "history colors")
        end
    },
    {
        name = "Update 'tierToken' in history",
        version = "0.23.0",
        func = function()
            for _, factionrealm in pairs(addon.lootDB.sv.factionrealm) do
                for _, data in pairs(factionrealm) do
                    for _, v in ipairs(data) do
                        v.tierToken = RCTokenTable[ItemUtils:GetItemIDFromLink(v.lootWon)] and true
                    end
                end
            end
        end
    },
    {
        name = "Update history times to ISO",
        version = "0.24.2", -- Originally 0.24.0
        func = function()
            for _, factionrealm in pairs(addon.lootDB.sv.factionrealm) do
                for _, data in pairs(factionrealm) do
                    for _, v in ipairs(data) do
                        -- We can't really guesstimate the time difference from who ML'd the item and realm time, so just update the date
                        local d, m, y = strsplit("/", v.date, 3)
                        -- Ensure we're not trying to convert something that's already in ISO format
                        if #tostring(d) < 4 then
                            v.date = string.format("%04d/%02d/%02d", "20" .. y, m, d)
                        end
                    end
                end
            end
        end,
    }
}
