local mysql = exports.rl_mysql

function jailPlayer(thePlayer, commandName, targetPlayer, minutes, ...)
	if exports.rl_integration:isPlayerAdmin2(thePlayer) then
		local minutes = tonumber(minutes) and math.ceil(tonumber(minutes))
		if not (targetPlayer) or not (minutes) or not (...) or (minutes < 1) then
			outputChatBox("KULLANIM: /" .. commandName .. " [Karakter Adı / ID] [Dakika / 5000 = Sınırsız] [Sebep]", thePlayer, 255, 194, 14)
		else
			local targetPlayer, targetPlayerName = exports.rl_global:findPlayerByPartialNick(thePlayer, targetPlayer)
			local reason = table.concat({...}, " ")
			
			if (targetPlayer) then
				local jailTimer = getElementData(targetPlayer, "jailtimer")
				local accountID = getElementData(targetPlayer, "account_id")
				
				if isTimer(jailTimer) then
					killTimer(jailTimer)
				end
				
				if (isPedInVehicle(targetPlayer)) then
					setElementData(targetPlayer, "realinvehicle", 0)
					removePedFromVehicle(targetPlayer)
				end
				detachElements(targetPlayer)
				
				setElementDimension(targetPlayer, 65400 + getElementData(targetPlayer, "id"))
				setElementInterior(targetPlayer, 6)
				setCameraInterior(targetPlayer, 6)
				setElementPosition(targetPlayer, 263.821807, 77.848365, 1001.0390625)
				setPedRotation(targetPlayer, 267.438446)
				
				if (minutes >= 5000) then
					dbExec(mysql:getConnection(), "UPDATE accounts SET adminjail = '1', adminjail_time = ?, adminjail_permanent = '1', adminjail_by = ?, adminjail_reason = ? WHERE id = ?", minutes, exports.rl_global:getPlayerFullAdminTitle(thePlayer), reason, accountID)
					setElementData(targetPlayer, "jailtimer", true)
					
					outputChatBox("(( " .. targetPlayerName .. " cezalandırıldı. Süre: Sınırsız - Sebep: " .. reason .. " ))", root, 255, 0, 0)
					exports.rl_logs:addLog("jail", exports.rl_global:getPlayerFullAdminTitle(thePlayer) .. " isimli yetkili " .. targetPlayerName .. " isimli oyuncuyu Sınırsız olarak hapise attı.\nSebep: " .. reason)
				else
					dbExec(mysql:getConnection(), "UPDATE accounts SET adminjail = '1', adminjail_time = ?, adminjail_permanent = '0', adminjail_by = ?, adminjail_reason = ? WHERE id = ?", minutes, exports.rl_global:getPlayerFullAdminTitle(thePlayer), reason, accountID)
					
					local theTimer = setTimer(timerUnjailPlayer, 60000, 1, targetPlayer)
					setElementData(targetPlayer, "jailtimer", theTimer)
					setElementData(targetPlayer, "jailserved", 0)
					setElementData(targetPlayer, "jailtimer", theTimer)
					
					outputChatBox("(( " .. targetPlayerName .. " cezalandırıldı. Süre: " .. minutes .. " dakika - Sebep: " .. reason .. " ))", root, 255, 0, 0)
					exports.rl_logs:addLog("jail", exports.rl_global:getPlayerFullAdminTitle(thePlayer) .. " isimli yetkili " .. targetPlayerName .. " isimli oyuncuyu " .. minutes .. " dakika hapise attı.\nSebep: " .. reason)
				end
				
				setElementData(targetPlayer, "adminjailed", true)
				setElementData(targetPlayer, "jailreason", reason)
				setElementData(targetPlayer, "jailtime", minutes)
				setElementData(targetPlayer, "jailadmin", exports.rl_global:getPlayerFullAdminTitle(thePlayer))
				
				addAdminHistory(targetPlayer, thePlayer, reason, 0, (tonumber(minutes) and (minutes == 5000 and 0 or minutes) or 0))
			end
		end
	end
end
addCommandHandler("jail", jailPlayer, false, false)
addCommandHandler("sjail", jailPlayer, false, false)

