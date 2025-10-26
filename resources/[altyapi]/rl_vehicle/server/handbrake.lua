local handbrakeTimer = {}
local someExceptions = {
	[573] = true,
	[556] = true,
	[444] = true
}

function toggleHandbrake(player, vehicle, forceOnGround, commandName)
	local handbrake = getElementData(vehicle, "handbrake")
	local kickstand = false
	if commandName == nil then
		kickstand = getVehicleType(vehicle) == 'BMX' or getVehicleType(vehicle) == 'Bike'
	else
		kickstand = commandName == 'kickstand'
	end
	
	if (handbrake == 0) then
		if getVehicleType(vehicle) == 'BMX' or getVehicleType(vehicle) == 'Bike' then
			outputChatBox("[!]#FFFFFF Bu aracın el freni yok.", player, 255, 0, 0, true)
			playSoundFrontEnd(player, 4)
			return false
		elseif (isVehicleOnGround(vehicle) or forceOnGround) or getVehicleType(vehicle) == "Boat" or getVehicleType(vehicle) == "Helicopter" or someExceptions[getVehicleType(vehicle)] then
			if kickstand then
				outputChatBox("[!]#FFFFFF Bu aracın el freni yok.", player, 255, 0, 0, true)
				playSoundFrontEnd(player, 4)
				return false
			end
			setControlState(player, "handbrake", true)
			triggerClientEvent(root, "playVehicleSound", root, "public/sounds/hb_on.mp3", vehicle)
			setElementData(vehicle, "handbrake", 1, true)
			handbrakeTimer[vehicle] = setTimer(function()
				setElementFrozen(vehicle, true)
				setControlState(player, "handbrake", false)
			end, 3000, 1)
		end
	else
		if getVehicleType(vehicle) == 'BMX' or getVehicleType(vehicle) == 'Bike' then
			if not kickstand then
				outputChatBox("[!]#FFFFFF Bu aracın el freni yok.", player, 255, 0, 0, true)
				playSoundFrontEnd(player, 4)
				return false
			end
		else
			if kickstand then
				outputChatBox("[!]#FFFFFF Bu aracın el freni yok.", player, 255, 0, 0, true)
				playSoundFrontEnd(player, 4)
				return false
			end
		end

		if isTimer(handbrakeTimer[vehicle]) then
			killTimer(handbrakeTimer[vehicle])
			setControlState(player, "handbrake", false)
		end
		
		setElementData(vehicle, "handbrake", 0, true)
		setElementFrozen(vehicle, false)
		triggerEvent("vehicle:handbrake:lifted", vehicle, player)
		triggerClientEvent(root, "playVehicleSound", root, "public/sounds/hb_off.mp3", vehicle)
	end	
end

addEvent("vehicle:handbrake:lifted", true)

addEvent("vehicle:handbrake", true)
addEventHandler("vehicle:handbrake", root, function(forceOnGround, commandName)
	toggleHandbrake(client, source, forceOnGround, commandName)
end)