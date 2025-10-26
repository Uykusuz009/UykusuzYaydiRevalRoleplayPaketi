unemployedPay = 150

function createFaction(thePlayer, commandName, factionType, ...)
    if exports.rl_integration:isPlayerLeaderAdmin(thePlayer) then
        if not (...) then
            outputChatBox("KULLANIM: /" .. commandName .. " [Birlik Tipi | 0=GANG, 1=MAFIA, 2=LAW, 3=GOV, 4=MED, 5=OTHER, 6=NEWS, 7=MECHANIC] [Birlik Adı]", thePlayer, 255, 194, 14)
        else
            factionType = tonumber(factionType)
            if not factionType or factionType < 0 or factionType > 7 then
                outputChatBox("[!]#FFFFFF Geçersiz birlik tipi.", thePlayer, 255, 0, 0, true)
				playSoundFrontEnd(thePlayer, 4)
                return
            end
            
            local factionName = table.concat({...}, " ")
            if factionName == "" then
                outputChatBox("[!]#FFFFFF Birlik adı yazmalısınız.", thePlayer, 255, 0, 0, true)
				playSoundFrontEnd(thePlayer, 4)
                return
            end
            
            dbQuery(function(qh, client, factionType, factionName)
                local getrow = dbPoll(qh, 0)
                if #getrow > 0 then
                    outputChatBox("[!]#FFFFFF Bu birlik adı kullanılıyor.", client, 255, 0, 0, true)
                    playSoundFrontEnd(client, 4)
                    return false
                end
                
                local theTeam = createTeam(tostring(factionName))
                if theTeam then
                    dbExec(mysql:getConnection(), "INSERT INTO factions (name, bankbalance, type) VALUES (?, 0, ?)", factionName, factionType)
                    dbQuery(function(qh, client, factionType, factionName)
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
                        
                        outputChatBox("[!]#FFFFFF Başarıyla [" .. factionName .. "] isimli birlik kuruldu.", client, 0, 255, 0, true)
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
						
						exports.rl_global:sendMessageToAdmins("[ADM] " .. exports.rl_global:getPlayerFullAdminTitle(client) .. " isimli yetkili [" .. factionName .. "] (" .. id .. ") isimli yeni birlik yarattı.")
                    end, {thePlayer, factionType, factionName}, mysql:getConnection(), "SELECT LAST_INSERT_ID() AS id")
                else
                    outputChatBox("[!]#FFFFFF Bu birlik adı kullanılıyor.", client, 255, 0, 0, true)
                    playSoundFrontEnd(client, 4)
                end
            end, {thePlayer, factionType, factionName}, mysql:getConnection(), "SELECT * FROM factions WHERE name = ?", factionName)
        end
    end
end
addCommandHandler("makefaction", createFaction, false, false)

function adminRenameFaction(thePlayer, commandName, factionID, ...)
	if exports.rl_integration:isPlayerLeaderAdmin(thePlayer) then
		if not (factionID) or not (...)  then
			outputChatBox("KULLANIM: /" .. commandName .. " [Birlik ID] [Birlik İsmi]", thePlayer, 255, 194, 14)
		else
			factionID = tonumber(factionID)
			if factionID and factionID > 0 then
				local theTeam = exports.rl_pool:getElement("team", factionID)
				if (theTeam) then
					local factionName = table.concat({...}, " ")
					dbExec(mysql:getConnection(), "UPDATE factions SET name = ? WHERE id = ?", factionName, factionID)
					local oldName = getTeamName(theTeam)
					setTeamName(theTeam, factionName)
					exports.rl_global:sendMessageToAdmins(exports.rl_global:getPlayerFullAdminTitle(thePlayer) .. " renamed faction '" .. oldName .. "' to '" .. factionName .. "'.")
				else
					outputChatBox("[!]#FFFFFF Geçersiz Birlik ID.", thePlayer, 255, 0, 0, true)
				end
			else
				outputChatBox("[!]#FFFFFF Geçersiz Birlik ID.", thePlayer, 255, 0, 0, true)
			end
		end
	end
end
addCommandHandler("renamefaction", adminRenameFaction, false, false)

