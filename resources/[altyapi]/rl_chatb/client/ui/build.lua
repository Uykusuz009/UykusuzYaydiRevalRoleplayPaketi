sx, sy = guiGetScreenSize()
psx, psy = sx / 1920, sy / 1080

function loadLocalSettings ()
    fontHeight = {}
    fontHeight[chatSettings.inputFont] = dxGetFontHeight(chatSettings.inputSize, chatSettings.inputFont)
end

function removeHex (s)
    return s:gsub("#%x%x%x%x%x%x", "") or false
end

function dxDrawOutlineText(text, leftx, topy, rightx, bottomy, color, ...)
    dxDrawText(removeHex(text), leftx + 1, topy - 1, rightx + 1, bottomy - 1, tocolor(0, 0, 0, 200), ...)
    dxDrawText(removeHex(text), leftx + 1, topy + 1, rightx + 1, bottomy + 1, tocolor(0, 0, 0, 200), ...)
    dxDrawText(removeHex(text), leftx - 1, topy + 1, rightx - 1, bottomy + 1, tocolor(0, 0, 0, 200), ...)
    dxDrawText(removeHex(text), leftx - 1, topy - 1, rightx - 1, bottomy - 1, tocolor(0, 0, 0, 200), ...)
    dxDrawText(text, leftx, topy, rightx, bottomy, color, ...)
end

function _getCursorPosition()
    if not isCursorShowing() then
        return
    end
    local x, y = getCursorPosition()
    return x * sx, y * sy
end

keyCallBacks = {}
function keyCallBackRender()
    local tick = getTickCount()
    for index, value in pairs(keyCallBacks) do
        if getKeyState(value.key) and getKeyState(value.extra) then
            if tick >= value.delay then
                local diff = tick - value.delay
                if diff > 50 then
                    value.delay = tick + 400
                else
                    value.delay = tick + 50
                end
                value.callback()
            end
        else
            value.delay = 0
        end
    end
end
addEventHandler('onClientRender', root, keyCallBackRender)

function addKeyCallback(key, callback, extra)
    return table.insert(keyCallBacks, {
        key = key,
        callback = callback,
        extra = extra or key,
        delay = getTickCount()
    })
end

function inArea(x, y, width, height)
    if (not isCursorShowing()) then
        return false
    end
    local x, y, width, height = x, y, width, height

    local cx, cy = getCursorPosition()
    local cx, cy = (cx * sx), (cy * sy)

    return ((cx >= x and cx <= x + width) and (cy >= y and cy <= y + height))
end

local rounded = {}
function drawRoundedRectangle(x, y, w, h, color, radius, post)
    local r, g, b, a = fromColor(color)
    local id = string.format('%d%d%d%d%s', w, h, radius, tocolor(r, g, b), tostring(post or false))
    if not rounded[id] then
        local path = string.format([[<svg width="%s" height="%s" viewBox="0 0 %s %s" fill="none" xmlns="http://www.w3.org/2000/svg"><rect opacity="1" width="%s" height="%s" rx="%s" fill="#FFFFFF"/></svg>]], w, h, w, h, w, h, radius)
        rounded[id] = svgCreate(w, h, path)
    end
    if rounded[id] then
        dxDrawImage(x, y, w, h, rounded[id], 0, 0, 0, tocolor(r, g, b, a), (post or false))
    end
    return rounded[id]
end

function fromColor(color)
    if color then
        local blue = bitExtract(color, 0, 8)
        local green = bitExtract(color, 8, 8)
        local red = bitExtract(color, 16, 8)
        local alpha = bitExtract(color, 24, 8)

        return red, green, blue, alpha
    end
end

local pressing = false
function checkClicker ()
    if clicked then
        clicked = false
    end
    if getKeyState("mouse1") then
        if not pressing then
            pressing = true
        end
    else
        if pressing then
            clicked = true
            pressing = false
        end
    end
end
addEventHandler('onClientRender', root, checkClicker)

