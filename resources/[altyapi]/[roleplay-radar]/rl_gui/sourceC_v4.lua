local seexports = {
    rl_gui = false,
    rl_radar = false,
    rl_administration = false
  }
  local function seelangProcessExports()
    for k in pairs(seexports) do
      local res = getResourceFromName(k)
      if res and getResourceState(res) == "running" then
        seexports[k] = exports[k]
      else
        seexports[k] = false
      end
    end
  end
  seelangProcessExports()
  if triggerServerEvent then
    addEventHandler("onClientResourceStart", getRootElement(), seelangProcessExports, true, "high+9999999999")
  end
  if triggerClientEvent then
    addEventHandler("onResourceStart", getRootElement(), seelangProcessExports, true, "high+9999999999")
  end
  local seelangStatImgHand = false
  local seelangStaticImage = {}
  local seelangStaticImageToc = {}
  local seelangStaticImageUsed = {}
  local seelangStaticImageDel = {}
  local processSeelangStaticImage = {}
  seelangStaticImageToc[0] = true
  seelangStaticImageToc[1] = true
  seelangStaticImageToc[2] = true
  seelangStaticImageToc[3] = true
  seelangStaticImageToc[4] = true
  seelangStaticImageToc[5] = true
  seelangStaticImageToc[6] = true
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
    if seelangStaticImageUsed[1] then
      seelangStaticImageUsed[1] = false
      seelangStaticImageDel[1] = false
    elseif seelangStaticImage[1] then
      if seelangStaticImageDel[1] then
        if now >= seelangStaticImageDel[1] then
          if isElement(seelangStaticImage[1]) then
            destroyElement(seelangStaticImage[1])
          end
          seelangStaticImage[1] = nil
          seelangStaticImageDel[1] = false
          seelangStaticImageToc[1] = true
          return
        end
      else
        seelangStaticImageDel[1] = now + 5000
      end
    else
      seelangStaticImageToc[1] = true
    end
    if seelangStaticImageUsed[2] then
      seelangStaticImageUsed[2] = false
      seelangStaticImageDel[2] = false
    elseif seelangStaticImage[2] then
      if seelangStaticImageDel[2] then
        if now >= seelangStaticImageDel[2] then
          if isElement(seelangStaticImage[2]) then
            destroyElement(seelangStaticImage[2])
          end
          seelangStaticImage[2] = nil
          seelangStaticImageDel[2] = false
          seelangStaticImageToc[2] = true
          return
        end
      else
        seelangStaticImageDel[2] = now + 5000
      end
    else
      seelangStaticImageToc[2] = true
    end
    if seelangStaticImageUsed[3] then
      seelangStaticImageUsed[3] = false
      seelangStaticImageDel[3] = false
    elseif seelangStaticImage[3] then
      if seelangStaticImageDel[3] then
        if now >= seelangStaticImageDel[3] then
          if isElement(seelangStaticImage[3]) then
            destroyElement(seelangStaticImage[3])
          end
          seelangStaticImage[3] = nil
          seelangStaticImageDel[3] = false
          seelangStaticImageToc[3] = true
          return
        end
      else
        seelangStaticImageDel[3] = now + 5000
      end
    else
      seelangStaticImageToc[3] = true
    end
    if seelangStaticImageUsed[4] then
      seelangStaticImageUsed[4] = false
      seelangStaticImageDel[4] = false
    elseif seelangStaticImage[4] then
      if seelangStaticImageDel[4] then
        if now >= seelangStaticImageDel[4] then
          if isElement(seelangStaticImage[4]) then
            destroyElement(seelangStaticImage[4])
          end
          seelangStaticImage[4] = nil
          seelangStaticImageDel[4] = false
          seelangStaticImageToc[4] = true
          return
        end
      else
        seelangStaticImageDel[4] = now + 5000
      end
    else
      seelangStaticImageToc[4] = true
    end
    if seelangStaticImageUsed[5] then
      seelangStaticImageUsed[5] = false
      seelangStaticImageDel[5] = false
    elseif seelangStaticImage[5] then
      if seelangStaticImageDel[5] then
        if now >= seelangStaticImageDel[5] then
          if isElement(seelangStaticImage[5]) then
            destroyElement(seelangStaticImage[5])
          end
          seelangStaticImage[5] = nil
          seelangStaticImageDel[5] = false
          seelangStaticImageToc[5] = true
          return
        end
      else
        seelangStaticImageDel[5] = now + 5000
      end
    else
      seelangStaticImageToc[5] = true
    end
    if seelangStaticImageUsed[6] then
      seelangStaticImageUsed[6] = false
      seelangStaticImageDel[6] = false
    elseif seelangStaticImage[6] then
      if seelangStaticImageDel[6] then
        if now >= seelangStaticImageDel[6] then
          if isElement(seelangStaticImage[6]) then
            destroyElement(seelangStaticImage[6])
          end
          seelangStaticImage[6] = nil
          seelangStaticImageDel[6] = false
          seelangStaticImageToc[6] = true
          return
        end
      else
        seelangStaticImageDel[6] = now + 5000
      end
    else
      seelangStaticImageToc[6] = true
    end
    if seelangStaticImageToc[0] and seelangStaticImageToc[1] and seelangStaticImageToc[2] and seelangStaticImageToc[3] and seelangStaticImageToc[4] and seelangStaticImageToc[5] and seelangStaticImageToc[6] then
      seelangStatImgHand = false
      removeEventHandler("onClientPreRender", getRootElement(), seelangStatImgPre)
    end
  end
  processSeelangStaticImage[0] = function()
    if not isElement(seelangStaticImage[0]) then
      seelangStaticImageToc[0] = false
      seelangStaticImage[0] = dxCreateTexture("files/infocircle.dds", "argb", true)
    end
    if not seelangStatImgHand then
      seelangStatImgHand = true
      addEventHandler("onClientPreRender", getRootElement(), seelangStatImgPre, true, "high+999999999")
    end
  end
  processSeelangStaticImage[1] = function()
    if not isElement(seelangStaticImage[1]) then
      seelangStaticImageToc[1] = false
      seelangStaticImage[1] = dxCreateTexture("files/vignette.dds", "argb", true)
    end
    if not seelangStatImgHand then
      seelangStatImgHand = true
      addEventHandler("onClientPreRender", getRootElement(), seelangStatImgPre, true, "high+999999999")
    end
  end
  processSeelangStaticImage[2] = function()
    if not isElement(seelangStaticImage[2]) then
      seelangStaticImageToc[2] = false
      seelangStaticImage[2] = dxCreateTexture("files/glowside.dds", "argb", true)
    end
    if not seelangStatImgHand then
      seelangStatImgHand = true
      addEventHandler("onClientPreRender", getRootElement(), seelangStatImgPre, true, "high+999999999")
    end
  end
  processSeelangStaticImage[3] = function()
    if not isElement(seelangStaticImage[3]) then
      seelangStaticImageToc[3] = false
      seelangStaticImage[3] = dxCreateTexture("files/glow.dds", "argb", true)
    end
    if not seelangStatImgHand then
      seelangStatImgHand = true
      addEventHandler("onClientPreRender", getRootElement(), seelangStatImgPre, true, "high+999999999")
    end
  end
  processSeelangStaticImage[4] = function()
    if not isElement(seelangStaticImage[4]) then
      seelangStaticImageToc[4] = false
      seelangStaticImage[4] = dxCreateTexture("logo/v4/4.dds", "argb", true)
    end
    if not seelangStatImgHand then
      seelangStatImgHand = true
      addEventHandler("onClientPreRender", getRootElement(), seelangStatImgPre, true, "high+999999999")
    end
  end
  processSeelangStaticImage[5] = function()
    if not isElement(seelangStaticImage[5]) then
      seelangStaticImageToc[5] = false
      seelangStaticImage[5] = dxCreateTexture("cursor/move.dds", "argb", true)
    end
    if not seelangStatImgHand then
      seelangStatImgHand = true
      addEventHandler("onClientPreRender", getRootElement(), seelangStatImgPre, true, "high+999999999")
    end
  end
  processSeelangStaticImage[6] = function()
    if not isElement(seelangStaticImage[6]) then
      seelangStaticImageToc[6] = false
      seelangStaticImage[6] = dxCreateTexture("cursor/link.dds", "argb", true)
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
  local seelangBlankTex = dxCreateTexture(1, 1)
  local function latentDynamicImage(img, form, mip)
    if not seelangDynImgHand then
      seelangDynImgHand = true
      addEventHandler("onClientPreRender", getRootElement(), seelangDynImgPre, true, "high+999999999")
    end
    seelangDynImageForm[img] = form
    seelangDynImageMip[img] = mip
    seelangDynImageUsed[img] = true
    return seelangDynImage[img] or seelangBlankTex
  end
  local resetDynamicImage = function(img)
    if isElement(seelangDynImage[img]) then
      destroyElement(seelangDynImage[img])
    end
    seelangDynImage[img] = nil
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
  local seelangCondHandlState3 = false
  local function seelangCondHandl3(cond, prio)
    cond = cond and true or false
    if cond ~= seelangCondHandlState3 then
      seelangCondHandlState3 = cond
      if cond then
        addEventHandler("onClientClick", getRootElement(), ddsPreviewClick, true, prio)
      else
        removeEventHandler("onClientClick", getRootElement(), ddsPreviewClick)
      end
    end
  end
  local seelangCondHandlState2 = false
  local function seelangCondHandl2(cond, prio)
    cond = cond and true or false
    if cond ~= seelangCondHandlState2 then
      seelangCondHandlState2 = cond
      if cond then
        addEventHandler("onClientKey", getRootElement(), ddsPreviewZoomKey, true, prio)
      else
        removeEventHandler("onClientKey", getRootElement(), ddsPreviewZoomKey)
      end
    end
  end
  local seelangCondHandlState1 = false
  local function seelangCondHandl1(cond, prio)
    cond = cond and true or false
    if cond ~= seelangCondHandlState1 then
      seelangCondHandlState1 = cond
      if cond then
        addEventHandler("onClientCursorMove", getRootElement(), ddsPreviewCursor, true, prio)
      else
        removeEventHandler("onClientCursorMove", getRootElement(), ddsPreviewCursor)
      end
    end
  end
  local seelangCondHandlState0 = false
  local function seelangCondHandl0(cond, prio)
    cond = cond and true or false
    if cond ~= seelangCondHandlState0 then
      seelangCondHandlState0 = cond
      if cond then
        addEventHandler("onClientKey", getRootElement(), enterTriggerKey, true, prio)
      else
        removeEventHandler("onClientKey", getRootElement(), enterTriggerKey)
      end
    end
  end
  screenX, screenY = guiGetScreenSize()
  now = 0
  local togCursorState = false
  addEvent("onGuiRefreshColors", false)
  addEvent("refreshGradientTick", false)
  addEvent("refreshFaTicks", false)
  titleBarHeight = 36
  function getTitleBarHeight()
    return titleBarHeight
  end
  guiElements = {}
  lastGuiElement = false
  defaultHoverTime = 100
  hoverElement = false
  renderFunctions = {}
  local enterTrigger = false
  cx, cy = 0, 0
  renderList = {}
  hoverList = {}
  local hoverables = {
    button = true,
    input = true,
    checkbox = true,
    slider = true,
    toggle = true,
    window = true
  }
  local currentColorSet = 1
  local colorSets = {}
  function convertSizeToP2(size)
    local size = size or 36
    if 256 <= size then
      return math.ceil(size)
    else
      for i = 0, 8 do
        local p2 = math.pow(2, i)
        if size <= p2 then
          return p2
        end
      end
    end
  end
  function playUISound(f)
    if f == "click" then
      f = "click" .. math.random(1, 3)
    end
    local s = playSound("sounds/" .. f .. ".wav")
    setSoundVolume(s, 1)
  end
  table.insert(colorSets, {
    name = "V4Mod",
    hudwhite = {
      255,
      255,
      255
    },
    v4grey1 = {
      26,
      27,
      31
    },
    v4grey2 = {
      35,
      39,
      42
    },
    v4grey2a = {
      35,
      39,
      42,
      125
    },
    v4grey3 = {
      51,
      53,
      61
    },
    v4grey4 = {
      30,
      33,
      36
    },
    v4midgrey = {
      84,
      86,
      93
    },
    v4lightgrey = {
      186,
      190,
      196
    },
    v4green = {
      84, 
      134, 
      135
    },
    ["v4green-second"] = {
      94,
      150,
      151
    },
    v4red = {
      243,
      90,
      90
    },
    ["v4red-second"] = {
      250,
      120,
      95
    },
    v4blue = {
      49,
      154,
      215
    },
    ["v4blue-second"] = {
      49,
      180,
      225
    },
    v4yellow = {
      243,
      214,
      90
    },
    ["v4yellow-second"] = {
      250,
      240,
      130
    },
    v4orange = {
      255,
      149,
      20
    },
    ["v4orange-second"] = {
      250,
      179,
      40
    },
    v4purple = {
      148,
      60,
      184
    },
    ["v4purple-second"] = {
      182,
      76,
      226
    }
  })
  table.insert(colorSets, {
    name = "V4Mod v4 Élénk",
    v4green = {
      0,
      188,
      76
    },
    ["v4green-second"] = {
      44,
      229,
      122
    },
    v4red = {
      195,
      22,
      32
    },
    ["v4red-second"] = {
      233,
      58,
      69
    },
    v4blue = {
      0,
      84,
      187
    },
    ["v4blue-second"] = {
      50,
      142,
      226
    },
    v4yellow = {
      217,
      202,
      28
    },
    ["v4yellow-second"] = {
      236,
      227,
      107
    },
    v4orange = {
      239,
      130,
      19
    },
    ["v4orange-second"] = {
      249,
      170,
      45
    },
    v4purple = {
      148,
      60,
      184
    },
    ["v4purple-second"] = {
      182,
      76,
      226
    },
    v4grey1 = {
      23,
      25,
      24
    },
    v4grey2 = {
      33,
      35,
      36
    },
    v4grey3 = {
      49,
      52,
      53
    },
    v4grey4 = {
      28,
      29,
      29
    },
    v4midgrey = {
      82,
      87,
      89
    },
    v4lightgrey = {
      192,
      203,
      206
    },
    hudwhite = {
      243,
      250,
      254
    }
  })
  table.insert(colorSets, {
    name = "V4Mod v3",
    v4green = {
      124,
      197,
      118
    },
    ["v4green-second"] = {
      144,
      217,
      138
    },
    v4red = {
      215,
      89,
      89
    },
    ["v4red-second"] = {
      235,
      109,
      109
    },
    v4blue = {
      89,
      142,
      215
    },
    ["v4blue-second"] = {
      50,
      179,
      239
    },
    v4yellow = {
      235,
      230,
      89
    },
    ["v4yellow-second"] = {
      231,
      228,
      122
    },
    v4orange = {
      255,
      150,
      0
    },
    ["v4orange-second"] = {
      255,
      180,
      20
    },
    v4purple = {
      148,
      60,
      184
    },
    ["v4purple-second"] = {
      182,
      76,
      226
    },
    v4grey1 = {
      0,
      0,
      0
    },
    v4grey2 = {
      30,
      30,
      30
    },
    v4grey3 = {
      50,
      50,
      50
    },
    v4grey4 = {
      40,
      40,
      40
    },
    v4midgrey = {
      80,
      80,
      80
    },
    v4lightgrey = {
      180,
      180,
      180
    },
    hudwhite = {
      255,
      255,
      255
    }
  })
  table.insert(colorSets, {
    name = "V4Mod v2",
    v4green = {
      172,
      211,
      115
    },
    ["v4green-second"] = {
      192,
      231,
      135
    },
    v4red = {
      220,
      20,
      60
    },
    ["v4red-second"] = {
      240,
      40,
      80
    },
    v4blue = {
      74,
      171,
      208
    },
    ["v4blue-second"] = {
      94,
      191,
      228
    },
    v4yellow = {
      197,
      195,
      118
    },
    ["v4yellow-second"] = {
      217,
      215,
      138
    },
    v4orange = {
      255,
      165,
      0
    },
    ["v4orange-second"] = {
      255,
      185,
      20
    },
    v4purple = {
      148,
      60,
      184
    },
    ["v4purple-second"] = {
      182,
      76,
      226
    },
    v4grey1 = {
      0,
      0,
      0
    },
    v4grey2 = {
      30,
      30,
      30
    },
    v4grey3 = {
      50,
      50,
      50
    },
    v4grey4 = {
      40,
      40,
      40
    },
    v4midgrey = {
      80,
      80,
      80
    },
    v4lightgrey = {
      180,
      180,
      180
    },
    hudwhite = {
      255,
      255,
      255
    }
  })
  table.insert(colorSets, {
    name = "Élénk kontraszt",
    v4green = {
      123,
      192,
      67
    },
    ["v4green-second"] = {
      174,
      232,
      98
    },
    v4red = {
      238,
      64,
      53
    },
    ["v4red-second"] = {
      251,
      93,
      77
    },
    v4blue = {
      4,
      146,
      207
    },
    ["v4blue-second"] = {
      6,
      198,
      240
    },
    v4yellow = {
      253,
      244,
      152
    },
    ["v4yellow-second"] = {
      255,
      253,
      203
    },
    v4orange = {
      243,
      119,
      54
    },
    ["v4orange-second"] = {
      253,
      169,
      79
    },
    v4purple = {
      148,
      60,
      184
    },
    ["v4purple-second"] = {
      182,
      76,
      226
    },
    v4grey1 = {
      0,
      0,
      0
    },
    v4grey2 = {
      30,
      30,
      30
    },
    v4grey3 = {
      50,
      50,
      50
    },
    v4grey4 = {
      40,
      40,
      40
    },
    v4midgrey = {
      80,
      80,
      80
    },
    v4lightgrey = {
      180,
      180,
      180
    },
    hudwhite = {
      255,
      255,
      255
    }
  })
  table.insert(colorSets, {
    name = "New 1",
    v4green = {
      91,
      194,
      54
    },
    ["v4green-second"] = {
      121,
      209,
      90
    },
    v4red = {
      214,
      46,
      58
    },
    ["v4red-second"] = {
      208,
      72,
      72
    },
    v4blue = {
      54,
      136,
      194
    },
    ["v4blue-second"] = {
      69,
      151,
      227
    },
    v4yellow = {
      220,
      218,
      48
    },
    ["v4yellow-second"] = {
      233,
      231,
      64
    },
    v4orange = {
      243,
      138,
      3
    },
    ["v4orange-second"] = {
      247,
      165,
      59
    },
    v4purple = {
      191,
      48,
      193
    },
    ["v4purple-second"] = {
      206,
      60,
      208
    },
    v4grey1 = {
      19,
      20,
      23
    },
    v4grey2 = {
      26,
      29,
      31
    },
    v4grey3 = {
      38,
      39,
      45
    },
    v4grey4 = {
      22,
      24,
      27
    },
    v4midgrey = {
      62,
      64,
      69
    },
    v4lightgrey = {
      138,
      141,
      145
    },
    hudwhite = {
      241,
      248,
      255
    }
  })
  table.insert(colorSets, {
    name = "New 2",
    v4green = {
      72,
      209,
      77
    },
    ["v4green-second"] = {
      109,
      218,
      113
    },
    v4red = {
      214,
      46,
      87
    },
    ["v4red-second"] = {
      208,
      72,
      99
    },
    v4blue = {
      54,
      136,
      203
    },
    ["v4blue-second"] = {
      69,
      151,
      231
    },
    v4yellow = {
      220,
      218,
      79
    },
    ["v4yellow-second"] = {
      233,
      231,
      92
    },
    v4orange = {
      243,
      138,
      41
    },
    ["v4orange-second"] = {
      247,
      165,
      88
    },
    v4purple = {
      178,
      57,
      191
    },
    ["v4purple-second"] = {
      193,
      69,
      204
    },
    v4grey1 = {
      18,
      21,
      24
    },
    v4grey2 = {
      26,
      30,
      33
    },
    v4grey3 = {
      38,
      42,
      47
    },
    v4grey4 = {
      23,
      26,
      29
    },
    v4midgrey = {
      62,
      67,
      74
    },
    v4lightgrey = {
      136,
      145,
      156
    },
    hudwhite = {
      244,
      248,
      250
    }
  })
  table.insert(colorSets, {
    name = "New 3",
    v4green = {
      84,
      215,
      40
    },
    ["v4green-second"] = {
      119,
      223,
      83
    },
    v4red = {
      215,
      40,
      40
    },
    ["v4red-second"] = {
      223,
      83,
      83
    },
    v4blue = {
      40,
      98,
      215
    },
    ["v4blue-second"] = {
      83,
      162,
      223
    },
    v4yellow = {
      243,
      229,
      11
    },
    ["v4yellow-second"] = {
      223,
      218,
      83
    },
    v4orange = {
      237,
      91,
      20
    },
    ["v4orange-second"] = {
      249,
      144,
      42
    },
    v4purple = {
      196,
      40,
      215
    },
    ["v4purple-second"] = {
      215,
      83,
      223
    },
    v4grey1 = {
      20,
      21,
      25
    },
    v4grey2 = {
      27,
      30,
      34
    },
    v4grey3 = {
      39,
      41,
      50
    },
    v4grey4 = {
      23,
      25,
      29
    },
    v4midgrey = {
      65,
      66,
      76
    },
    v4lightgrey = {
      143,
      147,
      160
    },
    hudwhite = {
      255,
      255,
      255
    }
  })
  table.insert(colorSets, {
    name = "New 4",
    v4green = {
      65,
      190,
      110
    },
    ["v4green-second"] = {
      103,
      203,
      139
    },
    v4red = {
      218,
      69,
      83
    },
    ["v4red-second"] = {
      228,
      86,
      99
    },
    v4blue = {
      51,
      154,
      202
    },
    ["v4blue-second"] = {
      53,
      163,
      214
    },
    v4yellow = {
      206,
      225,
      98
    },
    ["v4yellow-second"] = {
      223,
      240,
      125
    },
    v4orange = {
      232,
      139,
      55
    },
    ["v4orange-second"] = {
      241,
      156,
      78
    },
    v4purple = {
      202,
      69,
      218
    },
    ["v4purple-second"] = {
      212,
      93,
      226
    },
    v4grey1 = {
      26,
      27,
      31
    },
    v4grey2 = {
      35,
      39,
      42
    },
    v4grey3 = {
      51,
      53,
      61
    },
    v4grey4 = {
      30,
      33,
      36
    },
    v4midgrey = {
      84,
      86,
      93
    },
    v4lightgrey = {
      186,
      190,
      196
    },
    hudwhite = {
      255,
      255,
      255
    }
  })
  table.insert(colorSets, {
    name = "New 5",
    v4green = {
      127,
      188,
      82
    },
    ["v4green-second"] = {
      153,
      201,
      117
    },
    v4red = {
      208,
      58,
      79
    },
    ["v4red-second"] = {
      217,
      97,
      114
    },
    v4blue = {
      89,
      157,
      233
    },
    ["v4blue-second"] = {
      122,
      177,
      237
    },
    v4yellow = {
      218,
      217,
      94
    },
    ["v4yellow-second"] = {
      225,
      225,
      126
    },
    v4orange = {
      212,
      132,
      54
    },
    ["v4orange-second"] = {
      221,
      157,
      94
    },
    v4purple = {
      125,
      54,
      212
    },
    ["v4purple-second"] = {
      151,
      94,
      221
    },
    v4grey1 = {
      21,
      20,
      19
    },
    v4grey2 = {
      40,
      39,
      37
    },
    v4grey3 = {
      50,
      49,
      47
    },
    v4grey4 = {
      28,
      26,
      24
    },
    v4midgrey = {
      68,
      66,
      61
    },
    v4lightgrey = {
      191,
      189,
      184
    },
    hudwhite = {
      255,
      255,
      255
    }
  })
  local allColorNames = {
    "v4green",
    "v4green-second",
    "v4red",
    "v4red-second",
    "v4blue",
    "v4blue-second",
    "v4yellow",
    "v4yellow-second",
    "v4orange",
    "v4orange-second",
    "v4purple",
    "v4purple-second",
    "v4grey1",
    "v4grey2",
    "v4grey3",
    "v4grey4",
    "v4midgrey",
    "v4lightgrey",
    "hudwhite"
  }
  colors = colorSets[currentColorSet]
  colorsToColor = {}
  for k in pairs(colors) do
    colorsToColor[k] = tocolor(colors[k][1], colors[k][2], colors[k][3])
  end
  local gradientList = {}
  local gradientToRestore = {}
  local gradient2ToRestore = {}
  local gradient3ToRestore = {}
  local gradient4ToRestore = {}
  gradientTick = {}
  function getColorsForPreview(colorSet)
    if not tonumber(colorSet) or not colorSets[colorSet] then
      colorSet = currentColorSet
    end
    local colors = {}
    for k = 1, #allColorNames do
      colors[k] = colorSets[colorSet][allColorNames[k]]
    end
    return colors
  end
  function getColorsForPreviewEx(colorSet)
    if not tonumber(colorSet) or not colorSets[colorSet] then
      colorSet = currentColorSet
    end
    local colors = {}
    for k = 1, #allColorNames do
      colors[allColorNames[k]] = colorSets[colorSet][allColorNames[k]]
    end
    return colors
  end
  function getColorSetName(colorSet)
    return colorSets[colorSet].name
  end
  function getColorSetsCount()
    return #colorSets
  end
  function getColorSet()
    return currentColorSet
  end
  function setColorSet(id)
    if tonumber(id) and id ~= currentColorSet and colorSets[id] then
      currentColorSet = id
      colors = colorSets[currentColorSet]
      for k in pairs(colors) do
        colorsToColor[k] = tocolor(colors[k][1], colors[k][2], colors[k][3])
      end
      for k = 1, #renderList do
        if renderList[k] then
          local el = renderList[k]
          if guiElements[el] then
            for data, color in pairs(guiElements[el].toColorCache) do
              guiElements[el][data] = colorsToColor[color]
            end
            for data, color in pairs(guiElements[el].toColorTableCache) do
              guiElements[el][data] = colors[color]
            end
            for data, color in pairs(guiElements[el].gradientCache) do
              setElementGradientToData(el, data, color)
            end
          end
        end
      end
      for k in pairs(colors) do
        registerChatColor(k, colorsToColor[k])
      end
      setRefreshColors()
      return true
    end
  end
  addCommandHandler("colorset", function(cmd, id)
    id = tonumber(id)
    if id and colorSets[id] then
      setColorSet(id)
    end
  end)
  colorSchemes = {
    slider = {
      dark = {"v4grey1", "v4green"}
    },
    toggle = {
      dark = {
        "v4grey1",
        "v4red",
        "v4green"
      }
    },
    input = {
      dark = {
        "v4midgrey",
        "v4grey2",
        "v4grey4",
        "v4grey3",
        "v4lightgrey"
      }
    },
    checkbox = {
      dark = {
        "v4midgrey",
        "v4grey2",
        "v4green",
        "#ffffff"
      },
      ["dark-red"] = {
        "v4midgrey",
        "v4grey2",
        "v4red",
        "#ffffff"
      },
      ["dark-text-red"] = {
        "v4midgrey",
        "v4grey2",
        "v4red",
        "v4red"
      },
      ["dark-text-green"] = {
        "v4midgrey",
        "v4grey2",
        "v4green",
        "v4green"
      },
      darker = {
        "v4midgrey",
        "v4grey2",
        "v4green",
        "v4midgrey"
      }
    },
    button = {
      default = {
        {"solid", "v4green"},
        {"solid", "v4blue"},
        "#ffffff"
      },
      green = {
        {"solid", "v4green"},
        {
          "gradient",
          {
            "v4green",
            "v4green-second"
          }
        },
        "#ffffff"
      },
      red = {
        {"solid", "v4red"},
        {
          "gradient",
          {
            "v4red",
            "v4red-second"
          }
        },
        "#ffffff"
      },
      blue = {
        {"solid", "v4blue"},
        {
          "gradient",
          {
            "v4blue",
            "v4blue-second"
          }
        },
        "#ffffff"
      },
      yellow = {
        {"solid", "v4yellow"},
        {
          "gradient",
          {
            "v4yellow",
            "v4yellow-second"
          }
        },
        "#ffffff"
      }
    }
  }
  fontSchemes = {
    checkbox = {
      normal = "11/Ubuntu-L.ttf"
    },
    label = {
      normal = "11/Ubuntu-L.ttf"
    },
    input = {
      normal = "11/Ubuntu-L.ttf"
    },
    button = {
      small = "15/BebasNeueBold.otf",
      normal = "18/BebasNeueBold.otf",
      large = "22/BebasNeueBold.otf",
      xl = "26/BebasNeueBold.otf"
    }
  }
  sizeSchemes = {
    slider = {
      normal = {300, 14}
    },
    toggle = {
      normal = {28, 14}
    },
    checkbox = {
      normal = {300, 24}
    },
    label = {
      normal = {300, 38}
    },
    input = {
      normal = {300, 38}
    },
    button = {
      small = {300, 32},
      normal = {300, 38},
      large = {300, 50},
      xl = {300, 60}
    }
  }
  function setGuiFontScheme(el, scheme)
    if tonumber(el) and guiElements[el] then
      if fontSchemes[guiElements[el].type] then
        scheme = scheme or "normal"
        if fontSchemes[guiElements[el].type][scheme] then
          if guiElements[el].type == "input" then
            setInputFont(el, fontSchemes[guiElements[el].type][scheme])
          elseif guiElements[el].type == "button" then
            setButtonFont(el, fontSchemes[guiElements[el].type][scheme])
          elseif guiElements[el].type == "label" then
            setLabelFont(el, fontSchemes[guiElements[el].type][scheme])
          elseif guiElements[el].type == "checkbox" then
            setCheckboxFont(el, fontSchemes[guiElements[el].type][scheme])
          end
        else
          throwGuiError("setGuiFontScheme: invalid fontscheme (" .. tostring(scheme) .. ")")
        end
      end
    else
      throwGuiError("setGuiFontScheme: invalid guiElement (" .. tostring(el) .. ")")
    end
  end
  function setGuiColorScheme(el, scheme)
    if tonumber(el) and guiElements[el] then
      if colorSchemes[guiElements[el].type] then
        if not scheme then
          if colorSchemes[guiElements[el].type].default then
            scheme = "default"
          else
            for k in pairs(colorSchemes[guiElements[el].type]) do
              scheme = k
              break
            end
          end
        end
        if colorSchemes[guiElements[el].type][scheme] then
          if guiElements[el].type == "checkbox" then
            setCheckboxColor(el, colorSchemes[guiElements[el].type][scheme][1], colorSchemes[guiElements[el].type][scheme][2], colorSchemes[guiElements[el].type][scheme][3], colorSchemes[guiElements[el].type][scheme][4])
          elseif guiElements[el].type == "slider" then
            setSliderColor(el, colorSchemes[guiElements[el].type][scheme][1], colorSchemes[guiElements[el].type][scheme][2])
          elseif guiElements[el].type == "toggle" then
            setToggleColor(el, colorSchemes[guiElements[el].type][scheme][1], colorSchemes[guiElements[el].type][scheme][2], colorSchemes[guiElements[el].type][scheme][3])
          elseif guiElements[el].type == "input" then
            setInputColor(el, colorSchemes[guiElements[el].type][scheme][1], colorSchemes[guiElements[el].type][scheme][2], colorSchemes[guiElements[el].type][scheme][3], colorSchemes[guiElements[el].type][scheme][4], colorSchemes[guiElements[el].type][scheme][5])
          elseif guiElements[el].type == "button" then
            setGuiBackground(el, colorSchemes[guiElements[el].type][scheme][1][1], colorSchemes[guiElements[el].type][scheme][1][2])
            setGuiHover(el, colorSchemes[guiElements[el].type][scheme][2][1], colorSchemes[guiElements[el].type][scheme][2][2])
            setButtonTextColor(el, colorSchemes[guiElements[el].type][scheme][3])
          else
            setGuiBackground(el, colorSchemes[guiElements[el].type][scheme][1][1], colorSchemes[guiElements[el].type][scheme][1][2])
            if colorSchemes[guiElements[el].type][scheme][2] then
              setGuiHover(el, colorSchemes[guiElements[el].type][scheme][2][1], colorSchemes[guiElements[el].type][scheme][2][2])
            end
          end
        else
          throwGuiError("setGuiColorScheme: invalid colorscheme (" .. tostring(scheme) .. ")")
        end
      end
    else
      throwGuiError("setGuiColorScheme: invalid guiElement (" .. tostring(el) .. ")")
    end
  end
  local colorHexCache = {}
  function getColorHex(color)
    if colorHexCache[color] then
      return colorHexCache[color]
    end
    local r, g, b, a = getColorFromString(color)
    colorHexCache[color] = {
      r,
      g,
      b,
      a
    }
    return colorHexCache[color]
  end
  function getColorCode(color)
    if type(color) == "string" then
      if color:sub(1, 1) == "#" then
        return getColorHex(color)
      else
        return colors[color]
      end
    else
      return color
    end
  end
  function setElementColorTableToData(el, data, color)
    guiElements[el].toColorTableCache[data] = nil
    if type(color) == "string" then
      if color:sub(1, 1) == "#" then
        guiElements[el][data] = getColorHex(color)
      else
        guiElements[el].toColorTableCache[data] = color
        guiElements[el][data] = colors[color]
      end
    elseif type(color) == "table" then
      guiElements[el][data] = color
    end
  end
  function getColorSetCodeToColor(color, set)
    if type(color) == "string" then
      if color:sub(1, 1) == "#" then
        return getColorHex(color)
      else
        return tocolor(colorSets[set][color][1], colorSets[set][color][2], colorSets[set][color][3], colorSets[set][color][4])
      end
    elseif type(color) == "table" then
      return tocolor(color[1], color[2], color[3], color[4])
    else
      return color
    end
  end
  function getColorCodeToColor(color)
    if type(color) == "string" then
      if color:sub(1, 1) == "#" then
        local color = getColorHex(color)
        return tocolor(color[1], color[2], color[3], color[4])
      else
        return colorsToColor[color]
      end
    elseif type(color) == "table" then
      return tocolor(color[1], color[2], color[3], color[4])
    else
      return color
    end
  end
  function setElementColorToData(el, data, color)
    guiElements[el].toColorCache[data] = nil
    if type(color) == "string" then
      if color:sub(1, 1) == "#" then
        local color = getColorHex(color)
        guiElements[el][data] = tocolor(color[1], color[2], color[3], color[4])
      else
        guiElements[el].toColorCache[data] = color
        guiElements[el][data] = colorsToColor[color]
      end
    elseif type(color) == "table" then
      guiElements[el][data] = tocolor(color[1], color[2], color[3], color[4])
    end
  end
  function getColorCodeHex(color)
    local rgb = getColorCode(color)
    if rgb then
      rgb = rgb[1] * 65536 + rgb[2] * 256 + rgb[3]
      local hex = string.format("%x", rgb)
      for i = utf8.len(hex) + 1, 6 do
        hex = "0" .. hex
      end
      return "#" .. hex
    end
  end
  function getGradientTick()
    return gradientTick
  end
  local gTick = 0
  function getGradientFilename(sizeX, sizeY, fromColor, toColor, force)
    sizeX = convertSizeToP2(sizeX)
    sizeY = convertSizeToP2(sizeY)
    local fileName = "gradients/" .. sizeX .. "-" .. sizeY .. "-" .. table.concat(fromColor, "-") .. "-" .. table.concat(toColor, "-") .. ".png"
    if force and gradientTick[fileName] and fileExists(fileName .. "." .. gradientTick[fileName]) then
      fileDelete(fileName .. "." .. gradientTick[fileName])
    end
    if not (not force and gradientTick[fileName]) or not fileExists(fileName .. "." .. gradientTick[fileName]) then
      gTick = gTick + 1
      gradientTick[fileName] = gTick
      doRefreshGradTicks = true
      if fileExists(fileName .. "." .. gradientTick[fileName]) then
        fileDelete(fileName .. "." .. gradientTick[fileName])
      end
      local rt = dxCreateRenderTarget(sizeX, sizeY)
      if not isElement(rt) then
        table.insert(gradientToRestore, {
          sizeX,
          sizeY,
          fromColor,
          toColor
        })
        throwGuiError("getGradientFilename: failed grad! (no rt)")
        return fileName
      end
      dxSetRenderTarget(rt, true)
      dxSetBlendMode("modulate_add")
      for x = 0, sizeX do
        for y = 0, sizeY do
          local r, g, b = interpolateBetween(fromColor[1], fromColor[2], fromColor[3], toColor[1], toColor[2], toColor[3], (x / sizeX + y / sizeY) / 2, "Linear")
          dxDrawRectangle(x, y, 1, 1, tocolor(r, g, b))
        end
      end
      dxSetBlendMode("blend")
      dxSetRenderTarget()
      local pixels = dxGetTexturePixels(rt)
      destroyElement(rt)
      if not pixels then
        table.insert(gradientToRestore, {
          sizeX,
          sizeY,
          fromColor,
          toColor
        })
        throwGuiError("getGradientFilename: failed grad! (1)")
      else
        local r, g, b = dxGetPixelColor(pixels, 0, 0)
        local r2, g2, b2 = dxGetPixelColor(pixels, math.floor(sizeX / 2), math.floor(sizeY / 2))
        local r3, g3, b3 = dxGetPixelColor(pixels, sizeX - 1, sizeY - 1)
        if tonumber(r + g + b + r2 + g2 + b2 + r3 + b3 + g3) == 0 then
          table.insert(gradientToRestore, {
            sizeX,
            sizeY,
            fromColor,
            toColor
          })
          throwGuiError("getGradientFilename: failed grad! (2)")
        end
        pixels = dxConvertPixels(pixels, "png")
        local fh = fileCreate(fileName .. "." .. gradientTick[fileName])
        writeFileList(fileName .. "." .. gradientTick[fileName])
        fileWrite(fh, pixels)
        fileClose(fh)
        pixels = nil
        collectgarbage("collect")
      end
    end
    if not gradientList[fileName] then
      gradientList[fileName] = true
    end
    return fileName
  end
  function getGradient2Filename(sizeX, sizeY, fromColor, toColor, force)
    sizeX = convertSizeToP2(sizeX)
    sizeY = convertSizeToP2(sizeY)
    local sizeX = math.ceil(sizeX)
    local sizeY = math.ceil(sizeY)
    local fileName = "gradients2/" .. sizeX .. "-" .. sizeY .. "-" .. table.concat(fromColor, "-") .. "-" .. table.concat(toColor, "-") .. ".png"
    if force and gradientTick[fileName] and fileExists(fileName .. "." .. gradientTick[fileName]) then
      fileDelete(fileName .. "." .. gradientTick[fileName])
    end
    if not (not force and gradientTick[fileName]) or not fileExists(fileName .. "." .. gradientTick[fileName]) then
      gTick = gTick + 1
      gradientTick[fileName] = gTick
      doRefreshGradTicks = true
      if fileExists(fileName .. "." .. gradientTick[fileName]) then
        fileDelete(fileName .. "." .. gradientTick[fileName])
      end
      local rt = dxCreateRenderTarget(sizeX, sizeY)
      if not isElement(rt) then
        table.insert(gradient2ToRestore, {
          sizeX,
          sizeY,
          fromColor,
          toColor
        })
        throwGuiError("getGradient2Filename: failed grad! (no rt)")
        return fileName
      end
      dxSetRenderTarget(rt, true)
      dxSetBlendMode("modulate_add")
      for x = 0, sizeX do
        local progress = x / sizeX
        local r, g, b = fromColor[1], fromColor[2], fromColor[3]
        if 0.5 < progress then
          r, g, b = interpolateBetween(fromColor[1], fromColor[2], fromColor[3], toColor[1], toColor[2], toColor[3], (progress - 0.5) * 2, "Linear")
        else
          r, g, b = interpolateBetween(toColor[1], toColor[2], toColor[3], fromColor[1], fromColor[2], fromColor[3], progress * 2, "Linear")
        end
        dxDrawRectangle(x, 0, 1, sizeY, tocolor(r, g, b))
      end
      dxSetBlendMode("blend")
      dxSetRenderTarget()
      local pixels = dxGetTexturePixels(rt)
      destroyElement(rt)
      if not pixels then
        table.insert(gradient2ToRestore, {
          sizeX,
          sizeY,
          fromColor,
          toColor
        })
        throwGuiError("getGradient2Filename: failed grad! (1)")
      else
        local r, g, b = dxGetPixelColor(pixels, 0, 0)
        local r2, g2, b2 = dxGetPixelColor(pixels, math.floor(sizeX / 2), math.floor(sizeY / 2))
        local r3, g3, b3 = dxGetPixelColor(pixels, sizeX - 1, sizeY - 1)
        if tonumber(r + g + b + r2 + g2 + b2 + r3 + b3 + g3) == 0 then
          table.insert(gradient2ToRestore, {
            sizeX,
            sizeY,
            fromColor,
            toColor
          })
          throwGuiError("getGradient2Filename: failed grad! (2)")
        end
        pixels = dxConvertPixels(pixels, "png")
        local fh = fileCreate(fileName .. "." .. gradientTick[fileName])
        writeFileList(fileName .. "." .. gradientTick[fileName])
        fileWrite(fh, pixels)
        fileClose(fh)
        pixels = nil
        collectgarbage("collect")
      end
    end
    if not gradientList[fileName] then
      gradientList[fileName] = true
    end
    return fileName
  end
  function getGradient3Filename(sizeX, sizeY, fromColor, toColor, force)
    sizeX = convertSizeToP2(sizeX)
    sizeY = convertSizeToP2(sizeY)
    local fileName = "gradients3/" .. sizeX .. "-" .. sizeY .. "-" .. table.concat(fromColor, "-") .. "-" .. table.concat(toColor, "-") .. ".png"
    if force and gradientTick[fileName] and fileExists(fileName .. "." .. gradientTick[fileName]) then
      fileDelete(fileName .. "." .. gradientTick[fileName])
    end
    if not (not force and gradientTick[fileName]) or not fileExists(fileName .. "." .. gradientTick[fileName]) then
      gTick = gTick + 1
      gradientTick[fileName] = gTick
      doRefreshGradTicks = true
      if fileExists(fileName .. "." .. gradientTick[fileName]) then
        fileDelete(fileName .. "." .. gradientTick[fileName])
      end
      local rt = dxCreateRenderTarget(sizeX, sizeY)
      if not isElement(rt) then
        table.insert(gradient3ToRestore, {
          sizeX,
          sizeY,
          fromColor,
          toColor
        })
        throwGuiError("getGradient3Filename: failed grad! (no rt)")
        return fileName
      end
      dxSetRenderTarget(rt, true)
      dxSetBlendMode("modulate_add")
      for x = 1, sizeX do
        local progress = x / sizeX
        local r, g, b = fromColor[1], fromColor[2], fromColor[3]
        r, g, b = interpolateBetween(fromColor[1], fromColor[2], fromColor[3], toColor[1], toColor[2], toColor[3], progress, "Linear")
        dxDrawRectangle(x - 1, 0, 1, sizeY, tocolor(r, g, b))
      end
      dxSetBlendMode("blend")
      dxSetRenderTarget()
      local pixels = dxGetTexturePixels(rt)
      destroyElement(rt)
      if not pixels then
        table.insert(gradient3ToRestore, {
          sizeX,
          sizeY,
          fromColor,
          toColor
        })
        throwGuiError("getGradient3Filename: failed grad! (1)")
      else
        local r, g, b = dxGetPixelColor(pixels, 0, 0)
        local r2, g2, b2 = dxGetPixelColor(pixels, math.floor(sizeX / 2), math.floor(sizeY / 2))
        local r3, g3, b3 = dxGetPixelColor(pixels, sizeX - 1, sizeY - 1)
        if tonumber(r + g + b + r2 + g2 + b2 + r3 + b3 + g3) == 0 then
          table.insert(gradient3ToRestore, {
            sizeX,
            sizeY,
            fromColor,
            toColor
          })
          throwGuiError("getGradient3Filename: failed grad! (2)")
        end
        pixels = dxConvertPixels(pixels, "png")
        local fh = fileCreate(fileName .. "." .. gradientTick[fileName])
        writeFileList(fileName .. "." .. gradientTick[fileName])
        fileWrite(fh, pixels)
        fileClose(fh)
        pixels = nil
        collectgarbage("collect")
      end
    end
    if not gradientList[fileName] then
      gradientList[fileName] = true
    end
    return fileName
  end
  function getGradient4Filename(sizeX, sizeY, fromColor, force)
    sizeX = convertSizeToP2(sizeX)
    sizeY = convertSizeToP2(sizeY)
    local fileName = "gradients4/" .. sizeX .. "-" .. sizeY .. "-" .. table.concat(fromColor, "-") .. ".png"
    if force and gradientTick[fileName] and fileExists(fileName .. "." .. gradientTick[fileName]) then
      fileDelete(fileName .. "." .. gradientTick[fileName])
    end
    if not (not force and gradientTick[fileName]) or not fileExists(fileName .. "." .. gradientTick[fileName]) then
      gTick = gTick + 1
      gradientTick[fileName] = gTick
      doRefreshGradTicks = true
      if fileExists(fileName .. "." .. gradientTick[fileName]) then
        fileDelete(fileName .. "." .. gradientTick[fileName])
      end
      local rt = dxCreateRenderTarget(sizeX, sizeY, true)
      if not isElement(rt) then
        table.insert(gradient4ToRestore, {
          sizeX,
          sizeY,
          fromColor
        })
        throwGuiError("getGradient4Filename: failed grad! (no rt)")
        return fileName
      end
      dxSetRenderTarget(rt, true)
      dxSetBlendMode("modulate_add")
      for y = 1, sizeY do
        local progress = y / sizeY
        dxDrawRectangle(0, y - 1, sizeX, 1, tocolor(fromColor[1], fromColor[2], fromColor[3], progress * 255))
      end
      dxSetBlendMode("blend")
      dxSetRenderTarget()
      local pixels = dxGetTexturePixels(rt)
      destroyElement(rt)
      if not pixels then
        table.insert(gradient4ToRestore, {
          sizeX,
          sizeY,
          fromColor
        })
        throwGuiError("getGradient4Filename: failed grad 1!")
      else
        local r, g, b = dxGetPixelColor(pixels, 0, 0)
        local r2, g2, b2 = dxGetPixelColor(pixels, math.floor(sizeX / 2), math.floor(sizeY / 2))
        local r3, g3, b3 = dxGetPixelColor(pixels, sizeX - 1, sizeY - 1)
        if tonumber(r + g + b + r2 + g2 + b2 + r3 + b3 + g3) == 0 then
          table.insert(gradient4ToRestore, {
            sizeX,
            sizeY,
            fromColor
          })
          throwGuiError("getGradient4Filename: failed grad 2!")
        end
        pixels = dxConvertPixels(pixels, "png")
        local fh = fileCreate(fileName .. "." .. gradientTick[fileName])
        writeFileList(fileName .. "." .. gradientTick[fileName])
        fileWrite(fh, pixels)
        fileClose(fh)
        pixels = nil
        collectgarbage("collect")
      end
    end
    if not gradientList[fileName] then
      gradientList[fileName] = true
    end
    return fileName
  end
  function forceCursorAlpha()
    if not isConsoleActive() and not isMainMenuActive() then
      setCursorAlpha(0)
    end
  end
  setTimer(forceCursorAlpha, 10000, 0)
  function tryRestoreGui(didClearRenderTargets)
    setCursorAlpha(0)
    local queue = {}
    for k in pairs(gradientToRestore) do
      if gradientToRestore[k] then
        table.insert(queue, gradientToRestore[k])
        gradientToRestore[k] = nil
      end
    end
    for i = 1, #queue do
      getGradientFilename(queue[i][1], queue[i][2], queue[i][3], queue[i][4], true)
    end
    local queue = {}
    for k in pairs(gradient2ToRestore) do
      if gradient2ToRestore[k] then
        table.insert(queue, gradient2ToRestore[k])
        gradient2ToRestore[k] = nil
      end
    end
    for i = 1, #queue do
      getGradient2Filename(queue[i][1], queue[i][2], queue[i][3], queue[i][4], true)
    end
    local queue = {}
    for k in pairs(gradient3ToRestore) do
      if gradient3ToRestore[k] then
        table.insert(queue, gradient3ToRestore[k])
        gradient3ToRestore[k] = nil
      end
    end
    for i = 1, #queue do
      getGradient3Filename(queue[i][1], queue[i][2], queue[i][3], queue[i][4], true)
    end
    local queue = {}
    for k in pairs(gradient4ToRestore) do
      if gradient4ToRestore[k] then
        table.insert(queue, gradient4ToRestore[k])
        gradient4ToRestore[k] = nil
      end
    end
    for i = 1, #queue do
      getGradient4Filename(queue[i][1], queue[i][2], queue[i][3], true)
    end
    local queue = {}
    for k in pairs(faIconsToRestore) do
      if faIconsToRestore[k] then
        table.insert(queue, faIconsToRestore[k])
        faIconsToRestore[k] = nil
      end
    end
    for i = 1, #queue do
      getFaIconFilename(queue[i][1], queue[i][2], queue[i][3], true, queue[i][4], queue[i][5], queue[i][6])
    end
  end
  addEventHandler("onClientRestore", getRootElement(), tryRestoreGui)
  function writeFileList(fileName)
    local fileName = split(fileName, "/")
    local hFile = false
    if fileExists(fileName[1] .. ".filelist") then
      hFile = fileOpen(fileName[1] .. ".filelist")
    else
      hFile = fileCreate(fileName[1] .. ".filelist")
    end
    if hFile then
      fileSetPos(hFile, fileGetSize(hFile))
      fileWrite(hFile, fileName[2] .. "/")
      fileFlush(hFile)
      fileClose(hFile)
    end
  end
  local cursorType = "normal"
  local cursorTexturesDelete = {}
  local cursorTextures = {
    normal = dxCreateTexture("cursor/normal.dds")
  }
  function setCursorType(theType)
    cursorTexturesDelete[cursorType] = now + 3000
    cursorType = theType
    cursorTexturesDelete[cursorType] = nil
    if not isElement(cursorTextures[cursorType]) and cursorType ~= "none" then
      cursorTextures[cursorType] = dxCreateTexture("cursor/" .. cursorType .. ".dds")
    end
  end
  local tooltipFont = false
  local tooltipColor = false
  local tooltipText = false
  local tooltipImage = false
  local tooltipImageDDS = false
  local tooltipImageSX = false
  local tooltipImageSY = false
  local tooltipPosX = "right"
  local tooltipPosY = "down"
  local currentTooltipText = {}
  addEventHandler("onClientResourceStart", getResourceRootElement(), function()
    setPlayerHudComponentVisible("all", false)
    setPlayerHudComponentVisible("crosshair", true)
    tooltipFont = getFont("11/Ubuntu-L.ttf")
    tooltipColor = getColorCodeToColor("#000")
    setCursorAlpha(0)
    local folders = {
      "faicons",
      "gradients",
      "gradients2",
      "gradients3",
      "gradients4"
    }
    for k, folder in pairs(folders) do
      if fileExists(folder .. ".filelist") then
        local hFile = fileOpen(folder .. ".filelist")
        local string = fileRead(hFile, fileGetSize(hFile))
        fileClose(hFile)
        local dat = split(string, "/")
        for k = 1, #dat do
          if fileExists(folder .. "/" .. dat[k]) then
            fileDelete(folder .. "/" .. dat[k])
          end
        end
        fileDelete(folder .. ".filelist")
      end
    end
    if getElementData(localPlayer, "logged") then
      setTimer(setRefreshColors, 5000, 1)
    end
  end, true, "low-99999999")
  addEventHandler("onClientResourceStop", getResourceRootElement(), function()
    for k in pairs(gradientList) do
      if fileExists(k .. "." .. gradientTick[k]) then
        fileDelete(k .. "." .. gradientTick[k])
      end
    end
  end)
  function setGuiParent(el, parent)
    if el == "last" then
      el = lastGuiElement
    end
    if tonumber(el) and guiElements[el] then
      if el == parent then
        throwGuiError("setGuiParent: parent same as element")
      else
        local parentEl = guiElements[el].parent
        if parentEl then
          if tonumber(parentEl) and guiElements[parentEl] then
            for k = 1, #guiElements[parentEl].children do
              if guiElements[parentEl].children[k] == el then
                table.remove(guiElements[parentEl].children, k)
                break
              end
            end
          end
          guiElements[el].parent = false
        end
        if tonumber(parent) and guiElements[parent] then
          guiElements[el].parent = parent
          table.insert(guiElements[parent].children, el)
        end
      end
    else
      throwGuiError("setGuiParent: invalid guiElement (" .. tostring(el) .. ")")
    end
  end
  function getGuiParent(el)
    if el == "last" then
      el = lastGuiElement
    end
    if tonumber(el) and guiElements[el] then
      return guiElements[el].parent
    else
      throwGuiError("getGuiParent: invalid guiElement (" .. tostring(el) .. ")")
    end
  end
  function getGuiPosition(el, dimension)
    if el == "last" then
      el = lastGuiElement
    end
    if tonumber(el) and guiElements[el] then
      local x, y = guiElements[el].x, guiElements[el].y
      local parentEl = guiElements[el].parent
      if parentEl then
        x = x - guiElements[parentEl].x
        y = y - guiElements[parentEl].y
      end
      if dimension == "x" then
        return x
      elseif dimension == "y" then
        return y
      else
        return x, y
      end
    else
      throwGuiError("getGuiPosition: invalid guiElement (" .. tostring(el) .. ")")
    end
  end
  function isGuiRenderDisabled(el, state)
    if el == "last" then
      el = lastGuiElement
    end
    if tonumber(el) and guiElements[el] then
      return guiElements[el].disableRender
    else
      throwGuiError("isGuiRenderDisabled: invalid guiElement (" .. tostring(el) .. ")")
    end
  end
  function setGuiRenderDisabled(el, state, childrenToo)
    if el == "last" then
      el = lastGuiElement
    end
    if tonumber(el) and guiElements[el] then
      guiElements[el].disableRender = state
      if childrenToo then
        for k = 1, #guiElements[el].children do
          local child = guiElements[el].children[k]
          setGuiRenderDisabled(child, state, true)
        end
      end
    else
      throwGuiError("setGuiRenderDisabled: invalid guiElement (" .. tostring(el) .. ")")
    end
  end
  function getGuiRealPosition(el, dimension)
    if el == "last" then
      el = lastGuiElement
    end
    if tonumber(el) and guiElements[el] then
      if dimension == "x" then
        return guiElements[el].x
      elseif dimension == "y" then
        return guiElements[el].y
      else
        return guiElements[el].x, guiElements[el].y
      end
    else
      throwGuiError("getGuiRealPosition: invalid guiElement (" .. tostring(el) .. ")")
    end
  end
  function setGuiPosition(el, x, y, absolute, excludeChildren)
    if el == "last" then
      el = lastGuiElement
    end
    if tonumber(el) and guiElements[el] then
      local parentEl = guiElements[el].parent
      local lastX = guiElements[el].x
      local lastY = guiElements[el].y
      if not tonumber(x) then
        x = guiElements[el].x
      elseif parentEl and not absolute then
        guiElements[el].x = guiElements[parentEl].x + x
      else
        guiElements[el].x = x
      end
      if not tonumber(y) then
        y = guiElements[el].y
      elseif parentEl and not absolute then
        guiElements[el].y = guiElements[parentEl].y + y
      else
        guiElements[el].y = y
      end
      if not excludeChildren then
        for k = 1, #guiElements[el].children do
          local child = guiElements[el].children[k]
          local px = guiElements[child].x - lastX
          local py = guiElements[child].y - lastY
          setGuiPosition(child, guiElements[el].x + px, guiElements[el].y + py, true)
        end
      end
    else
      throwGuiError("setGuiPosition: invalid guiElement (" .. tostring(el) .. ")")
    end
  end
  local guiAnimations = {}
  function setGuiPositionAnimated(el, x, y, time, event, interpolationType, absolute, excludeChildren)
    if el == "last" then
      el = lastGuiElement
    end
    if tonumber(el) and guiElements[el] then
      local parentEl = guiElements[el].parent
      local lastX = guiElements[el].x
      local lastY = guiElements[el].y
      if not tonumber(x) then
        x = guiElements[el].x
      end
      if not tonumber(y) then
        y = guiElements[el].y
      end
      local toX = 0
      local toY = 0
      if parentEl and not absolute then
        toX = guiElements[parentEl].x + x
        toY = guiElements[parentEl].y + y
      else
        toX = x
        toY = y
      end
      table.insert(guiAnimations, {
        now,
        tonumber(time) or 1000,
        event,
        el,
        {
          x = {lastX, toX},
          y = {lastY, toY}
        },
        interpolationType
      })
      if not excludeChildren then
        for k = 1, #guiElements[el].children do
          local child = guiElements[el].children[k]
          local px = guiElements[child].x - lastX
          local py = guiElements[child].y - lastY
          toX = x + px
          toY = y + py
          setGuiPositionAnimated(child, toX, toY, time, false, interpolationType, true, excludeChildren)
        end
      end
    else
      throwGuiError("setGuiPositionAnimated: invalid guiElement (" .. tostring(el) .. ")")
    end
  end
  function getGuiSize(el, dimension)
    if el == "last" then
      el = lastGuiElement
    end
    if tonumber(el) and guiElements[el] then
      if dimension == "x" then
        return guiElements[el].sx
      elseif dimension == "y" then
        return guiElements[el].sy
      else
        return guiElements[el].sx, guiElements[el].sy
      end
    else
      throwGuiError("setGuiSize: invalid guiElement (" .. tostring(el) .. ")")
    end
  end
  function setGuiSize(el, sx, sy)
    if el == "last" then
      el = lastGuiElement
    end
    if tonumber(el) and guiElements[el] then
      if not tonumber(sx) and sizeSchemes[guiElements[el].type] and sizeSchemes[guiElements[el].type][sx] then
        sx = sizeSchemes[guiElements[el].type][sx][1]
      end
      if not tonumber(sy) and sizeSchemes[guiElements[el].type] and sizeSchemes[guiElements[el].type][sy] then
        sy = sizeSchemes[guiElements[el].type][sy][2]
      end
      if not tonumber(sx) then
        sx = guiElements[el].sx
      end
      if not tonumber(sy) then
        sy = guiElements[el].sy
      end
      guiElements[el].sx = sx
      guiElements[el].sy = sy
      if guiElements[el].type == "input" then
        refreshInputSize(el)
      elseif guiElements[el].type == "checkbox" then
        guiElements[el].fontPadding = (guiElements[el].sy - dxGetFontHeight(fontScales[guiElements[el].font], guiElements[el].font)) / 2
        guiElements[el].checkIcon = getFaIconFilename("check", guiElements[el].sy)
      end
    else
      throwGuiError("setGuiSize: invalid guiElement (" .. tostring(el) .. ")")
    end
  end
  function setGuiSizeAnimated(el, sx, sy, time, event, interpolationType)
    if el == "last" then
      el = lastGuiElement
    end
    if tonumber(el) and guiElements[el] then
      if not tonumber(sx) and sizeSchemes[guiElements[el].type] and sizeSchemes[guiElements[el].type][sx] then
        sx = sizeSchemes[guiElements[el].type][sx][1]
      end
      if not tonumber(sy) and sizeSchemes[guiElements[el].type] and sizeSchemes[guiElements[el].type][sy] then
        sy = sizeSchemes[guiElements[el].type][sy][2]
      end
      if not tonumber(sx) then
        sx = guiElements[el].sx
      end
      if not tonumber(sy) then
        sy = guiElements[el].sy
      end
      local anim = {
        sx = {
          guiElements[el].sx,
          sx
        },
        sy = {
          guiElements[el].sy,
          sy
        }
      }
      if guiElements[el].type == "input" then
        if guiElements[el].multiline then
          refreshInputSize(el)
        else
          anim.fontPadding = {
            guiElements[el].fontPadding,
            (guiElements[el].sy - dxGetFontHeight(fontScales[guiElements[el].font], guiElements[el].font)) / 2
          }
          if guiElements[el].icon then
            guiElements[el].icon = getFaIconFilename(guiElements[el].iconRaw, math.ceil(sy) - 2)
          end
        end
      elseif guiElements[el].type == "checkbox" then
        anim.fontPadding = {
          guiElements[el].fontPadding,
          (guiElements[el].sy - dxGetFontHeight(fontScales[guiElements[el].font], guiElements[el].font)) / 2
        }
        guiElements[el].checkIcon = getFaIconFilename(guiElements[el].checkIconRaw, guiElements[el].sy)
      end
      table.insert(guiAnimations, {
        now,
        tonumber(time) or 1000,
        event,
        el,
        anim,
        interpolationType
      })
    else
      throwGuiError("setGuiSizeAnimated: invalid guiElement (" .. tostring(el) .. ")")
    end
  end
  function createGuiElement(guiType, x, y, sx, sy, parent, skipInit)
    local el = (lastGuiElement or 0) + 1
    lastGuiElement = el
    if not sx and sizeSchemes[guiType] and sizeSchemes[guiType].normal then
      sx = sizeSchemes[guiType].normal[1]
    end
    if not sy and sizeSchemes[guiType] and sizeSchemes[guiType].normal then
      sy = sizeSchemes[guiType].normal[2]
    end
    if not tonumber(sx) and sizeSchemes[guiType] and sizeSchemes[guiType][sx] then
      sx = sizeSchemes[guiType][sx][1]
    end
    if not tonumber(sy) and sizeSchemes[guiType] and sizeSchemes[guiType][sy] then
      sy = sizeSchemes[guiType][sy][2]
    end
    guiElements[el] = {
      type = guiType,
      x = x,
      y = y,
      sx = sx,
      sy = sy,
      parent = false,
      children = {},
      textures = {},
      sourceResource = sourceResource,
      sourceResourceRoot = sourceResourceRoot,
      toColorCache = {},
      toColorTableCache = {},
      gradientCache = {},
      clickSound = "click"
    }
    if tonumber(parent) then
      setGuiParent(el, parent)
      if tonumber(parent) and guiElements[parent] then
        guiElements[el].x = guiElements[parent].x + x
        guiElements[el].y = guiElements[parent].y + y
        if guiElements[parent].disableChildClickSound then
          guiElements[el].disableChildClickSound = true
          guiElements[el].clickSound = nil
        end
      end
    end
    if guiType ~= "null" then
      table.insert(renderList, el)
    end
    if hoverables[guiType] then
      guiElements[el].activateEffect = 0
      guiElements[el].disableClickTrough = true
      guiElements[el].hoverAlpha = 0
      guiElements[el].hoverTime = defaultHoverTime
      hoverList[el] = true
    end
    if not skipInit then
      if guiType == "slider" then
        setSliderColor(el, "v4grey1", "v4green")
      elseif guiType == "hr" then
        setGuiHrColor(el, "v4grey3", "v4grey1")
      elseif guiType == "window" then
        setWindowColors(el, "v4grey2", "v4grey1", "v4grey3", "#ffffff")
      end
    end
    setGuiColorScheme(el)
    setGuiFontScheme(el)
    return el
  end
  function drawGuiElement(el, x, y)
    if tonumber(el) and guiElements[el] then
      if not guiElements[el].disableRender then
        local xWas = guiElements[el].x
        local yWas = guiElements[el].y
        if x or y then
          guiElements[el].x = xWas + (x or 0)
          guiElements[el].y = yWas + (y or 0)
        end
        if guiElements[el].updateScreenSource then
          dxUpdateScreenSource(guiElements[el].updateScreenSource, guiElements[el].updateScreenSourceResample)
        end
        if renderFunctions[guiElements[el].type] then
          renderFunctions[guiElements[el].type](el)
        else
          renderBackground(el)
        end
        if x or y then
          guiElements[el].x = xWas
          guiElements[el].y = yWas
        end
      end
    else
      throwGuiError("drawGuiElement: invalid guiElement (" .. tostring(el) .. ")")
    end
  end
  local toDraw = {}
  function drawGuiElementWithChildren(el, x, y, secondLevel)
    if tonumber(el) and guiElements[el] then
      for k = 1, #guiElements[el].children do
        if guiElements[el].children[k] and guiElements[guiElements[el].children[k]] then
          drawGuiElementWithChildren(guiElements[el].children[k], x, y, true)
        end
      end
      toDraw[el] = true
      if not secondLevel then
        for k = 1, #renderList do
          if renderList[k] then
            local el = renderList[k]
            if not guiElements[el].disableRender and toDraw[el] then
              local xWas = guiElements[el].x
              local yWas = guiElements[el].y
              if x or y then
                guiElements[el].x = xWas + (x or 0)
                guiElements[el].y = yWas + (y or 0)
              end
              if guiElements[el].updateScreenSource then
                dxUpdateScreenSource(guiElements[el].updateScreenSource, guiElements[el].updateScreenSourceResample)
              end
              if renderFunctions[guiElements[el].type] then
                renderFunctions[guiElements[el].type](el)
              else
                renderBackground(el)
              end
              if x or y then
                guiElements[el].x = xWas
                guiElements[el].y = yWas
              end
            end
          end
        end
        toDraw = {}
      end
    else
      throwGuiError("drawGuiElementWithChildren: invalid guiElement (" .. tostring(el) .. ")")
    end
  end
  function deleteAllChildren(el)
    if tonumber(el) and guiElements[el] then
      for k = 1, #guiElements[el].children do
        local el = guiElements[el].children[k]
        if el and guiElements[el] then
          guiElements[el].parent = nil
          deleteGuiElement(el)
        end
      end
      guiElements[el].children = {}
    else
      throwGuiError("deleteAllChildren: invalid guiElement (" .. tostring(el) .. ")")
    end
  end
  function setDeleteEvent(el, event)
    if tonumber(el) and guiElements[el] then
      guiElements[el].deleteEvent = event
    else
      throwGuiError("setDeleteEvent: invalid guiElement (" .. tostring(el) .. ")")
    end
  end
  function deleteGuiElement(el, excludeChildren)
    if tonumber(el) and guiElements[el] then
      if enterTrigger == el then
        enterTrigger = false
        seelangCondHandl0(enterTrigger)
      end
      if guiElements[el].deleteEvent then
        triggerEvent(guiElements[el].deleteEvent, localPlayer, el)
      end
      for k = 1, #guiElements[el].children do
        if guiElements[el].children[k] and guiElements[guiElements[el].children[k]] then
          guiElements[guiElements[el].children[k]].parent = nil
          if not excludeChildren then
            deleteGuiElement(guiElements[el].children[k])
          end
        end
      end
      local parentEl = guiElements[el].parent
      if tonumber(parentEl) and guiElements[parentEl] then
        for k = 1, #guiElements[parentEl].children do
          if guiElements[parentEl].children[k] == el then
            table.remove(guiElements[parentEl].children, k)
            break
          end
        end
      end
      for k = #renderList, 1, -1 do
        if renderList[k] == el then
          table.remove(renderList, k)
          break
        end
      end
      hoverList[el] = nil
      guiElements[el] = nil
      if activeInput == el then
        activeInput = false
      end
    else
      throwGuiError("deleteGuiElement: invalid guiElement (" .. tostring(el) .. ")")
    end
  end
  addEventHandler("onClientResourceStop", getRootElement(), function()
    for el in pairs(guiElements) do
      if guiElements[el].sourceResourceRoot == source then
        deleteGuiElement(el, true)
      end
    end
  end)
  function setElementGradientToData(el, data, color)
    local color1 = getColorCode(color[1])
    local color2 = getColorCode(color[2])
    if not guiElements[el].hoverSy then
      local sx, sy = guiElements[el].hoverSx or guiElements[el].sx, guiElements[el].sy
    end
    if color[3] == "4rd" then
      guiElements[el][data] = getGradient4Filename(sx, sy, color1)
    elseif color[3] == "3rd" then
      guiElements[el][data] = getGradient3Filename(sx, sy, color1, color2)
    elseif color[3] then
      guiElements[el][data] = getGradient2Filename(sx, sy, color1, color2)
    else
      guiElements[el][data] = getGradientFilename(sx, sy, color1, color2)
    end
    guiElements[el].gradientCache[data] = nil
    if colors[color[1]] or colors[color[2]] then
      guiElements[el].gradientCache[data] = color
    end
  end
  function setGuiBackground(el, backgroundType, color)
    if tonumber(el) and guiElements[el] then
      guiElements[el].backgroundType = backgroundType
      if backgroundType == "solid" then
        setElementColorToData(el, "background", color)
      elseif backgroundType == "gradient" then
        guiElements[el].hoverSx = guiElements[el].sx
        guiElements[el].hoverSy = guiElements[el].sy
        setElementGradientToData(el, "background", color)
      end
    else
      throwGuiError("setGuiBackground: invalid guiElement (" .. tostring(el) .. ")")
    end
  end
  function cacheGradient(sx, sy, color)
    for k = 1, #colorSets do
      local color1 = false
      if colorSets[k][color[1]] then
        color1 = colorSets[k][color[1]]
      else
        color1 = getColorCode(color[1])
      end
      local color2 = false
      if colorSets[k][color[2]] then
        color2 = colorSets[k][color[2]]
      else
        color2 = getColorCode(color[2])
      end
      if color[3] == "3rd" then
        getGradient3Filename(sx, sy, color1, color2)
      elseif color[3] then
        getGradient2Filename(sx, sy, color1, color2)
      else
        getGradientFilename(sx, sy, color1, color2)
      end
    end
  end
  function setGuiHover(el, hoverType, color, toFront, disableSize)
    if tonumber(el) and guiElements[el] then
      guiElements[el].hoverType = hoverType
      guiElements[el].hoverFront = toFront
      guiElements[el].hoverDisableSize = disableSize
      if hoverType == "none" then
      elseif hoverType == "solid" then
        setElementColorToData(el, "hover", color)
      elseif hoverType == "gradient" then
        guiElements[el].hoverSx = guiElements[el].sx
        guiElements[el].hoverSy = guiElements[el].sy
        setElementGradientToData(el, "hover", color)
      else
        throwGuiWarning("setGuiHover: invalid hover color type")
      end
    else
      throwGuiError("setGuiHover: invalid guiElement (" .. tostring(el) .. ")")
    end
  end
  local cursorState = false
  local logoAnimations = {
    {
      now + 500 + 0,
      300
    },
    {
      now + 500 + 300,
      300
    },
    {
      now + 500 + 600,
      300
    },
    {
      now + 500 + 900,
      300
    },
    {
      now + 500 + 1200,
      600
    }
  }
  local logoAnimationState = "in"
  function setImageCrop(el, x, y)
    if tonumber(el) and guiElements[el] then
      if guiElements[el].type == "image" then
        guiElements[el].cropX = x
        guiElements[el].cropY = y
      else
        throwGuiError("setImageCrop: guiElement is not image")
      end
    else
      throwGuiError("setImageCrop: invalid guiElement (" .. tostring(el) .. ")")
    end
  end
  function setImageUV(el, u, v, usize, vsize)
    if tonumber(el) and guiElements[el] then
      if guiElements[el].type == "image" then
        guiElements[el].u = u
        guiElements[el].v = v
        guiElements[el].usize = usize
        guiElements[el].vsize = vsize
      else
        throwGuiError("setImageCrop: guiElement is not image")
      end
    else
      throwGuiError("setImageCrop: invalid guiElement (" .. tostring(el) .. ")")
    end
  end
  function setImageDDS(el, file, format, mipMap, latent)
    if tonumber(el) and guiElements[el] then
      if guiElements[el].type == "image" then
        guiElements[el].file = false
        guiElements[el].dds = file
        guiElements[el].ddsFormat = format
        guiElements[el].ddsMipMap = mipMap
        guiElements[el].ddsLatent = latent
      else
        throwGuiError("setImageDDS: guiElement is not image")
      end
    else
      throwGuiError("setImageDDS: invalid guiElement (" .. tostring(el) .. ")")
    end
  end
  function resetImageDDS(file)
    resetDynamicImage(file)
  end
  function setImageShadow(el, i, x, y, col)
    if tonumber(el) and guiElements[el] then
      if guiElements[el].type == "image" then
        if i then
          guiElements[el].shadowI = i
          guiElements[el].shadowX = x
          guiElements[el].shadowY = y
          setElementColorToData(el, "shadowColor", col)
        else
          guiElements[el].shadowI = nil
          guiElements[el].shadowX = nil
          guiElements[el].shadowY = nil
          setElementColorToData(el, "shadowColor", false)
        end
      else
        throwGuiError("setImageShadow: guiElement is not image")
      end
    else
      throwGuiError("setImageShadow: invalid guiElement (" .. tostring(el) .. ")")
    end
  end
  function setImageFile(el, file)
    if tonumber(el) and guiElements[el] then
      if guiElements[el].type == "image" then
        guiElements[el].file = file
        guiElements[el].dds = nil
        guiElements[el].ddsFormat = nil
        guiElements[el].ddsMipMap = nil
        guiElements[el].ddsLatent = nil
      else
        throwGuiError("setImageFile: guiElement is not image")
      end
    else
      throwGuiError("setImageFile: invalid guiElement (" .. tostring(el) .. ")")
    end
  end
  function setImageRotation(el, rotation)
    if tonumber(el) and guiElements[el] then
      if guiElements[el].type == "image" then
        guiElements[el].rotation = rotation
      else
        throwGuiError("setImageRotation: guiElement is not image")
      end
    else
      throwGuiError("setImageRotation: invalid guiElement (" .. tostring(el) .. ")")
    end
  end
  function setImageSpinner(el, spinner)
    if tonumber(el) and guiElements[el] then
      if guiElements[el].type == "image" then
        guiElements[el].spinner = spinner
      else
        throwGuiError("setImageSpinner: guiElement is not image")
      end
    else
      throwGuiError("setImageSpinner: invalid guiElement (" .. tostring(el) .. ")")
    end
  end
  function setImageFadeHover(el, state)
    if tonumber(el) and guiElements[el] then
      if guiElements[el].type == "image" then
        guiElements[el].fadeHover = state
      else
        throwGuiError("setImageFadeHover: guiElement is not image")
      end
    else
      throwGuiError("setImageFadeHover: invalid guiElement (" .. tostring(el) .. ")")
    end
  end
  function setImageColor(el, color)
    if tonumber(el) and guiElements[el] then
      if guiElements[el].type == "image" then
        setElementColorToData(el, "color", color)
      else
        throwGuiError("setImageColor: guiElement is not image")
      end
    else
      throwGuiError("setImageColor: invalid guiElement (" .. tostring(el) .. ")")
    end
  end
  function lockHover(el, state, excludeChildren)
    if tonumber(el) and guiElements[el] then
      guiElements[el].hoverLock = state
      if not excludeChildren then
        for k = 1, #guiElements[el].children do
          if guiElements[el].children[k] then
            lockHover(guiElements[el].children[k], state)
          end
        end
      end
    else
      throwGuiError("lockHover: invalid guiElement (" .. tostring(el) .. ")")
    end
  end
  function setGuiHoverable(el, state, hoverTime)
    if tonumber(el) and guiElements[el] then
      hoverList[el] = state
      if hoverList[el] then
        guiElements[el].activateEffect = 0
        guiElements[el].hoverAlpha = 0
        guiElements[el].hoverTime = hoverTime or defaultHoverTime
      else
        guiElements[el].activateEffect = false
        guiElements[el].hoverAlpha = false
        guiElements[el].hoverTime = false
        hoverList[el] = nil
      end
    else
      throwGuiError("setGuiHoverable: invalid guiElement (" .. tostring(el) .. ")")
    end
  end
  function getGuiHoverable(el)
    if tonumber(el) and guiElements[el] then
      return hoverList[el]
    else
      throwGuiError("getGuiHoverable: invalid guiElement (" .. tostring(el) .. ")")
    end
  end
  function setGuiBoundingBox(el, el2)
    if tonumber(el) and guiElements[el] then
      guiElements[el].boundingBox = el2
    else
      throwGuiError("setGuiBoundingBox: invalid guiElement (" .. tostring(el) .. ")")
    end
  end
  function setImageRightCornerHover(el, x, y)
    if tonumber(el) and guiElements[el] then
      if guiElements[el].type == "image" then
        guiElements[el].rightCornerX = x
        guiElements[el].rightCornerY = x
      else
        throwGuiError("setImageRightCornerHover: guiElement is not image")
      end
    else
      throwGuiError("setImageRightCornerHover: invalid guiElement (" .. tostring(el) .. ")")
    end
  end
  function setRadarCoords(el, x, y, zoom)
    if tonumber(el) and guiElements[el] then
      if guiElements[el].type == "radar" then
        guiElements[el].radarX = x
        guiElements[el].radarY = y
        guiElements[el].radarZoom = zoom
      else
        throwGuiError("setRadarCoords: guiElement is not radar")
      end
    else
      throwGuiError("setRadarCoords: invalid guiElement (" .. tostring(el) .. ")")
    end
  end
  function renderFunctions.radar(el)
    local rx, ry, rz = guiElements[el].radarX, guiElements[el].radarY, guiElements[el].radarZoom
    if rx and ry and rz then
      local fadeAlpha = 255
      if guiElements[el].fadeIn then
        local progress = getEasingValue(math.min(1, (now - guiElements[el].fadeIn) / guiElements[el].fadeInTime), "InOutQuad")
        fadeAlpha = progress * fadeAlpha
        guiElements[el].faded = false
        if 1 <= progress then
          guiElements[el].fadeIn = false
        end
      end
      if guiElements[el].fadeOut then
        local progress = 1 - getEasingValue(math.min(1, (now - guiElements[el].fadeOut) / guiElements[el].fadeOutTime), "InOutQuad")
        fadeAlpha = progress * fadeAlpha
        if progress <= 0 then
          guiElements[el].fadeOut = false
          guiElements[el].faded = true
        end
      end
      local x = guiElements[el].x
      local y = guiElements[el].y
      local sx = guiElements[el].sx
      local sy = guiElements[el].sy
      seexports.rl_radar:drawSecondaryRadar(x, y, sx, sy, rx, ry, rz, fadeAlpha)
    end
  end
  function renderFunctions.image(el)
    if not acayimmi then return end
	if guiElements[el].file or guiElements[el].dds then
      local color = guiElements[el].color or tocolor(255, 255, 255)
      local fadeAlpha = bitExtract(color, 24, 8)
      if guiElements[el].fadeIn then
        local progress = getEasingValue(math.min(1, (now - guiElements[el].fadeIn) / guiElements[el].fadeInTime), "InOutQuad")
        fadeAlpha = progress * fadeAlpha
        guiElements[el].faded = false
        if 1 <= progress then
          guiElements[el].fadeIn = false
        end
      end
      if guiElements[el].fadeOut then
        local progress = 1 - getEasingValue(math.min(1, (now - guiElements[el].fadeOut) / guiElements[el].fadeOutTime), "InOutQuad")
        fadeAlpha = progress * fadeAlpha
        if progress <= 0 then
          guiElements[el].fadeOut = false
          guiElements[el].faded = true
        end
      end
      local shadCol = false
      if guiElements[el].shadowI then
        shadCol = guiElements[el].shadowColor or tocolor(0, 0, 0, 255)
      end
      if not guiElements[el].faded then
        local rot = 0
        if guiElements[el].spinner then
          rot = now / 5 % 360
        else
          rot = guiElements[el].rotation
        end
        local x = guiElements[el].x
        local y = guiElements[el].y
        local sx = guiElements[el].sx
        local sy = guiElements[el].sy
        local fileName = false
        local dds = guiElements[el].dds
        if dds then
          if guiElements[el].ddsLatent then
            fileName = latentDynamicImage(guiElements[el].dds, guiElements[el].ddsFormat, guiElements[el].ddsMipMap)
            if not fileName then
              return
            end
          else
            fileName = dynamicImage(guiElements[el].dds, guiElements[el].ddsFormat, guiElements[el].ddsMipMap)
          end
        else
          fileName = guiElements[el].file
          if type(fileName) == "string" then
            fileName = fileName .. (faTicks[guiElements[el].file] and faTicks[guiElements[el].file] or "") .. (gradientTick[guiElements[el].file] and gradientTick[guiElements[el].file] or "")
          end
        end
        if guiElements[el].hoverAlpha and 0 < guiElements[el].hoverAlpha then
          local progress = guiElements[el].hoverAlpha / 255
          if guiElements[el].rightCornerX and guiElements[el].rightCornerY then
            local dx = (guiElements[el].rightCornerX - sx) * progress
            x = x - dx
            sx = sx + dx
            local dy = (guiElements[el].rightCornerY - sy) * progress
            y = y - dy
            sy = sy + dy
          end
          if guiElements[el].fadeHover then
            fadeAlpha = fadeAlpha * progress
          end
          if 0 < fadeAlpha then
            if guiElements[el].hoverType == "solid" then
              local r2, g2, b2 = 255, 255, 255
              if guiElements[el].color then
                r2, g2, b2 = bitExtract(guiElements[el].color, 16, 8), bitExtract(guiElements[el].color, 8, 8), bitExtract(guiElements[el].color, 0, 8)
              end
              local r, g, b = interpolateBetween(r2, g2, b2, bitExtract(guiElements[el].hover, 16, 8), bitExtract(guiElements[el].hover, 8, 8), bitExtract(guiElements[el].hover, 0, 8), progress, "Linear")
              if guiElements[el].u and guiElements[el].v and guiElements[el].usize and guiElements[el].vsize then
                local uPlus = guiElements[el].usize * 0.1 * progress
                local vPlus = guiElements[el].vsize * 0.1 * progress
                if shadCol then
                  local i = guiElements[el].shadowI
                  local shx = guiElements[el].shadowX
                  local shy = guiElements[el].shadowY
                  for k = i - 1, 1, -1 do
                    local col = bitReplace(shadCol, bitExtract(shadCol, 24, 8) * (1 - k / i) * fadeAlpha / 255, 24, 8)
                    dxDrawImageSection(x + shx * k, y + shy * k, sx * (guiElements[el].cropX or 1), sy * (guiElements[el].cropY or 1), guiElements[el].u + uPlus, guiElements[el].v + vPlus, guiElements[el].usize - uPlus * 2, guiElements[el].vsize - vPlus * 2, fileName, rot, 0, 0, col)
                  end
                end
                dxDrawImageSection(x, y, sx * (guiElements[el].cropX or 1), sy * (guiElements[el].cropY or 1), guiElements[el].u + uPlus, guiElements[el].v + vPlus, guiElements[el].usize - uPlus * 2, guiElements[el].vsize - vPlus * 2, fileName, rot, 0, 0, tocolor(r, g, b, fadeAlpha))
              elseif guiElements[el].cropX or guiElements[el].cropY then
                if shadCol then
                  local i = guiElements[el].shadowI
                  local shx = guiElements[el].shadowX
                  local shy = guiElements[el].shadowY
                  for k = i - 1, 1, -1 do
                    local col = bitReplace(shadCol, bitExtract(shadCol, 24, 8) * (1 - k / i) * fadeAlpha / 255, 24, 8)
                    dxDrawImageSection(x + shx * k, y + shy * k, sx * (guiElements[el].cropX or 1), sy * (guiElements[el].cropY or 1), 0, 0, sx * (guiElements[el].cropX or 1), sy * (guiElements[el].cropY or 1), fileName, rot, 0, 0, col)
                  end
                end
                dxDrawImageSection(x, y, sx * (guiElements[el].cropX or 1), sy * (guiElements[el].cropY or 1), 0, 0, sx * (guiElements[el].cropX or 1), sy * (guiElements[el].cropY or 1), fileName, rot, 0, 0, tocolor(r, g, b, fadeAlpha))
              else
                if shadCol then
                  local i = guiElements[el].shadowI
                  local shx = guiElements[el].shadowX
                  local shy = guiElements[el].shadowY
                  for k = i - 1, 1, -1 do
                    local col = bitReplace(shadCol, bitExtract(shadCol, 24, 8) * (1 - k / i) * fadeAlpha / 255, 24, 8)
                    dxDrawImage(x + shx * k, y + shy * k, sx, sy, fileName, rot, 0, 0, col)
                  end
                end
                dxDrawImage(x, y, sx, sy, fileName, rot, 0, 0, tocolor(r, g, b, fadeAlpha))
              end
            elseif guiElements[el].u and guiElements[el].v and guiElements[el].usize and guiElements[el].vsize then
              local uPlus = guiElements[el].usize * 0.1 * progress
              local vPlus = guiElements[el].vsize * 0.1 * progress
              if shadCol then
                local i = guiElements[el].shadowI
                local shx = guiElements[el].shadowX
                local shy = guiElements[el].shadowY
                for k = i - 1, 1, -1 do
                  local col = bitReplace(shadCol, bitExtract(shadCol, 24, 8) * (1 - k / i) * fadeAlpha / 255, 24, 8)
                  dxDrawImageSection(x + shx * k, y + shy * k, sx * (guiElements[el].cropX or 1), sy * (guiElements[el].cropY or 1), guiElements[el].u + uPlus, guiElements[el].v + vPlus, guiElements[el].usize - uPlus * 2, guiElements[el].vsize - vPlus * 2, fileName, rot, 0, 0, col)
                end
              end
              dxDrawImageSection(x, y, sx * (guiElements[el].cropX or 1), sy * (guiElements[el].cropY or 1), guiElements[el].u + uPlus, guiElements[el].v + vPlus, guiElements[el].usize - uPlus * 2, guiElements[el].vsize - vPlus * 2, fileName, rot, 0, 0, bitReplace(color, fadeAlpha, 24, 8))
            elseif guiElements[el].cropX or guiElements[el].cropY then
              if shadCol then
                local i = guiElements[el].shadowI
                local shx = guiElements[el].shadowX
                local shy = guiElements[el].shadowY
                for k = i - 1, 1, -1 do
                  local col = bitReplace(shadCol, bitExtract(shadCol, 24, 8) * (1 - k / i) * fadeAlpha / 255, 24, 8)
                  dxDrawImageSection(x + shx * k, y + shy * k, sx * (guiElements[el].cropX or 1), sy * (guiElements[el].cropY or 1), 0, 0, sx * (guiElements[el].cropX or 1), sy * (guiElements[el].cropY or 1), fileName, rot, 0, 0, col)
                end
              end
              dxDrawImageSection(x, y, sx * (guiElements[el].cropX or 1), sy * (guiElements[el].cropY or 1), 0, 0, sx * (guiElements[el].cropX or 1), sy * (guiElements[el].cropY or 1), fileName, rot, 0, 0, bitReplace(color, fadeAlpha, 24, 8))
            else
              if shadCol then
                local i = guiElements[el].shadowI
                local shx = guiElements[el].shadowX
                local shy = guiElements[el].shadowY
                for k = i - 1, 1, -1 do
                  local col = bitReplace(shadCol, bitExtract(shadCol, 24, 8) * (1 - k / i) * fadeAlpha / 255, 24, 8)
                  dxDrawImage(x + shx * k, y + shy * k, sx, sy, fileName, rot, 0, 0, col)
                end
              end
              dxDrawImage(x, y, sx, sy, fileName, rot, 0, 0, bitReplace(color, fadeAlpha, 24, 8))
            end
          end
          -- print("aaaasama2")
		else
          -- print("aaaasama1")
		  if guiElements[el].fadeHover then
            fadeAlpha = 0
          end
          if 0 < fadeAlpha then
            if guiElements[el].u and guiElements[el].v and guiElements[el].usize and guiElements[el].vsize then
              if shadCol then
                local i = guiElements[el].shadowI
                local shx = guiElements[el].shadowX
                local shy = guiElements[el].shadowY
                for k = i - 1, 1, -1 do
                  local col = bitReplace(shadCol, bitExtract(shadCol, 24, 8) * (1 - k / i) * fadeAlpha / 255, 24, 8)
                  dxDrawImageSection(x + shx * k, y + shy * k, sx * (guiElements[el].cropX or 1), sy * (guiElements[el].cropY or 1), guiElements[el].u, guiElements[el].v, guiElements[el].usize, guiElements[el].vsize, fileName, rot, 0, 0, col)
                end
              end
              dxDrawImageSection(x, y, sx * (guiElements[el].cropX or 1), sy * (guiElements[el].cropY or 1), guiElements[el].u, guiElements[el].v, guiElements[el].usize, guiElements[el].vsize, fileName, rot, 0, 0, bitReplace(color, fadeAlpha, 24, 8))
            elseif guiElements[el].cropX or guiElements[el].cropY then
              if shadCol then
                local i = guiElements[el].shadowI
                local shx = guiElements[el].shadowX
                local shy = guiElements[el].shadowY
                for k = i - 1, 1, -1 do
                  local col = bitReplace(shadCol, bitExtract(shadCol, 24, 8) * (1 - k / i) * fadeAlpha / 255, 24, 8)
                  dxDrawImageSection(x + shx * k, y + shy * k, sx * (guiElements[el].cropX or 1), sy * (guiElements[el].cropY or 1), 0, 0, sx * (guiElements[el].cropX or 1), sy * (guiElements[el].cropY or 1), fileName, rot, 0, 0, col)
                end
              end
              dxDrawImageSection(x, y, sx * (guiElements[el].cropX or 1), sy * (guiElements[el].cropY or 1), 0, 0, sx * (guiElements[el].cropX or 1), sy * (guiElements[el].cropY or 1), fileName, rot, 0, 0, bitReplace(color, fadeAlpha, 24, 8))
            else
              if shadCol then
                local i = guiElements[el].shadowI
                local shx = guiElements[el].shadowX
                local shy = guiElements[el].shadowY
                for k = i - 1, 1, -1 do
                  local col = bitReplace(shadCol, bitExtract(shadCol, 24, 8) * (1 - k / i) * fadeAlpha / 255, 24, 8)
                  if fileName then 
				  dxDrawImage(x + shx * k, y + shy * k, sx, sy, fileName, rot, 0, 0, col)
                  dxDrawImage(x, y, sx, sy, fileName, rot, 0, 0, bitReplace(color, fadeAlpha, 24, 8))
				  end 
				end
              end
              -- if dxDrawImage(x, y, sx, sy, fileName, rot, 0, 0, bitReplace(color, fadeAlpha, 24, 8)) then
				-- local isImageLoaded = fileExists(fileName)
				-- if fileName =
				-- local deger = "dosya/file.png"

					-- iprint(type(fileName))
				-- else
					-- outputChatBox("Bu bir string değil!")
				-- end
				-- if isImageLoaded then 
				-- if not type(fileName) == "userdata" then
					if isElement(fileName) then 
					dxDrawImage(x, y, sx, sy, fileName, rot, 0, 0, bitReplace(color, fadeAlpha, 24, 8))
				    end ----- ramoooooo
				
              -- end
			end
          else
		  end
        end
      end
    end
  end
  function setGuiHrColor(el, c1, c2)
    if tonumber(el) and guiElements[el] then
      if guiElements[el].type == "hr" then
        setElementColorToData(el, "color1", c1)
        setElementColorToData(el, "color2", c2)
      else
        throwGuiError("setGuiHrColor: guiElement is not hr")
      end
    else
      throwGuiError("setGuiHrColor: invalid guiElement (" .. tostring(el) .. ")")
    end
  end
  function renderFunctions.hr(el)
    local sx = guiElements[el].sx / 2
    local sy = guiElements[el].sy / 2
    if sx > sy then
      dxDrawRectangle(guiElements[el].x, guiElements[el].y, guiElements[el].sx, sy, guiElements[el].color1)
      dxDrawRectangle(guiElements[el].x, guiElements[el].y + sy, guiElements[el].sx, sy, guiElements[el].color2)
    else
      dxDrawRectangle(guiElements[el].x, guiElements[el].y, sx, guiElements[el].sy, guiElements[el].color1)
      dxDrawRectangle(guiElements[el].x + sx, guiElements[el].y, sx, guiElements[el].sy, guiElements[el].color2)
    end
  end
  function fadeIn(el, time, inclChildren)
    if tonumber(el) and guiElements[el] then
      guiElements[el].fadeIn = now
      guiElements[el].fadeInTime = time
      if inclChildren then
        for k = 1, #guiElements[el].children do
          fadeIn(guiElements[el].children[k], time, inclChildren)
        end
      end
    else
      throwGuiError("fadeIn: invalid guiElement (" .. tostring(el) .. ")")
    end
  end
  function fadeOut(el, time, inclChildren)
    if tonumber(el) and guiElements[el] then
      guiElements[el].fadeOut = now
      guiElements[el].fadeOutTime = time
      if inclChildren then
        for k = 1, #guiElements[el].children do
          fadeOut(guiElements[el].children[k], time, inclChildren)
        end
      end
    else
      throwGuiError("fadeOut: invalid guiElement (" .. tostring(el) .. ")")
    end
  end
  function fadeInLabel(el, time)
    fadeIn(el, time)
  end
  function fadeOutLabel(el, time)
    fadeOut(el, time)
  end
  function fadeInImage(el, time)
    fadeIn(el, time)
  end
  function fadeOutImage(el, time)
    fadeOut(el, time)
  end
  local infoboxTypes = {
    w = {
      "files/w.dds",
      "v4orange",
      "#ffffff",
      "Figyelmeztetés",
      "warning.wav"
    },
    e = {
      "files/e.dds",
      "v4red",
      "#ffffff",
      "Hiba",
      "error.wav"
    },
    i = {
      "files/i.dds",
      "v4blue",
      "#ffffff",
      "Információ",
      "noti.wav"
    },
    s = {
      "files/s.dds",
      "v4green",
      "#ffffff",
      "Siker",
      "success.wav"
    },
    g = {
      "files/duty.dds",
      "v4blue-second",
      "#ffffff",
      "AdminDuty",
      "duty.wav"
    },
    o = {
      "files/duty.dds",
      "v4blue-second",
      "#ffffff",
      "AdminDuty",
      "offduty.wav"
    },
    a = {
      "files/w.dds",
      "v4red-second",
      "#ffffff",
      "Admin Felhívás",
      "asay.wav",
      true
    }
  }
  local infoboxes = {}
  local infoboxHeight = 40
  local infoboxChatbox = true
  function getInfoboxChatbox()
    return infoboxChatbox
  end
  function setInfoboxChatbox(val)
    infoboxChatbox = val
  end
  local infoboxSound = true
  function getInfoboxSound()
    return infoboxSound
  end
  function setInfoboxSound(val)
    infoboxSound = val
  end
  function showInfobox(info, text, time, grouping)
    if type(info) == "string" then
      info = infoboxTypes[utf8.sub(info, 1, 1)]
    end
    if type(info) == "table" then
      local icon = info[1]
      local color = getColorCodeToColor(info[2])
      local color2 = getColorCodeToColor(info[3])
      if infoboxSound or info[6] then
        local s = playSound("sounds/" .. info[5])
        if info[6] then
          setSoundVolume(s, 2.5)
        end
      end
      local font = getFont("11/Ubuntu-L.ttf")
      local textWidth = getTextWidthFont(text, font)
      local fontPadding = math.floor((infoboxHeight - getFontHeight(font)) / 2)
      if not tonumber(time) then
        time = math.max(4000, utf8.len(text) * 120)
      end
      local y = 0
      local ty = 0
      if 0 < #infoboxes then
        y = infoboxes[#infoboxes][12] + (infoboxHeight + 8)
        ty = infoboxes[#infoboxes][13] + (infoboxHeight + 8)
        for k = 1, #infoboxes do
          if (infoboxes[k][2] == text or grouping and infoboxes[k][15] == grouping) and infoboxes[k][4] == icon and not infoboxes[k][14] then
            infoboxes[k][1] = now - infoboxes[k][11] - 250
            infoboxes[k][14] = true
          end
        end
      else
        y = 16
        ty = 16
      end
      table.insert(infoboxes, {
        now,
        text,
        textWidth,
        icon,
        color,
        color2,
        false,
        false,
        font,
        fontPadding,
        time,
        y,
        ty,
        false,
        grouping
      })
      if not info[6] then
        if infoboxChatbox then
          outputChatBox("[color=" .. info[2] .. "][V4Mod - " .. info[4] .. "]: #ffffff" .. text, 255, 255, 255, true)
        else
          outputConsole("[V4Mod - " .. info[4] .. "]: " .. text)
        end
      end
    end
  end
  addEvent("showInfobox", true)
  addEventHandler("showInfobox", getRootElement(), showInfobox)
  local loadingScreenData = false
  function getLoadingScreen()
    return loadingScreenData
  end
  function endLoadingScreen()
    if loadingScreenData then
      loadingScreenData[8] = now
    end
  end
  function showLoadingScreen(time, text, noUnload)
    loadingScreenData = {
      getColorCodeToColor("v4grey1"),
      getColorCodeToColor("v4midgrey"),
      getColorCodeToColor("v4green"),
      getFont("11/Ubuntu-L.ttf"),
      now,
      time,
      text or "Betöltés...",
      noUnload
    }
  end
  local fpsDeltas = {}
  local fpsDelta = 1
  local gpuFont = false
  local gpuFontH = false
  local fpsFont = false
  local fpsFontH = false
  local fpsFont2 = false
  local gpuWidgetPos = {0, 0}
  local gpuWidgetSize = {256, 256}
  local gpuWidgetState = false
  local fpsWidgetPos = {0, 0}
  local fpsWidgetSize = {256, 256}
  local fpsWidgetState = false
  local fpsSmallWidgetPos = {0, 0}
  local fpsSmallWidgetSize = {256, 256}
  local fpsSmallWidgetState = false
  local fpsGreen = false
  local fpsYellow = false
  local fpsOrange = false
  local fpsRed = false
  local fpsGrey = false
  local fpsLightGrey = false
  addEvent("onGuiRefreshColors", true)
  addEventHandler("onGuiRefreshColors", getRootElement(), function()
    fpsGreen = getColorCodeToColor("v4green")
    fpsLightGrey = getColorCodeToColor("v4lightgrey")
    fpsGrey = bitReplace(getColorCodeToColor("v4grey1"), 174, 24, 8)
    fpsYellow = getColorCodeToColor("v4yellow")
    fpsRed = getColorCodeToColor("v4red")
    fpsOrange = getColorCodeToColor("v4orange")
  end)
  function renderGPUWidget()
    local status = dxGetStatus()
    local color = "16"
    if status.Setting32BitColor then
      color = "32"
    end
    local text = "vram: " .. status.VideoCardRAM - status.VideoMemoryFreeForMTA .. "/" .. status.VideoCardRAM .. "mb, font: " .. status.VideoMemoryUsedByFonts .. [[
  mb,
  textures: ]] .. status.VideoMemoryUsedByTextures .. "mb, rtarget: " .. status.VideoMemoryUsedByRenderTargets .. [[
  mb,
  ratio: ]] .. status.SettingAspectRatio .. ", size: " .. screenX .. "x" .. screenY .. "x" .. color
    if not (fpsFontH and gpuFontH and fpsFont) or not gpuFont then
      fpsFont = getFont("15/BebasNeueBold.otf")
      fpsFontH = getFontHeight("15/BebasNeueBold.otf")
      gpuFont = getFont("11/Ubuntu-L.ttf")
      gpuFontH = getFontHeight("11/Ubuntu-L.ttf")
    end
    local y = gpuWidgetPos[2] + gpuWidgetSize[2] / 2 - (gpuFontH + fpsFontH * 3) / 2
    dxDrawText(status.VideoCardName, gpuWidgetPos[1], y, gpuWidgetPos[1] + gpuWidgetSize[1], 0, fpsGreen, fontScales[fpsFont], fpsFont, "left", "top")
    dxDrawText(text, gpuWidgetPos[1], y + fpsFontH, gpuWidgetPos[1] + gpuWidgetSize[1], 0, fpsLightGrey, fontScales[fpsFont], gpuFont, "left", "top")
  end
  addEvent("hudWidgetState:gpuData", true)
  addEventHandler("hudWidgetState:gpuData", getRootElement(), function(state)
    if gpuWidgetState ~= state then
      gpuWidgetState = state
      if gpuWidgetState then
        addEventHandler("onClientRender", getRootElement(), renderGPUWidget)
        if not fpsFont then
          fpsFont = getFont("15/BebasNeueBold.otf")
          fpsFontH = getFontHeight("15/BebasNeueBold.otf")
          gpuFont = getFont("11/Ubuntu-L.ttf")
          gpuFontH = getFontHeight("11/Ubuntu-L.ttf")
        end
        fpsGreen = getColorCodeToColor("v4green")
        fpsLightGrey = getColorCodeToColor("v4lightgrey")
      else
        removeEventHandler("onClientRender", getRootElement(), renderGPUWidget)
      end
    end
  end)
  addEvent("hudWidgetPosition:gpuData", true)
  addEventHandler("hudWidgetPosition:gpuData", getRootElement(), function(pos, final)
    gpuWidgetPos = pos
  end)
  addEvent("hudWidgetSize:gpuData", true)
  addEventHandler("hudWidgetSize:gpuData", getRootElement(), function(size, final)
    gpuWidgetSize = size
  end)
  local fpsAvg = 0
  local fpsSum = 0
  local fpsCount = 0
  addEventHandler("onClientRender", getRootElement(), function()
    local fps = 1000 / fpsDelta
    fpsSum = fpsSum + fps
    fpsCount = fpsCount + 1
    if 30 < fpsCount then
      fpsAvg = math.floor(fpsSum / fpsCount + 0.5)
      fpsSum = 0
      fpsCount = 0
    end
  end)
  function renderFpsWidget()
    if fpsAvg < 10 and 5 <= fpsAvg then
      dxDrawText(fpsAvg .. " FPS", fpsWidgetPos[1], fpsWidgetPos[2], 0, 0, fpsOrange, fontScales[fpsFont], fpsFont, "left", "top")
    elseif fpsAvg < 20 and 10 <= fpsAvg then
      dxDrawText(fpsAvg .. " FPS", fpsWidgetPos[1], fpsWidgetPos[2], 0, 0, fpsYellow, fontScales[fpsFont], fpsFont, "left", "top")
    elseif 20 <= fpsAvg then
      dxDrawText(fpsAvg .. " FPS", fpsWidgetPos[1], fpsWidgetPos[2], 0, 0, fpsGreen, fontScales[fpsFont], fpsFont, "left", "top")
    else
      dxDrawText(fpsAvg .. " FPS", fpsWidgetPos[1], fpsWidgetPos[2], 0, 0, fpsRed, fontScales[fpsFont], fpsFont, "left", "top")
    end
    local oneSize = math.max(1, (fpsWidgetSize[1] - 16) / 239)
    local x = fpsWidgetPos[1] + 16
    local y = fpsWidgetPos[2] + fpsWidgetSize[2]
    local max = fpsWidgetSize[2] - fpsFontH - 8
    for fps = 0, 60, 10 do
      local yp = y - max * (fps / 60)
      dxDrawText(fps, 0, yp, x - 4, yp, fpsGrey, fontScales[fpsFont2], fpsFont2, "right", "center")
      dxDrawLine(x, yp, fpsWidgetPos[1] + fpsWidgetSize[1], yp, fpsGrey)
    end
    local lastX = x
    for k = 2, 239 do
      if fpsDeltas[k] then
        local y1 = 1000 / (tonumber(fpsDeltas[k - 1]) or 1000)
        local y2 = 1000 / (tonumber(fpsDeltas[k]) or 1000)
        lastX = x
        x = x + oneSize * fpsDeltas[k] / 13
        local color = fpsRed
        if 10 > math.min(y1, y2) and 5 <= math.min(y1, y2) then
          color = fpsOrange
        elseif 20 > math.min(y1, y2) and 10 <= math.min(y1, y2) then
          color = fpsYellow
        elseif 20 <= math.min(y1, y2) then
          color = fpsGreen
        end
        dxDrawLine(lastX, y - max * (y1 / 75), x, y - max * (y2 / 75), color)
        if x > fpsWidgetPos[1] + fpsWidgetSize[1] then
          break
        end
      end
    end
  end
  function renderFpsSmallWidget()
    if fpsAvg < 10 and 5 <= fpsAvg then
      dxDrawText(fpsAvg .. " FPS", fpsSmallWidgetPos[1], fpsSmallWidgetPos[2], fpsSmallWidgetPos[1] + fpsSmallWidgetSize[1], fpsSmallWidgetPos[2] + fpsSmallWidgetSize[2], fpsOrange, fontScales[fpsFont], fpsFont, "center", "center")
    elseif fpsAvg < 20 and 10 <= fpsAvg then
      dxDrawText(fpsAvg .. " FPS", fpsSmallWidgetPos[1], fpsSmallWidgetPos[2], fpsSmallWidgetPos[1] + fpsSmallWidgetSize[1], fpsSmallWidgetPos[2] + fpsSmallWidgetSize[2], fpsYellow, fontScales[fpsFont], fpsFont, "center", "center")
    elseif 20 <= fpsAvg then
      dxDrawText(fpsAvg .. " FPS", fpsSmallWidgetPos[1], fpsSmallWidgetPos[2], fpsSmallWidgetPos[1] + fpsSmallWidgetSize[1], fpsSmallWidgetPos[2] + fpsSmallWidgetSize[2], fpsGreen, fontScales[fpsFont], fpsFont, "center", "center")
    else
      dxDrawText(fpsAvg .. " FPS", fpsSmallWidgetPos[1], fpsSmallWidgetPos[2], fpsSmallWidgetPos[1] + fpsSmallWidgetSize[1], fpsSmallWidgetPos[2] + fpsSmallWidgetSize[2], fpsRed, fontScales[fpsFont], fpsFont, "center", "center")
    end
  end
  addEvent("hudWidgetState:fpsGraph", true)
  addEventHandler("hudWidgetState:fpsGraph", getRootElement(), function(state)
    if fpsWidgetState ~= state then
      fpsWidgetState = state
      if fpsWidgetState then
        addEventHandler("onClientRender", getRootElement(), renderFpsWidget)
        if not fpsFont then
          fpsFont = getFont("15/BebasNeueBold.otf")
          fpsFontH = getFontHeight("15/BebasNeueBold.otf")
        end
        if not fpsFont2 then
          fpsFont2 = getFont("10/BebasNeueLight.otf")
        end
        fpsGreen = getColorCodeToColor("v4green")
        fpsYellow = getColorCodeToColor("v4yellow")
        fpsRed = getColorCodeToColor("v4red")
        fpsGrey = bitReplace(getColorCodeToColor("v4grey1"), 174, 24, 8)
      else
        removeEventHandler("onClientRender", getRootElement(), renderFpsWidget)
      end
    end
  end)
  addEvent("hudWidgetState:smallFps", true)
  addEventHandler("hudWidgetState:smallFps", getRootElement(), function(state)
    if fpsSmallWidgetState ~= state then
      fpsSmallWidgetState = state
      if fpsSmallWidgetState then
        addEventHandler("onClientRender", getRootElement(), renderFpsSmallWidget)
        if not fpsFont then
          fpsFont = getFont("15/BebasNeueBold.otf")
          fpsFontH = getFontHeight("15/BebasNeueBold.otf")
        end
        fpsGreen = getColorCodeToColor("v4green")
        fpsYellow = getColorCodeToColor("v4yellow")
        fpsOrange = getColorCodeToColor("v4yorange")
        fpsRed = getColorCodeToColor("v4red")
      else
        removeEventHandler("onClientRender", getRootElement(), renderFpsSmallWidget)
      end
    end
  end)
  addEvent("hudWidgetPosition:smallFps", true)
  addEventHandler("hudWidgetPosition:smallFps", getRootElement(), function(pos, final)
    fpsSmallWidgetPos = pos
  end)
  addEvent("hudWidgetSize:smallFps", true)
  addEventHandler("hudWidgetSize:smallFps", getRootElement(), function(size, final)
    fpsSmallWidgetSize = size
  end)
  addEvent("hudWidgetPosition:fpsGraph", true)
  addEventHandler("hudWidgetPosition:fpsGraph", getRootElement(), function(pos, final)
    fpsWidgetPos = pos
  end)
  addEvent("hudWidgetSize:fpsGraph", true)
  addEventHandler("hudWidgetSize:fpsGraph", getRootElement(), function(size, final)
    fpsWidgetSize = size
  end)
  addEventHandler("onClientResourceStart", getResourceRootElement(), function()
    triggerEvent("requestWidgetDatas", localPlayer, "gpuData")
    triggerEvent("requestWidgetDatas", localPlayer, "fpsGraph")
    triggerEvent("requestWidgetDatas", localPlayer, "smallFps")
  end)
  local infoHover = false
  local tmpActiveInput = false
  addEvent("onActiveInputChange", false)
  local ddsScreenShader = false
  local ddsScreenSrc = false
  local ddsShaderSource = " texture texture0; float factor; sampler Sampler0 = sampler_state { Texture = (texture0); AddressU = MIRROR; AddressV = MIRROR; }; struct PSInput { float2 TexCoord : TEXCOORD0; }; float4 PixelShader_Background(PSInput PS) : COLOR0 { float4 sum = tex2D(Sampler0, PS.TexCoord); for (float i = 1; i < 3; i++) { sum += tex2D(Sampler0, float2(PS.TexCoord.x, PS.TexCoord.y + (i * factor))); sum += tex2D(Sampler0, float2(PS.TexCoord.x, PS.TexCoord.y - (i * factor))); sum += tex2D(Sampler0, float2(PS.TexCoord.x - (i * factor), PS.TexCoord.y)); sum += tex2D(Sampler0, float2(PS.TexCoord.x + (i * factor), PS.TexCoord.y)); } sum /= 9; sum.a = 1.0; return sum; } technique complercated { pass P0 { PixelShader = compile ps_2_0 PixelShader_Background(); } } technique simple { pass P0 { Texture[0] = texture0; } } "
  local ddsPreviewTexture = false
  local ddsPreviewFile = false
  local ddsPreviewFormat = false
  local ddsPreviewMip = false
  local ddsPreviewLatent = false
  local ddsPreviewU = 0
  local ddsPreviewV = 0
  local ddsPreviewUS = 0
  local ddsPreviewVS = 0
  local ddsPreviewX = 0
  local ddsPreviewY = 0
  local ddsPreviewSX = 0
  local ddsPreviewSY = 0
  local ddsPreviewZoom = 1
  local ddsPreviewMinZoom = false
  local ddsPreviewMoving = false
  function ddsPreviewClampCoords()
    local sx, sy = ddsPreviewSX * ddsPreviewZoom, ddsPreviewSY * ddsPreviewZoom
    local maximumX = math.abs(sx - screenX) / 2
    local maximumY = math.abs(sy - screenY) / 2
    if maximumX < ddsPreviewX then
      ddsPreviewX = maximumX
    elseif ddsPreviewX < -maximumX then
      ddsPreviewX = -maximumX
    end
    if maximumY < ddsPreviewY then
      ddsPreviewY = maximumY
    elseif ddsPreviewY < -maximumY then
      ddsPreviewY = -maximumY
    end
  end
  function ddsPreviewCursor(rx, ry, cx, cy)
    if isCursorShowing() then
      ddsPreviewX = ddsPreviewMoving[1] + (ddsPreviewMoving[3] - cx)
      ddsPreviewY = ddsPreviewMoving[2] + (ddsPreviewMoving[4] - cy)
      ddsPreviewClampCoords()
      ddsPreviewMoving[1] = ddsPreviewX
      ddsPreviewMoving[2] = ddsPreviewY
      ddsPreviewMoving[3] = cx
      ddsPreviewMoving[4] = cy
    else
      ddsPreviewMoving = false
      seelangCondHandl1(false)
    end
  end
  function ddsPreviewClick(key, state, cx, cy)
    if state == "down" and ddsPreviewMinZoom then
      ddsPreviewMoving = {
        ddsPreviewX,
        ddsPreviewY,
        cx,
        cy
      }
      seelangCondHandl1(true)
    elseif ddsPreviewMoving then
      ddsPreviewMoving = false
      seelangCondHandl1(false)
    end
  end
  function ddsPreviewZoomKey(key)
    if key == "backspace" then
      setDDSPreview(false)
    elseif ddsPreviewMinZoom then
      if key == "mouse_wheel_up" then
        if ddsPreviewZoom < 1.5 then
          ddsPreviewZoom = ddsPreviewZoom + 0.1
          ddsPreviewClampCoords()
        end
      elseif key == "mouse_wheel_down" and ddsPreviewZoom > ddsPreviewMinZoom then
        ddsPreviewZoom = ddsPreviewZoom - 0.1
        ddsPreviewClampCoords()
      end
    end
  end
  function setTexturePreview(texture, u, v, us, vs, black)
    ddsPreviewX = 0
    ddsPreviewY = 0
    ddsPreviewZoom = 1
    ddsPreviewMinZoom = false
    if isElement(ddsScreenShader) then
      destroyElement(ddsScreenShader)
    end
    ddsScreenShader = nil
    if isElement(ddsScreenSrc) then
      destroyElement(ddsScreenSrc)
    end
    ddsScreenSrc = nil
    ddsPreviewMoving = false
    seelangCondHandl1(false)
    if texture then
      if not black then
        ddsScreenSrc = dxCreateScreenSource(screenX, screenY)
        ddsScreenShader = dxCreateShader(ddsShaderSource)
        dxSetShaderValue(ddsScreenShader, "UVSize", screenX, screenY)
        dxSetShaderValue(ddsScreenShader, "factor", 0.0016)
        dxSetShaderValue(ddsScreenShader, "texture0", ddsScreenSrc)
      end
      ddsPreviewTexture = texture
      ddsPreviewFile = false
      ddsPreviewFormat = false
      ddsPreviewMip = false
      ddsPreviewLatent = false
      ddsPreviewU = u
      ddsPreviewV = v
      ddsPreviewUS = us
      ddsPreviewVS = vs
      ddsPreviewSX = false
      ddsPreviewSY = false
      showCursor(false)
      showChat(false)
      seelangCondHandl2(true)
      seelangCondHandl3(true)
      showInfobox("i", "A képnézegetőt a Backspace gombbal zárhatod be.")
    else
      ddsPreviewTexture = false
      ddsPreviewFile = false
      ddsPreviewFormat = false
      ddsPreviewMip = false
      ddsPreviewLatent = false
      ddsPreviewSX = false
      ddsPreviewSY = false
      ddsPreviewU = false
      ddsPreviewV = false
      ddsPreviewUS = false
      ddsPreviewVS = false
      showCursor(togCursorState)
      showChat(true)
      seelangCondHandl2(false)
      seelangCondHandl3(false)
    end
  end
  function setDDSPreview(file, format, mipMap, latent, u, v, us, vs, black)
    ddsPreviewX = 0
    ddsPreviewY = 0
    ddsPreviewZoom = 1
    ddsPreviewMinZoom = false
    if isElement(ddsScreenShader) then
      destroyElement(ddsScreenShader)
    end
    ddsScreenShader = nil
    if isElement(ddsScreenSrc) then
      destroyElement(ddsScreenSrc)
    end
    ddsScreenSrc = nil
    ddsPreviewMoving = false
    seelangCondHandl1(false)
    if file then
      if not black then
        ddsScreenSrc = dxCreateScreenSource(screenX, screenY)
        ddsScreenShader = dxCreateShader(ddsShaderSource)
        dxSetShaderValue(ddsScreenShader, "UVSize", screenX, screenY)
        dxSetShaderValue(ddsScreenShader, "factor", 0.0016)
        dxSetShaderValue(ddsScreenShader, "texture0", ddsScreenSrc)
      end
      ddsPreviewFile = file
      ddsPreviewFormat = format
      ddsPreviewMip = mipMap
      ddsPreviewLatent = latent
      ddsPreviewU = u
      ddsPreviewV = v
      ddsPreviewUS = us
      ddsPreviewVS = vs
      ddsPreviewSX = false
      ddsPreviewSY = false
      showCursor(true)
      showChat(false)
      seelangCondHandl2(true)
      seelangCondHandl3(true)
      showInfobox("i", "A képnézegetőt a Backspace gombbal zárhatod be.")
    else
      ddsPreviewTexture = false
      ddsPreviewFile = false
      ddsPreviewFormat = false
      ddsPreviewMip = false
      ddsPreviewLatent = false
      ddsPreviewSX = false
      ddsPreviewSY = false
      ddsPreviewU = false
      ddsPreviewV = false
      ddsPreviewUS = false
      ddsPreviewVS = false
      showCursor(togCursorState)
      showChat(true)
      seelangCondHandl2(false)
      seelangCondHandl3(false)
    end
  end
  function getDDSPreview()
    if ddsPreviewTexture then
      return ddsPreviewTexture
    else
      return ddsPreviewFile, ddsPreviewFormat, ddsPreviewMip, ddsPreviewLatent
    end
  end
  addEventHandler("onClientRender", getRootElement(), function()
    if activeInput ~= tmpActiveInput then
      triggerEvent("onActiveInputChange", localPlayer, activeInput, tmpActiveInput)
      tmpActiveInput = activeInput
      focusPasteBrowser()
    end
    local tmp = false
    local minY = screenY
    local minBox = false
    for k = #infoboxes, 1, -1 do
      if infoboxes[k] then
        local y = infoboxes[k][12]
        if minY > y then
          minY = y
          minBox = k
        end
      end
    end
    for k = #infoboxes, 1, -1 do
      if infoboxes[k] then
        local y = infoboxes[k][12]
        local fadeIn = math.min(1, (now - infoboxes[k][1]) / 250)
        if 1 <= fadeIn and k ~= minBox and not infoboxes[k][14] then
          infoboxes[k][1] = now - 250
        end
        local progress = math.min(1, (now - infoboxes[k][1] - 250) / infoboxes[k][11])
        local width = infoboxes[k][3] + infoboxHeight + infoboxes[k][10] + 16
        local xAlpha = 100
        if 1 <= fadeIn and progress < 1 and not infoboxes[k][14] and cx and cx >= screenX / 2 + width / 2 - 16 and cx <= screenX / 2 + width / 2 and y <= cy and cy <= y + infoboxHeight then
          xAlpha = 255
          tmp = k
        end
        if 1 <= progress then
          fadeIn = 1 - math.min(1, (now - infoboxes[k][1] - infoboxes[k][11] - 250) / 250)
        end
        dxDrawRectangle(screenX / 2 - width / 2, y, width, infoboxHeight, bitReplace(infoboxes[k][5], fadeIn * 175, 24, 8))
        if not infoboxes[k][14] then
          dxDrawText("X", screenX / 2 + width / 2 - 16, y, screenX / 2 + width / 2, y + infoboxHeight, tocolor(255, 255, 255, xAlpha * fadeIn), fontScales[infoboxes[k][9]], infoboxes[k][9], "center", "center", false, false, false, true)
        end
        local grossW = (width + infoboxHeight + 4) * 2
        local p = 0
        dxDrawRectangle(screenX / 2 - width / 2, y - 2, width, 2, bitReplace(infoboxes[k][5], fadeIn * 100, 24, 8))
        dxDrawRectangle(screenX / 2 + width / 2, y - 2, 2, infoboxHeight + 4, bitReplace(infoboxes[k][5], fadeIn * 100, 24, 8))
        dxDrawRectangle(screenX / 2 - width / 2, y + infoboxHeight, width, 2, bitReplace(infoboxes[k][5], fadeIn * 100, 24, 8))
        dxDrawRectangle(screenX / 2 - width / 2 - 2, y - 2, 2, infoboxHeight + 4, bitReplace(infoboxes[k][5], fadeIn * 100, 24, 8))
        local w = width / 2
        local pr = math.max(math.min(1, (1 - progress - p) / (w / grossW)), 0)
        dxDrawRectangle(screenX / 2 - width / 2 + w - w * pr, y - 2, w * pr, 2, bitReplace(infoboxes[k][5], fadeIn * 255, 24, 8))
        p = p + w / grossW
        local w = infoboxHeight + 4
        local pr = math.max(math.min(1, (1 - progress - p) / (w / grossW)), 0)
        dxDrawRectangle(screenX / 2 - width / 2 - 2, y - 2, 2, w * pr, bitReplace(infoboxes[k][5], fadeIn * 255, 24, 8))
        p = p + w / grossW
        local w = width
        local pr = math.max(math.min(1, (1 - progress - p) / (w / grossW)), 0)
        dxDrawRectangle(screenX / 2 - width / 2, y + infoboxHeight, w * pr, 2, bitReplace(infoboxes[k][5], fadeIn * 255, 24, 8))
        p = p + w / grossW
        local w = infoboxHeight + 4
        local pr = math.max(math.min(1, (1 - progress - p) / (w / grossW)), 0)
        dxDrawRectangle(screenX / 2 + width / 2, y - 2 + w - w * pr, 2, w * pr, bitReplace(infoboxes[k][5], fadeIn * 255, 24, 8))
        p = p + w / grossW
        local w = width / 2
        local pr = math.max(math.min(1, (1 - progress - p) / (w / grossW)), 0)
        dxDrawRectangle(screenX / 2 + w - w * pr, y - 2, w * pr, 2, bitReplace(infoboxes[k][5], fadeIn * 255, 24, 8))
        seelangStaticImageUsed[0] = true
        if seelangStaticImageToc[0] then
          processSeelangStaticImage[0]()
        end
        dxDrawImage(screenX / 2 - width / 2, y, infoboxHeight, infoboxHeight, seelangStaticImage[0], 0, 0, 0, bitReplace(infoboxes[k][5], fadeIn * 255, 24, 8))
        dxDrawImage(screenX / 2 - width / 2 + (infoboxHeight - 32) / 2, y + (infoboxHeight - 32) / 2, 32, 32, dynamicImage(infoboxes[k][4]), 0, 0, 0, bitReplace(infoboxes[k][6], fadeIn * 255, 24, 8))
        dxDrawText(infoboxes[k][2], screenX / 2 - width / 2 + infoboxHeight, y, screenX / 2 + width / 2 - 16, y + infoboxHeight, bitReplace(infoboxes[k][6], fadeIn * 255, 24, 8), fontScales[infoboxes[k][9]], infoboxes[k][9], "center", "center", false, false, false, true)
        if 1 <= progress and fadeIn <= 0 then
          for i = k + 1, #infoboxes do
            infoboxes[i][13] = infoboxes[i][13] - (infoboxHeight + 8)
          end
          table.remove(infoboxes, k)
        end
      end
    end
    if tmp ~= infoHover then
      infoHover = tmp
      seexports.rl_gui:setCursorType(infoHover and "link" or "normal")
    end
    if loadingScreenData then
      local progress = math.min(1, (now - loadingScreenData[5]) / loadingScreenData[6])
      local fadeIn = math.min(1, (now - loadingScreenData[5]) / 250)
      if 1 <= progress then
        if tonumber(loadingScreenData[8]) then
          fadeIn = 1 - math.min(1, (now - loadingScreenData[5]) / 250)
        elseif loadingScreenData[8] then
          fadeIn = 1
        else
          fadeIn = 1 - math.min(1, (now - loadingScreenData[5] - loadingScreenData[6]) / 250)
        end
      end
      dxDrawRectangle(0, 0, screenX, screenY, bitReplace(loadingScreenData[1], fadeIn * 255, 24, 8))
      seelangStaticImageUsed[1] = true
      if seelangStaticImageToc[1] then
        processSeelangStaticImage[1]()
      end
      dxDrawImage(0, 0, screenX, screenY, seelangStaticImage[1], 0, 0, 0, tocolor(255, 255, 255, fadeIn * 255))
      dxDrawRectangle(32, screenY - 32 - 4, screenX - 64, 4, bitReplace(loadingScreenData[2], fadeIn * 255, 24, 8))
      seelangStaticImageUsed[2] = true
      if seelangStaticImageToc[2] then
        processSeelangStaticImage[2]()
      end
      dxDrawImage(19, screenY - 32 - 2 - 16, 13, 32, seelangStaticImage[2], 0, 0, 0, bitReplace(loadingScreenData[3], fadeIn * 255, 24, 8))
      seelangStaticImageUsed[2] = true
      if seelangStaticImageToc[2] then
        processSeelangStaticImage[2]()
      end
      dxDrawImage(32 + (screenX - 64) * progress, screenY - 32 - 2 - 16, 13, 32, seelangStaticImage[2], 180, 0, 0, bitReplace(loadingScreenData[3], fadeIn * 255, 24, 8))
      seelangStaticImageUsed[3] = true
      if seelangStaticImageToc[3] then
        processSeelangStaticImage[3]()
      end
      dxDrawImage(32, screenY - 32 - 2 - 16, (screenX - 64) * progress, 32, seelangStaticImage[3], 0, 0, 0, bitReplace(loadingScreenData[3], fadeIn * 255, 24, 8))
      dxDrawRectangle(32, screenY - 32 - 4, (screenX - 64) * progress, 4, bitReplace(loadingScreenData[3], fadeIn * 255, 24, 8))
      seelangStaticImageUsed[4] = true
      if seelangStaticImageToc[4] then
        processSeelangStaticImage[4]()
      end
      dxDrawImage(screenX - 32 - 128, screenY - 64 - 4 - 115.2, 128, 128, seelangStaticImage[4], 0, 0, 0, tocolor(255, 255, 255, fadeIn * 255))
      dxDrawText(loadingScreenData[7], screenX - 32 - 128, screenY - 64 - 4, screenX - 32, screenY - 32 - 4, tocolor(255, 255, 255, fadeIn * 255), fontScales[loadingScreenData[4]], loadingScreenData[4], "center", "center", false, false, false, true)
      if 1 <= progress and fadeIn <= 0 then
        loadingScreenData = false
        triggerEvent("doneLoadingScreen", localPlayer)
      end
    end
    if cx then
      if ddsPreviewFile or ddsPreviewTexture then
        seelangStaticImageUsed[5] = true
        if seelangStaticImageToc[5] then
          processSeelangStaticImage[5]()
        end
        dxDrawImage(cx - 16, cy, 32, 16, seelangStaticImage[5], 0, 0, 0, tocolor(255, 255, 255), true)
      elseif movingWindow then
        seelangStaticImageUsed[5] = true
        if seelangStaticImageToc[5] then
          processSeelangStaticImage[5]()
        end
        dxDrawImage(cx - 16, cy, 32, 16, seelangStaticImage[5], 0, 0, 0, tocolor(255, 255, 255), true)
      elseif hoverElement and guiElements[hoverElement] and not guiElements[hoverElement].disableLinkCursor then
        if guiElements[hoverElement] and guiElements[hoverElement].type == "window" and (not guiElements[hoverElement].closeIcon or 0 >= guiElements[hoverElement].hoverAlpha) then
          seelangStaticImageUsed[5] = true
          if seelangStaticImageToc[5] then
            processSeelangStaticImage[5]()
          end
          dxDrawImage(cx - 16, cy, 32, 16, seelangStaticImage[5], 0, 0, 0, tocolor(255, 255, 255), true)
        else
          seelangStaticImageUsed[6] = true
          if seelangStaticImageToc[6] then
            processSeelangStaticImage[6]()
          end
          dxDrawImage(cx - 16, cy, 32, 16, seelangStaticImage[6], 0, 0, 0, tocolor(255, 255, 255), true)
        end
      elseif cursorType ~= "none" then
        dxDrawImage(cx - 16, cy, 32, 16, cursorTextures[cursorType], 0, 0, 0, tocolor(255, 255, 255), true)
      end
      if tooltipImage then
        local sx, sy = tooltipImageSX, tooltipImageSY
        local x = cx
        local y = cy
        if tooltipPosX == "right" and x + 8 + sx + 4 < screenX then
          x = x + 8
        elseif x - sx - 8 - 4 > 0 then
          x = x - sx - 8
        else
          x = x + 8
        end
        if tooltipPosY == "down" and y + 16 + sy + 4 < screenY then
          y = y + 16
        elseif y - sy - 4 > 0 then
          y = y - sy
        else
          y = y + 16
        end
        dxDrawRectangle(x, y, sx, sy, tocolor(0, 0, 0, 200))
        if tooltipImageDDS then
          dxDrawImage(x, y, sx, sy, dynamicImage(tooltipImage))
        else
          dxDrawImage(x, y, sx, sy, tooltipImage)
        end
      elseif tooltipText and tooltipText ~= true then
        local dat = split(tooltipText, "\n")
        for k = 1, #dat do
          if not currentTooltipText[k] then
            currentTooltipText[k] = {}
          end
          if currentTooltipText[k][1] ~= dat[k] then
            currentTooltipText[k][1] = dat[k]
            currentTooltipText[k][2] = getTextWidthFont(dat[k], tooltipFont) + 8
            currentTooltipText[k][3] = getFontHeight(tooltipFont) + 4
            currentTooltipText[k][4] = currentTooltipText[k - 1] and currentTooltipText[k - 1][3] + currentTooltipText[k - 1][4] or 0
          end
          local x = cx
          local y = cy + currentTooltipText[k][4]
          if tooltipPosX == "right" and x + 8 + currentTooltipText[k][2] + 4 < screenX then
            x = x + 8
          elseif x - currentTooltipText[k][2] - 8 - 4 > 0 then
            x = x - currentTooltipText[k][2] - 8
          else
            x = x + 8
          end
          if tooltipPosY == "down" and y + 16 + currentTooltipText[k][3] + 4 < screenY then
            y = y + 16
          elseif y - currentTooltipText[k][3] - 4 > 0 then
            y = y - currentTooltipText[k][3]
          else
            y = y + 16
          end
          dxDrawRectangle(x, y, currentTooltipText[k][2], currentTooltipText[k][3], tocolor(0, 0, 0, 200))
          dxDrawText(dat[k], x + 4, y + 2, 0, 0, tocolor(255, 255, 255), fontScales[tooltipFont], tooltipFont, "left", "top", false, false, false, true)
        end
      end
    end
  end, true, "low-9999999999999999999")
  addEventHandler("onClientRender", getRootElement(), function()
    now = getTickCount()
    for k = #guiAnimations, 1, -1 do
      if guiAnimations[k] then
        local progress = getEasingValue(math.min(1, (now - guiAnimations[k][1]) / guiAnimations[k][2]), guiAnimations[k][6] or "Linear")
        local el = guiAnimations[k][4]
        if guiElements[el] then
          for i, v in pairs(guiAnimations[k][5]) do
            guiElements[el][i] = v[1] + (v[2] - v[1]) * progress
          end
        end
        if 1 <= progress then
          if guiAnimations[k][3] then
            triggerEvent(guiAnimations[k][3], localPlayer, el)
          end
          table.remove(guiAnimations, k)
        end
      end
    end
    for k = 1, #renderList do
      if renderList[k] then
        local el = renderList[k]
        if not guiElements[el].disableRender then
          if guiElements[el].updateScreenSource then
            dxUpdateScreenSource(guiElements[el].updateScreenSource, guiElements[el].updateScreenSourceResample)
          end
          if renderFunctions[guiElements[el].type] then
            renderFunctions[guiElements[el].type](el)
          elseif guiElements[el].backgroundType then
            renderBackground(el)
          end
        end
      end
    end
    if ddsPreviewFile or ddsPreviewTexture then
      local tex = false
      if ddsPreviewTexture then
        tex = ddsPreviewTexture
        if not isElement(tex) then
          setDDSPreview(false)
          tex = nil
        end
      elseif ddsPreviewLatent then
        tex = latentDynamicImage(ddsPreviewFile, ddsPreviewFormat, ddsPreviewMip)
      else
        tex = dynamicImage(ddsPreviewFile, ddsPreviewFormat, ddsPreviewMip)
      end
      if tex then
        if ddsPreviewTexture then
          local sx, sy = dxGetMaterialSize(ddsPreviewTexture)
          if sx ~= ddsPreviewSX or sy ~= ddsPreviewSY then
            local scrX, scrY = screenX * 0.65, screenY * 0.65
            ddsPreviewZoom = math.min(scrX / sx, scrY / sy)
            ddsPreviewMinZoom = ddsPreviewZoom - 0.5
            if 1 < ddsPreviewZoom then
              ddsPreviewZoom = 1
            end
            ddsPreviewSX, ddsPreviewSY = sx, sy
          end
        elseif not ddsPreviewMinZoom then
          local sx, sy = dxGetMaterialSize(tex)
          local scrX, scrY = screenX * 0.65, screenY * 0.65
          ddsPreviewZoom = math.min(scrX / sx, scrY / sy)
          ddsPreviewMinZoom = ddsPreviewZoom - 0.5
          if 1 < ddsPreviewZoom then
            ddsPreviewZoom = 1
          end
          ddsPreviewSX, ddsPreviewSY = sx, sy
        end
        local sx, sy = ddsPreviewSX * ddsPreviewZoom, ddsPreviewSY * ddsPreviewZoom
        if ddsPreviewU then
          sx = sx * ddsPreviewUS / ddsPreviewSX
          sy = sy * ddsPreviewVS / ddsPreviewSY
        end
        local x, y = screenX / 2 - ddsPreviewX - sx / 2, screenY / 2 - ddsPreviewY - sy / 2
        if isElement(ddsScreenSrc) then
          dxUpdateScreenSource(ddsScreenSrc, true)
          if isElement(ddsScreenShader) then
            dxDrawImage(0, 0, screenX, screenY, ddsScreenShader)
          else
            dxDrawRectangle(0, 0, screenX, screenY, tocolor(0, 0, 0, 255))
          end
        else
          dxDrawRectangle(0, 0, screenX, screenY, tocolor(0, 0, 0, 255))
        end
        if ddsPreviewU then
          dxDrawImageSection(x, y, sx, sy, ddsPreviewU, ddsPreviewV, ddsPreviewUS, ddsPreviewVS, tex)
        else
          dxDrawImage(x, y, sx, sy, tex)
        end
      end
    end
  end, true, "low-999")
  doRefreshFaTicks = false
  doRefreshGradTicks = false
  local doRefreshColors = false
  function setRefreshColors()
    doRefreshColors = true
  end
  addEventHandler("onClientPreRender", getRootElement(), function(delta)
    if doRefreshFaTicks then
      triggerEvent("refreshFaTicks", localPlayer)
      doRefreshFaTicks = false
    end
    if doRefreshGradTicks then
      triggerEvent("refreshGradientTick", localPlayer)
      doRefreshGradTicks = false
    end
    now = getTickCount()
    if doRefreshColors then
      tryRestoreGui(didClearRenderTargets)
      triggerEvent("onGuiRefreshColors", localPlayer)
      doRefreshColors = false
    end
    for name in pairs(faFonts) do
      if isElement(faFonts[name]) then
        destroyElement(faFonts[name])
      end
      faFonts[name] = nil
      break
    end
    for file, t in pairs(cursorTexturesDelete) do
      if t < now then
        cursorTexturesDelete[file] = nil
        if isElement(cursorTextures[file]) then
          destroyElement(cursorTextures[file])
        end
        cursorTextures[file] = nil
      end
    end
    fpsDelta = delta
    for k = 240, 2, -1 do
      fpsDeltas[k] = fpsDeltas[k - 1]
    end
    fpsDeltas[1] = delta
    for k = 1, #infoboxes do
      if infoboxes[k] and infoboxes[k][12] ~= infoboxes[k][13] then
        if infoboxes[k][12] > infoboxes[k][13] then
          infoboxes[k][12] = infoboxes[k][12] - delta / 250 * (infoboxHeight + 8 + 4)
          if infoboxes[k][12] < infoboxes[k][13] then
            infoboxes[k][12] = infoboxes[k][13]
          end
        elseif infoboxes[k][12] < infoboxes[k][13] then
          infoboxes[k][12] = infoboxes[k][12] + delta / 250 * (infoboxHeight + 8 + 4)
          if infoboxes[k][12] > infoboxes[k][13] then
            infoboxes[k][12] = infoboxes[k][13]
          end
        end
      end
    end
    local hoverTmp = false
    cx, cy = getCursorPosition()
    if cx and (ddsPreviewFile or ddsPreviewTexture) then
      cx = cx * screenX
      cy = cy * screenY
    end
    if cx and not ddsPreviewFile and not ddsPreviewTexture then
      cursorState = true
      cx = cx * screenX
      cy = cy * screenY
      local hovered = false
      for k = #renderList, 1, -1 do
        local el = renderList[k]
        if not guiElements[el].disableRender and hoverList[el] then
          if hovered then
            if guiElements[el].hoverState then
              guiElements[el].hoverState = false
              if guiElements[el].hoverEvent then
                triggerEvent(guiElements[el].hoverEvent, localPlayer, el, false)
              end
            end
          else
            local bbox = guiElements[el].boundingBox or el
            local x, y = guiElements[bbox].x, guiElements[bbox].y
            local sx, sy = guiElements[bbox].sx, guiElements[bbox].sy
            if guiElements[bbox].type == "window" then
              if not guiElements[bbox].hoverLock and not guiElements[bbox].disabled and x <= cx and y <= cy and cx <= x + sx and cy <= y + sy then
                hovered = true
              end
              sy = titleBarHeight
            end
            local tmp = guiElements[el].hoverState
            if not guiElements[bbox].hoverLock and not guiElements[bbox].disabled and x <= cx and y <= cy and cx <= x + sx and cy <= y + sy then
              tmp = true
              if not hoverTmp then
                hoverTmp = el
              end
            else
              guiElements[el].clicked = false
              tmp = false
            end
            if tmp ~= guiElements[el].hoverState then
              guiElements[el].hoverState = tmp
              if guiElements[el].hoverSound and tmp then
                playUISound(guiElements[el].hoverSound)
              end
              if guiElements[el].hoverEvent then
                triggerEvent(guiElements[el].hoverEvent, localPlayer, el, tmp)
              end
            end
            if tmp and guiElements[el].disableClickTrough then
              hovered = true
            end
          end
        end
      end
      for k = #renderList, 1, -1 do
        local el = renderList[k]
        if hoverList[el] and not guiElements[el].disableRender then
          local bbox = guiElements[el].boundingBox or el
          if guiElements[el].type == "toggle" then
            if guiElements[el].toggleState then
              if 1 > (guiElements[el].toggleStateVal or 0) then
                guiElements[el].toggleStateVal = (guiElements[el].toggleStateVal or 0) + delta / guiElements[el].hoverTime * 1
                if 1 < guiElements[el].toggleStateVal then
                  guiElements[el].toggleStateVal = 1
                end
              end
            elseif 0 < (guiElements[el].toggleStateVal or 0) then
              guiElements[el].toggleStateVal = (guiElements[el].toggleStateVal or 0) - delta / guiElements[el].hoverTime * 1
              if guiElements[el].toggleStateVal < 0 then
                guiElements[el].toggleStateVal = 0
              end
            end
          end
          local hover = guiElements[el].hoverState
          if hover and guiElements[bbox].type == "slider" then
            local val = guiElements[bbox].sliderValue or 0
            local sx = guiElements[bbox].sliderSize or 24
            local sy = guiElements[bbox].sy
            local x = guiElements[bbox].x + (guiElements[bbox].sx - sx) * val
            local y = guiElements[bbox].y
            hover = x <= cx and y <= cy and cx <= x + sx and cy <= y + sy
          elseif hover and guiElements[bbox].type == "window" then
            local sx = guiElements[bbox].sx
            local sy = titleBarHeight
            local x = guiElements[bbox].x + sx - titleBarHeight
            local y = guiElements[bbox].y
            hover = x <= cx and y <= cy and cx <= x + sx and cy <= y + sy
          end
          if hover or guiElements[bbox].sliderDrag then
            if guiElements[el].hoverAlpha < 255 then
              guiElements[el].hoverAlpha = guiElements[el].hoverAlpha + delta / guiElements[el].hoverTime * 255
              if guiElements[el].hoverAlpha > 255 then
                guiElements[el].hoverAlpha = 255
              end
            end
          elseif 0 < guiElements[el].hoverAlpha then
            guiElements[el].hoverAlpha = guiElements[el].hoverAlpha - delta / guiElements[el].hoverTime * 255
            if 0 > guiElements[el].hoverAlpha then
              guiElements[el].hoverAlpha = 0
            end
          end
          if guiElements[el].clicked then
            if 1 > guiElements[el].activateEffect then
              guiElements[el].activateEffect = guiElements[el].activateEffect + delta / guiElements[el].hoverTime * 2
              if 1 < guiElements[el].activateEffect then
                guiElements[el].activateEffect = 1
              end
            end
          elseif 0 < guiElements[el].activateEffect then
            guiElements[el].activateEffect = guiElements[el].activateEffect - delta / guiElements[el].hoverTime * 2
            if 0 > guiElements[el].activateEffect then
              guiElements[el].activateEffect = 0
            end
          end
        end
      end
    elseif cursorState then
      local allZero = true
      for k = 1, #renderList do
        local el = renderList[k]
        if hoverList[el] then
          if 0 < guiElements[el].hoverAlpha then
            allZero = false
            guiElements[el].hoverAlpha = guiElements[el].hoverAlpha - delta / guiElements[el].hoverTime * 255
            if 0 > guiElements[el].hoverAlpha then
              guiElements[el].hoverAlpha = 0
            end
          end
          if 0 < guiElements[el].activateEffect then
            allZero = false
            guiElements[el].activateEffect = guiElements[el].activateEffect - delta / guiElements[el].hoverTime * 2
            if 0 > guiElements[el].activateEffect then
              guiElements[el].activateEffect = 0
            end
          end
        end
      end
      if allZero then
        cursorState = false
      end
    end
    if hoverTmp ~= hoverElement then
      tooltipText = false
      tooltipImage = false
      hoverElement = hoverTmp
      if hoverElement and guiElements[hoverElement].hoverFront then
        guiToFront(hoverElement)
      end
      if hoverElement and guiElements[hoverElement].tooltipImage then
        tooltipText = false
        tooltipImage = guiElements[hoverElement].tooltipImage
        tooltipImageDDS = guiElements[hoverElement].tooltipImageDDS
        tooltipImageSX = guiElements[hoverElement].tooltipImageSX
        tooltipImageSY = guiElements[hoverElement].tooltipImageSY
        tooltipPosX = guiElements[hoverElement].tooltipPosX or "right"
        tooltipPosY = guiElements[hoverElement].tooltipPosY or "down"
      elseif hoverElement and guiElements[hoverElement].tooltipText then
        tooltipText = guiElements[hoverElement].tooltipText
        tooltipImage = false
        tooltipPosX = guiElements[hoverElement].tooltipPosX or "right"
        tooltipPosY = guiElements[hoverElement].tooltipPosY or "down"
      end
    end
  end)
  function thousandsStepper(amount)
    local formatted = amount
    while true do
      formatted, k = string.gsub(formatted, "^(-?%d+)(%d%d%d)", "%1 %2")
      if k == 0 then
        break
      end
    end
    return formatted
  end
  function updateScreenSourceBefore(el, screenSource, resample)
    if tonumber(el) and guiElements[el] then
      guiElements[el].updateScreenSource = screenSource
      guiElements[el].updateScreenSourceResample = resample
    else
      throwGuiError("guiToBack: invalid guiElement (" .. tostring(el) .. ")")
    end
  end
  function guiToBack(el, excludeChildren)
    if tonumber(el) and guiElements[el] then
      local tmp = {}
      if guiElements[el].type ~= "null" then
        table.insert(tmp, el)
      end
      local childrenTmp = {}
      if not excludeChildren then
        for k = 1, #guiElements[el].children do
          if guiElements[el].children[k] then
            childrenTmp[guiElements[el].children[k]] = true
          end
        end
        for k = 1, #renderList do
          if childrenTmp[renderList[k]] and guiElements[k].type ~= "null" then
            table.insert(tmp, renderList[k])
          end
        end
      end
      for k = 1, #renderList do
        if renderList[k] ~= el and not childrenTmp[renderList[k]] and guiElements[k] and guiElements[k].type ~= "null" then
          table.insert(tmp, renderList[k])
        end
      end
      renderList = tmp
    else
      throwGuiError("guiToBack: invalid guiElement (" .. tostring(el) .. ")")
    end
  end
  function guiToFront(el, excludeChildren)
    if tonumber(el) and guiElements[el] then
      local childrenTmp = {}
      local childrenTo = {}
      if not excludeChildren then
        for k = 1, #guiElements[el].children do
          if guiElements[el].children[k] then
            childrenTmp[guiElements[el].children[k]] = true
          end
        end
      end
      for k = #renderList, 1, -1 do
        if renderList[k] == el then
          table.remove(renderList, k)
          break
        end
      end
      if not excludeChildren then
        for k = 1, #renderList do
          if childrenTmp[renderList[k]] then
            table.insert(childrenTo, renderList[k])
          end
        end
      end
      if guiElements[el].type ~= "null" then
        table.insert(renderList, el)
      end
      if not excludeChildren then
        for k = 1, #childrenTo do
          guiToFront(childrenTo[k])
        end
      end
    else
      throwGuiError("guiToFront: invalid guiElement (" .. tostring(el) .. ")")
    end
  end
  function isGuiElementValid(el)
    return tonumber(el) and guiElements[el]
  end
  function guiSetTooltip(el, text, x, y)
    if tonumber(el) and guiElements[el] then
      if hoverElement == el then
        tooltipText = text
        tooltipImage = false
        tooltipPosX = x or "right"
        tooltipPosY = y or "down"
      end
      guiElements[el].tooltipText = text
      guiElements[el].tooltipImage = nil
      guiElements[el].tooltipImageSX = nil
      guiElements[el].tooltipImageSY = nil
      guiElements[el].tooltipPosX = x
      guiElements[el].tooltipPosY = y
    else
      throwGuiError("guiSetTooltip: invalid guiElement (" .. tostring(el) .. ")")
    end
  end
  function guiSetTooltipImage(el, image, sx, sy, x, y)
    if tonumber(el) and guiElements[el] then
      if hoverElement == el then
        tooltipText = false
        tooltipImage = image
        tooltipImageSX = sx
        tooltipImageSY = sy
        tooltipPosX = x or "right"
        tooltipPosY = y or "down"
      end
      guiElements[el].tooltipText = nil
      guiElements[el].tooltipImage = image
      guiElements[el].tooltipImageSX = sx
      guiElements[el].tooltipImageSY = sy
      guiElements[el].tooltipPosX = x
      guiElements[el].tooltipPosY = y
    else
      throwGuiError("guiSetTooltip: invalid guiElement (" .. tostring(el) .. ")")
    end
  end
  function guiSetTooltipImageDDS(el, image, sx, sy, x, y)
    if tonumber(el) and guiElements[el] then
      if hoverElement == el then
        tooltipText = false
        tooltipImage = image
        tooltipImageSX = sx
        tooltipImageSY = sy
        tooltipPosX = x or "right"
        tooltipPosY = y or "down"
      end
      guiElements[el].tooltipText = nil
      guiElements[el].tooltipImage = image
      guiElements[el].tooltipImageDDS = true
      guiElements[el].tooltipImageSX = sx
      guiElements[el].tooltipImageSY = sy
      guiElements[el].tooltipPosX = x
      guiElements[el].tooltipPosY = y
    else
      throwGuiError("guiSetTooltip: invalid guiElement (" .. tostring(el) .. ")")
    end
  end
  function showTooltip(text, x, y)
    tooltipText = text
    tooltipImage = false
    tooltipPosX = x or "right"
    tooltipPosY = y or "down"
  end
  function showTooltipImage(image, sx, sy, x, y, dds)
    tooltipText = false
    tooltipImage = image
    tooltipImageDDS = dds
    tooltipImageSX = sx
    tooltipImageSY = sy
    tooltipPosX = x or "right"
    tooltipPosY = y or "down"
  end
  function guiSetPositionAbsolute(el, x, y, excludeChildren)
    if tonumber(el) and guiElements[el] then
      local lastX = guiElements[el].x
      local lastY = guiElements[el].y
      guiElements[el].x = x
      guiElements[el].y = y
      if not excludeChildren then
        for k = 1, #guiElements[el].children do
          local child = guiElements[guiElements[el].children[k]]
          local px = guiElements[child].x - lastX
          local py = guiElements[child].y - lastY
          guiElements[child].x = guiElements[el].x + px
          guiElements[child].y = guiElements[el].y + py
        end
      end
    else
      throwGuiError("guiSetPositionAbsolute: invalid guiElement (" .. tostring(el) .. ")")
    end
  end
  local inventoryX, inventoryY = -1, -1
  local inventorySizeX, inventorySizeY = 0, 0
  function setInventoryPosition(x, y, sizeX, sizeY)
    inventoryX = x
    inventoryY = y
    inventorySizeX = sizeX
    inventorySizeY = sizeY
  end
  addEventHandler("onClientClick", getRootElement(), function(button, state, absoluteX, absoluteY, worldX, worldY, worldZ, clickedElement)
    if state == "down" and not ddsPreviewFile and not ddsPreviewTexture then
      if infoHover then
        local k = infoHover
        if not infoboxes[k][14] then
          infoboxes[k][1] = now - infoboxes[k][11] - 250
          infoboxes[k][14] = true
        end
        return
      end
      if activeInput then
        guiElements[activeInput].active = false
        activeInput = false
      end
      if inventoryX ~= -1 and absoluteX >= inventoryX and absoluteX <= inventoryX + inventorySizeX and absoluteY >= inventoryY and absoluteY <= inventoryY + inventorySizeY then
        return
      end
      local clickEventBuffer = {}
      for k = #renderList, 1, -1 do
        local el = renderList[k]
        if hoverList[el] and not guiElements[el].disableRender and guiElements[el].hoverState then
          guiElements[el].clicked = true
          if guiElements[el].type == "checkbox" then
            guiElements[el].checked = not guiElements[el].checked
          elseif guiElements[el].type == "toggle" then
            guiElements[el].toggleState = not guiElements[el].toggleState
          elseif guiElements[el].type == "slider" then
            local x = guiElements[el].x
            local sx = guiElements[el].sx
            local val = guiElements[el].sliderValue or 0
            sx = guiElements[el].sliderSize or 24
            x = x + (guiElements[el].sx - sx) * val
            if absoluteX < x or absoluteX > x + sx then
              guiElements[el].sliderDrag = guiElements[el].x + sx / 2
              guiElements[el].sliderValue = math.min(1, math.max((absoluteX - (guiElements[el].x + sx / 2)) / (guiElements[el].sx - sx), 0))
            else
              guiElements[el].sliderDrag = guiElements[el].x + sx / 2 + (absoluteX - (x + sx / 2))
            end
          elseif guiElements[el].type == "input" then
            guiElements[el].active = true
            activeInput = el
          end
          if guiElements[el].clickEvent then
            table.insert(clickEventBuffer, el)
          end
          if guiElements[el].disableClickTrough then
            break
          end
        end
      end
      for i = 1, #clickEventBuffer do
        local el = clickEventBuffer[i]
        if el and guiElements[el] then
          if guiElements[el].clickSound then
            playUISound(guiElements[el].clickSound)
          end
          if guiElements[el].clickEvent then
            triggerEvent(guiElements[el].clickEvent, localPlayer, button, state, absoluteX, absoluteY, el, guiElements[el].clickArg)
          end
        end
      end
    else
      for k = 1, #renderList do
        local el = renderList[k]
        if hoverList[el] then
          guiElements[el].clicked = false
          if guiElements[el].sliderDrag then
            guiElements[el].sliderDrag = false
            if guiElements[el].changeEvent then
              triggerEvent(guiElements[el].changeEvent, localPlayer, el, guiElements[el].sliderValue, true)
            end
          end
        end
      end
    end
  end, true, "high+999999")
  function setElementDisabled(el, disabled)
    if tonumber(el) and guiElements[el] then
      guiElements[el].disabled = disabled
    else
      throwGuiError("setElementDisabled: invalid guiElement (" .. tostring(el) .. ")")
    end
  end
  function enterTriggerKey(key, por)
    if por and (key == "enter" or key == "num_enter") and guiElements[enterTrigger] and guiElements[enterTrigger].clickEvent then
      triggerEvent(guiElements[enterTrigger].clickEvent, localPlayer, "enter", false, false, false, enterTrigger, guiElements[enterTrigger].clickArg)
    end
  end
  function setHoverEvent(el, event)
    if tonumber(el) and guiElements[el] then
      guiElements[el].hoverEvent = event
    else
      throwGuiError("setHoverEvent: invalid guiElement (" .. tostring(el) .. ")")
    end
  end
  function setClickSound(el, sound)
    if tonumber(el) and guiElements[el] then
      guiElements[el].clickSound = sound
    else
      throwGuiError("setClickSound: invalid guiElement (" .. tostring(el) .. ")")
    end
  end
  function setDisableClickSound(el, disable, children)
    if tonumber(el) and guiElements[el] then
      if disable then
        guiElements[el].clickSound = nil
      end
      guiElements[el].disableChildClickSound = children
    else
      throwGuiError("setClickSound: invalid guiElement (" .. tostring(el) .. ")")
    end
  end
  function setClickArgument(el, arg)
    if tonumber(el) and guiElements[el] then
      guiElements[el].clickArg = arg
    else
      throwGuiError("setClickEvent: invalid guiElement (" .. tostring(el) .. ")")
    end
  end
  function setClickEvent(el, event, keyTrigger)
    if tonumber(el) and guiElements[el] then
      if enterTrigger == el then
        enterTrigger = false
      end
      guiElements[el].clickEvent = event
      if event and keyTrigger then
        enterTrigger = el
      end
      seelangCondHandl0(enterTrigger)
    else
      throwGuiError("setClickEvent: invalid guiElement (" .. tostring(el) .. ")")
    end
  end
  function disableLinkCursor(el, state)
    if tonumber(el) and guiElements[el] then
      guiElements[el].disableLinkCursor = state
    else
      throwGuiError("disableClickTrough: invalid guiElement (" .. tostring(el) .. ")")
    end
  end
  function disableClickTrough(el, state)
    if tonumber(el) and guiElements[el] then
      guiElements[el].disableClickTrough = state
    else
      throwGuiError("disableClickTrough: invalid guiElement (" .. tostring(el) .. ")")
    end
  end
  addCommandHandler("showmouse", function()
    togCursorState = not togCursorState
    showCursor(togCursorState)
  end)
  -- bindKey("m", "down", "showmouse")
  -- addCommandHandler("mouseon", function()
    -- if not togCursorState and not seexports.rl_administration:getFly() then
      -- togCursorState = true
      -- showCursor(true)
    -- end
  -- end)
  addCommandHandler("mouseoff", function()
    if togCursorState and not seexports.rl_administration:getFly() then
      togCursorState = false
      showCursor(false)
    end
  end)
  local togCursorKey = "lalt"
  bindKey(togCursorKey, "down", "mouseon")
  bindKey(togCursorKey, "up", "mouseoff")
  function getTogCursorKey()
    return togCursorKey
  end
  function setTogCursorKey(val)
    unbindKey(togCursorKey, "down", "mouseon")
    unbindKey(togCursorKey, "up", "mouseoff")
    togCursorKey = val
    bindKey(togCursorKey, "down", "mouseon")
    bindKey(togCursorKey, "up", "mouseoff")
  end
  local bakerState = false
  local bakerGui = false
  local gWeekDays = {
    "vasárnap",
    "hétfő",
    "kedd",
    "szerda",
    "csütörtök",
    "péntek",
    "szombat"
  }
  function formatDate(format, escaper, timestamp)
    escaper = (escaper or "'"):sub(1, 1)
    local time = getRealTime(timestamp)
    local formattedDate = ""
    local escaped = false
    time.year = time.year + 1900
    time.month = time.month + 1
    local datetime = {
      d = ("%02d"):format(time.monthday),
      h = ("%02d"):format(time.hour),
      i = ("%02d"):format(time.minute),
      m = ("%02d"):format(time.month),
      s = ("%02d"):format(time.second),
      w = gWeekDays[time.weekday + 1]:sub(1, 2),
      W = gWeekDays[time.weekday + 1],
      y = tostring(time.year):sub(-2),
      Y = time.year
    }
    for char in format:gmatch(".") do
      if char == escaper then
        escaped = not escaped
      else
        formattedDate = formattedDate .. (not escaped and datetime[char] or char)
      end
    end
    return formattedDate
  end

addEvent("zorunlukapat",true)
addEventHandler("zorunlukapat",root,function(durum)
	if durum == "ac" then
		acayimmi = true
	else
		acayimmi = false
	end
end)