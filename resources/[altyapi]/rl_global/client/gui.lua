function centerWindow(window)
    local screenSize = Vector2(guiGetScreenSize())
    local windowX, windowY = guiGetSize(window, false)
    local x, y = (screenSize.x - windowX) / 2, (screenSize.y - windowY) / 2
    guiSetPosition(window, x, y, false)
end

function guiComboBoxAdjustHeight(comboBox, itemCount)
	if itemCount < 3 then itemCount = 3 end
	itemCount = itemCount + 1
	if getElementType(comboBox) ~= "gui-combobox" or type(itemCount) ~= "number" then error("Invalid arguments @ 'guiComboBoxAdjustHeight'", 2) end
	local width = guiGetSize(comboBox, false)
	return guiSetSize(comboBox, width, (itemCount * 20) + 20, false)
end