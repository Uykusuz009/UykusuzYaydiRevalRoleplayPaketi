local secretHandle = 'some_shit_that_is_really_secured'

function changeProtectedElementData(thePlayer, index, newvalue)
	setElementData(thePlayer, index, newvalue)
end

function changeProtectedElementDataEx(thePlayer, index, newvalue, sync, nosyncatall)
	if (thePlayer) and (index) then
		setElementData(thePlayer, index, newvalue)
		return true
	end
	return false
end

function yereyatir(thePlayer, commandName, targetPlayerNick)
	local logged = getElementData(thePlayer, "loggedin")
	local targetPlayer, targetPlayerName = exports.rl_global:findPlayerByPartialNick(thePlayer, targetPlayerNick)	
	
	if (getElementData(thePlayer, "faction")==1) then
		if not (targetPlayerNick) then
			outputChatBox("#ffffff /" .. commandName .. " [Player Partial Nick]", thePlayer, 255, 194, 14,true)
		else
			if (targetPlayer==thePlayer) then
				outputChatBox("[!] #f0f0f0Kendini yere yatıramazsın.", thePlayer, 255, 0, 0, true)
				return false
			end

			if (getElementData(targetPlayer, "duty_admin")==1) then 
				outputChatBox("[!] #f0f0f0Görevdeki yetkiliyi yere yatıramazsın.", thePlayer, 255, 0, 0, true)
				return false
			end		
		
			if targetPlayer then
				local x, y, z = getElementPosition(thePlayer)
				local tx, ty, tz = getElementPosition(targetPlayer)
				
				local distance = getDistanceBetweenPoints3D(x, y, z, tx, ty, tz)
				
				if (distance<=10) then
					detachElements(targetPlayer)
					toggleAllControls(targetPlayer, false, true, false)
					setElementFrozen(targetPlayer, true)
					triggerClientEvent(targetPlayer, "onClientPlayerWeaponCheck", targetPlayer)
					setPedWeaponSlot(targetPlayer, 0)
					--exports.rl_anticheat:changeProtectedElementDataEx(targetPlayer, "freeze", 1, false)				
					--setPedAnimation(targetPlayer, "sword", "sword_block", 1000, false, true, false)
					--exports.rl_bone_attach:attachElementToBone(targetPlayer, thePlayer, 3, 0, 0.7, -0.3, 0, 0, 0)
					--setElementData(targetPlayer, "yatirildi", true)
					setPedAnimation(targetPlayer, "CRACK", "crckidle2", -1, false, false, false)					
					setElementFrozen(targetPlayer, true)
					--setTimer(setElementFrozen, 10005, 1, targetPlayer)
					triggerEvent("sendLocalMeAction", root, thePlayer, " " .. targetPlayerName .. " kişisinin üstüne doğru atlar.")
					--outputChatBox("[!] #f0f0f0" .. targetPlayerName .. " isimli kişiyi sürüklüyorsunuz. (/suruklemeyibirak)", thePlayer, 0, 255, 0, true)
					--outputChatBox("[!] #f0f0f0" .. getPlayerName(thePlayer) .. " isimli polis memuru sizi sürüklüyor.", targetPlayer, 0, 255, 0, true)
				else
					outputChatBox("[!] #f0f0f0" .. targetPlayerName .. " isimli kişiden uzaksınız.", thePlayer, 255, 0, 0, true)
				end
			end
		end
	end
end
addCommandHandler("yereyatir", yereyatir)

function yereyatir(thePlayer, commandName, targetPlayerNick)
	local logged = getElementData(thePlayer, "loggedin")
	local targetPlayer, targetPlayerName = exports.rl_global:findPlayerByPartialNick(thePlayer, targetPlayerNick)	
	
	if (getElementData(thePlayer, "faction")==1) then
		if not (targetPlayerNick) then
			outputChatBox("SYNTAX: /" .. commandName .. " [Player Partial Nick]", thePlayer, 255, 194, 14)
		else
			if (targetPlayer==thePlayer) then
				outputChatBox("[!] #f0f0f0Kendini yere yatıramazsın.", thePlayer, 255, 0, 0, true)
				return false
			end

			if (getElementData(targetPlayer, "duty_admin")==1) then 
				outputChatBox("[!] #f0f0f0Görevdeki yetkiliyi yere yatıramazsın.", thePlayer, 255, 0, 0, true)
				return false
			end		
		
			if targetPlayer then
				local x, y, z = getElementPosition(thePlayer)
				local tx, ty, tz = getElementPosition(targetPlayer)
				
				local distance = getDistanceBetweenPoints3D(x, y, z, tx, ty, tz)
				
				if (distance<=10) then
					detachElements(targetPlayer)
					toggleAllControls(targetPlayer, false, false, false)
					setElementFrozen(targetPlayer, false)
					triggerClientEvent(targetPlayer, "onClientPlayerWeaponCheck", targetPlayer)
					setPedWeaponSlot(targetPlayer, 0)
					--exports.rl_anticheat:changeProtectedElementDataEx(targetPlayer, "freeze", 1, false)				
					--setPedAnimation(targetPlayer, "sword", "sword_block", 1000, false, true, false)
					--exports.rl_bone_attach:attachElementToBone(targetPlayer, thePlayer, 3, 0, 0.7, -0.3, 0, 0, 0)
					--setElementData(targetPlayer, "yatirildi", true)
					setPedAnimation(targetPlayer, "CRACK", "crckidle2", -1, false, false, false)					
					setElementFrozen(targetPlayer, false)
					--setTimer(setElementFrozen, 10005, 1, targetPlayer)
					triggerEvent("sendLocalMeAction", root, thePlayer, " " .. targetPlayerName .. " kişisini yerden kaldırır.")
					--outputChatBox("[!] #f0f0f0" .. targetPlayerName .. " isimli kişiyi sürüklüyorsunuz. (/suruklemeyibirak)", thePlayer, 0, 255, 0, true)
					--outputChatBox("[!] #f0f0f0" .. getPlayerName(thePlayer) .. " isimli polis memuru sizi sürüklüyor.", targetPlayer, 0, 255, 0, true)
				else
					outputChatBox("[!] #f0f0f0" .. targetPlayerName .. " isimli kişiden uzaksınız.", thePlayer, 255, 0, 0, true)
				end
			end
		end
	end
end
addCommandHandler("yerdenkaldir", yereyatir)
