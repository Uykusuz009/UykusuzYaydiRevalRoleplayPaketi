local mysql = exports.rl_mysql

function adminDuty(thePlayer, commandName)
	if exports.rl_integration:isPlayerTrialAdmin(thePlayer) then
		local dutyAdmin = getElementData(thePlayer, "duty_admin") or false
		if dutyAdmin then
			setElementData(thePlayer, "duty_admin", false)
			exports.rl_global:updateNametagColor(thePlayer)
			exports.rl_global:sendMessageToAdmins("[ADUTY] " .. getPlayerName(thePlayer):gsub("_", " ") .. " görevden ayrıldı.")
		else
			setElementData(thePlayer, "duty_admin", true)
			exports.rl_global:updateNametagColor(thePlayer)
			exports.rl_global:sendMessageToAdmins("[ADUTY] " .. getPlayerName(thePlayer):gsub("_", " ") .. " göreve başladı.")
		end
	else
		outputChatBox("[!]#FFFFFF Yeterli yetkiniz yok.", thePlayer, 255, 0, 0, true)
		playSoundFrontEnd(thePlayer, 4)
	end
end
addCommandHandler("adminduty", adminDuty, false, false)
addCommandHandler("aduty", adminDuty, false, false)

function ahealPlayer(thePlayer, commandName, targetPlayer)
    if exports.rl_integration:isPlayerTrialAdmin(thePlayer) then
		if targetPlayer then
            local targetPlayer, targetPlayerName = exports.rl_global:findPlayerByPartialNick(thePlayer, targetPlayer)
            if targetPlayer then
                if getElementData(targetPlayer, "logged") then
                    setElementHealth(targetPlayer, 100)
					setElementData(targetPlayer, "hunger", 100)
					setElementData(targetPlayer, "thirst", 100)
				    outputChatBox("[!]#FFFFFF " .. targetPlayerName .. " isimli oyuncunun ihtiyaçlarını karşıladın.", thePlayer, 0, 255, 0, true)
				    outputChatBox("[!]#FFFFFF " .. exports.rl_global:getPlayerFullAdminTitle(thePlayer) .. " isimli yetkili ihtiyaçlarını karşıladı.", targetPlayer, 0, 0, 255, true)
					exports.rl_logs:addLog("aheal", exports.rl_global:getPlayerFullAdminTitle(thePlayer) .. " isimli yetkili " .. targetPlayerName .. " isimli oyuncunun ihtiyaçlarını karşıladı.")
                else
                    outputChatBox("[!]#FFFFFF Bu oyuncu karakterine giriş yapmadığı için işlem gerçekleşmedi.", thePlayer, 255, 0, 0, true)
                    playSoundFrontEnd(thePlayer, 4)
                end
            end
        else
            outputChatBox("KULLANIM: /" .. commandName .. " [Karakter Adı / ID]", thePlayer, 255, 194, 14)
        end
	else
		outputChatBox("[!]#FFFFFF Yeterli yetkiniz yok.", thePlayer, 255, 0, 0, true)
		playSoundFrontEnd(thePlayer, 4)
	end
end
addCommandHandler("aheal", ahealPlayer, false, false)

function setHealth(thePlayer, commandName, targetPlayer, health)
    if exports.rl_integration:isPlayerTrialAdmin(thePlayer) then
		if targetPlayer and health and tonumber(health) then
			health = math.floor(tonumber(health))
			if health >= 0 and health <= 100 then
				local targetPlayer, targetPlayerName = exports.rl_global:findPlayerByPartialNick(thePlayer, targetPlayer)
				if targetPlayer then
					if getElementData(targetPlayer, "logged") then
						if setElementHealth(targetPlayer, health) then
							outputChatBox("[!]#FFFFFF " .. targetPlayerName .. " isimli oyuncunun sağlamlığı [" .. health .. "] olarak değiştirildi.", thePlayer, 0, 255, 0, true)
							outputChatBox("[!]#FFFFFF " .. exports.rl_global:getPlayerFullAdminTitle(thePlayer) .. " isimli yetkili sağlamlığınızı [" .. health .. "] olarak değiştirdi.", targetPlayer, 0, 0, 255, true)
							exports.rl_logs:addLog("sethp", exports.rl_global:getPlayerFullAdminTitle(thePlayer) .. " isimli yetkili " .. targetPlayerName .. " isimli oyuncunun sağlamlığını [" .. health .. "] olarak değiştirdi.")
						else
							outputChatBox("[!]#FFFFFF Bir sorun oluştu.", thePlayer, 255, 0, 0, true)
							playSoundFrontEnd(thePlayer, 4)
						end
					else
						outputChatBox("[!]#FFFFFF Bu oyuncu karakterine giriş yapmadığı için işlem gerçekleşmedi.", thePlayer, 255, 0, 0, true)
						playSoundFrontEnd(thePlayer, 4)
					end
				end
			else
				outputChatBox("[!]#FFFFFF 0 - 100 arasında bir değer girmelisiniz.", thePlayer, 255, 0, 0, true)
				playSoundFrontEnd(thePlayer, 4)
			end
        else
            outputChatBox("KULLANIM: /" .. commandName .. " [Karakter Adı / ID] [Değer]", thePlayer, 255, 194, 14)
        end
	else
		outputChatBox("[!]#FFFFFF Yeterli yetkiniz yok.", thePlayer, 255, 0, 0, true)
		playSoundFrontEnd(thePlayer, 4)
	end
end
addCommandHandler("sethp", setHealth, false, false)

function setArmor(thePlayer, commandName, targetPlayer, armor)
    if exports.rl_integration:isPlayerSeniorAdmin(thePlayer) then
		if targetPlayer and armor and tonumber(armor) then
			armor = math.floor(tonumber(armor))
			if armor >= 0 and armor <= 100 then
				local targetPlayer, targetPlayerName = exports.rl_global:findPlayerByPartialNick(thePlayer, targetPlayer)
				if targetPlayer then
					if getElementData(targetPlayer, "logged") then
						if setPedArmor(targetPlayer, armor) then
							outputChatBox("[!]#FFFFFF " .. targetPlayerName .. " isimli oyuncunun zırhını [" .. armor .. "] olarak değiştirildi.", thePlayer, 0, 255, 0, true)
							outputChatBox("[!]#FFFFFF " .. exports.rl_global:getPlayerFullAdminTitle(thePlayer) .. " isimli yetkili zırhınızı [" .. armor .. "] olarak değiştirdi.", targetPlayer, 0, 0, 255, true)
							exports.rl_logs:addLog("setarmor", exports.rl_global:getPlayerFullAdminTitle(thePlayer) .. " isimli yetkili " .. targetPlayerName .. " isimli oyuncunun zırhını [" .. armor .. "] olarak değiştirdi.")
						else
							outputChatBox("[!]#FFFFFF Bir sorun oluştu.", thePlayer, 255, 0, 0, true)
							playSoundFrontEnd(thePlayer, 4)
						end
					else
						outputChatBox("[!]#FFFFFF Bu oyuncu karakterine giriş yapmadığı için işlem gerçekleşmedi.", thePlayer, 255, 0, 0, true)
						playSoundFrontEnd(thePlayer, 4)
					end
				end
			else
				outputChatBox("[!]#FFFFFF 0 - 100 arasında bir değer girmelisiniz.", thePlayer, 255, 0, 0, true)
				playSoundFrontEnd(thePlayer, 4)
			end
        else
            outputChatBox("KULLANIM: /" .. commandName .. " [Karakter Adı / ID] [Değer]", thePlayer, 255, 194, 14)
        end
	else
		outputChatBox("[!]#FFFFFF Yeterli yetkiniz yok.", thePlayer, 255, 0, 0, true)
		playSoundFrontEnd(thePlayer, 4)
	end
end
addCommandHandler("setarmor", setArmor, false, false)

function setSkin(thePlayer, commandName, targetPlayer, skin)
    if exports.rl_integration:isPlayerSeniorAdmin(thePlayer) then
		if targetPlayer and skin and tonumber(skin) then
			skin = math.floor(tonumber(skin))
			local targetPlayer, targetPlayerName = exports.rl_global:findPlayerByPartialNick(thePlayer, targetPlayer)
			if targetPlayer then
				if getElementData(targetPlayer, "logged") then
					if setElementModel(targetPlayer, skin) then
						dbExec(mysql:getConnection(), "UPDATE characters SET skin = ? WHERE id = ?", skin, getElementData(targetPlayer, "dbid"))
						outputChatBox("[!]#FFFFFF " .. targetPlayerName .. " isimli oyuncunun skinini [" .. skin .. "] olarak değiştirildi.", thePlayer, 0, 255, 0, true)
						outputChatBox("[!]#FFFFFF " .. exports.rl_global:getPlayerFullAdminTitle(thePlayer) .. " isimli yetkili skininizi [" .. skin .. "] olarak değiştirdi.", targetPlayer, 0, 0, 255, true)
						exports.rl_logs:addLog("setskin", exports.rl_global:getPlayerFullAdminTitle(thePlayer) .. " isimli yetkili " .. targetPlayerName .. " isimli oyuncunun skinini [" .. skin .. "] olarak değiştirdi.")
					else
						outputChatBox("[!]#FFFFFF Bir sorun oluştu.", thePlayer, 255, 0, 0, true)
						playSoundFrontEnd(thePlayer, 4)
					end
				else
					outputChatBox("[!]#FFFFFF Bu oyuncu karakterine giriş yapmadığı için işlem gerçekleşmedi.", thePlayer, 255, 0, 0, true)
					playSoundFrontEnd(thePlayer, 4)
				end
			end
        else
            outputChatBox("KULLANIM: /" .. commandName .. " [Karakter Adı / ID] [Skin ID]", thePlayer, 255, 194, 14)
        end
	else
		outputChatBox("[!]#FFFFFF Yeterli yetkiniz yok.", thePlayer, 255, 0, 0, true)
		playSoundFrontEnd(thePlayer, 4)
	end
end
addCommandHandler("setskin", setSkin, false, false)

