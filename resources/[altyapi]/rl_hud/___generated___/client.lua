-- filename: @
-- version: lua51
-- line: [0, 0] id: 0
local r0_0 = {
  {
    1,
    2
  },
  {
    1,
    2
  },
  {
    {
      1,
      2
    },
    {
      {
        1,
        2
      },
      {
        1,
        2
      },
      {
        1,
        2
      },
      {
        {
          1,
          2
        },
        {
          1,
          2
        },
        {
          1,
          2
        },
        {
          {
            {
              {
                1,
                2
              }
            }
          }
        }
      }
    },
    {
      1,
      2
    },
    {
      1,
      2
    }
  },
  {
    1,
    2
  }
}
r0_0 = nil
screenSize = Vector2(guiGetScreenSize())
importer:import("*"):from("rl_ui")
importer:import("inArea"):from("rl_widget")
loadstring(_injectHooks())()
BLACK = tocolor(0, 0, 0, 255)
PADDING = 10
function reMap(r0_1, r1_1, r2_1, r3_1, r4_1)
  -- line: [15, 17] id: 1
  return r3_1 + (r0_1 - r1_1) * (r4_1 - r3_1) / (r2_1 - r1_1)
end
local r1_0 = reMap(screenSize.x, 800, 1920, 0.6, 1)
function resp(r0_2)
  -- line: [27, 29] id: 2
  return math.ceil(r0_2 * r1_0)
end
function respc(r0_3)
  -- line: [31, 33] id: 3
  return tonumber(string.format("%.1f", tostring(r0_3 * r1_0)))
end
function abs(r0_4)
  -- line: [35, 40] id: 4
  return {
    x = r0_4.x * screenSize.x,
    y = r0_4.y * screenSize.y,
  }
end
function absX(r0_5)
  -- line: [42, 44] id: 5
  return r0_5 * screenSize.x
end
function absY(r0_6)
  -- line: [46, 48] id: 6
  return r0_6 * screenSize.y
end
function conv(r0_7)
  -- line: [50, 52] id: 7
  return r0_7 / screenSize.x
end
function convY(r0_8)
  -- line: [54, 56] id: 8
  return r0_8 / screenSize.y
end
function getTime()
  -- line: [58, 60] id: 9
  return string.format("%02d:%02d", time.hour, time.minute)
end
function getDate()
  -- line: [62, 64] id: 10
  return string.format("%02d/%02d/%04d", time.monthday, time.month + 1, time.year + 1900)
end
function removeHEXFromString(r0_11)
  -- line: [66, 68] id: 11
  return string.gsub(r0_11, "#%x%x%x%x%x%x", "")
end
function dxDrawBorderedText(r0_12, r1_12, r2_12, r3_12, r4_12, r5_12, r6_12, r7_12, r8_12, r9_12, r10_12, r11_12, r12_12, r13_12, r14_12, r15_12, r16_12, r17_12, r18_12)
  -- line: [70, 77] id: 12
  for r22_12 = r0_12 * -1, r0_12, 1 do
    for r26_12 = r0_12 * -1, r0_12, 1 do
      dxDrawText(removeHEXFromString(r1_12), r2_12 + r22_12, r3_12 + r26_12, r4_12 + r22_12, r5_12 + r26_12, tocolor(0, 0, 0, 255), r7_12, r8_12, r9_12, r10_12, r11_12, r12_12, r13_12, r14_12, r15_12, r16_12, r17_12, r18_12)
    end
  end
  dxDrawText(r1_12, r2_12, r3_12, r4_12, r5_12, r6_12, r7_12, r8_12, r9_12, r10_12, r11_12, r12_12, r13_12, r14_12, r15_12, r16_12, r17_12, r18_12)
end
MAX_RPM = 9500
function dxDrawBorderText(r0_13, r1_13, r2_13, r3_13, r4_13, r5_13, r6_13, r7_13, r8_13, r9_13, r10_13, r11_13, r12_13)
  -- line: [81, 92] id: 13
  if not r0_13 then
    return 
  end
  local r13_13 = r5_13 or tocolor(255, 255, 255)
  local r14_13 = r6_13 or 1
  local r15_13 = r7_13 or "default"
  local r16_13 = r8_13 or "left"
  local r17_13 = r9_13 or "top"
  local r18_13 = r10_13 or false
  local r19_13 = r11_13 or false
  if not r12_13 then
    r12_13 = false
  end
  r11_13 = r19_13
  r10_13 = r18_13
  r9_13 = r17_13
  r8_13 = r16_13
  r7_13 = r15_13
  r6_13 = r14_13
  r5_13 = r13_13
  dxDrawText(r0_13:gsub("#%x%x%x%x%x%x", ""), r1_13 + 1, r2_13 + 1, r3_13 + 1, r4_13 + 1, BLACK, r6_13, r7_13, r8_13, r9_13, r10_13, r11_13, r12_13)
  dxDrawText(r0_13:gsub("#%x%x%x%x%x%x", ""), r1_13 + 1, r2_13 - 1, r3_13 + 1, r4_13 - 1, BLACK, r6_13, r7_13, r8_13, r9_13, r10_13, r11_13, r12_13)
  dxDrawText(r0_13:gsub("#%x%x%x%x%x%x", ""), r1_13 - 1, r2_13 + 1, r3_13 - 1, r4_13 + 1, BLACK, r6_13, r7_13, r8_13, r9_13, r10_13, r11_13, r12_13)
  dxDrawText(r0_13:gsub("#%x%x%x%x%x%x", ""), r1_13 - 1, r2_13 - 1, r3_13 - 1, r4_13 - 1, BLACK, r6_13, r7_13, r8_13, r9_13, r10_13, r11_13, r12_13)
  dxDrawText(r0_13, r1_13, r2_13, r3_13, r4_13, r5_13, r6_13, r7_13, r8_13, r9_13, r10_13, r11_13, r12_13, true)
end
function dxDrawGradient(r0_14, r1_14, r2_14, r3_14, r4_14, r5_14, r6_14, r7_14, r8_14, r9_14)
  -- line: [94, 112] id: 14
  if r8_14 == true then
    for r13_14 = 0, r3_14, 1 do
      if r9_14 == false then
        dxDrawRectangle(r0_14, r1_14 + r13_14, r2_14, 1, tocolor(r4_14, r5_14, r6_14, r13_14 / r3_14 * r7_14 or 255))
      else
        dxDrawRectangle(r0_14, r1_14 + r3_14 - r13_14, r2_14, 1, tocolor(r4_14, r5_14, r6_14, r13_14 / r3_14 * r7_14 or 255))
      end
    end
  else
    for r13_14 = 0, r2_14, 1 do
      if r9_14 == false then
        dxDrawRectangle(r0_14 + r13_14, r1_14, 1, r3_14, tocolor(r4_14, r5_14, r6_14, r13_14 / r2_14 * r7_14 or 255))
      else
        dxDrawRectangle(r0_14 + r2_14 - r13_14, r1_14, 1, r3_14, tocolor(r4_14, r5_14, r6_14, r13_14 / r2_14 * r7_14 or 255))
      end
    end
  end
end
function getVehicleRPM(r0_15, r1_15, r2_15)
  -- line: [114, 141] id: 15
  local r3_15 = 0
  if r0_15 then
    if getVehicleEngineState(r0_15) == true then
      if getVehicleCurrentGear(r0_15) > 0 then
        r3_15 = math.floor(r2_15 / r1_15 * 160 + 0.5)
        if r3_15 < 650 then
          r3_15 = math.random(650, 750)
        elseif r3_15 >= 9000 then
          r3_15 = math.random(9000, MAX_RPM)
        end
      else
        r3_15 = math.floor(r2_15 * 160 + 0.5)
        if r3_15 < 650 then
          r3_15 = math.random(650, 750)
        elseif r3_15 >= 9000 then
          r3_15 = math.random(9000, MAX_RPM)
        end
      end
    else
      r3_15 = 0
    end
    return tonumber(r3_15)
  else
    return 0
  end
end
function isVehicleReversing(r0_16, r1_16)
  -- line: [143, 151] id: 16
  local r2_16 = getElementMatrix(r0_16)
  local r3_16 = Vector3(getElementVelocity(r0_16))
  local r4_16 = r3_16.x * r2_16[2][1] + r3_16.y * r2_16[2][2] + r3_16.z * r2_16[2][3]
  if r1_16 == 0 and r4_16 < 0 then
    return true
  end
  return false
end
components = {
  hud = {
    alias = "Hud",
    default = "neo",
  },
  carhud = {
    alias = "Araç Göstergesi",
    default = "neo",
  },
  minimap = {
    alias = "Harita",
    default = "rectangle",
  },
}
function getCurrentRenderingHud(r0_17)
  -- line: [170, 175] id: 17
  return useStore(r0_17 .. "_data"):get("component")
end
function createHudComponent(r0_18, r1_18, r2_18, r3_18)
  -- line: [177, 194] id: 18
  local r4_18, r5_18 = string.match(r0_18, "(.+)/(.+)")
  local r6_18 = useStore(r4_18 .. "_data")
  local function r7_18()
    -- line: [181, 184] id: 19
    return r1_18(useStore(r4_18))
  end
  r6_18:set("component", r5_18)
  local r8_18 = components[r4_18]
  local r9_18 = {
    render = r7_18,
    initialize = r3_18 or function()
      -- line: [190, 191] id: 20
    end,
    options = r2_18,
  }
  r8_18[r5_18] = r9_18
end
local r2_0 = nil
local r3_0 = {}
local r4_0 = 0
local r5_0 = true
local r6_0 = {
  Idlewood = 70,
  Commerce = 60,
  ["Verdant Bluffs"] = 110,
  Marina = 60,
  ["Santa Maria Beach"] = 70,
  Rodeo = 70,
  Vinewood = 80,
}
function getCurrentHud()
  -- line: [212, 219] id: 21
  local r0_21 = useStore("hud_data")
  if r0_21 then
    return r0_21:get("component")
  end
  return nil
end
local function r7_0()
  -- line: [221, 287] id: 22
  if not shortName then
    shortName = exports.rl_core:get("alias"):lower()
  end
  if getTickCount() - r4_0 > 1000 then
    r4_0 = getTickCount()
    local r0_22 = exports.rl_pointinghand:isPlayerPointing(localPlayer)
    setPlayerHudComponentVisible("all", false)
    setPlayerHudComponentVisible("crosshair", not r0_22)
  end
  renderSkull()
  for r3_22, r4_22 in pairs(components) do
    local r5_22 = useStore(r3_22 .. "_data")
    if r5_22 then
      local r6_22 = r5_22:get("component")
      local r7_22 = r4_22[r6_22]
      if r7_22 then
        r7_22.render()
        if not r3_0[r6_22] then
          r7_22.initialize()
          r3_0[r6_22] = true
        end
      end
    end
  end
  local r0_22 = r6_0[getZoneName(localPlayer.position)]
  if r0_22 and localPlayer.vehicle then
    local r1_22 = {
      x = 79.8,
      y = 106.39999999999999,
    }
    local r2_22 = {
      x = screenSize.x - r1_22.x - 20,
      y = screenSize.y / 2 - r1_22.y / 2,
    }
    dxDrawImage(r2_22.x, r2_22.y, r1_22.x, r1_22.y, "public/carhud/speed.png")
    dxDrawText(r0_22, r2_22.x, r2_22.y - 20, r1_22.x + r2_22.x, r1_22.y + r2_22.y - 20, rgba(theme.BLACK, 1), 1, fonts.ProximaNovaBold.h1, "center", "bottom")
  end
  if HAS_EDITOR_VISIBLE then
    renderEditor()
  end
  return true
