local factionToggleState = {}

local supportPlayers = {}
local followPlayers = {}

addEventHandler("onPlayerChat", root, function(message, messageType)
    cancelEvent()
	if (messageType == 1 or not (isPedDead(source))) and (getElementData(source, "logged")) and not (messageType == 2) then
		if (messageType == 0) then
			localIC(source, message, 1)
		elseif (messageType == 1) then
			meEmote(source, "me", message)
		end
	elseif (messageType == 2) and (getElementData(source, "logged")) then
		radio(source, 1, message)
	end
end)

addEventHandler("onPlayerPrivateMessage", root, function(message, player)
	cancelEvent()
	pmPlayer(source, "pm", player, message)
end)

function localIC(source, message)
	local affectedElements = {}
	table.insert(affectedElements, source)
	
	local playerName = getPlayerName(source):gsub("_", " ")
	if exports.rl_global:getPlayerMaskState(source) then
		playerName = "Gizli [>" .. getElementData(source, "dbid") .. "]"
	end

	message = string.gsub(message, "#%x%x%x%x%x%x", "")

	local color = {0xEE, 0xEE, 0xEE}

	local focus = getElementData(source, "focus")
	local focusColor = false
	if type(focus) == "table" then
		for player, color2 in pairs(focus) do
			if player == source then
				color = color2
			end
		end
	end

	if message == ":)" then
		exports.rl_global:sendLocalMeAction(source, "gülümser.")
		return
	elseif message == ":D" then
		exports.rl_global:sendLocalMeAction(source, "kahkaha atar.")
		return
	elseif message == ";)" then
		exports.rl_global:sendLocalMeAction(source, "göz kırpar.")
		return
	elseif message == "O.o" then
		exports.rl_global:sendLocalMeAction(source, "sol kaşını havaya kaldırır.")
		return
	elseif message == "O.O" then
		exports.rl_global:sendLocalMeAction(source, "sağ kaşını havaya kaldırır.")
		return
	elseif message == "X.x" then
		exports.rl_global:sendLocalMeAction(source, "gözlerini yumar.")
		return
	elseif message == ":(" then
		exports.rl_global:sendLocalDoAction(source, "Yüzünde kederli bir ifade görüle bilir.")
		return	
	end
	
	local phone = ""
	if tonumber(getElementData(source, "callingState")) == 2 then
		phone = " (Telefon)"
	end
	
	if getElementData(source, "chat_spelling") then
		message = spellingText(message)
	end
	
	local playerVehicle = getPedOccupiedVehicle(source)
	if playerVehicle then
		local vehicle = ""
		if (exports.rl_vehicle:isVehicleWindowUp(playerVehicle)) then
			table.insert(affectedElements, playerVehicle)
			vehicle = " ((Araçta))"
		end
		outputChatBox(playerName .. phone .. vehicle .. ": " .. message, source, unpack(color))
	else
		if (getElementData(source, "talk_anim")) and (not getElementData(source, "dead")) then
			exports.rl_global:applyAnimation(source, "GANGS", "prtial_gngtlkA", 1, false, true, false)
		end
		outputChatBox(playerName .. phone .. ": " .. message, source, unpack(color))
	end

	local interior = getElementInterior(source)
	local dimension = getElementDimension(source)

	if dimension ~= 0 then
		table.insert(affectedElements, "in" .. tostring(dimension))
	end

	for key, nearbyPlayer in ipairs(getElementsByType("player")) do
		local distance = getElementDistance(source, nearbyPlayer)
		if distance <= 20 then
			local nearbyPlayerDimension = getElementDimension(nearbyPlayer)
			local nearbyPlayerInterior = getElementInterior(nearbyPlayer)
			if (nearbyPlayerDimension == dimension) and (nearbyPlayerInterior == interior) then
				if not (isPedDead(nearbyPlayer)) and (getElementData(nearbyPlayer, "logged")) and (nearbyPlayer ~= source) then
					message2 = message
					
					local pveh = getPedOccupiedVehicle(source)
					local nbpveh = getPedOccupiedVehicle(nearbyPlayer)
					local color = {0xEE, 0xEE, 0xEE}

					local focus = getElementData(nearbyPlayer, "focus")
					local focusColor = false
					if type(focus) == "table" then
						for player, color2 in pairs(focus) do
							if player == source then
								focusColor = true
								color = color2
							end
						end
					end

					if pveh then
						if (exports.rl_vehicle:isVehicleWindowUp(pveh)) then
							for i = 0, getVehicleMaxPassengers(pveh) do
								local lp = getVehicleOccupant(pveh, i)

								if (lp) and (lp ~= source) then
									outputChatBox(playerName .. " ((Araçta)): " .. message2, lp, unpack(color))
									table.insert(affectedElements, lp)
								end
							end
							table.insert(affectedElements, pveh)
							return
						end
					end

					if nbpveh and exports.rl_vehicle:isVehicleWindowUp(nbpveh) then
					else
						if not focusColor then
							if distance < 4 then
							elseif distance < 8 then
								color = {0xDD, 0xDD, 0xDD}
							elseif distance < 12 then
								color = {0xCC, 0xCC, 0xCC}
							elseif distance < 16 then
								color = {0xBB, 0xBB, 0xBB}
							else
								color = {0xAA, 0xAA, 0xAA}
							end
						end
						outputChatBox(playerName.. phone .. ": " .. message2, nearbyPlayer, unpack(color))
						table.insert(affectedElements, nearbyPlayer)
					end
				end
			end
		end
	end
end

function meEmote(thePlayer, commandName, ...)
	if not (...) then
		outputChatBox("KULLANIM: /" .. commandName .. " [Aktivite]", thePlayer, 255, 194, 14)
	else
		local message = table.concat({...}, " ")
		exports.rl_global:sendLocalMeAction(thePlayer, message, true, true)
	end
end
addCommandHandler("me", meEmote, false, false)

function doEmote(thePlayer, commandName, ...)
	if not (...) then
		outputChatBox("KULLANIM: /" .. commandName .. " [Aktivite]", thePlayer, 255, 194, 14)
	else
		local message = table.concat({...}, " ")
		exports.rl_global:sendLocalDoAction(thePlayer, message, true, true)
	end
end
addCommandHandler("do", doEmote, false, false)

function megaphoneShout(thePlayer, commandName, ...)
	if not (isPedDead(thePlayer)) and (getElementData(thePlayer, "logged")) then
		local interior = getElementInterior(thePlayer)
		local dimension = getElementDimension(thePlayer)
		local vehicle = getPedOccupiedVehicle(thePlayer)
		local seat = getPedOccupiedVehicleSeat(thePlayer)
		
		local faction = getPlayerTeam(thePlayer)
		local factionID = getElementData(thePlayer, "faction") or -1

		if (factionID == 1) or (factionID == 2) or (factionID == 3) then
			if not (...) then
				outputChatBox("KULLANIM: /" .. commandName .. " [Mesaj]", thePlayer, 255, 194, 14)
			else
				local affectedElements = {}
				local message = table.concat({...}, " ")
				
				if getElementData(thePlayer, "chat_spelling") then
					message = spellingText(message)
				end

				for index, nearbyPlayer in ipairs(getElementsByType("player")) do
					if getElementDistance(thePlayer, nearbyPlayer) < 40 then
						local nearbyPlayerDimension = getElementDimension(nearbyPlayer)
						local nearbyPlayerInterior = getElementInterior(nearbyPlayer)
						if (nearbyPlayerInterior == interior) and (nearbyPlayerDimension == dimension) then
							if not (isPedDead(nearbyPlayer)) and getElementData(nearbyPlayer, "logged") then
								table.insert(affectedElements, nearbyPlayer)
								outputChatBox("((" .. getPlayerName(thePlayer):gsub("_", " ") .. ")) Megafon <O: " .. message, nearbyPlayer, 255, 255, 0)
							end
						end
					end
				end
			end
		end
	end
end
addCommandHandler("m", megaphoneShout, false, false)

