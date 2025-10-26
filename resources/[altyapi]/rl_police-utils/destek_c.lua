local drawTimers = {} 
local colorTimers = {} 

local fonts = {
	icon = exports.rl_fonts:getFont("FontAwesome", 25),
	main = exports.rl_fonts:getFont("UbuntuRegular", 10),
}

local colors = {
	{48, 128, 255},
	{255, 0, 0},
}

local colorIndex = 1

function toggleColor()
	colorIndex = colorIndex % #colors + 1
end

function dxDrawTextOnElement(element, text, height, distance, R, G, B, alpha, size, font, tur, reason, id, ...)
    if getElementDimension(localPlayer) ~= 0 then return end
    if getElementInterior(localPlayer) ~= 0 then return end
    local x, y, z = getElementPosition(element)
    local x2, y2, z2 = getCameraMatrix()
    local distance = distance or 20
    local height = height or 1
    local sourcePos = Vector3(getElementPosition(element))
    local distance = getDistanceBetweenPoints3D(sourcePos.x, sourcePos.y, sourcePos.z, Vector3(getElementPosition(localPlayer)))
    local sx, sy = getScreenFromWorldPosition(x, y, z + 1.5)
    local reason = reason or ""
	if localPlayer == element then return end
    if (sx) and (sy) then
        if id == 1 then
			R, G, B = colors[colorIndex][1], colors[colorIndex][2], colors[colorIndex][3]
		elseif id == 2 then
			R, G, B = 175, 50, 50
		elseif id == 3 then
			R, G, B = 74, 104, 44
		end
		
		if tur == "destek" then
            dxDrawText("", sx, sy, sx, sy - 40, tocolor(R, G, B, 255), 1, fonts.icon, "center", "bottom", false, false, false, true, false)
        elseif tur == "takip" then
            dxDrawText("", sx, sy, sx, sy - 40, tocolor(R, G, B, 255), 1, fonts.icon, "center", "bottom", false, false, false, true, false)
        end

        local fullText = text:gsub("_", " ") .. " (" .. reason .. ")\n#8AE68A" .. math.floor(distance) .. " #FFFFFFmetre"
        if reason == "" then
            fullText = text:gsub("_", " ") .. "\n#8AE68A" .. math.floor(distance) .. " #FFFFFFmetre"
        end

        dxDrawText(fullText, sx, sy, sx, sy, tocolor(255, 255, 255, 255), 1, fonts.main, "center", "bottom", false, false, false, true, false)
    end
end

function destek(state, player, reason, id)
    if (state) then
        drawTimers[player] = setTimer(dxDrawTextOnElement, 0, 0, player, getPlayerName(player):gsub("_", " "), 1, 20, 255, 255, 255, 255, 1, font, "destek", reason, id)
        colorTimers[player] = setTimer(toggleColor, 500, 0)
    else
        if (isTimer(drawTimers[player])) then killTimer(drawTimers[player]) end
        if (isTimer(colorTimers[player])) then killTimer(colorTimers[player]) end
    end
end
addEvent("lspd:destek", true) 
addEventHandler("lspd:destek", root, destek)

function takip(state, player, reason, id)
    if (state) then
        drawTimers[player] = setTimer(dxDrawTextOnElement, 0, 0, player, getPlayerName(player):gsub("_", " "), 1, 20, 255, 255, 255, 255, 1, font, "takip", reason, id)
        colorTimers[player] = setTimer(toggleColor, 500, 0)
    else
        if (isTimer(drawTimers[player])) then killTimer(drawTimers[player]) end
        if (isTimer(colorTimers[player])) then killTimer(colorTimers[player]) end
    end
end
addEvent("lspd:takip", true) 
addEventHandler("lspd:takip", root, takip)

function panik(state, player, reason, id)
    if (state) then
        playSound("panik.mp3")
        drawTimers[player] = setTimer(dxDrawTextOnElement, 0, 0, player, getPlayerName(player):gsub("_", " "), 1, 20, 255, 255, 255, 255, 1, font, "destek", reason, id)
        colorTimers[player] = setTimer(toggleColor, 500, 0)
        if player == getLocalPlayer() then
            if (isTimer(drawTimers[player])) then killTimer(drawTimers[player]) end
            if (isTimer(colorTimers[player])) then killTimer(colorTimers[player]) end
        end
    else
        if (isTimer(drawTimers[player])) then killTimer(drawTimers[player]) end
        if (isTimer(colorTimers[player])) then killTimer(colorTimers[player]) end
    end
end
addEvent("lspd:panik", true) 
addEventHandler("lspd:panik", root, panik)
