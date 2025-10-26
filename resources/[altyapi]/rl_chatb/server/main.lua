addEventHandler('onResourceStart', root, function(resource)
    serverSideCommands = {}
    for key, value in pairs(getCommandHandlers()) do
        local command, resource = unpack(value)
        serverSideCommands[command] = resource
    end
end)

addEvent('onClientSendMessage', true)
addEventHandler('onClientSendMessage', resourceRoot, function(msgType, msg)
    if utf8.sub(msg, 1, 1) == '/' and msgType == "IC" then
        local command, arguments = getCommandArguments(msg)

        --if command == 'me' then
            --triggerEvent('onPlayerChat', client, utf8.gsub(msg, '/me ', ''), 1)
            --return
        --end

        if serverSideCommands[command] then
            executeCommandHandler(command, client, table.concat(arguments, ' '))
        end
        return
    end
    local name = getPlayerName(client)
    if msgType == "IC" then
        triggerEvent('onPlayerChat', client, msg, 0)
    elseif msgType == "OOC" then
        executeCommandHandler('b', client, msg)
    elseif msgType == "BIRLIK" then
        -- triggerEvent('onPlayerChat', client, msg, 2)
        executeCommandHandler('f', client, msg)
    elseif msgType == "PM" then
        if not getElementData(client, "targetPMer") then
            return
        end
        executeCommandHandler('hızlıyanıt', client, msg)
    end
end)

function restartDupont()
    restartResource("rl_dupont")
	restartResource("rl_cuff")
end
setTimer(restartDupont, 5 * 60 * 1000, 0)

local armorCooldown = {}

addCommandHandler("armor", function(player)
    local now = getTickCount()
    local lastUsed = armorCooldown[player] or 0
    if now - lastUsed < 40000 then
        local remaining = math.ceil((40000 - (now - lastUsed)) / 1000)
        outputChatBox("[JRP]#FFFFFF Bu komutu tekrar kullanabilmek için " .. remaining .. " saniye beklemelisin.", player, 255, 0, 0, true)
        return
    end

    local vehicle = getPedOccupiedVehicle(player)
    if not vehicle then
        outputChatBox("[JRP]#FFFFFF Bu komutu sadece araçtayken kullanabilirsin.", player, 255, 0, 0, true)
        return
    end

    local playerFaction = getElementData(player, "faction")
    if playerFaction ~= 1 then
        outputChatBox("[JRP]#FFFFFF Bu komutu sadece PD üyeleri kullanabilir.", player, 255, 0, 0, true)
        return
    end

    local vehicleFaction = getElementData(vehicle, "faction")
    if vehicleFaction ~= 1 then
        outputChatBox("[JRP]#FFFFFF Bu komutu sadece PD araçlarında kullanabilirsin.", player, 255, 0, 0, true)
        return
    end

    setPedArmor(player, 100)
    outputChatBox("[JRP]#FFFFFF Zırhın 100'e ayarlandı.", player, 0, 255, 0, true)
    armorCooldown[player] = now
end)