function radio(thePlayer, radioID, message)
	local customSound = false
	local affectedElements = {}
	local indirectlyAffectedElements = {}
	table.insert(affectedElements, thePlayer)
	radioID = tonumber(radioID) or 1
	local hasRadio, itemKey, itemValue, itemID = exports.rl_global:hasItem(thePlayer, 6)
	if hasRadio or getElementType(thePlayer) == "ped" or radioID == -2 then
		local theChannel = itemValue
		if radioID < 0 then
			theChannel = radioID
		elseif radioID == 1 and exports.rl_integration:isPlayerTrialAdmin(thePlayer) and tonumber(message) and tonumber(message) >= 1 and tonumber(message) <= 10 then
			return
		elseif radioID ~= 1 then
			local count = 0
			local items = exports.rl_items:getItems(thePlayer)
			for k, v in ipairs(items) do
				if v[1] == 6 then
					count = count + 1
					if count == radioID then
						theChannel = v[2]
						break
					end
				end
			end
		end

		local isRestricted, factionID = isThisFreqRestricted(theChannel)
		local playerFaction = getElementData(thePlayer, "faction")
		if theChannel == 1 or theChannel == 0 then
			outputChatBox("[!]#FFFFFF Lütfen önce radyoyu /tuneradio [kanal] ile ayarlayın.", thePlayer, 255, 0, 0, true)
            playSoundFrontEnd(thePlayer, 4)
		elseif isRestricted and tonumber(playerFaction) ~= tonumber(factionID) then
			outputChatBox("[!]#FFFFFF Bu kanala erişim izniniz yok. Lütfen radyoyu tekrar ayarlayın.", thePlayer, 255, 0, 0, true)
            playSoundFrontEnd(thePlayer, 4)
		elseif theChannel > 1 or radioID < 0 then
			local username = getPlayerName(thePlayer):gsub("_", " ")
			local channelName = "#" .. theChannel
			
			if getElementData(thePlayer, "chat_spelling") then
				message = spellingText(message)
			end
			
			local r, g, b = 0, 102, 255
			local focus = getElementData(thePlayer, "focus")
			if type(focus) == "table" then
				for player, color in pairs(focus) do
					if player == thePlayer then
						r, g, b = unpack(color)
					end
				end
			end

			if radioID == -1 then
				local teams = {
					getTeamFromName("Los Santos Police Department"),
					getTeamFromName("Los Santos Medical Department"),
					getTeamFromName("Los Santos Sheriff Department"),
					getTeamFromName("Federal Aviation Administration")
				}

				for _, faction in ipairs(teams) do
					if faction and isElement(faction) then
						for key, value in ipairs(getPlayersInTeam(faction)) do
							for _, itemRow in ipairs(exports.rl_items:getItems(value)) do
								if tonumber(itemRow[1]) and tonumber(itemRow[2]) and tonumber(itemRow[1]) == 6 and tonumber(itemRow[2]) > 0 then
									table.insert(affectedElements, value)
									break
								end
							end
						end
					end
				end

				channelName = "DEPARTMENT"
			elseif radioID == -2 then
				local a = {}
				for key, value in ipairs(exports.rl_sfia:getPlayersInAircraft()) do
					table.insert(affectedElements, value)
					a[value] = true
				end

				for key, value in ipairs(getPlayersInTeam(getTeamFromName("Federal Aviation Administration"))) do
					if not a[value] then
						for _, itemRow in ipairs(exports.rl_items:getItems(value)) do
							if (itemRow[1] == 6 and itemRow[2] > 0) then
								table.insert(affectedElements, value)
								break
							end
						end
					end
				end

				channelName = "AIR"
			elseif radioID == -3 then
				local outputDim = getElementDimension(thePlayer)
				local vehicle
				if isPedInVehicle(thePlayer) then
					vehicle = getPedOccupiedVehicle(thePlayer)
					outputDim = tonumber(getElementData(vehicle, "dbid")) + 20000
				end
				if (outputDim > 0) then
					local canUsePA = false
					if (outputDim > 20000) then
						local dbid = outputDim - 20000
						if not vehicle then
							for k, v in ipairs(exports.rl_pool:getPoolElementsByType("vehicle")) do
								if getElementData(v, "dbid") == dbid then
									vehicle = v
									break
								end
							end
						end
						if vehicle then
							canUsePA = getElementData(thePlayer, "duty_admin") or exports.rl_global:hasItem(thePlayer, 3, tonumber(dbid)) or (getElementData(thePlayer, "faction") > 0 and getElementData(thePlayer, "faction") == getElementData(vehicle, "faction"))
						end
					else
						canUsePA = getElementData(thePlayer, "duty_admin") or exports.rl_global:hasItem(thePlayer, 4, outputDim) or exports.rl_global:hasItem(thePlayer, 5, outputDim)
					end

					if not canUsePA then
						return false
					end

					local outputInt = getElementInterior(thePlayer)
					for key, value in ipairs(exports.rl_pool:getPoolElementsByType("player")) do
						if (getElementDimension(value) == outputDim) then
							if (getElementInterior(value) == outputInt or vehicle) then
								table.insert(affectedElements, value)
							end
						end
					end
					if vehicle then
						for i = 0, getVehicleMaxPassengers(vehicle) do
							local player = getVehicleOccupant(vehicle, i)
							if player then
								table.insert(affectedElements, player)
							end
						end
					end
					r, g, b = 0, 149, 255
					channelName = "SPEAKERS"
					customSound = "pa.mp3"
				else
					return false
				end
			else
				for key, value in ipairs(getElementsByType("player")) do
					if exports.rl_global:hasItem(value, 6, theChannel) then
						local isRestricted, factionID = isThisFreqRestricted(theChannel)
						local playerFaction = getElementData(value, "faction")
						if (isRestricted and tonumber(playerFaction) == tonumber(factionID)) or not isRestricted then
							table.insert(affectedElements, value)
						end
					end
				end
			end

			if channelName == "DEPARTMENT" then
				outputChatBoxCar(getPedOccupiedVehicle(thePlayer), thePlayer, "[" .. channelName .. "] " .. username, ": " .. message, {r, 162, b})
			else
				outputChatBoxCar(getPedOccupiedVehicle(thePlayer), thePlayer, "[" .. channelName .. "] " .. username, ": " .. message, {r, g, b})
			end

			for i = #affectedElements, 1, -1 do
				if not getElementData(affectedElements[i], "logged") then
					table.remove(affectedElements, i)
				end
			end

			for key, value in ipairs(affectedElements) do
				if customSound then
					triggerClientEvent(value, "playCustomChatSound", root, customSound)
				else
					triggerClientEvent(value, "playRadioSound", root)
				end
				if value ~= thePlayer then
					local r, g, b = 0, 102, 255
					local focus = getElementData(value, "focus")
					if type(focus) == "table" then
						for player, color in pairs(focus) do
							if player == thePlayer then
								r, g, b = unpack(color)
							end
						end
					end
					if channelName == "DEPARTMENT" then
					    outputChatBoxCar(getPedOccupiedVehicle(value), value, "[" .. channelName .. "] " .. username, ": " .. message2, {r, 162, b})
					else
					    outputChatBoxCar(getPedOccupiedVehicle(value), value, "[" .. channelName .. "] " .. username, ": " .. message2, {r, g, b})
					end

					if not exports.rl_global:hasItem(value, 88) then
						for k, v in ipairs(exports.rl_global:getNearbyElements(value, "player", 7)) do
							local logged2 = getElementData(v, "logged")
							if (logged2) then
								local found = false
								for kx, vx in ipairs(affectedElements) do
									if v == vx then
										found = true
										break
									end
								end

								if not found then
									local message2 = message
									local text1 = getPlayerName(value):gsub("_", " ") .. "'s Radio"
									local text2 = ": " .. message2

									if outputChatBoxCar(getPedOccupiedVehicle(value), v, text1, text2, {255, 255, 255}) then
										table.insert(indirectlyAffectedElements, v)
									end
								end
							end
						end
					end
				end
			end

			for key, value in ipairs(getElementsByType("player")) do
				if getElementDistance(thePlayer, value) < 10 then
					if (value ~= thePlayer) then
						local message2 = message
						local text1 = getPlayerName(thePlayer):gsub("_", " ") .. " [RADIO]"
						local text2 = ": " .. message2

						if outputChatBoxCar(getPedOccupiedVehicle(thePlayer), value, text1, text2, {255, 255, 255}) then
							table.insert(indirectlyAffectedElements, value)
						end
					end
				end
			end

			if #indirectlyAffectedElements > 0 then
				table.insert(affectedElements, "Indirectly Affected:")
				for k, v in ipairs(indirectlyAffectedElements) do
					table.insert(affectedElements, v)
				end
			end
		else
			outputChatBox("[!]#FFFFFF Radyonuz kapalı.", thePlayer, 255, 0, 0, true)
            playSoundFrontEnd(thePlayer, 4)
		end
	else
		outputChatBox("[!]#FFFFFF Radyonuz yok.", thePlayer, 255, 0, 0, true)
        playSoundFrontEnd(thePlayer, 4)
	end
end

function radioCommand(thePlayer, commandName, ...)
	if (...) then
		local message = table.concat({...}, " ")
		radio(thePlayer, 1, message)
	else
		outputChatBox("KULLANIM: /" .. commandName .. " [Mesaj]", thePlayer, 255, 194, 14)
	end
end
addCommandHandler("r", radioCommand, false, false)
addCommandHandler("radio", radioCommand, false, false)

function localOOC(thePlayer, commandName, ...)
	if (getElementData(thePlayer, "logged")) and not (isPedDead(thePlayer)) then
		if not (...) then
			outputChatBox("KULLANIM: /" .. commandName .. " [Mesaj]", thePlayer, 255, 194, 14)
		else
			local playerName = getPlayerName(thePlayer):gsub("_", " ")
			local interior = getElementInterior(thePlayer)
			local dimension = getElementDimension(thePlayer)
			
			if (dimension >= 1 and interior >= 1) then
				local dbid, entrance, exit, interiorType, interiorElement = exports.rl_interior:findProperty(thePlayer)
				if interiorElement then
					ooc = getElementData(interiorElement, "interiorsettings").ooc
					if ooc then
						outputChatBox("[!]#FFFFFF Bulunduğunuz mülkün sahibi bu mülkte OOC sohbetinin kullanımını yasakladı.", thePlayer, 255, 0, 0, true)
						playSoundFrontEnd(thePlayer, 4)
						return
					end
				end
			end

			local message = table.concat({...}, " ")

			local playerName = getPlayerName(thePlayer):gsub("_", " ")
			if exports.rl_global:getPlayerMaskState(thePlayer) then
				playerName = "Gizli [>" .. getElementData(thePlayer, "dbid") .. "]"
			end

			if getElementData(thePlayer, "chat_spelling") then
				message = spellingText(message)
			end
			
			local sending = "#ccffff[OOC]#ccffff " .. playerName .. "#ccffff: (( " .. message .. " ))"
			
			if exports.rl_integration:isPlayerTrialAdmin(thePlayer) and thePlayer:getData("duty_admin") and not thePlayer:getData("hidden_admin") then
				sending = "#ccffff[OOC]#FF0000 " .. playerName .. "#ccffff: (( " .. message .. " ))"
			end
			
			exports.rl_global:sendLocalText(thePlayer, sending, 220, 220, 220)
		end
	end
end
addCommandHandler("b", localOOC, false, false)
addCommandHandler("LocalOOC", localOOC, false, false)

function managerChat(thePlayer, commandName, ...)
	if exports.rl_integration:isPlayerLeaderAdmin(thePlayer) then
		if (...) then
			if getElementData(thePlayer, "hideu") then
				setElementData(thePlayer, "hideu", false)
				outputChatBox("[!]#FFFFFF Yönetici sohbeti kapatıldığı için otomatik olarak açıldı.", thePlayer, 0, 255, 0, true)
			end
			
			local message = table.concat({...}, " ")
			
			if getElementData(thePlayer, "chat_spelling") then
				message = spellingText(message)
			end
			
			for _, player in ipairs(getElementsByType("player")) do
				if exports.rl_integration:isPlayerLeaderAdmin(player) then
					local hideu = getElementData(player, "hideu") or false
					if not hideu then
						outputChatBox("[ÜYK] " .. exports.rl_global:getPlayerFullAdminTitle(thePlayer) .. ": " .. message, player, 204, 102, 255)
					end
				end
			end
			exports.rl_logs:addLog("uchat", exports.rl_global:getPlayerFullAdminTitle(thePlayer) .. ": " .. message)
		else 
			outputChatBox("KULLANIM: /" .. commandName .. " [Mesaj]", thePlayer, 255, 194, 14)
		end
	else
		outputChatBox("[!]#FFFFFF Yeterli yetkiniz yok.", thePlayer, 255, 0, 0, true)
		playSoundFrontEnd(thePlayer, 4)
	end
