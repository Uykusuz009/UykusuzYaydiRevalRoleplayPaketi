local screenX, screenY = screenSize.x - 20, screenSize.y - 110

local font = exports.kaisen_fonts:getFont("Bankgothic", 17)

setTimer(function()
	if getElementData(localPlayer, "logged") then
		if getElementData(localPlayer, "hud_settings").speedo == 1 then
			if getPedOccupiedVehicle(localPlayer) then
				local theVehicle = getPedOccupiedVehicle(localPlayer)
				local speed = math.floor(getElementSpeed(theVehicle, "kmh"))
				local fuel = getElementData(theVehicle, "fuel") or 100
				local odometer = getElementData(theVehicle, "odometer") or 0
				exports.rl_ui:dxDrawBorderedText(2, speed .. " KM/H\n" .. math.floor(fuel) .. " LT\n" .. math.floor(tonumber(odometer) / 1000) .. " KM", screenX, screenY, screenX, 0, tocolor(225, 225, 230, 255), 1, font, "right")
			end
		end
	end
end, 0, 0)