-- Certain functions changes aren't retrospectively added to vanilla.
-- This file takes care of that.

if not C_Container then
    C_Container = {
        GetContainerNumSlots = GetContainerNumSlots,
        GetContainerItemLink = GetContainerItemLink,
        GetContainerNumFreeSlots = GetContainerNumFreeSlots,
        GetContainerItemInfo = GetContainerItemInfo,
        PickupContainerItem = PickupContainerItem
    }
end
