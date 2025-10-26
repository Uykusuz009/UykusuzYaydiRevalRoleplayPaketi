function setPlayerFreecamEnabled(player, x, y, z, dontChangeFixedMode)
	removePedFromVehicle(player)
	setElementData(player, "realinvehicle", 0, false)
	return triggerClientEvent(player,"doSetFreecamEnabled", root, x, y, z, dontChangeFixedMode)
end

function setPlayerFreecamDisabled(player, dontChangeFixedMode)
	return triggerClientEvent(player,"doSetFreecamDisabled", root, dontChangeFixedMode)
end

function setPlayerFreecamOption(player, theOption, value)
	return triggerClientEvent(player,"doSetFreecamOption", root, theOption, value)
end

function isPlayerFreecamEnabled(player)
	return isEnabled(player)
end

function asyncActivateFreecam ()
	if client ~= source then
		exports.rl_ac:banForEventAbuse(client, eventName)
		return
	end
	
	if not isEnabled(source) then
		outputDebugString("[FREECAM] asyncActivateFreecam / Ran")
		removePedFromVehicle(source)
		setElementAlpha(source, 0)
		setElementFrozen(source, true)
		if not exports.rl_integration:isPlayerTrialAdmin(source) then
			exports.rl_global:sendMessageToAdmins("[FREECAM] " .. exports.rl_global:getAdminTitle1(source) .. " has activated temporary /freecam.")
		end
		setElementData(source, "freecam:state", true, false)
	end
end
addEvent("freecam:asyncActivateFreecam", true)
addEventHandler("freecam:asyncActivateFreecam", root, asyncActivateFreecam)

function asyncDeactivateFreecam ()
	if client ~= source then
		exports.rl_ac:banForEventAbuse(client, eventName)
		return
	end
	
	if true or isEnabled(source) then
		outputDebugString("[FREECAM] asyncDeactivateFreecam / Ran")
		removePedFromVehicle(source)
		setElementAlpha(source, 255)
		setElementFrozen(source, false)
		setElementData(source, "freecam:state", false, false)
	end
end
addEvent("freecam:asyncDeactivateFreecam", true)
addEventHandler("freecam:asyncDeactivateFreecam", root, asyncDeactivateFreecam)