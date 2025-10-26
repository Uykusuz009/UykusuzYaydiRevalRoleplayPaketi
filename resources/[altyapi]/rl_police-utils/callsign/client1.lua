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

local robotoFont = exports.rl_fonts:getFont("RobotoB", 13)

function callsignrender()
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
					
					vehicleZ = vehicleZ + maxZ + 1.15
					vehicleZ = vehicleZ -2
					if isLineOfSightClear(vehicleX, vehicleY, vehicleZ, localX, localY, localZ, true, false, false, true, false, false, false,localPlayer) then
						local screenX, screenY = getScreenFromWorldPosition(vehicleX, vehicleY, vehicleZ)
						if screenX and screenY then
							local distance = getDistanceBetweenPoints3D(vehicleX, vehicleY, vehicleZ, localX, localY, localZ)

							if distance < 15 then
								local distMul = 1 - distance / 100
								local alphaMul = 1 - distance / 50

								local sx = 50 
								local sy = 50 
								local x = screenX - sx / 3
								local y = screenY - sy / 3

								dxDrawText(getElementData(vehicle, "callsign"), x+2, y-105 , x + sx, 0, tocolor(0, 0, 0, 255), 1, robotoFont, "center", "top")
								dxDrawText(getElementData(vehicle, "callsign"), x, y-105 , x + sx, 0, tocolor(255, 255, 255, 255), 1, robotoFont, "center", "top")
							end
						end
					end
				end
			end
		end
	end
end
setTimer(callsignrender, 5, 0)