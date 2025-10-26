local reports = {}

function sortReports()
    local sortedReports = {}
    local lastSlot = 0
    
    for id, report in pairs(reports) do
        if report then
            lastSlot = lastSlot + 1
            table.insert(sortedReports, {id = id, report = report})
        end
    end
    
    table.sort(sortedReports, function(a, b)
        return a.id < b.id
    end)
    
    for i, item in ipairs(sortedReports) do
        if item.id ~= i then
            reports[i] = item.report
            reports[item.id] = nil
            
            if item.report.player then
				triggerClientEvent(item.report.player, "reports.show.ui", item.report.player, i)
                outputChatBox("[!]#FFFFFF Rapor ID'niz değişti: [" .. item.id .. "] -> [" .. i .. "]", item.report.player, 0, 0, 255, true)
            end
            
            if item.report.admin then
                outputChatBox("[!]#FFFFFF Yönetmekte olduğunuz raporun ID'si değişti: [" .. item.id .. "] -> [" .. i .. "]", item.report.admin, 0, 0, 255, true)
            end
			
            item.id = i
        end
    end
end

function acceptReport(thePlayer, commandName, reportID)
	if exports.rl_integration:isPlayerTrialAdmin(thePlayer) then
		if reportID and tonumber(reportID) then
			reportID = tonumber(reportID)
			local report = reports[reportID]
			if report then
				if not report.admin then
					if report.player ~= thePlayer then
						report.admin = thePlayer
						outputChatBox("[!]#FFFFFF [" .. reportID .. "] ID'li rapor kabul edildi.", thePlayer, 0, 255, 0, true)
						outputChatBox("[!]#FFFFFF " .. exports.rl_global:getPlayerFullAdminTitle(thePlayer) .. " isimli yetkili raporunuzu kabul etti.", report.player, 0, 255, 0, true)
						triggerClientEvent(report.player, "playNudgeSound", report.player)
						exports.rl_global:sendMessageToAdmins("[#" .. reportID .. "] " .. exports.rl_global:getPlayerFullAdminTitle(thePlayer) .. " isimli yetkili " .. getPlayerName(report.player):gsub("_", " ") .. " isimli oyuncunun raporunu kabul etti.", false, 70, 200, 30)
					else
						outputChatBox("[!]#FFFFFF Kendi raporunuzu kabul edemezsiniz.", thePlayer, 255, 0, 0, true)
						playSoundFrontEnd(thePlayer, 4)
					end
				else
					outputChatBox("[!]#FFFFFF Bu rapor " .. exports.rl_global:getPlayerFullAdminTitle(report.admin) .. " isimli yetkili tarafından yönetiliyor.", thePlayer, 255, 0, 0, true)
					playSoundFrontEnd(thePlayer, 4)
				end
			else
				outputChatBox("[!]#FFFFFF Geçersiz rapor ID.", thePlayer, 255, 0, 0, true)
				playSoundFrontEnd(thePlayer, 4)
			end
		else
			outputChatBox("KULLANIM: /" .. commandName .. " [Rapor ID]", thePlayer, 255, 194, 14)
		end
	else
		outputChatBox("[!]#FFFFFF Yeterli yetkiniz yok.", thePlayer, 255, 0, 0, true)
		playSoundFrontEnd(thePlayer, 4)
	end
end
addCommandHandler("acceptreport", acceptReport, false, false)
addCommandHandler("ar", acceptReport, false, false)

function dropReport(thePlayer, commandName, reportID)
	if exports.rl_integration:isPlayerTrialAdmin(thePlayer) then
		if reportID and tonumber(reportID) then
			reportID = tonumber(reportID)
			local report = reports[reportID]
			if report then
				if report.admin == thePlayer then
					report.admin = nil
					outputChatBox("[!]#FFFFFF [" .. reportID .. "] ID'li rapor bırakıldı.", thePlayer, 0, 255, 0, true)
					outputChatBox("[!]#FFFFFF " .. exports.rl_global:getPlayerFullAdminTitle(thePlayer) .. " isimli yetkili raporunuzu bıraktı.", report.player, 0, 0, 255, true)
					exports.rl_global:sendMessageToAdmins("[#" .. reportID .. "] " .. exports.rl_global:getPlayerFullAdminTitle(thePlayer) .. " isimli yetkili " .. getPlayerName(report.player):gsub("_", " ") .. " isimli oyuncunun raporunu bıraktı.", false, 70, 200, 30)
				else
					outputChatBox("[!]#FFFFFF Bu rapor " .. exports.rl_global:getPlayerFullAdminTitle(report.admin) .. " isimli yetkili tarafından yönetiliyor.", thePlayer, 255, 0, 0, true)
					playSoundFrontEnd(thePlayer, 4)
				end
			else
				outputChatBox("[!]#FFFFFF Geçersiz rapor ID.", thePlayer, 255, 0, 0, true)
				playSoundFrontEnd(thePlayer, 4)
			end
		else
			outputChatBox("KULLANIM: /" .. commandName .. " [Rapor ID]", thePlayer, 255, 194, 14)
		end
	else
		outputChatBox("[!]#FFFFFF Yeterli yetkiniz yok.", thePlayer, 255, 0, 0, true)
		playSoundFrontEnd(thePlayer, 4)
	end