function adminSetPlayerFaction(thePlayer, commandName, partialNick, factionID)
	if exports.rl_integration:isPlayerLeaderAdmin(thePlayer) then
		factionID = tonumber(factionID)
		if not (partialNick) or not (factionID) then
			outputChatBox("KULLANIM: /" .. commandName .. " [Karakter Adı / ID] [Faction ID (-1 for none)]", thePlayer, 255, 194, 14)
		else
			local targetPlayer, targetPlayerNick = exports.rl_global:findPlayerByPartialNick(thePlayer, partialNick)
			
			if targetPlayer then
				local theTeam = exports.rl_pool:getElement("team", factionID)
				if not theTeam and factionID ~= -1 then
					outputChatBox("[!]#FFFFFF Geçersiz Birlik ID.", thePlayer, 255, 0, 0, true)
					return
				end
				
				if dbExec(mysql:getConnection(), "UPDATE characters SET faction_leader = 0, faction_id = ?, faction_rank = 1, faction_phone = NULL, custom_duty = 0 WHERE id = ?", factionID, getElementData(targetPlayer, "dbid")) then
					setPlayerTeam(targetPlayer, theTeam)
					if factionID > 0 then
						setElementData(targetPlayer, "faction", factionID)
						setElementData(targetPlayer, "factionrank", 1)
						setElementData(targetPlayer, "factionphone", nil)
						setElementData(targetPlayer, "factionleader", 0)
						triggerEvent("duty.offDuty", targetPlayer)
						
						outputChatBox("[!]#FFFFFF " .. targetPlayerNick .. " isimli oyuncu " .. getTeamName(theTeam) .. " (" .. factionID .. ") isimli birliğine eklendi.", thePlayer, 0, 255, 0, true)
						outputChatBox("[!]#FFFFFF " .. exports.rl_global:getPlayerFullAdminTitle(thePlayer) .. " isimli yetkili sizi " .. getTeamName(theTeam) .. " (" .. factionID .. ") isimli birliğe ekledi.", targetPlayer, 0, 0, 255, true)
						
						triggerEvent("onPlayerJoinFaction", targetPlayer, theTeam)
						outputChatBox("You were set to Faction '" .. getTeamName(theTeam) .. "'.", targetPlayer, 255, 194, 14)
					else
						local citizenTeam = getTeamFromName("Vatandaş")
						setPlayerTeam(targetPlayer, citizenTeam)
						setElementData(targetPlayer, "faction", -1)
						setElementData(targetPlayer, "factionrank", 1)
						setElementData(targetPlayer, "factionphone", nil)
						setElementData(targetPlayer, "factionleader", 0)
						if getElementData(targetPlayer, "duty") then
							takeAllWeapons(targetPlayer)
							setElementData(targetPlayer, "duty", false)
							setElementData(targetPlayer, "custom_duty", 0)
						end
						
						outputChatBox("[!]#FFFFFF " .. targetPlayerNick .. " isimli oyuncu " .. getTeamName(theTeam) .. " (" .. factionID .. ") isimli birliğine eklendi.", thePlayer, 0, 255, 0, true)
						outputChatBox("[!]#FFFFFF " .. exports.rl_global:getPlayerFullAdminTitle(thePlayer) .. " isimli yetkili sizi " .. getTeamName(theTeam) .. " (" .. factionID .. ") isimli birliğe ekledi.", targetPlayer, 0, 0, 255, true)
					end
				end
			end
		end
	end
end
addCommandHandler("setfaction", adminSetPlayerFaction, false, false)

