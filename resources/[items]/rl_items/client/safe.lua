wRightClick = nil
bInventory = nil
bCloseMenu = nil
ax, ay = nil
safe = nil

local function requestInventory(button)
	if button=="left" and not getElementData(localPlayer, "exclusiveGUI") then
		triggerServerEvent("openFreakinInventory", localPlayer, safe, ax, ay)
		hideSafeMenu()
	end
end

function clickSafe(button, state, absX, absY, wx, wy, wz, element)
	if getElementData(localPlayer, "exclusiveGUI") then
		return
	end
	if element and getElementType(element) == "object" and button == "right" and state == "down" and getElementModel(element) == 2332 then
		local x, y, z = getElementPosition(localPlayer)
		
		if getDistanceBetweenPoints3D(x, y, z, wx, wy, wz) <= 3 then
			if (wRightClick) then
				hideSafeMenu()
			end
			
			local dimension = getElementDimension(localPlayer)
			if (dimension < 19000 and (hasItem(localPlayer, 5, dimension) or hasItem(localPlayer, 4, dimension))) or (dimension >= 20000 and hasItem(localPlayer, 3, dimension - 20000)) or ((getElementData(localPlayer, "admin_level") >= 9) and (getElementData(localPlayer, "duty_admin"))) then
				showCursor(true)
				ax = absX
				ay = absY
				safe = element
				showSafeMenu()
			else
				outputChatBox("[!]#FFFFFF Bu işlemi gerçekleştirme izniniz yok.", 255, 0, 0, true)
				playSoundFrontEnd(4)
			end
		end
	end
end
addEventHandler("onClientClick", root, clickSafe, true)

function showSafeMenu()
	wRightClick = guiCreateWindow(ax, ay, 150, 100, "Kasa", false)

	bInventory = guiCreateButton(0.05, 0.23, 0.87, 0.2, "Envanter", true, wRightClick)
	addEventHandler("onClientGUIClick", bInventory, requestInventory, false)
	
	bCloseMenu = guiCreateButton(0.05, 0.63, 0.87, 0.2, "Kapat", true, wRightClick)
	addEventHandler("onClientGUIClick", bCloseMenu, hideSafeMenu, false)
end

function hideSafeMenu()
	if (isElement(bCloseMenu)) then
		destroyElement(bCloseMenu)
	end
	bCloseMenu = nil
	
	if (isElement(wRightClick)) then
		destroyElement(wRightClick)
	end
	wRightClick = nil
	
	ax = nil
	ay = nil


	showCursor(false)
	triggerEvent("cursorHide", localPlayer)
	setElementData(localPlayer, "exclusiveGUI", false, false)
end