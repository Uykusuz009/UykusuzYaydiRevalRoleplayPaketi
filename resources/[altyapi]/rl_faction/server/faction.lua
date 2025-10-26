mysql = exports.rl_mysql

addEvent("onPlayerJoinFaction", false)
addEventHandler("onPlayerJoinFaction", root, function(theTeam)
	return
end)

locations = {}
custom = {}

function loadAllFactions(res)
	local counter = 0
	setElementData(resourceRoot, "DutyGUI", {})

	dbQuery(function(qh)
		local result = dbPoll(qh, 0)
		if result then
			for _, row in ipairs(result) do
				local id = tonumber(row.id)
				local name = row.name
				local money = tonumber(row.bankbalance)
				local factionType = tonumber(row.type)
				
				local theTeam = createTeam(tostring(name))
				if theTeam then
					exports.rl_pool:allocateElement(theTeam, id)
					setElementData(theTeam, "type", factionType)
					setElementData(theTeam, "money", money)
					setElementData(theTeam, "id", id)
					
					local factionRanks = {}
					local factionWages = {}
					for i = 1, 20 do
						factionRanks[i] = row['rank_' .. i]
						factionWages[i] = tonumber(row['wage_' .. i])
					end
					
					local motd = row.motd
					setElementData(theTeam, "ranks", factionRanks)
					setElementData(theTeam, "wages", factionWages)
					setElementData(theTeam, "motd", motd)
					setElementData(theTeam, "note", row.note == nil and "" or row.note)
					setElementData(theTeam, "fnote", row.fnote == nil and "" or row.fnote)
					setElementData(theTeam, "phone", row.phone ~= nil and row.phone or nil)
					setElementData(theTeam, "max_interiors", tonumber(row.max_interiors))

					custom[id] = {}
					dbQuery(function(qh2)
						local customResult = dbPoll(qh2, 0)
						if customResult then
							for _, customRow in ipairs(customResult) do
								local skins = fromJSON(tostring(customRow.skins)) or {}
								local locations = fromJSON(tostring(customRow.locations)) or {}
								local items = fromJSON(tostring(customRow.items)) or {}
								custom[id][tonumber(customRow.id)] = { customRow.id, customRow.name, skins, locations, items }
							end
							triggerEvent("Duty:updateDuty", root, custom)
						end
					end, mysql:getConnection(), "SELECT * FROM duty_custom WHERE factionid = ? ORDER BY id ASC", id)

					locations[id] = {}
					dbQuery(function(qh3)
						local locationResult = dbPoll(qh3, 0)
						if locationResult then
							for _, locationRow in ipairs(locationResult) do
								locations[id][tonumber(locationRow.id)] = { locationRow.id, locationRow.name, locationRow.x, locationRow.y, locationRow.z, locationRow.radius, locationRow.dimension, locationRow.interior, locationRow.vehicleid, locationRow.model }
							end
						end
					end, mysql:getConnection(), "SELECT * FROM duty_locations WHERE factionid = ? ORDER BY id ASC", id)
					counter = counter + 1
				end
			end
		end
	end, mysql:getConnection(), "SELECT * FROM factions ORDER BY id ASC")

	dbQuery(function(qh)
		local maxlResult = dbPoll(qh, 0)
		if maxlResult and maxlResult[1] and tonumber(maxlResult[1].id) then
			setElementData(resourceRoot, "maxlindex", tonumber(maxlResult[1].id))
		else
			setElementData(resourceRoot, "maxlindex", 0)
		end
	end, mysql:getConnection(), "SELECT id FROM duty_locations ORDER BY id DESC LIMIT 0, 1")

	dbQuery(function(qh)
		local maxcResult = dbPoll(qh, 0)
		if maxcResult and maxcResult[1] and tonumber(maxcResult[1].id) then
			setElementData(resourceRoot, "maxcindex", tonumber(maxcResult[1].id))
		else
			setElementData(resourceRoot, "maxcindex", 0)
		end
	end, mysql:getConnection(), "SELECT id FROM duty_custom ORDER BY id DESC LIMIT 0, 1")

	local citizenTeam = createTeam("Vatandaş", 255, 255, 255)
	exports.rl_pool:allocateElement(citizenTeam, -1)
	
	local players = exports.rl_pool:getPoolElementsByType("player")
	for _, player in ipairs(players) do
		dbQuery(function(qh)
			local result = dbPoll(qh, 0)
			if result and result[1] then
				setElementData(player, "factionMenu", 0)
				setElementData(player, "faction", tonumber(result[1].faction_id))
				setElementData(player, "factionrank", tonumber(result[1].faction_rank))
				setElementData(player, "factionphone", tonumber(result[1].faction_phone))
				setElementData(player, "factionleader", tonumber(result[1].faction_leader))
				setElementData(player, "factionPackages", type(result[1].faction_perks) == "string" and fromJSON(result[1].faction_perks) or {})
				
				setPlayerTeam(player, exports.rl_pool:getElement("team", result[1].faction_id) or citizenTeam)
			end
		end, mysql:getConnection(), "SELECT faction_id, faction_rank, faction_leader, faction_perks, faction_phone FROM characters WHERE name = ? LIMIT 1", getPlayerName(player))
	end
end
addEventHandler("onResourceStart", resourceRoot, loadAllFactions)

function hasPlayerAccessOverFaction(theElement, factionID)
	if (isElement(theElement)) then
		local realFactionID = getElementData(theElement, "faction") or -1
		local factionLeaderStatus = getElementData(theElement, "factionleader") or 0
		if tonumber(realFactionID) == tonumber(factionID) then
			if tonumber(factionLeaderStatus) == 1 then
				return true
			end
		end
	end
	return false
end

function getPlayerFaction(playerName, callback)
    local thePlayerElement = getPlayerFromName(playerName)
    local override = false
    
    if thePlayerElement then
        if not getElementData(thePlayerElement, "logged") then
            override = true
        else
            local playerFaction = getElementData(thePlayerElement, "faction")
            local playerFactionRank = getElementData(thePlayerElement, "factionrank")
            local playerFactionLeader = getElementData(thePlayerElement, "factionleader")
            local playerFactionPerks = getElementData(thePlayerElement, "factionPackages")
            
            callback({0, playerFaction, playerFactionRank, playerFactionLeader, playerFactionPerks, thePlayerElement})
            return
        end
    end
    
    if not thePlayerElement or override then
        dbQuery(function(qh)
            local result = dbPoll(qh, 0)
            if result and #result > 0 then
                local row = result[1]
                callback({1, tonumber(row["faction_id"]), tonumber(row["faction_rank"]), tonumber(row["faction_leader"]), (fromJSON(row["faction_perks"]) or {}), nil})
            else
                callback({2, -1, 20, 0, {}, nil})
            end
        end, mysql:getConnection(), "SELECT faction_id, faction_rank, faction_perks, faction_leader FROM characters WHERE name = ?", playerName)
    end
