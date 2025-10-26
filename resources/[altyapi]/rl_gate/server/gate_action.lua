local affectedByGate = {}

addEvent("gate:trigger", true)
function triggerGate(password)
	if not source or not client then
		return
	end
	
	local isGate = getElementData(source, "gate")
	if not isGate then
		return
	end
	
	local playerX, playerY, playerZ = getElementPosition(client)		
	local gateX, gateY, gateZ = getElementPosition(source)		
	local reachedit = true
	
	if reachedit then
		local isGateBusy = getElementData(source, "gate:busy")
		if not (isGateBusy) then
			if (canPlayerControlGate(source, client, password)) or exports.rl_integration:isPlayerServerManager(client) then
				moveGate(source)
			else
				outputChatBox("[!]#FFFFFF Bu qapı bağlıdır.", source, 255, 0, 0, true)
				playSoundFrontEnd(source, 4)
			end
		end
	end
end
addEventHandler("gate:trigger", root, triggerGate)

function moveGate(theGate, secondtime)
	if not secondtime then
		secondtime = false
	end
	local isGateBusy = getElementData(theGate, "gate:busy")
	if not (isGateBusy) or (secondtime) then
		setElementData(theGate, "gate:busy", true, false)
		local gateParameters = getElementData(theGate, "gate:parameters")
		
		local newX, newY, newZ, offsetRX, offsetRY, offsetRZ, movementTime, autocloseTime
		
		local startPosition = gateParameters["startPosition"]
		local endPosition = gateParameters["endPosition"]
		if gateParameters["state"] then
			newX = startPosition[1]
			newY = startPosition[2]
			newZ = startPosition[3]
			offsetRX = endPosition[4] - startPosition[4] 
			offsetRY = endPosition[5] - startPosition[5] 
			offsetRZ = endPosition[6] - startPosition[6] 
			gateParameters["state"] = false
			local x, y, z = getElementPosition(theGate)
			local int = getElementInterior(theGate)
			local dim = getElementDimension(theGate)
			local gateSound = getElementData(theGate, "gate:sound")
			if gateSound then
				local sphere = createColSphere(startPosition[1], startPosition[2], startPosition[3], 100)
				local affectedPlayers = getElementsWithinColShape(sphere, "player")
				affectedByGate[theGate] = affectedPlayers
				for k,v in ipairs(affectedPlayers) do
					triggerClientEvent(root, "playGateSound", resourceRoot, theGate, false, {x, y, z, int, dim}, gateSound)
				end
			end
		else
			newX = endPosition[1]
			newY = endPosition[2]
			newZ = endPosition[3]
			offsetRX = startPosition[4] - endPosition[4] 
			offsetRY = startPosition[5] - endPosition[5] 
			offsetRZ = startPosition[6] - endPosition[6] 
			gateParameters["state"] = true
			local x, y, z = getElementPosition(theGate)
			local int = getElementInterior(theGate)
			local dim = getElementDimension(theGate)
			local gateSound = getElementData(theGate, "gate:sound")
			if gateSound then
				local sphere = createColSphere(startPosition[1], startPosition[2], startPosition[3], 100)
				local affectedPlayers = getElementsWithinColShape(sphere, "player")
				affectedByGate[theGate] = affectedPlayers
				for k,v in ipairs(affectedPlayers) do
					triggerClientEvent(root, "playGateSound", resourceRoot, theGate, true, {x, y, z, int, dim}, gateSound)
				end
			end
		end

		movementTime = gateParameters["movementTime"] * 100

		offsetRX = fixRotation(offsetRX)
		offsetRY = fixRotation(offsetRY)
		offsetRZ = fixRotation(offsetRZ)
		
		moveObject(theGate, movementTime, newX, newY, newZ, offsetRX, offsetRY, offsetRZ)
		
		if (not secondtime) and (gateParameters["autocloseTime"] ~= 0) then
			autocloseTime = tonumber(gateParameters["autocloseTime"])*100
			gateParameters["timer"] = setTimer(moveGate, movementTime+autocloseTime, 1, theGate, true)
			gateParameters["timerSound"] = setTimer(resetGateSound, movementTime, 1, theGate)
		else
			setTimer(resetBusyState, movementTime, 1, theGate)
		end
		setElementData(theGate, "gate:parameters", gateParameters, false)
	end
