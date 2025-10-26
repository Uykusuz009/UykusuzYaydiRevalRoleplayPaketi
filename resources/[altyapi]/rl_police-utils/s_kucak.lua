local kucak = {}

addCommandHandler("kucak", function(thePlayer, cmd, targetPlayer)
	if not targetPlayer then
		outputChatBox("KULLANIM:/" .. cmd .. " [Karakter Adı / ID]", thePlayer, 255, 194, 14, true)
	return end
	if getElementData(thePlayer, "gelenIstekler") then outputChatBox("[!]#FFFFFF Zaten şu anda bir teklifiniz mevcut.", thePlayer, 255, 0, 0, true) return end
	if getElementData(thePlayer, "kucakta") then outputChatBox("[!]#FFFFFF Zaten şu anda birini taşıyorsunuz", thePlayer, 255, 0, 0, true) return end
			local targetPlayer, targetPlayerName = exports.rl_global:findPlayerByPartialNick(thePlayer, targetPlayer)
			if targetPlayer == thePlayer then outputChatBox("[!]#FFFFFF Kendini kucaklayamazsın.", thePlayer, 255, 0, 0, true) return end
	if targetPlayer then
		local x, y, z = getElementPosition(thePlayer)
		local tx, ty, tz = getElementPosition(targetPlayer)
		local targetPlayerName = getPlayerName(targetPlayer)
		local distance = getDistanceBetweenPoints3D(x, y, z, tx, ty, tz)
				
		if (distance<=1) then
			outputChatBox("[!]#FFFFFF " .. getPlayerName(targetPlayer) .. " adlı oyuncuya teklifi yolladınız.", thePlayer, 255, 0, 255, true)
			outputChatBox("[!]#FFFFFF " .. getPlayerName(thePlayer) .. " adlı oyuncu sizi kucağına almak istiyor.", targetPlayer, 255, 0, 255, true)
			setElementData(thePlayer, "gelenIstekler", true)
			triggerClientEvent(targetPlayer, "kucak:gui", thePlayer, thePlayer, targetPlayer)
			setTimer(function()
				triggerClientEvent(targetPlayer, "kucak:guiclose", targetPlayer)
				exports["rl_infobox"]:addBox(targetPlayer, "error", "15 saniye geçtiği için arayüzün kapatıldı.")
				if getElementData(thePlayer, "gelenIstekler") then
					setElementData(thePlayer, "gelenIstekler", nil)
				end
			end, 15000, 1)
		else
			outputChatBox("[!]#FFFFFF Belirttiğiniz şahısa çok uzaksınız.", thePlayer, 255, 0,0,true)
		end
	end
end)

addCommandHandler("kucakindir", function(thePlayer)
	local surukle = getElementData(thePlayer, "kucakta")
	if surukle then
		setElementFrozen(surukle, false)
		detachElements(surukle, thePlayer)
		setElementData(thePlayer, "kucakta", false)
		setElementData(thePlayer, "gelenIstekler", false)
		local targetPlayerName = getPlayerName(surukle)		
		exports.rl_global:sendLocalMeAction(thePlayer, "şahısı yere indirir.", false, true)
		outputChatBox("[!]#FFFFFF " .. targetPlayerName .. " isimli şahsı kucaklamayı bıraktınız.", thePlayer, 0, 255, 0, true)
		exports.rl_global:applyAnimation(surukle, "CRACK", "crckidle3", -1, false, false, false)

		exports.rl_global:removeAnimation(targetPlayer)
		setElementFrozen(surukle, false)
		outputChatBox("[!]#FFFFFF " .. getPlayerName(thePlayer).. " isimli şahıs sizi kucaklamayı bıraktı.", surukle, 0, 255, 0, true)
	end
end)

function kucak.kabul (thePlayer, targetPlayer)
	if thePlayer and targetPlayer then
		setElementData(thePlayer, "kucakta", targetPlayer)
		attachElements(targetPlayer, thePlayer, 0, 0.4, 1.3)
		setElementData(thePlayer, "kucakta", targetPlayer)
		setElementFrozen(targetPlayer, true)
		setPedAnimation(targetPlayer, "CRACK", "crckidle4", 50, false)
		setPedAnimation(thePlayer, "CARRY", "crry_prtial", 50, false)
		outputChatBox("[!]#FFFFFF " .. getPlayerName(targetPlayer) .. " adlı oyuncu teklifinizi kabul etti. İndirmek için /kucakindir.", thePlayer, 0, 0, 255, true)
		outputChatBox("[!]#FFFFFF Başarıyla gelen teklifi kabul ettiniz.", targetPlayer, 0, 0, 255, true)
	end
end
addEvent("kucak:kabul", true)
addEventHandler("kucak:kabul", root, kucak.kabul)

function kucak.reddet(thePlayer, targetPlayer)
	if thePlayer and targetPlayer then
		outputChatBox("[!]#FFFFFF Başarıyla gelen teklifi reddettiniz.", targetPlayer, 0, 255, 0, true)
		outputChatBox("[!]#FFFFFF Karşı taraf teklifinizi reddetti.", thePlayer, 255, 0, 0, true)
		setElementData(thePlayer, "gelenIstekler", nil)
		setElementData(thePlayer, "kucakta", nil)
	end
end
addEvent("kucak:reddet", true)
addEventHandler("kucak:reddet", getRootElement(), kucak.reddet)

function enterVehicle (player, seat, jacked)
    if getElementData(player, "gelenIstekler") or getElementData(player, "kucakta") then
		cancelEvent()
        outputChatBox ("[!]#FFFFFF Kucak işlemin devam ettiği için bu işlemi gerçekleştiremezsin.", player, 255, 0, 0, true)
	end
end
addEventHandler ("onVehicleStartEnter", getRootElement(), enterVehicle)