function setInterior(thePlayer, commandName, targetPlayer, interior)
    if exports.rl_integration:isPlayerSeniorAdmin(thePlayer) then
		if targetPlayer and interior and tonumber(interior) then
			interior = math.floor(tonumber(interior))
			local targetPlayer, targetPlayerName = exports.rl_global:findPlayerByPartialNick(thePlayer, targetPlayer)
			if targetPlayer then
				if getElementData(targetPlayer, "logged") then
					local theVehicle = getPedOccupiedVehicle(targetPlayer)
                    if theVehicle then
						if setElementInterior(theVehicle, interior) then
							outputChatBox("[!]#FFFFFF " .. targetPlayerName .. " isimli oyuncunun interioru [" .. interior .. "] olarak değiştirildi.", thePlayer, 0, 255, 0, true)
							outputChatBox("[!]#FFFFFF " .. exports.rl_global:getPlayerFullAdminTitle(thePlayer) .. " isimli yetkili interiorunuzu [" .. interior .. "] olarak değiştirdi.", targetPlayer, 0, 0, 255, true)
							exports.rl_logs:addLog("setinterior", exports.rl_global:getPlayerFullAdminTitle(thePlayer) .. " isimli yetkili " .. targetPlayerName .. " isimli oyuncunun interioru [" .. interior .. "] olarak değiştirdi.")
						else
							outputChatBox("[!]#FFFFFF Bir sorun oluştu.", thePlayer, 255, 0, 0, true)
							playSoundFrontEnd(thePlayer, 4)
						end
					else
						if setElementInterior(targetPlayer, interior) then
							outputChatBox("[!]#FFFFFF " .. targetPlayerName .. " isimli oyuncunun interioru [" .. interior .. "] olarak değiştirildi.", thePlayer, 0, 255, 0, true)
							outputChatBox("[!]#FFFFFF " .. exports.rl_global:getPlayerFullAdminTitle(thePlayer) .. " isimli yetkili interiorunuzu [" .. interior .. "] olarak değiştirdi.", targetPlayer, 0, 0, 255, true)
							exports.rl_logs:addLog("setinterior", exports.rl_global:getPlayerFullAdminTitle(thePlayer) .. " isimli yetkili " .. targetPlayerName .. " isimli oyuncunun interioru [" .. interior .. "] olarak değiştirdi.")
						else
							outputChatBox("[!]#FFFFFF Bir sorun oluştu.", thePlayer, 255, 0, 0, true)
							playSoundFrontEnd(thePlayer, 4)
						end
					end
				else
					outputChatBox("[!]#FFFFFF Bu oyuncu karakterine giriş yapmadığı için işlem gerçekleşmedi.", thePlayer, 255, 0, 0, true)
					playSoundFrontEnd(thePlayer, 4)
				end
			end
        else
            outputChatBox("KULLANIM: /" .. commandName .. " [Karakter Adı / ID] [interior ID]", thePlayer, 255, 194, 14)
        end
	else
		outputChatBox("[!]#FFFFFF Yeterli yetkiniz yok.", thePlayer, 255, 0, 0, true)
		playSoundFrontEnd(thePlayer, 4)
	end
end
addCommandHandler("setinterior", setInterior, false, false)
addCommandHandler("setint", setInterior, false, false)

function setDimension(thePlayer, commandName, targetPlayer, dimension)
    if exports.rl_integration:isPlayerSeniorAdmin(thePlayer) then
		if targetPlayer and dimension and tonumber(dimension) then
			dimension = math.floor(tonumber(dimension))
			local targetPlayer, targetPlayerName = exports.rl_global:findPlayerByPartialNick(thePlayer, targetPlayer)
			if targetPlayer then
				if getElementData(targetPlayer, "logged") then
					local theVehicle = getPedOccupiedVehicle(targetPlayer)
                    if theVehicle then
						if setElementDimension(theVehicle, dimension) then
							triggerEvent("frames:loadInteriorTextures", targetPlayer, dimension)
							outputChatBox("[!]#FFFFFF " .. targetPlayerName .. " isimli oyuncunun dimensionu [" .. dimension .. "] olarak değiştirildi.", thePlayer, 0, 255, 0, true)
							outputChatBox("[!]#FFFFFF " .. exports.rl_global:getPlayerFullAdminTitle(thePlayer) .. " isimli yetkili dimensionunuzu [" .. dimension .. "] olarak değiştirdi.", targetPlayer, 0, 0, 255, true)
							exports.rl_logs:addLog("setdimension", exports.rl_global:getPlayerFullAdminTitle(thePlayer) .. " isimli yetkili " .. targetPlayerName .. " isimli oyuncunun dimensionunu [" .. dimension .. "] olarak değiştirdi.")
						else
							outputChatBox("[!]#FFFFFF Bir sorun oluştu.", thePlayer, 255, 0, 0, true)
							playSoundFrontEnd(thePlayer, 4)
						end
					else
						if setElementDimension(targetPlayer, dimension) then
							triggerEvent("frames:loadInteriorTextures", targetPlayer, dimension)
							outputChatBox("[!]#FFFFFF " .. targetPlayerName .. " isimli oyuncunun dimensionu [" .. dimension .. "] olarak değiştirildi.", thePlayer, 0, 255, 0, true)
							outputChatBox("[!]#FFFFFF " .. exports.rl_global:getPlayerFullAdminTitle(thePlayer) .. " isimli yetkili dimensionunuzu [" .. dimension .. "] olarak değiştirdi.", targetPlayer, 0, 0, 255, true)
							exports.rl_logs:addLog("setdimension", exports.rl_global:getPlayerFullAdminTitle(thePlayer) .. " isimli yetkili " .. targetPlayerName .. " isimli oyuncunun dimensionunu [" .. dimension .. "] olarak değiştirdi.")
						else
							outputChatBox("[!]#FFFFFF Bir sorun oluştu.", thePlayer, 255, 0, 0, true)
							playSoundFrontEnd(thePlayer, 4)
						end
					end
				else
					outputChatBox("[!]#FFFFFF Bu oyuncu karakterine giriş yapmadığı için işlem gerçekleşmedi.", thePlayer, 255, 0, 0, true)
					playSoundFrontEnd(thePlayer, 4)
				end
			end
        else
            outputChatBox("KULLANIM: /" .. commandName .. " [Karakter Adı / ID] [Dimension ID]", thePlayer, 255, 194, 14)
        end
	else
		outputChatBox("[!]#FFFFFF Yeterli yetkiniz yok.", thePlayer, 255, 0, 0, true)
		playSoundFrontEnd(thePlayer, 4)
	end
end
addCommandHandler("setdimension", setDimension, false, false)
addCommandHandler("setdim", setDimension, false, false)

function adminLoungeTeleport(thePlayer, commandName)
	if exports.rl_integration:isPlayerTrialAdmin(thePlayer) then
		setElementPosition(thePlayer, 817.4912109375, -1347.9521484375, 13.526844024658)
		setElementDimension(thePlayer, 0)
		setElementInterior(thePlayer, 0)
		triggerEvent("frames:loadInteriorTextures", thePlayer, 0)
	else
		outputChatBox("[!]#FFFFFF Yeterli yetkiniz yok.", thePlayer, 255, 0, 0, true)
		playSoundFrontEnd(thePlayer, 4)
	end
end
addCommandHandler("adminlounge", adminLoungeTeleport, false, false)
addCommandHandler("gmlounge", adminLoungeTeleport, false, false)

function gotoPlayer(thePlayer, commandName, targetPlayer)
    if exports.rl_integration:isPlayerTrialAdmin(thePlayer) then
        if targetPlayer then
            local targetPlayer, targetPlayerName = exports.rl_global:findPlayerByPartialNick(thePlayer, targetPlayer)
            if targetPlayer then
				if getElementData(targetPlayer, "logged") then
					detachElements(thePlayer)
					local theVehicle = getPedOccupiedVehicle(thePlayer)
					local x, y, z = getElementPosition(targetPlayer)
					local interior = getElementInterior(targetPlayer)
					local dimension = getElementDimension(targetPlayer)
					local rotation = getPedRotation(targetPlayer)
					
					x = x + ((math.cos(math.rad(rotation))) * 2)
					y = y + ((math.sin(math.rad(rotation))) * 2)
					
					if theVehicle then
						setElementPosition(theVehicle, x, y, z)
						setElementInterior(theVehicle, interior)
						setElementDimension(theVehicle, dimension)
					else
						setElementPosition(thePlayer, x, y, z)
						setElementInterior(thePlayer, interior)
						setElementDimension(thePlayer, dimension)
					end
					
					triggerEvent("frames:loadInteriorTextures", thePlayer, dimension)
					
					outputChatBox("[!]#FFFFFF " .. targetPlayerName .. " isimli oyuncuya ışınlandınız.", thePlayer, 0, 255, 0, true)
					outputChatBox("[!]#FFFFFF " .. exports.rl_global:getPlayerFullAdminTitle(thePlayer) .. " isimli yetkili size ışınlandı.", targetPlayer, 0, 0, 255, true)
					exports.rl_logs:addLog("goto", exports.rl_global:getPlayerFullAdminTitle(thePlayer) .. " isimli yetkili " .. targetPlayerName .. " isimli oyuncuya ışınlandı.")
				else
					outputChatBox("[!]#FFFFFF Bu oyuncu karakterine giriş yapmadığı için işlem gerçekleşmedi.", thePlayer, 255, 0, 0, true)
					playSoundFrontEnd(thePlayer, 4)
				end
            end
        else 
            outputChatBox("KULLANIM: /" .. commandName .. " [Karakter Adı / ID]", thePlayer, 255, 194, 14)
        end
    else
		outputChatBox("[!]#FFFFFF Yeterli yetkiniz yok.", thePlayer, 255, 0, 0, true)
		playSoundFrontEnd(thePlayer, 4)
	end
end
addCommandHandler("goto", gotoPlayer, false, false)

function getherePlayer(thePlayer, commandName, targetPlayer)
    if exports.rl_integration:isPlayerTrialAdmin(thePlayer) then
        if targetPlayer then
            local targetPlayer, targetPlayerName = exports.rl_global:findPlayerByPartialNick(thePlayer, targetPlayer)
            if targetPlayer then
				if getElementData(targetPlayer, "logged") then
					detachElements(thePlayer)
					local theVehicle = getPedOccupiedVehicle(targetPlayer)
					local x, y, z = getElementPosition(thePlayer)
					local interior = getElementInterior(thePlayer)
					local dimension = getElementDimension(thePlayer)
					local rotation = getPedRotation(thePlayer)
					
					x = x + ((math.cos(math.rad(rotation))) * 2)
					y = y + ((math.sin(math.rad(rotation))) * 2)
					
					if theVehicle then
						setElementPosition(theVehicle, x, y, z)
						setElementInterior(theVehicle, interior)
						setElementDimension(theVehicle, dimension)
					else
						setElementPosition(targetPlayer, x, y, z)
						setElementInterior(targetPlayer, interior)
						setElementDimension(targetPlayer, dimension)
					end
					
					triggerEvent("frames:loadInteriorTextures", targetPlayer, dimension)
					
					outputChatBox("[!]#FFFFFF " .. targetPlayerName .. " isimli oyuncuyu yanınıza çektiniz.", thePlayer, 0, 255, 0, true)
					outputChatBox("[!]#FFFFFF " .. exports.rl_global:getPlayerFullAdminTitle(thePlayer) .. " isimli yetkili sizi yanına çekti.", targetPlayer, 0, 0, 255, true)
					exports.rl_logs:addLog("gethere", exports.rl_global:getPlayerFullAdminTitle(thePlayer) .. " isimli yetkili " .. targetPlayerName .. " isimli oyuncuyu yanına çekti.")
				else
					outputChatBox("[!]#FFFFFF Bu oyuncu karakterine giriş yapmadığı için işlem gerçekleşmedi.", thePlayer, 255, 0, 0, true)
					playSoundFrontEnd(thePlayer, 4)
				end
            end
        else 
            outputChatBox("KULLANIM: /" .. commandName .. " [Karakter Adı / ID]", thePlayer, 255, 194, 14)
        end
    else
		outputChatBox("[!]#FFFFFF Yeterli yetkiniz yok.", thePlayer, 255, 0, 0, true)
		playSoundFrontEnd(thePlayer, 4)
	end
