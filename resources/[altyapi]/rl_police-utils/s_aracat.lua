addCommandHandler("aracat",
	function(thePlayer, commandName, fonksiyon, targetPlayerNick, koltukID)
		local logged = getElementData(thePlayer, "logged")
	
		if (logged==1) then
			local theTeam = getPlayerTeam(thePlayer)
			local factionType = getElementData(theTeam, "type")
		
			if (factionType==1) or (factionType == 3) then
				if not (targetPlayerNick) or not (fonksiyon) or not (koltukID) then
					outputChatBox("KULLANIM: /" .. commandName .. " [at/bindir] [ID] [koltukID]", thePlayer, 255, 194, 14)
				else
					if not ((tonumber(koltukID)) >= 0 and (tonumber(koltukID) <= 3)) then
						outputChatBox("Koltuk ID'leri:", thePlayer, 255, 194, 14)
						outputChatBox("=> 0 - Sürücü Koltuğu", thePlayer, 255, 194, 14)
						outputChatBox("=> 1 - Ön Yolcu Koltuğu", thePlayer, 255, 194, 14)
						outputChatBox("=> 2 - Sol Arka Yolcu Koltuğu", thePlayer, 255, 194, 14)
						outputChatBox("=> 3 - Sağ Arka Yolcu Koltuğu", thePlayer, 255, 194, 14)
						return
					end
					local targetPlayer, targetPlayerName = exports.rl_global:findPlayerByPartialNick(thePlayer, targetPlayerNick)
					local theVehicle = exports.rl_pool:getElement("vehicle", getElementData(thePlayer, "lastvehid"))
				
					if targetPlayer then
						local x, y, z = getElementPosition(thePlayer)
						local tx, ty, tz = getElementPosition(targetPlayer)
						local vx, vy, vz = getElementPosition(theVehicle)
						
						local distance = getDistanceBetweenPoints3D(x, y, z, tx, ty, tz)
						local distance2 = getDistanceBetweenPoints3D(tx, ty, tz, vx, vy, vz)
						
						if (distance<=10) then
							if not (distance2<=10) then
								outputChatBox("[!]#FFFFFF " .. targetPlayerName .. " isimli şahıs en son bindiğiniz araçtan uzakta.", thePlayer, 255, 0, 0, true)
								return
							end
							if getVehicleOccupant(theVehicle, tonumber(koltukID)) then
								outputChatBox("[!]#FFFFFF Kişiyi atmak istediğiniz koltuk şu an dolu.", thePlayer, 255, 0, 0, true)
								return
							end
							local vehicleID = getElementData(thePlayer, "lastvehid")
							outputChatBox("[!]#FFFFFF " .. targetPlayerName .. " isimli şahsı #" .. vehicleID .. " ID'li aracın '" .. koltukID .. "' ID'li koltuğuna bindirdiniz.", thePlayer, 0, 255, 0, true)
							outputChatBox("[!]#FFFFFF " .. getPlayerName(thePlayer) .. " isimli şahıs tarafından #" .. vehicleID .. " ID'li aracın '" .. koltukID .. "' ID'li koltuğuna bindirildiniz.", targetPlayer, 0, 255, 0, true)
							warpPedIntoVehicle(targetPlayer, theVehicle, tonumber(koltukID))
						else
							outputChatBox("[!]#FFFFFF " .. targetPlayerName .. " isimli şahısdan uzaksınız.", thePlayer, 255, 0, 0, true)
						end
					end
				end
			end
		end
	end
)