function adminSetFactionLeader(thePlayer, commandName, partialNick, factionID)
	if exports.rl_integration:isPlayerLeaderAdmin(thePlayer) then
		factionID = tonumber(factionID)
		if not (partialNick) or not (factionID)  then
			outputChatBox("KULLANIM: /" .. commandName .. " [Karakter Adı / ID] [Birlik ID]", thePlayer, 255, 194, 14)
		elseif factionID > 0 then
			local targetPlayer, targetPlayerNick = exports.rl_global:findPlayerByPartialNick(thePlayer, partialNick)
			if targetPlayer then
				local theTeam = exports.rl_pool:getElement("team", factionID)
				if not theTeam then
					outputChatBox("[!]#FFFFFF Geçersiz Birlik ID.", thePlayer, 255, 0, 0, true)
					return
				end
				
				if dbExec(mysql:getConnection(), "UPDATE characters SET faction_leader = 1, faction_id = ?, faction_rank = 1, faction_phone = NULL, custom_duty = 0 WHERE id = ?", tonumber(factionID), getElementData(targetPlayer, "dbid")) then
					setPlayerTeam(targetPlayer, theTeam)
					setElementData(targetPlayer, "faction", factionID)
					setElementData(targetPlayer, "factionrank", 1)
					setElementData(targetPlayer, "factionleader", 1)
					setElementData(targetPlayer, "factionphone", nil)
					triggerEvent("duty.offDuty", targetPlayer)
					
					outputChatBox("[!]#FFFFFF Başarıyla " .. targetPlayerNick .. " isimli oyuncu " .. getTeamName(theTeam) .. " (" .. factionID .. ") isimli birliğe eklendi.", thePlayer, 0, 255, 0, true)
					outputChatBox("[!]#FFFFFF " .. exports.rl_global:getPlayerFullAdminTitle(thePlayer) .. " isimli yetkili sizi " .. getTeamName(theTeam) .. " (" .. factionID .. ") isimli birliğe ekledi.", targetPlayer, 0, 0, 255, true)
					triggerEvent("onPlayerJoinFaction", targetPlayer, theTeam)
				else
					outputChatBox("[!]#FFFFFF Geçersiz Birlik ID.", thePlayer, 255, 0, 0, true)
				end
			end
		end
	end
end
addCommandHandler("setfactionleader", adminSetFactionLeader, false, false)

function adminSetFactionRank(thePlayer, commandName, partialNick, factionRank)
	if exports.rl_integration:isPlayerLeaderAdmin(thePlayer) then
		factionRank = math.ceil(tonumber(factionRank) or -1)
		if not (partialNick) or not (factionRank)  then
			outputChatBox("KULLANIM: /" .. commandName .. " [Karakter Adı / ID] [Faction Rank, 1-20]", thePlayer, 255, 194, 14)
		elseif factionRank >= 1 and factionRank <= 20 then
			local targetPlayer, targetPlayerNick = exports.rl_global:findPlayerByPartialNick(thePlayer, partialNick)
			
			if targetPlayer then
				local theTeam = getPlayerTeam(targetPlayer)
				if not theTeam or getTeamName(theTeam) == "Vatandaş" then
					outputChatBox("Player is not in a faction.", thePlayer, 255, 0, 0)
					return
				end
				
				if dbExec(mysql:getConnection(), "UPDATE characters SET faction_rank = " .. factionRank .. " WHERE id = " .. getElementData(targetPlayer, "dbid")) then
					setElementData(targetPlayer, "factionrank", factionRank, true)
					
					outputChatBox("Player " .. targetPlayerNick .. " is now rank " .. factionRank .. ".", thePlayer, 0, 255, 0)
					outputChatBox("Admin " .. getPlayerName(thePlayer):gsub("_"," ") .. " set you to rank " .. factionRank .. ".", targetPlayer, 0, 255, 0)
				else
					outputChatBox("Error #125151 - Report on Mantis.", thePlayer, 255, 0, 0)
				end
			end
		else
			outputChatBox("Invalid Rank - valid ones are 1 to 20", thePlayer, 255, 0, 0)
		end
	end
end
addCommandHandler("setfactionrank", adminSetFactionRank, false, false)

function adminDeleteFaction(thePlayer, commandName, factionID)
	if exports.rl_integration:isPlayerLeaderAdmin(thePlayer) then
		if not (factionID)  then
			outputChatBox("KULLANIM: /" .. commandName .. " [Birlik ID]", thePlayer, 255, 194, 14)
		else
			factionID = tonumber(factionID)
			if factionID and factionID > 0 then
				local theTeam = exports.rl_pool:getElement("team", factionID)
				
				if (theTeam) then
					
					dbExec(mysql:getConnection(), "DELETE FROM factions WHERE id='" .. factionID .. "'")
					
					outputChatBox("Faction #" .. factionID .. " was deleted.", thePlayer, 0, 255, 0)
					local citizenTeam = getTeamFromName("Vatandaş")
					for key, value in pairs(getPlayersInTeam(theTeam)) do
						setPlayerTeam(value, citizenTeam)
						setElementData(value, "faction", -1, true)
					end
					destroyElement(theTeam)
				else
					outputChatBox("[!]#FFFFFF Geçersiz Birlik ID.", thePlayer, 255, 0, 0, true)
				end
			else
				outputChatBox("[!]#FFFFFF Geçersiz Birlik ID.", thePlayer, 255, 0, 0, true)
			end
		end
	end
