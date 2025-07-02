local _, addon = ...
local VC = addon:GetModule("VersionCheck")

VC.statusString = VC.statusString .. " (group loot only)"
