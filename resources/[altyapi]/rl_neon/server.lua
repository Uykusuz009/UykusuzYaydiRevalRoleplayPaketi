local neonList = {
	["0"] = "null",
	["1"] = "white",
	["2"] = "blue",
	["3"] = "green",
	["4"] = "red",
	["5"] = "yellow",
	["6"] = "pink",
	["7"] = "orange",
	["8"] = "lightblue",
	["9"] = "rasta",
	["10"] = "ice"
}

addEvent("tuning->Neon", true)
addEventHandler("tuning->Neon", root, function(vehicle, neon)
	if vehicle then
		triggerClientEvent(root, "tuning->Neon", root, vehicle, neon)
	end
end)

function setNeon(thePlayer, commandName, vehicleID, neonColor)
	if exports.rl_integration:isPlayerServerManager(thePlayer) then
		if vehicleID and tonumber(vehicleID) and neonColor then
			vehicleID = tonumber(vehicleID)
			if neonList[neonColor] then
				local theVehicle = exports.rl_pool:getElement("vehicle", vehicleID)
				if theVehicle then
					setElementData(theVehicle, "tuning.neon", neonColor)
					triggerClientEvent(root, "delNeon", root, theVehicle, false)
					triggerClientEvent(root, "addNeon", root, theVehicle, neonColor)
					outputChatBox("[!]#FFFFFF Aracın neon rengi başarıyla değiştirildi.", thePlayer, 0, 255, 0, true)
				else
					outputChatBox("[!]#FFFFFF Böyle bir araç yok.", thePlayer, 255, 0, 0, true)
					playSoundFrontEnd(thePlayer, 4)
				end
			else
				outputChatBox("KULLANIM: /" .. commandName .. " [Araç ID] [Neon ID (1-10)]", thePlayer, 255, 194, 14)
			end
		else
			outputChatBox("KULLANIM: /" .. commandName .. " [Araç ID] [Neon ID (1-10)]", thePlayer, 255, 194, 14)
		end
	else
		outputChatBox("[!]#FFFFFF Yeterli yetkiniz yok.", thePlayer, 255, 0, 0, true)
		playSoundFrontEnd(thePlayer, 4)
	end
end
addCommandHandler("setneon", setNeon, false, false)