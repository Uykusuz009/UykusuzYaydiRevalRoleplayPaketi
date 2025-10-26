local browser = createBrowser(500, 500, true, true)
addEvent("returnClipBoardValue", false)
addEventHandler("returnClipBoardValue", browser, function(data)
  if activeInput and data then
    data = tostring(data)
    local value = guiElements[activeInput].value or ""
    local max = tonumber(guiElements[activeInput].maxLength) or 48
    if max < utf8.len(data) + utf8.len(value) then
      data = utf8.sub(data, 1, max - utf8.len(value))
    end
    if not guiElements[activeInput].cursorPosition then
      guiElements[activeInput].cursorPosition = 0
    end
    value = utf8.sub(value, 1, guiElements[activeInput].cursorPosition) .. data .. utf8.sub(value, guiElements[activeInput].cursorPosition + 1, utf8.len(value))
    guiElements[activeInput].cursorPosition = guiElements[activeInput].cursorPosition + utf8.len(data)
    setInputValue(activeInput, value)
    if guiElements[activeInput].changeEvent then
      triggerEvent(guiElements[activeInput].changeEvent, localPlayer, guiElements[activeInput].value, activeInput)
    end
  end
end)
addEventHandler("onClientBrowserCreated", browser, function()
  loadBrowserURL(browser, "http://mta/local/files/paste.html")
end)
activeInput = false
function renderFunctions.input(el)
  if not guiElements[el].disableBorder then
    if guiElements[el].hoverAlpha and guiElements[el].hoverAlpha > 0 or guiElements[el].active then
      local border = guiElements[el].active and 1 or guiElements[el].hoverAlpha / 255 * 1
      if guiElements[el].inputBorderSize then
        border = border * guiElements[el].inputBorderSize
      end
      dxDrawRectangle(guiElements[el].x - border, guiElements[el].y - border, guiElements[el].sx + border * 2, guiElements[el].sy + border * 2, guiElements[el].color4)
      dxDrawRectangle(guiElements[el].x - border, guiElements[el].y - border, guiElements[el].sx + border * 2, guiElements[el].sy + border * 2, bitReplace(guiElements[el].color1, border * 255, 24, 8))
    else
      dxDrawRectangle(guiElements[el].x, guiElements[el].y, guiElements[el].sx, guiElements[el].sy, guiElements[el].color4)
    end
  end
  dxDrawRectangle(guiElements[el].x + 1, guiElements[el].y + 1, guiElements[el].sx - 2, guiElements[el].sy - 2, guiElements[el].color2)
  local xPlus = guiElements[el].fontPadding
  if guiElements[el].icon then
    xPlus = xPlus + guiElements[el].sy - 2
    dxDrawRectangle(guiElements[el].x + 1, guiElements[el].y + 1, guiElements[el].sy - 2, guiElements[el].sy - 2, guiElements[el].color3)
    dxDrawImage(guiElements[el].x + 1, guiElements[el].y + 1, guiElements[el].sy - 2, guiElements[el].sy - 2, guiElements[el].icon .. faTicks[guiElements[el].icon], 0, 0, 0, guiElements[el].color1)
  end
  if guiElements[el].password and guiElements[el].value and 0 < utf8.len(guiElements[el].value) then
    local h = guiElements[el].sy - guiElements[el].fontPadding * 2
    if guiElements[el].passwordShown then
      dxDrawImage(guiElements[el].x + guiElements[el].sx - guiElements[el].fontPadding - h, guiElements[el].y + guiElements[el].fontPadding, h, h, guiElements[el].shownIcon .. faTicks[guiElements[el].shownIcon], 0, 0, 0, guiElements[el].fontColor)
    else
      dxDrawImage(guiElements[el].x + guiElements[el].sx - guiElements[el].fontPadding - h, guiElements[el].y + guiElements[el].fontPadding, h, h, guiElements[el].hiddenIcon .. faTicks[guiElements[el].hiddenIcon], 0, 0, 0, guiElements[el].fontColor)
    end
  end
  local xMinus = guiElements[el].fontPadding
  if guiElements[el].password and guiElements[el].value and 0 < utf8.len(guiElements[el].value) then
    local h = guiElements[el].sy - guiElements[el].fontPadding * 2
    xMinus = xMinus + h + guiElements[el].fontPadding
  end
  if guiElements[el].active then
    if guiElements[el].multiline then
      local h = guiElements[el].lineHeight or guiElements[el].sy
      local fh = guiElements[el].fontHeight or h
      local line = 0
      local width = 0
      local my = guiElements[el].y + guiElements[el].sy - guiElements[el].fontPadding
      local my2 = guiElements[el].y + guiElements[el].fontPadding
      local len = 0
      if guiElements[el].processedValue then
        for i = 1, #guiElements[el].processedValue do
          local d = 0
          if len <= guiElements[el].cursorPosition then
            line = i - 1
            d = guiElements[el].cursorPosition - len
            width = dxGetTextWidth(utf8.sub(guiElements[el].processedValue[i] .. " ", 1, d), fontScales[guiElements[el].font], guiElements[el].font)
          end
          len = len + utf8.len(guiElements[el].processedValue[i] .. " ")
        end
      end
      local offset = math.max(0, line + 1 - guiElements[el].maxLines)
      local y = guiElements[el].y + guiElements[el].fontPadding - offset * h
      local oy = y
      if guiElements[el].processedValue then
        for i = 1, #guiElements[el].processedValue do
          local y2 = y + h
          if my2 <= y + h and y2 <= my + h then
            if my2 <= y then
              dxDrawText(guiElements[el].processedValue[i], guiElements[el].x + xPlus, y + h / 2 - fh / 2, guiElements[el].x + guiElements[el].sx - xMinus, math.min(my, y2), guiElements[el].fontColor, fontScales[guiElements[el].font], guiElements[el].font, "left", "top", true)
            else
              dxDrawText(guiElements[el].processedValue[i], guiElements[el].x + xPlus, my2, guiElements[el].x + guiElements[el].sx - xMinus, math.min(my, y2) - h / 2 + fh / 2, guiElements[el].fontColor, fontScales[guiElements[el].font], guiElements[el].font, "left", "bottom", true)
            end
          end
          y = y2
        end
      end
      local progress = now % 1000 / 1000 * 2
      if 1 < progress then
        progress = 2 - progress
      end
      local alpha = interpolateBetween(255, 0, 0, 0, 0, 0, progress, "InOutQuad")
      local x = math.floor(guiElements[el].x + xPlus + width)
      local y = oy + h * line
      if x <= guiElements[el].x + guiElements[el].sx - guiElements[el].fontPadding then
        dxDrawLine(x, y, x, y + h, bitReplace(guiElements[el].fontColor, alpha, 24, 8), 1)
      end
      dxDrawText((guiElements[activeInput].len or 0) .. "/" .. (tonumber(guiElements[activeInput].maxLength) or 48), 0, 0, guiElements[el].x + guiElements[el].sx - 1, guiElements[el].y + guiElements[el].sy - 1, guiElements[el].fontColor, fontScales[guiElements[el].font] * 0.8, guiElements[el].font, "right", "bottom", true)
    else
      local width = 0
      local val = ""
      if guiElements[el].value and 0 < utf8.len(guiElements[el].value) then
        val = guiElements[el].value
        if guiElements[el].password and not guiElements[el].passwordShown then
          val = guiElements[el].mask
        end
      end
      width = dxGetTextWidth(utf8.sub(val, 1, guiElements[activeInput].cursorPosition), fontScales[guiElements[el].font], guiElements[el].font)
      if width + xPlus > guiElements[el].sx - xMinus then
        dxDrawText(utf8.sub(val, 1, guiElements[activeInput].cursorPosition), guiElements[el].x + xPlus, guiElements[el].y, guiElements[el].x + guiElements[el].sx - xMinus, guiElements[el].y + guiElements[el].sy, guiElements[el].fontColor, fontScales[guiElements[el].font], guiElements[el].font, "right", "center", true)
        xPlus = xPlus - (width + xPlus - (guiElements[el].sx - xMinus))
      else
        dxDrawText(val, guiElements[el].x + xPlus, guiElements[el].y, guiElements[el].x + guiElements[el].sx - xMinus, guiElements[el].y + guiElements[el].sy, guiElements[el].fontColor, fontScales[guiElements[el].font], guiElements[el].font, "left", "center", true)
      end
      local progress = now % 1000 / 1000 * 2
      if 1 < progress then
        progress = 2 - progress
      end
      local alpha = interpolateBetween(255, 0, 0, 0, 0, 0, progress, "InOutQuad")
      local x = math.floor(guiElements[el].x + xPlus + width)
      local y = guiElements[el].y
      dxDrawLine(x, y + guiElements[el].fontPadding, x, y + guiElements[el].sy - guiElements[el].fontPadding, bitReplace(guiElements[el].fontColor, alpha, 24, 8), 1)
    end
  elseif guiElements[el].value and 0 < utf8.len(guiElements[el].value) then
    if guiElements[el].multiline then
      local h = guiElements[el].lineHeight or guiElements[el].sy
      local fh = guiElements[el].fontHeight or h
      if guiElements[el].processedValue then
        local my = guiElements[el].y + guiElements[el].sy - guiElements[el].fontPadding
        local y = guiElements[el].y + guiElements[el].fontPadding
        for i = 1, #guiElements[el].processedValue do
          local y2 = y + h
          dxDrawText(guiElements[el].processedValue[i], guiElements[el].x + xPlus, y + h / 2 - fh / 2, guiElements[el].x + guiElements[el].sx - xMinus, math.min(my, y2), guiElements[el].fontColor, fontScales[guiElements[el].font], guiElements[el].font, "left", "top", true)
          if my <= y2 then
            break
          end
          y = y2
        end
      end
    else
      dxDrawText(not (not guiElements[el].password or guiElements[el].passwordShown) and guiElements[el].mask or guiElements[el].value, guiElements[el].x + xPlus, guiElements[el].y, guiElements[el].x + guiElements[el].sx - xMinus, guiElements[el].y + guiElements[el].sy, guiElements[el].fontColor, fontScales[guiElements[el].font], guiElements[el].font, "left", "center", true)
    end
  elseif guiElements[el].placeholder then
    local h = guiElements[el].sy
    if guiElements[el].multiline then
      if guiElements[el].paddingHeight then
        h = guiElements[el].paddingHeight
      elseif guiElements[el].lineHeight then
        h = guiElements[el].lineHeight
      end
    end
    dxDrawText(guiElements[el].placeholder, guiElements[el].x + xPlus, guiElements[el].y, 0, guiElements[el].y + h, guiElements[el].color1, fontScales[guiElements[el].font], guiElements[el].font, "left", "center")
  end