end
function applyRadarForPurpleHud()
  -- line: [289, 306] id: 23
  local r0_23 = useStore("hud_data")
  if r0_23 then
    local r1_23 = r0_23:get("component")
    local r2_23 = Resource.getFromName("rl_radar")
    if r2_23 and r2_23.state ~= "running" then
      return 
    end
    if r1_23 == "purple" then
      exports.rl_radar:setRadarSize(nil, nil, "circular")
    else
      exports.rl_radar:setRadarSize(nil, nil, "rectangular")
    end
  end
end
function applyVoiceForPurpleHud()
  -- line: [308, 321] id: 24
  local r0_24 = useStore("hud_data")
  if r0_24 then
    local r1_24 = r0_24:get("component")
    local r2_24 = Resource.getFromName("rl_voice")
    if r2_24 and r2_24.state ~= "running" then
      return 
    end
    exports.rl_voice:setCurrentHud(r1_24)
  end
end
local function r8_0()
  -- line: [323, 363] id: 25
  if r2_0 then
    return 
  end
  if not exports.rl_settings:getEntitySetting(localPlayer, "hud_visible") then
    return 
  end
  if localPlayer:getData("loggedin") ~= 1 then
    return 
  end
  CoreSingleton.utils.executeOnReady(applyRadarForPurpleHud, "rl_radar")
  CoreSingleton.utils.executeOnReady(applyVoiceForPurpleHud, "rl_voice")
  fonts = useFonts()
  theme = useTheme()
  NeoHud.colorsCache = {
    iconColor = rgba(NeoHud.palette.main, 1),
    main = rgba(NeoHud.palette.main, 1),
    gray_400 = rgba(theme.GRAY[400], 1),
    gray_50 = rgba(theme.GRAY[50], 1),
    health = rgba(NeoHud.colors.health, 1),
    healthShade = rgba(NeoHud.colors.healthShade, 1),
    armor = rgba(NeoHud.colors.armor, 1),
    hunger = rgba(NeoHud.colors.hunger, 1),
    thirst = rgba(NeoHud.colors.thirst, 1),
    stamina = rgba(NeoHud.colors.stamina, 1),
    white = rgba(theme.WHITE, 1),
    white_half = rgba(theme.WHITE, 0.5),
    customGray = rgba("#CFCFCF", 1),
  }
  r2_0 = setTimer(r7_0, 0, 0)
end
local function r9_0()
  -- line: [365, 372] id: 26
  if not r2_0 then
    return 
  end
  killTimer(r2_0)
  r2_0 = nil
end
createEvent("settings.change", function(r0_27, r1_27)
  -- line: [374, 384] id: 27
  if r0_27 ~= "hud_visible" then
    return 
  end
  if r1_27 then
    r8_0()
  else
    r9_0()
  end
end, localPlayer)
addEventHandler("onClientResourceStart", resourceRoot, function()
  -- line: [386, 391] id: 28
  if localPlayer:getData("loggedin") == 1 then
    r8_0()
    return 
  end
end)
addEventHandler("onClientElementDataChange", localPlayer, function(r0_29, r1_29)
  -- line: [393, 404] id: 29
  if r0_29 ~= "loggedin" then
    return 
  end
  if r1_29 == 1 then
    r9_0()
    return 
  end
  r8_0()
end)
HAS_EDITOR_VISIBLE = false
local r10_0 = "preferences"
addCommandHandler("hud", function()
  -- line: [410, 416] id: 30
  if getElementData(localPlayer, "loggedin") ~= 1 then
    return false
  end
  HAS_EDITOR_VISIBLE = true
end)
addEventHandler("onClientResourceStart", resourceRoot, function()
  -- line: [418, 442] id: 31
  local r0_31 = {}
  for r4_31, r5_31 in pairs(components) do
    r0_31[r4_31] = r5_31.default
  end
  hudPreferences, exists = exports.rl_json:jsonGET(r10_0)
  if not exists then
    exports.rl_json:jsonSAVE(r10_0, r0_31)
    hudPreferences = r0_31
  end
  for r4_31, r5_31 in pairs(hudPreferences) do
    useStore(r4_31 .. "_data"):set("component", r5_31)
  end
  serverTag = exports.rl_core:get("name")
  if serverTag then
    serverTag = string.lower(serverTag)
  end
  CoreSingleton.utils.executeOnReady(applyRadarForPurpleHud, "rl_radar")
  CoreSingleton.utils.executeOnReady(applyVoiceForPurpleHud, "rl_voice")
end)
addEventHandler("onClientCoreLoaded", localPlayer, function()
  -- line: [444, 446] id: 32
  serverTag = exports.rl_core:get("name"):lower()
end)
function saveHudPreferences()
  -- line: [448, 453] id: 33
  exports.rl_json:jsonSAVE(r10_0, hudPreferences)
  CoreSingleton.utils.executeOnReady(applyRadarForPurpleHud, "rl_radar")
  CoreSingleton.utils.executeOnReady(applyVoiceForPurpleHud, "rl_voice")
end
local r11_0 = {
  maxColumns = 5,
  maxRows = 1,
}
local r12_0, r13_0 = guiGetScreenSize()
local r14_0 = math.min(r12_0 / 1920, r13_0 / 1080)
local r15_0 = r14_0 * 1.1
r11_0.columnGap = 20 * r14_0
r11_0.rowGap = 20 * r14_0
r11_0.containerSize = {
  x = math.max(r12_0 * 0.7, 1400 * r14_0),
  y = math.max(r13_0 * 0.4, 460 * r14_0),
}
r11_0.containerPosition = {
  x = (r12_0 - r11_0.containerSize.x) / 2,
  y = (r13_0 - r11_0.containerSize.y) / 2,
}
r11_0.columnSize = (r11_0.containerSize.x - r11_0.columnGap * r11_0.maxColumns) / r11_0.maxColumns
r11_0.rowSize = (r11_0.containerSize.y - r11_0.rowGap * r11_0.maxRows) / r11_0.maxRows
r11_0.gridItems = {}
for r19_0, r20_0 in pairs(components) do
  table.insert(r11_0.gridItems, {
    name = r20_0.alias,
    key = r19_0,
  })
end
table.insert(r11_0.gridItems, {
  name = "İsim Etiketi",
  key = "nametag",
})
table.insert(r11_0.gridItems, {
  name = "Sohbet Kutusu",
  key = "chat",
})
function renderEditor()
  -- line: [499, 621] id: 34
  exports.rl_radialblur:dxDrawRadialBlurSection(0, 0, r12_0, r13_0, 0.2)
  dxDrawImage(0, 0, r12_0, r13_0, "public/bg.png")
  dxDrawText("Görünüşü Ayarla", r11_0.containerPosition.x - 1, r11_0.containerPosition.y - 119 * r14_0, 0, 0, rgba(theme.GREEN[800], 1), r15_0 * 1.1, fonts.ProximaNovaBold.h0)
  dxDrawText("Görünüşü Ayarla", r11_0.containerPosition.x, r11_0.containerPosition.y - 120 * r14_0, 0, 0, rgba(theme.GREEN[500], 1), r15_0 * 1.1, fonts.ProximaNovaBold.h0)
  local r0_34 = {
    x = 40 * r14_0,
    y = 40 * r14_0,
  }
  local r1_34 = {
    x = r11_0.containerPosition.x + r11_0.containerSize.x - 50 * r14_0,
    y = r11_0.containerPosition.y - 110 * r14_0,
  }
  local r2_34 = inArea(r1_34.x, r1_34.y, r0_34.x, r0_34.y)
  if r2_34 and isMouseClicked() then
    HAS_EDITOR_VISIBLE = false
    showCursor(false)
  end
  local r3_34 = drawRoundedRectangle
  local r4_34 = {
    position = r1_34,
    size = r0_34,
  }
  local r5_34 = nil	-- notice: implicit variable refs by block#[6, 9]
  if r2_34 then
    r5_34 = "#ff4444"
    if not r5_34 then
      ::label_119::
      r5_34 = "#333333"
    end
  else
    goto label_119	-- block#5 is visited secondly
  end
  r4_34.color = r5_34
  if r2_34 then
    r5_34 = 0.9
    if not r5_34 then
      ::label_126::
      r5_34 = 0.7
    end
  else
    goto label_126	-- block#8 is visited secondly
  end
  r4_34.alpha = r5_34
  r4_34.radius = 5 * r14_0
  r3_34(r4_34)
  dxDrawText("✕", r1_34.x, r1_34.y - 2 * r14_0, r1_34.x + r0_34.x, r1_34.y + r0_34.y - 2 * r14_0, rgba(theme.WHITE, 1), r14_0, fonts.ProximaNovaBold.h3, "center", "center")
  for r6_34 = 1, r11_0.maxColumns, 1 do
    local r7_34 = r11_0.gridItems[r6_34]
    local r8_34 = {
      x = r11_0.containerPosition.x + (r11_0.columnSize + r11_0.columnGap) * (r6_34 - 1),
      y = r11_0.containerPosition.y,
    }
    if r7_34 then
      local r9_34 = components[r7_34.key]
      dxDrawText(r7_34.name, r8_34.x + 6 * r14_0, r8_34.y - 24 * r14_0, 0, 0, rgba(theme.GRAY[500], 1), r15_0 * 0.9, fonts.ProximaNovaBold.h3)
      dxDrawText(r7_34.name, r8_34.x + 5 * r14_0, r8_34.y - 25 * r14_0, 0, 0, rgba(theme.WHITE, 1), r15_0 * 0.9, fonts.ProximaNovaBold.h3)
      if r9_34 then
        local r10_34 = useStore(r7_34.key .. "_data")
        local r11_34 = 0
        for r15_34, r16_34 in pairs(r9_34) do
          if r16_34.options then
            local r17_34 = r16_34.options.name
            local r18_34 = {
              x = r11_0.columnSize - 20 * r14_0,
              y = 40 * r14_0,
            }
            local r19_34 = {
              x = r8_34.x + 10 * r14_0,
              y = r8_34.y + 15 * r14_0 + r11_34 * 45 * r14_0,
            }
            local r20_34 = inArea(r19_34.x, r19_34.y, r18_34.x, r18_34.y)
            local r21_34 = r10_34:get("component") == r15_34
            local r22_34 = drawRoundedRectangle
            local r23_34 = {
              position = r19_34,
              size = r18_34,
              color = "#4b4c4c",
            }
            local r24_34 = nil	-- notice: implicit variable refs by block#[20]
            if r20_34 then
              r24_34 = 0.8
              if not r24_34 then
                ::label_302::
                r24_34 = 0.5
              end
            else
              goto label_302	-- block#19 is visited secondly
            end
            r23_34.alpha = r24_34
            r24_34 = 5 * r14_0
            r23_34.radius = r24_34
            r22_34(r23_34)
            if r20_34 and isMouseClicked() then
              r10_34:set("component", r15_34)
              hudPreferences[r7_34.key] = r15_34
              saveHudPreferences()
            end
            dxDrawText(r17_34, r19_34.x + 10 * r14_0, r19_34.y, 0, r19_34.y + r18_34.y, rgba(theme.WHITE, 1), r15_0 * 0.85, fonts.ProximaNovaRegular.h6, "left", "center")
            if r21_34 then
              dxDrawText("", r19_34.x - 10 * r14_0, r19_34.y, r19_34.x + r18_34.x - 10 * r14_0, r19_34.y + r18_34.y, rgba(theme.GREEN[500], 1), r15_0 * 0.85, fonts.icon, "right", "center")
            end
            r11_34 = r11_34 + 1
          end
        end
      elseif r7_34.key == "nametag" then
        exports.rl_nametag:renderNameTagChoices({
          x = r8_34.x + 10 * r14_0,
          y = r8_34.y + 10 * r14_0,
        }, {
          x = r11_0.columnSize - 20 * r14_0,
          y = r11_0.rowSize - 20 * r14_0,
        })
      elseif r7_34.key == "chat" then
        exports.rl_chat:renderCustomChatChoices({
          x = r8_34.x + 10 * r14_0,
          y = r8_34.y + 10 * r14_0,
        }, {
          x = r11_0.columnSize - 20 * r14_0,
          y = r11_0.rowSize - 20 * r14_0,
        })
      end
    end
  end
