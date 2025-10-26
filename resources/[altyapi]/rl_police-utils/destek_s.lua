local destekPlayers = {}
local takipPlayers = {}

function destekMain(thePlayer, commandName, reason)
	local faction = getElementData(thePlayer, "faction") or 0
	if faction == 1 or faction == 2 or faction == 3 then
		if destekPlayers[thePlayer] then
			for i, player in ipairs(getElementsByType("player")) do
				local playerFaction = getElementData(player, "faction") or 0
		    	if playerFaction == 1 or playerFaction == 2 or playerFaction == 3 then
					if faction == 1 then
						r, g, b = 48, 128, 255
					elseif faction == 2 then
						r, g, b = 175, 50, 50
					elseif faction == 3 then
						r, g, b = 74, 104, 44
					end

					triggerClientEvent(player, "lspd:destek", player, false, thePlayer, reason, faction)
					outputChatBox("[OPERATOR] " .. getPlayerName(thePlayer):gsub("_", " ") .. " isimli kişi destek ekip çağırısını kapattı.", player, r, g, b)
		    	end
		    end
		    destekPlayers[thePlayer] = nil
		else
			for i, player in ipairs(getElementsByType("player")) do
				local playerFaction = getElementData(player, "faction") or 0
		    	if playerFaction == 1 or playerFaction == 2 or playerFaction == 3 then
		    		if faction == 1 then
						r, g, b = 48, 128, 255
					elseif faction == 2 then
						r, g, b = 175, 50, 50
					elseif faction == 3 then
						r, g, b = 74, 104, 44
					end

					triggerClientEvent(player, "lspd:destek", player, true, thePlayer, reason, faction)
					outputChatBox("[OPERATOR] " .. getPlayerName(thePlayer):gsub("_", " ") .. " isimli kişi destek ekip çağırısı açtı.", player, r, g, b)
		    	end
		    end
		    destekPlayers[thePlayer] = true
		end
	else
		outputChatBox("[!]#FFFFFF Bu işlemi yalnızca legal birlik üyeleri yapabilir.", thePlayer, 255, 0, 0, true)
		playSoundFrontEnd(thePlayer, 4)
	end
end
addCommandHandler("destek", destekMain)

function takipMain(thePlayer, commandName, reason)
	local faction = getElementData(thePlayer, "faction") or 0
	if faction == 1 or faction == 2 or faction == 3 then
		if takipPlayers[thePlayer] then
			for i, player in ipairs(getElementsByType("player")) do
				local playerFaction = getElementData(player, "faction") or 0
		    	if playerFaction == 1 or playerFaction == 2 or playerFaction == 3 then
		    		if faction == 1 then
						r, g, b = 48, 128, 255
					elseif faction == 2 then
						r, g, b = 175, 50, 50
					elseif faction == 3 then
						r, g, b = 74, 104, 44
					end

					triggerClientEvent(player, "lspd:takip", player, false, thePlayer, reason, faction)
					outputChatBox("[OPERATOR] " .. getPlayerName(thePlayer):gsub("_", " ") .. " isimli kişi takip çağırısı kapattı.", player, r, g, b)
		    	end
		    end
		    takipPlayers[thePlayer] = nil
		else
			for i, player in ipairs(getElementsByType("player")) do
				local playerFaction = getElementData(player, "faction") or 0
		    	if playerFaction == 1 or playerFaction == 2 or playerFaction == 3 then
		    		if faction == 1 then
						r, g, b = 48, 128, 255
					elseif faction == 2 then
						r, g, b = 175, 50, 50
					elseif faction == 3 then
						r, g, b = 74, 104, 44
					end

					triggerClientEvent(player, "lspd:takip", player, true, thePlayer, reason, faction)
					outputChatBox("[OPERATOR] " .. getPlayerName(thePlayer):gsub("_", " ") .. " isimli kişi takip çağırısı açtı.", player, r, g, b)
		    	end
		    end
		    takipPlayers[thePlayer] = true
		end
	else
		outputChatBox("[!]#FFFFFF Bu işlemi yalnızca legal birlik üyeleri yapabilir.", thePlayer, 255, 0, 0, true)
		playSoundFrontEnd(thePlayer, 4)
	end
