
gkirPanel = guiCreateWindow(0.38, 0.37, 0.25, 0.25, "Reval Roleplay - Gate Kırma Sistemi", true)
guiWindowSetSizable(gkirPanel, false)
guiSetVisible(gkirPanel,false)

GridList = guiCreateGridList(0.03, 0.11, 0.59, 0.84, true, gkirPanel)
guiGridListAddColumn(GridList, "İşlevler", 0.9)
for i = 1, 4 do
    guiGridListAddRow(GridList)
end
guiGridListSetItemText(GridList, 0, 1, "Bomba Kur", false, false)
guiGridListSetItemText(GridList, 1, 1, "Halat Bağla", false, false)
guiGridListSetItemText(GridList, 2, 1, "Bombayı Patlat", false, false)
guiGridListSetItemText(GridList, 3, 1, "Gateyi Kapat", false, false)
secBtn = guiCreateButton(0.62, 0.17, 0.35, 0.13, "Seç", true, gkirPanel)
kapatBtn = guiCreateButton(0.62, 0.77, 0.35, 0.13, "Kapat", true, gkirPanel)


addCommandHandler("gatekir", function()
	if getElementData(localPlayer,"faction") == 1 then
		guiSetVisible(gkirPanel, not guiGetVisible(gkirPanel))
		showCursor(guiGetVisible(gkirPanel))
		if guiGetVisible(gkirPanel) then
			guiSetInputMode("no_binds_when_editing")
		end	
	end	
end)

addEventHandler("onClientGUIClick", guiRoot, function ()
if source == secBtn then
				local row = guiGridListGetSelectedItem(GridList)
	if row == 0 then
		triggerServerEvent("gatekir:bomba", localPlayer, localPlayer)
	elseif row == 1 then
		triggerServerEvent("gatekir:halat", localPlayer, localPlayer)
	elseif row == 2 then
		triggerServerEvent("gatekir:patlat", localPlayer, localPlayer)
	elseif row == 3 then
		triggerServerEvent("gatekir:kapat", localPlayer, localPlayer)	
	end
	
elseif source == kapatBtn then
		guiSetVisible(gkirPanel,false)
		showCursor(false)
	end
end)