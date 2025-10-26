addEventHandler("onVehicleStartEnter", root, function(player, seat)
    if isPrivateVehicle(getElementModel(source)) then
		if seat == 0 then
			local ownerFound = false
			local occupants = getVehicleOccupants(source) or {}
			local vehicleOwner = getElementData(source, "owner") or 0
			local vehicleFaction = getElementData(source, "faction") or 0

			for seat, occupant in pairs(occupants) do
				if (occupant and getElementType(occupant) == "player") then
					local dbid = getElementData(occupant, "dbid") or 0
					if dbid == vehicleOwner then
						ownerFound = true
						break
					end
				end
			end

			local playerDBID = getElementData(player, "dbid") or 0
			local playerFaction = getElementData(player, "faction") or 0
			if not ownerFound and (not (playerDBID == vehicleOwner) and not (playerFaction == vehicleFaction)) then
				outputChatBox("[!]#FFFFFF Özel aracın sahibi araçta olmadığı sürece araca binemezsin.", player, 255, 0, 0, true)
				playSoundFrontEnd(player, 4)
				cancelEvent()
			end
		end
	end
end)