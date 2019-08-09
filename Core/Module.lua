local _, addon = ...

local ClassicModule = addon:NewModule("RCClassic", "AceHook-3.0")

function ClassicModule:OnInitialize()
   self.version = GetAddOnMetadata("RCLootCouncil_Classic", "Version")
   self.tVersion = "alpha.1"
   self.debug = true
   self.nnp = false

   -- Store RCLootCouncil Variables
   self.RCLootCouncil = {}
   self.RCLootCouncil.version = addon.version
   self.RCLootCouncil.tVersion = addon.tVersion
   addon.version =  self.version
   addon.tVersion = self.tVersion
   addon.debug = self.debug
   addon.nnp = self.nnp

   self:Enable()
end

function ClassicModule:OnEnable ()
   addon:DebugLog("ClassicModule enabled", self.version, self.tVersion)

   addon.db.global.Classic_oldVersion = addon.db.global.Classic_oldVersion
	addon.db.global.Classic_version = self.version

   self:DoHooks()
end
