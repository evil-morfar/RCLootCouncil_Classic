--- autopass.lua	Contains everything related to autopassing in Classic
-- @author	Potdisc
-- Create Date : 6/9/2019
---@type RCLootCouncil
local addon = select(2, ...)
local Classic = addon:GetModule("RCClassic")
local AutoPass = addon.AutoPass

if Classic:IsPreWrath() then
	-- Druids pass on polearms in Classic, but not WotLK (or SoD)
	if Classic:IsSeasonOfDiscovery() then
		AutoPass.autopassTable[Enum.ItemClass.Weapon][Enum.ItemWeaponSubclass.Polearm] = { "ROGUE", "SHAMAN", "PRIEST",
			"MAGE",
			"WARLOCK", }
	else
		AutoPass.autopassTable[Enum.ItemClass.Weapon][Enum.ItemWeaponSubclass.Polearm] = { "ROGUE", "SHAMAN", "PRIEST",
			"MAGE",
			"WARLOCK", "DRUID", }
	end
	-- From Cataclysm, all classes use their main gear type, which still may not be true in vanilla
	AutoPass.autopassTable[Enum.ItemClass.Armor][Enum.ItemArmorSubclass.Cloth]      = {}
	AutoPass.autopassTable[Enum.ItemClass.Armor][Enum.ItemArmorSubclass.Leather]    = { "PRIEST", "MAGE", "WARLOCK", }
	AutoPass.autopassTable[Enum.ItemClass.Armor][Enum.ItemArmorSubclass.Mail]       = { "DRUID", "ROGUE", "PRIEST",
		"MAGE", "WARLOCK", }
	AutoPass.autopassTable[Enum.ItemClass.Armor][Enum.ItemArmorSubclass.Plate]      = { "DRUID", "ROGUE", "HUNTER",
		"SHAMAN",
		"PRIEST", "MAGE", "WARLOCK", }
	AutoPass.autopassTable[Enum.ItemClass.Armor][Enum.ItemArmorSubclass.Shield]     = { "DRUID", "ROGUE", "HUNTER",
		"PRIEST", "MAGE",
		"WARLOCK", }
	AutoPass.autopassTable[Enum.ItemClass.Weapon][Enum.ItemWeaponSubclass.Guns]     = { "DEATHKNIGHT", "PALADIN", "DRUID",
		"MONK", "SHAMAN", "PRIEST", "MAGE", "WARLOCK", }
	AutoPass.autopassTable[Enum.ItemClass.Weapon][Enum.ItemWeaponSubclass.Bows]     = { "DEATHKNIGHT", "PALADIN", "DRUID",
		"MONK", "SHAMAN", "PRIEST", "MAGE", "WARLOCK", }
	AutoPass.autopassTable[Enum.ItemClass.Weapon][Enum.ItemWeaponSubclass.Crossbow] = { "DEATHKNIGHT", "PALADIN", "DRUID",
		"MONK", "SHAMAN", "PRIEST", "MAGE", "WARLOCK", }
end

addon:RawHook(AutoPass, "AutoPassCheck",
	--- See [Original](lua://RCLootCouncil.AutoPass.AutoPassCheck)
	function(_,link, equipLoc, typeID, subTypeID, classesFlag, class)
		local db = addon:Getdb()
		-- If player has enabled `db.autoPassSlot[equipLoc]` we should auto pass
		if db.autoPassSlot[equipLoc] then return true end

		-- Use special "Classic" autopass that only autopasses items your class cannot use (Vanilla/TBC)
		if db.classicAutoPass then
			local typeName = C_Item.GetItemSubClassInfo(typeID, subTypeID)
			if not C_Item.IsEquippedItemType(typeName) then
				return true
			end
		end

		return addon.hooks[AutoPass].AutoPassCheck(AutoPass, link, equipLoc, typeID, subTypeID, classesFlag, class)
	end)
