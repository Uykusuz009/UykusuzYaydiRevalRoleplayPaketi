local seelangStatImgHand = false
local seelangStaticImage = {}
local seelangStaticImageToc = {}
local seelangStaticImageUsed = {}
local seelangStaticImageDel = {}
local processSeelangStaticImage = {}
seelangStaticImageToc[0] = true
local seelangStatImgPre
function seelangStatImgPre()
  local now = getTickCount()
  if seelangStaticImageUsed[0] then
    seelangStaticImageUsed[0] = false
    seelangStaticImageDel[0] = false
  elseif seelangStaticImage[0] then
    if seelangStaticImageDel[0] then
      if now >= seelangStaticImageDel[0] then
        if isElement(seelangStaticImage[0]) then
          destroyElement(seelangStaticImage[0])
        end
        seelangStaticImage[0] = nil
        seelangStaticImageDel[0] = false
        seelangStaticImageToc[0] = true
        return
      end
    else
      seelangStaticImageDel[0] = now + 5000
    end
  else
    seelangStaticImageToc[0] = true
  end
  if seelangStaticImageToc[0] then
    seelangStatImgHand = false
    removeEventHandler("onClientPreRender", getRootElement(), seelangStatImgPre)
  end
end
processSeelangStaticImage[0] = function()
  if not isElement(seelangStaticImage[0]) then
    seelangStaticImageToc[0] = false
    seelangStaticImage[0] = dxCreateTexture("logo/v4/4.dds", "argb", true)
  end
  if not seelangStatImgHand then
    seelangStatImgHand = true
    addEventHandler("onClientPreRender", getRootElement(), seelangStatImgPre, true, "high+999999999")
  end
end
local seelangDynImgHand = false
local seelangDynImgLatCr = falselocal
seelangDynImage = {}
local seelangDynImageForm = {}
local seelangDynImageMip = {}
local seelangDynImageUsed = {}
local seelangDynImageDel = {}
local seelangDynImgPre
function seelangDynImgPre()
  local now = getTickCount()
  seelangDynImgLatCr = true
  local rem = true
  for k in pairs(seelangDynImage) do
    rem = false
    if seelangDynImageDel[k] then
      if now >= seelangDynImageDel[k] then
        if isElement(seelangDynImage[k]) then
          destroyElement(seelangDynImage[k])
        end
        seelangDynImage[k] = nil
        seelangDynImageForm[k] = nil
        seelangDynImageMip[k] = nil
        seelangDynImageDel[k] = nil
        break
      end
    elseif not seelangDynImageUsed[k] then
      seelangDynImageDel[k] = now + 5000
    end
  end
  for k in pairs(seelangDynImageUsed) do
    if not seelangDynImage[k] and seelangDynImgLatCr then
      seelangDynImgLatCr = false
      seelangDynImage[k] = dxCreateTexture(k, seelangDynImageForm[k], seelangDynImageMip[k])
    end
    seelangDynImageUsed[k] = nil
    seelangDynImageDel[k] = nil
    rem = false
  end
  if rem then
    removeEventHandler("onClientPreRender", getRootElement(), seelangDynImgPre)
    seelangDynImgHand = false
  end
end
local function dynamicImage(img, form, mip)
  if not seelangDynImgHand then
    seelangDynImgHand = true
    addEventHandler("onClientPreRender", getRootElement(), seelangDynImgPre, true, "high+999999999")
  end
  if not seelangDynImage[img] then
    seelangDynImage[img] = dxCreateTexture(img, form, mip)
  end
  seelangDynImageForm[img] = form
  seelangDynImageUsed[img] = true
  return seelangDynImage[img]
