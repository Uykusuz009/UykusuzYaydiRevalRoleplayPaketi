local mysql = exports.rl_mysql

function getAllVehs(thePlayer, commandName, ...)
	if exports.rl_integration:isPlayerTrialAdmin(thePlayer) then
		local vehicleList = {}
		local mQuery1 = nil
		
		dbQuery(function(qh, thePlayer)
			local res, rows, err = dbPoll(qh, 0)
			if rows > 0 then
				for index, row in ipairs(res) do
					table.insert(vehicleList, { row["vID"], row["type"], row["name"], row["cost"], row["name"], row["username"], row["cked"], row["DiffDate"], row["locked"], row["supplies"], row["safepositionX"], row["disabled"], row["deleted"], row["iAdminNote"], row["iCreatedDate"],row["iCreator"], row["`vehicles`.`x`"], row["`vehicles`.`y`"], row["`vehicles`.`z`"] })
				end
				triggerClientEvent(thePlayer, "createVehManagerWindow", thePlayer, vehicleList, getElementData(thePlayer, "account_username"))
			end
		end, {thePlayer}, mysql:getConnection(), "SELECT vehicles.id AS vID, type, name, cost, name, username, cked, locked, supplies, safepositionX, disabled, deleted, vehicles.adminnote AS iAdminNote, vehicles.createdDate AS iCreatedDate, vehicles.creator AS iCreator, DATEDIFF(NOW(), lastused) AS DiffDate, vehicles.x, vehicles.y, vehicles.y FROM vehicles LEFT JOIN characters ON vehicles.owner = characters.id LEFT JOIN accounts ON characters.account = accounts.id ORDER BY vehicles.createdDate DESC")
	end
end
addEvent("vehicleManager:openit", true)
addEventHandler("vehicleManager:openit", root, getAllVehs)

function delVehCmd(vehID)
	if client ~= source then
		return
	end
	
	executeCommandHandler("delveh", client, vehID)
end
addEvent("vehicleManager:delVeh", true)
addEventHandler("vehicleManager:delVeh", root, delVehCmd)

function gotoVeh(vehID) 
	if client ~= source then
		return
	end
	
	executeCommandHandler("gotocar", client, vehID)
end
addEvent("vehicleManager:gotoVeh", true)
addEventHandler("vehicleManager:gotoVeh", root, gotoVeh)

function restoreVeh(vehID)
	if client ~= source then
		return
	end
	
	executeCommandHandler("restoreveh", client, vehID)
end
addEvent("vehicleManager:restoreVeh", true)
addEventHandler("vehicleManager:restoreVeh", root, restoreVeh)

function removeVeh(vehID)
	if client ~= source then
		return
	end
	
	executeCommandHandler("removeveh", client, vehID)
end
addEvent("vehicleManager:removeVeh", true)
addEventHandler("vehicleManager:removeVeh", root, removeVeh)
  
function forceSellInt(vehID)
	if client ~= source then
		return
	end
	
	executeCommandHandler("fsell", client, vehID)
end
addEvent("vehicleManager:forceSellInt", true)
addEventHandler("vehicleManager:forceSellInt", root, forceSellInt)

function openAdminNote(vehID)
	if client ~= source then
		return
	end
	
	executeCommandHandler("checkint", client, vehID)
end
addEvent("vehicleManager:openAdminNote", true)
addEventHandler("vehicleManager:openAdminNote", root, openAdminNote)

function vehiclesearch(keyword)
	if client ~= source then
		return
	end
	
	if keyword and keyword ~= "" and keyword ~= "Search..." then
		local vehiclesResultList = {}
		local mQuery1 = nil
		dbQuery(function(qh, client)
			local res, rows = dbPoll(qh, 0)
			if rows > 0 then
				for index, row in ipairs(res) do
					table.insert(vehiclesResultList, row)
				end
				triggerClientEvent(client, "vehicleManager:FetchSearchResults", client, vehiclesResultList, getElementData(client, "account_username"))
			end
		end, {client}, mysql:getConnection(), "SELECT *, v.id AS id, TO_SECONDS(lastUsed) AS lastused_sec FROM vehicles v LEFT JOIN vehicles_shop s ON v.vehicle_shop_id=s.id LEFT JOIN characters c ON v.owner=c.id LEFT JOIN factions f ON v.faction=f.id WHERE v.id LIKE '%" .. keyword .. "%'  OR vehmtamodel LIKE '%" .. keyword .. "%' OR vehbrand LIKE '%" .. keyword .. "%' OR vehyear LIKE '%" .. keyword .. "%' OR c.name LIKE '%" .. keyword .. "%' OR f.name LIKE '%" .. keyword .. "%' OR f.name LIKE '%" .. keyword .. "%' ORDER BY v.id DESC")
	end