end
addCommandHandler("gethere", getherePlayer, false, false)

function slapPlayer(thePlayer, commandName, targetPlayer)
    if exports.rl_integration:isPlayerTrialAdmin(thePlayer) then
        if targetPlayer then
            local targetPlayer, targetPlayerName = exports.rl_global:findPlayerByPartialNick(thePlayer, targetPlayer)
            if targetPlayer then
				if getElementData(targetPlayer, "logged") then
					local x, y, z = getElementPosition(targetPlayer)
					if (isPedInVehicle(targetPlayer)) then
						removePedFromVehicle(targetPlayer)
					end
					detachElements(targetPlayer)
					setElementPosition(targetPlayer, x, y, z + 15)
					
					outputChatBox("[!]#FFFFFF " .. targetPlayerName .. " isimli oyuncu tokatlandı.", thePlayer, 0, 255, 0, true)
					outputChatBox("[!]#FFFFFF " .. exports.rl_global:getPlayerFullAdminTitle(thePlayer) .. " isimli yetkili sizi tokatladı.", targetPlayer, 0, 0, 255, true)
					exports.rl_logs:addLog("slap", exports.rl_global:getPlayerFullAdminTitle(thePlayer) .. " isimli yetkili " .. targetPlayerName .. " isimli oyuncuyu tokatladı.")
				else
					outputChatBox("[!]#FFFFFF Bu oyuncu karakterine giriş yapmadığı için işlem gerçekleşmedi.", thePlayer, 255, 0, 0, true)
					playSoundFrontEnd(thePlayer, 4)
				end
            end
        else 
            outputChatBox("KULLANIM: /" .. commandName .. " [Karakter Adı / ID]", thePlayer, 255, 194, 14)
        end
    else
		outputChatBox("[!]#FFFFFF Yeterli yetkiniz yok.", thePlayer, 255, 0, 0, true)
		playSoundFrontEnd(thePlayer, 4)
	end
end
addCommandHandler("slap", slapPlayer, false, false)

function disarmPlayer(thePlayer, commandName, targetPlayer)
	if exports.rl_integration:isPlayerLeaderAdmin(thePlayer) then
		if targetPlayer then
			local targetPlayer, targetPlayerName = exports.rl_global:findPlayerByPartialNick(thePlayer, targetPlayer)
			if targetPlayer then
				if getElementData(targetPlayer, "logged") then
					for i = 115, 116 do
						while exports.rl_items:takeItem(targetPlayer, i) do
						end
					end
					
					outputChatBox("[!]#FFFFFF " .. targetPlayerName .. " isimli oyuncunun tüm silahları silindi.", thePlayer, 0, 255, 0, true)
					outputChatBox("[!]#FFFFFF " .. exports.rl_global:getPlayerFullAdminTitle(thePlayer) .. " isimli yetkili tarafından tüm silahlarınız silindi.", targetPlayer, 255, 0, 0, true)
					exports.rl_global:sendMessageToAdmins("[DISARM] " .. exports.rl_global:getPlayerFullAdminTitle(thePlayer) .. " isimli yetkili " .. targetPlayerName .. " isimli oyuncunun tüm silahlarını sildi.")
					exports.rl_logs:addLog("disarm", exports.rl_global:getPlayerFullAdminTitle(thePlayer) .. " isimli yetkili " .. targetPlayerName .. " isimli oyuncunun tüm silahlarını sildi.")
				else
					outputChatBox("[!]#FFFFFF Bu oyuncu karakterine giriş yapmadığı için işlem gerçekleşmedi.", thePlayer, 255, 0, 0, true)
					playSoundFrontEnd(thePlayer, 4)
				end
			end
		else
			outputChatBox("KULLANIM: /" .. commandName .. " [Karakter Adı / ID]", thePlayer, 255, 194, 14)
		end
	else
		outputChatBox("[!]#FFFFFF Yeterli yetkiniz yok.", thePlayer, 255, 0, 0, true)
		playSoundFrontEnd(thePlayer, 4)
	end
end
addCommandHandler("disarm", disarmPlayer, false, false)

function changePlayerName(thePlayer, commandName, targetPlayer, ...)
	if exports.rl_integration:isPlayerAdmin3(thePlayer) then
		if targetPlayer and (...) then
			local newName = table.concat({...}, "_")
			local targetPlayer, targetPlayerName = exports.rl_global:findPlayerByPartialNick(thePlayer, targetPlayer)

			if targetPlayer then
				if getElementData(targetPlayer, "logged") then
					local hoursPlayed = getElementData(targetPlayer, "hours_played")
					if hoursPlayed > 10 and not exports.rl_integration:isPlayerAdmin1(thePlayer) then
						outputChatBox("[!]#FFFFFF Yalnızca elit veya daha yüksek seviyeler 10 saatten eski bir karakteri yeniden adlandırabilir.", thePlayer, 255, 0, 0, true)
						playSoundFrontEnd(thePlayer, 4)
						return false
					end
					
					if tonumber(newName) then
						if tonumber(newName) == -1 then
							newName = exports.rl_global:getRandomName("full", math.random(0, 1))
							newName = string.gsub(newName, " ", "_")
						end
					end
					
					if newName == targetPlayerName then
						outputChatBox("[!]#FFFFFF Bu oyuncunun adı.", thePlayer, 255, 0, 0, true)
						playSoundFrontEnd(thePlayer, 4)
					else
						local oldName = targetPlayerName
						setElementData(targetPlayer, "legal_name_change", true)
						if (setPlayerName(targetPlayer, newName)) then
							local dbid = getElementData(targetPlayer, "dbid")
							exports.rl_cache:clearCharacterName(dbid)
							dbExec(mysql:getConnection(), "UPDATE characters SET name = ? WHERE id = ?", newName, dbid)
							
							outputChatBox("[!]#FFFFFF " .. oldName .. " isimli oyuncunun adı " .. newName:gsub("_", " ") .. " olarak değiştirildi.", thePlayer, 0, 255, 0, true)
							outputChatBox("[!]#FFFFFF " .. exports.rl_global:getPlayerFullAdminTitle(thePlayer) .. " isimli yetkili adınızı " .. newName:gsub("_", " ") .. " olarak değiştirdi.", targetPlayer, 0, 0, 255, true)
							exports.rl_global:sendMessageToAdmins("[ADM] " .. exports.rl_global:getPlayerFullAdminTitle(thePlayer) .. " isimli yetkili " .. oldName .. " isimli oyuncunun adını " .. newName:gsub("_", " ") .. " olarak değiştirdi.")
							exports.rl_logs:addLog("changename", exports.rl_global:getPlayerFullAdminTitle(thePlayer) .. " isimli yetkili " .. oldName .. " isimli oyuncunun adını " .. newName:gsub("_", " ") .. " olarak değiştirdi.")
						else
							outputChatBox("[!]#FFFFFF Bir sorun oluştu.", thePlayer, 255, 0, 0, true)
							playSoundFrontEnd(thePlayer, 4)
						end
						setElementData(targetPlayer, "legal_name_change", false)
					end
				else
					outputChatBox("[!]#FFFFFF Bu oyuncu karakterine giriş yapmadığı için işlem gerçekleşmedi.", thePlayer, 255, 0, 0, true)
					playSoundFrontEnd(thePlayer, 4)
				end
			end
		else
			outputChatBox("KULLANIM: /" .. commandName .. " [Karakter Adı / ID] [Yeni Karakter Adı | -1 = Random]", thePlayer, 255, 194, 14)
		end
	else
		outputChatBox("[!]#FFFFFF Yeterli yetkiniz yok.", thePlayer, 255, 0, 0, true)
		playSoundFrontEnd(thePlayer, 4)
	end
end
addCommandHandler("changename", changePlayerName, false, false)

function hideAdmin(thePlayer, commandName)
	if exports.rl_integration:isPlayerManager(thePlayer) then
		local adminTitle = exports.rl_global:getPlayerAdminTitle(thePlayer) .. " " .. getPlayerName(thePlayer):gsub("_", " ") .. " (" .. getElementData(thePlayer, "account_username") .. ")"
		local hiddenAdmin = getElementData(thePlayer, "hidden_admin")
		if not hiddenAdmin then
			setElementData(thePlayer, "hidden_admin", true)
			outputChatBox("[!]#FFFFFF Gizli yetkililik başarıyla açıldı.", thePlayer, 0, 255, 0, true)
			exports.rl_global:sendMessageToAdmins("[ADM] " .. adminTitle .. " isimli yetkili gizli yetkililiği açtı.")
			exports.rl_logs:addLog("hideadmin", adminTitle .. " isimli yetkili gizli yetkililiği açtı.")
		else
			setElementData(thePlayer, "hidden_admin", false)
			outputChatBox("[!]#FFFFFF Gizli yetkililik başarıyla kapatıldı.", thePlayer, 255, 0, 0, true)
			exports.rl_global:sendMessageToAdmins("[ADM] " .. adminTitle .. " isimli yetkili gizli yetkililiği kapattı.")
			exports.rl_logs:addLog("hideadmin", adminTitle .. " isimli yetkili gizli yetkililiği kapattı.")
		end
		
		exports.rl_global:updateNametagColor(thePlayer)
		dbExec(mysql:getConnection(), "UPDATE accounts SET hidden_admin = " .. ((getElementData(thePlayer, "hidden_admin")) and 1 or 0) .. " WHERE id = " .. (getElementData(thePlayer, "account_id")))
	else
		outputChatBox("[!]#FFFFFF Yeterli yetkiniz yok.", thePlayer, 255, 0, 0, true)
		playSoundFrontEnd(thePlayer, 4)
	end
end
addCommandHandler("hideadmin", hideAdmin, false, false)

function forceReconnect(thePlayer, commandName, targetPlayer)
	if exports.rl_integration:isPlayerSeniorAdmin(thePlayer) then
		if targetPlayer then
			local targetPlayer, targetPlayerName = exports.rl_global:findPlayerByPartialNick(thePlayer, targetPlayer)

			if targetPlayer then
				local timer = setTimer(kickPlayer, 1000, 1, targetPlayer, root, exports.rl_global:getPlayerFullAdminTitle(thePlayer) .. " isimli yetkili tarafından force reconnect atıldınız.")
				addEventHandler("onPlayerQuit", targetPlayer, function()
					killTimer(timer)
				end)
				
				outputChatBox("[!]#FFFFFF " .. targetPlayerName .. " isimli oyuncuya force reconnect atıldı.", thePlayer, 255, 0, 0, true)
				exports.rl_global:sendMessageToAdmins("[ADM] " .. exports.rl_global:getPlayerFullAdminTitle(thePlayer) .. " isimli yetkili " .. targetPlayerName .. " isimli oyuncuya force reconnect attı.")
				exports.rl_logs:addLog("freconnect", exports.rl_global:getPlayerFullAdminTitle(thePlayer) .. " isimli yetkili " .. targetPlayerName .. " isimli oyuncuya force reconnect attı.")
				
				redirectPlayer(targetPlayer, "", 0)
			end
		else
			outputChatBox("KULLANIM: /" .. commandName .. " [Karakter Adı / ID]", thePlayer, 255, 194, 14)
		end
	else
		outputChatBox("[!]#FFFFFF Yeterli yetkiniz yok.", thePlayer, 255, 0, 0, true)
		playSoundFrontEnd(thePlayer, 4)
	end
