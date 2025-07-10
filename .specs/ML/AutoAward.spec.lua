require "busted.runner" ()
---@type RCLootCouncil
local addon = dofile("../.specs/ClassicAddonLoader.lua").LoadToc("../RCLootCouncil_Classic.toc")
dofile("../.specs/EmulateClassicPlayerLogin.lua")
---@type RCLootCouncil_Classic
local Classic = addon:GetModule("RCClassic")
---@type RCLootCouncilML
local MLModule = addon:GetActiveModule("masterlooter")

insulate("#Classic #MasterLooter #AutoAward", function()
	addon.isMasterLooter = true
	addon.handleLoot = true
	addon.lootMethod = "master"
	_G.IsInGroupVal = true
	_G.BACKPACK_CONTAINER = 1
	_G.GetLootThreshold = function() return 2 end
	_G.GetNumLootItems = function() return 3 end
	_G.LootSlotHasItem = function(i) return true end
	_G.GetLootSlotInfo = function(i)
		return "texture", "Footbomb Championship Ring", 1, nil, 4
	end
	_G.GetLootSourceInfo = function(i)
		return "Creature-0-1-2769-1-234567-0000000001", "CreatureName"
	end
	_G.GetLootSlotLink = function(i)
		return "|cffa335ee|Hitem:159462:5938::::::::::16:3:5010:1602:4786::::::|h[Footbomb Championship Ring]|h|r"
	end
	_G.UnitInParty = function() return true end
	_G.UnitIsConnected = function() return true end
	_G.UnitPosition = function() return 1,1,1,1 end
	
	it("should autoaward properly", function()
		local s = spy.on(_G, "GiveMasterLoot")
		addon.db.profile.autoAward = true
		addon.db.profile.autoAwardReason = 1
		addon.db.profile.autoAwardTo = {addon.player:GetName()}
		addon.db.profile.autoAwardUpperThreshold = 6
		addon:CallModule("masterlooter")
		MLModule:NewML(addon.player)
		_ADVANCE_TIME(1)
		Classic:LootOpened()
		assert.spy(s).was_called(3)
		assert.spy(s).was_called_with(1, 1)

		finally(function()
			_CancelAllTimers()
		end)
	end)
end)
