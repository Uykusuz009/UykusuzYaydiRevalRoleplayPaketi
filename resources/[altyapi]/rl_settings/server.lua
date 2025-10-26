local playerSettings = {}

addEvent("settings.sync", true)
addEventHandler("settings.sync", resourceRoot, function(clientSettings, initialSync)
    local player = client
    playerSettings[player] = clientSettings

    if initialSync then
        for _, otherPlayer in ipairs(getElementsByType("player")) do
            if otherPlayer ~= player then
                triggerClientEvent(otherPlayer, "settings.sync", resourceRoot, player, clientSettings)
            end
        end
    end
end)

addEvent("settings.wantSync", true)
addEventHandler("settings.wantSync", resourceRoot, function(entity)
    local player = client
    if playerSettings[entity] then
        triggerClientEvent(player, "settings.sync", resourceRoot, entity, playerSettings[entity])
    end
end)

addEvent("settings.patch", true)
addEventHandler("settings.patch", resourceRoot, function(key, value)
    local player = client
    if not playerSettings[player] then
        playerSettings[player] = {}
    end
    playerSettings[player][key] = value

    for _, otherPlayer in ipairs(getElementsByType("player")) do
        if otherPlayer ~= player then
            triggerClientEvent(otherPlayer, "settings.patch", resourceRoot, player, key, value)
        end
    end
end)

addEventHandler("onPlayerQuit", root, function()
    playerSettings[source] = nil
end)

addEventHandler("onResourceStart", resourceRoot, function()
    for _, player in ipairs(getElementsByType("player")) do
        playerSettings[player] = {}
    end
end)

function getPlayerSetting(player, key)
    if playerSettings[player] and playerSettings[player][key] ~= nil then
        return playerSettings[player][key]
    end
	return nil
end

function setPlayerSetting(player, key, value)
    if not playerSettings[player] then
        playerSettings[player] = {}
    end
    playerSettings[player][key] = value
    triggerClientEvent(player, "settings.patch", resourceRoot, key, value, false)
end

function getPlayerSettings(player)
    return playerSettings[player] or {}
end

function setPlayerSettings(player, settings)
    playerSettings[player] = settings
    triggerClientEvent(player, "settings.sync", resourceRoot, player, settings)
end

function getAllPlayersSettings()
    return playerSettings
end