labels = {}
caretPosition = 0
selectedLabel = false
selectStart, selectStop = false, false
local labelsettings = {
    caretWidth = 1,
    caretColor = 'lesswhite',
    selectColor = 'blue'
}
local labelinfos = {}
local clickedLabel = false
function drawLabel(id, name, x, y, width, height, color, font, center, mask)
    local _y = y
    local self = labelsettings

    if center then
        local textHeight = chatSettings.fontHeight
        y = y + (height / 2) - (textHeight / 2)
    end

    labelinfos[id] = { width, height, font }
    if not labels[id] then
        labels[id] = ''
    end

    selectedLabel = 'chatinput'
    local selected = true
    local text = (labels[id] ~= '' or selected) and labels[id] or name
    local text = (labels[id] ~= '' and mask) and ('*'):rep(utf8.len(text)) or text
    local tick = getTickCount()
    local isHover = inArea(x - 5, _y, width + 10, height)

    if isHover or selectStart then
        if getKeyState('mouse1') then
            if not clickedLabel then
                if selectStart then
                    selectStart = false
                    selectStop = false
                end
                clickedLabel = true
            end
            if isHover or selectStart then
                onLabelClick(x, id, text, font)
            end
        end
        if isHover then
            if clicked then
                if clickedLabel then

                    clickedLabel = false
                end
            end
        end
    end

    if selected then
        local selectX, selectW = getSelectInfos(x, text, font)
        if selectX and selectW then
            local textHeight = chatSettings.fontHeight
            local selectY = y
            dxDrawRectangle(selectX, selectY, selectW, textHeight, tocolor(42, 84, 156, 255))
        end

        local caretX = getCaretPosition(x, text, font)
        if caretX then
            local textHeight = chatSettings.fontHeight
            local y = y
            dxDrawRectangle(caretX, y, self.caretWidth, textHeight, tocolor(255, 255, 255))
        end
    end

    dxDrawText(text, x, y, nil, nil, color, chatSettings.inputSize, font, 'left', 'top')
    return labels[id]
end

function getCaretPosition(x, text, font)
    local text = utf8.sub(text, 0, caretPosition)
    local width = dxGetTextWidth(text, chatSettings.inputSize, font)

    return x + width
end

function getSelectInfos(x, text, font)
    if not selectStart or not selectStop or selectStart == selectStop then
        return
    end
    local selectedText, beforeSelect = getSelectedText(text)

    local x = dxGetTextWidth(beforeSelect, chatSettings.inputSize, font) + x
    local width = dxGetTextWidth(selectedText, chatSettings.inputSize, font)

    return x, width
end

function getSelectedText(text)
    if not selectStart or not selectStop or selectStart == selectStop then
        return
    end
    local selectedText, beforeSelect, afterSelect, startP, stopP

    if selectStop > selectStart then
        selectedText = utf8.sub(text, selectStart + 1, selectStop)
        beforeSelect = utf8.sub(text, 0, selectStart)
        afterSelect = utf8.sub(text, selectStop + 1)
        startP, stopP = selectStart + 1, selectStop
    else
        selectedText = utf8.sub(text, selectStop + 1, selectStart)
        beforeSelect = utf8.sub(text, 0, selectStop)
        afterSelect = utf8.sub(text, selectStart + 1)
        startP, stopP = selectStop + 1, selectStart
    end
    return selectedText, beforeSelect, afterSelect, startP, stopP
end

function onLabelClick(x, id, text, font)
    if id ~= selectedLabel then
        return
    end

    local index = getIndexFromMousePosition(x, text, font)

    if not selectStart then
        selectStart = index
    else
        selectStop = index
    end

    caretPosition = index
end

function getIndexFromMousePosition(x, text, font)
    local mx, my = _getCursorPosition()
    local x = (mx - x)

    local _x = 0
    for i = 0, utf8.len(text) do
        local character = utf8.sub(text, i, i)
        local w = dxGetTextWidth(character, chatSettings.inputSize, font)
        if x >= _x and x <= _x + w then
            return i
        end
        _x = _x + w
    end
    return x < 0 and 0 or utf8.len(text)
end