end
local r16_0 = {
  hunger = {
    floor = true,
  },
  thirst = {
    floor = true,
  },
  level = {},
  exp = {
    floor = true,
  },
  exprange = {
    floor = true,
  },
  money = {
    format = true,
    floor = true,
  },
  bankmoney = {
    format = true,
    floor = true,
  },
  playerid = {},
  injury = {},
}
local function r17_0(r0_35, r1_35)
  -- line: [636, 658] id: 35
  local r2_35 = r16_0[r0_35]
  local r3_35 = r1_35
  if not r1_35 then
    return 
  end
  if r2_35.floor then
    r3_35 = math.floor(r1_35)
  end
  if not store then
    store = useStore("hud")
  end
  if r2_35.format then
    store:set(r0_35 .. "_no-format", exports.rl_core:get("currency") .. r3_35)
    r3_35 = exports.rl_core:get("currency") .. exports.rl_global:formatMoney(r3_35)
  end
  return r3_35
end
local function r18_0()
  -- line: [660, 668] id: 36
  if not store then
    store = useStore("hud")
  end
  for r3_36 in pairs(r16_0) do
    store:set(r3_36, r17_0(r3_36, localPlayer:getData(r3_36)))
  end
end
local function r19_0(r0_37, r1_37)
  -- line: [670, 692] id: 37
  ammoPerInventory = 0
  if 0 < tonumber(r0_37) and not r1_37 then
    items = exports.rl_items:getItems(localPlayer)
    if items and 0 < #items then
      for r5_37, r6_37 in pairs(items) do
        if r6_37.itemID == 116 then
          local r7_37 = r6_37.itemValue
          if r7_37 then
            local r8_37 = exports.rl_global:split(r7_37, ":")
            if r8_37 then
              local r10_37 = r8_37[2]
              if tonumber(r0_37) == tonumber(r8_37[1]) then
                ammoPerInventory = ammoPerInventory + r10_37
              end
            end
          end
        end
      end
    end
  end
end
addEventHandler("onClientResourceStart", resourceRoot, function()
  -- line: [694, 698] id: 38
  if localPlayer:getData("loggedin") == 1 then
    r18_0()
  end
end)
addEventHandler("onClientElementDataChange", localPlayer, function(r0_39, r1_39, r2_39)
  -- line: [700, 753] id: 39
  if r0_39 == "loggedin" and r2_39 == 1 then
    r18_0()
  end
  if not r16_0[r0_39] then
    return 
  end
  if not store then
    store = useStore("hud")
  end
  if r0_39 == "money" and r2_39 then
    local r3_39 = tonumber(r2_39)
    if r3_39 then
      setPlayerMoney(r3_39)
      playSound("public/hud/sounds/money.mp3")
      if isTimer(moneyGainRef) then
        killTimer(moneyGainRef)
      end
      local r4_39 = exports.rl_core:get("currency")
      if r1_39 then
        local r5_39 = tonumber(r1_39)
        if r5_39 then
          local r6_39 = r3_39 - r5_39
          if r6_39 > 0 then
            store:set("money-gain", {
              value = "+" .. r4_39 .. exports.rl_global:formatMoney(r6_39),
              isPositive = true,
            })
          elseif r6_39 < 0 then
            store:set("money-gain", {
              value = "-" .. r4_39 .. exports.rl_global:formatMoney(math.abs(r6_39)),
              isPositive = false,
            })
          end
          moneyGainRef = Timer(function()
            -- line: [743, 745] id: 40
            store:set("money-gain", nil)
          end, 5000, 1)
        end
      end
    end
  end
  store:set(r0_39, r17_0(r0_39, r2_39))
end)
setTimer(function()
  -- line: [755, 798] id: 41
  -- notice: unreachable block#17
  if localPlayer:getData("loggedin") ~= 1 then
    return 
  end
  if not store then
    store = useStore("hud")
  end
  if not theme then
    theme = theme or useTheme()
  end
  local r0_41 = exports.rl_pointinghand:isPlayerPointing(localPlayer)
  local r1_41 = localPlayer:getAmmoInClip()
  local r2_41 = getRealTime()
  r19_0(localPlayer:getWeapon(), r0_41)
  store:set("name", localPlayer.name:gsub("_", " "))
  store:set("dimension", localPlayer:getDimension())
  store:set("health", math.floor(localPlayer:getHealth()))
  store:set("armor", math.floor(localPlayer:getArmor()))
  store:set("weapon", localPlayer:getWeapon())
  store:set("stamina", exports.rl_realism:getStamina())
  if not store:get("money") then
    store:set("money", exports.rl_core:get("currency") .. exports.rl_global:formatMoney(localPlayer:getData("money")))
  end
  local r3_41 = exports.rl_streetnames:getPlayerStreetLocation(localPlayer) or ""
  if #r3_41 > 20 then
    r3_41 = r3_41:sub(1, 20) .. "..."
  end
  store:set("zoneName", r3_41)
  store:set("time", string.format("%02d:%02d", r2_41.hour, r2_41.minute))
  store:set("date", string.format("%02d/%02d/%04d", r2_41.monthday, r2_41.month + 1, r2_41.year + 1900))
  local r4_41 = store
  local r6_41 = "ammo"
  local r7_41 = nil	-- notice: implicit variable refs by block#[18]
  if not r0_41 then
    r7_41 = r1_41 .. theme.GRAY[400] .. "/" .. ammoPerInventory
  else
    r7_41 = false
  end
  r4_41:set(r6_41, r7_41)
end, 500, 0)
createHudComponent("hud/simple", function(r0_42)
  -- line: [800, 819] id: 42
  local r1_42 = r0_42:get("playerid") or ""
  local r2_42 = r0_42:get("date") or ""
  local r3_42 = r0_42:get("time") or ""
  local r4_42 = r0_42:get("hunger") or 0
  local r5_42 = r0_42:get("thirst") or 0
  local r6_42 = r0_42:get("exp")
  local r7_42 = r0_42:get("exprange")
  local r8_42 = r0_42:get("level")
  if not bankGothicFont then
    bankGothicFont = exports.kaisen_fonts:getFont("BankGothic", 13)
  end
  local r9_42 = "#757575Seviye: #1B9CFC" .. r8_42 .. " (" .. r6_42 .. "/" .. r7_42 .. ")\n"
  local r10_42 = getKeyState("tab")
  if r10_42 then
    r10_42 = "#757575Açlık: #F97F51" .. r4_42 .. "%" .. "\n#757575Susuzluk: #58B19F" .. r5_42 .. "%\n" .. r9_42 or ""
  else
    goto label_72	-- block#14 is visited secondly
  end
  dxDrawBorderedText(2, r10_42 .. "#4a4a4asmartroleplay.com\n#ffffff" .. localPlayer.name:gsub("_", " ") .. " (" .. r1_42 .. ")\n#757575" .. r2_42 .. " " .. r3_42, 0, 0, screenSize.x - 10, screenSize.y - 5, tocolor(255, 255, 255), 1, bankGothicFont, "right", "bottom", false, false, true, true)
end)
Purple = {
  enums = {},
}
Purple.enums.rightTopAction = {
  Ping = "ping",
  Players = "players",
  ID = "ID",
}
Purple.enums.moneyMode = {
  Cash = "cash",
  Bank = "bank",
}
Purple.outerPadding = 10
Purple.rightTopActions = {
  {
    alias = "ID",
    action = Purple.enums.rightTopAction.ID,
  },
  {
    icon = svgCreate(32, 32, "public/hud/icons/user.svg"),
    action = Purple.enums.rightTopAction.Players,
  },
  {
    icon = svgCreate(32, 32, "public/hud/icons/ping.svg"),
    action = Purple.enums.rightTopAction.Ping,
  }
}
Purple.palette = {
  main = "#b20e40",
  shade = "#50061c",
}
Purple.moneyModes = {
  [Purple.enums.moneyMode.Cash] = "NAKİT",
  [Purple.enums.moneyMode.Bank] = "BANKA",
}
Purple.currentMoneyMode = Purple.enums.moneyMode.Cash
Purple.circleSize = {
  x = resp(55),
  y = resp(55),
}
Purple.iconSize = {
  x = resp(20),
  y = resp(20),
}
Purple.colors = {
  stamina = "#f80b52",
  health = "#0bbe32",
  hunger = "#ffb84c",
  thirst = "#6effd4",
}
Purple.modePadding = 2
Purple.icons = {
  bar = svgCreate(Purple.circleSize.x, Purple.circleSize.y, "public/hud/icons/bar.svg"),
  background = svgCreate(Purple.circleSize.x, Purple.circleSize.y, "public/hud/icons/stamina_bg.svg"),
  staminaIcon = svgCreate(Purple.iconSize.x, Purple.iconSize.y, "public/hud/icons/stamina.svg"),
  healthIcon = svgCreate(Purple.iconSize.x, Purple.iconSize.y, "public/hud/icons/health.svg"),
  hungerIcon = svgCreate(Purple.iconSize.x, Purple.iconSize.y, "public/hud/icons/hunger.svg"),
  thirstIcon = svgCreate(Purple.iconSize.x, Purple.iconSize.y, "public/hud/icons/thirst.svg"),
  ammo = svgCreate(64, 64, "public/hud/icons/ammo.svg"),
}
weaponContainerSize = {
  x = resp(256),
  y = resp(128),
}
local r20_0 = {
  x = weaponContainerSize.x / 2.5,
  y = resp(40),
}
function Purple.getActionValue(r0_43)
  -- line: [891, 899] id: 43
  if r0_43 == Purple.enums.rightTopAction.Ping then
    return localPlayer.ping
  elseif r0_43 == Purple.enums.rightTopAction.Players then
    return #getElementsByType("player")
  elseif r0_43 == Purple.enums.rightTopAction.ID then
    return localPlayer:getData("playerid")
  end
end
function Purple.drawBar(r0_44, r1_44, r2_44, r3_44)
  -- line: [901, 940] id: 44
  r1_44 = math.floor(math.min(100, math.max(0, r1_44 or 0)))
  dxDrawImage(r2_44.x, r2_44.y, r3_44.x, r3_44.y, Purple.icons.background)
  local r4_44 = {
    x = r2_44.x + r3_44.x / 2 - Purple.iconSize.x / 2,
    y = r2_44.y + r3_44.y / 2 - Purple.iconSize.y / 2,
  }
  dxDrawImage(r4_44.x, r4_44.y, Purple.iconSize.x, Purple.iconSize.y, Purple.icons[r0_44 .. "Icon"], 0, 0, 0, rgba(Purple.colors[r0_44], 1))
  local r5_44 = -(r3_44.y * r1_44 / 100)
  dxDrawImageSection(r2_44.x, r2_44.y + r3_44.y, r3_44.x, r5_44, 0, 0, r3_44.x, r5_44, Purple.icons.bar, 0, 0, 0, rgba(Purple.colors[r0_44], 1))
  dxDrawText("%" .. r1_44, r2_44.x, r2_44.y + 18, r2_44.x + r3_44.x, r2_44.y + r3_44.y + 18, rgba(Purple.colors[r0_44], 1), 1, fonts.ProximaNovaBold.caption, "center", "bottom")
