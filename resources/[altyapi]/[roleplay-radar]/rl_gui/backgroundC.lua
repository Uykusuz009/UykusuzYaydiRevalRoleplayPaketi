function renderBackground(el)
  local x, y = guiElements[el].x, guiElements[el].y
  local sx, sy = guiElements[el].sx, guiElements[el].sy
  local fadeAlpha = 1
  if guiElements[el].fadeIn then
    fadeAlpha = getEasingValue(math.min(1, (now - guiElements[el].fadeIn) / guiElements[el].fadeInTime), "InOutQuad")
    guiElements[el].faded = false
    if 1 <= fadeAlpha then
      guiElements[el].fadeIn = false
    end
  end
  if guiElements[el].fadeOut then
    fadeAlpha = 1 - getEasingValue(math.min(1, (now - guiElements[el].fadeOut) / guiElements[el].fadeOutTime), "InOutQuad")
    if fadeAlpha <= 0 then
      guiElements[el].fadeOut = false
      guiElements[el].faded = true
    end
  end
  if guiElements[el].backgroundAlpha then
    fadeAlpha = guiElements[el].backgroundAlpha
  end
  if not guiElements[el].faded then
    if guiElements[el].hoverAlpha and 0 < guiElements[el].hoverAlpha and not guiElements[el].hoverDisableSize then
      sx = sx + math.max(5, sx * 0.025) * (guiElements[el].hoverAlpha / 255)
      sy = sy + math.max(5, sy * 0.025) * (guiElements[el].hoverAlpha / 255)
      x = x - math.max(5, sx * 0.025) * (guiElements[el].hoverAlpha / 255) * 0.5
      y = y - math.max(5, sy * 0.025) * (guiElements[el].hoverAlpha / 255) * 0.5
    end
    if guiElements[el].activateEffect and 0 < guiElements[el].activateEffect and not guiElements[el].hoverDisableSize then
      sx = sx + math.max(5, sx * 0.05) * guiElements[el].activateEffect
      sy = sy + math.max(5, sy * 0.05) * guiElements[el].activateEffect
      x = x - math.max(5, sx * 0.05) * guiElements[el].activateEffect * 0.5
      y = y - math.max(5, sy * 0.05) * guiElements[el].activateEffect * 0.5
    end
    if guiElements[el].border then
      if fadeAlpha < 1 then
        dxDrawRectangle(x, y, sx, sy, bitReplace(guiElements[el].border, bitExtract(guiElements[el].border, 24, 8) * fadeAlpha, 24, 8))
      else
        dxDrawRectangle(x, y, sx, sy, guiElements[el].border)
      end
      x = x + guiElements[el].borderSize
      y = y + guiElements[el].borderSize
      sx = sx - guiElements[el].borderSize * 2
      sy = sy - guiElements[el].borderSize * 2
    end
    if guiElements[el].backgroundType == "solid" then
      if fadeAlpha < 1 then
        dxDrawRectangle(x, y, sx, sy, bitReplace(guiElements[el].background, bitExtract(guiElements[el].background, 24, 8) * fadeAlpha, 24, 8))
      else
        dxDrawRectangle(x, y, sx, sy, guiElements[el].background)
      end
    elseif guiElements[el].backgroundType == "gradient" then
      dxDrawImage(x, y, sx, sy, guiElements[el].background .. "." .. gradientTick[guiElements[el].background], 0, 0, 0, tocolor(255, 255, 255, fadeAlpha * 255))
    else
      dxDrawRectangle(x, y, sx, sy, tocolor(255, 0, 0, fadeAlpha * 255))
    end
    if guiElements[el].hoverAlpha and 0 < guiElements[el].hoverAlpha and guiElements[el].hoverType ~= "none" then
      if guiElements[el].hoverType == "solid" then
        if fadeAlpha < 1 then
          dxDrawRectangle(x, y, sx, sy, bitReplace(guiElements[el].hover, bitExtract(guiElements[el].hover, 24, 8) / 255 * guiElements[el].hoverAlpha * fadeAlpha, 24, 8))
        else
          dxDrawRectangle(x, y, sx, sy, guiElements[el].hover)
        end
      elseif guiElements[el].hoverType == "gradient" then
        dxDrawImage(x, y, sx, sy, guiElements[el].hover .. "." .. gradientTick[guiElements[el].hover], 0, 0, 0, tocolor(255, 255, 255, guiElements[el].hoverAlpha * fadeAlpha))
      else
        dxDrawRectangle(x, y, sx, sy, tocolor(0, 255, 0, guiElements[el].hoverAlpha * fadeAlpha))
      end
    end
  end
end
function setGuiBackgroundAlpha(el, alpha)
  if tonumber(el) and guiElements[el] then
    guiElements[el].backgroundAlpha = alpha
  else
    throwGuiError("setGuiBackgroundAlpha: invalid guiElement (" .. tostring(el) .. ")")
  end
end
function setGuiBackgroundBorder(el, size, color)
  if tonumber(el) and guiElements[el] then
    if tonumber(size) then
      guiElements[el].borderSize = size
      setElementColorToData(el, "border", color)
    else
      guiElements[el].border = nil
    end
  else
    throwGuiError("setGuiBackgroundBorder: invalid guiElement (" .. tostring(el) .. ")")
  end
end
