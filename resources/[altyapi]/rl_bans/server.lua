local mysql = exports.rl_mysql

 function bansList(thePlayer, commandName)
	if exports.rl_integration:isPlayerLeaderAdmin(thePlayer) then
         local bans = {}
         local clientBans = {}
         local accountBans = {}
		
		 for _, ban in ipairs(getBans()) do
        	 table.insert(bans, { getBanNick(ban), getBanAdmin(ban), getBanReason(ban), getBanIP(ban), getBanSerial(ban) })
         end
		
		 local query = dbPoll(dbQuery(mysql:getConnection(), "SELECT * FROM bans"), -1)
		if (query) then
			 for _, data in ipairs(query) do
            	 table.insert(clientBans, { data["id"], data["serial"], data["ip"], data["admin"], data["reason"], data["date"] })
            end
         end
		
		 local query = dbPoll(dbQuery(mysql:getConnection(), "SELECT * FROM accounts WHERE banned = 1"), -1)
		 if (query) then
			 for _, data in ipairs(query) do
            	 table.insert(accountBans, { data["id"], data["username"] })
             end
         end

         triggerClientEvent(thePlayer, "bans.openWindow", thePlayer, bans, clientBans, accountBans)
	 else
		 outputChatBox("[!]#FFFFFF Yeterli yetkiniz yok.", thePlayer, 255, 0, 0, true)
		 playSoundFrontEnd(thePlayer, 4)
	 end
 end
 addCommandHandler("bans", bansList, false, false)

function SmallestID()
	local query = dbQuery(mysql:getConnection(), "SELECT MIN(e1.id+1) AS nextID FROM bans AS e1 LEFT JOIN bans AS e2 ON e1.id +1 = e2.id WHERE e2.id IS NULL")
	local result = dbPoll(query, -1)
	if result then
		local id = tonumber(result[1]["nextID"]) or 1
		return id
	end
	return false
end


function bans(thePlayer, cmd, targetPlayer, hours, ...)
    if exports.rl_integration:isPlayerLeaderAdmin(thePlayer) then
        if not targetPlayer then
            thePlayer:outputChat("#D0D0D0  /pban [ID] [Saat] [Sebep]", 84, 170, 235, true)
        else
            local targetPlayer, targetPlayerName = exports.rl_global:findPlayerByPartialNick(thePlayer, targetPlayer)
            if targetPlayer then
                if tonumber(hours) and (...) then
                    local reason = table.concat({...}, " ")
                    local username = targetPlayer:getData('account:username')
                    local adminTitle = exports.rl_global:getPlayerAdminTitle(thePlayer)
                    local targetSerial = getPlayerSerial(targetPlayer)
                    local ips = getPlayerIP(targetPlayer)
                    local smallestID = SmallestID()

                    local end_tick = getRealTime().timestamp + (tonumber(hours) * 3600)

                    dbExec(mysql:getConnection(),
                        "INSERT INTO bans (id, serial, ip, admin, reason, date, end_tick) VALUES (?, ?, ?, ?, ?, NOW(), ?)",smallestID, targetSerial, ips, adminTitle, reason, end_tick)
                    for _, player in ipairs(getElementsByType("player")) do
                        player:outputChat('[YASAKLAMA] '..adminTitle..' isimli yetkili '..targetPlayerName..' isimli oyuncuyu yasakladı. ('..hours..' saat)', 255, 0, 0, true)
                        player:outputChat('[YASAKLAMA] Gerekçe: '..reason..'.', 255, 0, 0, true)
                    end

                    kickPlayer(targetPlayer, thePlayer, reason)
                else
                    thePlayer:outputChat("#D0D0D0  Lütfen geçerli bir saat ve sebep giriniz!", 84, 170, 235, true)
                end
            end
        end
    end
end
addCommandHandler("faxyban", bans, false, false)


addEvent("bans.removeBan", true)
addEventHandler("bans.removeBan", root, function(type, data)
	if client ~= source then
		return
	end
	
	if exports.rl_integration:isPlayerLeaderAdmin(client) then
		if type == 1 then
			removeBanFromSerial(data)
			outputChatBox("[!]#FFFFFF Başarıyla [" .. data .. "] isimli serialin banı açıldı.", client, 0, 255, 0, true)
			exports.rl_global:sendMessageToAdmins("[UNBAN] " .. exports.rl_global:getPlayerFullAdminTitle(client) .. " isimli yetkili [" .. data .. "] isimli serialin banını açdı.")
			exports.rl_logs:addLog("unban", exports.rl_global:getPlayerFullAdminTitle(client) .. " isimli yetkili [" .. data .. "] serialin banını açdı.")
		elseif type == 2 then
			dbExec(mysql:getConnection(), "DELETE FROM bans WHERE id = ?", data)
			outputChatBox("[!]#FFFFFF Başarıyla [" .. data .. "] ID'li ban açıldı.", client, 0, 255, 0, true)
			exports.rl_global:sendMessageToAdmins("[UNCBAN] " .. exports.rl_global:getPlayerFullAdminTitle(client) .. " isimli yetkili [" .. data .. "] ID'li banını açdı.")
			exports.rl_logs:addLog("unban", exports.rl_global:getPlayerFullAdminTitle(client) .. " isimli yetkili [" .. data .. "] ID'li banını açdı.")
		elseif type == 3 then
			dbExec(mysql:getConnection(), "UPDATE accounts SET banned = 0 WHERE id = ?", data[1])
			outputChatBox("[!]#FFFFFF Başarıyla [" .. data[2] .. "] isimli hesabın banı açıldı.", client, 0, 255, 0, true)
			exports.rl_global:sendMessageToAdmins("[UNBAN] " .. exports.rl_global:getPlayerFullAdminTitle(client) .. " isimli yetkili [" .. data[2] .. "] isimli hesabın banını açdı.")
			exports.rl_logs:addLog("unban", exports.rl_global:getPlayerFullAdminTitle(client) .. " isimli yetkili [" .. data[2] .. "] isimli hesabın banını açdı.")
		end
	end
end)

function removeBanFromSerial(serial)
	for _, ban in ipairs(getBans()) do
		if serial == getBanSerial(ban) then
			removeBan(ban)
		end
    end
end