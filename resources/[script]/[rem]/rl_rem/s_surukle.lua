addCommandHandler("surukle",
	function(thePlayer, commandName, targetPlayerNick)
		local logged = getElementData(thePlayer, "loggedin")
	
		if (logged==1) then
			if getElementData(thePlayer, "surukle") then
				outputChatBox("#575757Reval: #f0f0f0Aynı anda birden fazla kişi sürükleyemezsiniz!", thePlayer, 255, 0, 0, true)
				return false
			end
			local theTeam = getPlayerTeam(thePlayer)
			local factionType = getElementData(theTeam, "type")
		
			if (factionType==2) or (factionType == 3) or getElementData(thePlayer,'faction') == 143 then
				if not (targetPlayerNick) then
					outputChatBox("KULLANIM: /" .. commandName .. " [Player Partial Nick]", thePlayer, 255, 194, 14)
				else
					local targetPlayer, targetPlayerName = exports.rl_global:findPlayerByPartialNick(thePlayer, targetPlayerNick)
				
					if targetPlayer then
						if getElementData(thePlayer, "isleme:durum") or getElementData(thePlayer, "kazma:durum") or getElementData(thePlayer, "tutun:durum") then
							outputChatBox("#575757Reval:#f9f9f9 Bu durumdayken bu komutu kullanamazsınız.", thePlayer, 255, 0, 0, true)
						return end
							if getElementData(targetPlayer, "isleme:durum") or getElementData(targetPlayer, "kazma:durum") or getElementData(targetPlayer, "tutun:durum") then
							outputChatBox("#575757Reval:#f9f9f9 Geçmiş olsun kardeşim, adminlere bildirildin. Kendini zeki zannediyorsun.", thePlayer, 255, 0, 0, true)
							outputChatBox("#575757Reval:#f9f9f9 Geçmiş olsun kardeşim, adminlere bildirildin. Kendini zeki zannediyorsun.", targetPlayer, 255, 0, 0, true)
							outputChatBox("#575757Reval:#f9f9f9 10.000 TL'ne sistem tarafından el konuldu.", targetPlayer, 255, 0, 0, true)
							outputChatBox("#575757Reval:#f9f9f9 10.000 TL'ne sistem tarafından el konuldu.", thePlayer, 255, 0, 0, true)
							exports.rl_global:takeMoney(thePlayer, 10000)
							exports.rl_global:takeMoney(targetPlayer, 10000)
							exports.rl_global:sendMessageToAdmins("[BUG UYARI] '" .. getPlayerName(thePlayer) .. "' isimli oyuncu maden mesleğinde, '"..getPlayerName(targetPlayer).."' isimli oyuncuya /surukle yapmaya çalıştı!")
						return end
						local x, y, z = getElementPosition(thePlayer)
						local tx, ty, tz = getElementPosition(targetPlayer)
						
						local distance = getDistanceBetweenPoints3D(x, y, z, tx, ty, tz)
						
						if (distance<=10) then
							exports.rl_global:applyAnimation( targetPlayer, "CRACK", "crckidle4", -1, false, false, false)
							attachElements(targetPlayer, thePlayer, 0, 1, 0)
							setElementData(thePlayer, "surukle", targetPlayer)
							setElementFrozen(targetPlayer, true)
							exports.rl_global:sendLocalMeAction(thePlayer, "şahsın kolundan tutar ve sürüklemeye başlar.", false, true)
							outputChatBox("#575757Reval: #f0f0f0" .. targetPlayerName .. " isimli şahsı sürüklemektesiniz. Sürüklemeyi bırakmak için /suruklemeyibirak", thePlayer, 0, 255, 0, true)
							outputChatBox("#575757Reval: #f0f0f0" .. getPlayerName(thePlayer) .. " isimli şahıs sizi sürüklüyor.", targetPlayer, 0, 255, 0, true)
						else
							outputChatBox("#575757Reval: #f0f0f0" .. targetPlayerName .. " isimli şahısdan uzaksınız.", thePlayer, 255, 0, 0, true)
						end
					end
				end
			end
		end
	end
)

addCommandHandler("suruklemeyibirak",
	function(thePlayer)
		local surukle = getElementData(thePlayer, "surukle")
		if surukle then
			detachElements(surukle, thePlayer)
			setElementFrozen(surukle, false)
			setElementData(thePlayer, "surukle", false)
			local targetPlayerName = getPlayerName(surukle)
			exports.rl_global:sendLocalMeAction(thePlayer, "şahsın kolunu bırakır.", false, true)
			outputChatBox("#575757Reval: #f0f0f0" .. targetPlayerName .. " isimli şahsı sürüklemeyi bıraktınız.", thePlayer, 0, 255, 0, true)
			exports.rl_global:removeAnimation(surukle)
			outputChatBox("#575757Reval: #f0f0f0" .. getPlayerName(thePlayer).. " sizi sürüklemeyi bıraktı.", surukle, 0, 255, 0, true)
		else
			outputChatBox("#575757Reval: #f0f0f0Şu anda hiçkimseyi sürüklememektesiniz.", thePlayer, 255, 0, 0, true)
		end
	end
)