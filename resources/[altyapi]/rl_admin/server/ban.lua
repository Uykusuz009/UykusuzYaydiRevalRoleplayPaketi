local mysql = exports.rl_mysql

local bannedPlayers = {}
local banSecurity = {}
local kickSecurity = {}

addEventHandler("onResourceStart", resourceRoot, function()
	dbQuery(function(queryHandle)
		local result, rows = dbPoll(queryHandle, 0)
		if rows > 0 then
			for _, row in ipairs(result) do
				loadBan(row.serial)
			end
		end
	end, mysql:getConnection(), "SELECT serial FROM bans")
	
	for _, player in ipairs(getElementsByType("player")) do
        reloadSomethings(player)
    end
end)

addEventHandler("onPlayerJoin", root, function()
    reloadSomethings(source)
end)

addEventHandler("onPlayerQuit", root, function()
    banSecurity[source] = nil
    kickSecurity[source] = nil
end)

function loadBan(serial)
	if not serial then
		return false
	end

	dbQuery(function(queryHandle)
		local result, rows = dbPoll(queryHandle, 0)
		if rows > 0 then
			for _, row in ipairs(result) do
				local endTick = tonumber(row.end_tick) or 0
				if endTick ~= -1 then
					bannedPlayers[serial] = {}
					bannedPlayers[serial].endTick = endTick
				end
			end
		end
	end, mysql:getConnection(), "SELECT end_tick FROM bans WHERE serial = ?", serial)
end

function saveBan(serial)
	if not serial then
		return false
	end

	if not bannedPlayers[serial] then
		return false
	end
	
	dbExec(mysql:getConnection(), "UPDATE bans SET end_tick = ? WHERE serial = ?", bannedPlayers[serial].endTick, serial)
end

function removeBan(serial)
	if not bannedPlayers[serial] then
		return false
	end	
	
	local query = dbExec(mysql:getConnection(), "DELETE FROM bans WHERE serial = ?", serial)
	if query then
		local targetPlayer = exports.rl_global:getPlayerFromSerial(serial)
		if targetPlayer then
			redirectPlayer(targetPlayer, "", 0)
		end
		bannedPlayers[serial] = nil
		return true
	end
	return false
end

function checkExpireTime()
	for serial, _ in pairs(bannedPlayers) do
		if bannedPlayers[serial] then
			if bannedPlayers[serial].endTick and bannedPlayers[serial].endTick <= 0 then
				removeBan(serial)
			elseif bannedPlayers[serial].endTick and bannedPlayers[serial].endTick > 0 then
				bannedPlayers[serial].endTick = math.max(bannedPlayers[serial].endTick - (60 * 1000), 0)
				saveBan(serial)
				
				if bannedPlayers[serial].endTick == 0 then
					removeBan(serial)
				end
			end
		end
	end
end
setTimer(checkExpireTime, 60 * 1000, 0)