end
function setInputUppercaseOnly(el, val)
  if tonumber(el) and guiElements[el] then
    if guiElements[el].type == "input" then
      guiElements[el].uppercaseOnly = val
    else
      throwGuiError("setInputUppercaseOnly: guiElement is not input")
    end
  else
    throwGuiError("setInputUppercaseOnly: invalid guiElement")
  end
end
addEventHandler("onClientCharacter", getRootElement(), function(character)
  if activeInput then
    if character == "\127" then
      return
    end
    if not guiElements[activeInput].value then
      guiElements[activeInput].value = ""
      guiElements[activeInput].len = 0
    end
    if not guiElements[activeInput].cursorPosition then
      guiElements[activeInput].cursorPosition = utf8.len(guiElements[activeInput].value)
    end
    if guiElements[activeInput].len < (tonumber(guiElements[activeInput].maxLength) or 48) then
      if guiElements[activeInput].numberNegative then
        if character == "-" then
          if 0 < guiElements[activeInput].cursorPosition then
            return
          end
        elseif not tonumber(character) then
          return
        end
      end
      if guiElements[activeInput].numberOnly and not tonumber(character) then
        return
      end
      guiElements[activeInput].value = utf8.sub(guiElements[activeInput].value, 1, guiElements[activeInput].cursorPosition) .. character .. utf8.sub(guiElements[activeInput].value, guiElements[activeInput].cursorPosition + 1, utf8.len(guiElements[activeInput].value))
      if guiElements[activeInput].uppercaseOnly then
        guiElements[activeInput].value = utf8.upper(guiElements[activeInput].value)
      end
      guiElements[activeInput].len = utf8.len(guiElements[activeInput].value)
      guiElements[activeInput].cursorPosition = guiElements[activeInput].cursorPosition + 1
      if guiElements[activeInput].password then
        guiElements[activeInput].mask = ""
        for k = 1, utf8.len(guiElements[activeInput].value) do
          guiElements[activeInput].mask = guiElements[activeInput].mask .. "\226\128\162"
        end
      end
      if guiElements[activeInput].multiline then
        refreshMultilineText(activeInput, character ~= " ")
      end
      if guiElements[activeInput].changeEvent then
        triggerEvent(guiElements[activeInput].changeEvent, localPlayer, guiElements[activeInput].value, activeInput)
      end
    end
  end
end)
addEventHandler("onClientClick", getRootElement(), function(button, state, cx, cy)
  if activeInput then
    if state == "up" then
      if guiElements[activeInput].passwordShown then
        guiElements[activeInput].passwordShown = false
      end
    elseif state == "down" then
      if guiElements[activeInput].multiline then
        if guiElements[activeInput].processedValue then
          local y = guiElements[activeInput].y + guiElements[activeInput].fontPadding
          local h = guiElements[activeInput].lineHeight or guiElements[activeInput].sy
          local x = guiElements[activeInput].x + guiElements[activeInput].fontPadding
          local line = math.floor((cy - y) / h) + 1
          if line > #guiElements[activeInput].processedValue then
            line = #guiElements[activeInput].processedValue
          end
          if 0 < line then
            local len = 0
            for i = 1, line do
              if guiElements[activeInput].processedValue[i] then
                len = len + utf8.len(guiElements[activeInput].processedValue[i] .. " ")
              end
            end
            local val = guiElements[activeInput].processedValue[line]
            local len2 = utf8.len(val)
            guiElements[activeInput].cursorPosition = len - len2 - 1
            for k = 0, len2 do
              local xPos = x + dxGetTextWidth(utf8.sub(val, 1, k), fontScales[guiElements[activeInput].font], guiElements[activeInput].font)
              if cx >= xPos then
                guiElements[activeInput].cursorPosition = len - len2 + k - 1
              end
              if k < len2 and cx >= xPos + dxGetTextWidth(utf8.sub(val, k + 1, k + 1), fontScales[guiElements[activeInput].font], guiElements[activeInput].font) / 2 then
                guiElements[activeInput].cursorPosition = len - len2 + k
              end
            end
          end
        end
      else
        local x = guiElements[activeInput].x
        local xPlus = guiElements[activeInput].fontPadding
        if guiElements[activeInput].icon then
          xPlus = xPlus + guiElements[activeInput].sy - 2
        end
        local xMinus = guiElements[activeInput].fontPadding
        if guiElements[activeInput].password and guiElements[activeInput].value and 0 < utf8.len(guiElements[activeInput].value) then
          local h = guiElements[activeInput].sy - guiElements[activeInput].fontPadding * 2
          xMinus = xMinus + h + guiElements[activeInput].fontPadding
        end
        if cx >= x and cy >= guiElements[activeInput].y and cx <= guiElements[activeInput].x + guiElements[activeInput].sx and cy <= guiElements[activeInput].y + guiElements[activeInput].sy then
          local h = guiElements[activeInput].sy - guiElements[activeInput].fontPadding * 2
          if guiElements[activeInput].password and cx >= guiElements[activeInput].x + guiElements[activeInput].sx - guiElements[activeInput].fontPadding - h then
            guiElements[activeInput].passwordShown = true
          else
            local val = ""
            if guiElements[activeInput].value and 0 < utf8.len(guiElements[activeInput].value) then
              val = guiElements[activeInput].value
              if guiElements[activeInput].password then
                val = guiElements[activeInput].mask
              end
            end
            if guiElements[activeInput].active then
              local width = dxGetTextWidth(utf8.sub(val, 1, guiElements[activeInput].cursorPosition), fontScales[guiElements[activeInput].font], guiElements[activeInput].font)
              if width + xPlus > guiElements[activeInput].sx - xMinus then
                xPlus = xPlus - (width + xPlus - (guiElements[activeInput].sx - xMinus))
              end
            end
            guiElements[activeInput].cursorPosition = 0
            local len = utf8.len(val)
            x = x + xPlus
            for k = 0, len do
              local xPos = x + dxGetTextWidth(utf8.sub(val, 1, k), fontScales[guiElements[activeInput].font], guiElements[activeInput].font)
              if cx >= xPos then
                guiElements[activeInput].cursorPosition = k
              end
              if k < len and cx >= xPos + dxGetTextWidth(utf8.sub(val, k + 1, k + 1), fontScales[guiElements[activeInput].font], guiElements[activeInput].font) / 2 then
                guiElements[activeInput].cursorPosition = k + 1
              end
            end
          end
        end
      end
    end
  end
end)
local keyTimers = {}
local keyPressed = {}
function focusPasteBrowser()
  if activeInput then
    focusBrowser(browser)
  end
