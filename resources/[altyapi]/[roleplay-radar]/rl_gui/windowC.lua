activeInput = false
function renderFunctions.window(el)
  dxDrawRectangle(guiElements[el].x, guiElements[el].y, guiElements[el].sx, guiElements[el].sy, guiElements[el].bcg)
  dxDrawRectangle(guiElements[el].x, guiElements[el].y, guiElements[el].sx, titleBarHeight, guiElements[el].titleColor)
  dxDrawRectangle(guiElements[el].x, guiElements[el].y + titleBarHeight - 1, guiElements[el].sx, 1, guiElements[el].light)
  dxDrawText(guiElements[el].title, guiElements[el].x + guiElements[el].fontPadding, guiElements[el].y, guiElements[el].x + guiElements[el].sx, guiElements[el].y + titleBarHeight, guiElements[el].textColor, fontScales[guiElements[el].font], guiElements[el].font, "left", "center", true)
  if guiElements[el].closeIcon then
    dxDrawImage(guiElements[el].x + guiElements[el].sx - titleBarHeight, guiElements[el].y, titleBarHeight, titleBarHeight, guiElements[el].closeIcon .. faTicks[guiElements[el].closeIcon], 0, 0, 0, tocolor(255, 255, 255))
    if 0 < guiElements[el].hoverAlpha then
      dxDrawImage(guiElements[el].x + guiElements[el].sx - titleBarHeight, guiElements[el].y, titleBarHeight, titleBarHeight, guiElements[el].closeIcon .. faTicks[guiElements[el].closeIcon], 0, 0, 0, bitReplace(guiElements[el].closeButtonColor, guiElements[el].hoverAlpha, 24, 8))
    end
  end
  if guiElements[el].element then
    if isElement(guiElements[el].element) then
      local x, y, z = getElementPosition(localPlayer)
      local x2, y2, z2 = getElementPosition(guiElements[el].element)
      local distance = getDistanceBetweenPoints3D(x, y, z, x2, y2, z2)
      if distance > guiElements[el].maxDistance then
        if guiElements[el].elementEvent then
          guiElements[el].element = nil
          triggerEvent(guiElements[el].elementEvent, localPlayer)
        else
          deleteGuiElement(el)
          triggerEvent("onGuiWindowForceClosed", localPlayer, el)
        end
      end
    elseif guiElements[el].elementEvent then
      guiElements[el].element = nil
      triggerEvent(guiElements[el].elementEvent, localPlayer)
    else
      deleteGuiElement(el)
      triggerEvent("onGuiWindowForceClosed", localPlayer, el)
    end
  end
end
movingWindow = false
addEventHandler("onClientClick", getRootElement(), function(button, state, cx, cy)
  if state == "up" then
    movingWindow = false
  elseif state == "down" and hoverElement and guiElements[hoverElement] and guiElements[hoverElement].type == "window" then
    if guiElements[hoverElement].closeIconEvent and cx >= guiElements[hoverElement].x + guiElements[hoverElement].sx - titleBarHeight then
      if guiElements[hoverElement].clickSound then
        playUISound(guiElements[hoverElement].clickSound)
      end
      triggerEvent(guiElements[hoverElement].closeIconEvent, localPlayer, button, state, absoluteX, absoluteY, el)
    else
      movingWindow = {
        hoverElement,
        guiElements[hoverElement].x,
        guiElements[hoverElement].y,
        cx,
        cy
      }
    end
  end
end)
addEventHandler("onClientCursorMove", getRootElement(), function(rx, ry, cx, cy)
  if movingWindow then
    if not guiElements[movingWindow[1]] then
      movingWindow = false
      return
    end
    local x, y = movingWindow[2] + (cx - movingWindow[4]), movingWindow[3] + (cy - movingWindow[5])
    if x < 0 then
      x = 0
    end
    if y < 0 then
      y = 0
    end
    if x > screenX - guiElements[movingWindow[1]].sx then
      x = screenX - guiElements[movingWindow[1]].sx
    end
    if y > screenY - guiElements[movingWindow[1]].sy then
      y = screenY - guiElements[movingWindow[1]].sy
    end
    setGuiPosition(movingWindow[1], math.floor(x), math.floor(y))
    if guiElements[movingWindow[1]].moveEvent then
      triggerEvent(guiElements[movingWindow[1]].moveEvent, localPlayer, movingWindow[1], math.floor(x), math.floor(y))
    end
  end
end)
function setWindowMoveEvent(el, ev)
  if tonumber(el) and guiElements[el] then
    if guiElements[el].type == "window" then
      guiElements[el].moveEvent = ev
    else
      throwGuiError("setWindowMoveEvent: guiElement is not window")
    end
  else
    throwGuiError("setWindowMoveEvent: invalid guiElement")
  end
end
function setWindowCloseButton(el, event, icon, color)
  if tonumber(el) and guiElements[el] then
    if guiElements[el].type == "window" then
      if event then
        color = color or "v4red"
        icon = icon or "times"
        guiElements[el].closeIcon = getFaIconFilename(icon, titleBarHeight)
        guiElements[el].closeIconEvent = event
        setElementColorToData(el, "closeButtonColor", color)
      else
        guiElements[el].closeIcon = nil
        guiElements[el].closeIconEvent = nil
        setElementColorToData(el, "closeButtonColor", false)
      end
    else
      throwGuiError("setWindowCloseButton: guiElement is not window")
    end
  else
    throwGuiError("setWindowCloseButton: invalid guiElement")
  end
end
function setWindowColors(el, bcg, titleColor, light, text)
  if tonumber(el) and guiElements[el] then
    if guiElements[el].type == "window" then
      setElementColorToData(el, "bcg", bcg)
      setElementColorToData(el, "titleColor", titleColor)
      setElementColorToData(el, "light", light)
      setElementColorToData(el, "textColor", textColor)
    else
      throwGuiError("setWindowColors: guiElement is not window")
    end
  else
    throwGuiError("setWindowColors: invalid guiElement")
  end
end
function setWindowTitle(el, font, title)
  if tonumber(el) and guiElements[el] then
    if guiElements[el].type == "window" then
      guiElements[el].font = getFont(font)
      local height = math.ceil(dxGetFontHeight(fontScales[guiElements[el].font], guiElements[el].font))
      guiElements[el].fontPadding = math.floor((titleBarHeight - height) / 2)
      guiElements[el].title = title
    else
      throwGuiError("setWindowTitle: guiElement is not window")
    end
  else
    throwGuiError("setWindowTitle: invalid guiElement")
  end
end
function setWindowElementMaxDistance(el, element, distance, closeEvent)
  if tonumber(el) and guiElements[el] then
    if guiElements[el].type == "window" then
      guiElements[el].element = element
      guiElements[el].maxDistance = distance
      guiElements[el].elementEvent = closeEvent
    else
      throwGuiError("setWindowElementMaxDistance: guiElement is not window")
    end
  else
    throwGuiError("setWindowElementMaxDistance: invalid guiElement")
  end
end
