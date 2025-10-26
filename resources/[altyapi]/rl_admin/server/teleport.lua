local teleportLocations = {
	ls = { 1481.2021484375, -1740.2626953125, 13.546875, 0, 0, 0 },
	sf = { -1988.5693, 507.0029, 35.1719, 0, 0, 90 },
	sfia = { -1689.069, -536.792, 14.255, 0, 0, 252 },
	lv = { 1691.6802, 1449.1294, 10.7654, 0, 0, 268 },
	pc = { 2253.668, -85.0479, 28.0861, 0, 0, 180 },
	cicek = { 1863.052734375, -1246.4482421875, 13.967384338379, 0, 0, 24 },
	bank = { 1310.0888671875, -1376.587890625, 13.656514167786, 0, 0, 0 },
	cityhall = { 1481.5781, -1768.628, 18.7958, 0, 0, 3 },
	crusher = { 2438.7314, -2092.624, 13.5469, 0, 0, 267 },
	dmv = { -1978.2578, 440.4844, 35.1719, 0, 0, 90 },
	bayside = { -2620.1035, 2271.2324, 8.1442, 0, 0, 360 },
	sfpd = { -1607.7188, 722.9854, 12.3681, 0, 0, 360 },
	igs = { 1968.3682, -1764.0225, 13.5469, 0, 0, 120 },
	lsia = { 1967.7998, -2180.4707, 13.5469, 0, 0, 165 },
	hastane = { 1178.9795, -1324.2129, 14.1468, 0, 0, 268 },
	dmv = { 1094.3066, -1791.8574, 13.6174, 0, 0, 255 },
	lstr = { 2668.1299, -2555.0, 13.6143, 0, 0, 180 },
	vgs = { 996.3438, -920.4053, 42.1797, 0, 0, 6 },
}