end
local r21_0 = {
  x = screenSize.x - Purple.outerPadding,
  y = Purple.outerPadding * 3,
}
local r22_0 = {
  x = resp(210),
  y = resp(20),
}
local r23_0 = {
  x = resp(200),
  y = resp(40),
}
local r24_0 = {
  x = r23_0.x,
  y = resp(30),
}
local r25_0 = {
  x = screenSize.x - Purple.outerPadding * 2 - r23_0.x,
  y = r21_0.y + r22_0.y + Purple.outerPadding * 5,
}
local r26_0 = {
  x = r25_0.x,
  y = r25_0.y - r24_0.y + 10,
}
local r27_0 = {
  x = r24_0.x * 0.2,
  y = resp(2),
}
local r28_0 = {
  x = r26_0.x,
  y = r26_0.y + r24_0.y / 2 - r27_0.y / 2,
}
local r29_0 = {
  x = r26_0.x + r24_0.x - r27_0.x,
  y = r26_0.y + r24_0.y / 2 - r27_0.y / 2,
}
local r30_0 = {
  x = r24_0.x - r27_0.x * 2,
  y = r24_0.y,
}
local r31_0 = {
  x = r26_0.x + r27_0.x,
  y = r26_0.y,
}
local r32_0 = {
  x = screenSize.x - weaponContainerSize.x,
  y = r25_0.y + r23_0.y + Purple.outerPadding * 10,
}
local r33_0 = {
  x = screenSize.x - r20_0.x + 8,
  y = r32_0.y + weaponContainerSize.y - r20_0.y,
}
local r34_0 = {
  x = r20_0.y / 2,
  y = r20_0.y / 2,
}
local r35_0 = {
  x = r33_0.x + 8,
  y = r33_0.y + r20_0.y / 2 - r34_0.y / 2,
}
createHudComponent("hud/purple", function(r0_45)
  -- line: [1017, 1266] id: 45
  for r4_45, r5_45 in ipairs(Purple.rightTopActions) do
    local r6_45 = {
      x = r22_0.x / #Purple.rightTopActions,
      y = r22_0.y,
    }
    local r7_45 = {
      x = r21_0.x - r6_45.x * r4_45,
      y = r21_0.y,
    }
    local r8_45 = Purple.getActionValue(r5_45.action)
    if r5_45.alias then
      dxDrawText(r5_45.alias, r7_45.x, r7_45.y, 0, r6_45.y + r7_45.y, rgba(Purple.palette.main, 1), 1, fonts.ProximaNovaBold.h6, "left", "center")
    else
      dxDrawImage(r7_45.x, r7_45.y + r6_45.y / 2 - r6_45.y / 2, r6_45.y, r6_45.y, r5_45.icon, 0, 0, 0, rgba(Purple.palette.main, 1))
    end
    dxDrawText(r8_45, r7_45.x + 24, r7_45.y + 1, 0, r6_45.y + r7_45.y + 1, rgba(theme.GRAY[400], 1), 1, fonts.ProximaNovaBold.h6, "left", "center")
    dxDrawText(r8_45, r7_45.x + 24, r7_45.y, 0, r6_45.y + r7_45.y, rgba(theme.GRAY[50], 1), 1, fonts.ProximaNovaBold.h6, "left", "center")
  end
  local r1_45 = 0
  for r5_45, r6_45 in pairs(Purple.moneyModes) do
    local r7_45 = {
      x = r30_0.x / 2,
      y = r30_0.y,
    }
    local r8_45 = {
      x = r31_0.x + (r7_45.x + Purple.modePadding) * r1_45,
      y = r31_0.y,
    }
    if inArea(r8_45.x, r8_45.y, r7_45.x, r7_45.y) then
      exports.rl_cursor:setCursor("all", "pointinghand")
      if isMouseClicked() then
        Purple.currentMoneyMode = r5_45
      end
    end
    local r10_45 = r5_45 == Purple.currentMoneyMode
    local r11_45 = dxDrawText
    local r12_45 = r6_45
    local r13_45 = r8_45.x
    local r14_45 = r8_45.y + 1
    local r15_45 = r7_45.x + r8_45.x
    local r16_45 = r7_45.y + r8_45.y + 1
    local r17_45 = rgba
    local r18_45 = nil	-- notice: implicit variable refs by block#[16, 19]
    if r10_45 then
      r18_45 = Purple.palette.shade
      if not r18_45 then
        ::label_198::
        r18_45 = theme.GRAY[700]
      end
    else
      goto label_198	-- block#15 is visited secondly
    end
    r11_45(r12_45, r13_45, r14_45, r15_45, r16_45, r17_45(r18_45, 1), 1, fonts.ProximaNovaBold.h6, "center", "center")
    r11_45 = dxDrawText
    r12_45 = r6_45
    r13_45 = r8_45.x
    r14_45 = r8_45.y
    r15_45 = r7_45.x + r8_45.x
    r16_45 = r7_45.y + r8_45.y
    r17_45 = rgba
    if r10_45 then
      r18_45 = Purple.palette.main
      if not r18_45 then
        ::label_228::
        r18_45 = theme.GRAY[300]
      end
    else
      goto label_228	-- block#18 is visited secondly
    end
    r11_45(r12_45, r13_45, r14_45, r15_45, r16_45, r17_45(r18_45, 1), 1, fonts.ProximaNovaBold.h6, "center", "center")
    r1_45 = r1_45 + 1
  end
  dxDrawText("/", r26_0.x + 3, r26_0.y, r26_0.x + r24_0.x + 3, r24_0.y + r26_0.y, rgba(theme.GRAY[500], 1), 1, fonts.ProximaNovaBold.h3, "center", "center")
  dxDrawGradient(r28_0.x - 4, r28_0.y, r27_0.x, r27_0.y, 35, 35, 35, 255, false, false)
  dxDrawGradient(r29_0.x, r29_0.y, r27_0.x, r27_0.y, 35, 35, 35, 255, false, true)
  local r2_45 = Purple.currentMoneyMode
  if r2_45 == Purple.enums.moneyMode.Cash then
    r2_45 = r0_45:get("money") or r0_45:get("bankmoney")
  else
    goto label_320	-- block#23 is visited secondly
  end
  dxDrawText(r2_45, r25_0.x, r25_0.y + 4, r25_0.x + r23_0.x, r23_0.y + r25_0.y + 4, rgba(Purple.palette.shade, 1), 1, fonts.TabletGothicBold.header, "right", "top")
  dxDrawText(r2_45, r25_0.x, r25_0.y, r25_0.x + r23_0.x, r23_0.y + r25_0.y, rgba(Purple.palette.main, 1), 1, fonts.TabletGothicBold.header, "right", "top")
  local r3_45 = r0_45:get("money-gain")
  if r3_45 then
    local r4_45 = {
      x = r25_0.x,
      y = r25_0.y + r23_0.y + 20,
    }
    local r5_45 = dxDrawText
    local r6_45 = r3_45.value
    local r7_45 = r4_45.x
    local r8_45 = r4_45.y + 2
    local r9_45 = r4_45.x + r23_0.x
    local r10_45 = r23_0.y + r4_45.y + 2
    local r11_45 = rgba
    local r12_45 = r3_45.isPositive
    if r12_45 then
      r12_45 = theme.GREEN[700] or theme.RED[700]
    else
      goto label_422	-- block#27 is visited secondly
    end
    r5_45(r6_45, r7_45, r8_45, r9_45, r10_45, r11_45(r12_45, 1), 1, fonts.ProximaNovaBold.h3, "right", "top")
    r5_45 = dxDrawText
    r6_45 = r3_45.value
    r7_45 = r4_45.x
    r8_45 = r4_45.y
    r9_45 = r4_45.x + r23_0.x
    r10_45 = r23_0.y + r4_45.y
    r11_45 = rgba
    r12_45 = r3_45.isPositive
    if r12_45 then
      r12_45 = theme.GREEN[500] or theme.RED[500]
    else
      goto label_455	-- block#30 is visited secondly
    end
    r5_45(r6_45, r7_45, r8_45, r9_45, r10_45, r11_45(r12_45, 1), 1, fonts.ProximaNovaBold.h3, "right", "top")
  end
  local r4_45 = r0_45:get("weapon") or 0
  local r5_45 = r0_45:get("ammo")
  if r4_45 ~= 0 then
    drawRoundedRectangle({
      position = r33_0,
      size = r20_0,
      color = theme.GRAY[900],
      alpha = 0.9,
      radius = 8,
    })
    dxDrawImage(r35_0.x, r35_0.y, r34_0.x, r34_0.y, Purple.icons.ammo, 0, 0, 0, rgba(Purple.palette.main, 1))
    dxDrawText(r5_45, r33_0.x - 32, r33_0.y, r33_0.x + r20_0.x - 32, r33_0.y + r20_0.y, rgba(theme.WHITE, 1), 1, fonts.ProximaNovaBold.h6, "right", "center", false, false, false, true)
    dxDrawImage(r32_0.x, r32_0.y, weaponContainerSize.x, weaponContainerSize.y, "public/weapons_modern/" .. r4_45 .. ".png")
  end
  if isNativeRadarVisible() then
    Purple.drawBar("stamina", r0_45:get("stamina"), {
      x = Purple.outerPadding * 3,
      y = screenSize.y - Purple.outerPadding - Purple.circleSize.y - 15,
    }, Purple.circleSize)
    Purple.drawBar("health", r0_45:get("health"), {
      x = Purple.outerPadding * 5 + Purple.circleSize.x,
      y = screenSize.y - Purple.outerPadding - Purple.circleSize.y - 15,
    }, Purple.circleSize)
    Purple.drawBar("hunger", r0_45:get("hunger"), {
      x = Purple.outerPadding * 9 + Purple.circleSize.x * 2,
      y = screenSize.y - Purple.outerPadding - Purple.circleSize.y - 15,
    }, Purple.circleSize)
    Purple.drawBar("thirst", r0_45:get("thirst"), {
      x = Purple.outerPadding * 3 + 250,
      y = screenSize.y - Purple.outerPadding - Purple.circleSize.y - 15,
    }, Purple.circleSize)
  else
    Purple.drawBar("stamina", r0_45:get("stamina"), {
      x = Purple.outerPadding * 3,
      y = screenSize.y - Purple.outerPadding - Purple.circleSize.y * 2 - 15,
    }, Purple.circleSize)
    Purple.drawBar("health", r0_45:get("health"), {
      x = Purple.outerPadding * 5 + Purple.circleSize.x,
      y = screenSize.y - Purple.outerPadding - Purple.circleSize.y - 5 - 15,
    }, Purple.circleSize)
    Purple.drawBar("hunger", r0_45:get("hunger"), {
      x = Purple.outerPadding * 9 + Purple.circleSize.x * 2,
      y = screenSize.y - Purple.outerPadding - Purple.circleSize.y - 5 - 15,
    }, Purple.circleSize)
    Purple.drawBar("thirst", r0_45:get("thirst"), {
      x = Purple.outerPadding * 3 + 250,
      y = screenSize.y - Purple.outerPadding - Purple.circleSize.y * 2 - 15,
    }, Purple.circleSize)
  end
end, {
  name = "Purple",
})
local r36_0 = {
  x = 120,
  y = 80,
}
local r37_0 = {
  x = screenSize.x - r36_0.x - PADDING * 2,
  y = PADDING * 4,
}
local r38_0 = {
  x = 120,
  y = 15,
}
createHudComponent("hud/trilogy", function(r0_46)
  -- line: [1286, 1325] id: 46
  local r1_46 = r0_46:get("weapon") or 0
  local r2_46 = exports.kaisen_fonts:getFont("gtaFont", 25)
  local r3_46 = r0_46:get("time") or ""
  local r4_46 = r0_46:get("money_no-format") or 0
  local r5_46 = r0_46:get("ammo") or ""
  local r6_46 = r37_0.x
  local r7_46 = r37_0.y
  dxDrawImage(r6_46, r7_46, 128, 128, "public/weapons/" .. r1_46 .. ".png")
  if r1_46 ~= 0 then
    dxDrawText(r5_46, r6_46, r7_46, 115 + r6_46, 115 + r7_46, tocolor(225, 225, 225), 1, fonts.body.regular, "right", "bottom", false, false, false, true)
  end
  r7_46 = r7_46 + 5
  r6_46 = r6_46 - 150
  dxDrawBorderText(r3_46, r6_46, r7_46, r36_0.x + r6_46, 0, tocolor(255, 255, 255), 1, r2_46, "right", "top")
  dxDrawBorderText(r4_46, r6_46, r7_46 + 30, r36_0.x + r6_46, 0, tocolor(85, 152, 78), 1, r2_46, "right", "top")
  r7_46 = r7_46 + 75
  for r11_46, r12_46 in ipairs({
    "health",
    "armor"
  }) do
    local r13_46 = r0_46:get(r12_46) or 0
    if r13_46 <= 0 then
      local r14_46 = false
      return r14_46
    end
    local r14_46 = 225
    local r15_46 = 225
    local r16_46 = 225
    if r12_46 == "health" then
      r16_46 = 0
      r15_46 = 0
      r14_46 = 255
    end
    dxDrawRectangle(r6_46, r7_46, r38_0.x, r38_0.y, BLACK)
    dxDrawRectangle(r6_46 + 2, r7_46 + 2, r38_0.x - 4, r38_0.y - 4, tocolor(r14_46, r15_46, r16_46, 100))
    dxDrawRectangle(r6_46 + 2 + r38_0.x - 4, r7_46 + 2, -(r38_0.x - 4) * r13_46 / 100, r38_0.y - 4, tocolor(r14_46, r15_46, r16_46))
    r7_46 = r7_46 + r38_0.y + 5
  end
end, {
  name = "Trilogy",
})
local r39_0 = {
  x = screenSize.x * 0.786,
  y = screenSize.y * 0.025,
}
local r40_0 = {
  x = screenSize.x * 0.035,
  y = screenSize.y * 0.017,
}
local r41_0 = {
  x = screenSize.x * 0.095,
  y = screenSize.y * 0.019,
}
local r42_0 = screenSize.x * 0.004
local r43_0 = screenSize.y * 0.016
local r44_0 = 225
local r45_0 = 225
local r46_0 = 255
local r47_0 = 180
local r48_0 = 25
local r49_0 = 29
createHudComponent("hud/native", function(r0_47)
  -- line: [1350, 1484] id: 47
  local r1_47 = r39_0.x
  local r2_47 = r39_0.y
  local r3_47 = getRealTime()
  local r9_47 = string.format("%02d-%02d-%04d", r3_47.monthday, r3_47.month + 1, r3_47.year + 1900)
  local r10_47 = string.format("%02d:%02d", r3_47.hour, r3_47.minute)
  for r14_47, r15_47 in ipairs({
    "ammo",
    "breath",
    "money",
    "weapon"
  }) do
    setPlayerHudComponentVisible(r15_47, true)
  end
  setPlayerHudComponentVisible("clock", false)
  setPlayerHudComponentVisible("armour", false)
  setPlayerHudComponentVisible("health", false)
  local r11_47 = r0_47:get("exp")
  local r12_47 = r0_47:get("exprange")
  for r16_47, r17_47 in ipairs({
    "hunger",
    "thirst",
    "level",
    "stamina"
  }) do
    if r17_47 == "stamina" then
      local r18_47 = exports.rl_realism:getStamina() or r0_47:get(r17_47)
    else
      goto label_76	-- block#6 is visited secondly
    end
    local r18_47 = math.min(r18_47, 100)
    if r17_47 == "level" then
      r18_47 = r11_47 / r12_47 * 100
    end
    local r19_47 = 131
    local r20_47 = 189
    local r21_47 = 44
    if 60 <= r18_47 and r18_47 <= 80 then
      r21_47 = 116
      r20_47 = 211
      r19_47 = 145
    elseif 40 <= r18_47 and r18_47 <= 60 then
      r21_47 = 49
      r20_47 = 138
      r19_47 = 192
    elseif 0 <= r18_47 and r18_47 <= 40 then
      r21_47 = 29
      r20_47 = 25
      r19_47 = 180
    end
    dxDrawRectangle(r1_47, r2_47, r40_0.x, r40_0.y, BLACK)
    dxDrawRectangle(r1_47 + r42_0 / 2, r2_47 + r42_0 / 2, r40_0.x - r42_0, r40_0.y - r42_0, tocolor(r19_47, r20_47, r21_47, 155))
    dxDrawRectangle(r1_47 + r42_0 / 2, r2_47 + r42_0 / 2, (r40_0.x - r42_0) * r18_47 / 100, r40_0.y - r42_0, tocolor(r19_47, r20_47, r21_47, 155))
    dxDrawImage(r1_47 - screenSize.x * 0.004, r2_47, r43_0, r43_0, "public/hud/native/" .. r17_47 .. ".png")
    if r17_47 == "level" then
      dxDrawText(r11_47 .. "/" .. r12_47, r1_47, r2_47, r40_0.x + r1_47, r40_0.y + r2_47, rgba(theme.GRAY[200]), 0.8, "default-bold", "center", "center")
    end
    r1_47 = r1_47 + r40_0.x * 1.2
  end
  dxDrawText("[", 0, 0, screenSize.x * 1.716, screenSize.y * 0.115, tocolor(0, 0, 0), respc(5), "default-bold", "center", "bottom")
  dxDrawBorderedText(1, r10_47, 0, 0, screenSize.x * 1.803, screenSize.y * 0.155, tocolor(47, 90, 38), respc(2), "pricedown", "center", "center")
  dxDrawBorderedText(1, r9_47, 0, 0, screenSize.x * 1.803, screenSize.y * 0.205, tocolor(195, 195, 195), respc(1.4), "default-bold", "center", "center")
  dxDrawText("]", 0, 0, screenSize.x * 1.892, screenSize.y * 0.115, tocolor(0, 0, 0), respc(5), "default-bold", "center", "bottom")
  local r13_47 = math.min(localPlayer.armor)
  local r14_47 = r1_47 * 0.895
  local r15_47 = r2_47 + r40_0.y + r42_0 * 11
  if r13_47 > 0 then
    dxDrawRectangle(r14_47, r15_47, r41_0.x, r41_0.y, BLACK)
    dxDrawRectangle(r14_47 + r42_0 / 2, r15_47 + r42_0 / 2, r41_0.x - r42_0, r41_0.y - r42_0, tocolor(r44_0, r45_0, r46_0, 155))
    dxDrawRectangle(r14_47 + r42_0 / 2, r15_47 + r42_0 / 2, (r41_0.x - r42_0) * r13_47 / 100, r41_0.y - r42_0, tocolor(r44_0, r45_0, r46_0, 155))
  end
  local r16_47 = math.min(localPlayer.health)
  local r17_47 = r1_47 * 0.895
  local r18_47 = r2_47 + r40_0.y + r42_0 * 15
  dxDrawRectangle(r17_47, r18_47, r41_0.x, r41_0.y, BLACK)
  dxDrawRectangle(r17_47 + r42_0 / 2, r18_47 + r42_0 / 2, r41_0.x - r42_0, r41_0.y - r42_0, tocolor(r47_0, r48_0, r49_0, 155))
  dxDrawRectangle(r17_47 + r42_0 / 2, r18_47 + r42_0 / 2, (r41_0.x - r42_0) * r16_47 / 100, r41_0.y - r42_0, tocolor(r47_0, r48_0, r49_0, 155))
end, {
  name = "Native",
})
NeoHud = {
  enums = {},
}
local r50_0, r51_0 = guiGetScreenSize()
local r52_0 = math.min(r50_0 / 1920, r51_0 / 1080)
local r53_0 = r52_0
if r50_0 < 1920 then
  r53_0 = r52_0 * (1 + 0.25 * (1 - r50_0 / 1920))
