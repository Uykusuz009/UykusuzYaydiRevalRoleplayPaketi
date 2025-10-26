local rc = 10
local bmx = 0
local bike = 15
local low = 25
local offroad = 35
local sport = 100
local van = 50
local bus = 75
local truck = 200
local boat = 300
local heli = 500
local plane = 750
local race = 75
local minute = 10
local spawnedShopVehicles = {}
local vehicleTaxes = {
	offroad, low, sport, truck, low, low, 1000, truck, truck, 200, -- dumper, stretch
	low, sport, low, van, van, sport, truck, heli, van, low,
	low, low, low, van, low, 1000, low, truck, van, sport, -- hunter
	boat, bus, 1000, truck, offroad, van, low, bus, low, low, -- rhino
	van, rc, low, truck, 500, low, boat, heli, bike, 0, -- monster, tram
	van, sport, boat, boat, boat, truck, van, 10, low, van, -- caddie
	plane, bike, bike, bike, rc, rc, low, low, bike, heli,
	van, bike, boat, 20, low, low, plane, sport, low, low, -- dinghy
	sport, bmx, van, van, boat, 10, 75, heli, heli, offroad, -- baggage, dozer
	offroad, low, low, boat, low, offroad, low, heli, van, van,
	low, rc, low, low, low, offroad, sport, low, van, bmx,
	bmx, plane, plane, plane, truck, truck, low, low, low, plane,
	plane * 10, bike, bike, bike, truck, van, low, low, truck, low, -- hydra
	10, 20, offroad, low, low, low, low, 0, 0, offroad, -- forklift, tractor, 2x train
	low, sport, low, van, truck, low, low, low, rc, low,
	low, low, van, plane, van, low, 500, 500, race, race, -- 2x monster
	race, low, race, heli, rc, low, low, low, offroad, 0, -- train trailer
	0, 10, 10, offroad, 15, low, low, 3*plane, truck, low,-- train trailer, kart, mower, sweeper, at400
	low, bike, van, low, van, low, bike, race, van, low,
	0, van, 2*plane, plane, rc, boat, low, low, low, offroad, -- train trailer, andromeda
	low, truck, race, sport, low, low, low, low, low, van,
	low, low
}

local global = exports.rl_global
local mysql = exports.rl_mysql
local currentYear = getRealTime().year+1900

function SmallestID()
	local result = dbPoll(dbQuery(mysql:getConnection(), "SELECT MIN(e1.id+1) AS nextID FROM vehicles AS e1 LEFT JOIN vehicles AS e2 ON e1.id +1 = e2.id WHERE e2.id IS NULL"), -1)
	if result then
		local id = tonumber(result[1]["nextID"]) or 1
		return id
	end
	return false
end

