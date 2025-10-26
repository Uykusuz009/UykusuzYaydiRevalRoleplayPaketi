local mysql = exports.rl_mysql

function getAllInts(thePlayer, commandName, ...)
    if exports.rl_integration:isPlayerAdmin1(thePlayer) then
        local interiorsList = {}

        dbQuery(function(qh)
            local result, rows, err = dbPoll(qh, 0)
            if rows > 0 then
                for _, row in ipairs(result) do
                    table.insert(interiorsList, {
                        row["iID"],
                        row["type"],
                        row["name"],
                        row["cost"],
                        row["character_name"],
                        row["username"],
                        row["cked"],
                        row["DiffDate"],
                        row["locked"],
                        row["supplies"],
                        row["safepositionX"],
                        row["disabled"],
                        row["deleted"],
                        "",
                        row["iCreatedDate"],
                        row["iCreator"],
                        row["x"],
                        row["y"],
                        row["z"],
                        row["fowner"]
                    })
                end
            end
            triggerClientEvent(thePlayer, "createIntManagerWindow", thePlayer, interiorsList, getElementData(thePlayer, "account_username"))
        end, mysql:getConnection(),
            [[
                SELECT factions.name AS fowner, interiors.id AS iID, interiors.type AS type, interiors.name AS name,
                       cost, characters.name AS character_name, username, cked, locked, supplies, safepositionX, disabled, deleted,
                       interiors.createdDate AS iCreatedDate, interiors.creator AS iCreator,
                       DATEDIFF(NOW(), lastused) AS DiffDate, interiors.x, interiors.y, interiors.z
                FROM interiors
                LEFT JOIN characters ON interiors.owner = characters.id
                LEFT JOIN accounts ON characters.account = accounts.id
                LEFT JOIN factions ON interiors.faction = factions.id
                ORDER BY interiors.createdDate DESC
            ]]
        )
    else
		outputChatBox("[!]#FFFFFF Yeterli yetkiniz yok.", thePlayer, 255, 0, 0, true)
		playSoundFrontEnd(thePlayer, 4)
	end
end
addCommandHandler("interiors", getAllInts)
addCommandHandler("ints", getAllInts)
addEvent("interiorManager:openit", true)
addEventHandler("interiorManager:openit", root, getAllInts)

function delIntCmd(intID)
	if client ~= source then
		return
	end
	
	executeCommandHandler("delint", client, intID)
end
addEvent("interiorManager:delint", true)
addEventHandler("interiorManager:delint", root, delIntCmd)

function disableInt(intID)
	if client ~= source then
		return
	end
	
	executeCommandHandler("toggleinterior", client, intID)
end
addEvent("interiorManager:disableInt", true)
addEventHandler("interiorManager:disableInt", root, disableInt)

function gotoInt(intID)
	if client ~= source then
		return
	end
	
	executeCommandHandler("gotohouse", client, intID)
end
addEvent("interiorManager:gotoInt", true)
addEventHandler("interiorManager:gotoInt", root, gotoInt)

function restoreInt(intID)
	if client ~= source then
		return
	end
	
	executeCommandHandler("restoreInt", client, intID)
end
addEvent("interiorManager:restoreInt", true)
addEventHandler("interiorManager:restoreInt", root, restoreInt)

function removeInt(intID)
	if client ~= source then
		return
	end
	
	executeCommandHandler("removeint", client, intID)
end
addEvent("interiorManager:removeInt", true)
addEventHandler("interiorManager:removeInt", root, removeInt)
  
function forceSellInt(intID)
	if client ~= source then
		return
	end
	
	executeCommandHandler("fsell", client, intID)
end
addEvent("interiorManager:forceSellInt", true)
addEventHandler("interiorManager:forceSellInt", root, forceSellInt)

function openAdminNote(intID)
	if client ~= source then
		return
	end
	executeCommandHandler("checkint", client, intID)
end
addEvent("interiorManager:openAdminNote", true)
addEventHandler("interiorManager:openAdminNote", root, openAdminNote)

