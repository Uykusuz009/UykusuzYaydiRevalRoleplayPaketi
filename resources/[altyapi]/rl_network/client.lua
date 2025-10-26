local networkStatus = false

setTimer(function()
    local network = getNetworkStats()
    local breaked = false

    if network["packetlossTotal"] > 10 then
        if not networkStatus then
            outputConsole("[Network] Switched off due to packetloss!")
            networkStatus = true
            lastBreakedTick = getTickCount()
            return
        end
        breaked = true
    end

    if network["packetlossLastSecond"] >= 50 then
        if not networkStatus then
            outputConsole("[Network] Switched off due to packetloss!")
            networkStatus = true
            lastBreakedTick = getTickCount()
            return
        end
        breaked = true
    end

    if network["messagesInResendBuffer"] >= 10 then
        if not networkStatus then
            outputConsole("[Network] Switched off due to messagesInResendBuffer!")
            networkStatus = true
            lastBreakedTick = getTickCount()
            return
        end
        breaked = true
    end

    if network["isLimitedByCongestionControl"] > 0 then
        if not networkStatus then
            outputConsole("[Network] Switched off due to isLimitedByCongestionControl!")
            networkStatus = true
            lastBreakedTick = getTickCount()
            return
        end
        breaked = true
    end
	
    if getPlayerPing(localPlayer) > 500 then
        if not networkStatus then
            outputConsole("[Network] Switched off due to ping!")
            networkStatus = true
            lastBreakedTick = getTickCount()
            return
        end
        breaked = true
    end

    if networkStatus and not breaked then
        if lastBreakedTick + 3000 <= getTickCount() then
            outputConsole("[Network] Switched on!")
            networkStatus = false
            return
        end
    end
end, 500, 0)

function getNetworkStatus()
    return networkStatus
end