local faUnicodes = {}
addEventHandler("onClientResourceStart", getResourceRootElement(), function()
  local file = fileOpen("fa/icons.json")
  local count = fileGetSize(file)
  local data = fileRead(file, count)
  local tmp = fromJSON(data)
  fileClose(file)
  for k in pairs(tmp) do
    faUnicodes[k] = tmp[k].unicode
  end
  data = nil
  collectgarbage("collect")
end, true, "high+99999999999")
local faIconsList = {}
faIconsToRestore = {}
faTicks = {}
function writeDebugList(file, data)
  local hFile = false
  if fileExists(file .. ".list") then
    hFile = fileOpen(file .. ".list")
  else
    hFile = fileCreate(file .. ".list")
  end
  if hFile then
    fileSetPos(hFile, fileGetSize(hFile))
    fileWrite(hFile, data .. "\n")
    fileFlush(hFile)
    fileClose(hFile)
  end
end
faFonts = {}
local tick = 0
function getFaIconFilename(name, size, style, force, border, color, border2)
  if border or border2 then
    size = math.ceil(size)
  else
    size = convertSizeToP2(size)
  end
  style = style or "solid"
  if style == "solid" or style == "brands" or style == "regular" or style == "light" then
    if faUnicodes[name] then
      local fileName = "faicons/" .. name .. "-" .. style .. "-" .. size
      if border then
        fileName = fileName .. "-b-" .. border
      end
      if border2 then
        fileName = fileName .. "-b2-" .. border2
      end
      if color then
        fileName = fileName .. "-c-" .. color
      end
      fileName = fileName .. ".png"
      if force and faTicks[fileName] and fileExists(fileName .. faTicks[fileName]) then
        fileDelete(fileName .. faTicks[fileName])
      end
      if not (not force and faTicks[fileName]) or not fileExists(fileName .. faTicks[fileName]) then
        tick = tick + 1
        faTicks[fileName] = tick
        doRefreshFaTicks = true
        if fileExists(fileName .. faTicks[fileName]) then
          fileDelete(fileName .. faTicks[fileName])
        end
        local rt = dxCreateRenderTarget(size, size, true)
        if not isElement(rt) then
          table.insert(faIconsToRestore, {
            name,
            size,
            style,
            border,
            color,
            border2
          })
          throwGuiError("getFaIconFilename: failed icon! (no rt)")
          return fileName
        end
        local fontSize = size
        if border or border2 then
          fontSize = size - 2
        end
        if not isElement(faFonts[style .. fontSize]) then
          faFonts[style .. fontSize] = dxCreateFont("fa/" .. style .. ".otf", 0.4375 * fontSize, false, "antialiased")
        end
        local font = faFonts[style .. fontSize]
        if not isElement(font) then
          table.insert(faIconsToRestore, {
            name,
            size,
            style,
            border,
            color,
            border2
          })
          throwGuiError("getFaIconFilename: failed icon! (no font)")
          destroyElement(rt)
          return fileName
        end
        dxSetRenderTarget(rt, true)
        dxSetBlendMode("modulate_add")
        if border then
          dxDrawText(utf8.char(tonumber("0x" .. faUnicodes[name])), 1, 1, size + 1, size + 1, border, 1, font, "center", "center")
        end
        if border2 then
          for bx = -1, 1, 2 do
            for by = -1, 1, 2 do
              dxDrawText(utf8.char(tonumber("0x" .. faUnicodes[name])), 0 + bx, 0 + by, size + bx, size + by, border2, 1, font, "center", "center")
            end
          end
        end
        dxDrawText(utf8.char(tonumber("0x" .. faUnicodes[name])), 0, 0, size, size, color or tocolor(255, 255, 255), 1, font, "center", "center")
        dxSetBlendMode("blend")
        dxSetRenderTarget()
        local pixels = dxGetTexturePixels(rt)
        destroyElement(rt)
        if not pixels then
          table.insert(faIconsToRestore, {
            name,
            size,
            style,
            border,
            color,
            border2
          })
          throwGuiError("getFaIconFilename: failed icon! (1)")
        else
          local pixelCount = 0
          for x = 0, size - 1, 4 do
            for y = 0, size - 1, 4 do
              local r, g, b, a = dxGetPixelColor(pixels, x, y)
              pixelCount = pixelCount + a
              if 0 < pixelCount then
                break
              end
            end
          end
          if pixelCount == 0 then
            table.insert(faIconsToRestore, {
              name,
              size,
              style,
              border,
              color,
              border2
            })
            throwGuiError("getFaIconFilename: failed icon! (2)")
          end
          pixels = dxConvertPixels(pixels, "png")
          local fh = fileCreate(fileName .. faTicks[fileName])
          writeFileList(fileName .. faTicks[fileName])
          fileWrite(fh, pixels)
          fileClose(fh)
          if 0 < pixelCount then
            dxDrawImage(-10000, -10000, 1000, 100, fileName .. faTicks[fileName])
          end
          pixels = nil
          collectgarbage("collect")
        end
      end
      if not faIconsList[fileName] then
        faIconsList[fileName] = true
      end
      return fileName
    else
      throwGuiError("getFaIconFilename: invalid icon name (" .. name .. ")")
      return getFaIconFilename("times", size)
    end
  else
    throwGuiError("getFaIconFilename: invalid style")
    return getFaIconFilename("times", size)
  end
end
addEventHandler("onClientResourceStop", getResourceRootElement(), function()
  for k in pairs(faIconsList) do
    if faTicks[k] and fileExists(k .. faTicks[k]) then
      fileDelete(k .. faTicks[k])
    end
  end
end)
function getFaTicks()
  return faTicks
end