end

function bindKeys()
	local players = exports.rl_pool:getPoolElementsByType("player")
	for k, arrayPlayer in ipairs(players) do
		if not (isKeyBound(arrayPlayer, "F3", "down", showFactionMenu)) then
			bindKey(arrayPlayer, "F3", "down", showFactionMenu)
		end
	end
end

function bindKeysOnJoin()
	bindKey(source, "F3", "down", showFactionMenu)
end
addEventHandler("onResourceStart", resourceRoot, bindKeys)
addEventHandler("onPlayerJoin", root, bindKeysOnJoin)

function showFactionMenu(source)
	showFactionMenuEx(source)
end

function showFactionMenuEx(source, factionID, fromShowF)
    local logged = getElementData(source, "logged")
    
    if (logged) then
        local menuVisible = getElementData(source, "factionMenu")
        
        if (menuVisible == 0) then
            local factionID = factionID or getElementData(source, "faction")
            
            if (factionID ~= -1) then
                local theTeam = exports.rl_pool:getElement("team", factionID)
                dbQuery(function(qh)
                    local result = dbPoll(qh, 0)
                    if result then
                        local memberUsernames = {}
                        local memberRanks = {}
                        local memberLeaders = {}
                        local memberOnline = {}
                        local memberLastLogin = {}
                        local memberPerks = {}
                        local factionRanks = getElementData(theTeam, "ranks")
                        local factionWages = getElementData(theTeam, "wages")
                        local motd = getElementData(theTeam, "motd")
                        local birliklevel = getElementData(theTeam, "birlik_level") or 1
                        local birlikonay = getElementData(theTeam, "birlik_onay") or 0
                        local note = hasPlayerAccessOverFaction(source, factionID) and getElementData(theTeam, "note")
                        local fnote = getElementData(theTeam, "fnote")
                        local vehicleIDs = {}
                        local vehicleModels = {}
                        local vehiclePlates = {}
                        local vehicleLocations = {}
                        local memberOnDuty = {}
                        local phone = getElementData(theTeam, "phone")
                        local memberPhones = phone and {} or nil

                        if (motd == "") then motd = nil end
                        
                        for i, row in ipairs(result) do
                            local playerName = row.name
                            memberUsernames[i] = playerName
                            memberRanks[i] = row.faction_rank
                            memberPerks[i] = type(row.faction_perks) == "string" and fromJSON(row.faction_perks) or {}
                            if phone and row.faction_phone ~= nil and tonumber(row.faction_phone) then
                                memberPhones[i] = ("%02d"):format(tonumber(row.faction_phone))
                            end

                            if (tonumber(row.faction_leader) == 1) then
                                memberLeaders[i] = true
                            else
                                memberLeaders[i] = false
                            end
                            
                            memberLastLogin[i] = tonumber(row.last_login)
                            if getPlayerFromName(playerName) then
                                local testingPlayer = getPlayerFromName(playerName)
                                local onlineState = getElementData(testingPlayer, "logged")
                                if (onlineState) then
                                    memberOnline[i] = true
                                    
                                    local dutydata = getElementData(testingPlayer, "duty")
                                    if dutydata then
                                        if (tonumber(dutydata)) then
                                            memberOnDuty[i] = true
                                        else
                                            memberOnDuty[i] = false    
                                        end
                                    end                                
                                end
                            else
                                memberOnline[i] = false
                                memberOnDuty[i] = false
                            end
                        end

                        local towstats = nil
                        if hasPlayerAccessOverFaction(source, factionID) then
                            dbQuery(function(vehicleqh)
                                local vehicleResult = dbPoll(vehicleqh, 0)
                                if vehicleResult then
                                    for j, row in ipairs(vehicleResult) do
                                        vehicleIDs[j] = row.id
                                        vehiclePlates[j] = row.plate
                                        local veh = exports.rl_pool:getElement("vehicle", row.id)
                                        vehicleModels[j] = exports.rl_global:getVehicleName(veh)
                                        local x, y, z = getElementPosition(veh)
                                        vehicleLocations[j] = getZoneName(x, y, z)
                                    end
                                end

                                if factionID == 4 then
                                    dbQuery(function(towstatsqh)
                                        local towstatsResult = dbPoll(towstatsqh, 0)
                                        if towstatsResult then
                                            towstats = {}
                                            for _, row in ipairs(towstatsResult) do
                                                if not towstats[row.name] then
                                                    towstats[row.name] = {}
                                                end
                                                
                                                towstats[row.name][tonumber(row.week)] = tonumber(row.count)
                                            end
                                        end

                                        setElementData(source, "factionMenu", 1)
                                        triggerClientEvent(source, "birlik:panel", source, motd, memberUsernames, memberRanks, hasPlayerAccessOverFaction(source, factionID) and memberPerks or {}, memberLeaders, memberOnline, memberLastLogin, factionRanks, factionWages, theTeam, note, fnote, vehicleIDs, vehicleModels, vehiclePlates, vehicleLocations, memberOnDuty, towstats, phone, memberPhones, fromShowF, factionID, birliklevel, birlikonay)
                                    end, mysql:getConnection(), "SELECT ceil(datediff(`date`, curdate() + INTERVAL 6-WEEKDAY(curdate()) DAY) / 7) AS week, c.name, count(vehicle) AS count FROM towstats t JOIN characters c ON t.character = c.id WHERE c.faction_id = 4 GROUP BY t.character, week ORDER BY t.character ASC, week DESC")
                                else
                                    setElementData(source, "factionMenu", 1)
                                    triggerClientEvent(source, "birlik:panel", source, motd, memberUsernames, memberRanks, hasPlayerAccessOverFaction(source, factionID) and memberPerks or {}, memberLeaders, memberOnline, memberLastLogin, factionRanks, factionWages, theTeam, note, fnote, vehicleIDs, vehicleModels, vehiclePlates, vehicleLocations, memberOnDuty, towstats, phone, memberPhones, fromShowF, factionID, birliklevel, birlikonay)
                                end
                            end, mysql:getConnection(), "SELECT id, model, currx, curry, currz, plate FROM vehicles WHERE faction = ? AND deleted = 0", factionID)
                        else
                            setElementData(source, "factionMenu", 1)
                            triggerClientEvent(source, "birlik:panel", source, motd, memberUsernames, memberRanks, hasPlayerAccessOverFaction(source, factionID) and memberPerks or {}, memberLeaders, memberOnline, memberLastLogin, factionRanks, factionWages, theTeam, note, fnote, vehicleIDs, vehicleModels, vehiclePlates, vehicleLocations, memberOnDuty, towstats, phone, memberPhones, fromShowF, factionID, birliklevel, birlikonay)
                        end
                    end
                end, mysql:getConnection(), "SELECT name, faction_rank, faction_perks, faction_leader, faction_phone, DATEDIFF(NOW(), last_login) AS last_login FROM characters WHERE faction_ID=? ORDER BY faction_rank DESC, name ASC", factionID)
            else
                outputChatBox("[!]#FFFFFF Hiç bir birlikde değilsiniz.", source, 255, 0, 0, true)
                playSoundFrontEnd(source, 4)
            end
        else
            triggerClientEvent(source, "hideFactionMenu", source)
        end
    end
