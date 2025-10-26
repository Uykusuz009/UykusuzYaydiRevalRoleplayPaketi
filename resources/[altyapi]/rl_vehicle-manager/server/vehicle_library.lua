﻿mysql = exports.rl_mysql

function getRealDoorType(doortype)
	if doortype == 1 or doortype == 2 then
		return doortype
	end
	return nil
end

function refreshCarShop()
	local theResource = getResourceFromName("rl_carshop")
	if theResource then
		local hiddenAdmin = getElementData(client, "hidden_admin")
		if getResourceState(theResource) == "running" then
			restartResource(theResource)
			outputChatBox("Carshops were restarted.", client, 0, 255, 0)
			if not hiddenAdmin then
				exports.rl_global:sendMessageToAdmins("[VEHICLE MANAGER]" .. getPlayerName(client) .. " restarted the carshops.")
			else
				exports.rl_global:sendMessageToAdmins("[VEHICLE MANAGER] Gizli Yetkili restarted the carshops.")
			end
		elseif getResourceState(theResource) == "loaded" then
			startResource(theResource)
			outputChatBox("Carshops were started", client, 0, 255, 0)
			if not hiddenAdmin then
				exports.rl_global:sendMessageToAdmins("[VEHICLE MANAGER] " .. getPlayerName(client) .. " started the carshops.")
			else
				exports.rl_global:sendMessageToAdmins("[VEHICLE MANAGER] Gizli Yetkili started the carshops.")
			end
		elseif getResourceState(theResource) == "failed to load" then
			outputChatBox("Carshop's could not be loaded (" .. getResourceLoadFailureReason(theResource) .. ")", client, 255, 0, 0)
		end
	end
end
addEvent("vehlib:refreshcarshops", true)
addEventHandler("vehlib:refreshcarshops", root, refreshCarShop)

function sendLibraryToClient(ped)
	if source then 
		client = source
	end
	
	local vehs = {}
	local mQuery1 = nil
	local preparedQ = "SELECT `spawnto`, `id`, `vehmtamodel`, `vehbrand`, `vehmodel`, `vehyear`, `vehprice`, `vehtax`, (SELECT `username` FROM `accounts` WHERE `accounts`.`id`=`vehicles_shop`.`createdby`) AS 'createdby', `createdate`, (SELECT `username` FROM `accounts` WHERE `accounts`.`id`=`vehicles_shop`.`updatedby`) AS 'updatedby', `updatedate`, `notes`, `enabled` FROM `vehicles_shop`"
	if ped and isElement(ped) then
		local shopName = getElementData(ped, "carshop")
		if shopName == "grotti" then
			preparedQ = preparedQ.." WHERE `spawnto`='1'"
		elseif shopName == "JeffersonCarShop" then
			preparedQ = preparedQ.." WHERE `spawnto`='2'"
		elseif shopName == "IdlewoodBikeShop" then
			preparedQ = preparedQ.." WHERE `spawnto`='3'"
		elseif shopName == "SandrosCars" then
			preparedQ = preparedQ.." WHERE `spawnto`='4'"
		elseif shopName == "IndustrialVehicleShop" then
			preparedQ = preparedQ.." WHERE `spawnto`='5'"
		elseif shopName == "BoatShop" then
			preparedQ = preparedQ.." WHERE `spawnto`='6'"
		end
	end
	preparedQ = preparedQ

	dbQuery(function(qh, client)
		local res, rows, err = dbPoll(qh, 0)
		if rows > 0 then
			for index, value in ipairs(res) do
				table.insert(vehs, value)
			end
			triggerClientEvent(client, "vehlib:showLibrary", client, vehs, ped)
		end
	end, {client}, mysql:getConnection(), preparedQ)
end
addEvent("vehlib:sendLibraryToClient", true)
addEventHandler("vehlib:sendLibraryToClient", root, sendLibraryToClient)