end
addCommandHandler("u", managerChat, false, false)

function adminChat(thePlayer, commandName, ...)
	if exports.rl_integration:isPlayerTrialAdmin(thePlayer) then
		if (...) then
			if getElementData(thePlayer, "hidea") then
				setElementData(thePlayer, "hidea", false)
				outputChatBox("[!]#FFFFFF Yetkili sohbeti kapatıldığı için otomatik olarak açıldı.", thePlayer, 0, 255, 0, true)
			end
			
			local message = table.concat({...}, " ")
			
			if getElementData(thePlayer, "chat_spelling") then
				message = spellingText(message)
			end
			
			for _, player in ipairs(getElementsByType("player")) do
				if exports.rl_integration:isPlayerTrialAdmin(player) then
					local hidea = getElementData(player, "hidea") or false
					if not hidea then
						outputChatBox("[ADM] " .. exports.rl_global:getPlayerFullAdminTitle(thePlayer) .. ": " .. message, player, 51, 255, 102)
					end
				end
			end
			exports.rl_logs:addLog("achat", exports.rl_global:getPlayerFullAdminTitle(thePlayer) .. ": " .. message)
		else 
			outputChatBox("KULLANIM: /" .. commandName .. " [Mesaj]", thePlayer, 255, 194, 14)
		end
	else
		outputChatBox("[!]#FFFFFF Yeterli yetkiniz yok.", thePlayer, 255, 0, 0, true)
		playSoundFrontEnd(thePlayer, 4)
	end
end
addCommandHandler("a", adminChat, false, false)

function warnAdmins(thePlayer, commandName, ...)
	if exports.rl_integration:isPlayerSeniorAdmin(thePlayer) then
        if (...) then
			local message = table.concat({...}, " ")
            for _, player in ipairs(getElementsByType("player")) do 
                if exports.rl_integration:isPlayerTrialAdmin(player) then
                    outputChatBox(" ", player)
                    outputChatBox("[ÖNEMLİ] " .. getElementData(thePlayer, "account_username") .. ": " .. message, player, 255, 0, 0, true)
                    outputChatBox(" ", player)
                    triggerClientEvent(player, "playCustomChatSound", root, "warn.mp3", true)
                end
            end
        else 
            outputChatBox("KULLANIM: /" .. commandName .. " [Mesaj]", thePlayer, 255, 194, 14)
        end
	else
		outputChatBox("[!]#FFFFFF Yeterli yetkiniz yok.", thePlayer, 255, 0, 0, true)
		playSoundFrontEnd(thePlayer, 4)
	end
end
addCommandHandler("warn", warnAdmins, false, false)

function toggleManagerChat(thePlayer, commandName)
	if exports.rl_integration:isPlayerLeaderAdmin(thePlayer) then
		local hideu = getElementData(thePlayer, "hideu") or false
		setElementData(thePlayer, "hideu", not hideu)
		outputChatBox("[!]#FFFFFF Yönetim sohbeti başarıyla " .. (hideu and "açıldı" or "kapatıldı") .. ".", thePlayer, 0, 255, 0, true)
	else
		outputChatBox("[!]#FFFFFF Yeterli yetkiniz yok.", thePlayer, 255, 0, 0, true)
		playSoundFrontEnd(thePlayer, 4)
	end
end
addCommandHandler("togu", toggleManagerChat, false, false)
addCommandHandler("toggleu", toggleManagerChat, false, false)

function toggleAdminChat(thePlayer, commandName)
	if exports.rl_integration:isPlayerTrialAdmin(thePlayer) then
		local hidea = getElementData(thePlayer, "hidea") or false
		setElementData(thePlayer, "hidea", not hidea)
		outputChatBox("[!]#FFFFFF Yetkili sohbeti başarıyla " .. (hidea and "açıldı" or "kapatıldı") .. ".", thePlayer, 0, 255, 0, true)
	else
		outputChatBox("[!]#FFFFFF Yeterli yetkiniz yok.", thePlayer, 255, 0, 0, true)
		playSoundFrontEnd(thePlayer, 4)
	end
end
addCommandHandler("toga", toggleAdminChat, false, false)
addCommandHandler("togglea", toggleAdminChat, false, false)

function governmentOOC(thePlayer, commandName, ...)
	if (getElementData(thePlayer, "faction") == 1) or (getElementData(thePlayer, "faction") == 2) or (getElementData(thePlayer, "faction") == 3) then
		if (...) then
			local message = table.concat({...}, " ")
			
			if getElementData(thePlayer, "chat_spelling") then
				message = spellingText(message)
			end
			
			for _, player in ipairs(getElementsByType("player")) do
				if (getElementData(player, "faction") == 1) or (getElementData(player, "faction") == 2) or (getElementData(player, "faction") == 3) then
					outputChatBox("[Hükümet OOC] " .. getPlayerName(thePlayer):gsub("_", " ") .. ": " .. message, player, 255, 255, 255)
				end
			end
		else
			outputChatBox("KULLANIM: /" .. commandName .. " [Mesaj]", thePlayer, 255, 194, 14)
		end
	else
		outputChatBox("[!]#FFFFFF Bu işlemi yalnızca legal birlik üyeleri gerçekleştirebilir.", thePlayer, 255, 0, 0, true)
		playSoundFrontEnd(thePlayer, 4)
	end
end
addCommandHandler("gooc", governmentOOC, false, false)

function governmentAnnouncement(thePlayer, commandName, ...)
	if (getElementData(thePlayer, "faction") == 1) or (getElementData(thePlayer, "faction") == 2) or (getElementData(thePlayer, "faction") == 3) then
		local theTeam = getPlayerTeam(thePlayer)
		local factionLeader = getElementData(thePlayer, "factionleader")
		
		if factionLeader > 0 then
			if (...) then
				local factionRank = tonumber(getElementData(thePlayer, "factionrank"))
				local ranks = getElementData(theTeam, "ranks")
				local factionRankTitle = ranks[factionRank]
				local message = table.concat({...}, " ")
				
				if getElementData(thePlayer, "chat_spelling") then
					message = spellingText(message)
				end
				
				for _, player in ipairs(getElementsByType("player")) do
					if getElementData(player, "logged") then
						outputChatBox(">> Hükümet Duyuru " .. factionRankTitle .. " " .. getPlayerName(thePlayer):gsub("_", " "), player, 0, 183, 239)
						outputChatBox(message, player, 0, 183, 239)
					end
				end
			else
				outputChatBox("KULLANIM: /" .. commandName .. " [Mesaj]", thePlayer, 255, 194, 14)
			end
		else
			outputChatBox("[!]#FFFFFF Bu komutu kullanma yetkiniz yok.", thePlayer, 255, 0, 0, true)
			playSoundFrontEnd(thePlayer, 4)
		end
	else
		outputChatBox("[!]#FFFFFF Bu işlemi yalnızca legal birlik üyeleri gerçekleştirebilir.", thePlayer, 255, 0, 0, true)
		playSoundFrontEnd(thePlayer, 4)
	end
end
addCommandHandler("gov", governmentAnnouncement, false, false)

function departmentRadio(thePlayer, commandName, ...)
	if (getElementData(thePlayer, "faction") == 1) or (getElementData(thePlayer, "faction") == 2) or (getElementData(thePlayer, "faction") == 3) then
		if (...) then
			local message = table.concat({...}, " ")
			radio(thePlayer, -1, message)
		else
			outputChatBox("KULLANIM: /" .. commandName .. " [Mesaj]", thePlayer, 255, 194, 14)
		end
	else
		outputChatBox("[!]#FFFFFF Bu işlemi yalnızca legal birlik üyeleri gerçekleştirebilir.", thePlayer, 255, 0, 0, true)
		playSoundFrontEnd(thePlayer, 4)
	end
end
addCommandHandler("dep", departmentRadio, false, false)
addCommandHandler("department", departmentRadio, false, false)

function icPublicAnnouncement(thePlayer, commandName, ...)
	if (...) then
		local message = table.concat({...}, " ")
		radio(thePlayer, -3, message)
	else
		outputChatBox("KULLANIM: /" .. commandName .. " [Mesaj]", thePlayer, 255, 194, 14)
	end
end
addCommandHandler("pa", icPublicAnnouncement, false, false)

function adminAnnouncement(thePlayer, commandName, ...)
	if exports.rl_integration:isPlayerGeneralAdmin(thePlayer) then
        if (...) then
			local message = table.concat({...}, " ")
			local adminName = "(" .. getElementData(thePlayer, "id") .. ") " .. exports.rl_global:getPlayerAdminTitle(thePlayer) .. " " .. getElementData(thePlayer, "account_username")
			
			if getElementData(thePlayer, "hidden_admin") then
				adminName = "Gizli Yetkili"
			end
			
			if getElementData(thePlayer, "chat_spelling") then
				message = spellingText(message)
			end
			
            for _, player in ipairs(getElementsByType("player")) do
            	if getElementData(player, "logged") then
					exports.rl_infobox:addBox(player, "announcement", adminName .. ": " .. message)
				end
            end
        else 
            outputChatBox("KULLANIM: /" .. commandName .. " [Mesaj]", thePlayer, 255, 194, 14)
        end
	else
		outputChatBox("[!]#FFFFFF Yeterli yetkiniz yok.", thePlayer, 255, 0, 0, true)
		playSoundFrontEnd(thePlayer, 4)
    end
end
addCommandHandler("duyuru", adminAnnouncement, false, false)

