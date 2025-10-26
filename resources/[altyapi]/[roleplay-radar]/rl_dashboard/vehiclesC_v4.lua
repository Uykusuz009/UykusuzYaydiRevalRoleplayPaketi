local seexports = {
  rl_gui = false,
  rl_vehiclenames = false,
  rl_markers = false,
  rl_vehicles = false,
  rl_spinner = false,
  rl_custompj = false,
  rl_paintjob = false
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
    seelangStaticImage[0] = dxCreateTexture("files/fado.dds", "argb", true)
  end
  if not seelangStatImgHand then
    seelangStatImgHand = true
    addEventHandler("onClientPreRender", getRootElement(), seelangStatImgPre, true, "high+999999999")
  end
end
requestedVehiclePreview = false
local screenX, screenY = guiGetScreenSize()
buyingVehicleSlot = false
sellingVehicle = false
local sellWindow = false
local sellToPlayers = false
local buyingRect = false
local buyingLabel = false
local buyingWindow = false
local vehiclesOpened = false
local currentAmount = 0
local fonts = false
if screenX < 1366 then
  fonts = {
    "30/BebasNeueRegular.otf",
    "16/BebasNeueRegular.otf",
    "15/BebasNeueBold.otf",
    "9/Ubuntu-R.ttf",
    "9/Ubuntu-R.ttf"
  }
elseif 1600 < screenX then
  fonts = {
    "50/BebasNeueRegular.otf",
    "19/BebasNeueRegular.otf",
    "18/BebasNeueBold.otf",
    "12/Ubuntu-R.ttf",
    "11/Ubuntu-R.ttf"
  }
else
  fonts = {
    "40/BebasNeueRegular.otf",
    "17/BebasNeueRegular.otf",
    "17/BebasNeueBold.otf",
    "11/Ubuntu-R.ttf",
    "10/Ubuntu-R.ttf"
  }
end
local rtg = false
local sx, sy = 0, 0
local menuW = 0
local vehSrc = false
local previewTextSaved = false
local bottomLabel = false
local scrollbar = false
local noVehiclesBg = false
local noVehicles = false
local loaderIcon = false
local loaderBcg = false
local vehImg = false
local selectedVehicle = 1
local vehOffset = 0
local sideMenu = {}
vehicleList = false
vehLimit = 0
vehicleNum = 0
function requestPlayerVehicleList()
  vehicleList = false
end
function sortVehicleDashboardList(a, b)
  return a.dashboardSort < b.dashboardSort
end
function saveVehicleSort()
  if fileExists("!rl_vehsort.sg") then
    fileDelete("!rl_vehsort.sg")
  end
  local f = fileCreate("!rl_vehsort.sg")
  if f then
    for i = 1, #vehicleList do
      if vehicleList[i] and vehicleList[i].vehicleId then
        fileWrite(f, vehicleList[i].vehicleId .. "\n")
      end
    end
    fileClose(f)
  end
end


addEvent("gotPlayerVehicleList", true)
addEventHandler("gotPlayerVehicleList", getRootElement(), function(list, limit)
  vehicleList = list
  local n = math.max(0, #vehicleList - 9)
  if n < vehOffset then
    vehOffset = n
  end
  vehicleNum = #list
  if vehicleNumLabel and dashboardState then
    seexports.rl_gui:setLabelText(vehicleNumLabel, vehicleNum)
  end
  vehLimit = limit
  if vehicleLimitLabel and dashboardState then
    seexports.rl_gui:setLabelText(vehicleLimitLabel, vehLimit)
  end
  local maxSort = 0
  local refresh = false
  local sortList = {}
  if fileExists("!rl_vehsort.sg") then
    local f = fileOpen("!rl_vehsort.sg")
    if f then
      local data = fileRead(f, fileGetSize(f))
      data = split(data, "\n")
      for i = 1, #data do
        if tonumber(data[i]) then
          sortList[tonumber(data[i])] = i
          maxSort = i
        end
      end
      data = nil
      fileClose(f)
    end
  end
  for i = 1, #vehicleList do
    if vehicleList[i] and vehicleList[i].vehicleId then
      if sortList[vehicleList[i].vehicleId] then
        vehicleList[i].dashboardSort = sortList[vehicleList[i].vehicleId]
      else
        maxSort = maxSort + 1
        vehicleList[i].dashboardSort = maxSort
        refresh = true
      end
      vehicleList[i].name = seexports.rl_vehiclenames:getCustomVehicleName(vehicleList[i].model)
    end
  end
  sortList = nil
  collectgarbage("collect")
  table.sort(vehicleList, sortVehicleDashboardList)
  if refresh then
    saveVehicleSort()
  end
  if not vehicleList[selectedVehicle] then
    selectedVehicle = 1
  end
  if vehiclesOpened then
    processVehicleSideMenu()
    if vehImg and vehicleList[selectedVehicle] then
      requestPreviewVehicle(vehicleList[selectedVehicle].vehicleId)
    else
    end
  end
  refreshVehiclesBottomLabel()
end)
function drawVehiclesInside(x, y, isx, isy, i, j, irtg)
  vehiclesOpened = true
  if not isElement(vehSrc) then
    vehSrc = dxCreateRenderTarget(screenX, screenY, true)
  end
  rtg = irtg
  sx, sy = isx, isy
  addEventHandler("onClientKey", getRootElement(), vehiclesScrollKey)
  drawTheVehicles()
end
local layerMoved = false
local layerMoveStart = false
local layerMoveStartSort = false
function swap(array, index1, index2)
  array[index1], array[index2] = array[index2], array[index1]
end
function layerMoveCursorMove()
  local cx, cy = getCursorPosition()
  if cx and layerMoved and rtg then
    cx = cx * screenX
    cy = cy * screenY
    local y = seexports.rl_gui:getGuiRealPosition(rtg, "y")
    local h = sy / 9
    local i = math.min(9, math.max(1, math.ceil((cy - y) / h))) + vehOffset
    if i ~= layerMoved and vehicleList[i] then
      local tmp = vehicleList[layerMoved]
      table.remove(vehicleList, layerMoved)
      if selectedVehicle == layerMoved then
        selectedVehicle = i
      end
      layerMoved = i
      table.insert(vehicleList, i, tmp)
      processVehicleSideMenu()
    end
    seexports.rl_gui:setGuiPosition(sideMenu[layerMoved - vehOffset][1], false, cy - h / 2, true)
    seexports.rl_gui:guiToFront(sideMenu[layerMoved - vehOffset][1])
  end
end
function layerMoveClick(btn, state)
  if state == "up" then
    if layerMoved then
      if layerMoved ~= layerMoveStart then
        saveVehicleSort()
      end
      layerMoved = false
      processVehicleSideMenu()
    end
    removeEventHandler("onClientClick", getRootElement(), layerMoveClick)
    removeEventHandler("onClientCursorMove", getRootElement(), layerMoveCursorMove)
  end
end
addEvent("selectVehicleClick", true)
addEventHandler("selectVehicleClick", getRootElement(), function(button, state, absoluteX, absoluteY, el)
  if not requestedVehiclePreview and vehicleList and not layerSorting then
    for i = 1, 9 do
      if sideMenu[i][1] == el then
        if selectedVehicle ~= i + vehOffset then
          selectedVehicle = i + vehOffset
          if vehImg and vehicleList[selectedVehicle] then
            requestPreviewVehicle(vehicleList[selectedVehicle].vehicleId)
          end
          processVehicleSideMenu()
        end
        if not layerMoved then
          addEventHandler("onClientClick", getRootElement(), layerMoveClick)
          addEventHandler("onClientCursorMove", getRootElement(), layerMoveCursorMove)
        end
        if vehicleList[i + vehOffset] then
          layerMoved = i + vehOffset
          layerMoveStart = i + vehOffset
          layerMoveStartSort = vehicleList[i + vehOffset].dashboardSort
        end
        return
      end
    end
  end
end)
local carSellBtn = false
local carGPSBtn = false
local carTitle = false
local dataLabels = {}
local tuningLevels = {
  "[color=v4green]profi",
  "[color=v4yellow]verseny",
  "[color=v4blue]venom"
}
local absLevels = {
  "Gyenge",
  "Normál",
  "Erős"
}
absLevels[0] = "Nincs"
function getVehLabelValue(datas, name)
  if name == "plate" then
    local plate = datas.plate or ""
    local tmp = {}
    plate = split(plate, "-")
    for i = 1, #plate do
      if 1 <= utf8.len(plate[i]) then
        table.insert(tmp, plate[i])
      end
    end
    return "[color=v4green]" .. table.concat(tmp, "-")
  elseif name == "abs" then
    if datas.abs then
      return "[color=v4green]" .. absLevels[datas.abs]
    else
      return "[color=v4red]nincs"
    end
  elseif name == "inService" then
    local inService = tonumber(datas.inService)
    if inService then
      local now = wardis math.floor(getRealTimestamp() / 60)
      local delta = math.max(0, inService - now)
      if 0 < delta then
        local hours = math.floor(delta / 60)
        local minutes = math.floor(delta - hours * 60)
        local time = ""
        if 0 < hours then
          time = hours .. " óra"
        end
        if 0 < minutes then
          time = time .. " " .. minutes .. " perc"
        end
        return "[color=v4blue]" .. time
      else
        return "[color=v4green]átvehető"
      end
    else
      return "[color=v4lightgrey]nincs szervizben"
    end
  elseif name == "impounded" then
    local imp = tonumber(datas.impounded)
    if imp == 1 then
      return "[color=v4red]PF"
    elseif imp == 2 then
      return "[color=v4red]PD"
    elseif imp == 3 then
      return "[color=v4orange]átállás"
    else
      return "[color=v4lightgrey]nem"
    end
  elseif name == "odometer" then
    return "[color=v4green]" .. seexports.rl_gui:thousandsStepper(math.floor(tonumber(datas.odometer) or 0)) .. " km"
  elseif name == "id" then
    return "[color=v4green]" .. datas.vehicleId
  elseif name == "engine" then
    if datas.engine == 2 then
      return "[color=v4green]beindítva"
    elseif datas.engine == 1 then
      return "[color=v4yellow]gyújtás"
    else
      return "[color=v4lightgrey]leállítva"
    end
  elseif name == "battery" then
    local charge = math.floor((tonumber(datas.batteryCharge) or 0) * 100)
    local rate = math.floor((tonumber(datas.batteryRate) or 0) * 1000 + 0.5) / 10
    local text = ""
    if charge < 40 then
      text = text .. "[color=v4red]" .. charge .. "%"
    elseif charge < 60 then
      text = text .. "[color=v4orange]" .. charge .. "%"
    elseif charge < 80 then
      text = text .. "[color=v4yellow]" .. charge .. "%"
    else
      text = text .. "[color=v4green]" .. charge .. "%"
    end
    text = text .. "#ffffff"
    if rate == 0 then
      text = text .. " (0% / perc)"
    elseif 0 < rate then
      text = text .. " ([color=v4green]+" .. rate .. "% / perc#ffffff)"
    else
      text = text .. " ([color=v4red]" .. rate .. "% / perc#ffffff)"
    end
    return text
  elseif name == "fuel" then
    local text = datas.fuelType == "diesel" and "[color=v4lightgrey]dízel" or "[color=v4green]benzin"
    text = text .. "#ffffff (" .. math.floor(tonumber(datas.fuelLevel) or 0) .. "L / " .. math.floor(tonumber(datas.tankSize) or 0) .. "L)"
    return text
  elseif name == "driveType" then
    return "[color=v4green]" .. datas.driveType
  elseif name == "performance.engine" then
    return tuningLevels[datas["performance.engine"]] or "[color=v4lightgrey]gyári"
  elseif name == "performance.turbo" then
    if datas["performance.turbo"] == 5 then
      return "[color=v4purple]egyedi venom"
    elseif datas["performance.turbo"] == 4 then
      return "[color=v4purple]SuperCharger"
    else
      return tuningLevels[datas["performance.turbo"]] or "[color=v4lightgrey]gyári"
    end
  elseif name == "performance.ecu" then
    if datas["performance.ecu"] == 4 then
      return "[color=v4purple]állítható venom"
    else
      return tuningLevels[datas["performance.ecu"]] or "[color=v4lightgrey]gyári"
    end
  elseif name == "performance.transmission" then
    return tuningLevels[datas["performance.transmission"]] or "[color=v4lightgrey]gyári"
  elseif name == "performance.suspension" then
    return tuningLevels[datas["performance.suspension"]] or "[color=v4lightgrey]gyári"
  elseif name == "performance.brake" then
    return tuningLevels[datas["performance.brake"]] or "[color=v4lightgrey]gyári"
  elseif name == "performance.tire" then
    return tuningLevels[datas["performance.tire"]] or "[color=v4lightgrey]gyári"
  elseif name == "performance.weightReduction" then
    return tuningLevels[datas["performance.weightReduction"]] or "[color=v4lightgrey]gyári"
  elseif name == "backfire" then
    if datas.backfire == 2 then
      return "[color=v4purple]egyedi"
    elseif datas.backfire == 1 then
      return "[color=v4blue]normál"
    else
      return "[color=v4lightgrey]nincs"
    end
  elseif name == "rideTuning" then
    if datas.rideTuning == 5 then
      return "[color=v4purple]AirRide"
    elseif tonumber(datas.rideTuning) then
      return "[color=v4blue]ültetőrugó " .. datas.rideTuning
    else
      return "[color=v4lightgrey]gyári"
    end
  elseif name == "paintjob" then
    if datas.customPaintjob then
      return "[color=v4purple]egyedi"
    elseif datas.paintjob then
      return "[color=v4blue]normál"
    else
      return "[color=v4lightgrey]nincs"
    end
  elseif name == "wheelPaintjob" then
    return datas.wheelPaintjob and "[color=v4blue]van" or "[color=v4lightgrey]nincs"
  elseif name == "headlightPaintjob" then
    return datas.headlightPaintjob and "[color=v4blue]van" or "[color=v4lightgrey]nincs"
  elseif name == "lsdDoor" then
    return datas.lsdDoor and "[color=v4blue]van" or "[color=v4lightgrey]nincs"
  elseif name == "nitro" then
    if datas.nosFillType then
      if 0 < datas.nosLevel then
        if datas.nosFillType == 2 then
          return "[color=v4purple]van, venom töltet (" .. datas.nosLevel .. "/4)"
        else
          return "[color=v4blue]van, normál töltet (" .. datas.nosLevel .. "/4)"
        end
      else
        return "[color=v4green]van, üres"
      end
    else
      return "[color=v4lightgrey]nincs"
    end
  elseif name == "spinner" then
    return datas.spinner and "[color=v4blue]van" or "[color=v4lightgrey]nincs"
  elseif name == "protected" then
    if datas.protected then
      local time = getRealTime(datas.protected)
      return "[color=v4blue]" .. string.format("%04d. %02d. %02d. %02d:%02d", time.year + 1900, time.month + 1, time.monthday, time.hour, time.minute)
    end
    return "[color=v4lightgrey]nem"
  end
  return name
end
local vehicleLabelLayout = {
  {
    "Általános adatok:"
  },
  {"Rendszám:", "plate"},
  {
    "Kilóméteróra állása:",
    "odometer"
  },
  {
    "Alvázszám (ID):",
    "id"
  },
  {"Protect:", "protected"},
  {
    "Lefoglalva:",
    "impounded"
  },
  {
    "Motor szerviz:",
    "inService"
  },
  {
    "Motor/hajtáslánc:"
  },
  {
    "Üzemanyag:",
    "fuel"
  },
  {
    "Meghajtás:",
    "driveType"
  },
  {
    "Teljesítmény tuning:"
  },
  {
    "Motor:",
    "performance.engine"
  },
  {
    "Turbo:",
    "performance.turbo"
  },
  {
    "ECU:",
    "performance.ecu"
  },
  {
    "Váltó:",
    "performance.transmission"
  },
  {
    "Felfüggesztés:",
    "performance.suspension"
  },
  {
    "Fék:",
    "performance.brake"
  },
  {
    "Gumi:",
    "performance.tire"
  },
  {
    "Súlycsökkentés:",
    "performance.weightReduction"
  },
  {"Extrák:"},
  {"Backfire:", "backfire"},
  {
    "Hasmagasság:",
    "rideTuning"
  },
  {"Paintjob:", "paintjob"},
  {
    "Felni paintjob:",
    "wheelPaintjob"
  },
  {
    "Lámpa paintjob:",
    "headlightPaintjob"
  },
  {"LSD ajtó:", "lsdDoor"},
  {"Nitro:", "nitro"},
  {"Spinner:", "spinner"},
  {"ABS:", "abs"}
}
addEvent("startVehicleSelling", false)
addEventHandler("startVehicleSelling", getRootElement(), function()
  if not sellingVehicle then
    triggerServerEvent("canStartVehicleSelling", localPlayer, vehicleList[selectedVehicle].vehicleId)
  end
end)
addEvent("markVehicleOnGPS", false)
addEventHandler("markVehicleOnGPS", getRootElement(), function()
  triggerServerEvent("markVehicleOnGPS", localPlayer, vehicleList[selectedVehicle].vehicleId)
end)
local gpsMarkBlip = false
local gpsVehicle = false
addEventHandler("onClientPlayerVehicleEnter", localPlayer, function(veh)
  if veh == gpsVehicle then
    if isElement(gpsMarkBlip) then
      destroyElement(gpsMarkBlip)
    end
    gpsMarkBlip = false
    gpsVehicle = false
    seexports.rl_markers:setMarkedVehicle(gpsVehicle)
  end
end)
addEventHandler("onClientElementDestroy", getRootElement(), function()
  if source == gpsVehicle then
    if isElement(gpsMarkBlip) then
      destroyElement(gpsMarkBlip)
    end
    gpsMarkBlip = false
    gpsVehicle = false
    seexports.rl_markers:setMarkedVehicle(gpsVehicle)
  end
end)
addEvent("gotVehicleGPSMark", true)
addEventHandler("gotVehicleGPSMark", getRootElement(), function(veh)
  if isElement(gpsMarkBlip) then
    destroyElement(gpsMarkBlip)
  end
  gpsMarkBlip = false
  gpsVehicle = false
  if isElement(veh) then
    gpsVehicle = veh
    local r, g, b = unpack(seexports.rl_gui:getColorCode("v4green"))
    gpsMarkBlip = createBlipAttachedTo(veh, 1, 2, r, g, b)
    seexports.rl_gui:showInfobox("i", "A jármű megjelölésre került a térképen! (Zöld jármű ikon)")
  end
  seexports.rl_markers:setMarkedVehicle(gpsVehicle)
end)
addEvent("endVehicleSellingDashboardWindow", true)
addEventHandler("endVehicleSellingDashboardWindow", getRootElement(), function()
  if sellingVehicle then
    seexports.rl_gui:deleteGuiElement(sellingVehicle)
  end
  sellingVehicle = false
  if sellWindow then
    seexports.rl_gui:deleteGuiElement(sellWindow)
  end
  sellWindow = false
  sellInput = false
  sellToPlayers = false
end)
addEvent("finalSellVehicle", false)
addEventHandler("finalSellVehicle", getRootElement(), function()
  if isElement(sellToPlayers) then
    local price = tonumber(seexports.rl_gui:getInputValue(sellInput)) or 0
    if 0 < price then
      local px, py, pz = getElementPosition(localPlayer)
      local x, y, z = getElementPosition(sellToPlayers)
      if getDistanceBetweenPoints3D(x, y, z, px, py, pz) > 5 then
        seexports.rl_gui:showInfobox("e", "A kiválasztott játékos túl távol van tőled.")
      else
        triggerServerEvent("tryToSellVehicleToPlayer", localPlayer, vehicleList[selectedVehicle].vehicleId, sellToPlayers, price)
        if sellWindow then
          seexports.rl_gui:deleteGuiElement(sellWindow)
        end
        sellWindow = false
        return
      end
    else
      seexports.rl_gui:showInfobox("e", "A minimum eladási ár 1$.")
      return
    end
  end
  if sellingVehicle then
    seexports.rl_gui:deleteGuiElement(sellingVehicle)
  end
  sellingVehicle = false
  if sellWindow then
    seexports.rl_gui:deleteGuiElement(sellWindow)
  end
  sellWindow = false
  sellInput = false
  sellToPlayers = false
end)
addEvent("selectSellVehicleToPlayer", false)
addEventHandler("selectSellVehicleToPlayer", getRootElement(), function(button, state, absoluteX, absoluteY, el)
  if sellToPlayers[el] then
    sellToPlayers = sellToPlayers[el]
    if sellWindow then
      seexports.rl_gui:deleteGuiElement(sellWindow)
    end
    local titleBarHeight = seexports.rl_gui:getTitleBarHeight()
    local panelWidth = 325
    local panelHeight = titleBarHeight + 105 + 5
    sellWindow = seexports.rl_gui:createGuiElement("window", screenX / 2 - panelWidth / 2, screenY / 2 - panelHeight / 2, panelWidth, panelHeight)
    seexports.rl_gui:setWindowTitle(sellWindow, "16/BebasNeueRegular.otf", "Jármű eladás - Eladási ár")
    sellInput = seexports.rl_gui:createGuiElement("input", 5, titleBarHeight + 5, panelWidth - 10, 30, sellWindow)
    seexports.rl_gui:setInputFont(sellInput, "11/Ubuntu-R.ttf")
    seexports.rl_gui:setInputIcon(sellInput, "coins")
    seexports.rl_gui:setInputPlaceholder(sellInput, "Eladási ár")
    seexports.rl_gui:setInputMaxLength(sellInput, 20)
    seexports.rl_gui:setInputNumberOnly(sellInput, true)
    local btn = seexports.rl_gui:createGuiElement("button", 5, panelHeight - 70, panelWidth - 10, 30, sellWindow)
    seexports.rl_gui:setGuiBackground(btn, "solid", "v4green")
    seexports.rl_gui:setGuiHover(btn, "gradient", {
      "v4green",
      "v4green-second"
    }, false, true)
    seexports.rl_gui:setButtonFont(btn, "15/BebasNeueBold.otf")
    seexports.rl_gui:setButtonTextColor(btn, "#ffffff")
    seexports.rl_gui:setButtonText(btn, "Eladás")
    seexports.rl_gui:setClickEvent(btn, "finalSellVehicle")
    local btn = seexports.rl_gui:createGuiElement("button", 5, panelHeight - 30 - 5, panelWidth - 10, 30, sellWindow)
    seexports.rl_gui:setGuiBackground(btn, "solid", "v4red")
    seexports.rl_gui:setGuiHover(btn, "gradient", {
      "v4red",
      "v4red-second"
    }, false, true)
    seexports.rl_gui:setButtonFont(btn, "15/BebasNeueBold.otf")
    seexports.rl_gui:setButtonTextColor(btn, "#ffffff")
    seexports.rl_gui:setButtonText(btn, "Mégsem")
    seexports.rl_gui:setClickEvent(btn, "endVehicleSellingDashboardWindow")
  end
end)
addEvent("canStartVehicleSelling", true)
addEventHandler("canStartVehicleSelling", getRootElement(), function()
  if sellingVehicle then
    seexports.rl_gui:deleteGuiElement(sellingVehicle)
  end
  if sellWindow then
    seexports.rl_gui:deleteGuiElement(sellWindow)
  end
  sellingVehicle = seexports.rl_gui:createGuiElement("rectangle", 0, 0, screenX, screenY)
  seexports.rl_gui:setGuiBackground(sellingVehicle, "solid", {
    0,
    0,
    0,
    150
  })
  seexports.rl_gui:setGuiHover(sellingVehicle, "none")
  seexports.rl_gui:setGuiHoverable(sellingVehicle, true)
  seexports.rl_gui:disableClickTrough(sellingVehicle, true)
  seexports.rl_gui:disableLinkCursor(sellingVehicle, true)
  local titleBarHeight = seexports.rl_gui:getTitleBarHeight()
  local players = getElementsByType("player", getRootElement(), true)
  local px, py, pz = getElementPosition(localPlayer)
  for i = #players, 1, -1 do
    local x, y, z = getElementPosition(players[i])
    if players[i] == localPlayer or getDistanceBetweenPoints3D(px, py, pz, x, y, z) > 5 then
      table.remove(players, i)
    end
  end
  local panelWidth = 325
  local panelHeight = titleBarHeight + 35 * (#players + 1) + 5
  sellWindow = seexports.rl_gui:createGuiElement("window", screenX / 2 - panelWidth / 2, screenY / 2 - panelHeight / 2, panelWidth, panelHeight)
  seexports.rl_gui:setWindowTitle(sellWindow, "16/BebasNeueRegular.otf", "Jármű eladás - Közeledben lévő játékosok:")
  sellToPlayers = {}
  for i = 1, #players do
    local btn = seexports.rl_gui:createGuiElement("button", 5, titleBarHeight + 5 + 35 * (i - 1), panelWidth - 10, 30, sellWindow)
    seexports.rl_gui:setGuiBackground(btn, "solid", "v4green")
    seexports.rl_gui:setGuiHover(btn, "gradient", {
      "v4green",
      "v4green-second"
    }, false, true)
    seexports.rl_gui:setButtonFont(btn, "15/BebasNeueBold.otf")
    seexports.rl_gui:setButtonTextColor(btn, "#ffffff")
    seexports.rl_gui:setButtonText(btn, " " .. getElementData(players[i], "visibleName"):gsub("_", " "))
    seexports.rl_gui:setButtonIcon(btn, seexports.rl_gui:getFaIconFilename("user", 30))
    seexports.rl_gui:setClickEvent(btn, "selectSellVehicleToPlayer")
    sellToPlayers[btn] = players[i]
  end
  local btn = seexports.rl_gui:createGuiElement("button", 5, panelHeight - 30 - 5, panelWidth - 10, 30, sellWindow)
  seexports.rl_gui:setGuiBackground(btn, "solid", "v4red")
  seexports.rl_gui:setGuiHover(btn, "gradient", {
    "v4red",
    "v4red-second"
  }, false, true)
  seexports.rl_gui:setButtonFont(btn, "15/BebasNeueBold.otf")
  seexports.rl_gui:setButtonTextColor(btn, "#ffffff")
  seexports.rl_gui:setButtonText(btn, "Mégsem")
  seexports.rl_gui:setClickEvent(btn, "endVehicleSellingDashboardWindow")
end)
addEvent("closeVehicleSlotBuy", true)
addEventHandler("closeVehicleSlotBuy", getRootElement(), function()
  buyingLabel = false
  sellingInteriorTo = false
  sellInput = false
  if buyingRect then
    seexports.rl_gui:deleteGuiElement(buyingRect)
  end
  buyingRect = false
  if buyingWindow then
    seexports.rl_gui:deleteGuiElement(buyingWindow)
  end
  buyingWindow = false
  buyingVehicleSlot = false
end)
addEvent("finalBuyVehicleSlot", true)
addEventHandler("finalBuyVehicleSlot", getRootElement(), function()
  if vehSlotPrice * currentAmount > ppBalance then
    seexports.rl_gui:showInfobox("e", "Nincs elég PrémiumPontod!")
  else
    triggerServerEvent("buyVehicleSlot", localPlayer, currentAmount)
    if buyingRect then
      seexports.rl_gui:deleteGuiElement(buyingRect)
    end
    buyingRect = false
    if buyingWindow then
      seexports.rl_gui:deleteGuiElement(buyingWindow)
    end
    buyingWindow = false
    buyingVehicleSlot = false
  end
end)
addEvent("changeVehicleSlotAmount", true)
addEventHandler("changeVehicleSlotAmount", getRootElement(), function(value)
  value = tonumber(value)
  if value then
    if 1 <= value then
      currentAmount = round2(value)
    else
      currentAmount = 1
    end
  else
    currentAmount = 1
  end
  if dashboardState then
    seexports.rl_gui:setLabelText(buyingLabel, "Prémium egyenleged: " .. seexports.rl_gui:getColorCodeHex("v4blue") .. "" .. seexports.rl_gui:thousandsStepper(ppBalance) .. " PP #ffffff\nFizetendő: " .. seexports.rl_gui:getColorCodeHex("v4blue") .. "" .. seexports.rl_gui:thousandsStepper(currentAmount * intiSlotPrice) .. " PP")
  end
end)
addEvent("openVehicleSlotBuy", true)
addEventHandler("openVehicleSlotBuy", getRootElement(), function()
  buyingVehicleSlot = true
  local titleBarHeight = seexports.rl_gui:getTitleBarHeight()
  local h = seexports.rl_gui:getFontHeight("14/BebasNeueRegular.otf")
  currentAmount = 0
  local panelWidth = 300
  local panelHeight = titleBarHeight + 5 + h * 1.5 + h * 2 + 30 + 5 + 5 + 5 + 32 + 5
  buyingRect = seexports.rl_gui:createGuiElement("rectangle", 0, 0, screenX, screenY)
  seexports.rl_gui:setGuiBackground(buyingRect, "solid", {
    0,
    0,
    0,
    150
  })
  seexports.rl_gui:setGuiHover(buyingRect, "none")
  seexports.rl_gui:setGuiHoverable(buyingRect, true)
  seexports.rl_gui:disableClickTrough(buyingRect, true)
  seexports.rl_gui:disableLinkCursor(buyingRect, true)
  buyingWindow = seexports.rl_gui:createGuiElement("window", screenX / 2 - panelWidth / 2, screenY / 2 - panelHeight / 2, panelWidth, panelHeight)
  seexports.rl_gui:setWindowTitle(buyingWindow, "16/BebasNeueRegular.otf", "Jármű slot vásárlás")
  local y = titleBarHeight + 5
  local label = seexports.rl_gui:createGuiElement("label", 5, y, panelWidth - 5, h * 1.5, buyingWindow)
  seexports.rl_gui:setLabelFont(label, "14/BebasNeueRegular.otf")
  seexports.rl_gui:setLabelAlignment(label, "center", "center")
  seexports.rl_gui:setLabelText(label, vehSlotPrice .. " PP / jármű slot")
  y = y + h * 1.5 + 5
  local input = seexports.rl_gui:createGuiElement("input", 32, y, panelWidth - 64, 32, buyingWindow)
  seexports.rl_gui:setInputFont(input, "11/Ubuntu-R.ttf")
  seexports.rl_gui:setInputIcon(input, "boxes")
  seexports.rl_gui:setInputPlaceholder(input, "Mennyiség")
  seexports.rl_gui:setInputMaxLength(input, 5)
  seexports.rl_gui:setInputNumberOnly(input, true)
  seexports.rl_gui:setInputChangeEvent(input, "changeVehicleSlotAmount")
  y = y + 32 + 5
  buyingLabel = seexports.rl_gui:createGuiElement("label", 5, y, panelWidth - 5, h * 2, buyingWindow)
  seexports.rl_gui:setLabelFont(buyingLabel, "11/Ubuntu-R.ttf")
  seexports.rl_gui:setLabelAlignment(buyingLabel, "center", "center")
  seexports.rl_gui:setLabelText(buyingLabel, "Prémium egyenleged: " .. seexports.rl_gui:getColorCodeHex("v4blue") .. "" .. seexports.rl_gui:thousandsStepper(ppBalance) .. " PP #ffffff\nFizetendő: " .. seexports.rl_gui:getColorCodeHex("v4blue") .. "" .. seexports.rl_gui:thousandsStepper(currentAmount * vehSlotPrice) .. " PP")
  local btnW = (panelWidth - 15) / 2
  local btn = seexports.rl_gui:createGuiElement("button", 5, panelHeight - 35, btnW, 30, buyingWindow)
  seexports.rl_gui:setGuiBackground(btn, "solid", "v4green")
  seexports.rl_gui:setGuiHover(btn, "gradient", {
    "v4green",
    "v4green-second"
  })
  seexports.rl_gui:setButtonFont(btn, "15/BebasNeueBold.otf")
  seexports.rl_gui:setButtonTextColor(btn, "#ffffff")
  seexports.rl_gui:setButtonText(btn, "Vásárlás")
  seexports.rl_gui:setClickEvent(btn, "finalBuyVehicleSlot", false)
  local btn = seexports.rl_gui:createGuiElement("button", 10 + btnW, panelHeight - 35, btnW, 30, buyingWindow)
  seexports.rl_gui:setGuiBackground(btn, "solid", "v4red")
  seexports.rl_gui:setGuiHover(btn, "gradient", {
    "v4red",
    "v4red-second"
  })
  seexports.rl_gui:setButtonFont(btn, "15/BebasNeueBold.otf")
  seexports.rl_gui:setButtonTextColor(btn, "#ffffff")
  seexports.rl_gui:setButtonText(btn, "Mégsem")
  seexports.rl_gui:setClickEvent(btn, "closeVehicleSlotBuy", false)
end)
local whiteTrans = {
  255,
  255,
  255,
  100
}
function drawTheVehicles()
  local bcg = seexports.rl_gui:createGuiElement("rectangle", 0, 0, sx, sy, rtg)
  seexports.rl_gui:setGuiBackground(bcg, "solid", "v4grey1")
  menuW = math.max(220, math.floor(sx * 0.25))
  local x = menuW + dashboardPadding[3] * 3
  local y = 0
  local rect = seexports.rl_gui:createGuiElement("rectangle", 0, 0, menuW, sy, rtg)
  seexports.rl_gui:setGuiBackground(rect, "solid", "v4grey2")
  carTitle = seexports.rl_gui:createGuiElement("label", x, y, sx - x - 12 - 200 - 100 - 24, sy, rtg)
  seexports.rl_gui:setLabelFont(carTitle, fonts[1])
  seexports.rl_gui:setLabelAlignment(carTitle, "left", "top")
  seexports.rl_gui:setLabelClip(carTitle, true)
  seexports.rl_gui:setLabelText(carTitle, "")
  y = y + seexports.rl_gui:getLabelFontHeight(carTitle)
  local bh = seexports.rl_gui:getFontHeight(fonts[2]) + dashboardPadding[3] * 3
  vehImg = seexports.rl_gui:createGuiElement("image", menuW, y, sx - menuW, sy - y - dashboardPadding[3] * 3 - bh, rtg)
  seexports.rl_gui:setGuiRenderDisabled(vehImg, true)
  carGPSBtn = seexports.rl_gui:createGuiElement("button", sx - 100 - 12 - 200 - 12, y - 32 - dashboardPadding[3] * 3, 200, 32, rtg)
  seexports.rl_gui:setGuiBackground(carGPSBtn, "solid", "v4blue")
  seexports.rl_gui:setGuiHover(carGPSBtn, "gradient", {
    "v4blue",
    "v4blue-second"
  }, false, true)
  seexports.rl_gui:setButtonFont(carGPSBtn, "15/BebasNeueBold.otf")
  seexports.rl_gui:setButtonText(carGPSBtn, "Jármű megjelölése GPS-en")
  seexports.rl_gui:setClickEvent(carGPSBtn, "markVehicleOnGPS")
  carSellBtn = seexports.rl_gui:createGuiElement("button", sx - 100 - 12, y - 32 - dashboardPadding[3] * 3, 100, 32, rtg)
  seexports.rl_gui:setGuiBackground(carSellBtn, "solid", "v4green")
  seexports.rl_gui:setGuiHover(carSellBtn, "gradient", {
    "v4green",
    "v4green-second"
  }, false, true)
  --iprint(sx - 100 - 12, y - 32 - dashboardPadding[3] * 3, rtg, carSellBtn)
  seexports.rl_gui:setButtonFont(carSellBtn, "15/BebasNeueBold.otf")
  seexports.rl_gui:setButtonText(carSellBtn, "Eladás")
  seexports.rl_gui:setClickEvent(carSellBtn, "startVehicleSelling")
  local border = seexports.rl_gui:createGuiElement("hr", x, y, sx - x - 12, 2, rtg)
  seexports.rl_gui:setGuiHrColor(border, "v4grey3", "v4grey2")
  y = y + 2
  --iprint(carSellBtn, carGPSBtn, border)
  local breakpoints = {}
  local oy = y
  local lhy = y
  local lastHead = 1
  local fhb = seexports.rl_gui:getFontHeight(fonts[2])
  local fhs = seexports.rl_gui:getFontHeight(fonts[4])
  for i = 1, #vehicleLabelLayout do
    if #vehicleLabelLayout[i] == 1 then
      y = y + dashboardPadding[3] * 3
      y = y + fhb + dashboardPadding[3]
      lastHead = i
      lhy = y
    else
      y = y + fhs + 2
    end
    if y >= sy - dashboardPadding[3] * 3 - bh then
      y = lhy
      breakpoints[lastHead] = true
    end
  end
  y = oy
  local breaks = 0
  local maxX = x
  dataLabels = {}
  for i = 1, #vehicleLabelLayout do
    if breakpoints[i] then
      breaks = breaks + 1
      if 1 < breaks then
        local border = seexports.rl_gui:createGuiElement("hr", x - dashboardPadding[3] * 4 - 2, oy + dashboardPadding[3] * 4, 2, y - oy - dashboardPadding[3] * 4, rtg)
        seexports.rl_gui:setGuiHrColor(border, "v4grey3", "v4grey2")
      end
      y = oy
      x = maxX
    end
    if #vehicleLabelLayout[i] == 1 then
      y = y + dashboardPadding[3] * 3
      local label = seexports.rl_gui:createGuiElement("label", x, y, sx, sy, rtg)
      seexports.rl_gui:setLabelFont(label, fonts[2])
      seexports.rl_gui:setLabelAlignment(label, "left", "top")
      seexports.rl_gui:setLabelText(label, vehicleLabelLayout[i][1])
      y = y + fhb + dashboardPadding[3]
      maxX = math.max(maxX, x + seexports.rl_gui:getLabelTextWidth(label) * 1.5 + dashboardPadding[3] * 4 * 2 + 2)
    else
      local label = seexports.rl_gui:createGuiElement("label", x, y, sx, sy, rtg)
      seexports.rl_gui:setLabelFont(label, fonts[4])
      seexports.rl_gui:setLabelAlignment(label, "left", "top")
      seexports.rl_gui:setLabelText(label, vehicleLabelLayout[i][1] .. ": ")
      y = y + fhs + 2
      maxX = math.max(maxX, x + seexports.rl_gui:getLabelTextWidth(label) * 1.5 + dashboardPadding[3] * 4 * 2 + 2)
      dataLabels[i] = label
    end
  end
  local border = seexports.rl_gui:createGuiElement("hr", x - dashboardPadding[3] * 4 - 2, oy + dashboardPadding[3] * 4, 2, y - oy - dashboardPadding[3] * 4, rtg)
  seexports.rl_gui:setGuiHrColor(border, "v4grey3", "v4grey2")
  loaderBcg = seexports.rl_gui:createGuiElement("rectangle", 0, 0, sx, sy, rtg)
  seexports.rl_gui:setGuiBackground(loaderBcg, "solid", "v4grey1")
  loaderIcon = seexports.rl_gui:createGuiElement("image", menuW + (sx - menuW) / 2 - 32, (sy - dashboardPadding[3] * 3 - bh) / 2 - 32, 64, 64, rtg)
  seexports.rl_gui:setImageFile(loaderIcon, seexports.rl_gui:getFaIconFilename("circle-notch", 64))
  seexports.rl_gui:setImageSpinner(loaderIcon, true)
  noVehiclesBg = seexports.rl_gui:createGuiElement("rectangle", 0, 0, sx, sy, rtg)
  seexports.rl_gui:setGuiBackground(noVehiclesBg, "solid", "v4grey1")
  noVehicles = seexports.rl_gui:createGuiElement("label", menuW, 0, sx - menuW, sy, rtg)
  seexports.rl_gui:setLabelFont(noVehicles, fonts[2])
  seexports.rl_gui:setLabelAlignment(noVehicles, "center", "center")
  seexports.rl_gui:setLabelClip(noVehicles, true)
  seexports.rl_gui:setLabelText(noVehicles, "Nincsen járműved!")
  seexports.rl_gui:setGuiRenderDisabled(loaderBcg, true)
  seexports.rl_gui:setGuiRenderDisabled(loaderIcon, true)
  seexports.rl_gui:setGuiRenderDisabled(noVehicles, true)
  local rect = seexports.rl_gui:createGuiElement("rectangle", menuW + dashboardPadding[3] * 3, sy - dashboardPadding[3] * 3 - bh, sx - dashboardPadding[3] * 3 * 2 - menuW, bh, rtg)
  seexports.rl_gui:setGuiBackground(rect, "solid", "v4grey2")
  local btn = seexports.rl_gui:createGuiElement("button", sx - dashboardPadding[3] * 3 - dashboardPadding[3] * 2 - 125, sy - dashboardPadding[3] * 3 - bh + dashboardPadding[3] * 2, 125, bh - dashboardPadding[3] * 2 * 2, rtg)
  seexports.rl_gui:setGuiBackground(btn, "solid", "v4blue")
  seexports.rl_gui:setGuiHover(btn, "gradient", {
    "v4blue",
    "v4blue-second"
  }, false, true)
  seexports.rl_gui:setButtonFont(btn, "14/BebasNeueBold.otf")
  seexports.rl_gui:setButtonText(btn, "Slot vásárlás")
  seexports.rl_gui:setClickEvent(btn, "openVehicleSlotBuy")
  bottomLabel = seexports.rl_gui:createGuiElement("label", menuW + dashboardPadding[3] * 3 * 2, sy - dashboardPadding[3] * 3 - bh, sx, bh, rtg)
  seexports.rl_gui:setLabelFont(bottomLabel, fonts[2])
  seexports.rl_gui:setLabelAlignment(bottomLabel, "left", "center")
  seexports.rl_gui:setLabelText(bottomLabel, "")
  local rect = seexports.rl_gui:createGuiElement("rectangle", 0, 0, menuW, sy, rtg)
  seexports.rl_gui:setGuiBackground(rect, "solid", "v4grey2")
  menuW = menuW - dashboardPadding[3] + 2
  local rect = seexports.rl_gui:createGuiElement("rectangle", menuW, 0, dashboardPadding[3] + 2, sy, rtg)
  seexports.rl_gui:setGuiBackground(rect, "solid", "v4grey3")
  scrollbar = seexports.rl_gui:createGuiElement("rectangle", menuW + 1, 1, dashboardPadding[3], 0, rtg)
  seexports.rl_gui:setGuiBackground(scrollbar, "solid", "v4green")
  local h = sy / 9
  for i = 1, 9 do
    sideMenu[i] = {}
    sideMenu[i][1] = seexports.rl_gui:createGuiElement("rectangle", 0, (i - 1) * h, menuW, h, rtg)
    seexports.rl_gui:setGuiHoverable(sideMenu[i][1], false)
    seexports.rl_gui:setClickEvent(sideMenu[i][1], "selectVehicleClick")
    sideMenu[i][7] = seexports.rl_gui:createGuiElement("label", 0, 0, menuW, h, sideMenu[i][1])
    seexports.rl_gui:setLabelFont(sideMenu[i][7], fonts[1])
    seexports.rl_gui:setLabelAlignment(sideMenu[i][7], "center", "center")
    seexports.rl_gui:setLabelText(sideMenu[i][7], "LEFOGLALVA")
    seexports.rl_gui:setLabelColor(sideMenu[i][7], whiteTrans)
    seexports.rl_gui:setGuiRenderDisabled(sideMenu[i][7], true)
    local w = 100
    sideMenu[i][2] = seexports.rl_gui:createGuiElement("label", dashboardPadding[3] * 3, dashboardPadding[3] * 3, menuW - dashboardPadding[3] * 6 - w - dashboardPadding[3] * 3, h, sideMenu[i][1])
    seexports.rl_gui:setLabelFont(sideMenu[i][2], fonts[2])
    seexports.rl_gui:setLabelAlignment(sideMenu[i][2], "left", "top")
    seexports.rl_gui:setLabelClip(sideMenu[i][2], true)
    seexports.rl_gui:setLabelText(sideMenu[i][2], "")
    local y = dashboardPadding[3] * 3 + seexports.rl_gui:getLabelFontHeight(sideMenu[i][2])
    sideMenu[i][3] = seexports.rl_gui:createGuiElement("label", dashboardPadding[3] * 3, y, menuW, h, sideMenu[i][1])
    seexports.rl_gui:setLabelFont(sideMenu[i][3], fonts[5])
    seexports.rl_gui:setLabelAlignment(sideMenu[i][3], "left", "top")
    seexports.rl_gui:setLabelText(sideMenu[i][3], "")
    sideMenu[i][4] = seexports.rl_gui:createGuiElement("rectangle", menuW - dashboardPadding[3] * 3 - w, dashboardPadding[3] * 3, w, y - dashboardPadding[3] * 3, sideMenu[i][1])
    seexports.rl_gui:setGuiBackground(sideMenu[i][4], "solid", "#ffffff")
    sideMenu[i][5] = seexports.rl_gui:createGuiElement("label", menuW - dashboardPadding[3] * 3 - w, dashboardPadding[3] * 3, w, y - dashboardPadding[3] * 3, sideMenu[i][1])
    seexports.rl_gui:setLabelFont(sideMenu[i][5], fonts[3])
    seexports.rl_gui:setLabelAlignment(sideMenu[i][5], "center", "center")
    seexports.rl_gui:setLabelClip(sideMenu[i][5], true)
    seexports.rl_gui:setLabelColor(sideMenu[i][5], "#000000")
    seexports.rl_gui:setLabelText(sideMenu[i][5], "")
    sideMenu[i][6] = seexports.rl_gui:createGuiElement("label", menuW - dashboardPadding[3] * 3 - w, y, w, h, sideMenu[i][1])
    seexports.rl_gui:setLabelFont(sideMenu[i][6], fonts[5])
    seexports.rl_gui:setLabelAlignment(sideMenu[i][6], "center", "top")
    seexports.rl_gui:setLabelText(sideMenu[i][6], "")
    seexports.rl_gui:setGuiRenderDisabled(sideMenu[i][4], true)
    seexports.rl_gui:setGuiBackground(sideMenu[i][1], "solid", "v4grey2")
    seexports.rl_gui:setGuiHoverable(sideMenu[i][1], true)
    seexports.rl_gui:setLabelColor(sideMenu[i][3], "v4lightgrey")
  end
  processVehicleSideMenu()
  refreshVehiclesBottomLabel()
  if vehicleList and vehicleList[selectedVehicle] then
    requestPreviewVehicle(vehicleList[selectedVehicle].vehicleId)
  end
end
function refreshVehiclesBottomLabel()
  if bottomLabel then
    if vehicleList then
      seexports.rl_gui:setLabelText(bottomLabel, "Prémium egyenleg: [color=v4blue]" .. seexports.rl_gui:thousandsStepper(ppBalance) .. " PP#ffffff | Araç yuvaları: " .. vehicleNum .. "/" .. vehLimit)
    else
      seexports.rl_gui:setLabelText(bottomLabel, "Prémium egyenleg: [color=v4blue]" .. seexports.rl_gui:thousandsStepper(ppBalance) .. " PP#ffffff")
    end
  end
end
function vehiclesScrollKey(key, por)
  if vehicleList then
    if key == "mouse_wheel_up" then
      if 0 < vehOffset then
        vehOffset = vehOffset - 1
        if layerMoved then
          layerMoveCursorMove()
        else
          processVehicleSideMenu()
        end
      end
    elseif key == "mouse_wheel_down" and vehOffset < #vehicleList - 9 then
      vehOffset = vehOffset + 1
      if layerMoved then
        layerMoveCursorMove()
      else
        processVehicleSideMenu()
      end
    end
  end
end
function processVehicleSideMenu()
  if vehicleList then
    if noVehiclesBg and noVehicles then
      seexports.rl_gui:setGuiRenderDisabled(noVehiclesBg, #vehicleList > 0)
      seexports.rl_gui:setGuiRenderDisabled(noVehicles, #vehicleList > 0)
    end
    if scrollbar then
      local sh = sy
      if #vehicleList > 0 then
        sh = sy / math.max(1, #vehicleList - 9 + 1)
      else
        sh = 0
      end
      seexports.rl_gui:setGuiSize(scrollbar, false, sh - 2)
      seexports.rl_gui:setGuiPosition(scrollbar, false, 1 + sh * vehOffset)
    end
    local h = sy / 9
    for i = 1, 9 do
      if sideMenu[i] then
        seexports.rl_gui:setGuiPosition(sideMenu[i][1], false, (i - 1) * h)
        if vehicleList[i + vehOffset] then
          seexports.rl_gui:setGuiHoverable(sideMenu[i][1], true)
          if selectedVehicle == i + vehOffset then
            if vehicleList[i + vehOffset].inService then
              seexports.rl_gui:setGuiBackground(sideMenu[i][1], "solid", "v4blue")
              seexports.rl_gui:setGuiHover(sideMenu[i][1], "gradient", {
                "v4blue",
                "v4blue-second"
              }, false, true)
            elseif tonumber(vehicleList[i + vehOffset].impounded) == 3 then
              seexports.rl_gui:setGuiBackground(sideMenu[i][1], "solid", "v4orange")
              seexports.rl_gui:setGuiHover(sideMenu[i][1], "gradient", {
                "v4orange",
                "v4orange-second"
              }, false, true)
            elseif vehicleList[i + vehOffset].impounded then
              seexports.rl_gui:setGuiBackground(sideMenu[i][1], "solid", "v4red")
              seexports.rl_gui:setGuiHover(sideMenu[i][1], "gradient", {
                "v4red",
                "v4red-second"
              }, false, true)
            else
              seexports.rl_gui:setGuiBackground(sideMenu[i][1], "solid", "v4green")
              seexports.rl_gui:setGuiHover(sideMenu[i][1], "gradient", {
                "v4green",
                "v4green-second"
              }, false, true)
            end
            seexports.rl_gui:setLabelColor(sideMenu[i][3], "#ffffff")
            seexports.rl_gui:setLabelColor(sideMenu[i][6], "#ffffff")
          elseif vehicleList[i + vehOffset].inService then
            seexports.rl_gui:setGuiBackground(sideMenu[i][1], "solid", "v4blue-second")
            seexports.rl_gui:setGuiHover(sideMenu[i][1], "gradient", {
              "v4blue",
              "v4blue-second"
            }, false, true)
            seexports.rl_gui:setLabelColor(sideMenu[i][3], "#ffffff")
            seexports.rl_gui:setLabelColor(sideMenu[i][6], "#ffffff")
          elseif tonumber(vehicleList[i + vehOffset].impounded) == 3 then
            seexports.rl_gui:setGuiBackground(sideMenu[i][1], "solid", "v4orange-second")
            seexports.rl_gui:setGuiHover(sideMenu[i][1], "gradient", {
              "v4orange",
              "v4orange-second"
            }, false, true)
            seexports.rl_gui:setLabelColor(sideMenu[i][3], "#ffffff")
            seexports.rl_gui:setLabelColor(sideMenu[i][6], "#ffffff")
          elseif vehicleList[i + vehOffset].impounded then
            seexports.rl_gui:setGuiBackground(sideMenu[i][1], "solid", "v4red-second")
            seexports.rl_gui:setGuiHover(sideMenu[i][1], "gradient", {
              "v4red",
              "v4red-second"
            }, false, true)
            seexports.rl_gui:setLabelColor(sideMenu[i][3], "#ffffff")
            seexports.rl_gui:setLabelColor(sideMenu[i][6], "#ffffff")
          else
            seexports.rl_gui:setGuiBackground(sideMenu[i][1], "solid", "v4grey2")
            seexports.rl_gui:setGuiHover(sideMenu[i][1], "gradient", {"v4grey2", "v4grey1"}, false, true)
            seexports.rl_gui:setLabelColor(sideMenu[i][3], "v4lightgrey")
            seexports.rl_gui:setLabelColor(sideMenu[i][6], "v4lightgrey")
          end
          seexports.rl_gui:setGuiRenderDisabled(sideMenu[i][4], false)
          seexports.rl_gui:setLabelText(sideMenu[i][2], vehicleList[i + vehOffset].name)
          seexports.rl_gui:setLabelText(sideMenu[i][3], seexports.rl_gui:thousandsStepper(math.floor(vehicleList[i + vehOffset].odometer)) .. " km")
          local plate = vehicleList[i + vehOffset].plate or ""
          local tmp = {}
          plate = split(plate, "-")
          for i = 1, #plate do
            if 1 <= utf8.len(plate[i]) then
              table.insert(tmp, plate[i])
            end
          end
          seexports.rl_gui:setLabelText(sideMenu[i][5], table.concat(tmp, "-"))
          seexports.rl_gui:setLabelText(sideMenu[i][6], "ID: " .. vehicleList[i + vehOffset].vehicleId)
          if vehicleList[i + vehOffset].inService then
            seexports.rl_gui:setLabelText(sideMenu[i][7], "SZERVIZBEN")
            seexports.rl_gui:setGuiRenderDisabled(sideMenu[i][7], false)
          elseif tonumber(vehicleList[i + vehOffset].impounded) == 3 then
            seexports.rl_gui:setLabelText(sideMenu[i][7], "ÁTÁLLÁS")
            seexports.rl_gui:setGuiRenderDisabled(sideMenu[i][7], false)
          elseif vehicleList[i + vehOffset].impounded then
            seexports.rl_gui:setLabelText(sideMenu[i][7], "LEFOGLALVA")
            seexports.rl_gui:setGuiRenderDisabled(sideMenu[i][7], false)
          else
            seexports.rl_gui:setGuiRenderDisabled(sideMenu[i][7], true)
          end
        else
          seexports.rl_gui:setGuiBackground(sideMenu[i][1], "solid", "v4grey2")
          seexports.rl_gui:setGuiHoverable(sideMenu[i][1], false)
          seexports.rl_gui:setGuiRenderDisabled(sideMenu[i][4], true)
          seexports.rl_gui:setLabelText(sideMenu[i][2], "")
          seexports.rl_gui:setLabelText(sideMenu[i][3], "")
          seexports.rl_gui:setLabelText(sideMenu[i][5], "")
          seexports.rl_gui:setLabelText(sideMenu[i][6], "")
          seexports.rl_gui:setGuiRenderDisabled(sideMenu[i][7], true)
        end
      end
    end
  else
    for i = 1, 9 do
      seexports.rl_gui:setGuiBackground(sideMenu[i][1], "solid", "v4grey2")
      seexports.rl_gui:setGuiHoverable(sideMenu[i][1], false)
      seexports.rl_gui:setGuiRenderDisabled(sideMenu[i][4], true)
      seexports.rl_gui:setLabelText(sideMenu[i][2], "")
      seexports.rl_gui:setLabelText(sideMenu[i][3], "")
      seexports.rl_gui:setLabelText(sideMenu[i][5], "")
      seexports.rl_gui:setLabelText(sideMenu[i][6], "")
      seexports.rl_gui:setGuiRenderDisabled(sideMenu[i][7], true)
    end
  end
end
local customPjTexture = false
function vehiclesInsideDestroy()
  vehiclesOpened = false
  if sellingVehicle then
    seexports.rl_gui:deleteGuiElement(sellingVehicle)
  end
  sellingVehicle = false
  if buyingRect then
    seexports.rl_gui:deleteGuiElement(buyingRect)
  end
  buyingRect = false
  if buyingWindow then
    seexports.rl_gui:deleteGuiElement(buyingWindow)
  end
  buyingWindow = false
  buyingRect = false
  buyingLabel = false
  buyingWindow = false
  buyingVehicleSlot = false
  if sellWindow then
    seexports.rl_gui:deleteGuiElement(sellWindow)
  end
  sellWindow = false
  sellInput = false
  sellToPlayers = false
  rtg = false
  removeEventHandler("onClientKey", getRootElement(), vehiclesScrollKey)
  if isElement(vehSrc) then
    destroyElement(vehSrc)
  end
  vehSrc = false
  loaderIcon = false
  loaderBcg = false
  vehImg = false
  carTitle = false
  carSellBtn = false
  carGPSBtn = false
  noVehiclesBg = false
  scrollbar = false
  bottomLabel = false
  noVehicles = false
  if layerMoved then
    removeEventHandler("onClientClick", getRootElement(), layerMoveClick)
    removeEventHandler("onClientCursorMove", getRootElement(), layerMoveCursorMove)
  end
  layerMoved = false
  dataLabels = {}
  sideMenu = {}
  deleteShader()
  deletePreview()
  if isElement(customPjTexture) then
    destroyElement(customPjTexture)
  end
  customPjTexture = nil
end
local previewVehicleSpinners = {}
local previewVehicleObjects = {}
local previewVehicle = false
local previewVehicleModel = false
local handlingFlags = {
  _1G_BOOST = 1,
  _2G_BOOST = 2,
  NPC_ANTI_ROLL = 4,
  NPC_NEUTRAL_HANDL = 8,
  NO_HANDBRAKE = 16,
  STEER_REARWHEELS = 32,
  HB_REARWHEEL_STEER = 64,
  ALT_STEER_OPT = 128,
  WHEEL_F_NARROW2 = 256,
  WHEEL_F_NARROW = 512,
  WHEEL_F_WIDE = 1024,
  WHEEL_F_WIDE2 = 2048,
  WHEEL_R_NARROW2 = 4096,
  WHEEL_R_NARROW = 8192,
  WHEEL_R_WIDE = 16384,
  WHEEL_R_WIDE2 = 32768,
  HYDRAULIC_GEOM = 65536,
  HYDRAULIC_INST = 131072,
  HYDRAULIC_NONE = 262144,
  NOS_INST = 524288,
  OFFROAD_ABILITY = 1048576,
  OFFROAD_ABILITY2 = 2097152,
  HALOGEN_LIGHTS = 4194304,
  PROC_REARWHEEL_1ST = 8388608,
  USE_MAXSP_LIMIT = 16777216,
  LOW_RIDER = 33554432,
  STREET_RACER = 67108864,
  SWINGING_CHASSIS = 268435456
}
function isFlagSet(val, flag)
  return bitAnd(val, flag) == flag
end
addEvent("gotPreviewVehicleCustomPaintjob", true)
addEventHandler("gotPreviewVehicleCustomPaintjob", getRootElement(), function(id, data)
    --iprint(id)
  if 1 == 1 then
    if isElement(customPjTexture) then
      destroyElement(customPjTexture)
    end
    customPjTexture = dxCreateTexture(data, "dxt1", false)
    data = nil
    local tex = seexports.rl_custompj:getCustomPjTextureName(vehDatas.model)
    if tex then
      createPaintjobShaderEx(tex)
    end
    setVehiclePreview()

    collectgarbage("collect")
  end
end)
local smallCount = 0
local smallTextureCreated = false

vehDatas = {}
addEvent("gotPreviewVehicleDatas", true)
addEventHandler("gotPreviewVehicleDatas", getRootElement(), function(id, datas)
    vehDatas = datas
  if dashboardClosing then
    deleteShader()
    deletePreview()
    return
  end
  if requestedVehiclePreview == id then
    if carTitle then
      seexports.rl_gui:setLabelText(carTitle, seexports.rl_vehiclenames:getCustomVehicleName(datas.model))
    end
    if carGPSBtn then
      seexports.rl_gui:setGuiRenderDisabled(carGPSBtn, datas.inService or datas.impounded)
    end
    if carSellBtn then
      seexports.rl_gui:setGuiRenderDisabled(carSellBtn, datas.inService or datas.impounded)
    end
    for i = 1, #vehicleLabelLayout do
      if #vehicleLabelLayout[i] == 2 and dataLabels[i] then
        seexports.rl_gui:setLabelText(dataLabels[i], vehicleLabelLayout[i][1] .. " " .. tostring(getVehLabelValue(datas, vehicleLabelLayout[i][2])))
      end
    end
    deletePreview()
    deletePreviewPaintjobShaders()
    previewVehicleModel = datas.model
    previewVehicle = createVehicle(previewVehicleModel, 0, 0, 0, 0, 0, 0)
    setElementAlpha(previewVehicle, 254)
    setElementStreamable(previewVehicle, false)
    setElementFrozen(previewVehicle, true)
    setElementCollisionsEnabled(previewVehicle, false)
    setVehicleOverrideLights(previewVehicle, 1)
    setElementInterior(previewVehicle, getElementInterior(localPlayer))
    setElementDimension(previewVehicle, getElementDimension(localPlayer))
    if datas["performance.turbo"] == 4 then
      local o1, o2, o3, o4 = seexports.rl_vehicles:createPreviewSupercharger(previewVehicle)
      table.insert(previewVehicleObjects, o1)
      table.insert(previewVehicleObjects, o2)
      table.insert(previewVehicleObjects, o3)
      table.insert(previewVehicleObjects, o4)
    end
    if datas.spinner then
      local objs = seexports.rl_spinner:refreshSpinners(previewVehicle, datas.spinner, true)
      if objs then
        for i = 1, 4 do
          table.insert(previewVehicleObjects, objs[i])
        end
        if type(datas.spinner) == "table" then
          createSpinnerShader(datas.spinner[2], datas.spinner[3], datas.spinner[4], objs)
        end
      end
    end
    if datas.currentVariant then
      setVehicleVariant(previewVehicle, datas.currentVariant - 1, 255)
    end
    local value = getVehicleHandling(previewVehicle).handlingFlags
    local flagsSet = {}
    for k, v in pairs(handlingFlags) do
      if isFlagSet(value, v) then
        flagsSet[k] = true
      end
    end
    flagsSet.WHEEL_F_NARROW2 = datas.frontWheelWidth == 1
    flagsSet.WHEEL_F_NARROW = datas.frontWheelWidth == 2
    flagsSet.WHEEL_F_WIDE = datas.frontWheelWidth == 3
    flagsSet.WHEEL_F_WIDE2 = datas.frontWheelWidth == 4
    flagsSet.WHEEL_R_NARROW2 = datas.rearWheelWidth == 1
    flagsSet.WHEEL_R_NARROW = datas.rearWheelWidth == 2
    flagsSet.WHEEL_R_WIDE = datas.rearWheelWidth == 3
    flagsSet.WHEEL_R_WIDE2 = datas.rearWheelWidth == 4
    flagsSet.OFFROAD_ABILITY = datas.offroadSetting == 1
    flagsSet.OFFROAD_ABILITY2 = datas.offroadSetting == 2
    value = 0
    for k, v in pairs(flagsSet) do
      if v then
        value = value + handlingFlags[k]
      end
    end
    setVehicleHandling(previewVehicle, "handlingFlags", value)
    if datas.optical14 then
      addVehicleUpgrade(previewVehicle, datas.optical14)
    end
    if datas.optical15 then
      addVehicleUpgrade(previewVehicle, datas.optical15)
    end
    if datas.optical3 then
      addVehicleUpgrade(previewVehicle, datas.optical3)
    end
    if datas.optical0 then
      addVehicleUpgrade(previewVehicle, datas.optical0)
    end
    if datas.optical2 then
      addVehicleUpgrade(previewVehicle, datas.optical2)
    end
    if datas.optical7 then
      addVehicleUpgrade(previewVehicle, datas.optical7)
    end
    if datas.optical12 then
      addVehicleUpgrade(previewVehicle, datas.optical12)
    end
    if datas.optical13 then
      addVehicleUpgrade(previewVehicle, datas.optical13)
    end
    setVehicleHandling(previewVehicle, "suspensionLowerLimit", datas.rideHeight)
    setVehiclePlateText(previewVehicle, datas.plate)
    if datas.customPaintjob then
    elseif datas.paintjob then
      local tex, file, dxt = seexports.rl_paintjob:getVehiclePJ(previewVehicleModel, datas.paintjob)
      if tex then
        createPaintjobShader(tex, file, dxt)
      end
    end
    if datas.wheelPaintjob then
      local tex, file, dxt = seexports.rl_paintjob:getVehicleWheel(previewVehicleModel, datas.optical12, datas.wheelPaintjob)
      if tex then
        createPaintjobShader(tex, file, dxt)
      end
    end
    if datas.headlightPaintjob then
      local tex, file, dxt = seexports.rl_paintjob:getVehicleHeadlight(previewVehicleModel, datas.headlightPaintjob)
      if tex then
        createPaintjobShader(tex, file, dxt)
      end
    end
    setVehicleColor(previewVehicle, unpack(datas.col))
    setElementHealth(previewVehicle, datas.health)
    for i = 0, 6 do
      setVehiclePanelState(previewVehicle, i, datas.panelState[i] or 0)
    end
    for i = 0, 5 do
      local state = datas.doorState[i]
      if state == 1 then
        state = 0
      elseif state == 3 then
        state = 2
      end
      setVehicleDoorState(previewVehicle, i, state or 0)
    end
    setVehiclePreview()
    if not isElement(smallTextureCreated) then
      smallTextureCreated = dxCreateRenderTarget(screenX, screenY, true)
    end
    smallCount = 0
  end
end)
function getRequestedVehiclePreview()
  return false
end
function deletePreview()
  requestedVehiclePreview = false
  if loaderBcg then
    seexports.rl_gui:setGuiRenderDisabled(loaderBcg, true)
  end
  if loaderIcon then
    seexports.rl_gui:setGuiRenderDisabled(loaderIcon, true)
  end
  if isElement(previewVehicle) then
    destroyElement(previewVehicle)
  end
  previewVehicle = false
  previewVehicleSpinners = {}
  for i = 1, #previewVehicleObjects do
    if isElement(previewVehicleObjects[i]) then
      destroyElement(previewVehicleObjects[i])
    end
    previewVehicleObjects[i] = nil
  end
end
function requestPreviewVehicle(id)
  deletePreview()
  if isElement(customPjTexture) then
    destroyElement(customPjTexture)
  end
  customPjTexture = nil
  if not isElement(vehSrc) then
    vehSrc = dxCreateRenderTarget(screenX, screenY, true)
  end
  if vehImg then
    seexports.rl_gui:setGuiRenderDisabled(vehImg, true)
  end
  if loaderIcon then
    seexports.rl_gui:setGuiRenderDisabled(loaderIcon, false)
  end
  if loaderBcg then
    seexports.rl_gui:setGuiRenderDisabled(loaderBcg, false)
  end
  previewTextSaved = false
  requestedVehiclePreview = id
  triggerServerEvent("requestVehiclePreviewData", localPlayer, requestedVehiclePreview)
end
function getShaderSource(tex, tint)
  return " float sElementOffset = -3.9; float3 sCameraPosition = float3(0,0,0); float3 sCameraForward = float3(0,0,0); float3 sCameraUp = float3(0,0,0); float sFov = 1; float sAspect = 1; float2 sMoveObject2D = float2(0,0); float2 sScaleObject2D = float2(1,1); float2 sRealScale2D = float2(1,1); float sProjZMult = 2; texture gTexture0 < string textureState=\"0,Texture\"; >; texture gTexture1 < string textureState=\"1,Texture\"; >; float4x4 gProjection : PROJECTION; float4x4 gWorld : WORLD; float4x4 gWorldView : WORLDVIEW; texture secondRT < string renderTarget = \"yes\"; >; float gTime : TIME; float3 gCameraDirection = float3(0,0,-1); float4 gLightAmbient : LIGHTAMBIENT; float4 sLightDiffuse : LIGHTDIFFUSE; float4 gLight1Specular < string lightState=\"1,Specular\"; >; int gLighting < string renderState=\"LIGHTING\"; >; float4 gGlobalAmbient < string renderState=\"AMBIENT\"; >; int gAmbientMaterialSource < string renderState=\"AMBIENTMATERIALSOURCE\"; >; int gDiffuseMaterialSource < string renderState=\"DIFFUSEMATERIALSOURCE\"; >; int gEmissiveMaterialSource < string renderState=\"EMISSIVEMATERIALSOURCE\"; >; float4 gMaterialAmbient < string materialState=\"Ambient\"; >; float4 gMaterialDiffuse < string materialState=\"Diffuse\"; >; float4 gMaterialSpecular < string materialState=\"Specular\"; >; float4 gMaterialEmissive < string materialState=\"Emissive\"; >; float gMaterialSpecPower < string materialState=\"Power\"; >; int CUSTOMFLAGS <string createNormals = \"yes\"; string skipUnusedParameters = \"yes\"; >; static float4 gLightDiffuse = (sLightDiffuse.r + sLightDiffuse.g + sLightDiffuse.b) < 0.005 ? sLightDiffuse : float4(0.2,0.2,0.2,1); int gStage1ColorOp < string stageState=\"1,COLOROP\"; >; float4 gTextureFactor < string renderState=\"TEXTUREFACTOR\"; >; float3 gLightDirection = float3(0.507,-0.2,-0.507); " .. (tex and " texture TexInput; sampler Sampler0 = sampler_state { Texture = (TexInput); }; " or " sampler Sampler0 = sampler_state { Texture = (gTexture0); }; ") .. " sampler Sampler1 = sampler_state { Texture = (gTexture1); }; struct VSInput { float3 Position : POSITION0; float3 Normal : NORMAL0; float4 Diffuse : COLOR0; float2 TexCoord0 : TEXCOORD0; float2 TexCoord1 : TEXCOORD1; }; struct PSInput { float4 Position : POSITION0; float4 Diffuse : COLOR0; float3 Specular : COLOR1; float2 TexCoord0 : TEXCOORD0; float3 TexCoord1 : TEXCOORD1; float3 Normal : TEXCOORD2; float4 vPosition : TEXCOORD3; float2 Depth : TEXCOORD4; }; float4x4 createViewMatrix( float3 pos, float3 fwVec, float3 upVec ) { float3 zaxis = normalize( fwVec); float3 xaxis = normalize( cross( -upVec, zaxis )); float3 yaxis = cross( xaxis, zaxis ); float4x4 viewMatrix = { float4( xaxis.x, yaxis.x, zaxis.x, 0 ), float4( xaxis.y, yaxis.y, zaxis.y, 0 ), float4( xaxis.z, yaxis.z, zaxis.z, 0 ), float4(-dot( xaxis, pos ), -dot( yaxis, pos ), -dot( zaxis, pos ), 1 ) }; return viewMatrix; } float4x4 createProjectionMatrix(float near_plane, float far_plane, float fov_horiz, float fov_aspect, float2 ss_mov, float2 ss_scale) { float h, w, Q; w = 1/tan(fov_horiz * 0.5); h = w/fov_aspect; Q = far_plane/(far_plane - near_plane); float4x4 projectionMatrix = { float4(w * ss_scale.x, 0, 0, 0), float4(0, h * ss_scale.y, 0, 0), float4(ss_mov.x, ss_mov.y, Q, 1), float4(0, 0, -Q*near_plane, 0) }; return projectionMatrix; } float4 MTACalcGTABuildingDiffuse( float4 InDiffuse ) { float4 OutDiffuse; if ( !gLighting ) { OutDiffuse = InDiffuse; } else { float4 ambient = gAmbientMaterialSource == 0 ? gMaterialAmbient : InDiffuse; float4 diffuse = gDiffuseMaterialSource == 0 ? gMaterialDiffuse : InDiffuse; float4 emissive = gEmissiveMaterialSource == 0 ? gMaterialEmissive : InDiffuse; OutDiffuse = gGlobalAmbient * saturate( ambient + emissive ); OutDiffuse.a *= diffuse.a; } return OutDiffuse; } float4 MTACalcGTAVehicleDiffuse( float3 WorldNormal, float4 InDiffuse ) { float4 ambient = gAmbientMaterialSource == 0 ? gMaterialAmbient : InDiffuse; float4 diffuse = gDiffuseMaterialSource == 0 ? gMaterialDiffuse : InDiffuse; float4 emissive = gEmissiveMaterialSource == 0 ? gMaterialEmissive : InDiffuse; float4 TotalAmbient = ambient * ( gGlobalAmbient + gLightAmbient ); float DirectionFactor = max(0,dot(WorldNormal, -gLightDirection )); float4 TotalDiffuse = ( diffuse * gLightDiffuse * DirectionFactor ); float4 OutDiffuse = saturate(TotalDiffuse + TotalAmbient + emissive); OutDiffuse.a *= diffuse.a; return OutDiffuse; } float MTACalculateSpecular( float3 CamDir, float3 LightDir, float3 SurfNormal, float SpecPower ) { LightDir = normalize(LightDir); SurfNormal = normalize(SurfNormal); float3 halfAngle = normalize(-CamDir - LightDir); float r = dot(halfAngle, SurfNormal); return pow(saturate(r), SpecPower); } PSInput VertexShaderFunction(VSInput VS) { PSInput PS = (PSInput)0; if (VS.Normal.x == 0 && VS.Normal.y == 0 && VS.Normal.z == 0) VS.Normal = float3(0,0,1); float4 wPos = mul(float4(VS.Position, 1), gWorld); float4x4 sView = createViewMatrix(sCameraPosition, sCameraForward, sCameraUp); float4 vPos = mul(wPos, sView); vPos.z += sElementOffset; float sFarClip = gProjection[3][2] / (1 - gProjection[2][2]); float sNearClip = gProjection[3][2] / - gProjection[2][2]; float aspect = 1; float4x4 sProjection = createProjectionMatrix(sNearClip, sFarClip, sFov, sAspect, sMoveObject2D, sScaleObject2D); float4x4 tProjection = createProjectionMatrix(sNearClip, sFarClip, sFov, sAspect, float2(0,0), sScaleObject2D / sRealScale2D); PS.Position = mul(vPos, sProjection); PS.vPosition = mul(vPos, tProjection); PS.Depth = float2(PS.Position.z, PS.Position.w); PS.TexCoord0 = VS.TexCoord0; float3 ViewNormal = mul(VS.Normal, (float3x3)gWorldView); ViewNormal = normalize(ViewNormal); PS.TexCoord1 = 0; if (gStage1ColorOp == 25) PS.TexCoord1 = ViewNormal.xyz; if (gStage1ColorOp == 14) PS.TexCoord1 = float3(VS.TexCoord1.xy, 1); PS.Normal = mul(VS.Normal, (float3x3)gWorld); PS.Diffuse = MTACalcGTAVehicleDiffuse( VS.Normal, VS.Diffuse ); PS.Specular.rgb = gMaterialSpecular.rgb * MTACalculateSpecular(gCameraDirection, gLightDirection, VS.Normal, min(127, gMaterialSpecPower)) * gLight1Specular.rgb; return PS; } struct Pixel { float4 Color : COLOR0; float4 Extra : COLOR1; float Depth : DEPTH0; }; " .. (tint and " float red; float green; float blue; " or "") .. " float3 loadingColor; Pixel PixelShaderFunction(PSInput PS) { Pixel output; float4 texel = tex2D(Sampler0, PS.TexCoord0); " .. (tint and " texel.r = red; texel.g = green; texel.b = blue; " or "") .. " output.Color = float4(0, 0, 0, min(min(texel.a * PS.Diffuse.a, 0.006105), 1)); float4 finalColor = texel * PS.Diffuse * 2; if (gStage1ColorOp == 14) { float4 envTexel = tex2D(Sampler1, PS.TexCoord1.xy); finalColor.rgb = finalColor.rgb * (1 - gTextureFactor.a) + envTexel.rgb * gTextureFactor.a; } if (gStage1ColorOp == 25) { float4 sphTexel = tex2D(Sampler1, PS.TexCoord1.xy/PS.TexCoord1.z); finalColor.rgb += sphTexel.rgb * gTextureFactor.r; } if (gMaterialSpecPower != 0) finalColor.rgb += PS.Specular.rgb; float2 scrCoord =(PS.vPosition.xy / PS.vPosition.w) * float2(0.5, -0.5) + 0.5; output.Depth = ((PS.Depth.x * 0.00625 * sProjZMult) / PS.Depth.y); if ((scrCoord.x > 1) || (scrCoord.x < 0) || (scrCoord.y > 1) || (scrCoord.y < 0)) { output.Depth = 1; output.Color = 0; } output.Extra = saturate(finalColor); return output; } technique fx_pre_vehicle_MRT { pass P0 { FogEnable = false; AlphaBlendEnable = true; AlphaRef = 1; SeparateAlphaBlendEnable = true; SrcBlendAlpha = SrcAlpha; DestBlendAlpha = One; VertexShader = compile vs_2_0 VertexShaderFunction(); PixelShader = compile ps_2_0 PixelShaderFunction(); } } technique fallback { pass P0 { } } "
end
local shader = false
local psx, psy = 0, 0
local ppx, ppy = 0, 0
local prevX, prevW = 0, 0
local shaderRenderHandled = false
local paintjobShaders = {}
local paintjobTextures = {}
local paintjobTextureNames = {}
function deletePreviewPaintjobShaders()
  paintjobTextureNames = {}
  for i = 1, #paintjobShaders do
    if isElement(paintjobShaders[i]) then
      destroyElement(paintjobShaders[i])
    end
    paintjobShaders[i] = nil
  end
  for i = 1, #paintjobTextures do
    if isElement(paintjobTextures[i]) then
      destroyElement(paintjobTextures[i])
    end
    paintjobTextures[i] = nil
  end
end
function deleteShader()
  deletePreviewPaintjobShaders()
  if isElement(shader) then
    destroyElement(shader)
  end
  shader = false
  if shaderRenderHandled then
    removeEventHandler("onClientPreRender", getRootElement(), preRenderPreview)
    shaderRenderHandled = false
  end
end
function createSpinnerShader(r, g, b, objs)
  local shader = dxCreateShader(getShaderSource(false, true), 0, 0, false, "all")
  local i = #paintjobShaders + 1
  paintjobShaders[i] = shader
  dxSetShaderValue(shader, "sFov", 70)
  dxSetShaderValue(shader, "sAspect", screenY / screenX)
  dxSetShaderValue(shader, "red", r / 255)
  dxSetShaderValue(shader, "green", g / 255)
  dxSetShaderValue(shader, "blue", b / 255)
  for i = 1, 4 do
    previewVehicleSpinners[objs[i]] = true
    engineApplyShaderToWorldTexture(shader, "*", objs[i])
  end
end
function createPaintjobShaderEx(tex, texture)
  local shader = dxCreateShader(getShaderSource(true), 0, 0, false, "all")
  local i = #paintjobShaders + 1
  paintjobShaders[i] = shader
  paintjobTextureNames[i] = tex
  dxSetShaderValue(shader, "sFov", 70)
  dxSetShaderValue(shader, "sAspect", screenY / screenX)
  dxSetShaderValue(shader, "TexInput", customPjTexture)
end
function createPaintjobShader(tex, file, dxt)
  local texture = dxCreateTexture(":rl_paintjob/textures/" .. file, dxt)
  if isElement(texture) then
    table.insert(paintjobTextures, texture)
    local shader = dxCreateShader(getShaderSource(true), 0, 0, false, "all")
    local i = #paintjobShaders + 1
    paintjobShaders[i] = shader
    paintjobTextureNames[i] = tex
    dxSetShaderValue(shader, "sFov", 70)
    dxSetShaderValue(shader, "sAspect", screenY / screenX)
    dxSetShaderValue(shader, "TexInput", texture)
  end
end
function setVehiclePreview()
  if not isElement(shader) then
    shader = dxCreateShader(getShaderSource(), 0, 0, false, "all")
    dxSetShaderValue(shader, "sFov", 70)
    dxSetShaderValue(shader, "sAspect", screenY / screenX)
  end
  if isElement(shader) and isElement(vehSrc) and isElement(previewVehicle) and vehImg then
    if not shaderRenderHandled then
      addEventHandler("onClientPreRender", getRootElement(), preRenderPreview)
      shaderRenderHandled = true
    end
    local x, y = seexports.rl_gui:getGuiRealPosition(vehImg)
    local sx, sy = seexports.rl_gui:getGuiSize(vehImg)
    seexports.rl_gui:setGuiRenderDisabled(vehImg, false)
    seexports.rl_gui:setImageFile(vehImg, vehSrc)
    seexports.rl_gui:setImageUV(vehImg, x, y, sx, sy)
    seexports.rl_gui:setImageShadow(vehImg, 8, -2, -1, {
      0,
      0,
      0,
      63.75
    })
    engineApplyShaderToWorldTexture(shader, "*", previewVehicle)
    for i = 1, #previewVehicleObjects do
      if isElement(previewVehicleObjects[i]) and not previewVehicleSpinners[previewVehicleObjects[i]] then
        engineApplyShaderToWorldTexture(shader, "*", previewVehicleObjects[i])
      end
    end
    for i = 1, #paintjobShaders do
      if paintjobTextureNames[i] then
        local new = "#" .. utf8.sub(paintjobTextureNames[i], 2)
        engineRemoveShaderFromWorldTexture(shader, paintjobTextureNames[i], previewVehicle)
        engineRemoveShaderFromWorldTexture(shader, new, previewVehicle)
        engineApplyShaderToWorldTexture(paintjobShaders[i], paintjobTextureNames[i], previewVehicle)
        engineApplyShaderToWorldTexture(paintjobShaders[i], new, previewVehicle)
      end
    end
    prevX, prevW = x, sx
    psx, psy = sx / screenX / 2, sy / screenY / 2
    ppx, ppy = x / screenX + psx - 0.5, -(y / screenY + psy - 0.5)
    ppx, ppy = 2 * ppx, 2 * ppy
    dxSetRenderTarget(vehSrc, true)
    dxSetRenderTarget()
    local r, g, b = unpack(seexports.rl_gui:getColorCode("v4grey3"))
    for i = 1, #paintjobShaders do
      dxSetShaderValue(paintjobShaders[i], "loadingColor", r, g, b)
      dxSetShaderValue(paintjobShaders[i], "secondRT", vehSrc)
      dxSetShaderValue(paintjobShaders[i], "sMoveObject2D", ppx, ppy)
      dxSetShaderValue(paintjobShaders[i], "sScaleObject2D", 2 * math.min(psx, psy), 2 * math.min(psx, psy))
      dxSetShaderValue(paintjobShaders[i], "sRealScale2D", 2 * psx, 2 * psy)
    end
    dxSetShaderValue(shader, "loadingColor", r, g, b)
    dxSetShaderValue(shader, "secondRT", vehSrc)
    dxSetShaderValue(shader, "sMoveObject2D", ppx, ppy)
    dxSetShaderValue(shader, "sScaleObject2D", 2 * math.min(psx, psy), 2 * math.min(psx, psy))
    dxSetShaderValue(shader, "sRealScale2D", 2 * psx, 2 * psy)
  end
end
local vehicleBackP = 0
function preRenderPreview(delta)
  if isElement(vehSrc) and isElement(previewVehicle) and vehImg then
    setVehicleEngineState(previewVehicle, true)
    local cameraMatrix = getElementMatrix(getCamera())
    local r = 40
    local cx = getCursorPosition()
    local back = false
    if cx then
      cx = cx * screenX
      r = (getEasingValue(math.min(1, math.max(0, (cx - prevX) / prevW)), "InOutQuad") - 0.5) * 25 + 40
      if getKeyState("mouse2") then
        back = true
      end
    end
    if back then
      if vehicleBackP < 1 then
        vehicleBackP = vehicleBackP + 1 * delta / 500
        if 1 < vehicleBackP then
          vehicleBackP = 1
        end
      end
    elseif 0 < vehicleBackP then
      vehicleBackP = vehicleBackP - 1 * delta / 500
      if vehicleBackP < 0 then
        vehicleBackP = 0
      end
    end
    r = r + 180 * getEasingValue(vehicleBackP, "InOutQuad")
    local minX, minY, minZ, maxX, maxY, maxZ = getElementBoundingBox(previewVehicle)
    local radius, c = 1.5, 1
    if minX then
      local a = maxX - minX
      local b = maxY - minY
      local c = math.sqrt(a * a + b * b)
      local origRad = a * b / c
      radius = math.max(1.5, origRad)
      c = c * radius / origRad
    end
    local small = false
    if isElement(smallTextureCreated) then
      local s = math.floor(math.max(oneSize[1] * 2, oneSize[2] * 2) * 1.25 / 2) * 2
      if 2 < smallCount then
        dxSetRenderTarget(vehSrc, true)
        local rt = dxCreateRenderTarget(s, s)
        dxSetRenderTarget(rt, true)
        dxDrawRectangle(0, 0, s, s, seexports.rl_gui:getColorCodeToColor("v4grey1"))
        seelangStaticImageUsed[0] = true
        if seelangStaticImageToc[0] then
          processSeelangStaticImage[0]()
        end
        dxDrawImage(0, 0, s, s, seelangStaticImage[0])
        dxDrawImageSection(0, 0, s, s, screenX / 2 - s / 2, screenY / 2 - s / 2, s, s, smallTextureCreated)
        dxSetRenderTarget()
        if isElement(rt) then
          local pixels = dxGetTexturePixels(rt)
          if pixels then
            if fileExists("!rl_vehprev.sg") then
              fileDelete("!rl_vehprev.sg")
            end
            local file = fileCreate("!rl_vehprev.sg")
            fileWrite(file, pixels)
            fileClose(file)
            if vehiclePreviewTexture then
              backgroundSizes[vehiclePreviewTexture] = nil
            end
            if isElement(vehiclePreviewTexture) then
              destroyElement(vehiclePreviewTexture)
            end
            vehiclePreviewTexture = dxCreateTexture(pixels)
            if isElement(vehiclePreviewTexture) then
              local i, j = vehsPosition[1], vehsPosition[2]
              dashboardLayout[i][j].background = vehiclePreviewTexture
              backgroundSizes[vehiclePreviewTexture] = {s, s}
              if dashboardState and dashboardLayout[i][j].images and dashboardLayout[i][j].images[1] then
                seexports.rl_gui:setImageFile(dashboardLayout[i][j].images[1], vehiclePreviewTexture)
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
              seexports.rl_gui:setImageUV(dashboardLayout[i][j].images[1], (s - u) / 2, (s - v) / 2, u, v)
              seexports.rl_gui:setGuiHoverable(dashboardLayout[i][j].images[1], true, 1000)
              if isElement(smallTextureCreated) then
                destroyElement(smallTextureCreated)
              end
              smallTextureCreated = nil
            end
          end
          destroyElement(rt)
          for i = 1, #paintjobShaders do
            dxSetShaderValue(paintjobShaders[i], "secondRT", vehSrc)
            dxSetShaderValue(paintjobShaders[i], "sMoveObject2D", ppx, ppy)
            dxSetShaderValue(paintjobShaders[i], "sScaleObject2D", 2 * math.min(psx, psy), 2 * math.min(psx, psy))
            dxSetShaderValue(paintjobShaders[i], "sRealScale2D", 2 * psx, 2 * psy)
          end
          dxSetShaderValue(shader, "secondRT", vehSrc)
          dxSetShaderValue(shader, "sMoveObject2D", ppx, ppy)
          dxSetShaderValue(shader, "sScaleObject2D", 2 * math.min(psx, psy), 2 * math.min(psx, psy))
          dxSetShaderValue(shader, "sRealScale2D", 2 * psx, 2 * psy)
        end
      else
        small = true
        local psx, psy = s / screenX / 2, s / screenY / 2
        local ppx, ppy = (screenX / 2 - s / 2) / screenX + psx - 0.5, -((screenY / 2 - s / 2) / screenY + psy - 0.5)
        ppx, ppy = 2 * ppx, 2 * ppy
        for i = 1, #paintjobShaders do
          dxSetShaderValue(paintjobShaders[i], "secondRT", smallTextureCreated)
          dxSetShaderValue(paintjobShaders[i], "sMoveObject2D", ppx, ppy)
          dxSetShaderValue(paintjobShaders[i], "sScaleObject2D", 2 * math.min(psx, psy), 2 * math.min(psx, psy))
          dxSetShaderValue(paintjobShaders[i], "sRealScale2D", 2 * psx, 2 * psy)
        end
        dxSetShaderValue(shader, "secondRT", smallTextureCreated)
        dxSetShaderValue(shader, "sMoveObject2D", ppx, ppy)
        dxSetShaderValue(shader, "sScaleObject2D", 2 * math.min(psx, psy), 2 * math.min(psx, psy))
        dxSetShaderValue(shader, "sRealScale2D", 2 * psx, 2 * psy)
        dxSetRenderTarget(smallTextureCreated, true)
        dxSetRenderTarget()
      end
      smallCount = smallCount + 1
    else
      dxSetRenderTarget(vehSrc, true)
      dxSetRenderTarget()
    end
    local transformMatrix, posX, posY, posZ
    if small then
      transformMatrix = createElementMatrix(0, 0, 135)
      posX, posY, posZ = getPositionFromMatrixOffset(cameraMatrix, 0, 5.25 * radius, 0)
    else
      transformMatrix = createElementMatrix(0, 0, r + 90)
      posX, posY, posZ = getPositionFromMatrixOffset(cameraMatrix, c, 5.25 * radius, -radius / 4)
    end
    local multipliedMatrix = matrixMultiply(transformMatrix, cameraMatrix)
    local rotX, rotY, rotZ = getEulerAnglesFromMatrix(multipliedMatrix)
    setElementPosition(previewVehicle, posX, posY, posZ, false)
    setElementRotation(previewVehicle, rotX, rotY, rotZ, "ZXY")
    for i = 1, #paintjobShaders do
      dxSetShaderValue(paintjobShaders[i], "sCameraPosition", cameraMatrix[4])
      dxSetShaderValue(paintjobShaders[i], "sCameraForward", cameraMatrix[2])
      dxSetShaderValue(paintjobShaders[i], "sCameraUp", cameraMatrix[3])
    end
    dxSetShaderValue(shader, "sCameraPosition", cameraMatrix[4])
    dxSetShaderValue(shader, "sCameraForward", cameraMatrix[2])
    dxSetShaderValue(shader, "sCameraUp", cameraMatrix[3])
  end
end