end
addCommandHandler("freconnect", forceReconnect, false, false)
addCommandHandler("frec", forceReconnect, false, false)

function giveMoney(thePlayer, commandName, targetPlayer, amount, ...)
    if exports.rl_integration:isPlayerSeniorAdmin(thePlayer) then
		if targetPlayer and amount and tonumber(amount) and tonumber(amount) > 0 and (...) then
			amount = math.floor(amount)
            local reason = table.concat({...}, " ")
            if amount <= 10000000 then
                local targetPlayer, targetPlayerName = exports.rl_global:findPlayerByPartialNick(thePlayer, targetPlayer)
                if targetPlayer then
                    if getElementData(targetPlayer, "logged") then
                        if exports.rl_global:giveMoney(targetPlayer, amount) then
							outputChatBox("[!]#FFFFFF " .. targetPlayerName .. " isimli oyuncuya $" .. exports.rl_global:formatMoney(amount) .. " verildi.", thePlayer, 0, 255, 0, true)
							outputChatBox("[!]#FFFFFF " .. exports.rl_global:getPlayerFullAdminTitle(thePlayer) .. " isimli yetkili size $" .. exports.rl_global:formatMoney(amount) .. " verdi.", targetPlayer, 0, 0, 255, true)
							
							exports.rl_global:sendMessageToAdmins("[ADM] " .. exports.rl_global:getPlayerFullAdminTitle(thePlayer) .. " isimli yetkili " .. targetPlayerName .. " isimli oyuncuya $" .. exports.rl_global:formatMoney(amount) .. " verdi.")
							exports.rl_global:sendMessageToAdmins("[ADM] Sebep: " .. reason)
							
							exports.rl_logs:addLog("givemoney", exports.rl_global:getPlayerFullAdminTitle(thePlayer) .. " isimli yetkili " .. targetPlayerName .. " isimli oyuncuya $" .. exports.rl_global:formatMoney(amount) .. " verdi.\nSebep: " .. reason)
						else
							outputChatBox("[!]#FFFFFF Bir sorun oluştu.", thePlayer, 255, 0, 0, true)
							playSoundFrontEnd(thePlayer, 4)
						end
                    else
                        outputChatBox("[!]#FFFFFF Bu oyuncu karakterine giriş yapmadığı için işlem gerçekleşmedi.", thePlayer, 255, 0, 0, true)
                        playSoundFrontEnd(thePlayer, 4)
                    end
                end
            else
                outputChatBox("[!]#FFFFFF Birisine maksimum $10,000,000 verebilirsiniz.", thePlayer, 255, 0, 0, true)
                playSoundFrontEnd(thePlayer, 4)
            end
        else
            outputChatBox("KULLANIM: /" .. commandName .. " [Karakter Adı / ID] [Miktar] [Sebep]", thePlayer, 255, 194, 14)
        end
	else
		outputChatBox("[!]#FFFFFF Yeterli yetkiniz yok.", thePlayer, 255, 0, 0, true)
		playSoundFrontEnd(thePlayer, 4)
	end
end
addCommandHandler("givemoney", giveMoney, false, false)

function setMoney(thePlayer, commandName, targetPlayer, amount, ...)
    if exports.rl_integration:isPlayerSeniorAdmin(thePlayer) then
		if targetPlayer and amount and tonumber(amount) and tonumber(amount) > 0 and (...) then
			amount = math.floor(amount)
            local reason = table.concat({...}, " ")
            if amount <= 10000000 then
                local targetPlayer, targetPlayerName = exports.rl_global:findPlayerByPartialNick(thePlayer, targetPlayer)
                if targetPlayer then
                    if getElementData(targetPlayer, "logged") then
                        if exports.rl_global:setMoney(targetPlayer, amount) then
							outputChatBox("[!]#FFFFFF " .. targetPlayerName .. " isimli oyuncunun parası $" .. exports.rl_global:formatMoney(amount) .. " olarak ayarlandı.", thePlayer, 0, 255, 0, true)
							outputChatBox("[!]#FFFFFF " .. exports.rl_global:getPlayerFullAdminTitle(thePlayer) .. " isimli yetkili parası $" .. exports.rl_global:formatMoney(amount) .. " olarak ayarlandı.", targetPlayer, 0, 0, 255, true)
							
							exports.rl_global:sendMessageToAdmins("[ADM] " .. exports.rl_global:getPlayerFullAdminTitle(thePlayer) .. " isimli yetkili " .. targetPlayerName .. " isimli oyuncunun parasını $" .. exports.rl_global:formatMoney(amount) .. " olarak ayarladı.")
							exports.rl_global:sendMessageToAdmins("[ADM] Sebep: " .. reason)
							
							exports.rl_logs:addLog("setmoney", exports.rl_global:getPlayerFullAdminTitle(thePlayer) .. " isimli yetkili " .. targetPlayerName .. " isimli oyuncunun parasını $" .. exports.rl_global:formatMoney(amount) .. " olarak ayarladı.\nSebep: " .. reason)
						else
							outputChatBox("[!]#FFFFFF Bir sorun oluştu.", thePlayer, 255, 0, 0, true)
							playSoundFrontEnd(thePlayer, 4)
						end
                    else
                        outputChatBox("[!]#FFFFFF Bu oyuncu karakterine giriş yapmadığı için işlem gerçekleşmedi.", thePlayer, 255, 0, 0, true)
                        playSoundFrontEnd(thePlayer, 4)
                    end
                end
            else
                outputChatBox("[!]#FFFFFF Birisine maksimum $10,000,000 verebilirsiniz.", thePlayer, 255, 0, 0, true)
                playSoundFrontEnd(thePlayer, 4)
            end
        else
            outputChatBox("KULLANIM: /" .. commandName .. " [Karakter Adı / ID] [Miktar] [Sebep]", thePlayer, 255, 194, 14)
        end
	else
		outputChatBox("[!]#FFFFFF Yeterli yetkiniz yok.", thePlayer, 255, 0, 0, true)
		playSoundFrontEnd(thePlayer, 4)
	end
end
addCommandHandler("setmoney", setMoney, false, false)

function takeMoney(thePlayer, commandName, targetPlayer, amount, ...)
    if exports.rl_integration:isPlayerSeniorAdmin(thePlayer) then
		if targetPlayer and amount and tonumber(amount) and tonumber(amount) > 0 and (...) then
			amount = math.floor(amount)
            local reason = table.concat({...}, " ")
            local targetPlayer, targetPlayerName = exports.rl_global:findPlayerByPartialNick(thePlayer, targetPlayer)
            if targetPlayer then
                if getElementData(targetPlayer, "logged") then
                    if exports.rl_global:takeMoney(targetPlayer, amount) then
						outputChatBox("[!]#FFFFFF " .. targetPlayerName .. " isimli oyuncunun $" .. exports.rl_global:formatMoney(amount) .. " miktar parası kedildi.", thePlayer, 0, 255, 0, true)
						outputChatBox("[!]#FFFFFF " .. exports.rl_global:getPlayerFullAdminTitle(thePlayer) .. " isimli yetkili paranızdan $" .. exports.rl_global:formatMoney(amount) .. " kesdi.", targetPlayer, 0, 0, 255, true)
						
						exports.rl_global:sendMessageToAdmins("[ADM] " .. exports.rl_global:getPlayerFullAdminTitle(thePlayer) .. " isimli yetkili " .. targetPlayerName .. " isimli oyuncunun parasından $" .. exports.rl_global:formatMoney(amount) .. " kesdi.")
						exports.rl_global:sendMessageToAdmins("[ADM] Sebep: " .. reason)
						
						exports.rl_logs:addLog("takemoney", exports.rl_global:getPlayerFullAdminTitle(thePlayer) .. " isimli yetkili " .. targetPlayerName .. " isimli oyuncunun parasından $" .. exports.rl_global:formatMoney(amount) .. " kesdi.\nSebep: " .. reason)
					else
						outputChatBox("[!]#FFFFFF Bir sorun oluştu.", thePlayer, 255, 0, 0, true)
						playSoundFrontEnd(thePlayer, 4)
					end
                else
                    outputChatBox("[!]#FFFFFF Bu oyuncu karakterine giriş yapmadığı için işlem gerçekleşmedi.", thePlayer, 255, 0, 0, true)
                    playSoundFrontEnd(thePlayer, 4)
                end
            end
        else
            outputChatBox("KULLANIM: /" .. commandName .. " [Karakter Adı / ID] [Miktar] [Sebep]", thePlayer, 255, 194, 14)
        end
	else
		outputChatBox("[!]#FFFFFF Yeterli yetkiniz yok.", thePlayer, 255, 0, 0, true)
		playSoundFrontEnd(thePlayer, 4)
	end
end
addCommandHandler("takemoney", takeMoney, false, false)

function freezePlayer(thePlayer, commandName, targetPlayer)
    if exports.rl_integration:isPlayerTrialAdmin(thePlayer) then
		if targetPlayer then
            local targetPlayer, targetPlayerName = exports.rl_global:findPlayerByPartialNick(thePlayer, targetPlayer)
            if targetPlayer then
                if getElementData(targetPlayer, "logged") then
                    if not isElementFrozen(targetPlayer) then
						local theVehicle = getPedOccupiedVehicle(targetPlayer)
						if theVehicle then
							setElementFrozen(theVehicle, true)
							setElementFrozen(targetPlayer, true)
							toggleAllControls(targetPlayer, false, true, false)
						else
							detachElements(targetPlayer)
							toggleAllControls(targetPlayer, false, true, false)
							setElementFrozen(targetPlayer, true)
							triggerClientEvent(targetPlayer, "onClientPlayerWeaponCheck", targetPlayer)
							setPedWeaponSlot(targetPlayer, 0)
						end

						outputChatBox("[!]#FFFFFF " .. targetPlayerName .. " isimli oyuncu donduruldu.", thePlayer, 0, 255, 0, true)
						outputChatBox("[!]#FFFFFF " .. exports.rl_global:getPlayerFullAdminTitle(thePlayer) .. " isimli yetkili tarafından donduruldunuz.", targetPlayer, 0, 0, 255, true)
						exports.rl_logs:addLog("freeze", exports.rl_global:getPlayerFullAdminTitle(thePlayer) .. " isimli yetkili " .. targetPlayerName .. " isimli oyuncuyu dondurdu.")
					else
						outputChatBox("[!]#FFFFFF Bu oyuncu zaten dondurulmuş.", thePlayer, 255, 0, 0, true)
						playSoundFrontEnd(thePlayer, 4)
					end
                else
                    outputChatBox("[!]#FFFFFF Bu oyuncu karakterine giriş yapmadığı için işlem gerçekleşmedi.", thePlayer, 255, 0, 0, true)
                    playSoundFrontEnd(thePlayer, 4)
                end
            end
        else
            outputChatBox("KULLANIM: /" .. commandName .. " [Karakter Adı / ID]", thePlayer, 255, 194, 14)
        end
	else
		outputChatBox("[!]#FFFFFF Yeterli yetkiniz yok.", thePlayer, 255, 0, 0, true)
		playSoundFrontEnd(thePlayer, 4)
	end