end
addCommandHandler("delfaction", adminDeleteFaction, false, false)

function adminShowFactions(thePlayer)
	if (exports.rl_integration:isPlayerTrialAdmin(thePlayer)) then
		dbQuery(function(qh)
			local result = dbPoll(qh, 0)
			if result then
				local factions = {}
				
				for _, row in ipairs(result) do
					local team = getTeamFromName(row.name)
					local membersCount = team and #getPlayersInTeam(team) or "?"
					table.insert(factions, { row.id, row.name, row.type, membersCount .. " / " .. row.members })
				end
				
				triggerClientEvent(thePlayer, "showFactionList", root, factions)
			else
				outputChatBox("Error 300001 - Report on forums.", thePlayer, 255, 0, 0)
			end
		end, mysql:getConnection(), "SELECT id, name, type, (SELECT COUNT(*) FROM characters c WHERE c.faction_id = f.id) AS members FROM factions f ORDER BY id ASC")
	end
end
addCommandHandler("showfactions", adminShowFactions, false, false)

function adminShowFactionOnlinePlayers(thePlayer, commandName, factionID)
	if exports.rl_integration:isPlayerTrialAdmin(thePlayer) then
		if not (factionID)  then
			outputChatBox("KULLANIM: /" .. commandName .. " [Birlik ID]", thePlayer, 255, 194, 14)
		else
			factionID = tonumber(factionID)
			if factionID and factionID > 0 then
				local theTeam = exports.rl_pool:getElement("team", factionID)
				local theTeamName = getTeamName(theTeam)
				local teamPlayers = getPlayersInTeam(theTeam)
				
				if #teamPlayers == 0 then
					outputChatBox("There are no players online in faction '" ..  theTeamName  .. "'", thePlayer, 255, 194, 14)
				else
					local teamRanks = getElementData(theTeam, "ranks")
					outputChatBox("Players online in faction '" ..  theTeamName  .. "':", thePlayer, 255, 194, 14)
					for k, teamPlayer in ipairs(teamPlayers) do
						local leader = ""
						local playerRank = teamRanks [getElementData(teamPlayer, "factionrank")]
						if (getElementData(teamPlayer, "factionleader") == 1) then
							leader = "LEADER "
						end
						outputChatBox("" .. leader .. " " ..  getPlayerName(teamPlayer)  .. " - " .. playerRank, thePlayer, 255, 194, 14)
					end
				end
			else
				outputChatBox("Faction not found.", thePlayer, 255, 194, 14)
			end
		end
	end
end
addCommandHandler("showfactionplayers", adminShowFactionOnlinePlayers, false, false)

function callbackAdminPlayersFaction(teamID)
	adminShowFactionOnlinePlayers(client, "showfactionplayers", teamID)
end
addEvent("faction:admin:showplayers", true)
addEventHandler("faction:admin:showplayers", root, callbackAdminPlayersFaction)

addEvent('faction:admin:showf3', true)
addEventHandler('faction:admin:showf3', root, function(id, fromF3)
	if exports.rl_integration:isPlayerTrialAdmin(client) then
		showFactionMenuEx(client, id, fromF3)
	end
end)

function setFactionMoney(thePlayer, commandName, factionID, amount)
	if (exports.rl_integration:isPlayerGeneralAdmin(thePlayer)) then
		if not (factionID) or not (amount)  then
			outputChatBox("KULLANIM: /" .. commandName .. " [Birlik ID] [Money]", thePlayer, 255, 194, 14)
		else
			factionID = tonumber(factionID)
			if factionID and factionID > 0 then
				local theTeam = exports.rl_pool:getElement("team", factionID)
				amount = tonumber(amount) or 0
				if amount and amount > 500000*2 then
					outputChatBox("For security reason, you're not allowed to set more than $1,000,000 at once to a faction.", thePlayer, 255, 0, 0)
					return false
				end
				
				if (theTeam) then
					if exports.rl_global:setMoney(theTeam, amount) then
						outputChatBox("Set faction '" .. getTeamName(theTeam) .. "'s money to " .. amount .. " $.", thePlayer, 255, 194, 14)
					else
						outputChatBox("Could not set money to that faction.", thePlayer, 255, 194, 14)
					end
				else
					outputChatBox("[!]#FFFFFF Geçersiz Birlik ID.", thePlayer, 255, 0, 0, true)
				end
			else
				outputChatBox("[!]#FFFFFF Geçersiz Birlik ID.", thePlayer, 255, 0, 0, true)
			end
		end
	end
