function renderFunctions.label(el)
  if guiElements[el].text then
    local color = guiElements[el].fontColor or tocolor(255, 255, 255)
    local shadowColor = guiElements[el].shadow or tocolor(255, 255, 255)
    if guiElements[el].fadeIn then
      local progress = getEasingValue(math.min(1, (now - guiElements[el].fadeIn) / guiElements[el].fadeInTime), "InOutQuad")
      color = bitReplace(color, bitExtract(color, 24, 8) * progress, 24, 8)
      shadowColor = bitReplace(shadowColor, bitExtract(shadowColor, 24, 8) * progress, 24, 8)
      guiElements[el].faded = false
      if 1 <= progress then
        guiElements[el].fadeIn = false
      end
    end
    if guiElements[el].fadeOut then
      local progress = 1 - getEasingValue(math.min(1, (now - guiElements[el].fadeOut) / guiElements[el].fadeOutTime), "InOutQuad")
      color = bitReplace(color, bitExtract(color, 24, 8) * progress, 24, 8)
      shadowColor = bitReplace(shadowColor, bitExtract(shadowColor, 24, 8) * progress, 24, 8)
      if progress <= 0 then
        guiElements[el].fadeOut = false
        guiElements[el].faded = true
      end
    end
    if not guiElements[el].faded then
      if guiElements[el].shadow then
        if guiElements[el].clip then
          dxDrawText(guiElements[el].text, guiElements[el].x + guiElements[el].shadowX, guiElements[el].y + guiElements[el].shadowY, guiElements[el].x + guiElements[el].sx + guiElements[el].shadowX, guiElements[el].y + guiElements[el].sy + guiElements[el].shadowY, shadowColor, fontScales[guiElements[el].font] or 0.5, guiElements[el].font, guiElements[el].al1 or "center", guiElements[el].al2 or "center", true, false, false, false, false, guiElements[el].rotation)
        else
          dxDrawText(guiElements[el].text, guiElements[el].x + guiElements[el].shadowX, guiElements[el].y + guiElements[el].shadowY, guiElements[el].x + guiElements[el].sx + guiElements[el].shadowX, guiElements[el].y + guiElements[el].sy + guiElements[el].shadowY, shadowColor, fontScales[guiElements[el].font] or 0.5, guiElements[el].font, guiElements[el].al1 or "center", guiElements[el].al2 or "center", false, guiElements[el].wordBreak, false, not guiElements[el].wordBreak, false, guiElements[el].rotation)
        end
      end
      if guiElements[el].clip then
        dxDrawText(guiElements[el].text, guiElements[el].x, guiElements[el].y, guiElements[el].x + guiElements[el].sx, guiElements[el].y + guiElements[el].sy, color, fontScales[guiElements[el].font] or 0.5, guiElements[el].font, guiElements[el].al1 or "center", guiElements[el].al2 or "center", true, false, false, false, false, guiElements[el].rotation)
      else
        dxDrawText(guiElements[el].text, guiElements[el].x, guiElements[el].y, guiElements[el].x + guiElements[el].sx, guiElements[el].y + guiElements[el].sy, color, fontScales[guiElements[el].font] or 0.5, guiElements[el].font, guiElements[el].al1 or "center", guiElements[el].al2 or "center", false, guiElements[el].wordBreak, false, not guiElements[el].wordBreak, false, guiElements[el].rotation)
      end
      if guiElements[el].hoverAlpha and 0 < guiElements[el].hoverAlpha then
        local ulX, ulY = 0, 0
        if not guiElements[el].al1 or guiElements[el].al1 == "center" then
          ulX = guiElements[el].x + guiElements[el].sx / 2 - guiElements[el].textWidth / 2
        elseif guiElements[el].al1 == "left" then
          ulX = guiElements[el].x
        elseif guiElements[el].al1 == "right" then
          ulX = guiElements[el].x + guiElements[el].sx - guiElements[el].textWidth
        end
        if not guiElements[el].al2 or guiElements[el].al2 == "center" then
          ulY = guiElements[el].y + guiElements[el].sy / 2 + guiElements[el].fontHeight / 2
        elseif guiElements[el].al2 == "top" then
          ulY = guiElements[el].y + guiElements[el].fontHeight
        elseif guiElements[el].al2 == "bottom" then
          ulY = guiElements[el].y + guiElements[el].sy
        end
        local w = guiElements[el].textWidth
        if guiElements[el].clip then
          w = math.min(w, guiElements[el].sx)
        end
        dxDrawRectangle(ulX, ulY, w, 1, bitReplace(color, guiElements[el].hoverAlpha, 24, 8))
      end
    end
  end