end
addCommandHandler("dropreport", dropReport, false, false)
addCommandHandler("dr", dropReport, false, false)

function falseReport(thePlayer, commandName, reportID)
	if exports.rl_integration:isPlayerTrialAdmin(thePlayer) then
		if reportID and tonumber(reportID) then
			reportID = tonumber(reportID)
			local report = reports[reportID]
			if report then
				reports[reportID] = nil
				sortReports()
				triggerClientEvent(report.player, "reports.hide.ui", report.player)
				triggerClientEvent(report.player, "reports.block", report.player)
				outputChatBox("[!]#FFFFFF [" .. reportID .. "] ID'li rapor yalanlandı.", thePlayer, 0, 255, 0, true)
				outputChatBox("[!]#FFFFFF " .. exports.rl_global:getPlayerFullAdminTitle(thePlayer) .. " isimli yetkili raporunuzu yalanladı.", report.player, 255, 0, 0, true)
				exports.rl_global:sendMessageToAdmins("[#" .. reportID .. "] " .. exports.rl_global:getPlayerFullAdminTitle(thePlayer) .. " isimli yetkili " .. getPlayerName(report.player):gsub("_", " ") .. " isimli oyuncunun raporunu yalanladı.", false, 70, 200, 30)
			else
				outputChatBox("[!]#FFFFFF Geçersiz rapor ID.", thePlayer, 255, 0, 0, true)
				playSoundFrontEnd(thePlayer, 4)
			end
		else
			outputChatBox("KULLANIM: /" .. commandName .. " [Rapor ID]", thePlayer, 255, 194, 14)
		end
	else
		outputChatBox("[!]#FFFFFF Yeterli yetkiniz yok.", thePlayer, 255, 0, 0, true)
		playSoundFrontEnd(thePlayer, 4)
	end
end
addCommandHandler("falsereport", falseReport, false, false)
addCommandHandler("fr", falseReport, false, false)

