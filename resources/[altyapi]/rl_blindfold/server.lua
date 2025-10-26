addCommandHandler("goz", function(thePlayer, commandName, targetPlayer, argument)
	if targetPlayer then
		if argument == "bagla" then
			if exports["rl_items"]:hasItem(thePlayer, 66) then
				local target, targetPlayerName = exports.rl_global:findPlayerByPartialNick(thePlayer, targetPlayer)
				if target then
					if not (target == thePlayer) then
						local x, y, z = getElementPosition(thePlayer)
						local x2, y2, z2 = getElementPosition(target)
						if getDistanceBetweenPoints3D(x, y, z, x2, y2, z2) < 3 then
							if getElementData(target, "blindfold") ~= 1 then
								outputChatBox("[!]#FFFFFF ["..getPlayerName(target).."] adlı kişinin gözlerini bağladınız.", thePlayer, 0, 255, 0, true)
								outputChatBox("[!]#FFFFFF ["..getPlayerName(thePlayer).."] adlı kişi gözlerinizi bağladı.", target, 0, 0, 255, true)
								fadeCamera(target, false)
								setElementData(target, "blindfold", 1)
								exports["rl_items"]:takeItem(thePlayer, 66)
							else
								outputChatBox("[!]#ffffff Gözlerini bağlamaya çalıştığınız kişinin gözleri zaten bağlı.", thePlayer, 255, 0, 0, true)
								playSoundFrontEnd(thePlayer, 4)
							end
						else
							outputChatBox("[!]#FFFFFF Bu şahıs çok uzağınızda.", thePlayer, 255, 0, 0, true)
							playSoundFrontEnd(thePlayer, 4)
						end
					else
						outputChatBox("[!]#FFFFFF Bu işlemi kendinize uygulayamassınız.", thePlayer, 255, 0, 0, true)
						playSoundFrontEnd(thePlayer, 4)
					end
				else
					outputChatBox("[!]#FFFFFF Eşleşecek kimse bulunamadı.", thePlayer, 255, 0, 0, true)
					playSoundFrontEnd(thePlayer, 4)
				end
			else
				outputChatBox("[!]#FFFFFF Maalesef üzerinizde bandaj yok.", thePlayer, 255, 0, 0, true)
				playSoundFrontEnd(thePlayer, 4)
			end
		elseif argument == "coz" then
			local target, targetPlayerName = exports.rl_global:findPlayerByPartialNick(thePlayer, targetPlayer)
			if target then
				if not (target == thePlayer) then
					local x, y, z = getElementPosition(thePlayer)
					local x2, y2, z2 = getElementPosition(target)
					if getDistanceBetweenPoints3D(x, y, z, x2, y2, z2) < 3 then
						if getElementData(target, "blindfold") == 1 then
							outputChatBox("[!]#FFFFFF ["..getPlayerName(target).."] adlı kişinin gözlerini çözdünüz.", thePlayer, 0, 255, 0, true)
							outputChatBox("[!]#FFFFFF ["..getPlayerName(thePlayer).."] adlı kişi gözlerinizi çözdü.", target, 0, 0, 255, true)
							fadeCamera(target, true)
							setElementData(target, "blindfold", 0)
							exports["rl_items"]:giveItem(thePlayer, 66, 1)
						else
							outputChatBox("[!]#ffffff Gözlerini çözmeye çalıştığınız kişinin gözleri bağlı değil.", thePlayer, 255, 0, 0, true)
							playSoundFrontEnd(thePlayer, 4)
						end
					else
						outputChatBox("[!]#FFFFFF Bu şahıs çok uzağınızda.", thePlayer, 255, 0, 0, true)
						playSoundFrontEnd(thePlayer, 4)
					end
				else
					outputChatBox("[!]#FFFFFF Bu işlemi kendinize uygulayamassınız.", thePlayer, 255, 0, 0, true)
					playSoundFrontEnd(thePlayer, 4)
				end
			else
				outputChatBox("[!]#FFFFFF Eşleşecek kimse bulunamadı.", thePlayer, 255, 0, 0, true)
				playSoundFrontEnd(thePlayer, 4)
			end
		else
			outputChatBox("KULLANIM: /"..commandName.." [Karakter Adı / ID] [bagla/coz]", thePlayer, 255, 194, 14)
		end
	else
		outputChatBox("KULLANIM: /"..commandName.." [Karakter Adı / ID] [bagla/coz]", thePlayer, 255, 194, 14)
	end
end)