local mysql = exports.rl_mysql

armoredCars = {
	[427] = true,
	[528] = true,
	[432] = true,
	[601] = true,
	[428] = true
}
leadplus = {
	[425] = true,
	[520] = true,
	[447] = true,
	[432] = true,
	[444] = true,
	[556] = true,
	[557] = true,
	[441] = true,
	[464] = true,
	[501] = true,
	[465] = true,
	[564] = true,
	[476] = true
}
totalTempVehicles = 0
respawnTimer = nil

addEvent("onVehicleDelete", false)

function getVehicleName(vehicle)
	return exports.rl_global:getVehicleName(vehicle)
end

function respawnTheVehicle(vehicle)
	setElementCollisionsEnabled(vehicle, true)
	respawnVehicle(vehicle)
end

function reloadVehicleByAdmin(thePlayer, commandName, vehID)
	if exports.rl_integration:isPlayerSeniorAdmin(thePlayer) then
		local veh = false
		if not vehID or not tonumber(vehID) or (tonumber(vehID) % 1 ~= 0) then
			veh = getPedOccupiedVehicle(thePlayer) or false
			if veh then
				vehID = getElementData(veh, "dbid") or false
				if not vehID then
					outputChatBox("You must be in a vehicle.", thePlayer, 255, 194, 14)
					outputChatBox("Or use KULLANIM: /" .. commandName .. " [Araç ID]", thePlayer, 255, 194, 14)
					return false
				end
			end
		end

		if not vehID or not tonumber(vehID) or (tonumber(vehID) % 1 ~= 0) then
			outputChatBox("You must be in a vehicle.", thePlayer, 255, 194, 14)
			outputChatBox("Or use KULLANIM: /" .. commandName .. " [Araç ID]", thePlayer, 255, 194, 14)
			return false
		end
		
		exports["rl_vehicle"]:reloadVehicle(tonumber(vehID))
		outputChatBox("[VEHICLE MANAGER] Vehicle ID#" .. vehID .. " reloaded.", thePlayer)

		addVehicleLogs(tonumber(vehID), commandName, thePlayer)
		return true
	end
end
addCommandHandler("reloadveh", reloadVehicleByAdmin)
addCommandHandler("reloadvehicle", reloadVehicleByAdmin)

function togVehReg(admin, command, target, status)
	if (exports.rl_integration:isPlayerAdmin1(admin)) then
		if not (target) or not (status) then
			outputChatBox("KULLANIM: /" .. command .. " [Veh ID] [0- Off, 1- On]", admin, 255, 194, 14)
		else
			local username = getPlayerName(admin):gsub("_"," ")
			local pv = exports.rl_pool:getElement("vehicle", tonumber(target))

			if (pv) then
				local vid = getElementData(pv, "dbid")
				local stat = tonumber(status)
				if isElementAttached(pv) then
					detachElements(pv)
				end
				if (stat == 0) then
					dbExec(mysql:getConnection(), "UPDATE vehicles SET registered = '0' WHERE id='" .. vid .. "'")
					setElementData(pv, "registered", 0)
					outputChatBox("You have toggled the registration to unregistered on vehicle #" .. vid .. ".", admin)

					addVehicleLogs(getElementData(pv, "dbid"), command .. " OFF", admin)
				elseif (stat == 1) then
					dbExec(mysql:getConnection(), "UPDATE vehicles SET registered = '1' WHERE id='" .. vid .. "'")
					setElementData(pv, "registered", 1)
					outputChatBox("You have toggled the registration to registered on vehicle #" .. vid .. ".", admin)

					addVehicleLogs(getElementData(pv, "dbid"), command .. " ON", admin)
				end
			else
				outputChatBox("That's not a vehicle.", admin, 255, 194, 14)
			end
		end
	end
end
addCommandHandler("togreg", togVehReg)

function togVehPlate(admin, command, target, status)
	if (exports.rl_integration:isPlayerAdmin1(admin)) then
		if not (target) or not (status) then
			outputChatBox("KULLANIM: /" .. command .. " [Veh ID] [0- Off, 1- On]", admin, 255, 194, 14)
		else
			local username = getPlayerName(admin):gsub("_"," ")
			local pv = exports.rl_pool:getElement("vehicle", tonumber(target))

			if (pv) then
				local vid = getElementData(pv, "dbid")
				local stat = tonumber(status)
				if isElementAttached(pv) then
					detachElements(pv)
				end
				if (stat == 0) then
					dbExec(mysql:getConnection(), "UPDATE vehicles SET show_plate = '0' WHERE id='" .. vid .. "'")

					setElementData(pv, "show_plate", 0)

					outputChatBox("You have toggled the plates to off, on vehicle #" .. vid .. ".", admin)

					addVehicleLogs(getElementData(pv, "dbid"), command .. " OFF", admin)
				elseif (stat == 1) then
					dbExec(mysql:getConnection(), "UPDATE vehicles SET show_plate = '1' WHERE id='" .. vid .. "'")
					setElementData(pv, "show_plate", 1)
					outputChatBox("You have toggled the plates to on, on vehicle #" .. vid .. ".", admin)

					addVehicleLogs(getElementData(pv, "dbid"), command .. " ON", admin)
				end
			else
				outputChatBox("That's not a vehicle.", admin, 255, 194, 14)
			end
		end
	end
end
addCommandHandler("togplate", togVehPlate)

function togVehVin(admin, command, target, status)
	if (exports.rl_integration:isPlayerAdmin1(admin)) then
		if not (target) or not (status) then
			outputChatBox("KULLANIM: /" .. command .. " [Veh ID] [0- Off, 1- On]", admin, 255, 194, 14)
		else
			local username = getPlayerName(admin):gsub("_"," ")
			local pv = exports.rl_pool:getElement("vehicle", tonumber(target))

			if (pv) then
				local vid = getElementData(pv, "dbid")
				local stat = tonumber(status)
				if isElementAttached(pv) then
					detachElements(pv)
				end
				if (stat == 0) then
					dbExec(mysql:getConnection(), "UPDATE vehicles SET show_vin = '0' WHERE id='" .. vid .. "'")

					setElementData(pv, "show_vin", 0)

					outputChatBox("You have toggled the VIN to off, on vehicle #" .. vid .. ".", admin)

					addVehicleLogs(getElementData(pv, "dbid"), command .. " OFF", admin)
				elseif (stat == 1) then
					dbExec(mysql:getConnection(), "UPDATE vehicles SET show_vin = '1' WHERE id='" .. vid .. "'")
					setElementData(pv, "show_vin", 1)

					outputChatBox("You have toggled the VIN to on, on vehicle #" .. vid .. ".", admin)

					addVehicleLogs(getElementData(pv, "dbid"), command .. " ON", admin)
				end
			else
				outputChatBox("That's not a vehicle.", admin, 255, 194, 14)
			end
		end
	end
end
addCommandHandler("togvin", togVehVin)

function spinCarOut(thePlayer, commandName, targetPlayer, round)
	if (exports.rl_integration:isPlayerAdmin1(thePlayer)) then
		if not targetPlayer then
			outputChatBox("KULLANIM: /" .. commandName .. " [Karakter Adı / ID] [Rounds]", thePlayer, 255, 194, 14)
		else
			if not round or not tonumber(round) or tonumber(round) % 1 ~= 0 or tonumber(round) > 100 then
				round = 1
			end
			local targetPlayer = exports.rl_global:findPlayerByPartialNick(thePlayer, targetPlayer)
			local targetVehicle = getPedOccupiedVehicle(targetPlayer)
			if targetVehicle == false then
				outputChatBox("This player isn't in a vehicle!", thePlayer, 255, 0, 0)
			else
				outputChatBox("You've spun out " .. getPlayerName(targetPlayer) .. "'s vehicle " .. tostring(round) .. " round(s).", thePlayer)
				local delay = 50
				setTimer(function()
					setElementAngularVelocity (targetVehicle, 0, 0, 0.2)
					delay = delay + 50
				end, delay, tonumber(round))
			end
		end
	end
end
addCommandHandler("spinout", spinCarOut, false, false)

function unflipCar(thePlayer, commandName, targetPlayer)
	if exports.rl_integration:isPlayerTrialAdmin(thePlayer) then
		if not targetPlayer or not exports.rl_integration:isPlayerTrialAdmin(thePlayer) then
			if not (isPedInVehicle(thePlayer)) then
				outputChatBox("[!]#FFFFFF Oyuncu araçta değil.", thePlayer, 255, 0, 0,true)
			else
				local veh = getPedOccupiedVehicle(thePlayer)
				local rx, ry, rz = getVehicleRotation(veh)
				setVehicleRotation(veh, 0, ry, rz)
				outputChatBox("[!]#FFFFFF Aracınız ters çevirildi.", thePlayer, 0, 255, 0,true)
				addVehicleLogs(getElementData(veh, "dbid"), commandName, thePlayer)
			end
		else
			local targetPlayer, targetPlayerName = exports.rl_global:findPlayerByPartialNick(thePlayer, targetPlayer)
			if targetPlayer then
				local logged = getElementData(targetPlayer, "logged")
				local username = getPlayerName(thePlayer):gsub("_"," ")

				if (not logged) then
					outputChatBox("[!]#FFFFFF Bu oyuncu karakterine giriş yapmadığı için işlem gerçekleşmedi.", thePlayer, 255, 0, 0, true)
				else
					local pveh = getPedOccupiedVehicle(targetPlayer)
					if pveh then
						local rx, ry, rz = getVehicleRotation(pveh)
						setVehicleRotation(pveh, 0, ry, rz)
						if getElementData(thePlayer, "hidden_admin") == 1 then
							outputChatBox("[!]#FFFFFF Aracınız gizli bir admin tarafından ters çevirildi.", targetPlayer, 0, 255, 0,true)
						else
							outputChatBox("[!]#FFFFFF Aracınız " .. username .. " isimli yetkili tarafından ters çeviridli.", targetPlayer, 0, 255, 0,true)
						end
						outputChatBox("[!]#FFFFFF Aracını ters çevirdiğin oyuncu " .. targetPlayerName:gsub("_"," ") .. ".", thePlayer, 0, 255, 0,true)

						addVehicleLogs(getElementData(pveh, "dbid"), commandName, thePlayer)
					else
						outputChatBox("[!]#FFFFFF " .. targetPlayerName:gsub("_"," ") .. " isimli oyuncu araçta değil.", thePlayer, 255, 0, 0,true)
					end
				end
			end
		end
	end
end
addCommandHandler("unflip", unflipCar, false, false)