end

function callbackUpdateRanks(ranks, wages)
	local theTeam = getPlayerTeam(client)
	local factionID = getElementData(theTeam, "id")
	if not hasPlayerAccessOverFaction(client, factionID) then
		outputChatBox("Not allowed, sorry.", client)
		return
	end
	
	for key, value in ipairs(ranks) do
		ranks[key] = (ranks[key])
	end
	
	if (wages) then
		for i = 1, 20 do
			wages[i] = math.min(2500, math.max(0, tonumber(wages[i]) or 0))
		end
		
		dbExec(mysql:getConnection(), "UPDATE factions SET wage_1='" .. wages[1] .. "', wage_2='" .. wages[2] .. "', wage_3='" .. wages[3] .. "', wage_4='" .. wages[4] .. "', wage_5='" .. wages[5] .. "', wage_6='" .. wages[6] .. "', wage_7='" .. wages[7] .. "', wage_8='" .. wages[8] .. "', wage_9='" .. wages[9] .. "', wage_10='" .. wages[10] .. "', wage_11='" .. wages[11] .. "', wage_12='" .. wages[12] .. "', wage_13='" .. wages[13] .. "', wage_14='" .. wages[14] .. "', wage_15='" .. wages[15] .. "', wage_16='" .. wages[16] .. "', wage_17='" .. wages[17] .. "', wage_18='" .. wages[18] .. "', wage_19='" .. wages[19] .. "', wage_20='" .. wages[20] .. "' WHERE id='" .. factionID .. "'")
		setElementData(theTeam, "wages", wages)
	end
	
	dbExec(mysql:getConnection(), "UPDATE factions SET rank_1='" .. ranks[1] .. "', rank_2='" .. ranks[2] .. "', rank_3='" .. ranks[3] .. "', rank_4='" .. ranks[4] .. "', rank_5='" .. ranks[5] .. "', rank_6='" .. ranks[6] .. "', rank_7='" .. ranks[7] .. "', rank_8='" .. ranks[8] .. "', rank_9='" .. ranks[9] .. "', rank_10='" .. ranks[10] .. "', rank_11='" .. ranks[11] .. "', rank_12='" .. ranks[12] .. "', rank_13='" .. ranks[13] .. "', rank_14='" .. ranks[14] .. "', rank_15='" .. ranks[15] .. "', rank_16='" .. ranks[16] .. "', rank_17='" .. ranks[17] .. "', rank_18='" .. ranks[18] .. "', rank_19='" .. ranks[19] .. "', rank_20='" .. ranks[20] .. "' WHERE id='" .. factionID .. "'")
	setElementData(theTeam, "ranks", ranks)
	
	outputChatBox("Faction information updated successfully.", source, 0, 255, 0)
	showFactionMenu(source)
end
addEvent("cguiUpdateRanks", true)
addEventHandler("cguiUpdateRanks", root, callbackUpdateRanks)


function callbackRespawnVehicles()
	local theTeam = getPlayerTeam(source)
	
	local factionCooldown = getElementData(theTeam, "cooldown")
	local theTeam = getPlayerTeam(client)
	local factionID = getElementData(theTeam, "id")
	if not hasPlayerAccessOverFaction(client, factionID) then
		outputChatBox("Not allowed, sorry.", client)
		return
	end
	
	if not (factionCooldown) then
		for key, value in ipairs(exports.rl_pool:getPoolElementsByType("vehicle")) do
			local faction = getElementData(value, "faction")
			if (faction == factionID and not getVehicleOccupant(value, 0) and not getVehicleOccupant(value, 1) and not getVehicleOccupant(value, 2) and not getVehicleOccupant(value, 3) and not getVehicleTowingVehicle(value)) then
				respawnVehicle(value)
				setElementInterior(value, getElementData(value, "interior"))
				setElementDimension(value, getElementData(value, "dimension"))
				setVehicleLocked(value, true)
			end
		end
		
		local teamPlayers = getPlayersInTeam(theTeam)
		local username = getPlayerName(source)
		for _, player in ipairs(teamPlayers) do
			outputChatBox(">> Tüm birlik araçları " .. username:gsub("_"," ") .. " tarafından yenilendi.", player, 255, 194, 14)
		end

		setTimer(resetFactionCooldown, 60000, 1, theTeam)
		setElementData(theTeam, "cooldown", true)
	else
		outputChatBox("[!]#FFFFFF Şu anda birlik araçlarınızı yenileyemessiniz, lütfen bir süre bekleyin.", source, 255, 0, 0, true)
		playSoundFrontEnd(source, 4)
	end
end
addEvent("cguiRespawnVehicles", true)
addEventHandler("cguiRespawnVehicles", root, callbackRespawnVehicles)

function resetFactionCooldown(theTeam)
	removeElementData(theTeam, "cooldown")
end