end
addCommandHandler("freeze", freezePlayer, false, false)

function unfreezePlayer(thePlayer, commandName, targetPlayer)
    if exports.rl_integration:isPlayerTrialAdmin(thePlayer) then
		if targetPlayer then
            local targetPlayer, targetPlayerName = exports.rl_global:findPlayerByPartialNick(thePlayer, targetPlayer)
            if targetPlayer then
                if getElementData(targetPlayer, "logged") then
                    if isElementFrozen(targetPlayer) then
						local theVehicle = getPedOccupiedVehicle(targetPlayer)
						if theVehicle then
							setElementFrozen(theVehicle, false)
							setElementFrozen(targetPlayer, false)
							toggleAllControls(targetPlayer, true, true, true)
						else
							toggleAllControls(targetPlayer, true, true, true)
							setElementFrozen(targetPlayer, false)
							triggerClientEvent(targetPlayer, "onClientPlayerWeaponCheck", targetPlayer)
							setPedWeaponSlot(targetPlayer, 0)
						end

						outputChatBox("[!]#FFFFFF " .. targetPlayerName .. " isimli oyuncunun dondurulması açıldı.", thePlayer, 0, 255, 0, true)
						outputChatBox("[!]#FFFFFF " .. exports.rl_global:getPlayerFullAdminTitle(thePlayer) .. " isimli yetkili tarafından dondurulmanız açıldı.", targetPlayer, 0, 0, 255, true)
						exports.rl_logs:addLog("unfreeze", exports.rl_global:getPlayerFullAdminTitle(thePlayer) .. " isimli yetkili " .. targetPlayerName .. " isimli oyuncunun dondurulmasını açdı.")
					else
						outputChatBox("[!]#FFFFFF Bu oyuncu dondurulması yok.", thePlayer, 255, 0, 0, true)
						playSoundFrontEnd(thePlayer, 4)
					end
                else
                    outputChatBox("[!]#FFFFFF Bu oyuncu karakterine giriş yapmadığı için işlem gerçekleşmedi.", thePlayer, 255, 0, 0, true)
                    playSoundFrontEnd(thePlayer, 4)
                end
            end
        else
            outputChatBox("KULLANIM: /" .. commandName .. " [Karakter Adı / ID]", thePlayer, 255, 194, 14)
        end
	else
		outputChatBox("[!]#FFFFFF Yeterli yetkiniz yok.", thePlayer, 255, 0, 0, true)
		playSoundFrontEnd(thePlayer, 4)
	end
end
addCommandHandler("unfreeze", unfreezePlayer, false, false)

function disappearPlayer(thePlayer, commandName)
	if exports.rl_integration:isPlayerTrialAdmin(thePlayer) then
        if getElementAlpha(thePlayer) < 255 then
            setElementAlpha(thePlayer, 255)
            outputChatBox("[!]#FFFFFF Görünmezlik kapatıldı.", thePlayer, 255, 0, 0, true)
			exports.rl_logs:addLog("disappear", exports.rl_global:getPlayerFullAdminTitle(thePlayer) .. " isimli yetkili görünmezliğini kapattı.")
        else
            setElementAlpha(thePlayer, 0)
            outputChatBox("[!]#FFFFFF Görünmezlik açıldı.", thePlayer, 0, 255, 0, true)
			exports.rl_logs:addLog("disappear", exports.rl_global:getPlayerFullAdminTitle(thePlayer) .. " isimli yetkili görünmezliğini açtı.")
        end
	else
		outputChatBox("[!]#FFFFFF Yeterli yetkiniz yok.", thePlayer, 255, 0, 0, true)
		playSoundFrontEnd(thePlayer, 4)
	end
end
addCommandHandler("disappear", disappearPlayer, false, false)

function supervisePlayer(thePlayer, commandName)
	if exports.rl_integration:isPlayerTrialAdmin(thePlayer) then
        if getElementAlpha(thePlayer) < 255 then
            setElementAlpha(thePlayer, 255)
            outputChatBox("[!]#FFFFFF Supervise kapatıldı.", thePlayer, 255, 0, 0, true)
			exports.rl_logs:addLog("supervise", exports.rl_global:getPlayerFullAdminTitle(thePlayer) .. " isimli yetkili supervise kapattı.")
        else
            setElementAlpha(thePlayer, 100)
            outputChatBox("[!]#FFFFFF Supervise açıldı.", thePlayer, 0, 255, 0, true)
			exports.rl_logs:addLog("supervise", exports.rl_global:getPlayerFullAdminTitle(thePlayer) .. " isimli yetkili supervise açtı.")
        end
	else
		outputChatBox("[!]#FFFFFF Yeterli yetkiniz yok.", thePlayer, 255, 0, 0, true)
		playSoundFrontEnd(thePlayer, 4)
	end
end
addCommandHandler("supervise", supervisePlayer, false, false)

function sendPlayerToCity(thePlayer, commandName, targetPlayer)
	if exports.rl_integration:isPlayerTrialAdmin(thePlayer) then
		if targetPlayer then
			local targetPlayer, targetPlayerName = exports.rl_global:findPlayerByPartialNick(thePlayer, targetPlayer)
			if targetPlayer then
				if getElementData(targetPlayer, "logged") then
					local spawnPosition = exports.rl_global:getServerSettings().spawnPosition
					
					local theVehicle = getPedOccupiedVehicle(targetPlayer)
					if theVehicle then
						setElementPosition(theVehicle, spawnPosition.x + math.random(5), spawnPosition.y + math.random(5), spawnPosition.z)
						setElementRotation(theVehicle, 0, 0, spawnPosition.rotation)
						setElementInterior(theVehicle, 0)
						setElementDimension(theVehicle, 0)
					else 
						setElementPosition(targetPlayer, spawnPosition.x + math.random(5), spawnPosition.y + math.random(5), spawnPosition.z)
						setElementRotation(targetPlayer, 0, 0, spawnPosition.rotation)
						setElementInterior(targetPlayer, 0)
						setElementDimension(targetPlayer, 0)
					end
				
					outputChatBox("[!]#FFFFFF " .. targetPlayerName .. " isimli oyuncu şehre gönderildi.", thePlayer, 0, 255, 0, true)
					outputChatBox("[!]#FFFFFF " .. exports.rl_global:getPlayerFullAdminTitle(thePlayer) .. " isimli yetkili sizi şehre gönderdi.", targetPlayer, 0, 0, 255, true)
					exports.rl_logs:addLog("sehre", exports.rl_global:getPlayerFullAdminTitle(thePlayer) .. " isimli yetkili " .. targetPlayerName .. " isimli oyuncuyu şehre gönderildi.")
				else
                    outputChatBox("[!]#FFFFFF Bu oyuncu karakterine giriş yapmadığı için işlem gerçekleşmedi.", thePlayer, 255, 0, 0, true)
                    playSoundFrontEnd(thePlayer, 4)
                end
			end
		else
			outputChatBox("KULLANIM: /" .. commandName .. " [Karakter Adı / ID]", thePlayer, 255, 194, 14)
		end
	else
		outputChatBox("[!]#FFFFFF Yeterli yetkiniz yok.", thePlayer, 255, 0, 0, true)
		playSoundFrontEnd(thePlayer, 4)
	end
end
addCommandHandler("sehre", sendPlayerToCity, false, false)

function distributeMoney(thePlayer, commandName, amount)
    if exports.rl_integration:isPlayerGeneralAdmin(thePlayer) then
		if amount and tonumber(amount) and tonumber(amount) > 0 then
			amount = math.floor(amount)
			if amount <= 500000 then
				for _, player in ipairs(exports.rl_pool:getPoolElementsByType("player")) do
					if getElementData(player, "logged") then
						exports.rl_global:giveMoney(player, amount)
						exports.rl_infobox:addBox(player, "success", "Reval Roleplay'den herkese $" .. exports.rl_global:formatMoney(amount) .. " hediye!")
					end
				end
				exports.rl_logs:addLog("paradagit", exports.rl_global:getPlayerFullAdminTitle(thePlayer) .. " isimli yetkili $" .. exports.rl_global:formatMoney(amount) .. " dağıttı.")
			else
				outputChatBox("[!]#FFFFFF Güvenlik sebebiyle en fazla $500,000 dağıtabilirsiniz.", thePlayer, 255, 0, 0, true)
				playSoundFrontEnd(thePlayer, 4)
			end
		else
			outputChatBox("KULLANIM: /" .. commandName .. " [Miktar]", thePlayer, 255, 194, 14)
		end
    else
        outputChatBox("[!]#FFFFFF Yeterli yetkiniz yok.", thePlayer, 255, 0, 0, true)
		playSoundFrontEnd(thePlayer, 4)
    end
end
addCommandHandler("paradagit", distributeMoney, false, false)

local function showIPAlts(thePlayer, ip)
    local escapedIP = dbPrepareString(mysql:getConnection(), "SELECT `username`, `last_login` FROM `accounts` WHERE `ip` = ? ORDER BY `id` ASC", ip)
    local queryHandle = dbQuery(mysql:getConnection(), escapedIP)
    local result = dbPoll(queryHandle, -1)
    
    if result then
        local count = 0
        outputChatBox("IP Address: " .. ip, thePlayer)
        
        for _, row in ipairs(result) do
            if row["last_login"] == nil then
                row["last_login"] = "Asla"
            end
            
            local text = "#" .. count .. ": " .. tostring(row["username"])
            
            outputChatBox(text, thePlayer)
            count = count + 1
        end
        dbFree(queryHandle)
    end
end

