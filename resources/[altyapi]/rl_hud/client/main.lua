screenSize = Vector2(guiGetScreenSize())

fonts = exports.rl_ui:useFonts()
theme = exports.rl_ui:useTheme()

categories = {
	{"Hud Görünüşü"},
	{"Speedo Görünüşü"},
	{"Radar Görünüşü"}
}

huds = {
	{"GTA Hud"},
	{"Circular Hud"},
	{"Neo Hud"},
	{"Pink Hud"},
	{"Modern Hud"},
	{"Gizle"}
}

speedos = {
	{"SA:MP Speedo"},
	{"Klasik Speedo"},
	{"Modern Speedo"},
	{"White Speedo"},
	{"Gizle"}
}

radars = {
	{"Modern Radar"},
	{"Gizle"}
}

moneySuff = {"K", "M", "B", "T", "Q"}

bulletWeapons = {
	[22] = true,
	[23] = true,
	[24] = true,
	[25] = true,
	[26] = true,
	[27] = true,
	[28] = true,
	[29] = true,
	[32] = true,
	[30] = true,
	[31] = true,
	[33] = true,
	[34] = true,
	[35] = true,
	[36] = true,
	[37] = true,
	[38] = true,
	[16] = true,
	[17] = true,
	[18] = true,
	[39] = true,
	[41] = true,
	[42] = true,
	[43] = true,
}

function getElementSpeed(element,unit)
    if (unit == nil) then unit = 0 end
    if (isElement(element)) then
        local x,y,z = getElementVelocity(element)
        if (unit=="mph" or unit==1 or unit =='1') then
            return math.floor((x^2 + y^2 + z^2) ^ 0.49 * 100)
        else
            return math.floor((x^2 + y^2 + z^2) ^ 0.49 * 100 * 1.609344)
        end
    else
        return false
    end
end

function math.round(number, decimals, method)
    decimals = decimals or 0
    local factor = 10 ^ decimals
    if (method == "ceil" or method == "floor") then return math[method](number * factor) / factor
    else return tonumber(("%." .. decimals .. "f"):format(number)) end
end

function getFormatSpeed(unit)
    if unit < 10 then
        unit = "#aaaaaa00#ffffff" .. unit
    elseif unit < 100 then
        unit = "#aaaaaa0#ffffff" .. unit
    elseif unit >= 1000 then
        unit = "999"
    end
    return unit
end

function convertMoney(cMoney)
	didConvert = 0
	if not cMoney then
		return "?"
	end
	while cMoney / 1000 >= 1 do
		cMoney = cMoney / 1000
		didConvert = didConvert + 1
	end
	if didConvert > 0 then
		return "$" .. string.format("%.2f", cMoney) .. moneySuff[didConvert]
	else
		return "$" .. cMoney
	end
end

setTimer(function()
	if isElementInWater(localPlayer) then
        local oxygen = screenSize.x * getPedOxygenLevel(localPlayer) / 1000
        
        local rounded = {};
        function roundedDraw(id,x, y, w, h, radius, color, post)
            if not rounded[id] then
                rounded[id] = {}
            end
            if not rounded[id][w] then
                rounded[id][w] = {}
            end
            if not rounded[id][w][h] then
                local path = string.format([[<svg width="%s" height="%s" viewBox="0 0 %s %s" fill="none" xmlns="http://www.w3.org/2000/svg"><rect opacity="1" width="%s" height="%s" rx="%s" fill="#FFFFFF"/></svg>]], w, h, w, h, w, h, radius)
                rounded[id][w][h] = svgCreate(w, h, path)
            end
            if rounded[id][w][h] then
                dxDrawImage(x, y, w, h, rounded[id][w][h], 0, 0, 0, color, (post or false))
            end
        end
        
        roundedDraw("oxygen_bg", 0, 0, screenSize.x, 2, 0, tocolor(155, 155, 155, 155))
        roundedDraw("oxygen_bar", 0, 0, oxygen, 2, 0, tocolor(245, 245, 245))
    end
end, 0, 0)

function sendTopRightNotification(contentArray, thePlayer, widthNew, posXOffset, posYOffset, cooldown)
	triggerEvent("hud.drawOverlayTopRight", thePlayer, contentArray, widthNew, posXOffset, posYOffset, cooldown)
end