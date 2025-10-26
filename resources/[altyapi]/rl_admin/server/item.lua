function getAmmoPerClip(id)
	if id == 0 then
		return tostring(get(getResourceName(getThisResource()) .. ".fist"))
	elseif id == 1 then 
		return tostring(get(getResourceName(getThisResource()) .. ".brassknuckle"))
	elseif id == 2 then 
		return tostring(get(getResourceName(getThisResource()) .. ".golfclub"))
	elseif id == 3 then 
		return tostring(get(getResourceName(getThisResource()) .. ".nightstick"))
	elseif id == 4 then 
		return tostring(get(getResourceName(getThisResource()) .. ".knife"))
	elseif id == 5 then 
		return tostring(get(getResourceName(getThisResource()) .. ".bat"))
	elseif id == 6 then 
		return tostring(get(getResourceName(getThisResource()) .. ".shovel"))
	elseif id == 7 then 
		return tostring(get(getResourceName(getThisResource()) .. ".poolstick"))
	elseif id == 8 then 
		return tostring(get(getResourceName(getThisResource()) .. ".katana"))
	elseif id == 9 then 
		return tostring(get(getResourceName(getThisResource()) .. ".chainsaw"))
	elseif id == 10 then
		return tostring(get(getResourceName(getThisResource()) .. ".dildo"))
	elseif id == 11 then
		return tostring(get(getResourceName(getThisResource()) .. "dildo2"))
	elseif id == 12 then
		return tostring(get(getResourceName(getThisResource()) .. ".vibrator"))
	elseif id == 13 then
		return tostring(get(getResourceName(getThisResource()) .. ".vibrator2"))
	elseif id == 14 then
		return tostring(get(getResourceName(getThisResource()) .. ".flower"))
	elseif id == 15 then
		return tostring(get(getResourceName(getThisResource()) .. ".cane"))
	elseif id == 16 then
		return tostring(get(getResourceName(getThisResource()) .. ".grenade"))
	elseif id == 17 then
		return tostring(get(getResourceName(getThisResource()) .. ".teargas"))
	elseif id == 18 then
		return tostring(get(getResourceName(getThisResource()) .. ".molotov"))
	elseif id == 22 then
		return tostring(get(getResourceName(getThisResource()) .. ".colt45"))
	elseif id == 23 then
		return tostring(get(getResourceName(getThisResource()) .. ".silenced"))
	elseif id == 24 then
		return tostring(get(getResourceName(getThisResource()) .. ".deagle"))
	elseif id == 25 then
		return tostring(get(getResourceName(getThisResource()) .. ".shotgun"))
	elseif id == 26 then
		return tostring(get(getResourceName(getThisResource()) .. ".sawed-off"))
	elseif id == 27 then
		return tostring(get(getResourceName(getThisResource()) .. ".combatshotgun"))
	elseif id == 28 then
		return tostring(get(getResourceName(getThisResource()) .. ".uzi"))
	elseif id == 29 then
		return tostring(get(getResourceName(getThisResource()) .. ".mp5"))
	elseif id == 30 then
		return tostring(get(getResourceName(getThisResource()) .. ".ak-47"))
	elseif id == 31 then
		return tostring(get(getResourceName(getThisResource()) .. ".m4"))
	elseif id == 32 then
		return tostring(get(getResourceName(getThisResource()) .. ".tec-9"))
	elseif id == 33 then
		return tostring(get(getResourceName(getThisResource()) .. ".rifle"))
	elseif id == 34 then
		return tostring(get(getResourceName(getThisResource()) .. ".sniper"))
	elseif id == 35 then
		return tostring(get(getResourceName(getThisResource()) .. ".rocketlauncher"))
	elseif id == 41 then
		return tostring(get(getResourceName(getThisResource()) .. ".spraycan"))
	elseif id == 42 then
		return tostring(get(getResourceName(getThisResource()) .. ".fireextinguisher"))
	elseif id == 43 then
		return tostring(get(getResourceName(getThisResource()) .. ".camera"))
	elseif id == 44 then
		return tostring(get(getResourceName(getThisResource()) .. ".nightvision"))
	elseif id == 45 then
		return tostring(get(getResourceName(getThisResource()) .. ".infrared"))
	elseif id == 46 then
		return tostring(get(getResourceName(getThisResource()) .. ".parachute"))	
	else
		return "disabled"
	end
	return "disabled"
