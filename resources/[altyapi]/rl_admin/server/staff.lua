local mysql = exports.rl_mysql
local staffTitles = exports.rl_integration:getStaffTitles()

function getStaffInfo(username, error)
    if client ~= source then
        return false
    end
	
	if not hasPlayerAccess(client) then
		return false
	end
    
    local userQuery = dbPrepareString(mysql:getConnection(), "SELECT id, username, admin_level, manager_level FROM accounts WHERE username = ?", username)
    local userResultHandle = dbQuery(mysql:getConnection(), userQuery)
    local userResult = dbPoll(userResultHandle, -1)
    local user = userResult and userResult[1] or nil
    dbFree(userResultHandle)
    
    if not user then
        outputChatBox("[!]#FFFFFF Kullanıcı bulunamadı.", client, 255, 0, 0)
		playSoundFrontEnd(client, 4)
        return
    end
    
    local changelogs = {}
    local changelogsQuery = dbPrepareString(mysql:getConnection(), "SELECT (CASE WHEN to_rank > from_rank THEN 1 ELSE 0 END) AS promoted, s.id, a1.username, team, from_rank, to_rank, a2.username AS `by`, details, DATE_FORMAT(date,'%b %d, %Y %h:%i %p') AS date FROM staff_changelogs s LEFT JOIN accounts a1 ON s.userid = a1.id LEFT JOIN accounts a2 ON s.`by` = a2.id WHERE s.userid = ? ORDER BY id DESC", user.id)
    local changelogsResultHandle = dbQuery(mysql:getConnection(), changelogsQuery)
    local changelogsResult = dbPoll(changelogsResultHandle, -1)
    dbFree(changelogsResultHandle)
    
    if changelogsResult then
        for _, row in ipairs(changelogsResult) do
            table.insert(changelogs, row)
        end
    end
    
    local staffInfo = {
        user = user,
        changelogs = changelogs,
        error = error
    }
    
    triggerClientEvent(client, "staff.openStaffManager", client, staffInfo)
end
addEvent("staff.getStaffInfo", true)
addEventHandler("staff.getStaffInfo", root, getStaffInfo)

function getTeamsData()
    if client ~= source then
		return false
	end
	
	if not hasPlayerAccess(client) then
		return false
	end

    local staffTitles = exports.rl_integration:getStaffTitles()
    local users = {}
    
    local queryString = [[
        SELECT a.id, username, admin_level, manager_level, admin_reports, AVG(rating) AS rating, COUNT(f.staff_id) AS feedbacks
        FROM accounts a
        LEFT JOIN feedbacks f ON a.id = f.staff_id
        WHERE admin_level > 0 OR manager_level > 0
        GROUP BY a.id
        ORDER BY admin_level DESC, admin_reports DESC, manager_level DESC
    ]]
    
    local qh = dbQuery(mysql:getConnection(), queryString)
    local result = dbPoll(qh, -1)
    dbFree(qh)
    
    if result then
        for _, row in ipairs(result) do
            for i, title in ipairs(staffTitles) do
                if not users[i] then users[i] = {} end
                
                if tonumber(row.admin_level) > 0 and i == 1 then
                    if not row.rank then row.rank = {} end
                    row.rank[i] = tonumber(row.admin_level)
                    table.insert(users[i], row)
                end
				
                if tonumber(row.manager_level) > 0 and i == 2 then
                    if not row.rank then row.rank = {} end
                    row.rank[i] = tonumber(row.manager_level)
                    table.insert(users[i], row)
                end
            end
        end
    end
    
    triggerClientEvent(client, "staff.openStaffManager", client, nil, users)
end
addEvent("staff.getTeamsData", true)
addEventHandler("staff.getTeamsData", root, getTeamsData)

