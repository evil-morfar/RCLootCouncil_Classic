local _, addon = ...

local Classic = addon:GetModule("RCClassic")
local hooks = {}

function Classic:DoHooks ()
   for ref, data in pairs(hooks) do
      Classic:RawHook(data.object, ref, data.func)
   end
end

hooks = {
   GetInstalledModulesFormattedData = {
      object = addon,
      func = function()
         local modules = Classic.hooks[addon].GetInstalledModulesFormattedData(addon)
         -- Insert core RCLootCouncil version
         local coreVersion = "RCLootCouncil Core - "..Classic.RCLootCouncil.version
         if Classic.RCLootCouncil.tVersion then
            coreVersion = coreVersion .. "-" .. Classic.RCLootCouncil.tVersion
         end
         tinsert(modules, coreVersion)
         return modules
      end,
   }
}
