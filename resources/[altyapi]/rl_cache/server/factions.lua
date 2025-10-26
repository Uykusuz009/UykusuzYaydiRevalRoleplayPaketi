local mysql = exports.rl_mysql
local factionNameCache = {}
local searched = {}
local refreshCacheRate = 60

function getFactionNameFromId(id)
    if not id or not tonumber(id) then
        return false
    else
        id = tonumber(id)
    end
    
    if factionNameCache[id] then
        return factionNameCache[id]
    end
    
    local faction = exports.rl_faction:getTeamFromFactionID(id)
    if faction then
        factionNameCache[id] = getTeamName(faction)
        return factionNameCache[id]
    end
    
    if searched[id] then
        return false
    end
    searched[id] = true

    dbQuery(function(qh)
        local result = dbPoll(qh, 0)
        if result and #result > 0 and result[1].name then
            local factionName = result[1].name
            factionNameCache[id] = factionName
            for _, player in pairs(getElementsByType("player")) do
                triggerClientEvent(player, "retrieveFactionNameCacheFromServer", resourceRoot, factionName, id)
            end
        end
        searched[id] = nil
    end, mysql:getConnection(), "SELECT `name` FROM `factions` WHERE `id` = ? LIMIT 1", id)

    return false
end

function requestFactionNameCacheFromServer(id)
    local found = getFactionNameFromId(id)
    if found then
        triggerClientEvent(client, "retrieveFactionNameCacheFromServer", client, found, id)
    end
end
addEvent("requestFactionNameCacheFromServer", true)
addEventHandler("requestFactionNameCacheFromServer", root, requestFactionNameCacheFromServer)