end
addCommandHandler("takip", takipMain)

function panikMain(thePlayer, commandName, reason)
	local faction = getElementData(thePlayer, "faction") or 0
	if faction == 1 or faction == 2 or faction == 3 then
		if destekPlayers[thePlayer] then
			for i, player in ipairs(getElementsByType("player")) do
				local playerFaction = getElementData(player, "faction") or 0
		    	if playerFaction == 1 or playerFaction == 2 or playerFaction == 3 then
		    		if faction == 1 then
						r, g, b = 48, 128, 255
					elseif faction == 2 then
						r, g, b = 175, 50, 50
					elseif faction == 3 then
						r, g, b = 74, 104, 44
					end

					triggerClientEvent(player, "lspd:panik", player, false, thePlayer, reason, faction)
					outputChatBox("[OPERATOR] " .. getPlayerName(thePlayer):gsub("_", " ") .. " isimli kişi panik çağrısını kapattı.", player, r, g, b)
		    	end
		    end
		    destekPlayers[thePlayer] = nil
		else
			for i, player in ipairs(getElementsByType("player")) do
				local playerFaction = getElementData(player, "faction") or 0
		    	if playerFaction == 1 or playerFaction == 2 or playerFaction == 3 then
		    		if faction == 1 then
						r, g, b = 48, 128, 255
					elseif faction == 2 then
						r, g, b = 175, 50, 50
					elseif faction == 3 then
						r, g, b = 74, 104, 44
					end

					triggerClientEvent(player, "lspd:panik", player, true, thePlayer, reason, faction)
					outputChatBox("[OPERATOR] " .. getPlayerName(thePlayer):gsub("_", " ") .. " isimli kişi panik butonuna basar, tüm birimler desteğe yönelsin!", player, r, g, b)
		    	end
		    end
		    destekPlayers[thePlayer] = true
		end
	else
		outputChatBox("[!]#FFFFFF Bu işlemi yalnızca legal birlik üyeleri yapabilir.", thePlayer, 255, 0, 0, true)
		playSoundFrontEnd(thePlayer, 4)
	end
end
addCommandHandler("panik", panikMain)

addEventHandler("onPlayerQuit", root, function()
	if destekPlayers[source] then
		local faction = getElementData(source, "faction") or 0
		for i, player in ipairs(getElementsByType("player")) do
			local playerFaction = getElementData(player, "faction") or 0
			if playerFaction == 1 or playerFaction == 2 or playerFaction == 3 then
				if faction == 1 then
					r, g, b = 48, 128, 255
				elseif faction == 2 then
					r, g, b = 175, 50, 50
				elseif faction == 3 then
					r, g, b = 74, 104, 44
				end
	
				triggerClientEvent(player, "lspd:destek", player, false, source, "", faction)
				outputChatBox("[OPERATOR] " .. getPlayerName(source):gsub("_", " ") .. " isimli kişi destek çağrısını kapattı.", player, r, g, b)
			end
		end
		destekPlayers[source] = nil
	end
	
	if takipPlayers[source] then
		local faction = getElementData(source, "faction") or 0
		for i, player in ipairs(getElementsByType("player")) do
			local playerFaction = getElementData(player, "faction") or 0
			if playerFaction == 1 or playerFaction == 2 or playerFaction == 3 then
				if faction == 1 then
					r, g, b = 48, 128, 255
				elseif faction == 2 then
					r, g, b = 175, 50, 50
				elseif faction == 3 then
					r, g, b = 74, 104, 44
				end

				triggerClientEvent(player, "lspd:takip", player, false, source, "", faction)
				outputChatBox("[OPERATOR] " .. getPlayerName(source):gsub("_", " ") .. " isimli kişi takip çağırısı kapattı.", player, r, g, b)
			end
		end
		takipPlayers[source] = nil
	end
end)