end
addEvent("vehicleManager:Search", true)
addEventHandler("vehicleManager:Search", root, vehiclesearch)

function checkVeh(thePlayer, commandName, vehID)
	if exports.rl_integration:isPlayerTrialAdmin(thePlayer) then
		if not tonumber(vehID) or (tonumber(vehID) <= 0) or (tonumber(vehID) % 1 ~= 0) then
			local veh = getPedOccupiedVehicle(thePlayer) or false
			vehID = isElement(veh) and getElementData(veh, "dbid") or false
			if not vehID then
				outputChatBox("You must be in a vehicle.", thePlayer, 255, 194, 14)
				outputChatBox("Or use KULLANIM: /"..commandName.." [Vehicle ID]", thePlayer, 255, 194, 14)
				return false
			elseif vehID <= 0 then
				outputChatBox("You can't /checkveh on temp vehicle.", thePlayer, 255, 0, 0)
				return false
			end
		end
		
		dbQuery(function(qh, thePlayer)
			local res, rows, err = dbPoll(qh, 0)
			if rows > 0 then
				local row = res[1]
				if not row then
					outputChatBox("Vehicle ID #"..vehID.." doesn't exist!", thePlayer, 255, 0, 0)
					return false
				end
				
				-- if row["vjob"] ~= "-1" then
					-- outputChatBox("You can't /checkveh on a city hall job's vehicle.", thePlayer, 255, 0, 0)
					-- return false
				-- end
				
				local result = {}
				
				table.insert(result, { row["vID"], row["vModel"], row["vPosX"], row["vPosY"], row["vPosZ"], row["vFuel"], row["vPaintjob"], 
				row["vHp"], row["vPlate"], row["fFactionName"], row["cOwner"], row["vCurrdimension"], row["vCurrInterior"], row["vImpounded"],
				row["aCreator"],row["vPlate"], row["vOdometer"],  row["vSuspensionLowerLimit"], row["vDriveType"], row["vNote"], 
				row["vDeleted"], row["vChopped"],row["vStolen"], row["vLastUsed"], row["vCreationDate"], row["registered"] })
				
				local result2 = {}
				dbQuery(function(qh, thePlayer)
					local res, rows, err = dbPoll(qh, 0)
					if rows > 0 then
						for index, row2 in ipairs(res) do
							if row2 then
								table.insert(result2, { row2["date"], row2["action"], row2["adminname"], row2["logid"], row2["vehID"]})
							end
						end
						notes = {}
						dbQuery(function(qh, thePlayer)
							local res, rows, err = dbPoll(qh, 0)
							if rows > 0 then
								for index, row2 in ipairs(res) do
									row2.creatorname = formatCreator(row2.creatorname, row2.creator)
									table.insert(notes, row2)
								end
							end
							triggerClientEvent(thePlayer, "createCheckVehWindow", thePlayer, result, exports.rl_global:getPlayerAdminTitle(thePlayer), result2, notes)
						end, {thePlayer}, mysql:getConnection(), "SELECT n.id, n.note, a.username AS creatorname, n.date, n.creator FROM vehicle_notes n LEFT JOIN accounts a ON n.creator=a.id WHERE n.vehid="..vehID.." ORDER BY n.date DESC")
					end
				end, {thePlayer}, mysql:getConnection(), "SELECT `vehicle_logs`.`date` AS `date`, `vehicle_logs`.`vehID` as `vehID`, `vehicle_logs`.`action` AS `action`, `accounts`.`username` AS `adminname`, `vehicle_logs`.`log_id` AS `logid` FROM `vehicle_logs` LEFT JOIN `accounts` ON `vehicle_logs`.`actor` = `accounts`.`id` WHERE `vehicle_logs`.`vehID` = '"..vehID.."' ORDER BY `vehicle_logs`.`date` DESC")
			end
		end, {thePlayer}, mysql:getConnection(), "SELECT `vehicles`.`job` AS `vjob`,`vehicles`.`id` AS `vID`, `vehicles`.`model` AS `vModel`, `vehicles`.`currx` AS `vPosX`, `vehicles`.`curry` AS `vPosY`, `vehicles`.`currz` AS `vPosZ`, `vehicles`.`fuel` AS `vFuel`, `vehicles`.`paintjob` AS `vPaintjob`,	`vehicles`.`hp` AS `vHp`, `factions`.`name` AS `fFactionName`, `characters`.`name` AS `cOwner`, `vehicles`.`job` AS `vJob`, `vehicles`.`tintedwindows` AS `vTintedwindows`,	`vehicles`.`currdimension` AS `vCurrdimension`,	`vehicles`.`currinterior` AS `vCurrInterior`, `vehicles`.`impounded` AS `vImpounded`, `vehicles`.`plate` AS `vPlate`, `vehicles`.`registered` AS `registered`, `vehicles`.`odometer` AS `vOdometer`, `vehicles`.`suspensionLowerLimit` AS `vSuspensionLowerLimit`,	`vehicles`.`driveType` AS `vDriveType`,	(SELECT `username` FROM `accounts` WHERE `id` = `vehicles`.`deleted`) AS `vDeleted`,	`vehicles`.`chopped` AS `vChopped`,	`vehicles`.`stolen` AS `vStolen`,	DATEDIFF(NOW(), `vehicles`.`lastUsed`) AS `vLastUsed`,	`vehicles`.`creationDate` AS `vCreationDate`,	`accounts`.`username` AS `aCreator` FROM `vehicles` LEFT JOIN `characters` ON `vehicles`.`owner`=`characters`.`id` LEFT JOIN `accounts` ON `vehicles`.`createdBy`=`accounts`.`id` LEFT JOIN `factions` ON`vehicles`.`faction`=`factions`.`id` WHERE `vehicles`.`id`='"..vehID.."' ORDER BY `vehicles`.`creationDate` DESC")
	end