function globalOOC(thePlayer, commandName, ...)
	if exports.rl_integration:isPlayerLeaderAdmin(thePlayer) then
		if (...) then
			local message = table.concat({...}, " ")
			local adminName = "(" .. getElementData(thePlayer, "id") .. ") " .. exports.rl_global:getPlayerAdminTitle(thePlayer) .. " " .. getElementData(thePlayer, "account_username")
			
			if getElementData(thePlayer, "hidden_admin") then
				adminName = "Gizli Yetkili"
			end
			
			if getElementData(thePlayer, "chat_spelling") then
				message = spellingText(message)
			end
			
			for _, player in ipairs(exports.rl_pool:getPoolElementsByType("player")) do
				if getElementData(player, "logged") then
					outputChatBox("[OOC] #FF0000" .. adminName .. "#CCFFFF: " .. message .. " ))", player, 196, 255, 255, true)
				end
			end
		else
			outputChatBox("KULLANIM: /" .. commandName .. " [Mesaj]", thePlayer, 255, 194, 14)
		end
	else
		outputChatBox("[!]#FFFFFF Yeterli yetkiniz yok.", thePlayer, 255, 0, 0, true)
		playSoundFrontEnd(thePlayer, 4)
    end
end
addCommandHandler("ooc", globalOOC, false, false)
addCommandHandler("GlobalOOC", globalOOC)

function pmPlayer(thePlayer, commandName, targetPlayer, ...)
	local message = nil
	if tostring(commandName):lower() == "hızlıyanıt" and targetPlayer then
		local targetPMer = getElementData(thePlayer, "targetPMer")
		if not targetPMer or not isElement(targetPMer) or not (getElementType(targetPMer) == "player") or not (getElementData(targetPMer, "logged")) then
			outputChatBox("[!]#FFFFFF Kimse sana özel mesaj göndermedi.", thePlayer, 255, 0, 0, true)
			playSoundFrontEnd(thePlayer, 4)
			return
		end
		message = targetPlayer .. " " .. table.concat({...}, " ")
		targetPlayer = targetPMer
	else
		if not (targetPlayer) or not (...) then
			outputChatBox("KULLANIM: /" .. commandName .. " [Karakter Adı / ID] [Mesaj]", thePlayer, 255, 194, 14)
			return
		end
		message = table.concat({...}, " ")
	end

	if targetPlayer and message and getElementData(thePlayer, "logged") then
		local targetPlayer, targetPlayerName = exports.rl_global:findPlayerByPartialNick(thePlayer, targetPlayer)

		if (targetPlayer) then
			if not getElementData(targetPlayer, "logged") then
				outputChatBox("[!]#FFFFFF Bu oyuncu karakterine giriş yapmadığı için işlem gerçekleşmedi.", thePlayer, 255, 0, 0, true)
				playSoundFrontEnd(thePlayer, 4)
				return
			end

			if getElementData(thePlayer, "adminjailed") and not exports.rl_integration:isPlayerAdmin1(targetPlayer) then
				outputChatBox("[!]#FFFFFF OOC hapishanesindeyken yalnızca yetkililere özel mesaj gönderebilirsiniz.", thePlayer, 255, 0, 0, true)
				playSoundFrontEnd(thePlayer, 4)
		    	return
		    end
  
			if getElementData(thePlayer, "pm:off") then
				outputChatBox("[!]#FFFFFF Özel mesajlaşmanız devre dışı bırakıldığı için mesaj gönderemediniz.", thePlayer, 255, 0, 0, true)
				playSoundFrontEnd(thePlayer, 4)
				return
			end
  
			if getElementData(targetPlayer, "pm:off") then
				outputChatBox("[!]#FFFFFF Mesajlaştığınız oyuncu özel mesajlaşmayı kapattığı için mesaj gönderemediniz.", thePlayer, 255, 0, 0, true)
				playSoundFrontEnd(thePlayer, 4)
				return
			end

			setElementData(targetPlayer, "targetPMer", thePlayer)

			local playerName = getPlayerName(thePlayer):gsub("_", " ")
			local targetUsername1, username1 = getElementData(targetPlayer, "account_username"), getElementData(thePlayer, "account_username")

			local targetUsername = " (" .. targetUsername1 .. ")"
			local username = " (" .. username1 .. ")"

			if not exports.rl_integration:isPlayerTrialAdmin(targetPlayer) then
				username = ""
			end

			if not exports.rl_integration:isPlayerTrialAdmin(thePlayer) then
				targetUsername = ""
			end

			if getElementData(thePlayer, "chat_spelling") then
				message = spellingText(message)
			end

			local playerId = getElementData(thePlayer, "id")
			local targetId = getElementData(targetPlayer, "id")

			outputChatBox(">> (" .. targetId .. ") " .. targetPlayerName .. targetUsername .. ": " .. message, thePlayer, 255, 194, 14)
			triggerClientEvent(thePlayer, "pm.client", thePlayer)
			
			if getElementData(targetPlayer, "afk") then
				exports.rl_infobox:addBox(thePlayer, "info", "Mesaj göndermeye çalıştığınız oyuncu ALT-TAB, ancak mesajınız iletiliyor.")
			end
		
			outputChatBox("<< (" .. playerId .. ") " .. playerName .. username .. ": " .. message, targetPlayer, 255, 255, 0)
			triggerClientEvent(targetPlayer, "pm.client", targetPlayer, "<< (" .. playerId .. ") " .. playerName .. username .. ": " .. message)
		end
	end
end
addCommandHandler("pm", pmPlayer, false, false)
addCommandHandler("om", pmPlayer, false, false)
addCommandHandler("hızlıyanıt", pmPlayer, false, false)

function togPM(thePlayer, commandName)
	if exports.rl_integration:isPlayerTrialAdmin(thePlayer) or (getElementData(thePlayer, "vip") > 0) then
		if not getElementData(thePlayer, "pm:off") then
			outputChatBox("[!]#FFFFFF Özel mesajlarınızı başarıyla devre dışı bıraktınız.", thePlayer, 255, 0, 0, true)
			setElementData(thePlayer, "pm:off", true)
		else
			outputChatBox("[!]#FFFFFF Özel mesajlarınızı başarıyla etkinleştirdiniz.", thePlayer, 0, 255, 0, true)
			setElementData(thePlayer, "pm:off", false)
		end
	end	
end
addCommandHandler("pmkapat", togPM, false, false)
addCommandHandler("pmac", togPM, false, false)
addCommandHandler("togpm", togPM, false, false)

function localShout(thePlayer, commandName, ...)
	local interior = getElementInterior(thePlayer)
	local dimension = getElementDimension(thePlayer)
	local vehicle = getPedOccupiedVehicle(thePlayer)
	local seat = getPedOccupiedVehicleSeat(thePlayer)

	if not (...) then
		outputChatBox("KULLANIM: /" .. commandName .. " [Mesaj]", thePlayer, 255, 194, 14)
	else
		local affectedElements = {}
		local message = table.concat({...}, " ")
		
		if getElementData(thePlayer, "chat_spelling") then
			message = spellingText(message)
		end
		
		local r, g, b = 255, 255, 255
		local focus = getElementData(thePlayer, "focus")
		if type(focus) == "table" then
			for player, color in pairs(focus) do
				if player == thePlayer then
					r, g, b = unpack(color)
				end
			end
		end

		for index, nearbyPlayer in ipairs(getElementsByType("player")) do
			if getElementDistance(thePlayer, nearbyPlayer) < 40 then
				local nearbyPlayerDimension = getElementDimension(nearbyPlayer)
				local nearbyPlayerInterior = getElementInterior(nearbyPlayer)
				if (nearbyPlayerInterior == interior) and (nearbyPlayerDimension == dimension) then
					if not (isPedDead(nearbyPlayer)) and getElementData(nearbyPlayer, "logged") then
						table.insert(affectedElements, nearbyPlayer)
						
						local r, g, b = 255, 255, 255
						local focus = getElementData(nearbyPlayer, "focus")
						if type(focus) == "table" then
							for player, color in pairs(focus) do
								if player == thePlayer then
									r, g, b = unpack(color)
								end
							end
						end
						
						outputChatBox(getPlayerName(thePlayer):gsub("_", " ") .. " (Bağırma): " .. message .. "!", nearbyPlayer, r, g, b)
					end
				end
			end
		end
	end
end
addCommandHandler("s", localShout, false, false)

function toggleFaction(thePlayer, commandName)
	local faction = getElementData(thePlayer, "faction")
	local factionLeader = getElementData(thePlayer, "factionleader")
	local theTeam = getPlayerTeam(thePlayer)

	if factionLeader == 1 then
		if factionToggleState[faction] == false or not factionToggleState[faction] then
			factionToggleState[faction] = true
			for index, arrayPlayer in ipairs(getElementsByType("player")) do
				if isElement(arrayPlayer) then
					if getPlayerTeam(arrayPlayer) == theTeam and getElementData(thePlayer, "logged") then
						outputChatBox("[" .. getTeamName(theTeam) .. "] OOC birlik sohbeti devredışı bırakıldı.", arrayPlayer, 255, 0, 0)
					end
				end
			end
		else
			factionToggleState[faction] = false
			for index, arrayPlayer in ipairs(getElementsByType("player")) do
				if isElement(arrayPlayer) then
					if getPlayerTeam(arrayPlayer) == theTeam and getElementData(thePlayer, "logged") then
						outputChatBox("[" .. getTeamName(theTeam) .. "] OOC birlik sohbeti açıldı.", arrayPlayer, 0, 255, 0)
					end
				end
			end
		end
	end
end
addCommandHandler("togglef", toggleFaction, false, false)
addCommandHandler("togf", toggleFaction, false, false)

function toggleFactionSelf(thePlayer, commandName)
	local toggleFactionChat = getElementData(thePlayer, "toggle_faction_chat") or false
	setElementData(thePlayer, "toggle_faction_chat", not toggleFactionChat)
	outputChatBox("[!]#FFFFFF Birlik sohbet başarıyla kendinizden " .. (toggleFactionChat and "aktifleştirildi" or "kapatıldı") .. ".", thePlayer, 0, 255, 0, true)
end
addCommandHandler("togglefactionchat", toggleFactionSelf, false, false)
addCommandHandler("togglefaction", toggleFactionSelf, false, false)
addCommandHandler("togfaction", toggleFactionSelf, false, false)

