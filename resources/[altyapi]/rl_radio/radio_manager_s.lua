function addPurchaseHistory(thePlayer, perkName, cost)
	return true
end

function fetchStations()
	dbQuery(function(qh)
		local res, rows, err = dbPoll(qh, 0)
		if rows > 0 then
			for index, row in ipairs(res) do
				if type(row["owner"]) == "string" then
					table.insert(donorStations, row)
				else
					table.insert(defaultStations, row)
				end
			end
		end
	end, mysql:getConnection(), "SELECT `id`, `station_name`, `source`, (SELECT `username` FROM `` WHERE ``.`id`=`owner`) AS `owner`, `register_date`, `expire_date`, `enabled`, `order` FROM `radio_stations` WHERE (`expire_date` IS NULL) OR (`expire_date` > NOW()) ORDER BY `order` ")
	return defaultStations, donorStations
end

function openRadioManager()
	if source then
		client = source
	end
	local defaultStations, donorStations = fetchStations()
	triggerClientEvent(client, "openRadioManager", client, defaultStations, donorStations)
end
addEvent("openRadioManager", true)
addEventHandler("openRadioManager", root, openRadioManager)

function createNewStation(name, ip, donorStation)
	if name and ip then
		if donorStation then
			addPurchaseHistory(client, "Purchased new radio station (Name: '" .. name .. "', URL: '" .. ip .. "')", 10)
			local smallestID = SmallestID()
			dbExec(mysql:getConnection(), "INSERT INTO `radio_stations` SET `id`='" .. smallestID .. "', `station_name`='" .. exports.rl_global:toSQL(name) .. "', `source`='" .. exports.rl_global:toSQL(ip) .. "', `order`='" .. smallestID .. "', `owner`='" .. getElementData(client, "account_id") .. "', `expire_date`=(NOW() + interval 30 day) ")
			setElementData(client, "gui:ViewingRadioManager", true, true)
			forceUpdateClientsGUI()
		else
			local smallestID = SmallestID()
			dbExec(mysql:getConnection(), "INSERT INTO `radio_stations` SET `id`='" .. smallestID .. "', `station_name`='" .. exports.rl_global:toSQL(name) .. "', `source`='" .. exports.rl_global:toSQL(ip) .. "', `order`='" .. smallestID .. "'")
			forceUpdateClientsGUI()
		end
	end
end
addEvent("createNewStation", true)
addEventHandler("createNewStation", root, createNewStation)

function editStation(id, name, ip)
	if id and name and ip and dbExec(mysql:getConnection(), "UPDATE `radio_stations` SET `station_name`='" .. exports.rl_global:toSQL(name) .. "', `source`='" .. exports.rl_global:toSQL(ip) .. "' WHERE `id`='" .. id .. "'") then
		forceUpdateClientsGUI()
	end
end
addEvent("editStation", true)
addEventHandler("editStation", root, editStation)

function deleteStation(id)
	if id and dbExec(mysql:getConnection(), "DELETE FROM `radio_stations` WHERE `id`='" .. id .. "'") then
		forceUpdateClientsGUI()
	end
end
addEvent("deleteStation", true)
addEventHandler("deleteStation", root, deleteStation)

function togStation(id, state)
	if id and state and dbExec(mysql:getConnection(), "UPDATE `radio_stations` SET `enabled`='" .. (state == "Activated" and "1" or "0") .. "' WHERE `id`='" .. id .. "'") then
		forceUpdateClientsGUI()
	end
end
addEvent("togStation", true)
addEventHandler("togStation", root, togStation)

function moveStationPosition(id, name, order, movingUp, donorStation)
	if id and tonumber(id) and order and tonumber(order)  then
		id = tonumber(id)
		order = tonumber(order)
		if donorStation then
			addPurchaseHistory(client, "Moved radio station position (Name: '" .. name .. "', Direction: '" .. (movingUp and "Up" or "Down") .. "')", 1)
		end
		
		if movingUp then
			if order < 2 then
				return false
			end
			if dbExec(mysql:getConnection(), "UPDATE `radio_stations` SET `order`=`order`-1 WHERE `id`='" .. (id) .. "'") then
				forceUpdateClientsGUI()
			end
		else
			if dbExec(mysql:getConnection(), "UPDATE `radio_stations` SET `order`=`order`+1 WHERE `id`='" .. (id) .. "'") then
				forceUpdateClientsGUI()
			end
		end
	end
end
addEvent("moveStationPosition", true)
addEventHandler("moveStationPosition", root, moveStationPosition)

function renewStation(station, duration)
	if station and duration and tonumber(duration) then
		local id = station[1]
		local cost = nil
		if duration == 7 then
			cost = 3
		elseif duration == 30 then
			cost = 10
		elseif duration == 90 then
			cost = 25
		else
			return false
		end
		
		addPurchaseHistory(client, "Renewed radio station (ID: '" .. id .. "', Name: '" .. station[2] .. "', Duration: '" .. duration .. " days')", cost)
		
		if not dbExec(mysql:getConnection(), "UPDATE `radio_stations` SET `expire_date`=(`expire_date` + interval " .. duration .. " day) WHERE `id`='" .. (id) .. "'") then
			return false
		end
		
		forceUpdateClientsGUI()
	end
end
addEvent("renewStation", true)
addEventHandler("renewStation", root, renewStation)

function forceUpdateClientsGUI()
	local defaultStations, donorStations = fetchStations()
	for i, player in pairs(getElementsByType("player")) do
		if getElementData(player, "gui:ViewingRadioManager") then
			triggerClientEvent(player, "openRadioManager", player, defaultStations, donorStations)
		end
	end
end

function SmallestID()
	local result = dbPoll(dbQuery(mysql:getConnection(), "SELECT MIN(e1.id+1) AS nextID FROM vehicles AS e1 LEFT JOIN vehicles AS e2 ON e1.id +1 = e2.id WHERE e2.id IS NULL"), -1)
	if result then
		local id = tonumber(result["nextID"]) or 1
		return id
	end
	return false
end