function openVehlib(thePlayer)
	if exports.rl_integration:isPlayerTrialAdmin(thePlayer) then
		triggerEvent("vehlib:sendLibraryToClient", thePlayer)
	end
end
addCommandHandler("vehlib", openVehlib)
addCommandHandler("vehiclelibrary", openVehlib)

function createVehicleRecord(data)
	if not data then
		outputDebugString("VEHICLE MANAGER / VEHICLE LIB / createVehicleRecord / NO DATA RECIEVED FROM CLIENT")
		return false
	end
	
	local enabled = "0"
	if data.enabled then
		enabled = "1"
	end

	data.doortype = getRealDoorType(data.doortype) or 'NULL'
	
	if not data.update then
		local mQuery1 = dbExec(mysql:getConnection(), "INSERT INTO vehicles_shop SET vehmtamodel='"..toSQL(data["mtaModel"]).."', vehbrand='"..toSQL(data["brand"]).."', vehmodel='"..toSQL(data["model"]).."', vehyear='"..toSQL(data["year"]).."', vehprice='"..toSQL(data["price"]).."', vehtax='"..toSQL(data["tax"]).."', createdby='"..toSQL(getElementData(client, "account_id")).."', notes='"..toSQL(data["note"]).."', enabled='"..toSQL(enabled).."', `spawnto`='"..toSQL(data["spawnto"]).."', `doortype` = " .. data.doortype)
		if not mQuery1 then
			outputDebugString("VEHICLE MANAGER / VEHICLE LIB / createVehicleRecord / DATABASE ERROR")
			outputChatBox("[VEHICLE MANAGER] Failed to create new vehicle in library.", client, 255,0,0)
			return false
		end
		sendLibraryToClient(client)
		outputChatBox("[VEHICLE MANAGER] New vehicle created in library.", client, 0,255,0)
		exports.rl_global:sendMessageToAdmins("[ADM] "..getElementData(client, "account_username").." has created new vehicle in library.")
		return true
	else
		if data.copy then
			local mQuery1 = dbExec(mysql:getConnection(), "INSERT INTO vehicles_shop SET vehmtamodel='"..toSQL(data["mtaModel"]).."', vehbrand='"..toSQL(data["brand"]).."', vehmodel='"..toSQL(data["model"]).."', vehyear='"..toSQL(data["year"]).."', vehprice='"..toSQL(data["price"]).."', vehtax='"..toSQL(data["tax"]).."', createdby='"..toSQL(getElementData(client, "account_id")).."', notes='"..toSQL(data["note"]).."' , enabled='"..toSQL(enabled).."', `spawnto`='"..toSQL(data["spawnto"]).."', `doortype` = " .. data.doortype)
			if not mQuery1 then
				outputDebugString("VEHICLE MANAGER / VEHICLE LIB / createVehicleRecord / DATABASE ERROR")
				outputChatBox("[VEHICLE MANAGER] Failed to create new vehicle in library.", client, 255,0,0)
				return false
			end
			sendLibraryToClient(client)
			outputChatBox("[VEHICLE MANAGER] New vehicle created in library.", client, 0,255,0)
			exports.rl_global:sendMessageToAdmins("[ADM] "..getElementData(client, "account_username").." has created new vehicle in library.")
			return true
		else
			local mQuery1 = dbExec(mysql:getConnection(), "UPDATE vehicles_shop SET vehmtamodel='"..toSQL(data["mtaModel"]).."', vehbrand='"..toSQL(data["brand"]).."', vehmodel='"..toSQL(data["model"]).."', vehyear='"..toSQL(data["year"]).."', vehprice='"..toSQL(data["price"]).."', vehtax='"..toSQL(data["tax"]).."', updatedby='"..toSQL(getElementData(client, "account_id")).."', notes='"..toSQL(data["note"]).."', updatedate=NOW(), enabled='"..toSQL(enabled).."', `spawnto`='"..toSQL(data["spawnto"]).."',`doortype` = " .. data.doortype .. " WHERE id='"..toSQL(data["id"]).."' ")
			if not mQuery1 then
				outputDebugString("VEHICLE MANAGER / VEHICLE LIB / UPDATEVEHICLE / DATABASE ERROR")
				outputChatBox("[VEHICLE MANAGER] Update vehicle #"..data.id.." from vehicle library failed.", client, 255,0,0)
				return false
			end
			sendLibraryToClient(client)
			outputChatBox("[VEHICLE MANAGER] You have updated vehicle #"..data.id.." from vehicle library.", client, 0,255,0)
			exports.rl_global:sendMessageToAdmins("[ADM] "..getElementData(client, "account_username").." has updated vehicle #"..data.id.." in library.")
			return true
		end
	end
