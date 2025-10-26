local sx, sy = guiGetScreenSize()
local zoom = (sx < 2048) and math.min(2, 2048 / sx) or 1

local zoom = 1

local config = {
    tick = getTickCount(),
    image = {"bg", "fuel-bg", "fuel-icon", "icon-brake", "icon-engine", "icon-lights", "mileage", "nitro-bg", "overlay", "pointer", "fuel","nitro","nitro-icon", "fuel_low", "icon-off", "icon-lights-on", "icon-engine-on", "icon-brake-on", "mask"},
    fonts = {
        [1] = exports.kaisen_fonts:getFont("sf-bold", 10 / zoom),
        [2] = exports.kaisen_fonts:getFont("sf-medium", 7 / zoom),
        [3] = exports.kaisen_fonts:getFont("sf-bold", 8 / zoom)
    }
}

for _, value in ipairs(config.image) do
    config.image[value] = dxCreateTexture("public/images/_white-speedo/" .. value .. ".png", "argb", false, "clamp")
end

function drawShadowText(text, x, y, w, h, color, size, font, ...)
    local text = tostring(text)
    dxDrawText(text:gsub("#%x%x%x%x%x%x", ""), x - 1, y, w, h, tocolor(0, 0, 0, 255), size, font, ...)
    dxDrawText(text:gsub("#%x%x%x%x%x%x", ""), x, y - 1, w, h, tocolor(0, 0, 0, 255), size, font, ...)
    dxDrawText(text:gsub("#%x%x%x%x%x%x", ""), x - 1, y - 1, w, h, tocolor(0, 0, 0, 255), size, font, ...)
    dxDrawText(text, x, y, w, h, color, size, font, ...)
end

function drawMileage()
    for i = 1, 6 do 
        local offset = ((i - 1) * 15 / zoom)
        dxDrawImage(sx - 255 / zoom + offset / zoom, sy - 59 / zoom, 13 / zoom, 17 / zoom, config.image["mileage"], 0, 0, 0, tocolor(255, 255, 255, 255))
        
        local mileage = string.format("%06d", math.floor(getElementData(getPedOccupiedVehicle(localPlayer), "odometer") or 000000))
        dxDrawText(utf8.sub(mileage, i, i), sx - 249 / zoom + offset, sy - 50 / zoom, nil, nil, tocolor(255, 255, 255, 200), 1 / zoom, config.fonts[3], "center", "center")
    end
end

