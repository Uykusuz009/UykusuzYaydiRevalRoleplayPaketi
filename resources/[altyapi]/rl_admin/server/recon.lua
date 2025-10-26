addEvent("fixRecon", true)
addEventHandler("fixRecon", root, function(element)
	setElementDimension(client, getElementDimension(element))
	setElementInterior(client, getElementInterior(element))
	setCameraInterior(client, getElementInterior(element))
end)

function interiorChanged()
	for _, player in ipairs(exports.rl_pool:getPoolElementsByType("player")) do
		if isElement(player) then
			local cameraTarget = getCameraTarget(player)
			if (cameraTarget) then
				if (cameraTarget == source) then
					local interior = getElementInterior(source)
					local dimension = getElementDimension(source)
					setCameraInterior(player, interior)
					setElementInterior(player, interior)
					setElementDimension(player, dimension)
				end
			end
		end
	end
end
addEventHandler("onPlayerInteriorChange", root, interiorChanged)

function removeReconning()
	for _, player in ipairs(exports.rl_pool:getPoolElementsByType("player")) do
		if isElement(player) then
			local cameraTarget = getCameraTarget(player)
			if (cameraTarget) then
				if (cameraTarget == source) then
					reconPlayer(player)
				end
			end
		end
	end
end
addEventHandler("onPlayerQuit", root, removeReconning)

function reconPlayer(thePlayer, commandName, targetPlayer)
	if exports.rl_integration:isPlayerTrialAdmin(thePlayer) then
		if not (targetPlayer) then
			local rx = getElementData(thePlayer, "reconx")
			local ry = getElementData(thePlayer, "recony")
			local rz = getElementData(thePlayer, "reconz")
			local reconrot = getElementData(thePlayer, "reconrot")
			local recondimension = getElementData(thePlayer, "recondimension")
			local reconinterior = getElementData(thePlayer, "reconinterior")
			
			if not (rx) or not (ry) or not (rz) or not (reconrot) or not (recondimension) or not (reconinterior) then
				outputChatBox("KULLANIM: /" .. commandName .. " [Karakter Adı / ID]", thePlayer, 255, 194, 14)
			else
				detachElements(thePlayer)
			
				setElementPosition(thePlayer, rx, ry, rz)
				setPedRotation(thePlayer, reconrot)
				setElementDimension(thePlayer, recondimension)
				setElementInterior(thePlayer, reconinterior)
				setCameraInterior(thePlayer, reconinterior)
				
				setElementData(thePlayer, "reconx", nil, false)
				setElementData(thePlayer, "recony", nil, false)
				setElementData(thePlayer, "reconz", nil, false)
				setElementData(thePlayer, "reconrot", nil, false)
				setCameraTarget(thePlayer, thePlayer)
				setElementAlpha(thePlayer, 255)
				outputChatBox("[!]#FFFFFF İzlemeyi bıraktınız.", thePlayer, 0, 255, 0, true)
			end
		else
			local targetPlayer, targetPlayerName = exports.rl_global:findPlayerByPartialNick(thePlayer, targetPlayer)
			if targetPlayer then
				if not getElementData(targetPlayer, "logged") then
					outputChatBox("[!]#FFFFFF Bu oyuncu karakterine giriş yapmadığı için işlem gerçekleşmedi.", thePlayer, 255, 0, 0, true)
                    playSoundFrontEnd(thePlayer, 4)
				else
					if targetPlayer == thePlayer then
						outputChatBox("[!]#FFFFFF Kendinizi reconlayamazsınız.", thePlayer, 255, 0, 0, true)
						playSoundFrontEnd(thePlayer, 4)
						return
					end
					
					setElementAlpha(thePlayer, 0)
					
					if getPedOccupiedVehicle (thePlayer) then
						setElementData(thePlayer, "realinvehicle", 0, false)
						removePedFromVehicle(thePlayer)
					end
					
					if (not getElementData(thePlayer, "reconx") or getElementData(thePlayer, "reconx") == true) and not getElementData(thePlayer, "recony") then
						local x, y, z = getElementPosition(thePlayer)
						local rot = getPedRotation(thePlayer)
						local dimension = getElementDimension(thePlayer)
						local interior = getElementInterior(thePlayer)
						setElementData(thePlayer, "reconx", x, false)
						setElementData(thePlayer, "recony", y, false)
						setElementData(thePlayer, "reconz", z, false)
						setElementData(thePlayer, "reconrot", rot, false)
						setElementData(thePlayer, "recondimension", dimension, false)
						setElementData(thePlayer, "reconinterior", interior, false)
					end
					setPedWeaponSlot(thePlayer, 0)
					
					local playerdimension = getElementDimension(targetPlayer)
					local playerinterior = getElementInterior(targetPlayer)
					
					setElementDimension(thePlayer, playerdimension)
					setElementInterior(thePlayer, playerinterior)
					setCameraInterior(thePlayer, playerinterior)
					
					local x, y, z = getElementPosition(targetPlayer)
					setElementPosition(thePlayer, x - 10, y - 10, z - 5)
					local success = attachElements(thePlayer, targetPlayer, -10, -10, -5)
					if not (success) then
						success = attachElements(thePlayer, targetPlayer, -5, -5, -5)
						if not (success) then
							success = attachElements(thePlayer, targetPlayer, 5, 5, -5)
						end
					end
					
					if not (success) then
						outputChatBox("[!]#FFFFFF Bir sorun oluştu.", thePlayer, 255, 0, 0, true)
						playSoundFrontEnd(thePlayer, 4)
					else
						setCameraTarget(thePlayer, targetPlayer)
						outputChatBox("[!]#FFFFFF İzlediğiniz oyuncu: " .. targetPlayerName .. ".", thePlayer, 255, 0, 0, true)
						exports.rl_global:sendMessageToAdmins("[ADM] " .. exports.rl_global:getPlayerFullAdminTitle(thePlayer) .. " isimli yetkili " .. targetPlayerName .. " isimli oyuncuyu izlemeye başladı.")
						exports.rl_logs:addLog("recon", exports.rl_global:getPlayerFullAdminTitle(thePlayer) .. " isimli yetkili " .. targetPlayerName .. " isimli oyuncuyu izlemeye başladı.")
					end
				end
			end
		end
	end