function clientBan(thePlayer, commandName, targetPlayer, minutes, ...)
    if exports.rl_integration:isPlayerLeaderAdmin(thePlayer) then
		if banSecurity[thePlayer] <= 5 then
			if targetPlayer and minutes and tonumber(minutes) and (...) then
				local minutes = math.floor(minutes)
				if minutes > 0 then
					local reason = table.concat({...}, " ")
					local targetPlayer, targetPlayerName = exports.rl_global:findPlayerByPartialNick(thePlayer, targetPlayer)
					if targetPlayer then
						local playerAdminLevel = getElementData(thePlayer, "admin_level") or 0
						local targetPlayerAdminLevel = getElementData(targetPlayer, "admin_level") or 0
						if playerAdminLevel >= targetPlayerAdminLevel then
							local serial = getPlayerSerial(targetPlayer)
							local ip = getPlayerIP(targetPlayer)
							dbQuery(function(queryHandle, thePlayer, targetPlayer, reason, serial)
								local result, rows = dbPoll(queryHandle, 0)
								if (rows > 0) and (result[1]) then
									outputChatBox("[!]#FFFFFF Zaten [" .. result[1].serial .. "] seriallı kullanıcı sunucudan yasaklı durumda.", thePlayer, 255, 0, 0, true)
									playSoundFrontEnd(thePlayer, 4)
								else
									local time = getRealTime()
									local year = time.year + 1900
									local month = time.month + 1
									local day = time.monthday
									local hour = time.hour
									local minute = time.minute
									local second = time.second

									local currentDatetime = string.format("%04d-%02d-%02d %02d:%02d:%02d", year, month, day, hour, minute, second)
									local endTick = (minutes >= 10000) and -1 or minutes * 60 * 1000
									
									dbExec(mysql:getConnection(), "INSERT INTO bans (serial, ip, admin, reason, date, end_tick) VALUES (?, ?, ?, ?, ?, ?)", serial, ip, exports.rl_global:getPlayerFullAdminTitle(thePlayer), reason, currentDatetime, endTick)
									loadBan(serial)
									
									if minutes >= 10000 then
										outputChatBox("[BAN] " .. exports.rl_global:getPlayerFullAdminTitle(thePlayer) .. " isimli yetkili " .. targetPlayerName .. " (" .. (getElementData(targetPlayer, "account_username") or "?") .. ") isimli oyuncuyu sunucudan yasakladı.", root, 255, 0, 0)
										outputChatBox("[BAN] Sebep: " .. reason .. " (Sınırsız)", root, 255, 0, 0)
										exports.rl_logs:addLog("ban", exports.rl_global:getPlayerFullAdminTitle(thePlayer) .. " isimli yetkili " .. targetPlayerName .. " (" .. (getElementData(targetPlayer, "account_username") or "?") .. ") isimli oyuncuyu sunucudan yasakladı.\nSebep: " .. reason .. " (Sınırsız)")
									else
										outputChatBox("[BAN] " .. exports.rl_global:getPlayerFullAdminTitle(thePlayer) .. " isimli yetkili " .. targetPlayerName .. " (" .. (getElementData(targetPlayer, "account_username") or "?") .. ") isimli oyuncuyu sunucudan yasakladı.", root, 255, 0, 0)
										outputChatBox("[BAN] Sebep: " .. reason .. " (" .. minutes .. " dakika)", root, 255, 0, 0)
										exports.rl_logs:addLog("ban", exports.rl_global:getPlayerFullAdminTitle(thePlayer) .. " isimli yetkili " .. targetPlayerName .. " (" .. (getElementData(targetPlayer, "account_username") or "?") .. ") isimli oyuncuyu sunucudan yasakladı.\nSebep: " .. reason .. " (" .. minutes .. " dakika)")
									end
									
									triggerEvent("savePlayer", targetPlayer, "Banned", targetPlayer)
									addAdminHistory(targetPlayer, thePlayer, reason, 2, (tonumber(minutes) and (minutes >= 10000 and 0 or minutes) or 0))
									
									if (getPedOccupiedVehicle(targetPlayer)) then
										removePedFromVehicle(targetPlayer)
									end
									
									setElementPosition(targetPlayer, 0, 0, 0)
									setElementFrozen(targetPlayer, true)
									setElementDimension(targetPlayer, 9999)
									setElementInterior(targetPlayer, 0)
									
									setElementData(targetPlayer, "legal_name_change", true)
									setPlayerName(targetPlayer, "rl." .. getElementData(targetPlayer, "id"))
									setElementData(targetPlayer, "legal_name_change", false)
									
									exports.rl_account:resetPlayer(targetPlayer)
									triggerClientEvent(targetPlayer, "account.banScreen", targetPlayer, { exports.rl_global:getPlayerFullAdminTitle(thePlayer), reason, currentDatetime, endTick })
									
									banSecurity[thePlayer] = banSecurity[thePlayer] + 1
									if banSecurity[thePlayer] <= 1 then
										setTimer(function()
											banSecurity[thePlayer] = 0
										end, 1000 * 60 * 5, 1)
									end
								end
							end, {thePlayer, targetPlayer, reason, serial}, mysql:getConnection(), "SELECT serial FROM bans WHERE serial = ?", serial)
						else
							outputChatBox("[!]#FFFFFF Sizden daha yüksek seviyedeki birini sunucudan yasaklayamazsınız.", thePlayer, 255, 0, 0, true)
							playSoundFrontEnd(thePlayer, 4)
							outputChatBox("[!]#FFFFFF " .. exports.rl_global:getPlayerFullAdminTitle(thePlayer) .. " isimli yetkili sizi sunucudan yasaklamaya çalışdı.", targetPlayer, 255, 0, 0, true)
						end
					end
				else
					outputChatBox("KULLANIM: /" .. commandName .. " [Karakter Adı / ID] [Dakika / 10000 = Sınırsız] [Sebep]", thePlayer, 255, 194, 14)
				end
			else 
				outputChatBox("KULLANIM: /" .. commandName .. " [Karakter Adı / ID] [Dakika / 10000 = Sınırsız] [Sebep]", thePlayer, 255, 194, 14)
			end
		else
            outputChatBox("[!]#FFFFFF Beş dakika içinde en fazla 5 kişiyi sunucudan yasaklayabilirsiniz.", thePlayer, 255, 0, 0, true)
			playSoundFrontEnd(thePlayer, 4)
		end
    else
		outputChatBox("[!]#FFFFFF Yeterli yetkiniz yok.", thePlayer, 255, 0, 0, true)
		playSoundFrontEnd(thePlayer, 4)
	end
