function serialKontrol(thePlayer, commandName, targetPlayer)
	if (exports.rl_integration:isPlayerTrialAdmin(thePlayer)) then
		if (not tonumber(targetPlayer)) then
			outputChatBox("[!]#FFFFFF Birşey yazmadınız. /serialkontrol <oyuncu id>", thePlayer, 255, 0, 0, true)
		else
			local targetPlayer, targetPlayerName = exports.rl_global:findPlayerByPartialNick(thePlayer, targetPlayer)
			if targetPlayer then
				local serial = getPlayerSerial( targetPlayer )
				outputChatBox("[!]#FFFFFF "..targetPlayerName.." isimli oyuncunun Seriali: #00ff00"..serial, thePlayer, 0, 255, 0, true)
				outputChatBox("'"..serial.."' - Oyuncunun Seriali Kopyalandı.", thePlayer, 200, 200, 200)
				triggerClientEvent(thePlayer, "copySerialToClipboard", thePlayer, serial)
			end
		end
	else 
		outputChatBox("[!]#FFFFFF Bu işlemi yapmak için yetkiniz yok.", thePlayer, 255, 0, 0, true)
	end
end
addCommandHandler("serialkontrol", serialKontrol)