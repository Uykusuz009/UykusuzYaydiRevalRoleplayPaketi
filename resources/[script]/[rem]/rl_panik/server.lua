

function panik(thePlayer, cmd, ...)
	if getElementData(thePlayer, "loggedin") == 1 then
		if getElementData(thePlayer, "faction") == 1 or getElementData(thePlayer, "faction") == 2 then
			if not getElementData(thePlayer, "panikacik") then
				if not tonumber((...)) then
					outputChatBox("İşlem: /panik [Tür]", thePlayer, 255, 194, 14)
				return end
				local theTeam = getPlayerTeam(thePlayer)
				local factionRank = tonumber(getElementData(thePlayer,"factionrank"))
				local factionRanks = getElementData(theTeam, "ranks")
				local factionRankTitle = factionRanks[factionRank]
				local tur = table.concat({...}, " ")
				local username = getPlayerName(thePlayer)
				local x, y, z = getElementPosition(thePlayer)
				local playerX, playerY, playerZ = getElementPosition(thePlayer)
				local playerZoneName = getZoneName(playerX, playerY, playerZ)
				exports.rl_global:sendLocalMeAction(thePlayer, "Sağ elini panik butonuna uzatır ve basar.")
				setElementData(thePlayer, "panikacik", true)
				setElementData(thePlayer, "panik_tur", tonumber(tur))
				for k, pdplayer in ipairs(getPlayersInTeam(getTeamFromName ("Reval İl Emniyet Mudurlugu"))) do
                    triggerClientEvent("panik:ac",pdplayer)
                    outputChatBox("#ff0000[!]" .. username:gsub("_", " ") .. " Adlı panik butonuna bastı KOD 0 KOD 3 Sağlayın Dehal!. ("..tur..")", pdplayer, 0,0,0,true)
				end

				for k, lscsdplayer in ipairs(getPlayersInTeam(getTeamFromName ("Reval İl Saglik Mudurlugu"))) do
                    triggerClientEvent("panik:ac",lscsdplayer)
                    outputChatBox("#ff0000[!]" .. username:gsub("_", " ") .. "Adlı panik butonuna bastı KOD 0 KOD 3 Sağlayın Dehal! ("..tur..")", lscsdplayer, 0,0,0,true)
				end
			else
				local theTeam = getPlayerTeam(thePlayer)
				local factionRank = tonumber(getElementData(thePlayer,"factionrank"))
				local factionRanks = getElementData(theTeam, "ranks")
				local factionRankTitle = factionRanks[factionRank]
				local tur = table.concat({...}, " ")
				local username = getPlayerName(thePlayer)
				local x, y, z = getElementPosition(thePlayer)
				local playerX, playerY, playerZ = getElementPosition(thePlayer)
				local playerZoneName = getZoneName(playerX, playerY, playerZ)
				
				setElementData(thePlayer, "panikacik", false)
				
				for k, pdplayer in ipairs(getPlayersInTeam(getTeamFromName ("Reval İl Emniyet Mudurlugu"))) do
					outputChatBox("#6464FF[!]#8B8B8E (CH: 911) " .. username:gsub("_", " ") .. " panik çağrısını kaldırdı.", pdplayer, 0,0,0,true)
				end

				for k, lscsdplayer in ipairs(getPlayersInTeam(getTeamFromName ("Reval İl Saglik Mudurlugu"))) do
					outputChatBox("#6464FF[!]#8B8B8E (CH: 911) " .. username:gsub("_", " ") .. " panik çağrısını kaldırdı.", lscsdplayer, 0,0,0,true)
				end
			end
		end
	end
end
addCommandHandler("panik", panik)