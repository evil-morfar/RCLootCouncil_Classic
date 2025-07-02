--- Emulates the login process and fires needed events.
--- Should be called after addon files are loaded.
--- Run with: dofile ".specs/EmulatePlayerLogin.lua"

function _G.IsLoggedIn() return true end

WoWAPI_FireEvent("ADDON_LOADED", "RCLootCouncil_Classic")
WoWAPI_FireEvent("PLAYER_LOGIN", "RCLootCouncil_Classic")
RCLootCouncil:InitItemStorage() -- Will be called too late for tests
