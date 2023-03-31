--- Classic wrapper for retail addon loader

local debug = select(1, ...) or false
local ADDON_NAME = select(2, ...) or "RCLootCouncil_Classic"
local ADDON_OBJECT = select(3, ...) or {}

return loadfile("RCLootCouncil/.specs/AddonLoader.lua")(debug, ADDON_NAME, ADDON_OBJECT)