function callbackRespawnOneVehicle(vehicleID)
	local theTeam = getPlayerTeam(source)
	local theTeamID = getElementData(theTeam, "id")
	local theVehicle = exports.rl_pool:getElement("vehicle", tonumber(vehicleID))
	if not hasPlayerAccessOverFaction(source, theTeamID) then
		outputChatBox("Not allowed, sorry.", source, 255, 0, 0)
		return
	end
	if theVehicle then
		local theVehicleID = getElementData(theVehicle, "faction")
		if (theTeamID == theVehicleID and not getVehicleOccupant(theVehicle, 0) and not getVehicleOccupant(theVehicle, 1) and not getVehicleOccupant(theVehicle, 2) and not getVehicleOccupant(theVehicle, 3) and not getVehicleTowingVehicle(theVehicle)) then
			if isElementAttached(theVehicle) then
				detachElements(theVehicle)
			end
			removeElementData(theVehicle, "i:left")
			removeElementData(theVehicle, "i:right")
			respawnVehicle(theVehicle)
			setElementInterior(theVehicle, getElementData(theVehicle, "interior"))
			setElementDimension(theVehicle, getElementData(theVehicle, "dimension"))
			setVehicleLocked(theVehicle, true)
			outputChatBox("Vehicle Respawned.", source, 0, 255, 0)
			local teamPlayers = getPlayersInTeam(theTeam)
			local playerName = getPlayerName(source)
			for k, v in ipairs(teamPlayers) do
				outputChatBox(playerName:gsub("_"," ") .. " respawned faction vehicle " .. vehicleID  .. ".", v, 255, 194, 14)
			end
		else
			outputChatBox("That vehicle is currently occupied.", source, 255, 0, 0)
		end
	else
		outputChatBox("Please select a vehicle you wish to respawn.", source, 255, 0, 0)
	end
end
addEvent("cguiRespawnOneVehicle", true)
addEventHandler("cguiRespawnOneVehicle", root, callbackRespawnOneVehicle)

function callbackUpdateMOTD(motd)
	local theTeam = getPlayerTeam(client)
	local factionID = getElementData(theTeam, "id")
	if not hasPlayerAccessOverFaction(client, factionID) then
		outputChatBox("Not allowed, sorry.", client)
		return
	end

	local theTeam = getPlayerTeam(client)
	if (factionID~=-1) then
		if dbExec(mysql:getConnection(), "UPDATE factions SET motd='" .. tostring((motd)) .. "' WHERE id='" .. factionID .. "'") then
			outputChatBox("You changed your faction's MOTD to '" .. motd .. "'", client, 0, 255, 0)
			setElementData(theTeam, "motd", motd)
		else
			outputChatBox("Error 300000 - Report on Forums.", client, 255, 0, 0)
		end
	end
end
addEvent("cguiUpdateMOTD", true)
addEventHandler("cguiUpdateMOTD", root, callbackUpdateMOTD)

function callbackUpdateNote(note)
	local theTeam = getPlayerTeam(client)
	local factionID = getElementData(theTeam, "id")
	if not hasPlayerAccessOverFaction(client, factionID) or not note then
		outputChatBox("Not allowed, sorry.", client)
		return
	end

	local theTeam = getPlayerTeam(client)
	if (factionID~=-1) then
		if dbExec(mysql:getConnection(), "UPDATE factions SET note='" .. tostring((note)) .. "' WHERE id='" .. factionID .. "'") then
			outputChatBox("You successfully changed your faction's leader note.", client, 0, 255, 0)
			setElementData(theTeam, "note", note)
		else
			outputChatBox("Error 30000A - Report on mantis.", client, 255, 0, 0)
		end
	end
end
addEvent("faction:note", true)
addEventHandler("faction:note", root, callbackUpdateNote)

function callbackUpdateFNote(fnote)
	local theTeam = getPlayerTeam(client)
	local factionID = getElementData(theTeam, "id")
	if not hasPlayerAccessOverFaction(client, factionID) or not fnote then
		outputChatBox("Not allowed, sorry.", client)
		return
	end

	local theTeam = getPlayerTeam(client)
	if (factionID~=-1) then
		if dbExec(mysql:getConnection(), "UPDATE factions SET fnote='" .. tostring((fnote)) .. "' WHERE id='" .. factionID .. "'") then
			outputChatBox("You successfully changed your faction's faction-wide note.", client, 0, 255, 0)
			setElementData(theTeam, "fnote", fnote)
		else
			outputChatBox("Error 30000B - Report on mantis.", client, 255, 0, 0)
		end
	end
end
addEvent("faction:fnote", true)
addEventHandler("faction:fnote", root, callbackUpdateFNote)

function callbackRemovePlayer(removedPlayerName)
    local theTeam = getPlayerTeam(client)
    local factionID = getElementData(theTeam, "id")
    if not hasPlayerAccessOverFaction(client, factionID) then
        outputChatBox("Not allowed, sorry.", client)
        return
    end
	
	local _client = client

    getPlayerFaction(removedPlayerName, function(targetFactionInfo)
        if dbExec(mysql:getConnection(), "UPDATE characters SET faction_id = -1, faction_leader = 0, faction_rank = 1, custom_duty = 0 WHERE name = ?", removedPlayerName) then
            local theTeamName = getTeamName(theTeam) or "None"
            local username = getPlayerName(_client)

            local removedPlayer = getPlayerFromName(removedPlayerName)
            if removedPlayer then
                if getElementData(_client, "factionMenu") == 1 then
                    triggerClientEvent(removedPlayer, "hideFactionMenu", root)
                end
                outputChatBox(username:gsub("_", " ") .. " removed you from the faction '" .. tostring(theTeamName) .. "'", removedPlayer, 255, 0, 0)
                setPlayerTeam(removedPlayer, getTeamFromName("Vatandaş"))
                setElementData(removedPlayer, "faction", -1)
                setElementData(removedPlayer, "factionleader", 0)
                setElementData(removedPlayer, "custom_duty", 0)
                triggerEvent("duty.offDuty", removedPlayer)
            end

            local teamPlayers = getPlayersInTeam(theTeam)
            for k, v in ipairs(teamPlayers) do
                if v ~= removedPlayer then
                    outputChatBox(username:gsub("_", " ") .. " kicked " .. removedPlayerName:gsub("_", " ") .. " from faction '" .. tostring(theTeamName) .. "'.", v, 255, 194, 14)
                end
            end
        else
            outputChatBox("Failed to remove " .. removedPlayerName:gsub("_", " ") .. " from the faction, Contact an admin.", source, 255, 0, 0)
        end
    end)