end
addCommandHandler("setfactionmoney", setFactionMoney, false, false)

function setFactionBudget(thePlayer, commandName, factionID, amount)
	if getPlayerTeam(thePlayer) == getTeamFromName("Los Santos President") and getElementData(thePlayer, "factionrank") >= 15 then
		local amount = tonumber(amount)
		if not factionID or not amount or amount < 0 then
			outputChatBox("KULLANIM: /" .. commandName .. " [Birlik ID] [Money]", thePlayer, 255, 194, 14)
		else
			factionID = tonumber(factionID)
			if factionID and factionID > 0 then
				local theTeam = exports.rl_pool:getElement("team", factionID)
				amount = tonumber(amount)
				
				if (theTeam) then
					if getElementData(theTeam, "type") >= 2 and getElementData(theTeam, "type") <= 6 then
						if exports.rl_global:takeMoney(getPlayerTeam(thePlayer), amount) then
							exports.rl_global:giveMoney(theTeam, amount)
							outputChatBox("You added $" .. exports.rl_global:formatMoney(amount) .. " to the budget of '" .. getTeamName(theTeam) .. "' (Total: " .. exports.rl_global:getMoney(theTeam) .. ").", thePlayer, 255, 194, 14)
							dbExec(mysql:getConnection(),  "INSERT INTO wiretransfers (`from`, `to`, `amount`, `reason`, `type`) VALUES (" .. -getElementData(getPlayerTeam(thePlayer), "id") .. ", " .. -getElementData(theTeam, "id") .. ", " .. amount .. ", '', 8)")
						else
							outputChatBox("You can't afford this.", thePlayer, 255, 194, 14)
						end
					else
						outputChatBox("You can't set a budget for that faction.", thePlayer, 255, 194, 14)
					end
				else
					outputChatBox("[!]#FFFFFF Geçersiz Birlik ID.", thePlayer, 255, 0, 0, true)
				end
			else
				outputChatBox("[!]#FFFFFF Geçersiz Birlik ID.", thePlayer, 255, 0, 0, true)
			end
		end
	end
end
addCommandHandler("setbudget", setFactionBudget, false, false)

function setTax(thePlayer, commandName, amount)
	if getPlayerTeam(thePlayer) == getTeamFromName("Los Santos President") and getElementData(thePlayer, "factionrank") >= 15 then
		local amount = tonumber(amount)
		if not amount or amount < 0 or amount > 30 then
			outputChatBox("KULLANIM: /" .. commandName .. " [0-30%]", thePlayer, 255, 194, 14)
		else
			exports.rl_global:setTaxAmount(amount)
			outputChatBox("New Tax is " .. amount .. "%", thePlayer, 0, 255, 0)
		end
	end
end
addCommandHandler("settax", setTax, false, false)

function setIncomeTax(thePlayer, commandName, amount)
	if getPlayerTeam(thePlayer) == getTeamFromName("Los Santos President") and getElementData(thePlayer, "factionrank") >= 15 then
		local amount = tonumber(amount)
		if not amount or amount < 0 or amount > 25 then
			outputChatBox("KULLANIM: /" .. commandName .. " [0-25%]", thePlayer, 255, 194, 14)
		else
			exports.rl_global:setIncomeTaxAmount(amount)
			outputChatBox("New Income Tax is " .. amount .. "%", thePlayer, 0, 255, 0)
		end
	end
end
addCommandHandler("setincometax", setIncomeTax, false, false)

