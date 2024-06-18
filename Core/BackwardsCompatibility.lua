--- BackwardsCompatibility.lua See RCLootCouncil/Utils/BackwardsCompat.lua

--- @type RCLootCouncil
local addon = select(2, ...)
local Classic = addon:GetModule("RCClassic")
local Compat = {}
Classic.Compat = Compat

--- Runs all compability changes registered.
--- Initially called in `Classic:OnEnable()`
--- Note: Nothing is run on first installs.
--- Each compat can only be run once per login, so feel free to call it again.
function Compat:Run()
    for k, v in ipairs(self.list) do
        addon:Debug("CompatRun", v.name)
        if v.version == "always"
            or (addon:VersionCompare(addon.db.global.Classic_version, v.version) or not addon.db.global.Classic_version)
            and not v.executed then
            addon:Debug("<ClassicCompat>", "Executing:", k, v.name or "no_name")
            local check, err = pcall(v.func, addon, Classic.version, addon.db.global.Classic_version,
                addon.db.global.Classic_oldVersion)
            v.executed = true
            if not check then
                addon:Debug("<ClassicCompat>", "<ERROR>", err)
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
            addon:Debug("Fixed", count, "history colors")
        end
    }
}
