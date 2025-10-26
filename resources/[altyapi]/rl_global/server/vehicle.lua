function getVehiclesOwnedByCharacter(thePlayer)
	if thePlayer and isElement(thePlayer) then
		local dbid = tonumber(getElementData(thePlayer, "dbid"))
		local vehicles = {}
		
		for key, value in ipairs(exports.rl_pool:getPoolElementsByType("vehicle")) do
			local owner = tonumber(getElementData(value, "owner"))
			if (owner) and (owner == dbid) then
				local id = getElementData(value, "dbid")
				vehicles[#vehicles + 1] = id
			end
		end
		return #vehicles, vehicles
	end
	return false
end

function canPlayerBuyVehicle(thePlayer)
	if thePlayer and isElement(thePlayer) then
		if getElementData(thePlayer, "logged") then
			local maxVehicles = getElementData(thePlayer, "max_vehicles") or 0
			local vehiclesNums, vehicles = getVehiclesOwnedByCharacter(thePlayer)
			if (vehiclesNums < maxVehicles) then
				return true
			end
			return false, "Too much vehicles" 
			
		end
		return false, "Player not logged in"
	end
	return false, "Element not found"
end