function setWelfare(thePlayer, commandName, amount)
	if getPlayerTeam(thePlayer) == getTeamFromName("Los Santos President") and getElementData(thePlayer, "factionrank") >= 15 then
		local amount = tonumber(amount)
		if not amount or amount <= 0 then
			outputChatBox("KULLANIM: /" .. commandName .. " [Money]", thePlayer, 255, 194, 14)
		elseif dbExec(mysql:getConnection(),  "UPDATE settings SET value = " .. unemployedPay .. " WHERE name = 'welfare'") then
			unemployedPay = amount
			outputChatBox("New Welfare is $" .. exports.rl_global:formatMoney(unemployedPay) .. "/payday", thePlayer, 0, 255, 0)
		else
			outputChatBox("Error 129314 - Report on Mantis.", thePlayer, 255, 0, 0)
		end
	end
end
addCommandHandler("setwelfare", setWelfare, false, false)

function issueGovLicense(thePlayer, commandName, type, ...)
	local licenseTypes = {"Business License - Regular", "Business License - Premium", "Adult Entertainment License", "Gambling License", "Liquor License"}
	if getPlayerTeam(thePlayer) == getTeamFromName("Los Santos President") and getElementData(thePlayer, "factionrank") >= 3 then
		local type = tonumber(type)
		if not type or not licenseTypes[type] or not ... then
			outputChatBox("KULLANIM: /" .. commandName .. " [type] [biz name]", thePlayer, 255, 194, 14)
			for k, v in ipairs(licenseTypes) do
			outputChatBox("" .. k .. ": " .. v, thePlayer, 255, 194, 14)
			end
		else
			local text = licenseTypes[type] .. " - " .. table.concat({...}, " ")
			local success, error = exports.rl_global:giveItem(thePlayer, 80, text)
			if success then
				outputChatBox("Created a " .. text .. ".", thePlayer, 0, 255, 0)
			else
				outputChatBox(error, thePlayer, 255, 0, 0)
			end
		end
	end
end
addCommandHandler("govlicense", issueGovLicense, false, false)

--

function respawnFactionVehicles(thePlayer, commandName, factionID)
	if (exports.rl_integration:isPlayerTrialAdmin(thePlayer)) then
		local factionID = tonumber(factionID)
		if (factionID) and (factionID > 0) then
			local theTeam = exports.rl_pool:getElement("team", factionID)
			if (theTeam) then
				for key, value in ipairs(exports.rl_pool:getPoolElementsByType("vehicle")) do
					local faction = tonumber(getElementData(value, "faction"))
					if (faction == factionID and not getVehicleOccupant(value, 0) and not getVehicleOccupant(value, 1) and not getVehicleOccupant(value, 2) and not getVehicleOccupant(value, 3) and not getVehicleTowingVehicle(value)) then
						respawnVehicle(value)
						setElementInterior(value, getElementData(value, "interior"))
						setElementDimension(value, getElementData(value, "dimension"))
					end
				end
				
				local hiddenAdmin = tonumber(getElementData(thePlayer, "hidden_admin"))
				local adminTitle = exports.rl_global:getPlayerAdminTitle(thePlayer)
				local username = getPlayerName(thePlayer):gsub("_"," ")
				
				for _, player in ipairs(getPlayersInTeam(theTeam)) do
					outputChatBox(">> Tüm birlik araçları " .. (not hiddenAdmin and adminTitle .. " " .. username or "Gizli Yetkili") .. " tarafından yenilendi.", player, 255, 194, 14)
				end
				
				exports.rl_global:sendMessageToAdmins("[ADM] " .. tostring(adminTitle) .. " " .. username .. " respawned all unoccupied faction vehicles for faction ID " .. factionID .. ".")
			else
				outputChatBox("Invalid faction ID.", thePlayer, 255, 0, 0, false)
			end
		else
			outputChatBox("KULLANIM: /" .. commandName .. " [Birlik ID]", thePlayer, 255, 194, 14)
		end
	end
end
addCommandHandler("respawnfaction", respawnFactionVehicles, false, false)

