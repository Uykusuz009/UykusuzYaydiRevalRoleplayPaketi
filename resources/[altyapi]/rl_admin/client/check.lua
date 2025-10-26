function enterCommand(commandName, ...)
	triggerServerEvent("checkCommandEntered", localPlayer, localPlayer, commandName, ...)
end
addCommandHandler("check", enterCommand, false, false)

function createCheckWindow()
	local width, height = guiGetScreenSize()	
	Button = {}
	Window = guiCreateWindow(width-400, height/4, 400, 385, "Oyuncu Bilgileri", false)
	guiWindowSetSizable(Window, false)
	Button[3] = guiCreateButton(0.85, 0.86, 0.12, 0.125, "Kapat", true, Window)
	addEventHandler("onClientGUIClick", Button[3], closeCheck)
	Label = {
		guiCreateLabel(0.03, 0.06, 0.95, 0.0887, "Ad: N/A", true, Window), 
		guiCreateLabel(0.03, 0.10, 0.66, 0.0887, "IP: N/A", true, Window), 
		guiCreateLabel(0.03, 0.26, 0.66, 0.0887, "Cüzdan: N/A", true, Window), 
		guiCreateLabel(0.03, 0.30, 0.17, 0.0806, "HP: N/A", true, Window), 
		guiCreateLabel(0.27, 0.34, 0.30, 0.0806, "Zırh: N/A", true, Window), 
		guiCreateLabel(0.03, 0.34, 0.17, 0.0806, "Skin: N/A", true, Window), 
		guiCreateLabel(0.27, 0.30, 0.30, 0.0806, "Silah: N/A", true, Window), 
		guiCreateLabel(0.03, 0.38, 0.66, 0.0806, "Birlik: N/A", true, Window), 
		guiCreateLabel(0.03, 0.18, 0.66, 0.0806, "Ping: N/A", true, Window), 
		guiCreateLabel(0.03, 0.42, 0.66, 0.0806, "Araç: N/A", true, Window), 
		guiCreateLabel(0.03, 0.46, 0.66, 0.0806, "Uyarı: N/A", true, Window), 
		guiCreateLabel(0.03, 0.50, 0.97, 0.0766, "Bölge: N/A", true, Window), 
		guiCreateLabel(0.7, 0.06, 0.4031, 0.0766, "X:", true, Window), 
		guiCreateLabel(0.7, 0.10, 0.4031, 0.0766, "Y: N/A", true, Window), 
		guiCreateLabel(0.7, 0.14, 0.4031, 0.0766, "Z: N/A", true, Window), 
		guiCreateLabel(0.7, 0.18, 0.2907, 0.0806, "Interior: N/A", true, Window), 
		guiCreateLabel(0.7, 0.22, 0.2907, 0.0806, "Dimension: N/A", true, Window), 
		guiCreateLabel(0.03, 0.14, 0.66, 0.0887, "Yetki: N/A", true, Window),
		guiCreateLabel(0.7, 0.26, 0.4093, 0.0806, "Saat: N/A\n~ Toplam: N/A", true, Window), 
		guiCreateLabel(0.03, 0.22, 0.66, 0.0887, "Bakiye: N/A", true, Window), 
		guiCreateLabel(0.03, 0.50, 0.66, 0.0806, "", true, Window), 
	}
	
	memo = guiCreateMemo(0.03, 0.55, 0.8, 0.42, "", true, Window)
	addEventHandler("onClientGUIClick", Window, function(button, state)
		if button == "left" and state == "up" then
			if source == memo then
				guiSetInputEnabled(true)
			else
				guiSetInputEnabled(false)
			end
		end
	end)
	
	Button[4] = guiCreateButton(0.85, 0.55, 0.12, 0.175, "Notu\nKaydet", true, Window)
	
	addEventHandler("onClientGUIClick", Button[4], saveNote, false)
	
	Button[5] = guiCreateButton(0.7, 0.375, 0.4093, 0.15, "Tarihçe", true, Window)
	addEventHandler("onClientGUIClick", Button[5], showHistory, false)
	
	Button[6] = guiCreateButton(0.85, 0.73, 0.12, 0.125, "Envanter", true, Window)
	addEventHandler("onClientGUIClick", Button[6], showInventory, false)

	guiSetVisible(Window, false)
end

addEventHandler("onClientResourceStart", resourceRoot, function()
	createCheckWindow()
end)