end
addEvent("cguiKickPlayer", true)
addEventHandler("cguiKickPlayer", root, callbackRemovePlayer)

function callbackPerkEdit(perkIDTable, playerName)
    local theTeam = getPlayerTeam(client)
    local factionID = getElementData(theTeam, "id")
    if not hasPlayerAccessOverFaction(client, factionID) then
        outputChatBox("Not allowed, sorry.", client)
        return
    end
	
	local _client = client

    getPlayerFaction(playerName, function(targetFactionInfo)
        local jsonPerkIDTable = toJSON(perkIDTable)
        if dbExec(mysql:getConnection(), "UPDATE `characters` SET `faction_perks`=? WHERE `name`=?", jsonPerkIDTable, playerName) then
            outputChatBox("Duty perks updated for " .. playerName:gsub("_", " ") .. ".", _client, 255, 0, 0)
            local targetPlayer = getPlayerFromName(playerName)
            if targetPlayer then
                setElementData(targetPlayer, "factionPackages", perkIDTable)
                outputChatBox("Your duty perks have been updated by " .. getPlayerName(_client):gsub("_", " ") .. ".", targetPlayer, 255, 0, 0)
            end
        end
    end)
end
addEvent("faction:perks:edit", true)
addEventHandler("faction:perks:edit", root, callbackPerkEdit)

function callbackToggleLeader(playerName, isLeader)
    local theTeam = getPlayerTeam(client)
    local factionID = getElementData(theTeam, "id")
    if not hasPlayerAccessOverFaction(client, factionID) then
        outputChatBox("Not allowed, sorry.", client)
        return
    end
	
	local _client = client

    getPlayerFaction(playerName, function(targetFactionInfo)
        local username = getPlayerName(_client)
        local leaderStatus = isLeader and 1 or 0
		
        if dbExec(mysql:getConnection(), "UPDATE characters SET faction_leader = ? WHERE name = ?", leaderStatus, playerName) then
            local thePlayer = getPlayerFromName(playerName)
            if thePlayer then
                setElementData(thePlayer, "factionleader", leaderStatus)
                if not isLeader and getElementData(_client, "factionMenu") == 1 then
                    triggerClientEvent(thePlayer, "hideFactionMenu", root)
                end
                outputChatBox((isLeader and "promoted to" or "demoted from") .. " faction leader by " .. username:gsub("_", " "), thePlayer, 255, 0, 0)
            end
        else
            outputChatBox("Failed to " .. (isLeader and "promote " or "demote ") .. playerName:gsub("_", " ") .. ", contact an admin.", _client, 255, 0, 0)
        end
    end)
end
addEvent("cguiToggleLeader", true)
addEventHandler("cguiToggleLeader", root, callbackToggleLeader)

function callbackPromotePlayer(playerName, rankNum, oldRank, newRank)
    local theTeam = getPlayerTeam(client)
    local factionID = getElementData(theTeam, "id")
    if not hasPlayerAccessOverFaction(client, factionID) then
        outputChatBox("Not allowed, sorry.", client)
        return
    end
	
	local _client = client
    
    getPlayerFaction(playerName, function(targetFactionInfo)
        local username = getPlayerName(_client)
        if dbExec(mysql:getConnection(), "UPDATE characters SET faction_rank=? WHERE name=?", rankNum, playerName) then
            local thePlayer = getPlayerFromName(playerName)
            if thePlayer then
                setElementData(thePlayer, "factionrank", rankNum)
            end
        else
            outputChatBox("Failed to promote " .. playerName:gsub("_", " ") .. " in the faction, Contact an admin.", _client, 255, 0, 0)
        end
    end)
end
addEvent("cguiPromotePlayer", true)
addEventHandler("cguiPromotePlayer", root, callbackPromotePlayer)

function callbackDemotePlayer(playerName, rankNum, oldRank, newRank)
    local theTeam = getPlayerTeam(client)
    local factionID = getElementData(theTeam, "id")
    if not hasPlayerAccessOverFaction(client, factionID) then
        outputChatBox("Not allowed, sorry.", client)
        return
    end
	
	local _client = client

    getPlayerFaction(playerName, function(targetFactionInfo)
        local username = getPlayerName(_client)
        local safename = playerName

        if dbExec(mysql:getConnection(), "UPDATE characters SET faction_rank=? WHERE name=?", rankNum, safename) then
            local thePlayer = getPlayerFromName(playerName)
            if thePlayer then
                setElementData(thePlayer, "factionrank", rankNum)
            end
        else
            outputChatBox("Failed to demote " .. playerName .. " in the faction, Contact an admin.", _client, 255, 0, 0)
        end
    end)
end
addEvent("cguiDemotePlayer", true)
addEventHandler("cguiDemotePlayer", root, callbackDemotePlayer)

function callbackQuitFaction()
	local username = getPlayerName(client)
	local safename = (username)
	local theTeam = getPlayerTeam(client)
	local theTeamName = getTeamName(theTeam)

	if theTeamName == "Los Santos Bus & Cab" then
		executeCommandHandler("quitjob", client)	
	elseif dbExec(mysql:getConnection(), "UPDATE characters SET faction_id='-1', faction_leader='0', custom_duty = 0, faction_perks='{}' WHERE name=?", safename) then
		setPlayerTeam(client, getTeamFromName("Vatandaş"))
		setElementData(client, "faction", -1)
		setElementData(client, "factionrank", 1)
		setElementData(client, "factionleader", 0)
		setElementData(client, "factionphone", nil)
		setElementData(client, "factionPackages", {})
		setElementData(client, "custom_duty", 0)
		triggerEvent("duty.offDuty", client)
		
		outputChatBox("[!]#FFFFFF '" .. theTeamName .. "' isimli birlikten ayrıldınız.", client, 255, 0, 0, true)
	else
		outputChatBox("Failed to quit the faction, Contact an admin.", client, 255, 0, 0)
	end
end
addEvent("cguiQuitFaction", true)
addEventHandler("cguiQuitFaction", root, callbackQuitFaction)