end
function keyHandler(key)
  if key == "arrow_u" then
    local len = 0
    local storedLen = 0
    local line = 0
    local width = 0
    local d = 0
    local l = 0
    if not guiElements[activeInput].processedValue then
      return
    end
    if guiElements[activeInput].processedValue then
      for i = 1, #guiElements[activeInput].processedValue do
        l = utf8.len(guiElements[activeInput].processedValue[i] .. " ")
        if len <= guiElements[activeInput].cursorPosition then
          line = i
          storedLen = len
          d = guiElements[activeInput].cursorPosition - len
          width = dxGetTextWidth(utf8.sub(guiElements[activeInput].processedValue[i] .. " ", 1, d), fontScales[guiElements[activeInput].font], guiElements[activeInput].font)
        end
        len = len + l
      end
      if 1 < line then
        local val = guiElements[activeInput].processedValue[line - 1]
        local len2 = utf8.len(val)
        guiElements[activeInput].cursorPosition = storedLen
        for k = 0, len2 do
          local xPos = dxGetTextWidth(utf8.sub(val, 1, k), fontScales[guiElements[activeInput].font], guiElements[activeInput].font)
          if width >= xPos then
            guiElements[activeInput].cursorPosition = storedLen - len2 + k - 1
          end
          if k < len2 and width >= xPos + dxGetTextWidth(utf8.sub(val, k + 1, k + 1), fontScales[guiElements[activeInput].font], guiElements[activeInput].font) / 2 then
            guiElements[activeInput].cursorPosition = storedLen - len2 + k
          end
        end
      end
    end
  elseif key == "arrow_d" then
    local len = 0
    local storedLen = 0
    local line = 0
    local width = 0
    local d = 0
    local l = 0
    if not guiElements[activeInput].processedValue then
      return
    end
    for i = 1, #guiElements[activeInput].processedValue do
      l = utf8.len(guiElements[activeInput].processedValue[i] .. " ")
      if len <= guiElements[activeInput].cursorPosition then
        line = i
        storedLen = len + l + 1
        d = guiElements[activeInput].cursorPosition - len
        width = dxGetTextWidth(utf8.sub(guiElements[activeInput].processedValue[i] .. " ", 1, d), fontScales[guiElements[activeInput].font], guiElements[activeInput].font)
      end
      len = len + l
    end
    if line < #guiElements[activeInput].processedValue then
      local val = guiElements[activeInput].processedValue[line + 1]
      local len2 = utf8.len(val)
      guiElements[activeInput].cursorPosition = storedLen
      for k = 0, len2 do
        local xPos = dxGetTextWidth(utf8.sub(val, 1, k), fontScales[guiElements[activeInput].font], guiElements[activeInput].font)
        if width >= xPos then
          guiElements[activeInput].cursorPosition = storedLen + k - 1
        end
        if k < len2 and width >= xPos + dxGetTextWidth(utf8.sub(val, k + 1, k + 1), fontScales[guiElements[activeInput].font], guiElements[activeInput].font) / 2 then
          guiElements[activeInput].cursorPosition = storedLen + k
        end
      end
    end
  elseif key == "arrow_l" then
    local ctrl = getKeyState("lctrl") or getKeyState("rctrl")
    while 0 < guiElements[activeInput].cursorPosition do
      repeat
        guiElements[activeInput].cursorPosition = guiElements[activeInput].cursorPosition - 1
        do break end -- pseudo-goto
        break
      until true
      if not ctrl then
        break
      elseif utf8.sub(guiElements[activeInput].value, guiElements[activeInput].cursorPosition, guiElements[activeInput].cursorPosition) == " " then
        break
      end
    end
  elseif key == "arrow_r" then
    local ctrl = getKeyState("lctrl") or getKeyState("rctrl")
    while guiElements[activeInput].cursorPosition < utf8.len(guiElements[activeInput].value) do
      repeat
        guiElements[activeInput].cursorPosition = guiElements[activeInput].cursorPosition + 1
        do break end -- pseudo-goto
        break
      until true
      if not ctrl then
        break
      elseif utf8.sub(guiElements[activeInput].value, guiElements[activeInput].cursorPosition + 1, guiElements[activeInput].cursorPosition + 1) == " " then
        break
      end
    end
  elseif key == "tab" then
    if guiElements[activeInput].parent then
      local el = guiElements[activeInput].parent
      local foundNext = false
      local childrenPosition = 1
      for k = 1, #guiElements[el].children do
        if guiElements[el].children[k] == activeInput then
          childrenPosition = k
          break
        end
      end
      for k = childrenPosition, #guiElements[el].children do
        if guiElements[guiElements[el].children[k]].type == "input" and guiElements[el].children[k] ~= activeInput then
          foundNext = guiElements[el].children[k]
          break
        end
      end
      if not foundNext then
        for k = 1, childrenPosition do
          if guiElements[guiElements[el].children[k]].type == "input" and guiElements[el].children[k] ~= activeInput then
            foundNext = guiElements[el].children[k]
            break
          end
        end
      end
      if not foundNext then
        for k = 1, #renderList do
          if renderList[k] then
            local el = renderList[k]
            if el == activeInput then
              childrenPosition = k
              break
            end
          end
        end
        for k = childrenPosition, #renderList do
          if renderList[k] then
            local el = renderList[k]
            if guiElements[el].type == "input" and el ~= activeInput then
              foundNext = el
              break
            end
          end
        end
        if not foundNext then
          for k = 1, childrenPosition do
            if renderList[k] then
              local el = renderList[k]
              if guiElements[el].type == "input" and el ~= activeInput then
                foundNext = el
                break
              end
            end
          end
        end
      end
      if foundNext then
        guiElements[activeInput].active = false
        activeInput = foundNext
        triggerEvent("onActiveInputChange", localPlayer, activeInput, tmpActiveInput)
        focusPasteBrowser()
        guiElements[activeInput].active = true
      end
    end
  elseif key == "home" then
    if guiElements[activeInput].multiline then
      local len = 0
      local to = 0
      for i = 1, #guiElements[activeInput].processedValue do
        l = utf8.len(guiElements[activeInput].processedValue[i] .. " ")
        if len <= guiElements[activeInput].cursorPosition then
          to = len
        end
        len = len + l
      end
      guiElements[activeInput].cursorPosition = to
    else
      guiElements[activeInput].cursorPosition = 0
    end
  elseif key == "end" then
    if guiElements[activeInput].multiline then
      local len = 0
      local to = 0
      for i = 1, #guiElements[activeInput].processedValue do
        l = utf8.len(guiElements[activeInput].processedValue[i] .. " ")
        if len <= guiElements[activeInput].cursorPosition then
          to = len + l
        end
        len = len + l
      end
      guiElements[activeInput].cursorPosition = to - 1
    else
      guiElements[activeInput].cursorPosition = utf8.len(guiElements[activeInput].value)
    end
  elseif key == "pgup" then
    if guiElements[activeInput].multiline then
      guiElements[activeInput].cursorPosition = 0
    end
  elseif key == "pgdn" then
    if guiElements[activeInput].multiline then
      guiElements[activeInput].cursorPosition = utf8.len(guiElements[activeInput].value)
    end
  elseif key == "delete" then
    if guiElements[activeInput].value and 0 < utf8.len(guiElements[activeInput].value) and guiElements[activeInput].cursorPosition < utf8.len(guiElements[activeInput].value) then
      local n = 2
      if getKeyState("lctrl") or getKeyState("rctrl") then
        for i = guiElements[activeInput].cursorPosition + 2, guiElements[activeInput].len do
          if utf8.sub(guiElements[activeInput].value, i, i) == " " then
            break
          end
          n = n + 1
        end
      end
      guiElements[activeInput].value = utf8.sub(guiElements[activeInput].value, 1, guiElements[activeInput].cursorPosition) .. utf8.sub(guiElements[activeInput].value, guiElements[activeInput].cursorPosition + n, utf8.len(guiElements[activeInput].value))
      guiElements[activeInput].len = utf8.len(guiElements[activeInput].value)
      if guiElements[activeInput].password then
        guiElements[activeInput].mask = ""
        for k = 1, utf8.len(guiElements[activeInput].value) do
          guiElements[activeInput].mask = guiElements[activeInput].mask .. "\226\128\162"
        end
      end
      if guiElements[activeInput].multiline then
        refreshMultilineText(activeInput)
      end
      if guiElements[activeInput].changeEvent then
        triggerEvent(guiElements[activeInput].changeEvent, localPlayer, guiElements[activeInput].value, activeInput)
      end
    end
  elseif key == "backspace" and guiElements[activeInput].value and 0 < utf8.len(guiElements[activeInput].value) then
    if 0 < guiElements[activeInput].cursorPosition then
      local n = 1
      if getKeyState("lctrl") or getKeyState("rctrl") then
        for i = guiElements[activeInput].cursorPosition - 1, 1, -1 do
          if utf8.sub(guiElements[activeInput].value, i, i) == " " then
            break
          end
          n = n + 1
        end
      end
      guiElements[activeInput].value = utf8.sub(guiElements[activeInput].value, 1, guiElements[activeInput].cursorPosition - n) .. utf8.sub(guiElements[activeInput].value, guiElements[activeInput].cursorPosition + 1, utf8.len(guiElements[activeInput].value))
      guiElements[activeInput].len = utf8.len(guiElements[activeInput].value)
      guiElements[activeInput].cursorPosition = guiElements[activeInput].cursorPosition - n
    end
    if guiElements[activeInput].password then
      guiElements[activeInput].mask = ""
      for k = 1, utf8.len(guiElements[activeInput].value) do
        guiElements[activeInput].mask = guiElements[activeInput].mask .. "\226\128\162"
      end
    end
    if guiElements[activeInput].multiline then
      refreshMultilineText(activeInput)
    end
    if guiElements[activeInput].changeEvent then
      triggerEvent(guiElements[activeInput].changeEvent, localPlayer, guiElements[activeInput].value, activeInput)
    end
  end
  if key ~= "home" and key ~= "end" and key ~= "tab" and keyPressed[key] then
    keyTimers[key] = setTimer(keyHandler, 25, 1, key)
  end