function openCheck(ip, adminReports, balance, note, history, bankMoney, money, adminLevel, hoursPlayed, accountName, hoursAcc)
	player = source

	guiSetText(Label[1], "Ad: " .. getPlayerName(player):gsub("_", " ") .. " (" .. accountName .. ")")
	if adminReports == nil then
		adminReports = "-1"
	end
	
	if balance == nil then
		balance = "0"
	end
	
	if history == nil then
		history = "N/A"
	else
		local total = 0
		local str = {}
		for key, value in ipairs(history) do
			total = total + value[2]
			table.insert(str, value[2] .. " " .. getHistoryAction(value[1]))
			if key % 2 == 0 and key < #history then
				table.insert(str, "\n")
			end
		end
		history = table.concat(str, " ")
	end
	
	if bankMoney == nil then
		bankMoney = "-1"
	end
	
	guiSetText(Label[2], "IP: " .. ip)
	guiSetText(Label[18], "Yetki: " .. adminLevel .. " (" .. adminReports .. " Rapor)")
	if not exports.rl_integration:isPlayerTrialAdmin(localPlayer) then
		guiSetText(Label[3], "Cüzdan: N/A (Bankda Para: N/A)")
	else	
		guiSetText(Label[3], "Cüzdan: $" .. exports.rl_global:formatMoney(money) .. " (Bankda Para: $" .. exports.rl_global:formatMoney(bankMoney) .. ")")
	end
	guiSetText(Button[5], history)
	guiSetText(Label[20], "Bakiye: " .. exports.rl_global:formatMoney(balance) .. " TL")
	guiSetText(Label[19], "Saat: " .. (hoursPlayed or "N/A") .. "\n~ Toplam: " .. (hoursAcc or "N/A"))
	
	if (player == localPlayer) and not exports.rl_integration:isPlayerAdmin1(localPlayer) then
		guiSetText(memo, "- Yönetici hesabına erişiminiz yok -")
		guiMemoSetReadOnly(memo, true)
		guiSetEnabled(Button[4], false)
	elseif not exports.rl_integration:isPlayerTrialAdmin(localPlayer) then
		guiSetText(memo, "- Yönetici hesabına erişiminiz yok -")
		guiMemoSetReadOnly(memo, true)
		guiSetEnabled(Button[4], false)
	else
		guiSetText(memo, note or "HATA: KAYIT BAŞARISIZ OLDU")
		guiSetEnabled(Button[4], true)
		guiMemoSetReadOnly(memo, false)
	end

	if not guiGetVisible(Window) then
		guiSetVisible(Window, true)
	end
end
addEvent("onCheck", true)
addEventHandler("onCheck", root, openCheck)

addEventHandler("onClientRender", root, function()
	if guiGetVisible(Window) and isElement(player) then
		local x, y, z = 0, 0, 0
		if getElementAlpha(player) ~= 0 or exports.rl_integration:isPlayerHeadAdmin(localPlayer) then 
			x, y, z = getElementPosition(player)
			guiSetText(Label[13], "X: " .. string.format("%.5f", x))
			guiSetText(Label[14], "Y: " .. string.format("%.5f", y))
			guiSetText(Label[15], "Z: " .. string.format("%.5f", z))
		
		else
			guiSetText(Label[13], "X: N/A")
			guiSetText(Label[14], "Y: N/A")
			guiSetText(Label[15], "Z: N/A")
		end
		
		guiSetText(Label[4], "HP: " .. math.floor(getElementHealth(player)))
		guiSetText(Label[5], "Zırh: " .. math.floor(getPedArmor(player)))
		guiSetText(Label[6], "Skin: " .. getElementModel(player))
		
		local weapon = getPedWeapon(player)
		if weapon then
			weapon = getWeaponNameFromID(weapon)
		else
			weapon = "N/A"
		end
		guiSetText(Label[7], "Silah: " .. weapon)
		
        local faction =  "Birlik: Bilinmiyor"
		guiSetText(Label[8], faction)
		
		guiSetText(Label[9], "Ping: " .. getPlayerPing(player))
		
		local vehicle = getPedOccupiedVehicle(player)
		if vehicle and not exports.rl_integration:isPlayerTrialAdmin(localPlayer) then
			guiSetText(Label[10], "Araç: " .. exports.rl_global:getVehicleName(vehicle) .. " (" .. getVehicleName(vehicle) .. " - " .. getElementData(vehicle, "dbid") .. ")")
		else
			guiSetText(Label[10], "Araç: N/A")
		end
		
		if exports.rl_integration:isPlayerTrialAdmin(localPlayer) then
			guiSetText(Label[12], "Bölge: " .. getZoneName(x, y, z))
			guiSetText(Label[16], "Interior: " .. getElementInterior(player))
			guiSetText(Label[17], "Dimension: " .. getElementDimension(player))
		else
			guiSetText(Label[12], "Bölge: N/A")
			guiSetText(Label[16], "Interior: N/A")
			guiSetText(Label[17], "Dimension: N/A")
		end
	end
end)

function closeCheck(button, state)
	if source == Button[3] and button == "left" and state == "up" then
		triggerEvent("cursorHide", localPlayer)
		guiSetVisible(Window, false)
		guiSetInputEnabled(false)
		player = nil
	end
