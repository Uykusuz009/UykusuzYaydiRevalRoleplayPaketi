EditBox = {}
EditBox.__index = EditBox

function EditBox:create(x, y, fontSize, fontType, visibleCharCount, placeholderText, r, g, b, a, isPassword, preventSpecialChars, onlyNumbers)
    local instance = setmetatable({}, EditBox)
    instance.x = x
    instance.y = y
    instance.fontSize = fontSize or 1.2
    instance.fontType = fontType or "default-bold"
    instance.visibleCharCount = visibleCharCount or 20
    instance.placeholderText = placeholderText or ""
    instance.text = ""
    instance.cursorPosition = 0
    instance.selectedText = {start = nil, finish = nil}
    instance.isCtrlDown = false
    instance.showCursor = false
    instance.lastBlinkTime = 0
    instance.blinkInterval = 500
    instance.focused = false
    instance.isMouseDown = false
    instance.r = r or 200
    instance.g = g or 200
    instance.b = b or 200
    instance.a = a or 200
    instance.isPassword = isPassword or false
    instance.preventSpecialChars = preventSpecialChars or false
    instance.onlyNumbers = onlyNumbers or false

    instance:updateDimensions()

    return instance
end

function EditBox:updateDimensions()
    local sampleText = string.rep("W", self.visibleCharCount)
    self.width = dxGetTextWidth(sampleText, self.fontSize, self.fontType) + 20
    self.height = dxGetFontHeight(self.fontSize, self.fontType) + 20
end

