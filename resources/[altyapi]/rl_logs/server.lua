function addLog(logType, message)
    if logType and message then
        local time = getRealTime()
        local timestamp = string.format("%04d-%02d-%02d %02d:%02d:%02d", time.year + 1900, time.month + 1, time.monthday, time.hour, time.minute, time.second)
        dbExec(exports.rl_mysql:getConnection(), "INSERT INTO logs (log_type, message, timestamp) VALUES (?, ?, ?)", logType, message, timestamp)
    end
end

addEvent("logs.fetchLogs", true)
addEventHandler("logs.fetchLogs", root, function(page, pageSize, logType)
    if client ~= source then
        exports.rl_ac:banForEventAbuse(client, eventName)
		return
	end
	
	if not exports.rl_integration:isPlayerManager(client) then
		return
	end
	
	local startIndex = (page - 1) * pageSize
    local query = "SELECT * FROM logs"
    local params = {}
    
    if logType then
        query = query .. " WHERE log_type = ?"
        table.insert(params, logType)
    end
    
    query = query .. " ORDER BY timestamp DESC LIMIT ? OFFSET ?"
    table.insert(params, pageSize)
    table.insert(params, startIndex)
    
    dbQuery(function(queryHandle, client)
        local result = dbPoll(queryHandle, -1)
        if result then
            triggerClientEvent(client, "logs.receiveLogs", client, result)
        else
            triggerClientEvent(client, "logs.receiveLogs", client, {})
        end
    end, {client}, exports.rl_mysql:getConnection(), query, unpack(params))
end)

addEvent("logs.fetchLogTypes", true)
addEventHandler("logs.fetchLogTypes", root, function()
    if client ~= source then
        exports.rl_ac:banForEventAbuse(client, eventName)
		return
	end
	
	if not exports.rl_integration:isPlayerManager(client) then
		return
	end
	
	dbQuery(function(queryHandle, client)
        local result = dbPoll(queryHandle, -1)
        
        local logTypes = {}
        if result then
            for _, row in ipairs(result) do
                table.insert(logTypes, row.log_type)
            end
        end
        
        triggerClientEvent(client, "logs.receiveLogTypes", client, logTypes)
    end, {client}, exports.rl_mysql:getConnection(), "SELECT DISTINCT log_type FROM logs")
end)