end
addCommandHandler("checkveh", checkVeh)
addCommandHandler("checkvehicle", checkVeh)
addEvent("vehicleManager:checkveh", true)
addEventHandler("vehicleManager:checkveh", root, checkVeh)

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

function saveAdminNote(vehID, adminNote, noteId) 
	if client ~= source then
		return
	end
	
	if not vehID or not adminNote then
		outputChatBox("Internal Error!", source, 255,0,0)
		return false
	end

	if string.len(adminNote) > 500 then
		outputChatBox("Admin note has failed to add. Reason: Exceeded 500 characters.", source, 255, 0, 0)
		return false
	end

	if noteId then
		if dbExec(mysql:getConnection(), "UPDATE vehicle_notes SET note='"..(adminNote).."', creator="..getElementData(source, "account_id").." WHERE id ="..noteId.." AND vehid="..vehID) then
			outputChatBox("You have successfully updated admin note entry #"..noteId.." on vehicle #"..vehID..".", source, 0, 255,0)
			addVehicleLogs(vehID, "Modified admin note entry #"..noteId, source)
			return true
		end
	else
		local insertedId = dbExec(mysql:getConnection(), "INSERT INTO vehicle_notes SET note='"..(adminNote).."', creator="..getElementData(source, "account_id")..", vehid="..vehID) 
		if insertedId then
			outputChatBox("You have successfully added a new admin note entry to vehicle #"..vehID..".", source, 0, 255,0)
			addVehicleLogs(vehID, "Added new admin note.", source)
			return true
		end
	end
end
addEvent("vehicleManager:saveAdminNote", true)
addEventHandler("vehicleManager:saveAdminNote", root, saveAdminNote)

function systemDeleteVehicle(vehid, reason)
	if vehid and tonumber(vehid) then
		vehid = tonumber(vehid)
	else 
		return false, "veh id is missing or invalid"
	end
	call(getResourceFromName("rl_items"), "deleteAll", 3 , vehid)

	dbQuery(function(qh)
		local res, rows = dbPoll(qh, 0)
		if rows > 0 then
			dbExec(mysql:getConnection(), "UPDATE vehicles SET deleted=-1 WHERE id='" .. vehid .. "'")
			dbExec(mysql:getConnection(), "DELETE FROM vehicles_custom WHERE id='" .. vehid .. "'")

			addVehicleLogs(vehid, reason and reason or "DELETED BY SYSTEM")


			local theVehicle = exports.rl_pool:getElement("vehicle", vehid)
			if theVehicle then
				destroyElement(theVehicle)
				return true
			else
				return true, "vehicle is not loaded in game so only cleaned up in database."
			end
		else
			return false
		end
	end, mysql:getConnection(), "SELECT id FROM vehicles WHERE id="..vehid.." LIMIT 1")
end