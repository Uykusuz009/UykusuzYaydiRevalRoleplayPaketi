local gpsBlips = {}
local gpsMarkers = {}

function gpsFunc(thePlayer, commandName, vehID)
	if not vehID then
		outputChatBox("KULLANIM: /" .. commandName .. " [Araç ID]", thePlayer, 255, 194, 14)
		return false
	end
	local playerID = getElementData(thePlayer, "dbid")
	if not gpsBlips[playerID] then
		local vehicle = exports.rl_pool:getElement("vehicle", vehID)
		if vehicle then
			local vehicleOwner = getElementData(vehicle, "owner")
			if vehicleOwner == playerID then
				local vehposX, vehposY, vehposZ = getElementPosition(vehicle)
				gpsBlips[playerID] = createBlip(vehposX, vehposY, vehposZ, 19, 2, 255, 0, 0, 255, 0, 99999.0, thePlayer)
				gpsMarkers[playerID] = createMarker(vehposX, vehposY, vehposZ, "checkpoint", 3, 255, 0, 0, 255, thePlayer)
				attachElements(gpsMarkers[playerID], vehicle)
				attachElements(gpsBlips[playerID], vehicle)
				if gpsBlips[playerID] then
					outputChatBox("[!]#FFFFFF Haritadaki kırmızı bayraktan aracınızı takip edebilirsiniz.", thePlayer, 0, 255, 0, true)
				end
			else
				outputChatBox("[!]#FFFFFF Araç size ait değil.", thePlayer, 255, 0, 0, true)
			end
		end
	else
		outputChatBox("[!]#FFFFFF GPS şu anda çalışıyor, tekrar kullanmak için önce /kgps ile öncekini devre dışı bırakın.", thePlayer, 255, 0, 0, true)
	end
end
addCommandHandler("agps", gpsFunc)

function kgpsFunc(thePlayer, commandName)
	local playerID = getElementData(thePlayer, "dbid")
	if gpsBlips[playerID] then
		destroyElement(gpsMarkers[playerID])
		gpsMarkers[playerID] = false
		destroyElement(gpsBlips[playerID])
		gpsBlips[playerID] = false
		outputChatBox("[!]#FFFFFF GPS'i başarıyla devre dışı bıraktınız.", thePlayer, 0, 255, 0, true)
	end
end
addCommandHandler("kgps", kgpsFunc)