end
NeoHud.circleSize = {
  x = 64 * r53_0,
  y = 64 * r53_0,
}
NeoHud.enums.rightTopAction = {
  Ping = "ping",
  Players = "players",
  ID = "ID",
}
NeoHud.rightTopActions = {
  {
    alias = "ID",
    action = NeoHud.enums.rightTopAction.ID,
  },
  {
    icon = Purple.rightTopActions[2].icon,
    action = NeoHud.enums.rightTopAction.Players,
  },
  {
    icon = Purple.rightTopActions[3].icon,
    action = NeoHud.enums.rightTopAction.Ping,
  }
}
NeoHud.iconSize = {
  x = NeoHud.circleSize.x / 3.5,
  y = NeoHud.circleSize.y / 3.5,
}
NeoHud.outerPadding = 15 * r53_0
NeoHud.icons = {
  circleBg = svgCreate(NeoHud.circleSize.x, NeoHud.circleSize.y, "public/hud/neo/circle-bg.svg"),
  circleFg = svgCreate(NeoHud.circleSize.x, NeoHud.circleSize.y, "public/hud/neo/circle-fg.svg"),
  healthIcon = svgCreate(NeoHud.iconSize.x, NeoHud.iconSize.y, "public/hud/neo/health.svg"),
  armorIcon = svgCreate(NeoHud.iconSize.x, NeoHud.iconSize.y, "public/hud/neo/armor.svg"),
  hungerIcon = svgCreate(NeoHud.iconSize.x, NeoHud.iconSize.y, "public/hud/neo/hunger.svg"),
  thirstIcon = svgCreate(NeoHud.iconSize.x, NeoHud.iconSize.y, "public/hud/neo/thirst.svg"),
  staminaIcon = svgCreate(NeoHud.iconSize.x, NeoHud.iconSize.y, "public/hud/neo/stamina.svg"),
  locationIcon = svgCreate(32 * r53_0, 32 * r53_0, "public/hud/neo/location.svg"),
}
NeoHud.circleBars = {
  "health",
  "armor",
  "hunger",
  "thirst",
  "stamina"
}
NeoHud.palette = {
  main = "#FFD66E",
}
NeoHud.colors = {
  health = "#93FF6E",
  healthShade = "#2A571B",
  armor = "#3AC2FD",
  hunger = "#FFB46E",
  thirst = "#6EFFD3",
  stamina = "#6E7DFF",
}
local r54_0 = {
  x = r50_0 - Purple.outerPadding * r53_0,
  y = Purple.outerPadding * 3 * r53_0,
}
local r55_0 = {
  x = resp(210) * r53_0,
  y = resp(20) * r53_0,
}
function NeoHud.drawBar(r0_48, r1_48, r2_48, r3_48)
  -- line: [1565, 1593] id: 48
  r1_48 = math.floor(math.min(100, math.max(0, r1_48 or 0)))
  dxDrawImage(r2_48.x, r2_48.y, r3_48.x, r3_48.y, NeoHud.icons.circleBg)
  local r4_48 = {
    x = r2_48.x + r3_48.x / 2 - NeoHud.iconSize.x / 2,
    y = r2_48.y + r3_48.y / 2 - NeoHud.iconSize.y / 2,
  }
  dxDrawImage(r4_48.x, r4_48.y, NeoHud.iconSize.x, NeoHud.iconSize.y, NeoHud.icons[r0_48 .. "Icon"], 0, 0, 0, NeoHud.colorsCache[r0_48])
  local r5_48 = -(r3_48.y * r1_48 / 100)
  dxDrawImageSection(r2_48.x, r2_48.y + r3_48.y, r3_48.x, r5_48, 0, 0, r3_48.x, r5_48, NeoHud.icons.circleFg, 0, 0, 0, NeoHud.colorsCache[r0_48])
