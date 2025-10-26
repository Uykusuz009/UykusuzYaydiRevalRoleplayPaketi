local IntsList1 = {}
local IntsSearchList = {}
local intID = nil
local intsTabPanel = false
local sx, sy = guiGetScreenSize()

function createIntManagerWindow(IntsList)
	if gWin then
		closeIntManager()
	end
	
	if (IntsList) then
		showCursor(true)
		
		gWin = guiCreateWindow(sx/2-400,sy/2-300,800,600,"Interior Yönetim",false)
		guiWindowSetSizable(gWin,false)
		intsTabPanel = guiCreateTabPanel(0.0113,0.1417,0.9775,0.8633,true,gWin)
		
		bDelInt = guiCreateButton(0.0113,0.035,0.0938,0.045,"Kaldır",true,gWin)
		guiSetFont(bDelInt,"default-bold-small")
		bRestoreInt = guiCreateButton(0.0113,0.085,0.0938,0.045,"Düzelt",true,gWin)
		guiSetFont(bRestoreInt,"default-bold-small")
		
		bToggleInt = guiCreateButton(0.1175,0.035,0.1,0.045,"İnaktif Et",true,gWin)
		guiSetFont(bToggleInt,"default-bold-small")
		bGotoInt = guiCreateButton(0.1175,0.085,0.1,0.045,"Işınlan",true,gWin)
		guiSetFont(bGotoInt,"default-bold-small")

		bForceSell = guiCreateButton(0.23,0.035,0.1,0.045,"Sat",true,gWin)
		guiSetFont(bForceSell,"default-bold-small")
		bRemoveInt = guiCreateButton(0.23,0.085,0.1,0.045,"Kaldır",true,gWin)
		guiSetFont(bRemoveInt,"default-bold-small")
			
		bAdminNote = guiCreateButton(0.3425,0.035,0.1,0.045,"Düzenle",true,gWin)
		guiSetFont(bAdminNote,"default-bold-small")
		bSearch = guiCreateButton(0.3425,0.085,0.1,0.045,"Ara",true,gWin)
		guiSetFont(bSearch,"default-bold-small")
		
		bClose = guiCreateButton(0.455,0.035,0.1,0.09,"Kapat",true,gWin)
		guiSetFont(bClose,"default-bold-small")
		
		local lTotal = guiCreateLabel(460,25,164,17,"Toplam Interiorlar: ",false,gWin)
		local lActive = guiCreateLabel(460,42,164,17,"Aktif Interiorlar: ",false,gWin)
		local lDisableInts = guiCreateLabel(628,25,159,17,"Devre-dışı Interiorlar: ",false,gWin)
		local lInactive = guiCreateLabel(628,42,159,17,"İnaktif Interiorlar: ",false,gWin)
		local lOwnedbyCKs = guiCreateLabel(460,59,164,17,"Sahipleri CK olan Interiorlar: ",false,gWin)
		local lDeletedInts = guiCreateLabel(628,59,159,17,"Silinen Interiorlar: ",false,gWin)
		
		local targetTab = {}
		local targetList = {}
		local colID = {}
		local colType = {}
		local colName = {}
		local colPrice = {}
		local colOwner = {}
		local colLastUsed = {}
		local colLocked = {}
		local colSupplies = {}
		local colSafeInstalled = {}
		local colDisabled = {}
		local colDeleted = {}
		local colCreatedBy = {}
		local colCreatedDate = {}
		local colAdminNote = {}
		
		targetTab[1] = guiCreateTab("Aktif Interiorlar", intsTabPanel) 
		targetTab[2] = guiCreateTab("İnaktif Interiorlar", intsTabPanel) 
		targetTab[3] = guiCreateTab("Devre-dışı Interiorlar", intsTabPanel) 
		targetTab[4] = guiCreateTab("Sahipleri CK olan Interiorlar", intsTabPanel) 
		targetTab[5] = guiCreateTab("Silinen Interiorlar", intsTabPanel) 
		targetTab[6] = guiCreateTab("Aranan sonuçlar", intsTabPanel) 
		
		targetList[1] = guiCreateGridList(0,0,1,1,true,targetTab[1])
		targetList[2] = guiCreateGridList(0,0,1,1,true,targetTab[2])
		targetList[3] = guiCreateGridList(0,0,1,1,true,targetTab[3])
		targetList[4] = guiCreateGridList(0,0,1,1,true,targetTab[4])
		targetList[5] = guiCreateGridList(0,0,1,1,true,targetTab[5])
		targetList[6] = guiCreateGridList(0,0,1,1,true,targetTab[6])
		
		for i = 1,6 do
			colID[i] = guiGridListAddColumn(targetList[i],"ID",0.07)
			colType[i] = guiGridListAddColumn(targetList[i],"Tip",0.1)	
			colName[i] = guiGridListAddColumn(targetList[i],"İsim",0.25)
			colPrice[i] = guiGridListAddColumn(targetList[i],"Fiyat",0.07)
			colOwner[i] = guiGridListAddColumn(targetList[i],"Sahibi",0.2)
			colLastUsed[i] = guiGridListAddColumn(targetList[i],"Son Kullanılan",0.08)
			colLocked[i] = guiGridListAddColumn(targetList[i],"Kilit",0.06)
			colSupplies[i] = guiGridListAddColumn(targetList[i],"Tedarik",0.06)
			colSafeInstalled[i] = guiGridListAddColumn(targetList[i],"Güvenli Kurulum",0.06)
			colDisabled[i] = guiGridListAddColumn(targetList[i],"Devre-dışı",0.06)
			colDeleted[i] = guiGridListAddColumn(targetList[i],"Silindi",0.08)
			colCreatedBy[i] = guiGridListAddColumn(targetList[i],"Oluşturan",0.1)
			colCreatedDate[i] = guiGridListAddColumn(targetList[i],"Oluşturulma Tarihi",0.17)
			colAdminNote[i] = guiGridListAddColumn(targetList[i],"Yetkili Notu",1)
		end	
		local count = {[1]=0, [2] = 0, [3] = 0, [4] = 0, [5] = 0}
		for _, record in ipairs(IntsList) do
			local lastUsed, isInteriorInactive = formartDays(record[8])
			local i = 1 -- active ints
			if record[13] ~= "0" then --deleted ints
				i = 5 
				count[5] = count[5] + 1
			elseif isInteriorInactive then -- inactive ints
				i = 2
				count[2] = count[2] + 1
			elseif record[12] == "1" then --disabled ints
				i = 3 
				count[3] = count[3] + 1
			elseif record[7] == "1" then -- owned by CKed's
				i = 4
				count[4] = count[4] + 1
			else
				count[1] = count[1] + 1
			end
			
			local row = guiGridListAddRow(targetList[i])
			guiGridListSetItemText(targetList[i], row, colID[i], record[1] or "", false, true)
			guiGridListSetItemText(targetList[i], row, colType[i], intTypeName(record[2]), false, false)
			guiGridListSetItemText(targetList[i], row, colName[i], record[3] or "", false, false)
			guiGridListSetItemText(targetList[i], row, colPrice[i], record[4], false, true)
			guiGridListSetItemText(targetList[i], row, colOwner[i], charName(record[5])..cked(record[7])..accountName(record[6]) .. (record[20] or ""), false, false) 
			guiGridListSetItemText(targetList[i], row, colLastUsed[i],lastUsed , false, false)
			guiGridListSetItemText(targetList[i], row, colLocked[i], record[9] == "0" and "Açık" or "Kilitli", false, false)
			guiGridListSetItemText(targetList[i], row, colSupplies[i], record[10] or "", false, false)
			guiGridListSetItemText(targetList[i], row, colSafeInstalled[i], record[11] and "Evet" or "Hayır", false, false)
			guiGridListSetItemText(targetList[i], row, colDisabled[i], record[12] == "1" and "Evet" or "Hayır", false, false)
			guiGridListSetItemText(targetList[i], row, colDeleted[i], record[13] == "0" and "Hayır" or record[13], false, false)
			guiGridListSetItemText(targetList[i], row, colCreatedBy[i], record[16] or "", false, false)
			guiGridListSetItemText(targetList[i], row, colCreatedDate[i], record[15] or "", false, false)
			guiGridListSetItemText(targetList[i], row, colAdminNote[i], record[14] or "", false, false)
		end
		
		guiSetText(lTotal , "Toplam Interiorlar: " .. count[1]+count[2]+count[3]+count[4]+count[5])
		guiSetText(lActive , "Aktif Interiorlar: " .. count[1])
		guiSetText(lDisableInts , "Devre-dışı Interiorlar: " .. count[3])
		guiSetText(lInactive , "İnaktif Interiorlar: " .. count[2])
		guiSetText(lOwnedbyCKs , "Sahipleri CK olan Interiorlar: " .. count[4])
		guiSetText(lDeletedInts , "Silinen Interiorlar: " .. count[5])
		
		function getListFromActiveTab(intsTabPanel)
			if intsTabPanel then
				if guiGetSelectedTab (intsTabPanel) == targetTab[1] then
					return targetList[1], 1
				elseif guiGetSelectedTab (intsTabPanel) == targetTab[2] then
					return targetList[2], 2
				elseif guiGetSelectedTab (intsTabPanel) == targetTab[3] then
					return targetList[3], 3
				elseif guiGetSelectedTab (intsTabPanel) == targetTab[4] then
					return targetList[4], 4
				elseif guiGetSelectedTab (intsTabPanel) == targetTab[5] then
					return targetList[5], 5
				elseif guiGetSelectedTab (intsTabPanel) == targetTab[6] then
					return targetList[6], 6
				else
					return false, false
				end
			else
				return false, false
			end
		end
		
		addEventHandler("onClientGUIClick", bClose, singleClickedGate)
		
		addEventHandler("onClientGUIClick", bSearch,
			function(button)
				if button == "left" then
					if wInteriorSearch then
						destroyElement(wInteriorSearch)
						wInteriorSearch = nil
					end
					showCursor(true)
					guiSetInputEnabled(true)
					wInteriorSearch = guiCreateWindow(sx/2-176,sy/2-52,352,104,"Interior Ara",false)
					guiWindowSetSizable(wInteriorSearch,false)
					local lText = guiCreateLabel(10,22,341,16,"Interior araması için gerekli bilgileri girin (ID, İsim, Sahibi, Fiyat, ...):",false,wInteriorSearch)
					guiSetFont(lText,"default-small")
					local eSearch = guiCreateEdit(10,38,331,31,"Ara",false,wInteriorSearch)
					addEventHandler("onClientGUIFocus", eSearch, function()
						guiSetText(eSearch , "")
					end, false)
					local bCancel = guiCreateButton(10,73,169,22,"İptal",false,wInteriorSearch)
					guiSetFont(bCancel,"default-bold-small")
					addEventHandler("onClientGUIClick", bCancel, function(button)
						if button == "left" and wInteriorSearch then
							destroyElement(wInteriorSearch)
							wInteriorSearch = nil
						end
					end, false)
					local bGo = guiCreateButton(179,73,162,22,"Git",false,wInteriorSearch)
					guiSetFont(bGo,"default-bold-small")
					addEventHandler("onClientGUIClick", bGo, function(button)
						if button == "left" and wInteriorSearch then
							triggerServerEvent("interiorManager:Search", localPlayer, guiGetText(eSearch))
							destroyElement(wInteriorSearch)
							wInteriorSearch = nil
						end
					end, false)
				end
			end,
		false)
		
		addEventHandler("onClientGUIClick", bDelInt,
			function(button)
				if button == "left" then
					local row, col = -1, -1
					local activeList = getListFromActiveTab(intsTabPanel)
					if activeList then
						local row, col = guiGridListGetSelectedItem(activeList)
						if row ~= -1 and col ~= -1 then
							local gridID = guiGridListGetItemText(activeList , row, 1)
							triggerServerEvent("interiorManager:delint", localPlayer, gridID)
						else
							guiSetText(gWin, "Öncelikle aşağıdaki listeden bir interior seçmeniz gerekiyor.")
						end
					end
				end
			end,
		false)
		
		addEventHandler("onClientGUIClick", bToggleInt,
			function(button)
				if button == "left" then
					local row, col = -1, -1
					local activeList = getListFromActiveTab(intsTabPanel)
					if activeList then
						local row, col = guiGridListGetSelectedItem(activeList)
						if row ~= -1 and col ~= -1 then
							local gridID = guiGridListGetItemText(activeList , row, 1)
							triggerServerEvent("interiorManager:disableInt", localPlayer, gridID)
						else
							guiSetText(gWin, "Öncelikle aşağıdaki listeden bir interior seçmeniz gerekiyor.")
						end
					end
				end
			end,
		false)
		
		addEventHandler("onClientGUIClick", bGotoInt,
			function(button)
				if button == "left" then
					local row, col = -1, -1
					local activeList = getListFromActiveTab(intsTabPanel)
					if activeList then
						local row, col = guiGridListGetSelectedItem(activeList)
						if row ~= -1 and col ~= -1 then
							local gridID = guiGridListGetItemText(activeList , row, 1)
							triggerServerEvent("interiorManager:gotoInt", localPlayer, gridID)
						else
							guiSetText(gWin, "Öncelikle aşağıdaki listeden bir interior seçmeniz gerekiyor.")
						end
					end
				end
			end,
		false)
		
		addEventHandler("onClientGUIClick", bRestoreInt,
			function(button)
				if button == "left" then
					local row, col = -1, -1
					local activeList = getListFromActiveTab(intsTabPanel)
					if activeList then
						local row, col = guiGridListGetSelectedItem(activeList)
						if row ~= -1 and col ~= -1 then
							local gridID = guiGridListGetItemText(activeList , row, 1)
							triggerServerEvent("interiorManager:restoreInt", localPlayer, gridID)
						else
							guiSetText(gWin, "Öncelikle aşağıdaki listeden bir interior seçmeniz gerekiyor.")
						end
					end
				end
			end,
		false)
		
		addEventHandler("onClientGUIClick", bRemoveInt,
			function(button)
				if button == "left" then
					local row, col = -1, -1
					local activeList = getListFromActiveTab(intsTabPanel)
					if activeList then
						local row, col = guiGridListGetSelectedItem(activeList)
						if row ~= -1 and col ~= -1 then
							local gridID = guiGridListGetItemText(activeList , row, 1)
							triggerServerEvent("interiorManager:removeInt", localPlayer, gridID)
						else
							guiSetText(gWin, "Öncelikle aşağıdaki listeden bir interior seçmeniz gerekiyor.")
						end
					end
				end
			end,
		false)
		
		addEventHandler("onClientGUIClick", bForceSell,
			function(button)
				if button == "left" then
					local row, col = -1, -1
					local activeList = getListFromActiveTab(intsTabPanel)
					if activeList then
						local row, col = guiGridListGetSelectedItem(activeList)
						if row ~= -1 and col ~= -1 then
							local gridID = guiGridListGetItemText(activeList , row, 1)
							triggerServerEvent("interiorManager:forceSellInt", localPlayer, gridID)
						else
							guiSetText(gWin, "Öncelikle aşağıdaki listeden bir interior seçmeniz gerekiyor.")
						end
					end
				end
			end,
		false)
		
		addEventHandler("onClientGUIClick", bAdminNote,
			function(button)
				if button == "left" then
					local row, col = -1, -1
					local activeList = getListFromActiveTab(intsTabPanel)
					if activeList then
						local row, col = guiGridListGetSelectedItem(activeList)
						if row ~= -1 and col ~= -1 then
							local gridID = guiGridListGetItemText(activeList , row, 1)
							triggerServerEvent("interiorManager:openAdminNote", localPlayer, gridID)
						else
							guiSetText(gWin, "Öncelikle aşağıdaki listeden bir interior seçmeniz gerekiyor.")
						end
					end
				end
			end,
		false)
		
	function fetchSearchResults(interiorsResultList)
		if interiorsResultList then
			local i = 6
			guiGridListClear (targetList[i])
			local activeList, index = getListFromActiveTab(intsTabPanel)
			if index ~= i then
				guiSetSelectedTab (intsTabPanel, targetTab[i])
			end
			for _, record in ipairs(interiorsResultList) do
				local row = guiGridListAddRow(targetList[i])
				guiGridListSetItemText(targetList[i], row, colID[i], record[1] or "", false, true)
				guiGridListSetItemText(targetList[i], row, colType[i], intTypeName(record[2]), false, false)
				guiGridListSetItemText(targetList[i], row, colName[i], record[3] or "", false, false)
				guiGridListSetItemText(targetList[i], row, colPrice[i], record[4], false, true)
				guiGridListSetItemText(targetList[i], row, colOwner[i], charName(record[5])..cked(record[7])..accountName(record[6]) .. (record[20] or ""), false, false) 
				local lastUsed, isInteriorInactive = formartDays(record[8]) 
				guiGridListSetItemText(targetList[i], row, colLastUsed[i],lastUsed , false, false)
				guiGridListSetItemText(targetList[i], row, colLocked[i], record[9] == "0" and "Açık" or "Kilitli", false, false)
				guiGridListSetItemText(targetList[i], row, colSupplies[i], record[10] or "", false, false)
				guiGridListSetItemText(targetList[i], row, colSafeInstalled[i], record[11] and "Evet" or "Hayır", false, false)
				guiGridListSetItemText(targetList[i], row, colDisabled[i], record[12] == "1" and "Evet" or "Hayır", false, false)
				guiGridListSetItemText(targetList[i], row, colDeleted[i], record[13] == "0" and "Hayır" or record[13], false, false)
				guiGridListSetItemText(targetList[i], row, colCreatedBy[i], record[16] or "", false, false)
				guiGridListSetItemText(targetList[i], row, colCreatedDate[i], record[15] or "", false, false)
				guiGridListSetItemText(targetList[i], row, colAdminNote[i], record[14] or "", false, false)
			end
		end
	end
	addEvent("interiorManager:FetchSearchResults", true)
	addEventHandler("interiorManager:FetchSearchResults", localPlayer, fetchSearchResults)
	end