function factionOOC(thePlayer, commandName, ...)
	if not (...) then
		outputChatBox("KULLANIM: /" .. commandName .. " [Mesaj]", thePlayer, 255, 194, 14)
	else
		local theTeam = getPlayerTeam(thePlayer)
		local theTeamName = getTeamName(theTeam)
		
		if not (theTeam) or (theTeamName == "Vatandaş") then
			outputChatBox("[!]#FFFFFF Hiç bir birlikde değilsiniz.", thePlayer, 255, 0, 0, true)
			playSoundFrontEnd(thePlayer, 4)
			return
		end
		
		local playerName = getPlayerName(thePlayer):gsub("_", " ")
		local playerFaction = getElementData(thePlayer, "faction")
		local factionRank = tonumber(getElementData(thePlayer, "factionrank"))
		local ranks = getElementData(theTeam, "ranks")
		local factionRankTitle = ranks[factionRank] or "Bilinmiyor"

		local affectedElements = {}
		table.insert(affectedElements, theTeam)
		local message = table.concat({...}, " ")

		if (factionToggleState[playerFaction]) then
			return
		end

		if getElementData(thePlayer, "chat_spelling") then
			message = spellingText(message)
		end

		for index, arrayPlayer in ipairs(getElementsByType("player")) do
			if isElement(arrayPlayer) then
				if getPlayerTeam(arrayPlayer) == theTeam and getElementData(arrayPlayer, "logged") and not getElementData(arrayPlayer, "toggle_faction_chat") then
					table.insert(affectedElements, arrayPlayer)
					outputChatBox("[" .. getTeamName(getPlayerTeam(thePlayer)) .. "] (" .. factionRankTitle .. ") " .. playerName .. ": " .. message, arrayPlayer, 249, 160, 41)
				end
			end
		end
	end
end
addCommandHandler("f", factionOOC, false, false)
addCommandHandler("Birlik", factionOOC)

function factionLeaderOOC(thePlayer, commandName, ...)
	if not (...) then
		outputChatBox("KULLANIM: /" .. commandName .. " [Mesaj]", thePlayer, 255, 194, 14)
	else
		local theTeam = getPlayerTeam(thePlayer)
		local theTeamName = getTeamName(theTeam)
		
		if not (theTeam) or (theTeamName == "Vatandaş") then
			outputChatBox("[!]#FFFFFF Hiç bir birlikde değilsiniz.", thePlayer, 255, 0, 0, true)
			playSoundFrontEnd(thePlayer, 4)
			return
		end
		
		local playerName = getPlayerName(thePlayer):gsub("_", " ")
		local playerFaction = getElementData(thePlayer, "faction")
		local factionRank = tonumber(getElementData(thePlayer, "factionrank"))
		local ranks = getElementData(theTeam, "ranks")
		local factionRankTitle = ranks[factionRank] or "Bilinmiyor"

		local affectedElements = {}
		table.insert(affectedElements, theTeam)
		local message = table.concat({...}, " ")

		if (factionToggleState[playerFaction]) then
			return
		end

		if getElementData(thePlayer, "chat_spelling") then
			message = spellingText(message)
		end

		for index, arrayPlayer in ipairs(getElementsByType("player")) do
			if isElement(arrayPlayer) then
				if getPlayerTeam(arrayPlayer) == theTeam and getElementData(arrayPlayer, "logged") and not getElementData(arrayPlayer, "toggle_faction_chat") and getElementData(arrayPlayer, "factionleader") == 1 then
					table.insert(affectedElements, arrayPlayer)
					outputChatBox("[" .. getTeamName(getPlayerTeam(thePlayer)) .. "] (" .. factionRankTitle .. ") " .. playerName .. ": " .. message, arrayPlayer, 176, 115, 52)
				end
			end
		end
	end
end
addCommandHandler("fl", factionLeaderOOC, false, false)

function setRadioChannel(thePlayer, commandName, slot, channel)
	slot = tonumber(slot)
	channel = tonumber(channel)

	if not channel then
		channel = slot
		slot = 1
	end

	if channel then
		if (exports.rl_global:hasItem(thePlayer, 6)) then
			local count = 0
			local items = exports.rl_items:getItems(thePlayer)
			for k, v in ipairs(items) do
				if v[1] == 6 then
					count = count + 1
					if count == slot then
						if v[2] > 0 then
							local isRestricted, factionID = isThisFreqRestricted(channel)
							local playerFaction = getElementData(thePlayer, "faction")

							if channel > 1 and channel < 1000000000 and (not isRestricted or (tonumber(playerFaction) == tonumber(factionID))) then
								if exports.rl_items:updateItemValue(thePlayer, k, channel) then
									outputChatBox("[!]#FFFFFF Radiounuz başarıyla [" .. channel.. "] kanalına bağlandıRadiounuz başarıyla [" .. channel.. "] kanalına bağlandı.", thePlayer, 0, 255, 0, true)
									triggerEvent("sendAme", thePlayer, "radyoyu sıfırlar.")
								end
							else
								outputChatBox("[!]#FFFFFF Radyonuzu bu kanala ayarlayamazsınız.", thePlayer, 255, 0, 0, true)
								playSoundFrontEnd(thePlayer, 4)
							end
						else
							outputChatBox("[!]#FFFFFF Radyonuz kapalı.", thePlayer, 255, 0, 0, true)
							playSoundFrontEnd(thePlayer, 4)
						end
						return
					end
				end
			end
			
			outputChatBox("[!]#FFFFFF O kadar çok radyonuz yok.", thePlayer, 255, 0, 0, true)
			playSoundFrontEnd(thePlayer, 4)
		else
			outputChatBox("[!]#FFFFFF Radyonuz yok.", thePlayer, 255, 0, 0, true)
			playSoundFrontEnd(thePlayer, 4)
		end
	else
		outputChatBox("KULLANIM: /" .. commandName .. " [Radyo Kanalı] [Kanal Numarası]", thePlayer, 255, 194, 14)
	end
end
addCommandHandler("tuneradio", setRadioChannel, false, false)

function toggleRadio(thePlayer, commandName, slot)
	if (exports.rl_global:hasItem(thePlayer, 6)) then
		local slot = tonumber(slot)
		local items = exports.rl_items:getItems(thePlayer)
		local titemValue = false
		local count = 0
		for k, v in ipairs(items) do
			if v[1] == 6 then
				if slot then
					count = count + 1
					if count == slot then
						titemValue = v[2]
						break
					end
				else
					titemValue = v[2]
					break
				end
			end
		end

		if titemValue < 0 then
			outputChatBox("[!]#FFFFFF Radyonuzu başarıyla açtınız.", thePlayer, 0, 255, 0, true)
			triggerEvent("sendAme", thePlayer, "radyosunu açar.")
		else
			outputChatBox("[!]#FFFFFF Radyonuzu başarıyla kapattınız.", thePlayer, 0, 255, 0, true)
			triggerEvent("sendAme", thePlayer, "radyosunu kapatır.")
		end

		local count = 0
		for k, v in ipairs(items) do
			if v[1] == 6 then
				if slot then
					count = count + 1
					if count == slot then
						exports.rl_items:updateItemValue(thePlayer, k, (titemValue < 0 and 1 or -1) * math.abs(v[2] or 1))
						break
					end
				else
					exports.rl_items:updateItemValue(thePlayer, k, (titemValue < 0 and 1 or -1) * math.abs(v[2] or 1))
				end
			end
		end
	else
		outputChatBox("[!]#FFFFFF Radyonuz yok.", thePlayer, 255, 0, 0, true)
		playSoundFrontEnd(thePlayer, 4)
	end
end
addCommandHandler("toggleradio", toggleRadio, false, false)

function localWhisper(thePlayer, commandName, targetPlayerName, ...)
	if not (targetPlayerName) or not (...) then
		outputChatBox("KULLANIM: /" .. commandName .. " [Karakter Adı / ID] [Mesaj]", thePlayer, 255, 194, 14)
	else
		local targetPlayer, targetPlayerName = exports.rl_global:findPlayerByPartialNick(thePlayer, targetPlayerName)

		if targetPlayer then
			local x, y, z = getElementPosition(thePlayer)
			local tx, ty, tz = getElementPosition(targetPlayer)

			if (getDistanceBetweenPoints3D(x, y, z, tx, ty, tz) < 3) then
				local message = table.concat({...}, " ")
				
				if getElementData(thePlayer, "chat_spelling") then
					message = spellingText(message)
				end

				triggerEvent("sendAme", thePlayer, targetPlayerName .. " kişisine fısıldar.")
				
				local r, g, b = 255, 255, 255
				local focus = getElementData(thePlayer, "focus")
				if type(focus) == "table" then
					for player, color in pairs(focus) do
						if player == thePlayer then
							r, g, b = unpack(color)
						end
					end
				end
				
				outputChatBox(getPlayerName(thePlayer):gsub("_", " ") .. " (Fısıltı): " .. message, thePlayer, r, g, b)
				
				local r, g, b = 255, 255, 255
				local focus = getElementData(targetPlayer, "focus")
				if type(focus) == "table" then
					for player, color in pairs(focus) do
						if player == thePlayer then
							r, g, b = unpack(color)
						end
					end
				end
				
				outputChatBox(getPlayerName(thePlayer):gsub("_", " ") .. " (Fısıltı): " .. message, targetPlayer, r, g, b)
				
				for _, player in ipairs(getElementsByType("player")) do
					if player ~= targetPlayer and player ~= thePlayer then
						local ax, ay, az = getElementPosition(player)
						if (getDistanceBetweenPoints3D(x, y, z, ax, ay, az) < 4) then
							local playerVeh = getPedOccupiedVehicle(thePlayer)
							local targetVeh = getPedOccupiedVehicle(targetPlayer)
							local pVeh = getPedOccupiedVehicle(player)
							if playerVeh then
								if pVeh then
									if pVeh == playerVeh then
										outputChatBox(getPlayerName(thePlayer):gsub("_", " ") .. " (Fısıltı) " .. targetPlayerName .. ": " .. message, player, 255, 255, 255)
									end
								end
							else
								outputChatBox(getPlayerName(thePlayer):gsub("_", " ") .. " (Fısıltı) " .. targetPlayerName .. ": " .. message, player, 255, 255, 255)
							end
						end
					end
				end
			else
				outputChatBox("[!]#FFFFFF " .. targetPlayerName .. " isimli oyuncudan çok uzaktasınız.", thePlayer, 255, 0, 0, true)
				playSoundFrontEnd(thePlayer, 4)
			end
		end
	end
