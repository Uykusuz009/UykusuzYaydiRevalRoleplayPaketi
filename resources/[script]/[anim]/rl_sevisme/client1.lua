local screenW, screenH = guiGetScreenSize()
addEvent("sevisPanel.gosterPanel",true)
addEventHandler("sevisPanel.gosterPanel", root, function(isim)
        

        sevisGui = guiCreateWindow((screenW - 425) / 2, (screenH - 120) / 2, 425, 120, "Sevisme Sistemi - v1 / © pavlov", false)
        guiSetVisible(sevisGui, false)
	guiWindowSetSizable(sevisGui, false)  

        sellerLabel = guiCreateLabel(10, 26, 405, 40,""..isim.." adlı karakter sizinle sevişmek istiyor.\nBu işlemi gerçekleştirmeyi onaylıyor musun?", false, sevisGui)
        
	ckKabul = guiCreateButton(10, 70, 200, 39, "Evet, istiyorum.", false, sevisGui)
	guiSetProperty(ckKabul, "NormalTextColour", "FFAAAAAA")
	ckReddet = guiCreateButton(215, 70, 200, 39, "Hayır, istemiyorum.", false, sevisGui)
	guiSetProperty(ckReddet, "NormalTextColour", "FFAAAAAA")
        oyuncuisim = guiCreateLabel(0,0,0,0,"",false,sevisGui)

	if guiGetVisible(sevisGui) then return end
        guiSetVisible(sevisGui, true)
	showCursor(true)
	setWindowFlashing(true,3)
        guiSetText(oyuncuisim, isim)
end)


function kapatPanel()
	if isElement(sevisGui) then
                guiSetVisible(sevisGui, false)
		showCursor(false)
	end
end

addEventHandler("onClientGUIClick", root,
	function()
		if source == ckKabul then
			triggerServerEvent("sevisPanel.onaylama", localPlayer, "kabul", localPlayer, guiGetText(oyuncuisim) )
			kapatPanel()
		elseif source == ckReddet then
			triggerServerEvent("sevisPanel.onaylama", localPlayer, "reddet", localPlayer, guiGetText(oyuncuisim) )
			kapatPanel()
		end
	end
)	

