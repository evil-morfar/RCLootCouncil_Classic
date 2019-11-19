--- Fixed for retail RCLootCouncilML functions that doesn't function properly in Classic or otherwise needs editing
local _, addon = ...
local MLModule = addon:GetModule("RCLootCouncilML")

function MLModule:HandleReceivedTradeable ()
   -- Do nothing
end

function MLModule:HandleNonTradeable ()
   -- Do nothing
end