end
addEvent("vehlib:createVehicle", true)
addEventHandler("vehlib:createVehicle", root, createVehicleRecord)

function getCurrentVehicleRecord(id)
	dbQuery(
		function(qh, client)
			local res, rows, err = dbPoll(qh, 0)
			if rows > 0 then
				for index, row in ipairs(res) do
					local veh = {}
					veh.id = row.id
					veh.mtaModel = row.vehmtamodel
					veh.brand = row.vehbrand
					veh.model = row.vehmodel
					veh.price = row.vehprice
					veh.tax = row.vehtax
					veh.year = row.vehyear
					veh.enabled = row.enabled
					veh.update = true
					veh.spawnto = row.spawnto
					veh.doortype = getRealDoorType(tonumber(row.doortype))
					triggerClientEvent(client, "vehlib:showEditVehicleRecord", client, veh)
				end
			end
		end,
	{client}, mysql:getConnection(), "SELECT * FROM vehicles_shop WHERE id = '" .. (id) .. "' LIMIT 1")
end
addEvent("vehlib:getCurrentVehicleRecord", true)
addEventHandler("vehlib:getCurrentVehicleRecord", root, getCurrentVehicleRecord)

function deleteVehicleFromLibraby(id)
	if not id then
		outputDebugString("VEHICLE MANAGER / VEHICLE LIB / DELETEVEHICLE / NO DATA RECIEVED FROM CLIENT")
		return false
	end
	
	local mQuery1 = dbExec(mysql:getConnection(), "DELETE FROM vehicles_shop WHERE id='"..toSQL(id).."' ")
	if not mQuery1 then
		outputDebugString("VEHICLE MANAGER / VEHICLE LIB / DELETEVEHICLE / DATABASE ERROR")
		outputChatBox("[VEHICLE MANAGER] Deleted vehicle #"..id.." from vehicle library failed.", client, 255,0,0)
		return false
	end
	outputChatBox("[VEHICLE MANAGER] You have deleted vehicle #"..id.." from vehicle library.", client, 0,255,0)
	sendLibraryToClient(client)
	return true
end
addEvent("vehlib:deleteVehicle", true)
addEventHandler("vehlib:deleteVehicle", root, deleteVehicleFromLibraby)