function callbackInvitePlayer(invitedPlayer)
	local theTeam = getPlayerTeam(client)
	local factionID = getElementData(theTeam, "id")
	if not hasPlayerAccessOverFaction(client, factionID) then
		outputChatBox("Not allowed, sorry.", client)
		return
	end
	
	local invitedPlayerNick = getPlayerName(invitedPlayer)
	local safename = (invitedPlayerNick)
	
	local targetTeam = getPlayerTeam(invitedPlayer)
	if (targetTeam ~= nil) and (getTeamName(targetTeam) ~= "Vatandaş") then
		outputChatBox("Player is already in a faction.", client, 255, 0, 0)
		return
	end
	
	if dbExec(mysql:getConnection(), "UPDATE characters SET faction_leader = 0, faction_id = ?, faction_rank = 1 WHERE name = ?", factionID, safename) then
		local theTeam = getPlayerTeam(client)
		local theTeamName = getTeamName(theTeam)
		
		local targetTeam = getPlayerTeam(invitedPlayer)
		if (targetTeam~=nil) and (getTeamName(targetTeam)~="Vatandaş") then
			outputChatBox("Player is already in a faction.", client, 255, 0, 0)
		else
			setPlayerTeam(invitedPlayer, theTeam)
			setElementData(invitedPlayer, "faction", factionID)
			outputChatBox("Player " .. invitedPlayerNick:gsub("_", " ") .. " is now a member of faction '" .. tostring(theTeamName) .. "'.", client, 0, 255, 0)
			if	(invitedPlayer) then
				triggerEvent("onPlayerJoinFaction", invitedPlayer, theTeam)
				setElementData(invitedPlayer, "factionrank", 1)
				setElementData(client, "factionphone", nil)
				outputChatBox("You were set to Faction '" .. tostring(theTeamName) .. "'.", invitedPlayer, 255, 194, 14)
			end
		end
	else
		outputChatBox("Player is already in a faction.", client, 255, 0, 0)
	end
end
addEvent("cguiInvitePlayer", true)
addEventHandler("cguiInvitePlayer", root, callbackInvitePlayer)

function hideFactionMenu()
	setElementData(client, "factionMenu", 0)
end
addEvent("factionmenu:hide", true)
addEventHandler("factionmenu:hide", root, hideFactionMenu)

function getFactionFinance(factionID)
    if not factionID then factionID = getElementData(client, "faction") end

    if hasPlayerAccessOverFaction(client, factionID) then
        local bankThisWeek = {}
        local bankPrevWeek = {}
        local transactions = {}

        dbQuery(function(qh)
            local result = dbPoll(qh, 0)
            if result then
                local mostRecentWeek = 0
                local currentWeek = 0

                for _, row in ipairs(result) do
                    local id = tonumber(row["id"])
                    local amount = tonumber(row["amount"])
                    local time = row["newtime"]
                    local week = tonumber(row["week"])
                    currentWeek = tonumber(row["currentWeek"])
                    if week > mostRecentWeek then mostRecentWeek = week end
                    if not transactions[week] then transactions[week] = {} end
                    local type = tonumber(row["type"])
                    local reason = row["reason"] or ""

                    local from, to = "-", "-"
                    if row["characterfrom"] ~= nil then
                        from = row["characterfrom"]:gsub("_", " ")
                    elseif tonumber(row["from"]) then
                        local num = tonumber(row["from"]) 
                        if num < 0 then
                            from = getTeamName(exports.rl_pool:getElement("team", -num)) or "-"
                        elseif num == 0 and (type == 6 or type == 7) then
                            from = "Government"
                        end
                    end
                    if row["characterto"] ~= nil then
                        to = row["characterto"]:gsub("_", " ")
                    elseif tonumber(row["to"]) and tonumber(row["to"]) < 0 then
                        to = getTeamName(exports.rl_pool:getElement("team", -tonumber(row["to"])))
                    end

                    if tostring(row["from"]) == tostring(-factionID) and amount > 0 then
                        amount = -amount
                    end

                    table.insert(transactions[week], { id = id, amount = amount, time = time, type = type, from = from, to = to, reason = reason, week = week })
                end

                bankThisWeek = transactions[currentWeek] or {}
                bankPrevWeek = transactions[currentWeek-1] or {}

                local faction = getPlayerTeam(client)
                local bankmoney = exports.rl_global:getMoney(faction)

                local vehicles = {}
                dbQuery(function(vehicleqh)
                    local vehicleResult = dbPoll(vehicleqh, 0)
                    if vehicleResult then
                        for _, row in ipairs(vehicleResult) do
                            local vehicleShopID = tonumber(row["vehicle_shop_id"])
                            if vehicleShopID > 0 then
                                table.insert(vehicles, vehicleShopID)
                            end
                        end

                        local vehiclesvalue = 0
                        if not vehPrice then vehPrice = {} end
                        for _, v in ipairs(vehicles) do
                            if vehPrice[v] then
                                local price = tonumber(vehPrice[v]) or 0
                                vehiclesvalue = vehiclesvalue + price
                            else
                                dbQuery(function(priceqh)
                                    local priceResult = dbPoll(priceqh, 0)
                                    if priceResult then
                                        for _, row in ipairs(priceResult) do
                                            local price = tonumber(row["vehprice"]) or 0
                                            vehPrice[v] = price
                                            vehiclesvalue = vehiclesvalue + price
                                        end
                                    end
                                end, mysql:getConnection(), "SELECT vehprice FROM vehicles_shop WHERE id=?", v)
                            end
                        end

                        triggerClientEvent(client, "factionmenu:fillFinance", resourceRoot, factionID, bankThisWeek, bankPrevWeek, bankmoney, vehiclesvalue)
                    end
                end, mysql:getConnection(), "SELECT vehicle_shop_id FROM vehicles WHERE faction=? AND deleted=0 AND chopped=0", factionID)
            else
                outputDebugString("Mysql error @ tellTransfers", 2)
            end
        end, mysql:getConnection(), "SELECT w.*, a.name as characterfrom, b.name as characterto,w.`time` - INTERVAL 1 hour as 'newtime', WEEKOFYEAR(w.`time` - INTERVAL 1 hour) as 'week', WEEKOFYEAR(CURDATE() - INTERVAL 1 hour) as 'currentWeek' FROM wiretransfers w LEFT JOIN characters a ON a.id = `from` LEFT JOIN characters b ON b.id = `to` WHERE (`from` = ? OR `to` = ?) ORDER BY id DESC", -factionID, -factionID)
    end
