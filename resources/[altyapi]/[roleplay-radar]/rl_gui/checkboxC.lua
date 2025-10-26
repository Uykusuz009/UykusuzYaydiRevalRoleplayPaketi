function renderFunctions.checkbox(el)
  if guiElements[el].text then
    if guiElements[el].hoverAlpha and guiElements[el].hoverAlpha > 0 then
      local border = guiElements[el].hoverAlpha / 255 * 1
      dxDrawRectangle(guiElements[el].x - border, guiElements[el].y + guiElements[el].sy * 0.2 - border, guiElements[el].sy * 0.6 + border * 2, guiElements[el].sy * 0.6 + border * 2, bitReplace(guiElements[el].color1, border * 255, 24, 8))
    end
    dxDrawRectangle(guiElements[el].x, guiElements[el].y + guiElements[el].sy * 0.2, guiElements[el].sy * 0.6, guiElements[el].sy * 0.6, guiElements[el].color1)
    dxDrawRectangle(guiElements[el].x + 1, guiElements[el].y + guiElements[el].sy * 0.2 + 1, guiElements[el].sy * 0.6 - 2, guiElements[el].sy * 0.6 - 2, guiElements[el].color2)
    if guiElements[el].checked then
      dxDrawImage(guiElements[el].x + 1 - guiElements[el].sy * (guiElements[el].checkX + 0.2), guiElements[el].y + 1 - guiElements[el].sy * guiElements[el].checkY, guiElements[el].sy, guiElements[el].sy, guiElements[el].checkIcon .. faTicks[guiElements[el].checkIcon], 0, 0, 0, guiElements[el].color3)
    end
    dxDrawText(guiElements[el].text, guiElements[el].x + guiElements[el].sy * 0.6 + guiElements[el].fontPadding, guiElements[el].y, 0, guiElements[el].y + guiElements[el].sy, guiElements[el].fontColor, fontScales[guiElements[el].font], guiElements[el].font, "left", "center", false, false, false, true)
  else
    if guiElements[el].hoverAlpha and guiElements[el].hoverAlpha > 0 then
      local border = guiElements[el].hoverAlpha / 255 * 1
      dxDrawRectangle(guiElements[el].x + guiElements[el].sy * 0.2 - border, guiElements[el].y + guiElements[el].sy * 0.2 - border, guiElements[el].sy * 0.6 + border * 2, guiElements[el].sy * 0.6 + border * 2, bitReplace(guiElements[el].color1, border * 255, 24, 8))
    end
    dxDrawRectangle(guiElements[el].x + guiElements[el].sy * 0.2, guiElements[el].y + guiElements[el].sy * 0.2, guiElements[el].sy * 0.6, guiElements[el].sy * 0.6, guiElements[el].color1)
    dxDrawRectangle(guiElements[el].x + guiElements[el].sy * 0.2 + 1, guiElements[el].y + guiElements[el].sy * 0.2 + 1, guiElements[el].sy * 0.6 - 2, guiElements[el].sy * 0.6 - 2, guiElements[el].color2)
    if guiElements[el].checked then
      dxDrawImage(guiElements[el].x + guiElements[el].sy * 0.2 + 1 - guiElements[el].sy * (guiElements[el].checkX + 0.2), guiElements[el].y + 1 - guiElements[el].sy * guiElements[el].checkY, guiElements[el].sy, guiElements[el].sy, guiElements[el].checkIcon .. faTicks[guiElements[el].checkIcon], 0, 0, 0, guiElements[el].color3)
    end
  end
end
function setCheckboxFont(el, font)
  if tonumber(el) and guiElements[el] then
    if guiElements[el].type == "checkbox" then
      guiElements[el].font = getFont(font)
      local height = math.ceil(dxGetFontHeight(fontScales[guiElements[el].font], guiElements[el].font))
      guiElements[el].fontPadding = math.max(6, math.floor((guiElements[el].sy - height) / 2))
      guiElements[el].checkIcon = getFaIconFilename("check", guiElements[el].sy)
      guiElements[el].checkIconRaw = "check"
      guiElements[el].checkX = -0.075
      guiElements[el].checkY = 0.025
    else
      throwGuiError("setCheckboxFont: guiElement is not checkbox")
    end
  else
    throwGuiError("setCheckboxFont: invalid guiElement")
  end
end
function setCheckboxIcon(el, icon, x, y, iconStyle)
  if tonumber(el) and guiElements[el] then
    if guiElements[el].type == "checkbox" then
      guiElements[el].checkIcon = getFaIconFilename(icon, guiElements[el].sy, iconStyle)
      guiElements[el].checkIconRaw = icon
      guiElements[el].checkX = x
      guiElements[el].checkY = y
    else
      throwGuiError("setCheckboxIcon: guiElement is not checkbox")
    end
  else
    throwGuiError("setCheckboxIcon: invalid guiElement")
  end
end
function getCheckboxWidth(el)
  if tonumber(el) and guiElements[el] then
    if guiElements[el].type == "checkbox" then
      return guiElements[el].sy * 0.6 + guiElements[el].fontPadding + getTextWidthFont(guiElements[el].text, guiElements[el].font)
    else
      throwGuiError("getCheckboxWidth: guiElement is not checkbox")
    end
  else
    throwGuiError("getCheckboxWidth: invalid guiElement")
  end
end
function setCheckboxColor(el, color1, color2, color3, fontColor)
  if tonumber(el) and guiElements[el] then
    if guiElements[el].type == "checkbox" then
      setElementColorToData(el, "color1", color1)
      setElementColorToData(el, "color2", color2)
      setElementColorToData(el, "color3", color3)
      setElementColorToData(el, "fontColor", fontColor)
    else
      throwGuiError("setCheckboxColor: guiElement is not checkbox")
    end
  else
    throwGuiError("setCheckboxColor: invalid guiElement")
  end
end
function setCheckboxText(el, text)
  if tonumber(el) and guiElements[el] then
    if guiElements[el].type == "checkbox" then
      guiElements[el].text = text
    else
      throwGuiError("setCheckboxText: guiElement is not checkbox")
    end
  else
    throwGuiError("setCheckboxText: invalid guiElement")
  end
end
function isCheckboxChecked(el)
  if tonumber(el) and guiElements[el] then
    if guiElements[el].type == "checkbox" then
      return guiElements[el].checked
    else
      throwGuiError("isCheckboxChecked: guiElement is not checkbox")
    end
  else
    throwGuiError("isCheckboxChecked: invalid guiElement")
  end
end
function setCheckboxChecked(el, state)
  if tonumber(el) and guiElements[el] then
    if guiElements[el].type == "checkbox" then
      guiElements[el].checked = state
    else
      throwGuiError("setCheckboxChecked: guiElement is not checkbox")
    end
  else
    throwGuiError("setCheckboxChecked: invalid guiElement")
  end
end
function setCheckboxHoverable(el, state)
  if tonumber(el) and guiElements[el] then
    if guiElements[el].type == "checkbox" then
      hoverList[el] = state
      if hoverList[el] then
        guiElements[el].activateEffect = 0
        guiElements[el].hoverAlpha = 0
        guiElements[el].hoverTime = defaultHoverTime
      else
        guiElements[el].activateEffect = false
        guiElements[el].hoverAlpha = false
        guiElements[el].hoverTime = false
        hoverList[el] = nil
      end
    else
      throwGuiError("setCheckboxHoverable: guiElement is not checkbox")
    end
  else
    throwGuiError("setCheckboxHoverable: invalid guiElement")
  end
end
