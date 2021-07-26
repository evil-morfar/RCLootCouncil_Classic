require "busted.runner" {}

insulate("AddonLoader", function()
    it("should load RCLootCouncil_Classic", function()
        local s = spy.on(_G, "_errorhandler")
        loadfile("./RCLootCouncil/.specs/AddonLoader.lua")().LoadToc(
            "RCLootCouncil_Classic.toc")
        assert.truthy(_G.RCLootCouncil)
        WoWAPI_FireEvent("ADDON_LOADED", "RCLootCouncil")
        _G.IsLoggedIn = function() return true end
        WoWAPI_FireEvent("PLAYER_LOGIN", "RCLootCouncil")
        _G.RCLootCouncil.modules.RCClassic:Enable()
        assert.spy(s).was_not.called()
    end)
end)