addEvent("createFactionGUI", true)
addEventHandler("createFactionGUI", root, function()
	guiSetInputMode("no_binds_when_editing")
	
	local screenW, screenH = guiGetScreenSize()
	birlikWindow = guiCreateWindow((screenW - 288) / 2, (screenH - 321) / 2, 288, 321, "Birlik Kurma Arayüzü", false)
	guiWindowSetSizable(birlikWindow, false)

	isimLbl = guiCreateLabel(10, 26, 63, 26, "Birlik Adı: ", false, birlikWindow)
	guiLabelSetHorizontalAlign(isimLbl, "center", false)
	guiLabelSetVerticalAlign(isimLbl, "center")
	isimEdit = guiCreateEdit(73, 26, 204, 26, "", false, birlikWindow)
	maxKarakterLbl = guiCreateLabel(73, 52, 204, 15, "Max. 36 Karakter.", false, birlikWindow)
	turLbl = guiCreateLabel(10, 77, 63, 26, "Birlik Tipi: ", false, birlikWindow)
	guiLabelSetHorizontalAlign(turLbl, "center", false)
	guiLabelSetVerticalAlign(turLbl, "center")
	ceteRadio = guiCreateRadioButton(73, 77, 204, 26, "Çete", false, birlikWindow)
	mafyaRadio = guiCreateRadioButton(73, 103, 204, 26, "Mafya", false, birlikWindow)
	haberRadio = guiCreateRadioButton(73, 129, 204, 26, "Haber", false, birlikWindow)
	mechanicRadio = guiCreateRadioButton(73, 155, 204, 26, "Mekanik", false, birlikWindow)
	digerRadio = guiCreateRadioButton(73, 181, 204, 26, "Diğer (Legal)", false, birlikWindow)
	guiRadioButtonSetSelected(digerRadio, true)
	kurBtn = guiCreateButton(10, 217, 267, 39, "Kur ($10,000)", false, birlikWindow)
	addEventHandler("onClientGUIClick", kurBtn, function() 
		if guiRadioButtonGetSelected(ceteRadio) then
			birlikType = 0
		elseif guiRadioButtonGetSelected(mafyaRadio) then
			birlikType = 1
		elseif guiRadioButtonGetSelected(haberRadio) then
			birlikType = 6
		elseif guiRadioButtonGetSelected(mechanicRadio) then
			birlikType = 7
		elseif guiRadioButtonGetSelected(digerRadio) then
			birlikType = 5
		end
		triggerServerEvent("createFaction", localPlayer, guiGetText(isimEdit), birlikType) 
		destroyElement(birlikWindow) 
	end)
	guiSetProperty(kurBtn, "NormalTextColour", "FFAAAAAA")
	kapatBtn = guiCreateButton(10, 266, 267, 39, "Kapat", false, birlikWindow)
	addEventHandler("onClientGUIClick", kapatBtn, function() destroyElement(birlikWindow) end)
	guiSetProperty(kapatBtn, "NormalTextColour", "FFAAAAAA")
end)