function getChangelogs()
    if client ~= source then
		return false
	end
	
	if not hasPlayerAccess(client) then
		return false
	end

    local changelogs = {}
    
    local queryString = [[
        SELECT 
            (CASE WHEN to_rank > from_rank THEN 1 ELSE 0 END) AS promoted, 
            s.id, 
            a1.username, 
            team, 
            from_rank, 
            to_rank, 
            a2.username AS `by`, 
            details, 
            DATE_FORMAT(date, '%b %d, %Y %h:%i %p') AS date 
        FROM staff_changelogs s 
        LEFT JOIN accounts a1 ON s.userid = a1.id 
        LEFT JOIN accounts a2 ON s.`by` = a2.id 
        ORDER BY id DESC
    ]]
    
    local qh = dbQuery(mysql:getConnection(), queryString)
    local result = dbPoll(qh, -1)
    dbFree(qh)
    
    if result then
        for _, row in ipairs(result) do
            table.insert(changelogs, row)
        end
    end
    
    triggerClientEvent(client, "staff.openStaffManager", client, nil, nil, changelogs)
end
addEvent("staff.getChangelogs", true)
addEventHandler("staff.getChangelogs", root, getChangelogs)

function editStaff(userid, ranks, details)
    if client ~= source then
		return false
	end
	
    if not hasPlayerAccess(client) then
		return false
	end

    local error = nil
    if not userid or not tonumber(userid) then
        outputChatBox("[!]#FFFFFF Bir sorun oluştu.", client, 255, 0, 0, true)
		playSoundFrontEnd(client, 4)
        return false
    else
        userid = tonumber(userid)
    end

    local target = nil
    for _, player in ipairs(getElementsByType("player")) do
        if getElementData(player, "account_id") == userid then
            target = player
            break
        end
    end

    local staffTitles = exports.rl_integration:getStaffTitles()
    local queryString = "SELECT id, username, admin_level, manager_level FROM accounts WHERE id = ?"
    local user = dbPoll(dbQuery(mysql:getConnection(), queryString, userid), -1)[1]
    local tail = ""

    if not user then
        outputChatBox("[!]#FFFFFF Kullanıcı bulunamadı.", client, 255, 0, 0)
		playSoundFrontEnd(client, 4)
        return false
    end

    if details and string.len(details) > 0 then
        details = dbPrepareString(mysql:getConnection(), details)
    else
        details = nil
    end

    local changes = {
        {field = "admin_level", rank = ranks[1], team = 1},
        {field = "manager_level", rank = ranks[2], team = 2}
    }

    for _, change in ipairs(changes) do
        if change.rank and change.rank ~= tonumber(user[change.field]) then
            tail = tail .. change.field .. " = " .. change.rank .. ","
            local query = "INSERT INTO staff_changelogs SET userid = ?, details = ?, `by` = ?, team = ?, from_rank = ?, to_rank = ?, `date` = NOW()"
            dbExec(mysql:getConnection(), query, userid, details, getElementData(client, "account_id"), change.team, user[change.field], change.rank)
            exports.rl_global:sendMessageToAdmins("[YETKİ] " .. exports.rl_global:getPlayerFullAdminTitle(client) .. " isimli yetkili " .. user.username .. " isimli kullanıcıyı " .. staffTitles[change.team][tonumber(user[change.field])] .. " yetkisinden " .. staffTitles[change.team][change.rank] .. " yetkisine " .. (change.rank > tonumber(user[change.field]) and "yükseldi" or "düşürdü") .. ".", true)
            exports.rl_logs:addLog("yetki", exports.rl_global:getPlayerFullAdminTitle(client) .. " isimli yetkili " .. user.username .. " isimli kullanıcıyı " .. staffTitles[change.team][tonumber(user[change.field])] .. " yetkisinden " .. staffTitles[change.team][change.rank] .. " yetkisine " .. (change.rank > tonumber(user[change.field]) and "yükseli" or "düşürdü") .. ".")
            if target then setElementData(target, change.field, change.rank, true) end
        end
    end

    if tail ~= "" then
        tail = string.sub(tail, 1, string.len(tail) - 1)
        local updateQuery = "UPDATE accounts SET " .. tail .. " WHERE id = ?"
        if not dbExec(mysql:getConnection(), updateQuery, userid) then
            outputChatBox("[!]#FFFFFF Bir sorun oluştu.", client, 255, 0, 0, true)
            return false
        end
    end

    triggerEvent("staff.getStaffInfo", client, user.username, user.username .. " isimli oyuncunun yetkisi ayarlandı.")
end
addEvent("staff.editStaff", true)
addEventHandler("staff.editStaff", root, editStaff)