end
function playLogoAnimation(el, animType, animationTime)
  if tonumber(el) and guiElements[el] then
    if guiElements[el].type == "logo" then
      guiElements[el].logoAnimationType = animType
      if animType == "in" then
        guiElements[el].logoAnimations = {
          {
            now + animationTime * 0,
            animationTime
          },
          {
            now + animationTime * 1,
            animationTime
          },
          {
            now + animationTime * 2,
            animationTime
          },
          {
            now + animationTime * 3,
            animationTime
          },
          {
            now + animationTime * 4,
            animationTime * 3
          }
        }
      elseif animType == "out" then
        guiElements[el].logoAnimations = {
          {now, animationTime},
          {now, animationTime},
          {now, animationTime},
          {now, animationTime},
          {
            now,
            animationTime * 2
          }
        }
      elseif animType == "in-inv" then
        guiElements[el].logoAnimations = {
          {
            now + animationTime * 4,
            animationTime
          },
          {
            now + animationTime * 3,
            animationTime
          },
          {
            now + animationTime * 2,
            animationTime
          },
          {
            now + animationTime * 1,
            animationTime
          },
          {
            now + animationTime * 0,
            animationTime
          }
        }
      elseif animType == "hexa" then
        guiElements[el].logoAnimations = {
          {
            now + animationTime * 0,
            animationTime
          },
          false,
          false,
          false,
          false
        }
      elseif animType == "hexa2" then
        guiElements[el].logoAnimations = {
          {now, 0},
          {
            now + animationTime * 0,
            animationTime
          },
          {
            now + animationTime * 1,
            animationTime
          },
          {
            now + animationTime * 2,
            animationTime
          },
          {
            now + animationTime * 3,
            animationTime * 3
          }
        }
      end
    else
      throwGuiError("playLogoAnimation: guiElement it not logo")
    end
  else
    throwGuiError("playLogoAnimation: invalid guiElement")
  end
end
function setLogoAnimated(el, animated)
  if tonumber(el) and guiElements[el] then
    if guiElements[el].type == "logo" then
      guiElements[el].animatedLogo = animated
    else
      throwGuiError("setLogoAnimated: guiElement it not logo")
    end
  else
    throwGuiError("setLogoAnimated: invalid guiElement")
  end
end
function renderFunctions.logo(el)
  local fadeAlpha = 1
  if guiElements[el].fadeIn then
    local progress = getEasingValue(math.min(1, (now - guiElements[el].fadeIn) / guiElements[el].fadeInTime), "InOutQuad")
    fadeAlpha = progress
    guiElements[el].faded = false
    if 1 <= progress then
      guiElements[el].fadeIn = false
    end
  end
  if guiElements[el].fadeOut then
    local progress = 1 - getEasingValue(math.min(1, (now - guiElements[el].fadeOut) / guiElements[el].fadeOutTime), "InOutQuad")
    fadeAlpha = progress
    if progress <= 0 then
      guiElements[el].fadeOut = false
      guiElements[el].faded = true
    end
  end
  if guiElements[el].animatedLogo then
    if guiElements[el].logoAnimations then
      for k = 1, 5 do
        if guiElements[el].logoAnimations[k] then
          local progress = 1
          if 0 < guiElements[el].logoAnimations[k][2] then
            progress = math.min(math.max((now - guiElements[el].logoAnimations[k][1]) / guiElements[el].logoAnimations[k][2], 0), 1)
          end
          local alpha = 0
          local scale = 1.2
          if guiElements[el].logoAnimationType == "in" or guiElements[el].logoAnimationType == "hexa" or guiElements[el].logoAnimationType == "hexa2" then
            alpha, scale = interpolateBetween(0, 1.2, 0, 255, 1, 0, progress, "OutQuad")
          elseif guiElements[el].logoAnimationType == "out" or guiElements[el].logoAnimationType == "in-inv" then
            alpha, scale = interpolateBetween(255, 1, 0, 0, 1.2, 0, progress, "OutQuad")
          end
          dxDrawImage(guiElements[el].x - guiElements[el].sx / 2 * scale, guiElements[el].y - guiElements[el].sy / 2 * scale, guiElements[el].sx * scale, guiElements[el].sy * scale, dynamicImage("logo/v4/" .. k - 1 .. ".dds"), 0, 0, 0, tocolor(255, 255, 255, alpha * fadeAlpha))
        end
      end
    end
  else
    seelangStaticImageUsed[0] = true
    if seelangStaticImageToc[0] then
      processSeelangStaticImage[0]()
    end
    dxDrawImage(guiElements[el].x - guiElements[el].sx / 2, guiElements[el].y - guiElements[el].sy / 2, guiElements[el].sx, guiElements[el].sy, seelangStaticImage[0], 0, 0, 0, tocolor(255, 255, 255, 255 * fadeAlpha))
  end
end
