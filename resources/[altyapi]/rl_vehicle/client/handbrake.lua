local function checkVelocity(veh)
	local x, y, z = getElementVelocity(veh)
	return math.abs(x) < 0.05 and math.abs(y) < 0.05 and math.abs(z) < 0.05
end

function doHandbrake(commandName)
	if isPedInVehicle (localPlayer) then
		local playerVehicle = getPedOccupiedVehicle (localPlayer)
		if (getVehicleOccupant(playerVehicle, 0) == localPlayer) then
			local override = getElementDimension(playerVehicle) > 0 and checkVelocity(playerVehicle)
			triggerServerEvent("vehicle:handbrake", playerVehicle, override, commandName)
		end
	end
end
addCommandHandler("handbrake", doHandbrake)

function playerPressedKey(button, press)
	if button == "g" and (press) then
		doHandbrake()
		cancelEvent()
	end
end

function resourceStartBindG()
	bindKey("g", "down", playerPressedKey)
end
addEventHandler("onClientResourceStart", resourceRoot, resourceStartBindG)

addEventHandler("onClientVehicleStartExit", root, function(player)
	if player == localPlayer and not isVehicleLocked(source) and getPedControlState('handbrake') then
		setPedControlState('handbrake', false)
	end
end)