end
addCommandHandler("w", localWhisper, false, false)

function localClose(thePlayer, commandName, ...)
	if not (...) then
		outputChatBox("KULLANIM: /" .. commandName .. " [Mesaj]", thePlayer, 255, 194, 14)
	else
		local affectedElements = {}
		local message = table.concat({...}, " ")
		
		if getElementData(thePlayer, "chat_spelling") then
			message = spellingText(message)
		end

		local playerCar = getPedOccupiedVehicle(thePlayer)
		for index, targetPlayers in ipairs(getElementsByType("player")) do
			if getElementDistance(thePlayer, targetPlayers) < 3 then
				local r, g, b = 255, 255, 255
				local focus = getElementData(targetPlayers, "focus")
				if type(focus) == "table" then
					for player, color in pairs(focus) do
						if player == thePlayer then
							r, g, b = unpack(color)
						end
					end
				end
				local pveh = getPedOccupiedVehicle(targetPlayers)
				if playerCar then
					if not exports.rl_vehicle:isVehicleWindowUp(playerCar) then
						if pveh then
							if playerCar == pveh then
								table.insert(affectedElements, targetPlayers)
								outputChatBox(getPlayerName(thePlayer):gsub("_", " ") .. " (Kısık Ses): " .. message, targetPlayers, r, g, b)
							elseif not (exports.rl_vehicle:isVehicleWindowUp(pveh)) then
								table.insert(affectedElements, targetPlayers)
								outputChatBox(getPlayerName(thePlayer):gsub("_", " ") .. " (Kısık Ses): " .. message, targetPlayers, r, g, b)
							end
						else
							table.insert(affectedElements, targetPlayers)
							outputChatBox(getPlayerName(thePlayer):gsub("_", " ") .. " (Kısık Ses): " .. message, targetPlayers, r, g, b)
						end
					else
						if pveh then
							if pveh == playerCar then
								table.insert(affectedElements, targetPlayers)
								outputChatBox(getPlayerName(thePlayer):gsub("_", " ") .. " (Kısık Ses): " .. message, targetPlayers, r, g, b)
							end
						end
					end
				else
					if pveh then
						if playerCar then
							if playerCar == pveh then
								table.insert(affectedElements, targetPlayers)
								outputChatBox(getPlayerName(thePlayer):gsub("_", " ") .. " (Kısık Ses): " .. message, targetPlayers, r, g, b)
							end
						elseif not (exports.rl_vehicle:isVehicleWindowUp(pveh)) then
							table.insert(affectedElements, targetPlayers)
							outputChatBox(getPlayerName(thePlayer):gsub("_", " ") .. " (Kısık Ses): " .. message, targetPlayers, r, g, b)
						end
					else
						table.insert(affectedElements, targetPlayers)
						outputChatBox(getPlayerName(thePlayer):gsub("_", " ") .. " (Kısık Ses): " .. message, targetPlayers, r, g, b)
					end
				end
			end
		end
	end
end
addCommandHandler("c", localClose, false, false)

function focus(thePlayer, commandName, targetPlayer, r, g, b)
	local focus = getElementData(thePlayer, "focus")
	if targetPlayer then
		local targetPlayer, targetPlayerName = exports.rl_global:findPlayerByPartialNick(thePlayer, targetPlayer)
		if targetPlayer then
			if type(focus) ~= "table" then
				focus = {}
			end

			if focus[targetPlayer] and not r then
				outputChatBox("Vurgulamayı kapatdınız: " .. string.format("#%02x%02x%02x", unpack(focus[targetPlayer])) .. targetPlayerName .. "#ffc20e.", thePlayer, 255, 194, 14, true)
				focus[targetPlayer] = nil
			else
				color = {tonumber(r) or math.random(63,255), tonumber(g) or math.random(63,255), tonumber(b) or math.random(63,255)}
				for _, v in ipairs(color) do
					if v < 0 or v > 255 then
						outputChatBox("Geçersiz renk: " .. v, thePlayer, 255, 0, 0)
						return
					end
				end

				focus[targetPlayer] = color
				outputChatBox("Vurgulamayı açtınız: " .. string.format("#%02x%02x%02x", unpack(focus[targetPlayer])) .. targetPlayerName .. "#00ff00.", thePlayer, 0, 255, 0, true)
			end
			setElementData(thePlayer, "focus", focus, false)
		end
	else
		if type(focus) == "table" then
			outputChatBox("izliyorsun: ", thePlayer, 255, 194, 14)
			for player, color in pairs(focus) do
				outputChatBox(getPlayerName(player):gsub("_", " "), thePlayer, unpack(color))
			end
		end
		outputChatBox("Birisini eklemek için, /" .. commandName .. " [player] [optional red/green/blue], to remove just /" .. commandName .. " [player] again.", thePlayer, 255, 194, 14)
	end
end
addCommandHandler("focus", focus, false, false)
addCommandHandler("highlight", focus, false, false)

function chatTemizle(thePlayer, commandName)
    if exports.rl_integration:isPlayerAdmin3(thePlayer) then
        for i = 0, 50 do
			outputChatBox(" ", root)
		end
		outputChatBox("[!]#FFFFFF " .. exports.rl_global:getPlayerFullAdminTitle(thePlayer) .. " isimli yetkili sohbeti temizledi.", root, 0, 255, 0, true)
		outputChatBox("[!]#FFFFFF Keyifli çatışmalar ve eğlenceler dileriz.", root, 0, 255, 0, true)
		exports.rl_logs:addLog("temizle", exports.rl_global:getPlayerFullAdminTitle(thePlayer) .. " isimli yetkili sohbeti temizledi.")
    end
end
addCommandHandler("temizle", chatTemizle, false, false)

function operator(thePlayer, commandName, ...)
	if (...) then
		if (getElementData(thePlayer, "faction") == 1) or (getElementData(thePlayer, "faction") == 2) or (getElementData(thePlayer, "faction") == 3) then
			if (not getElementData(thePlayer, "restrain")) or (not getElementData(thePlayer, "dead")) then
				local theTeam = getPlayerTeam(thePlayer)
				local factionRank = tonumber(getElementData(thePlayer, "factionrank"))
				local factionRanks = getElementData(theTeam, "ranks")
				local factionRankTitle = factionRanks[factionRank]
				local playerName = getPlayerName(thePlayer):gsub("_", " ")
				
				local message = table.concat({...}, " ")
				if getElementData(thePlayer, "chat_spelling") then
					message = spellingText(message)
				end

				for _, player in ipairs(getElementsByType("player")) do
					if (getElementData(player, "faction") == 1) or (getElementData(player, "faction") == 2) or (getElementData(player, "faction") == 3) then
						local r, g, b = 255, 255, 255
						if getElementData(thePlayer, "faction") == 1 then
							r, g, b = 65, 65, 255
						elseif getElementData(thePlayer, "faction") == 2 then
							r, g, b = 255, 130, 130
						elseif getElementData(thePlayer, "faction") == 3 then
							r, g, b = 0, 80, 0
						end
						
						outputChatBox("[OPERATOR] " .. factionRankTitle .. " " .. playerName .. ": " .. message, player, r, g, b, true)
						triggerClientEvent(player, "playCustomChatSound", root, "radio.mp3")
					end
				end
			else
				outputChatBox("[!]#FFFFFF Kelepçeli veya baygın durumdayken radyoyu kullanamazsınız.", thePlayer, 255, 0, 0, true)
				playSoundFrontEnd(thePlayer, 4)
			end
		else
			outputChatBox("[!]#FFFFFF Bu işlemi yalnızca hukuk derneğinin üyeleri gerçekleştirebilir.", thePlayer, 255, 0, 0, true)
			playSoundFrontEnd(thePlayer, 4)
		end
	else
		outputChatBox("KULLANIM: /" .. commandName .. " [Mesaj]", thePlayer, 255, 194, 14)
	end
end
addCommandHandler("op", operator, false, false)
addCommandHandler("operator", operator, false, false)

function yakaTelsiz(thePlayer, commandName, ...)
	if (...) then
		if (getElementData(thePlayer, "faction") == 1) or (getElementData(thePlayer, "faction") == 2) or (getElementData(thePlayer, "faction") == 3) then
			if (not getElementData(thePlayer, "restrain")) or (not getElementData(thePlayer, "dead")) then
				local theTeam = getPlayerTeam(thePlayer)
				local factionRank = tonumber(getElementData(thePlayer, "factionrank"))
				local factionRanks = getElementData(theTeam, "ranks")
				local factionRankTitle = factionRanks[factionRank]
				local playerName = getPlayerName(thePlayer):gsub("_", " ")
				
				local message = table.concat({...}, " ")
				if getElementData(thePlayer, "chat_spelling") then
					message = spellingText(message)
				end
				
				for _, player in ipairs(getElementsByType("player")) do
					if (getElementData(player, "faction") == 1) or (getElementData(player, "faction") == 2) or (getElementData(player, "faction") == 3) then
						if getElementData(thePlayer, "faction") == 1 then
							r, g, b = 65, 65, 255
						elseif getElementData(thePlayer, "faction") == 2 then
							r, g, b = 255, 130, 130
						elseif getElementData(thePlayer, "faction") == 3 then
							r, g, b = 0, 80, 0
						end
						
						outputChatBox("** [CH: 911 S: YAKIN] " .. factionRankTitle .. " " .. playerName .. ": " .. message, player, r, g, b, true)
						triggerClientEvent(player, "playCustomChatSound", root, "radio.mp3")
					end
				end
			else
				outputChatBox("[!]#FFFFFF Kelepçeli veya baygın durumdayken radyoyu kullanamazsınız.", thePlayer, 255, 0, 0, true)
				playSoundFrontEnd(thePlayer, 4)
			end
		else
			outputChatBox("[!]#FFFFFF Bu işlemi yalnızca hukuk derneğinin üyeleri gerçekleştirebilir.", thePlayer, 255, 0, 0, true)
			playSoundFrontEnd(thePlayer, 4)
		end
	else
		outputChatBox("KULLANIM: /" .. commandName .. " [Mesaj]", thePlayer, 255, 194, 14)
	end