end
addEvent("onGetAmmoPerClip", true)
addEventHandler("onGetAmmoPerClip", root, getAmmoPerClip)

function givePlayerItem(thePlayer, commandName, targetPlayer, itemID, ...)
    if exports.rl_integration:isPlayerLeaderAdmin(thePlayer) then
        if targetPlayer and itemID and tonumber(itemID) and (...) then
            itemID = tonumber(itemID)
            local itemValue = table.concat({...}, " ")
			itemValue = tonumber(itemValue) or itemValue

            local targetPlayer, targetPlayerName = exports.rl_global:findPlayerByPartialNick(thePlayer, targetPlayer)
            if targetPlayer then
                if getElementData(targetPlayer, "logged") then
                    local itemName = exports.rl_items:getItemName(itemID, itemValue)
                    if itemID > 0 and itemName and itemName ~= "?" then
                        if exports.rl_items:hasSpaceForItem(targetPlayer, itemID, itemValue) then
                            local success, reason = exports.rl_global:giveItem(targetPlayer, itemID, itemValue)
                            if success then
                                outputChatBox("[!]#FFFFFF " .. targetPlayerName .. " isimli oyuncuya [" .. itemName .. "] isimli eşyayı [" .. itemValue .. "] adet verildi.", thePlayer, 0, 255, 0, true)
                                outputChatBox("[!]#FFFFFF " .. exports.rl_global:getPlayerFullAdminTitle(thePlayer) .. " isimli yetkili size [" .. itemName .. "] isimli eşyayı [" .. itemValue .. "] adet verildi.", targetPlayer, 0, 0, 255, true)
								exports.rl_logs:addLog("giveitem", exports.rl_global:getPlayerFullAdminTitle(thePlayer) .. " isimli yetkili " .. targetPlayerName .. " isimli oyuncuya [" .. itemName .. "] isimli eşyayı [" .. itemValue .. "] adet verildi.")
                            else
                                outputChatBox("[!]#FFFFFF Bir sorun oluştu.", thePlayer, 255, 0, 0, true)
                                playSoundFrontEnd(thePlayer, 4)
                            end
                        else
                            outputChatBox("[!]#FFFFFF Bu oyuncunun envanterinde yeterli alan yok.", thePlayer, 255, 0, 0, true)
                            playSoundFrontEnd(thePlayer, 4)
                        end
                    else
                        outputChatBox("[!]#FFFFFF Geçersiz eşya ID.", thePlayer, 255, 0, 0, true)
                        playSoundFrontEnd(thePlayer, 4)
                    end
                else
                    outputChatBox("[!]#FFFFFF Bu oyuncu karakterine giriş yapmadığı için işlem gerçekleşmedi.", thePlayer, 255, 0, 0, true)
                    playSoundFrontEnd(thePlayer, 4)
                end
            end
        else
            outputChatBox("KULLANIM: /" .. commandName .. " [Karakter Adı / ID] [Item ID] [Item adet]", thePlayer, 255, 194, 14)
        end
    else
        outputChatBox("[!]#FFFFFF Yeterli yetkiniz yok.", thePlayer, 255, 0, 0, true)
		playSoundFrontEnd(thePlayer, 4)
    end
end
addCommandHandler("giveitem", givePlayerItem, false, false)

