function checkLSCSD(thePlayer, seat, jacked)
	local playerFaction = tonumber(getElementData(getPlayerTeam(thePlayer), "id"))
	local vehicleFaction = tonumber(getElementData(source, "faction"))
	
	if (thePlayer == getLocalPlayer()) and (seat == 0) and (vehicleFaction == 23) and not (playerFaction == 23) then
		cancelEvent()
		outputChatBox("#575757Reval: #f0f0f0Bu aracı yalnızca Los Santos County Sheriff Department üyeleri kullanabilir.", 255, 0, 0, true)
	end
end
addEventHandler("onClientVehicleStartEnter", getRootElement(), checkLSCSD)

function checkLSPD(thePlayer, seat, jacked)
	local playerFaction = tonumber(getElementData(getPlayerTeam(thePlayer), "id"))
	local vehicleFaction = tonumber(getElementData(source, "faction"))
	
	if (thePlayer == getLocalPlayer()) and (seat == 0) and (vehicleFaction == 1) and not (playerFaction == 1) then
		cancelEvent()
		exports['rl_bildirim']:addNotification("Bu aracı yalnızca Reval Emniyet Mudurlugu üyeleri kullanabilir.", "error")
		--outputChatBox("#575757Reval: #f0f0f0Bu aracı yalnızca Reval Emniyet Mudurlugu üyeleri kullanabilir.", 255, 0, 0, true)
	elseif (thePlayer == getLocalPlayer()) and (seat == 0) and (vehicleFaction == 2) and not (playerFaction == 2) then
		cancelEvent()
		exports['rl_bildirim']:addNotification("Bu aracı yalnızca Reval Saglik Mudurlugu üyeleri kullanabilir.", "error")
		--outputChatBox("#575757RevalBu aracı yalnızca Reval Saglik Mudurlugu üyeleri kullanabilir.", 255, 0, 0, true)
	elseif (thePlayer == getLocalPlayer()) and (seat == 0) and (vehicleFaction == 3) and not (playerFaction == 3) then
		cancelEvent()
		exports['rl_bildirim']:addNotification("Bu aracı yalnızca Reval Belediyesi kullanabilir.", "error")
		--outputChatBox("#575757Reval: #f0f0f0Bu aracı yalnızca Reval Saglik Mudurlugu üyeleri kullanabilir.", 255, 0, 0, true)
	elseif (thePlayer == getLocalPlayer()) and (seat == 0) and (vehicleFaction == 233) and not (playerFaction == 233) then
		cancelEvent()
		exports['rl_bildirim']:addNotification("Bu aracı yalnızca WILSON BARON kullanabilir.", "error")
		--outputChatBox("#575757Reval: #f0f0f0Bu aracı yalnızca Reval Saglik Mudurlugu üyeleri kullanabilir.", 255, 0, 0, true)
	end
end
addEventHandler("onClientVehicleStartEnter", getRootElement(), checkLSPD)

function callsignrender ()
local localX, localY, localZ = getElementPosition(localPlayer)
	local vehicles = getElementsByType("vehicle", getRootElement(), true)

	if #vehicles > 0 then
		for i = 1, #vehicles do
			local vehicle = vehicles[i]

			if isElement(vehicle) and getElementData(vehicle, "callsign") then
				local numberPlate = getVehiclePlateText(vehicle)

				if numberPlate then
					local vehicleX, vehicleY, vehicleZ = getElementPosition(vehicle)
					local minX, minY, minZ, maxX, maxY, maxZ = getElementBoundingBox(vehicle)
					
					vehicleZ = vehicleZ + maxZ + 0.15
					vehicleZ	= vehicleZ -2
					--vehicleX =  minX
					if isLineOfSightClear(vehicleX, vehicleY, vehicleZ, localX, localY, localZ, true, false, false, true, false, false, false,localPlayer) then
						local screenX, screenY = getScreenFromWorldPosition(vehicleX, vehicleY, vehicleZ)
		
						if screenX and screenY then
							
							local distance = getDistanceBetweenPoints3D(vehicleX, vehicleY, vehicleZ, localX, localY, localZ)

							if distance < 50 then
								local distMul = 1 - distance / 100
								local alphaMul = 1 - distance / 50

								local sx = 50 
								local sy = 50 
								local x = screenX - sx / 2
								local y = screenY - sy / 2

								dxDrawText(getElementData(vehicle, "callsign"), x, y , x + sx, 0, tocolor(255, 255, 255, 255 ), 1, "default-bold", "center", "top")
							end
						end
					end
				end
			end
		end
	end
end
addEventHandler("onClientRender",root,callsignrender)