end
addCommandHandler("ban", clientBan, false, false)

function offlineClientBan(thePlayer, commandName, serial, minutes, ...)
    if exports.rl_integration:isPlayerLeaderAdmin(thePlayer) then
		if banSecurity[thePlayer] <= 5 then
			if serial and minutes and tonumber(minutes) and (...) then
				if #serial == 32 then
					local minutes = math.floor(minutes)
					if minutes > 0 then
						local reason = table.concat({...}, " ")
						dbQuery(function(queryHandle, thePlayer, serial, minutes, reason)
							local result, rows = dbPoll(queryHandle, 0)
							if (rows > 0) and (result[1]) then
								outputChatBox("[!]#FFFFFF Zaten [" .. result[1].serial .. "] seriallı kullanıcı sunucudan yasaklı durumda.", thePlayer, 255, 0, 0, true)
								playSoundFrontEnd(thePlayer, 4)
							else
								local time = getRealTime()
								local year = time.year + 1900
								local month = time.month + 1
								local day = time.monthday
								local hour = time.hour
								local minute = time.minute
								local second = time.second

								local currentDatetime = string.format("%04d-%02d-%02d %02d:%02d:%02d", year, month, day, hour, minute, second)
								local endTick = (minutes >= 10000) and -1 or minutes * 60 * 1000
								
								loadBan(serial)
								dbExec(mysql:getConnection(), "INSERT INTO bans (serial, ip, admin, reason, date, end_tick) VALUES (?, ?, ?, ?, ?, ?)", serial, nil, exports.rl_global:getPlayerFullAdminTitle(thePlayer), reason, currentDatetime, endTick)
								
								if minutes >= 10000 then
									outputChatBox("[OBAN] " .. exports.rl_global:getPlayerFullAdminTitle(thePlayer) .. " isimli yetkili [" .. serial .. "] serialını sunucudan yasakladı.", root, 255, 0, 0)
									outputChatBox("[OBAN] Sebep: " .. reason .. " (Sınırsız)", root, 255, 0, 0)
									exports.rl_logs:addLog("ban", exports.rl_global:getPlayerFullAdminTitle(thePlayer) .. " isimli yetkili [" .. serial .. "] serialını sunucudan yasakladı.\nSebep: " .. reason .. " (Sınırsız)")
								else
									outputChatBox("[OBAN] " .. exports.rl_global:getPlayerFullAdminTitle(thePlayer) .. " isimli yetkili [" .. serial .. "] serialını sunucudan yasakladı.", root, 255, 0, 0)
									outputChatBox("[OBAN] Sebep: " .. reason .. " (" .. minutes .. " dakika)", root, 255, 0, 0)
									exports.rl_logs:addLog("ban", exports.rl_global:getPlayerFullAdminTitle(thePlayer) .. " isimli yetkili [" .. serial .. "] serialını sunucudan yasakladı.\nSebep: " .. reason .. " (" .. minutes .. " dakika)")
								end
								
								for _, player in ipairs(getElementsByType("player")) do
									if getPlayerSerial(player) == serial then
										triggerEvent("savePlayer", player, "Banned", player)
										addAdminHistory(player, thePlayer, reason, 2, (tonumber(minutes) and (minutes >= 10000 and 0 or minutes) or 0))
										
										if (getPedOccupiedVehicle(player)) then
											removePedFromVehicle(player)
										end
										
										setElementPosition(player, 0, 0, 0)
										setElementFrozen(player, true)
										setElementDimension(player, 9999)
										setElementInterior(player, 0)
										
										setElementData(player, "legal_name_change", true)
										setPlayerName(player, "jrp." .. getElementData(player, "id"))
										setElementData(player, "legal_name_change", false)
										
										exports.rl_account:resetPlayer(player)
										triggerClientEvent(player, "account.banScreen", player, { exports.rl_global:getPlayerFullAdminTitle(thePlayer), reason, currentDatetime, endTick })
									end
								end
								
								banSecurity[thePlayer] = banSecurity[thePlayer] + 1
								if banSecurity[thePlayer] <= 1 then
									setTimer(function()
										banSecurity[thePlayer] = 0
									end, 1000 * 60 * 5, 1)
								end
							end
						end, {thePlayer, serial, minutes, reason}, mysql:getConnection(), "SELECT serial FROM bans WHERE serial = ?", serial)
					else
						outputChatBox("KULLANIM: /" .. commandName .. " [Serial] [Dakika / 10000 = Sınırsız] [Sebep]", thePlayer, 255, 194, 14)
					end
				else
					outputChatBox("[!]#FFFFFF Lütfen geçerli bir serial girin.", thePlayer, 255, 0, 0, true)
					playSoundFrontEnd(thePlayer, 4)
				end
			else
				outputChatBox("KULLANIM: /" .. commandName .. " [Serial] [Dakika / 10000 = Sınırsız] [Sebep]", thePlayer, 255, 194, 14)
			end
		else
			outputChatBox("[!]#FFFFFF Beş dakika içinde en fazla 5 kişiyi sunucudan yasaklayabilirsiniz.", thePlayer, 255, 0, 0, true)
			playSoundFrontEnd(thePlayer, 4)
		end
    else
		outputChatBox("[!]#FFFFFF Yeterli yetkiniz yok.", thePlayer, 255, 0, 0, true)
		playSoundFrontEnd(thePlayer, 4)
	end