end
addEventHandler("onClientKey", getRootElement(), function(key, por)
  if activeInput then
    cancelEvent()
    if not por then
      if isTimer(keyTimers[key]) then
        killTimer(keyTimers[key])
      end
      keyPressed[key] = nil
      keyTimers[key] = nil
    elseif key == "pgup" or key == "pgdn" or key == "arrow_l" or key == "arrow_r" or key == "arrow_u" or key == "arrow_d" or key == "tab" or key == "home" or key == "end" or key == "delete" or key == "backspace" then
      if not guiElements[activeInput].value then
        guiElements[activeInput].value = ""
        guiElements[activeInput].len = 0
      end
      if not guiElements[activeInput].cursorPosition then
        guiElements[activeInput].cursorPosition = utf8.len(guiElements[activeInput].value)
      end
      keyHandler(key)
      if key ~= "home" and key ~= "end" and key ~= "tab" then
        keyPressed[key] = true
        keyTimers[key] = setTimer(keyHandler, 500, 1, key)
      end
    end
  elseif key == "tab" and por and isCursorShowing() then
    local foundNext = false
    for k = 1, #renderList do
      if renderList[k] then
        local el = renderList[k]
        if guiElements[el].type == "input" then
          foundNext = el
          break
        end
      end
    end
    if foundNext then
      activeInput = foundNext
      triggerEvent("onActiveInputChange", localPlayer, activeInput, false)
      focusPasteBrowser()
      guiElements[activeInput].active = true
    end
    cancelEvent()
  end
end, true, "high+9999999999999")
function setInputColor(el, color1, color2, color3, color4, fontColor)
  if tonumber(el) and guiElements[el] then
    if guiElements[el].type == "input" then
      setElementColorToData(el, "color1", color1)
      setElementColorToData(el, "color2", color2)
      setElementColorToData(el, "color3", color3)
      setElementColorToData(el, "color4", color4)
      setElementColorToData(el, "fontColor", fontColor)
    else
      throwGuiError("setInputColor: guiElement is not input")
    end
  else
    throwGuiError("setInputColor: invalid guiElement")
  end
