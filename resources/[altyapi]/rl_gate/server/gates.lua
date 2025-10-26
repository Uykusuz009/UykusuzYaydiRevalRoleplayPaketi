mysql = exports.rl_mysql
gates = {}

function newGate(thePlayer, commandName, itemID)
	if exports.rl_integration:isPlayerAdmin1(thePlayer) then
		if not itemID or not tonumber(itemID) then
			outputChatBox("KULLANIM: /" .. commandName .. " <itemID>", thePlayer)
			return
		end
		local playerX, playerY, playerZ = getElementPosition(thePlayer)
		
		local tempObject = createObject(itemID, playerX, playerY, playerZ, 0, 0, 0)
		if tempObject then
			local tempTable = {}
			tempTable["startPosition"] = { playerX, playerY, playerZ, 0, 0, 0 }
			tempTable["endPosition"] = { playerX, playerY, playerZ, 0, 0, 0 }
			tempTable["state"] = false
			tempTable["timer"] = false
			tempTable["type"] = 1
			tempTable["autocloseTime"] = -1
			tempTable["movementTime"] = 3500
			tempTable["gateSecurityParameters"] = ""
			setElementData(tempObject, "gate:parameters", tempTable, false)
			setElementData(tempObject, "gate:id", -1, false)
			setElementData(tempObject, "gate:edit", true, false)
			table.insert(gates, tempObject)
			triggerClientEvent(thePlayer, "gates:startedit", thePlayer, tempObject, tempTable, -1)
		else
			outputChatBox("Failed to spawn object", thePlayer, 255, 0,0)
		end
	end
end
addCommandHandler("newgate", newGate)

function cancelGateEdit()
	if source then
		if isElement(source) then
			local dbid = getElementData(source, "gate:id")
			if dbid and dbid == -1 then
				destroyElement(source)
			end
			outputChatBox("Edit cancelled", client, 255, 0,0)
		end
	end
end
addEvent("gates:canceledit", true)
addEventHandler("gates:canceledit", root, cancelGateEdit)

function startGateSystem(res)
    dbQuery(function(qh)
        local result = dbPoll(qh, 0)
        if result then
            for _, row in ipairs(result) do
                local co = coroutine.create(loadOneGate)
                coroutine.resume(co, tonumber(row.id), false)
            end
        end
    end, mysql:getConnection(), "SELECT `id` FROM `gates` ORDER BY `id` ASC")
end
addEventHandler("onResourceStart", resourceRoot, startGateSystem)

function loadOneGate(gateID)
    dbQuery(function(qh)
        local result = dbPoll(qh, 0)
        if result and result[1] then
            local row = result[1]
            local tempObject = createObject(row["objectID"], row["startX"], row["startY"], row["startZ"], row["startRX"], row["startRY"], row["startRZ"])
            if tempObject then
                local tempTable = {
                    ["startPosition"] = { tonumber(row["startX"]), tonumber(row["startY"]), tonumber(row["startZ"]), tonumber(row["startRX"]), tonumber(row["startRY"]), tonumber(row["startRZ"]) },
                    ["endPosition"] = { tonumber(row["endX"]), tonumber(row["endY"]), tonumber(row["endZ"]), tonumber(row["endRX"]), tonumber(row["endRY"]), tonumber(row["endRZ"]) },
                    ["state"] = false,
                    ["timer"] = false,
                    ["type"] = tonumber(row["gateType"]),
                    ["autocloseTime"] = tonumber(row["autocloseTime"]),
                    ["movementTime"] = tonumber(row["movementTime"]),
                    ["gateSecurityParameters"] = row["gateSecurityParameters"]
                }
				
                setElementData(tempObject, "gate:parameters", tempTable, false)
                setElementData(tempObject, "gate:id", row["id"], true)
                setElementData(tempObject, "gate:edit", false, false)
                setElementData(tempObject, "gate:busy", false, false)
                setElementData(tempObject, "gate", true, true)
                
                local triggerDistance = (row["triggerDistance"] == nil) and false or tonumber(row["triggerDistance"]) or 35
                local triggerDistanceVehicle = (row["triggerDistanceVehicle"] == nil) and false or tonumber(row["triggerDistanceVehicle"]) or 35
                local gateSound = (row["sound"] == nil) and false or tostring(row["sound"])
                
                setElementData(tempObject, "gate:triggerDistance", triggerDistance, true)
                setElementData(tempObject, "gate:triggerDistanceVehicle", triggerDistanceVehicle, true)
                setElementData(tempObject, "gate:sound", gateSound, true)
                
                setElementDimension(tempObject, tonumber(row["objectDimension"]))
                setElementInterior(tempObject, tonumber(row["objectInterior"]))
                table.insert(gates, tempObject)
            end
        end
    end, mysql:getConnection(), "SELECT * FROM gates WHERE id = ?", gateID)
end

function createGate(model, x, y, z, rx, ry, rz, x2, y2, z2, rx2, ry2, rz2, int, dim, autocloseTime, movementTime, gateType, securityParameters, triggerDistance, triggerDistanceVehicle, sound)
	local tempObject = createObject(model, x, y, z, rx, ry, rz)
	if tempObject then
		local tempTable = {}
		tempTable["startPosition"] = { x, y, z, rx, ry, rz }
		tempTable["endPosition"] = { x2, y2, z2, rx2, ry2, rz2 }
		tempTable["state"] = false
		tempTable["timer"] = false
		tempTable["type"] = gateType or 1
		tempTable["autocloseTime"] = autocloseTime or -1
		tempTable["movementTime"] = movementTime or 3500
		tempTable["gateSecurityParameters"] = securityParameters or ""
		setElementData(tempObject, "gate:parameters", tempTable)
		setElementData(tempObject, "gate:id", -1, false)
		setElementData(tempObject, "gate:edit", false)
		setElementData(tempObject, "gate:busy", false)
		setElementData(tempObject, "gate", true)
		if not triggerDistance then triggerDistance = false else triggerDistance = tonumber(triggerDistance) or 35 end
		if not triggerDistanceVehicle then triggerDistanceVehicle = false else triggerDistanceVehicle = tonumber(triggerDistanceVehicle) or 35 end
		if not sound then sound = false else sound = tostring(sound) end
		setElementData(tempObject, "gate:triggerDistance", triggerDistance)
		setElementData(tempObject, "gate:triggerDistanceVehicle", triggerDistanceVehicle)
		setElementData(tempObject, "gate:sound", sound)
		setElementDimension(tempObject, dim)
		setElementInterior(tempObject, int)
		if triggerDistance then
			setElementData(tempObject, "gate.triggerdistance", triggerDistance)
		end
		if sound then
			setElementData(tempObject, "gate.sound", sound)
		end
		table.insert(gates, tempObject)
		return tempObject
	else
		return false
	end
end

function removeGate(element)
	if not isElement(element) then return end
	local position
	for k, v in ipairs(gates) do
		if (v == element) then
			position = k
			break
		end
	end
	if position then
		table.remove(gates, position)
	end
	destroyElement(element)
end