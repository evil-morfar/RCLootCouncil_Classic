---@type RCLootCouncil
local addon = select(2, ...)
local GroupLoot = addon.Require "Utils.GroupLoot"

-- Use original for Group Loot
local targetStatusMLGL = GroupLoot:GetTargetedMLStatus()
local targetStatusGL   = GroupLoot:GetTargetedStatus()
-- For Master Loot we ignore mldb.autoGroupLoot & guildGroup
local targetStatusML   = tonumber("100111101", 2)
local targetStatus     = tonumber("100101101", 2)

-- BCC
GroupLoot.IgnoreList[30183] = true -- Nether Vortex
GroupLoot.IgnoreList[22726] = true -- Splinter of Atiesh

function GroupLoot:GetTargetedStatus()
	local lootMethod = addon:GetLootMethod()
	return lootMethod == Enum.LootMethod.Group and targetStatusGL or targetStatus
end

function GroupLoot:GetTargetedMLStatus()
	local lootMethod = addon:GetLootMethod()
	return lootMethod == Enum.LootMethod.Group and targetStatusMLGL or targetStatusML
end