function takePlayerItem(thePlayer, commandName, targetPlayer, itemID, ...)
    if exports.rl_integration:isPlayerLeaderAdmin(thePlayer) then
        if targetPlayer and itemID and tonumber(itemID) and (...) then
            itemID = tonumber(itemID)
            local itemValue = table.concat({...}, " ")
			itemValue = tonumber(itemValue) or itemValue

            local targetPlayer, targetPlayerName = exports.rl_global:findPlayerByPartialNick(thePlayer, targetPlayer)
            if targetPlayer then
                if getElementData(targetPlayer, "logged") then
                    if exports.rl_global:hasItem(targetPlayer, itemID, itemValue) then
						exports.rl_global:takeItem(targetPlayer, itemID, itemValue)
						outputChatBox("[!]#FFFFFF " .. targetPlayer .. " isimli oyuncudan [" .. itemValue .. "] adet olan [" .. itemID .. "] ID'li eşyayı götürdünüz.", thePlayer, 0, 255, 0)
						outputChatBox("[!]#FFFFFF " .. exports.rl_global:getPlayerFullAdminTitle(thePlayer) .. " isimli yetkili sizden [" .. itemValue .. "] adet olan [" .. itemID .. "] ID'li eşyayı götürdü.", targetPlayer, 0, 255, 0)
						exports.rl_logs:addLog("takeitem", exports.rl_global:getPlayerFullAdminTitle(thePlayer) .. " isimli yetkili " .. targetPlayerName .. " isimli oyuncudan [" .. itemValue .. "] adet olan [" .. itemID .. "] ID'li eşyayı götürdü.")
					else
						outputChatBox("[!]#FFFFFF Oyuncu bu öğeye sahip değil.", thePlayer, 255, 0, 0, true)
						playSoundFrontEnd(thePlayer, 4)
					end
                else
                    outputChatBox("[!]#FFFFFF Bu oyuncu karakterine giriş yapmadığı için işlem gerçekleşmedi.", thePlayer, 255, 0, 0, true)
                    playSoundFrontEnd(thePlayer, 4)
                end
            end
        else
            outputChatBox("KULLANIM: /" .. commandName .. " [Karakter Adı / ID] [Item ID] [Item adet]", thePlayer, 255, 194, 14)
        end
    else
        outputChatBox("[!]#FFFFFF Yeterli yetkiniz yok.", thePlayer, 255, 0, 0, true)
		playSoundFrontEnd(thePlayer, 4)
    end
end
addCommandHandler("takeitem", takePlayerItem, false, false)

function givePlayerGun(thePlayer, commandName, targetPlayer, weaponID)
    if exports.rl_integration:isPlayerLeaderAdmin(thePlayer) then
        if targetPlayer and weaponID and tonumber(weaponID) then
            weaponID = tonumber(weaponID)
            if getWeaponNameFromID(weaponID) then
                local targetPlayer, targetPlayerName = exports.rl_global:findPlayerByPartialNick(thePlayer, targetPlayer)
                if targetPlayer then
                    if getElementData(targetPlayer, "logged") then
                        local weaponSerial = exports.rl_global:createWeaponSerial(1, getElementData(thePlayer, "dbid"), getElementData(targetPlayer, "dbid"))
                        local itemValue = weaponID .. ":" .. weaponSerial .. ":" .. getWeaponNameFromID(weaponID) .. "::"
                        if exports.rl_items:hasSpaceForItem(targetPlayer, 115, itemValue) then
                            local success, reason = exports.rl_global:giveItem(targetPlayer, 115, itemValue)
                            if success then
                                outputChatBox("[!]#FFFFFF " .. targetPlayerName .. " isimli oyuncuya " .. getWeaponNameFromID(weaponID) .. " markalı silah verildi.", thePlayer, 0, 255, 0, true)
                                outputChatBox("[!]#FFFFFF " .. exports.rl_global:getPlayerFullAdminTitle(thePlayer) .. " isimli yetkili size " .. getWeaponNameFromID(weaponID) .. " markalı silah verdi.", targetPlayer, 0, 0, 255, true)
								exports.rl_logs:addLog("makegun", exports.rl_global:getPlayerFullAdminTitle(thePlayer) .. " isimli yetkili " .. targetPlayerName .. " isimli oyuncuya " .. getWeaponNameFromID(weaponID) .. " markalı silah verdi.")
                            else
                                outputChatBox("[!]#FFFFFF Bir sorun oluştu.", thePlayer, 255, 0, 0, true)
                                playSoundFrontEnd(thePlayer, 4)
                            end
                        else
                            outputChatBox("[!]#FFFFFF Bu oyuncunun envanterinde yeterli alan yok.", thePlayer, 255, 0, 0, true)
                            playSoundFrontEnd(thePlayer, 4)
                        end
                    else
                        outputChatBox("[!]#FFFFFF Bu oyuncu karakterine giriş yapmadığı için işlem gerçekleşmedi.", thePlayer, 255, 0, 0, true)
                        playSoundFrontEnd(thePlayer, 4)
                    end
                end
            else
                outputChatBox("[!]#FFFFFF Geçersiz silah ID.", thePlayer, 255, 0, 0, true)
                playSoundFrontEnd(thePlayer, 4)
            end
        else
            outputChatBox("KULLANIM: /" .. commandName .. " [Karakter Adı / ID] [Silah ID]", thePlayer, 255, 194, 14)
        end
    else
        outputChatBox("[!]#FFFFFF Yeterli yetkiniz yok.", thePlayer, 255, 0, 0, true)
		playSoundFrontEnd(thePlayer, 4)
    end