function closeReport(thePlayer, commandName, reportID)
	if exports.rl_integration:isPlayerTrialAdmin(thePlayer) then
		if reportID and tonumber(reportID) then
			reportID = tonumber(reportID)
			local report = reports[reportID]
			if report then
				if report.admin == thePlayer then
					reports[reportID] = nil
					sortReports()
					triggerClientEvent(report.player, "reports.hide.ui", report.player)
					
					local adminReports = getElementData(thePlayer, "admin_reports") or 0
					setElementData(thePlayer, "admin_reports", adminReports + 1)
					dbExec(exports.rl_mysql:getConnection(), "UPDATE accounts SET admin_reports = ? WHERE id = ?", getElementData(thePlayer, "admin_reports"), getElementData(thePlayer, "account_id"))
					checkAndAwardPrize(thePlayer)
					
					outputChatBox("[!]#FFFFFF [" .. reportID .. "] ID'li rapor kapatıldı.", thePlayer, 0, 255, 0, true)
					outputChatBox("[!]#FFFFFF " .. exports.rl_global:getPlayerFullAdminTitle(thePlayer) .. " isimli yetkili raporunuzu kapattı.", report.player, 0, 0, 255, true)
					exports.rl_global:sendMessageToAdmins("[#" .. reportID .. "] " .. exports.rl_global:getPlayerFullAdminTitle(thePlayer) .. " isimli yetkili " .. getPlayerName(report.player):gsub("_", " ") .. " isimli oyuncunun raporunu kapattı.", false, 70, 200, 30)
				else
					outputChatBox("[!]#FFFFFF Bu rapor " .. exports.rl_global:getPlayerFullAdminTitle(report.admin) .. " isimli yetkili tarafından yönetiliyor.", thePlayer, 255, 0, 0, true)
					playSoundFrontEnd(thePlayer, 4)
				end
			else
				outputChatBox("[!]#FFFFFF Geçersiz rapor ID.", thePlayer, 255, 0, 0, true)
				playSoundFrontEnd(thePlayer, 4)
			end
		else
			local closedReports = 0
			for id, report in pairs(reports) do
				if report.admin == thePlayer then
					reports[id] = nil
					sortReports()
					triggerClientEvent(report.player, "reports.hide.ui", report.player)
					outputChatBox("[!]#FFFFFF [" .. id .. "] ID'li rapor kapatıldı.", thePlayer, 0, 255, 0, true)
					outputChatBox("[!]#FFFFFF " .. exports.rl_global:getPlayerFullAdminTitle(thePlayer) .. " isimli yetkili raporunuzu kapattı.", report.player, 0, 0, 255, true)
					exports.rl_global:sendMessageToAdmins("[#" .. id .. "] " .. exports.rl_global:getPlayerFullAdminTitle(thePlayer) .. " isimli yetkili " .. getPlayerName(report.player):gsub("_", " ") .. " isimli oyuncunun raporunu kapattı.", false, 70, 200, 30)
					closedReports = closedReports + 1
				end
			end
			
			if closedReports <= 0 then
				outputChatBox("[!]#FFFFFF Kapatılacak raporunuz yok.", thePlayer, 255, 0, 0, true)
				playSoundFrontEnd(thePlayer, 4)
			else
				local adminReports = getElementData(thePlayer, "admin_reports") or 0
				setElementData(thePlayer, "admin_reports", adminReports + closedReports)
				dbExec(exports.rl_mysql:getConnection(), "UPDATE accounts SET admin_reports = ? WHERE id = ?", getElementData(thePlayer, "admin_reports"), getElementData(thePlayer, "account_id"))
				checkAndAwardPrize(thePlayer)
			end
		end
	else
		outputChatBox("[!]#FFFFFF Yeterli yetkiniz yok.", thePlayer, 255, 0, 0, true)
		playSoundFrontEnd(thePlayer, 4)
	end
end
addCommandHandler("closereport", closeReport, false, false)
addCommandHandler("cr", closeReport, false, false)

function endReport(thePlayer, commandName)
	local reportID = nil
	for id, report in pairs(reports) do
		if report.player == thePlayer then
			reportID = id
			break
		end
	end
	
	if reportID then
		local report = reports[reportID]
		if report then
			if not report.admin then
				outputChatBox("[!]#FFFFFF Raporunuzu kapatdınız.", thePlayer, 0, 255, 0, true)
				exports.rl_global:sendMessageToAdmins("[#" .. reportID .. "] " .. getPlayerName(thePlayer):gsub("_", " ") .. " isimli oyuncu raporu kapattı.", false, 70, 200, 30)
				if report.admin then
					outputChatBox("[!]#FFFFFF " .. getPlayerName(thePlayer):gsub("_", " ") .. " isimli oyuncu raporu kapattı.", report.admin, 0, 255, 0, true)
				end
				
				reports[reportID] = nil
				sortReports()
				triggerClientEvent(thePlayer, "reports.hide.ui", thePlayer)
			else
				outputChatBox("[!]#FFFFFF Raporunuzu birisi yönetirken kapatamazsınız.", thePlayer, 255, 0, 0, true)
				playSoundFrontEnd(thePlayer, 4)
			end
		else
			outputChatBox("[!]#FFFFFF Bir sorun oluştu.", thePlayer, 255, 0, 0, true)
			playSoundFrontEnd(thePlayer, 4)
		end
	else
		outputChatBox("[!]#FFFFFF Açık bir raporunuz yok.", thePlayer, 255, 0, 0, true)
		playSoundFrontEnd(thePlayer, 4)
	end
end
addCommandHandler("endreport", endReport, false, false)
addCommandHandler("er", endReport, false, false)