end
addCommandHandler("oban", offlineClientBan, false, false)

function playerBan(thePlayer, commandName, targetPlayer, minutes, ...)
    if exports.rl_integration:isPlayerLeaderAdmin(thePlayer) then
		if banSecurity[thePlayer] <= 5 then
			if targetPlayer then
				local targetPlayer, targetPlayerName = exports.rl_global:findPlayerByPartialNick(thePlayer, targetPlayer)
				if targetPlayer then
					minutes = tonumber(minutes)
					if minutes then
						if (...) then
							local reason = table.concat({...}, " ")
							if minutes >= 0 then
								local playerAdminLevel = getElementData(thePlayer, "admin_level") or 0
								local targetPlayerAdminLevel = getElementData(targetPlayer, "admin_level") or 0
								if playerAdminLevel >= targetPlayerAdminLevel then
									if minutes == 0 then
										outputChatBox("[PBAN] " .. exports.rl_global:getPlayerFullAdminTitle(thePlayer) .. " isimli yetkili " .. targetPlayerName .. " (" .. (getElementData(targetPlayer, "account_username") or "?") .. ") isimli oyuncuyu sunucudan yasakladı.", root, 255, 0, 0)
										outputChatBox("[PBAN] Sebep: " .. reason .. " (Sınırsız)", root, 255, 0, 0)
										exports.rl_logs:addLog("ban", exports.rl_global:getPlayerFullAdminTitle(thePlayer) .. " isimli yetkili " .. targetPlayerName .. " (" .. (getElementData(targetPlayer, "account_username") or "?") .. ") isimli oyuncuyu sunucudan yasakladı.\nSebep: " .. reason .. " (Sınırsız)")
									else
										outputChatBox("[PBAN] " .. exports.rl_global:getPlayerFullAdminTitle(thePlayer) .. " isimli yetkili " .. targetPlayerName .. " (" .. (getElementData(targetPlayer, "account_username") or "?") .. ") isimli oyuncuyu sunucudan yasakladı.", root, 255, 0, 0)
										outputChatBox("[PBAN] Sebep: " .. reason .. " (" .. minutes .. " dakika)", root, 255, 0, 0)
										exports.rl_logs:addLog("ban", exports.rl_global:getPlayerFullAdminTitle(thePlayer) .. " isimli yetkili " .. targetPlayerName .. " (" .. (getElementData(targetPlayer, "account_username") or "?") .. ") isimli oyuncuyu sunucudan yasakladı.\nSebep: " .. reason .. " (" .. minutes .. " dakika)")
									end
									
									triggerEvent("savePlayer", targetPlayer, "Banned", targetPlayer)
									addAdminHistory(targetPlayer, thePlayer, reason, 2, (tonumber(minutes) and (minutes == 0 and 0 or minutes) or 0))
									banPlayer(targetPlayer, true, false, true, (getElementData(thePlayer, "account_username") or "?"), reason, minutes * 60)

                                    banSecurity[thePlayer] = banSecurity[thePlayer] + 1
                                    if banSecurity[thePlayer] <= 1 then
                                        setTimer(function()
                                            banSecurity[thePlayer] = 0
                                        end, 10000, 1)
                                    end
								else
									outputChatBox("[!]#FFFFFF Sizden daha yüksek seviyedeki birini sunucudan yasaklayamazsınız.", thePlayer, 255, 0, 0, true)
									playSoundFrontEnd(thePlayer, 4)
									outputChatBox("[!]#FFFFFF " .. exports.rl_global:getPlayerFullAdminTitle(thePlayer) .. " isimli yetkili sizi sunucudan yasaklamaya çalışdı.", targetPlayer, 255, 0, 0, true)
								end
							else
								outputChatBox("KULLANIM: /" .. commandName .. " [Karakter Adı / ID] [Dakika / 0 = Sınırsız] [Sebep]", thePlayer, 255, 194, 14)
							end
						else
							outputChatBox("KULLANIM: /" .. commandName .. " [Karakter Adı / ID] [Dakika / 0 = Sınırsız] [Sebep]", thePlayer, 255, 194, 14)
						end
					else
						outputChatBox("KULLANIM: /" .. commandName .. " [Karakter Adı / ID] [Dakika / 0 = Sınırsız] [Sebep]", thePlayer, 255, 194, 14)
					end
				end
			else 
				outputChatBox("KULLANIM: /" .. commandName .. " [Karakter Adı / ID] [Dakika / 0 = Sınırsız] [Sebep]", thePlayer, 255, 194, 14)
			end
		else
			outputChatBox("[!]#FFFFFF Beş dakika içinde en fazla 5 kişiyi sunucudan yasaklayabilirsiniz.", thePlayer, 255, 0, 0, true)
			playSoundFrontEnd(thePlayer, 4)
		end
    else
		outputChatBox("[!]#FFFFFF Yeterli yetkiniz yok.", thePlayer, 255, 0, 0, true)
		playSoundFrontEnd(thePlayer, 4)
	end
