local mysql = exports.rl_mysql

function doCheck(thePlayer, command, ...)
	if exports.rl_integration:isPlayerTrialAdmin(thePlayer) then
		if not (...) then
			outputChatBox("KULLANIM: /" .. command .. " [Karakter Adı / ID]", thePlayer, 255, 194, 14)
		else
			local targetPlayer, targetPlayerName = exports.rl_global:findPlayerByPartialNick(thePlayer, table.concat({...}, "_"))
			if (targetPlayer) then
				if getElementData(targetPlayer, "logged") then
					if targetPlayer and isElement(targetPlayer) then
						local ip = getPlayerIP(targetPlayer)
						local adminReports = tonumber(getElementData(targetPlayer, "admin_reports"))
						local balance = nil
						local note = ""
						
						dbQuery(function(qh)
							local res, rows, err = dbPoll(qh, 0)
							local result = res[1]
							if result then
								text = result["admin_note"] or "?"
								balance = result["balance"] or "?"
							end

							dbQuery(function(qh)
								local res, rows, err = dbPoll(qh, 0)
								history = {}
								for index, row in ipairs(res) do
									if row then
										table.insert(history, {tonumber(row.action), tonumber(row.numbr)})
									end
								end
								
								hoursAcc = "N/A"
								
								dbQuery(function(qh)
									local res, rows, err = dbPoll(qh, 0)

									hoursAcc = tonumber(res[1].hours)
									local bankMoney = getElementData(targetPlayer, "bank_money") or -1
									local money = getElementData(targetPlayer, "money") or -1
									
									local adminLevel = exports.rl_global:getPlayerAdminTitle(targetPlayer)
									
									local hoursPlayed = getElementData(targetPlayer, "hours_played")
									local username = getElementData(targetPlayer, "account_username")
									triggerClientEvent(thePlayer, "onCheck", targetPlayer, ip, adminReports, balance, note, history, bankMoney, money, adminLevel, hoursPlayed, username, hoursAcc)
								end, mysql:getConnection(), "SELECT SUM(hours_played) AS hours FROM `characters` WHERE account = ?", tostring(getElementData(targetPlayer, "account_id")))
							end, mysql:getConnection(), "SELECT action, COUNT(*) as numbr FROM admin_history WHERE user = ? GROUP BY action", tostring(getElementData(targetPlayer, "account_id")))
						end, mysql:getConnection(), "SELECT admin_note, balance FROM accounts WHERE id = ?", tostring(getElementData(targetPlayer, "account_id")))
					end
				end
			end
		end
	end
end
addEvent("checkCommandEntered", true)
addEventHandler("checkCommandEntered", root, doCheck)

function savePlayerNote(targetPlayer, text)
	if exports.rl_integration:isPlayerTrialAdmin(client) then
		local account = getElementData(targetPlayer, "account_id")
		if account then
			local result = dbExec(mysql:getConnection(), "UPDATE accounts SET admin_note = ? WHERE id = ?", text, account)
			if result then
				outputChatBox("[!]#FFFFFF Başarıyla " .. getPlayerName(targetPlayer):gsub("_", " ") .. " (" .. getElementData(targetPlayer, "account_username") .. ") isimli oyuncunun yetkili notu yenilendi.", client, 0, 255, 0, true)
			end
		else
			outputChatBox("[!]#FFFFFF Bir sorun oluştu.", client, 255, 0, 0, true)
			playSoundFrontEnd(client, 4)
		end
	end
end
addEvent("savePlayerNote", true)
addEventHandler("savePlayerNote", root, savePlayerNote)

function showAdminHistory(targetPlayer)
	if source and isElement(source) and getElementType(source) == "player" then
		client = source
	end
	
	if not (exports.rl_integration:isPlayerTrialAdmin(client)) then
		if client ~= targetPlayer then
			return false
		end
	end
	
	if getElementData(targetPlayer, "logged") then
		local targetID = getElementData(targetPlayer, "account_id")
		if targetID then
			dbQuery(function(qh, client)
				local res, rows, err = dbPoll(qh, 0)
				local info = {}
				for index, row in ipairs(res) do
					local i = #info + 1
					if not info[i] then
						info[i] = {}
					end
					info[i][1] = row["date"]
					info[i][2] = row["action"]
					info[i][3] = row["reason"]
					info[i][4] = row["duration"]
					info[i][5] = row["username"] == nil and "SİSTEM" or row["username"]
					info[i][6] = row["user_char"] == nil and "N/A" or row["user_char"]
					info[i][7] = row["recordid"]
					info[i][8] = row["hadmin"]
				end
				
				triggerClientEvent(client, "cshowAdminHistory", targetPlayer, info, tostring(getElementData(targetPlayer, "account_username")))
			end, {client}, mysql:getConnection(), "SELECT DATE_FORMAT(date,'%b %d, %Y at %h:%i %p') AS date, action, h.admin AS hadmin, reason, duration, a.username as username, c.name AS user_char, h.id as recordid FROM admin_history h LEFT JOIN accounts a ON a.id = h.admin LEFT JOIN characters c ON h.user_char = c.id WHERE user = ? ORDER BY h.id DESC", targetID)
		else
			outputChatBox("[!]#FFFFFF Bir sorun oluştu.", client, 255, 0, 0, true)
			playSoundFrontEnd(client, 4)
		end
	else
		outputChatBox("[!]#FFFFFF Bu oyuncu karakterine giriş yapmadığı için işlem gerçekleşmedi.", client, 255, 0, 0, true)
        playSoundFrontEnd(client, 4)
	end
