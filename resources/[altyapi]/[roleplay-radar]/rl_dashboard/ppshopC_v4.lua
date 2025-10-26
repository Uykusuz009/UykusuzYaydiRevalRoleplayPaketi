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
local screenX, screenY = guiGetScreenSize()
local dashboardGridSize = {6, 4}
local dashboardPadding = {
  screenX <= 1366 and math.floor(screenX * 0.075) or math.floor(screenX * 0.15),
  math.floor(screenY * 0.15),
  screenX <= 1366 and (screenX <= 1024 and 2 or 3) or 4
}
local oneSize = {
  math.floor((screenX - dashboardPadding[1] * 2) / dashboardGridSize[1] / 10 + 0.5) * 10,
  math.floor((screenY - dashboardPadding[2] * 2) / dashboardGridSize[2] / 10 + 0.5) * 10
}
local dashSize = {
  oneSize[1] * dashboardGridSize[1],
  oneSize[2] * dashboardGridSize[2]
}
local shopSize = {
  math.max(3, math.floor(dashSize[1] / 220)),
  math.max(2, math.floor(dashSize[2] / 190))
}
local currentMenu = 1
local currentPage = 1
local pagerButtons = {}
local inside = false
buyingItem = false
local ppBuyWindow = false
local buyingWindow = false
local buyingRect = false
local buyingLabel = false
local shopButtons = false
function ppInsideDestroy()
  pagerButtons = false
  buyingLabel = false
  buyingItem = false
  shopButtons = false
  inside = false
  if ppBuyRect then
    seexports.rl_gui:deleteGuiElement(ppBuyRect)
  end
  ppBuyRect = false
  if ppBuyWindow then
    seexports.rl_gui:deleteGuiElement(ppBuyWindow)
  end
  ppBuyWindow = false
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
end
local rtg = false
local sx, sy = 0, 0
local buttonsWidth = 0
addEvent("ppShopPageSelector", true)
addEventHandler("ppShopPageSelector", getRootElement(), function(button, state, absoluteX, absoluteY, el)
  if pagerButtons[el] then
    if tonumber(pagerButtons[el]) then
      currentPage = pagerButtons[el]
    elseif pagerButtons[el] == "next" then
      currentPage = currentPage + 1
    elseif pagerButtons[el] == "prev" then
      currentPage = currentPage - 1
    end
    drawPPMenu()
  end
end)
function drawPPMenu()
  shopButtons = {}
  buyingLabel = false
  buyingItem = false
  if ppBuyRect then
    seexports.rl_gui:deleteGuiElement(ppBuyRect)
  end
  ppBuyRect = false
  if ppBuyWindow then
    seexports.rl_gui:deleteGuiElement(ppBuyWindow)
  end
  ppBuyWindow = false
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
  if inside then
    seexports.rl_gui:deleteGuiElement(inside)
  end
  inside = seexports.rl_gui:createGuiElement("null", 0, 0, sx, sy, rtg)
  local label = seexports.rl_gui:createGuiElement("label", dashboardPadding[3] * 4, 0, buttonsWidth - dashboardPadding[3] * 4 * 2, sy, inside)
  seexports.rl_gui:setLabelFont(label, "15/BebasNeueRegular.otf")
  seexports.rl_gui:setLabelAlignment(label, "left", "bottom")
  seexports.rl_gui:setLabelText(label, "Egyenleg:\n" .. seexports.rl_gui:getColorCodeHex("v4blue") .. seexports.rl_gui:thousandsStepper(ppBalance) .. " PP")
  local btn = seexports.rl_gui:createGuiElement("button", buttonsWidth / 2 + dashboardPadding[3] * 4, sy - 30, buttonsWidth / 2 - dashboardPadding[3] * 4 * 2, 30, inside)
  seexports.rl_gui:setGuiBackground(btn, "solid", "v4blue")
  seexports.rl_gui:setGuiHover(btn, "gradient", {
    "v4blue",
    "v4blue-second"
  })
  seexports.rl_gui:setButtonFont(btn, "13/BebasNeueBold.otf")
  seexports.rl_gui:setButtonTextColor(btn, "#ffffff")
  seexports.rl_gui:setButtonText(btn, "PP vásárlás")
  seexports.rl_gui:setClickEvent(btn, "openSMSPanel", false)
  local x = buttonsWidth + dashboardPadding[3] * 2
  local y = dashboardPadding[3] * 2
  local oneX = (sx - x + dashboardPadding[3] * 2) / shopSize[1]
  local oneY = sy / shopSize[2]
  local num = shopSize[1] * shopSize[2]
  local pages = math.ceil(#menus[currentMenu].items / num)
  pagerButtons = {}
  oneX = (sx - x - 64 + dashboardPadding[3] * 2) / shopSize[1]
  x = x + 32
  oneY = (sy - 24) / shopSize[2]
  if 1 < currentPage then
    local rect = seexports.rl_gui:createGuiElement("rectangle", buttonsWidth, dashboardPadding[3] * 4, 32 + dashboardPadding[3] * 2, sy - 24 - dashboardPadding[3] * 4, inside)
    local el = seexports.rl_gui:createGuiElement("image", buttonsWidth + dashboardPadding[3] * 1, dashboardPadding[3] * 4 + (sy - 24 - dashboardPadding[3] * 4) / 2 - 16, 32, 32, inside)
    seexports.rl_gui:setGuiHover(el, "solid", "v4blue")
    seexports.rl_gui:setGuiHoverable(el, true)
    seexports.rl_gui:setClickEvent(el, "ppShopPageSelector")
    seexports.rl_gui:setImageFile(el, seexports.rl_gui:getFaIconFilename("chevron-left", 32))
    seexports.rl_gui:setGuiBoundingBox(el, rect)
    pagerButtons[el] = "prev"
  end
  if pages > currentPage then
    local rect = seexports.rl_gui:createGuiElement("rectangle", sx + dashboardPadding[3] * 4 - 32 - dashboardPadding[3] * 2, dashboardPadding[3] * 4, 32 + dashboardPadding[3] * 2, sy - 24 - dashboardPadding[3] * 4, inside)
    local el = seexports.rl_gui:createGuiElement("image", sx + dashboardPadding[3] * 4 - 32 - dashboardPadding[3] * 1, dashboardPadding[3] * 4 + (sy - 24 - dashboardPadding[3] * 4) / 2 - 16, 32, 32, inside)
    seexports.rl_gui:setGuiHover(el, "solid", "v4blue")
    seexports.rl_gui:setGuiHoverable(el, true)
    seexports.rl_gui:setClickEvent(el, "ppShopPageSelector")
    seexports.rl_gui:setImageFile(el, seexports.rl_gui:getFaIconFilename("chevron-right", 32))
    seexports.rl_gui:setGuiBoundingBox(el, rect)
    pagerButtons[el] = "next"
  end
  for i = 1, pages do
    local el = seexports.rl_gui:createGuiElement("image", buttonsWidth + (sx - buttonsWidth + dashboardPadding[3] * 4) / 2 - pages * 16 / 2 + (i - 1) * 16, sy - 24 + dashboardPadding[3] * 4, 16, 16, inside)
    seexports.rl_gui:setGuiHover(el, "solid", "v4blue")
    seexports.rl_gui:setGuiHoverable(el, i ~= currentPage)
    seexports.rl_gui:setClickEvent(el, "ppShopPageSelector")
    seexports.rl_gui:setImageFile(el, seexports.rl_gui:getFaIconFilename("circle", 16, i == currentPage and "solid" or "regular"))
    pagerButtons[el] = i
  end
  local h = seexports.rl_gui:getFontHeight("14/BebasNeueRegular.otf")
  local w = oneX - dashboardPadding[3] * 4
  local col = seexports.rl_gui:getColorCode("v4grey2")
  for i = 1, shopSize[1] do
    y = dashboardPadding[3] * 2
    for j = 1, shopSize[2] do
      local id = i + (j - 1) * shopSize[1] + (currentPage - 1) * num
      local data = menus[currentMenu].items[id]
      if data then
        local rect = seexports.rl_gui:createGuiElement("rectangle", x + dashboardPadding[3] * 2 + 1, y + dashboardPadding[3] * 2 + 1, w, oneY - dashboardPadding[3] * 4, inside)
        seexports.rl_gui:setGuiBackground(rect, "solid", "#000000")
        local rect = seexports.rl_gui:createGuiElement("rectangle", x + dashboardPadding[3] * 2, y + dashboardPadding[3] * 2, w, oneY - dashboardPadding[3] * 4, inside)
        seexports.rl_gui:setGuiBackground(rect, "gradient", {"v4grey3", "v4grey1"})
        local item = seexports.rl_gui:createGuiElement("image", math.floor(x + oneX / 2 - 18) - 15, math.floor(y + dashboardPadding[3] * 4 + 9) - 15, 66, 66, inside)
        seexports.rl_gui:setImageDDS(item, ":rl_hud/files/itemHover.dds")
        seexports.rl_gui:setImageColor(item, "v4blue")
        local item = seexports.rl_gui:createGuiElement("image", math.floor(x + oneX / 2 - 18), math.floor(y + dashboardPadding[3] * 4 + 9), 36, 36, inside)
        if data[1] == "money" then
          seexports.rl_gui:setImageDDS(item, ":rl_dashboard/files/money.dds")
        else
          seexports.rl_gui:setImageFile(item, ":rl_items/" .. seexports.rl_items:getItemPic(data[1]))
        end
        if weaponPreviewNames[data[1]] then
          seexports.rl_gui:guiSetTooltipImageDDS(item, ":rl_dashboard/files/weps/" .. weaponPreviewNames[data[1]] .. ".dds", 512, 288)
          seexports.rl_gui:setGuiHoverable(item, true)
        end
        local itemData = false
        if data[3] then
          local index = data[1] .. "-" .. data[3]
          itemData = itemDatas[index]
        else
          itemData = itemDatas[data[1]]
        end
        local label = seexports.rl_gui:createGuiElement("label", x, y + dashboardPadding[3] * 4 + 45, oneX, oneY - dashboardPadding[3] * 6 - 48 - (dashboardPadding[3] * 4 + 45), inside)
        seexports.rl_gui:setLabelFont(label, "14/BebasNeueRegular.otf")
        seexports.rl_gui:setLabelAlignment(label, "center", "center")
        seexports.rl_gui:setLabelText(label, utf8.upper(itemData[1]))
        local width = seexports.rl_gui:getLabelTextWidth(label)
        local specialTooltip = seexports.rl_items:getItemSpecialTooltip(data[1])
        if width >= w - 16 then
          local text = utf8.sub(utf8.upper(itemData[1]), 1, -6)
          if utf8.sub(text, 1) == " " then
            text = utf8.sub(utf8.upper(itemData[1]), 1, -2)
          end
          text = text .. "..."
          local i = utf8.len(text)
          while width >= w - 16 do
            seexports.rl_gui:setLabelText(label, text)
            width = seexports.rl_gui:getLabelTextWidth(label)
            text = utf8.sub(text, 1, -6) .. "..."
          end
          if weaponAmmoNames[data[1]] then
            seexports.rl_gui:guiSetTooltip(label, itemData[1] .. "\nLőszer: " .. seexports.rl_gui:getColorCodeHex("v4blue") .. weaponAmmoNames[data[1]])
          elseif weaponsForAmmo[data[1]] then
            seexports.rl_gui:guiSetTooltip(label, itemData[1] .. "\n" .. seexports.rl_gui:getColorCodeHex("v4blue") .. "Fegyverek:\n" .. table.concat(weaponsForAmmo[data[1]], "\n"))
          elseif specialTooltip then
            specialTooltip = utf8.gsub(specialTooltip, "\n", "\n" .. seexports.rl_gui:getColorCodeHex("v4blue"))
            seexports.rl_gui:guiSetTooltip(label, itemData[1] .. "\n" .. seexports.rl_gui:getColorCodeHex("v4blue") .. specialTooltip)
          else
            seexports.rl_gui:guiSetTooltip(label, itemData[1])
          end
          seexports.rl_gui:setGuiHoverable(label, true)
        elseif weaponAmmoNames[data[1]] then
          seexports.rl_gui:guiSetTooltip(label, "Lőszer: " .. seexports.rl_gui:getColorCodeHex("v4blue") .. weaponAmmoNames[data[1]])
          seexports.rl_gui:setGuiHoverable(label, true)
        elseif weaponsForAmmo[data[1]] then
          seexports.rl_gui:guiSetTooltip(label, seexports.rl_gui:getColorCodeHex("v4blue") .. "Fegyverek:\n" .. table.concat(weaponsForAmmo[data[1]], "\n"))
          seexports.rl_gui:setGuiHoverable(label, true)
        elseif specialTooltip then
          specialTooltip = utf8.gsub(specialTooltip, "\n", "\n" .. seexports.rl_gui:getColorCodeHex("v4blue"))
          seexports.rl_gui:guiSetTooltip(label, seexports.rl_gui:getColorCodeHex("v4blue") .. specialTooltip)
          seexports.rl_gui:setGuiHoverable(label, true)
        end
        if data[2] > ppBalance then
          local btn = seexports.rl_gui:createGuiElement("button", x + dashboardPadding[3] * 4, y + oneY - dashboardPadding[3] * 4 - 24, oneX - dashboardPadding[3] * 8, 24, inside)
          seexports.rl_gui:setGuiBackground(btn, "solid", "v4red")
          seexports.rl_gui:setElementDisabled(btn, true)
          seexports.rl_gui:setButtonFont(btn, "13/BebasNeueBold.otf")
          seexports.rl_gui:setButtonTextColor(btn, "#ffffff")
          seexports.rl_gui:setButtonText(btn, "Nincs elég PP-d!")
        else
          local btn = seexports.rl_gui:createGuiElement("button", x + dashboardPadding[3] * 4, y + oneY - dashboardPadding[3] * 4 - 24, oneX - dashboardPadding[3] * 8, 24, inside)
          seexports.rl_gui:setGuiBackground(btn, "solid", "v4blue")
          seexports.rl_gui:setGuiHover(btn, "gradient", {
            "v4blue",
            "v4blue-second"
          })
          seexports.rl_gui:setButtonFont(btn, "13/BebasNeueBold.otf")
          seexports.rl_gui:setButtonTextColor(btn, "#ffffff")
          seexports.rl_gui:setButtonText(btn, "VÁSÁRLÁS")
          shopButtons[btn] = {
            currentMenu,
            id,
            data
          }
          seexports.rl_gui:setClickEvent(btn, "buyPPItem", false)
        end
        local text = " " .. seexports.rl_gui:thousandsStepper(data[2]) .. " PP "
        local tw = seexports.rl_gui:getTextWidthFont(text, "13/BebasNeueBold.otf")
        local rect = seexports.rl_gui:createGuiElement("rectangle", x + oneX / 2 - tw / 2, y + oneY - dashboardPadding[3] * 6 - 48, tw, 24, inside)
        seexports.rl_gui:setGuiBackground(rect, "solid", "v4green")
        local label = seexports.rl_gui:createGuiElement("label", 0, 0, tw, 24, rect)
        seexports.rl_gui:setLabelFont(label, "13/BebasNeueBold.otf")
        seexports.rl_gui:setLabelAlignment(label, "center", "center")
        seexports.rl_gui:setLabelText(label, text)
        seexports.rl_gui:setLabelColor(label, "v4grey1")
        if data[2] > ppBalance then
          local rect = seexports.rl_gui:createGuiElement("rectangle", x + dashboardPadding[3] * 2, y + dashboardPadding[3] * 2, w + 1, oneY, inside)
          seexports.rl_gui:setGuiBackground(rect, "solid", {
            col[1],
            col[2],
            col[3],
            125
          })
          else
          end
        end
      y = y + oneY
    end
    x = x + oneX
  end
end
addEvent("gotPremiumData", true)
addEventHandler("gotPremiumData", getRootElement(), function(balance)
  ppBalance = balance
  if dashboardState then
    seexports.rl_gui:setLabelText(ppLabelElement, seexports.rl_gui:thousandsStepper(ppBalance) .. " PP")
    seexports.rl_gui:setGuiSize(ppLabelElement2, seexports.rl_gui:getGuiSize(ppLabelElement, "x") - seexports.rl_gui:getLabelTextWidth(ppLabelElement), false)
    if dashboardExpanded then
      refreshVehiclesBottomLabel()
      local i, j = dashboardExpanded[1], dashboardExpanded[2]
      if dashboardLayout[i][j].ppShop then
        drawPPMenu()
      end
    end
  end
end)
function ppInsideDraw(x, y, isx, isy, i, j, irtg)
  rtg = irtg
  sx, sy = isx, isy
  buttonsWidth = 0
  local fontSize = bebasSize - 10
  local buttonsHeight = seexports.rl_gui:getFontHeight(fontSize .. "/BebasNeueRegular.otf") + dashboardPadding[3] * 4
  for k = 1, #menus do
    local w = seexports.rl_gui:getTextWidthFont(menus[k].name, fontSize .. "/BebasNeueRegular.otf")
    if w > buttonsWidth then
      buttonsWidth = w
    end
  end
  buttonsWidth = buttonsWidth + dashboardPadding[3] * 8
  local rect = seexports.rl_gui:createGuiElement("rectangle", x + buttonsWidth, y, sx - buttonsWidth, sy, rtg)
  seexports.rl_gui:setGuiBackground(rect, "solid", "v4grey2")
  for k = 1, #menus do
    menus[k].button = seexports.rl_gui:createGuiElement("button", x, y, buttonsWidth, buttonsHeight, rtg)
    if currentMenu == k then
      seexports.rl_gui:setGuiBackground(menus[k].button, "solid", "v4blue")
      seexports.rl_gui:setGuiHover(menus[k].button, "gradient", {
        "v4blue-second",
        "v4blue"
      }, true)
    else
      seexports.rl_gui:setGuiBackground(menus[k].button, "solid", "v4grey1")
      seexports.rl_gui:setGuiHover(menus[k].button, "gradient", {"v4grey2", "v4grey1"}, true)
    end
    seexports.rl_gui:setButtonFont(menus[k].button, fontSize .. "/BebasNeueRegular.otf")
    seexports.rl_gui:setButtonTextColor(menus[k].button, "#ffffff")
    seexports.rl_gui:setButtonText(menus[k].button, menus[k].name)
    seexports.rl_gui:setButtonTextAlign(menus[k].button, "left", "center")
    seexports.rl_gui:setButtonTextPadding(menus[k].button, dashboardPadding[3] * 4, dashboardPadding[3] * 2)
    seexports.rl_gui:setClickEvent(menus[k].button, "dashboardPPMenuClick", false)
    y = y + buttonsHeight
  end
  sx = sx - dashboardPadding[3] * 4
  sy = sy - dashboardPadding[3] * 4
  drawPPMenu()
end
addEvent("closePPBuy", true)
addEventHandler("closePPBuy", getRootElement(), function()
  buyingLabel = false
  buyingItem = false
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
end)
local currentAmount = 1
local currentPrice = 1
addEvent("changePPShopAmount", true)
addEventHandler("changePPShopAmount", getRootElement(), function(value)
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
  seexports.rl_gui:setLabelText(buyingLabel, "Fizetendő: " .. seexports.rl_gui:getColorCodeHex("v4blue") .. "" .. seexports.rl_gui:thousandsStepper(currentPrice * currentAmount) .. " PP")
end)
addEvent("finalBuyPPItem", true)
addEventHandler("finalBuyPPItem", getRootElement(), function()
  if currentPrice * currentAmount > ppBalance then
    seexports.rl_gui:showInfobox("e", "Nincs elég PrémiumPontod!")
  elseif buyingItem then
    triggerServerEvent("buyPremiumItem", localPlayer, buyingItem[1], buyingItem[2], currentAmount)
    buyingLabel = false
    buyingItem = false
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
  end
end)
addEvent("closeSMSPanel", true)
addEventHandler("closeSMSPanel", getRootElement(), function()
  seexports.rl_gui:lockHover(rtg, false)
  seexports.rl_gui:lockHover(closeButton, false)
  seexports.rl_gui:lockHover(helpIcon, false)
  if ppBuyRect then
    seexports.rl_gui:deleteGuiElement(ppBuyRect)
  end
  ppBuyRect = false
  if ppBuyWindow then
    seexports.rl_gui:deleteGuiElement(ppBuyWindow)
  end
  ppBuyWindow = false
end)
addEvent("openSMSPanel", true)
addEventHandler("openSMSPanel", getRootElement(), function()
  seexports.rl_gui:lockHover(rtg, true)
  seexports.rl_gui:lockHover(closeButton, true)
  seexports.rl_gui:lockHover(helpIcon, true)
  ppBuyRect = seexports.rl_gui:createGuiElement("rectangle", 0, 0, screenX, screenY)
  seexports.rl_gui:setGuiBackground(ppBuyRect, "solid", {
    0,
    0,
    0,
    150
  })
  seexports.rl_gui:setGuiHover(ppBuyRect, "none")
  seexports.rl_gui:setGuiHoverable(ppBuyRect, true)
  seexports.rl_gui:disableClickTrough(ppBuyRect, true)
  seexports.rl_gui:disableLinkCursor(ppBuyRect, true)
  local titleBarHeight = seexports.rl_gui:getTitleBarHeight()
  local panelWidth = 780
  local panelHeight = titleBarHeight + 300 + 10 + 30 + 20
  ppBuyWindow = seexports.rl_gui:createGuiElement("window", screenX / 2 - panelWidth / 2, screenY / 2 - panelHeight / 2, panelWidth, panelHeight)
  seexports.rl_gui:setWindowTitle(ppBuyWindow, "16/BebasNeueRegular.otf", "PrémiumPont vásárlás - https://premium.sg-game.com/")
  seexports.rl_gui:setWindowCloseButton(ppBuyWindow, "closeSMSPanel")
  local item = seexports.rl_gui:createGuiElement("image", 421, titleBarHeight + 10, 349, 300, ppBuyWindow)
  seexports.rl_gui:setImageDDS(item, ":rl_dashboard/files/ill.dds")
  local label = seexports.rl_gui:createGuiElement("label", 10, titleBarHeight, 401, 320, ppBuyWindow)
  seexports.rl_gui:setLabelFont(label, "10/Ubuntu-L.ttf")
  seexports.rl_gui:setLabelAlignment(label, "center", "center")
  seexports.rl_gui:setLabelWordBreak(label, true)
  seexports.rl_gui:setLabelText(label, "Account ID: " .. getElementData(localPlayer, "char.accID") .. "\n\n\t\t\t- Több fizetési mód is elérhető:\n\t\t\tEzek között szerepel az OTP SimplePay Bankkártyás fizetés, a paysafecarddal történő fizetés, illetve az emelt díjas hívás.\n\t\t\t\n\t\t\t- Teljesen automata rendszer, sikeres fizetést követően szinte azonnal elérhető a vásárolt Prémum Pont mennyiség - szolgáltatás!\n\t\t\t\n\t\t\t- Bankkártyás és paysafecardos vásárlásnál új, nagyobb, kedvezőbb csomag is elérhető: Smaragd Csomag!\n\n\t\t\t- Bankkártyás fizetés esetén bónusz PrémiumPont jár.")
  local btn = seexports.rl_gui:createGuiElement("button", 10, titleBarHeight + 300 + 20, panelWidth - 20, 30, ppBuyWindow)
  seexports.rl_gui:setGuiBackground(btn, "solid", "v4green")
  seexports.rl_gui:setGuiHover(btn, "gradient", {
    "v4green",
    "v4green-second"
  }, false, true)
  seexports.rl_gui:setButtonFont(btn, "15/BebasNeueBold.otf")
  seexports.rl_gui:setButtonTextColor(btn, "#ffffff")
  seexports.rl_gui:setButtonText(btn, " PremiumShop megnyitása")
  seexports.rl_gui:setClickEvent(btn, "openPremiumShop")
  seexports.rl_gui:setButtonIcon(btn, seexports.rl_gui:getFaIconFilename("external-link", 30, "solid"))
end)
addEvent("openPremiumShop", true)
addEventHandler("openPremiumShop", getRootElement(), function()
  openURL("https://premium.sg-game.com/server/v4/")
end)
addEvent("buyPPItem", true)
addEventHandler("buyPPItem", getRootElement(), function(button, state, absoluteX, absoluteY, el)
  if shopButtons and shopButtons[el] then
    currentAmount = 1
    buyingItem = shopButtons[el]
    local data = buyingItem[3]
    currentPrice = data[2]
    local itemData = false
    if data[3] then
      local index = data[1] .. "-" .. data[3]
      itemData = itemDatas[index]
    else
      itemData = itemDatas[data[1]]
    end
    local canBuyMultiple = itemData[3]
    local titleBarHeight = seexports.rl_gui:getTitleBarHeight()
    local h = seexports.rl_gui:getFontHeight("14/BebasNeueRegular.otf")
    local panelWidth = 300
    local panelHeight = titleBarHeight + 5 + 66 + 5 + h + h * 2 + 30 + 5 + 5 + 5
    if canBuyMultiple then
      panelHeight = panelHeight + 32 + 5
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
    seexports.rl_gui:setGuiHover(buyingRect, "none")
    seexports.rl_gui:setGuiHoverable(buyingRect, true)
    seexports.rl_gui:disableClickTrough(buyingRect, true)
    seexports.rl_gui:disableLinkCursor(buyingRect, true)
    buyingWindow = seexports.rl_gui:createGuiElement("window", screenX / 2 - panelWidth / 2, screenY / 2 - panelHeight / 2, panelWidth, panelHeight)
    seexports.rl_gui:setWindowTitle(buyingWindow, "16/BebasNeueRegular.otf", "Premium Mağaza vásárlás")
    local y = titleBarHeight + 5
    local item = seexports.rl_gui:createGuiElement("image", panelWidth / 2 - 33, y, 66, 66, buyingWindow)
    seexports.rl_gui:setImageDDS(item, ":rl_hud/files/itemHover.dds")
    seexports.rl_gui:setImageColor(item, "v4blue")
    local item = seexports.rl_gui:createGuiElement("image", panelWidth / 2 - 18, y + 15, 36, 36, buyingWindow)
    if data[1] == "money" then
      seexports.rl_gui:setImageDDS(item, ":rl_dashboard/files/money.dds")
    else
      seexports.rl_gui:setImageFile(item, ":rl_items/" .. seexports.rl_items:getItemPic(data[1]))
    end
    if weaponPreviewNames[data[1]] then
      seexports.rl_gui:guiSetTooltipImageDDS(item, ":rl_dashboard/files/weps/" .. weaponPreviewNames[data[1]] .. ".dds", 512, 288)
      seexports.rl_gui:setGuiHoverable(item, true)
    end
    y = y + 66 + 5
    local label = seexports.rl_gui:createGuiElement("label", 5, y, panelWidth - 5, h, buyingWindow)
    seexports.rl_gui:setLabelFont(label, "14/BebasNeueRegular.otf")
    seexports.rl_gui:setLabelAlignment(label, "center", "center")
    seexports.rl_gui:setLabelText(label, utf8.upper(itemData[1]))
    y = y + h + 5
    if canBuyMultiple then
      local input = seexports.rl_gui:createGuiElement("input", 32, y, panelWidth - 64, 32, buyingWindow)
      seexports.rl_gui:setInputFont(input, "11/Ubuntu-R.ttf")
      seexports.rl_gui:setInputIcon(input, "boxes")
      seexports.rl_gui:setInputPlaceholder(input, "Mennyiség")
      seexports.rl_gui:setInputMaxLength(input, 5)
      seexports.rl_gui:setInputNumberOnly(input, true)
      seexports.rl_gui:setInputChangeEvent(input, "changePPShopAmount")
      y = y + 32 + 5
    end
    buyingLabel = seexports.rl_gui:createGuiElement("label", 5, y, panelWidth - 5, h * 2, buyingWindow)
    seexports.rl_gui:setLabelFont(buyingLabel, "11/Ubuntu-R.ttf")
    seexports.rl_gui:setLabelAlignment(buyingLabel, "center", "center")
    seexports.rl_gui:setLabelText(buyingLabel, "Fizetendő: " .. seexports.rl_gui:getColorCodeHex("v4blue") .. "" .. seexports.rl_gui:thousandsStepper(currentPrice * currentAmount) .. " PP")
    seexports.rl_gui:setLabelColor(buyingLabel, "v4lightgrey")
    local btnW = (panelWidth - 15) / 2
    local btn = seexports.rl_gui:createGuiElement("button", 5, panelHeight - 35, btnW, 30, buyingWindow)
    seexports.rl_gui:setGuiBackground(btn, "solid", "v4green")
    seexports.rl_gui:setGuiHover(btn, "gradient", {
      "v4green",
      "v4green-second"
    }, false, true)
    seexports.rl_gui:setButtonFont(btn, "15/BebasNeueBold.otf")
    seexports.rl_gui:setButtonTextColor(btn, "#ffffff")
    seexports.rl_gui:setButtonText(btn, "Vásárlás")
    seexports.rl_gui:setClickEvent(btn, "finalBuyPPItem", false)
    local btn = seexports.rl_gui:createGuiElement("button", 10 + btnW, panelHeight - 35, btnW, 30, buyingWindow)
    seexports.rl_gui:setGuiBackground(btn, "solid", "v4red")
    seexports.rl_gui:setGuiHover(btn, "gradient", {
      "v4red",
      "v4red-second"
    }, false, true)
    seexports.rl_gui:setButtonFont(btn, "15/BebasNeueBold.otf")
    seexports.rl_gui:setButtonTextColor(btn, "#ffffff")
    seexports.rl_gui:setButtonText(btn, "Mégsem")
    seexports.rl_gui:setClickEvent(btn, "closePPBuy", false)
  end
end)
addEvent("dashboardPPMenuClick", true)
addEventHandler("dashboardPPMenuClick", getRootElement(), function(button, state, absoluteX, absoluteY, el)
  for k = 1, #menus do
    if el == menus[k].button then
      currentMenu = k
      currentPage = 1
      seexports.rl_gui:setGuiBackground(menus[k].button, "solid", "v4blue")
      seexports.rl_gui:setGuiHover(menus[k].button, "gradient", {
        "v4blue-second",
        "v4blue"
      }, true)
    else
      seexports.rl_gui:setGuiBackground(menus[k].button, "solid", "v4grey1")
      seexports.rl_gui:setGuiHover(menus[k].button, "gradient", {"v4grey2", "v4grey1"}, true)
    end
  end
  drawPPMenu()
end)