function transferReport(thePlayer, commandName, reportID, targetPlayer)
    if exports.rl_integration:isPlayerTrialAdmin(thePlayer) then
        if reportID and tonumber(reportID) and targetPlayer then
            reportID = tonumber(reportID)
            local targetPlayer, targetPlayerName = exports.rl_global:findPlayerByPartialNick(thePlayer, targetPlayer)
            if targetPlayer then
				local report = reports[reportID]
				if report then
					if report.admin == thePlayer then
						if exports.rl_integration:isPlayerTrialAdmin(targetPlayer) then
							report.admin = targetPlayer
							outputChatBox("[!]#FFFFFF [" .. reportID .. "] ID'li rapor " .. exports.rl_global:getPlayerFullAdminTitle(targetPlayer) .. " isimli yetkiliye transfer edildi.", thePlayer, 0, 255, 0, true)
							outputChatBox("[!]#FFFFFF " .. exports.rl_global:getPlayerFullAdminTitle(thePlayer) .. " isimli yetkili [" .. reportID .. "] ID'li raporu size transfer etti.", targetPlayer, 0, 255, 0, true)
							outputChatBox("[!]#FFFFFF " .. exports.rl_global:getPlayerFullAdminTitle(thePlayer) .. " isimli yetkili raporunuzu " .. exports.rl_global:getPlayerFullAdminTitle(targetPlayer) .. " isimli yetkiliye transfer etti.", report.player, 0, 0, 255, true)
							exports.rl_global:sendMessageToAdmins("[#" .. reportID .. "] " .. exports.rl_global:getPlayerFullAdminTitle(thePlayer) .. " isimli yetkili raporunuzu " .. exports.rl_global:getPlayerFullAdminTitle(targetPlayer) .. " isimli yetkiliye transfer etti.", false, 70, 200, 30)
						else
							outputChatBox("[!]#FFFFFF Bu oyuncu yetkili deyil.", thePlayer, 255, 0, 0, true)
							playSoundFrontEnd(thePlayer, 4)
						end
					else
						outputChatBox("[!]#FFFFFF Bu rapor " .. exports.rl_global:getPlayerFullAdminTitle(report.admin) .. " isimli yetkili tarafından yönetiliyor.", thePlayer, 255, 0, 0, true)
						playSoundFrontEnd(thePlayer, 4)
					end
				else
					outputChatBox("[!]#FFFFFF Geçersiz rapor ID.", thePlayer, 255, 0, 0, true)
					playSoundFrontEnd(thePlayer, 4)
				end
			end
        else
            outputChatBox("KULLANIM: /" .. commandName .. " [Rapor ID] [Karakter Adı / ID]", thePlayer, 255, 194, 14)
        end
    else
        outputChatBox("[!]#FFFFFF Yeterli yetkiniz yok.", thePlayer, 255, 0, 0, true)
        playSoundFrontEnd(thePlayer, 4)
    end
end
addCommandHandler("transferreport", transferReport, false, false)
addCommandHandler("tr", transferReport, false, false)

function reportInfo(thePlayer, commandName, reportID)
    if exports.rl_integration:isPlayerTrialAdmin(thePlayer) then
        if reportID and tonumber(reportID) then
            reportID = tonumber(reportID)
            local report = reports[reportID]
            if report then
                local adminName = report.admin and exports.rl_global:getPlayerFullAdminTitle(report.admin) or "Hiç kimse"
                outputChatBox("[!]#FFFFFF Rapor ID: " .. reportID .. " | Oyuncu: " .. getPlayerName(report.player):gsub("_", " ") .. " | Sebep: " .. report.reason .. " | Zaman: " .. report.time .. " | Yetkili: " .. adminName, thePlayer, 0, 0, 255, true)
            else
                outputChatBox("[!]#FFFFFF Geçersiz rapor ID.", thePlayer, 255, 0, 0, true)
                playSoundFrontEnd(thePlayer, 4)
            end
        else
            outputChatBox("KULLANIM: /" .. commandName .. " [Rapor ID]", thePlayer, 255, 194, 14)
        end
    else
        outputChatBox("[!]#FFFFFF Yeterli yetkiniz yok.", thePlayer, 255, 0, 0, true)
        playSoundFrontEnd(thePlayer, 4)
    end
end
addCommandHandler("reportinfo", reportInfo, false, false)
addCommandHandler("ri", reportInfo, false, false)