setTimer(function()
	if getElementData(localPlayer, "logged") then
		if getElementData(localPlayer, "hud_settings").speedo == 4 then
			local theVehicle = getPedOccupiedVehicle(localPlayer)
			if theVehicle then
				local speex, speey, speez = getElementVelocity(theVehicle)
				local speedVehicle = (speex ^ 2 + speey ^ 2 + speez ^ 2) ^ (0.7)
				local vmax = speedVehicle * 165
				local vmax1 = speedVehicle * 140
				local vmax = string.format("%03d", math.floor(math.min(vmax, 236)))
				local vmax1 = string.format("%03d", math.floor(math.min(vmax1, 999)))
				local fuel = tonumber(getElementData(theVehicle, "fuel") or 100)
				local bak = exports["rl_vehicle-fuel"]:getMaxFuel(theVehicle)

				dxDrawImage(sx - 368 / zoom, sy - 244 / zoom, 302 / zoom, 218 / zoom, config.image["mask"], 0, 0, 0, tocolor(255, 255, 255, 255), false)
				dxDrawImage(sx - 368 / zoom, sy - 244 / zoom, 302 / zoom, 218 / zoom, config.image["mask"], 0, 0, 0, tocolor(255, 255, 255, 255), false)
				dxDrawImage(sx - 368 / zoom, sy - 244 / zoom, 303 / zoom, 218 / zoom, config.image["bg"], 0, 0, 0, tocolor(255, 255, 255, 255), false)

				dxDrawImage(sx - 368 / zoom, sy - 244 / zoom, 303 / zoom, 218 / zoom, config.image["bg"], 0, 0, 0, tocolor(255, 255, 255, 255), false)

				dxDrawImage(sx - 364 / zoom, sy - 238 / zoom, 294 / zoom, 205 / zoom, config.image["overlay"], 0, 0, 0, tocolor(255, 255, 255, 255), false)

				dxDrawImage(sx - 83 / zoom, sy - 178 / zoom, 37 / zoom, 150 / zoom, config.image["fuel-bg"], 0, 0, 0, tocolor(255, 255, 255, 255), false)
				dxDrawImageSection(sx - 84 / zoom, sy - 178 / zoom + (150 / zoom - 150 / zoom*(fuel/bak)), 37 / zoom, 150 / zoom*(fuel/bak), 0, (150*(1 - fuel/bak)), 37, 150*(fuel/bak), config.image["fuel"], 0, 0, 0, tocolor(255, 255, 255, 150), false)

				dxDrawImage(sx - 380 / zoom, sy - 270 / zoom, 330 / zoom, 330 / zoom, config.image["pointer"], vmax, 0, 0, tocolor(255, 255, 255, 255), false)

				drawShadowText(vmax1, sx - 214 / zoom, sy - 107 / zoom, nil, nil, tocolor(255, 255, 255, 255), 1, config.fonts[1], "center", "center")
				drawShadowText("km/h", sx - 214 / zoom, sy - 97 / zoom, nil, nil, tocolor(245, 245, 245, 225), 1, config.fonts[2], "center", "center")

				dxDrawImage(sx - 53 / zoom, sy - 41 / zoom, 14 / zoom, 14 / zoom, config.image["fuel-icon"], 0, 0, 0, tocolor(255, 255, 255, 255), false)

				drawMileage()

				if not getVehicleEngineState(theVehicle) then
					dxDrawImage(sx - 418 / zoom, sy - 47 / zoom, 16 / zoom, 16 / zoom, config.image["icon-engine"], 0, 0, 0, tocolor(255, 255, 255, 155), false)
					dxDrawImage(sx - 422 / zoom, sy - 51 / zoom, 25 / zoom, 25 / zoom, config.image["icon-off"], 0, 0, 0, tocolor(255, 255, 255, 255), false)
				else
					dxDrawImage(sx - 418 / zoom, sy - 47 / zoom, 16 / zoom, 16 / zoom, config.image["icon-engine"], 0, 0, 0, tocolor(255, 255, 255, 255), false)
					dxDrawImage(sx - 422 / zoom, sy - 51 / zoom, 25 / zoom, 25 / zoom, config.image["icon-engine-on"], 0, 0, 0, tocolor(255, 255, 255, 255), false)
				end

				if not isElementFrozen(theVehicle) then
					dxDrawImage(sx - 423.1 / zoom, sy - 77 / zoom, 16 / zoom, 16 / zoom, config.image["icon-brake"], 0, 0, 0, tocolor(255, 255, 255, 155), false)
					dxDrawImage(sx - 428 / zoom, sy - 81 / zoom, 25 / zoom, 25 / zoom, config.image["icon-off"], 0, 0, 0, tocolor(255, 255, 255, 255), false)
				else 
					dxDrawImage(sx - 423.1 / zoom, sy - 77 / zoom, 16 / zoom, 16 / zoom, config.image["icon-brake"], 0, 0, 0, tocolor(255, 255, 255, 155), false)
					dxDrawImage(sx - 428 / zoom, sy - 81 / zoom, 25 / zoom, 25 / zoom, config.image["icon-brake-on"], 0, 0, 0, tocolor(255, 255, 255, 255), false)
				end

				if getVehicleOverrideLights(theVehicle) == 2 then
					dxDrawImage(sx - 423 / zoom, sy - 109 / zoom, 17 / zoom, 17 / zoom, config.image["icon-lights"], 0, 0, 0, tocolor(255, 255, 255, 255), false)
					dxDrawImage(sx - 427 / zoom, sy - 112 / zoom, 25 / zoom, 25 / zoom, config.image["icon-lights-on"], 0, 0, 0, tocolor(255, 255, 255, 255), false)
				else
					dxDrawImage(sx - 423 / zoom, sy - 109 / zoom, 17 / zoom, 17 / zoom, config.image["icon-lights"], 0, 0, 0, tocolor(255, 255, 255, 255), false)
					dxDrawImage(sx - 427 / zoom, sy - 112 / zoom, 25 / zoom, 25 / zoom, config.image["icon-off"], 0, 0, 0, tocolor(255, 255, 255, 255), false)
				end

				if fuel < 25 then
					big = interpolateBetween(0, 0, 0, 255, 0, 0, (getTickCount()/1000), "CosineCurve")
					dxDrawImage(sx - 65.4 / zoom, sy - 53.5 / zoom, 39 / zoom, 39 / zoom, config.image["fuel_low"], 0, 0, 0, tocolor(255, 0, 0, big), false)
				end
				
				local nitroProgress = getVehicleNitroLevel(theVehicle) or 1
				if nitroProgress then
					dxDrawImage(sx - 399 / zoom, sy - 48 / zoom, 26 / zoom, 26 / zoom, config.image["nitro-icon"], 0, 0, 0, tocolor(255, 255, 255, 255), false)
					dxDrawImage(sx - 388 / zoom, sy - 179 / zoom, 38 / zoom, 153 / zoom, config.image["nitro-bg"], 0, 0, 0, tocolor(255, 255, 255, 255), false)
					dxDrawImageSection(sx - 388 / zoom, sy - 179 / zoom + (153 / zoom - 153 / zoom * (nitroProgress)), 37 / zoom, 153 / zoom * (nitroProgress), 0, (153 * (1 - nitroProgress)), 37, 153 * (nitroProgress), config.image["nitro"], 0, 0, 0, tocolor(255, 255, 255, 150), false)
				end
			end
		end
	end
end, 0, 0)