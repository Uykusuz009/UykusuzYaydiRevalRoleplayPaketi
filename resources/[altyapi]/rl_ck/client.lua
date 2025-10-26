local screenW, screenH = guiGetScreenSize()
addEvent("ckPanel.gosterPanel",true)
addEventHandler("ckPanel.gosterPanel", root, function(isim)
        

        ckGui = guiCreateWindow((screenW - 425) / 2, (screenH - 120) / 2, 425, 120, "Ck Sistemi v1.0", false)
        guiSetVisible(ckGui, false)
	guiWindowSetSizable(ckGui, false)  

        sellerLabel = guiCreateLabel(10, 26, 405, 40,""..isim.." Adlı kişi sizi ck etmek istiyor,\nCK olmak istiyormusun?", false, ckGui)
        
	ckKabul = guiCreateButton(10, 70, 200, 39, "Evet, istiyorum.", false, ckGui)
	guiSetProperty(ckKabul, "NormalTextColour", "FFAAAAAA")
	ckReddet = guiCreateButton(215, 70, 200, 39, "Hayır, istemiyorum.", false, ckGui)
	guiSetProperty(ckReddet, "NormalTextColour", "FFAAAAAA")
        oyuncuisim = guiCreateLabel(0,0,0,0,"",false,ckGui)

	if guiGetVisible(ckGui) then return end
        guiSetVisible(ckGui, true)
	showCursor(true)
	setWindowFlashing(true,3)
        guiSetText(oyuncuisim, isim)
end)


function kapatPanel()
	if isElement(ckGui) then
                guiSetVisible(ckGui, false)
		showCursor(false)
	end
end

addEventHandler("onClientGUIClick", root,
	function()
		if source == ckKabul then
			triggerServerEvent("ckPanel.onaylama", localPlayer, "kabul", localPlayer, guiGetText(oyuncuisim) )
			kapatPanel()
		elseif source == ckReddet then
			triggerServerEvent("ckPanel.onaylama", localPlayer, "reddet", localPlayer, guiGetText(oyuncuisim) )
			kapatPanel()
		end
	end
)