end
addEvent("factionmenu:getFinance", true)
addEventHandler("factionmenu:getFinance", resourceRoot, getFactionFinance)

addEvent("factionmenu:setphone", true)
addEventHandler("factionmenu:setphone", root, function(playerName, number)
    local theTeam = getPlayerTeam(client)
    local factionID = getElementData(theTeam, "id")
    if not hasPlayerAccessOverFaction(client, factionID) then
        outputChatBox("Not allowed, sorry.", client)
        return
    end
	
	local _client = client
    
    getPlayerFaction(playerName, function(targetFactionInfo)
        local username = getPlayerName(_client)
        local safename = playerName

        if dbExec(mysql:getConnection(), "UPDATE characters SET faction_phone=? WHERE name=?", tonumber(number) or "NULL", safename) then
            local thePlayer = getPlayerFromName(playerName)
            if thePlayer then
                setElementData(thePlayer, "factionphone", tonumber(number) or nil)
            end
        else
            outputChatBox("Failed to set phone number for " .. playerName:gsub("_", " ") .. " in the faction, Contact an admin.", _client, 255, 0, 0)
        end
    end)
end)

function isLeapYear(year)
	return year%4==0 and (year%100~=0 or year%400==0)
end

local lastDayOfMonth = {31,28,31,30,31,30,31,31,30,31,30,31}

function fromDatetime(string)
	local split1 = exports.rl_global:split(string, " ")
	local date = split1[1]
	local time = split1[2]

	local datesplit = exports.rl_global:split(date, "-")
	local year = tonumber(datesplit[1])
	local month = tonumber(datesplit[2])
	local day = tonumber(datesplit[3])

	local timesplit = exports.rl_global:split(date, ":")
	local hour = tonumber(timesplit[1])
	local minute = tonumber(timesplit[2])
	local second = tonumber(timesplit[3])
	
	local prevdays = 0
	local addmonth = 1
	while true do
		if addmonth >= month then break end
		if addmonth == 2 and isLeapYear(year) then
			prevdays = prevdays + lastDayOfMonth[addmonth] + 1
		else
			prevdays = prevdays + lastDayOfMonth[addmonth]
		end
		addmonth = addmonth + 1
	end
	local yearday = prevdays + day

	local time = { year = year, month = month, day = day, hour = hour, minute = minute, second = second, yearday = yearday }
	return time
end

function getWeekNumFromYearDay(yearday)
	local weekNum = math.floor(yearday / 7)
	return weekNum
end

addEvent("fetchDutyInfo", true)
addEventHandler("fetchDutyInfo", resourceRoot, function(factionID)
	if not factionID then
		factionID = getElementData(client, "faction")
	end

	local elementInfo = getElementData(resourceRoot, "DutyGUI")
	elementInfo[client] = factionID
	setElementData(resourceRoot, "DutyGUI", elementInfo)

	triggerClientEvent(client, "importDutyData", resourceRoot, custom[tonumber(factionID)], locations[tonumber(factionID)], factionID)
end)

addEvent("Duty:Grab", true)
addEventHandler("Duty:Grab", resourceRoot, function(factionID)
	if not factionID then
		factionID = getElementData(client, "faction")
	end
	
	local t = getAllowList(factionID)
	triggerClientEvent(client, "gotAllow", resourceRoot, t)
end)

addEvent("Duty:GetPackages", true)
addEventHandler("Duty:GetPackages", resourceRoot, function(factionID)
	factionID = tonumber(factionID)
	triggerClientEvent(client, "Duty:GotPackages", resourceRoot, custom[factionID])
end)

function refreshClient(message, factionID, dontSendToClient)
	for k,v in pairs(getElementData(resourceRoot, "DutyGUI")) do
		if dontSendToClient then
			if v == factionID and k~=dontSendToClient then
				triggerClientEvent(k, "importDutyData", resourceRoot, custom[tonumber(factionID)], locations[tonumber(factionID)], factionID, message)
			end
		else
			if v == factionID then
				triggerClientEvent(k, "importDutyData", resourceRoot, custom[tonumber(factionID)], locations[tonumber(factionID)], factionID, message)
			end
		end
	end
	
	local resource = getResourceRootElement(getResourceFromName("rl_duty"))
	if resource then
		setElementData(resource, "factionDuty", custom)
		setElementData(resource, "factionLocations", locations)
	end
end

function disconnectThem()
	local t = getElementData(resourceRoot, "DutyGUI") 
	t[source] = nil
	setElementData(resourceRoot, "DutyGUI", t)
end
addEventHandler("onPlayerQuit", root, disconnectThem)

function addDuty(dutyItems, finalLocations, dutyNewSkins, name, factionID, dutyID)
	local dutyItems = dutyItems or {}
	local finalLocations = finalLocations or {}
	local dutyNewSkins = dutyNewSkins or {}
	if dutyID == 0 then
		local index = getElementData(resourceRoot, "maxcindex")+1
		dbExec(mysql:getConnection(), "INSERT INTO duty_custom SET id=" .. index .. ", factionID=" .. (factionID) .. ", name='" .. (name) .. "', skins='" .. (toJSON(dutyNewSkins)) .. "', locations='" .. (toJSON(finalLocations)) .. "', items='" .. (toJSON(dutyItems)) .. "'")
		setElementData(resourceRoot, "maxcindex", index)
		custom[tonumber(factionID)][index] = { index, name, dutyNewSkins, finalLocations, dutyItems }
		refreshClient("> " .. getPlayerName(client):gsub("_", " ") .. ": Added duty '" .. name .. "'.", factionID, false)
	else
		dbExec(mysql:getConnection(), "UPDATE duty_custom SET name='" .. (name) .. "', skins='" .. (toJSON(dutyNewSkins)) .. "', locations='" .. (toJSON(finalLocations)) .. "', items='" .. (toJSON(dutyItems)) .. "' WHERE id=" .. dutyID)
		table.remove(custom[tonumber(factionID)], dutyID)
		custom[tonumber(factionID)][dutyID] = { dutyID, name, dutyNewSkins, finalLocations, dutyItems }
		refreshClient("> " .. getPlayerName(client):gsub("_", " ") .. ": Revised duty ID #" .. dutyID .. ".", factionID, false)
	end
end
addEvent("Duty:AddDuty", true)
addEventHandler("Duty:AddDuty", resourceRoot, addDuty)

