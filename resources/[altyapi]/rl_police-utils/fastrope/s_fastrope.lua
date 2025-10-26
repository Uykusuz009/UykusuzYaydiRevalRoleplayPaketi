function startRappel(x, y, z, gz)
if client ~= source then 
        kickPlayer(client,"Ramo AC - triggerServerEvent")
        print("RamoAC 111")
        return 
    end
	local r = getPedRotation(source)
	
	local seat = getPedOccupiedVehicleSeat(source)
	
	if (seat==0 or seat==2) then -- left hand side
		r = r + 90
	else
		r = r - 90
	end
	
	setPedRotation(source, r)
	
	local slot = getPedWeaponSlot(source)
	local invisible = createObject (1337, x, y, z, 0, 0, r)
	setElementAlpha(invisible, 0)
	setElementData(source, "realinvehicle", 0, false)
	removePedFromVehicle(source)
	attachElements(source, invisible)
	moveObject(invisible, 2000, x, y, gz, 0, 0, 0)
	exports.rl_pool:allocateElement(invisible)
	setTimer(stopRappel, 2000, 1, invisible, source, slot)
	for key, value in ipairs(exports.rl_global:getNearbyElements(invisible, "player", 100)) do
		triggerClientEvent(value, "createRope", value, x, y, z, gz)
	end
end
addEvent("startRappel", true)
addEventHandler("startRappel", getRootElement(), startRappel)

function stopRappel(object, player, slot)
	detachElements(player, object)
	exports.rl_global:removeAnimation(player)
	setPedWeaponSlot(player, slot)
	destroyElement(object)
end
	