function teleportToPresetPoint(thePlayer, commandName, place, optionalPlayer)
	if exports.rl_integration:isPlayerTrialAdmin(thePlayer) then
		if not (place) then
			outputChatBox("KULLANIM: /" .. commandName .. " [Yer] [Karakter Adı / ID (İsteğe Bağlı)]", thePlayer, 255, 194, 14)
		elseif not optionalPlayer and place then
			local place = string.lower(tostring(place))
			
			if (teleportLocations[place] ~= nil) then
				if (isPedInVehicle(thePlayer)) then
					local theVehicle = getPedOccupiedVehicle(thePlayer)
					setElementAngularVelocity(theVehicle, 0, 0, 0)
					setElementPosition(theVehicle, teleportLocations[place][1], teleportLocations[place][2], teleportLocations[place][3])
					setVehicleRotation(theVehicle, 0, 0, teleportLocations[place][6])
					setTimer(setElementAngularVelocity, 50, 20, theVehicle, 0, 0, 0)
					
					setElementDimension(theVehicle, teleportLocations[place][5])
					setElementInterior(theVehicle, teleportLocations[place][4])

					setElementDimension(thePlayer, teleportLocations[place][5])
					setElementInterior(thePlayer, teleportLocations[place][4])
					setCameraInterior(thePlayer, teleportLocations[place][4])
				else
					detachElements(thePlayer)
					setElementPosition(thePlayer, teleportLocations[place][1], teleportLocations[place][2], teleportLocations[place][3])
					setPedRotation(thePlayer, teleportLocations[place][6])
					setElementDimension(thePlayer, teleportLocations[place][5])
					setCameraInterior(thePlayer, teleportLocations[place][4])
					setElementInterior(thePlayer, teleportLocations[place][4])
				end
				
				triggerEvent("frames:loadInteriorTextures", thePlayer, teleportLocations[place][5])
				
				outputChatBox("[!]#FFFFFF Başarıyla [" .. tostring(place) .. "] isimli bölgeye ışınlandı.", thePlayer, 0, 255, 0, true)
			else
				outputChatBox("[!]#FFFFFF Geçersiz bir konum adı girdiniz.", thePlayer, 255, 0, 0, true)
				playSoundFrontEnd(thePlayer, 4)
			end
		elseif optionalPlayer and place then
			local place = string.lower(tostring(place))
			local targetPlayer, targetPlayerName = exports.rl_global:findPlayerByPartialNick(thePlayer, optionalPlayer)
			
			if targetPlayer then
				if not getElementData(targetPlayer, "logged") then
					outputChatBox("[!]#FFFFFF Bu oyuncu karakterine giriş yapmadığı için işlem gerçekleşmedi.", thePlayer, 255, 0, 0, true)
					playSoundFrontEnd(thePlayer, 4)
				elseif (teleportLocations[place] ~= nil) then
					if (isPedInVehicle(targetPlayer)) then
						local theVehicle = getPedOccupiedVehicle(targetPlayer)
						setElementAngularVelocity(theVehicle, 0, 0, 0)
						setElementPosition(theVehicle, teleportLocations[place][1], teleportLocations[place][2], teleportLocations[place][3])
						setVehicleRotation(theVehicle, 0, 0, teleportLocations[place][6])
						setTimer(setElementAngularVelocity, 50, 20, theVehicle, 0, 0, 0)
						
						setElementDimension(theVehicle, teleportLocations[place][5])
						setElementInterior(theVehicle, teleportLocations[place][4])

						setElementDimension(targetPlayer, teleportLocations[place][5])
						setElementInterior(targetPlayer, teleportLocations[place][4])
						setCameraInterior(targetPlayer, teleportLocations[place][4])
					else
						detachElements(targetPlayer)
						setElementPosition(targetPlayer, teleportLocations[place][1], teleportLocations[place][2], teleportLocations[place][3])
						setPedRotation(targetPlayer, teleportLocations[place][6])
						setElementDimension(targetPlayer, teleportLocations[place][5])
						setCameraInterior(targetPlayer, teleportLocations[place][4])
						setElementInterior(targetPlayer, teleportLocations[place][4])
					end
					
					triggerEvent("frames:loadInteriorTextures", targetPlayer, teleportLocations[place][5])
					
					outputChatBox("[!]#FFFFFF " .. targetPlayerName .. " isimli oyuncu [" .. tostring(place) .. "] isimli bölgeye ışınlanıldı.", thePlayer, 0, 255, 0, true)
					outputChatBox("[!]#FFFFFF " .. exports.rl_global:getPlayerFullAdminTitle(thePlayer) .. " isimli yetkili sizi [" .. tostring(place) .. "] isimli bölgeye ışınladı.", targetPlayer, 0, 0, 255, true)
					exports.rl_logs:addLog("gotoplace", exports.rl_global:getPlayerFullAdminTitle(thePlayer) .. " isimli yetkili " .. targetPlayerName .. " isimli oyuncuyu [" .. tostring(place) .. "] isimli bölgeye ışınladı.")
				else
					outputChatBox("[!]#FFFFFF Geçersiz bir konum adı girdiniz.", thePlayer, 255, 0, 0, true)
					playSoundFrontEnd(thePlayer, 4)
				end
			end
		end
	end
end
addCommandHandler("gotoplace", teleportToPresetPoint, false, false)

function getPosition(thePlayer, commandName)
	if exports.rl_integration:isPlayerTrialAdmin(thePlayer) then
		local x, y, z = getElementPosition(thePlayer)
		local rx, ry, rz = getElementRotation(thePlayer)
		local dimension = getElementDimension(thePlayer)
		local interior = getElementInterior(thePlayer)
		
		outputChatBox("Position: " .. x .. ", " .. y .. ", " .. z, thePlayer, 255, 194, 14)
		outputChatBox("Rotation: " .. rx .. ", " .. ry .. ", " .. rz, thePlayer, 255, 194, 14)
		outputChatBox("Dimension: " .. dimension, thePlayer, 255, 194, 14)
		outputChatBox("Interior: " .. interior, thePlayer, 255, 194, 14)
		
		local text = x .. ", " .. y .. ", " .. z
		outputChatBox(text .. " - kopyalandı.", thePlayer, 200, 200, 200)
		triggerClientEvent(thePlayer, "copyPosToClipboard", thePlayer, text)
	end