end
addCommandHandler("yt", yakaTelsiz, false, false)
addCommandHandler("yakatelsiz", yakaTelsiz, false, false)

function telsiz(thePlayer, commandName, ...)
	if (...) then
		if (getElementData(thePlayer, "faction") == 1) or (getElementData(thePlayer, "faction") == 2) or (getElementData(thePlayer, "faction") == 3) then
			if (not getElementData(thePlayer, "restrain")) or (not getElementData(thePlayer, "dead")) then
				local theTeam = getPlayerTeam(thePlayer)
				local factionRank = tonumber(getElementData(thePlayer, "factionrank"))
				local factionRanks = getElementData(theTeam, "ranks")
				local factionRankTitle = factionRanks[factionRank]
				local playerName = getPlayerName(thePlayer):gsub("_", " ")
				
				local message = table.concat({...}, " ")
				if getElementData(thePlayer, "chat_spelling") then
					message = spellingText(message)
				end
				
				for _, player in ipairs(getElementsByType("player")) do
					if (getElementData(player, "faction") == 1) or (getElementData(player, "faction") == 2) or (getElementData(player, "faction") == 3) then
						if getElementData(thePlayer, "faction") == 1 then
							r, g, b = 65, 65, 255
						elseif getElementData(thePlayer, "faction") == 2 then
							r, g, b = 255, 130, 130
						elseif getElementData(thePlayer, "faction") == 3 then
							r, g, b = 0, 80, 0
						end
						
						outputChatBox("** [CH: 911] " .. factionRankTitle .. " " .. playerName .. ": " .. message, player, r, g, b, true)
						triggerClientEvent(player, "playCustomChatSound", root, "radio.mp3")
					end
				end
			else
				outputChatBox("[!]#FFFFFF Kelepçeli veya baygın durumdayken radyoyu kullanamazsınız.", thePlayer, 255, 0, 0, true)
				playSoundFrontEnd(thePlayer, 4)
			end
		else
			outputChatBox("[!]#FFFFFF Bu işlemi yalnızca hukuk derneğinin üyeleri gerçekleştirebilir.", thePlayer, 255, 0, 0, true)
			playSoundFrontEnd(thePlayer, 4)
		end
	else
		outputChatBox("KULLANIM: /" .. commandName .. " [Mesaj]", thePlayer, 255, 194, 14)
	end
end
addCommandHandler("t", telsiz, false, false)
addCommandHandler("telsiz", telsiz, false, false)

function supportCommand(thePlayer, commandName, reason)
	local faction = getElementData(thePlayer, "faction") or 0
	if faction == 1 or faction == 2 or faction == 3 then
		if supportPlayers[thePlayer] then
			for i, player in ipairs(getElementsByType("player")) do
				local playerFaction = getElementData(player, "faction") or 0
		    	if playerFaction == 1 or playerFaction == 2 or playerFaction == 3 then
					if faction == 1 then
						r, g, b = 65, 65, 255
					elseif faction == 2 then
						r, g, b = 255, 130, 130
					elseif faction == 3 then
						r, g, b = 0, 80, 0
					end

					triggerClientEvent(player, "police.support", player, false, thePlayer, reason, faction)
					outputChatBox("[OPERATOR] " .. getPlayerName(thePlayer):gsub("_", " ") .. " isimli kişi destek ekip çağırısını kapattı.", player, r, g, b)
		    	end
		    end
		    supportPlayers[thePlayer] = nil
		else
			for i, player in ipairs(getElementsByType("player")) do
				local playerFaction = getElementData(player, "faction") or 0
		    	if playerFaction == 1 or playerFaction == 2 or playerFaction == 3 then
		    		if faction == 1 then
						r, g, b = 65, 65, 255
					elseif faction == 2 then
						r, g, b = 255, 130, 130
					elseif faction == 3 then
						r, g, b = 0, 80, 0
					end

					triggerClientEvent(player, "police.support", player, true, thePlayer, reason, faction)
					outputChatBox("[OPERATOR] " .. getPlayerName(thePlayer):gsub("_", " ") .. " isimli kişi destek ekip çağırısı açtı.", player, r, g, b)
		    	end
		    end
		    supportPlayers[thePlayer] = true
		end
	else
		outputChatBox("[!]#FFFFFF Bu işlemi yalnızca legal birlik üyeleri yapabilir.", thePlayer, 255, 0, 0, true)
		playSoundFrontEnd(thePlayer, 4)
	end
end
addCommandHandler("destek", supportCommand, false, false)

function followCommand(thePlayer, commandName, reason)
	local faction = getElementData(thePlayer, "faction") or 0
	if faction == 1 or faction == 2 or faction == 3 then
		if followPlayers[thePlayer] then
			for i, player in ipairs(getElementsByType("player")) do
				local playerFaction = getElementData(player, "faction") or 0
		    	if playerFaction == 1 or playerFaction == 2 or playerFaction == 3 then
		    		if faction == 1 then
						r, g, b = 65, 65, 255
					elseif faction == 2 then
						r, g, b = 255, 130, 130
					elseif faction == 3 then
						r, g, b = 0, 80, 0
					end

					triggerClientEvent(player, "police.follow", player, false, thePlayer, reason, faction)
					outputChatBox("[OPERATOR] " .. getPlayerName(thePlayer):gsub("_", " ") .. " isimli kişi takip çağırısı kapattı.", player, r, g, b)
		    	end
		    end
		    followPlayers[thePlayer] = nil
		else
			for i, player in ipairs(getElementsByType("player")) do
				local playerFaction = getElementData(player, "faction") or 0
		    	if playerFaction == 1 or playerFaction == 2 or playerFaction == 3 then
		    		if faction == 1 then
						r, g, b = 65, 65, 255
					elseif faction == 2 then
						r, g, b = 255, 130, 130
					elseif faction == 3 then
						r, g, b = 0, 80, 0
					end

					triggerClientEvent(player, "police.follow", player, true, thePlayer, reason, faction)
					outputChatBox("[OPERATOR] " .. getPlayerName(thePlayer):gsub("_", " ") .. " isimli kişi takip çağırısı açtı.", player, r, g, b)
		    	end
		    end
		    followPlayers[thePlayer] = true
		end
	else
		outputChatBox("[!]#FFFFFF Bu işlemi yalnızca legal birlik üyeleri yapabilir.", thePlayer, 255, 0, 0, true)
		playSoundFrontEnd(thePlayer, 4)
	end
end
addCommandHandler("takip", followCommand, false, false)

function panicCommand(thePlayer, commandName, reason)
	local faction = getElementData(thePlayer, "faction") or 0
	if faction == 1 or faction == 2 or faction == 3 then
		if supportPlayers[thePlayer] then
			for i, player in ipairs(getElementsByType("player")) do
				local playerFaction = getElementData(player, "faction") or 0
		    	if playerFaction == 1 or playerFaction == 2 or playerFaction == 3 then
		    		if faction == 1 then
						r, g, b = 65, 65, 255
					elseif faction == 2 then
						r, g, b = 255, 130, 130
					elseif faction == 3 then
						r, g, b = 0, 80, 0
					end

					triggerClientEvent(player, "police.panic", player, false, thePlayer, reason, faction)
					outputChatBox("[OPERATOR] " .. getPlayerName(thePlayer):gsub("_", " ") .. " isimli kişi panik çağrısını kapattı.", player, r, g, b)
		    	end
		    end
		    supportPlayers[thePlayer] = nil
		else
			for i, player in ipairs(getElementsByType("player")) do
				local playerFaction = getElementData(player, "faction") or 0
		    	if playerFaction == 1 or playerFaction == 2 or playerFaction == 3 then
		    		if faction == 1 then
						r, g, b = 65, 65, 255
					elseif faction == 2 then
						r, g, b = 255, 130, 130
					elseif faction == 3 then
						r, g, b = 0, 80, 0
					end

					triggerClientEvent(player, "police.panic", player, true, thePlayer, reason, faction)
					outputChatBox("[OPERATOR] " .. getPlayerName(thePlayer):gsub("_", " ") .. " isimli kişi panik butonuna basar, tüm birimler desteğe yönelsin!", player, r, g, b)
		    	end
		    end
		    supportPlayers[thePlayer] = true
		end
	else
		outputChatBox("[!]#FFFFFF Bu işlemi yalnızca legal birlik üyeleri yapabilir.", thePlayer, 255, 0, 0, true)
		playSoundFrontEnd(thePlayer, 4)
	end
end
addCommandHandler("panic", panicCommand, false, false)