function flipCar(thePlayer, commandName, targetPlayer)
	if exports.rl_integration:isPlayerTrialAdmin(thePlayer) or getElementData(thePlayer,"faction") == 4 then
		if not targetPlayer or not exports.rl_integration:isPlayerTrialAdmin(thePlayer) then
			if not (isPedInVehicle(thePlayer)) then
				outputChatBox("You are not in a vehicle.", thePlayer, 255, 0, 0)
			else
				local veh = getPedOccupiedVehicle(thePlayer)
				local rx, ry, rz = getVehicleRotation(veh)
				setVehicleRotation(veh, 180, ry, rz)
				fixVehicle (veh)
				outputChatBox("Your car was flipped!", thePlayer, 0, 255, 0)
				addVehicleLogs(getElementData(veh, "dbid"), commandName, thePlayer)
			end
		else
			local targetPlayer, targetPlayerName = exports.rl_global:findPlayerByPartialNick(thePlayer, targetPlayer)
			if targetPlayer then
				local logged = getElementData(targetPlayer, "logged")
				local username = getPlayerName(thePlayer):gsub("_"," ")

				if (not logged) then
					outputChatBox("[!]#FFFFFF Bu oyuncu karakterine giriş yapmadığı için işlem gerçekleşmedi.", thePlayer, 255, 0, 0, true)
				else
					local pveh = getPedOccupiedVehicle(targetPlayer)
					if pveh then
						local rx, ry, rz = getVehicleRotation(pveh)
						setVehicleRotation(pveh, 180, ry, rz)
						if getElementData(thePlayer, "hidden_admin") == 1 then
							outputChatBox("Your car was flipped by Gizli Yetkili.", targetPlayer, 0, 255, 0)
						else
							outputChatBox("Your car was flipped by " .. username .. ".", targetPlayer, 0, 255, 0)
						end
						outputChatBox("You flipped " .. targetPlayerName:gsub("_"," ") .. "'s car.", thePlayer, 0, 255, 0)

						addVehicleLogs(getElementData(pveh, "dbid"), commandName, thePlayer)
					else
						outputChatBox(targetPlayerName:gsub("_"," ") .. " is not in a vehicle.", thePlayer, 255, 0, 0)
					end
				end
			end
		end
	end
end
addCommandHandler("flip", flipCar, false, false)

function createTempVehicle(thePlayer, commandName, vehShopID)
	if exports["rl_integration"]:isPlayerTrialAdmin(thePlayer) then
		if not vehShopID or not tonumber(vehShopID) then
			outputChatBox("KULLANIM: /" .. commandName .. " [ID from Vehicle Lib] [color1] [color2]", thePlayer, 255, 194, 14)
			outputChatBox("KULLANIM: /vehlib for IDs.", thePlayer, 255, 194, 14)
			return false
		else
			vehShopID = tonumber(vehShopID)
		end

		local vehShopData = getInfoFromVehShopID(vehShopID)
		if not vehShopData then
			outputDebugString("VEHICLE MANAGER / createTempVehicle / FAILED TO FETCH VEHSHOP DATA")
			outputChatBox("KULLANIM: /" .. commandName .. " [ID from Vehicle Lib] [color1] [color2]", thePlayer, 255, 194, 14)
			outputChatBox("KULLANIM: /vehlib for IDs.", thePlayer, 255, 194, 14)
			return false
		end

		local vehicleID = vehShopData.vehmtamodel
		if not vehicleID or not tonumber(vehicleID) then -- vehicle is specified as name
			outputDebugString("VEHICLE MANAGER / createTempVehicle / FAILED TO FETCH VEHSHOP DATA")
			outputChatBox("Ops.. Something went wrong.", thePlayer, 255, 0, 0)
			return false
		else
			vehicleID = tonumber(vehicleID)
		end

		local r = getPedRotation(thePlayer)
		local x, y, z = getElementPosition(thePlayer)
		x = x + ((math.cos(math.rad(r))) * 5)
		y = y + ((math.sin(math.rad(r))) * 5)

		local plate = exports.rl_global:generatePlate()
		
		local veh = createVehicle(vehicleID, x, y, z, 0, 0, r, plate)

		if not (veh) then
			outputDebugString("VEHICLE MANAGER / createTempVehicle / FAILED TO FETCH VEHSHOP DATA")
			outputChatBox("Ops.. Something went wrong.", thePlayer, 255, 0, 0)
			return false
		end

		if (armoredCars[vehicleID]) then
			setVehicleDamageProof(veh, true)
		end

		totalTempVehicles = totalTempVehicles + 1
		local dbid = (-totalTempVehicles)
		exports.rl_pool:allocateElement(veh, dbid)

		setElementInterior(veh, getElementInterior(thePlayer))
		setElementDimension(veh, getElementDimension(thePlayer))

		setVehicleOverrideLights(veh, 1)
		setVehicleEngineState(veh, false)
		setVehicleFuelTankExplodable(veh, false)
		setVehicleVariant(veh, exports['rl_vehicle']:getRandomVariant(getElementModel(veh)))

		setElementData(veh, "dbid", dbid)
		setElementData(veh, "fuel", exports["rl_vehicle-fuel"]:getMaxFuel(veh))
		setElementData(veh, "Impounded", 0)
		setElementData(veh, "engine", 0)
		setElementData(veh, "oldx", x)
		setElementData(veh, "oldy", y)
		setElementData(veh, "oldz", z)
		setElementData(veh, "faction", -1)
		setElementData(veh, "owner", -1)
		setElementData(veh, "job", 0)
		setElementData(veh, "handbrake", 0)
		exports['rl_vehicle-interiors']:add(veh)

		setElementData(veh, "brand", vehShopData.vehbrand)
		setElementData(veh, "model", vehShopData.vehmodel)
		setElementData(veh, "year", vehShopData.vehyear)
		setElementData(veh, "vehicle_shop_id", vehShopData.id)

		loadHandlingToVeh(veh, vehShopData.handling)

		outputChatBox(getVehicleName(veh) .. " spawned with TEMP ID " .. dbid .. ".", thePlayer, 255, 194, 14)
	end
end
addCommandHandler("veh", createTempVehicle, false, false)

function gotoCar(thePlayer, commandName, id)
	if exports.rl_integration:isPlayerTrialAdmin(thePlayer) then
		if not (id) then
			outputChatBox("KULLANIM: /" .. commandName .. " [Araç ID]", thePlayer, 255, 194, 14)
		else
			local theVehicle = exports.rl_pool:getElement("vehicle", tonumber(id))
			if theVehicle then
				local rx, ry, rz = getVehicleRotation(theVehicle)
				local x, y, z = getElementPosition(theVehicle)
				x = x + ((math.cos (math.rad (rz))) * 5)
				y = y + ((math.sin (math.rad (rz))) * 5)

				setElementPosition(thePlayer, x, y, z)
				setPedRotation(thePlayer, rz)
				setElementInterior(thePlayer, getElementInterior(theVehicle))
				setElementDimension(thePlayer, getElementDimension(theVehicle))

				addVehicleLogs(id, commandName, thePlayer)

				outputChatBox("[!]#FFFFFF Başarıyla [" .. id .. "] ID'li arabaya ışınlandın.", thePlayer, 0, 255, 0, true)
			else
				outputChatBox("[!]#FFFFFF Geçersiz araç ID.", thePlayer, 255, 0, 0, true)
			end
		end
	end
end
addCommandHandler("gotocar", gotoCar, false, false)
addCommandHandler("gotoveh", gotoCar, false, false)

function getCar(thePlayer, commandName, id)
	if exports.rl_integration:isPlayerTrialAdmin(thePlayer) then
		if not (id) then
			outputChatBox("KULLANIM: /" .. commandName .. " [Araç ID]", thePlayer, 255, 194, 14)
		else
			local theVehicle = exports.rl_pool:getElement("vehicle", tonumber(id))
			if theVehicle then
				local r = getPedRotation(thePlayer)
				local x, y, z = getElementPosition(thePlayer)
				x = x + ((math.cos(math.rad(r))) * 5)
				y = y + ((math.sin(math.rad(r))) * 5)

				if (getElementHealth(theVehicle) == 0) then
					spawnVehicle(theVehicle, x, y, z, 0, 0, r)
				else
					respawnTheVehicle(theVehicle)
					setElementPosition(theVehicle, x, y, z)
					setVehicleRotation(theVehicle, 0, 0, r)
				end
                
				setElementInterior(theVehicle, getElementInterior(thePlayer))
				setElementDimension(theVehicle, getElementDimension(thePlayer))

				outputChatBox("[!]#FFFFFF Başarıyla araç yanınıza çekildi.", thePlayer, 0, 255, 0, true)
				exports.rl_logs:addLog("getveh", exports.rl_global:getPlayerFullAdminTitle(thePlayer) .. " isimli yetkili [" .. id .. "] ID'li araç yanına çekti.")
			else
				outputChatBox("[!]#FFFFFF Geçersiz araç ID.", thePlayer, 255, 0, 0, true)
			end
		end
	end
end
addCommandHandler("getcar", getCar, false, false)
addCommandHandler("getveh", getCar, false, false)

function getPlayerVehicle(thePlayer, commandName, id)
	if id and tonumber(id) then
		id = tonumber(id)
		if not getPedOccupiedVehicle(thePlayer) then
			if not getElementData(thePlayer, "adminjailed") then
				local theVehicle = exports.rl_pool:getElement("vehicle", id)
				if theVehicle then
					if getElementData(theVehicle, "owner") == getElementData(thePlayer, "dbid") then
						local r = getPedRotation(thePlayer)
						local x, y, z = getElementPosition(thePlayer)
						x = x + ((math.cos(math.rad(r))) * 5)
						y = y + ((math.sin(math.rad(r))) * 5)

						setElementPosition(theVehicle, x, y, z)
						setVehicleRotation(theVehicle, 0, 0, r)
						setElementInterior(theVehicle, getElementInterior(thePlayer))
						setElementDimension(theVehicle, getElementDimension(thePlayer))

						outputChatBox("[!]#FFFFFF Aracınız başarıyla yanınıza getirildi.", thePlayer, 0, 255, 0, true)
						triggerClientEvent(thePlayer, "playSuccessfulSound", thePlayer)
					else
						outputChatBox("[!]#FFFFFF Bu aracın sahibi değilsiniz.", thePlayer, 255, 0, 0, true)
						playSoundFrontEnd(thePlayer, 4)
					end
				else
					outputChatBox("[!]#FFFFFF Geçersiz araç ID.", thePlayer, 255, 0, 0, true)
					playSoundFrontEnd(thePlayer, 4)
				end
			else
				outputChatBox("[!]#FFFFFF OOC cezası altındayken aracı çekemezsiniz.", thePlayer, 255, 0, 0, true)
				playSoundFrontEnd(thePlayer, 4)
			end
		else
			outputChatBox("[!]#FFFFFF Bu komutu aracın içinde kullanamazsınız.", thePlayer, 255, 0, 0, true)
			playSoundFrontEnd(thePlayer, 4)
		end
	else
		outputChatBox("KULLANIM: /" .. commandName .. " [Araç ID]", thePlayer, 255, 194, 14)
	end