function interiorSearch(keyword)
	if client ~= source then
		return
	end
	
	if keyword and keyword ~= "" and keyword ~= "Search..." then
		local interiorsResultList = {}
		local mQuery1 = dbQuery(mysql:getConnection(), 
			[[
				SELECT 
					factions.name AS fowner, 
					interiors.id AS iID, 
					interiors.type AS type, 
					interiors.name AS name, 
					cost, 
					characters.name AS charactername, 
					username, 
					cked, 
					locked, 
					supplies, 
					safepositionX, 
					disabled, 
					deleted, 
					interiors.createdDate AS iCreatedDate, 
					interiors.creator AS iCreator, 
					DATEDIFF(NOW(), lastused) AS DiffDate, 
					interiors.x, 
					interiors.y, 
					interiors.z 
				FROM interiors 
				LEFT JOIN characters ON interiors.owner = characters.id 
				LEFT JOIN accounts ON characters.account = accounts.id 
				LEFT JOIN factions ON interiors.faction = factions.id 
				WHERE 
					interiors.id LIKE ? 
					OR interiors.name LIKE ? 
					OR factions.name LIKE ? 
					OR cost LIKE ? 
					OR charactername LIKE ? 
					OR username LIKE ? 
					OR interiors.creator LIKE ? 
				ORDER BY interiors.createdDate DESC
			]], 
			"%" .. keyword .. "%", "%" .. keyword .. "%", "%" .. keyword .. "%", "%" .. keyword .. "%", "%" .. keyword .. "%", "%" .. keyword .. "%", "%" .. keyword .. "%")

		local result = dbPoll(mQuery1, -1)
		if result then
			for _, row in ipairs(result) do
				table.insert(interiorsResultList, { 
					row["iID"], 
					row["type"], 
					row["name"], 
					row["cost"], 
					row["charactername"], 
					row["username"], 
					row["cked"], 
					row["DiffDate"], 
					row["locked"], 
					row["supplies"], 
					row["safepositionX"], 
					row["disabled"], 
					row["deleted"], 
					'', 
					row["iCreatedDate"], 
					row["iCreator"], 
					row["x"], 
					row["y"], 
					row["z"], 
					row["fowner"]
				})
			end
		end

		triggerClientEvent(client, "interiorManager:FetchSearchResults", client, interiorsResultList, getElementData(client, "account_username"))
	end
end
addEvent("interiorManager:Search", true)
addEventHandler("interiorManager:Search", root, interiorSearch)

function checkInt(thePlayer, commandName, intID)
	if exports.rl_integration:isPlayerTrialAdmin(thePlayer) then 
		if not tonumber(intID) or (tonumber(intID) <= 0) or (tonumber(intID) % 1 ~= 0) then
			intID = getElementDimension(thePlayer)
			if intID == 0 then
				outputChatBox("İç mekanın içinde olmalısınız.", thePlayer, 255, 194, 14)
				outputChatBox("Veya KULLANIM: /" .. commandName .. " [İç Mekan ID]", thePlayer, 255, 194, 14)
				return false
			end
		end
		local mQuery1 = dbQuery(mysql:getConnection(), "SELECT factions.name AS fowner, interiors.id AS iID, interiors.type AS type, interiors.name AS name, cost, characters.name AS charactername, username, cked, locked, supplies, safepositionX,safepositionY, safepositionZ, disabled, deleted, interiors.createdDate AS iCreatedDate, interiors.creator AS iCreator, DATEDIFF(NOW(), lastused) AS DiffDate, interiors.x, interiors.y, interiors.y FROM interiors LEFT JOIN characters ON interiors.owner = characters.id LEFT JOIN accounts ON characters.account = accounts.id LEFT JOIN factions ON interiors.faction=factions.id WHERE interiors.id = ? ORDER BY interiors.createdDate DESC", intID)

		if mQuery1 then
			local result = dbPoll(mQuery1, -1) or {}
			if #result == 0 then
				outputChatBox("İç mekan ID mevcut değil!", thePlayer, 255, 0, 0)
				return 
			end

			local result2 = {}
			local mQuery2 = dbQuery(mysql:getConnection(), "SELECT `interior_logs`.`date` AS `date`, `interior_logs`.`intID` as `intID`, `interior_logs`.`action` AS `action`, `accounts`.`username` AS `adminname`, `interior_logs`. AS `log_id` FROM `interior_logs` LEFT JOIN `accounts` ON `interior_logs`.`actor` = `accounts`.`id` WHERE `interior_logs`.`intID` = ? ORDER BY `interior_logs`.`date` DESC", intID)
			local logsResult = dbPoll(mQuery2, -1) or {}
			dbFree(mQuery2)

			local notesResult = {}
			local mQuery3 = dbQuery(mysql:getConnection(), "SELECT n.id, n.note, a.username AS creatorname, n.date, n.creator FROM interior_notes n LEFT JOIN accounts a ON n.creator=a.id WHERE n.intid= ? ORDER BY n.date DESC", intID)
			local notes = dbPoll(mQuery3, -1) or {}
			dbFree(mQuery3)

			triggerClientEvent(thePlayer, "createCheckIntWindow", thePlayer, result, exports.rl_global:getPlayerAdminTitle(thePlayer), logsResult, notes)
		else
			outputChatBox("Veritabanı Hatası!", thePlayer, 255, 0, 0)
		end
	end