function adminDutyStart()
	dbQuery(function(maxQuery)
		local maxResult = dbPoll(maxQuery, 0)
		if maxResult then
			local maxIndex = maxResult[1] and maxResult[1].id or 0
			dbQuery(function(factionQuery)
				local factionResult = dbPoll(factionQuery, 0)
				if factionResult then
					local dutyAllow = {}
					local dutyAllowChanges = {}
					local i = 0
					local totalFactions = #factionResult
					local processedFactions = 0
					
					for _, faction in ipairs(factionResult) do
						dutyAllow[i + 1] = { faction.id, faction.name, {} }
						
						dbQuery(function(dutyQuery, factionIndex)
							local dutyResult = dbPoll(dutyQuery, 0)
							if dutyResult then
								for _, duty in ipairs(dutyResult) do
									table.insert(dutyAllow[factionIndex][3], { duty.id, tonumber(duty.itemID), duty.itemValue })
								end
							end
							
							processedFactions = processedFactions + 1
							if processedFactions == totalFactions then
								setElementData(resourceRoot, "maxIndex", maxIndex)
								setElementData(resourceRoot, "dutyAllowTable", dutyAllow)
							end
						end, { i + 1 }, mysql:getConnection(), "SELECT * FROM duty_allowed WHERE faction = ?", faction.id)
						
						i = i + 1
					end
				else
					outputDebugString("[Factions] ERROR: Duty allow permissions failed.")
				end
			end, mysql:getConnection(), "SELECT id, name FROM factions WHERE type >= 2 ORDER BY id ASC")
		else
			outputDebugString("[Factions] ERROR: Duty allow permissions failed.")
		end
	end, mysql:getConnection(), "SELECT id FROM duty_allowed ORDER BY id DESC LIMIT 1")
end
addEventHandler("onResourceStart", resourceRoot, adminDutyStart)

function getAllowList(factionID)
	local factionID = tonumber(factionID)
	if factionID then
		for k,v in pairs(dutyAllow) do
			if tonumber(v[1]) == factionID then
				key = k
				break
			end
		end
		return dutyAllow[key][3]
	end
end

function adminDuty(thePlayer)
	if (exports.rl_integration:isPlayerLeaderAdmin(thePlayer)) then
		if not getElementData(resourceRoot, "dutyadmin") and type(dutyAllow) == "table" then
			triggerClientEvent(thePlayer, "adminDutyAllow", resourceRoot, dutyAllow, dutyAllowChanges)
			setElementData(resourceRoot, "dutyadmin", true)
		elseif type(dutyAllow) ~= "table" then
			outputChatBox("There was a issue with the startup caching of this resource. Contact a Scripter.", thePlayer, 255, 0, 0)
		else
			outputChatBox("Oops! Someone is already editing duty permissions. Sorry!", thePlayer, 255, 0, 0) -- No time to set up proper syncing + kinda not needed.
		end
	end
end
addCommandHandler("dutyadmin", adminDuty, false, false)

function updateTable(newTable, changesTable)
	dutyAllow = newTable
	dutyAllowChanges = changesTable
	removeElementData(resourceRoot, "dutyadmin")
	setElementData(resourceRoot, "dutyAllowTable", dutyAllow)
end
addEvent("dutyAdmin:Save", true)
addEventHandler("dutyAdmin:Save", resourceRoot, updateTable)


function birlikOnayla(thePlayer, commandName, factionID, onay)
	if (exports.rl_integration:isPlayerLeaderAdmin(thePlayer)) then
		if not (factionID) or not (onay)  then
			outputChatBox("KULLANIM: /" .. commandName .. " [Birlik ID] [1 / 0]", thePlayer, 255, 194, 14)
		else
			factionID = tonumber(factionID)
			if factionID and factionID > 0 then
				local theTeam = exports.rl_pool:getElement("team", factionID)
				if (theTeam) then
					dbExec(mysql:getConnection(),"UPDATE factions SET onay='" .. tonumber(onay) .. "' WHERE id='" .. factionID .. "'")
					local oldName = getTeamName(theTeam)
					setElementData(theTeam, "birlik_onay", tonumber(onay))
					
					if tonumber(onay) == 1 then
						exports.rl_global:sendMessageToAdmins(exports.rl_global:getPlayerFullAdminTitle(thePlayer) .. " '" .. oldName .. "' isimli birliği onayladı!")
					elseif tonumber(onay) == 0 then
						exports.rl_global:sendMessageToAdmins(exports.rl_global:getPlayerFullAdminTitle(thePlayer) .. " '" .. oldName .. "' isimli birliği onayını kaldırdı!")
					end
				else
					outputChatBox("[!]#FFFFFF Geçersiz Birlik ID.", thePlayer, 255, 0, 0, true)
				end
			else
				outputChatBox("[!]#FFFFFF Geçersiz Birlik ID.", thePlayer, 255, 0, 0, true)
			end
		end
	end
