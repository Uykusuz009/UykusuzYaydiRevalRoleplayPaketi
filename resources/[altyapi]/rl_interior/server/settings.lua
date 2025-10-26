addCommandHandler("intsettings", function(player, cmd)
	if getElementData(player, "logged") then
		local dbid, entrance, exit, interiorType, interiorElement = findProperty(player)

		if interiorElement then
			local interiorOwner = getElementData(interiorElement, "status")[4]
			local playerID = getElementData(player, "dbid")
			if tonumber(interiorOwner) == tonumber(playerID) then
				triggerClientEvent(player, "interior:settingsGui", player, interiorElement, getElementInterior(player), getElementDimension(player), getElementData(interiorElement, "interiorsettings"))
			end
		end
	end
end)

addEvent("interior:saveSettings", true)
addEventHandler("interior:saveSettings", root, function(element, interiorID, isVehicleInterior, newData)
	setElementData(element, "interiorsettings", newData)
	outputChatBox("[!]#FFFFFF Mülk ayarları başarıyla kaydedildi!", client, 0, 255, 0, true)
end)