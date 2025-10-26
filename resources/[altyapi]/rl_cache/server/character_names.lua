local mysql = exports.rl_mysql
local characterNameCache = {}
local searched = {}
local refreshCacheRate = 60

function getCharacterNameFromID(id)
    if not id or not tonumber(id) then
        return false
    else
        id = tonumber(id)
    end
    
    if characterNameCache[id] then
        return characterNameCache[id]
    end
    
    for _, player in pairs(getElementsByType("player")) do
        if id == getElementData(player, "dbid") then
            characterNameCache[id] = getPlayerName(player)
            return characterNameCache[id]
        end
    end
    
    if searched[id] then
        return false
    end
    searched[id] = true

    dbQuery(function(qh)
        local result = dbPoll(qh, 0)
        if result and #result > 0 and result[1].name then
            local characterName = string.gsub(result[1].name, "_", " ")
            characterNameCache[id] = characterName
            for _, player in pairs(getElementsByType("player")) do
                triggerClientEvent(player, "retrieveCharacterNameCacheFromServer", resourceRoot, characterName, id)
            end
        end
        searched[id] = nil
    end, mysql:getConnection(), "SELECT `name` FROM `characters` WHERE `id` = ? LIMIT 1", id)

    return false
end

function requestCharacterNameCacheFromServer(id)
    local found = getCharacterNameFromID(id)
    if found then
        triggerClientEvent(client, "retrieveCharacterNameCacheFromServer", client, found, id)
    end
end
addEvent("requestCharacterNameCacheFromServer", true)
addEventHandler("requestCharacterNameCacheFromServer", root, requestCharacterNameCacheFromServer)