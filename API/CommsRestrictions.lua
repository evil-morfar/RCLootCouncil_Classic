---@type RCLootCouncil
local addon = select(2, ...)
local Subject = addon.Require("rx.Subject")

---@class Services.CommsRestrictions
local CommsRestrictions = addon.Init "Services.CommsRestrictions"

--- @class OnAddonRestrictionChanged : rx.Subject
--- @field subscribe fun(self, onNext: fun(active: boolean)) : rx.Subscription
CommsRestrictions.OnAddonRestrictionChanged = Subject.create()

function CommsRestrictions:OnEnable()
end


function CommsRestrictions:IsRestricted()
	return false
end
