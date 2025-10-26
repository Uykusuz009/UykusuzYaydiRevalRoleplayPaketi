function yereYatir(thePlayer, commandName, targetPlayer)
	if (getElementData(thePlayer, "faction") == 1) or (getElementData(thePlayer, "faction") == 3) then
		if targetPlayer then
			local targetPlayer, targetPlayerName = exports.rl_global:findPlayerByPartialNick(thePlayer, targetPlayer)
			if targetPlayer then
				if targetPlayer ~= thePlayer then
					local x, y, z = getElementPosition(thePlayer)
					local tx, ty, tz = getElementPosition(targetPlayer)
					local distance = getDistanceBetweenPoints3D(x, y, z, tx, ty, tz)
					if distance <= 3 then
						if not getElementData(targetPlayer, "yatirildi") then
							detachElements(targetPlayer)
							toggleAllControls(targetPlayer, false, true, false)
							setElementFrozen(targetPlayer, true)
							triggerClientEvent(targetPlayer, "onClientPlayerWeaponCheck", targetPlayer)
							setPedWeaponSlot(targetPlayer, 0)
							setElementData(targetPlayer, "freeze", 1, false)
							setElementData(targetPlayer, "yatirildi", true)
							setPedAnimation(targetPlayer, "CRACK", "crckidle2", -1, false, false, false)					
							setElementFrozen(targetPlayer, true)
							exports.rl_global:sendLocalMeAction(thePlayer, targetPlayerName .. " isimli kişinin üstüne doğru atlar.")
						else
							outputChatBox("[!]#FFFFFF " .. targetPlayerName .. " isimli oyuncu zaten yerde.", thePlayer, 255, 0, 0, true)
							playSoundFrontEnd(thePlayer, 4)
						end
					else
						outputChatBox("[!]#FFFFFF " .. targetPlayerName .. " isimli oyuncuya yeterince yakın değilsiniz.", thePlayer, 255, 0, 0, true)
						playSoundFrontEnd(thePlayer, 4)
					end
				else
					outputChatBox("[!]#FFFFFF Kendini yere yatıramazsın.", thePlayer, 255, 0, 0, true)
					playSoundFrontEnd(thePlayer, 4)
				end
			end
		else
			outputChatBox("KULLANIM: /" .. commandName .. " [Karakter Adı / ID]", thePlayer, 255, 194, 14)
		end
	else
		outputChatBox("[!]#FFFFFF Bu işlemi yalnızca legal birlik üyeleri yapabilir.", thePlayer, 255, 0, 0, true)
		playSoundFrontEnd(thePlayer, 4)
	end
end
addCommandHandler("yereyatir", yereYatir, false, false)

function yerdenKaldir(thePlayer, commandName, targetPlayer)
	if (getElementData(thePlayer, "faction") == 1) or (getElementData(thePlayer, "faction") == 3) then
		if targetPlayer then
			local targetPlayer, targetPlayerName = exports.rl_global:findPlayerByPartialNick(thePlayer, targetPlayer)
			if targetPlayer then
				if targetPlayer ~= thePlayer then
					local x, y, z = getElementPosition(thePlayer)
					local tx, ty, tz = getElementPosition(targetPlayer)
					local distance = getDistanceBetweenPoints3D(x, y, z, tx, ty, tz)
					if distance <= 3 then
						if getElementData(targetPlayer, "yatirildi") then
							removeElementData(targetPlayer, "yatirildi")
							setPedAnimation(targetPlayer, false)
							setElementFrozen(targetPlayer, false)
							exports.rl_global:sendLocalMeAction(thePlayer, targetPlayerName .. " isimli kişiyi yerden kaldırır.")
						else
							outputChatBox("[!]#FFFFFF " .. targetPlayerName .. " isimli oyuncu yerde değil.", thePlayer, 255, 0, 0, true)
							playSoundFrontEnd(thePlayer, 4)
						end
					else
						outputChatBox("[!]#FFFFFF " .. targetPlayerName .. " isimli oyuncuya yeterince yakın değilsiniz.", thePlayer, 255, 0, 0, true)
						playSoundFrontEnd(thePlayer, 4)
					end
				else
					outputChatBox("[!]#FFFFFF Kendini yerden kaldıramazsın.", thePlayer, 255, 0, 0, true)
					playSoundFrontEnd(thePlayer, 4)
				end
			end
		else
			outputChatBox("KULLANIM: /" .. commandName .. " [Karakter Adı / ID]", thePlayer, 255, 194, 14)
		end
	else
		outputChatBox("[!]#FFFFFF Bu işlemi yalnızca legal birlik üyeleri yapabilir.", thePlayer, 255, 0, 0, true)
		playSoundFrontEnd(thePlayer, 4)
	end
end
addCommandHandler("yerdenkaldir", yerdenKaldir, false, false)