end
addEvent("showAdminHistory", true)
addEventHandler("showAdminHistory", root, showAdminHistory)

function removeAdminHistoryLine(id)
	if not id then
		return
	end
	
	dbQuery(function(qh, client)
		local res, rows, err = dbPoll(qh, 0)
		if rows > 0 then
			dbExec(mysql:getConnection(), "DELETE FROM admin_history WHERE id = ?", tostring(id))
			if client then
				outputChatBox("[!]#FFFFFF Başarıyla [" .. id .. "] ID'li kayıt silindi.", client, 0, 255, 0, true)
			end
		end
	end, {client}, mysql:getConnection(), "SELECT * FROM admin_history WHERE id = ?", tostring(id))
end
addEvent("admin:removehistory", true)
addEventHandler("admin:removehistory", root, removeAdminHistoryLine)

addCommandHandler("history", function(thePlayer, commandName, ...)
    if not exports.rl_integration:isPlayerTrialAdmin(thePlayer) then
        if (...) then
            outputChatBox("[!]#FFFFFF Yeterli yetkiniz yok.", thePlayer, 255, 0, 0, true)
            playSoundFrontEnd(thePlayer, 4)
            return false
        end
    end

    local targetPlayer = thePlayer
    if (...) then
        targetPlayer = exports.rl_global:findPlayerByPartialNick(thePlayer, table.concat({...}, "_"))
    end

    if targetPlayer then
        if not getElementData(targetPlayer, "logged") then
            outputChatBox("[!]#FFFFFF Bu oyuncu karakterine giriş yapmadığı için işlem gerçekleşmedi.", thePlayer, 255, 0, 0, true)
            playSoundFrontEnd(thePlayer, 4)
        else
            triggerEvent("showAdminHistory", thePlayer, targetPlayer)
        end
    else
        local targetPlayerName = table.concat({...}, "_")

        local query = dbPrepareString(mysql:getConnection(), "SELECT account FROM characters WHERE name = ?", targetPlayerName)
        local result = dbPoll(dbQuery(mysql:getConnection(), query), -1)
        if result then
            if #result == 1 then
                local row = result[1]
                local id = row["account"] or "0"
                triggerEvent("showOfflineAdminHistory", thePlayer, id, targetPlayerName)
                return
            else
                local query2 = dbPrepareString(mysql:getConnection(), "SELECT id FROM accounts WHERE username = ?", targetPlayerName)
                local result2 = dbPoll(dbQuery(mysql:getConnection(), query2), -1)
                if result2 then
                    if #result2 == 1 then
                        local row2 = result2[1]
                        local id = tonumber(row2["id"]) or "0"
                        triggerEvent("showOfflineAdminHistory", thePlayer, id, targetPlayerName)
                        return
                    end
                end
            end
        end

        outputChatBox("[!]#FFFFFF Oyuncu bulunamadı veya birden fazla oyuncu bulunamadı.", thePlayer, 255, 0, 0, true)
        playSoundFrontEnd(thePlayer, 4)
    end
end)

addEvent("admin:showInventory", true)
addEventHandler("admin:showInventory", root, function(targetPlayer)
	if client ~= source then
		return
	end
	
	executeCommandHandler("showinv", client, getElementData(targetPlayer, "id"))
end)

function addAdminHistory(user, admin, reason, action, duration)
	local user_char = 0
	
	if not action or not tonumber(action) then
		action = getHistoryAction(action)
	end
	
	if not action then
		action = 6
	end
	
	if not duration or not tonumber(duration) then
		duration = 0
	end
	
	if isElement(user) then
		user_char = getElementData(user, "dbid") or 0
		user = getElementData(user, "account_id") or 0
	end
	
	if isElement(admin) then
		admin = getElementData(admin, "account_id")
	end
	
	if not tonumber(user) or not tonumber(admin) or not reason then
		return false
	end
	
	return dbExec(mysql:getConnection(), "INSERT INTO admin_history SET admin = ?, user = ?, user_char = ?, action = ?, duration = ?, reason = ?", admin, user, user_char, action, duration, reason)
end