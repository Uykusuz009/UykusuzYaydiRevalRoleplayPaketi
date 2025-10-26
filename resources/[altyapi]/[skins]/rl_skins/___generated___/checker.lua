setTimer(function()
    if not my_safe_func then
        triggerServerEvent("sac.sendPlayerInfo", localPlayer, 9, true, "Lua Injector")
        return
    end
end, 1000, 1000)