function findAltAccIP(thePlayer, commandName, ...)
    if exports.rl_integration:isPlayerLeaderAdmin(thePlayer) then
        if not (...) then
            outputChatBox("KULLANIM: /" .. commandName .. " [Karakter Adı / ID]", thePlayer, 255, 194, 14)
        else
            local targetPlayerName = table.concat({...}, "_")
            local targetPlayer = exports.rl_global:findPlayerByPartialNick(nil, targetPlayerName)
            
            if not targetPlayer or not getElementData(targetPlayer, "logged") then
                local charQuery = dbPrepareString(mysql:getConnection(), "SELECT a.`ip` FROM `characters` c LEFT JOIN `accounts` a on c.`account`=a.`id` WHERE c.`name` = ?", targetPlayerName)
                local charHandle = dbQuery(mysql:getConnection(), charQuery)
                local charResult = dbPoll(charHandle, -1)
                
                if charResult and #charResult == 1 then
                    local ip = charResult[1]["ip"] or "0.0.0.0"
                    dbFree(charHandle)
                    showIPAlts(thePlayer, ip)
                    return
                end
                dbFree(charHandle)
                
                targetPlayerName = table.concat({...}, " ")
                
                local accountQuery = dbPrepareString(mysql:getConnection(), "SELECT ip FROM accounts WHERE username = ?", targetPlayerName)
                local accountHandle = dbQuery(mysql:getConnection(), accountQuery)
                local accountResult = dbPoll(accountHandle, -1)
                
                if accountResult and #accountResult == 1 then
                    local ip = accountResult[1]["ip"] or "0.0.0.0"
                    dbFree(accountHandle)
                    showIPAlts(thePlayer, ip)
                    return
                end
                dbFree(accountHandle)

                local ipQuery = dbPrepareString(mysql:getConnection(), "SELECT ip FROM accounts WHERE ip = ?", targetPlayerName)
                local ipHandle = dbQuery(mysql:getConnection(), ipQuery)
                local ipResult = dbPoll(ipHandle, -1)
                
                if ipResult and #ipResult >= 1 then
                    local ip = ipResult[1]["ip"] or "0.0.0.0"
                    dbFree(ipHandle)
                    showIPAlts(thePlayer, ip)
                    return
                end
                dbFree(ipHandle)

                outputChatBox("[!]#FFFFFF Oyuncu bulunamadı ve ya birden fazla oyuncu bulundu.", thePlayer, 255, 0, 0, true)
				playSoundFrontEnd(thePlayer, 4)
            else
                showIPAlts(thePlayer, getPlayerIP(targetPlayer))
            end
        end
    else
        outputChatBox("[!]#FFFFFF Yeterli yetkiniz yok.", thePlayer, 255, 0, 0, true)
		playSoundFrontEnd(thePlayer, 4)
    end
end
addCommandHandler("findip", findAltAccIP, false, false)

local function showAlts(thePlayer, id, creation)
    local query = dbPrepareString(mysql:getConnection(), "SELECT `name`, `cked`, `faction_id`, `last_login`, `creation_date`, `hours_played` FROM `characters` WHERE `account` = ? ORDER BY `name` ASC", id)
    dbQuery(function(queryHandle)
        local result = dbPoll(queryHandle, 0)
        if result then
            local nameQuery = dbPrepareString(mysql:getConnection(), "SELECT `username` FROM `accounts` WHERE `id` = ?", id)
            dbQuery(function(nameHandle)
                local nameResult = dbPoll(nameHandle, 0)
                if nameResult and #nameResult > 0 then
                    local name = nameResult[1]
                    local uname = name["username"]
                    if uname then
                        outputChatBox("Kullanıcı Adı: " .. uname, thePlayer, 255, 194, 14)
                    else
                        outputChatBox("?", thePlayer)
                    end
                else
                    outputChatBox("?", thePlayer)
                end
                dbFree(nameHandle)
            end, mysql:getConnection(), nameQuery)

            local count = 0
            for _, row in ipairs(result) do
                count = count + 1
                local r = 255
                if getPlayerFromName(row["name"]) then
                    r = 0
                end
                
                local text = "#" .. count .. ": " .. row["name"]:gsub("_", " ")
                if tonumber(row["cked"]) == 1 then
                    text = text .. " (İtkin)"
                elseif tonumber(row["cked"]) == 2 then
                    text = text .. " (Basdırılmış)"
                end
                
                if row["last_login"] then
                    text = text .. " - " .. tostring(row["last_login"])
                end
                
                if creation and row["creation_date"] then
                    text = text .. " - Yaradılıb " .. tostring(row["creation_date"])
                end
                
                local faction = tonumber(row["faction_id"]) or 0
                if faction > 0 and exports.rl_integration:isPlayerAdmin1(thePlayer) then
                    local theTeam = exports.rl_pool:getElement("team", faction)
                    if theTeam then
                        text = text .. " - " .. getTeamName(theTeam)
                    end
                end
                
                local hours = tonumber(row.hours_played)
                if hours and hours > 0 then
                    text = text .. " - " .. hours .. " saat"
                end
				
                outputChatBox(text, thePlayer, r, 255, 0)
            end
        end
        dbFree(queryHandle)
    end, mysql:getConnection(), query)
end

function findAltChars(thePlayer, commandName, ...)
    if exports.rl_integration:isPlayerTrialAdmin(thePlayer) then
        if not (...) then
            outputChatBox("KULLANIM: /" .. commandName .. " [Karakter Adı / ID]", thePlayer, 255, 194, 14)
        else
            local creation = commandName == "findalts2"
            local targetPlayerName = table.concat({...}, "_")
            local targetPlayer = targetPlayerName == "*" and thePlayer or exports.rl_global:findPlayerByPartialNick(nil, targetPlayerName)

            if not targetPlayer or not getElementData(targetPlayer, "logged") then
                local query = dbPrepareString(mysql:getConnection(), "SELECT account FROM characters WHERE name = ?", targetPlayerName)
                dbQuery(function(queryHandle, ...)
                    local result = dbPoll(queryHandle, 0)
                    if result and #result == 1 then
                        local id = tonumber(result[1]["account"]) or 0
                        showAlts(thePlayer, id, creation)
                    else
                        local query2 = dbPrepareString(mysql:getConnection(), "SELECT id FROM accounts WHERE username = ?", table.concat({...}, " "))
                        dbQuery(function(queryHandle2)
                            local result2 = dbPoll(queryHandle2, 0)
                            if result2 and #result2 == 1 then
                                local id = tonumber(result2[1]["id"]) or 0
                                showAlts(thePlayer, id, creation)
                            else
                                outputChatBox("[!]#FFFFFF Oyuncu bulunmadı veya birden fazla oyuncu bulundu.", thePlayer, 255, 0, 0, true)
								playSoundFrontEnd(thePlayer, 4)
                            end
                            dbFree(queryHandle2)
                        end, mysql:getConnection(), query2)
                    end
                    dbFree(queryHandle)
                end, {...}, mysql:getConnection(), query)
            else
                local id = getElementData(targetPlayer, "account_id")
                if id then
                    showAlts(thePlayer, id, creation)
                else
                    outputChatBox("[!]#FFFFFF Bu oyuncu karakterine giriş yapmadığı için işlem gerçekleşmedi.", thePlayer, 255, 0, 0, true)
                    playSoundFrontEnd(thePlayer, 4)
                end
            end
        end
    else
        outputChatBox("[!]#FFFFFF Yeterli yetkiniz yok.", thePlayer, 255, 0, 0, true)
		playSoundFrontEnd(thePlayer, 4)
    end
end
addCommandHandler("findalts", findAltChars)
addCommandHandler("findalts2", findAltChars)

local function showSerialAlts(thePlayer, serial)
    local query = dbPrepareString(mysql:getConnection(), "SELECT `username`, `last_login` FROM `accounts` WHERE serial = ?", serial)
    dbQuery(function(queryHandle)
        local result = dbPoll(queryHandle, 0)
        if result then
            local count = 0
            for _, row in ipairs(result) do
                count = count + 1
                if count == 1 then
                    outputChatBox("Serial: " .. serial, thePlayer)
                end

                local text = "#" .. count .. ": " .. row["username"]
                outputChatBox(text, thePlayer)
            end
        end
        dbFree(queryHandle)
    end, mysql:getConnection(), query)
end

function findAltAccSerial(thePlayer, commandName, ...)
    if exports.rl_integration:isPlayerLeaderAdmin(thePlayer) then
        if not (...) then
            outputChatBox("KULLANIM: /" .. commandName .. " [Kullanıcı Adı / Serial]", thePlayer, 255, 194, 14)
        else
            local targetPlayerName = table.concat({...}, "_")
            local targetPlayer = exports.rl_global:findPlayerByPartialNick(nil, targetPlayerName)

            if not targetPlayer then
                local query = dbPrepareString(mysql:getConnection(), "SELECT a.`serial` FROM `characters` c LEFT JOIN `accounts` a on c.`account`=a.`id` WHERE c.`name` = ?", targetPlayerName)
                dbQuery(function(queryHandle, ...)
                    local result = dbPoll(queryHandle, 0)
                    if result and #result == 1 then
                        local serial = result[1]["serial"] or "Bilinmiyor"
                        showSerialAlts(thePlayer, serial)
                    else
                        local targetPlayerName = table.concat({...}, " ")

                        local accountQuery = dbPrepareString(mysql:getConnection(), "SELECT `serial` FROM `accounts` WHERE `username` = ?", targetPlayerName)
                        dbQuery(function(accountQueryHandle)
                            local accountResult = dbPoll(accountQueryHandle, 0)
                            if accountResult and #accountResult == 1 then
                                local serial = accountResult[1]["serial"] or "Bilinmiyor"
                                showSerialAlts(thePlayer, serial)
                            else
                                local ipQuery = dbPrepareString(mysql:getConnection(), "SELECT `serial` FROM `accounts` WHERE `ip` = ?", targetPlayerName)
                                dbQuery(function(ipQueryHandle)
                                    local ipResult = dbPoll(ipQueryHandle, 0)
                                    if ipResult and #ipResult >= 1 then
                                        local serial = ipResult[1]["serial"] or "Bilinmiyor"
                                        showSerialAlts(thePlayer, serial)
                                    else
                                        local serialQuery = dbPrepareString(mysql:getConnection(), "SELECT `serial` FROM `accounts` WHERE `serial` = ?", targetPlayerName)
                                        dbQuery(function(serialQueryHandle)
                                            local serialResult = dbPoll(serialQueryHandle, 0)
                                            if serialResult and #serialResult >= 1 then
                                                local serial = serialResult[1]["serial"] or "Bilinmiyor"
                                                showSerialAlts(thePlayer, serial)
                                            else
                                                outputChatBox("[!]#FFFFFF Oyuncu bulunmadı veya birden fazla oyuncu bulundu.", thePlayer, 255, 0, 0, true)
												playSoundFrontEnd(thePlayer, 4)
                                            end
                                        end, mysql:getConnection(), serialQuery)
                                    end
                                end, mysql:getConnection(), ipQuery)
                            end
                        end, mysql:getConnection(), accountQuery)
                    end
                end, {...}, mysql:getConnection(), query)
            else
                showSerialAlts(thePlayer, getPlayerSerial(targetPlayer))
            end
        end
    else
        outputChatBox("[!]#FFFFFF Yeterli yetkiniz yok.", thePlayer, 255, 0, 0, true)
		playSoundFrontEnd(thePlayer, 4)
    end