function reportsInfo(thePlayer)
    if exports.rl_integration:isPlayerTrialAdmin(thePlayer) then
        local hasReports = false
        for id, report in pairs(reports) do
            local adminName = report.admin and exports.rl_global:getPlayerFullAdminTitle(report.admin) or "Hiç kimse"
            outputChatBox("[!]#FFFFFF Rapor ID: " .. id .. " | Oyuncu: " .. getPlayerName(report.player):gsub("_", " ") .. " | Sebep: " .. report.reason .. " | Zaman: " .. report.time .. " | Yetkili: " .. adminName, thePlayer, 0, 0, 255, true)
            hasReports = true
        end
        
        if not hasReports then
            outputChatBox("[!]#FFFFFF Şu anda hiç rapor yok.", thePlayer, 255, 0, 0, true)
            playSoundFrontEnd(thePlayer, 4)
        end
    else
        outputChatBox("[!]#FFFFFF Yeterli yetkiniz yok.", thePlayer, 255, 0, 0, true)
        playSoundFrontEnd(thePlayer, 4)
    end
end
addCommandHandler("reports", reportsInfo, false, false)

function checkAndAwardPrize(thePlayer)
	if thePlayer and isElement(thePlayer) then
		if (getElementData(thePlayer, "admin_reports") % 50) == 0 then
			exports.rl_items:giveItem(thePlayer, 353, 1)
			outputChatBox("[!]#FFFFFF Tebrikler, 50 rapor topladınız ve Altın Şans Kutusu kazandınız!", thePlayer, 0, 255, 0, true)
			triggerClientEvent(thePlayer, "playSuccessfulSound", thePlayer)
			exports.rl_logs:addLog("rapor", exports.rl_global:getPlayerFullAdminTitle(thePlayer) .. " isimli yetkili 50 rapor topladı ve Altın Şans Kutusu kazandı.")
		end
	end
end

addEvent("reports.send", true)
addEventHandler("reports.send", root, function(...)
	if client ~= source then
		exports.rl_ac:banForEventAbuse(client, eventName)
		return
	end
	
	for id, report in pairs(reports) do
		if report.player == client then
			outputChatBox("[!]#FFFFFF Zaten bir rapor açtınız.", client, 255, 0, 0, true)
			playSoundFrontEnd(client, 4)
			return
		end
	end
	
	local slot = nil
	for i = 1, getMaxPlayers() do
		if not reports[i] then
			slot = i
			break
		end
	end
	
	if not slot then
		outputChatBox("[!]#FFFFFF Tüm rapor yuvaları dolu. Lütfen daha sonra tekrar deneyiniz.", client, 255, 0, 0, true)
		playSoundFrontEnd(client, 4)
		return
	end
	
	local reason = table.concat({...}, " ")
	if reason == "" then
		reason = "Bilinmiyor"
	end

	local playerId = getElementData(client, "id") or "-"

	reports[slot] = {
		player = client,
		admin = nil,
		reason = reason,
		time = os.date("%H:%M:%S"),
		playerId = playerId, -- oyuncunun id datası
	}

	sortReports()
	triggerClientEvent(client, "reports.show.ui", client, slot)
	
	exports.rl_infobox:addBox(client, "success", "Raporunuz gönderildi ve ID'si [" .. slot .. "] olarak seçildi.")
	exports.rl_global:sendMessageToAdmins("[#" .. slot .. "] " .. getPlayerName(client):gsub("_", " ") .. " isimli oyuncu rapor gönderdi.", false, 70, 200, 30)
	exports.rl_global:sendMessageToAdmins("[#" .. slot .. "] Sebep: " .. reason, false, 70, 200, 30)
end)

addEvent("reports.close", true)
addEventHandler("reports.close", root, function(reportID)
    if client ~= source then
		exports.rl_ac:banForEventAbuse(client, eventName)
        return
    end

    if reportID and tonumber(reportID) then
        reportID = tonumber(reportID)
        local report = reports[reportID]
        if report then
            if not report.admin then
				if report.player == client then
					exports.rl_infobox:addBox(client, "success", "Raporunuzu kapatdınız.")
					exports.rl_global:sendMessageToAdmins("[#" .. reportID .. "] " .. getPlayerName(client):gsub("_", " ") .. " isimli oyuncu raporu kapattı.", false, 70, 200, 30)
					if report.admin then
						outputChatBox("[!]#FFFFFF " .. getPlayerName(client):gsub("_", " ") .. " isimli oyuncu raporu kapattı.", report.admin, 0, 255, 0, true)
					end
					
					reports[reportID] = nil
					sortReports()
					triggerClientEvent(client, "reports.hide.ui", client)
				else
					exports.rl_infobox:addBox(client, "error", "Bu rapor sizin değil.")
				end
			else
				exports.rl_infobox:addBox(client, "error", "Raporunuzu birisi yönetirken kapatamazsınız.")
			end
        else
            exports.rl_infobox:addBox(client, "error", "Bir sorun oluştu.")
        end
    else
        exports.rl_infobox:addBox(client, "error", "Bir sorun oluştu.")
    end
end)

