function renderFunctions.toggle(el)
  if guiElements[el].disabled then
    dxDrawRectangle(guiElements[el].x, guiElements[el].y, guiElements[el].sx, guiElements[el].sy, bitReplace(guiElements[el].color1, 150, 24, 8))
  else
    dxDrawRectangle(guiElements[el].x, guiElements[el].y, guiElements[el].sx, guiElements[el].sy, guiElements[el].color1)
  end
  local x, y, sx, sy = guiElements[el].x, guiElements[el].y, guiElements[el].sx / 2, guiElements[el].sy
  local r, g, b = interpolateBetween(guiElements[el].color2[1], guiElements[el].color2[2], guiElements[el].color2[3], guiElements[el].color3[1], guiElements[el].color3[2], guiElements[el].color3[3], guiElements[el].toggleStateVal or 0, "Linear")
  if guiElements[el].hoverAlpha and 0 < guiElements[el].hoverAlpha and not guiElements[el].hoverDisableSize then
    sy = sy + 4 * (guiElements[el].hoverAlpha / 255)
    y = y - 4 * (guiElements[el].hoverAlpha / 255) * 0.5
  end
  if guiElements[el].disabled then
    dxDrawRectangle(x + sx * (guiElements[el].toggleStateVal or 0), y, sx, sy, tocolor(r, g, b, 100))
  else
    dxDrawRectangle(x + sx * (guiElements[el].toggleStateVal or 0), y, sx, sy, tocolor(r, g, b))
  end
end
function setToggleColor(el, color1, color2, color3)
  if tonumber(el) and guiElements[el] then
    if guiElements[el].type == "toggle" then
      setElementColorToData(el, "color1", color1)
      setElementColorTableToData(el, "color2", color2)
      setElementColorTableToData(el, "color3", color3)
    else
      throwGuiError("setToggleColor: guiElement is not toggle")
    end
  else
    throwGuiError("setToggleColor: invalid guiElement")
  end
end
function setToggleState(el, state, skipAnimation)
  if tonumber(el) and guiElements[el] then
    if guiElements[el].type == "toggle" then
      guiElements[el].toggleState = state
      if skipAnimation then
        guiElements[el].toggleStateVal = state and 1 or 0
      end
    else
      throwGuiError("setToggleState: guiElement is not toggle")
    end
  else
    throwGuiError("setToggleState: invalid guiElement")
  end
end
function getToggleState(el)
  if tonumber(el) and guiElements[el] then
    if guiElements[el].type == "toggle" then
      return guiElements[el].toggleState
    else
      throwGuiError("getToggleState: guiElement is not toggle")
    end
  else
    throwGuiError("getToggleState: invalid guiElement")
  end
end
