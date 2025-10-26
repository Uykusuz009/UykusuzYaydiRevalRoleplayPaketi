mysql = exports.rl_mysql

local null = nil
local toLoad = {}
local threads = {}

function SmallestID()
	local result = dbPoll(dbQuery(mysql:getConnection(), "SELECT MIN(e1.id+1) AS nextID FROM vehicles AS e1 LEFT JOIN vehicles AS e2 ON e1.id +1 = e2.id WHERE e2.id IS NULL"), -1)
	if result then
		local id = tonumber(result[1]["nextID"]) or 1
		return id
	end
	return false
end

function getVehicleName(vehicle)
	return exports.rl_global:getVehicleName(vehicle)
end

function createPermVehicle(thePlayer, commandName, ...)
	if exports.rl_integration:isPlayerLeaderAdmin(thePlayer) then
		local args = {...}
		if (#args < 7) then
			printMakeVehError(thePlayer, commandName)
		else

			local vehShopData = exports["rl_vehicle-manager"]:getInfoFromVehShopID(tonumber(args[1]))
			if not vehShopData then
				outputDebugString("VEHICLE SYSTEM / createPermVehicle / FAILED TO FETCH VEHSHOP DATA")
				printMakeVehError(thePlayer, commandName)
				return false
			end

			local vehicleID = tonumber(vehShopData.vehmtamodel)
			local col1, col2, userName, factionVehicle, cost, tint

			if not vehicleID then
				outputDebugString("VEHICLE SYSTEM / createPermVehicle / FAILED TO FETCH VEHSHOP DATA")
				printMakeVehError(thePlayer, commandName)
				return false
			end

			col1 = tonumber(args[2])
			col2 = tonumber(args[3])
			userName = args[4]
			factionVehicle = tonumber(args[5])
			cost = tonumber(args[6])
			if cost < 0 then
				cost = tonumber(vehShopData.vehprice)
			end
			tint = tonumber(args[7])

			local id = vehicleID

			local r = getPedRotation(thePlayer)
			local x, y, z = getElementPosition(thePlayer)
			x = x + ((math.cos(math.rad(r))) * 5)
			y = y + ((math.sin(math.rad(r))) * 5)

			local targetPlayer, username = exports.rl_global:findPlayerByPartialNick(thePlayer, userName)

			if targetPlayer then
				local to = nil
				local dbid = getElementData(targetPlayer, "dbid")

				if (factionVehicle == 1) then
					factionVehicle = tonumber(getElementData(targetPlayer, "faction"))
					local theTeam = getPlayerTeam(targetPlayer)
					to = theTeam

					if not exports.rl_global:takeMoney(theTeam, cost) then
						outputChatBox("[MAKEVEH] This faction cannot afford this vehicle.", thePlayer, 255, 0, 0)
						outputChatBox("Your faction cannot afford this vehicle.", targetPlayer, 255, 0, 0)
						return
					end
				else
					factionVehicle = -1
					to = targetPlayer
					if not exports.rl_global:takeMoney(targetPlayer, cost) then
						outputChatBox("[MAKEVEH] This player cannot afford this vehicle.", thePlayer, 255, 0, 0)
						outputChatBox("You cannot afford this vehicle.", targetPlayer, 255, 0, 0)
						return
					elseif not exports.rl_global:canPlayerBuyVehicle(targetPlayer) then
						outputChatBox("[MAKEVEH] This player has too many cars.", thePlayer, 255, 0, 0)
						outputChatBox("You have too many cars.", targetPlayer, 255, 0, 0)
						exports.rl_global:giveMoney(targetPlayer, cost)
						return
					end
				end
				
				local plate = exports.rl_global:generatePlate()

				local veh = createVehicle(id, x, y, z, 0, 0, r, plate)
				if not (veh) then
					outputChatBox("Invalid Vehicle ID.", thePlayer, 255, 0, 0)
					exports.rl_global:giveMoney(to, cost)
				else
					setVehicleColor(veh, col1, col2, col1, col2)
					local col =  { getVehicleColor(veh, true) }
					local color1 = toJSON({col[1], col[2], col[3]})
					local color2 = toJSON({col[4], col[5], col[6]})
					local color3 = toJSON({col[7], col[8], col[9]})
					local color4 = toJSON({col[10], col[11], col[12]})
					local vehicleName = getVehicleName(veh)
					destroyElement(veh)
					local dimension = getElementDimension(thePlayer)
					local interior = getElementInterior(thePlayer)
					local var1, var2 = exports['rl_vehicle']:getRandomVariant(id)
					local smallestID = SmallestID()
					dbExec(mysql:getConnection(), "INSERT INTO vehicles SET id=?, model=?, x=?, y=?, z=?, rotx='0', roty='0', rotz=?, color1=?, color2=?, color3=?, color4=?, faction=?, owner=?, plate=?, currx=?, curry=?, currz=?, currrx='0', currry='0', currrz=?, locked=1, interior=?, currinterior=?, dimension=?, currdimension=?, tintedwindows=?, variant1=?, variant2=?, creationDate=NOW(), createdBy=?, vehicle_shop_id=?", smallestID, id, x, y, z, r, color1, color2, color3, color4, factionVehicle, (factionVehicle == -1 and dbid or -1), plate, x, y, z, r, interior, interior, dimension, dimension, tint, var1, var2, getElementData(thePlayer, "account_id"), args[1])
					local insertid = smallestID
					if (insertid) then
						if (factionVehicle==-1) then
							exports.rl_global:giveItem(targetPlayer, 3, tonumber(insertid))
						end

						local owner = ""
						if factionVehicle == -1 then
							owner = getPlayerName(targetPlayer)
						else
							owner = "Faction #" .. factionVehicle
						end

						local hiddenAdmin = getElementData(thePlayer, "hidden_admin")
						local adminTitle = exports.rl_global:getPlayerAdminTitle(thePlayer)
						local adminUsername = getElementData(thePlayer, "account_username")
						local adminID = getElementData(thePlayer, "account_id")
						
						local action = commandName .. " " .. vehicleName .. " ($" .. cost .. " - to " .. owner .. ")"
						local success = dbExec(mysql:getConnection(), "INSERT INTO `vehicle_logs` (`vehID`, `action`, `actor`) VALUES (?, ?, ?)", tostring(insertid), action, adminID)
						if not success then
							outputDebugString("Failed to add vehicle logs.")
						end

						if (not hiddenAdmin) then
							exports.rl_global:sendMessageToAdmins("[ADM] " .. tostring(adminTitle) .. " " .. getPlayerName(thePlayer) .. " (" .. adminUsername .. ") has spawned a " .. vehicleName .. " (ID #" .. insertid .. ") to " .. owner .. " for $" .. cost .. ".")
							outputChatBox(tostring(adminTitle) .. " " .. getPlayerName(thePlayer) .. " has spawned a " .. vehicleName .. " (ID #" .. insertid .. ") to you for $" .. cost .. ".", targetPlayer, 255, 194, 14)
							exports.rl_logs:addLog("makeveh", exports.rl_global:getPlayerFullAdminTitle(thePlayer) .. " isimli yetkili " .. owner .. " isimli oyuncu adına " .. vehicleName .. " (" .. insertid .. ") markalı aracı yaratdı.")
						else
							exports.rl_global:sendMessageToAdmins("[ADM] Gizli Yetkili has spawned a " .. vehicleName .. " (ID #" .. insertid .. ") to " .. owner .. " for $" .. cost .. ".")
							outputChatBox("Gizli Yetkili has spawned a " .. vehicleName .. " (ID #" .. insertid .. ") to you for $" .. cost .. ".", targetPlayer, 255, 194, 14)
							exports.rl_logs:addLog("makeveh", exports.rl_global:getPlayerFullAdminTitle(thePlayer) .. " isimli yetkili " .. owner .. " isimli oyuncu adına " .. vehicleName .. " (" .. insertid .. ") markalı aracı yaratdı.")
						end

						reloadVehicle(tonumber(insertid))
					end
				end
			end
		end
	else
		outputChatBox("[!]#FFFFFF Yeterli yetkiniz yok.", thePlayer, 255, 0, 0, true)
		playSoundFrontEnd(thePlayer, 4)
	end
end
addCommandHandler("makeveh", createPermVehicle, false, false)

function printMakeVehError(thePlayer, commandName)
	outputChatBox("KULLANIM: /" .. commandName .. " [ID from Veh Lib] [color1] [color2] [Owner] [Faction Vehicle (1/0)] [-1=carshop price] [Tinted Windows] ", thePlayer, 255, 194, 14)
	outputChatBox("NOTE: If it is a faction vehicle, ownership will be given to the 'owner''s faction.", thePlayer, 255, 194, 14)
	outputChatBox("NOTE: If it is a faction vehicle, the cost is taken from the faction fund, rather than the player.", thePlayer, 255, 194, 14)
end

function createCivilianPermVehicle(thePlayer, commandName, ...)
	if (exports.rl_integration:isPlayerLeaderAdmin(thePlayer)) then
		local args = {...}
		if (#args < 4) then
			outputChatBox("KULLANIM: /" .. commandName .. " [id/name] [color1 (-1 for random)] [color2 (-1 for random)] [Job ID -1 for none]", thePlayer, 255, 194, 14)
			outputChatBox("Job 1 = Delivery Driver", thePlayer, 255, 194, 14)
			outputChatBox("Job 2 = Taxi Driver", thePlayer, 255, 194, 14)
			outputChatBox("Job 3 = Bus Driver", thePlayer, 255, 194, 14)
			outputChatBox("Job 4 = Sigara Kaçakçılığı", thePlayer, 255, 194, 14)
		else
			local vehicleID = tonumber(args[1])
			local col1, col2, job

			if not vehicleID then
				local vehicleEnd = 1
				repeat
					vehicleID = getVehicleModelFromName(table.concat(args, " ", 1, vehicleEnd))
					vehicleEnd = vehicleEnd + 1
				until vehicleID or vehicleEnd == #args
				if vehicleEnd == #args then
					outputChatBox("Invalid Vehicle Name.", thePlayer, 255, 0, 0)
					return
				else
					col1 = tonumber(args[vehicleEnd])
					col2 = tonumber(args[vehicleEnd + 1])
					job = tonumber(args[vehicleEnd + 2])
				end
			else
				col1 = tonumber(args[2])
				col2 = tonumber(args[3])
				job = tonumber(args[4])
			end

			local id = vehicleID

			local r = getPedRotation(thePlayer)
			local x, y, z = getElementPosition(thePlayer)
			local interior = getElementInterior(thePlayer)
			local dimension = getElementDimension(thePlayer)
			x = x + ((math.cos (math.rad (r))) * 5)
			y = y + ((math.sin (math.rad (r))) * 5)

			local plate = exports.rl_global:generatePlate()

			local veh = createVehicle(id, x, y, z, 0, 0, r, plate)
			if not (veh) then
				outputChatBox("Invalid Vehicle ID.", thePlayer, 255, 0, 0)
			else
				local vehicleName = getVehicleName(veh)
				destroyElement(veh)

				local var1, var2 = exports['rl_vehicle']:getRandomVariant(id)
				local smallestID = SmallestID()
				local insertid = dbExec(mysql:getConnection(), "INSERT INTO vehicles SET id='" .. (smallestID) .. "', job='" .. (job) .. "', model='" .. (args[1]) .. "', x='" .. (x) .. "', y='" .. (y) .. "', z='" .. (z) .. "', rotx='" .. ("0.0") .. "', roty='" .. ("0.0") .. "', rotz='" .. (r) .. "', color1='[ [ 0, 0, 0 ] ]', color2='[ [ 0, 0, 0 ] ]', color3='[ [ 0, 0, 0 ] ]', color4='[ [0, 0, 0] ]', faction='-1', owner='-2', plate='" .. (plate) .. "', currx='" .. (x) .. "', curry='" .. (y) .. "', currz='" .. (z) .. "', currrx='0', currry='0', currrz='" .. (r) .. "', interior='" .. (interior) .. "', currinterior='" .. (interior) .. "', dimension='" .. (dimension) .. "', currdimension='" .. (dimension) .. "',variant1=" .. var1 .. ",variant2=" .. var2 .. ", creationDate=NOW(), createdBy=" .. getElementData(thePlayer, "account_id"))
				insertid = smallestID
				if (insertid) then
					reloadVehicle(insertid)

					local adminID = getElementData(thePlayer, "account_id")
					local addLog = dbExec(mysql:getConnection(), "INSERT INTO `vehicle_logs` (`vehID`, `action`, `actor`) VALUES ('" .. tostring(insertid) .. "', '" .. commandName .. " " .. vehicleName .. " (job " .. job .. ")', '" .. adminID .. "')") or false
					if not addLog then
						outputDebugString("Failed to add vehicle logs.")
					end
				end
			end
		end
	end
end
addCommandHandler("makecivveh", createCivilianPermVehicle, false, false)

vehicleData = {}

function loadAllVehicles(res)
	local vehicleLoadList = {}
	dbQuery(function(qh)
		local res, rows, err = dbPoll(qh, 0)
		if rows > 0 then
			Async:foreach(res, function(row)
				vehicleData[tonumber(row.id)] = {}
				for key, value in pairs(row) do
					vehicleData[tonumber(row.id)][key] = value
				end
				loadOneVehicle(row.id)
			end)
		end
	end, mysql:getConnection(), "SELECT * FROM `vehicles` WHERE deleted=0 ORDER BY `id` ASC")
end
addEventHandler("onResourceStart", resourceRoot, loadAllVehicles)

function resume()
	for key, value in ipairs(threads) do
		coroutine.resume(value)
	end
end

function reloadVehicle(id)
	local theVehicle = exports.rl_pool:getElement("vehicle", tonumber(id))
	if (theVehicle) then
		removeSafe(tonumber(id))
		exports.rl_save:saveVehicle(theVehicle)
		destroyElement(theVehicle)
	end

	loadOneVehicle(id, false)
	return true
end

function loadOneVehicle(id, hasCoroutine, loadDeletedOne)
	if (hasCoroutine == nil) then
		hasCoroutine = false
	end

	if loadDeletedOne then
		loadDeletedOne = "AND deleted = '0'"
	else
		loadDeletedOne = ""
	end

	local row = "SELECT v.*, (CASE WHEN ((protected_until IS NULL) OR (protected_until > NOW() = 0)) THEN -1 ELSE TO_SECONDS(protected_until) END) AS protected_until, "
             .. "TO_SECONDS(lastUsed) AS lastused_sec, (CASE WHEN last_login IS NOT NULL THEN TO_SECONDS(last_login) ELSE NULL END) AS owner_last_login "
             .. "FROM vehicles v "
             .. "LEFT JOIN characters c ON v.owner=c.id "
             .. "WHERE v.id = " .. id .. " " .. loadDeletedOne .. " LIMIT 1"
			 
	dbQuery(function(qh)
		local res, rows, err = dbPoll(qh, 0)
		if rows > 0 then
			for index, row in ipairs(res) do
				if (hasCoroutine) then
					coroutine.yield()
				end

				for k, v in pairs(row) do
					if v == null then
						row[k] = nil
					else
						row[k] = tonumber(row[k]) or row[k]
					end
				end
				
				local var1, var2 = row.variant1, row.variant2
				if not isValidVariant(row.model, var1, var2) then
					var1, var2 = getRandomVariant(row.model)
					dbExec(mysql:getConnection(), "UPDATE vehicles SET variant1 = " .. var1 .. ", variant2 = " .. var2 .. " WHERE id='" .. row.id .. "'")
				end

				local veh = createVehicle(row.model, row.currx, row.curry, row.currz, row.currrx, row.currry, row.currrz, row.plate, false, var1, var2)
				if veh then
					setElementData(veh, "dbid", row.id)
					exports.rl_pool:allocateElement(veh, row.id)

					if row.paintjob ~= 0 then
						setVehiclePaintjob(veh, row.paintjob)
					end

					if row.paintjob_url then
						setElementData(veh, "paintjob:url", row.paintjob_url, true)
					end

					local color1 = fromJSON(row.color1)
					local color2 = fromJSON(row.color2)
					local color3 = fromJSON(row.color3)
					local color4 = fromJSON(row.color4)
					setVehicleColor(veh, color1[1], color1[2], color1[3], color2[1], color2[2], color2[3], color3[1], color3[2], color3[3], color4[1], color4[2], color4[3])

					if (armoredCars[row.model]) then
						setVehicleDamageProof(veh, true)
					end

					local upgrades = fromJSON(row["upgrades"]) or {}
					for slot, upgrade in ipairs(upgrades) do
						if upgrade and tonumber(upgrade) > 0 then
							addVehicleUpgrade(veh, upgrade)
						end
					end

					local panelStates = fromJSON(row["panelStates"])
					for panel, state in ipairs(panelStates) do
						setVehiclePanelState(veh, panel-1 , tonumber(state) or 0)
					end

					local doorStates = fromJSON(row["doorStates"])
					for door, state in ipairs(panelStates) do
						setVehicleDoorState(veh, door-1, tonumber(state) or 0)
					end

					local headlightColors = fromJSON(row["headlights"])
					if headlightColors then
						setVehicleHeadLightColor (veh, headlightColors[1], headlightColors[2], headlightColors[3])
					end
					setElementData(veh, "headlightcolors", headlightColors, true)

					local wheelStates = fromJSON(row["wheelStates"])
					setVehicleWheelStates(veh, tonumber(wheelStates[1]) , tonumber(wheelStates[2]) , tonumber(wheelStates[3]) , tonumber(wheelStates[4]))

					setVehicleLocked(veh, row.owner ~= -1 and row.locked == 1)

					setVehicleSirensOn(veh, row.sirens == 1)

					if row.job > 0 then
						toggleVehicleRespawn(veh, true)
						setVehicleRespawnDelay(veh, 60000)
						setVehicleIdleRespawnDelay(veh, 15 * 60000)
						setElementData(veh, "job", row.job)
					else
						setElementData(veh, "job", 0)
					end

					setVehicleRespawnPosition(veh, row.x, row.y, row.z, row.rotx, row.roty, row.rotz)
					setElementData(veh, "respawnposition", {row.x, row.y, row.z, row.rotx, row.roty, row.rotz})

					setElementData(veh, "vehicle_shop_id", row.vehicle_shop_id)
					setElementData(veh, "fuel", row.fuel)
					setElementData(veh, "oldx", row.currx)
					setElementData(veh, "oldy", row.curry)
					setElementData(veh, "oldz", row.currz)
					setElementData(veh, "faction", tonumber(row.faction))
					setElementData(veh, "factionrank", tonumber(row.factionrank) or 1)
					setElementData(veh, "owner", tonumber(row.owner))
					setElementData(veh, "vehicle:windowstat", 0)
					setElementData(veh, "plate", row.plate)
					setElementData(veh, "registered", row.registered)
					setElementData(veh, "show_plate", row.show_plate)
					setElementData(veh, "show_vin", row.show_vin)
					setElementData(veh, "description:1", row.description1)
					setElementData(veh, "description:2", row.description2)
					setElementData(veh, "description:3", row.description3)
					setElementData(veh, "description:4", row.description4)
					setElementData(veh, "description:5", row.description5)
					setElementData(veh, "tuning.neon", row.neon)
					setElementData(veh, "plate_design", row.plate_design)
					setElementData(veh, "punishment", row.punishment)
					
					if row.lastused_sec ~= nil then
						setElementData(veh, "lastused", row.lastused_sec)
					end

					if row.owner_last_login ~= nil then
						setElementData(veh, "owner_last_login", row.owner_last_login)
					end

					if row.owner > 0 and row.protected_until ~= -1 then
						setElementData(veh, "protected_until", row.protected_until)
					end

					local customTextures = fromJSON(row.textures) or {}
					setElementData(veh, "textures", customTextures)

					setElementData(veh, "deleted", row.deleted)
					setElementData(veh, "chopped", row.chopped)
					
					setElementData(veh, "Impounded", tonumber(row.Impounded))
					if tonumber(row.Impounded) > 0 then
						setVehicleDamageProof(veh, true)
						if row.impounder then
							setElementData(veh, "impounder", row.impounder)
						else
							setElementData(veh, "impounder", 4)
						end
					end

					setElementDimension(veh, 33333)
					setElementInterior(veh, row.currinterior)

					setElementData(veh, "dimension", row.dimension)
					setElementData(veh, "interior", row.interior)

					setVehicleOverrideLights(veh, row.lights == 0 and 1 or row.lights)

					if row.hp <= 350 then
						setElementHealth(veh, 300)
						setVehicleDamageProof(veh, true)
						setVehicleEngineState(veh, false)
						setElementData(veh, "engine", 0)
						setElementData(veh, "enginebroke", 1)
					else
						setElementHealth(veh, row.hp)
						setVehicleEngineState(veh, row.engine == 1)
						setElementData(veh, "engine", row.engine)
						setElementData(veh, "enginebroke", 0)
					end
					setVehicleFuelTankExplodable(veh, false)

					setElementData(veh, "handbrake", row.handbrake)
					if row.handbrake > 0 then
						setElementFrozen(veh, true)
					end

					local hasInterior, interior = exports["rl_vehicle-interiors"]:add(veh)
					if hasInterior and row.safepositionX and row.safepositionY and row.safepositionZ and row.safepositionRZ then
						addSafe(row.id, row.safepositionX, row.safepositionY, row.safepositionZ, row.safepositionRZ, interior)
					end

					if row.bulletproof == 1 then
						setVehicleDamageProof(veh, true)
					end

					if row.tintedwindows == 1 then
						setElementData(veh, "tinted", true)
					end
					setElementData(veh, "odometer", tonumber(row.odometer))

					if getResourceFromName("rl_vehicle-manager") then
						exports["rl_vehicle-manager"]:loadCustomVehProperties(tonumber(row.id), veh)
					end

					if #customTextures > 0 then
						for somenumber, texture in ipairs(customTextures) do
							exports["rl_item-texture"]:addTexture(veh, texture[1], texture[2])
						end
					end
					
					return veh
				end
			end
		end
	end, mysql:getConnection(), row)
end

function vehicleExploded()
	local job = getElementData(source, "job")

	if not job or job<=0 then
		setTimer(respawnVehicle, 60000, 1, source)
	end
end
addEventHandler("onVehicleExplode", root, vehicleExploded)

function vehicleRespawn(exploded)
	local id = getElementData(source, "dbid")
	local faction = getElementData(source, "faction")
	local factionrank = getElementData(source, "factionrank")
	local job = getElementData(source, "job")
	local owner = getElementData(source, "owner")
	local windowstat = getElementData(source, "vehicle:windowstat")

	if (job > 0) then
		toggleVehicleRespawn(source, true)
		setVehicleRespawnDelay(source, 60000)
		setVehicleIdleRespawnDelay(source, 15 * 60000)
		setElementFrozen(source, true)
		setElementData(source, "handbrake", 1)
	end

	local vehid = getElementModel(source)
	if (armoredCars[tonumber(vehid)]) then
		setVehicleDamageProof(source, true)
	else
		setVehicleDamageProof(source, false)
	end

	setVehicleFuelTankExplodable(source, false)
	setVehicleEngineState(source, false)
	setVehicleLandingGearDown(source, true)

	setElementData(source, "enginebroke", 0)

	setElementData(source, "dbid", id)
	setElementData(source, "fuel", exports["rl_vehicle-fuel"]:getMaxFuel(vehid))
	setElementData(source, "engine", 0)
	setElementData(source, "vehicle:windowstat", windowstat)

	local x, y, z = getElementPosition(source)
	setElementData(source, "oldx", x)
	setElementData(source, "oldy", y)
	setElementData(source, "oldz", z)

	setElementData(source, "faction", faction)
	setElementData(source, "factionrank", factionrank)
	setElementData(source, "owner", owner)

	setVehicleOverrideLights(source, 1)
	setElementFrozen(source, false)

	setVehicleSirensOn(source, false)

	setVehicleLightState(source, 0, 0)
	setVehicleLightState(source, 1, 0)

	local dimension = getElementDimension(source)
	local interior = getElementInterior(source)

	setElementDimension(source, dimension)
	setElementInterior(source, interior)

	if owner == -1 then
		setVehicleLocked(source, false)
		setElementFrozen(source, true)
		setElementData(source, "handbrake", 1)
	end

	setElementFrozen(source, getElementData(source, "handbrake") == 1)
end
addEventHandler("onVehicleRespawn", resourceRoot, vehicleRespawn)

function setEngineStatusOnEnter(thePlayer, seat)
	if seat == 0 then
		local engine = getElementData(source, "engine")
		local model = getElementModel(source)
		if not (enginelessVehicle[model]) then
			if (engine==0) then
				toggleControl(thePlayer, "brake_reverse", false)
				setVehicleEngineState(source, false)
			else
				toggleControl(thePlayer, "brake_reverse", true)
				setVehicleEngineState(source, true)
			end
		else
			toggleControl(thePlayer, "brake_reverse", true)

			setVehicleEngineState(source, true)
			setElementData(source, "engine", 1)
		end
	end
	triggerEvent("sendCurrentInventory", thePlayer, source)
end
addEventHandler("onVehicleEnter", root, setEngineStatusOnEnter)

function vehicleExit(thePlayer, seat)
	if (isElement(thePlayer)) then
		if getElementType(thePlayer) ~= "player" then return end
		toggleControl(thePlayer, "brake_reverse", true)
		
		local vehid = getElementData(source, "dbid")
		setElementData(thePlayer, "lastvehid", vehid, false)
		setPedGravity(thePlayer, 0.008)
		setElementFrozen(thePlayer, false)
	end
end
addEventHandler("onVehicleExit", root, vehicleExit)

function destroyTyre(veh)
	local tyre1, tyre2, tyre3, tyre4 = getVehicleWheelStates(veh)

	if (tyre1==1) then
		tyre1 = 2
	end

	if (tyre2==1) then
		tyre2 = 2
	end

	if (tyre3==1) then
		tyre3 = 2
	end

	if (tyre4==1) then
		tyre4 = 2
	end

	if (tyre1==2 and tyre2==2 and tyre3==2 and tyre4==2) then
		tyre3 = 0
	end

	setElementData(veh, "tyretimer", nil)
	setVehicleWheelStates(veh, tyre1, tyre2, tyre3, tyre4)
end

function damageTyres()
	local tyre1, tyre2, tyre3, tyre4 = getVehicleWheelStates(source)
	local tyreTimer = getElementData(source, "tyretimer")

	if (tyretimer~=1) then
		if (tyre1==1) or (tyre2==1) or (tyre3==1) or (tyre4==1) then
			setElementData(source, "tyretimer", 1, false)
			local randTime = math.random(5, 15)
			randTime = randTime * 1000
			setTimer(destroyTyre, randTime, 1, source)
		end
	end
end
addEventHandler("onVehicleDamage", root, damageTyres)

function bindKeys()
	local players = exports.rl_pool:getPoolElementsByType("player")
	for k, arrayPlayer in ipairs(players) do
		if not(isKeyBound(arrayPlayer, "j", "down", toggleEngine)) then
			bindKey(arrayPlayer, "j", "down", toggleEngine)
		end

		--[[if not(isKeyBound(arrayPlayer, "l", "down", toggleLights)) then
			bindKey(arrayPlayer, "l", "down", toggleLights)
		end]]--

		if not(isKeyBound(arrayPlayer, "k", "down", toggleLock)) then
			bindKey(arrayPlayer, "k", "down", toggleLock)
		end
	end
end

function bindKeysOnJoin()
	bindKey(source, "j", "down", toggleEngine)
	--bindKey(source, "l", "down", toggleLights)
	bindKey(source, "k", "down", toggleLock)
end
addEventHandler("onResourceStart", resourceRoot, bindKeys)
addEventHandler("onPlayerJoin", root, bindKeysOnJoin)

local spamTimers_engine = {}
function toggleEngine(source, key, keystate)
	local veh = getPedOccupiedVehicle(source)
	local inVehicle = getElementData(source, "realinvehicle")

	if veh and inVehicle == 1 then
		local seat = getPedOccupiedVehicleSeat(source)

		if (seat == 0) then
			if isTimer(spamTimers_engine[source]) then return end
			local model = getElementModel(veh)
			if not (enginelessVehicle[model]) then
				local engine = getElementData(veh, "engine")
				local vehID = getElementData(veh, "dbid")
				local vehKey = exports['rl_global']:hasItem(source, 3, vehID)
				if engine == 0 then
					local vjob = tonumber(getElementData(veh, "job"))
					local job = getElementData(source, "job")
					local owner = getElementData(veh, "owner")
					local faction = tonumber(getElementData(veh, "faction"))
					local factionrank = tonumber(getElementData(veh, "factionrank")) or 1
					local playerFaction = tonumber(getElementData(source, "faction"))
					local playerFactionRank = tonumber(getElementData(source, "factionrank"))
					if (vehKey) or (owner < 0) and (faction == -1) or (playerFaction == faction and playerFactionRank >= factionrank) and (faction ~= -1) or ((getElementData(source, "duty_admin") or false)) then
						local fuel = getElementData(veh, "fuel") or 100
						local broke = getElementData(veh, "enginebroke") or 0
						if broke == 1 then
							exports.rl_global:sendLocalMeAction(source, "aracı çalıştırmayı dener ancak başaramaz.", false, true)
							outputChatBox("[!]#FFFFFF Aracın motoru arızalı.", source, 255, 0, 0, true)
							playSoundFrontEnd(source, 4)
						elseif exports.rl_global:hasItem(veh, 74) then
							while exports.rl_global:hasItem(veh, 74) do
								exports.rl_global:takeItem(veh, 74)
							end
							blowVehicle(veh)
						elseif fuel > 0 then
							randomVehicleEngine = 1
							exports.rl_global:sendLocalMeAction(source, "sağ elini kontağa götürür anahtarı saat yönünde çevirerek motoru çalıştırmaya çalışır.", false, true)
							triggerClientEvent(root, "playVehicleSound", root, "public/sounds/engine.wav", veh)
							setTimer(function()
								if randomVehicleEngine == 1 then
									toggleControl(source, "brake_reverse", true)
									setVehicleEngineState(veh, true)
									if getElementData(veh, "kontakBombasi") then
										blowVehicle(veh)
									else
										setElementData(veh, "engine", 1)
										setElementData(veh, "vehicle:radio", tonumber(getElementData(veh, "vehicle:radio:old")))
										setElementData(veh, "lastused", exports.rl_datetime:now())
										dbExec(mysql:getConnection(), "UPDATE vehicles SET lastUsed = NOW() WHERE id = ?", vehID)
										exports['rl_vehicle-manager']:addVehicleLogs(vehID, "Started engine", source)
										exports.rl_global:sendLocalDoAction(source, "Aracın motoru çalıştırıldı.", false, true)
									end
								else
									exports.rl_global:sendLocalDoAction(source, "Aracın motoru çalıştırılmadı.", false, true)
								end
							end, 1100, 1)
						elseif fuel <= 0 then
							exports.rl_global:sendLocalMeAction(source, "motoru çalıştırmayı dener ancak başaramaz.", false, true)
							outputChatBox("[!]#FFFFFF Araçta hiç benzin yok.", source, 255, 0, 0, true)
							playSoundFrontEnd(source, 4)
						end
					else
						outputChatBox("[!]#FFFFFF Aracı çalıştırmak için bir anahtara ihtiyacınız var.", source, 255, 0, 0, true)
						playSoundFrontEnd(source, 4)
					end
				else
					exports.rl_global:sendLocalMeAction(source, "sağ elini kontak anahtarına götürür ve motoru kapatmak için anahtarı saat yönünün tersine çevirir.", false, true)
					triggerClientEvent(root, "playVehicleSound", root, "public/sounds/engine_off.mp3", veh)
					toggleControl(source, "brake_reverse", false)
					setVehicleEngineState(veh, false)
					setElementData(veh, "engine", 0)
					setElementData(veh, "vehicle:radio", 0)
					setVehicleOverrideLights(veh, 1)
					setElementData(veh, "lights", 0)
				end

				spamTimers_engine[source] = setTimer(function() end, 3000, 1)
			end
		end
	end
end
addEvent("toggleEngine", true)
addEventHandler("toggleEngine", root, toggleEngine)
addCommandHandler("engine", toggleEngine)

local spamTimersVeh = {}

function toggleLock(source, key, keystate)
	local veh = getPedOccupiedVehicle(source)
	local inVehicle = getElementData(source, "realinvehicle")

	if isTimer(spamTimersVeh[source]) then
		return
	end

	if (veh) and (inVehicle==1) then
		triggerEvent("lockUnlockInsideVehicle", source, veh)
	elseif not veh then
		if getElementDimension(source) >= 19000 then
			local vehicle = exports.rl_pool:getElement("vehicle", getElementDimension(source) - 20000)
			if vehicle and exports["rl_vehicle-interiors"]:isNearExit(source, vehicle) then
				local model = getElementModel(vehicle)
				local owner = getElementData(vehicle, "owner")
				local dbid = getElementData(vehicle, "dbid")
				if (getElementData(vehicle, "Impounded") or 0) == 0 then
					local locked = isVehicleLocked(vehicle)
					if (locked) then
						triggerClientEvent(root, "playVehicleSound", root, "public/sounds/unlock.mp3", vehicle)
						setVehicleLocked(vehicle, false)
						triggerEvent("sendAme", source, "sol/sağ tarafına döner, tuşa basarak aracın kilidini açar.")
					else
						triggerClientEvent(root, "playVehicleSound", root, "public/sounds/lock.mp3", vehicle)
						setVehicleLocked(vehicle, true)
						triggerEvent("sendAme", source, "sol/sağ tarafına döner, tuşa basarak aracı kilitler.")
					end
				else
					outputChatBox("[!]#FFFFFF Çekilmiş araçları kilitleyemezsiniz.", source, 255, 0, 0, true)
					playSoundFrontEnd(source, 4)
				end
				return
			end
		end

		local interiorFound, interiorDistance = exports.rl_interior:lockUnlockHouseEvent(source, true)

		local x, y, z = getElementPosition(source)
		local nearbyVehicles = exports.rl_global:getNearbyElements(source, "vehicle", 30)

		local found = nil
		local shortest = 31
		for i, veh in ipairs(nearbyVehicles) do
			local dbid = tonumber(getElementData(veh, "dbid"))
			local distanceToVehicle = getDistanceBetweenPoints3D(x, y, z, getElementPosition(veh))
			if shortest > distanceToVehicle and (exports.rl_global:isAdminOnDuty(source) or exports.rl_global:hasItem(source, 3, dbid) or (getElementData(source, "faction") > 0 and getElementData(source, "faction") == getElementData(veh, "faction"))) then
				shortest = distanceToVehicle
				found = veh
			end
		end

		if (interiorFound and found) then
			if shortest < interiorDistance then
				triggerEvent("lockUnlockOutsideVehicle", source, found)
			else
				triggerEvent("lockUnlockHouse", source)
			end
		elseif found then
			triggerEvent("lockUnlockOutsideVehicle", source, found)
		elseif interiorFound then
			triggerEvent("lockUnlockHouse", source)
		end

		spamTimersVeh[source] = setTimer(function() end, 1500, 1)
	end
end
addCommandHandler("lock", toggleLock, true)
addEvent("togLockVehicle", true)
addEventHandler("togLockVehicle", root, toggleLock)

function checkLock(thePlayer, seat, jacked)
	local locked = isVehicleLocked(source)

	if (locked) and not (jacked) then
		cancelEvent()
		outputChatBox("[!]#FFFFFF Aracın kapıları kilitli.", thePlayer, 255, 0, 0, true)
		playSoundFrontEnd(thePlayer, 4)
	end
end
addEventHandler("onVehicleStartExit", root, checkLock)

function toggleLights(source, key, keystate)
	local veh = getPedOccupiedVehicle(source)
	local inVehicle = getElementData(source, "realinvehicle")

	if (veh) and (inVehicle==1) then
		local model = getElementModel(veh)
		if not (lightlessVehicle[model]) then
			local lights = getVehicleOverrideLights(veh)
			local seat = getPedOccupiedVehicleSeat(source)

			if (seat==0) then
				if (lights~=2) then
					setVehicleOverrideLights(veh, 2)
					setElementData(veh, "lights", 1, true)
					local trailer = getVehicleTowedByVehicle(veh)
					if trailer then
						setVehicleOverrideLights(trailer, 2)
					end
				elseif (lights~=1) then
					setVehicleOverrideLights(veh, 1)
					setElementData(veh, "lights", 0, true)
					local trailer = getVehicleTowedByVehicle(veh)
					if trailer then
						setVehicleOverrideLights(trailer, 1)
					end
				end
			end
		end
	end
end
addCommandHandler("lights", toggleLights, true)

addEvent("togLightsVehicle", true)
addEventHandler("togLightsVehicle", root, function()
	toggleLights(client)
end)

function setRealInVehicle(thePlayer)
	if isVehicleLocked(source) then
		setElementData(thePlayer, "realinvehicle", 0)
		removePedFromVehicle(thePlayer)
		setVehicleLocked(source, true)
	else
		local brand = getElementData(source, "brand") or "?"
		local model = getElementData(source, "model") or "?"
		local year = getElementData(source, "year") or "?"
		setElementData(thePlayer, "realinvehicle", 1)

		local owner = getElementData(source, "owner") or -1
		local faction = getElementData(source, "faction") or -1
		local carName = getVehicleName(source)

		if (owner < 0) and (faction == -1) then
			if brand ~= "?" then
				outputChatBox("(( Bu " .. year .. " " .. brand .. " " .. model .. " bir sivil araçtır. ))", thePlayer, 255, 194, 14)
			else
				outputChatBox("(( Bu " .. carName .. " bir mülki araçtır. ))", thePlayer, 255, 194, 14)
			end
		elseif (faction == -1) and (owner > 0) then
			local ownerName = exports.rl_cache:getCharacterName(owner)
			if ownerName then
				if brand then
					outputChatBox(">> Araç Sahibi: " .. ownerName .. " / Model: " .. year .. " " .. brand .. " " .. model, thePlayer, 255, 194, 14)
					outputChatBox(">> Sistem Fiyatı: $" .. exports.rl_global:formatMoney((getElementData(source, "carshop:cost") or 0)) .. " / Plaka: " .. (getElementData(source, "plate") or "?"), thePlayer, 255, 194, 14)
					outputChatBox(">> Araç Cezası: $" .. exports.rl_global:formatMoney((getElementData(source, "punishment") or 0)), thePlayer, 255, 194, 14)
				end
			end
		end
	end
end
addEventHandler("onVehicleEnter", root, setRealInVehicle)

function setRealNotInVehicle(thePlayer)
	local locked = isVehicleLocked(source)

	if not (locked) then
		if (thePlayer) then
			setElementData(thePlayer, "realinvehicle", 0, false)
		end
	end
end
addEventHandler("onVehicleStartExit", root, setRealNotInVehicle)

function removeFromFactionVehicle(thePlayer)
	local brand = getElementData(source, "brand") or "?"
	local model = getElementData(source, "model") or "?"
	local year = getElementData(source, "year") or "?"

	local faction = tonumber(getElementData(source, "faction"))

	if (faction ~= -1) then
		local seat = getPedOccupiedVehicleSeat(thePlayer)
		local factionName = "?"
		for key, value in ipairs(exports.rl_pool:getPoolElementsByType("team")) do
			local id = tonumber(getElementData(value, "id"))
			if (id == faction) then
				factionName = getTeamName(value)
				break
			end
		end
		if (seat == 0) then
			if brand then
				outputChatBox(">> Araç Sahibi: " .. factionName .. " / Model: " .. year .. " " .. brand .. " " .. model, thePlayer, 255, 194, 14)
				outputChatBox(">> Sistem Fiyatı: $" .. exports.rl_global:formatMoney((getElementData(source, "carshop:cost") or 0)) .. " / Plaka: " .. (getElementData(source, "plate") or "?"), thePlayer, 255, 194, 14)
				outputChatBox(">> Araç Cezası: $" .. exports.rl_global:formatMoney((getElementData(source, "punishment") or 0)), thePlayer, 255, 194, 14)
			end
		end
	end

	local Impounded = getElementData(source, "Impounded")
	if (Impounded and Impounded > 0) then
		setElementData(source, "enginebroke", 1)
		setVehicleDamageProof(source, true)
		setVehicleEngineState(source, false)
	end
	
	local vjob = tonumber(getElementData(source, "job")) or -1
	local job = getElementData(thePlayer, "job") or -1
	local seat = getPedOccupiedVehicleSeat(thePlayer)

	if (vjob > 0) and (seat == 0) then
		for key, value in pairs(exports['rl_items']:getMasks()) do
			if getElementData(thePlayer, value[1]) then
				exports.rl_global:sendLocalMeAction(thePlayer, value[3] .. ".")
				setElementData(thePlayer, value[1], false)
			end
		end
	end
end
addEventHandler("onVehicleEnter", root, removeFromFactionVehicle)

function doBreakdown()
	if exports.rl_global:hasItem(source, 74) then
		while exports.rl_global:hasItem(source, 74) do
			exports.rl_global:takeItem(source, 74)
		end

		blowVehicle(source)
	else
		local health = getElementHealth(source)
		local broke = getElementData(source, "enginebroke")

		if (health <= 350) and (broke == 0 or broke == false) then
			setElementHealth(source, 300)
			setVehicleDamageProof(source, true)
			setVehicleEngineState(source, false)
			setElementData(source, "enginebroke", 1)
			setElementData(source, "engine", 0)

			local player = getVehicleOccupant(source)
			if player then
				toggleControl(player, "brake_reverse", false)
			end
		end
	end
end
addEventHandler("onVehicleDamage", root, doBreakdown)

function sellVehicle(thePlayer, commandName, targetPlayerName)
    if isPedInVehicle(thePlayer) then
        if not targetPlayerName then
            outputChatBox("KULLANIM: /" .. commandName .. " [Karakter Adı / ID]", thePlayer, 255, 194, 14)
        else
            local targetPlayer, targetPlayerName = exports.rl_global:findPlayerByPartialNick(thePlayer, targetPlayerName)
            if targetPlayer and getElementData(targetPlayer, "dbid") then
                local px, py, pz = getElementPosition(thePlayer)
                local tx, ty, tz = getElementPosition(targetPlayer)
                if getDistanceBetweenPoints3D(px, py, pz, tx, ty, tz) < 20 then
                    local theVehicle = getPedOccupiedVehicle(thePlayer)
                    if theVehicle then
                        local vehicleID = getElementData(theVehicle, "dbid")
                        if getElementData(theVehicle, "owner") == getElementData(thePlayer, "dbid") or exports.rl_integration:isPlayerDeveloper(thePlayer) then
                            if getElementData(targetPlayer, "dbid") ~= getElementData(theVehicle, "owner") then
                                if exports.rl_global:hasSpaceForItem(targetPlayer, 3, vehicleID) then
                                    if exports.rl_global:canPlayerBuyVehicle(targetPlayer) then
                                        local query = dbExec(mysql:getConnection(), "UPDATE vehicles SET owner = '" .. getElementData(targetPlayer, "dbid") .. "', lastUsed=NOW() WHERE id='" .. vehicleID .. "'")
                                        if query then
                                            setElementData(theVehicle, "owner", getElementData(targetPlayer, "dbid"), true)
                                            setElementData(theVehicle, "owner_last_login", exports.rl_datetime:now(), true)
                                            setElementData(theVehicle, "lastused", exports.rl_datetime:now(), true)

                                            exports.rl_global:takeItem(thePlayer, 3, vehicleID)

                                            if not exports.rl_global:hasItem(targetPlayer, 3, vehicleID) then
                                                exports.rl_global:giveItem(targetPlayer, 3, vehicleID)
                                            end

                                            outputChatBox("[!]#FFFFFF Başarıyla " .. getVehicleName(theVehicle) .. " markalı araç " .. targetPlayerName .. " isimli oyuncuya satdınız.", thePlayer, 0, 255, 0, true)
                                            outputChatBox("[!]#FFFFFF " .. getPlayerName(thePlayer):gsub("_", " ") .. " isimli oyuncu size " .. getVehicleName(theVehicle) .. " markalı aracı satdı.", targetPlayer, 0, 255, 0, true)

                                            local adminID = getElementData(thePlayer, "account_id")
                                            local addLog = dbExec(mysql:getConnection(), "INSERT INTO `vehicle_logs` (`vehID`, `action`, `actor`) VALUES ('" .. tostring(vehicleID) .. "', '" .. commandName .. " to " .. getPlayerName(targetPlayer) .. "', '" .. adminID .. "')")
                                            if not addLog then
                                                outputDebugString("Failed to add vehicle logs.")
                                            end
                                        else
                                            outputChatBox("[!]#FFFFFF Bir sorun oluştu.", thePlayer, 255, 0, 0, true)
                                        end
                                    else
                                        outputChatBox("[!]#FFFFFF " .. targetPlayerName .. " isimli oyuncunun çok aracı var.", thePlayer, 255, 0, 0, true)
                                    end
                                else
                                    outputChatBox("[!]#FFFFFF " .. targetPlayerName .. " isimli oyuncunun envanteri dolu.", thePlayer, 255, 0, 0, true)
                                end
                            else
                                outputChatBox("[!]#FFFFFF Kendinize kendi aracınızı satamazsınız.", thePlayer, 255, 0, 0, true)
                            end
                        else
                            outputChatBox("[!]#FFFFFF Bu araç sizin değil.", thePlayer, 255, 0, 0, true)
                        end
                    else
                        outputChatBox("[!]#FFFFFF Bir araçda olmalısınız.", thePlayer, 255, 0, 0, true)
                    end
                else
                    outputChatBox("[!]#FFFFFF " .. targetPlayerName .. " isimli oyuncudan çok uzaktasın.", thePlayer, 255, 0, 0, true)
                end
            end
        end
    end
end
addCommandHandler("sell", sellVehicle, false, false)
addCommandHandler("aracsat", sellVehicle, false, false)
addEvent("sellVehicle", true)
addEventHandler("sellVehicle", resourceRoot, sellVehicle)

function lockUnlockInside(vehicle)
	local model = getElementModel(vehicle)
	local owner = getElementData(vehicle, "owner")
	local dbid = getElementData(vehicle, "dbid")
	
	if (getElementData(vehicle, "Impounded") or 0) == 0 and not getElementData(vehicle, "robbery_vehicle") then
		if not locklessVehicle[model] or exports.rl_global:hasItem(source, 3, dbid) then
			if (getElementData(source, "realinvehicle") == 1) then
				local locked = isVehicleLocked(vehicle)
				local seat = getPedOccupiedVehicleSeat(source)
				if seat == 0 or exports.rl_global:hasItem(source, 3, dbid) then
					if (locked) then
						triggerClientEvent(root, "playVehicleSound", root, "public/sounds/unlock.mp3", vehicle)
						setVehicleLocked(vehicle, false)
						triggerEvent("sendAme", source, "sol/sağ tarafına döner, tuşa basarak aracın kilidini açar.")
					else
						triggerClientEvent(root, "playVehicleSound", root, "public/sounds/lock.mp3", vehicle)
						setVehicleLocked(vehicle, true)
						triggerEvent("sendAme", source, "sol/sağ tarafına döner, tuşa basarak aracı kilitler.")
					end
					spamTimersVeh[source] = setTimer(function() end, 1000, 1)
				end
			end
		end
	else
		outputChatBox("[!]#FFFFFF Çekilmiş araçları kilitleyemezsiniz.", source, 255, 0, 0, true)
		playSoundFrontEnd(source, 4)
	end
end
addEvent("lockUnlockInsideVehicle", true)
addEventHandler("lockUnlockInsideVehicle", root, lockUnlockInside)

local storeTimers = {}

function lockUnlockOutside(vehicle)
	if (not source or exports.rl_integration:isPlayerTrialAdmin(source)) or (getElementData(vehicle, "Impounded") or 0) == 0 and not getElementData(vehicle, "robbery_vehicle") then
		local dbid = getElementData(vehicle, "dbid")

		if (isVehicleLocked(vehicle)) then
			triggerClientEvent(root, "playVehicleSound", root, "public/sounds/unlock.mp3", vehicle)
			setVehicleLocked(vehicle, false)
			triggerEvent("sendAme", source, "sol/sağ tarafına döner, tuşa basarak aracın kilidini açar.")
		else
			triggerClientEvent(root, "playVehicleSound", root, "public/sounds/lock.mp3", vehicle)
			setVehicleLocked(vehicle, true)
			triggerEvent("sendAme", source, "sol/sağ tarafına döner, tuşa basarak aracı kilitler.")
		end

		if (storeTimers[vehicle] == nil) or not (isTimer(storeTimers[vehicle])) then
			storeTimers[vehicle] = setTimer(storeVehicleLockState, 180000, 1, vehicle, dbid)
		end
	end
end
addEvent("lockUnlockOutsideVehicle", true)
addEventHandler("lockUnlockOutsideVehicle", root, lockUnlockOutside)

function storeVehicleLockState(vehicle, dbid)
	if (isElement(vehicle)) then
		local newdbid = getElementData(vehicle, "dbid")
		if tonumber(newdbid) > 0 then
			local locked = isVehicleLocked(vehicle)

			local state = 0
			if (locked) then
				state = 1
			end

			local query = dbExec(mysql:getConnection(), "UPDATE vehicles SET locked='" .. (tostring(state)) .. "' WHERE id='" .. (tostring(newdbid)) .. "' LIMIT 1")
		end
		storeTimers[vehicle] = nil
	end
end

function fillFuelTank(veh, fuel)
	if client ~= source then
		return
	end

	local currFuel = getElementData(veh, "fuel")
	local engine = getElementData(veh, "engine")
	local max = exports["rl_vehicle-fuel"]:getMaxFuel(getElementModel(veh))
	if (math.ceil(currFuel) == max) then
		outputChatBox("[!]#FFFFFF Bu araç benzinle dolu.", source, 255, 0, 0, true)
		playSoundFrontEnd(source, 4)
	elseif (fuel == 0) then
		outputChatBox("[!]#FFFFFF Bu benzin bidonu boş.", source, 255, 0, 0, true)
		playSoundFrontEnd(source, 4)
	elseif (engine == 1) then
		outputChatBox("[!]#FFFFFF Çalışan araçlara benzin dolduramazsınız, lütfen önce motoru durdurun.", source, 255, 0, 0, true)
		playSoundFrontEnd(source, 4)
	else
		local fuelAdded = fuel

		if (fuelAdded + currFuel > max) then
			fuelAdded = max - currFuel
		end

		outputChatBox("[!]#FFFFFF Benzin bidonundan aracınıza " .. math.ceil(fuelAdded) .. " litr benzin doldurdunuz.", source, 0, 255, 0, true)
		triggerEvent("sendAme", source, "aracına küçük bir benzin bidonunu doldurur.")
		exports.rl_global:takeItem(source, 57, fuel)
		exports.rl_global:giveItem(source, 57, math.ceil(fuel - fuelAdded))

		setElementData(veh, "fuel", currFuel + fuelAdded)
		triggerClientEvent(thePlayer, "syncFuel", veh, currFuel + fuelAdded)
	end
end
addEvent("fillFuelTankVehicle", true)
addEventHandler("fillFuelTankVehicle", root, fillFuelTank)

function removeNOS(theVehicle)
	removeVehicleUpgrade(theVehicle, getVehicleUpgradeOnSlot(theVehicle, 8))
	triggerEvent("sendAme", source, "NOS-u " .. getVehicleName(theVehicle) .. " markalı araçtan çıkarır.")
	exports.rl_save:saveVehicleMods(theVehicle)
end
addEvent("removeNOS", true)
addEventHandler("removeNOS", root, removeNOS)

local destroyTimers = {}

function checkVehpos(veh, dbid)
	local requires = getElementData(veh, "requires.vehpos")

	if (requires) then
		if (requires==1) then
			local id = tonumber(getElementData(veh, "dbid"))

			if (id==dbid) then
				destroyElement(veh)
				local query = dbExec(mysql:getConnection(), "DELETE FROM vehicles WHERE id='" .. (id) .. "' LIMIT 1")

				call(getResourceFromName("rl_items"), "clearItems", veh)
				call(getResourceFromName("rl_items"), "deleteAll", 3, id)
			end
		end
	end
end

function setVehiclePosition(thePlayer, commandName)
	local veh = getPedOccupiedVehicle(thePlayer)
	if not veh or getElementData(thePlayer, "realinvehicle") == 0 then
		outputChatBox("[!]#FFFFFF Araç içerisinde değilsiniz.", thePlayer, 255, 0, 0, true)
		playSoundFrontEnd(thePlayer, 4)
	else
		local playerid = getElementData(thePlayer, "dbid")
		local playerfl = getElementData(thePlayer, "factionleader")
		local playerfid = getElementData(thePlayer, "faction")
		local owner = getElementData(veh, "owner")
		local dbid = getElementData(veh, "dbid")
		local carfid = getElementData(veh, "faction")
		local x, y, z = getElementPosition(veh)
		if (owner==playerid) or (exports.rl_global:hasItem(thePlayer, 3, dbid)) or (exports.rl_integration:isPlayerTrialAdmin(thePlayer)) then
			if (dbid<0) then
				outputChatBox("[!]#FFFFFF Bir sorun oluştu.", thePlayer, 255, 0, 0, true)
                playSoundFrontEnd(thePlayer, 4)
			else
				setElementData(veh, "requires.vehpos", nil)
				local rx, ry, rz = getVehicleRotation(veh)

				local interior = getElementInterior(thePlayer)
				local dimension = getElementDimension(thePlayer)

				local query = dbExec(mysql:getConnection(), "UPDATE vehicles SET x='" .. (x) .. "', y='" .. (y) .."', z='" .. (z) .. "', rotx='" .. (rx) .. "', roty='" .. (ry) .. "', rotz='" .. (rz) .. "', currx='" .. (x) .. "', curry='" .. (y) .. "', currz='" .. (z) .. "', currrx='" .. (rx) .. "', currry='" .. (ry) .. "', currrz='" .. (rz) .. "', interior='" .. (interior) .. "', currinterior='" .. (interior) .. "', dimension='" .. (dimension) .. "', currdimension='" .. (dimension) .. "' WHERE id='" .. (dbid) .. "'")
				setVehicleRespawnPosition(veh, x, y, z, rx, ry, rz)
				setElementData(veh, "respawnposition", {x, y, z, rx, ry, rz})
				setElementData(veh, "interior", interior)
				setElementData(veh, "dimension", dimension)
				outputChatBox("[!]#FFFFFF Aracınızı başarıyla park ettiniz.", thePlayer, 0, 255, 0, true)

				local adminID = getElementData(thePlayer, "account_id")
				local addLog = dbExec(mysql:getConnection(), "INSERT INTO `vehicle_logs` (`vehID`, `action`, `actor`) VALUES ('" .. tostring(dbid) .. "', '" .. commandName .. "', '" .. adminID .. "')")
				if not addLog then
					outputDebugString("Failed to add vehicle logs.")
				end

				for key, value in ipairs(destroyTimers) do
					if (tonumber(destroyTimers[key][2]) == dbid) then
						local timer = destroyTimers[key][1]

						if (isTimer(timer)) then
							killTimer(timer)
							table.remove(destroyTimers, key)
						end
					end
				end

				if (getElementData(veh, "Impounded") or 0) > 0 then
					local owner = getPlayerFromName(exports.rl_cache:getCharacterName(getElementData(veh, "owner")))
					if isElement(owner) and exports.rl_global:hasItem(owner, 2) then
						outputChatBox("((SFT&R)) #5555 [SMS]: Your " .. getVehicleName(veh) .. " has been impounded. Head over to the impound to release it.", owner, 120, 255, 80)
					end
				end
			end
		end
	end
end
addCommandHandler("vehpos", setVehiclePosition, false, false)
addCommandHandler("park", setVehiclePosition, false, false)

function setVehiclePosition2(thePlayer, commandName, vehicleID)
	if exports.rl_integration:isPlayerTrialAdmin(thePlayer) then
		local vehicleID = tonumber(vehicleID)
		if not vehicleID or vehicleID < 0 then
			outputChatBox("KULLANIM: /" .. commandName .. " [Araç ID]", thePlayer, 255, 194, 14)
		else
			local veh = exports.rl_pool:getElement("vehicle", vehicleID)
			if veh then
				setElementData(veh, "requires.vehpos")
				local x, y, z = getElementPosition(veh)
				local rx, ry, rz = getVehicleRotation(veh)

				local interior = getElementInterior(thePlayer)
				local dimension = getElementDimension(thePlayer)

				local query = dbExec(mysql:getConnection(), "UPDATE vehicles SET x='" .. (x) .. "', y='" .. (y) .."', z='" .. (z) .. "', rotx='" .. (rx) .. "', roty='" .. (ry) .. "', rotz='" .. (rz) .. "', currx='" .. (x) .. "', curry='" .. (y) .. "', currz='" .. (z) .. "', currrx='" .. (rx) .. "', currry='" .. (ry) .. "', currrz='" .. (rz) .. "', interior='" .. (interior) .. "', currinterior='" .. (interior) .. "', dimension='" .. (dimension) .. "', currdimension='" .. (dimension) .. "' WHERE id='" .. (vehicleID) .. "'")
				setVehicleRespawnPosition(veh, x, y, z, rx, ry, rz)
				setElementData(veh, "respawnposition", {x, y, z, rx, ry, rz})
				setElementData(veh, "interior", interior)
				setElementData(veh, "dimension", dimension)
				outputChatBox("[!]#FFFFFF Aracınızı başarıyla park ettiniz.", thePlayer, 0, 255, 0, true)
				
				for key, value in ipairs(destroyTimers) do
					if (tonumber(destroyTimers[key][2]) == vehicleID) then
						local timer = destroyTimers[key][1]

						if (isTimer(timer)) then
							killTimer(timer)
							table.remove(destroyTimers, key)
						end
					end
				end

				if (getElementData(veh, "Impounded") or 0) > 0 then
					local owner = getPlayerFromName(exports.rl_cache:getCharacterName(getElementData(veh, "owner")))
					if isElement(owner) and exports.rl_global:hasItem(owner, 2) then
						outputChatBox("((SFT&R)) #5555 [SMS]: Your " .. getVehicleName(veh) .. " has been impounded. Head over to the impound to release it.", owner, 120, 255, 80)
					end
				end
			else
				outputChatBox("[!]#FFFFFF Bir sorun oluştu.", thePlayer, 255, 0, 0, true)
                playSoundFrontEnd(thePlayer, 4)
			end
		end
	end
end
addCommandHandler("avehpos", setVehiclePosition2, false, false)
addCommandHandler("apark", setVehiclePosition2, false, false)

function setVehiclePosition3(veh)
	local playerid = getElementData(source, "dbid")
	local owner = getElementData(veh, "owner")
	local dbid = getElementData(veh, "dbid")
	local x, y, z = getElementPosition(veh)
	if (owner==playerid) or (exports.rl_global:hasItem(source, 3, dbid)) or (exports.rl_integration:isPlayerTrialAdmin(source)) then
		if (dbid<0) then
			outputChatBox("[!]#FFFFFF Bir sorun oluştu.", source, 255, 0, 0, true)
            playSoundFrontEnd(source, 4)
		else
			setElementData(veh, "requires.vehpos")
			local rx, ry, rz = getVehicleRotation(veh)

			local interior = getElementInterior(source)
			local dimension = getElementDimension(source)

			local query = dbExec(mysql:getConnection(), "UPDATE vehicles SET x='" .. (x) .. "', y='" .. (y) .."', z='" .. (z) .. "', rotx='" .. (rx) .. "', roty='" .. (ry) .. "', rotz='" .. (rz) .. "', currx='" .. (x) .. "', curry='" .. (y) .. "', currz='" .. (z) .. "', currrx='" .. (rx) .. "', currry='" .. (ry) .. "', currrz='" .. (rz) .. "', interior='" .. (interior) .. "', currinterior='" .. (interior) .. "', dimension='" .. (dimension) .. "', currdimension='" .. (dimension) .. "' WHERE id='" .. (dbid) .. "'")
			setVehicleRespawnPosition(veh, x, y, z, rx, ry, rz)
			setElementData(veh, "respawnposition", {x, y, z, rx, ry, rz})
			setElementData(veh, "interior", interior)
			setElementData(veh, "dimension", dimension)
			outputChatBox("[!]#FFFFFF Aracınızı başarıyla park ettiniz.", thePlayer, 0, 255, 0, true)
			
			for key, value in ipairs(destroyTimers) do
				if (tonumber(destroyTimers[key][2]) == dbid) then
					local timer = destroyTimers[key][1]

					if (isTimer(timer)) then
						killTimer(timer)
						table.remove(destroyTimers, key)
					end
				end
			end

			if (getElementData(veh, "Impounded") or 0) > 0 then
				local owner = getPlayerFromName(exports.rl_cache:getCharacterName(getElementData(veh, "owner")))
				if isElement(owner) and exports.rl_global:hasItem(owner, 2) then
					outputChatBox("((SFT&R)) #5555 [SMS]: Your " .. getVehicleName(veh) .. " has been impounded. Head over to the impound to release it.", owner, 120, 255, 80)
				end
			end
		end
	else
		outputChatBox("You can't park this vehicle.", source, 255, 0, 0)
	end
end
addEvent("parkVehicle", true)
addEventHandler("parkVehicle", root, setVehiclePosition3)

function setVehiclePosition4(thePlayer, commandName)
	local veh = getPedOccupiedVehicle(thePlayer)
	if not veh or getElementData(thePlayer, "realinvehicle") == 0 then
		outputChatBox("You are not in a vehicle.", thePlayer, 255, 0, 0)
	else
		local playerid = getElementData(thePlayer, "dbid")
		local playerfl = getElementData(thePlayer, "factionleader")
		local playerfid = getElementData(thePlayer, "faction")
		local owner = getElementData(veh, "owner")
		local dbid = getElementData(veh, "dbid")
		local carfid = getElementData(veh, "faction")
		if (playerfl == 1) and (playerfid == carfid) then
			setElementData(veh, "requires.vehpos", nil)

			local x, y, z = getElementPosition(veh)
			local rx, ry, rz = getVehicleRotation(veh)

			local interior = getElementInterior(thePlayer)
			local dimension = getElementDimension(thePlayer)

			local query = dbExec(mysql:getConnection(), "UPDATE vehicles SET x='" .. (x) .. "', y='" .. (y) .."', z='" .. (z) .. "', rotx='" .. (rx) .. "', roty='" .. (ry) .. "', rotz='" .. (rz) .. "', currx='" .. (x) .. "', curry='" .. (y) .. "', currz='" .. (z) .. "', currrx='" .. (rx) .. "', currry='" .. (ry) .. "', currrz='" .. (rz) .. "', interior='" .. (interior) .. "', currinterior='" .. (interior) .. "', dimension='" .. (dimension) .. "', currdimension='" .. (dimension) .. "' WHERE id='" .. (dbid) .. "'")
			setVehicleRespawnPosition(veh, x, y, z, rx, ry, rz)
			setElementData(veh, "respawnposition", {x, y, z, rx, ry, rz})
			setElementData(veh, "interior", interior)
			setElementData(veh, "dimension", dimension)
			outputChatBox("[!]#FFFFFF Aracınızı başarıyla park ettiniz.", thePlayer, 0, 255, 0, true)

			local adminID = getElementData(thePlayer, "account_id")
			local addLog = dbExec(mysql:getConnection(), "INSERT INTO `vehicle_logs` (`vehID`, `action`, `actor`) VALUES ('" .. tostring(dbid) .. "', '" .. commandName .. "', '" .. adminID .. "')")
			if not addLog then
				outputDebugString("Failed to add vehicle logs.")
			end

			for key, value in ipairs(destroyTimers) do
				if (tonumber(destroyTimers[key][2]) == dbid) then
					local timer = destroyTimers[key][1]

					if (isTimer(timer)) then
						killTimer(timer)
						table.remove(destroyTimers, key)
					end
				end
			end

			if (getElementData(veh, "Impounded") or 0) > 0 then
				local owner = getPlayerFromName(exports.rl_cache:getCharacterName(getElementData(veh, "owner")))
				if isElement(owner) and exports.rl_global:hasItem(owner, 2) then
					outputChatBox("((SFT&R)) #5555 [SMS]: Your " .. getVehicleName(veh) .. " has been impounded. Head over to the impound to release it.", owner, 120, 255, 80)
				end
			end
		end
	end
end
addCommandHandler("fvehpos", setVehiclePosition4, false, false)
addCommandHandler("fpark", setVehiclePosition4, false, false)

function quitPlayer (quitReason)
	if (quitReason == "Timed out") then
		if (isPedInVehicle(source)) then
			local vehicleSeat = getPedOccupiedVehicleSeat(source)
			if (vehicleSeat == 0) then
				local theVehicle = getPedOccupiedVehicle(source)
				local dbid = tonumber(getElementData(theVehicle, "dbid"))
				
				if exports.rl_global:hasItem(theVehicle, 3, dbid) then
					exports.rl_global:takeItem(theVehicle, 3, dbid)
					exports.rl_global:giveItem(source, 3, dbid)
				end
				
				local passenger1 = getVehicleOccupant(theVehicle , 1)
				local passenger2 = getVehicleOccupant(theVehicle , 2)
				local passenger3 = getVehicleOccupant(theVehicle , 3)
				if not (passenger1) and not (passenger2) and not (passenger3) then
					local vehicleFaction = tonumber(getElementData(theVehicle, "faction"))
					local playerFaction = tonumber(getElementData(source, "faction"))
					if exports.rl_global:hasItem(source, 3, dbid) or ((playerFaction == vehicleFaction) and (vehicleFaction ~= -1)) then
						if not isVehicleLocked(theVehicle) then
							lockUnlockOutside(theVehicle)
						end
						local engine = getElementData(theVehicle, "engine")
						if engine == 1 then
							setVehicleEngineState(theVehicle, false)
							setElementData(theVehicle, "engine", 0)
						end
					end
					setElementData(theVehicle, "handbrake", 1)
					setElementVelocity(theVehicle, 0, 0, 0)
					setElementFrozen(theVehicle, true)
				end
			end
		end
	end
end
addEventHandler("onPlayerQuit",root, quitPlayer)

function detachVehicle(thePlayer)
	if isPedInVehicle(thePlayer) and getPedOccupiedVehicleSeat(thePlayer) == 0 then
		local veh = getPedOccupiedVehicle(thePlayer)
		if getVehicleTowedByVehicle(veh) then
			detachTrailerFromVehicle(veh)
			outputChatBox("The trailer was detached.", thePlayer, 0, 255, 0)
		else
			outputChatBox("There is no trailer...", thePlayer, 255, 0, 0)
		end
	end
end
addCommandHandler("detach", detachVehicle)

safeTable = {}

function addSafe(dbid, x, y, z, rz, interior)
	local tempobject = createObject(2332, x, y, z, 0, 0, rz)
	setElementInterior(tempobject, interior)
	setElementDimension(tempobject, dbid + 20000)
	safeTable[dbid] = tempobject
end

function removeSafe(dbid)
	if safeTable[dbid] then
		destroyElement(safeTable[dbid])
		safeTable[dbid] = nil
	end
end

function getSafe(dbid)
	return safeTable[dbid]
end