--- autopass.lua	Contains everything related to autopassing in Classic
-- @author	Potdisc
-- Create Date : 6/9/2019
local _,addon = ...
local Classic = addon:GetModule("RCClassic")
local AutoPass = addon.AutoPass

if Classic:IsClassicEra() then
	-- Druids pass on polearms in Classic, but not WotLK (or SoD)
	if Classic:IsSeasonOfDiscovery() then
		AutoPass.autopassTable[Enum.ItemClass.Weapon][Enum.ItemWeaponSubclass.Polearm] = { "ROGUE", "SHAMAN", "PRIEST", "MAGE",
			"WARLOCK", }
	else
		AutoPass.autopassTable[Enum.ItemClass.Weapon][Enum.ItemWeaponSubclass.Polearm] = { "ROGUE", "SHAMAN", "PRIEST",
		"MAGE",
			"WARLOCK", "DRUID", }
	end
	-- From Cataclysm, all classes use their main gear type, which still may not be true in vanilla
	AutoPass.autopassTable[Enum.ItemClass.Armor][Enum.ItemArmorSubclass.Cloth]  = {}
	AutoPass.autopassTable[Enum.ItemClass.Armor][Enum.ItemArmorSubclass.Leather] = { "PRIEST", "MAGE", "WARLOCK", }
	AutoPass.autopassTable[Enum.ItemClass.Armor][Enum.ItemArmorSubclass.Mail]    = { "DRUID", "ROGUE", "PRIEST", "MAGE", "WARLOCK", }
	AutoPass.autopassTable[Enum.ItemClass.Armor][Enum.ItemArmorSubclass.Plate]   = { "DRUID", "ROGUE", "HUNTER", "SHAMAN",
		"PRIEST", "MAGE", "WARLOCK", }
	AutoPass.autopassTable[Enum.ItemClass.Armor][Enum.ItemArmorSubclass.Shield]  = { "DRUID", "ROGUE", "HUNTER", "PRIEST", "MAGE",
		"WARLOCK", }
	AutoPass.autopassTable[Enum.ItemClass.Weapon][Enum.ItemWeaponSubclass.Guns] = { "DEATHKNIGHT", "PALADIN", "DRUID", "MONK", "SHAMAN", "PRIEST",	"MAGE", "WARLOCK", }
	AutoPass.autopassTable[Enum.ItemClass.Weapon][Enum.ItemWeaponSubclass.Bows] = { "DEATHKNIGHT", "PALADIN", "DRUID", "MONK", "SHAMAN", "PRIEST",	"MAGE", "WARLOCK", }
	AutoPass.autopassTable[Enum.ItemClass.Weapon][Enum.ItemWeaponSubclass.Crossbow] = { "DEATHKNIGHT", "PALADIN", "DRUID", "MONK", "SHAMAN", "PRIEST",	"MAGE", "WARLOCK", }
end

addon:RawHook(AutoPass, "AutoPassCheck",
--- See [Original](lua://RCLootCouncil.AutoPass.AutoPassCheck)
function (link, equipLoc, typeID, subTypeID, classesFlag, class)
	-- If player has enabled `db.autoPassSlot[equipLoc]` we should auto pass
	if addon:Getdb().autoPassSlot[equipLoc] then return true end
	return addon.hooks[AutoPass].AutoPassCheck(link, equipLoc, typeID, subTypeID, classesFlag, class)
end)