function offlineJailPlayer(thePlayer, commandName, targetPlayer, minutes, ...)
    if exports.rl_integration:isPlayerAdmin2(thePlayer) then
        local minutes = tonumber(minutes) and math.ceil(tonumber(minutes))
        if not targetPlayer or not minutes or not (...) or minutes < 1 then
            outputChatBox("KULLANIM: /" .. commandName .. " [Kullanıcı Adı] [Dakika / 5000 = Sınırsız] [Sebep]", thePlayer, 255, 194, 14)
        else
            local reason = table.concat({...}, " ")
            for _, player in ipairs(getElementsByType("player")) do
				if getElementData(player, "logged") then
					if targetPlayer:lower() == getElementData(player, "account_username"):lower() then
						local commandNameTemp = "jail"
						if commandName:lower() == "sojail" then
							commandNameTemp = "sjail"
						end
						jailPlayer(thePlayer, commandNameTemp, getPlayerName(player):gsub(" ", "_"), minutes, reason)
						return true
					end
				end
            end
            
            local targetPlayerQuery = dbPrepareString(mysql:getConnection(), "SELECT id, username, serial, admin_level FROM accounts WHERE username = ? LIMIT 1", targetPlayer)
            local targetPlayerResultHandle = dbQuery(mysql:getConnection(), targetPlayerQuery)
            local targetPlayerResult = dbPoll(targetPlayerResultHandle, -1)
            local accountID, accountUsername = nil, nil
            
            if targetPlayerResult and #targetPlayerResult > 0 then
                accountID = targetPlayerResult[1].id
                accountUsername = targetPlayerResult[1].username
            else
                outputChatBox("[!]#FFFFFF Böyle bir kişi bulunamadı.", thePlayer, 255, 0, 0, true)
				playSoundFrontEnd(thePlayer, 4)
                return false
            end
            dbFree(targetPlayerResultHandle)
            
            if minutes >= 5000 then
                dbExec(mysql:getConnection(), "UPDATE accounts SET adminjail = '1', adminjail_time = '5000', adminjail_permanent = '1', adminjail_by = ?, adminjail_reason = ? WHERE id = ?", exports.rl_global:getPlayerFullAdminTitle(thePlayer), reason, accountID)
                outputChatBox("(( " .. accountUsername .. " cezalandırıldı. Süre: Sınırsız - Sebep: " .. reason .. " ))", root, 255, 0, 0)
                exports.rl_logs:addLog("jail", exports.rl_global:getPlayerFullAdminTitle(thePlayer) .. " isimli yetkili " .. accountUsername .. " isimli oyuncuyu Sınırsız olarak hapise attı.\nSebep: " .. reason)
            else
                dbExec(mysql:getConnection(), "UPDATE accounts SET adminjail = '1', adminjail_time = ?, adminjail_permanent = '0', adminjail_by = ?, adminjail_reason = ? WHERE id = ?", minutes, exports.rl_global:getPlayerFullAdminTitle(thePlayer), reason, accountID)
                outputChatBox("(( " .. accountUsername .. " cezalandırıldı. Süre: " .. minutes .. " dakika - Sebep: " .. reason .. " ))", root, 255, 0, 0)
                exports.rl_logs:addLog("jail", exports.rl_global:getPlayerFullAdminTitle(thePlayer) .. " isimli yetkili " .. accountUsername .. " isimli oyuncuyu " .. minutes .. " dakika hapise attı.\nSebep: " .. reason)
            end
            
            addAdminHistory(accountID, thePlayer, reason, 0, (tonumber(minutes) and (minutes == 5000 and 0 or minutes) or 0))
        end
    end
end
addCommandHandler("ojail", offlineJailPlayer, false, false)
addCommandHandler("sojail", offlineJailPlayer, false, false)

function timerUnjailPlayer(jailedPlayer)
	if isElement(jailedPlayer) then
		local timeServed = getElementData(jailedPlayer, "jailserved")
		local timeLeft = getElementData(jailedPlayer, "jailtime")
		local accountID = getElementData(jailedPlayer, "account_id")
		if (timeServed) then
			setElementData(jailedPlayer, "jailserved", timeServed + 1)
			timeLeft = timeLeft - 1
			setElementData(jailedPlayer, "jailtime", timeLeft)
		
			if (timeLeft <= 0) and not (getElementData(jailedPlayer, "pd.jailtime")) then
				local spawnPosition = exports.rl_global:getServerSettings().spawnPosition
				
				dbExec(mysql:getConnection(), "UPDATE accounts SET adminjail_time = '0', adminjail = '0' WHERE id = ?", accountID)
				
				setElementData(jailedPlayer, "jailtimer", false)
				setElementData(jailedPlayer, "adminjailed", false)
				setElementData(jailedPlayer, "jailreason", false)
				setElementData(jailedPlayer, "jailtime", false)
				setElementData(jailedPlayer, "jailadmin", false)
				setElementPosition(jailedPlayer, spawnPosition.x + math.random(5), spawnPosition.y + math.random(5), spawnPosition.z)
				setPedRotation(jailedPlayer, spawnPosition.rotation)
				setElementDimension(jailedPlayer, 0)
				setElementInterior(jailedPlayer, 0)
				setCameraInterior(jailedPlayer, 0)
				
				outputChatBox("[!]#FFFFFF Hapis süreniz bitti.", jailedPlayer, 0, 255, 0, true)
				exports.rl_global:sendMessageToAdmins("[UNJAIL] " .. getPlayerName(jailedPlayer):gsub("_", " ") .. " isimli oyuncunun hapis süresi bitti.")
				exports.rl_logs:addLog("jail", getPlayerName(jailedPlayer):gsub("_", " ") .. " isimli oyuncunun hapis süresi bitti.")
			else
				dbExec(mysql:getConnection(), "UPDATE accounts SET adminjail_time = ? WHERE id = ?", timeLeft, accountID)
				
				local theTimer = setTimer(timerUnjailPlayer, 60000, 1, jailedPlayer)
				setElementData(jailedPlayer, "jailtimer", theTimer)
				
				local jailCounter = {}
				jailCounter.minutesleft = timeLeft
				jailCounter.reason = getElementData(jailedPlayer, "jailreason")
				jailCounter.admin = getElementData(jailedPlayer, "jailadmin")
			end
		end
	end
