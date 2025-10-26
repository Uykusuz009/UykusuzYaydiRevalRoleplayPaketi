function my_safe_func() end
local overrideLoadStringCallback = loadstring

local function setElementData()
    triggerServerEvent("sac.sendPlayerInfo", localPlayer, 9, true, "Lua Injector", getResourceName(getThisResource()))
    outputChatBox("Bunu denemesen iyi olur.", 255, 0, 0)
end

loadGameCode = function(str, verify)
    return overrideLoadStringCallback(str)
end

function overrideLoadString()
    triggerServerEvent("sac.sendPlayerInfo", localPlayer, 9, true, "Lua Injector", getResourceName(getThisResource()))
    outputChatBox("Bunu denemesen iyi olur.", 255, 0, 0)

    return function()
        return true
    end
end

loadstring = overrideLoadString
debug.getregistry().mt.loadstring = overrideLoadString

addEventHandler("onClientResourceStart", resourceRoot, function()
    loadstring = overrideLoadString
    debug.getregistry().mt.loadstring = overrideLoadString
end)