addEventHandler("onPlayerQuit", root, function()
	for id, report in pairs(reports) do
		if report.player == source then
			if report.admin then
				outputChatBox("[!]#FFFFFF [" .. id .. "] ID'li raporun yaratıcısı " .. getPlayerName(source):gsub("_", " ") .. " oyundan ayrıldığı için rapor kapandı.", report.admin, 255, 0, 0, true)
				playSoundFrontEnd(report.admin, 4)
				exports.rl_global:sendMessageToAdmins("[#" .. id .. "] " .. getPlayerName(source):gsub("_", " ") .. " isimli oyuncu oyundan ayrıldığı için rapor kapandı.", false, 70, 200, 30)
			end
			reports[id] = nil
		elseif report.admin == source then
			outputChatBox("[!]#FFFFFF [" .. id .. "] ID'li raporu kabul eden yetkili " .. exports.rl_global:getPlayerFullAdminTitle(source) .. " oyundan ayrıldığı için rapor bırakıldı.", report.player, 255, 0, 0, true)
			playSoundFrontEnd(report.player, 4)
			exports.rl_global:sendMessageToAdmins("[#" .. id .. "] " .. exports.rl_global:getPlayerFullAdminTitle(source) .. " isimli yetkili oyundan ayrıldığı için rapor bırakıldı.", false, 70, 200, 30)
			report.admin = nil
		end
	end
	sortReports()
end)

-- /rapor komutu ile rapor gönderebilme
addCommandHandler("rapor", function(thePlayer, cmd, ...)
    if not ... or tostring(...) == "" then
        outputChatBox("KULLANIM: /rapor [Sebep]", thePlayer, 255, 194, 14)
        return
    end

    -- Zaten açık raporu var mı kontrolü
    for id, report in pairs(reports) do
        if report.player == thePlayer then
            outputChatBox("[!]#FFFFFF Zaten bir rapor açtınız.", thePlayer, 255, 0, 0, true)
            playSoundFrontEnd(thePlayer, 4)
            return
        end
    end

    local slot = nil
    for i = 1, getMaxPlayers() do
        if not reports[i] then
            slot = i
            break
        end
    end

    if not slot then
        outputChatBox("[!]#FFFFFF Lütfen daha sonra tekrar deneyiniz.", thePlayer, 255, 0, 0, true)
        playSoundFrontEnd(thePlayer, 4)
        return
    end

    local reason = table.concat({...}, " ")
    if reason == "" then
        reason = "Bilinmiyor"
    end

    reports[slot] = {
        player = thePlayer,
        admin = nil,
        reason = reason,
        time = os.date("%H:%M:%S"),
    }

    sortReports()
    triggerClientEvent(thePlayer, "reports.show.ui", thePlayer, slot)

    exports.rl_infobox:addBox(thePlayer, "success", "Raporunuz gönderildi ve ID'si [" .. slot .. "] olarak seçildi.")
    exports.rl_global:sendMessageToAdmins("[#" .. slot .. "] " .. getPlayerName(thePlayer):gsub("_", " ") .. " isimli oyuncu rapor gönderdi.", false, 70, 200, 30)
    exports.rl_global:sendMessageToAdmins("[#" .. slot .. "] Sebep: " .. reason, false, 70, 200, 30)
end)

-- Admin rapor listesi isteği
addEvent("admin.reports.request", true)
addEventHandler("admin.reports.request", root, function()
    if not exports.rl_integration:isPlayerTrialAdmin(client) then return end
    local list = {}
    for id, report in pairs(reports) do
        table.insert(list, {
            id = id,
            playerName = getPlayerName(report.player):gsub("_", " "),
            reason = report.reason or "-",
            playerId = report.playerId or getElementData(report.player, "id") or "-", -- oyuncunun "id" datası
        })
    end
    triggerClientEvent(client, "admin.reports.list", client, list)
end)

-- Admin rapor paneli açma komutu ve toggle eventini kaldırıyoruz