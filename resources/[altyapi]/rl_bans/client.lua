function createWindow(bans, clientBans, accountBans)
	if not isElement(window) then
		if exports.rl_integration:isPlayerLeaderAdmin(localPlayer) then
			window = guiCreateWindow(0, 0, 700, 400, "[Banlar: " .. (#bans or 0) .. " - Client Banlar: " .. (#clientBans or 0) .. " - Hesap Banları: " .. (#accountBans or 0) .. "]", false)
			exports.rl_global:centerWindow(window)

			tabPanel = guiCreateTabPanel(10, 24, 680, 315, false, window)
			tab1 = guiCreateTab("Banlar", tabPanel)
			tab2 = guiCreateTab("Client Banlar", tabPanel)
			tab3 = guiCreateTab("Hesap Banları", tabPanel)

			gridList1 = guiCreateGridList(10, 10, 660, 270, false, tab1)
			guiGridListAddColumn(gridList1, "Karakter Adı", 0.2)
			guiGridListAddColumn(gridList1, "Yetkili", 0.2)
			guiGridListAddColumn(gridList1, "Sebep", 0.15)
			guiGridListAddColumn(gridList1, "IP", 0.16)
			guiGridListAddColumn(gridList1, "Serial", 0.24)
			
			for _, value in ipairs(bans) do
				local row = guiGridListAddRow(gridList1)
				guiGridListSetItemText(gridList1, row, 1, value[1] or "?", false, false)
				guiGridListSetItemText(gridList1, row, 2, value[2] or "?", false, false)
				guiGridListSetItemText(gridList1, row, 3, value[3] or "?", false, false)
				guiGridListSetItemText(gridList1, row, 4, value[4] or "?", false, false)
				guiGridListSetItemText(gridList1, row, 5, value[5] or "?", false, false)
			end
			
			gridList2 = guiCreateGridList(10, 10, 660, 270, false, tab2)
			guiGridListAddColumn(gridList2, "ID", 0.1)
			guiGridListAddColumn(gridList2, "Serial", 0.25)
			guiGridListAddColumn(gridList2, "IP", 0.15)
			guiGridListAddColumn(gridList2, "Yetkili", 0.25)
			guiGridListAddColumn(gridList2, "Sebep", 0.15)
			guiGridListAddColumn(gridList2, "Tarih", 0.2)

			for _, value in ipairs(clientBans) do
				local row = guiGridListAddRow(gridList2)
				guiGridListSetItemText(gridList2, row, 1, value[1] or "?", false, false)
				guiGridListSetItemText(gridList2, row, 2, value[2] or "?", false, false)
				guiGridListSetItemText(gridList2, row, 3, value[3] or "?", false, false)
				guiGridListSetItemText(gridList2, row, 4, value[4] or "?", false, false)
				guiGridListSetItemText(gridList2, row, 5, value[5] or "?", false, false)
				guiGridListSetItemText(gridList2, row, 6, value[6] or "?", false, false)
			end
			
			gridList3 = guiCreateGridList(10, 10, 660, 270, false, tab3)
			guiGridListAddColumn(gridList3, "ID", 0.1)
			guiGridListAddColumn(gridList3, "Kullanıcı Adı", 0.8)
			
			for _, value in ipairs(accountBans) do
				local row = guiGridListAddRow(gridList3)
				guiGridListSetItemText(gridList3, row, 1, value[1] or "?", false, false)
				guiGridListSetItemText(gridList3, row, 2, value[2] or "?", false, false)
			end

			close = guiCreateButton(0.01, 0.87, 0.47, 0.10, "Kapat", true, window)
			guiSetFont(close, "default-bold-small")
			
			submit = guiCreateButton(0.5, 0.87, 0.48, 0.10, "Banı Aç", true, window)
			guiSetFont(submit, "default-bold-small")
		end
	else
		destroyElement(window)
	end
end
addEvent("bans.openWindow", true)
addEventHandler("bans.openWindow", root, createWindow)

addEventHandler("onClientGUIClick", root, function()
    if source == close then 
        destroyElement(window)
    elseif source == submit then
		if guiGetSelectedTab(tabPanel) == tab1 then
			local selectedItem = guiGridListGetSelectedItem(gridList1)
			if selectedItem and selectedItem ~= -1 then
				local serial = guiGridListGetItemText(gridList1, selectedItem, 5)
				triggerServerEvent("bans.removeBan", localPlayer, 1, serial)
				destroyElement(window)
				showCursor(false)
			end
		elseif guiGetSelectedTab(tabPanel) == tab2 then
			local selectedItem = guiGridListGetSelectedItem(gridList2)
			if selectedItem and selectedItem ~= -1 then
				local id = guiGridListGetItemText(gridList2, selectedItem, 1)
				triggerServerEvent("bans.removeBan", localPlayer, 2, id)
				destroyElement(window)
				showCursor(false)
			end
		elseif guiGetSelectedTab(tabPanel) == tab3 then
			local selectedItem = guiGridListGetSelectedItem(gridList3)
			if selectedItem and selectedItem ~= -1 then
				local id = guiGridListGetItemText(gridList3, selectedItem, 1)
				local username = guiGridListGetItemText(gridList3, selectedItem, 2)
				triggerServerEvent("bans.removeBan", localPlayer, 3, { id, username })
				destroyElement(window)
				showCursor(false)
			end
		end
    end
end)