function addCharacter(character)
    if not selectedLabel then
        return
    end

    local width, height, font = unpack(labelinfos[selectedLabel])
    local text = labels[selectedLabel]

    if selectStart and selectStop and selectStart ~= selectStop then
        local selectedText, beforeSelect, afterSelect, startP, stopP = getSelectedText(text)
        if not selectedText then
            return
        end

        if dxGetTextWidth(beforeSelect .. character .. afterSelect, chatSettings.inputSize, font) > width then
            return
        end

        selectStart, selectStop = false, false
        caretPosition = #beforeSelect + 1

        labels[selectedLabel] = beforeSelect .. character .. afterSelect
        return
    end

    local beforeCaret, afterCaret = utf8.sub(text, 0, caretPosition), utf8.sub(text, caretPosition + 1)

    if dxGetTextWidth(beforeCaret .. character .. afterCaret, chatSettings.inputSize, font) > width then
        return
    end

    labels[selectedLabel] = beforeCaret .. character .. afterCaret
    caretPosition = caretPosition + 1
end
addEventHandler('onClientCharacter', root, addCharacter)

function onPaste(clipboardText)
    if not selectedLabel then
        return
    end

    local width, height, font = unpack(labelinfos[selectedLabel])
    local text = labels[selectedLabel]

    if selectStart and selectStop and selectStart ~= selectStop then
        local selectedText, beforeSelect, afterSelect, startP, stopP = getSelectedText(text)
        if not selectedText then
            return
        end

        if dxGetTextWidth(beforeSelect .. clipboardText .. afterSelect, chatSettings.inputSize, font) > width then
            return
        end

        selectStart, selectStop = false, false
        caretPosition = #beforeSelect + utf8.len(clipboardText)

        labels[selectedLabel] = beforeSelect .. clipboardText .. afterSelect
        return
    end

    local beforeCaret, afterCaret = utf8.sub(text, 0, caretPosition), utf8.sub(text, caretPosition + 1)

    if dxGetTextWidth(beforeCaret .. clipboardText .. afterCaret, chatSettings.inputSize, font) > width then
        return
    end

    labels[selectedLabel] = beforeCaret .. clipboardText .. afterCaret
    caretPosition = caretPosition + utf8.len(clipboardText)
end
addEventHandler('onClientPaste', root, onPaste)

function removeFromLabel()
    if not selectedLabel then
        return
    end
    local text = labels[selectedLabel]

    if selectStart and selectStop and selectStart ~= selectStop then
        local selectedText, beforeSelect, afterSelect, startP, stopP = getSelectedText(text)
        if not selectedText then
            return
        end

        selectStart, selectStop = false, false
        caretPosition = #beforeSelect

        labels[selectedLabel] = beforeSelect .. afterSelect
        return
    end

    local beforeCaret, afterCaret = utf8.sub(text, 0, caretPosition), utf8.sub(text, caretPosition + 1)

    if beforeCaret ~= '' then
        labels[selectedLabel] = utf8.sub(beforeCaret, 1, -2) .. afterCaret
        caretPosition = caretPosition - 1
    end
end
addKeyCallback('backspace', removeFromLabel)

addKeyCallback('arrow_l', function()
    if not selectedLabel then
        return
    end

    caretPosition = math.max(caretPosition - 1, 0)
    selectStart, selectStop = false, false
end)

addKeyCallback('arrow_r', function()
    if not selectedLabel then
        return
    end

    caretPosition = math.min(caretPosition + 1, utf8.len(labels[selectedLabel]))
    selectStart, selectStop = false, false
end)

addKeyCallback('home', function()
    if not labels[selectedLabel] then
        return
    end

    caretPosition = 0
    selectStart, selectStop = false, false
end)

addKeyCallback('end', function()
    if not labels[selectedLabel] then
        return
    end

    caretPosition = utf8.len(labels[selectedLabel])
    selectStart, selectStop = false, false
end)

addKeyCallback('lctrl', function()
    if not labels[selectedLabel] then
        return
    end

    selectStart, selectStop = 0, utf8.len(labels[selectedLabel])
end, 'a')