end
addCommandHandler("aracgetir", getPlayerVehicle, false, false)

function getFactionVehicle(thePlayer, commandName, id)
	if id and tonumber(id) then
		id = tonumber(id)
		if not getPedOccupiedVehicle(thePlayer) then
			if not getElementData(thePlayer, "adminjailed") then
				local theVehicle = exports.rl_pool:getElement("vehicle", id)
				if theVehicle then
					if getElementData(theVehicle, "faction") == getElementData(thePlayer, "faction") then
						local r = getPedRotation(thePlayer)
						local x, y, z = getElementPosition(thePlayer)
						x = x + ((math.cos(math.rad(r))) * 5)
						y = y + ((math.sin(math.rad(r))) * 5)

						setElementPosition(theVehicle, x, y, z)
						setVehicleRotation(theVehicle, 0, 0, r)
						setElementInterior(theVehicle, getElementInterior(thePlayer))
						setElementDimension(theVehicle, getElementDimension(thePlayer))

						outputChatBox("[!]#FFFFFF Birlik aracı başarıyla yanınıza getirildi.", thePlayer, 0, 255, 0, true)
						triggerClientEvent(thePlayer, "playSuccessfulSound", thePlayer)
					else
						outputChatBox("[!]#FFFFFF Bu araç sizin birliğinizde değil.", thePlayer, 255, 0, 0, true)
						playSoundFrontEnd(thePlayer, 4)
					end
				else
					outputChatBox("[!]#FFFFFF Geçersiz araç ID.", thePlayer, 255, 0, 0, true)
					playSoundFrontEnd(thePlayer, 4)
				end
			else
				outputChatBox("[!]#FFFFFF OOC cezası altındayken aracı çekemezsiniz.", thePlayer, 255, 0, 0, true)
				playSoundFrontEnd(thePlayer, 4)
			end
		else
			outputChatBox("[!]#FFFFFF Bu komutu aracın içinde kullanamazsınız.", thePlayer, 255, 0, 0, true)
			playSoundFrontEnd(thePlayer, 4)
		end
	else
		outputChatBox("KULLANIM: /" .. commandName .. " [Araç ID]", thePlayer, 255, 194, 14)
	end
end
addCommandHandler("faracgetir", getFactionVehicle, false, false)

function sendCar(thePlayer, commandName, id, toPlayer)
	if exports.rl_integration:isPlayerTrialAdmin(thePlayer) then
		if not (id) or not (toPlayer) then
			outputChatBox("KULLANIM: /" .. commandName .. " [Araç ID] [Karakter Adı / ID]", thePlayer, 255, 194, 14)
		else
			local theVehicle = exports.rl_pool:getElement("vehicle", tonumber(id))
			local targetPlayer, targetPlayerName = exports.rl_global:findPlayerByPartialNick(thePlayer, toPlayer)
			if theVehicle then
				local r = getPedRotation(targetPlayer)
				local x, y, z = getElementPosition(targetPlayer)
				x = x + ((math.cos (math.rad (r))) * 5)
				y = y + ((math.sin (math.rad (r))) * 5)

				if	(getElementHealth(theVehicle)==0) then
					spawnVehicle(theVehicle, x, y, z, 0, 0, r)
				else
					setElementPosition(theVehicle, x, y, z)
					setVehicleRotation(theVehicle, 0, 0, r)
				end

				setElementInterior(theVehicle, getElementInterior(targetPlayer))
				setElementDimension(theVehicle, getElementDimension(targetPlayer))

				addVehicleLogs(id, commandName, thePlayer)

				outputChatBox("[!]#FFFFFF " .. targetPlayerName .. " isimli oyuncuya aracı ışınladın.", thePlayer, 255, 194, 14,true)
				if getElementData(thePlayer, "hidden_admin") == 1 then
					outputChatBox("[!]#FFFFFF Gizli bir yetkili aracı senin yanına ışınladı.", targetPlayer, 255, 194, 14,true)
				else
					outputChatBox("[!]#FFFFFF " .. exports.rl_global:getPlayerFullAdminTitle(thePlayer) .. " isimli yetkili aracı yanına ışınladı.", targetPlayer, 255, 194, 14,true)
				end
			else
				outputChatBox("[!]#FFFFFF Geçersiz araç ID.", thePlayer, 255, 0, 0,true)
			end
		end
	end
end
addCommandHandler("sendcar", sendCar, false, false)
addCommandHandler("sendvehto", sendCar, false, false)
addCommandHandler("sendveh", sendCar, false, false)

function sendPlayerToVehicle(thePlayer, commandName, toPlayer, id)
	if exports.rl_integration:isPlayerTrialAdmin(thePlayer) then
		if not (id) or not (toPlayer) then
			outputChatBox("KULLANIM: /" .. commandName .. " [player ID] [Araç ID]", thePlayer, 255, 194, 14)
		else
			local theVehicle = exports.rl_pool:getElement("vehicle", tonumber(id))
			local targetPlayer, targetPlayerName = exports.rl_global:findPlayerByPartialNick(thePlayer, toPlayer)
			if theVehicle then
				local rx, ry, rz = getVehicleRotation(theVehicle)
				local x, y, z = getElementPosition(theVehicle)
				x = x + ((math.cos(math.rad(rz))) * 5)
				y = y + ((math.sin(math.rad(rz))) * 5)

				setElementPosition(targetPlayer, x, y, z)
				setPedRotation(targetPlayer, rz)
				setElementInterior(targetPlayer, getElementInterior(theVehicle))
				setElementDimension(targetPlayer, getElementDimension(theVehicle))

				addVehicleLogs(id, commandName, thePlayer)

				outputChatBox("Player " .. targetPlayerName .. " teleported to vehicle.", thePlayer, 255, 194, 14)
				if getElementData(thePlayer, "hidden_admin") == 1 then
					outputChatBox("Gizli Yetkili has teleported you to a vehicle.", targetPlayer, 255, 194, 14)
				else
					outputChatBox(exports.rl_global:getPlayerFullAdminTitle(thePlayer) .. " has teleported a you to a vehicle.", targetPlayer, 255, 194, 14)
				end
			else
				outputChatBox("Invalid Vehicle ID.", thePlayer, 255, 0, 0)
			end
		end
	end
end
addCommandHandler("sendtoveh", sendPlayerToVehicle, false, false)

function getNearbyVehicles(thePlayer, commandName)
	if exports.rl_integration:isPlayerTrialAdmin(thePlayer) then
		outputChatBox("Nearby Vehicles:", thePlayer, 255, 126, 0)
		local count = 0

		for index, nearbyVehicle in ipairs(exports.rl_global:getNearbyElements(thePlayer, "vehicle")) do
			local thisvehid = getElementData(nearbyVehicle, "dbid")
			if thisvehid then
				local vehicleID = getElementModel(nearbyVehicle)
				local vehicleName = getVehicleNameFromModel(vehicleID)
				local owner = getElementData(nearbyVehicle, "owner")
				local faction = getElementData(nearbyVehicle, "faction")
				count = count + 1

				local ownerName = ""

				if faction then
					if (faction>0) then
						local theTeam = exports.rl_pool:getElement("team", faction)
						if theTeam then
							ownerName = getTeamName(theTeam)
						end
					elseif (owner==-1) then
						ownerName = "Admin Temp Vehicle"
					elseif (owner>0) then
						ownerName = exports['rl_cache']:getCharacterName(owner, true)
					else
						ownerName = "Civilian"
					end
				else
					ownerName = "Car Dealership"
				end

				if (thisvehid) then
					outputChatBox("" .. vehicleName .. " (" .. vehicleID  .. ") with ID: " .. thisvehid .. ". Owner: " .. ownerName, thePlayer, 255, 126, 0)
				end
			end
		end

		if (count==0) then
			outputChatBox("None.", thePlayer, 255, 126, 0)
		end
	end
end
addCommandHandler("nearbyvehicles", getNearbyVehicles, false, false)
addCommandHandler("nearbyvehs", getNearbyVehicles, false, false)

function delNearbyVehicles(thePlayer, commandName)
	if exports.rl_integration:isPlayerLeaderAdmin(thePlayer)  then
		outputChatBox("Deleting Nearby Vehicles:", thePlayer, 255, 126, 0)
		local count = 0

		for index, nearbyVehicle in ipairs(exports.rl_global:getNearbyElements(thePlayer, "vehicle")) do
			local thisvehid = getElementData(nearbyVehicle, "dbid")
			if thisvehid then
				local vehicleID = getElementModel(nearbyVehicle)
				local vehicleName = getVehicleNameFromModel(vehicleID)
				local owner = getElementData(nearbyVehicle, "owner")
				local faction = getElementData(nearbyVehicle, "faction")
				count = count + 1

				local ownerName = ""

				if faction then
					if (faction>0) then
						local theTeam = exports.rl_pool:getElement("team", faction)
						if theTeam then
							ownerName = getTeamName(theTeam)
						end
					elseif (owner==-1) then
						ownerName = "Admin Temp Vehicle"
					elseif (owner>0) then
						ownerName = exports['rl_cache']:getCharacterName(owner, true)
					else
						ownerName = "Civilian"
					end
				else
					ownerName = "Car Dealership"
				end

				if (thisvehid) then
					deleteVehicle(thePlayer, "delveh", thisvehid)
				end
			end
		end

		if (count==0) then
			outputChatBox("None was deleted.", thePlayer, 255, 126, 0)
		elseif count == 1 then
			outputChatBox("One vehicle were deleted.", thePlayer, 255, 126, 0)
		else
			outputChatBox("" .. count .. " vehicles were deleted.", thePlayer, 255, 126, 0)
		end
	end
end
addCommandHandler("delnearbyvehs", delNearbyVehicles, false, false)
addCommandHandler("delnearbyvehicles", delNearbyVehicles, false, false)