end
addEvent("createIntManagerWindow", true)
addEventHandler("createIntManagerWindow", localPlayer, createIntManagerWindow)

function formartDays(days)
	if not days then
		return "Bilinmiyor", false
	elseif tonumber(days) == 0 then
		return "Bugün", false
	elseif tonumber(days) >= 14 then
		return days .. " gün önce (inaktif)", true
	else
		return days .. " gün önce", false
	end
end

function intTypeName(intType)
	local intTypeName = "Bilinmiyor" 
	if intType == "0" then 
		intTypeName = "House" 
	elseif intType == "1" then 
		intTypeName = "Business"
	elseif intType == "2" then
		intTypeName = "Government"
	elseif intType == "3" then
		intTypeName = "Rentable"
	end
	return intTypeName
end

function cked(ckStatus)
	local cked = ""
	if ckStatus == "1" then 
		cked = " - CKlı" 
	end
	return cked
end

function charName(name)
	local charName = ""
	if name then
		charName = name:gsub("_", " ")
	end
	return charName
end

function accountName(name)
	local accountName = ""
	if name then
		accountName = " (" .. name .. ")"
	end
	return accountName
end
 
function closeIntManager()
	if gWin then
		removeEventHandler("onClientGUIClick", root, singleClickedGate)
		destroyElement(gWin)
		gWin = nil
		if wInteriorSearch then
			destroyElement(wInteriorSearch)
			wInteriorSearch = nil
		end
		showCursor(false)
		guiSetInputEnabled(false)
		intsTabPanel = nil
	end
