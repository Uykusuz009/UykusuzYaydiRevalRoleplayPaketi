--local mclain = createPed(280, 381.7802734375, 894.708984375, 1298.666259765)
local mclain = createPed(280, 381.7802734375, 894.708984375, 1298.666259765)
local pdOptionMenu = nil
setPedRotation(mclain, 270)
setElementFrozen(mclain, true)
setElementDimension(mclain, 2)
setElementInterior(mclain, 0)
--setPedAnimation(mclain, "INT_OFFICE", "OFF_Sit_Idle_Loop", -1, true, false, false)
setElementData(mclain, "talk", 1, false)
setElementData(mclain, "name", "Jeffrey Willowfield", false)

function popupPDPedMenu()
	if getElementData(getLocalPlayer(), "exclusiveGUI") then
		return
	end
	if not pdOptionMenu then
		local width, height = 200, 150
		local scrWidth, scrHeight = guiGetScreenSize()
		local x = scrWidth/2 - (width/2)
		local y = scrHeight/2 - (height/2)

		pdOptionMenu = guiCreateWindow(577,227,238,244, "Size nasýl yardýmcý olabilirim ?", false)

		bReportCrime = guiCreateButton(0.05,0.1,0.87,0.2, "Bir suç bildirmek için geldim", true, pdOptionMenu)
		addEventHandler("onClientGUIClick", bReportCrime, reportcrimeButtonFunction, false)

		bTurnIn = guiCreateButton(0.05, 0.35, 0.87, 0.2, "Suçumu itiraf etmeye geldim", true, pdOptionMenu)
		addEventHandler("onClientGUIClick", bTurnIn, turninButtonFunction, false)

		bAppointment = guiCreateButton(0.05, 0.6, 0.87, 0.2, "Bir memurdan randevu almak istiyorum", true, pdOptionMenu)
		addEventHandler("onClientGUIClick", bAppointment, appointmentButtonFunction, false)

		bSomethingElse = guiCreateButton(0.05, 0.85, 0.87, 0.2, "Yok, teþekkürler.", true, pdOptionMenu)
		addEventHandler("onClientGUIClick", bSomethingElse, otherButtonFunction, false)
		triggerServerEvent("pd:ped:start", getLocalPlayer(), getElementData(mclain, "name"))
		showCursor(true)
	end
end
addEvent("pd:popupPedMenu", true)
addEventHandler("pd:popupPedMenu", getRootElement(), popupPDPedMenu)


function closePDPedMenu()
	destroyElement(pdOptionMenu)
	pdOptionMenu = nil
	showCursor(false)
end

function reportcrimeButtonFunction()
	closePDPedMenu()
	triggerServerEvent("pd:ped:reportcrime", getLocalPlayer(), getElementData(mclain, "name"))
end

function turninButtonFunction()
	closePDPedMenu()
	triggerServerEvent("pd:ped:turnin", getLocalPlayer(), getElementData(mclain, "name"))
end

function appointmentButtonFunction()
	closePDPedMenu()
	triggerServerEvent("pd:ped:appointment", getLocalPlayer(), getElementData(mclain, "name"))
end

function otherButtonFunction()
	closePDPedMenu()
end