end
addCommandHandler("birlikonay", birlikOnayla)

function aracimiBirligeVer(thePlayer, commandName, vehID)
	if vehID then
		local playerID = getElementData(thePlayer, "dbid")
		local vehElement = exports.rl_pool:getElement("vehicle", vehID)
		local vehOwner = getElementData(vehElement, "owner")
		local vehFaction = getElementData(vehElement, "faction")
		if vehFaction == -1 then
			if (vehOwner == playerID) or (exports.rl_integration:isPlayerDeveloper(thePlayer)) then
				local faction = getElementData(thePlayer, "faction")
				if faction then
					local elementSet = setElementData(vehElement, "faction", faction)
					local query = dbExec(mysql:getConnection(), "UPDATE vehicles SET faction = ? WHERE id = ?", faction, vehID)
					if elementSet and query then
						exports["rl_items"]:deleteAll(3, vehID)
						outputChatBox("[!]#FFFFFF Araçınız başarıyla birliğe verildi.", thePlayer, 0, 255, 0, true)
					else
						outputChatBox("[!]#FFFFFF Bir sorun oluştu.", thePlayer, 255, 0, 0, true)
						playSoundFrontEnd(thePlayer, 4)
					end
				else
					outputChatBox("[!]#FFFFFF Bir birlikde değilsiniz.", thePlayer, 255, 0, 0, true)
					playSoundFrontEnd(thePlayer, 4)
				end
			else
				outputChatBox("[!]#FFFFFF Araç size ait değil.", thePlayer, 255, 0, 0, true)
				playSoundFrontEnd(thePlayer, 4)
			end
		else
			outputChatBox("[!]#FFFFFF Araç artık birliğe aitdir.", thePlayer, 255, 0, 0, true)
			playSoundFrontEnd(thePlayer, 4)
		end
	else
		outputChatBox("KULLANIM: /" .. commandName .. " [Araç ID]", thePlayer, 255, 194, 14)
	end
end
addCommandHandler("abv", aracimiBirligeVer)

function aracimiBirlikGeriVer(thePlayer, commandName, vehID)
	if vehID then
		local playerID = getElementData(thePlayer, "dbid")
		local vehElement = exports.rl_pool:getElement("vehicle", vehID)
		local vehFaction = getElementData(vehElement, "faction")
		local vehOwner = getElementData(vehElement, "owner")
		local factionLeader = getElementData(thePlayer, "factionleader")
		local faction = getElementData(thePlayer, "faction")
		if faction then
			if (faction == vehFaction) or (vehOwner == playerID) or (exports.rl_integration:isPlayerDeveloper(thePlayer)) then
				if factionLeader == 1 then
					local elementSet = setElementData(vehElement, "faction", -1)
					local query = dbExec(mysql:getConnection(), "UPDATE vehicles SET faction = '-1' WHERE id = ?", vehID)
					if elementSet and query then
						outputChatBox("[!]#FFFFFF Araç başarıyla sahibine teslim edildi.", thePlayer, 0, 255, 0, true)
					else
						outputChatBox("[!]#FFFFFF Bir sorun oluştu.", thePlayer, 255, 0, 0, true)
						playSoundFrontEnd(thePlayer, 4)
					end
				else
					outputChatBox("[!]#FFFFFF Arabayı sahibine teslim etmek için lonca lideri olmanız gerekir.", thePlayer, 255, 0, 0, true)
					playSoundFrontEnd(thePlayer, 4)
				end
			else
				outputChatBox("[!]#FFFFFF Araç size ait değil.", thePlayer, 255, 0, 0, true)
				playSoundFrontEnd(thePlayer, 4)
			end
		else
			outputChatBox("[!]#FFFFFF Bir birlikde değilsiniz.", thePlayer, 255, 0, 0, true)
			playSoundFrontEnd(thePlayer, 4)
		end
	else
		outputChatBox("KULLANIM: /" .. commandName .. " [Araç ID]", thePlayer, 255, 194, 14)
	end
end
addCommandHandler("abg", aracimiBirlikGeriVer)