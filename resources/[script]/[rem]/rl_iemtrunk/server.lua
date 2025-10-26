local enterableVehicles = {}
local restrictedWeapons = {}
for i=0, 15 do
	restrictedWeapons[i] = true
end
local carWeapons = {
	["M4"] = true,
	["Shotgun"] = true,
	["MP5"] = true,
}
local enabledFactions = {
	[1] = true,
}
addCommandHandler("bsilahal",
	function(player, cmd, weap)
		if getElementData(player, "loggedin") == 1 and enabledFactions[getElementData(player, "faction")] and getElementData(player, "vdutypd") == 1 or getElementData(player, "vdutypd") == 2 or getElementData(player, "vdutypd") == 3 or getElementData(player, "vdutypd") == 4 or getElementData(player, "vdutypd") == 5 then
			local nearbyVehicles = exports.rl_global:getNearbyElements(player, "vehicle", 5)
			local found = nil
			local plaka = nil
			local x, y, z = getElementPosition(player)
			for i, veh in ipairs(nearbyVehicles) do
				local dbid = tonumber(getElementData(veh, "dbid"))
				local distanceToVehicle = getDistanceBetweenPoints3D(x, y, z, getElementPosition(veh))
				if distanceToVehicle <= 5 and (tonumber(getElementData(player, "faction")) == tonumber(getElementData(veh, "faction"))) then
					shortest = distanceToVehicle
					found = veh
					plaka = getElementData(veh, "dbid")
				end
			end
			if found then
				if not weap or not carWeapons[weap] then
					outputChatBox("[!]#ffffff Bu araçtan yalnızca şu silahları alabilirsin:", player, 0, 0, 255, true)
					local vehicleItems = exports['rl_items']:getItems(found)
					for i, v in ipairs(vehicleItems) do
						if v[1] == 115 and not restrictedWeapons[tonumber(exports.rl_global:explode(":", v[2])[1])] then
							local checkString = string.sub(exports.rl_global:explode(":", v[2])[3], -4) == " (D)"
							if checkString then
								outputChatBox("[!]#ffffff /bsilahal "..exports.rl_global:explode(":", v[2])[3], player, 0, 255, 0, true)
							end
						end
					end
				return end
				local vehicleItems = exports['rl_items']:getItems(found)
				for i, v in ipairs(vehicleItems) do
					if v[1] == 115 and not restrictedWeapons[tonumber(exports.rl_global:explode(":", v[2])[1])] then
						local checkString = string.sub(exports.rl_global:explode(":", v[2])[3], -4) == " (D)"
						if checkString and string.find(string.lower(exports.rl_global:explode(":", v[2])[3]), weap:lower()) then
							exports.rl_global:takeItem(found, v[1], v[2])
							exports.rl_global:giveItem(player, v[1], v[2])
							local count = 0
							setVehicleDoorOpenRatio(found, 1, 1, 500)
							setTimer(function()
								setVehicleDoorOpenRatio(found, 1, 0, 500)
							end, 1000, 1)
							exports.rl_global:sendLocalMeAction(player, "aracın bagajını açar, "..weap.."'ı bagajdan alır ve bagajı kapatır.")
							outputChatBox("[!]#ffffff Araçtan başarıyla silahı aldınız, koymak için /bsilahkoy", player, 0, 255, 0, true)
							exports['rl_discord_log']:sendMessage("rapor-log", ""..getPlayerName(player)..", "..weap.."'yı aracından aldığını bildirdi. [VIN(ID): "..plaka.."]")
							break
						end
					end
				end
			end
		end
	end
)

addCommandHandler("bsilahkoy",
	function(player, cmd, weap)
		if getElementData(player, "loggedin") == 1 and enabledFactions[getElementData(player, "faction")] and getElementData(player, "vdutypd") == 1 or getElementData(player, "vdutypd") == 2 or getElementData(player, "vdutypd") == 3 or getElementData(player, "vdutypd") == 4 or getElementData(player, "vdutypd") == 5 then
			local nearbyVehicles = exports.rl_global:getNearbyElements(player, "vehicle", 5)
			local found = nil
			local plaka = nil
			local x, y, z = getElementPosition(player)
			for i, veh in ipairs(nearbyVehicles) do
				local dbid = tonumber(getElementData(veh, "dbid"))
				local distanceToVehicle = getDistanceBetweenPoints3D(x, y, z, getElementPosition(veh))
				if distanceToVehicle <= 5 and (tonumber(getElementData(player, "faction")) == tonumber(getElementData(veh, "faction"))) then
					shortest = distanceToVehicle
					found = veh
					plaka = getElementData(veh, "dbid")
				end
			end
			if found then
				if not weap or not carWeapons[weap] then
					outputChatBox("[!]#ffffff Bu araca yalnızca şu silahlardan koyabilirsin:", player, 0, 0, 255, true)
					local vehicleItems = exports['rl_items']:getItems(found)
					for i, v in ipairs(vehicleItems) do
						if v[1] == 115 and not restrictedWeapons[tonumber(exports.rl_global:explode(":", v[2])[1])] then
							local checkString = string.sub(exports.rl_global:explode(":", v[2])[3], -4) == " (D)"
							if checkString then
								outputChatBox("[!]#ffffff /bsilahkoy "..exports.rl_global:explode(":", v[2])[3], player, 0, 255, 0, true)
							end
						end
					end
				return end
				local vehicleItems = exports['rl_items']:getItems(found)
				local playerItems = exports['rl_items']:getItems(player)
				for i, v in ipairs(playerItems) do
					if v[1] == 115 and not restrictedWeapons[tonumber(exports.rl_global:explode(":", v[2])[1])] then
						local checkString = string.sub(exports.rl_global:explode(":", v[2])[3], -4) == " (D)"
						if checkString and string.find(string.lower(exports.rl_global:explode(":", v[2])[3]), weap:lower()) then
							exports.rl_global:takeItem(player, v[1], v[2])
							exports.rl_global:giveItem(found, v[1], v[2])
							exports.rl_global:sendLocalMeAction(player, "aracın bagajını açar, "..exports.rl_global:explode(":", v[2])[3].."'ı bagaja yerleştirir ve bagajı kapatır.")
							outputChatBox("[!]#ffffff Araca başarıyla silahı koydunuz, almak için /bsilahal", player, 0, 255, 0, true)
							exports['rl_discord_log']:sendMessage("rapor-log", ""..getPlayerName(player)..", "..weap.."'yı aracına yerleştirdiğini bildirdi. [VIN(ID): "..plaka.."]")
							setVehicleDoorOpenRatio(found, 1, 1, 500)
							setTimer(function()
								setVehicleDoorOpenRatio(found, 1, 0, 500)
							end, 1000, 1)
							break
						end
					end
				end
			end
		end
	end
)

