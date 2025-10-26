function syncRadio(station)
	local vehicle = getPedOccupiedVehicle(source)
	setElementData(vehicle, "vehicle:radio", station, true)
	setElementData(vehicle, "vehicle:radio:old", station, true)
end
addEvent("car:radio:sync", true)
addEventHandler("car:radio:sync", root, syncRadio)

function syncRadio(vol)
	local vehicle = getPedOccupiedVehicle(source)
	setElementData(vehicle, "vehicle:radio:volume", vol, true)
	exports.rl_global:sendLocalMeAction(source, "radyo ses seviyesini ayarlar.")
end
addEvent("car:radio:vol", true)
addEventHandler("car:radio:vol", root, syncRadio)

addCommandHandler("srd", function(thePlayer, commandName)
	if exports.rl_integration:isPlayerTrialAdmin(thePlayer) then
		local x, y, z = getElementPosition(thePlayer)
		
		for i, v in ipairs(getElementsByType("vehicle")) do
			local vx, vy, vz = getElementPosition(v)
			local distance = getDistanceBetweenPoints3D(x, y, z, vx, vy, vz)
			
			if distance < 200 then
				setElementData(v, "vehicle:radio:volume", 0, true)
			end
		end
		
		exports.rl_global:sendMessageToAdmins("[ADM] " .. getPlayerName(thePlayer):gsub("_", " ") .. " has turned all radios off in district " .. getZoneName(x, y, z, false) .. ".")
	end
end)