end

function fixRotation(value)
	local invert = true
	if value < 0 then
		while value < -360 do
			value = value + 360
		end
		if value < -180 then
			value = value + 180
			value = value - value - value
		end
	else
		while value > 360 do
			value = value - 360
		end
		if value > 180 then
			value = value - 180
			value = value - value - value
		end
	end
	
	return value
end

function resetGateSound(theGate)
	if affectedByGate[theGate] then
		for k,v in ipairs(affectedByGate[theGate]) do
			triggerClientEvent(v, "stopGateSound", resourceRoot, theGate)
		end
		affectedByGate[theGate] = nil
	end
end

function resetBusyState(theGate)
	local isGateBusy = getElementData(theGate, "gate:busy")
	if (isGateBusy) then
		setElementData(theGate, "gate:busy", false, false)
	end
	resetGateSound(theGate)
end

function getProtectionType(theGate)
	local gateParameters = getElementData(theGate, "gate:parameters")
	return tonumber(gateParameters["type"]) or -1
end

function canPlayerControlGate(theGate, thePlayer, password)
	if not password then
		password = ""
	end
	local gateParameters = getElementData(theGate, "gate:parameters")
	local gateProtection = getProtectionType(theGate)
	if gateProtection == 1 then
		return true
	elseif gateProtection == 2 then
		if password == gateParameters["gateSecurityParameters"] then
			return true
		end
	elseif gateProtection == 3 then
		local tempAccess = split(gateParameters["gateSecurityParameters"], " ")
		for _, itemID in ipairs(tempAccess) do
			if (exports.rl_global:hasItem(thePlayer, tonumber(itemID))) then
				return true
			end
		end
		outputDebugString("Found none, returning false.")
		return false
	elseif gateProtection == 4 then
		local tempAccess = split(gateParameters["gateSecurityParameters"], " ")
		local hasItem, slotID, itemValue, databaseID = exports.rl_global:hasItem(thePlayer, tonumber(tempAccess[1]))
		if (hasItem) then
			if string.find(itemValue, tempAccess[2]) then
				return true
			end
		end
	elseif gateProtection == 5 then
		if password == gateParameters["gateSecurityParameters"] then
			return true
		end
	elseif gateProtection == 7 then
		local tempAccess = split(gateParameters["gateSecurityParameters"], " ")
		for _, factionID in ipairs(tempAccess) do
			if exports.rl_faction:isPlayerInFaction(thePlayer, tonumber(factionID)) then
				return true
			end 
		end
	elseif gateProtection == 8 then
		local tempAccess = split(gateParameters["gateSecurityParameters"], " AND ")
		local badges = exports["rl_items"]:getBadges()
		local count = 0
		for _, itemID in ipairs(tempAccess) do
			local orString = split(itemID, " OR ")
			if (#orString > 1) then
				local countOr = 0
				for k, v in ipairs(orString) do
					local theItem = split(orString[k], "=")
					if isNumeric(theItem[1]) then
						local hasItem, key, value2, value3 = exports.rl_global:hasItem(thePlayer, tonumber(theItem[1]))
						if hasItem then
							if theItem[2] then
								if (isNumeric(theItem[2])) then
									theItem[2] = tonumber(theItem[2])
								else
									theItem[2] = tostring(theItem[2])
								end
								
								if (tonumber(exports['rl_items']:countItems(thePlayer, tonumber(theItem[1]), theItem[2])) > 0) then
									countOr = countOr + 1
								end
							else
								countOr = countOr + 1
							end						
						end
					else
						local textFunction = tostring(theItem[1])
						if textFunction == "PILOT" then
							local pilotlicenses = exports['rl_mdc']:getPlayerPilotLicenses(thePlayer) or {}
							if theItem[2] then
								local requireLicense = split(theItem[2], "-")
								if isNumeric(requireLicense[1]) then
									for licenseKey, licenseValue in ipairs(pilotlicenses) do
										if licenseValue[1] == tonumber(requireLicense[1]) then
											if licenseValue[1] == 7 and requireLicense[2] and tonumber(requireLicense[2]) then
												if tonumber(requireLicense[2]) == licenseValue[2] then
													countOr = countOr + 1
												end
											else
												countOr = countOr + 1
											end
										end
									end
								else
									for licenseKey, licenseValue in ipairs(pilotlicenses) do
										if tostring(licenseValue[3]) == tostring(requireLicense[1]) then
											if licenseValue[1] == 7 and requireLicense[2] and tonumber(requireLicense[2]) then
												if tonumber(requireLicense[2]) == licenseValue[2] then
													countOr = countOr + 1
												end
											else
												countOr = countOr + 1
											end
										end
									end
								end
							else
								if #pilotlicenses > 0 then
									for licenseKey,licenseValue in ipairs(pilotlicenses) do
										if licenseValue[1] == 3 or licenseValue[1] == 4 then
											countOr = countOr + 1
											break
										end
									end
								end
							end
						elseif textFunction == "F" or textFunction == "FACTION" then
							if theItem[2] then
								local checkFaction = split(theItem[2], "-")
								if isNumeric(checkFaction[1]) then
									if isNumeric(checkFaction[2]) then
										if exports.rl_faction:isPlayerInFaction(thePlayer, tonumber(checkFaction[1]), tonumber(checkFaction[2])) then
											countOr = countOr + 1
										end
									else
										if exports.rl_faction:isPlayerInFaction(thePlayer, tonumber(checkFaction[1])) then
											countOr = countOr + 1
										end
									end
								else
									local checkFactionName = tostring(theItem[2])
									local factionID = exports.rl_faction:getFactionIDFromName(checkFactionName)
									if factionID then
										if exports.rl_faction:isPlayerInFaction(thePlayer, factionID) then
											countOr = countOr + 1
										end
									end
								end
							end
						elseif textFunction == "FL" or textFunction == "FACTIONLEADER" then
							if theItem[2] then
								local checkFaction = split(theItem[2], "-")
								if isNumeric(checkFaction[1]) then
									if isNumeric(checkFaction[2]) then
										local isMember, rank, isLeader = exports.rl_faction:isPlayerInFaction(thePlayer, tonumber(checkFaction[1]), tonumber(checkFaction[2]))
										if isMember and isLeader then
											countOr = countOr + 1
										end
									else
										local isMember, rank, isLeader = exports.rl_faction:isPlayerInFaction(thePlayer, tonumber(checkFaction[1]))
										if isMember and isLeader then
											countOr = countOr + 1
										end
									end
								else
									local checkFactionName = tostring(theItem[2])
									local factionID = exports.rl_faction:getFactionIDFromName(checkFactionName)
									if factionID then
										local isMember, rank, isLeader = exports.rl_faction:isPlayerInFaction(thePlayer, factionID)
										if isMember and isLeader then
											countOr = countOr + 1
										end
									end
								end
							end
						end
					end
				end
				if (countOr > 0) then
					count = count + 1
				end
			else
				local theItem = split(orString[1], "=")
				if isNumeric(theItem[1]) then
					local hasItem, key, value2, value3 = exports.rl_global:hasItem(thePlayer, tonumber(theItem[1]))
					if hasItem then
						if theItem[2] then
							if (isNumeric(theItem[2])) then
								theItem[2] = tonumber(theItem[2])
							else
								theItem[2] = tostring(theItem[2])
							end
							
							if (tonumber(exports['rl_items']:countItems(thePlayer, tonumber(theItem[1]), theItem[2])) > 0) then
								count = count + 1
							end
						else
							count = count + 1
						end
					end
				else
					local textFunction = tostring(theItem[1])
					if textFunction == "PILOT" then
						local pilotlicenses = exports['rl_mdc']:getPlayerPilotLicenses(thePlayer) or {}
						if theItem[2] then
							local requireLicense = split(theItem[2], "-")
							if isNumeric(requireLicense[1]) then
								for licenseKey, licenseValue in ipairs(pilotlicenses) do
									if licenseValue[1] == tonumber(requireLicense[1]) then
										if licenseValue[1] == 7 and requireLicense[2] and tonumber(requireLicense[2]) then
											if tonumber(requireLicense[2]) == licenseValue[2] then
												count = count + 1
											end
										else
											count = count + 1
										end
									end
								end
							else
								for licenseKey, licenseValue in ipairs(pilotlicenses) do
									if tostring(licenseValue[3]) == tostring(requireLicense[1]) then
										if licenseValue[1] == 7 and requireLicense[2] and tonumber(requireLicense[2]) then
											if tonumber(requireLicense[2]) == licenseValue[2] then
												count = count + 1
											end
										else
											count = count + 1
										end
									end
								end
							end
						else
							if #pilotlicenses > 0 then
								for licenseKey,licenseValue in ipairs(pilotlicenses) do
									if licenseValue[1] == 3 or licenseValue[1] == 4 then
										count = count + 1
										break
									end
								end
							end
						end
					elseif textFunction == "F" or textFunction == "FACTION" then
						if theItem[2] then
							local checkFaction = split(theItem[2], "-")
							if isNumeric(checkFaction[1]) then
								if isNumeric(checkFaction[2]) then
									if exports.rl_faction:isPlayerInFaction(thePlayer, tonumber(checkFaction[1]), tonumber(checkFaction[2])) then
										count = count + 1
									end
								else
									if exports.rl_faction:isPlayerInFaction(thePlayer, tonumber(checkFaction[1])) then
										count = count + 1
									end
								end
							else
								local checkFactionName = tostring(theItem[2])
								local factionID = exports.rl_faction:getFactionIDFromName(checkFactionName)
								if factionID then
									if exports.rl_faction:isPlayerInFaction(thePlayer, factionID) then
										count = count + 1
									end
								end
							end
						end
					elseif textFunction == "FL" or textFunction == "FACTIONLEADER" then
						if theItem[2] then
							local checkFaction = split(theItem[2], "-")
							if isNumeric(checkFaction[1]) then
								if isNumeric(checkFaction[2]) then
									local isMember, rank, isLeader = exports.rl_faction:isPlayerInFaction(thePlayer, tonumber(checkFaction[1]), tonumber(checkFaction[2]))
									if isMember and isLeader then
										count = count + 1
									end
								else
									local isMember, rank, isLeader = exports.rl_faction:isPlayerInFaction(thePlayer, tonumber(checkFaction[1]))
									if isMember and isLeader then
										count = count + 1
									end
								end
							else
								local checkFactionName = tostring(theItem[2])
								local factionID = exports.rl_faction:getFactionIDFromName(checkFactionName)
								if factionID then
									local isMember, rank, isLeader = exports.rl_faction:isPlayerInFaction(thePlayer, factionID)
									if isMember and isLeader then
										count = count + 1
									end
								end
							end
						end
					end
				end
			end
		end
		
		if (#tempAccess == count) then
			return true
		end
		
		return false
	elseif gateProtection == 9 then
		local tempAccess = split(gateParameters["gateSecurityParameters"], " ")
		for _, vehID in ipairs(tempAccess) do
			local veh
			for k,v in ipairs(exports.rl_pool:getPoolElementsByType("vehicle")) do
				if (getElementData(v, "dbid") == tonumber(vehID)) then
					veh = v
					break
				end
			end
			if veh then
				if (exports.rl_global:isAdminOnDuty(thePlayer) or exports.rl_global:hasItem(thePlayer, 3, tonumber(vehID)) or (getElementData(veh, "faction") > 0 and exports.rl_faction:isPlayerInFaction(thePlayer, getElementData(veh, "faction")))) then
					return true
				end
			end
		end		
		return false
	elseif gateProtection == 10 then
		local keycardItemID = 170
		if (exports.rl_global:hasItem(thePlayer, keycardItemID, gateParameters["gateSecurityParameters"])) then
			return true
		end
	end
	
	return false
end

function split(str, pat)
	local t = {}
	local fpat = "(.-)" .. pat
	local last_end = 1
	local s, e, cap = str:find(fpat, 1)
	
	while s do
		if s ~= 1 or cap ~= "" then
			table.insert(t,cap)
		end
		last_end = e + 1
		s, e, cap = str:find(fpat, last_end)
	end
	
	if last_end <= #str then
		cap = str:sub(last_end)
		table.insert(t, cap)
	end
	
	return t
end

function isNumeric(a)
	if tonumber(a) ~= nil then return true else return false end
end