end
addCommandHandler("findserial", findAltAccSerial, false, false)

function nudgePlayer(thePlayer, commandName, targetPlayer)
    if exports.rl_integration:isPlayerTrialAdmin(thePlayer) then
        if targetPlayer then
            local targetPlayer, targetPlayerName = exports.rl_global:findPlayerByPartialNick(thePlayer, targetPlayer)
            if targetPlayer then
				if getElementData(targetPlayer, "logged") then
					outputChatBox("[!]#FFFFFF " .. targetPlayerName .. " isimli oyuncuya uyarıldı.", thePlayer, 0, 255, 0, true)
					outputChatBox("[!]#FFFFFF " .. exports.rl_global:getPlayerFullAdminTitle(thePlayer) .. " isimli yetkili size uyardı.", targetPlayer, 0, 0, 255, true)
					triggerClientEvent(targetPlayer, "playNudgeSound", targetPlayer)
				else
					outputChatBox("[!]#FFFFFF Bu oyuncu karakterine giriş yapmadığı için işlem gerçekleşmedi.", thePlayer, 255, 0, 0, true)
					playSoundFrontEnd(thePlayer, 4)
				end
            end
        else 
            outputChatBox("KULLANIM: /" .. commandName .. " [Karakter Adı / ID]", thePlayer, 255, 194, 14)
        end
    else
        outputChatBox("[!]#FFFFFF Yeterli yetkiniz yok.", thePlayer, 255, 0, 0, true)
		playSoundFrontEnd(thePlayer, 4)
    end
end
addCommandHandler("nudge", nudgePlayer)

function findCharacterID(thePlayer, commandName, charID)
	if exports.rl_integration:isPlayerAdmin1(thePlayer) then
		if charID and tonumber(charID) and tonumber(charID) > 0 then
			charID = tonumber(charID)
			dbQuery(function(qh)
				local results, rows = dbPoll(qh, -1)
				if rows > 0 and results[1] then
					local charAccountID = results[1].account
					dbQuery(function(accountQuery)
						local accountResults, accountRows = dbPoll(accountQuery, -1)
						if accountRows > 0 and accountResults[1] then
							local accountName = accountResults[1].username
							outputChatBox("[!]#FFFFFF Bulundu: " .. results[1].name:gsub("_", " ") .. " (" .. accountName .. ")", thePlayer, 0, 255, 0, true)
						else
							outputChatBox("[!]#FFFFFF Böyle bir hesap bulunamadı.", thePlayer, 255, 0, 0, true)
						end
					end, mysql:getConnection(), "SELECT username FROM accounts WHERE id = ? LIMIT 1", charAccountID)
				else
					outputChatBox("[!]#FFFFFF Böyle bir karakter bulunamadı.", thePlayer, 255, 0, 0, true)
					playSoundFrontEnd(thePlayer, 4)
				end
			end, mysql:getConnection(), "SELECT * FROM characters WHERE id = ? LIMIT 1", charID)
		else
			outputChatBox("KULLANIM: /" .. commandName .. " [ID]", thePlayer, 255, 194, 14)
		end
	else
		outputChatBox("[!]#FFFFFF Yeterli yetkiniz yok.", thePlayer, 255, 0, 0, true)
		playSoundFrontEnd(thePlayer, 4)
	end
end
addCommandHandler("findcharid", findCharacterID, false, false)
addCommandHandler("cid", findCharacterID, false, false)
addCommandHandler("findcid", findCharacterID, false, false)
addCommandHandler("maskebul", findCharacterID, false, false)

function setVehicleLimit(thePlayer, commandName, targetPlayer, limit)
    if exports.rl_integration:isPlayerLeaderAdmin(thePlayer) then
		if targetPlayer and limit and tonumber(limit) then
			limit = math.floor(tonumber(limit))
			local targetPlayer, targetPlayerName = exports.rl_global:findPlayerByPartialNick(thePlayer, targetPlayer)
			if targetPlayer then
				if getElementData(targetPlayer, "logged") then
					setElementData(targetPlayer, "max_vehicles", limit)
					dbExec(mysql:getConnection(), "UPDATE characters SET max_vehicles = ? WHERE id = ?", limit, getElementData(targetPlayer, "dbid"))
					outputChatBox("[!]#FFFFFF " .. targetPlayerName .. " isimli oyuncunun araç limiti [" .. limit .. "] olarak değiştirdi.", thePlayer, 0, 255, 0, true)
					outputChatBox("[!]#FFFFFF " .. exports.rl_global:getPlayerFullAdminTitle(thePlayer) .. " isimli yetkili araç limitinizi [" .. limit .. "] olarak değitirdi.", targetPlayer, 0, 0, 255, true)
					exports.rl_logs:addLog("setvehlimit", exports.rl_global:getPlayerFullAdminTitle(thePlayer) .. " isimli yetkili " .. targetPlayerName .. " isimli oyuncunun araç limiti [" .. limit .. "] olarak değiştirdi.")
				else
					outputChatBox("[!]#FFFFFF Bu oyuncu karakterine giriş yapmadığı için işlem gerçekleşmedi.", thePlayer, 255, 0, 0, true)
					playSoundFrontEnd(thePlayer, 4)
				end
			end
        else
            outputChatBox("KULLANIM: /" .. commandName .. " [Karakter Adı / ID] [Limit]", thePlayer, 255, 194, 14)
        end
	else
		outputChatBox("[!]#FFFFFF Yeterli yetkiniz yok.", thePlayer, 255, 0, 0, true)
		playSoundFrontEnd(thePlayer, 4)
	end
end
addCommandHandler("setvehlimit", setVehicleLimit, false, false)

function setInteriorLimit(thePlayer, commandName, targetPlayer, limit)
    if exports.rl_integration:isPlayerLeaderAdmin(thePlayer) then
		if targetPlayer and limit and tonumber(limit) then
			limit = math.floor(tonumber(limit))
			local targetPlayer, targetPlayerName = exports.rl_global:findPlayerByPartialNick(thePlayer, targetPlayer)
			if targetPlayer then
				if getElementData(targetPlayer, "logged") then
					setElementData(targetPlayer, "max_interiors", limit)
					dbExec(mysql:getConnection(), "UPDATE characters SET max_interiors = ? WHERE id = ?", limit, getElementData(targetPlayer, "dbid"))
					outputChatBox("[!]#FFFFFF " .. targetPlayerName .. " isimli oyuncunun ev limiti [" .. limit .. "] olarak değiştirildi.", thePlayer, 0, 255, 0, true)
					outputChatBox("[!]#FFFFFF " .. exports.rl_global:getPlayerFullAdminTitle(thePlayer) .. " isimli yetkili ev limitinizi [" .. limit .. "] olarak değiştirildi.", targetPlayer, 0, 0, 255, true)
					exports.rl_logs:addLog("setintlimit", exports.rl_global:getPlayerFullAdminTitle(thePlayer) .. " isimli yetkili " .. targetPlayerName .. " isimli oyuncunun ec limiti [" .. limit .. "] olarak değiştirildi.")
				else
					outputChatBox("[!]#FFFFFF Bu oyuncu karakterine giriş yapmadığı için işlem gerçekleşmedi.", thePlayer, 255, 0, 0, true)
					playSoundFrontEnd(thePlayer, 4)
				end
			end
        else
            outputChatBox("KULLANIM: /" .. commandName .. " [Karakter Adı / ID] [Limit]", thePlayer, 255, 194, 14)
        end
	else
		outputChatBox("[!]#FFFFFF Yeterli yetkiniz yok.", thePlayer, 255, 0, 0, true)
		playSoundFrontEnd(thePlayer, 4)
	end
end
addCommandHandler("setintlimit", setInteriorLimit, false, false)

function earthquake(thePlayer, commandName)
	if exports.rl_integration:isPlayerDeveloper(thePlayer) then
		for _, player in ipairs(getElementsByType("player")) do
			triggerClientEvent(root, "doEarthquake", player)
		end
	else
		outputChatBox("[!]#FFFFFF Yeterli yetkiniz yok.", thePlayer, 255, 0, 0, true)
		playSoundFrontEnd(thePlayer, 4)
	end
end
addCommandHandler("deprem", earthquake, false, false)

function getPlayerID(thePlayer, commandName, targetPlayer)
	if targetPlayer then
		local targetPlayer, targetPlayerName = exports.rl_global:findPlayerByPartialNick(thePlayer, targetPlayer)
		if targetPlayer then
			if getElementData(targetPlayer, "logged") then
				local id = getElementData(targetPlayer, "id")
				local level = getElementData(targetPlayer, "level")
				outputChatBox(">>#FFFFFF " .. targetPlayerName .. " isimli oyuncunun ID: " .. id .. " - Seviye: " .. level, thePlayer, 0, 255, 0, true)
			else
				outputChatBox("[!]#FFFFFF Bu oyuncu karakterine giriş yapmadığı için işlem gerçekleşmedi.", thePlayer, 255, 0, 0, true)
				playSoundFrontEnd(thePlayer, 4)
			end
		end
	else
		outputChatBox("KULLANIM: /" .. commandName .. " [Karakter Adı / ID]", thePlayer, 255, 194, 14)
	end
end
addCommandHandler("getid", getPlayerID, false, false)
addCommandHandler("id", getPlayerID, false, false)

function setUsername(thePlayer, commandName, username, newUsername)
    if exports.rl_integration:isPlayerManager(thePlayer) then
        if username and newUsername then
            dbQuery(function(qh)
                local results, rows = dbPoll(qh, -1)
                if rows > 0 and results[1] then
					local data = results[1]
                    local query = dbExec(mysql:getConnection(), "UPDATE accounts SET username = ? WHERE id = ? LIMIT 1", newUsername, tonumber(data.id))
					if query then
						for _, player in ipairs(getElementsByType("player")) do
							if getElementData(player, "account_username") == username then
								setElementData(player, "account_username", newUsername)
							end
						end
						
						outputChatBox("[!]#FFFFFF [" .. username .. "] isimli kullanıcının kullanıcı adı [" .. newUsername .. "] olarak değiştirildi.", thePlayer, 0, 255, 0, true)
						exports.rl_logs:addLog("setusername", exports.rl_global:getPlayerFullAdminTitle(thePlayer) .. " isimli yetkili [" .. username .. "] isimli kullanıcının kullanıcı adını [" .. newUsername .. "] olarak değiştirildi.")
					else
						outputChatBox("[!]#FFFFFF Bir sorun oluştu.", thePlayer, 255, 0, 0, true)
						playSoundFrontEnd(thePlayer, 4)
					end
				else
                    outputChatBox("[!]#FFFFFF Kullanıcı adı bulunamadı.", thePlayer, 255, 0, 0, true)
                    playSoundFrontEnd(thePlayer, 4)
                end
            end, mysql:getConnection(), "SELECT * FROM accounts WHERE username = ? LIMIT 1", username)
        else
            outputChatBox("KULLANIM: /" .. commandName .. " [Kullanıcı Adı] [Yeni Kullanıcı Adı]", thePlayer, 255, 194, 14)
        end
    else
        outputChatBox("[!]#FFFFFF Yeterli yetkiniz yok.", thePlayer, 255, 0, 0, true)
        playSoundFrontEnd(thePlayer, 4)
    end
