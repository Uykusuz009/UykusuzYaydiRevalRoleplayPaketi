txd = engineLoadTXD("riot_shield.txd")
engineImportTXD(txd, 1631)
dff = engineLoadDFF("riot_shield.dff", 1631)
col = engineLoadCOL("riot_shield.col")
engineReplaceCOL(col, 1631)
engineReplaceModel(dff, 1631)

function checkLASD(thePlayer, seat, jacked)
	local playerFaction = tonumber(getElementData(getPlayerTeam(thePlayer), "id"))
	local vehicleFaction = tonumber(getElementData(source, "faction"))
	
	if (thePlayer == getLocalPlayer()) and (seat == 0) and (vehicleFaction == 3) and not (playerFaction == 3) then
		cancelEvent()
		outputChatBox("[!]#FFFFFF Bu aracı yalnızca Los Santos Sheriff Department üyeleri kullanabilir.", 255, 0, 0, true)
	end
end
addEventHandler("onClientVehicleStartEnter", getRootElement(), checkLASD)

function checkLSPD(thePlayer, seat, jacked)
	local playerFaction = tonumber(getElementData(getPlayerTeam(thePlayer), "id"))
	local vehicleFaction = tonumber(getElementData(source, "faction"))
	
	if (thePlayer == getLocalPlayer()) and (seat == 0) and (vehicleFaction == 1) and not (playerFaction == 1) then
		cancelEvent()
		outputChatBox("[!]#FFFFFF Bu aracı yalnızca Los Santos Police Department üyeleri kullanabilir.", 255, 0, 0, true)
	end
end
addEventHandler("onClientVehicleStartEnter", getRootElement(), checkLSPD)