end
function setInputNumberOnly(el, val)
  if tonumber(el) and guiElements[el] then
    if guiElements[el].type == "input" then
      guiElements[el].numberOnly = val
      guiElements[el].numberNegative = nil
    else
      throwGuiError("setInputNumberOnly: guiElement is not input")
    end
  else
    throwGuiError("setInputNumberOnly: invalid guiElement")
  end
end
function setInputNumberNegative(el, val)
  if tonumber(el) and guiElements[el] then
    if guiElements[el].type == "input" then
      guiElements[el].numberOnly = nil
      guiElements[el].numberNegative = val
    else
      throwGuiError("setInputNumberNegative: guiElement is not input")
    end
  else
    throwGuiError("setInputNumberNegative: invalid guiElement")
  end
end
function setInputFontPaddingHeight(el, height)
  if tonumber(el) and guiElements[el] then
    if guiElements[el].type == "input" then
      if guiElements[el].multiline then
        guiElements[el].paddingHeight = height
        guiElements[el].fontPadding = (height - guiElements[el].fontHeight) / 2
      end
    else
      throwGuiError("setInputFontPaddingHeight: guiElement is not input")
    end
  else
    throwGuiError("setInputFontPaddingHeight: invalid guiElement")
  end
end
function setActiveInput(el)
  if tonumber(el) and guiElements[el] then
    if guiElements[el].type == "input" then
      if activeInput then
        guiElements[activeInput].active = false
      end
      activeInput = el
      focusPasteBrowser()
      guiElements[activeInput].active = true
    else
      throwGuiError("setActiveInput: guiElement is not input")
    end
  else
    if activeInput then
      guiElements[activeInput].active = false
    end
    activeInput = false
  end
