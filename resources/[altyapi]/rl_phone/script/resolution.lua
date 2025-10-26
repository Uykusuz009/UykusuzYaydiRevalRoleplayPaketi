local screen = {guiGetScreenSize ()}
local resolution = {1920, 1080}
local x, y = screen[1] / resolution[1], screen[2] / resolution[2]

function aToR (X, Y, sX, sY)
    local Py = (Global and (Global.PosY or resolution[2]) or resolution[2])
    local Falta = resolution[2] - Y
	local Y = Py - Falta - 800
    local xd = X/resolution[1] or X
    local yd = Y/resolution[2] or Y
    local xsd = sX/resolution[1] or sX
    local ysd = sY/resolution[2] or sY
    return xd*screen[1], yd*screen[2], xsd*screen[1], ysd*screen[2]
end

function isCursorOnElement (x, y, w, h)
    if (not isCursorShowing()) then
        return false
    end
    local mx, my = getCursorPosition()
    local fullx, fully = guiGetScreenSize()
    local cursorx, cursory = mx*fullx, my*fully
    if cursorx > x and cursorx < x + w and cursory > y and cursory < y + h then
        return true
    else
        return false
    end
end

_dxCreateFont = dxCreateFont
function dxCreateFont (path, size)
    local _, _, size, _ = aToR (0, 0, size, 0)
    return _dxCreateFont (path, size)
end

_isCursorOnElement = isCursorOnElement
function isCursorOnElement (x, y, w, h)
    local x, y, w, h = aToR (x, y, w, h)
    return _isCursorOnElement (x, y, w, h)
end

_dxDrawRectangle = dxDrawRectangle
function dxDrawRectangle(x, y, w, h, ...)
    local x, y, w, h = aToR(x, y, w, h)
    return _dxDrawRectangle(x, y, w, h, ...)
end

_dxDrawText = dxDrawText
function dxDrawText (text, x, y, w, h, color, scale, font, alignX, alignY, clip, wbreak, post, colorcode, sPP, fR, fRCX, fRCY)
    local x, y, w, h = aToR (x, y, w, h)
    return _dxDrawText (text, x, y, (w + x), (h + y) , color, scale, font, alignX, alignY, clip, wbreak, post, colorcode, sPP, fR, fRCX, fRCY)
end

_dxDrawImageSection = dxDrawImageSection
function dxDrawImageSection(x, y, w, h, ...)
    local x, y, w, h = aToR(x, y, w, h)
    return _dxDrawImageSection(x, y, w, h, ...)
end

_dxDrawImage = dxDrawImage
function dxDrawImage(x, y, w, h, ...)
    local x, y, w, h = aToR(x, y, w, h)
    return _dxDrawImage(x, y, w, h, ...)
end