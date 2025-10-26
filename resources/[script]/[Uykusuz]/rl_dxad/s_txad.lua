addEvent("teleportToPlayer", true)
addEventHandler("teleportToPlayer", root, function(targetPlayer)
    local adminLevel = getElementData(client, "admin_level") or 0
    
    if adminLevel <= 0 then
        outputChatBox("[!]#FFFFFF Bu menüyü kullanmak için admin olmalısınız.", client, 255, 0, 0, true)
        return
    end
    
    if client and targetPlayer then
        local x, y, z = getElementPosition(targetPlayer)
        setElementPosition(client, x + 3, y, z)
        outputChatBox("[!] #FFFFFFBaşarıyla " .. getPlayerName(targetPlayer) .. " adlı oyuncunun yanına ışınlandınız!", client, 0, 255, 0, true)
        outputChatBox("[!] #FFFFFF" .. getPlayerName(client) .. " adlı oyuncu yanınıza ışınlandı!", targetPlayer, 0, 255, 0, true)
        saveLog("gotos", getPlayerName(client), getPlayerName(targetPlayer), "Goto işlemi gerçekleştirildi")
    end
end)
local function hasAdminPermission(player)
    return exports.rl_integration:isPlayerLeaderAdmin(player) or exports.rl_integration:isPlayerDeveloper(player) or exports.rl_integration:isPlayerServerOwner(player)
end
local txadLogs = {
    bans = {},
    kicks = {},
    gotos = {},
    aheals = {},
    getheres = {},
    sehre = {},
    watch = {},
}
function saveLog(logType, admin, target, reason, value)
    local logEntry = {
        admin = admin,
        target = target,
        reason = reason or "",
        value = value or 0,
        time = getRealTime().timestamp
    }
    if not txadLogs[logType] then
        txadLogs[logType] = {}
    end
    table.insert(txadLogs[logType], 1, logEntry)
    if #txadLogs[logType] > 100 then
        table.remove(txadLogs[logType])
    end
    local connection = exports.rl_mysql:getConnection()
    if connection then
        dbExec(connection, 
            "INSERT INTO dxlog (action_type, admin, target, reason, value) VALUES (?, ?, ?, ?, ?)",
            logType,
            admin,
            target,
            reason or "",
            value or 0
        )
    end
end
addEvent("requestTxadLogs", true)
addEventHandler("requestTxadLogs", root, function(logType)
    if hasAdminPermission(client) then
        triggerClientEvent(client, "receiveTxadLogs", client, txadLogs[logType])
    end
end)
addEvent("banPlayer", true)
addEventHandler("banPlayer", root, function(targetPlayer, reason, duration)
    if not client or not hasObjectPermissionTo(client, "function.banPlayer") then return end
    local adminLevel = getElementData(client, "admin_level") or 0
    if adminLevel < 1 then return end
    if not isElement(targetPlayer) then return end
    local adminName = getPlayerName(client)
    local targetName = getPlayerName(targetPlayer)
    local banDuration = (duration == 0) and 0 or (duration * 3600)
    banPlayer(targetPlayer, false, false, true, client, reason, banDuration)
    local banMessage
    if duration == 0 then
        banMessage = string.format("#FF0000[BAN]#FFFFFF %s adlı oyuncu %s tarafından sınırsız banlandı. Sebep: %s", 
            targetName, adminName, reason)
    else
        local hours = duration
        local days = math.floor(hours / 24)
        local remainingHours = hours % 24
        
        local timeText = ""
        if days > 0 then
            timeText = days .. " gün"
            if remainingHours > 0 then
                timeText = timeText .. " " .. remainingHours .. " saat"
            end
        else
            timeText = hours .. " saat"
        end
        
        banMessage = string.format("#FF0000[BAN]#FFFFFF %s adlı oyuncu %s tarafından %s banlandı. Sebep: %s", 
            targetName, adminName, timeText, reason)
    end
    outputChatBox(banMessage, root, 255, 255, 255, true)
    local logReason = string.format("Süre: %s     |       Sebep: %s ", 
        duration == 0 and "Sınırsız" or (duration .. " saat"), 
        reason)
    
    saveLog("bans", 
        adminName,           
        targetName,         
        logReason,         
        duration          
    )
end)

