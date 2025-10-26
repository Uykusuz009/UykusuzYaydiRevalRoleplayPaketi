local seexports = {rl_gui = false, rl_items = false}
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
local sellInput = false
animalMenuDrawn = false
function animalsInsideDestroy()
  inside = false
  animalMenuDrawn = false
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
  sellingAnimalTo = false
  selectedAnimalToBuy = false
  buyInput = false
  renameInput = false
  sellInput = false
end
local maxAnimalOffset = 0
local animalOffset = 0
selectedAnimal = 1
local sideMenu = {}
local sh = false
local scrollbar = false
local menuW = false
local buttons = {}
renameInput = false
local spawnedAnimal = false
local spawnedPetElement = false
local petDatas = {}
addEventHandler("onClientElementDataChange", getRootElement(), function(data)
  if source == spawnedPetElement or getElementType(source) == "ped" then
    local animalId = getElementData(source, "animal.animalId")
    if animalId then
      local ownerId = getElementData(source, "animal.ownerId")
      if ownerId and ownerId == charId then
        spawnedAnimal = animalId
        spawnedPetElement = source
        petDatas[data] = getElementData(source, data)
        if animalMenuDrawn then
          drawAnimal()
        end
      end
    end
  end
end)
addEventHandler("onClientElementDestroy", getRootElement(), function()
  if getElementType(source) == "ped" and getElementData(source, "animal.animalId") and getElementData(source, "animal.ownerId") == charId then
    spawnedAnimal = false
    spawnedPetElement = false
    petDatas = {}
    if animalMenuDrawn then
      drawAnimal()
    end
  end
end)
local petSpawnTick = 0
addEvent("spawnPet", true)
addEventHandler("spawnPet", getRootElement(), function(button, state, absoluteX, absoluteY, el)
  if petSpawnTick + 5000 <= getTickCount() then
    if playerAnimals[selectedAnimal] then
      local animalId = playerAnimals[selectedAnimal].animalId
      if animalId then
        if spawnedAnimal then
          if spawnedAnimal == playerAnimals[selectedAnimal].animalId then
            triggerServerEvent("destroyAnimal", localPlayer, spawnedAnimal)
            petSpawnTick = getTickCount()
          else
            seexports.rl_gui:showInfobox("e", "Másik állat lespawnolása előtt, először despawnold az aktívat!")
          end
        else
          triggerServerEvent("spawnAnimal", localPlayer, animalId)
          petSpawnTick = getTickCount()
        end
      end
    end
  else
    seexports.rl_gui:showInfobox("e", "5 másodpercenként egyszer használhatod ezt a gombot.")
  end
end)
addEvent("selectAnimalClick", true)
addEventHandler("selectAnimalClick", getRootElement(), function(button, state, absoluteX, absoluteY, el)
  if buttons[el] then
    selectedAnimal = buttons[el]
    drawAnimal()
  end
end)
addEventHandler("onClientKey", getRootElement(), function(key, por)
  if animalMenuDrawn and 0 < maxAnimalOffset then
    if key == "mouse_wheel_up" then
      if 0 < animalOffset then
        animalOffset = animalOffset - 1
        drawAnimalSideMenu()
      end
    elseif key == "mouse_wheel_down" and animalOffset < maxAnimalOffset then
      animalOffset = animalOffset + 1
      drawAnimalSideMenu()
    end
  end
end)
local h = 0
function drawAnimalSideMenu()
  if #playerAnimals + 1 > 10 then
    local sw = menuW - dashboardPadding[3] - 2
    seexports.rl_gui:setGuiPosition(scrollbar, sw + 1, 1 + sh * animalOffset)
  end
  for i = 1, 10 do
    if playerAnimals[i + animalOffset] then
      if selectedAnimal == i + animalOffset then
        seexports.rl_gui:setGuiBackground(sideMenu[i][1], "solid", "v4green")
        seexports.rl_gui:setGuiHoverable(sideMenu[i][1], false)
        seexports.rl_gui:setClickEvent(sideMenu[i][1], false)
      else
        seexports.rl_gui:setGuiBackground(sideMenu[i][1], "solid", "v4grey1")
        seexports.rl_gui:setGuiHoverable(sideMenu[i][1], true)
        seexports.rl_gui:setGuiHover(sideMenu[i][1], "gradient", {"v4grey2", "v4grey1"}, true)
        seexports.rl_gui:setClickEvent(sideMenu[i][1], "selectAnimalClick")
      end
      seexports.rl_gui:setLabelText(sideMenu[i][2], playerAnimals[i + animalOffset].name)
      seexports.rl_gui:setLabelText(sideMenu[i][3], "#" .. playerAnimals[i + animalOffset].animalId)
      seexports.rl_gui:setLabelText(sideMenu[i][6], "")
      seexports.rl_gui:setImageDDS(sideMenu[i][5], ":rl_dashboard/files/dogs/" .. utf8.lower(utf8.gsub(playerAnimals[i + animalOffset].type, " ", "")) .. ".dds")
      buttons[sideMenu[i][1]] = i + animalOffset
      seexports.rl_gui:setLabelText(sideMenu[i][4], "Fajta: " .. playerAnimals[i + animalOffset].type)
    elseif i + animalOffset == #playerAnimals + 1 then
      seexports.rl_gui:setGuiBackground(sideMenu[i][1], "solid", "v4blue")
      seexports.rl_gui:setGuiHover(sideMenu[i][1], "gradient", {
        "v4blue",
        "v4blue-second"
      }, true)
      seexports.rl_gui:setGuiHoverable(sideMenu[i][1], true)
      seexports.rl_gui:setClickEvent(sideMenu[i][1], "buyAnimalClick")
      seexports.rl_gui:setLabelText(sideMenu[i][2], "")
      seexports.rl_gui:setLabelText(sideMenu[i][3], "")
      buttons[sideMenu[i][1]] = i + animalOffset
      seexports.rl_gui:setLabelText(sideMenu[i][4], "")
      seexports.rl_gui:setImageFile(sideMenu[i][5], seexports.rl_gui:getFaIconFilename("paw", h - 16))
      seexports.rl_gui:setLabelText(sideMenu[i][6], "Háziállat vásárlás")
    end
  end