end
createHudComponent("hud/neo", function(r0_49)
  -- line: [1595, 1791] id: 49
  for r4_49, r5_49 in ipairs(Purple.rightTopActions) do
    local r6_49 = {
      x = r55_0.x / #Purple.rightTopActions,
      y = r55_0.y,
    }
    local r7_49 = {
      x = r54_0.x - r6_49.x * r4_49,
      y = r54_0.y,
    }
    local r8_49 = Purple.getActionValue(r5_49.action)
    if r5_49.alias then
      dxDrawText(r5_49.alias, r7_49.x, r7_49.y, 0, r6_49.y + r7_49.y, NeoHud.colorsCache.main, r53_0, fonts.ProximaNovaBold.h6, "left", "center")
    else
      dxDrawImage(r7_49.x, r7_49.y + r6_49.y / 2 - r6_49.y / 2, r6_49.y, r6_49.y, r5_49.icon, 0, 0, 0, NeoHud.colorsCache.main)
    end
    dxDrawText(r8_49, r7_49.x + 24 * r53_0, r7_49.y + 1, 0, r6_49.y + r7_49.y + 1, NeoHud.colorsCache.gray_400, r53_0, fonts.ProximaNovaBold.h6, "left", "center")
    dxDrawText(r8_49, r7_49.x + 24 * r53_0, r7_49.y, 0, r6_49.y + r7_49.y, NeoHud.colorsCache.gray_50, r53_0, fonts.ProximaNovaBold.h6, "left", "center")
  end
  local r1_49 = r0_49:get("dimension") or 0
  local r2_49, r3_49, r4_49, r5_49 = exports.rl_radar:getRadarPosition()
  if r1_49 > 0 then
    r4_49 = 0
  end
  dxDrawText(r0_49:get("money") or 0, r2_49 + r4_49 + 11, r3_49 + 1, 0, r3_49 + r5_49 + 1, NeoHud.colorsCache.healthShade, 1, fonts.TabletGothicBold.header, "left", "bottom")
  dxDrawText(r0_49:get("money") or 0, r2_49 + r4_49 + 10, r3_49, 0, r3_49 + r5_49, NeoHud.colorsCache.health, 1, fonts.TabletGothicBold.header, "left", "bottom")
  local r6_49 = r0_49:get("weapon") or 0
  local r7_49 = r0_49:get("ammo") or ""
  if r6_49 ~= 0 then
    local r8_49 = {
      x = 100 * r53_0,
      y = 50 * r53_0,
    }
    local r9_49 = {
      x = r2_49 + r4_49 + 10 * r53_0,
      y = r3_49 + r5_49 - 100 * r53_0,
    }
    dxDrawImage(r9_49.x, r9_49.y, r8_49.x, r8_49.y, "public/weapons_modern/" .. r6_49 .. ".png")
    dxDrawText(r7_49, r9_49.x, r9_49.y, r9_49.x + r8_49.x - 10 * r53_0, r9_49.y + r8_49.y - 10 * r53_0, NeoHud.colorsCache.white, r53_0, fonts.TabletGothicBold.body, "right", "bottom", false, false, false, true)
  end
  if r1_49 == 0 then
    local r8_49 = {
      x = r4_49 * 0.8,
      y = 50 * r53_0,
    }
    local r9_49 = {
      x = r2_49,
      y = r3_49 - r8_49.y - 10 * r53_0,
    }
    drawRoundedRectangle({
      position = r9_49,
      size = r8_49,
      color = theme.GRAY[900],
      alpha = 0.8,
      radius = 12 * r53_0,
    })
    local r10_49 = {
      x = r8_49.y / 2,
      y = r8_49.y / 2,
    }
    local r11_49 = {
      x = r9_49.x + 10 * r53_0,
      y = r9_49.y + r8_49.y / 2 - r10_49.y / 2,
    }
    dxDrawImage(r11_49.x, r11_49.y, r10_49.x, r10_49.y, NeoHud.icons.locationIcon)
    dxDrawText("Konum", r11_49.x + 35 * r53_0, r11_49.y - 5 * r53_0, 0, 0, NeoHud.colorsCache.white_half, r53_0, fonts.ProximaNovaLight.caption)
    dxDrawText(r0_49:get("zoneName") or "", r11_49.x + 35 * r53_0, r11_49.y + 10 * r53_0, 0, 0, NeoHud.colorsCache.customGray, r53_0, fonts.ProximaNovaBold.h6)
  end
  if not localPlayer.vehicle then
    for r11_49, r12_49 in ipairs(NeoHud.circleBars) do
      NeoHud.drawBar(r12_49, r0_49:get(r12_49) or 0, {
        x = r50_0 - NeoHud.outerPadding - (NeoHud.circleSize.x + 5 * r53_0) * r11_49,
        y = r51_0 - NeoHud.outerPadding - NeoHud.circleSize.y,
      }, NeoHud.circleSize)
    end
  elseif useStore("carhud_data"):get("component") == "neo" then
    local r10_49 = NeoSpeedometer.containerPosition.x + NeoSpeedometer.containerSize.x / 2
    local r11_49 = NeoSpeedometer.containerPosition.y
    NeoHud.drawBar("health", r0_49:get("health"), {
      x = r10_49 - NeoHud.circleSize.x / 2,
      y = r11_49 - NeoHud.circleSize.y - 5 * r53_0,
    }, NeoHud.circleSize)
    NeoHud.drawBar("armor", r0_49:get("armor"), {
      x = r10_49 - NeoHud.circleSize.x / 2 - 70 * r53_0,
      y = r11_49 - 50 * r53_0,
    }, NeoHud.circleSize)
    NeoHud.drawBar("stamina", r0_49:get("stamina"), {
      x = r10_49 - NeoHud.circleSize.x / 2 - 130 * r53_0,
      y = r11_49 - 15 * r53_0,
    }, NeoHud.circleSize)
    NeoHud.drawBar("hunger", r0_49:get("hunger"), {
      x = r10_49 - NeoHud.circleSize.x / 2 + 70 * r53_0,
      y = r11_49 - 50 * r53_0,
    }, NeoHud.circleSize)
    NeoHud.drawBar("thirst", r0_49:get("thirst"), {
      x = r10_49 - NeoHud.circleSize.x / 2 + 130 * r53_0,
      y = r11_49 - 15 * r53_0,
    }, NeoHud.circleSize)
  end
end, {
  name = "Neo",
})
GradientHud = {}
GradientHud.backgroundSize = {
  x = 390,
  y = 78,
}
GradientHud.backgroundTopSize = {
  x = 280,
  y = 57,
}
GradientHud.backgroundTopPosition = {
  x = screenSize.x / 2 - GradientHud.backgroundTopSize.x / 2,
  y = 0,
}
GradientHud.backgroundPosition = {
  x = screenSize.x / 2 - GradientHud.backgroundSize.x / 2,
  y = screenSize.y - GradientHud.backgroundSize.y,
}
GradientHud.icons = {
  background = svgCreate(GradientHud.backgroundSize.x, GradientHud.backgroundSize.y, "public/hud/gradient/background.svg"),
  backgroundTop = svgCreate(GradientHud.backgroundTopSize.x, GradientHud.backgroundTopSize.y, "public/hud/gradient/background-top.svg"),
}
createHudComponent("hud/gradient", function(r0_50)
  -- line: [1821, 1973] id: 50
  if not serverName then
    serverName = exports.rl_core:get("name"):upper()
    serverFirstName = exports.rl_global:split(serverName, " ")[1]
  end
  dxDrawImage(GradientHud.backgroundPosition.x, GradientHud.backgroundPosition.y, GradientHud.backgroundSize.x, GradientHud.backgroundSize.y, GradientHud.icons.background)
  for r4_50, r5_50 in ipairs(NeoHud.circleBars) do
    local r6_50 = r0_50:get(r5_50) or 0
    local r7_50 = {
      x = GradientHud.backgroundPosition.x + NeoHud.outerPadding + (NeoHud.circleSize.x + 10) * (r4_50 - 1),
      y = GradientHud.backgroundPosition.y + 10,
    }
    if r6_50 > 100 then
      r6_50 = 100
    end
    NeoHud.drawBar(r5_50, r6_50, r7_50, NeoHud.circleSize)
    dxDrawText(r6_50 .. "%", r7_50.x, r7_50.y + 3, r7_50.x + NeoHud.circleSize.x, r7_50.y + NeoHud.circleSize.y + 3, rgba(theme.WHITE, 0.7), 0.75, fonts.ProximaNovaBold.caption, "center", "bottom")
  end
  dxDrawText(r0_50:get("name") or "", GradientHud.backgroundPosition.x + 36, GradientHud.backgroundPosition.y - 19, 0, 0, rgba(theme.GRAY[700]), 1, fonts.ProximaNovaBold.body, "left", "top")
  dxDrawText(r0_50:get("name") or "", GradientHud.backgroundPosition.x + 36, GradientHud.backgroundPosition.y - 20, 0, 0, rgba(theme.WHITE), 1, fonts.ProximaNovaBold.body, "left", "top")
  dxDrawText(r0_50:get("date") or "", GradientHud.backgroundPosition.x + 36, GradientHud.backgroundPosition.y - 19, GradientHud.backgroundPosition.x + GradientHud.backgroundSize.x - 36, 0, rgba(theme.GRAY[700]), 1, fonts.ProximaNovaBold.body, "right", "top")
  dxDrawText(r0_50:get("date") or "", GradientHud.backgroundPosition.x + 36, GradientHud.backgroundPosition.y - 20, GradientHud.backgroundPosition.x + GradientHud.backgroundSize.x - 36, 0, rgba(theme.WHITE), 1, fonts.ProximaNovaBold.body, "right", "top")
  dxDrawImage(GradientHud.backgroundTopPosition.x, GradientHud.backgroundTopPosition.y, GradientHud.backgroundTopSize.x, GradientHud.backgroundTopSize.y, GradientHud.icons.backgroundTop)
  local r1_50 = r0_50:get("weapon") or 0
  local r2_50 = r0_50:get("ammo") or ""
  drawLogo({
    position = {
      x = GradientHud.backgroundTopPosition.x + 20,
      y = GradientHud.backgroundTopPosition.y + GradientHud.backgroundTopSize.y / 2 - 16,
    },
    size = 32,
    opacity = 1,
    fill = theme.GRAY[50],
  })
  local r3_50 = {
    x = GradientHud.backgroundTopSize.y - 10,
    y = GradientHud.backgroundTopSize.y - 10,
  }
  dxDrawText(serverFirstName, GradientHud.backgroundTopPosition.x + r3_50.x + 10, GradientHud.backgroundTopPosition.y + 15, 0, 0, rgba(theme.WHITE), 1, fonts.ProximaNovaBold.caption)
  dxDrawText("ROLEPLAY", GradientHud.backgroundTopPosition.x + r3_50.x + 10, GradientHud.backgroundTopPosition.y + 28, 0, 0, rgba(theme.GRAY[300]), 1, fonts.ProximaNovaLight.caption)
  local r4_50 = {
    x = GradientHud.backgroundTopPosition.x + GradientHud.backgroundTopSize.x / 2 - r3_50.x / 2,
    y = GradientHud.backgroundTopPosition.y + GradientHud.backgroundTopSize.y + 10,
  }
  if r1_50 ~= 0 then
    dxDrawImage(r4_50.x, r4_50.y, r3_50.x, r3_50.y, "public/weapons/" .. r1_50 .. ".png")
    dxDrawText(r2_50, r4_50.x, r4_50.y + 5, r4_50.x + r3_50.x, r4_50.y + r3_50.y + 5, rgba(theme.GRAY[50], 1), 1, fonts.ProximaNovaBold.caption, "center", "bottom", false, false, false, true)
  end
  dxDrawText(r0_50:get("money") or 0, GradientHud.backgroundTopPosition.x - 25, GradientHud.backgroundTopPosition.y, GradientHud.backgroundTopPosition.x + GradientHud.backgroundTopSize.x - 25, GradientHud.backgroundTopPosition.y + GradientHud.backgroundTopSize.y, rgba(NeoHud.colors.health, 1), 1, fonts.TabletGothicBold.h1, "right", "center")
end, {
  name = "Gradient",
})
local r56_0 = {
  x = 32,
  y = 32,
}
local r57_0 = {
  x = screenSize.x / 2 - r56_0.x / 2,
  y = screenSize.y - r56_0.y - 10,
}
function renderSkull()
  -- line: [1987, 1996] id: 51
  if useStore("hud"):get("injury") ~= 1 then
    return 
  end
  dxDrawImage(r57_0.x, r57_0.y, r56_0.x, r56_0.y, "public/hud/native/skull.png")
