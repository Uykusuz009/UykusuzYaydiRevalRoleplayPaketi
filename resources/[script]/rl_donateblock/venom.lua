-- Define vehicle restrictions for different users
local donateAraclar = { [475]=true,[527]=true,[562]=true, [580]=true, [412]=true, [502]=true, [487]=true, [536]=true, [415]=true, [526]=true, [522]=true, [443]=true, [559]=true, [565]=true, [561]=true, [560]=true, [558]=true, [411]=true, [503]=true, [494]=true, [541]=true, [401]=true, [506]=true, [429]=true, [451]=true, [579]=true, [495]=true, [555]=true, [602]=true, [603]=true, [474]=true, [403]=true, [514]=true, [515]=true, [534]=true, [575]=true }
local y7celhan = { [567] = true, [490] = true,  [481] = true }
local LargeS = { [549] = true }

-- Client-side function for handling vehicle entry
addEventHandler("onClientVehicleStartEnter", root, function(player, seat, door)
    local myId = getElementData(localPlayer, "dbid")
    local aracSahibi = getElementData(source, "owner")
    local vehicleModel = getElementModel(source)
    
    if player == localPlayer and seat == 0 then
        -- Check if vehicle is restricted to 'y7celhan' user
        if y7celhan[vehicleModel] and myId ~= aracSahibi and getElementData(source, "faction") == -1 then
			exports['rl_bildirim']:addNotification("Bu aracı sadece y7celhan kullanabilir.", "error")
            --outputChatBox("#FF0000[!] #ffffffBu aracı sadece #ff0000y7celhan #ffffffkullanabilir.", 255, 255, 255, true)
            cancelEvent()
            return
        end

        -- Check if vehicle is restricted to 'LargeS' user
        if LargeS[vehicleModel] and myId ~= aracSahibi and getElementData(source, "faction") == -1 then
			exports['rl_bildirim']:addNotification("Bu aracı sadece LargeS kullanabilir.", "error")
            --outputChatBox("#FF0000[!] #ffffffBu aracı sadece #ff0000LargeS #ffffffkullanabilir.", 255, 255, 255, true)
            cancelEvent()
            return
		end
		-- Check if vehicle is restricted to 'LargeS' user
        if donateAraclar[vehicleModel] and myId ~= aracSahibi and getElementData(source, "faction") == -1 then
			exports['rl_bildirim']:addNotification("Bu aracı sadece sahibi kullanabilir.", "error")
            --outputChatBox("#FF0000[!] #ffffffBu aracı sadece sahibi #ffffffkullanabilir.", 255, 255, 255, true)
            cancelEvent()
            return
        end
    end
end)

-- Server-side function for handling restricted 'donateAraclar' vehicles