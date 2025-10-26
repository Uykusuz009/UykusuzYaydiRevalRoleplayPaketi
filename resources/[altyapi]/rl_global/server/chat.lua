function getNearbyElements(root, type, distance)
	local x, y, z = getElementPosition(root)
	local elements = {}
	
	for index, nearbyElement in ipairs(getElementsByType(type)) do
		if isElement(nearbyElement) and getDistanceBetweenPoints3D(x, y, z, getElementPosition(nearbyElement)) < (distance or 20) then
			if getElementDimension(root) == getElementDimension(nearbyElement) then
				table.insert(elements, nearbyElement)
			end
		end
	end
	return elements
end

function sendMessageToAdmins(message, showToOffDutyAdmins, r, g, b)
    r = r or 255
    g = g or 0
    b = b or 0

    for _, player in pairs(exports.rl_pool:getPoolElementsByType("player")) do
        if exports.rl_integration:isPlayerTrialAdmin(player) then
            if showToOffDutyAdmins or getElementData(player, "duty_admin") then
                outputChatBox(message, player, r, g, b)
            end
        end
    end
end

function findPlayerByPartialNick(thePlayer, targetPlayer, fromBankSystem)
	if not targetPlayer and not isElement(thePlayer) and type(thePlayer) == "string" then
		outputDebugString("Incorrect Parameters in findPlayerByPartialNick")
		targetPlayer = thePlayer
		thePlayer = nil
	end
	
	local candidates = {}
	local matchPlayer = nil
	local matchNick = nil
	local matchNickAccuracy = -1
	
	if type(targetPlayer) == "string" then
		targetPlayer = string.lower(targetPlayer)
	elseif isElement(targetPlayer) and getElementType(targetPlayer) == "player" then
		return targetPlayer, getPlayerName(targetPlayer):gsub("_", " ")
	end

	if thePlayer and targetPlayer == "*" then
		return thePlayer, getPlayerName(thePlayer):gsub("_", " ")
	elseif type(targetPlayer) == "string" and getPlayerFromName(targetPlayer) then
		return getPlayerFromName(targetPlayer), getPlayerName(getPlayerFromName(targetPlayer)):gsub("_", " ")
	elseif tonumber(targetPlayer) then
		matchPlayer = exports.rl_pool:getElement("player", tonumber(targetPlayer))
		candidates = { matchPlayer }
	else
		local players = exports.rl_pool:getPoolElementsByType("player")
		for playerKey, arrayPlayer in ipairs(players) do
			if isElement(arrayPlayer) then
				local found = false
				local playerName = string.lower(getPlayerName(arrayPlayer))
				local posStart, posEnd = string.find(playerName, tostring(targetPlayer), 1, true)
				if not posStart and not posEnd then
					posStart, posEnd = string.find(playerName:gsub(" ", "_"), tostring(targetPlayer), 1, true)
				end

				if posStart and posEnd then
					if posEnd - posStart > matchNickAccuracy then
						matchNickAccuracy = posEnd - posStart
						matchNick = playerName
						matchPlayer = arrayPlayer
						candidates = { arrayPlayer }
					elseif posEnd - posStart == matchNickAccuracy then
						matchNick = nil
						matchPlayer = nil
						table.insert(candidates, arrayPlayer)
					end
				end
			end
		end
	end
	
	if not matchPlayer or not isElement(matchPlayer) then
		if isElement(thePlayer) then
			if #candidates == 0 then
				if not fromBankSystem then
					outputChatBox("[!]#FFFFFF Eşleşecek kimse bulunamadı.", thePlayer, 255, 0, 0, true)
					playSoundFrontEnd(thePlayer, 4)
				end
			else
				outputChatBox("[!]#FFFFFF Toplam " .. #candidates .. " oyuncu eşleşiyor:", thePlayer, 0, 0, 255, true)
				for _, arrayPlayer in ipairs(candidates) do
					outputChatBox(">>#FFFFFF (" .. tostring(getElementData(arrayPlayer, "id")) .. ") " .. getPlayerName(arrayPlayer):gsub("_", " "), thePlayer, 0, 255, 0, true)
				end
			end
		end
		return false
	else
		return matchPlayer, getPlayerName(matchPlayer):gsub("_", " ")
	end
end

function sendLocalText(root, message, r, g, b, distance, exclude, useFocusColors, ignoreDeaths)
	if client and client ~= source then
		exports.rl_ac:banForEventAbuse(client, eventName)
		return
	end
	
	exclude = exclude or {}
	local affectedPlayers = {}
	local x, y, z = getElementPosition(root)
	
	for index, nearbyPlayer in ipairs(getElementsByType("player")) do
		if isElement(nearbyPlayer) and getDistanceBetweenPoints3D(x, y, z, getElementPosition(nearbyPlayer)) < (distance or 20) then
			local logged = getElementData(nearbyPlayer, "logged")
			if not exclude[nearbyPlayer] and (ignoreDeaths or not isPedDead(nearbyPlayer)) and logged and getElementDimension(root) == getElementDimension(nearbyPlayer) then
				local r2, g2, b2 = r, g, b
				if useFocusColors then
					local focus = getElementData(nearbyPlayer, "focus")
					if type(focus) == "table" then
						for player, color in pairs(focus) do
							if player == root then
								r2, g2, b2 = unpack(color)
							end
						end
					end
				end
				
				outputChatBox(message, nearbyPlayer, r2, g2, b2, true)
				table.insert(affectedPlayers, nearbyPlayer)
			end
		end
	end
	
	return true, affectedPlayers
end
addEvent("sendLocalText", true)
addEventHandler("sendLocalText", root, sendLocalText)

function sendLocalMeAction(thePlayer, message, fromPlayer, ignoreDeaths)
	if client and client ~= source then
		exports.rl_ac:banForEventAbuse(client, eventName)
		return
	end
	
	if string.find(message, "#%x%x%x%x%x%x") then
		message = message
	end

	local name = getPlayerName(thePlayer)
	if getPlayerMaskState(thePlayer) then
		name = "Gizli [>" .. getElementData(thePlayer, "dbid") .. "]"
	end

	local state, affectedPlayers = sendLocalText(thePlayer, (fromPlayer and "*" or "*") .. " " ..  string.gsub(name, "_", " ") .. (message:sub(1, 1) == "'" and "" or " ") .. message:gsub('"([^"]-)"', '#FFFFFF "%1#FFFFFF "#dfaeff'), 223, 174, 255, 30, {}, true, ignoreDeaths, true)
	return state, affectedPlayers
end
addEvent("sendLocalMeAction", true)
addEventHandler("sendLocalMeAction", root, sendLocalMeAction)

function sendLocalDoAction(thePlayer, message, ignoreDeaths)
	if client and client ~= source then
		exports.rl_ac:banForEventAbuse(client, eventName)
		return
	end
	
	if string.find(message, "#%x%x%x%x%x%x") then
		message = message
	end
	
	local name = getPlayerName(thePlayer)
	if getPlayerMaskState(thePlayer) then
		name = "Gizli [>" .. getElementData(thePlayer, "dbid") .. "]"
	end

	local state, affectedPlayers = sendLocalText(thePlayer, "* " .. message:gsub('"([^"]-)"', '#FFFFFF "%1#FFFFFF "#84cbad') .. " ((" .. name:gsub("_", " ") .. "))", 132, 203, 173, 30, {}, true, ignoreDeaths)
	return state, affectedPlayers
end
addEvent("sendLocalDoAction", true)
addEventHandler("sendLocalDoAction", root, sendLocalDoAction)

function sendLocalChatAction(thePlayer, message, fromPlayer, ignoreDeaths)
	if client and client ~= source then
		exports.rl_ac:banForEventAbuse(client, eventName)
		return
	end
	
	if string.find(message, "#%x%x%x%x%x%x") then
		message = message
	end
	
	local name = getPlayerName(thePlayer)
	if getPlayerMaskState(thePlayer) then
		name = "Gizli [>" .. getElementData(thePlayer, "dbid") .. "]"
	end
	
	local state, affectedPlayers = sendLocalText(thePlayer, (fromPlayer and "*" or "*") .. " " ..  string.gsub(name, "_", " ") .. (message:sub(1, 1) == "'" and "" or " ") .. message:gsub('"([^"]-)"', '#FFFFFF "%1#FFFFFF "#dfaeff'), 223, 174, 255, 30, {}, true, ignoreDeaths, true)
	return state, affectedPlayers
end
addEvent("sendLocalChatAction", true)
addEventHandler("sendLocalChatAction", root, sendLocalChatAction)

addEvent("sendAme", true)
addEventHandler("sendAme", root, function(message)
	if client and client ~= source then
		exports.rl_ac:banForEventAbuse(client, eventName)
		return
	end
	return sendLocalMeAction(source, message, true, true)
end)

addEvent("sendAdo", true)
addEventHandler("sendAdo", root, function(message)
	if client and client ~= source then
		exports.rl_ac:banForEventAbuse(client, eventName)
		return
	end
	return sendLocalDoAction(source, message, true, true)
end)