end
addCommandHandler("getpos", getPosition, false, false)

function setX(thePlayer, commandName, ix)
	if exports.rl_integration:isPlayerTrialAdmin(thePlayer) then
		if not (ix) or not tonumber(ix) then
			outputChatBox("KULLANIM: /" .. commandName .. " [X]", thePlayer, 255, 194, 14)
		else
			if (isPedInVehicle(thePlayer)) then
				local x, y, z = getElementPosition(thePlayer)
				local theVehicle = getPedOccupiedVehicle(thePlayer)
				setElementPosition(theVehicle, x + ix, y, z)
			else
				local x, y, z = getElementPosition(thePlayer)
				setElementPosition(thePlayer, x + ix, y, z)
			end
		end
	end
end
addCommandHandler("x", setX, false, false)

function setY(thePlayer, commandName, iy)
	if exports.rl_integration:isPlayerTrialAdmin(thePlayer) then
		if not (iy) or not tonumber(iy) then
			outputChatBox("KULLANIM: /" .. commandName .. " [Y]", thePlayer, 255, 194, 14)
		else
			if (isPedInVehicle(thePlayer)) then
				local x, y, z = getElementPosition(thePlayer)
				local theVehicle = getPedOccupiedVehicle(thePlayer)
				setElementPosition(theVehicle, x, y + iy, z)
			else
				local x, y, z = getElementPosition(thePlayer)
				setElementPosition(thePlayer, x, y + iy, z)
			end
		end
	end
end
addCommandHandler("y", setY, false, false)

function setZ(thePlayer, commandName, iz)
	if exports.rl_integration:isPlayerTrialAdmin(thePlayer) then
		if not (iz) or not tonumber(iz) then
			outputChatBox("KULLANIM: /" .. commandName .. " [Z]", thePlayer, 255, 194, 14)
		else
			if (isPedInVehicle(thePlayer)) then
				local x, y, z = getElementPosition(thePlayer)
				local theVehicle = getPedOccupiedVehicle(thePlayer)
				setElementPosition(theVehicle, x, y, z + iz)
			else
				local x, y, z = getElementPosition(thePlayer)
				setElementPosition(thePlayer, x, y, z + iz)
			end
		end
	end
end
addCommandHandler("z", setZ, false, false)

function setXYZ(thePlayer, commandName, ix, iy, iz)
	if exports.rl_integration:isPlayerTrialAdmin(thePlayer) then
		if not (ix) or not (iy) or not (iz) or not tonumber(ix) or not tonumber(iy) or not tonumber(iz) then
			outputChatBox("KULLANIM: /" .. commandName .. " [X] [Y] [Z]", thePlayer, 255, 194, 14)
		else
			if (isPedInVehicle(thePlayer)) then
				local x, y, z = getElementPosition(thePlayer)
				local theVehicle = getPedOccupiedVehicle(thePlayer)
				setElementPosition(theVehicle, x + ix, y + iy, z + iz)
			else
				local x, y, z = getElementPosition(thePlayer)
				setElementPosition(thePlayer, x + ix, y + iy, z + iz)
			end
		end
	end
end
addCommandHandler("xyz", setXYZ, false, false)

function setPosition(thePlayer, commandName, ix, iy, iz)
	if exports.rl_integration:isPlayerTrialAdmin(thePlayer) then
		if not (ix) or not (iy) or not (iz) or not tonumber(ix) or not tonumber(iy) or not tonumber(iz) then
			outputChatBox("KULLANIM: /" .. commandName .. " [X] [Y] [Z]", thePlayer, 255, 194, 14)
		else
			if (isPedInVehicle(thePlayer)) then
				local x, y, z = getElementPosition(thePlayer)
				local theVehicle = getPedOccupiedVehicle(thePlayer)
				setElementPosition(theVehicle, ix, iy, iz)
			else
				local x, y, z = getElementPosition(thePlayer)
				setElementPosition(thePlayer, ix, iy, iz)
			end
		end
	end
end
addCommandHandler("setpos", setPosition, false, false)