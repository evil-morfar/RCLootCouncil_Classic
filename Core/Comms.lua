--- Comms.lua Overrides RCLootCouncil comms to (de)compress all sent/received messages.
-- Temporary fix for new throttle limits implemented in Classic until RCLootCouncil v3.0 is complete.
local _, addon = ...
local Classic = addon:GetModule("RCClassic")
local LD = LibStub("LibDeflate")

-- Reimplemented with compression
function addon:SendCommand (target, command, ...)
	-- send all data as a table, and let receiver unpack it
	local serialized = self:Serialize(command, {...})
   local compressed = LD:CompressDeflate(serialized)
   local toSend = LD:EncodeForWoWAddonChannel(compressed)

   if target == "group" then
		if IsInRaid() then -- Raid
			self:SendCommMessage("RCLootCouncil", toSend, self.Utils:IsInNonInstance() and "INSTANCE_CHAT" or "RAID")
		elseif IsInGroup() then -- Party
			self:SendCommMessage("RCLootCouncil", toSend, self.Utils:IsInNonInstance() and "INSTANCE_CHAT" or "PARTY")
		else--if self.testMode then -- Alone (testing)
			self:SendCommMessage("RCLootCouncil", toSend, "WHISPER", self.playerName)
		end

	elseif target == "guild" then
		self:SendCommMessage("RCLootCouncil", toSend, "GUILD")

	else
		if self:UnitIsUnit(target,"player") then -- If target == "player"
			self:SendCommMessage("RCLootCouncil", toSend, "WHISPER", self.playerName)
		else
			-- We cannot send "WHISPER" to a crossrealm player
			if target:find("-") then
				if target:find(self.realmName) then -- Our own realm, just send it
					self:SendCommMessage("RCLootCouncil", toSend, "WHISPER", target)
				else -- Get creative
					-- Remake command to be "xrealm" and put target and command in the table
					-- See "RCLootCouncil:HandleXRealmComms()" for more info
					toSend = self:Serialize("xrealm", {target, command, ...})
					if GetNumGroupMembers() > 0 then -- We're in a group
						self:SendCommMessage("RCLootCouncil", toSend, self.Utils:IsInNonInstance() and "INSTANCE_CHAT" or "RAID")
					else -- We're not, probably a guild verTest
						self:SendCommMessage("RCLootCouncil", toSend, "GUILD")
					end
				end

			else -- Should also be our own realm
				self:SendCommMessage("RCLootCouncil", toSend, "WHISPER", target)
			end
		end
	end
end

-- Takes `serializedMsg`, so just compress and encode it.
function addon:SendCommandModified (prefix, serializedMsg, channel, target, prio, ...)
	local compressed = LD:CompressDeflate(serializedMsg)
   local toSend = LD:EncodeForWoWAddonChannel(compressed)
	self:SendCommMessage(prefix, toSend, channel, target, prio, ...)
end

local function decompressor (data)
   local decoded = LD:DecodeForWoWAddonChannel(data)
   if not decoded then return data end -- Assume it's a pre 0.10 message.
   local serializedMsg = LD:DecompressDeflate(decoded)
   return serializedMsg or ""
end

local function OnCommReceived (self, origHandler, prefix, compressedMessage, distri, sender)
   local serializedMsg = decompressor(compressedMessage)
   origHandler(self, prefix, serializedMsg, distri, sender)
end

function Classic:DoCommsCompressFix ()
   addon:Debug("DoCommsCompressFix")
   local origHandlers = {
      core = {
         handler = addon.OnCommReceived,
         obj = addon
      }
   }
   -- Fetch all modules' handlers
   for name, module in addon:IterateModules() do
      if module.OnCommReceived and type(module.OnCommReceived) == "function" then
         origHandlers[name] = {
            handler = module.OnCommReceived,
            obj = module
         }
      end
   end
   -- Push them through the decompressor:
   for _, data in pairs(origHandlers) do
      data.obj.OnCommReceived = function(self, prefix, compressedMessage, distri, sender)
         OnCommReceived(self, data.handler, prefix, compressedMessage, distri, sender)
      end
   end
end
