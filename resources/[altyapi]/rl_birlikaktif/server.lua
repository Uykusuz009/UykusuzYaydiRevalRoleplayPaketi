function birlik(thePlayer, commandName)
	takim = tonumber(getElementData(thePlayer, "faction"))
	if takim and takim > 0 then
		local takimveri = exports.rl_pool:getElement("team", takim)
		local takimisim = getTeamName(takimveri)
		local takimoyunculari = getPlayersInTeam(takimveri)
		local takimtel = "-"
		
		if #takimoyunculari == 0 then
			outputChatBox("[!]#FFFFFF '".. takimisim .."' isimli birlikte aktif oyuncu yok.", thePlayer, 255, 0, 0, true)
		else
			local takimrutbe = getElementData(takimveri, "ranks")
			outputChatBox("[!]#FFFFFF '".. takimisim .."' isimli birlikteki aktif oyuncular:", thePlayer, 0, 0, 255, true)
			for k, takimoyuncular in ipairs(takimoyunculari) do
				local takimItems = exports["rl_items"]:getItems(takimoyuncular)
				for i, val in ipairs(takimItems) do
					if val[1] == 2 then
						takimtel = val[2]
					end
				end
				local oyuncurutbe = takimrutbe [ getElementData(takimoyuncular, "factionrank") ]
				outputChatBox("[!]#FFFFFF Karakter Adı: ".. getPlayerName(takimoyuncular) .." | Rütbesi: ".. oyuncurutbe .. " | Telefon: "..takimtel, thePlayer, 0, 0, 255, true)
			end
		end
	else
		outputChatBox("[!]#FFFFFF Herhangibi bir oluşumda değilsiniz, lütfen oluşuma girdikten sonra tekrar deneyiniz.", thePlayer, 255, 0, 0, true)
	end
end
addCommandHandler("birlikaktif", birlik)