end

function singleClickedGate()
	if source == bClose then
		closeIntManager()
	end
end

local notes = {}
local bAddNote = nil
local gAdminNote = nil
local newNoteLabel, newNoteMemo = nil
local currentNote = nil

function drawAdminNotes(tabAdminNote)
	if tabAdminNote and isElement(tabAdminNote) then
		cleanAllNotesGUI()
		guiSetText(bAddNote, "YENİ NOT EKLE")
		gAdminNote = guiCreateGridList(0,0,1,1,true,tabAdminNote)
		local note_colDate = guiGridListAddColumn(gAdminNote,"Tarih",0.25)
		local note_colNote = guiGridListAddColumn(gAdminNote,"İçerik",0.5)
		local note_colCreator = guiGridListAddColumn(gAdminNote,"Yaratıcı",0.1)
		local note_colNoteId = guiGridListAddColumn(gAdminNote,"Not Girişi",0.1) 
		for i, note in ipairs(notes) do
			local row = guiGridListAddRow(gAdminNote)
			guiGridListSetItemText(gAdminNote, row, note_colDate, note.date , false, true)
			guiGridListSetItemText(gAdminNote, row, note_colNote, note.note, false, false)
			guiGridListSetItemText(gAdminNote, row, note_colCreator, note.creatorname, false, false)
			guiGridListSetItemText(gAdminNote, row, note_colNoteId, note.id, false, false)
		end
		addEventHandler("onClientGUIDoubleClick", gAdminNote, function (button, state)
			if source == gAdminNote then
				local row, col = guiGridListGetSelectedItem(source)
				if row ~= -1 and col ~= -1 then
					local noteId = guiGridListGetItemText(source , row, 4)
					drawNewNote(tabAdminNote, #notes<1, noteId, button == "left")
				end
			end
		end)
	end
end

function drawNewNote(tabAdminNote, isNotesEmpty, noteId, editExiting)
	if tabAdminNote and isElement(tabAdminNote) then
		cleanAllNotesGUI()
		guiSetText(bAddNote, "NOTLARI GÖSTER")
		local margin = 0.01
		local textH = 0.1
		local text = "Aşağıda yeni bir not girişi oluşturabilirsiniz:"
		if noteId then
			currentNote = getNoteFromId(noteId)
			if editExiting then
				text = "Not düzenleniyor #" .. noteId .. " " .. currentNote.creatorname .. " tarafından. Bu notun yaratıcısı, tamamlandıktan sonra size aktarılacaktır:"
				currentNote.edit = true
			else
				text = "Not görüntüleniyor #" .. noteId .. " " .. currentNote.creatorname .. " tarafından.Düzenlemek için bunun yerine SOL'a çift tıklayın."
			end
		elseif isNotesEmpty then
			text = "Bu interiorda herhangi bir not bulunamamıştır. " .. text
		end
		local curMemo = currentNote and currentNote.note or nil
		newNoteLabel = guiCreateLabel(margin, margin*2, 1-margin*2, textH, text, true, tabAdminNote)
		newNoteMemo = guiCreateMemo(margin, margin*2+textH, 1-margin*2, 0.85, curMemo or "", true, tabAdminNote)
		if currentNote and not currentNote.edit then
			guiMemoSetReadOnly(newNoteMemo, true)
		end
	end
end

function getNoteFromId(id)
	for i, note in pairs(notes) do
		if tonumber(note.id) == tonumber(id) then
			return note
		end
	end
end

function cleanAllNotesGUI()
	if newNoteLabel and isElement(newNoteLabel) then destroyElement(newNoteLabel) newNoteLabel = nil destroyElement(newNoteMemo) newNoteMemo = nil end
	if gAdminNote and isElement(gAdminNote) then destroyElement(gAdminNote) gAdminNote = nil end
	currentNote = nil
end

function createCheckIntWindow(result, adminTitle, history, notes1)
	if checkIntWindow then
		closeCheckIntWindow()
	end
	showCursor(true)
	guiSetInputEnabled(true)
	notes = notes1
	checkIntWindow = guiCreateWindow(sx/2-300,sy/2-233,600,466,"Interior Yönetim - Interior Yetkili Not - " .. adminTitle .. " " .. getElementData(localPlayer, "account_username"),false)
	guiWindowSetSizable(checkIntWindow,false)
	local lIntNameID = guiCreateLabel(12,27,365,17,"İsim / ID: ",false,checkIntWindow)
	local lOwner = guiCreateLabel(12,44,365,17,"Sahibi: ",false,checkIntWindow)
	local lLastUsed = guiCreateLabel(12,112,163,17,"Son Kullanılan: ",false,checkIntWindow)
	local lLocked = guiCreateLabel(372,61,163,17,"Kilit: ",false,checkIntWindow)
	local lSupplies = guiCreateLabel(372,95,163,17,"Tedarik: ",false,checkIntWindow)
	local lDeleted = guiCreateLabel(372,27,163,17,"Silindi: ",false,checkIntWindow)
	local lPrice = guiCreateLabel(12,78,163,17,"Fiyat: ",false,checkIntWindow)
	local lType = guiCreateLabel(12,61,163,17,"Tip: ",false,checkIntWindow)
	local lDisabled = guiCreateLabel(372,44,163,17,"Devre-dışı: ",false,checkIntWindow)
	local lHasSafe = guiCreateLabel(372,78,163,17,"Kasa Var: ",false,checkIntWindow)
	local lCreateDate = guiCreateLabel(372,112,200,17,"Oluşturulma Tarihi: ",false,checkIntWindow)
	local lCreateBy = guiCreateLabel(372,129,200,17,"Oluşturan: ",false,checkIntWindow)
	local lLocation = guiCreateLabel(12,95,163,17,"Bölge: ",false,checkIntWindow)
	local lAdminNote = guiCreateLabel(12,133,80,17,"Yetkili Not: ",false,checkIntWindow)
		guiSetFont(lAdminNote,"default-bold-small")
	local checkIntTabPanel = guiCreateTabPanel(12,156,576,269,false,checkIntWindow) 
	local tabAdminNote = guiCreateTab("Yetkili Not", checkIntTabPanel) 
	local bCopyAdminInfo = guiCreateButton(110,133,220,20,"Yönetici Adınızı & Güncel Tarihinizi Kopyalayın",false,checkIntWindow)
	
	local tabHistory = guiCreateTab("History", checkIntTabPanel) 
	local gHistory = guiCreateGridList(0,0,1,1,true,tabHistory)
	local colDate = guiGridListAddColumn(gHistory,"Tarih",0.25)
	local colAction = guiGridListAddColumn(gHistory,"Aksiyon",0.5)
	local colActor = guiGridListAddColumn(gHistory,"Aktör",0.1)
	local colLogID = guiGridListAddColumn(gHistory,"Günlük Girişi",0.1) 
	
	--fetching shit
	guiSetText(lIntNameID, "İsim / ID: (" .. result[1][1] .. ") " .. result[1][3])
	guiSetText(lOwner, "Sahibi: " .. charName(result[1][5])..cked(result[1][7])..accountName(result[1][6]) .. (result[1][22] or ""))
	guiSetText(lLastUsed, "Son Kullanılan: " .. formartDays(result[1][8]))
	guiSetText(lLocked, "Kilit: " .. (result[1][9] == "0" and "Açık" or "Kilitli"))
	guiSetText(lSupplies, "Tedarik: " .. result[1][10] or "")
	guiSetText(lDeleted, "Silindi: " .. (result[1][15] == "0" and "Hayır" or " by " .. result[1][15]))
	guiSetText(lPrice, "Fiyat: $" .. result[1][4] or "")
	guiSetText(lType, "Tip: " .. intTypeName(result[1][2]) or "")
	guiSetText(lDisabled, "Devre-dışı: " .. (result[1][12] == "1" and "Evet" or "Hayır"))
	guiSetText(lHasSafe, "Kasa Var: " .. (result[1][11] and "Evet" or "Hayır"))
	guiSetText(lCreateDate, "Oluşturulma Tarihi: " .. (result[1][17] or ""))
	guiSetText(lCreateBy, "Oluşturan: " .. (result[1][18] or ""))
	
	if history then
		for _, h in ipairs(history) do
			local row = guiGridListAddRow(gHistory)
			guiGridListSetItemText(gHistory, row, colDate, h[1] or "N/A", false, true)
			guiGridListSetItemText(gHistory, row, colAction, h[2] or "N/A", false, false)
			guiGridListSetItemText(gHistory, row, colActor, h[3] or "N/A", false, false)
			guiGridListSetItemText(gHistory, row, colLogID, h[4] or "N/A", false, false)
		end
	end

	bAddNote = guiCreateButton(212+100,430,90,28,"YENİ NOT EKLE",false,checkIntWindow)
		guiSetFont(bAddNote,"default-bold-small")
	addEventHandler("onClientGUIClick", bAddNote,
		function(button)
			if button == "left" then
				if guiGetText(bAddNote) == "YENİ NOT EKLE" then
					drawNewNote(tabAdminNote, #notes<1)
				else
					drawAdminNotes(tabAdminNote)
				end
			end
		end,
	false)

	if notes and #notes>0 then
		drawAdminNotes(tabAdminNote, notes)
	else
		drawNewNote(tabAdminNote, #notes<1)
	end
	
	local bToggleInt1 = guiCreateButton(212,430,90,28,"Devre-dışı Et",false,checkIntWindow)
		guiSetFont(bToggleInt1,"default-bold-small")
	addEventHandler("onClientGUIClick", bToggleInt1,
		function(button)
			if button == "left" then
				triggerServerEvent("interiorManager:disableInt", localPlayer, result[1][1])
			end
		end,
	false)
	
	local bGotoInt1, bRestoreInt1, bDelInt1 = nil
	if result[1][15] ~= "0" then --deleted
		bRestoreInt1 = guiCreateButton(12,430,90,28,"Düzelt",false,checkIntWindow)
		guiSetFont(bRestoreInt1,"default-bold-small") 
		addEventHandler("onClientGUIClick", bRestoreInt1,
			function(button)
				if button == "left" then
					if triggerServerEvent("interiorManager:restoreInt", localPlayer, result[1][1]) then
						triggerServerEvent("interiorManager:checkint", localPlayer, localPlayer, "checkint", result[1][1])
					end
				end
			end,
		false)
		bRemoveInt1 = guiCreateButton(112,430,90,28,"REMOVE INT",false,checkIntWindow)
		guiSetFont(bRemoveInt1,"default-bold-small")
		addEventHandler("onClientGUIClick", bRemoveInt1,
			function(button)
				if button == "left" then
					if triggerServerEvent("interiorManager:removeInt", localPlayer, result[1][1]) then
						closeCheckIntWindow()
					end 
				end
			end,
		false)
		if getElementData(localPlayer, "admin_level") < 6 then
			guiSetEnabled(bRemoveInt1, false)
		end
		guiSetEnabled(bToggleInt1, false)
	else
		bGotoInt1 = guiCreateButton(12,430,90,28,"GO TO INT",false,checkIntWindow)
		guiSetFont(bGotoInt1,"default-bold-small") 
		addEventHandler("onClientGUIClick", bGotoInt1,
			function(button)
				if button == "left" then
					triggerServerEvent("interiorManager:gotoInt", localPlayer, result[1][1])
				end
			end,
		false)
		bDelInt1 = guiCreateButton(112,430,90,28,"DEL INT",false,checkIntWindow)
		guiSetFont(bDelInt1,"default-bold-small")
		addEventHandler("onClientGUIClick", bDelInt1,
			function(button)
				if button == "left" then
					if triggerServerEvent("interiorManager:delint", localPlayer, result[1][1]) then
						triggerServerEvent("interiorManager:checkint", localPlayer, localPlayer, "checkint", result[1][1])
					end
				end
			end,
		false)
	end
	
	local bSave = guiCreateButton(412,430,90,28,"SAVE",false,checkIntWindow)
		guiSetFont(bSave,"default-bold-small")
	local bClose = guiCreateButton(509,430,79,28,"CLOSE",false,checkIntWindow)
		guiSetFont(bClose,"default-bold-small")
	
	addEventHandler("onClientGUIClick", bClose,
		function(button)
			if button == "left" then
				closeCheckIntWindow()
			end
		end,
	false)
	
	addEventHandler("onClientGUIClick", bCopyAdminInfo,
		function(button)
			if button == "left" then
				local time = getRealTime()
				local date = time.monthday
				local month = time.month+1
				local year = time.year+1900
				local adminUsername = getElementData(localPlayer, "account_username")
				local content = " (" .. adminTitle .. " " .. adminUsername .. " on " .. date .. "/" .. month .. "/" .. year .. ")"
				if setClipboard(content) then
					guiSetText(checkIntWindow, "Kopyalandı: '" .. content .. "'")
				end
			end
		end,
	false)
	
	addEventHandler("onClientGUIClick", bSave,
		function(button)
			if button == "left" then
				local noteMemo = nil
				if newNoteMemo and isElement(newNoteMemo) then
					noteMemo = guiGetText(newNoteMemo) or nil
				end
				if noteMemo == "" or noteMemo == "\n" then
					noteMemo = nil
				end
				if noteMemo or (currentNote and currentNote.edit and currentNote.note~=noteMemo) then
					triggerServerEvent("interiorManager:saveAdminNote", localPlayer, result[1][1] , noteMemo, currentNote and currentNote.id)
					exports.rl_global:playSoundSuccess()
					closeCheckIntWindow()
				else
					outputChatBox("[!]#FFFFFF Kaydedilecek bir şey yok.", 255, 0, 0, true)
				end
			end
		end,
	false)
end
addEvent("createCheckIntWindow", true)
addEventHandler("createCheckIntWindow", localPlayer, createCheckIntWindow)

function closeCheckIntWindow()
	if checkIntWindow then
		destroyElement(checkIntWindow)
		checkIntWindow = nil
		showCursor(false)
		guiSetInputEnabled(false)
		cleanAllNotesGUI()
	end
end