end
addCommandHandler("pban", playerBan, false, false)

function offlineBan(thePlayer, commandName, serial, minutes, ...)
    if exports.rl_integration:isPlayerLeaderAdmin(thePlayer) then
		if banSecurity[thePlayer] <= 5 then
			if serial then
				minutes = tonumber(minutes)
				if minutes then
					if (...) then
						local reason = table.concat({...}, " ")
						if minutes >= 0 then
							if minutes == 0 then
								outputChatBox("[OPBAN] " .. exports.rl_global:getPlayerFullAdminTitle(thePlayer) .. " isimli yetkili [" .. serial .. "] serialını sunucudan yasakladı.", root, 255, 0, 0)
								outputChatBox("[OPBAN] Sebep: " .. reason .. " (Sınırsız)", root, 255, 0, 0)
								exports.rl_logs:addLog("ban", exports.rl_global:getPlayerFullAdminTitle(thePlayer) .. " isimli yetkili [" .. serial .. "] serialını sunucudan yasakladı.\nSebep: " .. reason .. " (Sınırsız)")
							else
								outputChatBox("[OPBAN] " .. exports.rl_global:getPlayerFullAdminTitle(thePlayer) .. " isimli yetkili [" .. serial .. "] serialını sunucudan yasakladı.", root, 255, 0, 0)
								outputChatBox("[OPBAN] Sebep: " .. reason .. " (" .. minutes .. " dakika)", root, 255, 0, 0)
								exports.rl_logs:addLog("ban", exports.rl_global:getPlayerFullAdminTitle(thePlayer) .. " isimli yetkili [" .. serial .. "] serialını sunucudan yasakladı.\nSebep: " .. reason .. " (" .. minutes .. " dakika)")
							end
							
							for _, player in ipairs(getElementsByType("player")) do
								if getPlayerSerial(player) == serial then
									triggerEvent("savePlayer", player, "Banned", player)
									addAdminHistory(targetPlayer, player, reason, 2, (tonumber(minutes) and (minutes == 0 and 0 or minutes) or 0))
								end
							end
							
							addBan(nil, nil, serial, (getElementData(thePlayer, "account_username") or "?"), reason, minutes * 60)
							
							banSecurity[thePlayer] = banSecurity[thePlayer] + 1
                            if banSecurity[thePlayer] <= 1 then
                                setTimer(function()
                                    banSecurity[thePlayer] = 0
                                end, 10000, 1)
                            end
						else
							outputChatBox("KULLANIM: /" .. commandName .. " [Serial] [Dakika / 0 = Sınırsız] [Sebep]", thePlayer, 255, 194, 14)
						end
					else
						outputChatBox("KULLANIM: /" .. commandName .. " [Serial] [Dakika / 0 = Sınırsız] [Sebep]", thePlayer, 255, 194, 14)
					end
				else
					outputChatBox("KULLANIM: /" .. commandName .. " [Serial] [Dakika / 0 = Sınırsız] [Sebep]", thePlayer, 255, 194, 14)
				end
			else
				outputChatBox("KULLANIM: /" .. commandName .. " [Serial] [Dakika / 0 = Sınırsız] [Sebep]", thePlayer, 255, 194, 14)
			end
		else
			outputChatBox("[!]#FFFFFF Beş dakika içinde en fazla 5 kişiyi sunucudan yasaklayabilirsiniz.", thePlayer, 255, 0, 0, true)
			playSoundFrontEnd(thePlayer, 4)
		end
    else
		outputChatBox("[!]#FFFFFF Yeterli yetkiniz yok.", thePlayer, 255, 0, 0, true)
		playSoundFrontEnd(thePlayer, 4)
	end