function respawnCmdVehicle(thePlayer, commandName, id)
	if (exports.rl_integration:isPlayerTrialAdmin(thePlayer)) then
		if not (id) then
			outputChatBox("KULLANIM: /" .. commandName .. " [Araç ID]", thePlayer, 255, 194, 14)
		else
			local theVehicle = exports.rl_pool:getElement("vehicle", tonumber(id))
			if theVehicle then
				if isElementAttached(theVehicle) then
					detachElements(theVehicle)
					setElementCollisionsEnabled(theVehicle, true)
				end
				removeElementData(theVehicle, "i:left")
				removeElementData(theVehicle, "i:right")
				local dbid = getElementData(theVehicle,"dbid")
				if (dbid<0) then
					fixVehicle(theVehicle)
					if armoredCars[getElementModel(theVehicle)] then
						setVehicleDamageProof(theVehicle, true)
					else
						setVehicleDamageProof(theVehicle, false)
					end
					setVehicleWheelStates(theVehicle, 0, 0, 0, 0)
					setElementData(theVehicle, "enginebroke", 0)
				else
					addVehicleLogs(id, commandName, thePlayer)

					respawnTheVehicle(theVehicle)
					setElementInterior(theVehicle, getElementData(theVehicle, "interior"))
					setElementDimension(theVehicle, getElementData(theVehicle, "dimension"))
					if getElementData(theVehicle, "owner") == -2 and getElementData(theVehicle,"Impounded") == 0  then
						setVehicleLocked(theVehicle, false)
					end
				end
				outputChatBox("[!]#FFFFFF Araç yenilendi.", thePlayer, 0, 255, 0, true)
			else
				outputChatBox("[!]#FFFFFF Geçersiz araç ID.", thePlayer, 255, 0, 0, true)
			end
		end
	end
end
addCommandHandler("respawnveh", respawnCmdVehicle, false, false)

function respawnGuiVehicle(theVehicle)
	local thePlayer = source
	if (exports.rl_integration:isPlayerTrialAdmin(thePlayer)) then
		if isElementAttached(theVehicle) then
			detachElements(theVehicle)
			setElementCollisionsEnabled(theVehicle, true)
		end
		removeElementData(theVehicle, "i:left")
		removeElementData(theVehicle, "i:right")
		local dbid = getElementData(theVehicle,"dbid")
		if (dbid<0) then
			fixVehicle(theVehicle)
			if armoredCars[getElementModel(theVehicle)] then
				setVehicleDamageProof(theVehicle, true)
			else
				setVehicleDamageProof(theVehicle, false)
			end
			setVehicleWheelStates(theVehicle, 0, 0, 0, 0)
			setElementData(theVehicle, "enginebroke", 0)
		else
			local id = tonumber(getElementData(theVehicle, "dbid"))
			addVehicleLogs(id, "respawnveh", thePlayer)

			respawnTheVehicle(theVehicle)
			setElementInterior(theVehicle, getElementData(theVehicle, "interior"))
			setElementDimension(theVehicle, getElementData(theVehicle, "dimension"))
			if getElementData(theVehicle, "owner") == -2 and getElementData(theVehicle,"Impounded") == 0  then
				setVehicleLocked(theVehicle, false)
			end
		end
	end
end
addEvent("vehicle-manager:respawn", true)
addEventHandler("vehicle-manager:respawn", root, respawnGuiVehicle)

function round(num, idp)
	local mult = 10^(idp or 0)
	return math.floor(num * mult + 0.5) / mult
end

function respawnAllVehicles(thePlayer, commandName, timeToRespawn)
	if (exports.rl_integration:isPlayerTrialAdmin(thePlayer)) then
		if commandName then
			if isTimer(respawnTimer) then
				outputChatBox("[!]#FFFFFF Şu anda bir tanesi zaten açık, eğer kapatmak isterseniz /respawnstop yazarak durdurabilirsiniz.", thePlayer, 255, 0, 0, true)
				playSoundFrontEnd(thePlayer, 4)
			else
				timeToRespawn = tonumber(timeToRespawn) or 30
				timeToRespawn = timeToRespawn < 10 and 10 or timeToRespawn
				exports.rl_global:sendMessageToAdmins("[ADM] " .. exports.rl_global:getPlayerFullAdminTitle(thePlayer) .. " isimli yetkili araç yenilemesi başlattı.")
				outputChatBox(">> Tüm araçlar " .. timeToRespawn .. " saniye sonra yenilenecektir.", root, 255, 194, 14)
				respawnTimer = setTimer(respawnAllVehicles, timeToRespawn*1000, 1, thePlayer)
			end
			return
		end
		local tick = getTickCount()
		local vehicles = exports.rl_pool:getPoolElementsByType("vehicle")
		local counter = 0
		local tempcounter = 0
		local tempoccupied = 0
		local radioCounter = 0
		local occupiedcounter = 0
		local unlockedcivs = 0
		local notmoved = 0
		local deleted = 0

		local dimensions = {}
		for k, p in ipairs(getElementsByType("player")) do
			dimensions[getElementDimension(p)] = true
		end

		for k, theVehicle in ipairs(vehicles) do
			if isElement(theVehicle) then
				local dbid = getElementData(theVehicle, "dbid")
				if not (dbid) or (dbid < 0) then
					local driver = getVehicleOccupant(theVehicle)
					local pass1 = getVehicleOccupant(theVehicle, 1)
					local pass2 = getVehicleOccupant(theVehicle, 2)
					local pass3 = getVehicleOccupant(theVehicle, 3)

					if (dbid and dimensions[dbid + 20000]) or (pass1) or (pass2) or (pass3) or (driver) or (getVehicleTowingVehicle(theVehicle)) or #getAttachedElements(theVehicle) > 0 then
						tempoccupied = tempoccupied + 1
					else
						destroyElement(theVehicle)
						tempcounter = tempcounter + 1
					end
				else
					if getElementDimension(theVehicle) ~= 33333 then
						local driver = getVehicleOccupant(theVehicle)
						local pass1 = getVehicleOccupant(theVehicle, 1)
						local pass2 = getVehicleOccupant(theVehicle, 2)
						local pass3 = getVehicleOccupant(theVehicle, 3)

						if (dimensions[dbid + 20000]) or (pass1) or (pass2) or (pass3) or (driver) or (getVehicleTowingVehicle(theVehicle)) or #getAttachedElements(theVehicle) > 0 then
							occupiedcounter = occupiedcounter + 1
						else
							if isVehicleBlown(theVehicle) then
								fixVehicle(theVehicle)
								if armoredCars[getElementModel(theVehicle)] then
									setVehicleDamageProof(theVehicle, true)
								else
									setVehicleDamageProof(theVehicle, false)
								end
								for i = 0, 5 do
									setVehicleDoorState(theVehicle, i, 4)
								end
								setElementHealth(theVehicle, 300)
								setElementData(theVehicle, "enginebroke", 1)
							end

							removeElementData(theVehicle, "i:left")
							removeElementData(theVehicle, "i:right")
							if getElementData(theVehicle, "owner") == -2 and getElementData(theVehicle, "Impounded") == 0 then
								if isElementAttached(theVehicle) then
									detachElements(theVehicle)
									setElementCollisionsEnabled(theVehicle, true)
								end
								respawnVehicle(theVehicle)
								setVehicleLocked(theVehicle, false)
								unlockedcivs = unlockedcivs + 1
							else
								local checkx, checky, checkz = getElementPosition(theVehicle)
								if getElementData(theVehicle, "respawnposition") then
									local x, y, z, rx, ry, rz = unpack(getElementData(theVehicle, "respawnposition"))

									if (round(checkx, 6) == x) and (round(checky, 6) == y) then
										notmoved = notmoved + 1
									else
										if isElementAttached(theVehicle) then
											detachElements(theVehicle)
										end
										setElementCollisionsEnabled(theVehicle, true)
										if getElementData(theVehicle, "vehicle:radio") ~= 0 then
											setElementData(theVehicle, "vehicle:radio", 0)
											radioCounter = radioCounter + 1
										end
										setElementPosition(theVehicle, x, y, z)
										setVehicleRotation(theVehicle, rx, ry, rz)
										setElementInterior(theVehicle, getElementData(theVehicle, "interior"))
										setElementDimension(theVehicle, getElementData(theVehicle, "dimension"))
										if (not getElementData(theVehicle, "carshop")) and (not getElementData(theVehicle, "robbery_vehicle")) then
											counter = counter + 1
										end
									end
								else
									setElementDimension(theVehicle, 33333)
									deleted = deleted + 1
								end
							end
							
							if getElementData(theVehicle, "faction") ~= -1 then
								fixVehicle(theVehicle)
								if (getElementData(theVehicle, "Impounded") == 0) then
									setElementData(theVehicle, "enginebroke", 0)
									setElementData(theVehicle, "handbrake", 1)
									setTimer(setElementFrozen, 2000, 1, theVehicle, true)
									if armoredCars[getElementModel(theVehicle)] then
										setVehicleDamageProof(theVehicle, true)
									else
										setVehicleDamageProof(theVehicle, false)
									end
								end
							end
						end
					end
				end
			end
		end
		
		outputChatBox(">> Tüm araçlar yenilenmiştir.", root, 255, 194, 14)
	end
end
addCommandHandler("respawnall", respawnAllVehicles, false, false)

function respawnVehiclesStop(thePlayer, commandName)
	if exports.rl_integration:isPlayerTrialAdmin(thePlayer) and isTimer(respawnTimer) then
		killTimer(respawnTimer)
		respawnTimer = nil
		if commandName then
			outputChatBox(">> " .. exports.rl_global:getPlayerFullAdminTitle(thePlayer) .. " isimli yetkili araç yenilenmesini durdurdu.", root, 255, 194, 14)
		end
	end
end
addCommandHandler("respawnstop", respawnVehiclesStop, false, false)

function addPaintjob(thePlayer, commandName, target, paintjobID)
	if exports.rl_integration:isPlayerSeniorAdmin(thePlayer)  then
		if not (target) or not (paintjobID) then
			outputChatBox("KULLANIM: /" .. commandName .. " [Karakter Adı / ID] [Paintjob ID]", thePlayer, 255, 194, 14)
		else
			local targetPlayer, targetPlayerName = exports.rl_global:findPlayerByPartialNick(thePlayer, target)
			if targetPlayer then
				if not (isPedInVehicle(targetPlayer)) then
					outputChatBox("[!]#FFFFFF Seçtiğiniz oyuncu araçta değil.", thePlayer, 255, 0, 0,true)
				else
					local theVehicle = getPedOccupiedVehicle(targetPlayer)
					paintjobID = tonumber(paintjobID)
					if paintjobID == getVehiclePaintjob(theVehicle) then
						outputChatBox("This Vehicle already has this paintjob.", thePlayer, 255, 0, 0)
					else
						local success = setVehiclePaintjob(theVehicle, paintjobID)

						if (success) then
							addVehicleLogs(getElementData(theVehicle,"dbid"), commandName .. " " .. paintjobID, thePlayer)
							outputChatBox("[!]#FFFFFF Başarıyla [" .. paintjobID .. "] ID'li boya kodunu " .. targetPlayerName .. " oyuncunun aracına eklendi.", thePlayer, 0, 255, 0, true)
							outputChatBox("[!]#FFFFFF " .. exports.rl_global:getPlayerFullAdminTitle(thePlayer) .. " isimli yetkili aracınıza [" .. paintjobID .. "] ID'li boya kodunu ekledi.", targetPlayer, 0, 255, 0, true)
							exports['rl_save']:saveVehicleMods(theVehicle)
						else
							outputChatBox("[!]#FFFFFF Bir sorun oluştu.", thePlayer, 255, 0, 0, true)
							playSoundFrontEnd(thePlayer, 4)
						end
					end
				end
			end
		end
	end
