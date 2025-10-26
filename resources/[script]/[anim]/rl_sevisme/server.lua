local mysql = exports.rl_mysql
local istekTablo = {}

function ckEtme(thePlayer, command, karsi)

	
	if not karsi then
		return outputChatBox("[Reval] #ffffffKullanım: /sevismeteklif <oyuncuAdi>", thePlayer, 255, 137, 10, true)
	end

	local karsiOyuncu = exports.rl_global:findPlayerByPartialNick(thePlayer, karsi)
	if not isElement(karsiOyuncu) then
		return outputChatBox("[Reval] #ffffffBu oyuncu oyunda değil.", thePlayer, 255, 137, 10, true)
	end
	
	
	if (thePlayer == karsiOyuncu) then
	return outputChatBox("[Reval] #ffffffKendini mi sikicen gerizekalı amcık ozanı seni.", thePlayer, 255, 137, 10, true)
	end
	


	istekTablo[karsiOyuncu] = {thePlayer}
	local x, y, z = getElementPosition(thePlayer)
	local tx, ty, tz = getElementPosition(karsiOyuncu)
	local distance = getDistanceBetweenPoints3D(x, y, z, tx, ty, tz)
	if distance<=10 then
		outputChatBox("[Reval]#ffffff Başarıyla hedef karaktere sevişme isteği gönderdin.",thePlayer,0, 0, 255,true)	
	triggerClientEvent(karsiOyuncu, "sevisPanel.gosterPanel", karsiOyuncu, getPlayerName(thePlayer))
	else
	outputChatBox("[Reval] #ffffffHedef karakterden uzak olduğun için sevişme isteği gönderemezsin.", thePlayer, 255, 0, 0, true)
	end
end
addCommandHandler( "sevismeteklif", ckEtme)






function onaylamaPaneli(onaylama, thePlayer, targetPlayer)
	local targetPlayer, targetPlayerName = exports.rl_global:findPlayerByPartialNick(thePlayer, targetPlayer)
	local karsi = client
	
	if tostring(onaylama) == "kabul" then
	if thePlayer then
	setPedAnimation ( targetPlayer, "sex", "sex_1_cum_p", -1, true, false, false )
	end
			if targetPlayer then
			setPedAnimation ( thePlayer, "sex", "sex_1_cum_w", -1, true, false, false )
						local x, y, z = getElementPosition(thePlayer)
						local skin = getPedSkin(thePlayer)
						local rotation = getPedRotation(thePlayer)
						--local look = getElementData(thePlayer, "look")
						--local desc = look[5]
				outputChatBox("[Reval] #ffffffSevişmeye başladınız", thePlayer, 0, 0, 255, true)
				outputChatBox("[Reval] #ffffff"..targetPlayer.." adlı karakter sevişmeyi  kabul etti.", targetPlayer, 0, 0, 255, true)
				istekTablo[karsi] = nil
			elseif tostring(onaylama) == "reddet" then
				outputChatBox("[Reval] #ffffff"..getPlayerName(thePlayer).." adlı karakter sevişme istedğinizi kabul etmedi.", targetPlayer, 255, 137, 10, true)
				istekTablo[karsi] = nil
		end
	end
end
addEvent('sevisPanel.onaylama', true)
addEventHandler('sevisPanel.onaylama', root, onaylamaPaneli)