end
addCommandHandler("opban", offlineBan, false, false)

function playerKick(thePlayer, commandName, targetPlayer, reason)
    if exports.rl_integration:isPlayerSeniorAdmin(thePlayer) then
		if kickSecurity[thePlayer] <= 5 then
			if targetPlayer then
				local targetPlayer, targetPlayerName = exports.rl_global:findPlayerByPartialNick(thePlayer, targetPlayer)
				if targetPlayer then
					if reason then
						local playerAdminLevel = getElementData(thePlayer, "admin_level") or 0
						local targetPlayerAdminLevel = getElementData(targetPlayer, "admin_level") or 0
						if playerAdminLevel >= targetPlayerAdminLevel then
							outputChatBox("[KICK] " .. exports.rl_global:getPlayerFullAdminTitle(thePlayer) .. " isimli yetkili " .. targetPlayerName .. " (" .. (getElementData(targetPlayer, "account_username") or "?") .. ") isimli oyuncuyu sunucudan attı.", root, 255, 0, 0)
							outputChatBox("[KICK] Sebep: " .. reason, root, 255, 0, 0)
							exports.rl_logs:addLog("kick", exports.rl_global:getPlayerFullAdminTitle(thePlayer) .. " isimli yetkili " .. targetPlayerName .. " (" .. (getElementData(targetPlayer, "account_username") or "?") .. ") isimli oyuncuyu sunucudan attı.\nSebep: " .. reason)
							
							triggerEvent("savePlayer", targetPlayer, "Kicked", targetPlayer)
							addAdminHistory(targetPlayer, thePlayer, reason, 1, 0)
							kickPlayer(targetPlayer, thePlayer, reason)
							
							kickSecurity[thePlayer] = kickSecurity[thePlayer] + 1
                            if kickSecurity[thePlayer] <= 1 then
                                setTimer(function()
                                    kickSecurity[thePlayer] = 0
                                end, 1000 * 60 * 5, 1)
                            end
						else
							outputChatBox("[!]#FFFFFF Kendinizden üst yetkili birisini sunucudan atamazsınız.", thePlayer, 255, 0, 0, true)
							playSoundFrontEnd(thePlayer, 4)
							outputChatBox("[!]#FFFFFF " .. exports.rl_global:getPlayerFullAdminTitle(thePlayer) .. " isimli yetkili sizi sunucudan atmaya çalıştı.", targetPlayer, 255, 0, 0, true)
						end
					else
						outputChatBox("KULLANIM: /" .. commandName .. " [Karakter Adı / ID] [Sebep]", thePlayer, 255, 194, 14)
					end
				end
			else 
				outputChatBox("KULLANIM: /" .. commandName .. " [Karakter Adı / ID] [Sebep]", thePlayer, 255, 194, 14)
			end
		else
            outputChatBox("[!]#FFFFFF Beş dakika içerisinde yalnızca en fazla 5 kişiyi sunucudan atabilirsiniz.", thePlayer, 255, 0, 0, true)
			playSoundFrontEnd(thePlayer, 4)
		end
    else
		outputChatBox("[!]#FFFFFF Yeterli yetkiniz yok.", thePlayer, 255, 0, 0, true)
		playSoundFrontEnd(thePlayer, 4)
	end
end
addCommandHandler("kick", playerKick, false, false)

function reloadSomethings(thePlayer)
    banSecurity[thePlayer] = 0
    kickSecurity[thePlayer] = 0
end