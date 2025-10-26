local seexports = {
  rl_death = false,
  rl_gui = false,
  rl_hud = false,
  rl_plate = false,
  rl_names = false,
  rl_speedo = false,
  rl_gps = false,
  rl_crosshair = false,
  rl_radar = false,
  rl_groups = false,
  rl_borders = false,
  rl_administration = false,
  rl_shader = false,
  rl_chat = false,
  rl_dof = false,
  rl_carshader = false,
  rl_osws = false,
  rl_roadshine = false,
  rl_radialblur = false,
  rl_watereffects = false,
  rl_voice = false,
  rl_animpanel = false,
  rl_clothesshop = false,
  rl_pointing = false,
  rl_camera = false,
  rl_items = false
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
local seelangCondHandlState0 = false
local function seelangCondHandl0(cond, prio)
  cond = cond and true or false
  if cond ~= seelangCondHandlState0 then
    seelangCondHandlState0 = cond
    if cond then
      addEventHandler("onClientRender", getRootElement(), streamerModePromptToFront, true, prio)
    else
      removeEventHandler("onClientRender", getRootElement(), streamerModePromptToFront)
    end
  end
end
local sliderDatas = {}
local toggleDatas = {}
local enumDatas = {}
local enumButtons = {}
local menus = {}
local currentMenu = 1
local currentChatAnim = 1
local currentFightStyle = 1
local movieShaderPreview = false
function saveValue(name, value)
  if fileExists("!dashboard/" .. name .. ".setting") then
    fileDelete("!dashboard/" .. name .. ".setting")
  end
  local fh = fileCreate("!dashboard/" .. name .. ".setting")
  if fh then
    fileWrite(fh, tostring(value))
    fileClose(fh)
  end
end
local savedFog = false
local savedFarClip = false
function getFarClipDistanceEx()
  return savedFarClip or getFarClipDistance()
end
function getFogDistanceEx()
  return savedFog or getFogDistance()
end
function setFogDistanceEx(dist)
  savedFog = dist
  if not exports.rl_death:isDeath() then
    setFogDistance(dist)
  end
end
function setFarClipDistanceEx(dist)
  savedFarClip = dist
  if not exports.rl_death:isDeath() then
    setFarClipDistance(dist)
  end
  local slider = menus[5].elements[2]
  if slider then
    sliderDatas[slider][3] = dist - 100
    menus[5].settings[2][4] = dist - 100
    local fog = getFogDistanceEx()
    if fog > sliderDatas[slider][3] then
      setFogDistanceEx(sliderDatas[slider][3])
      fog = sliderDatas[slider][3]
    end
    exports.rl_gui:setLabelText(sliderDatas[slider][1], math.floor(fog + 0.5))
    exports.rl_gui:setSliderValue(slider, (fog - sliderDatas[slider][2]) / (sliderDatas[slider][3] - sliderDatas[slider][2]))
  end
end
local crosshairColors = {
  "hudwhite",
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
  "v4grey1",
  "v4grey4",
  "v4midgrey",
  "v4lightgrey",
  "#ffffff",
  "#000000"
}
function getVignetteLevel()
  return exports.rl_hud:getVignetteLevel()
end
function setVignetteLevel(val)
  return exports.rl_hud:setVignetteLevel(val)
end
function getVignetteState()
  return exports.rl_hud:getVignetteState()
end
function setVignetteState(val)
  return exports.rl_hud:setVignetteState(val)
end
function setPlatesVisible(state)
  if state ~= plateState then
    plateState = state
    if plateState then
      addEventHandler("onClientRender", getRootElement(), renderPlates)
    else
      removeEventHandler("onClientRender", getRootElement(), renderPlates)
    end
  end
end
function setPlatesVisible(val)
  return exports.rl_plate:setPlatesVisible(val)
end
function getPlatesVisible()
  return exports.rl_plate:getPlatesVisible()
end
function setSquadsVisible(val)
  return exports.rl_names:setSquadsVisible(val)
end
function getSquadsVisible()
  return exports.rl_names:getSquadsVisible()
end
function getHudCommandState()
  return exports.rl_hud:getHudCommandState()
end
function setHudCommandState(val)
  return exports.rl_hud:setHudCommandState(val, 1)
end
function getInfoboxChatbox()
  return exports.rl_gui:getInfoboxChatbox()
end
function setInfoboxChatbox(val)
  return exports.rl_gui:setInfoboxChatbox(val)
end
function getInfoboxSound()
  return exports.rl_gui:getInfoboxSound()
end
function setInfoboxSound(val)
  return exports.rl_gui:setInfoboxSound(val)
end
function getSpeedoUnit()
  return exports.rl_speedo:getUnit()
end
function setSpeedoUnit(val)
  return exports.rl_speedo:setUnit(val)
end
function getGpsSoundPack()
  return exports.rl_gps:getGpsSoundPack()
end
function setGpsSoundPack(val)
  return exports.rl_gps:setGpsSoundPack(val)
end
function setCrosshair(id)
  local cData = exports.rl_crosshair:getCrosshair()
  cData[1] = id
  return exports.rl_crosshair:setCrosshair(cData)
end
function setCrosshairColor(col)
  local cData = exports.rl_crosshair:getCrosshair()
  if crosshairColors[col] then
    cData[2] = crosshairColors[col]
  else
    cData[2] = "hudwhite"
  end
  return exports.rl_crosshair:setCrosshair(cData)
end
function setColorSet(val)
  return exports.rl_gui:setColorSet(val)
end
function get3DBlipState()
  return exports.rl_radar:get3DBlipState()
end

function set3DBlipState(val)
  return exports.rl_radar:set3DBlipState(val)
end
function get3DBlipAlpha()
  return exports.rl_radar:get3DBlipAlpha()
end
function set3DBlipAlpha(val)
  return exports.rl_radar:set3DBlipAlpha(val)
end 
function setD2State(val)
  return exports.rl_groups:setD2State(val)
end
function getAirfieldState()
  return exports.rl_groups:getAirfieldState()
end

function getD2State()
  return exports.rl_groups:getD2State()
end
function setAirfieldState(val)
  return exports.rl_groups:setAirfieldState(val)
end
function getTogTraffi()
  return exports.rl_groups:getTogTraffi()
end
function setTogTraffi(val)
  return exports.rl_groups:setTogTraffi(val)
end
function getTogGroupMsg()
  return exports.rl_groups:getTogGroupMsg()
end
function setTogGroupMsg(val)
  return exports.rl_groups:setTogGroupMsg(val)
end
function getTogHatar()
  return exports.rl_borders:getBorderState()
end
function setTogHatar(val)
  return exports.rl_borders:setBorderState(val)
end
function getTogKick()
  return exports.rl_administration:getTogKick()
end
function setTogKick(val)
  return exports.rl_administration:setTogKick(val)
end
function getBlipColorState()
  return exports.rl_radar:getBlipColorState()
end
function setBlipColorState(val)
  return exports.rl_radar:setBlipColorState(val)
end
function getNameSize()
  return exports.rl_names:getNameSize()
end
function setNameSize(val)
  return exports.rl_names:setNameSize(val)
end
function getNameAlpha()
  return exports.rl_names:getNameAlpha()
end
function setNameAlpha(val)
  return exports.rl_names:setNameAlpha(val)
end
function getNameFont()
  return exports.rl_names:getNameFont()
end
function setNameFont(val)
  return exports.rl_names:setNameFont(val)
end
function getMovieShaderState()
  return exports.rl_shader:getMovieShaderState()
end
function setCurrentMoviePreset(val)
  return exports.rl_shader:setCurrentMoviePreset(val)
end
function setNamesState(val)
  return exports.rl_names:setNamesState(val)
end
function getNamesState()
  return exports.rl_names:getNamesState()
end
function setOwnNamesState(val)
  return exports.rl_names:setOwnNameState(val)
end
function getOwnNamesState()
  return exports.rl_names:getOwnNameState()
end
function getOOCTimestamps()
  return exports.rl_chat:getOOCTimestamps()
end
function setOOCTimestamps(val)
  return exports.rl_chat:setOOCTimestamps(val)
end
function setMovieShaderState(val)
  local target = exports.rl_shader:setMovieShaderState(val)
  if movieShaderPreview then
    if isElement(target) then
      exports.rl_gui:setImageFile(movieShaderPreview, target)
    else
      exports.rl_gui:setImageDDS(movieShaderPreview, ":rl_dashboard/news/def.dds")
    end
  end
end
function getMovieShaderHue()
  return exports.rl_shader:getMovieShaderData("Hue")
end
function setMovieShaderHue(val)
  return exports.rl_shader:setMovieShaderData("Hue", val)
end
function getMovieShaderBrightness()
  return exports.rl_shader:getMovieShaderData("Brightness") * 100
end
function setMovieShaderBrightness(val)
  return exports.rl_shader:setMovieShaderData("Brightness", val / 100)
end
function getMovieShaderContrast()
  return exports.rl_shader:getMovieShaderData("Contrast") * 50
end
function setMovieShaderContrast(val)
  return exports.rl_shader:setMovieShaderData("Contrast", val / 50)
end
function getMovieShaderSaturation()
  return exports.rl_shader:getMovieShaderData("Saturation") * 50
end
function setMovieShaderSaturation(val)
  return exports.rl_shader:setMovieShaderData("Saturation", val / 50)
end
function getMovieShaderR()
  return exports.rl_shader:getMovieShaderData("R") * 50
end
function setMovieShaderR(val)
  return exports.rl_shader:setMovieShaderData("R", val / 50)
end
function getMovieShaderG()
  return exports.rl_shader:getMovieShaderData("G") * 50
end
function setMovieShaderG(val)
  return exports.rl_shader:setMovieShaderData("G", val / 50)
end
function getMovieShaderB()
  return exports.rl_shader:getMovieShaderData("B") * 50
end
function setMovieShaderB(val)
  return exports.rl_shader:setMovieShaderData("B", val / 50)
end
function getMovieShaderL()
  return exports.rl_shader:getMovieShaderData("L") * 50
end
function setMovieShaderL(val)
  return exports.rl_shader:setMovieShaderData("L", val / 50)
end
function getMovieShadernoise()
  return exports.rl_shader:getMovieShaderData("noise") * 50
end
function setMovieShadernoise(val)
  return exports.rl_shader:setMovieShaderData("noise", val / 50)
end
function setDofState(val)
  exports.rl_dof:setDofState(val)
end
function getDofState()
  return exports.rl_dof:getDofState()
end
function setCarPaintState(val)
  exports.rl_carshader:setCarPaintState(val)
end
function getCarPaintState()
  return exports.rl_carshader:getCarPaintState()
end
function setOswsState(val)
  exports.rl_osws:setOswsState(val)
end
function getOswsState()
  return exports.rl_osws:getOswsState()
end
function setRoadShineState(val)
  exports.rl_roadshine:setRoadShineState(val)
end
function getRoadShineState()
  return exports.rl_roadshine:getRoadShineState()
end
function setRadialBlurState(val)
  exports.rl_radialblur:setRadialBlurState(val)
end
function getRadialBlurState()
  return exports.rl_radialblur:getRadialBlurState()
end
function setWaterEffectState(val)
  exports.rl_watereffects:setWaterEffectState(val)
end
function getWaterEffectState()
  return exports.rl_watereffects:getWaterEffectState()
end
function setVoiceVolume(val)
  exports.rl_voice:setVoiceVolume(val)
end
function getVoiceVolume()
  return exports.rl_voice:getVoiceVolume()
end
local streamerMode = true
function getStreamerMode()
  return streamerMode
end
addEvent("streamerModeChanged", false)
function setStreamerMode(val)
  streamerMode = val
  triggerEvent("streamerModeChanged", localPlayer, val)
end
function getAnimCircleBind()
  return exports.rl_animpanel:getAnimCircleBind()
end
function setAnimCircleBind(btn)
  return exports.rl_animpanel:setAnimCircleBind(btn)
end
function setCustomVoiceBind(bind)
  exports.rl_voice:setCustomBind(bind)
end
function getCustomVoiceBind()
  return exports.rl_voice:getCustomBind()
end
function getAnimPanelBind()
  return exports.rl_animpanel:getAnimPanelBind()
end
function setAnimPanelBind(btn)
  return exports.rl_animpanel:setAnimPanelBind(btn)
end
function getCuccaimBind()
  return exports.rl_clothesshop:getCuccaimBind()
end
function setCuccaimBind(btn)
  return exports.rl_clothesshop:setCuccaimBind(btn)
end
function getTempomatToggle()
  return exports.rl_speedo:getCruiseKey("toggle")
end
function getTempomatIncrease()
  return exports.rl_speedo:getCruiseKey("increase")
end
function getTempomatDecrease()
  return exports.rl_speedo:getCruiseKey("decrease")
end
function getTempomatMul()
  return exports.rl_speedo:getCruiseKey("mul")
end
function getTempomatDiv()
  return exports.rl_speedo:getCruiseKey("div")
end
function setTempomatToggle(btn)
  return exports.rl_speedo:setCruiseKey("toggle", btn)
end
function setTempomatIncrease(btn)
  return exports.rl_speedo:setCruiseKey("increase", btn)
end
function setTempomatDecrease(btn)
  return exports.rl_speedo:setCruiseKey("decrease", btn)
end
function setTempomatMul(btn)
  return exports.rl_speedo:setCruiseKey("mul", btn)
end
function setTempomatDiv(btn)
  return exports.rl_speedo:setCruiseKey("div", btn)
end
function getSpoilerKey()
  return exports.rl_speedo:getSpoilerKey()
end
function setSpoilerKey(btn)
  return exports.rl_speedo:setSpoilerKey(btn)
end
function getCurrentChatAnim()
  if currentChatAnim == #chatAnims then
    return nil
  elseif currentChatAnim == #chatAnims - 1 then
    return math.random(1, #chatAnims - 2)
  else
    return currentChatAnim
  end
end
function setCurrentChatAnim(val)
  if val <= #chatAnims then
    currentChatAnim = val
  else
    currentChatAnim = 1
  end
end
function getPointingKey()
  return exports.rl_pointing:getPointingKey()
end
function setPointingKey(btn)
  return exports.rl_pointing:setPointingKey(btn)
end
function getFpHeight()
  return exports.rl_camera:getFpHeight()
end
function setFpHeight(val)
  return exports.rl_camera:setFpHeight(val)
end
function getFpHeightInCar()
  return exports.rl_camera:getFpHeightInCar()
end
function setFpHeightInCar(val)
  return exports.rl_camera:setFpHeightInCar(val)
end
function getFpMouseSens()
  return exports.rl_camera:getFpMouseSens()
end
function setFpMouseSens(val)
  return exports.rl_camera:setFpMouseSens(val)
end
function getBeltKey()
  return exports.rl_speedo:getBeltKey()
end
function setBeltKey(val)
  return exports.rl_speedo:setBeltKey(val)
end
function getDownShift()
  return exports.rl_speedo:getDownShift()
end
function setDownShift(val)
  return exports.rl_speedo:setDownShift(val)
end
function getUpShift()
  return exports.rl_speedo:getUpShift()
end
function setUpShift(val)
  return exports.rl_speedo:setUpShift(val)
end
function getTogCursorKey()
  return exports.rl_gui:getTogCursorKey()
end
function setTogCursorKey(val)
  return exports.rl_gui:setTogCursorKey(val)
end
movieShaderNames = {
  "Egyedi",
  "Csomag #1",
  "Csomag #2",
  "Csomag #3",
  "Csomag #4",
  "Csomag #5",
  "Csomag #6",
  "Csomag #7",
  "Csomag #8",
  "Csomag #9",
  "Csomag #10",
  "Csomag #11"
}
-- menus = {
  -- {
    -- name = "Megjelenés",
    -- settings = {
      -- {
        -- "Vignette effekt",
        -- "toggle",
        -- getVignetteState,
        -- setVignetteState,
        -- true,
        -- "vignetteState"
      -- },
      -- {
        -- "Vignette erősség",
        -- "slider",
        -- 0,
        -- 100,
        -- getVignetteLevel,
        -- setVignetteLevel,
        -- "vignetteLevel"
      -- },
      -- {"line"},
      -- {
        -- "movieShaderStart"
      -- },
      -- {
        -- "V4Mod grafika",
        -- "toggle",
        -- getMovieShaderState,
        -- setMovieShaderState,
        -- true,
        -- "movieShaderState_v4"
      -- },
      -- {
        -- "Grafikai csomag",
        -- "movieShaderPreset"
      -- },
      -- {
        -- "Árnyalat",
        -- "slider",
        -- 0,
        -- 360,
        -- getMovieShaderHue,
        -- setMovieShaderHue,
        -- "movieShaderHue_v4"
      -- },
      -- {
        -- "Fényerő",
        -- "slider",
        -- -100,
        -- 100,
        -- getMovieShaderBrightness,
        -- setMovieShaderBrightness,
        -- "movieShaderBrightness_v4"
      -- },
      -- {
        -- "Kontraszt",
        -- "slider",
        -- -100,
        -- 100,
        -- getMovieShaderContrast,
        -- setMovieShaderContrast,
        -- "movieShaderContrast_v4"
      -- },
      -- {
        -- "Telítettség",
        -- "slider",
        -- 0,
        -- 100,
        -- getMovieShaderSaturation,
        -- setMovieShaderSaturation,
        -- "movieShaderSaturation_v4"
      -- },
      -- {
        -- "Vörös",
        -- "slider",
        -- 0,
        -- 100,
        -- getMovieShaderR,
        -- setMovieShaderR,
        -- "movieShaderR_v4"
      -- },
      -- {
        -- "Zöld",
        -- "slider",
        -- 0,
        -- 100,
        -- getMovieShaderG,
        -- setMovieShaderG,
        -- "movieShaderG_v4"
      -- },
      -- {
        -- "Kék",
        -- "slider",
        -- 0,
        -- 100,
        -- getMovieShaderB,
        -- setMovieShaderB,
        -- "movieShaderB_v4"
      -- },
      -- {
        -- "Fényesség",
        -- "slider",
        -- 0,
        -- 100,
        -- getMovieShaderL,
        -- setMovieShaderL,
        -- "movieShaderL_v4"
      -- },
      -- {
        -- "Zaj",
        -- "slider",
        -- 0,
        -- 100,
        -- getMovieShadernoise,
        -- setMovieShadernoise,
        -- "movieShadernoise_v4"
      -- },
      -- {
        -- "movieShaderEnd"
      -- },
      -- {"line"},
      -- {
        -- "Mélységélesség",
        -- "toggle",
        -- getDofState,
        -- setDofState,
        -- false,
        -- "dofState"
      -- },
      -- {
        -- "Jármű tükröződés",
        -- "toggle",
        -- getCarPaintState,
        -- setCarPaintState,
        -- false,
        -- "carPaint"
      -- },
      -- {
        -- "Víz tükröződés",
        -- "toggle",
        -- getOswsState,
        -- setOswsState,
        -- false,
        -- "osws"
      -- },
      -- {
        -- "Napfény",
        -- "toggle",
        -- getRoadShineState,
        -- setRoadShineState,
        -- false,
        -- "roadShine"
      -- },
      -- {
        -- "Mozgási elmosódás",
        -- "toggle",
        -- getRadialBlurState,
        -- setRadialBlurState,
        -- false,
        -- "radialBlur"
      -- },
      -- {
        -- "Vízcseppek",
        -- "toggle",
        -- getWaterEffectState,
        -- setWaterEffectState,
        -- false,
        -- "waterEffects"
      -- }
    -- },
    -- labels = {},
    -- elements = {}
  -- },
  -- {
    -- name = "Színséma",
    -- settings = {
      -- {"Színséma", "colorset"},
      -- {"line"},
      -- {
        -- "Példa",
        -- "colorsetTest"
      -- }
    -- },
    -- labels = {},
    -- elements = {}
  -- },
  -- {
    -- name = "Felület",
    -- settings = {
      -- {
        -- "HUD megjelenítése",
        -- "toggle",
        -- getHudCommandState,
        -- setHudCommandState,
        -- false,
        -- "hudState"
      -- },
      -- {"line"},
      -- {
        -- "Radar ikonok színe",
        -- "enum",
        -- {
          -- "Színes",
          -- "Fehér",
          -- "Fekete",
          -- "Szürke"
        -- },
        -- getBlipColorState,
        -- setBlipColorState,
        -- "radarBlipColorState"
      -- },
      -- {
        -- "3D blipek megjelenítése",
        -- "toggle",
        -- get3DBlipState,
        -- set3DBlipState,
        -- true,
        -- "radar3DBlipState"
      -- },
      -- {
        -- "3D blipek átlátszósága",
        -- "slider",
        -- 75,
        -- 255,
        -- get3DBlipAlpha,
        -- set3DBlipAlpha,
        -- "radar3DBlipAlpha"
      -- },
      -- {"line"},
      -- {
        -- "Kilóméteróra mértékegység",
        -- "enum",
        -- {"KM/H", "MPH"},
        -- getSpeedoUnit,
        -- setSpeedoUnit,
        -- "speedoUnit"
      -- },
      -- {"line"},
      -- {
        -- "Nevek megjelenítése",
        -- "toggle",
        -- getNamesState,
        -- setNamesState,
        -- false,
        -- "namesState"
      -- },
      -- {
        -- "Saját név megjelenítése",
        -- "toggle",
        -- getOwnNamesState,
        -- setOwnNamesState,
        -- false,
        -- "ownNamesState"
      -- },
      -- {
        -- "Név méret",
        -- "slider",
        -- 0,
        -- 100,
        -- getNameSize,
        -- setNameSize,
        -- "nameSize"
      -- },
      -- {
        -- "Név átlátszóság",
        -- "slider",
        -- 75,
        -- 255,
        -- getNameAlpha,
        -- setNameAlpha,
        -- "nameAlpha"
      -- },
      -- {
        -- "Név betűtípus",
        -- "enumNameFont",
        -- {
          -- "Betűtípus #1",
          -- "Betűtípus #2"
        -- },
        -- getNameFont,
        -- setNameFont,
        -- "nameFont"
      -- },
      -- {"line"},
      -- {
        -- "Célkereszt",
        -- "crosshair"
      -- },
      -- {
        -- "Célkereszt színe",
        -- "crosshairColor"
      -- },
      -- {"line"},
      -- {
        -- "Rendszámtáblák megjelenítése",
        -- "toggle",
        -- getPlatesVisible,
        -- setPlatesVisible,
        -- false,
        -- "plateState"
      -- },
      -- {
        -- "Egységszámok megjelenítése",
        -- "toggle",
        -- getSquadsVisible,
        -- setSquadsVisible,
        -- false,
        -- "squadState"
      -- }
    -- },
    -- labels = {},
    -- elements = {}
  -- },
  -- {
    -- name = "Chat",
    -- settings = {
      -- {
        -- "Infoboxok kiírása chatre",
        -- "toggle",
        -- getInfoboxChatbox,
        -- setInfoboxChatbox,
        -- false,
        -- "infoboxChatbox"
      -- },
      -- {
        -- "Infoboxok hangja",
        -- "toggle",
        -- getInfoboxSound,
        -- setInfoboxSound,
        -- false,
        -- "infoboxChatbox"
      -- },
      -- {
        -- "Kick üzenetek",
        -- "toggle",
        -- getTogKick,
        -- setTogKick,
        -- false,
        -- "togkick"
      -- },
      -- {"line"},
      -- {
        -- "Frakció üzenetek",
        -- "toggle",
        -- getTogGroupMsg,
        -- setTogGroupMsg,
        -- true,
        -- "toggroupmsg"
      -- },
      -- {
        -- "/d2 megjelenítése",
        -- "toggle",
        -- getD2State,
        -- setD2State,
        -- false,
        -- "d2State"
      -- },
      -- {
        -- "Légtér értesítések",
        -- "toggle",
        -- getAirfieldState,
        -- setAirfieldState,
        -- false,
        -- "airfieldState"
      -- },
      -- {
        -- "Traffipax értesítések (Rendvédelem)",
        -- "toggle",
        -- getTogTraffi,
        -- setTogTraffi,
        -- false,
        -- "togtraffi"
      -- },
      -- {
        -- "Határ értesítések (Rendvédelem)",
        -- "toggle",
        -- getTogHatar,
        -- setTogHatar,
        -- false,
        -- "toghatar"
      -- },
      -- {"line"},
      -- {
        -- "OOC Chat időbélyegek",
        -- "toggle",
        -- getOOCTimestamps,
        -- setOOCTimestamps,
        -- false,
        -- "oocTimestamps"
      -- }
    -- },
    -- labels = {},
    -- elements = {}
  -- },
  -- {
    -- name = "Karakter és játékmenet",
    -- settings = {
      -- {
        -- "Látóhatár",
        -- "slider",
        -- 300,
        -- 6000,
        -- getFarClipDistanceEx,
        -- setFarClipDistanceEx,
        -- "farClipDistance"
      -- },
      -- {
        -- "Köd távolság",
        -- "slider",
        -- 10,
        -- getFarClipDistanceEx() - 100,
        -- getFogDistanceEx,
        -- setFogDistanceEx,
        -- "fogDistance"
      -- },
      -- {"line"},
      -- {
        -- "Voice hangerő",
        -- "slider",
        -- 0,
        -- 100,
        -- getVoiceVolume,
        -- setVoiceVolume,
        -- "voiceVolume"
      -- },
      -- {"line"},
      -- {
        -- "GPS hang",
        -- "enum",
        -- {
          -- "Női",
          -- "Férfi",
          -- "Kikapcsolva"
        -- },
        -- getGpsSoundPack,
        -- setGpsSoundPack,
        -- "gpsSoundPack"
      -- },
      -- {"line"},
      -- {
        -- "Streamer mód",
        -- "toggle",
        -- getStreamerMode,
        -- setStreamerMode,
        -- true,
        -- "streamerMode"
      -- },
      -- {
        -- "Streamer módban az összes jogvédett zene lenémításra kerül.",
        -- "text"
      -- },
      -- {"line"},
      -- {
        -- "Sétastílus",
        -- "walkingStyle"
      -- },
      -- {
        -- "Harcstílus",
        -- "fightingStyle"
      -- },
      -- {
        -- "Beszéd animáció",
        -- "chatAnim"
      -- },
      -- {"line"},
      -- {
        -- "First Person magasság",
        -- "slider",
        -- 0,
        -- 100,
        -- getFpHeight,
        -- setFpHeight,
        -- "fpHeight"
      -- },
      -- {
        -- "First Person magasság járműben",
        -- "slider",
        -- 0,
        -- 100,
        -- getFpHeightInCar,
        -- setFpHeightInCar,
        -- "fpHeightCar"
      -- },
      -- {
        -- "First Person egérérzékenység",
        -- "slider",
        -- 0,
        -- 100,
        -- getFpMouseSens,
        -- setFpMouseSens,
        -- "fpMouse"
      -- }
    -- },
    -- labels = {},
    -- elements = {}
  -- },
  -- {
    -- name = "Irányítás",
    -- settings = {
      -- {
        -- "Voice egyedi nyomógomb",
        -- "keyBind",
        -- getCustomVoiceBind,
        -- setCustomVoiceBind,
        -- "voice",
        -- "q"
      -- },
      -- {"line"},
      -- {
        -- "Animációk gyors elérése",
        -- "keyBind",
        -- getAnimCircleBind,
        -- setAnimCircleBind,
        -- "animcircle",
        -- "mouse3"
      -- },
      -- {
        -- "Animáció lista",
        -- "keyBind",
        -- getAnimPanelBind,
        -- setAnimPanelBind,
        -- "animpanel",
        -- "F2"
      -- },
      -- {"line"},
      -- {
        -- "Kiegészítők",
        -- "keyBind",
        -- getCuccaimBind,
        -- setCuccaimBind,
        -- "cuccaim",
        -- "F9"
      -- },
      -- {"line"},
      -- {
        -- "Mutatás",
        -- "keyBind",
        -- getPointingKey,
        -- setPointingKey,
        -- "pointing",
        -- "x"
      -- },
      -- {"line"},
      -- {
        -- "Tempomat be/ki",
        -- "keyBind",
        -- getTempomatToggle,
        -- setTempomatToggle,
        -- "tempotoggle",
        -- "c"
      -- },
      -- {
        -- "Tempomat sebesség +",
        -- "keyBind",
        -- getTempomatIncrease,
        -- setTempomatIncrease,
        -- "tempoup",
        -- "num_add"
      -- },
      -- {
        -- "Tempomat sebesség -",
        -- "keyBind",
        -- getTempomatDecrease,
        -- setTempomatDecrease,
        -- "tempodown",
        -- "num_sub"
      -- },
      -- {
        -- "Tempomat távolság +",
        -- "keyBind",
        -- getTempomatMul,
        -- setTempomatMul,
        -- "tempodistup",
        -- "num_mul"
      -- },
      -- {
        -- "Tempomat távolság -",
        -- "keyBind",
        -- getTempomatDiv,
        -- setTempomatDiv,
        -- "tempodistdown",
        -- "num_div"
      -- },
      -- {
        -- "Active Spoiler",
        -- "keyBind",
        -- getSpoilerKey,
        -- setSpoilerKey,
        -- "activespoiler",
        -- "num_5"
      -- },
      -- {
        -- "Biztonsági öv",
        -- "keyBind",
        -- getBeltKey,
        -- setBeltKey,
        -- "v4tbelt",
        -- "F5"
      -- },
      -- {
        -- "Sebességváltó -",
        -- "keyBind",
        -- getDownShift,
        -- setDownShift,
        -- "downshift",
        -- "lctrl"
      -- },
      -- {
        -- "Sebességváltó +",
        -- "keyBind",
        -- getUpShift,
        -- setUpShift,
        -- "upshift",
        -- "lshift"
      -- },
      -- {"line"},
      -- {
        -- "Kurzor mód (nyomva tartva)",
        -- "keyBind",
        -- getTogCursorKey,
        -- setTogCursorKey,
        -- "togcursor",
        -- "lalt"
      -- }
    -- },
    -- labels = {},
    -- elements = {}
  -- }
-- }
local inside = false
function settingsInsideDestroy()
  inside = false
  movieShaderPreview = false
  sliderDatas = {}
  toggleDatas = {}
  enumDatas = {}
  enumButtons = {}
end
local rtg = false
local sx, sy = 0, 0
local buttonsWidth = 0
local fontSize = 0
local buttonsHeight = 0
local colorSetLabel = false
local colorSetSave = false
local colorSetTmp = false
local colorSetRectangles = {}
local colorSetTestWindow = false
local colorSetTestBtn = {}
local colorSetTestRect = {}
local colorSetTestImg = {}
local colorSetTestLabel = {}
local crosshairImages = {}
local crosshairColorRect = false
local movieShaderPresetLabel = false
local walkingStyleLabel = false
local chatAnimLabel = false
local moviePresetLocation = false
local movieShaderStartY = 0
local bindInProgress = false
local bindData = {}
local bindButtonDatas = {}
local bindButtonCache = {}
function bindKeyEvent(key, por)
  if key and por then
    removeEventHandler("onClientKey", getRootElement(), bindKeyEvent)
    local x, y = exports.rl_gui:getGuiPosition(bindData.bindElement)
    local sx, sy = exports.rl_gui:getGuiSize(bindData.bindElement)
    local parent = exports.rl_gui:getGuiParent(bindData.bindElement)
    exports.rl_gui:deleteGuiElement(bindData.bindElement)
    local defaultValue = bindButtonDatas.defaultValue
    bindButtonCache[bindData.bindElement] = nil
    local fontSize = screenX < 1600 and 11 or 12
    local button = "Nincs"
    if key == "escape" then
      bindButtonDatas.setter(false)
    else
      bindButtonDatas.setter(key)
    end
    local bind = bindButtonDatas.getter()
    saveValue(bindButtonDatas.saveValue, tostring(bind))
    if bind then
      button = utf8.upper(bind)
    end
    local w = exports.rl_gui:getTextWidthFont(button, fontSize + 2 .. "/BebasNeueBold.otf") + 8
    bindData.bindElement = exports.rl_gui:createGuiElement("button", x, y, math.max(w, sy), sy, inside)
    exports.rl_gui:setButtonFont(bindData.bindElement, fontSize + 2 .. "/BebasNeueBold.otf")
    exports.rl_gui:setButtonTextColor(bindData.bindElement, "v4grey1")
    exports.rl_gui:setButtonText(bindData.bindElement, button)
    exports.rl_gui:setGuiBackground(bindData.bindElement, "solid", "#ffffff")
    exports.rl_gui:setGuiHover(bindData.bindElement, "gradient", {
      "v4lightgrey",
      "#ffffff"
    }, true)
    exports.rl_gui:setClickEvent(bindData.bindElement, "startBindingProcess")
    bindButtonCache[bindData.bindElement] = {}
    bindButtonCache[bindData.bindElement].getter = bindButtonDatas.getter
    bindButtonCache[bindData.bindElement].setter = bindButtonDatas.setter
    bindButtonCache[bindData.bindElement].saveValue = bindButtonDatas.saveValue
    bindButtonCache[bindData.bindElement].defaultValue = bindButtonDatas.defaultValue
    if bind and utf8.lower(bind) ~= utf8.lower(defaultValue) then
      local btn2 = exports.rl_gui:createGuiElement("image", x + math.max(w, sy) + dashboardPadding[3] * 2, y, 24, 24, inside)
      exports.rl_gui:setImageFile(btn2, exports.rl_gui:getFaIconFilename("undo", 24))
      exports.rl_gui:setGuiHoverable(btn2, true)
      exports.rl_gui:setGuiHover(btn2, "solid", "v4red")
      exports.rl_gui:guiSetTooltip(btn2, "Alapértelmezett beállítás")
      exports.rl_gui:setClickEvent(btn2, "resetBind")
      bindButtonCache[btn2] = {}
      bindButtonCache[btn2].bindElement = bindData.bindElement
      bindButtonCache[btn2].setter = bindButtonDatas.setter
      bindButtonCache[btn2].saveValue = bindButtonDatas.saveValue
      bindButtonCache[btn2].value = bindButtonDatas.defaultValue
      bindButtonCache[bindData.bindElement].resetElement = btn2
    end
    bindInProgress = false
  end
  cancelEvent()
end
addEvent("startBindingProcess", true)
addEventHandler("startBindingProcess", getRootElement(), function(button, state, absoluteX, absoluteY, el)
  if not bindInProgress then
    bindInProgress = true
    bindData = {}
    bindData.bindElement = el
    bindButtonDatas.getter = bindButtonCache[el].getter
    bindButtonDatas.setter = bindButtonCache[el].setter
    bindButtonDatas.saveValue = bindButtonCache[el].saveValue
    bindButtonDatas.defaultValue = bindButtonCache[el].defaultValue
    local x, y = exports.rl_gui:getGuiPosition(el)
    local sx, sy = exports.rl_gui:getGuiSize(el)
    local parent = exports.rl_gui:getGuiParent(el)
    exports.rl_gui:deleteGuiElement(el)
    if bindButtonCache[el].resetElement then
      exports.rl_gui:deleteGuiElement(bindButtonCache[el].resetElement)
      bindButtonCache[bindButtonCache[el].resetElement] = nil
    end
    local fontSize = screenX < 1600 and 11 or 12
    bindData.bindElement = exports.rl_gui:createGuiElement("label", x, y, 1024, sy, parent)
    exports.rl_gui:setLabelFont(bindData.bindElement, fontSize .. "/Ubuntu-L.ttf")
    exports.rl_gui:setLabelAlignment(bindData.bindElement, "left", "center")
    exports.rl_gui:setLabelText(bindData.bindElement, "Nyomj egy gombot a beállításhoz, ESC gombot a bind törléséhez.")
    addEventHandler("onClientKey", getRootElement(), bindKeyEvent)
  end
end)
addEvent("resetBind", true)
addEventHandler("resetBind", getRootElement(), function(button, state, absoluteX, absoluteY, el)
  if not bindInProgress then
    local data = bindButtonCache[el]
    if data then
      exports.rl_gui:deleteGuiElement(el)
      saveValue(data.saveValue, data.value)
      data.setter(data.value)
      local fontSize = screenX < 1600 and 11 or 12
      local w = exports.rl_gui:getTextWidthFont(utf8.upper(data.value), fontSize + 2 .. "/BebasNeueBold.otf") + 8
      local x, y = exports.rl_gui:getGuiSize(data.bindElement)
      exports.rl_gui:setGuiSize(data.bindElement, math.max(y, w), y)
      exports.rl_gui:setButtonText(data.bindElement, utf8.upper(data.value))
      bindButtonCache[el] = nil
    end
  end
end)
local currentWalkingStyle = 1
function drawSettingsMenu()
  sliderDatas = {}
  if inside then
    exports.rl_gui:deleteGuiElement(inside)
  end
  inside = exports.rl_gui:createGuiElement("null", 0, 0, sx, sy, rtg)
  local fontSize = 12
  local dh = 24
  local h = dh
  local gs = 20
  if screenX < 1600 then
    fontSize = 11
    dh = 20
    h = dh
    gs = 16
  end
  local w = 0
  local x = buttonsWidth + dashboardPadding[3] * 4
  local y = dashboardPadding[3] * 4
  local image = exports.rl_gui:createGuiElement("image", sx + dashboardPadding[3] * 8 - 512, sy + dashboardPadding[3] * 8 - 512, 512, 512, inside)
  exports.rl_gui:setImageDDS(image, ":rl_dashboard/files/settings_bcg_big.dds")
  local lastLine = 0
  for k = 1, #menus[currentMenu].settings do
    if menus[currentMenu].settings[k][1] == "movieShaderStart" or menus[currentMenu].settings[k][1] == "movieShaderEnd" then
    elseif menus[currentMenu].settings[k][1] == "line" then
      y = y + 2 + dashboardPadding[3] * 2
      lastLine = y
    else
      if menus[currentMenu].settings[k][2] == "crosshair" then
        h = 64
      else
        h = dh
      end
      local label = exports.rl_gui:createGuiElement("label", x, y, 0, h, inside)
      exports.rl_gui:setLabelFont(label, math.max(fontSize - (menus[currentMenu].settings[k][2] == "text" and 1 or 0), 11) .. "/Ubuntu-L.ttf")
      exports.rl_gui:setLabelAlignment(label, "left", "center")
      exports.rl_gui:setLabelText(label, menus[currentMenu].settings[k][1] .. (menus[currentMenu].settings[k][2] ~= "text" and ": " or ""))
      local tw = exports.rl_gui:getLabelTextWidth(label)
      if menus[currentMenu].settings[k][2] ~= "text" and w < tw then
        w = tw
      end
      menus[currentMenu].labels[k] = label
      y = y + h + dashboardPadding[3] * 2
      if y > sy then
        y = lastLine
        x = x + w + dashboardPadding[3] * 2 + gs * 4
      end
    end
  end
  y = dashboardPadding[3] * 4
  x = buttonsWidth + dashboardPadding[3] * 4 + w + dashboardPadding[3] * 2
  lastLine = 0
  for k = 1, #menus[currentMenu].settings do
    menus[currentMenu].elements[k] = false
    if menus[currentMenu].settings[k][2] == "crosshair" then
      h = 64
    else
      h = dh
    end
    if menus[currentMenu].settings[k][1] == "line" then
      local border = exports.rl_gui:createGuiElement("hr", buttonsWidth + dashboardPadding[3] * 4, y, sx - buttonsWidth - dashboardPadding[3] * 4, 2, inside)
      y = y + 2 + dashboardPadding[3] * 2
      lastLine = y
    elseif menus[currentMenu].settings[k][2] == "slider" then
      local slider = exports.rl_gui:createGuiElement("slider", x, y + h / 2 - (gs - 6) / 2, 300, gs - 6, inside)
      exports.rl_gui:setSliderChangeEvent(slider, "settingsSliderChange")
      local val = menus[currentMenu].settings[k][3]
      if menus[currentMenu].settings[k][5] then
        val = menus[currentMenu].settings[k][5]()
      end
      exports.rl_gui:setSliderValue(slider, (val - menus[currentMenu].settings[k][3]) / (menus[currentMenu].settings[k][4] - menus[currentMenu].settings[k][3]))
      local label = exports.rl_gui:createGuiElement("label", x + 300 + dashboardPadding[3] * 2, y, 0, h, inside)
      exports.rl_gui:setLabelFont(label, "11/Ubuntu-L.ttf")
      exports.rl_gui:setLabelAlignment(label, "left", "center")
      exports.rl_gui:setLabelText(label, math.floor(val + 0.5))
      menus[currentMenu].elements[k] = slider
      sliderDatas[slider] = {
        label,
        menus[currentMenu].settings[k][3],
        menus[currentMenu].settings[k][4],
        menus[currentMenu].settings[k][6],
        menus[currentMenu].settings[k][7]
      }
      y = y + h + dashboardPadding[3] * 2
    elseif menus[currentMenu].settings[k][2] == "enum" or menus[currentMenu].settings[k][2] == "enumNameFont" then
      local val = menus[currentMenu].settings[k][4]()
      enumButtons[k] = {}
      for i = 1, #menus[currentMenu].settings[k][3] do
        local btn = exports.rl_gui:createGuiElement("button", x + (i - 1) * (100 + dashboardPadding[3]), y + h / 2 - gs / 2, 100, gs, inside)
        if val == menus[currentMenu].settings[k][3][i] then
          exports.rl_gui:setGuiBackground(btn, "solid", "v4green")
          exports.rl_gui:setGuiHover(btn, "gradient", {
            "v4green",
            "v4green-second"
          }, true)
        else
          exports.rl_gui:setGuiBackground(btn, "solid", "v4grey1")
          exports.rl_gui:setGuiHover(btn, "gradient", {"v4grey1", "v4grey2"}, true)
        end
        if menus[currentMenu].settings[k][2] == "enumNameFont" then
          if i == 1 then
            exports.rl_gui:setButtonFont(btn, "11/BebasNeueBold.otf")
          else
            exports.rl_gui:setButtonFont(btn, "10/Ubuntu-B.ttf")
          end
        else
          exports.rl_gui:setButtonFont(btn, "11/BebasNeueRegular.otf")
        end
        exports.rl_gui:setButtonTextColor(btn, "#ffffff")
        exports.rl_gui:setClickEvent(btn, "settingsEnumClick")
        exports.rl_gui:setButtonText(btn, menus[currentMenu].settings[k][3][i])
        enumDatas[btn] = {
          menus[currentMenu].settings[k][5],
          menus[currentMenu].settings[k][3][i],
          k,
          menus[currentMenu].settings[k][6]
        }
        enumButtons[k][i] = {
          btn,
          menus[currentMenu].settings[k][3][i]
        }
      end
      y = y + h + dashboardPadding[3] * 2
    elseif menus[currentMenu].settings[k][2] == "walkingStyle" then
      menus[currentMenu].elements[k] = {}
      local btn = exports.rl_gui:createGuiElement("image", x, y - (32 - h) / 2, 32, 32, inside)
      exports.rl_gui:setImageFile(btn, exports.rl_gui:getFaIconFilename("caret-left", 32))
      exports.rl_gui:setGuiHoverable(btn, true)
      exports.rl_gui:setGuiHover(btn, "solid", "v4green")
      exports.rl_gui:setClickEvent(btn, "dashChangeWalkStyle")
      exports.rl_gui:setClickArgument(btn, -1)
      table.insert(menus[currentMenu].elements[k], btn)
      walkingStyleLabel = exports.rl_gui:createGuiElement("label", x + 32, y, 96, h, inside)
      exports.rl_gui:setLabelFont(walkingStyleLabel, "11/BebasNeueRegular.otf")
      exports.rl_gui:setLabelAlignment(walkingStyleLabel, "center", "center")
      exports.rl_gui:setLabelText(walkingStyleLabel, walkingStyles[currentWalkingStyle][2])
      local btn = exports.rl_gui:createGuiElement("image", x + 128, y - (32 - h) / 2, 32, 32, inside)
      exports.rl_gui:setImageFile(btn, exports.rl_gui:getFaIconFilename("caret-right", 32))
      exports.rl_gui:setGuiHoverable(btn, true)
      exports.rl_gui:setGuiHover(btn, "solid", "v4green")
      exports.rl_gui:setClickEvent(btn, "dashChangeWalkStyle")
      exports.rl_gui:setClickArgument(btn, 1)
      table.insert(menus[currentMenu].elements[k], btn)
      moviePresetLocation = k
      y = y + h + dashboardPadding[3] * 2
    elseif menus[currentMenu].settings[k][2] == "fightingStyle" then
      menus[currentMenu].elements[k] = {}
      local btn = exports.rl_gui:createGuiElement("image", x, y - (32 - h) / 2, 32, 32, inside)
      exports.rl_gui:setImageFile(btn, exports.rl_gui:getFaIconFilename("caret-left", 32))
      exports.rl_gui:setGuiHoverable(btn, true)
      exports.rl_gui:setGuiHover(btn, "solid", "v4green")
      exports.rl_gui:setClickEvent(btn, "dashChangeFightStyle")
      exports.rl_gui:setClickArgument(btn, -1)
      table.insert(menus[currentMenu].elements[k], btn)
      fightingStyleLabel = exports.rl_gui:createGuiElement("label", x + 32, y, 96, h, inside)
      exports.rl_gui:setLabelFont(fightingStyleLabel, "11/BebasNeueRegular.otf")
      exports.rl_gui:setLabelAlignment(fightingStyleLabel, "center", "center")
      exports.rl_gui:setLabelText(fightingStyleLabel, "Stílus #" .. currentFightStyle)
      local btn = exports.rl_gui:createGuiElement("image", x + 128, y - (32 - h) / 2, 32, 32, inside)
      exports.rl_gui:setImageFile(btn, exports.rl_gui:getFaIconFilename("caret-right", 32))
      exports.rl_gui:setGuiHoverable(btn, true)
      exports.rl_gui:setGuiHover(btn, "solid", "v4green")
      exports.rl_gui:setClickEvent(btn, "dashChangeFightStyle")
      exports.rl_gui:setClickArgument(btn, 1)
      table.insert(menus[currentMenu].elements[k], btn)
      moviePresetLocation = k
      y = y + h + dashboardPadding[3] * 2
    elseif menus[currentMenu].settings[k][2] == "chatAnim" then
      menus[currentMenu].elements[k] = {}
      local btn = exports.rl_gui:createGuiElement("image", x, y - (32 - h) / 2, 32, 32, inside)
      exports.rl_gui:setImageFile(btn, exports.rl_gui:getFaIconFilename("caret-left", 32))
      exports.rl_gui:setGuiHoverable(btn, true)
      exports.rl_gui:setGuiHover(btn, "solid", "v4green")
      exports.rl_gui:setClickEvent(btn, "dashChangeChatAnim")
      exports.rl_gui:setClickArgument(btn, -1)
      table.insert(menus[currentMenu].elements[k], btn)
      chatAnimLabel = exports.rl_gui:createGuiElement("label", x + 32, y, 96, h, inside)
      exports.rl_gui:setLabelFont(chatAnimLabel, "11/BebasNeueRegular.otf")
      exports.rl_gui:setLabelAlignment(chatAnimLabel, "center", "center")
      if currentChatAnim == #chatAnims then
        exports.rl_gui:setLabelText(chatAnimLabel, "Kikapcsolva")
      elseif currentChatAnim == #chatAnims - 1 then
        exports.rl_gui:setLabelText(chatAnimLabel, "Véletlenszerű")
      else
        exports.rl_gui:setLabelText(chatAnimLabel, "Animáció #" .. currentChatAnim)
      end
      local btn = exports.rl_gui:createGuiElement("image", x + 128, y - (32 - h) / 2, 32, 32, inside)
      exports.rl_gui:setImageFile(btn, exports.rl_gui:getFaIconFilename("caret-right", 32))
      exports.rl_gui:setGuiHoverable(btn, true)
      exports.rl_gui:setGuiHover(btn, "solid", "v4green")
      exports.rl_gui:setClickEvent(btn, "dashChangeChatAnim")
      exports.rl_gui:setClickArgument(btn, 1)
      table.insert(menus[currentMenu].elements[k], btn)
      moviePresetLocation = k
      y = y + h + dashboardPadding[3] * 2
    elseif menus[currentMenu].settings[k][2] == "crosshairColor" then
      local btn = exports.rl_gui:createGuiElement("image", x, y - (32 - h) / 2, 32, 32, inside)
      exports.rl_gui:setImageFile(btn, exports.rl_gui:getFaIconFilename("caret-left", 32))
      exports.rl_gui:setGuiHoverable(btn, true)
      exports.rl_gui:setGuiHover(btn, "solid", "v4green")
      exports.rl_gui:setClickEvent(btn, "dashPreviusCrosshairColor")
      local crosshair = exports.rl_crosshair:getCrosshair()
      local id = crosshair[1]
      local color = crosshair[2]
      crosshairColorRect = exports.rl_gui:createGuiElement("rectangle", x + 72 - 7, y + h / 2 - 7, 14, 14, inside)
      exports.rl_gui:setGuiBackground(crosshairColorRect, "solid", color)
      local btn = exports.rl_gui:createGuiElement("image", x + 96 + 16, y - (32 - h) / 2, 32, 32, inside)
      exports.rl_gui:setImageFile(btn, exports.rl_gui:getFaIconFilename("caret-right", 32))
      exports.rl_gui:setGuiHoverable(btn, true)
      exports.rl_gui:setGuiHover(btn, "solid", "v4green")
      exports.rl_gui:setClickEvent(btn, "dashNextCrosshairColor")
      y = y + h + dashboardPadding[3] * 2
    elseif menus[currentMenu].settings[k][2] == "crosshair" then
      local crosshair = exports.rl_crosshair:getCrosshair()
      local id = crosshair[1]
      local color = crosshair[2]
      local btn = exports.rl_gui:createGuiElement("image", x, y - (32 - h) / 2, 32, 32, inside)
      exports.rl_gui:setImageFile(btn, exports.rl_gui:getFaIconFilename("caret-left", 32))
      exports.rl_gui:setGuiHoverable(btn, true)
      exports.rl_gui:setGuiHover(btn, "solid", "v4green")
      exports.rl_gui:setClickEvent(btn, "dashPreviusCrosshair")
      local btn = exports.rl_gui:createGuiElement("image", x + 96 + 16, y - (32 - h) / 2, 32, 32, inside)
      exports.rl_gui:setImageFile(btn, exports.rl_gui:getFaIconFilename("caret-right", 32))
      exports.rl_gui:setGuiHoverable(btn, true)
      exports.rl_gui:setGuiHover(btn, "solid", "v4green")
      exports.rl_gui:setClickEvent(btn, "dashNextCrosshair")
      local px, py = math.floor(x + 32 + 8), math.floor(y + h / 2 - 32)
      crosshairImages = {}
      local image = exports.rl_gui:createGuiElement("image", px, py, 32, 32, inside)
      exports.rl_gui:setImageDDS(image, ":rl_crosshair/files/" .. id .. ".dds")
      exports.rl_gui:setImageColor(image, color)
      table.insert(crosshairImages, image)
      local image = exports.rl_gui:createGuiElement("image", px, py + 32, 32, 32, inside)
      exports.rl_gui:setImageDDS(image, ":rl_crosshair/files/" .. id .. ".dds")
      exports.rl_gui:setImageColor(image, color)
      exports.rl_gui:setImageRotation(image, 270)
      table.insert(crosshairImages, image)
      local image = exports.rl_gui:createGuiElement("image", px + 32, py, 32, 32, inside)
      exports.rl_gui:setImageDDS(image, ":rl_crosshair/files/" .. id .. ".dds")
      exports.rl_gui:setImageColor(image, color)
      exports.rl_gui:setImageRotation(image, 90)
      table.insert(crosshairImages, image)
      local image = exports.rl_gui:createGuiElement("image", px + 32, py + 32, 32, 32, inside)
      exports.rl_gui:setImageDDS(image, ":rl_crosshair/files/" .. id .. ".dds")
      exports.rl_gui:setImageColor(image, color)
      exports.rl_gui:setImageRotation(image, 180)
      table.insert(crosshairImages, image)
      y = y + h + dashboardPadding[3] * 2
    elseif menus[currentMenu].settings[k][1] == "movieShaderStart" then
      movieShaderStartY = y
    elseif menus[currentMenu].settings[k][1] == "movieShaderEnd" then
      local w = sx - (x + 300 + 32 + gs)
      local h = y - movieShaderStartY - dashboardPadding[3] * 2
      local iw = w - 64
      local ih = screenY * w / screenX - 64
      local px = x + 300 + 32 + gs + w / 2 - iw / 2
      local py = movieShaderStartY + h / 2 - ih / 2
      local rect = exports.rl_gui:createGuiElement("rectangle", px - 8, py - 8, iw + 16, ih + 16, inside)
      exports.rl_gui:setGuiBackground(rect, "solid", "v4grey1")
      movieShaderPreview = exports.rl_gui:createGuiElement("image", px, py, iw, ih, inside)
      if isElement(exports.rl_shader:getShaderTarget()) then
        exports.rl_gui:setImageFile(movieShaderPreview, exports.rl_shader:getShaderTarget())
      else
        exports.rl_gui:setImageDDS(movieShaderPreview, ":rl_dashboard/files/wallp.dds")
      end
    elseif menus[currentMenu].settings[k][2] == "movieShaderPreset" then
      menus[currentMenu].elements[k] = {}
      local btn = exports.rl_gui:createGuiElement("image", x, y - (32 - h) / 2, 32, 32, inside)
      exports.rl_gui:setImageFile(btn, exports.rl_gui:getFaIconFilename("caret-left", 32))
      exports.rl_gui:setGuiHoverable(btn, true)
      exports.rl_gui:setGuiHover(btn, "solid", "v4green")
      exports.rl_gui:setClickEvent(btn, "dashPreviusMoviePreset")
      table.insert(menus[currentMenu].elements[k], btn)
      movieShaderPresetLabel = exports.rl_gui:createGuiElement("label", x + 32, y, 96, h, inside)
      exports.rl_gui:setLabelFont(movieShaderPresetLabel, "11/BebasNeueRegular.otf")
      exports.rl_gui:setLabelAlignment(movieShaderPresetLabel, "center", "center")
      exports.rl_gui:setLabelText(movieShaderPresetLabel, movieShaderNames[exports.rl_shader:getCurrentMoviePreset()])
      local btn = exports.rl_gui:createGuiElement("image", x + 128, y - (32 - h) / 2, 32, 32, inside)
      exports.rl_gui:setImageFile(btn, exports.rl_gui:getFaIconFilename("caret-right", 32))
      exports.rl_gui:setGuiHoverable(btn, true)
      exports.rl_gui:setGuiHover(btn, "solid", "v4green")
      exports.rl_gui:setClickEvent(btn, "dashNextMoviePreset")
      table.insert(menus[currentMenu].elements[k], btn)
      moviePresetLocation = k
      y = y + h + dashboardPadding[3] * 2
    elseif menus[currentMenu].settings[k][2] == "keyBind" then
      local button = "Nincs"
      local bind = menus[currentMenu].settings[k][3]()
      if bind then
        button = utf8.upper(bind)
      end
      local w = exports.rl_gui:getTextWidthFont(button, fontSize + 2 .. "/BebasNeueBold.otf") + 8
      local btn = exports.rl_gui:createGuiElement("button", x, y, math.max(w, h), h, inside)
      exports.rl_gui:setButtonFont(btn, fontSize + 2 .. "/BebasNeueBold.otf")
      exports.rl_gui:setButtonTextColor(btn, "v4grey1")
      exports.rl_gui:setButtonText(btn, button)
      exports.rl_gui:setGuiBackground(btn, "solid", "#ffffff")
      exports.rl_gui:setGuiHover(btn, "gradient", {
        "v4lightgrey",
        "#ffffff"
      }, true)
      exports.rl_gui:setClickEvent(btn, "startBindingProcess")
      bindButtonCache[btn] = {}
      bindButtonCache[btn].getter = menus[currentMenu].settings[k][3]
      bindButtonCache[btn].setter = menus[currentMenu].settings[k][4]
      bindButtonCache[btn].saveValue = menus[currentMenu].settings[k][5]
      bindButtonCache[btn].defaultValue = menus[currentMenu].settings[k][6]
      if bind and utf8.lower(menus[currentMenu].settings[k][6]) ~= utf8.lower(bind) then
        local btn2 = exports.rl_gui:createGuiElement("image", x + math.max(w, h) + dashboardPadding[3] * 2, y, 24, 24, inside)
        exports.rl_gui:setImageFile(btn2, exports.rl_gui:getFaIconFilename("undo", 24))
        exports.rl_gui:setGuiHoverable(btn2, true)
        exports.rl_gui:setGuiHover(btn2, "solid", "v4red")
        exports.rl_gui:guiSetTooltip(btn2, "Alapértelmezett beállítás")
        exports.rl_gui:setClickEvent(btn2, "resetBind")
        bindButtonCache[btn2] = {}
        bindButtonCache[btn2].bindElement = btn
        bindButtonCache[btn2].setter = menus[currentMenu].settings[k][4]
        bindButtonCache[btn2].saveValue = menus[currentMenu].settings[k][5]
        bindButtonCache[btn2].value = menus[currentMenu].settings[k][6]
        bindButtonCache[btn].resetElement = btn2
      end
      y = y + h + dashboardPadding[3] * 2
    elseif menus[currentMenu].settings[k][2] == "colorsetTest" then
      colorSetTestBtn = {}
      colorSetTestRect = {}
      colorSetTestImg = {}
      colorSetTestLabel = {}
      local pw = 300
      local titleBarHeight = exports.rl_gui:getTitleBarHeight()
      local ph = titleBarHeight + 80
      local rect = exports.rl_gui:createGuiElement("rectangle", x, y, pw + dashboardPadding[3] * 2, ph + dashboardPadding[3] * 2, inside)
      exports.rl_gui:setGuiBackground(rect, "solid", "#fff")
      colorSetTestWindow = exports.rl_gui:createGuiElement("window", x + dashboardPadding[3], y + dashboardPadding[3], pw, ph, inside)
      exports.rl_gui:setWindowTitle(colorSetTestWindow, "16/BebasNeueRegular.otf", "Teszt")
      exports.rl_gui:setGuiHoverable(colorSetTestWindow, false)
      local label = exports.rl_gui:createGuiElement("label", 0, titleBarHeight, pw, ph - 8 - 32 - 8 - titleBarHeight, colorSetTestWindow)
      exports.rl_gui:setLabelAlignment(label, "center", "center")
      exports.rl_gui:setLabelText(label, "Ez egy teszt ablak.")
      exports.rl_gui:setLabelFont(label, "11/Ubuntu-R.ttf")
      local w = (pw - 24) / 2
      local btn = exports.rl_gui:createGuiElement("button", 8, ph - 8 - 32, w, 32, colorSetTestWindow)
      exports.rl_gui:setButtonFont(btn, "15/BebasNeueBold.otf")
      exports.rl_gui:setButtonText(btn, "Igen")
      colorSetTestBtn[btn] = "v4green"
      local btn = exports.rl_gui:createGuiElement("button", pw - w - 8, ph - 8 - 32, w, 32, colorSetTestWindow)
      exports.rl_gui:setButtonFont(btn, "15/BebasNeueBold.otf")
      exports.rl_gui:setButtonText(btn, "Nem")
      colorSetTestBtn[btn] = "v4red"
      y = y + ph + dashboardPadding[3] * 4
      local tw = exports.rl_gui:getTextWidthFont("0000100000 SSC", "22/BebasNeueBold.otf")
      local rect = exports.rl_gui:createGuiElement("rectangle", x, y, tw + dashboardPadding[3] * 2, 128 + dashboardPadding[3] * 2, inside)
      colorSetTestRect[rect] = "v4grey1"
      y = y + dashboardPadding[3]
      local label = exports.rl_gui:createGuiElement("label", x + dashboardPadding[3], y, 0, 32, inside)
      exports.rl_gui:setLabelAlignment(label, "left", "center")
      exports.rl_gui:setLabelText(label, "- 100000 $")
      exports.rl_gui:setLabelFont(label, "22/BebasNeueBold.otf")
      colorSetTestLabel[label] = "v4red"
      y = y + 32
      local label = exports.rl_gui:createGuiElement("label", x + dashboardPadding[3], y, 0, 32, inside)
      exports.rl_gui:setLabelAlignment(label, "left", "center")
      exports.rl_gui:setLabelText(label, "0000")
      exports.rl_gui:setLabelFont(label, "22/BebasNeueBold.otf")
      colorSetTestLabel[label] = "hudwhite"
      local label = exports.rl_gui:createGuiElement("label", x + dashboardPadding[3] + exports.rl_gui:getLabelTextWidth(label), y, 0, 32, inside)
      exports.rl_gui:setLabelAlignment(label, "left", "center")
      exports.rl_gui:setLabelText(label, "100000 $")
      exports.rl_gui:setLabelFont(label, "22/BebasNeueBold.otf")
      colorSetTestLabel[label] = "v4green"
      y = y + 32
      local label = exports.rl_gui:createGuiElement("label", x + dashboardPadding[3], y, 0, 32, inside)
      exports.rl_gui:setLabelAlignment(label, "left", "center")
      exports.rl_gui:setLabelText(label, "0000")
      exports.rl_gui:setLabelFont(label, "22/BebasNeueBold.otf")
      colorSetTestLabel[label] = "hudwhite"
      local label = exports.rl_gui:createGuiElement("label", x + dashboardPadding[3] + exports.rl_gui:getLabelTextWidth(label), y, 0, 32, inside)
      exports.rl_gui:setLabelAlignment(label, "left", "center")
      exports.rl_gui:setLabelText(label, "100000 PP")
      exports.rl_gui:setLabelFont(label, "22/BebasNeueBold.otf")
      colorSetTestLabel[label] = "v4blue"
      y = y + 32
      local label = exports.rl_gui:createGuiElement("label", x + dashboardPadding[3], y, 0, 32, inside)
      exports.rl_gui:setLabelAlignment(label, "left", "center")
      exports.rl_gui:setLabelText(label, "0000")
      exports.rl_gui:setLabelFont(label, "22/BebasNeueBold.otf")
      colorSetTestLabel[label] = "hudwhite"
      local label = exports.rl_gui:createGuiElement("label", x + dashboardPadding[3] + exports.rl_gui:getLabelTextWidth(label), y, 0, 32, inside)
      exports.rl_gui:setLabelAlignment(label, "left", "center")
      exports.rl_gui:setLabelText(label, "100000 SSC")
      exports.rl_gui:setLabelFont(label, "22/BebasNeueBold.otf")
      colorSetTestLabel[label] = "v4yellow"
      y = y + 32
      y = y + dashboardPadding[3] * 3
      local rect = exports.rl_gui:createGuiElement("rectangle", x, y, 198 + dashboardPadding[3] * 2, 66 + dashboardPadding[3] * 2, inside)
      colorSetTestRect[rect] = "v4grey1"
      local item = exports.rl_gui:createGuiElement("image", x + dashboardPadding[3], y + dashboardPadding[3], 66, 66, inside)
      exports.rl_gui:setImageDDS(item, ":rl_hud/files/itemHover.dds")
      colorSetTestImg[item] = "v4green"
      local item = exports.rl_gui:createGuiElement("image", 15, 15, 36, 36, item)
      exports.rl_gui:setImageFile(item, ":rl_items/" .. exports.rl_items:getItemPic(174))
      local item = exports.rl_gui:createGuiElement("image", x + dashboardPadding[3] + 66, y + dashboardPadding[3], 66, 66, inside)
      exports.rl_gui:setImageDDS(item, ":rl_hud/files/itemHover.dds")
      colorSetTestImg[item] = "v4blue"
      local item = exports.rl_gui:createGuiElement("image", 15, 15, 36, 36, item)
      exports.rl_gui:setImageFile(item, ":rl_items/" .. exports.rl_items:getItemPic(174))
      local item = exports.rl_gui:createGuiElement("image", x + dashboardPadding[3] + 132, y + dashboardPadding[3], 66, 66, inside)
      exports.rl_gui:setImageDDS(item, ":rl_hud/files/itemHover.dds")
      colorSetTestImg[item] = "v4purple"
      local item = exports.rl_gui:createGuiElement("image", 15, 15, 36, 36, item)
      exports.rl_gui:setImageFile(item, ":rl_items/" .. exports.rl_items:getItemPic(174))
      y = y + 66 + dashboardPadding[3] * 3
      local rect = exports.rl_gui:createGuiElement("rectangle", x, y, 256 + dashboardPadding[3] * 2, 30 + dashboardPadding[3] * 2, inside)
      colorSetTestRect[rect] = "v4grey1"
      local btn = exports.rl_gui:createGuiElement("button", x + dashboardPadding[3], y + dashboardPadding[3], 256, 30, inside)
      exports.rl_gui:setButtonFont(btn, "15/BebasNeueRegular.otf")
      exports.rl_gui:setButtonIcon(btn, exports.rl_gui:getFaIconFilename("mug", 30))
      exports.rl_gui:setButtonTextColor(btn, "#000")
      exports.rl_gui:setButtonText(btn, " Sárga bögre, görbe bögre")
      colorSetTestBtn[btn] = "v4yellow"
      y = y + 30 + dashboardPadding[3] * 3
      local rect = exports.rl_gui:createGuiElement("rectangle", x, y, 256 + dashboardPadding[3] * 2, 30 + dashboardPadding[3] * 2, inside)
      colorSetTestRect[rect] = "v4grey1"
      local btn = exports.rl_gui:createGuiElement("button", x + dashboardPadding[3], y + dashboardPadding[3], 256, 30, inside)
      exports.rl_gui:setButtonFont(btn, "15/BebasNeueBold.otf")
      exports.rl_gui:setButtonIcon(btn, exports.rl_gui:getFaIconFilename("lemon", 30))
      exports.rl_gui:setButtonText(btn, " Narancssárga")
      colorSetTestBtn[btn] = "v4orange"
      y = y + 30 + dashboardPadding[3] * 3
      local rect = exports.rl_gui:createGuiElement("rectangle", x, y, 256 + dashboardPadding[3] * 2, 30 + dashboardPadding[3] * 2, inside)
      colorSetTestRect[rect] = "v4grey1"
      local btn = exports.rl_gui:createGuiElement("button", x + dashboardPadding[3], y + dashboardPadding[3], 256, 30, inside)
      exports.rl_gui:setButtonFont(btn, "15/BebasNeueBold.otf")
      exports.rl_gui:setButtonIcon(btn, exports.rl_gui:getFaIconFilename("seedling", 30))
      exports.rl_gui:setButtonText(btn, " Lila")
      colorSetTestBtn[btn] = "v4purple"
      y = y + 30 + dashboardPadding[3] * 3
      doColorsetTesters()
    elseif menus[currentMenu].settings[k][2] == "colorset" then
      local colorSet = exports.rl_gui:getColorSet()
      local colors = exports.rl_gui:getColorsForPreview(colorSet)
      colorSetTmp = colorSet
      colorSetRectangles = {}
      for k = 1, #colors do
        colorSetRectangles[k] = exports.rl_gui:createGuiElement("rectangle", x + (gs - 6) * (k - 1) + h, y + h / 2 - (gs - 6) / 2, gs - 6, gs - 6, inside)
        exports.rl_gui:setGuiBackground(colorSetRectangles[k], "solid", colors[k])
      end
      local btn = exports.rl_gui:createGuiElement("image", x - (32 - h) / 2, y - (32 - h) / 2, 32, 32, inside)
      exports.rl_gui:setImageFile(btn, exports.rl_gui:getFaIconFilename("caret-left", 32))
      exports.rl_gui:setGuiHoverable(btn, true)
      exports.rl_gui:setGuiHover(btn, "solid", "v4green")
      exports.rl_gui:setClickEvent(btn, "dashPreviusColorSet")
      local btn = exports.rl_gui:createGuiElement("image", x + (gs - 6) * #colors + h - (32 - h) / 2, y - (32 - h) / 2, 32, 32, inside)
      exports.rl_gui:setImageFile(btn, exports.rl_gui:getFaIconFilename("caret-right", 32))
      exports.rl_gui:setGuiHoverable(btn, true)
      exports.rl_gui:setGuiHover(btn, "solid", "v4green")
      exports.rl_gui:setClickEvent(btn, "dashNextColorSet")
      colorSetLabel = exports.rl_gui:createGuiElement("label", x + (gs - 6) * #colors + h * 2, y, 0, h, inside)
      exports.rl_gui:setLabelFont(colorSetLabel, "11/BebasNeueRegular.otf")
      exports.rl_gui:setLabelAlignment(colorSetLabel, "left", "center")
      exports.rl_gui:setLabelText(colorSetLabel, exports.rl_gui:getColorSetName(colorSet))
      local btn = exports.rl_gui:createGuiElement("button", 0, 0, 80, h, colorSetLabel)
      exports.rl_gui:setButtonFont(btn, "11/BebasNeueBold.otf")
      exports.rl_gui:setGuiBackground(btn, "solid", "v4green")
      exports.rl_gui:setGuiHover(btn, "gradient", {
        "v4green",
        "v4green-second"
      }, false, true)
      exports.rl_gui:setButtonIcon(btn, exports.rl_gui:getFaIconFilename("save", h))
      exports.rl_gui:setButtonText(btn, " Mentés")
      exports.rl_gui:setClickEvent(btn, "dashSaveColorSet")
      colorSetSave = btn
      exports.rl_gui:setGuiRenderDisabled(colorSetSave, true)
      y = y + h + dashboardPadding[3] * 2
    elseif menus[currentMenu].settings[k][2] == "toggle" then
      local toggle = exports.rl_gui:createGuiElement("toggle", x, y + h / 2 - (gs - 6) / 2, (gs - 6) * 2, gs - 6, inside)
      local val = menus[currentMenu].settings[k][3]()
      exports.rl_gui:setToggleState(toggle, val, true)
      exports.rl_gui:setClickEvent(toggle, "settingsToggleClick")
      exports.rl_gui:setToggleColor(toggle, "v4grey1", "v4red", "v4green")
      toggleDatas[toggle] = {
        menus[currentMenu].settings[k][4],
        k,
        menus[currentMenu].settings[k][5],
        menus[currentMenu].settings[k][6]
      }
      menus[currentMenu].elements[k] = toggle
      y = y + h + dashboardPadding[3] * 2
    else
      y = y + h + dashboardPadding[3] * 2
    end
    if y > sy then
      y = lastLine
      x = x + w + dashboardPadding[3] * 2 + gs * 4
    end
  end
  local movie = false
  for i = 1, #menus[currentMenu].settings do
    if menus[currentMenu].settings[i][2] == "toggle" then
      local el = menus[currentMenu].elements[i]
      local val = exports.rl_gui:getToggleState(el)
      if toggleDatas[el][3] then
        for k = toggleDatas[el][2] + 1, #menus[currentMenu].settings do
          if menus[currentMenu].settings[k][2] == "movieShaderPreset" then
            if val then
              movie = k
            end
            exports.rl_gui:setImageColor(menus[currentMenu].elements[k][1], val and "#ffffff" or "v4midgrey")
            exports.rl_gui:setImageColor(menus[currentMenu].elements[k][2], val and "#ffffff" or "v4midgrey")
            exports.rl_gui:setGuiHoverable(menus[currentMenu].elements[k][1], val)
            exports.rl_gui:setLabelColor(movieShaderPresetLabel, val and "#ffffff" or "v4midgrey")
            exports.rl_gui:setLabelColor(menus[currentMenu].labels[k], val and "#ffffff" or "v4midgrey")
          elseif menus[currentMenu].elements[k] then
            local el2 = menus[currentMenu].elements[k]
            exports.rl_gui:setElementDisabled(el2, not val)
            if sliderDatas[el2] then
              exports.rl_gui:setLabelColor(sliderDatas[el2][1], val and "#ffffff" or "v4midgrey")
            end
            exports.rl_gui:setLabelColor(menus[currentMenu].labels[k], val and "#ffffff" or "v4midgrey")
          else
            break
          end
        end
      end
    end
  end
  if movie then
    local val = exports.rl_shader:getCurrentMoviePreset() == 1
    for k = movie + 1, #menus[currentMenu].settings do
      if menus[currentMenu].elements[k] then
        local el2 = menus[currentMenu].elements[k]
        exports.rl_gui:setElementDisabled(el2, not val)
        if sliderDatas[el2] then
          exports.rl_gui:setLabelColor(sliderDatas[el2][1], val and "#ffffff" or "v4midgrey")
        end
        exports.rl_gui:setLabelColor(menus[currentMenu].labels[k], val and "#ffffff" or "v4midgrey")
      else
        break
      end
    end
  end
end
function setCurrentWalkingStyle(val)
  if not walkingStyles[val] then
    val = 1
  end
  currentWalkingStyle = val
  triggerServerEvent("refreshWalkingStyle", localPlayer, val)
end
function setCurrentFightingStyle(val)
  if not fightingStyles[val] then
    val = 1
  end
  currentFightStyle = val
  triggerServerEvent("refreshFightingStyle", localPlayer, val)
end
addEvent("dashChangeWalkStyle", true)
addEventHandler("dashChangeWalkStyle", getRootElement(), function(button, state, absoluteX, absoluteY, el, n)
  local val = currentWalkingStyle + n
  if val > #walkingStyles then
    val = 1
  elseif val < 1 then
    val = #walkingStyles
  end
  exports.rl_gui:setLabelText(walkingStyleLabel, walkingStyles[val][2])
  setCurrentWalkingStyle(val)
  saveValue("walkingStyle", val)
end)
addEvent("dashChangeFightStyle", true)
addEventHandler("dashChangeFightStyle", getRootElement(), function(button, state, absoluteX, absoluteY, el, n)
  local val = currentFightStyle + n
  if val > #fightingStyles then
    val = 1
  elseif val < 1 then
    val = #fightingStyles
  end
  exports.rl_gui:setLabelText(fightingStyleLabel, "Stílus #" .. val)
  setCurrentFightingStyle(val)
  saveValue("fightingStyle", val)
end)
addEvent("dashChangeChatAnim", true)
addEventHandler("dashChangeChatAnim", getRootElement(), function(button, state, absoluteX, absoluteY, el, n)
  local val = currentChatAnim + n
  if val > #chatAnims then
    val = 1
  elseif val < 1 then
    val = #chatAnims
  end
  currentChatAnim = val
  if val == #chatAnims then
    exports.rl_gui:setLabelText(chatAnimLabel, "Kikapcsolva")
  elseif val == #chatAnims - 1 then
    exports.rl_gui:setLabelText(chatAnimLabel, "Véletlenszerű")
  else
    exports.rl_gui:setLabelText(chatAnimLabel, "Animáció #" .. currentChatAnim)
  end
  saveValue("chatAnim", val)
end)
addEvent("dashNextMoviePreset", true)
addEventHandler("dashNextMoviePreset", getRootElement(), function()
  local preset = exports.rl_shader:getCurrentMoviePreset() + 1
  if preset > #movieShaderNames then
    preset = 1
  end
  setCurrentMoviePreset(preset)
  exports.rl_gui:setLabelText(movieShaderPresetLabel, movieShaderNames[preset])
  saveValue("moviePreset_v4", preset)
  if moviePresetLocation then
    local val = preset == 1
    for k = moviePresetLocation + 1, #menus[currentMenu].settings do
      if menus[currentMenu].elements[k] then
        local el2 = menus[currentMenu].elements[k]
        exports.rl_gui:setElementDisabled(el2, not val)
        if sliderDatas[el2] then
          exports.rl_gui:setLabelColor(sliderDatas[el2][1], val and "#ffffff" or "v4midgrey")
        end
        exports.rl_gui:setLabelColor(menus[currentMenu].labels[k], val and "#ffffff" or "v4midgrey")
      else
        break
      end
    end
  end
end)
addEvent("dashPreviusMoviePreset", true)
addEventHandler("dashPreviusMoviePreset", getRootElement(), function()
  local preset = exports.rl_shader:getCurrentMoviePreset() - 1
  if preset < 1 then
    preset = #movieShaderNames
  end
  setCurrentMoviePreset(preset)
  exports.rl_gui:setLabelText(movieShaderPresetLabel, movieShaderNames[preset])
  saveValue("moviePreset_v4", preset)
  if moviePresetLocation then
    local val = preset == 1
    for k = moviePresetLocation + 1, #menus[currentMenu].settings do
      if menus[currentMenu].elements[k] then
        local el2 = menus[currentMenu].elements[k]
        exports.rl_gui:setElementDisabled(el2, not val)
        if sliderDatas[el2] then
          exports.rl_gui:setLabelColor(sliderDatas[el2][1], val and "#ffffff" or "v4midgrey")
        end
        exports.rl_gui:setLabelColor(menus[currentMenu].labels[k], val and "#ffffff" or "v4midgrey")
      else
        break
      end
    end
  end
end)
function doColorsetTesters()
  local colors = exports.rl_gui:getColorsForPreviewEx(colorSetTmp)
  exports.rl_gui:setWindowColors(colorSetTestWindow, colors.v4grey2, colors.v4grey1, colors.v4grey3, "#ffffff")
  for img, col in pairs(colorSetTestImg) do
    exports.rl_gui:setImageColor(img, colors[col])
  end
  for rect, col in pairs(colorSetTestRect) do
    exports.rl_gui:setGuiBackground(rect, "solid", colors[col])
  end
  for btn, col in pairs(colorSetTestBtn) do
    exports.rl_gui:setGuiBackground(btn, "solid", colors[col])
    exports.rl_gui:setGuiHover(btn, "gradient", {
      colors[col],
      colors[col .. "-second"]
    }, false, true)
  end
  for btn, col in pairs(colorSetTestLabel) do
    exports.rl_gui:setLabelColor(btn, colors[col])
  end
end
addEvent("dashNextColorSet", true)
addEventHandler("dashNextColorSet", getRootElement(), function()
  local colorSet = colorSetTmp + 1
  if colorSet > exports.rl_gui:getColorSetsCount() then
    colorSet = 1
  end
  colorSetTmp = colorSet
  local colors = exports.rl_gui:getColorsForPreview(colorSet)
  for k = 1, #colors do
    exports.rl_gui:setGuiBackground(colorSetRectangles[k], "solid", colors[k])
  end
  exports.rl_gui:setLabelText(colorSetLabel, exports.rl_gui:getColorSetName(colorSet))
  exports.rl_gui:setGuiRenderDisabled(colorSetSave, false)
  exports.rl_gui:setGuiPosition(colorSetSave, exports.rl_gui:getLabelTextWidth(colorSetLabel) + 8)
  doColorsetTesters()
end)
addEvent("dashPreviusColorSet", true)
addEventHandler("dashPreviusColorSet", getRootElement(), function()
  local colorSet = colorSetTmp - 1
  if colorSet < 1 then
    colorSet = exports.rl_gui:getColorSetsCount()
  end
  colorSetTmp = colorSet
  local colors = exports.rl_gui:getColorsForPreview(colorSet)
  for k = 1, #colors do
    exports.rl_gui:setGuiBackground(colorSetRectangles[k], "solid", colors[k])
  end
  exports.rl_gui:setLabelText(colorSetLabel, exports.rl_gui:getColorSetName(colorSet))
  exports.rl_gui:setGuiRenderDisabled(colorSetSave, false)
  exports.rl_gui:setGuiPosition(colorSetSave, exports.rl_gui:getLabelTextWidth(colorSetLabel) + 8)
  doColorsetTesters()
end)
addEvent("dashSaveColorSet", true)
addEventHandler("dashSaveColorSet", getRootElement(), function()
  exports.rl_gui:setGuiRenderDisabled(colorSetSave, true)
  setColorSet(colorSetTmp)
  saveValue("colorSet", colorSetTmp)
  exports.rl_gui:showInfobox("w", "A megfelelő játékélmény érdekében színséma váltás után indítsd újra az MTA-t!")
  doColorsetTesters()
end)
addEvent("dashNextCrosshairColor", true)
addEventHandler("dashNextCrosshairColor", getRootElement(), function()
  local cData = exports.rl_crosshair:getCrosshair()
  if cData[1] > 0 then
    local currentColor = 1
    for i = 1, #crosshairColors do
      if crosshairColors[i] == cData[2] then
        currentColor = i
        break
      end
    end
    currentColor = currentColor + 1
    if currentColor > #crosshairColors then
      currentColor = 1
    end
    for i = 1, #crosshairImages do
      exports.rl_gui:setImageColor(crosshairImages[i], crosshairColors[currentColor])
    end
    cData[2] = crosshairColors[currentColor]
    exports.rl_crosshair:setCrosshair(cData)
    exports.rl_gui:setGuiBackground(crosshairColorRect, "solid", crosshairColors[currentColor])
    saveValue("crosshairColor", currentColor)
  end
end)
addEvent("dashPreviusCrosshairColor", true)
addEventHandler("dashPreviusCrosshairColor", getRootElement(), function()
  local cData = exports.rl_crosshair:getCrosshair()
  if cData[1] > 0 then
    local currentColor = 1
    for i = 1, #crosshairColors do
      if crosshairColors[i] == cData[2] then
        currentColor = i
        break
      end
    end
    currentColor = currentColor - 1
    if currentColor < 1 then
      currentColor = #crosshairColors
    end
    for i = 1, #crosshairImages do
      exports.rl_gui:setImageColor(crosshairImages[i], crosshairColors[currentColor])
    end
    cData[2] = crosshairColors[currentColor]
    exports.rl_crosshair:setCrosshair(cData)
    exports.rl_gui:setGuiBackground(crosshairColorRect, "solid", crosshairColors[currentColor])
    saveValue("crosshairColor", currentColor)
  end
end)
addEvent("dashNextCrosshair", true)
addEventHandler("dashNextCrosshair", getRootElement(), function()
  local cData = exports.rl_crosshair:getCrosshair()
  local crosshair = cData[1] + 1
  if 12 < crosshair then
    crosshair = 1
  end
  cData[1] = crosshair
  exports.rl_crosshair:setCrosshair(cData)
  for i = 1, #crosshairImages do
    exports.rl_gui:setImageDDS(crosshairImages[i], ":rl_crosshair/files/" .. crosshair .. ".dds")
    exports.rl_gui:setImageColor(crosshairImages[i], cData[2])
  end
  exports.rl_gui:setGuiBackground(crosshairColorRect, "solid", cData[2])
  saveValue("crosshair", crosshair)
end)
addEvent("dashPreviusCrosshair", true)
addEventHandler("dashPreviusCrosshair", getRootElement(), function()
  local cData = exports.rl_crosshair:getCrosshair()
  local crosshair = cData[1] - 1
  if crosshair < 1 then
    crosshair = 12
  end
  cData[1] = crosshair
  exports.rl_crosshair:setCrosshair(cData)
  for i = 1, #crosshairImages do
    exports.rl_gui:setImageDDS(crosshairImages[i], ":rl_crosshair/files/" .. crosshair .. ".dds")
    exports.rl_gui:setImageColor(crosshairImages[i], cData[2])
  end
  exports.rl_gui:setGuiBackground(crosshairColorRect, "solid", cData[2])
  saveValue("crosshair", crosshair)
end)
addEvent("settingsEnumClick", true)
addEventHandler("settingsEnumClick", getRootElement(), function(button, state, absoluteX, absoluteY, el)
  if enumDatas[el] and state == "down" then
    enumDatas[el][1](enumDatas[el][2])
    if enumDatas[el][4] then
      saveValue(enumDatas[el][4], enumDatas[el][2])
    end
    for i = 1, #enumButtons[enumDatas[el][3]] do
      local btn = enumButtons[enumDatas[el][3]][i][1]
      if enumDatas[el][2] == enumButtons[enumDatas[el][3]][i][2] then
        exports.rl_gui:setGuiBackground(btn, "solid", "v4green")
        exports.rl_gui:setGuiHover(btn, "gradient", {
          "v4green",
          "v4green-second"
        }, true)
      else
        exports.rl_gui:setGuiBackground(btn, "solid", "v4grey1")
        exports.rl_gui:setGuiHover(btn, "gradient", {"v4grey1", "v4grey2"}, true)
      end
    end
  end
end)
addEvent("settingsToggleClick", true)
addEventHandler("settingsToggleClick", getRootElement(), function(button, state, absoluteX, absoluteY, el)
  if toggleDatas[el] and state == "down" then
    local val = exports.rl_gui:getToggleState(el)
    if toggleDatas[el][1] then
      toggleDatas[el][1](val)
    end
    if toggleDatas[el][4] then
      saveValue(toggleDatas[el][4], val and 1 or 0)
    end
    if toggleDatas[el][3] then
      local movie = false
      for k = toggleDatas[el][2] + 1, #menus[currentMenu].settings do
        if menus[currentMenu].settings[k][2] == "movieShaderPreset" then
          if val then
            movie = k
          end
          exports.rl_gui:setImageColor(menus[currentMenu].elements[k][1], val and "#ffffff" or "v4midgrey")
          exports.rl_gui:setImageColor(menus[currentMenu].elements[k][2], val and "#ffffff" or "v4midgrey")
          exports.rl_gui:setGuiHoverable(menus[currentMenu].elements[k][1], val)
          exports.rl_gui:setLabelColor(movieShaderPresetLabel, val and "#ffffff" or "v4midgrey")
          exports.rl_gui:setLabelColor(menus[currentMenu].labels[k], val and "#ffffff" or "v4midgrey")
        elseif menus[currentMenu].elements[k] then
          local el2 = menus[currentMenu].elements[k]
          exports.rl_gui:setElementDisabled(el2, not val)
          if sliderDatas[el2] then
            exports.rl_gui:setLabelColor(sliderDatas[el2][1], val and "#ffffff" or "v4midgrey")
          end
          exports.rl_gui:setLabelColor(menus[currentMenu].labels[k], val and "#ffffff" or "v4midgrey")
        else
          break
        end
      end
      if movie then
        local val = exports.rl_shader:getCurrentMoviePreset() == 1
        for k = movie + 1, #menus[currentMenu].settings do
          if menus[currentMenu].elements[k] then
            local el2 = menus[currentMenu].elements[k]
            exports.rl_gui:setElementDisabled(el2, not val)
            if sliderDatas[el2] then
              exports.rl_gui:setLabelColor(sliderDatas[el2][1], val and "#ffffff" or "v4midgrey")
            end
            exports.rl_gui:setLabelColor(menus[currentMenu].labels[k], val and "#ffffff" or "v4midgrey")
          else
            break
          end
        end
      end
    end
  end
end)
addEvent("settingsSliderChange", true)
addEventHandler("settingsSliderChange", getRootElement(), function(el, sliderValue, final)
  if sliderDatas[el] then
    local val = sliderDatas[el][2] + sliderValue * (sliderDatas[el][3] - sliderDatas[el][2])
    exports.rl_gui:setLabelText(sliderDatas[el][1], math.floor(val + 0.5))
    if sliderDatas[el][4] then
      sliderDatas[el][4](val)
    end
    if final and sliderDatas[el][5] then
      saveValue(sliderDatas[el][5], val)
    end
  end
end)
function resetFogAndFarClip()
  resetFarClipDistance()
  resetFogDistance()
  if savedFarClip then
    setFarClipDistance(savedFarClip)
  elseif fileExists("!dashboard/farClipDistance.setting") then
    local fh = fileOpen("!dashboard/farClipDistance.setting")
    if fh then
      local val = fileRead(fh, fileGetSize(fh))
      if val then
        val = tonumber(val) or val
        setFarClipDistanceEx(val)
      end
      fileClose(fh)
    end
  end
  if savedFog then
    setFogDistance(savedFog)
  elseif fileExists("!dashboard/fogDistance.setting") then
    local fh = fileOpen("!dashboard/fogDistance.setting")
    if fh then
      local val = fileRead(fh, fileGetSize(fh))
      if val then
        val = tonumber(val) or val
        setFogDistanceEx(val)
      end
      fileClose(fh)
    end
  end
end
local streamerModePrompt = false
local streamerModeToggle = false
addEvent("streamerModePromptClose", false)
addEventHandler("streamerModePromptClose", getRootElement(), function()
  local val = exports.rl_gui:getToggleState(streamerModeToggle) or false
  setStreamerMode(val)
  saveValue("streamerMode", val and 1 or 0)
  showCursor(false)
  if streamerModePrompt then
    exports.rl_gui:deleteGuiElement(streamerModePrompt)
  end
  streamerModePrompt = nil
  streamerModeToggle = false
  seelangCondHandl0(false)
end)
addEvent("streamerModeToggleChange", false)
addEventHandler("streamerModeToggleChange", getRootElement(), function()
  local val = exports.rl_gui:getToggleState(streamerModeToggle) or false
  setStreamerMode(val)
  saveValue("streamerMode", val and 1 or 0)
end)
local lateSettings = {
  farClipDistance = true,
  fogDistance = true,
  vignetteState = true,
  vignetteLevel = true,
  moviePreset_v4 = true,
  movieShaderState_v4 = true,
  movieShaderHue_v4 = true,
  movieShaderBrightness_v4 = true,
  movieShaderContrast_v4 = true,
  movieShaderSaturation_v4 = true,
  movieShaderR_v4 = true,
  movieShaderG_v4 = true,
  movieShaderB_v4 = true,
  movieShaderL_v4 = true,
  movieShadernoise_v4 = true,
  dofState = true,
  carPaint = true,
  osws = true,
  roadShine = true,
  radialBlur = true,
  waterEffects = true,
  colorSet = true
}
local lateSettingValues = {}
function loadLateSettings()
  for i = 1, #lateSettingValues do
    lateSettingValues[i][1](lateSettingValues[i][2])
  end
  lateSettingValues = {}
end
function loadColorset()
  for i = #lateSettingValues, 1, -1 do
    if lateSettingValues[i][3] == "colorSet" then
      local res = lateSettingValues[i][1](lateSettingValues[i][2])
      table.remove(lateSettingValues, i)
      return res
    end
  end
end
function loadSettings()
  requestPlayerVehicleList()
  if fileExists("!rl_vehprev.sg") then
    local fh = fileOpen("!rl_vehprev.sg")
    if fh then
      local val = fileRead(fh, fileGetSize(fh))
      if val then
        if vehiclePreviewTexture then
          backgroundSizes[vehiclePreviewTexture] = nil
        end
        if isElement(vehiclePreviewTexture) then
          destroyElement(vehiclePreviewTexture)
        end
        local s = dxGetPixelsSize(val)
        vehiclePreviewTexture = dxCreateTexture(val)
        if isElement(vehiclePreviewTexture) then
          local i, j = vehsPosition[1], vehsPosition[2]
          dashboardLayout[i][j].background = vehiclePreviewTexture
          backgroundSizes[vehiclePreviewTexture] = {s, s}
          if dashboardState and dashboardLayout[i][j].images and dashboardLayout[i][j].images[1] then
            exports.rl_gui:setImageFile(dashboardLayout[i][j].images[1], vehiclePreviewTexture)
          end
          local u = 0
          local v = 0
          local us = s / dashboardLayout[i][j].originalSize[1]
          local vs = s / dashboardLayout[i][j].originalSize[2]
          if us < vs then
            u = s
            v = dashboardLayout[i][j].originalSize[2] * us
          else
            u = dashboardLayout[i][j].originalSize[1] * vs
            v = s
          end
          if dashboardState and dashboardLayout[i][j].images and dashboardLayout[i][j].images[1] then
            exports.rl_gui:setImageUV(dashboardLayout[i][j].images[1], (s - u) / 2, (s - v) / 2, u, v)
            exports.rl_gui:setGuiHoverable(dashboardLayout[i][j].images[1], true, 1000)
          end
        end
      end
      fileClose(fh)
    end
  end
  local streamerModeFound = false
  for i = 1, #menus do
    for j = 1, #menus[i].settings do
      local data = menus[i].settings[j]
      if data then
        local name = false
        local func = false
        if data[2] == "colorset" then
          func = setColorSet
          name = "colorSet"
        elseif data[2] == "crosshair" then
          func = setCrosshair
          name = "crosshair"
        elseif data[2] == "keyBind" then
          func = data[4]
          name = data[5]
        elseif data[2] == "crosshairColor" then
          func = setCrosshairColor
          name = "crosshairColor"
        elseif data[2] == "movieShaderPreset" then
          func = setCurrentMoviePreset
          name = "moviePreset_v4"
        elseif data[2] == "walkingStyle" then
          func = setCurrentWalkingStyle
          name = "walkingStyle"
        elseif data[2] == "fightingStyle" then
          func = setCurrentFightingStyle
          name = "fightingStyle"
        elseif data[2] == "chatAnim" then
          func = setCurrentChatAnim
          name = "chatAnim"
        elseif data[2] == "toggle" then
          func = data[4]
          name = data[6]
        elseif data[2] == "enum" or data[2] == "enumNameFont" then
          func = data[5]
          name = data[6]
        elseif data[2] == "slider" then
          func = data[6]
          name = data[7]
        end
        if name and func and fileExists("!dashboard/" .. name .. ".setting") then
          local fh = fileOpen("!dashboard/" .. name .. ".setting")
          if fh then
            local val = fileRead(fh, fileGetSize(fh))
            if val then
              val = tonumber(val) or val
              if name == "streamerMode" then
                streamerModeFound = true
              end
              if data[2] == "keyBind" then
                val = tostring(val)
                if val == "false" then
                  val = false
                end
                if lateSettings[name] then
                  table.insert(lateSettingValues, {
                    func,
                    val,
                    name
                  })
                else
                  func(val)
                end
              elseif data[2] == "toggle" then
                if lateSettings[name] then
                  table.insert(lateSettingValues, {
                    func,
                    val == 1,
                    name
                  })
                else
                  func(val == 1)
                end
              elseif lateSettings[name] then
                table.insert(lateSettingValues, {
                  func,
                  val,
                  name
                })
              else
                func(val)
              end
            end
            fileClose(fh)
          end
        end
      end
    end
  end
  if not streamerModeFound then
    if streamerModePrompt then
      exports.rl_gui:deleteGuiElement(streamerModePrompt)
    end
    streamerModePrompt = nil
    seelangCondHandl0(true)
    local pw = 550
    local fh1 = exports.rl_gui:getFontHeight("11/Ubuntu-R.ttf")
    local fh2 = exports.rl_gui:getFontHeight("11/Ubuntu-L.ttf")
    local titleBarHeight = exports.rl_gui:getTitleBarHeight()
    local ph = titleBarHeight + fh2 * 2 + fh1 * 2 + 36
    showCursor(true)
    streamerModePrompt = exports.rl_gui:createGuiElement("window", screenX / 2 - pw / 2, screenY / 2 - ph / 2, pw, ph)
    exports.rl_gui:setWindowTitle(streamerModePrompt, "16/BebasNeueRegular.otf", "Streamer mód")
    exports.rl_gui:setWindowCloseButton(streamerModePrompt, "streamerModePromptClose")
    local y = titleBarHeight + 6
    local label = exports.rl_gui:createGuiElement("label", 0, y, pw, fh1, streamerModePrompt)
    exports.rl_gui:setLabelAlignment(label, "center", "center")
    exports.rl_gui:setLabelFont(label, "11/Ubuntu-R.ttf")
    exports.rl_gui:setLabelText(label, "Szeretnéd bekapcsolni a streamer módot?")
    y = y + fh1 + 12
    local w = fh1 * 2 + 6 + exports.rl_gui:getTextWidthFont(" Streamer mód", "11/Ubuntu-R.ttf")
    local label = exports.rl_gui:createGuiElement("label", pw / 2 - w / 2 + fh1 * 2 + 6, y, pw, fh1, streamerModePrompt)
    exports.rl_gui:setLabelAlignment(label, "left", "center")
    exports.rl_gui:setLabelFont(label, "11/Ubuntu-R.ttf")
    exports.rl_gui:setLabelText(label, " Streamer mód")
    streamerModeToggle = exports.rl_gui:createGuiElement("toggle", pw / 2 - w / 2, y, fh1 * 2, fh1, streamerModePrompt)
    exports.rl_gui:setToggleState(streamerModeToggle, val, true)
    exports.rl_gui:setClickEvent(streamerModeToggle, "streamerModeToggleChange")
    exports.rl_gui:setToggleColor(streamerModeToggle, "v4grey1", "v4red", "v4green")
    y = y + fh1 + 12
    local label = exports.rl_gui:createGuiElement("label", 0, y, pw, fh2 * 2, streamerModePrompt)
    exports.rl_gui:setLabelAlignment(label, "center", "center")
    exports.rl_gui:setLabelFont(label, "11/Ubuntu-L.ttf")
    exports.rl_gui:setLabelText(label, "Streamer módban az összes jogvédett zene lenémításra kerül.\nKésőbb ezt a beállítást megváltoztathatod a dashboardban (HOME gomb).")
  end
  setTimer(triggerEvent, 500, 1, "extraLoaderDone", localPlayer, "loadDashSettings")
end
function streamerModePromptToFront()
  exports.rl_gui:guiToFront(streamerModePrompt)
end
addEventHandler("onClientResourceStart", getResourceRootElement(), function(res)
  if getElementData(localPlayer, "logged") then
    loadSettings()
    loadLateSettings()
  end
end)
addEventHandler("onClientResourceStart", getRootElement(), function(res)
  if getResourceName(res) == "rl_gui" or source == getResourceRootElement() then
    local resource = getResourceFromName("rl_gui")
    if resource and getResourceState(resource) == "running" then
      buttonsWidth = 0
      fontSize = math.max(13, bebasSize - 10)
      buttonsHeight = exports.rl_gui:getFontHeight(fontSize .. "/BebasNeueRegular.otf") + dashboardPadding[3] * 4
      for k = 1, #menus do
        local w = exports.rl_gui:getTextWidthFont(menus[k].name, fontSize .. "/BebasNeueRegular.otf")
        if w > buttonsWidth then
          buttonsWidth = w
        end
      end
      buttonsWidth = buttonsWidth + dashboardPadding[3] * 8
      exports.rl_gui:cacheGradient(buttonsWidth, buttonsHeight, {
        "v4green-second",
        "v4green"
      })
      exports.rl_gui:cacheGradient(buttonsWidth, buttonsHeight, {"v4grey2", "v4grey1"})
      exports.rl_gui:cacheGradient(100, 20, {
        "v4green",
        "v4green-second"
      })
      exports.rl_gui:cacheGradient(100, 20, {"v4grey1", "v4grey2"})
    end
  end
end)
function settingsInsideDraw(x, y, isx, isy, i, j, irtg)
  rtg = irtg
  sx, sy = isx, isy
  local rect = exports.rl_gui:createGuiElement("rectangle", x + buttonsWidth, y, sx - buttonsWidth, sy, rtg)
  exports.rl_gui:setGuiBackground(rect, "solid", "v4grey2")
  for k = 1, #menus do
    menus[k].button = exports.rl_gui:createGuiElement("button", x, y, buttonsWidth, buttonsHeight, rtg)
    if currentMenu == k then
      exports.rl_gui:setGuiBackground(menus[k].button, "solid", "v4green")
      exports.rl_gui:setGuiHover(menus[k].button, "gradient", {
        "v4green-second",
        "v4green"
      }, true)
    else
      exports.rl_gui:setGuiBackground(menus[k].button, "solid", "v4grey1")
      exports.rl_gui:setGuiHover(menus[k].button, "gradient", {"v4grey2", "v4grey1"}, true)
    end
    exports.rl_gui:setButtonFont(menus[k].button, fontSize .. "/BebasNeueRegular.otf")
    exports.rl_gui:setButtonTextColor(menus[k].button, "#ffffff")
    exports.rl_gui:setButtonText(menus[k].button, menus[k].name)
    exports.rl_gui:setButtonTextAlign(menus[k].button, "left", "center")
    exports.rl_gui:setButtonTextPadding(menus[k].button, dashboardPadding[3] * 4, dashboardPadding[3] * 2)
    exports.rl_gui:setClickEvent(menus[k].button, "settingsMenuClick", false)
    y = y + buttonsHeight
  end
  sx = sx - dashboardPadding[3] * 8
  sy = sy - dashboardPadding[3] * 8
  drawSettingsMenu()
end
addEvent("settingsMenuClick", true)
addEventHandler("settingsMenuClick", getRootElement(), function(button, state, absoluteX, absoluteY, el)
  for k = 1, #menus do
    if el == menus[k].button then
      currentMenu = k
      exports.rl_gui:setGuiBackground(menus[k].button, "solid", "v4green")
      exports.rl_gui:setGuiHover(menus[k].button, "gradient", {
        "v4green-second",
        "v4green"
      }, true)
    else
      exports.rl_gui:setGuiBackground(menus[k].button, "solid", "v4grey1")
      exports.rl_gui:setGuiHover(menus[k].button, "gradient", {"v4grey2", "v4grey1"}, true)
    end
  end
  drawSettingsMenu()
end)