addKeyCallback('lctrl', function()
    if not labels[selectedLabel] then
        return
    end

    if not selectStart or not selectStop then
        return
    end

    local text = labels[selectedLabel]
    local selectedText = getSelectedText(text)
    setClipboard(selectedText)
end, 'c')

function resetLabels (resourceName)
    for key, value in pairs(labels) do
        if key:find(resourceName) then
            labels[key] = nil
        end
    end
    if selectedLabel and selectedLabel:find(resourceName) then
        selectedLabel = nil
    end
end

local scrollOffset = 0
local maxVisible = 5
local filteredCommands = {}
local lastText = ""
local commands = {}
local selectedItemIndex = nil

function updateCommandsList()
    commands = {}
    for _, commandData in ipairs(getCommandHandlers()) do
        table.insert(commands, '/' .. commandData[1])
    end
end

function updateFilteredCommands(text)
    filteredCommands = {}
    if text:sub(1, 1) == "/" and #text > 1 then
        local filterText = text:sub(2):lower()
        
        for _, commandName in ipairs(commands) do
            if commandName:sub(2, #filterText + 1):lower() == filterText then
                table.insert(filteredCommands, commandName)
            end
        end
    end
end

local tick = 0

function commandlist(x, y, w, h)
    local text = labels[selectedLabel] or ""

    if #commands == 0 then
        updateCommandsList()
    end

    if text ~= lastText then
        updateFilteredCommands(text)
        lastText = text
    end

    local totalCommands = #filteredCommands
    local startIdx = scrollOffset + 1
    local endIdx = math.min(startIdx + maxVisible - 1, totalCommands)

    local offsetY = 0
    for i = startIdx, endIdx do
        local itemY = y + offsetY
        local isSelected = (i == selectedItemIndex)
        
        if mouse(x, itemY, w, 25, 'hand') then
            if getKeyState('mouse1') and tick+600 <= getTickCount() then
                tick = getTickCount()
                labels[selectedLabel] = filteredCommands[i]
            end
            drawRoundedRectangle(x, itemY, w, 25, tocolor(20, 20, 20, 200), 3 * psy)
            dxDrawText(filteredCommands[i], x + 5, itemY + 5, x + w - 5, itemY + 20, tocolor(200, 200, 200), 1, chatSettings.inputFont, "left", "top")
        else
            drawRoundedRectangle(x, itemY, w, 25, tocolor(5, 5, 5, 200), 3 * psy)
            dxDrawText(filteredCommands[i], x + 5, itemY + 5, x + w - 5, itemY + 20, tocolor(200, 200, 200), 1, chatSettings.inputFont, "left", "top")
        end
        offsetY = offsetY + 28
    end
end


function mouse(x, y, w, h, type)
    if isCursorShowing() then
        local cx, cy = getCursorPosition()
        local sx,sy = guiGetScreenSize()
        cx, cy = cx*sx, cy*sy
        if (cx >= x and cx <= x+w and cy >= y and cy <= y+h) then
            if type then
                exports.rl_cursor:setPointer(type)
            end
            return true
        end
    end
    return false
end

function addScrollEventHandler()
    addEventHandler("onClientKey", root, function(button, press)
        if not press then return end

        local text = labels[selectedLabel] or ""
        
        if text ~= lastText then
            updateFilteredCommands(text)
            lastText = text
        end

        if button == "mouse_wheel_up" then
            if scrollOffset > 0 then
                scrollOffset = scrollOffset - 1
            end
        end

        if button == "mouse_wheel_down" then
            if scrollOffset + maxVisible < #filteredCommands then
                scrollOffset = scrollOffset + 1
            end
        end
    end)
end

addScrollEventHandler()

function drawMaterialSection(x, y, w, h, texture, borderX, borderY, borderW, borderH)
    local texturewidth, textureheight = dxGetMaterialSize(texture)
    local texturex, texturey = 0, 0
    local oranx, orany = texturewidth / w, textureheight / h
    if x <= borderX then
        local diffx = math.min(borderX - x, w)
        x, texturex, texturewidth, w = borderX, diffx * oranx, texturewidth - (diffx * oranx), w - diffx
    end
    if x + w >= borderX + borderW then
        local diffx = math.min((x + w) - (borderX + borderW), w)
        texturewidth, w = texturewidth - (diffx * oranx), w - diffx
    end
    if y <= borderY then
        local diffy = math.min(borderY - y, h)
        y, texturey, textureheight, h = borderY, diffy * orany, textureheight - (diffy * orany), h - diffy
    end
    if y + h >= borderY + borderH then
        local diffy = math.min((y + h) - (borderY + borderH), h)
        textureheight, h = textureheight - (diffy * orany), h - diffy
    end

    dxDrawImageSection(x, y, w, h, texturex, texturey, texturewidth, textureheight, texture, 0, 0, 0, tocolor(255, 255, 255))
end

function drawSectionedText(text, x, y, w, h, borderx, bordery, borderw, borderh, color, size, font)
    local fontHeight = chatSettings.fontHeight

    if not (x + w > borderx and x < borderx + borderw) then
        return
    end

    if not (y + h > bordery and y < bordery + borderh) then
        return
    end

    local closestX, closestY = getClosestSide(x, y, borderx, bordery, borderw, borderh)
    local left, top, right, bottom, alignx, aligny
    if closestX == 'right' then
        left, right, alignx = x, borderx + borderw, 'left'
    else
        left, right, alignx = borderx, x + w, 'right'
    end
    if closestY == 'bottom' then
        top, bottom, aligny = y, bordery + borderh, 'top'
    else
        top, bottom, aligny = bordery, y, 'bottom'
    end
    if aligny == 'top' then
        top = top
    else
        bottom = bottom + fontHeight
    end
    drawTextWithColorCodes(text, left, top, right, bottom, color, size, font, alignx, aligny, true)
end

function getClosestSide(x, y, borderx, bordery, borderw, borderh)
    return ((x - borderx) <= (borderx + borderw) - x) and 'left' or 'right', ((y - bordery) <= (bordery + borderh) - y) and 'top' or 'bottom'
end

function drawTextWithColorCodes(text, left, top, right, bottom, color, size, font, alignx, aligny, clip)
    local hexStart = text:find('#%x%x%x%x%x%x')

    if not hexStart then
        return dxDrawOutlineText(text, left, top, right, bottom, color, size, font, alignx, aligny, clip)
    end

    local r, g, b = fromColor(color)
    local beforeHex = utf8.sub(text, 0, hexStart - 1)
    local addW = 0

    local hexMessages = {
        { RGBToHex(r, g, b), beforeHex }
    }

    if alignx == 'right' then
        for hex, message in utf8.gmatch(text, '(%s*#%x%x%x%x%x%x)([^#]*)') do
            local spaces = countSpace(hex)
            table.insert(hexMessages, { utf8.gsub(hex, ' ', ''), (' '):rep(spaces) .. message })
        end

        hexMessages = flipTable(hexMessages)
    else
        for hex, message in utf8.gmatch(text, '(#%x%x%x%x%x%x)([^#]*)') do
            table.insert(hexMessages, {hex, message })
        end
    end

    for _, value in ipairs(hexMessages) do
        local hex, message = unpack(value)
        local r, g, b = getColorFromString(hex)
        local width = dxGetTextWidth(message, size, font) + 1 or 0
        local left, right = left, right
        if alignx == 'left' then
            left = left + addW
        else
            right = right - addW
        end
        dxDrawOutlineText(message, left, top, right, bottom, tocolor(r, g, b, 255), size, font, alignx, aligny, clip)
        addW = addW + width
    end
end

function countSpace(message)
    local spaceCounter = 0
    for i = 1, utf8.len(message) do
        if utf8.sub(message, i, i) == ' ' then
            spaceCounter = spaceCounter + 1
        end
    end
    return spaceCounter
end

function RGBToHex(red, green, blue)
    return string.format("#%.2X%.2X%.2X", red, green, blue)
end

function flipTable(table)
    local result = {}
    for i = 1, #table do
        local _i = (#table) - i + 1
        result[i] = table[_i]
    end
    return result
end