end
function setInputDisableBorder(el, state)
  if tonumber(el) and guiElements[el] then
    if guiElements[el].type == "input" then
      guiElements[el].disableBorder = state
    else
      throwGuiError("setInputDisableBorder: guiElement is not input")
    end
  else
    throwGuiError("setInputDisableBorder: invalid guiElement")
  end
end
function setInputLineHeight(el, height)
  if tonumber(el) and guiElements[el] then
    if guiElements[el].type == "input" then
      if guiElements[el].multiline then
        guiElements[el].lineHeight = height
        guiElements[el].maxLines = (guiElements[el].sy - guiElements[el].fontPadding * 2) / guiElements[el].lineHeight
      end
    else
      throwGuiError("setInputLineHeight: guiElement is not input")
    end
  else
    throwGuiError("setInputLineHeight: invalid guiElement")
  end
end
function setInputMultiline(el, state, padding)
  if tonumber(el) and guiElements[el] then
    if guiElements[el].type == "input" then
      guiElements[el].multiline = state
      if guiElements[el].multiline then
        guiElements[el].fontPadding = tonumber(padding) or 8
        guiElements[el].lineHeight = guiElements[el].fontHeight
        guiElements[el].maxLines = (guiElements[el].sy - guiElements[el].fontPadding * 2) / guiElements[el].lineHeight
        refreshMultilineText(el, true)
      else
        refreshInputSize(el)
      end
    else
      throwGuiError("setInputMultiline: guiElement is not input")
    end
  else
    throwGuiError("setInputMultiline: invalid guiElement")
  end
