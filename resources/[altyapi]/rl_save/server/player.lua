function syncTIS()
	for _, player in ipairs(getElementsByType("player")) do
		local timeInServer = getElementData(player, "time_in_server")
		if timeInServer and (getPlayerIdleTime(player) < 600000) then
			setElementData(player, "time_in_server", tonumber(timeInServer) + 1)
		end
	end
end
setTimer(syncTIS, 60000, 0)

function savePlayer(reason, player)
	if source then
		player = source
	end

	if isElement(player) then
		local logged = getElementData(player, "logged")
		if logged or reason == "Change Character" then
			local vehicle = getPedOccupiedVehicle(player)
		
			if vehicle then
				local seat = getPedOccupiedVehicleSeat(player)
				triggerEvent("onVehicleExit", vehicle, player, seat)
			end
		
			local x, y, z = getElementPosition(player)
			local rotation = getPedRotation(player)
			local interior = getElementInterior(player)
			local dimension = getElementDimension(player)
			local health = getElementHealth(player)
			local armor = getPedArmor(player)
			local skin = getElementModel(player)
		
			local zone = exports.rl_global:getElementZoneName(player)
			if not zone or #zone == 0 then
				zone = "Bilinmiyor"
			end
			
			if getElementData(player, "duty") then
				triggerEvent("duty.offDuty", player)
			end
		
			dbExec(exports.rl_mysql:getConnection(), "UPDATE characters SET x = ?, y = ?, z = ?, rotation = ?, interior = ?, dimension = ?, health = ?, armor = ?, skin = ?, last_login = NOW(), last_area = ? WHERE id = ?", x, y, z, rotation, interior, dimension, health, armor, skin, zone, getElementData(player, "dbid"))
			dbExec(exports.rl_mysql:getConnection(), "UPDATE accounts SET last_login = NOW() WHERE id = ?", getElementData(player, "account_id"))
		end
	end
end
addEventHandler("onPlayerQuit", root, savePlayer)
addEvent("savePlayer", false)
addEventHandler("savePlayer", root, savePlayer)

addCommandHandler("saveall", function(thePlayer, commandName)
	if exports.rl_integration:isPlayerDeveloper(thePlayer) then
		for _, player in ipairs(getElementsByType("player")) do
			savePlayer("Save All", player)
		end
		outputChatBox("[!]#FFFFFF Herkesin bilgileri veritabanına başarıyla kaydedildi.", thePlayer, 0, 255, 0, true)
	end
end)