--- Classic wrapper for retail addon loader
local debug = select(1, ...) or false
local ADDON_NAME = select(2, ...) or "RCLootCouncil_Classic"
local ADDON_OBJECT = select(3, ...) or {}

local AL = loadfile(".specs/AddonLoader.lua")(debug, ADDON_NAME, ADDON_OBJECT, WOW_PROJECT_CLASSIC)

-- Tests are defined with "RCLootCouncil" as the root, but toc files with "RCLootCouncil_Classic".

---@param path string
local function FixPath (path)
	if path:match("^RCLootCouncil/?\\?") then
		return (path:gsub("RCLootCouncil/?\\?", ""))
	elseif path:match("^/?%.%./") then
		return (path)
	end
	return "../" .. path
end

local NormalizePath = AL.NormalizePath
AL.NormalizePath = function(path)
	return NormalizePath(FixPath(path))
end

return AL