function carshop_updateVehicles(forceUpdate)
	for i, veh in pairs(spawnedShopVehicles) do
		if veh[1] and isElement(veh[1]) and getElementType(veh[1]) == "vehicle" then
			destroyElement(veh[1])
			destroyElement(veh[2])
		end
	end
	spawnedShopVehicles = {}
	
	local blocking = {}
	
	for key, value in ipairs(getElementsByType("player")) do
		local x, y, z = getElementPosition(value)
		table.insert(blocking, { x, y, z, getElementInterior(value), getElementDimension(value), true })
	end
	
	for key, value in ipairs(getElementsByType("vehicle")) do
		local x, y, z = getElementPosition(value)
		table.insert(blocking, { x, y, z, getElementInterior(value), getElementDimension(value), false, value })
	end
	
	for dealerID = 1, #shops do
		if #shops[dealerID]["spawnpoints"] > 0 then
			for k, v in ipairs(shops[dealerID]["spawnpoints"]) do
				local canPopulate2 = true
				for _, va in ipairs(blocking) do
					if (v[4] == va[4] and v[5] == va[5]) then
						local distance = getDistanceBetweenPoints3D(v[1], v[2], v[3], va[1], va[2], va[3])
						if distance < 4 then
							canPopulate2 = false
							if va[7] and isElement(va[7]) and getElementType(va[7]) == "vehicle" then
								respawnVehicle(va[7])
							end
							break
						end
					end
				end
				
				getRandomVehicleFromCarshop(dealerID, function(vehicleData)
					if canPopulate2 and vehicleData then
						local plate = "SATILIK"
						local model = tonumber(vehicleData.vehmtamodel)
						
						local vehicle = createVehicle(model, v[1], v[2], v[3], v[4], v[5], v[6], plate)
						local vehBrand = vehicleData["vehbrand"]
						local vehModel = vehicleData["vehmodel"]
						local vehPrice = tonumber(vehicleData["vehprice"])
						local vehTax = tonumber(vehicleData["vehtax"])
						local vehYear = tonumber(vehicleData["vehyear"])

						local odometer = 0
						if vehYear < currentYear - 1 then
							local yearsSince = currentYear - vehYear - 1
							for i = 1, yearsSince do
								odometer = odometer + math.random(60, 500)
							end
						end

						local vehicle_shop_id = tonumber(vehicleData["id"])
						if vehicle and vehBrand and vehModel and vehPrice and vehTax and vehYear and vehicle_shop_id then
							setElementInterior(vehicle, v[4])
							setElementDimension(vehicle, v[5])
							setVehicleLocked(vehicle, true)
							setTimer(setElementFrozen, 180, 1, vehicle, true)
							setVehicleDamageProof(vehicle, true)
							setVehicleVariant(vehicle, exports.rl_vehicle:getRandomVariant(getElementModel(vehicle)))
							v["vehicle"] = vehicle

							local x = v[1] - ((math.cos (math.rad ( v[6]))) * 1.5)
							local y = v[2] - ((math.sin (math.rad ( v[6]))) * 1.5)
							local tempPickup = nil 
							if dealerID == 6 then
								tempPickup = createPickup(v[1], v[2], v[3]+1, 3, 1)
							else
								tempPickup = createPickup(x, y, v[3], 3, 1)
							end
							table.insert(spawnedShopVehicles, {vehicle, tempPickup})
							setElementData(tempPickup, "carshop:parentCar", v["vehicle"])
							
							setElementData(v["vehicle"], "brand", vehBrand)
							setElementData(v["vehicle"], "model", vehModel)
							setElementData(v["vehicle"], "year", vehYear)
							setElementData(v["vehicle"], "odometer", odometer)
							setElementData(v["vehicle"], "carshop:cost", vehPrice)
							setElementData(v["vehicle"], "carshop", dealerID)
							setElementData(v["vehicle"], "carshop:childPickup", tempPickup)
							setElementData(v["vehicle"], "carshop:taxcost", vehTax)
							setElementData(v["vehicle"], "dbid", -1)
							
							setElementData(v["vehicle"], "vehicle_shop_id", vehicle_shop_id)
							for i = 1, 5, 1 do
								setElementData(v["vehicle"], "description:" .. i, "")
							end
							
							notifyEveryoneWhoOrderedThisModel(shops[dealerID]["name"], shops[dealerID]["nicename"], vehicle_shop_id, vehYear, vehBrand, vehModel, vehPrice)
						end
					end
				end)
			end
		end
	end
end

function carshop_Initalize()
	carshop_updateVehicles(true)	
	setTimer(carshop_updateVehicles, 1000 * 60 * minute, 0, false)
end
addEventHandler("onResourceStart", resourceRoot, carshop_Initalize)

function carshop_blockEnterVehicle(thePlayer)
	local isCarShop = getElementData(source, "carshop")
	if (isCarShop) then
		local costCar = getElementData(source, "carshop:cost")
		
		local payByCash = true
		local payByBank = true
		
		if not exports.rl_global:hasMoney(thePlayer, costCar) or costCar == 0 then
			payByCash = false
		end
		
		local money = getElementData(thePlayer, "bank_money") - costCar
		if money < 0 or costCar == 0 then
			payByBank = false
		end
		
		triggerClientEvent(thePlayer, "carshop:buyCar", source, costCar, payByCash, payByBank)
	end
	cancelEvent()