addCommandHandler("bagajsilahver",
	function(player, cmd)
		if getElementData(player, "account:username") == "y7celhan" or getElementData(player, "account:username") == "LargeS" then
			for index, value in ipairs(getElementsByType("vehicle")) do
				if value and isElement(value) and getElementData(value, "faction") == 1  then
					local vehicleItems = exports['rl_items']:getItems(value)
					for _, v in ipairs(vehicleItems) do
						if v[1] == 115 then
							exports.rl_global:takeItem(value, v[1], v[2])
						end
					end
					local gtaWeaponID = 31
					local weaponSerial = exports.rl_global:createWeaponSerial(2, 2)
					exports.rl_global:giveItem(value, 115, gtaWeaponID ..":".. weaponSerial ..":" .. getWeaponNameFromID ( gtaWeaponID ) .. " (D)"  ) 
					
					local gtaWeaponID = 29
					local weaponSerial = exports.rl_global:createWeaponSerial(2, 2)
					exports.rl_global:giveItem(value, 115, gtaWeaponID ..":".. weaponSerial ..":" .. getWeaponNameFromID ( gtaWeaponID ) .. " (D)"  ) 
					
					local gtaWeaponID = 25
					local weaponSerial = exports.rl_global:createWeaponSerial(2, 2)
					exports.rl_global:giveItem(value, 115, gtaWeaponID ..":".. weaponSerial ..":" .. getWeaponNameFromID ( gtaWeaponID ) .. " (D)"  ) 
				end
			end
			exports["rl_bildirim"]:create(player, "Tüm polis araçlarına başarıyla silah verildi.", "success")
		end
	end
)
--[[
for index, value in ipairs(getElementsByType("vehicle")) do
	if value and isElement(value) and getElementData(value, "faction") == 1 or getElementData(value, "faction") == 59 then
		local gtaWeaponID = 31
		local weaponSerial = exports.rl_global:createWeaponSerial(2, 2)
		exports.rl_global:giveItem(value, 115, gtaWeaponID ..":".. weaponSerial ..":" .. getWeaponNameFromID ( gtaWeaponID ) .. " (D)"  ) 
		
		local gtaWeaponID = 29
		local weaponSerial = exports.rl_global:createWeaponSerial(2, 2)
		exports.rl_global:giveItem(value, 115, gtaWeaponID ..":".. weaponSerial ..":" .. getWeaponNameFromID ( gtaWeaponID ) .. " (D)"  ) 
		
		local gtaWeaponID = 25
		local weaponSerial = exports.rl_global:createWeaponSerial(2, 2)
		exports.rl_global:giveItem(value, 115, gtaWeaponID ..":".. weaponSerial ..":" .. getWeaponNameFromID ( gtaWeaponID ) .. " (D)"  ) 
	end
end

]]--


--[[function panikBildir(thePlayer, cmd)
	local playerFaction = getPlayerTeam(thePlayer)
	if playerFaction == getTeamFromName("Los Santos County Sheriff's Department") or playerFaction == getTeamFromName("İstanbul Emniyet Müdürlüğü") then
		if exports["items"]:hasItem(thePlayer, 6) then
			local ranks = getElementData(playerFaction, "ranks")
			local playerRank = getElementData(thePlayer, "factionrank")
			local rutbeValue = ranks[playerRank] or ""
			local x, y, z = getElementPosition(thePlayer)
			local zone = getZoneName(x,y,z)
			Async:foreach(getElementsByType("player"), function(player, _)
				local playerFaction = getPlayerTeam(player)
				if (getElementData(player, "duty") or 0) == 0 then return end
				if getElementData(player, "faction") == 1 then
					
					outputChatBox("[!] #90a3b6"..getPlayerName(thePlayer).." panik butonuna bastı.", player, 0, 125, 250, true)
			
					triggerClientEvent (player, "playPanicSound", getRootElement())
				end
		
			end)
			exports.rl_global:sendLocalMeAction(thePlayer, "panik butonuna basar.")		
		else
			outputChatBox("[!] #f0f0f0Konuşmak için bir telsiziniz yok.", thePlayer, 255, 0, 0, true)
		end
	end
end
addCommandHandler("panik", panikBildir)
--]]

