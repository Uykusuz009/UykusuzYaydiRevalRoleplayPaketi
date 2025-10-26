screenSize = Vector2(guiGetScreenSize())

initialPosition = { x = 1, y = 1 }
initialSize = { x = 1, y = 1 }
initialRadius = 4
initialPadding = 10

CurrentTheme = Theme.DARK

lastClick = getTickCount()

function dxDrawShadowText(text, left, top, width, height, color, scale, font, alignX, alignY, clip, wordBreak, postGUI)
    dxDrawText(text, left - 1, top, width - 1, height, tocolor(0, 0, 0, 150), scale, font, alignX, alignY, clip, wordBreak, postGUI)
    dxDrawText(text, left + 1, top, width + 1, height, tocolor(0, 0, 0, 150), scale, font, alignX, alignY, clip, wordBreak, postGUI)
    dxDrawText(text, left, top - 1, width, height - 1, tocolor(0, 0, 0, 150), scale, font, alignX, alignY, clip, wordBreak, postGUI)
    dxDrawText(text, left, top + 1, width, height + 1, tocolor(0, 0, 0, 150), scale, font, alignX, alignY, clip, wordBreak, postGUI)
    dxDrawText(text, left - 2, top, width - 2, height, tocolor(0, 0, 0, 150), scale, font, alignX, alignY, clip, wordBreak, postGUI)
    dxDrawText(text, left + 2, top, width + 2, height, tocolor(0, 0, 0, 150), scale, font, alignX, alignY, clip, wordBreak, postGUI)
    dxDrawText(text, left, top - 2, width, height - 2, tocolor(0, 0, 0, 150), scale, font, alignX, alignY, clip, wordBreak, postGUI)
    dxDrawText(text, left, top + 2, width, height + 2, tocolor(0, 0, 0, 150), scale, font, alignX, alignY, clip, wordBreak, postGUI)
    dxDrawText(text, left, top, width, height, color, scale, font, alignX, alignY, clip, wordBreak, postGUI)
end

function dxDrawFramedText(text, left, top, width, height, color, scale, font, alignX, alignY, clip, wordBreak, postGUI)
	local alpha = bitExtract(color, 24, 8)
    dxDrawText(text, left + 1, top + 1, width + 1, height + 1, tocolor(0, 0, 0, alpha), scale, font, alignX, alignY, clip, wordBreak, postGUI)
    dxDrawText(text, left + 1, top - 1, width + 1, height - 1, tocolor(0, 0, 0, alpha), scale, font, alignX, alignY, clip, wordBreak, postGUI)
    dxDrawText(text, left - 1, top + 1, width - 1, height + 1, tocolor(0, 0, 0, alpha), scale, font, alignX, alignY, clip, wordBreak, postGUI)
    dxDrawText(text, left - 1, top - 1, width - 1, height - 1, tocolor(0, 0, 0, alpha), scale, font, alignX, alignY, clip, wordBreak, postGUI)
    dxDrawText(text, left, top, width, height, color, scale, font, alignX, alignY, clip, wordBreak, postGUI)
end

function dxDrawBorderedText(outline, text, left, top, right, bottom, color, scale, font, alignX, alignY, clip, wordBreak, postGUI, colorCoded, subPixelPositioning, fRotation, fRotationCenterX, fRotationCenterY)
    for oX = (outline * -1), outline do
        for oY = (outline * -1), outline do
            dxDrawText(text:gsub("#%x%x%x%x%x%x", ""), left + oX, top + oY, right + oX, bottom + oY, tocolor(0, 0, 0, 255), scale, font, alignX, alignY, clip, wordBreak, postGUI, colorCoded, subPixelPositioning, fRotation, fRotationCenterX, fRotationCenterY)
        end
    end
    dxDrawText(text, left, top, right, bottom, color, scale, font, alignX, alignY, clip, wordBreak, postGUI, colorCoded, subPixelPositioning, fRotation, fRotationCenterX, fRotationCenterY)
end

function dxDrawGradient(left, top, right, bottom, r, g, b, a, vertical, inverse, postGUI)
    postGUI = postGUI or false
    if vertical then
        for i = 0, bottom do
            local alpha = (i / bottom) * a
            if inverse then
                dxDrawRectangle(left, top + bottom - i, right, 1, tocolor(r, g, b, alpha), postGUI)
            else
                dxDrawRectangle(left, top + i, right, 1, tocolor(r, g, b, alpha), postGUI)
            end
        end
    else
        for i = 0, right do
            local alpha = (i / right) * a
            if inverse then
                dxDrawRectangle(left + right - i, top, 1, bottom, tocolor(r, g, b, alpha), postGUI)
            else
                dxDrawRectangle(left + i, top, 1, bottom, tocolor(r, g, b, alpha), postGUI)
            end
        end
    end
end

function reMap(value, low1, high1, low2, high2)
    return low2 + (value - low1) * (high2 - low2) / (high1 - low1)
end

responsiveMultipler = reMap(screenSize.x, 800, 1920, 0.6, 1)

function resp(value)
    return math.ceil(value * responsiveMultipler)
end

function respc(value)
    return tonumber(string.format("%.1f", tostring(value * responsiveMultipler)))
end

function abs(size)
    return {
        x = size.x * screenSize.x,
        y = size.y * screenSize.y
    }
end

function absX(size)
    return size * screenSize.x
end

function absY(size)
    return size * screenSize.y
end

function conv(sizeValue)
    return sizeValue / screenSize.x
end

function convY(sizeValue)
    return sizeValue / screenSize.y
end

addEvent("playSuccessfulSound", true)
addEventHandler("playSuccessfulSound", root, function()
	local sound = playSound(":cr_infobox/public/sounds/success.mp3", false)
	setSoundVolume(sound, 0.5)
end)