end
function setLabelRotation(el, rotation)
  if tonumber(el) and guiElements[el] then
    if guiElements[el].type == "label" then
      guiElements[el].rotation = rotation
    else
      throwGuiError("setLabelRotation: guiElement is not label")
    end
  else
    throwGuiError("setLabelRotation: invalid guiElement (" .. tostring(el) .. ")")
  end
end
function setLabelClip(el, state)
  if tonumber(el) and guiElements[el] then
    if guiElements[el].type == "label" then
      guiElements[el].clip = state
    else
      throwGuiError("setLabelClip: guiElement is not label")
    end
  else
    throwGuiError("setLabelClip: invalid guiElement")
  end
end
function setLabelWordBreak(el, state)
  if tonumber(el) and guiElements[el] then
    if guiElements[el].type == "label" then
      guiElements[el].wordBreak = state
    else
      throwGuiError("setLabelWordBreak: guiElement is not label")
    end
  else
    throwGuiError("setLabelWordBreak: invalid guiElement")
  end
end
function setLabelAlignment(el, al1, al2)
  if tonumber(el) and guiElements[el] then
    if guiElements[el].type == "label" then
      if al1 then
        guiElements[el].al1 = al1
      end
      if al2 then
        guiElements[el].al2 = al2
      end
    else
      throwGuiError("setLabelAlignment: guiElement is not label")
    end
  else
    throwGuiError("setLabelAlignment: invalid guiElement")
  end
end
function setLabelShadow(el, color, x, y)
  if tonumber(el) and guiElements[el] then
    if guiElements[el].type == "label" then
      if color then
        setElementColorToData(el, "shadow", color)
        guiElements[el].shadowX = x
        guiElements[el].shadowY = y
      else
        setElementColorToData(el, "shadow", false)
        guiElements[el].shadow = false
      end
    else
      throwGuiError("setLabelShadow: guiElement is not label")
    end
  else
    throwGuiError("setLabelShadow: invalid guiElement")
  end
end
function setLabelFont(el, font)
  if tonumber(el) and guiElements[el] then
    if guiElements[el].type == "label" then
      guiElements[el].font = isElement(font) and font or getFont(font)
      if guiElements[el].text then
        guiElements[el].textWidth = getTextWidthFont(guiElements[el].text, guiElements[el].font)
      end
      guiElements[el].fontHeight = getFontHeight(guiElements[el].font)
    else
      throwGuiError("setLabelFont: guiElement is not label")
    end
  else
    throwGuiError("setLabelFont: invalid guiElement")
  end
end
function setLabelColor(el, color)
  if tonumber(el) and guiElements[el] then
    if guiElements[el].type == "label" then
      setElementColorToData(el, "fontColor", color)
    else
      throwGuiError("setLabelColor: guiElement is not label")
    end
  else
    throwGuiError("setLabelColor: invalid guiElement")
  end
end
function setLabelText(el, text)
  if tonumber(el) and guiElements[el] then
    if guiElements[el].type == "label" then
      guiElements[el].ot = text
      guiElements[el].text = utf8.gsub(guiElements[el].ot, "%[color%=([a-zA-Z1-9]*)%]", function(color)
        return getColorCodeHex(color)
      end)
      guiElements[el].textWidth = getTextWidthFont(guiElements[el].text, guiElements[el].font)
    else
      throwGuiError("setLabelText: guiElement is not label")
    end
  else
    throwGuiError("setLabelText: invalid guiElement")
  end
end
addEvent("onGuiRefreshColors", true)
addEventHandler("onGuiRefreshColors", getRootElement(), function()
  for k = 1, #renderList do
    if renderList[k] and guiElements[renderList[k]].type == "label" then
      local el = renderList[k]
      guiElements[el].text = utf8.gsub(guiElements[el].ot, "%[color%=([a-zA-Z1-9]*)%]", function(color)
        return getColorCodeHex(color)
      end)
    end
  end
end)
function getLabelFontHeight(el)
  if tonumber(el) and guiElements[el] then
    if guiElements[el].type == "label" then
      guiElements[el].fontHeight = getFontHeight(guiElements[el].font)
      return guiElements[el].fontHeight
    else
      throwGuiError("getLabelFontHeight: guiElement is not label")
    end
  else
    throwGuiError("getLabelFontHeight: invalid guiElement")
  end
end
function getLabelTextWidth(el)
  if tonumber(el) and guiElements[el] then
    if guiElements[el].type == "label" then
      if guiElements[el].text then
        guiElements[el].textWidth = getTextWidthFont(guiElements[el].text, guiElements[el].font)
        return guiElements[el].textWidth
      else
        return 0
      end
    else
      throwGuiError("getLabelTextWidht: guiElement is not label")
    end
  else
    throwGuiError("getLabelTextWidht: invalid guiElement")
  end
end
