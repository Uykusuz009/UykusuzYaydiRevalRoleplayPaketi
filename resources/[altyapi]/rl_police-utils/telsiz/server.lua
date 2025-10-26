local r, g, b = 255, 255, 255

function operator(thePlayer, commandName, ...)
	if getElementData(thePlayer, "logged") == true then
		if (...) then
			if getElementData(thePlayer, "faction") == 1 or getElementData(thePlayer, "faction") == 2 or getElementData(thePlayer, "faction") == 3 then
				if (getElementData(thePlayer, "restrain") ~= 1) or (getElementData(thePlayer, "dead") ~= 1) then
					local theTeam = getPlayerTeam(thePlayer)
					local factionRank = tonumber(getElementData(thePlayer, "factionrank"))
					local factionRanks = getElementData(theTeam, "ranks")
					local factionRankTitle = factionRanks[factionRank]
					local message = table.concat({...}, " ")
					local playerName = getPlayerName(thePlayer):gsub("_", " ")

					for k, arrayPlayer in ipairs(getElementsByType("player")) do
						if getElementData(arrayPlayer, "faction") == 1 or getElementData(arrayPlayer, "faction") == 2 or getElementData(arrayPlayer, "faction") == 3 then
							if getElementData(thePlayer, "faction") == 1 then
								r, g, b = 48, 128, 255
							elseif getElementData(thePlayer, "faction") == 2 then
								r, g, b = 175, 50, 50
							elseif getElementData(thePlayer, "faction") == 3 then
								r, g, b = 74, 104, 44
							end
							
							outputChatBox("[OPERATOR] " .. factionRankTitle .. " " .. playerName .. ": " .. message, arrayPlayer, r, g, b, true)
							triggerClientEvent(arrayPlayer, "playRadioSound", arrayPlayer)
						end
					end
				else
					outputChatBox("[!]#FFFFFF Kelepçeli veya baygın durumdayken telsizi kullanamazsınız.", thePlayer, 255, 0, 0, true)
					playSoundFrontEnd(thePlayer, 4)
				end
			else
				outputChatBox("[!]#FFFFFF Bu işlemi yalnızca legal birlik üyeleri yapabilir.", thePlayer, 255, 0, 0, true)
				playSoundFrontEnd(thePlayer, 4)
			end
		else
			outputChatBox("KULLANIM: /" .. commandName .. " [Mesaj]", thePlayer, 255, 194, 14)
		end
	end
end
addCommandHandler("op", operator, false, false)
addCommandHandler("operator", operator, false, false)

function yakaTelsiz(thePlayer, commandName, ...)
	if getElementData(thePlayer, "logged") == true then
		if (...) then
			if getElementData(thePlayer, "faction") == 1 or getElementData(thePlayer, "faction") == 2 or getElementData(thePlayer, "faction") == 3 then
				if (getElementData(thePlayer, "restrain") ~= 1) or (getElementData(thePlayer, "dead") ~= 1) then
					local theTeam = getPlayerTeam(thePlayer)
					local factionRank = tonumber(getElementData(thePlayer, "factionrank"))
					local factionRanks = getElementData(theTeam, "ranks")
					local factionRankTitle = factionRanks[factionRank]
					local message = table.concat({...}, " ")
					local playerName = getPlayerName(thePlayer):gsub("_", " ")
					
					for k, arrayPlayer in ipairs(getElementsByType("player")) do
						if getElementData(arrayPlayer, "faction") == 1 or getElementData(arrayPlayer, "faction") == 2 or getElementData(arrayPlayer, "faction") == 3 then
							if getElementData(thePlayer, "faction") == 1 then
								r, g, b = 48, 128, 255
							elseif getElementData(thePlayer, "faction") == 2 then
								r, g, b = 175, 50, 50
							elseif getElementData(thePlayer, "faction") == 3 then
								r, g, b = 74, 104, 44
							end
							
							outputChatBox("** [CH: 155 S: YAKIN] " .. factionRankTitle .. " " .. playerName .. ": " .. message, arrayPlayer, r, g, b, true)
							triggerClientEvent(arrayPlayer, "playRadioSound", arrayPlayer)
						end
					end
				else
					outputChatBox("[!]#FFFFFF Kelepçeli veya baygın durumdayken telsizi kullanamazsınız.", thePlayer, 255, 0, 0, true)
					playSoundFrontEnd(thePlayer, 4)
				end
			else
				outputChatBox("[!]#FFFFFF Bu işlemi yalnızca legal birlik üyeleri yapabilir.", thePlayer, 255, 0, 0, true)
				playSoundFrontEnd(thePlayer, 4)
			end
		else
			outputChatBox("KULLANIM: /" .. commandName .. " [Mesaj]", thePlayer, 255, 194, 14)
		end
	end
end
addCommandHandler("yt", yakaTelsiz, false, false)
addCommandHandler("yakatelsiz", yakaTelsiz, false, false)

function telsiz(thePlayer, commandName, ...)
	if getElementData(thePlayer, "logged") == true then
		if (...) then
			if getElementData(thePlayer, "faction") == 1 or getElementData(thePlayer, "faction") == 2 or getElementData(thePlayer, "faction") == 3 then
				if (getElementData(thePlayer, "restrain") ~= 1) or (getElementData(thePlayer, "dead") ~= 1) then
					local theTeam = getPlayerTeam(thePlayer)
					local factionRank = tonumber(getElementData(thePlayer, "factionrank"))
					local factionRanks = getElementData(theTeam, "ranks")
					local factionRankTitle = factionRanks[factionRank]
					local message = table.concat({...}, " ")
					local playerName = getPlayerName(thePlayer):gsub("_", " ")
					
					for k, arrayPlayer in ipairs(getElementsByType("player")) do
						if getElementData(arrayPlayer, "faction") == 1 or getElementData(arrayPlayer, "faction") == 2 or getElementData(arrayPlayer, "faction") == 3 then
							if getElementData(thePlayer, "faction") == 1 then
								r, g, b = 48, 128, 255
							elseif getElementData(thePlayer, "faction") == 2 then
								r, g, b = 175, 50, 50
							elseif getElementData(thePlayer, "faction") == 3 then
								r, g, b = 74, 104, 44
							end
							
							outputChatBox("** [CH: 155] " .. factionRankTitle .. " " .. playerName .. ": " .. message, arrayPlayer, r, g, b, true)
							triggerClientEvent(arrayPlayer, "playRadioSound", arrayPlayer)
						end
					end
				else
					outputChatBox("[!]#FFFFFF Kelepçeli veya baygın durumdayken telsizi kullanamazsınız.", thePlayer, 255, 0, 0, true)
					playSoundFrontEnd(thePlayer, 4)
				end
			else
				outputChatBox("[!]#FFFFFF Bu işlemi yalnızca legal birlik üyeleri yapabilir.", thePlayer, 255, 0, 0, true)
				playSoundFrontEnd(thePlayer, 4)
			end
		else
			outputChatBox("KULLANIM: /" .. commandName .. " [Mesaj]", thePlayer, 255, 194, 14)
		end
	end
end
addCommandHandler("t", telsiz, false, false)
addCommandHandler("telsiz", telsiz, false, false)