function EditBox:draw()
    -- dxDrawRectangle(self.x, self.y, self.width, self.height, tocolor(0, 0, 0, 150))

    if self.selectedText.start and self.selectedText.finish then
        local selectedWidth = dxGetTextWidth(self.text:sub(self.selectedText.start + 1, self.selectedText.finish), self.fontSize, self.fontType)
        dxDrawRectangle(self.x + 7.5 + dxGetTextWidth(self.text:sub(1, self.selectedText.start), self.fontSize, self.fontType), self.y + 10, selectedWidth + 5, self.height - 20, tocolor(100, 100, 255, 100),true)
    end

    local displayText = self.text
    if self.isPassword then
        displayText = string.rep("*", #self.text)
    end

    if not self.focused and self.text == "" then
        displayText = self.placeholderText
    end

    dxDrawText(displayText, self.x + 10, self.y + 10, self.x + self.width - 10, self.y + self.height - 10, tocolor(self.r, self.g, self.b, self.a), self.fontSize, self.fontType,"left","top",true,true,true,true)

    if self.focused then
        if getTickCount() - self.lastBlinkTime > self.blinkInterval then
            self.showCursor = not self.showCursor
            self.lastBlinkTime = getTickCount()
        end

        if self.showCursor then
            local cursorX = self.x + 10 + dxGetTextWidth(displayText:sub(1, self.cursorPosition), self.fontSize, self.fontType)
            dxDrawText("|", cursorX, self.y + 10, cursorX + 10, self.y + self.height - 10, tocolor(200, 200, 200, self.a), self.fontSize, self.fontType,"left","top",true,true,true,true)
        end
    end
end

function EditBox:handleKeyPress(button, press)
    if self.focused then
        if press then
            local sound = playSound("key.mp3", false)
            setSoundVolume(sound, 0.5)
            if button == "lctrl" or button == "rctrl" then
                self.isCtrlDown = true
            elseif button == "v" and self.isCtrlDown then
                -- Paste functionality not changed
            elseif button == "c" and self.isCtrlDown and self.selectedText.start and self.selectedText.finish then
                setClipboard(self.text)
            elseif button == "a" and self.isCtrlDown then
                self.selectedText.start = 0
                self.selectedText.finish = #self.text
            elseif button == "arrow_l" then
                self.cursorPosition = math.max(0, self.cursorPosition - 1)
                self.selectedText.start, self.selectedText.finish = nil, nil
            elseif button == "arrow_r" then
                self.cursorPosition = math.min(#self.text, self.cursorPosition + 1)
                self.selectedText.start, self.selectedText.finish = nil, nil
            elseif button == "backspace" then
                if self.selectedText.start and self.selectedText.finish then
                    self.text = self.text:sub(1, self.selectedText.start) .. self.text:sub(self.selectedText.finish + 1)
                    self.cursorPosition = self.selectedText.start
                    self.selectedText.start, self.selectedText.finish = nil, nil
                elseif self.cursorPosition > 0 then
                    self.text = self.text:sub(1, self.cursorPosition - 1) .. self.text:sub(self.cursorPosition + 1)
                    self.cursorPosition = self.cursorPosition - 1
                end
            elseif button == "delete" then
                if self.selectedText.start and self.selectedText.finish then
                    self.text = self.text:sub(1, self.selectedText.start) .. self.text:sub(self.selectedText.finish + 1)
                    self.cursorPosition = self.selectedText.start
                    self.selectedText.start, self.selectedText.finish = nil, nil
                elseif self.cursorPosition < #self.text then
                    self.text = self.text:sub(1, self.cursorPosition) .. self.text:sub(self.cursorPosition + 2)
                end
            end
        else
            if button == "lctrl" or button == "rctrl" then
                self.isCtrlDown = false
            end
        end
    end
end

function EditBox:handleCharacterInput(character)
    if self.onlyNumbers and not character:match("%d") then
        return
    end

    if self.preventSpecialChars then
        local forbiddenCharacters = {",", "(", ")", "%", "$", "^", "&", "*", "+", "[", "]", "{", "}", "|", "\\", ";", ":", "'", "\"", "<", ">", "/", "?", "#"}
        for _, forbidden in ipairs(forbiddenCharacters) do
            if character == forbidden then
                return
            end
        end
    end

    if self.focused then
        if self.selectedText.start and self.selectedText.finish then
            self.text = self.text:sub(1, self.selectedText.start) .. character .. self.text:sub(self.selectedText.finish + 1)
            self.cursorPosition = self.selectedText.start + 1
            self.selectedText.start, self.selectedText.finish = nil, nil
        else
            if #self.text < self.visibleCharCount then
                self.text = self.text:sub(1, self.cursorPosition) .. character .. self.text:sub(self.cursorPosition + 1)
                self.cursorPosition = self.cursorPosition + 1
            end
        end
    end
end

function EditBox:handlePaste(pastedText)
    if self.onlyNumbers then
        pastedText = pastedText:gsub("%D", "") -- Remove non-digit characters
    end

    if self.focused and pastedText then
        if self.selectedText.start and self.selectedText.finish then
            self.text = self.text:sub(1, self.selectedText.start) .. pastedText .. self.text:sub(self.selectedText.finish + 1)
            self.cursorPosition = self.selectedText.start + #pastedText
            self.selectedText.start, self.selectedText.finish = nil, nil
        else
            local newText = self.text:sub(1, self.cursorPosition) .. pastedText .. self.text:sub(self.cursorPosition + 1)
            if #newText <= self.visibleCharCount then
                self.text = newText
                self.cursorPosition = self.cursorPosition + #pastedText
            else
                self.text = newText:sub(-self.visibleCharCount)
                self.cursorPosition = #self.text
            end
        end
    end
end

function EditBox:isMouseHover(x, y)
    return x >= self.x and x <= self.x + self.width and y >= self.y and y <= self.y + self.height
end

function EditBox:setFocus(focused)
    self.focused = focused
    if focused then
        self.showCursor = true
    else
        self.showCursor = false
    end
end

function EditBox:mouseClick(x, y, button)
    if self:isMouseHover(x, y) then
        self:setFocus(true)
        local relativeX = x - self.x - 10
        self.cursorPosition = self:findCursorPosition(relativeX)
        if self.isMouseDown then
            if self.selectedText.start then
                self.selectedText.finish = self:findCursorPosition(relativeX)
            end
        end
    else
        self:setFocus(false)
    end
end

function EditBox:findCursorPosition(x)
    local text = self.text
    local position = 0
    while position <= #text do
        local textWidth = dxGetTextWidth(text:sub(1, position), self.fontSize, self.fontType)
        if textWidth > x then
            return position - 1
        end
        position = position + 1
    end
    return #text
end

local editBoxes = {}

function createEditBox(x, y, fontSize, fontType, visibleCharCount, placeholderText, r, g, b, a, isPassword, preventSpecialChars, onlyNumbers)
    local editBox = EditBox:create(x, y, fontSize, fontType, visibleCharCount, placeholderText, r, g, b, a, isPassword, preventSpecialChars, onlyNumbers)
    table.insert(editBoxes, editBox)
    return editBox
end

function deleteEditBox(editBox)
    for i, box in ipairs(editBoxes) do
        if box == editBox then
            table.remove(editBoxes, i)
            return true
        end
    end
    return false
end

function EditBox:getText()
    return self.text
end

function getEditBoxText(editBox)
    if editBox and editBox.getText then
        return editBox:getText()
    else
        return nil
    end
end

function render()
    for _, editBox in ipairs(editBoxes) do
        editBox:draw()
    end
end
addEventHandler("onClientRender", root, render)

-- Mouse click olayını işleme
function onMouseClick(button, state, x, y)
    if button == "left" then
        for _, editBox in ipairs(editBoxes) do
            if state == "down" then
                editBox.isMouseDown = true
                editBox:mouseClick(x, y, button)
            elseif state == "up" then
                editBox.isMouseDown = false
                editBox:mouseClick(x, y, button)
            end
        end
    end
end
addEventHandler("onClientClick", root, onMouseClick)

-- Key press ve karakter input olayları
function onKeyPress(button, press)
    for _, editBox in ipairs(editBoxes) do
        editBox:handleKeyPress(button, press)
    end
end
addEventHandler("onClientKey", root, onKeyPress)

function onCharacterInput(character)
    for _, editBox in ipairs(editBoxes) do
        editBox:handleCharacterInput(character)
    end
end
addEventHandler("onClientCharacter", root, onCharacterInput)

function onPaste(pastedText)
    for _, editBox in ipairs(editBoxes) do
        editBox:handlePaste(pastedText)
    end
end
addEventHandler("onClientPaste", root, onPaste)