end
addCommandHandler("makegun", givePlayerGun, false, false)

function givePlayerAmmo(thePlayer, commandName, targetPlayer, weaponID, ammoClip)
    if exports.rl_integration:isPlayerLeaderAdmin(thePlayer) then
        if targetPlayer and weaponID and tonumber(weaponID) then
            weaponID = tonumber(weaponID)
			ammoClip = tonumber(ammoClip) or -1
            if getWeaponNameFromID(weaponID) then
                local targetPlayer, targetPlayerName = exports.rl_global:findPlayerByPartialNick(thePlayer, targetPlayer)
                if targetPlayer then
                    if getElementData(targetPlayer, "logged") then
						if ammoClip == -1 then
							ammoClip = getAmmoPerClip(weaponID)
						end
						
                        local itemValue = weaponID .. ":" .. ammoClip .. ":" .. getWeaponNameFromID(weaponID) .. " Mermisi"
                        if exports.rl_items:hasSpaceForItem(targetPlayer, 116, itemValue) then
                            local success, reason = exports.rl_global:giveItem(targetPlayer, 116, itemValue)
                            if success then
                                outputChatBox("[!]#FFFFFF " .. targetPlayerName .. " isimli oyuncuya " .. getWeaponNameFromID(weaponID) .. " markalı silah için " .. ammoClip .. " adet mermi verildi.", thePlayer, 0, 255, 0, true)
                                outputChatBox("[!]#FFFFFF " .. exports.rl_global:getPlayerFullAdminTitle(thePlayer) .. " isimli yetkili size " .. getWeaponNameFromID(weaponID) .. " markalı silah için " .. ammoClip .. " adet mermi verdi.", targetPlayer, 0, 0, 255, true)
								exports.rl_logs:addLog("makeammo", exports.rl_global:getPlayerFullAdminTitle(thePlayer) .. " isimli yetkili " .. targetPlayerName .. " isimli oyuncuya " .. getWeaponNameFromID(weaponID) .. " markalı silah için " .. ammoClip .. " adet mermi verdi.")
							else
                                outputChatBox("[!]#FFFFFF Bir sorun oluştu.", thePlayer, 255, 0, 0, true)
                                playSoundFrontEnd(thePlayer, 4)
                            end
                        else
                            outputChatBox("[!]#FFFFFF Bu oyuncunun envanterinde yeterli alan yok.", thePlayer, 255, 0, 0, true)
                            playSoundFrontEnd(thePlayer, 4)
                        end
                    else
                        outputChatBox("[!]#FFFFFF Bu oyuncu karakterine giriş yapmadığı için işlem gerçekleşmedi.", thePlayer, 255, 0, 0, true)
                        playSoundFrontEnd(thePlayer, 4)
                    end
                end
            else
                outputChatBox("[!]#FFFFFF Geçersiz silah ID.", thePlayer, 255, 0, 0, true)
                playSoundFrontEnd(thePlayer, 4)
            end
        else
            outputChatBox("KULLANIM: /" .. commandName .. " [Karakter Adı / ID] [Silah ID] [Mermi]", thePlayer, 255, 194, 14)
        end
    else
        outputChatBox("[!]#FFFFFF Yeterli yetkiniz yok.", thePlayer, 255, 0, 0, true)
		playSoundFrontEnd(thePlayer, 4)
    end
end
addCommandHandler("makeammo", givePlayerAmmo, false, false)

function clearMines(thePlayer, commandName)
    if exports.rl_integration:isPlayerServerManager(thePlayer) then
		for _, object in ipairs(getElementsByType("object")) do
			if getElementData(object, "mine") then
				destroyElement(object)
			end
		end
		
		for _, colshape in ipairs(getElementsByType("colshape")) do
			if getElementData(colshape, "mine") then
				destroyElement(colshape)
			end
		end
		
        outputChatBox("[!]#FFFFFF Başarıyla mayınlar temizlendi.", thePlayer, 0, 255, 0, true)
    end
end
addCommandHandler("clearmines", clearMines, false, false)