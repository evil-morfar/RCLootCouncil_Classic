--- Sets up specific Classic data that's missing or otherwise different from retail.
--- Should be included in all test files.
require "wow_api"
require "wow_item_api"
--- WoW API

LE_ITEM_CLASS_ARMOR = Enum.ItemClass.Armor
LE_ITEM_ARMOR_CLOTH = Enum.ItemArmorSubclass.Cloth
LE_ITEM_ARMOR_LEATHER = Enum.ItemArmorSubclass.Leather
LE_ITEM_ARMOR_MAIL = Enum.ItemArmorSubclass.Mail
LE_ITEM_ARMOR_PLATE = Enum.ItemArmorSubclass.Plate
LE_ITEM_ARMOR_SHIELD = Enum.ItemArmorSubclass.Shield
LE_ITEM_ARMOR_LIBRAM = Enum.ItemArmorSubclass.Libram
LE_ITEM_ARMOR_IDOL = Enum.ItemArmorSubclass.Idol
LE_ITEM_ARMOR_TOTEM = Enum.ItemArmorSubclass.Totem
LE_ITEM_ARMOR_SIGIL = Enum.ItemArmorSubclass.Sigil

LE_ITEM_CLASS_WEAPON = Enum.ItemClass.Weapon
LE_ITEM_WEAPON_AXE1H = Enum.ItemWeaponSubclass.Axe1H
LE_ITEM_WEAPON_AXE2H = Enum.ItemWeaponSubclass.Axe2H
LE_ITEM_WEAPON_BOWS = Enum.ItemWeaponSubclass.Bows
LE_ITEM_WEAPON_CROSSBOW = Enum.ItemWeaponSubclass.Crossbow
LE_ITEM_WEAPON_DAGGER = Enum.ItemWeaponSubclass.Dagger
LE_ITEM_WEAPON_GUNS = Enum.ItemWeaponSubclass.Guns
LE_ITEM_WEAPON_MACE1H = Enum.ItemWeaponSubclass.Mace1H
LE_ITEM_WEAPON_MACE2H = Enum.ItemWeaponSubclass.Mace2H
LE_ITEM_WEAPON_POLEARM = Enum.ItemWeaponSubclass.Polearm
LE_ITEM_WEAPON_SWORD1H = Enum.ItemWeaponSubclass.Sword1H
LE_ITEM_WEAPON_SWORD2H = Enum.ItemWeaponSubclass.Sword2H
LE_ITEM_WEAPON_STAFF = Enum.ItemWeaponSubclass.Staff
LE_ITEM_WEAPON_WAND = Enum.ItemWeaponSubclass.Wand
LE_ITEM_WEAPON_WARGLAIVE = Enum.ItemWeaponSubclass.Warglaive
LE_ITEM_WEAPON_UNARMED = Enum.ItemWeaponSubclass.Unarmed
LE_ITEM_WEAPON_THROWN = Enum.ItemWeaponSubclass.Thrown

GetItemStats = C_Item.GetItemStats
GetMasterLootCandidate = function() return "Player1-Realm1" end
GiveMasterLoot = function(slot, i) end
