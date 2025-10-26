function renderFunctions.slider(el)
  if guiElements[el].disabled then
    dxDrawRectangle(guiElements[el].x, guiElements[el].y, guiElements[el].sx, guiElements[el].sy, bitReplace(guiElements[el].color1, 150, 24, 8))
  else
    dxDrawRectangle(guiElements[el].x, guiElements[el].y, guiElements[el].sx, guiElements[el].sy, guiElements[el].color1)
  end
  local x, y, sx, sy = guiElements[el].x, guiElements[el].y, guiElements[el].sliderSize or 24, guiElements[el].sy
  if guiElements[el].sliderDrag and cx then
    local tmp = math.min(1, math.max((cx - guiElements[el].sliderDrag) / (guiElements[el].sx - sx), 0))
    if tmp ~= guiElements[el].sliderValue then
      guiElements[el].sliderValue = tmp
      if guiElements[el].changeEvent then
        triggerEvent(guiElements[el].changeEvent, localPlayer, el, guiElements[el].sliderValue, false)
      end
    end
  end
  local val = guiElements[el].sliderValue or 0
  x = x + (guiElements[el].sx - sx) * val
  if guiElements[el].hoverAlpha and 0 < guiElements[el].hoverAlpha and not guiElements[el].hoverDisableSize then
    sy = sy + 4 * (guiElements[el].hoverAlpha / 255)
    y = y - 4 * (guiElements[el].hoverAlpha / 255) * 0.5
  end
  if guiElements[el].disabled then
    dxDrawRectangle(x, y, sx, sy, bitReplace(guiElements[el].color2, 100, 24, 8))
  elseif guiElements[el].sliderBorderSize then
    if guiElements[el].sliderBorderEx then
      dxDrawRectangle(x, y, guiElements[el].sliderBorderSize, sy, guiElements[el].sliderBorderColor)
      dxDrawRectangle(x + sx - guiElements[el].sliderBorderSize, y, guiElements[el].sliderBorderSize, sy, guiElements[el].sliderBorderColor)
      dxDrawRectangle(x + guiElements[el].sliderBorderSize, y, sx - 2 * guiElements[el].sliderBorderSize, guiElements[el].sliderBorderSize, guiElements[el].sliderBorderColor)
      dxDrawRectangle(x + guiElements[el].sliderBorderSize, y + sy - guiElements[el].sliderBorderSize, sx - 2 * guiElements[el].sliderBorderSize, guiElements[el].sliderBorderSize, guiElements[el].sliderBorderColor)
    else
      dxDrawRectangle(x, y, sx, sy, guiElements[el].sliderBorderColor)
    end
    dxDrawRectangle(x + guiElements[el].sliderBorderSize, y + guiElements[el].sliderBorderSize, sx - guiElements[el].sliderBorderSize * 2, sy - guiElements[el].sliderBorderSize * 2, guiElements[el].color2)
  else
    dxDrawRectangle(x, y, sx, sy, guiElements[el].color2)
  end
end
function setSliderChangeEvent(el, event)
  if tonumber(el) and guiElements[el] then
    if guiElements[el].type == "slider" then
      guiElements[el].changeEvent = event
    else
      throwGuiError("setSliderChangeEvent: guiElement is not slider")
    end
  else
    throwGuiError("setSliderChangeEvent: invalid guiElement")
  end
end
function setSliderBorder(el, col, size, ex)
  if tonumber(el) and guiElements[el] then
    if guiElements[el].type == "slider" then
      if col then
        setElementColorToData(el, "sliderBorderColor", col)
        guiElements[el].sliderBorderSize = size or 1
        guiElements[el].sliderBorderEx = ex
      else
        guiElements[el].sliderBorderColor = nil
        guiElements[el].sliderBorderEx = nil
        setElementColorToData(el, "sliderBorderColor", false)
        guiElements[el].sliderBorderSize = nil
      end
    else
      throwGuiError("setSliderSize: guiElement is not slider")
    end
  else
    throwGuiError("setSliderSize: invalid guiElement")
  end
end
function setSliderSize(el, size)
  if tonumber(el) and guiElements[el] then
    if guiElements[el].type == "slider" then
      guiElements[el].sliderSize = size
    else
      throwGuiError("setSliderSize: guiElement is not slider")
    end
  else
    throwGuiError("setSliderSize: invalid guiElement")
  end
end
function setSliderColor(el, color1, color2)
  if tonumber(el) and guiElements[el] then
    if guiElements[el].type == "slider" then
      setElementColorToData(el, "color1", color1)
      setElementColorToData(el, "color2", color2)
    else
      throwGuiError("setSliderColor: guiElement is not slider")
    end
  else
    throwGuiError("setSliderColor: invalid guiElement")
  end
end
function setSliderValue(el, value)
  if tonumber(el) and guiElements[el] then
    if guiElements[el].type == "slider" then
      guiElements[el].sliderValue = math.min(1, math.max(value, 0))
    else
      throwGuiError("setSliderValue: guiElement is not slider")
    end
  else
    throwGuiError("setSliderValue: invalid guiElement")
  end
end
function getSliderValue(el, value)
  if tonumber(el) and guiElements[el] then
    if guiElements[el].type == "slider" then
      return guiElements[el].sliderValue
    else
      throwGuiError("getSliderValue: guiElement is not slider")
    end
  else
    throwGuiError("getSliderValue: invalid guiElement")
  end
end