end
createHudComponent("carhud/native", function()
  -- line: [1999, 2026] id: 52
  local r0_52 = localPlayer:getOccupiedVehicle()
  if not r0_52 then
    return 
  end
  local r1_52 = math.floor(exports.rl_global:getVehicleVelocity(r0_52) or 0)
  local r2_52 = math.floor(r0_52:getData("fuel") or 0) or 0
  dxDrawBorderedText(2, "Hız: #405239" .. r1_52 .. "#c1c1c1 km/h\n#2f3361Yakıt: #405239" .. r2_52 .. "#c1c1c1%" .. "\n#2f3361Kilometre: #405239" .. math.floor((r0_52:getData("odometer") or 0)) .. "#c1c1c1km", 0, 0, screenSize.x * 0.95, screenSize.y * 0.55, rgba("#2f3361"), 1, exports.kaisen_fonts:getFont("gtaFont", 18), "right", "center", false, false, true, true)
end, {
  name = "Native",
  options = {},
})
createHudComponent("carhud/triloy", function()
  -- line: [2031, 2042] id: 53
  local r0_53 = localPlayer:getOccupiedVehicle()
  if not r0_53 then
    return 
  end
  local r1_53 = math.floor(exports.rl_global:getVehicleVelocity(r0_53) or 0) or 0
  local r2_53 = math.floor(r0_53:getData("fuel") or 0) or 0
  dxDrawBorderText("Hız: " .. r1_53 .. " km/h\nYakıt: " .. r2_53 .. "%" .. "\nKilometre: " .. (math.floor(r0_53:getData("odometer") or 0) or 0) .. "km", screenSize.x - PADDING * 3, 0, screenSize.x - PADDING * 3, screenSize.y, tocolor(225, 225, 225), 1, fonts.h5.bold, "right", "center")
end, {
  name = "Trilogy",
  options = {},
})
local r58_0 = {
  {
    icon = "\u{f624}",
    prefix = "",
  },
  {
    icon = "\u{f52f}",
    prefix = "",
  },
  {
    icon = "",
    prefix = "KM",
  }
}
local r59_0 = {
  x = 230,
  y = 40,
}
createHudComponent("carhud/circular", function()
  -- line: [2058, 2141] id: 54
  local r0_54 = localPlayer:getOccupiedVehicle()
  if not r0_54 then
    return 
  end
  local r1_54 = math.floor(exports.rl_global:getVehicleVelocity(r0_54) or 0)
  local r2_54 = math.floor(r0_54:getData("fuel") or 0)
  local r3_54 = math.floor(r0_54:getData("odometer") or 0)
  local r4_54 = getCurrentRenderingHud("hud")
  local r5_54 = {
    x = screenSize.x - PADDING * 2 - r59_0.x,
    y = screenSize.y - PADDING * 2 - r59_0.y,
  }
  if r4_54 == "circular" then
    r5_54.y = r5_54.y - r59_0.y - 3
  end
  drawRoundedRectangle({
    position = r5_54,
    size = r59_0,
    color = theme.GRAY[800],
    radius = 15,
    alpha = 0.9,
    section = false,
  })
  if r0_54:getEngineState() then
    local r6_54 = getVehicleCurrentGear(r0_54)
    drawRoundedRectangle({
      position = r5_54,
      size = r59_0,
      color = theme.GRAY[700],
      radius = 15,
      alpha = 0.9,
      section = {
        percentage = getVehicleRPM(r0_54, r6_54, r1_54) / MAX_RPM * 100,
        direction = "left",
      },
    })
    if r1_54 == 0 then
      r6_54 = "N"
    elseif isVehicleReversing(r0_54, r6_54) then
      r6_54 = "R"
    end
    dxDrawText(r6_54, r5_54.x - 10, r5_54.y, r59_0.x + r5_54.x - 10, r59_0.y + r5_54.y, rgba(theme.GRAY[300], 1), 1, fonts.h6.bold, "right", "center")
  end
  r5_54.x = r5_54.x + 20
  for r9_54, r10_54 in ipairs(r58_0) do
    local r11_54 = ""
    if r9_54 == 1 then
      r11_54 = string.format("%03d", r1_54)
    elseif r9_54 == 2 then
      r11_54 = r2_54
    elseif r9_54 == 3 then
      r11_54 = r3_54
    end
    local r12_54 = dxGetTextWidth(r11_54, 1, fonts.body.regular)
    if r10_54.icon ~= "" then
      dxDrawText(r10_54.icon, r5_54.x, r5_54.y, r5_54.x + r59_0.x, r5_54.y + r59_0.y, rgba(theme.GRAY[400], 1), 0.5, fonts.icon, "left", "center", true, true)
    else
      dxDrawText(r10_54.prefix, r5_54.x, r5_54.y, r5_54.x + r59_0.x, r5_54.y + r59_0.y, rgba(theme.GRAY[400], 1), 1, fonts.body.bold, "left", "center", true, true)
    end
    dxDrawText(r11_54, r5_54.x + PADDING * 2.5, r5_54.y, r5_54.x + r59_0.x, r5_54.y + r59_0.y, rgba(theme.GRAY[400], 1), 1, fonts.body.regular, "left", "center", true, true)
    r5_54.x = r5_54.x + r12_54 + PADDING * 4
  end
end, {
  name = "Circular",
  options = {},
})
createHudComponent("carhud/purple", function()
  -- line: [2146, 2153] id: 55
  local r0_55 = localPlayer:getOccupiedVehicle()
  if not r0_55 then
    return 
  end
  exports.rl_speedo:renderSpeedometer(r0_55)
end, {
  name = "Purple",
  options = {},
})
NeoSpeedometer = {}
local r60_0, r61_0 = guiGetScreenSize()
local r62_0 = math.min(r60_0 / 1920, r61_0 / 1080)
local r63_0 = r62_0
if r60_0 < 1920 then
  r63_0 = r62_0 * (1 + 0.25 * (1 - r60_0 / 1920))
end
NeoSpeedometer.containerSize = {
  x = 343 * r63_0,
  y = 343 * r63_0,
}
NeoSpeedometer.containerPosition = {
  x = r60_0 - NeoSpeedometer.containerSize.x - 20 * r63_0,
  y = r61_0 - NeoSpeedometer.containerSize.y - 20 * r63_0,
}
NeoSpeedometer.discGap = 16 * r63_0
NeoSpeedometer.fuelBarSize = {
  x = 64 * r63_0,
  y = 214 * r63_0,
}
NeoSpeedometer.gradientBgSize = {
  x = 26 * r63_0,
  y = 84 * r63_0,
}
NeoSpeedometer.fuelBarPosition = {
  x = NeoSpeedometer.containerPosition.x + NeoSpeedometer.containerSize.x - NeoSpeedometer.fuelBarSize.x - 20 * r63_0,
  y = NeoSpeedometer.containerPosition.y + NeoSpeedometer.containerSize.y / 2 - NeoSpeedometer.fuelBarSize.y / 2 + 12 * r63_0,
}
NeoSpeedometer.batteryBarPosition = {
  x = NeoSpeedometer.containerPosition.x + 20 * r63_0,
  y = NeoSpeedometer.containerPosition.y + NeoSpeedometer.containerSize.y / 2 - NeoSpeedometer.fuelBarSize.y / 2 + 12 * r63_0,
}
NeoSpeedometer.actionIconSize = {
  x = 16 * r63_0,
  y = 16 * r63_0,
}
NeoSpeedometer.serviceBgSize = {
  x = 147 * r63_0,
  y = 21 * r63_0,
}
NeoSpeedometer.serviceBgPosition = {
  x = NeoSpeedometer.containerPosition.x + NeoSpeedometer.containerSize.x / 2 - NeoSpeedometer.serviceBgSize.x / 2,
  y = NeoSpeedometer.containerPosition.y + 70 * r63_0,
}
NeoSpeedometer.icons = {
  disc_bg = svgCreate(NeoSpeedometer.containerSize.x, NeoSpeedometer.containerSize.y, "public/carhud/neo/disc_bg.svg"),
  disc_fg = svgCreate(NeoSpeedometer.containerSize.x - NeoSpeedometer.discGap, NeoSpeedometer.containerSize.y - NeoSpeedometer.discGap, "public/carhud/neo/disc_fg.svg"),
  fuel_bar = svgCreate(NeoSpeedometer.fuelBarSize.x, NeoSpeedometer.fuelBarSize.y, "public/carhud/neo/fuel_bar.svg"),
  fuel_bar_fg = svgCreate(NeoSpeedometer.fuelBarSize.x, NeoSpeedometer.fuelBarSize.y, "public/carhud/neo/fuel_bar_fg.svg"),
  fuel = svgCreate(32 * r63_0, 32 * r63_0, "public/carhud/neo/fuel.svg"),
  battery_bar = svgCreate(NeoSpeedometer.fuelBarSize.x, NeoSpeedometer.fuelBarSize.y, "public/carhud/neo/battery_bar.svg"),
  battery_bar_fg = svgCreate(NeoSpeedometer.fuelBarSize.x, NeoSpeedometer.fuelBarSize.y, "public/carhud/neo/battery_bar_fg.svg"),
  battery = svgCreate(32 * r63_0, 32 * r63_0, "public/carhud/neo/battery.svg"),
  seatbelt = svgCreate(32 * r63_0, 32 * r63_0, "public/carhud/neo/seatbelt.svg"),
  lock = svgCreate(32 * r63_0, 32 * r63_0, "public/carhud/neo/lock.svg"),
  headlight = svgCreate(32 * r63_0, 32 * r63_0, "public/carhud/neo/headlight.svg"),
  engine = svgCreate(32 * r63_0, 32 * r63_0, "public/carhud/neo/engine.svg"),
  gradientBg = svgCreate(NeoSpeedometer.gradientBgSize.x, NeoSpeedometer.gradientBgSize.y, "public/carhud/neo/gradient-bg.svg"),
  serviceBg = svgCreate(NeoSpeedometer.serviceBgSize.x, NeoSpeedometer.serviceBgSize.y, "public/carhud/neo/service-bg.svg"),
  service = svgCreate(32 * r63_0, 32 * r63_0, "public/carhud/neo/service.svg"),
}
NeoSpeedometer.actions = {
  {
    key = "seatbelt",
    icon = NeoSpeedometer.icons.seatbelt,
    passiveColor = "#222222",
    activeColor = "#93FF6E",
  },
  {
    key = "lock",
    icon = NeoSpeedometer.icons.lock,
    passiveColor = "#222222",
    activeColor = "#F23C3C",
  },
  {
    key = "headlight",
    icon = NeoSpeedometer.icons.headlight,
    passiveColor = "#222222",
    activeColor = "#3AC2FD",
  },
  {
    key = "engine",
    icon = NeoSpeedometer.icons.engine,
    passiveColor = "#F23C3C",
    activeColor = "#FFB46E",
  }
}
NeoSpeedometer.speedFont = DxFont("public/carhud/Orbitron.ttf", 35)
function NeoSpeedometer.getActionValue(r0_56, r1_56)
  -- line: [2240, 2250] id: 56
  if r1_56 == "seatbelt" then
    return localPlayer:getData("seatbelt")
  elseif r1_56 == "lock" then
    return r0_56.locked
  elseif r1_56 == "headlight" then
    return r0_56.overrideLights == 2
  elseif r1_56 == "engine" then
    return r0_56.engineState
  end
