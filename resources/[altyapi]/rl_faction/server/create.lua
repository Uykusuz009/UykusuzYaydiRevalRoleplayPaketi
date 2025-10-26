function birlikKur(thePlayer, commandName)
	local playerTeam = getElementData(thePlayer, "faction")
	
	if playerTeam ~= -1 then
		outputChatBox("[!]#FFFFFF Zaten birliğiniz var.", thePlayer, 255, 0, 0, true)
		playSoundFrontEnd(thePlayer, 4)
		return
	end
	
	triggerClientEvent(thePlayer, "createFactionGUI", thePlayer)
end
addCommandHandler("birlikkur", birlikKur, false, false)

addEvent("createFaction", true)
addEventHandler("createFaction", root, function(birlikName, birlikType)
	if client ~= source then
		exports.rl_ac:banForEventAbuse(client, eventName)
		return
	end
	
	if string.len(birlikName) < 4 then
		outputChatBox("[!]#FFFFFF Birliyin adı minimum 4 karakter içermelidir.", client, 255, 0, 0, true)
		playSoundFrontEnd(client, 4)
		return false
	elseif string.len(birlikName) > 36 then
		outputChatBox("[!]#FFFFFF Birliyin adı maksimum 36 karakter içermelidir.", client, 255, 0, 0, true)
		playSoundFrontEnd(client, 4)
		return false
	end
	
	if exports.rl_global:hasMoney(client, 10000) then
		factionName = birlikName
		factionType = tonumber(birlikType)
		dbQuery(function(qh, client)
			local getrow = dbPoll(qh, 0)
			if #getrow > 0 then
				outputChatBox("[!]#FFFFFF Bu birlik adı kullanılıyor.", client, 255, 0, 0, true)
				playSoundFrontEnd(client, 4)
				return false
			end
			
			local theTeam = createTeam(tostring(factionName))
			if theTeam then
				dbExec(mysql:getConnection(), "INSERT INTO factions (name, bankbalance, type) VALUES (?, 0, ?)", factionName, factionType)
				dbQuery(function(qh, client)
					local result = dbPoll(qh, 0)
					local id = result[1].id
					exports.rl_pool:allocateElement(theTeam, id)
					
					local updateQuery = [[
						UPDATE factions SET
							rank_1 = 'Dinamik Rütbe #1', rank_2 = 'Dinamik Rütbe #2', rank_3 = 'Dinamik Rütbe #3', rank_4 = 'Dinamik Rütbe #4', 
							rank_5 = 'Dinamik Rütbe #5', rank_6 = 'Dinamik Rütbe #6', rank_7 = 'Dinamik Rütbe #7', rank_8 = 'Dinamik Rütbe #8', 
							rank_9 = 'Dinamik Rütbe #9', rank_10 = 'Dinamik Rütbe #10', rank_11 = 'Dinamik Rütbe #11', rank_12 = 'Dinamik Rütbe #12', 
							rank_13 = 'Dinamik Rütbe #13', rank_14 = 'Dinamik Rütbe #14', rank_15 = 'Dinamik Rütbe #15', rank_16 = 'Dinamik Rütbe #16', 
							rank_17 = 'Dinamik Rütbe #17', rank_18 = 'Dinamik Rütbe #18', rank_19 = 'Dinamik Rütbe #19', rank_20 = 'Dinamik Rütbe #20',  
							motd = 'Birliğe hoş geldiniz.', note = '' 
						WHERE id = ?
					]]
					dbExec(mysql:getConnection(), updateQuery, id)
					
					outputChatBox("[!]#FFFFFF Başarıyla [" .. factionName .. "] isimli birliğiniz kuruldu.", client, 0, 255, 0, true)
					setElementData(theTeam, "type", tonumber(factionType))
					setElementData(theTeam, "id", tonumber(id))
					setElementData(theTeam, "money", 0)
					
					local factionRanks = {}
					local factionWages = {}
					for i = 1, 20 do
						factionRanks[i] = "Dinamik Rütbe #" .. i
						factionWages[i] = 100
					end
					setElementData(theTeam, "ranks", factionRanks)
					setElementData(theTeam, "wages", factionWages)
					setElementData(theTeam, "motd", "Birliğe hoş geldiniz.")
					setElementData(theTeam, "note", "")
					
					local updateCharacterQuery = [[
						UPDATE characters SET 
							faction_leader = 1, faction_id = ?, faction_rank = 1, faction_phone = NULL, custom_duty = 0 
						WHERE id = ?
					]]
					dbExec(mysql:getConnection(), updateCharacterQuery, id, getElementData(client, "dbid"))
					setPlayerTeam(client, theTeam)
					setElementData(client, "faction", id)
					setElementData(client, "factionrank", 1)
					setElementData(client, "factionleader", 1)
					setElementData(client, "factionphone", nil)
					setElementData(client, "custom_duty", 0)
					triggerEvent("duty.offDuty", client)
					triggerEvent("onPlayerJoinFaction", client, theTeam)
					
					exports.rl_global:takeMoney(client, 10000)
					exports.rl_global:sendMessageToAdmins("[BIRLIK-KUR] " .. getPlayerName(client):gsub("_", " ") .. " isimli oyuncu [" .. factionName .. "] (" .. id .. ") isimli yeni birlik yarattı.")
				end, {client}, mysql:getConnection(), "SELECT LAST_INSERT_ID() AS id")
			else
				outputChatBox("[!]#FFFFFF Bu birlik adı kullanılıyor.", client, 255, 0, 0, true)
				playSoundFrontEnd(client, 4)
			end
		end, {client}, mysql:getConnection(), "SELECT * FROM factions WHERE name = ?", factionName)
	else
		outputChatBox("[!]#FFFFFF Maalesef birlik kuracak paranız yok.", client, 255, 0, 0, true)
		playSoundFrontEnd(client, 4)
	end
end)