rcmenu = false
local rcWidth = 0
local rcHeight = 0

function destroy()
	destroyTimer = nil
	if rcmenu then
		destroyElement(rcmenu)
	end
	rcWidth = 0
	rcHeight = 0
	rcmenu = nil
	if isCursorShowing() then
		showCursor(false)
	end
	return true
end

function isrcOpen()
	return rcmenu
end

function leftClickAnywhere(button, state, absX, absY, wx, wy, wz, element)
	if (button == "left" and state == "down") then
		if isElement(rcmenu) then
			destroyTimer = setTimer(destroy, 250, 1)
		end
	end
end
addEventHandler("onClientClick", root, leftClickAnywhere, true)
addEvent("serverTriggerLeftClick", true)
addEventHandler("serverTriggerLeftClick", localPlayer, leftClickAnywhere)

function create(title)
	if (destroyTimer) then
		killTimer(destroyTimer)
		destroyTimer = nil
	end
	if (rcmenu) then
		destroy()
	end
	if not title then title = "" end
	local x, y, wx, wy, wz = getCursorPosition()
	if type(x) == 'boolean' then
		x = 0.5
		y = 0.5
	end
	rcmenu = guiCreateStaticImage(x, y, 0, 0, "public/images/0_a90.png", true)
	rcTitleBg = guiCreateStaticImage(0, 0, 0, 0, "public/images/0.png", false, rcmenu)
	rcTitle = guiCreateLabel(10, 0, 0, 0, tostring(title), false, rcTitleBg)
	guiSetFont(rcTitle, "default-bold-small")
	guiLabelSetColor(rcTitle, 255, 255, 255)
	guiLabelSetVerticalAlign(rcTitle, "center")
	local extent = guiLabelGetTextExtent(rcTitle)
	guiSetSize(rcTitleBg, 500, 30, false)
	guiSetSize(rcTitle, extent, 30, false)
	rcWidth = extent + 20
	rcHeight = 30
	guiSetSize(rcmenu, rcWidth, rcHeight, false)
	return rcmenu
end

function addRow(title, header, nohover)
	local row
	local image
	if not title then title = "" end
	if header then
		local rowbg = guiCreateStaticImage(0, rcHeight, 500, 30, "0.png", false, rcmenu)
		local textX = 10+19+10
		local addWidth = textX + 10
		row = guiCreateLabel(textX, 0, 0, 0, tostring(title), false, rowbg)
		guiSetFont(row, "default-bold-small")
		guiLabelSetColor(row, 255, 255, 255)
		guiLabelSetVerticalAlign(row, "center")
		local extent = guiLabelGetTextExtent(row)
		guiSetSize(row, extent, 30, false)
		rcHeight = rcHeight + 30
		if (extent + addWidth > rcWidth) then
			rcWidth = extent + addWidth + 10
		end
		guiSetSize(rcmenu, rcWidth, rcHeight+5, false)
	else
		local textX = 10+19+10
		local addWidth = textX + 5
		row = guiCreateLabel(textX, rcHeight, 0, 0, tostring(title), false, rcmenu)
		guiLabelSetVerticalAlign(row, "center")
		image = guiCreateStaticImage(10, rcHeight+6, 19, 19, ":rl_ui/public/images/logo.png", false, rcmenu)
		guiSetProperty(image, "ImageColours", exports.rl_ui:getServerColor(3))
		guiSetVisible(image, false)
		guiSetFont(row, "default-normal")
		guiLabelSetColor(row, 255, 255, 255)
		local extent = guiLabelGetTextExtent(row)
		guiSetSize(row, extent, 30, false)
		rcHeight = rcHeight + 30
		if (extent + addWidth > rcWidth) then
			rcWidth = extent + addWidth + 10
		end
		guiSetSize(rcmenu, rcWidth, rcHeight+5, false)
		if not nohover then
			addEventHandler("onClientMouseEnter", row, function()
				guiSetVisible(image, true)
			end, false)
			addEventHandler("onClientMouseLeave", row, function()
				guiSetVisible(image, false)
			end, false)
		else
			guiLabelSetColor(row, 180, 180, 180)
		end
	end

	local posX, posY = guiGetPosition(rcmenu, false)
	local menuWidth, menuHeight = guiGetSize(rcmenu, false)
	local screenWidth, screenHeight = guiGetScreenSize()
	posX = math.max(0, math.min(posX, screenWidth - menuWidth))
	posY = math.max(0, math.min(posY, screenHeight - menuHeight))
	guiSetPosition(rcmenu, posX, posY, false)

	return row
end

function addrow(title, header, nohover)
	return addRow(title, header, nohover)
end