addEvent("kickPlayer", true)
addEventHandler("kickPlayer", root, function(targetPlayer, reason)
    if not hasAdminPermission(client) then
        outputChatBox("[!]#FFFFFF Bu menüyü kullanmak için admin olmalısınız.", client, 255, 0, 0, true)
        return
    end
    if not client or not isElement(targetPlayer) or not reason then return end

    local targetName = getPlayerName(targetPlayer)
    local adminName = getPlayerName(client)
    local formattedReason = "[DX Admin] " .. reason
    kickPlayer(targetPlayer, client, formattedReason)

    outputChatBox("[!] #FFFFFF" .. targetName .. " adlı oyuncu " .. adminName .. " tarafından kicklendi.", root, 255, 165, 0, true)
    outputChatBox("[!] #FFFFFFSebep: " .. formattedReason, root, 255, 165, 0, true)
    outputServerLog(adminName .. " kicked " .. targetName .. " (Reason: " .. formattedReason .. ")")
    saveLog("kicks", getPlayerName(client), getPlayerName(targetPlayer), "[TX Admin] " .. reason, 0)
end)
addEventHandler("onResourceStart", resourceRoot, function()
    local connection = exports.rl_mysql:getConnection()
    if connection then
        dbExec(connection, [[
            CREATE TABLE IF NOT EXISTS dxlog (
                id INT AUTO_INCREMENT PRIMARY KEY,
                action_type VARCHAR(50),
                admin VARCHAR(50),
                target VARCHAR(50),
                reason TEXT,
                value INT,
                timestamp DATETIME DEFAULT CURRENT_TIMESTAMP
            )
        ]])
    end
end)
addEvent("getDxLogs", true)
addEventHandler("getDxLogs", root, function(logType)
    if exports.rl_integration:isPlayerServerOwner(client) or exports.rl_integration:isPlayerDeveloper(client) then
        local connection = exports.rl_mysql:getConnection()
        if connection then
            local query
            if logType == "watch" then
                query = "SELECT * FROM dxlog WHERE action_type = 'watch' ORDER BY timestamp DESC"
            elseif logType == "aheals" then
                query = "SELECT * FROM dxlog WHERE action_type = 'aheals' ORDER BY timestamp DESC"
            else
                query = "SELECT * FROM dxlog WHERE action_type = ? ORDER BY timestamp DESC"
            end
            
            dbQuery(function(qh)
                local result = dbPoll(qh, 0)
                if result then
                    triggerClientEvent("receiveDxLogs", root, result)
                end
            end, connection, query, logType ~= "watch" and logType or nil)
        end
    end
end)

addEvent("ahealPlayer", true)
addEventHandler("ahealPlayer", root, function(targetPlayer, adminName, targetName)
    if client and hasObjectPermissionTo(client, "function.kickPlayer") then
        setElementHealth(targetPlayer, 100)
        setElementData(targetPlayer, "hunger", 100)
        setElementData(targetPlayer, "thirst", 100)
        outputChatBox("[!]#FFFFFF " .. getPlayerName(targetPlayer) .. " isimli oyuncunun canını fullediniz.", client, 0, 255, 0, true)
        outputChatBox("[!]#FFFFFF " .. getPlayerName(client) .. " isimli yetkili canınızı fulledi.", targetPlayer, 0, 255, 0, true)
        saveLog("aheals", 
            getPlayerName(client), 
            getPlayerName(targetPlayer), 
            "Can fullendi", 
            0 
        )
    end
end)

addEvent("getherePlayer", true)
addEventHandler("getherePlayer", root, function(targetPlayer, adminName, targetName)
    if targetPlayer then
        local x, y, z = getElementPosition(source)
        setElementPosition(targetPlayer, x + 2, y, z)
        outputChatBox("[!]#ffffff " .. getPlayerName(targetPlayer) .. " isimli oyuncu yanınıza getirildi.", source, 0, 255, 0, true)
        outputChatBox("[!]#ffffff Bir yetkili tarafından çağrıldınız.", targetPlayer, 0, 255, 0, true)
        saveLog("getheres", 
            adminName, 
            targetName, 
            "Gethere işlemi gerçekleştirildi", 
            0 
        )
    end
end)
addEvent("sehrePlayer", true)
addEventHandler("sehrePlayer", root, function(targetPlayer, adminName, targetName)
    if targetPlayer then
        setElementPosition(targetPlayer, 1009.4296875, -1344.263671875, 13.356732368469)
        outputChatBox("[!]#ffffff " .. getPlayerName(targetPlayer) .. " isimli oyuncu şehre ışınlandı.", source, 0, 255, 0, true)
        outputChatBox("[!]#ffffff Bir yetkili tarafından şehre ışınlandınız.", targetPlayer, 0, 255, 0, true)
        saveLog("sehre", 
            adminName, 
            targetName, 
            "Şehre ışınlama işlemi gerçekleştirildi",
            0 -- value
        )
    end
end)

addEvent("setPlayerArmor", true)
addEventHandler("setPlayerArmor", root, function(targetPlayer, armorValue, adminName, targetName)
    if client and hasObjectPermissionTo(client, "function.kickPlayer") then
        setPedArmor(targetPlayer, armorValue)
        outputChatBox("[!] #FFFFFFZırh değeriniz " .. adminName .. " tarafından " .. armorValue .. " olarak ayarlandı.", targetPlayer, 0, 255, 0, true)
        outputChatBox("[!] #FFFFFF" .. targetName .. " adlı oyuncunun zırh değerini " .. armorValue .. " olarak ayarladınız.", client, 0, 255, 0, true)
        saveLog("setarmor", 
            getPlayerName(client), 
            getPlayerName(targetPlayer), 
            "Zırh değeri: " .. armorValue
        )
    end
end)
