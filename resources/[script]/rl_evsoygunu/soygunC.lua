addEventHandler("onClientResourceStart", root, function()
	setElementData(root,"giris:yapildi",0)
end)

addEvent('evsoygun:render',true)
addEventHandler('evsoygun:render', root, function(state)
	if state == 1 then
		addEventHandler("onClientRender", root, test)
	else
		removeEventHandler("onClientRender", root, test)
	end
end)

x, y = guiGetScreenSize()
ayaksesi = 0
checked = false

function test()
	dxDrawRoundedRectangle(x/2.3, y/1.06, 230, 50, 20, tocolor(20, 20, 20))

	if checked == false then
		if (getElementVelocity(localPlayer) ~= 0) then
			ayaksesi = ayaksesi + 1
		else
			ayaksesi = ayaksesi - 1
		end

		if ayaksesi > 99 then
			ayaksesi = 100
			outputChatBox("[Reval] #ffffffEv sahibi uyandı ve ekiplere haber verdi!", thePlayer, 255, 137, 10, true)

			triggerServerEvent("evsoygun:ihbar", localPlayer)

			checked = true
		elseif ayaksesi < 1 then
			ayaksesi = 0
		end
	end

	dxDrawText('aYaK sesi: %'..ayaksesi, x/2.245, y/1.055, x/2.245, y/1.055, tocolor(255, 255, 255, 255), 1.3, "pricedown")
	
end

function dxDrawRoundedRectangle(x, y, width, height, radius, color, postGUI, subPixelPositioning)
    dxDrawRectangle(x+radius, y+radius, width-(radius*2), height-(radius*2), color, postGUI, subPixelPositioning)
    dxDrawCircle(x+radius, y+radius, radius, 180, 270, color, color, 16, 1, postGUI)
    dxDrawCircle(x+radius, (y+height)-radius, radius, 90, 180, color, color, 16, 1, postGUI)
    dxDrawCircle((x+width)-radius, (y+height)-radius, radius, 0, 90, color, color, 16, 1, postGUI)
    dxDrawCircle((x+width)-radius, y+radius, radius, 270, 360, color, color, 16, 1, postGUI)
    dxDrawRectangle(x, y+radius, radius, height-(radius*2), color, postGUI, subPixelPositioning)
    dxDrawRectangle(x+radius, y+height-radius, width-(radius*2), radius, color, postGUI, subPixelPositioning)
    dxDrawRectangle(x+width-radius, y+radius, radius, height-(radius*2), color, postGUI, subPixelPositioning)
    dxDrawRectangle(x+radius, y, width-(radius*2), radius, color, postGUI, subPixelPositioning)
end