end
function refreshMultilineText(el, refreshLine)
  if tonumber(el) and guiElements[el] then
    if guiElements[el].type == "input" then
      if guiElements[el].multiline then
        local val = guiElements[el].value
        if val then
          guiElements[el].processedValue = {}
          if utf8.len(val) > 0 then
            val = split(val, " ")
            if #val == 1 then
              guiElements[el].processedValue = {
                val[1]
              }
            else
              local text = val[1]
              for i = 2, #val do
                local w = dxGetTextWidth(text .. " " .. val[i], fontScales[guiElements[el].font], guiElements[el].font)
                if w > guiElements[el].sx - guiElements[el].fontPadding * 2 then
                  table.insert(guiElements[el].processedValue, text)
                  text = val[i]
                else
                  text = text .. " " .. val[i]
                end
              end
              table.insert(guiElements[el].processedValue, text)
            end
            if refreshLine then
              guiElements[el].value = table.concat(val, " ")
              local max = utf8.len(guiElements[el].value)
              if max <= guiElements[el].cursorPosition then
                guiElements[el].cursorPosition = max
              end
              guiElements[el].len = max
            end
          end
        end
      else
        throwGuiError("refreshMultilineText: input is not multiline")
      end
    else
      throwGuiError("refreshMultilineText: guiElement is not input")
    end
  else
    throwGuiError("refreshMultilineText: invalid guiElement")
  end
end
function refreshInputSize(el)
  if tonumber(el) and guiElements[el] then
    if guiElements[el].type == "input" then
      if guiElements[el].multiline then
        guiElements[el].maxLines = (guiElements[el].sy - guiElements[el].fontPadding * 2) / guiElements[el].lineHeight
        refreshMultilineText(el)
      else
        guiElements[el].fontPadding = (guiElements[el].sy - guiElements[el].fontHeight) / 2
        if guiElements[el].icon then
          guiElements[el].icon = getFaIconFilename(guiElements[el].iconRaw, math.ceil(guiElements[el].sy) - 2)
        end
      end
    else
      throwGuiError("refreshInputSize: guiElement is not input")
    end
  else
    throwGuiError("refreshInputSize: invalid guiElement")
  end
end
function setInputFont(el, font)
  if tonumber(el) and guiElements[el] then
    if guiElements[el].type == "input" then
      guiElements[el].font = getFont(font)
      if not guiElements[el].multiline then
        guiElements[el].fontHeight = dxGetFontHeight(fontScales[guiElements[el].font], guiElements[el].font)
        local height = math.ceil(guiElements[el].fontHeight)
        guiElements[el].fontPadding = math.floor((guiElements[el].sy - height) / 2)
        if guiElements[el].password then
          guiElements[el].shownIcon = getFaIconFilename("eye", height)
          guiElements[el].hiddenIcon = getFaIconFilename("eye-slash", height)
        end
      end
    else
      throwGuiError("setInputFont: guiElement is not input")
    end
  else
    throwGuiError("setInputFont: invalid guiElement")
  end
end
function setInputMaxLength(el, maxLength)
  if tonumber(el) and guiElements[el] then
    if guiElements[el].type == "input" then
      guiElements[el].maxLength = maxLength
    else
      throwGuiError("setInputMaxLength: guiElement is not input")
    end
  else
    throwGuiError("setInputMaxLength: invalid guiElement")
  end
