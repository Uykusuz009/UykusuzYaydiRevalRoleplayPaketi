function switchLights(veh)
	if veh then
		local cur = getElementData(veh,"lights")
		if cur == 0 then
			setElementData(veh,"lights",1)
		elseif cur == 1 then
			setElementData(veh,"lights",2)
		elseif cur == 2 then
			setElementData(veh,"lights",0)
		else
			setElementData(veh,"lights",0)
		end
	end
end
addEvent("switchLights",true)
addEventHandler("switchLights",root,switchLights)

addEvent("getVehicleHeadlightColor", true)
addEventHandler("getVehicleHeadlightColor", root, function(vehicle)
	local ID = getElementData(vehicle, "dbid")
	
	if ID then
		local conn = exports.rl_mysql:getConnection()
		local query = dbQuery(conn, "SELECT headlights FROM vehicles WHERE id=?", ID)
		local result = dbPoll(query, -1)
		
		if result and result[1] then
			local headlightColors = fromJSON(result[1].headlights)
			if headlightColors then
				triggerClientEvent(client, "onClientHeadlightColor", root, vehicle, headlightColors[1], headlightColors[2], headlightColors[3])
			else
				-- Default to white if JSON parsing fails
				triggerClientEvent(client, "onClientHeadlightColor", root, vehicle, 255, 255, 255)
			end
		else
			-- Default to white if no result found
			triggerClientEvent(client, "onClientHeadlightColor", root, vehicle, 255, 255, 255)
		end
	else
		-- Default to white if no ID found
		triggerClientEvent(client, "onClientHeadlightColor", root, vehicle, 255, 255, 255)
	end
end)