function loadCustomVehProperties(vehID, theVehicle)
	if not vehID or not tonumber(vehID) then
		return false
	else
		vehID = tonumber(vehID)
	end
	
	if not theVehicle or not isElement(theVehicle) or not getElementType(theVehicle) == "vehicle" then
		local allVehicles = getElementsByType("vehicle")
		for i, veh in pairs (allVehicles) do
			if tonumber(getElementData(veh, "dbid")) == vehID then
				theVehicle = veh
				break
			end
		end
	end

	if not theVehicle then
		return false
	end
	
	local toBeSet = {} 
	local customHandlings, baseHandlings = nil, nil
	local hasCustomInfo = false
	local res = dbPoll(dbQuery(mysql:getConnection(), "SELECT * FROM `vehicles_custom` WHERE `id` = '" .. (vehID) .. "' LIMIT 1"), -1)
	if res then
		for index, rowVehCustom in ipairs(res) do
			toBeSet.brand = rowVehCustom.brand
			toBeSet.model = rowVehCustom.model
			toBeSet.year = rowVehCustom.year
			toBeSet.price = rowVehCustom.price
			toBeSet.tax = rowVehCustom.tax
			toBeSet.duration = rowVehCustom.duration
			toBeSet.doortype = getRealDoorType(tonumber(rowVehCustom.doortype))
			customHandlings = rowVehCustom.handling
			if rowVehCustom.brand and rowVehCustom.brand ~= "" then
				hasCustomInfo = true
	            setElementData(theVehicle, "unique", true, true)
			end
		end
	end
	
	local vehicleShopID = getElementData(theVehicle, "vehicle_shop_id") or 0
	
	if vehicleShopID and vehicleShopID ~= 0 then
		local res = dbPoll(dbQuery(mysql:getConnection(), "SELECT * FROM `vehicles_shop` WHERE `id` = '" .. (vehicleShopID) .. "' AND `enabled`='1' LIMIT 1"), -1)
		if res then
			for index, rowVehShop in ipairs(res) do
				if not hasCustomInfo then
					toBeSet.brand = rowVehShop.vehbrand
					toBeSet.model = rowVehShop.vehmodel
					toBeSet.year = rowVehShop.vehyear
					toBeSet.price = rowVehShop.vehprice
					toBeSet.tax = rowVehShop.vehtax
					toBeSet.doortype = getRealDoorType(tonumber(rowVehShop.doortype))
					toBeSet.duration = rowVehShop.duration
				end

				baseHandlings = rowVehShop.handling
			end
		end
	end
	
	setElementData(theVehicle, "vehicle_shop_id", vehicleShopID)
	
	if toBeSet.brand then
		setElementData(theVehicle, "brand", toBeSet.brand)
		setElementData(theVehicle, "model", toBeSet.model)
		setElementData(theVehicle, "year", toBeSet.year)
		setElementData(theVehicle, "carshop:cost", toBeSet.price)
		setElementData(theVehicle, "carshop:taxcost", toBeSet.tax)
		setElementData(theVehicle, "vDoorType", toBeSet.doortype)
	end
	
	local hasCustomHandling = false
	if customHandlings and type(customHandlings) == "string" then
		local h = fromJSON(customHandlings)
		if h then
			for i = 1, #handlings do 
				if i ~= 29 then -- I don't know why this isn't working in 1.4. Temporarily disable this stat / Maxime
					setVehicleHandling(theVehicle, handlings[i][1], h[i] or h[tostring(i)])
				end
				--outputDebugString(h[tostring(i)])
			end
			hasCustomHandling = true
			--outputDebugString("Loaded custom handlings to veh #"..getElementData(theVehicle, "dbid"))
		end
	end
	
	if not hasCustomHandling then
		if baseHandlings and type(baseHandlings) == "string" then
			local h = fromJSON(baseHandlings)
			if h then
				for i = 1, #handlings do 
					if i ~= 29 then -- I don't know why this isn't working in 1.4. Temporarily disable this stat / Maxime
						setVehicleHandling(theVehicle, handlings[i][1], h[i] or h[tostring(i)])
					end
					--outputDebugString(handlings[i][1].." - ".. h[i])
				end
			end
			--outputDebugString("Loaded base handlings to veh #"..getElementData(theVehicle, "dbid"))
		end
	end
	
	return true
end
addEvent("vehlib:loadCustomVehProperties", true)
addEventHandler("vehlib:loadCustomVehProperties", root, loadCustomVehProperties)

function toSQL(stuff)
	return (stuff)
end

function SmallestID()
	local result = dbPoll(dbQuery(mysql:getConnection(), "SELECT MIN(e1.id+1) AS nextID FROM vehicles_shop AS e1 LEFT JOIN vehicles_shop AS e2 ON e1.id +1 = e2.id WHERE e2.id IS NULL"), -1)
	if result then
		local id = tonumber(result[1]["nextID"]) or 1
		return id
	end
	return false
end