end
addCommandHandler("setpaintjob", addPaintjob, false, false)

function fixPlayerVehicle(thePlayer, commandName, target)
	if (exports.rl_integration:isPlayerTrialAdmin(thePlayer)) then
		if not (target) then
			outputChatBox("KULLANIM: /" .. commandName .. " [Karakter Adı / ID]", thePlayer, 255, 194, 14)
		else
			local username = getPlayerName(thePlayer)
			local targetPlayer, targetPlayerName = exports.rl_global:findPlayerByPartialNick(thePlayer, target)

			if targetPlayer then
				local logged = getElementData(targetPlayer, "logged")
				if (not logged) then
					outputChatBox("[!]#FFFFFF Bu oyuncu karakterine giriş yapmadığı için işlem gerçekleşmedi.", thePlayer, 255, 0, 0, true)
					playSoundFrontEnd(thePlayer, 4)
				else
					local veh = getPedOccupiedVehicle(targetPlayer)
					if (veh) then
						fixVehicle(veh)
						
						if (getElementData(veh, "Impounded") == 0) then
							setElementData(veh, "enginebroke", 0)
							if armoredCars[getElementModel(veh)] then
								setVehicleDamageProof(veh, true)
							else
								setVehicleDamageProof(veh, false)
							end
						end
						
						for i = 0, 5 do
							setVehicleDoorState(veh, i, 0)
						end
						
						addVehicleLogs(getElementData(veh,"dbid"), commandName, thePlayer)

						outputChatBox("[!]#FFFFFF " .. targetPlayerName .. " isimli oyuncunun aracı tamir edildi.", thePlayer, 0, 255, 0, true)
						exports.rl_logs:addLog("fixveh", exports.rl_global:getPlayerFullAdminTitle(thePlayer) .. " isimli yetkili (" .. targetPlayerName .. ") isimli kişinin aracını tamir etti.")
						outputChatBox("[!]#FFFFFF " .. username:gsub("_", " ") .. " isimli yetkili aracınızı tamir etti.", targetPlayer, 0, 0, 255, true)
					else
						outputChatBox("[!]#FFFFFF Oyuncu bir araçta değil!", thePlayer, 255, 0, 0, true)
					end
				end
			end
		end
	end
end
addCommandHandler("fixveh", fixPlayerVehicle, false, false)

function setCarHP(thePlayer, commandName, target, hp)
	if (exports.rl_integration:isPlayerGeneralAdmin(thePlayer)) then
		if not (target) or not (hp) then
			outputChatBox("KULLANIM: /" .. commandName .. " [Karakter Adı / ID] [Health]", thePlayer, 255, 194, 14)
		else
			local username = getPlayerName(thePlayer)
			local targetPlayer, targetPlayerName = exports.rl_global:findPlayerByPartialNick(thePlayer, target)

			if targetPlayer then
				local logged = getElementData(targetPlayer, "logged")
				if (not logged) then
					outputChatBox("[!]#FFFFFF Bu oyuncu karakterine giriş yapmadığı için işlem gerçekleşmedi.", thePlayer, 255, 0, 0, true)
				else
					local veh = getPedOccupiedVehicle(targetPlayer)
					if (veh) then
						local sethp = setElementHealth(veh, tonumber(hp))

						if (sethp) then
							outputChatBox("You set " .. targetPlayerName .. "'s vehicle health to " .. hp .. ".", thePlayer)
						
						else
							outputChatBox("Invalid health value.", thePlayer, 255, 0, 0)
						end
					else
						outputChatBox("That player is not in a vehicle.", thePlayer, 255, 0, 0)
					end
				end
			end
		end
	end
end
addCommandHandler("setcarhp", setCarHP, false, false)

function fixAllVehicles(thePlayer, commandName)
	if (exports.rl_integration:isPlayerTrialAdmin(thePlayer)) then
		local username = getPlayerName(thePlayer)
		for key, value in ipairs(exports.rl_pool:getPoolElementsByType("vehicle")) do
			fixVehicle(value)
			if (not getElementData(value, "Impounded")) then
				setElementData(value, "enginebroke", 0)
				if armoredCars[getElementModel(value)] then
					setVehicleDamageProof(value, true)
				else
				setVehicleDamageProof(value, false)
				end
			end
		end
		outputChatBox(">> Tüm araçlar tamir edildi.", root, 255, 194, 14)
	end
end
addCommandHandler("fixvehs", fixAllVehicles)

function fuelPlayerVehicle(thePlayer, commandName, target, amount)
	if (exports.rl_integration:isPlayerTrialAdmin(thePlayer)) then
		if not (target) or not (amount) then
			outputChatBox("KULLANIM: /" .. commandName .. " [Karakter Adı / ID] [Litr, 0 = Full]", thePlayer, 255, 194, 14)
		else
			local username = getPlayerName(thePlayer)
			local targetPlayer, targetPlayerName = exports.rl_global:findPlayerByPartialNick(thePlayer, target)
			local amount = math.floor(tonumber(amount) or 0)

			if targetPlayer then
				local logged = getElementData(targetPlayer, "logged")
				if (not logged) then
					outputChatBox("[!]#FFFFFF Bu oyuncu karakterine giriş yapmadığı için işlem gerçekleşmedi.", thePlayer, 255, 0, 0, true)
				else
					local veh = getPedOccupiedVehicle(targetPlayer)
					if (veh) then
						if exports["rl_vehicle-fuel"]:getMaxFuel(getElementModel(veh)) < amount or amount == 0 then
							amount = exports["rl_vehicle-fuel"]:getMaxFuel(getElementModel(veh))
						end
						setElementData(veh, "fuel", amount)
						outputChatBox("[!]#FFFFFF " .. targetPlayerName .. " isimli oyuncunun araç benzini fullendi.", thePlayer, 0, 255, 0, true)
						outputChatBox("[!]#FFFFFF " .. exports.rl_global:getPlayerFullAdminTitle(targetPlayer) .. " isimli yetkili araç benzinini fulledi.", targetPlayer, 0, 255, 0, true)
					else
						outputChatBox("[!]#FFFFFF Seçtiğiniz oyuncu arabada değil.", thePlayer, 255, 0, 0,true)
					end
				end
			end
		end
	end
end
addCommandHandler("fuelveh", fuelPlayerVehicle, false, false)

function fuelAllVehicles(thePlayer, commandName)
	if (exports.rl_integration:isPlayerTrialAdmin(thePlayer)) then
		for key, value in ipairs(exports.rl_pool:getPoolElementsByType("vehicle")) do
			setElementData(value, "fuel", exports["rl_vehicle-fuel"]:getMaxFuel(getElementModel(value)))
		end
		outputChatBox(">> Tüm araçların benzinleri dolduruldu.", root, 255, 194, 14)
	end
end
addCommandHandler("fuelvehs", fuelAllVehicles, false, false)

