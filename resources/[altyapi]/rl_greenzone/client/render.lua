local screenSize = Vector2(guiGetScreenSize())
local theme = exports.rl_ui:useTheme()
local fonts = {
	main = exports.rl_fonts:getFont("sf-medium", 9),
}

setTimer(function()
    if getElementData(localPlayer, "greenzone") then
        local text = "Güvenli Bölge"
		local sizeX, sizeY = dxGetTextWidth(text, 1, fonts.main), 35
		local screenX, screenY = ((screenSize.x - sizeX) / 2) + 20, (screenSize.y - sizeY) - 20
		
        dxDrawText(text, screenX - 1770, screenY - 3, screenX + sizeX, sizeY, tocolor(0, 255, 0, 200), 1, fonts.main, "center")
    end
end, 0, 0)