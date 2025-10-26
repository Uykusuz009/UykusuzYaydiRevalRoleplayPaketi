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
		matchPlayer = nil
		for i, player in pairs(getElementsByType("player")) do
			if getElementData(player, "id") == tonumber(targetPlayer) then
				matchPlayer = player
				break
			end
		end
		candidates = { matchPlayer }
	else
		local players = getElementsByType("player")
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
						matchNickAccuracy = posEnd-posStart
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
					outputChatBox("[!]#FFFFFF Eşleşecek kimse bulunamadı.", 255, 0, 0, true)
					playSoundFrontEnd(4)
				end
			else
				outputChatBox("[!]#FFFFFF Toplam " .. #candidates .. " oyuncu eşleşiyor:", 0, 0, 255, true)
				for _, arrayPlayer in ipairs(candidates) do
					outputChatBox(">>#FFFFFF (" .. tostring(getElementData(arrayPlayer, "id")) .. ") " .. getPlayerName(arrayPlayer):gsub("_", " "), 0, 255, 0, true)
				end
			end
		end
		return false
	else
		return matchPlayer, getPlayerName(matchPlayer):gsub("_", " ")
	end
end