function addLocation(x, y, z, r, i, d, name, factionID, index)
	local interiorElement = exports.rl_pool:getElement("interior", d) or d == 0
	if interiorElement then
		local interiorF = 0
		if isElement(interiorElement) then
			interiorStatus = getElementData(interiorElement, "status")
			interiorF = interiorStatus[7]
		end

		if tonumber(factionID) or d == 0 then
			if not index then -- Index is used if the event is from a edit
				local newIndex = getElementData(resourceRoot, "maxlindex")+1
				dbExec(mysql:getConnection(), "INSERT INTO duty_locations SET id=" .. newIndex .. ", factionID=" .. (factionID) .. ", name='" ..  (name)  .. "', x=" .. (x) .. ", y=" .. (y) .. ", z=" .. (z) .. ", radius=" .. (r) .. ", dimension=" .. (d) .. ", interior=" .. (i))
				setElementData(resourceRoot, "maxlindex", newIndex)
				exports.rl_duty:createDutyColShape(x, y, z, r, i, d, factionID, newIndex)
				locations[tonumber(factionID)][newIndex] = { newIndex, name, x, y, z, r, d, i, nil, nil }
				refreshClient("> " .. getPlayerName(client):gsub("_", " ") .. ": Added location '" .. name .. "'.", factionID, false)
			else
				dbExec(mysql:getConnection(), "UPDATE duty_locations SET name='" ..  (name)  .. "', x=" .. (x) .. ", y=" .. (y) .. ", z=" .. (z) .. ", radius=" .. (r) .. ", dimension=" .. (d) .. ", interior=" .. (i) .. " WHERE id=" .. index)
				table.remove(locations[factionID], index)
				exports.rl_duty:destroyDutyColShape(factionID, index)
				exports.rl_duty:createDutyColShape(x, y, z, r, i, d, factionID, index)
				locations[tonumber(factionID)][index] = { index, name, x, y, z, r, d, i, nil, nil }
				refreshClient("> " .. getPlayerName(client):gsub("_", " ") .. ": Revised location ID #" .. index .. ".", factionID, false)
			end
		else
			outputChatBox("The interior you entered must be owned by the faction to be added as a duty location.", client, 255, 0, 0)
		end
	else
		outputChatBox("Server could not find the interior you entered!", client, 255, 0, 0)
	end
end
addEvent("Duty:AddLocation", true)
addEventHandler("Duty:AddLocation", resourceRoot, addLocation)

function addVehicle(vehicleID, factionID)
	local element = exports.rl_pool:getElement("vehicle", vehicleID)
	if element then
		if getElementData(element, "faction") == factionID then
		    local newIndex = getElementData(resourceRoot, "maxlindex")+1
			dbExec(mysql:getConnection(), "INSERT INTO duty_locations SET id=" .. newIndex .. ", factionID=" .. (factionID) .. ", name='VEHICLE', vehicleid=" .. (vehicleID) .. ", model=" .. getElementModel(element))
			setElementData(resourceRoot, "maxlindex", newIndex)
			locations[tonumber(factionID)][newIndex] = { newIndex, "VEHICLE", nil, nil, nil, nil, nil, nil, tonumber(vehicleID), getElementModel(element) }
			refreshClient("> " .. getPlayerName(client):gsub("_", " ") .. ": Added vehicle #" .. vehicleID .. ".", factionID, false)
		else
			outputChatBox("You can only add faction vehicles as duty locations.", client, 255, 0, 0)
		end
	else
		outputChatBox("Error finding your vehicle, did you type the ID in right?", client, 255, 0, 0)
	end
end
addEvent("Duty:AddVehicle", true)
addEventHandler("Duty:AddVehicle", resourceRoot, addVehicle)

function removeLocation(removeID, factionID)
	locations[tonumber(factionID)][tonumber(removeID)] = nil
	exports.rl_duty:destroyDutyColShape(factionID, removeID)
	dbExec(mysql:getConnection(), "DELETE FROM duty_locations WHERE id=" .. removeID)
	refreshClient("> " .. getPlayerName(client):gsub("_", " ") .. ": removed location " .. removeID .. ".", factionID, client)
end
addEvent("Duty:RemoveLocation", true)
addEventHandler("Duty:RemoveLocation", resourceRoot, removeLocation)

function removeDuty(removeID, factionID)
	custom[tonumber(factionID)][tonumber(removeID)] = nil
	dbExec(mysql:getConnection(), "DELETE FROM duty_custom WHERE id=" .. removeID)
	refreshClient("> " .. getPlayerName(client):gsub("_", " ") .. ": removed duty " .. removeID .. ".", factionID, client)
end
addEvent("Duty:RemoveDuty", true)
addEventHandler("Duty:RemoveDuty", resourceRoot, removeDuty)

function getTeamFromFactionID(factionID)
	if not tonumber(factionID) then
		return false
	else 
		factionID = tonumber(factionID)
	end
	return exports.rl_pool:getElement("team", factionID)
end

function getFactionType(factionID)
	local theTeam = getTeamFromFactionID(factionID)
	if theTeam then
		local ftype = tonumber(getElementData(theTeam, "type"))
		if ftype then
			return ftype
		end
	end
	return false
end

function getFactionFromName(factionName)
	for k,v in ipairs(exports.rl_pool:getPoolElementsByType("team")) do
		if string.lower(getTeamName(v)) == string.lower(factionName) then
			return v
		end
	end
	return false
end

function getFactionIDFromName(factionName)
	local theTeam = getFactionFromName(factionName)
	if theTeam then
		local id = tonumber(getElementData(theTeam, "id"))
		if id then
			return id
		end
	end
	return false
end

function getAllPlayersFromFactionId(fId, groupByAccount, leaderOnly, callback)
	local users = {}
	local queryStr = "SELECT a.id AS aid, c.id AS cid, name, username FROM accounts a LEFT JOIN characters c ON a.id = c.account WHERE " .. (leaderOnly and "faction_leader=1 AND " or "") .. " faction_id =" .. fId .. " " .. (groupByAccount and "GROUP BY (a.id)" or '')

	dbQuery(function(qh)
		local result = dbPoll(qh, 0)
		if result then
			for _, row in ipairs(result) do
				table.insert(users, row)
			end
			callback(users)
		else
			outputDebugString("[getAllPlayersFromFactionId] Database query failed.")
			callback(nil)
		end
	end, mysql:getConnection(), queryStr)
end
