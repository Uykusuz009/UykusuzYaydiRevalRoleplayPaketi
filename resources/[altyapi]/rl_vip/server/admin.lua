local mysql = exports.rl_mysql

function vipVer(thePlayer, commandName, targetPlayer, rank, days)
	if exports.rl_integration:isPlayerDeveloper(thePlayer) then
		if (not targetPlayer or not tonumber(rank) or not tonumber(days) or (tonumber(rank) < 0 or tonumber(rank) > 4)) then
			outputChatBox("KULLANIM: /" .. commandName .. " [Karakter Adı / ID] [1-4] [Gün]", thePlayer, 255, 194, 14)
		else
			rank = math.floor(tonumber(rank))
			days = math.floor(tonumber(days))
			local targetPlayer, targetPlayerName = exports.rl_global:findPlayerByPartialNick(thePlayer, targetPlayer)
			if targetPlayer then
				if getElementData(targetPlayer, "logged") then
					local charID = getElementData(targetPlayer, "dbid")
					local endTick = math.max(days, 1) * 24 * 60 * 60 * 1000
					if not isPlayerVIP(charID) then
						local id = SmallestID()
						
						dbExec(mysql:getConnection(), "INSERT INTO `vips` (`id`, `char_id`, `vip_type`, `vip_end_tick`) VALUES (?, ?, ?, ?)", id, charID, rank, endTick)
					
						outputChatBox("[!]#FFFFFF " .. targetPlayerName .. " isimli oyuncuya " .. days .. " günlük VIP [" .. rank .. "] verildi.", thePlayer, 0, 255, 0, true)
						outputChatBox("[!]#FFFFFF " .. exports.rl_global:getPlayerFullAdminTitle(thePlayer) .. " isimli yetkili size " .. days .. " günlük VIP [" .. rank .. "] verdi.", targetPlayer, 0, 255, 0, true)
						exports.rl_logs:addLog("vip", exports.rl_global:getPlayerFullAdminTitle(thePlayer) .. " isimli yetkili " .. targetPlayerName .. " isimli oyuncuya " .. days .. " günlük VIP [" .. rank .. "] verdi.")
					
						loadVIP(charID)
					else
						if rank ~= getElementData(thePlayer, "vip") then 
							outputChatBox("[!]#FFFFFF Bu oyuncuya vermeye çalıştığınız VIP [" .. rank .. "] seviyesine sahip değil.", thePlayer, 255, 0, 0, true)
							playSoundFrontEnd(thePlayer, 4)
							return
						end
						
						dbExec(mysql:getConnection(), "UPDATE `vips` SET vip_end_tick = vip_end_tick + ? WHERE char_id = ? and vip_type = ? LIMIT 1", endTick, charID, rank)
						
						outputChatBox("[!]#FFFFFF " .. targetPlayerName .. " isimli oyuncunun VIP süresine " .. days .. " gün ilave edildi.", thePlayer, 0, 255, 0, true)
						outputChatBox("[!]#FFFFFF " .. exports.rl_global:getPlayerFullAdminTitle(thePlayer) .. " isimli yetkili VIP [" .. rank .. "] sürenizi " .. days .. " gün uzatdı.", targetPlayer, 0, 255, 0, true)
						exports.rl_logs:addLog("vip", exports.rl_global:getPlayerFullAdminTitle(thePlayer) .. " isimli yetkili " .. targetPlayerName .. " isimli oyuncunun VIP [" .. rank .. "] süreni " .. days .. " gün uzatdı.")
						
						loadVIP(charID)
					end
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
addCommandHandler("vipver", vipVer, false, false)

function vipAl(thePlayer, commandName, targetPlayer)
	if exports.rl_integration:isPlayerDeveloper(thePlayer) then
		if (not targetPlayer) then
			outputChatBox("KULLANIM: /" .. commandName .. " [Karakter Adı / ID]", thePlayer, 255, 194, 14)
		else
			local targetPlayer, targetPlayerName = exports.rl_global:findPlayerByPartialNick(thePlayer, targetPlayer)
			if targetPlayer then
				if getElementData(targetPlayer, "logged") then
					local charID = getElementData(targetPlayer, "dbid")
					if isPlayerVIP(charID) then
						local success = removeVIP(charID)
						if success then
							outputChatBox("[!]#FFFFFF " .. targetPlayerName .. " isimli oyuncunun VIP üyeliğini aldınız.", thePlayer, 0, 255, 0, true)
							outputChatBox("[!]#FFFFFF " .. exports.rl_global:getPlayerFullAdminTitle(thePlayer) .. " isimli yetkili VIP üyeliğinizi aldı.", thePlayer, 255, 0, 0, true)
							exports.rl_logs:addLog("vip", exports.rl_global:getPlayerFullAdminTitle(thePlayer) .. " isimli yetkili " .. targetPlayerName .. " isimli oyuncunun VIP üyeliğini aldı.")
						end
					else
						outputChatBox("[!]#FFFFFF Bu oyuncunun VIP üyeliği yok.", thePlayer, 255, 0, 0, true)
						playSoundFrontEnd(thePlayer, 4)
					end
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
addCommandHandler("vipal", vipAl, false, false)