function payPlayer(thePlayer, commandName, targetPlayer, amount)
	if not (targetPlayer) or not (amount) or not tonumber(amount) then
		outputChatBox("KULLANIM: /" .. commandName .. " [Karakter Adı / ID] [Miktar]", thePlayer, 255, 194, 14)
	else
		local targetPlayer, targetPlayerName = exports.rl_global:findPlayerByPartialNick(thePlayer, targetPlayer)
		
		if targetPlayer then
			local x, y, z = getElementPosition(thePlayer)
			local tx, ty, tz = getElementPosition(targetPlayer)
			local distance = getDistanceBetweenPoints3D(x, y, z, tx, ty, tz)

			if (distance <= 10) then
				amount = math.floor(math.abs(tonumber(amount)))

				local hoursPlayed = getElementData(thePlayer, "hours_played")

				if (targetPlayer == thePlayer) then
					outputChatBox("[!]#FFFFFF Kendine ödeme yapamazsın.", thePlayer, 255, 0, 0, true)
					playSoundFrontEnd(thePlayer, 4)
				elseif amount <= 0 then
					outputChatBox("[!]#FFFFFF 0'dan büyük bir tutar girmelisiniz.", thePlayer, 255, 0, 0, true)
					playSoundFrontEnd(thePlayer, 4)
				elseif (hoursPlayed < 5) and (amount > 50) and not exports.rl_integration:isPlayerTrialAdmin(thePlayer) and not exports.rl_integration:isPlayerTrialAdmin(targetPlayer) then
					outputChatBox("[!]#FFFFFF 50$'dan fazla para atmadan önce en az 5 saat oynamalısınız.", thePlayer, 255, 0, 0, true)
					playSoundFrontEnd(thePlayer, 4)
				elseif exports.rl_global:hasMoney(thePlayer, amount) then
					if (hoursPlayed < 5) and not exports.rl_integration:isPlayerTrialAdmin(targetPlayer) and not exports.rl_integration:isPlayerTrialAdmin(thePlayer) then
						local totalAmount = (getElementData(thePlayer, "pay_amount") or 0) + amount
						if totalAmount > 1000 then
							outputChatBox("[!]#FFFFFF Beş dakikada toplam 1000$ bağışlayabilirsiniz.", thePlayer, 255, 0, 0, true)
							playSoundFrontEnd(thePlayer, 4)
							return
						end
						
						setElementData(thePlayer, "pay_amount", totalAmount, false)
						
						setTimer(function(thePlayer, amount)
							if isElement(thePlayer) then
								local totalAmount = (getElementData(thePlayer, "pay_amount") or 0) - amount
								setElementData(thePlayer, "pay_amount", totalAmount <= 0 and false or totalAmount, false)
							end
						end, 300000, 1, thePlayer, amount)
					end
					
					exports.rl_global:takeMoney(thePlayer, amount)
					exports.rl_global:giveMoney(targetPlayer, amount)

					triggerEvent("sendAme", thePlayer, "elini cebine atar, cüzdanından birkaç miktar para alır ve " .. targetPlayerName .. "'e verir.")
					outputChatBox("[!]#FFFFFF Başarıyla $" ..  exports.rl_global:formatMoney(amount) .. " parayı " .. targetPlayerName .. " isimli oyuncuya verdiniz.", thePlayer, 0, 255, 0, true)
					outputChatBox("[!]#FFFFFF " .. getPlayerName(thePlayer):gsub("_", " ") .. " isimli oyuncu size $" .. exports.rl_global:formatMoney(amount) .. " para verdi.", targetPlayer, 0, 255, 0, true)
					exports.rl_logs:addLog("paraver", getPlayerName(thePlayer):gsub("_", " ") .. " isimli oyuncu " .. targetPlayerName .. " isimli oyuncuya $" .. exports.rl_global:formatMoney(amount) .. " para verdi.")
					exports.rl_global:applyAnimation(thePlayer, "DEALER", "shop_pay", 4000, false, true, true)
					
				else
					outputChatBox("[!]#FFFFFF Yeterli paranız yok.", thePlayer, 255, 0, 0, true)
					playSoundFrontEnd(thePlayer, 4)
				end
			else
				outputChatBox("[!]#FFFFFF " .. targetPlayerName .. " isimli oyuncudan çok uzaksınız.", thePlayer, 255, 0, 0, true)
				playSoundFrontEnd(thePlayer, 4)
			end
		end
	end
end
addCommandHandler("paraver", payPlayer, false, false)

function sendStatus(thePlayer, commandName, ...)
	if not (...) then
		removeElementData(thePlayer, "chat_status")
		return
	end
	local message = table.concat({...}, " ")
	setElementData(thePlayer, "chat_status", message)
	outputChatBox("[!]#FFFFFF Statusunuzu başarıyla değiştirdiniz.", thePlayer, 0, 255, 0, true)
end
addCommandHandler("status", sendStatus, false, false)

addCommandHandler("zarat100", function(thePlayer)
	exports.rl_global:sendLocalText(thePlayer, "✪ " .. getPlayerName(thePlayer):gsub("_", " ") .. " zar attı. ((" .. math.random(1, 100) .. "))", 102, 255, 255)	
end)

function tryLuck(thePlayer, commandName, pa1, pa2)
	local p1, p2, p3 = nil
	p1 = tonumber(pa1)
	p2 = tonumber(pa2)
	if pa1 == nil and pa2 == nil and pa3 == nil then
		exports.rl_global:sendLocalText(thePlayer, "((OOC Şans)) " .. getPlayerName(thePlayer):gsub("_", " ") .. " isimli kişi 1 ile 100 arasında şansını denedi ve " .. math.random(100) .. " sayı geliyor.", 255, 51, 102, 30, {}, true)
	elseif pa1 ~= nil and p1 ~= nil and pa2 == nil then
		exports.rl_global:sendLocalText(thePlayer, "((OOC Şans)) " .. getPlayerName(thePlayer):gsub("_", " ") .. " isimli kişi 1 ile " .. p1 .. " ve arasında şansını denedi " .. math.random(p1) .. " sayı geliyor.", 255, 51, 102, 30, {}, true)
	else
		outputChatBox("KULLANIM: /" .. commandName .. " [1-(+∞)]", thePlayer, 255, 194, 14)
	end
end
addCommandHandler("sans", tryLuck, false, false)

function tryChance(thePlayer, commandName , pa1, pa2)
	local p1, p2, p3 = nil
	p1 = tonumber(pa1)
	p2 = tonumber(pa2)
	if pa1 ~= nil then 
		if pa2 == nil and p1 ~= nil then
			if p1 <= 100 and p1 >=0 then
				if math.random(100) >= p1 then
					exports.rl_global:sendLocalText(thePlayer, "((OOC Şans - %" .. p1 .. ")) " .. getPlayerName(thePlayer):gsub("_", " ") .. " isimli kişi denemesi başarısızlıkla sonuçlandı.", 255, 51, 102, 30, {}, true)
				else
					exports.rl_global:sendLocalText(thePlayer, "((OOC Şans - %" .. p1 .. ")) " .. getPlayerName(thePlayer):gsub("_", " ") .. " isimli kişi denemesi başarılı oldu.", 255, 51, 102, 30, {}, true)
				end
			else
				outputChatBox("KULLANIM: /" .. commandName .. " [0-100]", thePlayer, 255, 194, 14)
			end
		else
			outputChatBox("KULLANIM: /" .. commandName .. " [0-100]", thePlayer, 255, 194, 14)
		end
	else
		outputChatBox("KULLANIM: /" .. commandName .. " [0-100]", thePlayer, 255, 194, 14)
	end
end
addCommandHandler("chance", tryChance, false, false)
addCommandHandler("sans2", tryChance, false, false)

addCommandHandler("imla", function(thePlayer, commandName)
	outputChatBox("[!]#FFFFFF Otomatik imla modu başarıyla " .. (not getElementData(thePlayer, "chat_spelling") and "açıldı" or "kapandı") .. ", " .. (getElementData(thePlayer, "chat_spelling") and "açmak" or "kapatmak") .. " için tekrardan /" .. commandName .. " yazın.", thePlayer, 0, 255, 0, true)
	setElementData(thePlayer, "chat_spelling", not getElementData(thePlayer, "chat_spelling") and true or false)
end, false, false)

addCommandHandler("talkanim", function(thePlayer, commandName)
	outputChatBox("[!]#FFFFFF Otomatik konuşma animasyonu başarıyla " .. (not getElementData(thePlayer, "talk_anim") and "açıldı" or "kapandı") .. ", " .. (getElementData(thePlayer, "talk_anim") and "açmak" or "kapatmak") .. " için tekrardan /" .. commandName .. " yazın.", thePlayer, 0, 255, 0, true)
	setElementData(thePlayer, "talk_anim", not getElementData(thePlayer, "talk_anim") and true or false)
end, false, false)

addEventHandler("onPlayerQuit", root, function()
	for _, player in ipairs(getElementsByType("player")) do
		if player ~= source then
			local focus = getElementData(player, "focus")
			if focus and focus[source] then
				focus[source] = nil
				setElementData(player, "focus", focus, false)
			end
		end
	end
	
	if supportPlayers[source] then
		local faction = getElementData(source, "faction") or 0
		for i, player in ipairs(getElementsByType("player")) do
			local playerFaction = getElementData(player, "faction") or 0
			if playerFaction == 1 or playerFaction == 2 or playerFaction == 3 then
				if faction == 1 then
					r, g, b = 65, 65, 255
				elseif faction == 2 then
					r, g, b = 255, 130, 130
				elseif faction == 3 then
					r, g, b = 0, 80, 0
				end
	
				triggerClientEvent(player, "LSPD.destek", player, false, source, "", faction)
				outputChatBox("[OPERATOR] " .. getPlayerName(source):gsub("_", " ") .. " isimli kişi destek çağrısını kapattı.", player, r, g, b)
			end
		end
		supportPlayers[source] = nil
	end
	
	if followPlayers[source] then
		local faction = getElementData(source, "faction") or 0
		for i, player in ipairs(getElementsByType("player")) do
			local playerFaction = getElementData(player, "faction") or 0
			if playerFaction == 1 or playerFaction == 2 or playerFaction == 3 then
				if faction == 1 then
					r, g, b = 65, 65, 255
				elseif faction == 2 then
					r, g, b = 255, 130, 130
				elseif faction == 3 then
					r, g, b = 0, 80, 0
				end

				triggerClientEvent(player, "LSPD.takip", player, false, source, "", faction)
				outputChatBox("[OPERATOR] " .. getPlayerName(source):gsub("_", " ") .. " isimli kişi takip çağırısı kapattı.", player, r, g, b)
			end
		end
		followPlayers[source] = nil
	end
end)

function trunklateText(text)
	return (tostring(text):gsub("^%l", string.upper))
end

function spellingText(text)
    if type(text) == "string" then
        text = trunklateText(text)
        
        if string.sub(text, -1) ~= "." and string.sub(text, -1) ~= "!" and string.sub(text, -1) ~= "?" then
            text = text .. "."
        end
    end
    
    return text
end

function getElementDistance(thePlayer, targetPlayer)
	if not isElement(thePlayer) or not isElement(targetPlayer) or getElementDimension(thePlayer) ~= getElementDimension(targetPlayer) then
		return math.huge
	else
		local x, y, z = getElementPosition(thePlayer)
		return getDistanceBetweenPoints3D(x, y, z, getElementPosition(targetPlayer))
	end
end

function isThisFreqRestricted()
	return false
end

function outputChatBoxCar(vehicle, targetPMer, text1, text2, color)
	if vehicle and exports.rl_vehicle:isVehicleWindowUp(vehicle) then
		if getPedOccupiedVehicle(targetPMer) == vehicle then
			outputChatBox(text1 .. " ((Araçta))" .. text2, targetPMer, unpack(color))
			return true
		else
			return false
		end
	end
	outputChatBox(text1 .. text2, targetPMer, unpack(color))
	return true
end