end
addEvent("admin:timerUnjailPlayer", false)
addEventHandler("admin:timerUnjailPlayer", root, timerUnjailPlayer)

function unjailPlayer(thePlayer, commandName, targetPlayer)
	if exports.rl_integration:isPlayerAdmin2(thePlayer) then
		if not (targetPlayer) then
			outputChatBox("KULLANIM: /" .. commandName .. " [Karakter Adı / ID]", thePlayer, 255, 194, 14)
		else
			local targetPlayer, targetPlayerName = exports.rl_global:findPlayerByPartialNick(thePlayer, targetPlayer)
			
			if (targetPlayer) then
				local jailed = getElementData(targetPlayer, "jailtimer", nil)
				local username = getPlayerName(thePlayer)
				local accountID = getElementData(targetPlayer, "account_id")
				
				if not (jailed) then
					outputChatBox("[!]#FFFFFF " .. targetPlayerName .. " isimli oyuncu hapisde değil.", thePlayer, 255, 0, 0, true)
					playSoundFrontEnd(thePlayer, 4)
				else
					local spawnPosition = exports.rl_global:getServerSettings().spawnPosition
					
					dbExec(mysql:getConnection(), "UPDATE accounts SET adminjail_time = '0', adminjail = '0' WHERE id = ?", accountID)

					if isTimer(jailed) then
						killTimer(jailed)
					end
					
					setElementData(targetPlayer, "jailtimer", false)
					setElementData(targetPlayer, "adminjailed", false)
					setElementData(targetPlayer, "jailreason", false)
					setElementData(targetPlayer, "jailtime", false)
					setElementData(targetPlayer, "jailadmin", false)
					setElementPosition(targetPlayer, spawnPosition.x + math.random(5), spawnPosition.y + math.random(5), spawnPosition.z)
					setPedRotation(targetPlayer, spawnPosition.rotation)
					setElementDimension(targetPlayer, 0)
					setCameraInterior(targetPlayer, 0)
					setElementInterior(targetPlayer, 0)
			
					outputChatBox("[!]#FFFFFF " .. exports.rl_global:getPlayerFullAdminTitle(thePlayer) .. " isimli yetkili sizi hapisden çıkardı.", targetPlayer, 0, 255, 0,true)
					exports.rl_global:sendMessageToAdmins("[UNJAIL] " .. exports.rl_global:getPlayerFullAdminTitle(thePlayer) .. " isimli yetkili " .. targetPlayerName .. " isimli oyuncuyu hapisden çıkardı.")
					exports.rl_logs:addLog("jail", exports.rl_global:getPlayerFullAdminTitle(thePlayer) .. " isimli yetkili " .. targetPlayerName .. " isimli oyuncuyu hapisden çıkardı.")
				end
			end
		end
	end
end
addCommandHandler("unjail", unjailPlayer, false, false)

function jailedPlayers(thePlayer, commandName)
	if exports.rl_integration:isPlayerAdmin2(thePlayer) then
		local players = exports.rl_pool:getPoolElementsByType("player")
		local count = 0
		for _, player in ipairs(players) do
			if getElementData(player, "adminjailed") then
				if tonumber(getElementData(player, "jailtime")) then
					outputChatBox("[OOC] " .. getPlayerName(player):gsub("_", " ") .. " isimli oyuncu " .. tostring(getElementData(player, "jailadmin")) .. " tarafından " .. tostring(getElementData(player, "jailserved")) .. " dakikadir içerde, " .. tostring(getElementData(player, "jailtime")) .. " dakikasi kaldı.", thePlayer, 255, 0, 0)
					outputChatBox("[OOC] Sebep: " .. tostring(getElementData(player, "jailreason")), thePlayer, 255, 0, 0)
				else
					outputChatBox("[OOC] " .. getPlayerName(player):gsub("_", " ") .. " isimli oyuncu " .. tostring(getElementData(player, "jailadmin")) .. " tarafından Sınırsız hapise atıldı.", thePlayer, 255, 0, 0)
					outputChatBox("[OOC] Sebep: " .. tostring(getElementData(player, "jailreason")), thePlayer, 255, 0, 0)
				end
				count = count + 1
			elseif getElementData(player, "jailed") then
				outputChatBox("[IC] " ..  getPlayerName(player):gsub("_", " ") .. " isimli oyuncunun || Hapis ID: " .. getElementData(player, "jail:cell") .. " || Mahkum ID: " ..  tostring(getElementData(player, "jail:id"))  .. " - daha bilgi için /arrest.", thePlayer, 255, 0, 0)
				count = count + 1
			end
		end
		
		if count == 0 then
			outputChatBox("[!]#FFFFFF Hiç kimse hapisde değil.", thePlayer, 255, 0, 0, true)
			playSoundFrontEnd(thePlayer, 4)
		end
	end
end
addCommandHandler("jailed", jailedPlayers, false, false)