end
addEventHandler("onVehicleEnter", resourceRoot, carshop_blockEnterVehicle)
addEventHandler("onVehicleStartEnter", resourceRoot, carshop_blockEnterVehicle)

function carshop_buyVehicle(paymentMethod)
	if not client then
		return false
	end
	
	local isCarshopVehicle = getElementData(source, "carshop")
	if not isCarshopVehicle then
		return false
	end
	
	local isOverlayDisabled = getElementData(client, "hud:isOverlayDisabled")

	if not exports.rl_global:canPlayerBuyVehicle(client) then
		outputChatBox("[!]#FFFFFF Araç limitini aştınız ve başka bir araç satın alamıyorsunuz.", client, 255, 0, 0, true)
		playSoundFrontEnd(client, 4)
		return false
	end
	
	local costCar = getElementData(source, "carshop:cost")
	if (paymentMethod == "cash") then
		if not exports.rl_global:hasMoney(client, costCar) or costCar == 0 then
			outputChatBox("[!]#FFFFFF Bu araç için yeterli paranız yok.", client, 255, 0, 0, true)
			playSoundFrontEnd(client, 4)
			return false
		else
			exports.rl_global:takeMoney(client, costCar)
		end
	elseif (paymentMethod == "bank") then
		local money = getElementData(client, "bank_money") - costCar
		if money < 0 or costCar == 0 then
			outputChatBox("[!]#FFFFFF Banka hesabınızda bu araç için yeterli para yok.", client, 255, 0, 0, true)
			playSoundFrontEnd(client, 4)
			return false
		else
			setElementData(client, "bank_money", money)
			dbExec(mysql:getConnection(), "UPDATE characters SET bank_money = ? WHERE id = ?", (tonumber(money) or 0), getElementData(client, "dbid"))
		end
	end
	
	local dbid = getElementData(client, "dbid")
	local modelID = getElementModel(source)
	local x, y, z = getElementPosition(source)
	local rx, ry, rz = getElementRotation(source)
	local odometer = tonumber(getElementData(source, "odometer")) * 1000
	local col = { getVehicleColor(source) }
	local color1 = toJSON({col[1], col[2], col[3]})
	local color2 = toJSON({col[4], col[5], col[6]})
	local color3 = toJSON({col[7], col[8], col[9]})
	local color4 = toJSON({col[10], col[11], col[12]})
	local var1, var2 = getVehicleVariant(source)
	local plate = exports.rl_global:generatePlate()
	local locked = 1
	local vehShopID = getElementData(source, "vehicle_shop_id") or 0
	local smallestID = SmallestID()
	local insertid = dbExec(mysql:getConnection(), "INSERT INTO vehicles SET id=?, model=?, x=?, y=?, z=?, rotx=?, roty=?, rotz=?, color1=?, color2=?, color3=?, color4=?, faction='-1', owner=?, plate=?, currx=?, curry=?, currz=?, currrx='0', currry='0', currrz=?, locked=?, variant1=?, variant2=?, description1='', description2='', description3='', description4='', description5='', creationDate=NOW(), createdBy='-1', vehicle_shop_id=?, odometer=?", smallestID, modelID, x, y, z, rx, ry, rz, color1, color2, color3, color4, dbid, plate, x, y, z, rz, locked, var1, var2, vehShopID, odometer)
	insertid = smallestID
	
	if not insertid then
		return false
	end
	
	call(getResourceFromName("rl_items"), "deleteAll", 3, insertid)
	exports.rl_global:giveItem(client, 3, insertid)		
	local tempPickup = getElementData(source,"carshop:childPickup")
	if (isElement(tempPickup)) then
		destroyElement(tempPickup)
	end
	destroyElement(source)					
	exports.rl_vehicle:reloadVehicle(insertid)
	
	outputChatBox("[!]#FFFFFF Aracınızı başarıyla satın aldınız, güvenli sürüşler dileriz.", client, 0, 255, 0, true)
	
	local adminID = getElementData(client, "account_id")	
	local addLog = dbExec(mysql:getConnection(), "INSERT INTO `vehicle_logs` (`vehID`, `action`, `actor`) VALUES (?, 'bought from carshop', ?)", tostring(insertid), adminID) or false
	if addLog then
		triggerEvent("vehicle-manager:handling:orderVehicle:cancel", client)
	end