function setPlayerVehicleColor(thePlayer, commandName, target, ...)
	if exports.rl_integration:isPlayerTrialAdmin(thePlayer) then
		if not tonumber(target) or not (...) then
			outputChatBox("KULLANIM: /" .. commandName .. " [Araç ID] [Colors ...]", thePlayer, 255, 194, 14)
		else
			local username = getPlayerName(thePlayer)
			for i, c in ipairs(exports.rl_pool:getPoolElementsByType("vehicle")) do
				if (getElementData(c, "dbid") == tonumber(target)) then
					theVehicle = c
					break
				end
			end

			if theVehicle then
				local colors = {...}
				local col = {}
				for i = 1, math.min(4, #colors) do
					local r, g, b = getColorFromString(#colors[i] == 6 and ("#" .. colors[i]) or colors[i])
					if r and g and b then
						col[i] = {r = r, g = g, b = b}
					elseif tonumber(colors[1]) and tonumber(colors[1]) >= 0 and tonumber(colors[1]) <= 255 then
						col[i] = math.floor(tonumber(colors[i]))
					else
						outputChatBox("Invalid color: " .. colors[i], thePlayer, 255, 0, 0)
						return
					end
				end
				if not col[2] then col[2] = col[1] end
				if not col[3] then col[3] = col[1] end
				if not col[4] then col[4] = col[2] end

				local set = false
				if type(col[1]) == "number" then
					set = setVehicleColor(theVehicle, col[1], col[2], col[3], col[4])
				else
					set = setVehicleColor(theVehicle, col[1].r, col[1].g, col[1].b, col[2].r, col[2].g, col[2].b, col[3].r, col[3].g, col[3].b, col[4].r, col[4].g, col[4].b)
				end

				if set then
					outputChatBox("[!]#FFFFFF Araç rengini başarıyla değiştirdin.", thePlayer, 0, 255, 0,true)
					exports['rl_save']:saveVehicleMods(theVehicle)
					addVehicleLogs(getElementData(theVehicle,"dbid"), commandName..table.concat({...}, " "), thePlayer)
				else
					outputChatBox("[!]#FFFFFF Geçersiz araç ID.", thePlayer, 255, 194, 14, true)
				end
			else
				outputChatBox("[!]#FFFFFF Araç bulunamadı.", thePlayer, 255, 0, 0, true)
			end
		end
	end
end
addCommandHandler("setcolor", setPlayerVehicleColor, false, false)

function getAVehicleColor(thePlayer, commandName, carid)
	if (exports.rl_integration:isPlayerSeniorAdmin(thePlayer)) then
		if not (carid) then
			outputChatBox("KULLANIM: /" .. commandName .. " [Car ID]", thePlayer, 255, 194, 14)
		else
			local acar = nil
			for i,c in ipairs(getElementsByType("vehicle")) do
				if (getElementData(c, "dbid") == tonumber(carid)) then
					acar = c
				end
			end
			if acar then
				local col =  { getVehicleColor(acar, true) }
				outputChatBox("Vehicle's colors are:", thePlayer)
				outputChatBox("1. " .. col[1].. "," .. col[2] .. "," .. col[3] .. " = " .. ("#%02X%02X%02X"):format(col[1], col[2], col[3]), thePlayer)
				outputChatBox("2. " .. col[4].. "," .. col[5] .. "," .. col[6] .. " = " .. ("#%02X%02X%02X"):format(col[4], col[5], col[6]), thePlayer)
				outputChatBox("3. " .. col[7].. "," .. col[8] .. "," .. col[9] .. " = " .. ("#%02X%02X%02X"):format(col[7], col[8], col[9]), thePlayer)
				outputChatBox("4. " .. col[10].. "," .. col[11] .. "," .. col[12] .. " = " .. ("#%02X%02X%02X"):format(col[10], col[11], col[12]), thePlayer)
			else
				outputChatBox("[!]#FFFFFF Geçersiz araç ID.", thePlayer, 255, 194, 14, true)
			end
		end
	end
end
addCommandHandler("getcolor", getAVehicleColor, false, false)

function removeVehicle(thePlayer, commandName, id)
	if exports.rl_integration:isPlayerServerManager(thePlayer) then
		local dbid = tonumber(id)
		if not dbid or dbid%1~=0 or dbid <=0 then
			dbid = getElementData(thePlayer, "vehicleManager:deletedVeh") or false
			if not dbid then
				outputChatBox("KULLANIM: /" .. commandName .. " [ID]", thePlayer, 255, 194, 14)
				return false
			end
		end
		
		dbQuery(function(qh, thePlayer, id)
			local res, rows, err = dbPoll(qh, 0)
			if rows > 0 then
				for index, row in ipairs(res) do
					if row["deleted"] == "0" then
						outputChatBox("Please use /delveh "..dbid.." first.", thePlayer, 255, 0, 0)
						return false
					else
						local theVehicle = exports["rl_vehicle"]:loadOneVehicle(dbid, false, true)
						if theVehicle then
							outputChatBox("Deleted " .. (clearVehicleInventory(theVehicle) or "0") .. " item(s) from vehicle's inventory.",thePlayer)
						else
							outputChatBox("Failed to clear vehicle's inventory.",thePlayer, 255,0,0)
							outputDebugString("[VEH MANAGER] Failed to clear vehicle's inventory.")
						end

						triggerEvent("onVehicleDelete", theVehicle)
						destroyElement(theVehicle)
						dbExec(mysql:getConnection(), "DELETE FROM `vehicles` WHERE `id`='" .. (dbid) .. "'")
						dbExec(mysql:getConnection(), "DELETE FROM `vehicle_logs` WHERE `vehID`='" .. (dbid) .. "'")
					
						call(getResourceFromName("rl_items"), "deleteAll", 3, dbid)

						local adminUsername = getElementData(thePlayer, "account_username")
						local hiddenAdmin = getElementData(thePlayer, "hidden_admin")
						local adminTitle = exports.rl_global:getPlayerAdminTitle(thePlayer)

						if not hiddenAdmin then
							exports.rl_global:sendMessageToAdmins("[VEHICLE]: "..adminTitle.." ".. getPlayerName(thePlayer):gsub("_", " ").. " ("..adminUsername..") has removed vehicle ID: #" .. dbid .. " completely from SQL.")
						else
							exports.rl_global:sendMessageToAdmins("[VEHICLE]: Gizli Yetkili has removed vehicle ID: #" .. dbid .. " completely from SQL.")
						end
						return true
					end
				end
			end
		end, {thePlayer, id}, mysql:getConnection(), "SELECT `deleted` FROM `vehicles` WHERE id='" .. (dbid) .. "'")
	else
		outputChatBox("You don't have permission to remove vehicles from SQL.", thePlayer, 255, 0, 0)
	end
end
addCommandHandler("removeveh", removeVehicle, false, false)
addCommandHandler("removevehicle", removeVehicle, false, false)

function clearVehicleInventory(theVehicle)
	if theVehicle then
		local count = 0
		for key, item in pairs(exports["rl_items"]:getItems(theVehicle)) do
			exports.rl_global:takeItem(theVehicle, item[1], item[2])
			count = count + 1
		end
		return count
	else
		outputDebugString("[VEH MANAGER] / vehicle commands / clearVehicleInventory() / element not found.")
		return false
	end
end

function adminClearVehicleInventory(thePlayer, commandName, vehicle)
	if exports.rl_integration:isPlayerGeneralAdmin(thePlayer) then
		vehicle = tonumber(vehicle)
		if vehicle and (vehicle%1==0) then
			for _, theVehicle in pairs(getElementsByType("vehicle")) do
				if getElementData(theVehicle, "dbid") == vehicle then
					vehicle = theVehicle
					break
				end
			end
		end

		if not isElement(vehicle) then
			vehicle = getPedOccupiedVehicle(thePlayer) or false
		end

		if not vehicle then
			outputChatBox("KULLANIM: /" .. commandName .. " [Araç ID]     -> Clear all items in a vehicle inventory.", thePlayer, 255, 194, 14)
			outputChatBox("KULLANIM: /" .. commandName .. "          -> Clear all items in current vehicle inventory.", thePlayer, 255, 194, 14)
			return false
		end

		outputChatBox("Deleted " .. (clearVehicleInventory(vehicle) or "0") .. " item(s) from vehicle's inventory.",thePlayer)

	else
		outputChatBox("Only Admins can perform this command. Operation cancelled.", thePlayer, 255,0,0)
	end
end
addCommandHandler("clearvehinv", adminClearVehicleInventory, false, false)
addCommandHandler("clearvehicleinventory", adminClearVehicleInventory, false, false)

function restoreVehicle(thePlayer, commandName, id)
	if exports.rl_integration:isPlayerGeneralAdmin(thePlayer) then
		local dbid = tonumber(id)
		if not (dbid) then
			outputChatBox("KULLANIM: /" .. commandName .. " [Araç ID]", thePlayer, 255, 194, 14)
		else
			local theVehicle = exports.rl_pool:getElement("vehicle", dbid)
			local adminUsername = getElementData(thePlayer, "account_username")
			local hiddenAdmin = getElementData(thePlayer, "hidden_admin")
			local adminTitle = exports.rl_global:getPlayerAdminTitle(thePlayer)
			local adminID = getElementData(thePlayer, "account_id")
			if not theVehicle then
				if dbExec(mysql:getConnection(), "UPDATE `vehicles` SET `deleted`='0', `chopped`='0' WHERE `id`='" .. dbid .. "'") then
					call(getResourceFromName("rl_vehicle"), "loadOneVehicle", dbid)
					outputChatBox("Restoring vehicle ID #" .. dbid .. "...", thePlayer)
					setTimer(function()
						outputChatBox("Restoring vehicle ID #" .. dbid .. "...Done!", thePlayer)
						addVehicleLogs(dbid, commandName, thePlayer)
						
						local theVehicle1 = exports.rl_pool:getElement("vehicle", dbid)
						local vehicleID = getElementModel(theVehicle1)
						local vehicleName = getVehicleNameFromModel(vehicleID)
						local owner = getElementData(theVehicle1, "owner")
						local faction = getElementData(theVehicle1, "faction")
						local ownerName = ""
						if faction then
							if (faction>0) then
								local theTeam = exports.rl_pool:getElement("team", faction)
								if theTeam then
									ownerName = getTeamName(theTeam)
								end
							elseif (owner==-1) then
								ownerName = "Admin Temp Vehicle"
							elseif (owner>0) then
								ownerName = exports['rl_cache']:getCharacterName(owner, true)
							else
								ownerName = "Civilian"
							end
						else
							ownerName = "Car Dealership"
						end

						if not hiddenAdmin then
							exports.rl_global:sendMessageToAdmins("[RESTOREVEH] " .. exports.rl_global:getPlayerFullAdminTitle(thePlayer) .. " isimli yetkili " .. owner .. " adına olan " .. vehicleName .. " markalı aracı restore etti.")
							exports.rl_logs:addLog("restoreveh", exports.rl_global:getPlayerFullAdminTitle(thePlayer) .. " isimli yetkili " .. owner .. " adına olan " .. vehicleName .. " markalı aracı restore etti.\nID: " .. dbid)
						else
							exports.rl_global:sendMessageToAdmins("[RESTOREVEH] Gizli Yetkili " .. owner .. " adına olan " .. vehicleName .. " markalı aracı restore etti.")
							exports.rl_logs:addLog("restoreveh", "Gizli Yetkili " .. owner .. " adına olan " .. vehicleName .. " markalı aracı restore etti.\nID: " .. dbid)
						end
					end, 2000,1)

				else
					outputChatBox("Database Error!", thePlayer, 255, 0, 0)
				end
			else
				outputChatBox("Vehicle ID #" .. dbid .. " is existed in game, please use /delveh first.", thePlayer, 255, 0, 0)
			end
		end
	end
end
addCommandHandler("restoreveh", restoreVehicle, false, false)
addCommandHandler("restorevehicle", restoreVehicle, false, false)

function deleteVehicle(thePlayer, commandName, id)
	if exports.rl_integration:isPlayerLeaderAdmin(thePlayer) then
		local dbid = tonumber(id)
		if not (dbid) then
			outputChatBox("KULLANIM: /" .. commandName .. " [Araç ID]", thePlayer, 255, 194, 14)
		else
			local theVehicle = exports.rl_pool:getElement("vehicle", dbid)
			local adminUsername = getElementData(thePlayer, "account_username")
			local hiddenAdmin = getElementData(thePlayer, "hidden_admin")
			local adminTitle = exports.rl_global:getPlayerAdminTitle(thePlayer)
			local adminID = getElementData(thePlayer, "account_id")
			if theVehicle then
				local protected, details = exports['rl_vehicle']:isProtected(theVehicle) 
	            if protected then
	                outputChatBox("[!]#FFFFFF Bu araçta araç koruması mevcut biticeği zaman: " .. details .. ".", thePlayer, 255,0,0)
	                return false
	            end
	            local active, details2, secs = exports['rl_vehicle']:isActive(theVehicle)
	            if active and exports.rl_data:get(getElementData(thePlayer, "account_id") .. "/" .. commandName) ~= dbid then
	            	local inactiveText = ""
	                local owner_last_login = getElementData(theVehicle, "owner_last_login")
					if owner_last_login and tonumber(owner_last_login) then
						local owner_last_login_text, owner_last_login_sec = exports.rl_datetime:formatTimeInterval(owner_last_login)
						inactiveText = inactiveText .. " Owner last seen " .. owner_last_login_text .. " "
					else
						inactiveText = inactiveText .. " Owner last seen is irrelevant, "
					end
	                local lastused = getElementData(theVehicle, "lastused")
					if lastused and tonumber(lastused) then
						local lastusedText, lastusedSeconds = exports.rl_datetime:formatTimeInterval(lastused)
						inactiveText = inactiveText .. "Last used " .. lastusedText .. ", "
					else
						inactiveText = inactiveText .. "Last used is irrelevant, "
					end
					outputChatBox("This vehicle is still active. " .. inactiveText .. " Please /" .. commandName .. " " .. dbid .. " again to proceed.", thePlayer, 255, 0, 0)
					exports.rl_data:save(dbid, getElementData(thePlayer, "account_id") .. "/" .. commandName)
					return false
	            end
				local vehicleID = getElementModel(theVehicle)
				local vehicleName = getVehicleNameFromModel(vehicleID)
				local owner = getElementData(theVehicle, "owner")
				local faction = getElementData(theVehicle, "faction")
				local ownerName = ""
				if faction then
					if (faction>0) then
						local theTeam = exports.rl_pool:getElement("team", faction)
						if theTeam then
							ownerName = getTeamName(theTeam)
						end
					elseif (owner==-1) then
						ownerName = "Admin Temp Vehicle"
					elseif (owner>0) then
						ownerName = exports['rl_cache']:getCharacterName(owner, true)
					else
						ownerName = "Civilian"
					end
				else
					ownerName = "Car Dealership"
				end

				triggerEvent("onVehicleDelete", theVehicle)
				if (dbid<0) then
					destroyElement(theVehicle)
				else
					dbExec(mysql:getConnection(), "UPDATE `vehicles` SET `deleted`='" .. tostring(adminID) .. "' WHERE `id`='" .. dbid .. "'")
					destroyElement(theVehicle)

					if not hiddenAdmin then
						exports.rl_global:sendMessageToAdmins("[VEHICLE]: " .. adminTitle .. " " ..  getPlayerName(thePlayer):gsub("_", " ").. " (" .. adminUsername .. ") has deleted a " .. vehicleName .. " (ID: #" .. dbid .. " - Owner: " .. ownerName .. ").")
						exports.rl_logs:addLog("delveh", exports.rl_global:getPlayerFullAdminTitle(thePlayer) .. " isimli yetkili (" .. owner .. ") adına olan (" .. vehicleName .. ") markalı aracı sildi.\nID: " .. dbid)
					else
						exports.rl_global:sendMessageToAdmins("[VEHICLE]: Gizli Yetkili has deleted a " .. vehicleName .. " (ID: #" .. dbid .. " - Owner: " .. ownerName .. ").")
					end
					addVehicleLogs(dbid, commandName, thePlayer)

					call(getResourceFromName("rl_items"), "deleteAll", 3, dbid)
					call(getResourceFromName("rl_items"), "clearItems", theVehicle)

					for k, theObject in ipairs(getElementsByType("object", getResourceRootElement(getResourceFromName("rl_item-world")))) do
					local itemID = getElementData(theObject, "itemID")
					local itemValue = getElementData(theObject, "itemValue")
					if itemID == 3 and itemValue == dbid then
						destroyElement(theObject)
						dbExec(mysql:getConnection(), "DELETE FROM worlditems WHERE itemid='3' AND itemvalue='" .. dbid .. "'")
					end
				end
					setElementData(thePlayer, "vehicleManager:deletedVeh", dbid)
				end
				outputChatBox("Sildiğin araç " .. vehicleName .. " (ID: #" .. dbid .. " - Sahibi: " .. ownerName .. ").", thePlayer, 255, 126, 0)
			else
				outputChatBox("[!]#FFFFFF Geçersiz araç ID.", thePlayer, 255, 194, 14, true)
			end
		end
	end
end
addCommandHandler("delveh", deleteVehicle, false, false)
addCommandHandler("deletevehicle", deleteVehicle, false, false)

function deleteThisVehicle(thePlayer, commandName)
	local veh = getPedOccupiedVehicle(thePlayer)
	local dbid = getElementData(veh, "dbid")
	if (exports.rl_integration:isPlayerTrialAdmin(thePlayer)) then
		if not (isPedInVehicle(thePlayer)) then
			outputChatBox("You are not in a vehicle.", thePlayer, 255, 0, 0)
		else
			deleteVehicle(thePlayer, "delveh", dbid)
		end
	else
		outputChatBox("You do not have the permission to delete permanent vehicles.", thePlayer, 255, 0, 0)
	end
end
addCommandHandler("delthisveh", deleteThisVehicle, false, false)

function setVehicleFaction(thePlayer, theCommand, vehicleID, factionID)
	if exports.rl_integration:isPlayerGeneralAdmin(thePlayer)  then
		if not (vehicleID) or not (factionID) then
			outputChatBox("KULLANIM: /" .. theCommand .. " [Araç ID] [Birlik ID]", thePlayer, 255, 194, 14)
		else
			local owner = -1
			local theVehicle = exports.rl_pool:getElement("vehicle", vehicleID)
			local factionElement = exports.rl_pool:getElement("team", factionID)
			if theVehicle then
				if (tonumber(factionID) == -1) then
					owner = getElementData(thePlayer, "dbid")
				else
					if not factionElement then
						outputChatBox("No faction with that ID found.", thePlayer, 255, 0, 0)
						return
					end
				end

				dbExec(mysql:getConnection(), "UPDATE `vehicles` SET `owner`='" .. owner .. "', `faction`='" .. factionID .. "' WHERE id = '" .. vehicleID .. "'")

				local x, y, z = getElementPosition(theVehicle)
				local int = getElementInterior(theVehicle)
				local dim = getElementDimension(theVehicle)
				exports['rl_vehicle']:reloadVehicle(tonumber(vehicleID))
				local newVehicleElement = exports.rl_pool:getElement("vehicle", vehicleID)
				setElementPosition(newVehicleElement, x, y, z)
				setElementInterior(newVehicleElement, int)
				setElementDimension(newVehicleElement, dim)
				outputChatBox("[!]#FFFFFF Aracı başarıyla faction'a atadınız.", thePlayer,0,255,0,true)
				addVehicleLogs(vehicleID, theCommand .. " " .. factionID, thePlayer)
			else
				outputChatBox("[!]#FFFFFF Geçersiz araç ID.", thePlayer, 255, 0, 0,true)
			end
		end
	end
end
addCommandHandler("setvehiclefaction", setVehicleFaction)
addCommandHandler("setvehfaction", setVehicleFaction)

function setVehTint(admin, command, target, status)
	if exports.rl_integration:isPlayerSeniorAdmin(admin) then
		if not (target) or not (status) then
			outputChatBox("KULLANIM: /" .. command .. " [player] [0- Off, 1- On]", admin, 255, 194, 14)
		else
			local username = getPlayerName(admin):gsub("_"," ")
			local targetPlayer, targetPlayerName = exports.rl_global:findPlayerByPartialNick(admin, target)

			if (targetPlayer) then
				local pv = getPedOccupiedVehicle(targetPlayer)
				if (pv) then
					local vid = getElementData(pv, "dbid")
					local stat = tonumber(status)
					if (stat == 1) then
						dbExec(mysql:getConnection(), "UPDATE vehicles SET tintedwindows = '1' WHERE id='" .. vid .. "'")
						for i = 0, getVehicleMaxPassengers(pv) do
							local player = getVehicleOccupant(pv, i)
							if (player) then
								triggerEvent("setTintName", pv, player)
							end
						end

						setElementData(pv, "tinted", true)
						
						outputChatBox("[!]#FFFFFF Cam filmi ekledin! Araç id: #" .. vid .. ".", admin,0,255,0,true)
						addVehicleLogs(vid, command .. " on", admin)
					elseif (stat == 0) then
						dbExec(mysql:getConnection(), "UPDATE vehicles SET tintedwindows = '0' WHERE id='" .. vid .. "'")
						for i = 0, getVehicleMaxPassengers(pv) do
							local player = getVehicleOccupant(pv, i)
							if (player) then
								triggerEvent("resetTintName", pv, player)
							end
						end
						
						setElementData(pv, "tinted", false)
						
						outputChatBox("[!]#FFFFFF Cam filmini sildiğiniz araç: #" .. vid .. ".", admin,255,255,0,true)
						addVehicleLogs(vid, command .. " off", admin)
					end
				else
					outputChatBox("[!]#FFFFFF Oyuncu araçta değil.", admin, 255, 194, 14,true)
				end
			end
		end
	end
end
addCommandHandler("setvehtint", setVehTint)

function setVehiclePlate(thePlayer, theCommand, vehicleID, ...)
	if exports.rl_integration:isPlayerGeneralAdmin(thePlayer)  then
		if not (vehicleID) or not (...) then
			outputChatBox("KULLANIM: /" .. theCommand .. " [Araç ID] [Plaka]", thePlayer, 255, 194, 14)
		else
			local theVehicle = exports.rl_pool:getElement("vehicle", vehicleID)
			if theVehicle then
				local plateText = table.concat({...}, " ")
				for index, value in ipairs(getElementsByType("vehicle")) do
					if getVehiclePlateText(value) == plateText then
						usingPlateText = true
					else
						usingPlateText = false
					end
				end
				
				if not (usingPlateText) then
					dbExec(mysql:getConnection(), "UPDATE vehicles SET plate = ? WHERE id = ?", plateText, vehicleID)
					local x, y, z = getElementPosition(theVehicle)
					local int = getElementInterior(theVehicle)
					local dim = getElementDimension(theVehicle)
					exports.rl_vehicle:reloadVehicle(tonumber(vehicleID))
					local newVehicleElement = exports.rl_pool:getElement("vehicle", vehicleID)
					setElementPosition(newVehicleElement, x, y, z)
					setElementInterior(newVehicleElement, int)
					setElementDimension(newVehicleElement, dim)
					outputChatBox("[!]#FFFFFF Aracın plakasını başarıyla değiştirdiniz.", thePlayer, 0, 255, 0, true)

					addVehicleLogs(vehicleID, theCommand .. " " .. plateText, thePlayer)
				else
					outputChatBox("[!]#FFFFFF Bu plaka şuanda aktif olarak kullanılıyor.", thePlayer, 255, 0, 0, true)
				end
			else
				outputChatBox("[!]#FFFFFF Geçersiz araç ID.", thePlayer, 255, 0, 0, true)
			end
		end
	end
end
addCommandHandler("setvehicleplate", setVehiclePlate)
addCommandHandler("setvehplate", setVehiclePlate)

function warpPedIntoVehicle2(player, car, ...)
	local dimension = getElementDimension(player)
	local interior = getElementInterior(player)

	setElementDimension(player, getElementDimension(car))
	setElementInterior(player, getElementInterior(car))
	if warpPedIntoVehicle(player, car, ...) then
		setElementData(player, "realinvehicle", 1)
		return true
	else
		setElementDimension(player, dimension)
		setElementInterior(player, interior)
	end
	return false
end

function enterCar(thePlayer, commandName, targetPlayerName, targetVehicle, seat)
	if exports.rl_integration:isPlayerTrialAdmin(thePlayer) then
		targetVehicle = tonumber(targetVehicle)
		seat = tonumber(seat)
		if targetPlayerName and targetVehicle then
			local targetPlayer, targetPlayerName = exports.rl_global:findPlayerByPartialNick(thePlayer, targetPlayerName)
			if targetPlayer then
				local theVehicle = exports.rl_pool:getElement("vehicle", targetVehicle)
				if theVehicle then
					if seat then
						local occupant = getVehicleOccupant(theVehicle, seat)
						if occupant then
							removePedFromVehicle(occupant)
							outputChatBox("Admin " .. getPlayerName(thePlayer):gsub("_", " ") .. " has put " .. targetPlayerName .. " onto your seat.", occupant)
							setElementData(occupant, "realinvehicle", 0)
						end

						if warpPedIntoVehicle2(targetPlayer, theVehicle, seat) then
							outputChatBox("Admin " .. getPlayerName(thePlayer):gsub("_", " ") .. " has warped you into this " .. getVehicleName(theVehicle) .. ".", targetPlayer)
							outputChatBox("You warped " .. targetPlayerName .. " into " .. getVehicleName(theVehicle) .. " #" .. targetVehicle .. ".", thePlayer)
						else
							outputChatBox("Unable to warp " .. targetPlayerName .. " into " .. getVehicleName(theVehicle) .. " #" .. targetVehicle .. ".", thePlayer, 255, 0, 0)
						end
					else
						local found = false
						local maxseats = getVehicleMaxPassengers(theVehicle) or 2
						for seat = 0, maxseats  do
							local occupant = getVehicleOccupant(theVehicle, seat)
							if not occupant then
								found = true
								if warpPedIntoVehicle2(targetPlayer, theVehicle, seat) then
									outputChatBox("Admin " .. getPlayerName(thePlayer):gsub("_", " ") .. " has warped you into this " .. getVehicleName(theVehicle) .. ".", targetPlayer)
									outputChatBox("You warped " .. targetPlayerName .. " into " .. getVehicleName(theVehicle) .. " #" .. targetVehicle .. ".", thePlayer)
								else
									outputChatBox("Unable to warp " .. targetPlayerName .. " into " .. getVehicleName(theVehicle) .. " #" .. targetVehicle .. ".", thePlayer, 255, 0, 0)
								end
								break
							end
						end

						if not found then
							outputChatBox("No free seats.", thePlayer, 255, 0, 0)
						end
					end

					addVehicleLogs(targetVehicle, commandName .. " " .. targetPlayerName, thePlayer)
				else
					outputChatBox("Vehicle not found", thePlayer, 255, 0, 0)
				end
			end
		else
			outputChatBox("KULLANIM: /" .. commandName .. " [player] [car ID] [seat]", thePlayer, 255, 194, 14)
		end
	end
end
addCommandHandler("entercar", enterCar, false, false)
addCommandHandler("enterveh", enterCar, false, false)
addCommandHandler("entervehicle", enterCar, false, false)

function setOdometer(thePlayer, theCommand, vehicleID, odometer)
	if exports.rl_integration:isPlayerTrialAdmin(thePlayer) then
		if not tonumber(vehicleID) or not tonumber(odometer) then
			outputChatBox("KULLANIM: /" .. theCommand .. " [Araç ID] [Odometer]", thePlayer, 255, 194, 14)
		else
			local theVehicle = exports.rl_pool:getElement("vehicle", vehicleID)
			if theVehicle then
				local oldOdometer = tonumber(getElementData(theVehicle, 'odometer'))
				local actualOdometer = tonumber(odometer) * 1000
				if oldOdometer and dbExec(mysql:getConnection(), "UPDATE vehicles SET odometer='" .. actualOdometer .. "' WHERE id = '" .. vehicleID .. "'") then
					addVehicleLogs(tonumber(vehicleID), "setodometer " .. odometer .. " (from " .. math.floor(oldOdometer/1000) .. ")", thePlayer)
					setElementData(theVehicle, "odometer", actualOdometer)
					outputChatBox("Vehicle odometer set to " .. odometer .. ".", thePlayer, 0, 255, 0)
					for _, v in pairs(getVehicleOccupants(theVehicle)) do
						triggerClientEvent(v, "realism:distance", theVehicle, actualOdometer)
					end
				end
			end
		end
	end
end
addCommandHandler("setodometer", setOdometer)
addCommandHandler("setmilage", setOdometer)

function clearNearbyVehicles(thePlayer, commandName)
    if exports.rl_integration:isPlayerServerManager(thePlayer) then
        local count = 0
		local theVehicle = getPedOccupiedVehicle(thePlayer)
        for _, vehicle in ipairs(exports.rl_global:getNearbyElements(thePlayer, "vehicle")) do
            if vehicle ~= theVehicle then
                if getElementDimension(vehicle) ~= 33333 then
					if (not getElementData(vehicle, "carshop")) and (not getElementData(vehicle, "robbery_vehicle")) then
						local seatCount = 0
					
						for seat, player in pairs(getVehicleOccupants(vehicle)) do
							seatCount = seatCount + 1
						end
						
						if seatCount == 0 then
							setElementDimension(vehicle, 33333)
							count = count + 1
						end
					end
				end
            end
        end
        outputChatBox("[!]#FFFFFF Başarıyla [" .. count .. "] adet araç farklı bir dünyaya gönderildi.", thePlayer, 0, 255, 0, true)
    end
end
addCommandHandler("clearnearbyvehs", clearNearbyVehicles, false, false)

function clearVehicles(thePlayer, commandName)
    if exports.rl_integration:isPlayerServerManager(thePlayer) then
        local count = 0
		local theVehicle = getPedOccupiedVehicle(thePlayer)
        for _, vehicle in ipairs(getElementsByType("vehicle")) do
            if vehicle ~= theVehicle then
				if getElementDimension(vehicle) ~= 33333 then
					if (not getElementData(vehicle, "carshop")) and (not getElementData(vehicle, "robbery_vehicle")) then
						local seatCount = 0
					
						for seat, player in pairs(getVehicleOccupants(vehicle)) do
							seatCount = seatCount + 1
						end
						
						if seatCount == 0 then
							setElementDimension(vehicle, 33333)
							count = count + 1
						end
					end
				end
            end
        end
        outputChatBox("[!]#FFFFFF Başarıyla [" .. count .. "] adet araç farklı bir dünyaya gönderildi.", thePlayer, 0, 255, 0, true)
    end
end
addCommandHandler("clearvehs", clearVehicles, false, false)

function autoRespawnAllCivVehicles()
	local vehicles = exports.rl_pool:getPoolElementsByType("vehicle")
	local counter = 0

	for k, theVehicle in ipairs(vehicles) do
		local dbid = getElementData(theVehicle, "dbid")
		if dbid and dbid > 0 then
			if getElementData(theVehicle, "owner") == -2 then
				local driver = getVehicleOccupant(theVehicle)
				local pass1 = getVehicleOccupant(theVehicle, 1)
				local pass2 = getVehicleOccupant(theVehicle, 2)
				local pass3 = getVehicleOccupant(theVehicle, 3)

				if not pass1 and not pass2 and not pass3 and not driver and not getVehicleTowingVehicle(theVehicle) and #getAttachedElements(theVehicle) == 0 then
					if isElementAttached(theVehicle) then
						detachElements(theVehicle)
					end
					removeElementData(theVehicle, "i:left")
					removeElementData(theVehicle, "i:right")
					respawnTheVehicle(theVehicle)
					setVehicleLocked(theVehicle, false)
					setElementInterior(theVehicle, getElementData(theVehicle, "interior"))
					setElementDimension(theVehicle, getElementData(theVehicle, "dimension"))
					setElementData(theVehicle, "vehicle:radio", 0)
					setElementData(theVehicle, "fuel", 100)
					counter = counter + 1
				end
			end
		end
	end
	outputChatBox(">> Tüm araçların benzinleri dolduruldu.", root, 255, 194, 14)
end
setTimer(autoRespawnAllCivVehicles, 3600000, 0)

function setVehiclePlateDesign(thePlayer, commandName, vehicleID, plateID)
	if exports.rl_integration:isPlayerGeneralAdmin(thePlayer) then
		local plateDesigns = exports["rl_vehicle-plate"]:getPlateDesigns()
		if vehicleID and plateID and tonumber(vehicleID) and tonumber(plateID) then
			vehicleID = tonumber(vehicleID)
			plateID = tonumber(plateID)
			if plateID >= 1 and plateID <= #plateDesigns then
				local theVehicle = exports.rl_pool:getElement("vehicle", vehicleID)
				if theVehicle then
					setElementData(theVehicle, "plate_design", plateID)
					dbExec(exports.rl_mysql:getConnection(), "UPDATE vehicles SET plate_design = ? WHERE id = ?", plateID, vehicleID)
					outputChatBox("[!]#FFFFFF Araç plakası tasarımı başarıyla değiştirildi.", thePlayer, 0, 255, 0, true)
					exports.rl_logs:addLog("setvehplatedesign", exports.rl_global:getPlayerFullAdminTitle(thePlayer) .. " isimli yetkili [" .. vehicleID .. "] ID'li aracın plaka tasarımını [" .. plateID .. "] olarak değiştirdi.")
				else
					outputChatBox("[!]#FFFFFF Geçersiz araç ID.", thePlayer, 255, 0, 0, true)
					playSoundFrontEnd(thePlayer, 4)
				end
			else
				outputChatBox("[!]#FFFFFF Bu numaraya ait plaka yok.", thePlayer, 255, 0, 0, true)
				playSoundFrontEnd(thePlayer, 4)
			end
		else
			outputChatBox("KULLANIM: /" .. commandName .. " [Araç ID] [1-" .. #plateDesigns .. "]", thePlayer, 255, 194, 14)
		end
	end
end
addCommandHandler("setvehicleplatedesign", setVehiclePlateDesign, false, false)
addCommandHandler("setvehplatedesign", setVehiclePlateDesign, false, false)