end
addCommandHandler("checkint", checkInt)
addCommandHandler("checkinterior", checkInt)
addEvent("interiorManager:checkint", true)
addEventHandler("interiorManager:checkint", root, checkInt)

function formatCreator(creator, creatorId)
	if creator and creatorId then
		if creator == nil then
			if creatorId == "0" then
				return "SİSTEM"
			else
				return "N/A"
			end
		else
			return creator
		end
	else
		return "N/A"
	end
end

function saveAdminNote(intID, adminNote, noteId)
	if client ~= source then
		return
	end
	
	if not intID or not adminNote then
		outputChatBox("Dahili Hata!", source, 255, 0, 0)
		return false
	end

	if string.len(adminNote) > 500 then
		outputChatBox("Yönetici notu eklenemedi. Sebep: 500 Karakteri aştı.", source, 255, 0, 0)
		return false
	end

	local accountId = getElementData(source, "account_id")
	if not accountId then
		outputChatBox("Hesap ID'si alınamadı!", source, 255, 0, 0)
		return false
	end

	local query = ""
	if noteId then
		query = dbPrepareString(mysql:getConnection(), "UPDATE interior_notes SET note=?, creator=? WHERE id=? AND intid=?", adminNote, accountId, noteId, intID)
	else
		query = dbPrepareString(mysql:getConnection(), "INSERT INTO interior_notes (note, creator, intid) VALUES (?, ?, ?)", adminNote, accountId, intID)
	end

	if query then
		local result = dbExec(mysql:getConnection(), query)
		if result then
			if noteId then
				outputChatBox("İç mekan #" .. intID .. " için yönetici notu girişi #" .. noteId .. " başarıyla güncellendi.", source, 0, 255, 0)
				addInteriorLogs(intID, "Yönetici notu girişi #" .. noteId .. " güncellendi", source)
			else
				local insertedId = dbPoll(dbQuery(mysql:getConnection(), "SELECT LAST_INSERT_ID()"))[1]["LAST_INSERT_ID()"]
				outputChatBox("İç mekan #" .. intID .. " için yeni yönetici notu girişi #" .. insertedId .. " başarıyla eklendi.", source, 0, 255, 0)
				addInteriorLogs(intID, "Yeni yönetici notu girişi #" .. insertedId .. " eklendi", source)
			end
			return true
		else
			outputChatBox("İç mekan notu kaydedilirken bir hata oluştu.", source, 255, 0, 0)
			return false
		end
	else
		outputChatBox("Veritabanı sorgusu oluşturulamadı!", source, 255, 0, 0)
		return false
	end
end
addEvent("interiorManager:saveAdminNote", true)
addEventHandler("interiorManager:saveAdminNote", root, saveAdminNote)