end
addEvent("carshop:buyCar", true)
addEventHandler("carshop:buyCar", root, carshop_buyVehicle)

local vehicleColors
function getRandomVehicleColor(vehicle)
	if not vehicleColors then
		vehicleColors = {}
		local file = fileOpen("vehiclecolors.conf", true)
		while not fileIsEOF(file) do
			local line = fileReadLine(file)
			if #line > 0 and line:sub(1, 1) ~= "#" then
				local model = tonumber(gettok(line, 1, string.byte(' ')))
				if not vehicleColors[model] then
					vehicleColors[model] = {}
				end
				vehicleColors[model][#vehicleColors[model] + 1] = {
					tonumber(gettok(line, 2, string.byte(' '))),
					tonumber(gettok(line, 3, string.byte(' '))) or nil,
				}
			end
		end
		fileClose(file)
	end
	
	local colors = vehicleColors[getElementModel(vehicle)]
	if colors then
		return unpack(colors[math.random(1, #colors)])
	end
end

function fileReadLine(file)
	local buffer = ""
	local tmp
	repeat
		tmp = fileRead(file, 1) or nil
		if tmp and tmp ~= "\r" and tmp ~= "\n" then
			buffer = buffer .. tmp
		end
	until not tmp or tmp == "\n" or tmp == ""
	
	return buffer
end

function isForSale(vehicle)
	if type(vehicle) == "number" then
	elseif type(vehicle) == "string" then
		vehicle = tonumber(vehicle)
	elseif isElement(vehicle) and getElementType(vehicle) == "vehicle" then
		vehicle = getElementModel(vehicle)
	else
		return false
	end
	for _, shop in ipairs(shops) do
		for _, data in ipairs(shop.prices) do
			if getVehicleModelFromName(data[1]) == vehicle then
				return true
			end
		end
	end
	return false
end

function notifyEveryoneWhoOrderedThisModel(shopname, shopnicename, vehicle_shop_id, vehYear, vehBrand, vehModel, vehPrice)
	for i, player in pairs (getElementsByType("player")) do
		if shopname and shopnicename and vehicle_shop_id and vehYear and vehBrand and vehModel and vehPrice then
			local orderedVehID = getElementData(player, "carshop:grotti:orderedvehicle:" .. shopname) or false
			if orderedVehID and tonumber(orderedVehID) == tonumber(vehicle_shop_id) then
				if exports.rl_global:hasItem(player, 2) then
					local itemName = vehYear .. " " .. vehBrand .. " " .. vehModel
					exports.rl_global:sendLocalDoAction(player, "Telefondan kısa mesaj aldı.")
					outputChatBox(">>#FFFFFF " .. shopnicename .. " (SMS): Merhaba! Sipariş ettiğiniz gibi " .. itemName .. " şimdi " .. exports.rl_global:formatMoney(vehPrice) .. "$'a depoda.", player, 0, 255, 0, true)
				end
			end
		end
	end
end

function getRandomVehicleFromCarshop(shopID, callback)
    if shopID and tonumber(shopID) then
        dbQuery(function(qh)
            local results, rows = dbPoll(qh, -1)
            if results then
                local tempTable = {}
                for _, row in ipairs(results) do
                    table.insert(tempTable, row)
                end
                
                if #tempTable > 0 then
                    local ran = math.random(1, #tempTable)
                    callback(tempTable[ran])
                else
                    callback(false)
                end
            else
                callback(false)
            end
        end, mysql:getConnection(), "SELECT * FROM vehicles_shop WHERE enabled = 1 AND spawnto = ?", shopID)
    else
        callback(false)
    end
end