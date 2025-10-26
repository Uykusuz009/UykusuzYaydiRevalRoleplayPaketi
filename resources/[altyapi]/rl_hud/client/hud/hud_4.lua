local sizeX, sizeY = 260, 90
local screenX, screenY = (screenSize.x - sizeX) - 15, 20

local fonts = {
    font1 = exports.kaisen_fonts:getFont("sf-regular", 11),
    font2 = exports.kaisen_fonts:getFont("UbuntuBold", 12),
    font3 = exports.kaisen_fonts:getFont("UbuntuBold", 20),
	awesome2 = exports.kaisen_fonts:getFont("FontAwesome", 11),
}

local clickTick = 0

local selected = 1

setTimer(function()
	if getElementData(localPlayer, "hudkapa") == true then return end
    if getElementData(localPlayer, "logged") then
		if getElementData(localPlayer, "hud_settings").hud == 4 then
			
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
			
			exports.rl_ui:dxDrawGradient(screenX + 10, screenY + 73, 50, 3, 31, 31, 31, 255, false, false)
			dxDrawText("BANKA", screenX + 70, screenY + 63, nil, nil, exports.rl_ui:inArea(screenX + 70, screenY + 63, dxGetTextWidth("BANKA", 1, fonts.font2), 15) and exports.rl_ui:getServerColor(1) or selected == 2 and exports.rl_ui:getServerColor(1) or tocolor(168, 168, 179, 255), 1, fonts.font2)
			
			dxDrawText("/", screenX + 140, screenY + 62, nil, nil, tocolor(46, 46, 46, 255), 1, fonts.font2)
			
			exports.rl_ui:dxDrawGradient(screenX + 215, screenY + 73, 50, 3, 31, 31, 31, 255, false, true)
			dxDrawText("NAKİT", screenX + 150, screenY + 63, nil, nil, exports.rl_ui:inArea(screenX + 150, screenY + 63, dxGetTextWidth("NAKİT", 1, fonts.font2), 15) and exports.rl_ui:getServerColor(1) or selected == 1 and exports.rl_ui:getServerColor(1) or tocolor(168, 168, 179, 255), 1, fonts.font2)
			
			if exports.rl_ui:inArea(screenX + 150, screenY + 63, dxGetTextWidth("NAKİT", 1, fonts.font2), 15) and getKeyState("mouse1") and clickTick + 500 <= getTickCount() then
				clickTick = getTickCount()
				selected = 1
			end
			
			if exports.rl_ui:inArea(screenX + 70, screenY + 63, dxGetTextWidth("BANKA", 1, fonts.font2), 15) and getKeyState("mouse1") and clickTick + 500 <= getTickCount() then
				clickTick = getTickCount()
				selected = 2
			end
			
			if selected == 1 then
				dxDrawText("$" .. exports.rl_global:formatMoney(exports.rl_global:getMoney(localPlayer)), screenX + 250, screenY + 90, nil, nil, exports.rl_ui:getServerColor(1), 1, fonts.font3, "right")
			elseif selected == 2 then
				dxDrawText("$" .. exports.rl_global:formatMoney(getElementData(localPlayer, "bank_money")), screenX + 250, screenY + 90, nil, nil, exports.rl_ui:getServerColor(1), 1, fonts.font3, "right")
			end
			
		end
	end
end, 0, 0)