function setInteriorFaction(thePlayer, cmd, ...)
	if exports.rl_integration:isPlayerAdmin1(thePlayer) then
		local args = { ... }
		if #args < 1 then
			outputChatBox("KULLANIM: /" .. cmd .. " [Faction Name or Faction ID]", thePlayer, 255, 194, 14)
			return
		end

		local dim = getElementDimension(thePlayer)
		if dim < 1 then
			outputChatBox("Bu eylemi gerçekleştirmek için bir iç mekanda olmalısınız.", thePlayer, 255, 0, 0)
			return
		end

		local clue = table.concat(args, " ")
		local theFaction = nil
		if tonumber(clue) then
			theFaction = exports.rl_pool:getElement("team", tonumber(clue))
		else
			theFaction = exports.rl_faction:getFactionFromName(clue)
		end

		if not theFaction then
			outputChatBox("Hiçbir birlik bulunamadı.", thePlayer, 255, 0, 0)
			return
		end

		local dbid, entrance, exit, interiorType, interiorElement = exports['rl_interior']:findProperty(thePlayer)
		if not isElement(interiorElement) then
			outputChatBox("Burada bir iç mekan bulunamadı.", thePlayer, 255, 0, 0)
			return
		end

		local can, reason = exports.rl_global:canFactionBuyInterior(theFaction)
		if not can then
			outputChatBox(reason, thePlayer, 255, 0, 0)
			return 
		end

		local factionId = getElementData(theFaction, "id")
		local factionName = getTeamName(theFaction)
		local intName = getElementData(interiorElement, "name")

		local query = dbPrepareString(mysql:getConnection(), "UPDATE interiors SET owner='-1', faction=?, locked=0 WHERE id=?", factionId, dbid)
		if not query then
			outputChatBox("Dahili Hata.", thePlayer, 255, 0, 0)
			return
		end

		local result = dbExec(mysql:getConnection(), query)
		if not result then
			outputChatBox("Veritabanı Hatası.", thePlayer, 255, 0, 0)
			return
		end

		call(getResourceFromName("rl_items"), "deleteAll", interiorType == 1 and 5 or 4, dbid)
		exports.rl_global:giveItem(thePlayer, interiorType == 1 and 5 or 4, dbid)

		exports['rl_interior']:realReloadInterior(tonumber(dbid))
		exports.rl_global:sendMessageToAdmins("[INTERIOR] " .. exports.rl_global:getPlayerFullAdminTitle(thePlayer) .. " iç mekan '" .. intName .. "' ID #" .. dbid .. " sahipliğini '" .. factionName .. "' birliğine aktardı.")
		return true
	end
end
addCommandHandler("setintfaction", setInteriorFaction, false, false)

function setInteriorToMyFaction(thePlayer, cmd)
	local factionId = getElementData(thePlayer, "faction")
	local factionLeader = getElementData(thePlayer, "factionleader")

	if not factionId or not factionLeader or factionId < 1 or factionLeader < 1 then
		outputChatBox("Bu eylemi gerçekleştirmek için birlik lideri olmalısınız.", thePlayer, 255, 0, 0)
		return
	end

	local dim = getElementDimension(thePlayer)
	if dim < 1 then
		outputChatBox("Bu eylemi gerçekleştirmek için bir iç mekanda olmalısınız.", thePlayer, 255, 0, 0)
		return
	end

	local theFaction = exports.rl_pool:getElement("team", tonumber(factionId))
	if not theFaction then
		outputChatBox("Hiçbir birlik bulunamadı.", thePlayer, 255, 0, 0)
		return
	end

	local dbid, entrance, exit, interiorType, interiorElement = exports['rl_interior']:findProperty(thePlayer)
	if not isElement(interiorElement) then
		outputChatBox("Burada bir iç mekan bulunamadı.", thePlayer, 255, 0, 0)
		return
	end

	local charId = getElementData(thePlayer, "dbid")
	local intStatus = getElementData(interiorElement, "status")
	local intName = getElementData(interiorElement, "name")
	local factionName = getTeamName(theFaction)

	if intStatus[INTERIOR_OWNER] ~= charId then
		outputChatBox("Bu eylemi gerçekleştirmek için bu iç mekanın sahibi olmalısınız.", thePlayer, 255, 0, 0)
		return
	end

	local can, reason = exports.rl_global:canPlayerFactionBuyInterior(thePlayer)
	if not can then
		outputChatBox(reason, thePlayer, 255, 0, 0)
		return 
	end

	local query = dbPrepareString(mysql:getConnection(), "UPDATE interiors SET owner='-1', faction=?, locked=0 WHERE id=?", factionId, dbid)
	if not query then
		outputChatBox("Dahili Hata.", thePlayer, 255, 0, 0)
		return
	end

	local result = dbExec(mysql:getConnection(), query)
	if not result then
		outputChatBox("Veritabanı Hatası.", thePlayer, 255, 0, 0)
		return
	end

	call(getResourceFromName("rl_items"), "deleteAll", interiorType == 1 and 5 or 4, dbid)
	exports.rl_global:giveItem(thePlayer, interiorType == 1 and 5 or 4, dbid)

	exports['rl_interior']:realReloadInterior(tonumber(dbid))
	exports.rl_global:sendMessageToAdmins("[INTERIOR] " .. exports.rl_global:getPlayerFullAdminTitle(thePlayer) .. " iç mekan '" .. intName .. "' ID #" .. dbid .. " sahipliğini kendi birliği '" .. factionName .. "' olarak aktardı.")
	return true
end
addCommandHandler("setinttomyfaction", setInteriorToMyFaction, false, false)