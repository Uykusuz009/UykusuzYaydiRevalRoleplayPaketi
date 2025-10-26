local seexports = {
  rl_gui = false,
  rl_interiors = false,
  rl_farm = false,
  rl_paintshop = false
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
local rtg = false
local sx, sy = 0, 0
local inside = false
local maxIntiOffset = 0
local intiOffset = 0
local selectedInterior = 1
local buttons = {}

      --[[
        editable false / true
        report {0, 1, 2}
      ]]

      --[[
local interiorRenderList = {
  [1] = {
    theType = "interior",
    data = {
      type = "garage",
      id = 1,
      name = "Teszt garázs",
      locked = false,
      interiorId = 1,
      editable = "N",
      report = 0,
      outside = {2879.552734375, -1044.3178710938, 10.875}
    }
  },
  [2] = {
    theType = "interior",
    data = {
      type = "house",
      id = 1,
      name = "Teszt ház",
      locked = false,
      interiorId = 1,
      editable = "Y",
      report = 1,
      --[(66, 2879.552734375, -1044.3178710938, 10.875, -0, 0, 328.17663574219)]
      outside = {2879.552734375, -1044.3178710938, 10.875}
    }
  }
}
]]
addEvent("selectInteriorClick", true)
addEventHandler("selectInteriorClick", getRootElement(), function(button, state, absoluteX, absoluteY, el)
  if buttons[el] then
    selectedInterior = buttons[el]
    drawInteriors()
  end
end)
function interiorsScrollKey(key, por)
  if interiorMenuDrawn and 0 < maxIntiOffset then
    if key == "mouse_wheel_up" then
      if 0 < intiOffset then
        intiOffset = intiOffset - 1
        drawInteriorsSideMenu()
      end
    elseif key == "mouse_wheel_down" and intiOffset < maxIntiOffset then
      intiOffset = intiOffset + 1
      drawInteriorsSideMenu()
    end
  end
end
local sideMenu = {}
local sh = false
local scrollbar = false
local menuW = false
function drawInteriorsSideMenu()
  if #interiorRenderList > 10 then
    local sw = menuW - dashboardPadding[3] - 2
    seexports.rl_gui:setGuiPosition(scrollbar, sw + 1, 1 + sh * intiOffset)
  end
  for i = 1, 10 do
    if interiorRenderList[i + intiOffset] then
      if selectedInterior == i + intiOffset then
        seexports.rl_gui:setGuiBackground(sideMenu[i][1], "solid", "v4green")
        seexports.rl_gui:setGuiHoverable(sideMenu[i][1], false)
        seexports.rl_gui:setClickEvent(sideMenu[i][1], false)
      else
        seexports.rl_gui:setGuiBackground(sideMenu[i][1], "solid", "v4grey1")
        seexports.rl_gui:setGuiHoverable(sideMenu[i][1], true)
        seexports.rl_gui:setClickEvent(sideMenu[i][1], "selectInteriorClick")
      end
      if interiorRenderList[i + intiOffset].theType == "interior" then
        seexports.rl_gui:setLabelText(sideMenu[i][2], interiorRenderList[i + intiOffset].data.name)
        seexports.rl_gui:setLabelText(sideMenu[i][3], "#" .. interiorRenderList[i + intiOffset].data.interiorId)
        buttons[sideMenu[i][1]] = i + intiOffset
        seexports.rl_gui:setLabelText(sideMenu[i][4], seexports.rl_interiors:getInteriorTypeName(interiorRenderList[i + intiOffset].data.type, selectedInterior == i + intiOffset))
      elseif interiorRenderList[i + intiOffset].theType == "farm" then
        seexports.rl_gui:setLabelText(sideMenu[i][2], interiorRenderList[i + intiOffset].data.name)
        seexports.rl_gui:setLabelText(sideMenu[i][3], "#" .. interiorRenderList[i + intiOffset].data.id)
        buttons[sideMenu[i][1]] = i + intiOffset
        if selectedInterior == i + intiOffset then
          seexports.rl_gui:setLabelText(sideMenu[i][4], "Farm")
        else
          seexports.rl_gui:setLabelText(sideMenu[i][4], "[color=v4yellow]Farm")
        end
      elseif interiorRenderList[i + intiOffset].theType == "otherRentable" then
        seexports.rl_gui:setLabelText(sideMenu[i][2], interiorRenderList[i + intiOffset].data.name)
        seexports.rl_gui:setLabelText(sideMenu[i][3], "#" .. interiorRenderList[i + intiOffset].data.id)
        buttons[sideMenu[i][1]] = i + intiOffset
        local typeText = interiorRenderList[i + intiOffset].data.type == "workshop" and "Fényezőműhely" or "Bérelhető garázs"
        if selectedInterior == i + intiOffset then
          seexports.rl_gui:setLabelText(sideMenu[i][4], typeText)
        else
          seexports.rl_gui:setLabelText(sideMenu[i][4], "[color=v4purple]" .. typeText)
        end
      end
    elseif sideMenu[i] then
      seexports.rl_gui:setGuiBackground(sideMenu[i][1], "solid", "v4grey1")
      seexports.rl_gui:setGuiHoverable(sideMenu[i][1], false)
      seexports.rl_gui:setClickEvent(sideMenu[i][1], false)
    end
  end
end
function drawInteriors()
  if buyingRect then
    seexports.rl_gui:deleteGuiElement(buyingRect)
  end
  buyingRect = false
  if buyingWindow then
    seexports.rl_gui:deleteGuiElement(buyingWindow)
    seexports.rl_gui:lockHover(rtg, false)
    seexports.rl_gui:lockHover(closeButton, false)
    seexports.rl_gui:lockHover(helpIcon, false)
  end
  buyingWindow = false
  buyingInteriorSlot = false
  menuW = math.floor(sx * 0.27)
  local h = (sy - 32) / 10
  if inside then
    seexports.rl_gui:deleteGuiElement(inside)
  end
  inside = seexports.rl_gui:createGuiElement("null", 0, 0, sx, sy, rtg)
  local rect = seexports.rl_gui:createGuiElement("rectangle", menuW, 0, sx - menuW, sy, inside)
  seexports.rl_gui:setGuiBackground(rect, "solid", "v4grey2")
  local rect = seexports.rl_gui:createGuiElement("rectangle", 0, sy - 32, menuW, 32, inside)
  seexports.rl_gui:setGuiBackground(rect, "solid", "v4grey3")
  maxIntiOffset = 0
  if 10 < #interiorRenderList then
    maxIntiOffset = #interiorRenderList - 10
    menuW = menuW - dashboardPadding[3] - 2
    local rect = seexports.rl_gui:createGuiElement("rectangle", menuW, 0, dashboardPadding[3] + 2, sy - 32, inside)
    seexports.rl_gui:setGuiBackground(rect, "solid", "v4grey3")
    sh = (sy - 32) / (#interiorRenderList - 10 + 1)
    scrollbar = seexports.rl_gui:createGuiElement("rectangle", menuW + 1, 1 + sh * intiOffset, dashboardPadding[3], sh - 2, inside)
    seexports.rl_gui:setGuiBackground(scrollbar, "solid", "v4green")
  end
  buttons = {}
  for i = 1, 10 do
    if interiorRenderList[i + intiOffset] then
      sideMenu[i] = {}
      sideMenu[i][1] = seexports.rl_gui:createGuiElement("rectangle", 0, (i - 1) * h, menuW, h, inside)
      seexports.rl_gui:setGuiHover(sideMenu[i][1], "gradient", {"v4grey2", "v4grey1"}, false, true)
      local w = 100
      sideMenu[i][2] = seexports.rl_gui:createGuiElement("label", dashboardPadding[3] * 3, dashboardPadding[3] * 3, menuW - dashboardPadding[3] * 3, h, sideMenu[i][1])
      seexports.rl_gui:setLabelFont(sideMenu[i][2], "19/BebasNeueRegular.otf")
      seexports.rl_gui:setLabelAlignment(sideMenu[i][2], "left", "top")
      seexports.rl_gui:setLabelClip(sideMenu[i][2], true)
      seexports.rl_gui:setLabelText(sideMenu[i][2], "")
      local y = dashboardPadding[3] * 3 + seexports.rl_gui:getLabelFontHeight(sideMenu[i][2])
      sideMenu[i][3] = seexports.rl_gui:createGuiElement("label", dashboardPadding[3] * 3, y, menuW, h, sideMenu[i][1])
      seexports.rl_gui:setLabelFont(sideMenu[i][3], "11/Ubuntu-R.ttf")
      seexports.rl_gui:setLabelAlignment(sideMenu[i][3], "left", "top")
      seexports.rl_gui:setLabelText(sideMenu[i][3], "")
      sideMenu[i][4] = seexports.rl_gui:createGuiElement("label", menuW - dashboardPadding[3] * 3 - w, y, w, h, sideMenu[i][1])
      seexports.rl_gui:setLabelFont(sideMenu[i][4], "11/Ubuntu-R.ttf")
      seexports.rl_gui:setLabelAlignment(sideMenu[i][4], "right", "top")
      seexports.rl_gui:setLabelText(sideMenu[i][4], "")
    end
  end
  local label = seexports.rl_gui:createGuiElement("label", 0, sy - 32, menuW * 0.7, 32, inside)
  seexports.rl_gui:setLabelFont(label, "11/Ubuntu-L.ttf")
  seexports.rl_gui:setLabelAlignment(label, "center", "center")
  seexports.rl_gui:setLabelText(label, "Interior yuvası: " .. interiorNum .. "/" .. interiorLimit)
  local btn = seexports.rl_gui:createGuiElement("button", menuW * 0.7 + dashboardPadding[3], sy - 32 + dashboardPadding[3], menuW * 0.3 - dashboardPadding[3] * 2, 32 - dashboardPadding[3] * 2, inside)
  seexports.rl_gui:setGuiBackground(btn, "solid", "v4blue")
  seexports.rl_gui:setGuiHover(btn, "gradient", {
    "v4blue",
    "v4blue-second"
  })
  seexports.rl_gui:setButtonFont(btn, "13/BebasNeueBold.otf")
  seexports.rl_gui:setButtonTextColor(btn, "#ffffff")
  seexports.rl_gui:setButtonText(btn, "Slot vásárlás")
  seexports.rl_gui:setClickEvent(btn, "buyInteriorSlot")
  if 10 < #interiorRenderList then
    menuW = menuW + dashboardPadding[3] + 2
  end
  drawInteriorsSideMenu()
  if interiorRenderList[selectedInterior] then
    if interiorRenderList[selectedInterior].theType == "interior" then
      local label = seexports.rl_gui:createGuiElement("label", menuW + dashboardPadding[3] * 4, 0, sx - menuW - dashboardPadding[3] * 8, 64, inside)
      seexports.rl_gui:setLabelFont(label, "24/BebasNeueRegular.otf")
      seexports.rl_gui:setLabelAlignment(label, "left", "center")
      seexports.rl_gui:setLabelColor(label, "v4green")
      seexports.rl_gui:setLabelText(label, "[" .. interiorRenderList[selectedInterior].data.interiorId .. "] " .. interiorRenderList[selectedInterior].data.name)
      local label = seexports.rl_gui:createGuiElement("label", menuW + dashboardPadding[3] * 4, 64, sx - menuW - dashboardPadding[3] * 8, 128, inside)
      seexports.rl_gui:setLabelFont(label, "12/Ubuntu-L.ttf")
      seexports.rl_gui:setLabelAlignment(label, "left", "center")
      local intiType = seexports.rl_interiors:getInteriorTypeName(interiorRenderList[selectedInterior].data.type)
      local locked = seexports.rl_gui:getColorCodeHex("v4red") .. "nem"
      if interiorRenderList[selectedInterior].data.locked then
        locked = seexports.rl_gui:getColorCodeHex("v4green") .. "igen"
      end
      local editable = seexports.rl_gui:getColorCodeHex("v4red") .. "nem"
      if interiorRenderList[selectedInterior].data.editable ~= "N" then
        editable = seexports.rl_gui:getColorCodeHex("v4green") .. interiorRenderList[selectedInterior].data.editable
      end
      --[[
        editable false / true
        report {0, 1, 2}
      ]]
      local report = "[color=v4red]nem"
      if interiorRenderList[selectedInterior].data.report then
        report = "[color=v4green]igen"
        if interiorRenderList[selectedInterior].data.report == 2 then
          report = "[color=v4green]örök"
        end
      end
      seexports.rl_gui:setLabelText(label, "Típus: " .. intiType .. "#ffffff\nZárva: " .. locked .. "#ffffff\nSzerkeszthető: " .. editable .. [[

#FFFFFFBejelentve: ]] .. report)
      if interiorRenderList[selectedInterior].data.type ~= "rentable" and interiorRenderList[selectedInterior].data.rentedGarage == 0 then
        local btn = seexports.rl_gui:createGuiElement("button", menuW + dashboardPadding[3] * 4, 192, 256, 30, inside)
        seexports.rl_gui:setGuiBackground(btn, "solid", "v4green")
        seexports.rl_gui:setGuiHover(btn, "gradient", {
          "v4green",
          "v4green-second"
        })
        seexports.rl_gui:setButtonFont(btn, "13/BebasNeueBold.otf")
        seexports.rl_gui:setButtonTextColor(btn, "#ffffff")
        seexports.rl_gui:setButtonText(btn, "Eladás")
        seexports.rl_gui:setClickEvent(btn, "startInteriorSell")
      end
      local btn = seexports.rl_gui:createGuiElement("button", menuW + dashboardPadding[3] * 4, 222 + dashboardPadding[3] * 4, 256, 30, inside)
      seexports.rl_gui:setGuiBackground(btn, "solid", "v4blue")
      seexports.rl_gui:setGuiHover(btn, "gradient", {
        "v4blue",
        "v4blue-second"
      })
      seexports.rl_gui:setButtonFont(btn, "13/BebasNeueBold.otf")
      seexports.rl_gui:setButtonTextColor(btn, "#ffffff")
      seexports.rl_gui:setButtonText(btn, "Megjelölés térképen")
      seexports.rl_gui:setClickEvent(btn, "markIntiOnMap")
      local px, py = menuW + dashboardPadding[3] * 4, 240 + dashboardPadding[3] * 8 + dashboardPadding[3] * 4
      local pw, ph = sx - menuW - dashboardPadding[3] * 8, sy - (240 + dashboardPadding[3] * 8 + dashboardPadding[3] * 8)
      local rx, ry = unpack(interiorRenderList[selectedInterior].data.outside)
      local map = seexports.rl_gui:createGuiElement("radar", px, py, pw, ph, inside)
      seexports.rl_gui:setRadarCoords(map, rx, ry, 128)
      local img = seexports.rl_gui:createGuiElement("image", px, py, 32, 32, inside)
      seexports.rl_gui:setImageDDS(img, ":rl_dashboard/files/mapcorner.dds")
      seexports.rl_gui:setImageColor(img, "v4grey2")
      local img = seexports.rl_gui:createGuiElement("image", px + pw, py, -32, 32, inside)
      seexports.rl_gui:setImageDDS(img, ":rl_dashboard/files/mapcorner.dds")
      seexports.rl_gui:setImageColor(img, "v4grey2")
      local img = seexports.rl_gui:createGuiElement("image", px + 32, py, pw - 64, 32, inside)
      seexports.rl_gui:setImageDDS(img, ":rl_dashboard/files/mapside.dds")
      seexports.rl_gui:setImageColor(img, "v4grey2")
      seexports.rl_gui:setImageUV(img, 0, 0, pw - 64, 32)
      local img = seexports.rl_gui:createGuiElement("image", px, py + ph, 32, -32, inside)
      seexports.rl_gui:setImageDDS(img, ":rl_dashboard/files/mapcorner.dds")
      seexports.rl_gui:setImageColor(img, "v4grey2")
      local img = seexports.rl_gui:createGuiElement("image", px + pw, py + ph, -32, -32, inside)
      seexports.rl_gui:setImageDDS(img, ":rl_dashboard/files/mapcorner.dds")
      seexports.rl_gui:setImageColor(img, "v4grey2")
      local img = seexports.rl_gui:createGuiElement("image", px + 32, py + ph, pw - 64, -32, inside)
      seexports.rl_gui:setImageDDS(img, ":rl_dashboard/files/mapside.dds")
      seexports.rl_gui:setImageColor(img, "v4grey2")
      seexports.rl_gui:setImageUV(img, 0, 0, pw - 64, 32)
      local img = seexports.rl_gui:createGuiElement("image", px, py + 32, 32, ph - 64, inside)
      seexports.rl_gui:setImageDDS(img, ":rl_dashboard/files/mapside2.dds")
      seexports.rl_gui:setImageColor(img, "v4grey2")
      seexports.rl_gui:setImageUV(img, 0, 0, 32, ph - 64)
      local img = seexports.rl_gui:createGuiElement("image", px + pw, py + 32, -32, ph - 64, inside)
      seexports.rl_gui:setImageDDS(img, ":rl_dashboard/files/mapside2.dds")
      seexports.rl_gui:setImageColor(img, "v4grey2")
      seexports.rl_gui:setImageUV(img, 0, 0, 32, ph - 64)
      local cross = seexports.rl_gui:createGuiElement("image", px + pw / 2 - 16, py + ph / 2 - 16, 32, 32, inside)
      if interiorRenderList[selectedInterior].data.type == "house" then
        seexports.rl_gui:setImageFile(cross, seexports.rl_gui:getFaIconFilename("home", 32, "solid", false, seexports.rl_gui:getColorCodeToColor("v4grey2"), seexports.rl_gui:getColorCodeToColor("v4blue")))
      elseif interiorRenderList[selectedInterior].data.type == "business" then
        seexports.rl_gui:setImageFile(cross, seexports.rl_gui:getFaIconFilename("dollar-sign", 32, "solid", false, seexports.rl_gui:getColorCodeToColor("v4grey2"), seexports.rl_gui:getColorCodeToColor("v4green")))
      elseif interiorRenderList[selectedInterior].data.type == "garage" or interiorRenderList[selectedInterior].data.type == "garage2" then
        seexports.rl_gui:setImageFile(cross, seexports.rl_gui:getFaIconFilename("garage", 32, "solid", false, seexports.rl_gui:getColorCodeToColor("v4grey2"), seexports.rl_gui:getColorCodeToColor("v4blue-second")))
      elseif interiorRenderList[selectedInterior].data.type == "rentable" then
        seexports.rl_gui:setImageFile(cross, seexports.rl_gui:getFaIconFilename("hotel", 32, "solid", false, seexports.rl_gui:getColorCodeToColor("v4grey2"), seexports.rl_gui:getColorCodeToColor("v4purple")))
      elseif interiorRenderList[selectedInterior].data.type == "lift" or interiorRenderList[selectedInterior].data.type == "stairs" then
        seexports.rl_gui:setImageFile(cross, seexports.rl_gui:getFaIconFilename("sort-circle-up", 32, "solid", false, seexports.rl_gui:getColorCodeToColor("v4grey2"), seexports.rl_gui:getColorCodeToColor("hudwhite")))
      elseif interiorRenderList[selectedInterior].data.type == "door" then
        seexports.rl_gui:setImageFile(cross, seexports.rl_gui:getFaIconFilename("door-closed", 32, "solid", false, seexports.rl_gui:getColorCodeToColor("v4grey2"), seexports.rl_gui:getColorCodeToColor("hudwhite")))
      else
        seexports.rl_gui:setImageFile(cross, seexports.rl_gui:getFaIconFilename("question", 32, "solid", false, seexports.rl_gui:getColorCodeToColor("v4grey2"), seexports.rl_gui:getColorCodeToColor("v4yellow")))
      end
    elseif interiorRenderList[selectedInterior].theType == "farm" then
      local label = seexports.rl_gui:createGuiElement("label", menuW + dashboardPadding[3] * 4, 0, sx - menuW - dashboardPadding[3] * 8, 64, inside)
      seexports.rl_gui:setLabelFont(label, "24/BebasNeueRegular.otf")
      seexports.rl_gui:setLabelAlignment(label, "left", "center")
      seexports.rl_gui:setLabelColor(label, "v4green")
      seexports.rl_gui:setLabelText(label, "[" .. interiorRenderList[selectedInterior].data.id .. "] " .. interiorRenderList[selectedInterior].data.name)
      local label = seexports.rl_gui:createGuiElement("label", menuW + dashboardPadding[3] * 4, 64, sx - menuW - dashboardPadding[3] * 8, 128, inside)
      seexports.rl_gui:setLabelFont(label, "12/Ubuntu-L.ttf")
      seexports.rl_gui:setLabelAlignment(label, "left", "center")
      local lock = "[color=v4red]nem"
      if interiorRenderList[selectedInterior].data.locked then
        lock = "[color=v4green]igen"
      end
      local expire = interiorRenderList[selectedInterior].data.expire
      local typeStr = "[color=v4yellow]nincs kiválasztva"
      if interiorRenderList[selectedInterior].data.type == 1 then
        typeStr = "[color=v4green]növénytermesztés"
      elseif interiorRenderList[selectedInterior].data.type == 2 then
        typeStr = "[color=v4green]állattenyésztés"
      end
      seexports.rl_gui:setLabelText(label, "Típus: " .. "[color=v4yellow]farm\n#ffffffFarm típusa: " .. typeStr .. "#ffffff\nZárva: " .. lock .. "#ffffff\nLejár: [color=v4blue]" .. expire)
      local btn = seexports.rl_gui:createGuiElement("button", menuW + dashboardPadding[3] * 4, 222 + dashboardPadding[3] * 4, 256, 30, inside)
      seexports.rl_gui:setGuiBackground(btn, "solid", "v4blue")
      seexports.rl_gui:setGuiHover(btn, "gradient", {
        "v4blue",
        "v4blue-second"
      })
      seexports.rl_gui:setButtonFont(btn, "13/BebasNeueBold.otf")
      seexports.rl_gui:setButtonTextColor(btn, "#ffffff")
      seexports.rl_gui:setButtonText(btn, "Megjelölés térképen")
      seexports.rl_gui:setClickEvent(btn, "markIntiOnMap")
      local px, py = menuW + dashboardPadding[3] * 4, 240 + dashboardPadding[3] * 8 + dashboardPadding[3] * 4
      local pw, ph = sx - menuW - dashboardPadding[3] * 8, sy - (240 + dashboardPadding[3] * 8 + dashboardPadding[3] * 8)
      local rx, ry = unpack(interiorRenderList[selectedInterior].data.pos)
      local map = seexports.rl_gui:createGuiElement("radar", px, py, pw, ph, inside)
      seexports.rl_gui:setRadarCoords(map, rx, ry, 128)
      local img = seexports.rl_gui:createGuiElement("image", px, py, 32, 32, inside)
      seexports.rl_gui:setImageDDS(img, ":rl_dashboard/files/mapcorner.dds")
      seexports.rl_gui:setImageColor(img, "v4grey2")
      local img = seexports.rl_gui:createGuiElement("image", px + pw, py, -32, 32, inside)
      seexports.rl_gui:setImageDDS(img, ":rl_dashboard/files/mapcorner.dds")
      seexports.rl_gui:setImageColor(img, "v4grey2")
      local img = seexports.rl_gui:createGuiElement("image", px + 32, py, pw - 64, 32, inside)
      seexports.rl_gui:setImageDDS(img, ":rl_dashboard/files/mapside.dds")
      seexports.rl_gui:setImageColor(img, "v4grey2")
      seexports.rl_gui:setImageUV(img, 0, 0, pw - 64, 32)
      local img = seexports.rl_gui:createGuiElement("image", px, py + ph, 32, -32, inside)
      seexports.rl_gui:setImageDDS(img, ":rl_dashboard/files/mapcorner.dds")
      seexports.rl_gui:setImageColor(img, "v4grey2")
      local img = seexports.rl_gui:createGuiElement("image", px + pw, py + ph, -32, -32, inside)
      seexports.rl_gui:setImageDDS(img, ":rl_dashboard/files/mapcorner.dds")
      seexports.rl_gui:setImageColor(img, "v4grey2")
      local img = seexports.rl_gui:createGuiElement("image", px + 32, py + ph, pw - 64, -32, inside)
      seexports.rl_gui:setImageDDS(img, ":rl_dashboard/files/mapside.dds")
      seexports.rl_gui:setImageColor(img, "v4grey2")
      seexports.rl_gui:setImageUV(img, 0, 0, pw - 64, 32)
      local img = seexports.rl_gui:createGuiElement("image", px, py + 32, 32, ph - 64, inside)
      seexports.rl_gui:setImageDDS(img, ":rl_dashboard/files/mapside2.dds")
      seexports.rl_gui:setImageColor(img, "v4grey2")
      seexports.rl_gui:setImageUV(img, 0, 0, 32, ph - 64)
      local img = seexports.rl_gui:createGuiElement("image", px + pw, py + 32, -32, ph - 64, inside)
      seexports.rl_gui:setImageDDS(img, ":rl_dashboard/files/mapside2.dds")
      seexports.rl_gui:setImageColor(img, "v4grey2")
      seexports.rl_gui:setImageUV(img, 0, 0, 32, ph - 64)
      local cross = seexports.rl_gui:createGuiElement("image", px + pw / 2 - 16, py + ph / 2 - 16, 32, 32, inside)
      seexports.rl_gui:setImageFile(cross, seexports.rl_gui:getFaIconFilename("farm", 32, "solid", false, seexports.rl_gui:getColorCodeToColor("v4grey2"), seexports.rl_gui:getColorCodeToColor("v4yellow")))
    elseif interiorRenderList[selectedInterior].theType == "otherRentable" then
      local label = seexports.rl_gui:createGuiElement("label", menuW + dashboardPadding[3] * 4, 0, sx - menuW - dashboardPadding[3] * 8, 64, inside)
      seexports.rl_gui:setLabelFont(label, "24/BebasNeueRegular.otf")
      seexports.rl_gui:setLabelAlignment(label, "left", "center")
      seexports.rl_gui:setLabelColor(label, "v4green")
      seexports.rl_gui:setLabelText(label, "[" .. interiorRenderList[selectedInterior].data.id .. "] " .. interiorRenderList[selectedInterior].data.name)
      local label = seexports.rl_gui:createGuiElement("label", menuW + dashboardPadding[3] * 4, 64, sx - menuW - dashboardPadding[3] * 8, 128, inside)
      seexports.rl_gui:setLabelFont(label, "12/Ubuntu-L.ttf")
      seexports.rl_gui:setLabelAlignment(label, "left", "center")
      local lock = "[color=v4red]nem"
      if interiorRenderList[selectedInterior].data.locked then
        lock = "[color=v4green]igen"
      end
      local location = "[color=v4blue]" .. interiorRenderList[selectedInterior].data.locationName
      local lock = "[color=v4red]nem"
      if interiorRenderList[selectedInterior].data.locked then
        lock = "[color=v4green]igen"
      end
      local typeText = "Egyéb"
      if interiorRenderList[selectedInterior].data.type == "workshop" then
        typeText = "Fényezőműhely"
      elseif interiorRenderList[selectedInterior].data.type == "garage" then
        typeText = "Bérelhető garázs"
      end
      local time = getRealTime(interiorRenderList[selectedInterior].data.rentUntil)
      local expire = string.format("%04d. %02d. %02d. %02d:%02d:%02d", time.year + 1900, time.month + 1, time.monthday, time.hour, time.minute, time.second)
      seexports.rl_gui:setLabelText(label, "Típus: [color=v4purple]" .. typeText .. [[

#FFFFFFHely: ]] .. location .. "\n#FFFFFFZárva: " .. lock .. "\n#FFFFFFLejár: [color=v4blue]" .. expire)
      local btn = seexports.rl_gui:createGuiElement("button", menuW + dashboardPadding[3] * 4, 222 + dashboardPadding[3] * 4, 256, 30, inside)
      seexports.rl_gui:setGuiBackground(btn, "solid", "v4blue")
      seexports.rl_gui:setGuiHover(btn, "gradient", {
        "v4blue",
        "v4blue-second"
      })
      seexports.rl_gui:setButtonFont(btn, "13/BebasNeueBold.otf")
      seexports.rl_gui:setButtonTextColor(btn, "#ffffff")
      seexports.rl_gui:setButtonText(btn, "Megjelölés térképen")
      seexports.rl_gui:setClickEvent(btn, "markIntiOnMap")
      local px, py = menuW + dashboardPadding[3] * 4, 240 + dashboardPadding[3] * 8 + dashboardPadding[3] * 4
      local pw, ph = sx - menuW - dashboardPadding[3] * 8, sy - (240 + dashboardPadding[3] * 8 + dashboardPadding[3] * 8)
      local rx, ry = unpack(interiorRenderList[selectedInterior].data.pos)
      local map = seexports.rl_gui:createGuiElement("radar", px, py, pw, ph, inside)
      seexports.rl_gui:setRadarCoords(map, rx, ry, 128)
      local img = seexports.rl_gui:createGuiElement("image", px, py, 32, 32, inside)
      seexports.rl_gui:setImageDDS(img, ":rl_dashboard/files/mapcorner.dds")
      seexports.rl_gui:setImageColor(img, "v4grey2")
      local img = seexports.rl_gui:createGuiElement("image", px + pw, py, -32, 32, inside)
      seexports.rl_gui:setImageDDS(img, ":rl_dashboard/files/mapcorner.dds")
      seexports.rl_gui:setImageColor(img, "v4grey2")
      local img = seexports.rl_gui:createGuiElement("image", px + 32, py, pw - 64, 32, inside)
      seexports.rl_gui:setImageDDS(img, ":rl_dashboard/files/mapside.dds")
      seexports.rl_gui:setImageColor(img, "v4grey2")
      seexports.rl_gui:setImageUV(img, 0, 0, pw - 64, 32)
      local img = seexports.rl_gui:createGuiElement("image", px, py + ph, 32, -32, inside)
      seexports.rl_gui:setImageDDS(img, ":rl_dashboard/files/mapcorner.dds")
      seexports.rl_gui:setImageColor(img, "v4grey2")
      local img = seexports.rl_gui:createGuiElement("image", px + pw, py + ph, -32, -32, inside)
      seexports.rl_gui:setImageDDS(img, ":rl_dashboard/files/mapcorner.dds")
      seexports.rl_gui:setImageColor(img, "v4grey2")
      local img = seexports.rl_gui:createGuiElement("image", px + 32, py + ph, pw - 64, -32, inside)
      seexports.rl_gui:setImageDDS(img, ":rl_dashboard/files/mapside.dds")
      seexports.rl_gui:setImageColor(img, "v4grey2")
      seexports.rl_gui:setImageUV(img, 0, 0, pw - 64, 32)
      local img = seexports.rl_gui:createGuiElement("image", px, py + 32, 32, ph - 64, inside)
      seexports.rl_gui:setImageDDS(img, ":rl_dashboard/files/mapside2.dds")
      seexports.rl_gui:setImageColor(img, "v4grey2")
      seexports.rl_gui:setImageUV(img, 0, 0, 32, ph - 64)
      local img = seexports.rl_gui:createGuiElement("image", px + pw, py + 32, -32, ph - 64, inside)
      seexports.rl_gui:setImageDDS(img, ":rl_dashboard/files/mapside2.dds")
      seexports.rl_gui:setImageColor(img, "v4grey2")
      seexports.rl_gui:setImageUV(img, 0, 0, 32, ph - 64)
      local cross = seexports.rl_gui:createGuiElement("image", px + pw / 2 - 16, py + ph / 2 - 16, 32, 32, inside)
      seexports.rl_gui:setImageFile(cross, seexports.rl_gui:getFaIconFilename("industry-alt", 32, "solid", false, seexports.rl_gui:getColorCodeToColor("v4grey2"), seexports.rl_gui:getColorCodeToColor("v4purple")))
    end
  end
end
local buyingRect = false
local buyingWindow = false
buyingInteriorSlot = false
interiorMenuDrawn = false
local playerButtons = {}
local sellInput
sellingInteriorTo = false
function interiorsInsideDestroy()
  inside = false
  interiorMenuDrawn = false
  removeEventHandler("onClientKey", getRootElement(), interiorsScrollKey)
  if buyingRect then
    seexports.rl_gui:deleteGuiElement(buyingRect)
  end
  buyingRect = false
  if buyingWindow then
    seexports.rl_gui:deleteGuiElement(buyingWindow)
    seexports.rl_gui:lockHover(closeButton, false)
    seexports.rl_gui:lockHover(helpIcon, false)
  end
  buyingWindow = false
  buyingInteriorSlot = false
end
function interiorsInsideDraw(x, y, isx, isy, i, j, irtg)
  rtg = irtg
  sx, sy = isx, isy
  intiOffset = 0
  selectedInterior = 1
  interiorMenuDrawn = true
  addEventHandler("onClientKey", getRootElement(), interiorsScrollKey)
  drawInteriors()
end
local currentAmount = 0
local buyingLabel = 0
local sellingWindow = false
addEvent("endIntiSell", true)
addEventHandler("endIntiSell", getRootElement(), function()
  if sellingWindow then
    seexports.rl_gui:deleteGuiElement(sellingWindow)
    sellingWindow = false
  end
end)
addEvent("changeInteriorSlotAmount", true)
addEventHandler("changeInteriorSlotAmount", getRootElement(), function(value)
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
  seexports.rl_gui:setLabelText(buyingLabel, "Prémium egyenleged: " .. seexports.rl_gui:getColorCodeHex("v4blue") .. "" .. seexports.rl_gui:thousandsStepper(ppBalance) .. " PP #ffffff\nFizetendő: " .. seexports.rl_gui:getColorCodeHex("v4blue") .. "" .. seexports.rl_gui:thousandsStepper(currentAmount * intiSlotPrice) .. " PP")
end)
addEvent("finalSellInterior", true)
addEventHandler("finalSellInterior", getRootElement(), function()
  local interior = interiorRenderList[selectedInterior]
  local interiorDatas = interior.data
  if sellingInteriorTo and isElement(sellingInteriorTo) and interior and interiorDatas.interiorId then
    local price = tonumber(seexports.rl_gui:getInputValue(sellInput))
    if 500 <= price then
      triggerEvent("gotInteriorSellPaper", localPlayer, {
        "buyer",
        true,
        getElementData(localPlayer, "visibleName"):gsub("_", " "),
        getElementData(sellingInteriorTo, "visibleName"):gsub("_", " "),
        seexports.rl_interiors:getInteriorName(interiorDatas.interiorId),
        interiorDatas.interiorId,
        seexports.rl_interiors:getInteriorTypeName(interiorDatas.type, true),
        price,
        getRealTime().timestamp,
        math.floor(price * 0.025),
        sellingInteriorTo,
        price
      })
      triggerServerEvent("tryToSellInterior", sellingInteriorTo, {
        "buyer",
        true,
        getElementData(localPlayer, "visibleName"):gsub("_", " "),
        getElementData(sellingInteriorTo, "visibleName"):gsub("_", " "),
        seexports.rl_interiors:getInteriorName(interiorDatas.interiorId),
        interiorDatas.interiorId,
        seexports.rl_interiors:getInteriorTypeName(interiorDatas.type, true),
        price,
        getRealTime().timestamp,
        math.floor(price * 0.025),
        sellingInteriorTo,
        price,
        localPlayer
      })
      if buyingWindow then
        seexports.rl_gui:deleteGuiElement(buyingWindow)
        seexports.rl_gui:lockHover(rtg, false)
        seexports.rl_gui:lockHover(closeButton, false)
        seexports.rl_gui:lockHover(helpIcon, false)
      end
      buyingWindow = false
      return
    else
      seexports.rl_gui:showInfobox("e", "A minimum eladási összeg 500$!")
      return
    end
  end
  buyingLabel = false
  sellingInteriorTo = false
  sellInput = false
  if buyingRect then
    seexports.rl_gui:deleteGuiElement(buyingRect)
  end
  buyingRect = false
  if buyingWindow then
    seexports.rl_gui:deleteGuiElement(buyingWindow)
    seexports.rl_gui:lockHover(rtg, false)
    seexports.rl_gui:lockHover(closeButton, false)
    seexports.rl_gui:lockHover(helpIcon, false)
  end
  buyingWindow = false
  buyingInteriorSlot = false
end)
addEvent("selectIntiSellPlayer", true)
addEventHandler("selectIntiSellPlayer", getRootElement(), function(button, state, absoluteX, absoluteY, el)
  if playerButtons[el] and isElement(playerButtons[el]) then
    sellingInteriorTo = playerButtons[el]
    local titleBarHeight = seexports.rl_gui:getTitleBarHeight()
    local panelWidth = 300
    local panelHeight = titleBarHeight + 5 + 70 + 32 + 5 + 64
    if buyingWindow then
      seexports.rl_gui:deleteGuiElement(buyingWindow)
    end
    buyingWindow = seexports.rl_gui:createGuiElement("window", screenX / 2 - panelWidth / 2, screenY / 2 - panelHeight / 2, panelWidth, panelHeight)
    seexports.rl_gui:setWindowTitle(buyingWindow, "16/BebasNeueRegular.otf", "Ingatlan eladás")
    local label = seexports.rl_gui:createGuiElement("label", 5, titleBarHeight, panelWidth - 10, 64, buyingWindow)
    seexports.rl_gui:setLabelFont(label, "11/Ubuntu-R.ttf")
    seexports.rl_gui:setLabelAlignment(label, "center", "center")
    seexports.rl_gui:setLabelText(label, "Ingatlan: " .. seexports.rl_gui:getColorCodeHex("v4green") .. interiorRenderList[selectedInterior].data.name .. " [" .. interiorRenderList[selectedInterior].data.interiorId .. "]\n#ffffffVevő: " .. seexports.rl_gui:getColorCodeHex("v4green") .. getElementData(sellingInteriorTo, "visibleName"):gsub("_", " "))
    sellInput = seexports.rl_gui:createGuiElement("input", 5, titleBarHeight + 5 + 64, panelWidth - 10, 32, buyingWindow)
    seexports.rl_gui:setInputFont(sellInput, "11/Ubuntu-R.ttf")
    seexports.rl_gui:setInputIcon(sellInput, "coins")
    seexports.rl_gui:setInputPlaceholder(sellInput, "Eladási ár")
    seexports.rl_gui:setInputMaxLength(sellInput, 20)
    seexports.rl_gui:setInputNumberOnly(sellInput, true)
    local btn = seexports.rl_gui:createGuiElement("button", 5, panelHeight - 70, panelWidth - 10, 30, buyingWindow)
    seexports.rl_gui:setGuiBackground(btn, "solid", "v4green")
    seexports.rl_gui:setGuiHover(btn, "gradient", {
      "v4green",
      "v4green-second"
    })
    seexports.rl_gui:setButtonFont(btn, "15/BebasNeueBold.otf")
    seexports.rl_gui:setButtonTextColor(btn, "#ffffff")
    seexports.rl_gui:setButtonText(btn, "Eladás")
    seexports.rl_gui:setClickEvent(btn, "finalSellInterior", false)
    local btn = seexports.rl_gui:createGuiElement("button", 5, panelHeight - 35, panelWidth - 10, 30, buyingWindow)
    seexports.rl_gui:setGuiBackground(btn, "solid", "v4red")
    seexports.rl_gui:setGuiHover(btn, "gradient", {
      "v4red",
      "v4red-second"
    })
    seexports.rl_gui:setButtonFont(btn, "15/BebasNeueBold.otf")
    seexports.rl_gui:setButtonTextColor(btn, "#ffffff")
    seexports.rl_gui:setButtonText(btn, "Mégsem")
    seexports.rl_gui:setClickEvent(btn, "closeIntiSlotBuy", false)
  else
    buyingLabel = false
    sellingInteriorTo = false
    sellInput = false
    if buyingRect then
      seexports.rl_gui:deleteGuiElement(buyingRect)
    end
    buyingRect = false
    if buyingWindow then
      seexports.rl_gui:deleteGuiElement(buyingWindow)
      seexports.rl_gui:lockHover(rtg, false)
      seexports.rl_gui:lockHover(closeButton, false)
      seexports.rl_gui:lockHover(helpIcon, false)
    end
    buyingWindow = false
    buyingInteriorSlot = false
  end
end)
addEvent("startInteriorSell", true)
addEventHandler("startInteriorSell", getRootElement(), function()
  if interiorRenderList[selectedInterior] then
    local data = interiorRenderList[selectedInterior].data
    local rx, ry, rz = seexports.rl_interiors:getInteriorOutsidePosition(data.interiorId)
    local px, py, pz = getElementPosition(localPlayer)
    local dist = getDistanceBetweenPoints3D(rx, ry, rz, px, py, pz)
    if dist < 15 then
      local playerList = {}
      local players = getElementsByType("player", getRootElement(), true)
      for i = 1, #players do
        if players[i] ~= localPlayer then
          local px2, py2, pz2 = getElementPosition(players[i])
          local dist = getDistanceBetweenPoints3D(px2, py2, pz2, px, py, pz)
          if dist < 5 then
            table.insert(playerList, players[i])
          end
        end
      end
      if #playerList < 1 then
        seexports.rl_gui:showInfobox("e", "Nincs senki a közeledben!")
      else
        if buyingRect then
          seexports.rl_gui:deleteGuiElement(buyingRect)
        end
        buyingRect = false
        if buyingWindow then
          seexports.rl_gui:deleteGuiElement(buyingWindow)
          seexports.rl_gui:lockHover(rtg, false)
          seexports.rl_gui:lockHover(closeButton, false)
          seexports.rl_gui:lockHover(helpIcon, false)
        end
        buyingWindow = false
        local titleBarHeight = seexports.rl_gui:getTitleBarHeight()
        local panelWidth = 250
        local panelHeight = titleBarHeight + 5 + 30 + 5 + 35 * #playerList
        seexports.rl_gui:lockHover(rtg, true)
        seexports.rl_gui:lockHover(closeButton, true)
        seexports.rl_gui:lockHover(helpIcon, true)
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
        seexports.rl_gui:setWindowTitle(buyingWindow, "16/BebasNeueRegular.otf", "Válassz játékost!")
        local y = titleBarHeight + 5
        playerButtons = {}
        for i = 1, #playerList do
          local btn = seexports.rl_gui:createGuiElement("button", 5, y, panelWidth - 10, 30, buyingWindow)
          seexports.rl_gui:setGuiBackground(btn, "solid", "v4green")
          seexports.rl_gui:setGuiHover(btn, "gradient", {
            "v4green",
            "v4green-second"
          })
          seexports.rl_gui:setButtonFont(btn, "15/BebasNeueBold.otf")
          seexports.rl_gui:setButtonTextColor(btn, "#ffffff")
          seexports.rl_gui:setButtonText(btn, getElementData(playerList[i], "visibleName"):gsub("_", " "))
          seexports.rl_gui:setClickEvent(btn, "selectIntiSellPlayer", false)
          playerButtons[btn] = playerList[i]
          y = y + 35
        end
        local btn = seexports.rl_gui:createGuiElement("button", 5, panelHeight - 35, panelWidth - 10, 30, buyingWindow)
        seexports.rl_gui:setGuiBackground(btn, "solid", "v4red")
        seexports.rl_gui:setGuiHover(btn, "gradient", {
          "v4red",
          "v4red-second"
        })
        seexports.rl_gui:setButtonFont(btn, "15/BebasNeueBold.otf")
        seexports.rl_gui:setButtonTextColor(btn, "#ffffff")
        seexports.rl_gui:setButtonText(btn, "Mégsem")
        seexports.rl_gui:setClickEvent(btn, "closeIntiSlotBuy", false)
      end
    else
      seexports.rl_gui:showInfobox("e", "Túl messze vagy az adott interior bejáratától!")
    end
  end
end)
addEvent("markIntiOnMap", true)
addEventHandler("markIntiOnMap", getRootElement(), function()
  if interiorRenderList[selectedInterior] then
    if interiorRenderList[selectedInterior].theType == "interior" then
      seexports.rl_interiors:markInteriorOnMap(interiorRenderList[selectedInterior].data.interiorId)
    elseif interiorRenderList[selectedInterior].theType == "farm" then
      seexports.rl_farm:markFarm(interiorRenderList[selectedInterior].data.id)
    elseif interiorRenderList[selectedInterior].theType == "otherRentable" then
      --seexports.rl_paintshop:markGarageDoor(interiorRenderList[selectedInterior].data.id)
    end
  end
end)
addEvent("closeIntiSlotBuy", true)
addEventHandler("closeIntiSlotBuy", getRootElement(), function()
  buyingLabel = false
  sellingInteriorTo = false
  sellInput = false
  if buyingRect then
    seexports.rl_gui:deleteGuiElement(buyingRect)
  end
  buyingRect = false
  if buyingWindow then
    seexports.rl_gui:deleteGuiElement(buyingWindow)
    seexports.rl_gui:lockHover(rtg, false)
    seexports.rl_gui:lockHover(closeButton, false)
    seexports.rl_gui:lockHover(helpIcon, false)
  end
  buyingWindow = false
  buyingInteriorSlot = false
end)
addEvent("finalBuyIntiSlot", true)
addEventHandler("finalBuyIntiSlot", getRootElement(), function()
  if intiSlotPrice * currentAmount > ppBalance then
    seexports.rl_gui:showInfobox("e", "Nincs elég PrémiumPontod!")
  else
    triggerServerEvent("buyInteriorSlot", localPlayer, currentAmount)
    buyingLabel = false
    sellingInteriorTo = false
    sellInput = false
    if buyingRect then
      seexports.rl_gui:deleteGuiElement(buyingRect)
    end
    buyingRect = false
    if buyingWindow then
      seexports.rl_gui:deleteGuiElement(buyingWindow)
      seexports.rl_gui:lockHover(rtg, false)
      seexports.rl_gui:lockHover(closeButton, false)
      seexports.rl_gui:lockHover(helpIcon, false)
    end
    buyingWindow = false
    buyingInteriorSlot = false
  end
end)
addEvent("buyInteriorSlot", true)
addEventHandler("buyInteriorSlot", getRootElement(), function()
  buyingInteriorSlot = true
  local titleBarHeight = seexports.rl_gui:getTitleBarHeight()
  local h = seexports.rl_gui:getFontHeight("14/BebasNeueRegular.otf")
  currentAmount = 0
  local panelWidth = 300
  local panelHeight = titleBarHeight + 5 + h * 1.5 + h * 2 + 30 + 5 + 5 + 5 + 32 + 5
  seexports.rl_gui:lockHover(rtg, true)
  seexports.rl_gui:lockHover(closeButton, true)
  seexports.rl_gui:lockHover(helpIcon, true)
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
  seexports.rl_gui:setWindowTitle(buyingWindow, "16/BebasNeueRegular.otf", "Interior slot vásárlás")
  local y = titleBarHeight + 5
  local label = seexports.rl_gui:createGuiElement("label", 5, y, panelWidth - 5, h * 1.5, buyingWindow)
  seexports.rl_gui:setLabelFont(label, "14/BebasNeueRegular.otf")
  seexports.rl_gui:setLabelAlignment(label, "center", "center")
  seexports.rl_gui:setLabelText(label, intiSlotPrice .. " PP / interior slot")
  y = y + h * 1.5 + 5
  local input = seexports.rl_gui:createGuiElement("input", 32, y, panelWidth - 64, 32, buyingWindow)
  seexports.rl_gui:setInputFont(input, "11/Ubuntu-R.ttf")
  seexports.rl_gui:setInputIcon(input, "boxes")
  seexports.rl_gui:setInputPlaceholder(input, "Mennyiség")
  seexports.rl_gui:setInputMaxLength(input, 5)
  seexports.rl_gui:setInputNumberOnly(input, true)
  seexports.rl_gui:setInputChangeEvent(input, "changeInteriorSlotAmount")
  y = y + 32 + 5
  buyingLabel = seexports.rl_gui:createGuiElement("label", 5, y, panelWidth - 5, h * 2, buyingWindow)
  seexports.rl_gui:setLabelFont(buyingLabel, "11/Ubuntu-R.ttf")
  seexports.rl_gui:setLabelAlignment(buyingLabel, "center", "center")
  seexports.rl_gui:setLabelText(buyingLabel, "Prémium egyenleged: " .. seexports.rl_gui:getColorCodeHex("v4blue") .. "" .. seexports.rl_gui:thousandsStepper(ppBalance) .. " PP #ffffff\nFizetendő: " .. seexports.rl_gui:getColorCodeHex("v4blue") .. "" .. seexports.rl_gui:thousandsStepper(currentAmount * intiSlotPrice) .. " PP")
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
  seexports.rl_gui:setClickEvent(btn, "finalBuyIntiSlot", false)
  local btn = seexports.rl_gui:createGuiElement("button", 10 + btnW, panelHeight - 35, btnW, 30, buyingWindow)
  seexports.rl_gui:setGuiBackground(btn, "solid", "v4red")
  seexports.rl_gui:setGuiHover(btn, "gradient", {
    "v4red",
    "v4red-second"
  })
  seexports.rl_gui:setButtonFont(btn, "15/BebasNeueBold.otf")
  seexports.rl_gui:setButtonTextColor(btn, "#ffffff")
  seexports.rl_gui:setButtonText(btn, "Mégsem")
  seexports.rl_gui:setClickEvent(btn, "closeIntiSlotBuy", false)
end)