end
addCommandHandler("setusername", setUsername, false, false)

function setPassword(thePlayer, commandName, username, password, passwordAgain)
    if exports.rl_integration:isPlayerManager(thePlayer) then
        if username and password and passwordAgain then
			if string.len(password) >= 6 and string.len(password) <= 32 then
				if password == passwordAgain then
					dbQuery(function(qh)
						local results, rows = dbPoll(qh, -1)
						if rows > 0 and results[1] then
							local data = results[1]
							
							local salt = exports.rl_global:generateSalt(16)
							local saltedPassword = salt .. password 
							local hashedPassword = string.lower(hash("sha256", saltedPassword))
							
							local query = dbExec(mysql:getConnection(), "UPDATE accounts SET password = ?, salt = ? WHERE id = ? LIMIT 1", hashedPassword, salt, tonumber(data.id))
							if query then
								outputChatBox("[!]#FFFFFF [" .. username .. "] isimli kullanıcının şifresi değiştirildi.", thePlayer, 0, 255, 0, true)
								exports.rl_logs:addLog("setpassword", exports.rl_global:getPlayerFullAdminTitle(thePlayer) .. " isimli yetkili [" .. username .. "] isimli kullanıcının şifresi değiştirldi.")
							else
								outputChatBox("[!]#FFFFFF Bir sorun oluştu.", thePlayer, 255, 0, 0, true)
								playSoundFrontEnd(thePlayer, 4)
							end
						else
							outputChatBox("[!]#FFFFFF Kullanıcı adı bulunamadı.", thePlayer, 255, 0, 0, true)
							playSoundFrontEnd(thePlayer, 4)
						end
					end, mysql:getConnection(), "SELECT * FROM accounts WHERE username = ? LIMIT 1", username)
				else
					outputChatBox("[!]#FFFFFF Şifreler uygun değil.", thePlayer, 255, 0, 0, true)
					playSoundFrontEnd(thePlayer, 4)
				end
			else
				outputChatBox("[!]#FFFFFF Şifre 6 ile 32 arasında olmalıdır.", thePlayer, 255, 0, 0, true)
				playSoundFrontEnd(thePlayer, 4)
			end
        else
            outputChatBox("KULLANIM: /" .. commandName .. " [Kullanıcı Adı] [Yeni Şifreniz] [Yeni Şifreniz 2x]", thePlayer, 255, 194, 14)
        end
    else
        outputChatBox("[!]#FFFFFF Yeterli yetkiniz yok.", thePlayer, 255, 0, 0, true)
        playSoundFrontEnd(thePlayer, 4)
    end
end
addCommandHandler("setpassword", setPassword, false, false)

function setSerial(thePlayer, commandName, username, newSerial)
    if exports.rl_integration:isPlayerManager(thePlayer) then
        if username and newSerial then
            dbQuery(function(qh)
                local results, rows = dbPoll(qh, -1)
                if rows > 0 and results[1] then
					local data = results[1]
                    local query = dbExec(mysql:getConnection(), "UPDATE accounts SET serial = ? WHERE id = ? LIMIT 1", newSerial, tonumber(data.id))
					if query then
						outputChatBox("[!]#FFFFFF [" .. username .. "] isimli kullanıcının serialı [" .. newSerial .. "] olarak değiştirildi.", thePlayer, 0, 255, 0, true)
						exports.rl_logs:addLog("setserial", exports.rl_global:getPlayerFullAdminTitle(thePlayer) .. " isimli yetkili [" .. username .. "] isimli kullanıcının serialı [" .. newSerial .. "] olarak değiştirildi.")
					else
						outputChatBox("[!]#FFFFFF Bir sorun oluştu.", thePlayer, 255, 0, 0, true)
						playSoundFrontEnd(thePlayer, 4)
					end
				else
                    outputChatBox("[!]#FFFFFF Kullanıcı adı bulunamadı.", thePlayer, 255, 0, 0, true)
                    playSoundFrontEnd(thePlayer, 4)
                end
            end, mysql:getConnection(), "SELECT * FROM accounts WHERE username = ? LIMIT 1", username)
        else
            outputChatBox("KULLANIM: /" .. commandName .. " [Kullanıcı Adı] [Yeni Serial]", thePlayer, 255, 194, 14)
        end
    else
        outputChatBox("[!]#FFFFFF Yeterli yetkiniz yok.", thePlayer, 255, 0, 0, true)
        playSoundFrontEnd(thePlayer, 4)
    end
end
addCommandHandler("setserial", setSerial, false, false)

function getKey(thePlayer, commandName)
	if exports.rl_integration:isPlayerGeneralAdmin(thePlayer) then
		local adminName = getPlayerName(thePlayer):gsub(" ", "_")
		local veh = getPedOccupiedVehicle(thePlayer)
		if veh then
			local vehID = getElementData(veh, "dbid")
			givePlayerItem(thePlayer, "giveitem" , adminName, "3" , tostring(vehID))
			outputChatBox("[!]#FFFFFF Başarıyla [" .. vehID .. "] ID'li aracın anahtarı çıkarıldı.", thePlayer, 0, 255, 0, true)
			exports.rl_global:sendMessageToAdmins("[ADM] " .. exports.rl_global:getPlayerFullAdminTitle(thePlayer) .. " isimli yetkili [" .. vehID .. "] ID'li aracın anahtarını çıxartdı.")
			exports.rl_logs:addLog("getkey", exports.rl_global:getPlayerFullAdminTitle(thePlayer) .. " isimli yetkili [" .. vehID .. "] ID'li aracın anahtarını çıxartdı.")
			return true
		else
			local intID = getElementDimension(thePlayer)
			if intID then
				local foundIntID = false
				local keyType = false
				local possibleInteriors = getElementsByType("interior")
				for _, theInterior in pairs(possibleInteriors) do
					if getElementData(theInterior, "dbid") == intID then
						local intType = getElementData(theInterior, "status")[1] 
						if intType == 0 or intType == 2 or intType == 3 then
							keyType = 4
						else
							keyType = 5
						end
						foundIntID = intID
						break
					end
				end
				
				if foundIntID and keyType then
					givePlayerItem(thePlayer, "giveitem" , adminName, tostring(keyType), tostring(foundIntID))
				outputChatBox("[!]#FFFFFF Başarıyla [" .. vehID .. "] ID'li interiorun anahtar çıkarıldı.", thePlayer, 0, 255, 0, true)
					exports.rl_global:sendMessageToAdmins("[ADM] " .. exports.rl_global:getPlayerFullAdminTitle(thePlayer) .. " isimli yetkili [" .. foundIntID .. "] ID'li interiorun anahtarını çıkardı.")
					exports.rl_logs:addLog("getkey", exports.rl_global:getPlayerFullAdminTitle(thePlayer) .. " isimli yetkili [" .. foundIntID .. "] ID'li interiorun anahtarını çıkardı.")
					return true
				else
					outputChatBox("[!]#FFFFFF Lütfen araca veya interiora girin.", thePlayer, 255, 0, 0, true)
					playSoundFrontEnd(thePlayer, 4)
					return false
				end
			end
		end
	else
        outputChatBox("[!]#FFFFFF Yeterli yetkiniz yok.", thePlayer, 255, 0, 0, true)
		playSoundFrontEnd(thePlayer, 4)
    end
end
addCommandHandler("getkey", getKey, false, false)

function setServerPasswordCommand(thePlayer, commandName, password)
	if exports.rl_integration:isPlayerDeveloper(thePlayer)	then
		outputChatBox("KULLANIM: /" .. commandName .. " [Şifre]", thePlayer, 255, 194, 14)
		if password and string.len(password) > 0 then
			if setServerPassword(password) then
				exports.rl_global:sendMessageToAdmins("[SERVER] " .. exports.rl_global:getPlayerFullAdminTitle(thePlayer) .. " isimli yetkili sunucunun sunucunun şifresini değiştirdi. (" .. password .. ")", true)
			end
		else
			if setServerPassword("") then
				exports.rl_global:sendMessageToAdmins("[SERVER] " .. exports.rl_global:getPlayerFullAdminTitle(thePlayer) .. " isimli yetkili sunucunun şifresini kaldırdı.", true)
			end
		end
	end
end
addCommandHandler("setserverpassword", setServerPasswordCommand, false, false)
addCommandHandler("setserverpw", setServerPasswordCommand, false, false)

function giveawayCommand(thePlayer, commandName)
    if exports.rl_integration:isPlayerManager(thePlayer) then
        local eligiblePlayers = {}
        
        for _, player in ipairs(getElementsByType("player")) do
            if getElementData(player, "logged") then
                table.insert(eligiblePlayers, player)
            end
        end

        if #eligiblePlayers > 0 then
            local randomIndex = math.random(1, #eligiblePlayers)
            local randomPlayer = eligiblePlayers[randomIndex]
            
            outputChatBox(">>#FFFFFF " .. exports.rl_global:getPlayerFullAdminTitle(thePlayer) .. " isimli yetkili tarafından seçilen rastgele oyuncu: " .. getPlayerName(randomPlayer):gsub("_", " ") .. " (" .. (getElementData(randomPlayer, "id") or 0) .. ")", root, 0, 255, 0, true)
        else
            outputChatBox("[!]#FFFFFF Seçilebilecek giriş yapmış oyuncu yok.", thePlayer, 255, 0, 0, true)
        end
    else
        outputChatBox("[!]#FFFFFF Yeterli yetkiniz yok.", thePlayer, 255, 0, 0, true)
        playSoundFrontEnd(thePlayer, 4)
    end
end
addCommandHandler("giveaway", giveawayCommand, false, false)

function blowPlayer(thePlayer, commandName, targetPlayer)
    if exports.rl_integration:isPlayerDeveloper(thePlayer) then
		if targetPlayer then
            local targetPlayer, targetPlayerName = exports.rl_global:findPlayerByPartialNick(thePlayer, targetPlayer)
            if targetPlayer then
                if getElementData(targetPlayer, "logged") then
                    local x, y, z = getElementPosition(targetPlayer)
					createExplosion(x, y, z, 4, thePlayer)
                else
                    outputChatBox("[!]#FFFFFF Bu oyuncu karakterine giriş yapmadığı için işlem gerçekleşmedi.", thePlayer, 255, 0, 0, true)
                    playSoundFrontEnd(thePlayer, 4)
                end
            end
        else
            outputChatBox("KULLANIM: /" .. commandName .. " [Karakter Adı / ID]", thePlayer, 255, 194, 14)
        end
	else
		outputChatBox("[!]#FFFFFF Yeterli yetkiniz yok.", thePlayer, 255, 0, 0, true)
		playSoundFrontEnd(thePlayer, 4)
	end
end
addCommandHandler("blow", blowPlayer, false, false)