end
addCommandHandler("recon", reconPlayer, false, false)

function asyncReconActivate(cur)
	if client ~= source then
		exports.rl_ac:banForEventAbuse(client, eventName)
		return
	end
	
	local target = exports.rl_pool:getElement("player", cur.target)
	if not target then
		triggerClientEvent(source, "admin:recon", source)
		return
	end
	removePedFromVehicle(source)
	setElementData(source, "reconx", true, false)
	setElementCollisionsEnabled (source, false)
	setElementAlpha(source, 0)
	setPedWeaponSlot(source, 0)
	
	local t_int = getElementInterior(target)
	local t_dim = getElementDimension(target)

	setElementDimension(source, t_dim)
	setElementInterior(source, t_int)
	setCameraInterior(source, t_int)

	local x1, y1, z1 = getElementPosition(target)
	attachElements(source, target, 0, 0, 5)
	setElementPosition(source, x1, y1, z1 + 5)
	setCameraTarget(source,target)
end
addEvent("admin:recon:async:activate", true)
addEventHandler("admin:recon:async:activate", root, asyncReconActivate)

function asyncReconDeactivate(cur)
	removePedFromVehicle(source)
	detachElements(source)
	setElementData(source, "reconx", false, false)

	setElementPosition(source, cur.x, cur.y, cur.z)
	setElementRotation(source, cur.rx, cur.ry, cur.rz)

	setElementDimension(source, cur.dim)
	setElementInterior(source, cur.int)
	setCameraInterior(source,cur.int)
	
	setCameraTarget(source, nil)
	setElementAlpha(source, 255)
	setElementCollisionsEnabled(source, true)
end
addEvent("admin:recon:async:deactivate", true)
addEventHandler("admin:recon:async:deactivate", root, asyncReconDeactivate)