end
function setInputChangeEvent(el, changeEvent)
  if tonumber(el) and guiElements[el] then
    if guiElements[el].type == "input" then
      guiElements[el].changeEvent = changeEvent
    else
      throwGuiError("setInputChangeEvent: guiElement is not input")
    end
  else
    throwGuiError("setInputChangeEvent: invalid guiElement")
  end
end
function setInputIcon(el, icon, iType)
  if tonumber(el) and guiElements[el] then
    if guiElements[el].type == "input" then
      if icon then
        guiElements[el].icon = getFaIconFilename(icon, math.ceil(guiElements[el].sy) - 2, iType)
        guiElements[el].iconRaw = icon
        local height = math.ceil(guiElements[el].fontHeight)
        guiElements[el].shownIcon = getFaIconFilename("eye", height)
        guiElements[el].hiddenIcon = getFaIconFilename("eye-slash", height)
      else
        guiElements[el].icon = nil
        guiElements[el].iconRaw = nil
      end
    else
      throwGuiError("setInputIcon: guiElement is not input")
    end
  else
    throwGuiError("setInputIcon: invalid guiElement")
  end
end
function setInputPassword(el, password)
  if tonumber(el) and guiElements[el] then
    if guiElements[el].type == "input" then
      guiElements[el].password = password
      if guiElements[el].password then
        guiElements[el].mask = ""
        for k = 1, utf8.len(guiElements[el].value or "") do
          guiElements[el].mask = guiElements[el].mask .. "\226\128\162"
        end
      end
    else
      throwGuiError("setInputPassword: guiElement is not input")
    end
  else
    throwGuiError("setInputPassword: invalid guiElement")
  end
end
function setInputPlaceholder(el, text)
  if tonumber(el) and guiElements[el] then
    if guiElements[el].type == "input" then
      guiElements[el].placeholder = text
    else
      throwGuiError("setInputPlaceholder: guiElement is not input")
    end
  else
    throwGuiError("setInputPlaceholder: invalid guiElement")
  end
end
function setInputBorderSize(el, size)
  if tonumber(el) and guiElements[el] then
    if guiElements[el].type == "input" then
      guiElements[el].inputBorderSize = size
    else
      throwGuiError("setInputBorderSize: guiElement is not input")
    end
  else
    throwGuiError("setInputBorderSize: invalid guiElement")
  end
end
function resetInput(el)
  if tonumber(el) and guiElements[el] then
    if guiElements[el].type == "input" then
      guiElements[el].value = ""
      guiElements[el].len = 0
      guiElements[el].mask = ""
      guiElements[el].cursorPosition = 0
      refreshMultilineText(el)
    else
      throwGuiError("resetInput: guiElement is not input")
    end
  else
    throwGuiError("resetInput: invalid guiElement")
  end
end
function setInputCursorPosition(el, pos)
  if tonumber(el) and guiElements[el] then
    if guiElements[el].type == "input" then
      if guiElements[el].value then
        guiElements[activeInput].cursorPosition = tonumber(pos) or utf8.len(guiElements[activeInput].value)
      end
    else
      throwGuiError("setInputCursorPosition: guiElement is not input")
    end
  else
    throwGuiError("setInputCursorPosition: invalid guiElement")
  end
end
function getInputCursorPosition(el)
  if tonumber(el) and guiElements[el] then
    if guiElements[el].type == "input" then
      return guiElements[activeInput].cursorPosition or 0
    else
      throwGuiError("getInputCursorPosition: guiElement is not input")
    end
  else
    throwGuiError("getInputCursorPosition: invalid guiElement")
  end
end
function moveInputCursorBack(el)
  if tonumber(el) and guiElements[el] then
    if guiElements[el].type == "input" then
      if guiElements[el].value then
        guiElements[activeInput].cursorPosition = utf8.len(guiElements[activeInput].value)
      end
    else
      throwGuiError("moveInputCursorBack: guiElement is not input")
    end
  else
    throwGuiError("moveInputCursorBack: invalid guiElement")
  end
end
function setInputValue(el, value)
  if tonumber(el) and guiElements[el] then
    if guiElements[el].type == "input" then
      guiElements[el].value = value
      guiElements[el].len = utf8.len(guiElements[el].value)
      if guiElements[el].multiline then
        refreshMultilineText(el)
      elseif guiElements[el].password then
        guiElements[el].mask = ""
        for k = 1, utf8.len(guiElements[el].value or "") do
          guiElements[el].mask = guiElements[el].mask .. "\226\128\162"
        end
      end
      if not guiElements[el].cursorPosition or guiElements[el].cursorPosition > utf8.len(guiElements[el].value) then
        guiElements[el].cursorPosition = utf8.len(guiElements[el].value)
      end
    else
      throwGuiError("setInputValue: guiElement is not input")
    end
  else
    throwGuiError("setInputValue: invalid guiElement")
  end
end
function getInputValue(el)
  if tonumber(el) and guiElements[el] then
    if guiElements[el].type == "input" then
      if guiElements[el].multiline and guiElements[el].value then
        local tmp = split(guiElements[el].value, " ")
        guiElements[el].value = table.concat(tmp, " ")
      end
      return guiElements[el].value
    else
      throwGuiError("getInputValue: guiElement is not input")
    end
  else
    throwGuiError("getInputValue: invalid guiElement")
  end
  return ""
end
function getActiveInput()
  return activeInput
end
