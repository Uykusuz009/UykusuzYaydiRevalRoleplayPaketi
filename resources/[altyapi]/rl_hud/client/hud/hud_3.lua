local sizeX, sizeY = 260, 90
local screenX, screenY = (screenSize.x - sizeX) - 15, 20

local sx, sy = guiGetScreenSize()

local fonts = {
    font1 = exports.kaisen_fonts:getFont("sf-regular", 11),
    font2 = exports.kaisen_fonts:getFont("UbuntuBold", 12),
    font3 = exports.kaisen_fonts:getFont("sf-bold", 28),
	awesome2 = exports.kaisen_fonts:getFont("FontAwesome", 11),
}

local clickTick = 0

local selected = 1

setTimer(function()
	if getElementData(localPlayer, "hudkapa") == true then return end
    if getElementData(localPlayer, "logged") then
		if getElementData(localPlayer, "hud_settings").hud == 3 then
			
			players = 0
			for index, value in ipairs(getElementsByType('player')) do
				players = players + 1
			end
			
			dxDrawText("", screenX + 52, screenY + 3, nil, nil, exports.rl_ui:getServerColor(1), 1, fonts.awesome2, "center")
	        dxDrawText(getPlayerPing(localPlayer), screenX + 70, screenY + 3, nil, nil, tocolor(255, 255, 255, 255), 1, fonts.font1)
			
			dxDrawText("", screenX + 122, screenY + 3, nil, nil, exports.rl_ui:getServerColor(1), 1, fonts.awesome2, "center")
	        dxDrawText(players, screenX + 140, screenY + 3, nil, nil, tocolor(255, 255, 255, 255), 1, fonts.font1)
			
			dxDrawText("ID", screenX + 192, screenY + 3, nil, nil, exports.rl_ui:getServerColor(1), 1, fonts.font1, "center")
	        dxDrawText(getElementData(localPlayer, 'id'), screenX + 210, screenY + 3, nil, nil, tocolor(255, 255, 255, 255), 1, fonts.font1)
			
			dxDrawText("₺" .. exports.rl_global:formatMoney(exports.rl_global:getMoney(localPlayer)), sx - 1510, sy - 70, sx - 15, sy, tocolor(147, 252, 109, 255), 1, fonts.font3, "left")
			
		end
	end
end, 0, 0)