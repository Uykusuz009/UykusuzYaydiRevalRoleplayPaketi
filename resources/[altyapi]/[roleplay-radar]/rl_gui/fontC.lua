fontScaleCorrection = {
  ["Pixellari.ttf"] = 2,
  ["Impact.ttf"] = 2,
  ["SweetSixteen.ttf"] = 2,
  ["BebasNeueRegular.otf"] = 2,
  ["BebasNeueBold.otf"] = 2,
  ["BebasNeueLight.otf"] = 2,
  ["Ubuntu-R.ttf"] = 2,
  ["Ubuntu-L.ttf"] = 2,
  ["Ubuntu-LI.ttf"] = 2,
  ["Ubuntu-B.ttf"] = 2,
  ["W95FA.otf"] = 2,
  ["IckyticketMono-nKpJ.ttf"] = 2
}
fontResize = {
  ["Ubuntu-R.ttf"] = 0.9,
  ["Ubuntu-L.ttf"] = 0.9,
  ["Ubuntu-LI.ttf"] = 0.9,
  ["Ubuntu-B.ttf"] = 0.9
}
fontScales = {}
fontCorrection = {}
local fontCache = {}
function getTextWidthFont(text, font, scale, disableColor)
  if type(font) == "string" then
    font = getFont(font)
  end
  return dxGetTextWidth(text, (tonumber(fontScales[font]) or 1) * (tonumber(scale) or 1), font, not disableColor)
end
local fontHeightCache = {}
function getFontHeight(font, scale)
  if type(font) == "string" then
    font = getFont(font)
  end
  scale = tonumber(scale) or 1
  local name = tostring(font) .. "*" .. scale
  if not fontHeightCache[name] then
    fontHeightCache[name] = dxGetFontHeight((tonumber(fontScales[font]) or 1) * scale, font)
  end
  return fontHeightCache[name]
end
function getFontScale(font)
  if fontCache[font] then
    return fontScales[fontCache[font]]
  end
end
function getFont(font)
  if isElement(fontCache[font]) then
    return fontCache[font]
  end
  if utf8.find(font, ":") then
    local fontData = split(font, ":")
    if fontSchemes[fontData[1]] and fontSchemes[fontData[1]][fontData[2]] then
      return getFont(fontSchemes[fontData[1]][fontData[2]])
    end
  elseif utf8.find(font, "/") then
    local fontData = split(font, "/")
    if tonumber(fontData[1]) and not isElement(fontCache[font]) then
      local scale = (tonumber(fontScaleCorrection[fontData[2]]) or 1) * (tonumber(fontResize[fontData[2]]) or 1)
      fontCache[font] = dxCreateFont("fonts/" .. fontData[2], fontData[1] * scale, false, "antialiased")
      fontScales[fontCache[font]] = 1 / scale
    end
    return fontCache[font]
  end
end