end
createHudComponent("carhud/neo", function()
  -- line: [2252, 2491] id: 57
  local r0_57 = localPlayer:getOccupiedVehicle()
  if not r0_57 then
    return 
  end
  local r1_57 = math.floor(exports.rl_global:getVehicleVelocity(r0_57) or 0)
  local r2_57 = math.floor(r0_57:getData("fuel") or 0) or 0
  local r3_57 = exports.rl_vehicle:getMaxFuel(r0_57.model)
  if r3_57 < r2_57 then
    r2_57 = r3_57
  end
  local r4_57 = math.floor(r0_57:getData("odometer") or 0)
  dxDrawImage(NeoSpeedometer.containerPosition.x, NeoSpeedometer.containerPosition.y, NeoSpeedometer.containerSize.x, NeoSpeedometer.containerSize.y, NeoSpeedometer.icons.disc_bg)
  dxDrawImage(NeoSpeedometer.containerPosition.x + NeoSpeedometer.discGap / 2, NeoSpeedometer.containerPosition.y + NeoSpeedometer.discGap / 2, NeoSpeedometer.containerSize.x - NeoSpeedometer.discGap, NeoSpeedometer.containerSize.y - NeoSpeedometer.discGap, NeoSpeedometer.icons.disc_fg)
  dxDrawText(r1_57, NeoSpeedometer.containerPosition.x, NeoSpeedometer.containerPosition.y + NeoSpeedometer.containerSize.y / 2 - 80 * r63_0, NeoSpeedometer.containerPosition.x + NeoSpeedometer.containerSize.x, 0, rgba(theme.WHITE, 1), r63_0, NeoSpeedometer.speedFont, "center")
  dxDrawText(r4_57 .. " km", NeoSpeedometer.containerPosition.x, NeoSpeedometer.containerPosition.y + NeoSpeedometer.containerSize.y / 2 - 25 * r63_0, NeoSpeedometer.containerPosition.x + NeoSpeedometer.containerSize.x, 0, rgba(theme.GRAY[300], 1), 0.3 * r63_0, NeoSpeedometer.speedFont, "center")
  local r5_57 = 100
  local r7_57 = getTickCount() % 2000 / 1000
  if r7_57 > 1 then
    r7_57 = 2 - r7_57
  end
  r7_57 = getEasingValue(r7_57, "InOutQuad")
  if r0_57.health <= 600 then
    dxDrawText("* SERVİS GEREKİYOR *", NeoSpeedometer.containerPosition.x, NeoSpeedometer.containerPosition.y + 50 * r63_0, NeoSpeedometer.containerPosition.x + NeoSpeedometer.containerSize.x, 0, rgba(theme.YELLOW[500], r7_57), 0.35 * r63_0, fonts.ProximaNovaBold.h1, "center")
  end
  if r5_57 < 30 then
    dxDrawText("* YAĞ DEĞİŞİMİ GEREKİYOR *", NeoSpeedometer.containerPosition.x, NeoSpeedometer.containerPosition.y + 35 * r63_0, NeoSpeedometer.containerPosition.x + NeoSpeedometer.containerSize.x, 0, rgba(theme.PURPLE[500], r7_57), 0.3 * r63_0, fonts.ProximaNovaBold.h1, "center")
  else
    dxDrawText("YAĞ DURUMU: %" .. math.floor(r5_57), NeoSpeedometer.containerPosition.x, NeoSpeedometer.containerPosition.y + 35 * r63_0, NeoSpeedometer.containerPosition.x + NeoSpeedometer.containerSize.x, 0, rgba(theme.GRAY[300], 1), 0.35 * r63_0, fonts.ProximaNovaBold.h1, "center")
  end
  local r8_57 = exports.rl_vehicle_shop:getBrandLogo(r0_57)
  if r8_57 then
    dxDrawImage(NeoSpeedometer.containerPosition.x + NeoSpeedometer.containerSize.x / 2 - 24 * r63_0, NeoSpeedometer.containerPosition.y + NeoSpeedometer.containerSize.y / 2 - 24 * r63_0 + 24 * r63_0, 48 * r63_0, 48 * r63_0, r8_57)
  end
  local r10_57 = r2_57 / r3_57 * NeoSpeedometer.fuelBarSize.y
  local r11_57 = 100 / 100 * NeoSpeedometer.fuelBarSize.y
  dxDrawImage(NeoSpeedometer.fuelBarPosition.x, NeoSpeedometer.fuelBarPosition.y, NeoSpeedometer.fuelBarSize.x, NeoSpeedometer.fuelBarSize.y, NeoSpeedometer.icons.fuel_bar)
  dxDrawImageSection(NeoSpeedometer.fuelBarPosition.x, NeoSpeedometer.fuelBarPosition.y + NeoSpeedometer.fuelBarSize.y, NeoSpeedometer.fuelBarSize.x, -r10_57, 0, 0, NeoSpeedometer.fuelBarSize.x, -r10_57, NeoSpeedometer.icons.fuel_bar_fg)
  dxDrawImage(NeoSpeedometer.fuelBarPosition.x - 15 * r63_0, NeoSpeedometer.fuelBarPosition.y + NeoSpeedometer.fuelBarSize.y, 14 * r63_0, 14 * r63_0, NeoSpeedometer.icons.fuel)
  dxDrawImage(NeoSpeedometer.batteryBarPosition.x, NeoSpeedometer.batteryBarPosition.y, NeoSpeedometer.fuelBarSize.x, NeoSpeedometer.fuelBarSize.y, NeoSpeedometer.icons.battery_bar)
  dxDrawImageSection(NeoSpeedometer.batteryBarPosition.x, NeoSpeedometer.batteryBarPosition.y + NeoSpeedometer.fuelBarSize.y, NeoSpeedometer.fuelBarSize.x, -r11_57, 0, 0, NeoSpeedometer.fuelBarSize.x, -r11_57, NeoSpeedometer.icons.battery_bar_fg)
  dxDrawImage(NeoSpeedometer.batteryBarPosition.x + NeoSpeedometer.fuelBarSize.x, NeoSpeedometer.batteryBarPosition.y + NeoSpeedometer.fuelBarSize.y, 14 * r63_0, 14 * r63_0, NeoSpeedometer.icons.battery)
  for r15_57, r16_57 in ipairs(NeoSpeedometer.actions) do
    local r18_57 = nil	-- notice: implicit variable refs by block#[25]
    if NeoSpeedometer.getActionValue(r0_57, r16_57.key) then
      r18_57 = r16_57.activeColor
      if not r18_57 then
        ::label_480::
        r18_57 = r16_57.passiveColor
      end
    else
      goto label_480	-- block#24 is visited secondly
    end
    local r19_57 = {
      x = NeoSpeedometer.containerPosition.x + 92 * r63_0 + r15_57 * NeoSpeedometer.gradientBgSize.x,
      y = NeoSpeedometer.containerPosition.y + NeoSpeedometer.containerSize.y - NeoSpeedometer.gradientBgSize.y - 20 * r63_0,
    }
    dxDrawImage(r19_57.x, r19_57.y, NeoSpeedometer.gradientBgSize.x, NeoSpeedometer.gradientBgSize.y, NeoSpeedometer.icons.gradientBg, 0, 0, 0, rgba(r18_57, 1))
    dxDrawImage(r19_57.x + NeoSpeedometer.gradientBgSize.x / 2 - NeoSpeedometer.actionIconSize.x / 2, r19_57.y + 5, NeoSpeedometer.actionIconSize.x, NeoSpeedometer.actionIconSize.y, r16_57.icon, 0, 0, 0, rgba(r18_57, 1))
  end
  dxDrawImage(NeoSpeedometer.serviceBgPosition.x, NeoSpeedometer.serviceBgPosition.y, NeoSpeedometer.serviceBgSize.x, NeoSpeedometer.serviceBgSize.y, NeoSpeedometer.icons.serviceBg)
  dxDrawImage(NeoSpeedometer.serviceBgPosition.x + 10 * r63_0, NeoSpeedometer.serviceBgPosition.y + NeoSpeedometer.serviceBgSize.y / 2 - 7 * r63_0, 14 * r63_0, 14 * r63_0, NeoSpeedometer.icons.service)
  local r12_57 = {
    x = NeoSpeedometer.serviceBgSize.x - 40 * r63_0,
    y = NeoSpeedometer.serviceBgSize.y / 4,
  }
  local r13_57 = {
    x = NeoSpeedometer.serviceBgPosition.x + 35 * r63_0,
    y = NeoSpeedometer.serviceBgPosition.y + NeoSpeedometer.serviceBgSize.y / 2 - r12_57.y / 2,
  }
  drawRoundedRectangle({
    position = r13_57,
    size = r12_57,
    color = theme.GRAY[400],
    alpha = 1,
    radius = 2,
  })
  drawRoundedRectangle({
    position = r13_57,
    size = r12_57,
    color = theme.GRAY[200],
    alpha = 1,
    radius = 2,
    section = {
      percentage = math.floor(r0_57.health / 10),
      direction = "left",
    },
  })
end, {
  name = "Neo",
  options = {},
})
GradientSpeedometer = {}
createHudComponent("minimap/native", function(r0_58)
  -- line: [2498, 2514] id: 58
  setPlayerHudComponentVisible("radar", true)
  local r1_58 = exports.rl_streetnames:getPlayerStreetLocation(localPlayer)
  if r1_58 then
    dxDrawBorderedText(1, r1_58, 0, 0, screenSize.x * 0.265, screenSize.y * 0.975, tocolor(255, 255, 255), 1.3, "default-bold", "center", "bottom")
  end
end, {
  name = "Native",
})
function isNativeRadarVisible()
  -- line: [2518, 2520] id: 59
  return isPlayerHudComponentVisible("radar")
end
createHudComponent("minimap/rectangle", function(r0_60)
  -- line: [2522, 2524] id: 60
end, {
  name = "Rectangle",
})
