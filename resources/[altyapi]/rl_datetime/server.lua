addEventHandler("onResourceStart", resourceRoot, function()
    lastTime = getRealTime().timestamp
    dbQuery(function(qh)
        local result = dbPoll(qh, 0)
        if result and #result > 0 then
            serverCurrentTimeSec = tonumber(result[1].timesec)
        end
    end, exports.rl_mysql:getConnection(), "SELECT TO_SECONDS(NOW()) AS `timesec`")
end)

function getServerCurrentTimeSec()
    triggerClientEvent(source, "setServerCurrentTimeSec", source, now())
end
addEvent("getServerCurrentTimeSec", true)
addEventHandler("getServerCurrentTimeSec", root, getServerCurrentTimeSec)

function getNow(thePlayer, commandName)
    outputChatBox("[Server] " .. now(), thePlayer)
    dbQuery(function(qh)
        local result = dbPoll(qh, 0)
        if result and #result > 0 then
            local serverSec = tonumber(result[1].timesec)
            outputChatBox("[SQL] " .. serverSec, thePlayer)
        end
    end, exports.rl_mysql:getConnection(), "SELECT TO_SECONDS(NOW()) AS `timesec`")
end
addCommandHandler("now", getNow, false, false)