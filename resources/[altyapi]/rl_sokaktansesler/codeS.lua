function SokakSes(thePlayer, cmd, ...)
	if not exports.rl_integration:isPlayerGeneralAdmin( thePlayer) then
		outputChatBox("[!] Bu komutu kullanabilmek için yeterli yetkiye sahip değilsin." , thePlayer, 255, 0, 0, true)	
		return
	end
	if not (...) then
		outputChatBox("SÖZDİZİMİ: /" .. cmd .. " [Mesaj]", thePlayer)
		return
	end
	local mesaj = table.concat({ ... }, " ")
	outputChatBox("[Sokaktan Sesler] #FFFFFF"..mesaj.."", getRootElement(), 247, 100, 2, true)
end
addCommandHandler("sa", SokakSes)