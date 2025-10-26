local mysql = exports.rl_mysql
local istekTablo = {}

function ckEtme(thePlayer, command, karsi)

	
	if not karsi then
		return outputChatBox("[!] #ffffffKullanım: /cket <oyuncu adı/oyuncu ıd>", thePlayer, 255, 0, 0, true)
	end

	local karsiOyuncu = exports.rl_global:findPlayerByPartialNick(thePlayer, karsi)
	if not isElement(karsiOyuncu) then
		return outputChatBox("[!] #ffffffOyuncu bulunamadı.", thePlayer, 255, 0, 0, true)
	end
	--[[if (thePlayer == karsiOyuncu) then
		return outputChatBox("[!] #ffffffBu işlemi kendinize uygulayamazsınız.", thePlayer, 255, 0, 0, true)
	end
]]
	istekTablo[karsiOyuncu] = {thePlayer}

	triggerClientEvent(karsiOyuncu, "ckPanel.gosterPanel", karsiOyuncu, getPlayerName(thePlayer))
	outputChatBox("[!] #ffffffOyuncuya istek gönderildi.", thePlayer, 0, 0, 255, true)
end
addCommandHandler( "cket", ckEtme)






function onaylamaPaneli(onaylama, thePlayer, targetPlayer)
	local targetPlayer, targetPlayerName = exports.rl_global:findPlayerByPartialNick(thePlayer, targetPlayer)
	local karsi = client
	if tostring(onaylama) == "kabul" then
			if targetPlayer then
						setElementData(thePlayer, "ckstatus", 0)
						setElementData(thePlayer, "ckreason", 0)
						dbExec(mysql:getConnection(), "UPDATE characters SET cked='1', ck_reason='Kendi istegi', `death_date`=NOW() WHERE id = " .. getElementData(thePlayer, "dbid"))--Lauren
						local x, y, z = getElementPosition(thePlayer)
						local skin = getPedSkin(thePlayer)
						local rotation = getPedRotation(thePlayer)
						--local look = getElementData(thePlayer, "look")
						--local desc = look[5]
						call( getResourceFromName( "realism-system" ), "addCharacterKillBody", x, y, z, rotation, skin, getElementData(thePlayer, "dbid"), targetPlayerName, getElementInterior(thePlayer), getElementDimension(thePlayer), getElementData(thePlayer, "age"), getElementData(thePlayer, "race"), getElementData(thePlayer, "weight"), getElementData(thePlayer, "height"), "yok", "Kendi istegi", getElementData(thePlayer, "gender"))
				outputChatBox("[!] #ffffffCk oldun cocugu.", thePlayer, 0, 0, 255, true)
				outputChatBox("[!] #ffffffCk olmayı kabul etti.", targetPlayer, 0, 0, 255, true)
				setTimer(
				kickPlayer(targetPlayer, "Ck.")
				)
				istekTablo[karsi] = nil
			elseif tostring(onaylama) == "reddet" then
				outputChatBox("[!] #ffffff"..getPlayerName(thePlayer)..", ck olmayı kabul etmedi.", targetPlayer, 255, 0, 0, true)
				istekTablo[karsi] = nil
		end
	end
end
addEvent('ckPanel.onaylama', true)
addEventHandler('ckPanel.onaylama', root, onaylamaPaneli)