end
function drawAnimal()
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
  sellingAnimalTo = false
  selectedAnimalToBuy = false
  buyInput = false
  renameInput = false
  sellInput = false
  menuW = math.floor(sx * 0.27)
  h = (sy - 32) / 10
  if inside then
    seexports.rl_gui:deleteGuiElement(inside)
  end
  inside = seexports.rl_gui:createGuiElement("null", 0, 0, sx, sy, rtg)
  local rect = seexports.rl_gui:createGuiElement("rectangle", menuW, 0, sx - menuW, sy, inside)
  seexports.rl_gui:setGuiBackground(rect, "solid", "v4grey2")
  local rect = seexports.rl_gui:createGuiElement("rectangle", 0, sy - 32, menuW, 32, inside)
  seexports.rl_gui:setGuiBackground(rect, "solid", "v4grey3")
  maxAnimalOffset = 0
  if 10 < #playerAnimals + 1 then
    maxAnimalOffset = #playerAnimals + 1 - 10
    menuW = menuW - dashboardPadding[3] - 2
    local rect = seexports.rl_gui:createGuiElement("rectangle", menuW, 0, dashboardPadding[3] + 2, sy - 32, inside)
    seexports.rl_gui:setGuiBackground(rect, "solid", "v4grey3")
    sh = (sy - 32) / (#playerAnimals + 1 - 10 + 1)
    scrollbar = seexports.rl_gui:createGuiElement("rectangle", menuW + 1, 1 + sh * animalOffset, dashboardPadding[3], sh - 2, inside)
    seexports.rl_gui:setGuiBackground(scrollbar, "solid", "v4green")
  end
  buttons = {}
  for i = 1, 10 do
    if playerAnimals[i + animalOffset] or i + animalOffset == #playerAnimals + 1 then
      sideMenu[i] = {}
      sideMenu[i][1] = seexports.rl_gui:createGuiElement("rectangle", 0, (i - 1) * h, menuW, h, inside)
      seexports.rl_gui:setGuiHover(sideMenu[i][1], "gradient", {"v4grey2", "v4grey1"}, true)
      sideMenu[i][2] = seexports.rl_gui:createGuiElement("label", dashboardPadding[3] * 2 + (h - 8), 0, menuW - dashboardPadding[3] * 2 * 2, h / 2, sideMenu[i][1])
      seexports.rl_gui:setLabelFont(sideMenu[i][2], "16/BebasNeueRegular.otf")
      seexports.rl_gui:setLabelAlignment(sideMenu[i][2], "left", "center")
      sideMenu[i][3] = seexports.rl_gui:createGuiElement("label", dashboardPadding[3] * 2 + (h - 8), h / 2, menuW - dashboardPadding[3] * 2 * 2, h / 2, sideMenu[i][1])
      seexports.rl_gui:setLabelFont(sideMenu[i][3], "12/Ubuntu-L.ttf")
      seexports.rl_gui:setLabelAlignment(sideMenu[i][3], "left", "center")
      sideMenu[i][4] = seexports.rl_gui:createGuiElement("label", dashboardPadding[3] * 2, h / 2, menuW - dashboardPadding[3] * 2 * 2, h / 2, sideMenu[i][1])
      seexports.rl_gui:setLabelFont(sideMenu[i][4], "12/Ubuntu-L.ttf")
      seexports.rl_gui:setLabelAlignment(sideMenu[i][4], "right", "center")
      sideMenu[i][5] = seexports.rl_gui:createGuiElement("image", dashboardPadding[3] * 2, 8, h - 16, h - 16, sideMenu[i][1])
      seexports.rl_gui:setImageFile(sideMenu[i][5], seexports.rl_gui:getFaIconFilename("paw", h - 16))
      sideMenu[i][6] = seexports.rl_gui:createGuiElement("label", dashboardPadding[3] * 2 + (h - 8), 0, menuW - dashboardPadding[3] * 2 * 2, h, sideMenu[i][1])
      seexports.rl_gui:setLabelFont(sideMenu[i][6], "18/BebasNeueRegular.otf")
      seexports.rl_gui:setLabelAlignment(sideMenu[i][6], "left", "center")
      seexports.rl_gui:setLabelText(sideMenu[i][6], "Háziállat vásárlás")
    end
  end
  local label = seexports.rl_gui:createGuiElement("label", 0, sy - 32, menuW, 32, inside)
  seexports.rl_gui:setLabelFont(label, "11/Ubuntu-L.ttf")
  seexports.rl_gui:setLabelAlignment(label, "center", "center")
  seexports.rl_gui:setLabelText(label, "Háziállatok: " .. #playerAnimals)
  if 10 < #playerAnimals + 1 then
    menuW = menuW + dashboardPadding[3] + 2
  end
  drawAnimalSideMenu()
  local x = menuW + dashboardPadding[3] * 4
  local y = dashboardPadding[3] * 4
  local sx = sx - menuW
  local h = seexports.rl_gui:getFontHeight("12/Ubuntu-L.ttf") * 1.25
  local h1 = seexports.rl_gui:getFontHeight("30/BebasNeueRegular.otf")
  local is = h1 * 1.25 + h * 2 + (h + 16 + 8) * 3 - 16
  if playerAnimals[selectedAnimal] then
    local rect = seexports.rl_gui:createGuiElement("rectangle", x + sx - is - 16 - dashboardPadding[3] * 8, y, is + 16, is + 16, inside)
    seexports.rl_gui:setGuiBackground(rect, "solid", "v4grey1")
    local img = seexports.rl_gui:createGuiElement("image", x + sx - is - 16 - dashboardPadding[3] * 8 + 8, y + 8, is, is, inside)
    seexports.rl_gui:setImageDDS(img, ":rl_dashboard/files/dogs/" .. utf8.lower(utf8.gsub(playerAnimals[selectedAnimal].type, " ", "")) .. ".dds")
    local label = seexports.rl_gui:createGuiElement("label", x, y, sx, h1, inside)
    seexports.rl_gui:setLabelFont(label, "30/BebasNeueRegular.otf")
    seexports.rl_gui:setLabelAlignment(label, "left", "center")
    seexports.rl_gui:setLabelText(label, playerAnimals[selectedAnimal].name)
    y = y + h1 * 1.25
    local label = seexports.rl_gui:createGuiElement("label", x, y, sx, h, inside)
    seexports.rl_gui:setLabelFont(label, "12/Ubuntu-R.ttf")
    seexports.rl_gui:setLabelAlignment(label, "left", "center")
    seexports.rl_gui:setLabelText(label, "ID: ")
    local label = seexports.rl_gui:createGuiElement("label", x + seexports.rl_gui:getLabelTextWidth(label), y, sx, h, inside)
    seexports.rl_gui:setLabelFont(label, "12/Ubuntu-L.ttf")
    seexports.rl_gui:setLabelAlignment(label, "left", "center")
    seexports.rl_gui:setLabelColor(label, "v4green")
    seexports.rl_gui:setLabelText(label, playerAnimals[selectedAnimal].animalId)
    y = y + h
    local label = seexports.rl_gui:createGuiElement("label", x, y, sx, h, inside)
    seexports.rl_gui:setLabelFont(label, "12/Ubuntu-R.ttf")
    seexports.rl_gui:setLabelAlignment(label, "left", "center")
    seexports.rl_gui:setLabelText(label, "Fajta: ")
    local label = seexports.rl_gui:createGuiElement("label", x + seexports.rl_gui:getLabelTextWidth(label), y, sx, h, inside)
    seexports.rl_gui:setLabelFont(label, "12/Ubuntu-L.ttf")
    seexports.rl_gui:setLabelAlignment(label, "left", "center")
    seexports.rl_gui:setLabelColor(label, "v4green")
    seexports.rl_gui:setLabelText(label, playerAnimals[selectedAnimal].type)
    y = y + h
    local health = math.floor(playerAnimals[selectedAnimal].health + 0.5)
    local hunger = math.floor(playerAnimals[selectedAnimal].hunger + 0.5)
    local love = math.floor(playerAnimals[selectedAnimal].love + 0.5)
    if spawnedAnimal == playerAnimals[selectedAnimal].animalId then
      health = math.floor(getElementHealth(spawnedPetElement) + 0.5)
      hunger = math.floor((petDatas["animal.hunger"] or 0) + 0.5)
      love = math.floor((petDatas["animal.love"] or 0) + 0.5)
    end
    local label = seexports.rl_gui:createGuiElement("label", x, y, sx, h, inside)
    seexports.rl_gui:setLabelFont(label, "12/Ubuntu-R.ttf")
    seexports.rl_gui:setLabelAlignment(label, "left", "center")
    seexports.rl_gui:setLabelText(label, "Életerő: ")
    local label = seexports.rl_gui:createGuiElement("label", x + seexports.rl_gui:getLabelTextWidth(label), y, sx, h, inside)
    seexports.rl_gui:setLabelFont(label, "12/Ubuntu-L.ttf")
    seexports.rl_gui:setLabelAlignment(label, "left", "center")
    if health <= 25 then
      seexports.rl_gui:setLabelColor(label, "v4red")
    elseif health <= 75 then
      seexports.rl_gui:setLabelColor(label, "v4yellow")
    else
      seexports.rl_gui:setLabelColor(label, "v4green")
    end
    seexports.rl_gui:setLabelText(label, health .. "%")
    y = y + h
    local rect = seexports.rl_gui:createGuiElement("rectangle", x, y + 4, sx * 0.4, 16, inside)
    seexports.rl_gui:setGuiBackground(rect, "solid", "v4grey1")
    local rect = seexports.rl_gui:createGuiElement("rectangle", x + 2, y + 4 + 2, sx * 0.4 - 4, 12, inside)
    seexports.rl_gui:setGuiBackground(rect, "solid", "v4grey3")
    local rect = seexports.rl_gui:createGuiElement("rectangle", x + 2, y + 4 + 2, (sx * 0.4 - 4) * (health / 100), 12, inside)
    seexports.rl_gui:setGuiBackground(rect, "solid", "v4green")
    y = y + 16 + 8
    local label = seexports.rl_gui:createGuiElement("label", x, y, sx, h, inside)
    seexports.rl_gui:setLabelFont(label, "12/Ubuntu-R.ttf")
    seexports.rl_gui:setLabelAlignment(label, "left", "center")
    seexports.rl_gui:setLabelText(label, "Éhség: ")
    local label = seexports.rl_gui:createGuiElement("label", x + seexports.rl_gui:getLabelTextWidth(label), y, sx, h, inside)
    seexports.rl_gui:setLabelFont(label, "12/Ubuntu-L.ttf")
    seexports.rl_gui:setLabelAlignment(label, "left", "center")
    if hunger <= 25 then
      seexports.rl_gui:setLabelColor(label, "v4red")
    elseif hunger <= 75 then
      seexports.rl_gui:setLabelColor(label, "v4yellow")
    else
      seexports.rl_gui:setLabelColor(label, "v4green")
    end
    seexports.rl_gui:setLabelText(label, hunger .. "%")
    y = y + h
    local rect = seexports.rl_gui:createGuiElement("rectangle", x, y + 4, sx * 0.4, 16, inside)
    seexports.rl_gui:setGuiBackground(rect, "solid", "v4grey1")
    local rect = seexports.rl_gui:createGuiElement("rectangle", x + 2, y + 4 + 2, sx * 0.4 - 4, 12, inside)
    seexports.rl_gui:setGuiBackground(rect, "solid", "v4grey3")
    local rect = seexports.rl_gui:createGuiElement("rectangle", x + 2, y + 4 + 2, (sx * 0.4 - 4) * (hunger / 100), 12, inside)
    seexports.rl_gui:setGuiBackground(rect, "solid", "v4blue")
    y = y + 16 + 8
    local label = seexports.rl_gui:createGuiElement("label", x, y, sx, h, inside)
    seexports.rl_gui:setLabelFont(label, "12/Ubuntu-R.ttf")
    seexports.rl_gui:setLabelAlignment(label, "left", "center")
    seexports.rl_gui:setLabelText(label, "Szeretet: ")
    local label = seexports.rl_gui:createGuiElement("label", x + seexports.rl_gui:getLabelTextWidth(label), y, sx, h, inside)
    seexports.rl_gui:setLabelFont(label, "12/Ubuntu-L.ttf")
    seexports.rl_gui:setLabelAlignment(label, "left", "center")
    if love <= 25 then
      seexports.rl_gui:setLabelColor(label, "v4red")
    elseif love <= 75 then
      seexports.rl_gui:setLabelColor(label, "v4yellow")
    else
      seexports.rl_gui:setLabelColor(label, "v4green")
    end
    seexports.rl_gui:setLabelText(label, love .. "%")
    y = y + h
    local rect = seexports.rl_gui:createGuiElement("rectangle", x, y + 4, sx * 0.4, 16, inside)
    seexports.rl_gui:setGuiBackground(rect, "solid", "v4grey1")
    local rect = seexports.rl_gui:createGuiElement("rectangle", x + 2, y + 4 + 2, sx * 0.4 - 4, 12, inside)
    seexports.rl_gui:setGuiBackground(rect, "solid", "v4grey3")
    local rect = seexports.rl_gui:createGuiElement("rectangle", x + 2, y + 4 + 2, (sx * 0.4 - 4) * (love / 100), 12, inside)
    seexports.rl_gui:setGuiBackground(rect, "solid", "v4red")
    y = y + 16 + 8
    y = y + 15
    if spawnedAnimal == playerAnimals[selectedAnimal].animalId then
      local btn = seexports.rl_gui:createGuiElement("button", x, y + 5, sx * 0.4, 30, inside)
      seexports.rl_gui:setGuiBackground(btn, "solid", "v4red")
      seexports.rl_gui:setGuiHover(btn, "gradient", {
        "v4red",
        "v4red-second"
      })
      seexports.rl_gui:setButtonFont(btn, "13/BebasNeueBold.otf")
      seexports.rl_gui:setButtonTextColor(btn, "#ffffff")
      seexports.rl_gui:setButtonText(btn, "Despawn")
      seexports.rl_gui:setClickEvent(btn, "spawnPet")
    else
      local btn = seexports.rl_gui:createGuiElement("button", x, y + 5, sx * 0.4, 30, inside)
      seexports.rl_gui:setGuiBackground(btn, "solid", "v4green")
      seexports.rl_gui:setGuiHover(btn, "gradient", {
        "v4green",
        "v4green-second"
      })
      seexports.rl_gui:setButtonFont(btn, "13/BebasNeueBold.otf")
      seexports.rl_gui:setButtonTextColor(btn, "#ffffff")
      seexports.rl_gui:setButtonText(btn, "Spawn")
      seexports.rl_gui:setClickEvent(btn, "spawnPet")
      y = y + 30 + 10
      local btn = seexports.rl_gui:createGuiElement("button", x, y + 5, sx * 0.4, 30, inside)
      seexports.rl_gui:setGuiBackground(btn, "solid", "v4blue")
      seexports.rl_gui:setGuiHover(btn, "gradient", {
        "v4blue",
        "v4blue-second"
      })
      seexports.rl_gui:setButtonFont(btn, "13/BebasNeueBold.otf")
      seexports.rl_gui:setButtonTextColor(btn, "#ffffff")
      seexports.rl_gui:setButtonText(btn, "Háziállat átnevezése")
      seexports.rl_gui:setClickEvent(btn, "renamePet")
      y = y + 30 + 10
      if playerAnimals[selectedAnimal].health <= 25 then
        local btn = seexports.rl_gui:createGuiElement("button", x, y + 5, sx * 0.4, 30, inside)
        seexports.rl_gui:setGuiBackground(btn, "solid", "v4blue")
        seexports.rl_gui:setGuiHover(btn, "gradient", {
          "v4blue",
          "v4blue-second"
        })
        seexports.rl_gui:setButtonFont(btn, "13/BebasNeueBold.otf")
        seexports.rl_gui:setButtonTextColor(btn, "#ffffff")
        if 0 >= playerAnimals[selectedAnimal].health then
          seexports.rl_gui:setButtonText(btn, "Felélesztés")
        else
          seexports.rl_gui:setButtonText(btn, "Életerő feltöltése")
        end
        seexports.rl_gui:setClickEvent(btn, "revivePet")
        y = y + 30 + 10
      end
      local btn = seexports.rl_gui:createGuiElement("button", x, y + 5, sx * 0.4, 30, inside)
      seexports.rl_gui:setGuiBackground(btn, "solid", "v4green")
      seexports.rl_gui:setGuiHover(btn, "gradient", {
        "v4green",
        "v4green-second"
      })
      seexports.rl_gui:setButtonFont(btn, "13/BebasNeueBold.otf")
      seexports.rl_gui:setButtonTextColor(btn, "#ffffff")
      seexports.rl_gui:setButtonText(btn, "Eladás")
      seexports.rl_gui:setClickEvent(btn, "startPetSell")
    end
  end
end
function animalsInsideDraw(x, y, isx, isy, i, j, irtg)
  rtg = irtg
  sx, sy = isx, isy
  animalOffset = 0
  animalMenuDrawn = true
  drawAnimal()
end
addEvent("finalSellPet", true)
addEventHandler("finalSellPet", getRootElement(), function()
  if sellingAnimalTo and isElement(sellingAnimalTo) and playerAnimals[selectedAnimal] and playerAnimals[selectedAnimal].animalId then
    local price = tonumber(seexports.rl_gui:getInputValue(sellInput))
    if 500 <= price then
      triggerServerEvent("tryToSellPet", localPlayer, playerAnimals[selectedAnimal].animalId, sellingAnimalTo, price)
    else
      seexports.rl_gui:showInfobox("e", "A minimum eladási összeg 500$!")
      return
    end
  end
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
  sellingAnimalTo = false
  selectedAnimalToBuy = false
  buyInput = false
  renameInput = false
  sellInput = false
end)
addEvent("closePetPanel", true)
addEventHandler("closePetPanel", getRootElement(), function()
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
  sellingAnimalTo = false
  selectedAnimalToBuy = false
  buyInput = false
  renameInput = false
  sellInput = false
end)
local playerButtons = {}
sellingAnimalTo = false
selectedAnimalToBuy = false
buyInput = false
renameInput = false
sellInput = false
addEvent("selectAnimalSellPlayer", true)
addEventHandler("selectAnimalSellPlayer", getRootElement(), function(button, state, absoluteX, absoluteY, el)
  if playerButtons[el] and isElement(playerButtons[el]) then
    sellingAnimalTo = playerButtons[el]
    local titleBarHeight = seexports.rl_gui:getTitleBarHeight()
    local panelWidth = 300
    local panelHeight = titleBarHeight + 5 + 70 + 32 + 5 + 96
    if buyingWindow then
      seexports.rl_gui:deleteGuiElement(buyingWindow)
    end
    buyingWindow = seexports.rl_gui:createGuiElement("window", screenX / 2 - panelWidth / 2, screenY / 2 - panelHeight / 2, panelWidth, panelHeight)
    seexports.rl_gui:setWindowTitle(buyingWindow, "16/BebasNeueRegular.otf", "Háziállat eladás")
    local label = seexports.rl_gui:createGuiElement("label", 5, titleBarHeight, panelWidth - 10, 96, buyingWindow)
    seexports.rl_gui:setLabelFont(label, "11/Ubuntu-R.ttf")
    seexports.rl_gui:setLabelAlignment(label, "center", "center")
    seexports.rl_gui:setLabelText(label, "Név: " .. seexports.rl_gui:getColorCodeHex("v4green") .. playerAnimals[selectedAnimal].name .. "[" .. playerAnimals[selectedAnimal].animalId .. [[
]
#ffffffFajta: ]] .. seexports.rl_gui:getColorCodeHex("v4green") .. playerAnimals[selectedAnimal].type .. "\n#ffffffVevő: " .. seexports.rl_gui:getColorCodeHex("v4green") .. getElementData(sellingAnimalTo, "visibleName"):gsub("_", " "))
    sellInput = seexports.rl_gui:createGuiElement("input", 5, titleBarHeight + 5 + 96, panelWidth - 10, 32, buyingWindow)
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
    seexports.rl_gui:setClickEvent(btn, "finalSellPet", false)
    local btn = seexports.rl_gui:createGuiElement("button", 5, panelHeight - 35, panelWidth - 10, 30, buyingWindow)
    seexports.rl_gui:setGuiBackground(btn, "solid", "v4red")
    seexports.rl_gui:setGuiHover(btn, "gradient", {
      "v4red",
      "v4red-second"
    })
    seexports.rl_gui:setButtonFont(btn, "15/BebasNeueBold.otf")
    seexports.rl_gui:setButtonTextColor(btn, "#ffffff")
    seexports.rl_gui:setButtonText(btn, "Mégsem")
    seexports.rl_gui:setClickEvent(btn, "closePetPanel", false)
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
    sellingAnimalTo = false
    selectedAnimalToBuy = false
    buyInput = false
    renameInput = false
    sellInput = false
  end
end)
addEvent("startPetSell", true)
addEventHandler("startPetSell", getRootElement(), function()
  if playerAnimals[selectedAnimal] then
    local data = playerAnimals[selectedAnimal]
    if spawnedAnimal ~= playerAnimals[selectedAnimal].animalId then
      local px, py, pz = getElementPosition(localPlayer)
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
          seexports.rl_gui:setClickEvent(btn, "selectAnimalSellPlayer", false)
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
        seexports.rl_gui:setClickEvent(btn, "closePetPanel", false)
      end
    else
      seexports.rl_gui:showInfobox("e", "Nem tudod eladni az állatot, ha le van spawnolva!")
    end
  end
end)
local selectPetButton = {}
addEvent("finalPetBuy", true)
addEventHandler("finalPetBuy", getRootElement(), function()
  if selectedAnimalToBuy and animalsToBuy[selectedAnimalToBuy] then
    if animalsToBuy[selectedAnimalToBuy][2] > ppBalance then
      seexports.rl_gui:showInfobox("e", "Nincs elég PrémiumPontod!")
    else
      local name = seexports.rl_gui:getInputValue(buyInput)
      if not name or utf8.len(name) < 1 then
        seexports.rl_gui:showInfobox("e", "Add meg a háziallat nevét!")
        return
      end
      triggerServerEvent("tryToBuyPet", localPlayer, selectedAnimalToBuy, name)
    end
  end
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
  sellingAnimalTo = false
  selectedAnimalToBuy = false
  buyInput = false
  renameInput = false
  sellInput = false
end)
addEvent("finalRenamePet", true)
addEventHandler("finalRenamePet", getRootElement(), function(button, state, absoluteX, absoluteY, el)
  if playerAnimals[selectedAnimal] and playerAnimals[selectedAnimal].animalId then
    local newName = seexports.rl_gui:getInputValue(renameInput)
    if not newName or utf8.len(newName) < 1 then
      seexports.rl_gui:showInfobox("e", "Add meg a háziallat nevét!")
      return
    end
    if playerAnimals[selectedAnimal].name ~= newName then
      triggerServerEvent("renamePet", localPlayer, playerAnimals[selectedAnimal].animalId, newName)
    else
      seexports.rl_gui:showInfobox("e", "Ugyanaz nem lehet az új neve a háziállatnak, mint a régi!")
      return
    end
  end
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
  sellingAnimalTo = false
  selectedAnimalToBuy = false
  buyInput = false
  renameInput = false
  sellInput = false
end)
addEvent("renamePet", true)
addEventHandler("renamePet", getRootElement(), function(button, state, absoluteX, absoluteY, el)
  if playerAnimals[selectedAnimal] then
    if not seexports.rl_items:playerHasItem(423) then
      seexports.rl_gui:showInfobox("e", "Nincs háziallat átnevező kártyád!")
      return
    end
    selectedAnimalToBuy = selectPetButton[el]
    local titleBarHeight = seexports.rl_gui:getTitleBarHeight()
    local panelWidth = 300
    local panelHeight = titleBarHeight + 5 + 70 + 32 + 5 + 60 + 16
    if buyingWindow then
      seexports.rl_gui:deleteGuiElement(buyingWindow)
      seexports.rl_gui:lockHover(rtg, false)
      seexports.rl_gui:lockHover(closeButton, false)
      seexports.rl_gui:lockHover(helpIcon, false)
    end
    seexports.rl_gui:lockHover(rtg, true)
    seexports.rl_gui:lockHover(closeButton, true)
    seexports.rl_gui:lockHover(helpIcon, true)
    if buyingRect then
      seexports.rl_gui:deleteGuiElement(buyingRect)
    end
    buyingRect = seexports.rl_gui:createGuiElement("rectangle", 0, 0, screenX, screenY)
    seexports.rl_gui:setGuiBackground(buyingRect, "solid", {
      0,
      0,
      0,
      150
    })
    buyingWindow = seexports.rl_gui:createGuiElement("window", screenX / 2 - panelWidth / 2, screenY / 2 - panelHeight / 2, panelWidth, panelHeight)
    seexports.rl_gui:setWindowTitle(buyingWindow, "16/BebasNeueRegular.otf", "Háziállat átnevezés")
    local label = seexports.rl_gui:createGuiElement("label", 5, titleBarHeight, panelWidth - 10, 60, buyingWindow)
    seexports.rl_gui:setLabelFont(label, "11/Ubuntu-R.ttf")
    seexports.rl_gui:setLabelAlignment(label, "center", "center")
    seexports.rl_gui:setLabelText(label, "Név: " .. seexports.rl_gui:getColorCodeHex("v4green") .. "[#" .. playerAnimals[selectedAnimal].animalId .. "] " .. playerAnimals[selectedAnimal].name .. [[

#ffffffFajta: ]] .. seexports.rl_gui:getColorCodeHex("v4green") .. playerAnimals[selectedAnimal].type)
    renameInput = seexports.rl_gui:createGuiElement("input", 5, titleBarHeight + 5 + 60 + 8, panelWidth - 10, 32, buyingWindow)
    seexports.rl_gui:setInputFont(renameInput, "11/Ubuntu-R.ttf")
    seexports.rl_gui:setInputIcon(renameInput, "tag")
    seexports.rl_gui:setInputPlaceholder(renameInput, "Új név")
    seexports.rl_gui:setInputMaxLength(renameInput, 20)
    local btn = seexports.rl_gui:createGuiElement("button", 5, panelHeight - 70, panelWidth - 10, 30, buyingWindow)
    seexports.rl_gui:setGuiBackground(btn, "solid", "v4blue")
    seexports.rl_gui:setGuiHover(btn, "gradient", {
      "v4blue",
      "v4blue-second"
    })
    seexports.rl_gui:setButtonFont(btn, "15/BebasNeueBold.otf")
    seexports.rl_gui:setButtonTextColor(btn, "#ffffff")
    seexports.rl_gui:setButtonText(btn, "Átnevezés")
    seexports.rl_gui:setClickEvent(btn, "finalRenamePet", false)
    local btn = seexports.rl_gui:createGuiElement("button", 5, panelHeight - 35, panelWidth - 10, 30, buyingWindow)
    seexports.rl_gui:setGuiBackground(btn, "solid", "v4red")
    seexports.rl_gui:setGuiHover(btn, "gradient", {
      "v4red",
      "v4red-second"
    })
    seexports.rl_gui:setButtonFont(btn, "15/BebasNeueBold.otf")
    seexports.rl_gui:setButtonTextColor(btn, "#ffffff")
    seexports.rl_gui:setButtonText(btn, "Mégsem")
    seexports.rl_gui:setClickEvent(btn, "closePetPanel", false)
  end
end)
addEvent("finalRevive", true)
addEventHandler("finalRevive", getRootElement(), function()
  if 100 > ppBalance then
    seexports.rl_gui:showInfobox("e", "Nincs elég PrémiumPontod!")
    return
  end
  if playerAnimals[selectedAnimal] and playerAnimals[selectedAnimal].animalId then
    triggerServerEvent("buyPetRevive", localPlayer, playerAnimals[selectedAnimal].animalId)
  end
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
  sellingAnimalTo = false
  selectedAnimalToBuy = false
  buyInput = false
  renameInput = false
  sellInput = false
end)
addEvent("revivePet", true)
addEventHandler("revivePet", getRootElement(), function(button, state, absoluteX, absoluteY, el)
  if playerAnimals[selectedAnimal] and playerAnimals[selectedAnimal].animalId then
    local titleBarHeight = seexports.rl_gui:getTitleBarHeight()
    local panelWidth = 300
    local panelHeight = titleBarHeight + 5 + 70 + 90
    if buyingRect then
      seexports.rl_gui:deleteGuiElement(buyingRect)
    end
    if buyingWindow then
      seexports.rl_gui:deleteGuiElement(buyingWindow)
      seexports.rl_gui:lockHover(rtg, false)
      seexports.rl_gui:lockHover(closeButton, false)
      seexports.rl_gui:lockHover(helpIcon, false)
    end
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
    buyingWindow = seexports.rl_gui:createGuiElement("window", screenX / 2 - panelWidth / 2, screenY / 2 - panelHeight / 2, panelWidth, panelHeight)
    seexports.rl_gui:setWindowTitle(buyingWindow, "16/BebasNeueRegular.otf", "Háziállat felélesztés")
    local label = seexports.rl_gui:createGuiElement("label", 5, titleBarHeight, panelWidth - 10, 90, buyingWindow)
    seexports.rl_gui:setLabelFont(label, "11/Ubuntu-R.ttf")
    seexports.rl_gui:setLabelAlignment(label, "center", "center")
    seexports.rl_gui:setLabelText(label, "Név: " .. seexports.rl_gui:getColorCodeHex("v4green") .. "[#" .. playerAnimals[selectedAnimal].animalId .. "] " .. playerAnimals[selectedAnimal].name .. [[

#ffffffFajta: ]] .. seexports.rl_gui:getColorCodeHex("v4green") .. playerAnimals[selectedAnimal].type .. [[

#ffffffPP egyenleg: ]] .. seexports.rl_gui:getColorCodeHex("v4blue") .. seexports.rl_gui:thousandsStepper(ppBalance) .. " PP" .. "\n#ffffffÁr: " .. seexports.rl_gui:getColorCodeHex("v4blue") .. "100 PP")
    local btn = seexports.rl_gui:createGuiElement("button", 5, panelHeight - 70, panelWidth - 10, 30, buyingWindow)
    seexports.rl_gui:setGuiBackground(btn, "solid", "v4blue")
    seexports.rl_gui:setGuiHover(btn, "gradient", {
      "v4blue",
      "v4blue-second"
    })
    seexports.rl_gui:setButtonFont(btn, "15/BebasNeueBold.otf")
    seexports.rl_gui:setButtonTextColor(btn, "#ffffff")
    seexports.rl_gui:setButtonText(btn, "Felélesztés")
    seexports.rl_gui:setClickEvent(btn, "finalRevive", false)
    local btn = seexports.rl_gui:createGuiElement("button", 5, panelHeight - 35, panelWidth - 10, 30, buyingWindow)
    seexports.rl_gui:setGuiBackground(btn, "solid", "v4red")
    seexports.rl_gui:setGuiHover(btn, "gradient", {
      "v4red",
      "v4red-second"
    })
    seexports.rl_gui:setButtonFont(btn, "15/BebasNeueBold.otf")
    seexports.rl_gui:setButtonTextColor(btn, "#ffffff")
    seexports.rl_gui:setButtonText(btn, "Mégsem")
    seexports.rl_gui:setClickEvent(btn, "closePetPanel", false)
  end
end)
addEvent("selectDogTypeBuy", true)
addEventHandler("selectDogTypeBuy", getRootElement(), function(button, state, absoluteX, absoluteY, el)
  if selectPetButton[el] and animalsToBuy[selectPetButton[el]] then
    if animalsToBuy[selectPetButton[el]][2] > ppBalance then
      seexports.rl_gui:showInfobox("e", "Nincs elég PrémiumPontod!")
      return
    end
    selectedAnimalToBuy = selectPetButton[el]
    local titleBarHeight = seexports.rl_gui:getTitleBarHeight()
    local panelWidth = 300
    local panelHeight = titleBarHeight + 5 + 70 + 32 + 5 + 80 + 16
    if buyingWindow then
      seexports.rl_gui:deleteGuiElement(buyingWindow)
      seexports.rl_gui:lockHover(rtg, false)
      seexports.rl_gui:lockHover(closeButton, false)
      seexports.rl_gui:lockHover(helpIcon, false)
    end
    seexports.rl_gui:lockHover(rtg, true)
    seexports.rl_gui:lockHover(closeButton, true)
    seexports.rl_gui:lockHover(helpIcon, true)
    buyingWindow = seexports.rl_gui:createGuiElement("window", screenX / 2 - panelWidth / 2, screenY / 2 - panelHeight / 2, panelWidth, panelHeight)
    seexports.rl_gui:setWindowTitle(buyingWindow, "16/BebasNeueRegular.otf", "Háziállat vásárlás")
    local label = seexports.rl_gui:createGuiElement("label", 5, titleBarHeight, panelWidth - 10, 80, buyingWindow)
    seexports.rl_gui:setLabelFont(label, "11/Ubuntu-R.ttf")
    seexports.rl_gui:setLabelAlignment(label, "center", "center")
    seexports.rl_gui:setLabelText(label, "Fajta: " .. seexports.rl_gui:getColorCodeHex("v4green") .. animalsToBuy[selectedAnimalToBuy][1] .. [[

#ffffffPP egyenleg: ]] .. seexports.rl_gui:getColorCodeHex("v4blue") .. seexports.rl_gui:thousandsStepper(ppBalance) .. " PP" .. "\n#ffffffÁr: " .. seexports.rl_gui:getColorCodeHex("v4blue") .. seexports.rl_gui:thousandsStepper(animalsToBuy[selectedAnimalToBuy][2]) .. " PP")
    buyInput = seexports.rl_gui:createGuiElement("input", 5, titleBarHeight + 5 + 80 + 8, panelWidth - 10, 32, buyingWindow)
    seexports.rl_gui:setInputFont(buyInput, "11/Ubuntu-R.ttf")
    seexports.rl_gui:setInputIcon(buyInput, "tag")
    seexports.rl_gui:setInputPlaceholder(buyInput, "Név")
    seexports.rl_gui:setInputMaxLength(buyInput, 20)
    local btn = seexports.rl_gui:createGuiElement("button", 5, panelHeight - 70, panelWidth - 10, 30, buyingWindow)
    seexports.rl_gui:setGuiBackground(btn, "solid", "v4blue")
    seexports.rl_gui:setGuiHover(btn, "gradient", {
      "v4blue",
      "v4blue-second"
    })
    seexports.rl_gui:setButtonFont(btn, "15/BebasNeueBold.otf")
    seexports.rl_gui:setButtonTextColor(btn, "#ffffff")
    seexports.rl_gui:setButtonText(btn, "Vásárlás")
    seexports.rl_gui:setClickEvent(btn, "finalPetBuy", false)
    local btn = seexports.rl_gui:createGuiElement("button", 5, panelHeight - 35, panelWidth - 10, 30, buyingWindow)
    seexports.rl_gui:setGuiBackground(btn, "solid", "v4red")
    seexports.rl_gui:setGuiHover(btn, "gradient", {
      "v4red",
      "v4red-second"
    })
    seexports.rl_gui:setButtonFont(btn, "15/BebasNeueBold.otf")
    seexports.rl_gui:setButtonTextColor(btn, "#ffffff")
    seexports.rl_gui:setButtonText(btn, "Mégsem")
    seexports.rl_gui:setClickEvent(btn, "closePetPanel", false)
  end
end)
addEvent("buyAnimalClick", true)
addEventHandler("buyAnimalClick", getRootElement(), function()
  local titleBarHeight = seexports.rl_gui:getTitleBarHeight()
  local panelWidth = 1024
  local one = panelWidth / #animalsToBuy
  local w = one - dashboardPadding[3] * 8
  local h = seexports.rl_gui:getFontHeight("14/BebasNeueBold.otf") * 1.75
  local panelHeight = titleBarHeight + one + dashboardPadding[3] * 8 + h + h
  if buyingRect then
    seexports.rl_gui:deleteGuiElement(buyingRect)
  end
  if buyingWindow then
    seexports.rl_gui:deleteGuiElement(buyingWindow)
    seexports.rl_gui:lockHover(rtg, false)
    seexports.rl_gui:lockHover(closeButton, false)
    seexports.rl_gui:lockHover(helpIcon, false)
  end
  seexports.rl_gui:lockHover(rtg, true)
  seexports.rl_gui:lockHover(closeButton, true)
  seexports.rl_gui:lockHover(helpIcon, true)
  selectPetButton = {}
  buyingRect = seexports.rl_gui:createGuiElement("rectangle", 0, 0, screenX, screenY)
  seexports.rl_gui:setGuiBackground(buyingRect, "solid", {
    0,
    0,
    0,
    150
  })
  buyingWindow = seexports.rl_gui:createGuiElement("window", screenX / 2 - panelWidth / 2, screenY / 2 - panelHeight / 2, panelWidth, panelHeight)
  seexports.rl_gui:setWindowTitle(buyingWindow, "16/BebasNeueRegular.otf", "Háziállat vásárlás")
  seexports.rl_gui:setWindowCloseButton(buyingWindow, "closePetPanel")
  local label = seexports.rl_gui:createGuiElement("label", 0, titleBarHeight, panelWidth, h + dashboardPadding[3] * 4, buyingWindow)
  seexports.rl_gui:setLabelFont(label, "16/BebasNeueRegular.otf")
  seexports.rl_gui:setLabelAlignment(label, "center", "center")
  seexports.rl_gui:setLabelText(label, "PP egyenleg: " .. seexports.rl_gui:getColorCodeHex("v4blue") .. seexports.rl_gui:thousandsStepper(ppBalance) .. " PP")
  for i = 1, #animalsToBuy do
    local rect = seexports.rl_gui:createGuiElement("rectangle", (i - 1) * one + 3 + dashboardPadding[3] * 4, titleBarHeight + h + 3 + dashboardPadding[3] * 4, w, one + h, buyingWindow)
    seexports.rl_gui:setGuiBackground(rect, "solid", "#000000")
    local rect = seexports.rl_gui:createGuiElement("rectangle", (i - 1) * one + dashboardPadding[3] * 4, titleBarHeight + h + dashboardPadding[3] * 4, w, one + h, buyingWindow)
    seexports.rl_gui:setGuiBackground(rect, "gradient", {"v4grey3", "v4grey1"})
    seexports.rl_gui:setGuiHoverable(rect, true)
    seexports.rl_gui:setGuiHover(rect, "gradient", {"v4grey1", "v4grey3"}, true)
    seexports.rl_gui:setClickEvent(rect, "selectDogTypeBuy", false)
    selectPetButton[rect] = i
    local img = seexports.rl_gui:createGuiElement("image", 0, 0 + h, w, w, rect)
    seexports.rl_gui:setImageDDS(img, ":rl_dashboard/files/dogs/" .. utf8.lower(utf8.gsub(animalsToBuy[i][1], " ", "")) .. ".dds")
    local label = seexports.rl_gui:createGuiElement("label", 0, 0, w, h * 0.8, rect)
    seexports.rl_gui:setLabelFont(label, "14/BebasNeueBold.otf")
    seexports.rl_gui:setLabelAlignment(label, "center", "center")
    seexports.rl_gui:setLabelText(label, animalsToBuy[i][1])
    local label = seexports.rl_gui:createGuiElement("label", 0, 0 + w + h, w, one - w, rect)
    seexports.rl_gui:setLabelFont(label, "13/BebasNeueRegular.otf")
    seexports.rl_gui:setLabelAlignment(label, "center", "center")
    seexports.rl_gui:setLabelColor(label, "v4blue")
    seexports.rl_gui:setLabelText(label, seexports.rl_gui:thousandsStepper(animalsToBuy[i][2]) .. " PP")
  end
end)
local sellingWindow = false
addEvent("acceptAnimalSell", true)
addEventHandler("acceptAnimalSell", getRootElement(), function()
  if sellingWindow then
    seexports.rl_gui:deleteGuiElement(sellingWindow)
    sellingWindow = false
    triggerServerEvent("animalSellResponse", localPlayer, true)
  end
end)
addEvent("declineAnimalSell", true)
addEventHandler("declineAnimalSell", getRootElement(), function()
  if sellingWindow then
    seexports.rl_gui:deleteGuiElement(sellingWindow)
    sellingWindow = false
    triggerServerEvent("animalSellResponse", localPlayer, false)
  end
end)
addEvent("endAnimalSell", true)
addEventHandler("endAnimalSell", getRootElement(), function()
  if sellingWindow then
    seexports.rl_gui:deleteGuiElement(sellingWindow)
    sellingWindow = false
  end
end)
addEvent("startAnimalSelling", true)
addEventHandler("startAnimalSelling", getRootElement(), function(animalId, data, price)
  if isElement(source) then
    local titleBarHeight = seexports.rl_gui:getTitleBarHeight()
    local panelWidth = 275
    local panelHeight = titleBarHeight + 140 + 5 + 30
    if sellingWindow then
      seexports.rl_gui:deleteGuiElement(sellingWindow)
    end
    sellingWindow = seexports.rl_gui:createGuiElement("window", screenX / 2 - panelWidth / 2, screenY - panelHeight - 48, panelWidth, panelHeight)
    seexports.rl_gui:setWindowTitle(sellingWindow, "16/BebasNeueRegular.otf", "Háziállat eladási ajánlat")
    local health = math.floor(data.health + 0.5)
    local hunger = math.floor(data.hunger + 0.5)
    local love = math.floor(data.love + 0.5)
    if health <= 25 then
      health = seexports.rl_gui:getColorCodeHex("v4red") .. health .. "%#ffffff"
    elseif health <= 75 then
      health = seexports.rl_gui:getColorCodeHex("v4yellow") .. health .. "%#ffffff"
    else
      health = seexports.rl_gui:getColorCodeHex("v4green") .. health .. "%#ffffff"
    end
    if hunger <= 25 then
      hunger = seexports.rl_gui:getColorCodeHex("v4red") .. hunger .. "%#ffffff"
    elseif hunger <= 75 then
      hunger = seexports.rl_gui:getColorCodeHex("v4yellow") .. hunger .. "%#ffffff"
    else
      hunger = seexports.rl_gui:getColorCodeHex("v4green") .. hunger .. "%#ffffff"
    end
    if love <= 25 then
      love = seexports.rl_gui:getColorCodeHex("v4red") .. love .. "%#ffffff"
    elseif love <= 75 then
      love = seexports.rl_gui:getColorCodeHex("v4yellow") .. love .. "%#ffffff"
    else
      love = seexports.rl_gui:getColorCodeHex("v4green") .. love .. "%#ffffff"
    end
    local label = seexports.rl_gui:createGuiElement("label", 5, titleBarHeight, panelWidth - 10, 140, sellingWindow)
    seexports.rl_gui:setLabelFont(label, "11/Ubuntu-L.ttf")
    seexports.rl_gui:setLabelAlignment(label, "left", "center")
    seexports.rl_gui:setLabelText(label, "Név: " .. seexports.rl_gui:getColorCodeHex("v4green") .. "[" .. animalId .. "] " .. data.name .. [[
#ffffff
Fajta: ]] .. seexports.rl_gui:getColorCodeHex("v4green") .. data.type .. "\n#ffffffÉleterő: " .. health .. "\nÉhség: " .. hunger .. [[

Szeretet: ]] .. love .. "\nEladó: " .. seexports.rl_gui:getColorCodeHex("v4green") .. getElementData(source, "visibleName"):gsub("_", " ") .. "\n#FFFFFFÁr: " .. seexports.rl_gui:getColorCodeHex("v4green") .. seexports.rl_gui:thousandsStepper(price) .. " $")
    local btnW = (panelWidth - 15) / 2
    local btn = seexports.rl_gui:createGuiElement("button", 5, panelHeight - 35, btnW, 30, sellingWindow)
    seexports.rl_gui:setGuiBackground(btn, "solid", "v4green")
    seexports.rl_gui:setGuiHover(btn, "gradient", {
      "v4green",
      "v4green-second"
    })
    seexports.rl_gui:setButtonFont(btn, "15/BebasNeueBold.otf")
    seexports.rl_gui:setButtonTextColor(btn, "#ffffff")
    seexports.rl_gui:setButtonText(btn, "Vásárlás")
    seexports.rl_gui:setClickEvent(btn, "acceptAnimalSell", false)
    local btn = seexports.rl_gui:createGuiElement("button", 10 + btnW, panelHeight - 35, btnW, 30, sellingWindow)
    seexports.rl_gui:setGuiBackground(btn, "solid", "v4red")
    seexports.rl_gui:setGuiHover(btn, "gradient", {
      "v4red",
      "v4red-second"
    })
    seexports.rl_gui:setButtonFont(btn, "15/BebasNeueBold.otf")
    seexports.rl_gui:setButtonTextColor(btn, "#ffffff")
    seexports.rl_gui:setButtonText(btn, "Mégsem")
    seexports.rl_gui:setClickEvent(btn, "declineAnimalSell", false)
  end
end)