function vipDagit(thePlayer, commandName, rank, days)
    if exports.rl_integration:isPlayerDeveloper(thePlayer) then
        if rank and days and tonumber(rank) and tonumber(days) then
            rank = math.floor(tonumber(rank))
            days = math.floor(tonumber(days))
            if rank >= 1 and rank <= 4 then
                if days >= 1 then
                    for _, player in ipairs(getElementsByType("player")) do
                        if getElementData(player, "logged") then
                            local playerVIP = getElementData(player, "vip") or 0
                            local charID = getElementData(player, "dbid")
                            if isPlayerVIP(charID) then
                                local addDay = ((math.floor(days / 2)) == 0) and 1 or math.floor(days / 2)
                                addVIP(player, rank, addDay)
                                exports.rl_infobox:addBox(player, "success", "Reval Roleplay tarafından VIP [" .. playerVIP .. "] sürenize " .. addDay .. " gün daha ilave olundu.")
                            else
                                removeVIP(charID)
                                addVIP(player, rank, days)
                                exports.rl_infobox:addBox(player, "success", "Reval Roleplay tarafından " .. days .. " günlük VIP [" .. rank .. "] kazandınız.")
                            end
                        end
                    end
                    exports.rl_logs:addLog("vip", exports.rl_global:getPlayerFullAdminTitle(thePlayer) .. " isimli yetkili " .. days .. " günlük VIP [" .. rank .. "] dağıtdı.")
                else
                    outputChatBox("[!]#FFFFFF Geçerli bir gün girin.", thePlayer, 255, 0, 0, true)
                    playSoundFrontEnd(thePlayer, 4)
                end
            else
                outputChatBox("[!]#FFFFFF Bu numarada VIP yok.", thePlayer, 255, 0, 0, true)
                playSoundFrontEnd(thePlayer, 4)
            end
        else
            outputChatBox("KULLANIM: /" .. commandName .. " [1-4] [Gün]", thePlayer, 255, 194, 14)
        end
    else
        outputChatBox("[!]#FFFFFF Yeterli yetkiniz yok.", thePlayer, 255, 0, 0, true)
        playSoundFrontEnd(thePlayer, 4)
    end
end
addCommandHandler("vipdagit", vipDagit, false, false)

function vipSure(thePlayer, commandName, targetPlayer)
	if targetPlayer then
		local targetPlayer, targetPlayerName = exports.rl_global:findPlayerByPartialNick(thePlayer, targetPlayer)
		if targetPlayer then
			local id = getElementData(targetPlayer, "dbid")
			
			if exports.rl_integration:isPlayerTrialAdmin(thePlayer) then
				if vips[id] then
					local vipType = vips[id].type
					local remaining = vips[id].endTick
					local remainingInfo = exports.rl_datetime:secondsToTimeDesc(remaining / 1000)
		
					return outputChatBox("[!]#FFFFFF " .. targetPlayerName .. " isimli oyuncunun kalan VIP [" .. vipType .. "] süresi: " .. remainingInfo, thePlayer, 0, 0, 255, true)
				end
				
				outputChatBox("[!]#FFFFFF " .. targetPlayerName .. " isimli oyuncunun VIP üyeliği yok.", thePlayer, 255, 0, 0, true)
				playSoundFrontEnd(thePlayer, 4)
				return
			else
				outputChatBox("[!]#FFFFFF Yeterli yetkiniz yok.", thePlayer, 255, 0, 0, true)
				playSoundFrontEnd(thePlayer, 4)
			end
		end
	end

	local charID = getElementData(thePlayer, "dbid")
	if not charID then return false end

	if vips[charID] then
		local vipType = vips[charID].type
		local remaining = vips[charID].endTick
		local remainingInfo = exports.rl_datetime:secondsToTimeDesc(remaining / 1000)

		outputChatBox("[!]#FFFFFF Kalan VIP [" .. vipType .. "] süreniz: " .. remainingInfo, thePlayer, 0, 0, 255, true)
	else
		outputChatBox("[!]#FFFFFF VIP üyeliğiniz yok.", thePlayer, 255, 0, 0, true)
		playSoundFrontEnd(thePlayer, 4)
	end
end
addCommandHandler("vipsure", vipSure, false, false)