end

function saveNote(button, state)
	if source == Button[4] and button == "left" and state == "up" then
		local text = guiGetText(memo)
		if text then
			triggerServerEvent("savePlayerNote", localPlayer, player, text)
		end
	end
end

function showHistory(button, state)
	if source == Button[5] and button == "left" and state == "up" then
		triggerServerEvent("showAdminHistory", localPlayer, player)
	end
end

function showInventory(button, state)
	if source == Button[6] and button == "left" and state == "up" then
		if exports.rl_integration:isPlayerTrialAdmin(localPlayer) then
			triggerServerEvent("admin:showInventory", localPlayer, player)
		end
	end
end

local wHist, gHist, bClose, lastElement

addEvent("cshowAdminHistory", true)
addEventHandler("cshowAdminHistory", root, function(info, targetID)
	if wHist then
		destroyElement(wHist)
		wHist = nil
		
		showCursor(false)
	else
		local sx, sy = guiGetScreenSize()
		
		local name
		if targetID == nil then
			name = getPlayerName(source)
		else
			name = "Account " .. tostring(targetID)
		end
		
		wHist = guiCreateWindow(sx / 2 - 350, sy / 2 - 250, 800, 600, tostring(targetID) .. " isimli oyuncunun tarihçesi", false)
		exports.rl_global:centerWindow(wHist)
		
		gHist = guiCreateGridList(0, 0.04, 1, 0.88, true, wHist)
		local colID = guiGridListAddColumn(gHist, "ID", 0.05)
		local colAction = guiGridListAddColumn(gHist, "Ceza", 0.07)
		local colChar = guiGridListAddColumn(gHist, "Karakter", 0.2)
		local colReason = guiGridListAddColumn(gHist, "Sebep", 0.25)
		local colDuration = guiGridListAddColumn(gHist, "Süre", 0.07)
		local colAdmin = guiGridListAddColumn(gHist, "Yetkili", 0.15)
		local colDate = guiGridListAddColumn(gHist, "Tarih", 0.15)
		
		for _, res in pairs(info) do
			local row = guiGridListAddRow(gHist)
			guiGridListSetItemText(gHist, row, colID, res[7]  or "?", false, true)
			guiGridListSetItemText(gHist, row, colAction, getHistoryAction(res[2]), false, false)
			guiGridListSetItemText(gHist, row, colChar, res[6], false, false)
			guiGridListSetItemText(gHist, row, colReason, res[3], false, false)
			guiGridListSetItemText(gHist, row, colDuration, historyDuration(res[4], tonumber(res[2])), false, false)
			guiGridListSetItemText(gHist, row, colAdmin, res[5], false, false)
			guiGridListSetItemText(gHist, row, colDate, res[1], false, false)
		end
		
		local bremove = guiCreateButton(0, 0.93, 0.5, 0.07, "Sil", true, wHist)
		addEventHandler("onClientGUIClick", bremove, function(button, state)
			if exports.rl_integration:isPlayerTrialAdmin(localPlayer) then
				local row, col = guiGridListGetSelectedItem(gHist)
				if row ~= -1 and col ~= -1 then
					local gridID = guiGridListGetItemText(gHist , row, col)
					local record = getHistoryRecordFromId(info, gridID)
					
					if tonumber(record[2]) == 6 then
						outputChatBox("[!]#FFFFFF Bu kayıt silinemez.", 255, 0, 0, true)
						playSoundFrontEnd(4)
						return
					end
					
					if not exports.rl_integration:isPlayerLeaderAdmin(localPlayer) and tonumber(record[8]) ~= getElementData(localPlayer, "account_id") then
						outputChatBox("[!]#FFFFFF Yalnızca ceza verme yetkisine sahip olduğunuz bir kaydı silebilirsiniz.", 255, 0, 0, true)
						playSoundFrontEnd(4)
						return
					end
					
					triggerServerEvent("admin:removehistory", localPlayer, gridID)
					destroyElement(wHist)
					wHist = nil
					showCursor(false)
				else
					outputChatBox("[!]#FFFFFF Bir kayıt seçmelisiniz.", 255, 0, 0, true)
					playSoundFrontEnd(4)
				end
			else
				outputChatBox("[!]#FFFFFF Bu kayıtı kaldırmak için discord adresimize bir ticket oluşturun.", 255, 0, 0, true)
				playSoundFrontEnd(4)
			end
		end, false)
		
		bClose = guiCreateButton(0.52, 0.93, 0.47, 0.07, "Kapat", true, wHist)
		addEventHandler("onClientGUIClick", bClose, function(button, state)
			if button == "left" and state == "up" then
				destroyElement(wHist)
				wHist = nil
				showCursor(false)
			end
		end, false)
		
		showCursor(true)
	end
end)