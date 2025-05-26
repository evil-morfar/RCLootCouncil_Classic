-- require "busted.runner" ()
local Loader = dofile("../.specs/ClassicAddonLoader.lua")
local lfs = require "lfs"
insulate("RCLootCouncil_Classic", function()
	
	it("can perform login phase", function()
		local s = spy.on(_G, "_errorhandler")
		-- stub(_G, "UnitGUID", function(unit)
		-- 	return "Player-1-00000002"
		-- end)

		print(lfs.currentdir())

		-- dofile("RCLootCouncil/.specs/AddonLoader.lua").LoadToc("RCLootCouncil_Classic.toc")
		Loader.LoadToc("../RCLootCouncil_Classic.toc")
		dofile("../.specs/EmulatePlayerLogin.lua")
		assert.spy(s).was_not.called()
	end)
end)


insulate("RCLootCouncil_Classic", function ()
	it("can load Classic addon", function()
		assert.has_no_error(function()
			Loader.LoadToc("RCLootCouncil_Classic.toc")
		end)
	end)
end)