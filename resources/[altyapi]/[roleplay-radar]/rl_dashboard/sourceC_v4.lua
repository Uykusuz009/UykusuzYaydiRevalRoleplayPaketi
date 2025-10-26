local seexports = {
  rl_gui = false,
  rl_groups = false,
  rl_reports = false,
  rl_permission = false,
  rl_core = false,
  rl_weapons = false,
  rl_clothesshop = false,
  pattach = false,
  rl_farm = false,
  rl_paintshop = false,
  rl_hud = false,
  rl_radar = false,
  rl_death = false,
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
local seelangGuiRefreshColors = function()
  local res = getResourceFromName("rl_gui")
  if res and getResourceState(res) == "running" then
    createGuiCache()
  end
end
addEventHandler("onGuiRefreshColors", getRootElement(), seelangGuiRefreshColors)
addEventHandler("onClientResourceStart", getResourceRootElement(), seelangGuiRefreshColors)
local seelangCondHandlState0 = false
local function seelangCondHandl0(cond, prio)
  cond = cond and true or false
  if cond ~= seelangCondHandlState0 then
    seelangCondHandlState0 = cond
    if cond then
      addEventHandler("onClientPreRender", getRootElement(), renderCharSet, true, prio)
    else
      removeEventHandler("onClientPreRender", getRootElement(), renderCharSet)
    end
  end
end
farms = {}
otherRentables = {}
interiorRenderList = {}
function createElementMatrix(rx, ry, rz)
  local rx, ry, rz = math.rad(rx), math.rad(ry), math.rad(rz)
  return {
    {
      math.cos(rz) * math.cos(ry) - math.sin(rz) * math.sin(rx) * math.sin(ry),
      math.cos(ry) * math.sin(rz) + math.cos(rz) * math.sin(rx) * math.sin(ry),
      -math.cos(rx) * math.sin(ry),
      0
    },
    {
      -math.cos(rx) * math.sin(rz),
      math.cos(rz) * math.cos(rx),
      math.sin(rx),
      0
    },
    {
      math.cos(rz) * math.sin(ry) + math.cos(ry) * math.sin(rz) * math.sin(rx),
      math.sin(rz) * math.sin(ry) - math.cos(rz) * math.cos(ry) * math.sin(rx),
      math.cos(rx) * math.cos(ry),
      0
    },
    {
      0,
      0,
      0,
      1
    }
  }
end
function getEulerAnglesFromMatrix(mat)
  local nz1, nz2, nz3
  nz3 = math.sqrt(mat[2][1] * mat[2][1] + mat[2][2] * mat[2][2])
  nz1 = -mat[2][1] * mat[2][3] / nz3
  nz2 = -mat[2][2] * mat[2][3] / nz3
  local vx = nz1 * mat[1][1] + nz2 * mat[1][2] + nz3 * mat[1][3]
  local vz = nz1 * mat[3][1] + nz2 * mat[3][2] + nz3 * mat[3][3]
  return math.deg(math.asin(mat[2][3])), -math.deg(math.atan2(vx, vz)), -math.deg(math.atan2(mat[2][1], mat[2][2]))
end
function getPositionFromMatrixOffset(mat, x, y, z)
  return x * mat[1][1] + y * mat[2][1] + z * mat[3][1] + mat[4][1], x * mat[1][2] + y * mat[2][2] + z * mat[3][2] + mat[4][2], x * mat[1][3] + y * mat[2][3] + z * mat[3][3] + mat[4][3]
end
function matrixMultiply(mat1, mat2)
  local matOut = {}
  for i = 1, #mat1 do
    matOut[i] = {}
    for j = 1, #mat2[1] do
      local num = mat1[i][1] * mat2[1][j]
      for n = 2, #mat1[1] do
        num = num + mat1[i][n] * mat2[n][j]
      end
      matOut[i][j] = num
    end
  end
  return matOut
end
screenX, screenY = guiGetScreenSize()
dashboardGridSize = {6, 4}
dashboardPadding = {
  screenX <= 1366 and math.floor(screenX * 0.075) or math.floor(screenX * 0.15),
  math.floor(screenY * 0.15),
  screenX <= 1366 and (screenX <= 1024 and 2 or 3) or 4
}
oneSize = {
  math.floor((screenX - dashboardPadding[1] * 2) / dashboardGridSize[1] / 10 + 0.5) * 10,
  math.floor((screenY - dashboardPadding[2] * 2) / dashboardGridSize[2] / 10 + 0.5) * 10
}
dashSize = {
  oneSize[1] * dashboardGridSize[1],
  oneSize[2] * dashboardGridSize[2]
}
dashboardPos = {
  screenX / 2 - dashSize[1] / 2,
  screenY / 2 - dashSize[2] / 2
}
imageSizes = screenX <= 1300 and 128 or screenX <= 1600 and 196 or 256
bebasSize = math.floor(screenX / 64)
dashboardGui = false
local screenShader = false
screenSrc = false
local expandTime = 750
local curtainTime = 350
dashboardLayout = {}
for i = 1, dashboardGridSize[1] do
  dashboardLayout[i] = {}
end
backgroundSizes = {}
local charDatas = {}
function drawAccountInfo(x, y, sx, sy, rtg, i, j)
  for k = 1, #charDatas do
    local label = seexports.rl_gui:createGuiElement("label", x, y, sx, sy, rtg)
    seexports.rl_gui:setLabelFont(label, "12/Ubuntu-R.ttf")
    seexports.rl_gui:setLabelAlignment(label, "left", "top")
    seexports.rl_gui:setLabelText(label, charDatas[k][1])
    table.insert(dashboardLayout[i][j].labels, label)
    local label = seexports.rl_gui:createGuiElement("label", x + seexports.rl_gui:getLabelTextWidth(label), y, sx, sy, rtg)
    seexports.rl_gui:setLabelFont(label, "12/Ubuntu-L.ttf")
    seexports.rl_gui:setLabelAlignment(label, "left", "top")
    seexports.rl_gui:setLabelText(label, charDatas[k][2])
    table.insert(dashboardLayout[i][j].labels, label)
    y = y + seexports.rl_gui:getLabelFontHeight(label)
  end
end
function checkIfGroupsAvailable()
  local myGroups = seexports.rl_groups:getPlayerGroupMembership()
  local count = 0
  for k in pairs(myGroups) do
    count = count + 1
    break
  end
  local retVal = 0 < count
  if not retVal then
    seexports.rl_gui:showInfobox("e", "Nem vagy egy frakció tagja sem!")
  end
  return retVal
end
ppBalance = 0
ppLabelElement = false
ppLabelElement2 = false

function drawPremiumInfo(x, y, sx, sy, rtg, i, j)
  ppBalance = getElementData(localPlayer, "acc.premiumPoints") or 0
  
  local label = seexports.rl_gui:createGuiElement("label", x, y, sx, sy, rtg)
  seexports.rl_gui:setLabelFont(label, "12/Ubuntu-L.ttf")
  seexports.rl_gui:setLabelAlignment(label, "right", "bottom")
  seexports.rl_gui:setLabelColor(label, "v4blue")
  seexports.rl_gui:setLabelText(label, seexports.rl_gui:thousandsStepper(ppBalance) .. " SC")
  ppLabelElement = label
  table.insert(dashboardLayout[i][j].labels, label)
  local label = seexports.rl_gui:createGuiElement("label", x, y, sx - seexports.rl_gui:getLabelTextWidth(label), sy, rtg)
  seexports.rl_gui:setLabelFont(label, "12/Ubuntu-R.ttf")
  seexports.rl_gui:setLabelAlignment(label, "right", "bottom")
  seexports.rl_gui:setLabelText(label, "StarisCoin: ")
  ppLabelElement2 = label
  table.insert(dashboardLayout[i][j].labels, label)
end
function drawChangelogInfo(x, y, sx, sy, rtg, i, j)
  local fh = seexports.rl_gui:getFontHeight("12/Ubuntu-B.ttf")
  local fh2 = seexports.rl_gui:getFontHeight("10/Ubuntu-R.ttf")
  local bh = 0
  local by = 0
  if 0 < #newsBadge then
    bh = seexports.rl_gui:getFontHeight("10/Ubuntu-R.ttf") + 8
    by = -bh - 5
  end
  local bx = x + sx
  for k = #newsBadge, 1, -1 do
    local w = seexports.rl_gui:getTextWidthFont(newsBadge[k][1], "10/Ubuntu-R.ttf") + 8
    bx = bx - w - 4
    if bx < 0 then
      bx = x + sx - w - 4
      by = by - bh - 5
    end
    local rect = seexports.rl_gui:createGuiElement("rectangle", bx + 4, y + sy + by + 5, w, bh, rtg)
    --seexports.rl_gui:setGuiBackground(rect, "solid", newsBadge[k][2])
    table.insert(dashboardLayout[i][j].labels, rect)
    local label = seexports.rl_gui:createGuiElement("label", bx + 4, y + sy + by + 5, w, bh, rtg)
    seexports.rl_gui:setLabelFont(label, "10/Ubuntu-R.ttf")
    seexports.rl_gui:setLabelAlignment(label, "center", "center")
    seexports.rl_gui:setLabelColor(label, "#000000")
    seexports.rl_gui:setLabelText(label, newsBadge[k][1])
    table.insert(dashboardLayout[i][j].labels, label)
  end
  local label = seexports.rl_gui:createGuiElement("label", x, y + sy + by - fh2 - fh * 4, sx, fh * 4, rtg)
  seexports.rl_gui:setLabelFont(label, "12/Ubuntu-B.ttf")
  seexports.rl_gui:setLabelAlignment(label, "right", "bottom")
  seexports.rl_gui:setLabelText(label, newsTitle)
  seexports.rl_gui:setLabelWordBreak(label, true)
  seexports.rl_gui:setLabelShadow(label, "#000000ae", 1, 1)
  table.insert(dashboardLayout[i][j].labels, label)
  local label = seexports.rl_gui:createGuiElement("label", x, y + sy + by - fh2, sx, fh2, rtg)
  seexports.rl_gui:setLabelFont(label, "10/Ubuntu-R.ttf")
  seexports.rl_gui:setLabelAlignment(label, "right", "center")
  seexports.rl_gui:setLabelText(label, newsDate)
  seexports.rl_gui:setLabelShadow(label, "#000000ae", 1, 1)
  table.insert(dashboardLayout[i][j].labels, label)
end
vehicleLimitLabel = false
function drawVehiclesInfo(x, y, sx, sy, rtg, i, j)
  local label = seexports.rl_gui:createGuiElement("label", x, y, sx, sy, rtg)
  seexports.rl_gui:setLabelFont(label, bebasSize .. "/BebasNeueBold.otf")
  seexports.rl_gui:setLabelAlignment(label, "left", "top")
  seexports.rl_gui:setLabelText(label, "YUVALAR: ")
  table.insert(dashboardLayout[i][j].labels, label)
  local label = seexports.rl_gui:createGuiElement("label", x + seexports.rl_gui:getLabelTextWidth(label), y, sx, sy, rtg)
  seexports.rl_gui:setLabelFont(label, bebasSize .. "/BebasNeueLight.otf")
  seexports.rl_gui:setLabelAlignment(label, "left", "top")
  seexports.rl_gui:setLabelText(label, vehLimit)
  vehicleLimitLabel = label
  table.insert(dashboardLayout[i][j].labels, label)
end
local farmNum = 0
local rentableNum = 0
local farmNumLabel = false
local rentableNumLabel = false
local intiLimitLabel = false
local ownInteriorLabel = false
function drawInteriorsInfo(x, y, sx, sy, rtg, i, j)
  local label = seexports.rl_gui:createGuiElement("label", x, y, sx, sy, rtg)
  seexports.rl_gui:setLabelFont(label, bebasSize .. "/BebasNeueBold.otf")
  seexports.rl_gui:setLabelAlignment(label, "left", "top")
  seexports.rl_gui:setLabelText(label, "MÜLKLERİN: ")
  table.insert(dashboardLayout[i][j].labels, label)
  local label = seexports.rl_gui:createGuiElement("label", x + seexports.rl_gui:getLabelTextWidth(label), y, sx, sy, rtg)
  seexports.rl_gui:setLabelFont(label, bebasSize .. "/BebasNeueLight.otf")
  seexports.rl_gui:setLabelAlignment(label, "left", "top")
  seexports.rl_gui:setLabelText(label, interiorLimit)
  ownInteriorLabel = label
  table.insert(dashboardLayout[i][j].labels, label)
  y = y + seexports.rl_gui:getLabelFontHeight(label)
  local label = seexports.rl_gui:createGuiElement("label", x, y, sx, sy, rtg)
  seexports.rl_gui:setLabelFont(label, bebasSize .. "/BebasNeueBold.otf")
  seexports.rl_gui:setLabelAlignment(label, "left", "top")
  seexports.rl_gui:setLabelText(label, "KİRALAMA: ")
  table.insert(dashboardLayout[i][j].labels, label)
  local label = seexports.rl_gui:createGuiElement("label", x + seexports.rl_gui:getLabelTextWidth(label), y, sx, sy, rtg)
  seexports.rl_gui:setLabelFont(label, bebasSize .. "/BebasNeueLight.otf")
  seexports.rl_gui:setLabelAlignment(label, "left", "top")
  seexports.rl_gui:setLabelText(label, rentableNum)
  rentableNumLabel = label
  table.insert(dashboardLayout[i][j].labels, label)
  y = y + seexports.rl_gui:getLabelFontHeight(label)
  local label = seexports.rl_gui:createGuiElement("label", x, y, sx, sy, rtg)
  seexports.rl_gui:setLabelFont(label, bebasSize .. "/BebasNeueBold.otf")
  seexports.rl_gui:setLabelAlignment(label, "left", "top")
  seexports.rl_gui:setLabelText(label, "YUVALAR: ")
  table.insert(dashboardLayout[i][j].labels, label)
  local label = seexports.rl_gui:createGuiElement("label", x + seexports.rl_gui:getLabelTextWidth(label), y, sx, sy, rtg)
  seexports.rl_gui:setLabelFont(label, bebasSize .. "/BebasNeueLight.otf")
  seexports.rl_gui:setLabelAlignment(label, "left", "top")
  seexports.rl_gui:setLabelText(label, "yok")
  intiLimitLabel = label
  table.insert(dashboardLayout[i][j].labels, label)
end
adminList = {}
local adminRtg = false
local adminSize = {0, 0}
local adminPos = {0, 0}
local adminInside = false
local reportMode = false
function drawSideReport(x, y, sx, sy, btn)
  local w = sx / 3
  local label = seexports.rl_gui:createGuiElement("label", x + dashboardPadding[3] * 4, y + dashboardPadding[3] * 4, w, 32, adminInside)
  seexports.rl_gui:setLabelFont(label, "18/BebasNeueRegular.otf")
  seexports.rl_gui:setLabelAlignment(label, "left", "center")
  seexports.rl_gui:setLabelText(label, "Report rendszer")
  y = y + 4
  local label = seexports.rl_gui:createGuiElement("label", x + dashboardPadding[3] * 4, y + dashboardPadding[3] * 6 + 32, w - dashboardPadding[3] * 8, sy, adminInside)
  seexports.rl_gui:setLabelFont(label, "11/Ubuntu-L.ttf")
  seexports.rl_gui:setLabelAlignment(label, "left", "top")
  seexports.rl_gui:setLabelWordBreak(label, true)
  seexports.rl_gui:setLabelText(label, "Ha bármilyen problémába ütköznél, esetleg kérdésed lenne, itt, a Report rendszeren keresztül tudsz segítséget kérni.\n\nHasználd a Report létrehozása gombot ahhoz, hogy üzenetet - bejelentést küldj az adminisztrátor csapat felé.\n\nA bejelentésed kategóriáját válaszd ki megfelelően, minél egyszerűbben és lényegre törően fogalmazd meg a kérdésed/problémád.\n\nA bejelentés megírását követően, az online Adminisztrátor csapat fogja kezelni az ügyed, és ha bárki fogadja azt, értesülni fogsz róla. Ezután az üzenetváltó ablakban fogsz tudni kommunikálni.")
  if btn then
    local btn = seexports.rl_gui:createGuiElement("button", x + dashboardPadding[3] * 4, y + sy - dashboardPadding[3] - 30, w - dashboardPadding[3] * 8, 30, adminInside)
    seexports.rl_gui:setGuiBackground(btn, "solid", "v4green")
    seexports.rl_gui:setGuiHover(btn, "gradient", {
      "v4green",
      "v4green-second"
    })
    seexports.rl_gui:setButtonFont(btn, "13/BebasNeueBold.otf")
    seexports.rl_gui:setButtonTextColor(btn, "#ffffff")
    seexports.rl_gui:setButtonText(btn, "Report létrehozása")
    seexports.rl_gui:setClickEvent(btn, "openReportGui")
  end
end
local reportCategoryButtons = {}
local selectedReportCategory = false
addEvent("selectReportCategory", false)
addEventHandler("selectReportCategory", getRootElement(), function(button, state, absoluteX, absoluteY, el)
  selectedReportCategory = reportCategoryButtons[el]
  for k in pairs(reportCategoryButtons) do
    if k == el then
      seexports.rl_gui:setGuiBackground(k, "solid", "v4green")
      seexports.rl_gui:setGuiHover(k, "gradient", {
        "v4green",
        "v4green-second"
      }, true)
    else
      seexports.rl_gui:setGuiBackground(k, "solid", "v4grey3")
      seexports.rl_gui:setGuiHover(k, "gradient", {"v4grey3", "v4grey2"}, true)
    end
  end
end)
local reportTitleInput = false
local reportDescriptionInput = false
addEvent("closeReportGui", false)
addEventHandler("closeReportGui", getRootElement(), function()
  reportMode = false
  if adminInside then
    seexports.rl_gui:deleteGuiElement(adminInside)
  end
  drawAdminList()
end)
addEvent("sendAdminReport", false)
addEventHandler("sendAdminReport", getRootElement(), function()
  local reportTitle = seexports.rl_gui:getInputValue(reportTitleInput)
  local reportDescription = seexports.rl_gui:getInputValue(reportDescriptionInput)
  if not selectedReportCategory then
    seexports.rl_gui:showInfobox("e", "Válassz kategóriát!")
  elseif not reportTitle or utf8.len(reportTitle) < 1 then
    seexports.rl_gui:showInfobox("e", "Add meg a bejelentés címét!")
  elseif not reportTitle or utf8.len(reportDescription) < 1 then
    seexports.rl_gui:showInfobox("e", "Add meg a bejelentés leírását!")
  else
    reportMode = false
    if adminInside then
      seexports.rl_gui:deleteGuiElement(adminInside)
    end
    drawAdminList()
    triggerServerEvent("createReport", localPlayer, reportTitle, selectedReportCategory, reportDescription)
  end
end)
addEvent("openReportGui", false)
addEventHandler("openReportGui", getRootElement(), function()
  reportMode = true
  if adminInside then
    seexports.rl_gui:deleteGuiElement(adminInside)
  end
  local x, y = adminPos[1], adminPos[2]
  local sx, sy = adminSize[1], adminSize[2]
  adminInside = seexports.rl_gui:createGuiElement("null", x, y, sx, sy, adminRtg)
  x, y = 0, 0
  drawSideReport(x, y, sx, sy)
  local n = 20
  local h = math.floor(sy / n)
  local border = seexports.rl_gui:createGuiElement("hr", x + sx / 3 - 1, y + dashboardPadding[3] * 4, 2, h * n, adminInside)
  seexports.rl_gui:setGuiHrColor(border, "v4grey3", "v4grey2")
  local w = sx / 3
  local x = w + dashboardPadding[3] * 4
  local label = seexports.rl_gui:createGuiElement("label", x, y + dashboardPadding[3] * 4, w, 32, adminInside)
  seexports.rl_gui:setLabelFont(label, "18/BebasNeueRegular.otf")
  seexports.rl_gui:setLabelAlignment(label, "left", "center")
  seexports.rl_gui:setLabelText(label, "Report létrehozása")
  local y = y + 32 + dashboardPadding[3] * 8
  local label = seexports.rl_gui:createGuiElement("label", x, y, 2 * w, 24, adminInside)
  seexports.rl_gui:setLabelFont(label, "11/Ubuntu-R.ttf")
  seexports.rl_gui:setLabelAlignment(label, "left", "top")
  seexports.rl_gui:setLabelWordBreak(label, true)
  seexports.rl_gui:setLabelText(label, "Cím:")
  y = y + 24 + dashboardPadding[3]
  reportTitleInput = seexports.rl_gui:createGuiElement("input", x, y, w - dashboardPadding[3] * 8, 32, adminInside)
  seexports.rl_gui:setInputPlaceholder(reportTitleInput, "Bejelentés rövid címe")
  seexports.rl_gui:setInputFont(reportTitleInput, "10/Ubuntu-R.ttf")
  seexports.rl_gui:setInputIcon(reportTitleInput, "pen")
  seexports.rl_gui:setInputMaxLength(reportTitleInput, 32)
  y = y + 32 + dashboardPadding[3] * 2
  local label = seexports.rl_gui:createGuiElement("label", x, y, 2 * w, 24, adminInside)
  seexports.rl_gui:setLabelFont(label, "10/Ubuntu-L.ttf")
  seexports.rl_gui:setLabelAlignment(label, "left", "top")
  seexports.rl_gui:setLabelWordBreak(label, true)
  seexports.rl_gui:setLabelText(label, "Fogalmazd meg a problémád pár szóban, ez alapján az adminok könnyebben tudják kezelni az ügyeket.")
  seexports.rl_gui:setLabelColor(label, {
    220,
    220,
    220
  })
  y = y + 24 + dashboardPadding[3] * 4
  local label = seexports.rl_gui:createGuiElement("label", x, y, 2 * w, 24, adminInside)
  seexports.rl_gui:setLabelFont(label, "11/Ubuntu-R.ttf")
  seexports.rl_gui:setLabelAlignment(label, "left", "top")
  seexports.rl_gui:setLabelWordBreak(label, true)
  seexports.rl_gui:setLabelText(label, "Kategória:")
  y = y + 24 + dashboardPadding[3]
  local categories = {
    "Bug/Hiba",
    "Kérdések",
    "Segítségkérés",
    "Szabálysértés/Panasz",
    "FőAdmin/SzuperAdmin",
    "Egyéb"
  }
  selectedReportCategory = false
  reportCategoryButtons = {}
  local w = 0
  for i = 1, #categories do
    local btnW = seexports.rl_gui:getTextWidthFont(categories[i], "11/BebasNeueRegular.otf") + 20
    local btn = seexports.rl_gui:createGuiElement("button", x + w, y, btnW - dashboardPadding[3], 24, adminInside)
    seexports.rl_gui:setGuiBackground(btn, "solid", "v4grey3")
    seexports.rl_gui:setGuiHover(btn, "gradient", {"v4grey3", "v4grey2"}, true)
    seexports.rl_gui:setButtonFont(btn, "11/BebasNeueRegular.otf")
    seexports.rl_gui:setButtonTextColor(btn, "#ffffff")
    seexports.rl_gui:setButtonText(btn, categories[i])
    seexports.rl_gui:setClickEvent(btn, "selectReportCategory")
    w = w + btnW
    reportCategoryButtons[btn] = categories[i]
  end
  y = y + 24 + dashboardPadding[3] * 4
  local label = seexports.rl_gui:createGuiElement("label", x, y, 2 * w, 24, adminInside)
  seexports.rl_gui:setLabelFont(label, "11/Ubuntu-R.ttf")
  seexports.rl_gui:setLabelAlignment(label, "left", "top")
  seexports.rl_gui:setLabelWordBreak(label, true)
  seexports.rl_gui:setLabelText(label, "Hosszabb leírás:")
  y = y + 24 + dashboardPadding[3]
  local w = w + dashboardPadding[3] * 10
  reportDescriptionInput = seexports.rl_gui:createGuiElement("input", x, y, w, 256, adminInside)
  seexports.rl_gui:setInputFont(reportDescriptionInput, "10/Ubuntu-R.ttf")
  seexports.rl_gui:setInputPlaceholder(reportDescriptionInput, "Leírás")
  seexports.rl_gui:setInputMaxLength(reportDescriptionInput, 750)
  seexports.rl_gui:setInputMultiline(reportDescriptionInput, true)
  seexports.rl_gui:setInputFontPaddingHeight(reportDescriptionInput, 32)
  y = y + 256 + dashboardPadding[3] * 4
  local btn = seexports.rl_gui:createGuiElement("button", x, y, (w - dashboardPadding[3] * 4) / 2, 30, adminInside)
  seexports.rl_gui:setGuiBackground(btn, "solid", "v4green")
  seexports.rl_gui:setGuiHover(btn, "gradient", {
    "v4green",
    "v4green-second"
  })
  seexports.rl_gui:setButtonFont(btn, "13/BebasNeueBold.otf")
  seexports.rl_gui:setButtonTextColor(btn, "#ffffff")
  seexports.rl_gui:setButtonText(btn, "Elküldés")
  seexports.rl_gui:setClickEvent(btn, "sendAdminReport")
  local btn = seexports.rl_gui:createGuiElement("button", x + (w - dashboardPadding[3] * 4) / 2 + dashboardPadding[3] * 4, y, (w - dashboardPadding[3] * 4) / 2, 30, adminInside)
  seexports.rl_gui:setGuiBackground(btn, "solid", "v4red")
  seexports.rl_gui:setGuiHover(btn, "gradient", {
    "v4red",
    "v4red-second"
  })
  seexports.rl_gui:setButtonFont(btn, "13/BebasNeueBold.otf")
  seexports.rl_gui:setButtonTextColor(btn, "#ffffff")
  seexports.rl_gui:setButtonText(btn, "Mégsem")
  seexports.rl_gui:setClickEvent(btn, "closeReportGui")
end)
function drawAdminList()
  local x, y = adminPos[1], adminPos[2]
  local sx, sy = adminSize[1], adminSize[2]
  adminInside = seexports.rl_gui:createGuiElement("null", x, y, sx, sy, adminRtg)
  local rtg = adminInside
  local n = 20
  local w = sx / 3
  local sy = sy - dashboardPadding[3] * 4
  local h = math.floor(sy / n)
  local canSeeId = seexports.rl_permission:hasPermission(localPlayer, "canSeeAdminId")
  local fh = seexports.rl_gui:getFontHeight("14/BebasNeueRegular.otf")
  local id = 1
  for i = 0, n - 1 do
    for j = 1, 2 do
      local bbox = seexports.rl_gui:createGuiElement("null", x + j * w + dashboardPadding[3] * 4, y + dashboardPadding[3] * 4 + i * h, w - dashboardPadding[3] * 8, h, rtg)
      if i == 0 then
        local bcg = seexports.rl_gui:createGuiElement("rectangle", x + j * w + dashboardPadding[3] * 4, y + dashboardPadding[3] * 4 + i * h, w - dashboardPadding[3] * 8, h, rtg)
        seexports.rl_gui:setGuiBackground(bcg, "solid", "v4grey2")
        local label = seexports.rl_gui:createGuiElement("label", x + j * w + dashboardPadding[3] * 4 + w * 0.075, y + dashboardPadding[3] * 4 + i * h, w - dashboardPadding[3] * 8, h, rtg)
        seexports.rl_gui:setLabelFont(label, "14/BebasNeueBold.otf")
        seexports.rl_gui:setLabelAlignment(label, "left", "center")
        seexports.rl_gui:setLabelText(label, "Név")
        local label = seexports.rl_gui:createGuiElement("label", x + j * w + dashboardPadding[3] * 4 + 4, y + dashboardPadding[3] * 4 + i * h, w * 0.05, h, rtg)
        seexports.rl_gui:setLabelFont(label, "14/BebasNeueBold.otf")
        seexports.rl_gui:setLabelAlignment(label, "center", "center")
        seexports.rl_gui:setLabelText(label, "ID")
        local label = seexports.rl_gui:createGuiElement("label", x + j * w + dashboardPadding[3] * 4, y + dashboardPadding[3] * 4 + i * h, w - dashboardPadding[3] * 8 - 8, h, rtg)
        seexports.rl_gui:setLabelFont(label, "14/BebasNeueBold.otf")
        seexports.rl_gui:setLabelAlignment(label, "right", "center")
        seexports.rl_gui:setLabelText(label, "Adminszint")
      else
        if adminList[id] then
          local col = "v4green"
          local text = "Admin " .. adminList[id][1]
          if adminList[id][1] == 11 then
            col = "v4blue-second"
            text = "Fejlesztő"
          elseif adminList[id][1] == 10 then
            col = "v4red"
            text = "Tulajdonos"
          elseif adminList[id][1] == 9 then
            col = "v4blue"
            text = "Contributor"
          elseif adminList[id][1] == 8 then
            col = "v4green-second"
            text = "Manager"
          elseif adminList[id][1] == 6 then
            col = "v4yellow"
            text = "FőAdmin"
          elseif adminList[id][1] == 7 then
            col = "v4orange"
            text = "SuperAdmin"
          elseif adminList[id][1] == -1 then
            col = helperColor
            text = "IDG AS"
          elseif adminList[id][1] == -2 then
            col = helperColor
            text = "SGH AS"
          end
          local label = seexports.rl_gui:createGuiElement("label", x + j * w + dashboardPadding[3] * 4 + w * 0.075, y + dashboardPadding[3] * 4 + i * h, w * -dashboardPadding[3] * 8, h, rtg)
          seexports.rl_gui:setLabelFont(label, "14/BebasNeueRegular.otf")
          seexports.rl_gui:setLabelAlignment(label, "left", "center")
          if adminList[id][4] then
            seexports.rl_gui:setLabelColor(label, col)
            seexports.rl_gui:setGuiHoverable(label, true)
            seexports.rl_gui:setGuiBoundingBox(label, bbox)
            seexports.rl_gui:guiSetTooltip(label, "Szolgálatban. Segítségkérésre használd a 'Report létrehozása' gombot!")
            seexports.rl_gui:setLabelText(label, adminList[id][3])
            local label = seexports.rl_gui:createGuiElement("label", x + j * w + dashboardPadding[3] * 4 + 4, y + dashboardPadding[3] * 4 + i * h, w * 0.05, h, rtg)
            seexports.rl_gui:setLabelFont(label, "14/BebasNeueRegular.otf")
            seexports.rl_gui:setLabelAlignment(label, "center", "center")
            seexports.rl_gui:setLabelText(label, adminList[id][2])
            seexports.rl_gui:setLabelColor(label, col)
            seexports.rl_gui:setGuiHoverable(label, true)
            seexports.rl_gui:setGuiBoundingBox(label, bbox)
            seexports.rl_gui:guiSetTooltip(label, "Szolgálatban. Segítségkérésre használd a 'Report létrehozása' gombot!")
          else
            seexports.rl_gui:setLabelText(label, adminList[id][3])
            seexports.rl_gui:setLabelColor(label, "v4lightgrey")
            local icon = seexports.rl_gui:createGuiElement("image", x + j * w + dashboardPadding[3] * 4 + 4 + w * 0.05 / 2 - fh / 2, y + dashboardPadding[3] * 4 + i * h + h / 2 - fh / 2, fh, fh, rtg)
            seexports.rl_gui:setImageFile(icon, seexports.rl_gui:getFaIconFilename("eye-slash", fh))
            if canSeeId then
              seexports.rl_gui:setGuiHoverable(icon, true)
              seexports.rl_gui:setGuiHover(icon, "solid", "v4green")
              seexports.rl_gui:guiSetTooltip(icon, "ID: " .. adminList[id][2])
            end
          end
          local label = seexports.rl_gui:createGuiElement("label", x + j * w + dashboardPadding[3] * 4, y + dashboardPadding[3] * 4 + i * h, w - dashboardPadding[3] * 8 - 8, h, rtg)
          seexports.rl_gui:setLabelFont(label, "14/BebasNeueRegular.otf")
          seexports.rl_gui:setLabelAlignment(label, "right", "center")
          seexports.rl_gui:setLabelText(label, text)
          if adminList[id][4] then
            seexports.rl_gui:setLabelColor(label, col)
            seexports.rl_gui:guiSetTooltip(label, "Szolgálatban. Segítségkérésre használd a 'Report létrehozása' gombot!")
            seexports.rl_gui:setGuiHoverable(label, true)
            seexports.rl_gui:setGuiBoundingBox(label, bbox)
          else
            seexports.rl_gui:setLabelColor(label, "v4lightgrey")
          end
        end
        id = id + 1
      end
      if i < n - 1 then
        local border = seexports.rl_gui:createGuiElement("hr", x + j * w + dashboardPadding[3] * 4, y + dashboardPadding[3] * 4 + (i + 1) * h - 1, w - dashboardPadding[3] * 8, 2, rtg)
        seexports.rl_gui:setGuiHrColor(border, "v4grey3", "v4grey2")
      end
    end
  end
  local border = seexports.rl_gui:createGuiElement("hr", x + sx / 3 - 1, y + dashboardPadding[3] * 4, 2, h * n, rtg)
  seexports.rl_gui:setGuiHrColor(border, "v4grey3", "v4grey2")
  local border = seexports.rl_gui:createGuiElement("hr", x + sx / 3 * 2 - 1, y + dashboardPadding[3] * 4, 2, h * n, rtg)
  seexports.rl_gui:setGuiHrColor(border, "v4grey3", "v4grey2")
  drawSideReport(x, y, sx, sy, true)
end
function adminInsideDestroy()
  reportMode = false
end
function drawAdminInside(x, y, sx, sy, i, j, rtg)
  adminRtg = rtg
  adminPos = {x, y}
  adminSize = {sx, sy}
  drawAdminList()
end
function adminSort(a, b)
  if (a[4] and 1 or 0) ~= (b[4] and 1 or 0) then
    return (a[4] and 1 or 0) > (b[4] and 1 or 0)
  end
  if a[1] ~= b[1] then
    return a[1] < b[1]
  end
  if a[2] ~= b[2] then
    return a[2] < b[2]
  end
end
function drawAdminsInfo(x, y, sx, sy, rtg, i, j)
  sy = sy + y - dashboardPadding[3] * 2
  y = dashboardPadding[3] * 2
  local dutyNum = 0
  local adminNum = 0
  local asNum = 0
  adminList = {}
  local players = getElementsByType("player")
  for i = 1, #players do
    if players[i] and getElementData(players[i], "logged") then
      local level = getElementData(players[i], "acc.adminLevel") or 0
      if 1 <= level and not getElementData(players[i], "hideOnline") then
        local duty = getElementData(players[i], "adminDuty")
        if level <= 7 then
          adminNum = adminNum + 1
          if duty then
            dutyNum = dutyNum + 1
          end
        end
        table.insert(adminList, {
          level,
          getElementData(players[i], "playerID"),
          getElementData(players[i], "acc.adminNick"),
          duty
        })
      end
      level = getElementData(players[i], "acc.helperLevel") or 0
      if 0 < level then
        asNum = asNum + 1
        table.insert(adminList, {
          -level,
          getElementData(players[i], "playerID"),
          getElementData(players[i], "visibleName"):gsub("_", " "),
          true
        })
      end
    end
  end
  table.sort(adminList, adminSort)
  local fs = math.floor(bebasSize * 0.75 + 0.5)
  local fh = seexports.rl_gui:getFontHeight(fs .. "/BebasNeueBold.otf")
  local w = seexports.rl_gui:getTextWidthFont(dutyNum, fs .. "/BebasNeueBold.otf") + seexports.rl_gui:getTextWidthFont(" ADMINDUTY", fs .. "/BebasNeueLight.otf")
  local label = seexports.rl_gui:createGuiElement("label", x + sx / 2 - w / 2, y + fh * 1.25, sx, sy, rtg)
  seexports.rl_gui:setLabelFont(label, fs .. "/BebasNeueBold.otf")
  seexports.rl_gui:setLabelAlignment(label, "left", "top")
  seexports.rl_gui:setLabelText(label, dutyNum)
  seexports.rl_gui:setLabelColor(label, "v4green")
  table.insert(dashboardLayout[i][j].labels, label)
  local label = seexports.rl_gui:createGuiElement("label", x + sx / 2 - w / 2 + seexports.rl_gui:getLabelTextWidth(label), y + fh * 1.25, sx, sy, rtg)
  seexports.rl_gui:setLabelFont(label, fs .. "/BebasNeueLight.otf")
  seexports.rl_gui:setLabelAlignment(label, "left", "top")
  seexports.rl_gui:setLabelText(label, " ADMINDUTY")
  table.insert(dashboardLayout[i][j].labels, label)
  local w = seexports.rl_gui:getTextWidthFont(asNum, fs .. "/BebasNeueBold.otf") + seexports.rl_gui:getTextWidthFont(" Rehber", fs .. "/BebasNeueLight.otf")
  local label = seexports.rl_gui:createGuiElement("label", x + sx / 2 - w / 2, y + fh * 2.25, sx, sy, rtg)
  seexports.rl_gui:setLabelFont(label, fs .. "/BebasNeueBold.otf")
  seexports.rl_gui:setLabelAlignment(label, "left", "top")
  seexports.rl_gui:setLabelText(label, asNum)
  seexports.rl_gui:setLabelColor(label, helperColor)
  table.insert(dashboardLayout[i][j].labels, label)
  local label = seexports.rl_gui:createGuiElement("label", x + sx / 2 - w / 2 + seexports.rl_gui:getLabelTextWidth(label), y + fh * 2.25, sx, sy, rtg)
  seexports.rl_gui:setLabelFont(label, fs .. "/BebasNeueLight.otf")
  seexports.rl_gui:setLabelAlignment(label, "left", "top")
  seexports.rl_gui:setLabelText(label, " REHBER")
  table.insert(dashboardLayout[i][j].labels, label)
  local label = seexports.rl_gui:createGuiElement("label", x, y, sx, sy, rtg)
  seexports.rl_gui:setLabelFont(label, "12/Ubuntu-L.ttf")
  seexports.rl_gui:setLabelAlignment(label, "right", "bottom")
  seexports.rl_gui:setLabelText(label, adminNum)
  table.insert(dashboardLayout[i][j].labels, label)
  local label = seexports.rl_gui:createGuiElement("label", x, y, sx - seexports.rl_gui:getLabelTextWidth(label), sy, rtg)
  seexports.rl_gui:setLabelFont(label, "12/Ubuntu-R.ttf")
  seexports.rl_gui:setLabelAlignment(label, "right", "bottom")
  seexports.rl_gui:setLabelText(label, "Online adminler: ")
  table.insert(dashboardLayout[i][j].labels, label)
end
local charSetObjs = {}
local charSetPed = false
local charPedSrc = false
local charPedShad = false
local charObjShads = {}
local charPedItems = {}
function charInfoInsideDraw(x, y, sx, sy, i, j, rtg)
  money = getElementData(localPlayer, "char.Money")
  local img = seexports.rl_gui:createGuiElement("image", x, y, sx / 2, sy, rtg)
  seexports.rl_gui:setImageFile(img, charPedSrc)
  local shadX, shadY = seexports.rl_gui:getGuiRealPosition(img)
  local shadSx, shadSy = seexports.rl_gui:getGuiSize(img)
  seexports.rl_gui:setImageUV(img, shadX, shadY, shadSx, shadSy)
  seexports.rl_gui:setImageShadow(img, 5, 2, -2, {
    0,
    0,
    0,
    89.25
  })
  local psx, psy = shadSx / screenX / 2, shadSy / screenY / 2
  local ppx, ppy = shadX / screenX + psx - 0.5, -(shadY / screenY + psy - 0.5)
  ppx, ppy = 2 * ppx, 2 * ppy
  dxSetShaderValue(charPedShad, "sMoveObject2D", ppx, ppy)
  dxSetShaderValue(charPedShad, "sScaleObject2D", 2 * math.min(psx, psy), 2 * math.min(psx, psy))
  dxSetShaderValue(charPedShad, "sRealScale2D", 2 * psx, 2 * psy)
  for i = 1, #charObjShads do
    dxSetShaderValue(charObjShads[i], "sMoveObject2D", ppx, ppy)
    dxSetShaderValue(charObjShads[i], "sScaleObject2D", 2 * math.min(psx, psy), 2 * math.min(psx, psy))
    dxSetShaderValue(charObjShads[i], "sRealScale2D", 2 * psx, 2 * psy)
  end
  local h = seexports.rl_gui:getFontHeight("12/Ubuntu-R.ttf") * 1.25
  local oh = h * 15
  x = math.floor(sx / 2)
  y = dashboardPadding[3] * 8
  local border = seexports.rl_gui:createGuiElement("hr", x - 1, sy / 2 - oh / 2, 2, oh, rtg)
  seexports.rl_gui:setGuiHrColor(border, "v4grey3", "v4grey2")
  y = sy / 2 - oh / 2
  x = x + dashboardPadding[3] * 4
  local label = seexports.rl_gui:createGuiElement("label", x, y, sx, h * 2, rtg)
  seexports.rl_gui:setLabelFont(label, "22/BebasNeueBold.otf")
  seexports.rl_gui:setLabelAlignment(label, "left", "center")
  seexports.rl_gui:setLabelText(label, getElementData(localPlayer, "visibleName"):gsub("_", " "))
  seexports.rl_gui:setLabelColor(label, "v4green")
  y = y + h * 2
  local label = seexports.rl_gui:createGuiElement("label", x, y, sx, h, rtg)
  seexports.rl_gui:setLabelFont(label, "12/Ubuntu-R.ttf")
  seexports.rl_gui:setLabelAlignment(label, "left", "center")
  seexports.rl_gui:setLabelText(label, "Account ID: ")
  local w = seexports.rl_gui:getLabelTextWidth(label)
  local label = seexports.rl_gui:createGuiElement("label", x + w, y, sx, h, rtg)
  seexports.rl_gui:setLabelFont(label, "12/Ubuntu-L.ttf")
  seexports.rl_gui:setLabelAlignment(label, "left", "center")
  seexports.rl_gui:setLabelText(label, getElementData(localPlayer, "char.accID"))
  seexports.rl_gui:setLabelColor(label, "v4green")
  y = y + h
  local label = seexports.rl_gui:createGuiElement("label", x, y, sx, h, rtg)
  seexports.rl_gui:setLabelFont(label, "12/Ubuntu-R.ttf")
  seexports.rl_gui:setLabelAlignment(label, "left", "center")
  seexports.rl_gui:setLabelText(label, "Karakter ID: ")
  local w = seexports.rl_gui:getLabelTextWidth(label)
  local label = seexports.rl_gui:createGuiElement("label", x + w, y, sx, h, rtg)
  seexports.rl_gui:setLabelFont(label, "12/Ubuntu-L.ttf")
  seexports.rl_gui:setLabelAlignment(label, "left", "center")
  seexports.rl_gui:setLabelText(label, getElementData(localPlayer, "char.ID"))
  seexports.rl_gui:setLabelColor(label, "v4green")
  y = y + h
  local label = seexports.rl_gui:createGuiElement("label", x, y, sx, h, rtg)
  seexports.rl_gui:setLabelFont(label, "12/Ubuntu-R.ttf")
  seexports.rl_gui:setLabelAlignment(label, "left", "center")
  seexports.rl_gui:setLabelText(label, "Játszott percek: ")
  local w = seexports.rl_gui:getLabelTextWidth(label)
  local label = seexports.rl_gui:createGuiElement("label", x + w, y, sx, h, rtg)
  seexports.rl_gui:setLabelFont(label, "12/Ubuntu-L.ttf")
  seexports.rl_gui:setLabelAlignment(label, "left", "center")
  seexports.rl_gui:setLabelText(label, seexports.rl_gui:thousandsStepper(playedMinutes) .. " (" .. seexports.rl_gui:thousandsStepper(math.floor(playedMinutes / 60)) .. " óra)")
  seexports.rl_gui:setLabelColor(label, "v4green")
  y = y + h
  local label = seexports.rl_gui:createGuiElement("label", x, y, sx, h, rtg)
  seexports.rl_gui:setLabelFont(label, "12/Ubuntu-R.ttf")
  seexports.rl_gui:setLabelAlignment(label, "left", "center")
  seexports.rl_gui:setLabelText(label, "Szint: ")
  local w = seexports.rl_gui:getLabelTextWidth(label)
  local label = seexports.rl_gui:createGuiElement("label", x + w, y, sx, h, rtg)
  seexports.rl_gui:setLabelFont(label, "12/Ubuntu-L.ttf")
  seexports.rl_gui:setLabelAlignment(label, "left", "center")
  seexports.rl_gui:setLabelText(label, "LVL " .. seexports.rl_core:getLevel(playedMinutes))
  seexports.rl_gui:setLabelColor(label, "v4green")
  y = y + h
  local label = seexports.rl_gui:createGuiElement("label", x, y, sx, h, rtg)
  seexports.rl_gui:setLabelFont(label, "12/Ubuntu-R.ttf")
  seexports.rl_gui:setLabelAlignment(label, "left", "center")
  seexports.rl_gui:setLabelText(label, "Araç sayısı: ")
  local w = seexports.rl_gui:getLabelTextWidth(label)
  local label = seexports.rl_gui:createGuiElement("label", x + w, y, sx, h, rtg)
  seexports.rl_gui:setLabelFont(label, "12/Ubuntu-L.ttf")
  seexports.rl_gui:setLabelAlignment(label, "left", "center")
  seexports.rl_gui:setLabelText(label, vehicleNum .. " db")
  seexports.rl_gui:setLabelColor(label, "v4green")
  y = y + h
  local label = seexports.rl_gui:createGuiElement("label", x, y, sx, h, rtg)
  seexports.rl_gui:setLabelFont(label, "12/Ubuntu-R.ttf")
  seexports.rl_gui:setLabelAlignment(label, "left", "center")
  seexports.rl_gui:setLabelText(label, "Interiorok száma: ")
  local w = seexports.rl_gui:getLabelTextWidth(label)
  local label = seexports.rl_gui:createGuiElement("label", x + w, y, sx, h, rtg)
  seexports.rl_gui:setLabelFont(label, "12/Ubuntu-L.ttf")
  seexports.rl_gui:setLabelAlignment(label, "left", "center")
  seexports.rl_gui:setLabelText(label, interiorNum .. " db")
  seexports.rl_gui:setLabelColor(label, "v4green")
  y = y + h
  local label = seexports.rl_gui:createGuiElement("label", x, y, sx, h, rtg)
  seexports.rl_gui:setLabelFont(label, "12/Ubuntu-R.ttf")
  seexports.rl_gui:setLabelAlignment(label, "left", "center")
  seexports.rl_gui:setLabelText(label, "Készpénz: ")
  local w = seexports.rl_gui:getLabelTextWidth(label)
  local label = seexports.rl_gui:createGuiElement("label", x + w, y, sx, h, rtg)
  seexports.rl_gui:setLabelFont(label, "12/Ubuntu-L.ttf")
  seexports.rl_gui:setLabelAlignment(label, "left", "center")
  seexports.rl_gui:setLabelText(label, seexports.rl_gui:thousandsStepper(money) .. " $")
  seexports.rl_gui:setLabelColor(label, money < 0 and "v4red" or "v4green")
  y = y + h
  local label = seexports.rl_gui:createGuiElement("label", x, y, sx, h, rtg)
  seexports.rl_gui:setLabelFont(label, "12/Ubuntu-R.ttf")
  seexports.rl_gui:setLabelAlignment(label, "left", "center")
  seexports.rl_gui:setLabelText(label, "Banki egyenleg: ")
  local w = seexports.rl_gui:getLabelTextWidth(label)
  local bankMoney = getElementData(localPlayer, "char.bankMoney")
  local label = seexports.rl_gui:createGuiElement("label", x + w, y, sx, h, rtg)
  seexports.rl_gui:setLabelFont(label, "12/Ubuntu-L.ttf")
  seexports.rl_gui:setLabelAlignment(label, "left", "center")
  seexports.rl_gui:setLabelText(label, seexports.rl_gui:thousandsStepper(bankMoney) .. " $")
  seexports.rl_gui:setLabelColor(label, bankMoney < 0 and "v4red" or "v4green")
end
function deleteCharRenderer()
  if isElement(charSetPed) then
    destroyElement(charSetPed)
  end
  charSetPed = nil
  if isElement(charPedSrc) then
    destroyElement(charPedSrc)
  end
  charPedSrc = nil
  if isElement(charPedShad) then
    destroyElement(charPedShad)
  end
  charPedShad = nil
  for i = 1, #charSetObjs do
    if isElement(charSetObjs[i]) then
      destroyElement(charSetObjs[i])
    end
    charSetObjs[i] = nil
  end
  for i = 1, #charObjShads do
    if isElement(charObjShads[i]) then
      destroyElement(charObjShads[i])
    end
    charObjShads[i] = nil
  end
  for i = 1, #charPedItems do
    seexports.rl_weapons:processWPSkinBack("self", charPedItems[i], false)
    charPedItems[i] = nil
  end
  seelangCondHandl0(false)
end
local pedPreviewSource = " float3 sElementOffset = float3(0,0,0); float3 sWorldOffset = float3(0,0,0); float3 sCameraPosition = float3(0,0,0); float3 sCameraForward = float3(0,0,0); float3 sCameraUp = float3(0,0,0); float sFov = 1; float sAspect = 1; float2 sMoveObject2D = float2(0,0); float2 sScaleObject2D = float2(1,1); float2 sRealScale2D = float2(1,1); float sAlphaMult = 1; float sProjZMult = 2; float4 sColorFilter1 = float4(0,0,0,0); float4 sColorFilter2 = float4(0,0,0,0); texture gTexture0 < string textureState=\"0,Texture\"; >; float4x4 gProjection : PROJECTION; float4x4 gWorld : WORLD; float4x4 gWorldView : WORLDVIEW; texture secondRT < string renderTarget = \"yes\"; >; int gLighting < string renderState=\"LIGHTING\"; >; float4 gGlobalAmbient < string renderState=\"AMBIENT\"; >; int gAmbientMaterialSource < string renderState=\"AMBIENTMATERIALSOURCE\"; >; int gDiffuseMaterialSource < string renderState=\"DIFFUSEMATERIALSOURCE\"; >; int gEmissiveMaterialSource < string renderState=\"EMISSIVEMATERIALSOURCE\"; >; float4 gMaterialAmbient < string materialState=\"Ambient\"; >; float4 gMaterialDiffuse < string materialState=\"Diffuse\"; >; float4 gMaterialSpecular < string materialState=\"Specular\"; >; float4 gMaterialEmissive < string materialState=\"Emissive\"; >; int CUSTOMFLAGS <string createNormals = \"yes\"; string skipUnusedParameters = \"yes\"; >; float4 gTextureFactor < string renderState=\"TEXTUREFACTOR\"; >; sampler Sampler0 = sampler_state { Texture = (gTexture0); }; struct VSInput { float3 Position : POSITION0; float3 Normal : NORMAL0; float4 Diffuse : COLOR0; float2 TexCoord0 : TEXCOORD0; }; struct PSInput { float4 Position : POSITION0; float4 Diffuse : COLOR0; float2 TexCoord0 : TEXCOORD0; float3 Normal : TEXCOORD1; float4 vPosition : TEXCOORD2; float2 Depth : TEXCOORD3; }; float4x4 createViewMatrix( float3 pos, float3 fwVec, float3 upVec ) { float3 zaxis = normalize( fwVec); float3 xaxis = normalize( cross( -upVec, zaxis )); float3 yaxis = cross( xaxis, zaxis ); float4x4 viewMatrix = { float4( xaxis.x, yaxis.x, zaxis.x, 0 ), float4( xaxis.y, yaxis.y, zaxis.y, 0 ), float4( xaxis.z, yaxis.z, zaxis.z, 0 ), float4(-dot( xaxis, pos ), -dot( yaxis, pos ), -dot( zaxis, pos ), 1 ) }; return viewMatrix; } float4x4 createProjectionMatrix(float near_plane, float far_plane, float fov_horiz, float fov_aspect, float2 ss_mov, float2 ss_scale) { float h, w, Q; w = 1/tan(fov_horiz * 0.5); h = w/fov_aspect; Q = far_plane/(far_plane - near_plane); float4x4 projectionMatrix = { float4(w * ss_scale.x, 0, 0, 0), float4(0, h * ss_scale.y, 0, 0), float4(ss_mov.x, ss_mov.y, Q, 1), float4(0, 0, -Q*near_plane, 0) }; return projectionMatrix; } float4 MTACalcGTABuildingDiffuse( float4 InDiffuse ) { float4 OutDiffuse; if ( !gLighting ) { OutDiffuse = InDiffuse; } else { float4 ambient = gAmbientMaterialSource == 0 ? gMaterialAmbient : InDiffuse; float4 diffuse = gDiffuseMaterialSource == 0 ? gMaterialDiffuse : InDiffuse; float4 emissive = gEmissiveMaterialSource == 0 ? gMaterialEmissive : InDiffuse; OutDiffuse = gGlobalAmbient * saturate( ambient + emissive ); OutDiffuse.a *= diffuse.a; } return OutDiffuse; } PSInput VertexShaderFunction(VSInput VS) { PSInput PS = (PSInput)0; if (VS.Normal.x == 0 && VS.Normal.y == 0 && VS.Normal.z == 0) VS.Normal = float3(0,0,1); VS.Position.xyz += normalize(VS.Normal) * 0.000f; float4 wPos = mul(float4(VS.Position, 1), gWorld); wPos.xyz += sWorldOffset; float4x4 sView = createViewMatrix(sCameraPosition, sCameraForward, sCameraUp); float4 vPos = mul(wPos, sView); vPos.xzy += sElementOffset; float sFarClip = gProjection[3][2] / (1 - gProjection[2][2]); float sNearClip = gProjection[3][2] / - gProjection[2][2]; float4x4 sProjection = createProjectionMatrix(sNearClip, sFarClip, sFov, sAspect, sMoveObject2D, sScaleObject2D); float4x4 tProjection = createProjectionMatrix(sNearClip, sFarClip, sFov, sAspect, float2(0,0), sScaleObject2D / sRealScale2D); PS.Position = mul(vPos, sProjection); PS.vPosition = mul(vPos, tProjection); PS.Depth = float2(PS.Position.z, PS.Position.w); PS.TexCoord0 = VS.TexCoord0; float4x4 sWorldView = mul(gWorld, sView); PS.Normal = mul(VS.Normal.xyz, (float3x3)sWorldView); float Diffa = MTACalcGTABuildingDiffuse(VS.Diffuse).a; PS.Diffuse = float4(0.35, 0.35, 0.3, Diffa); return PS; } struct Pixel { float4 Color : COLOR0; float4 Extra : COLOR1; float Depth : DEPTH0; }; Pixel PixelShaderFunction(PSInput PS) { Pixel output; float4 texel = tex2D(Sampler0, PS.TexCoord0); output.Color = float4(0, 0, 0, min(min(texel.a * PS.Diffuse.a, 0.006105), sAlphaMult)); float4 finalColor = texel * PS.Diffuse; float2 scrCoord =(PS.vPosition.xy / PS.vPosition.w) * float2(0.5, -0.5) + 0.5; output.Depth = ((PS.Depth.x * 0.00625 * sProjZMult) / PS.Depth.y); if ((scrCoord.x > 1) || (scrCoord.x < 0) || (scrCoord.y > 1) || (scrCoord.y < 0)) { output.Depth = 1; output.Color = 0; } output.Extra = saturate(finalColor); output.Extra.rgb += output.Extra.rgb * sColorFilter1.rgb * sColorFilter1.a; output.Extra.rgb += output.Extra.rgb * sColorFilter2.rgb * sColorFilter2.a; output.Extra.rgb *= 1.65; output.Extra.a *= sAlphaMult; return output; } technique fx_pre_ped_MRT { pass P0 { FogEnable = false; AlphaBlendEnable = true; AlphaRef = 1; SeparateAlphaBlendEnable = true; SrcBlendAlpha = SrcAlpha; DestBlendAlpha = One; VertexShader = compile vs_2_0 VertexShaderFunction(); PixelShader = compile ps_2_0 PixelShaderFunction(); } } technique fallback { pass P0 { } } "
function getObjectPreviewSource(tex)
  return " float3 sElementOffset = float3(0,0,0); float3 sWorldOffset = float3(0,0,0); float3 sCameraPosition = float3(0,0,0); float3 sCameraForward = float3(0,0,0); float3 sCameraUp = float3(0,0,0); float sFov = 1; float sAspect = 1; float2 sMoveObject2D = float2(0,0); float2 sScaleObject2D = float2(1,1); float2 sRealScale2D = float2(1,1); float sAlphaMult = 1; float sProjZMult = 2; float4 sColorFilter1 = float4(0,0,0,0); float4 sColorFilter2 = float4(0,0,0,0); texture gTexture0 < string textureState=\"0,Texture\"; >; float4x4 gWorld : WORLD; float4x4 gProjection : PROJECTION; texture secondRT < string renderTarget = \"yes\"; >; int gLighting < string renderState=\"LIGHTING\"; >; float4 gGlobalAmbient < string renderState=\"AMBIENT\"; >; int gAmbientMaterialSource < string renderState=\"AMBIENTMATERIALSOURCE\"; >; int gDiffuseMaterialSource < string renderState=\"DIFFUSEMATERIALSOURCE\"; >; int gEmissiveMaterialSource < string renderState=\"EMISSIVEMATERIALSOURCE\"; >; float4 gMaterialAmbient < string materialState=\"Ambient\"; >; float4 gMaterialDiffuse < string materialState=\"Diffuse\"; >; float4 gMaterialSpecular < string materialState=\"Specular\"; >; float4 gMaterialEmissive < string materialState=\"Emissive\"; >; int CUSTOMFLAGS <string createNormals = \"yes\"; string skipUnusedParameters = \"yes\"; >; float4 gTextureFactor < string renderState=\"TEXTUREFACTOR\"; >; " .. (tex and " texture TexInput; sampler Sampler0 = sampler_state { Texture = (TexInput); }; " or " sampler Sampler0 = sampler_state { Texture = (gTexture0); }; ") .. " struct VSInput { float3 Position : POSITION0; float4 Diffuse : COLOR0; float2 TexCoord0 : TEXCOORD0; }; struct PSInput { float4 Position : POSITION0; float4 Diffuse : COLOR0; float2 TexCoord0 : TEXCOORD0; float4 vPosition : TEXCOORD1; float2 Depth : TEXCOORD2; }; float4x4 createViewMatrix( float3 pos, float3 fwVec, float3 upVec ) { float3 zaxis = normalize( fwVec); float3 xaxis = normalize( cross( -upVec, zaxis )); float3 yaxis = cross( xaxis, zaxis ); float4x4 viewMatrix = { float4( xaxis.x, yaxis.x, zaxis.x, 0 ), float4( xaxis.y, yaxis.y, zaxis.y, 0 ), float4( xaxis.z, yaxis.z, zaxis.z, 0 ), float4(-dot( xaxis, pos ), -dot( yaxis, pos ), -dot( zaxis, pos ), 1 ) }; return viewMatrix; } float4x4 createProjectionMatrix(float near_plane, float far_plane, float fov_horiz, float fov_aspect, float2 ss_mov, float2 ss_scale) { float h, w, Q; w = 1/tan(fov_horiz * 0.5); h = w/fov_aspect; Q = far_plane/(far_plane - near_plane); float4x4 projectionMatrix = { float4(w * ss_scale.x, 0, 0, 0), float4(0, h * ss_scale.y, 0, 0), float4(ss_mov.x, ss_mov.y, Q, 1), float4(0, 0, -Q*near_plane, 0) }; return projectionMatrix; } float4 MTACalcGTABuildingDiffuse( float4 InDiffuse ) { float4 OutDiffuse; if ( !gLighting ) { OutDiffuse = InDiffuse; } else { float4 ambient = gAmbientMaterialSource == 0 ? gMaterialAmbient : InDiffuse; float4 diffuse = gDiffuseMaterialSource == 0 ? gMaterialDiffuse : InDiffuse; float4 emissive = gEmissiveMaterialSource == 0 ? gMaterialEmissive : InDiffuse; OutDiffuse = gGlobalAmbient * saturate( ambient + emissive ); OutDiffuse.a *= diffuse.a; } return OutDiffuse; } PSInput VertexShaderFunction(VSInput VS) { PSInput PS = (PSInput)0; float4 wPos = mul(float4(VS.Position, 1), gWorld); wPos.xyz += sWorldOffset; float4x4 sView = createViewMatrix(sCameraPosition, sCameraForward, sCameraUp); float4 vPos = mul(wPos, sView); vPos.xzy += sElementOffset; float sFarClip = gProjection[3][2] / (1 - gProjection[2][2]); float sNearClip = gProjection[3][2] / - gProjection[2][2]; float4x4 sProjection = createProjectionMatrix(sNearClip, sFarClip, sFov, sAspect, sMoveObject2D, sScaleObject2D); float4x4 tProjection = createProjectionMatrix(sNearClip, sFarClip, sFov, sAspect, float2(0,0), sScaleObject2D / sRealScale2D); PS.Position = mul(vPos, sProjection); PS.vPosition = mul(vPos, tProjection); PS.Depth = float2(PS.Position.z, PS.Position.w); PS.TexCoord0 = VS.TexCoord0; float Diffa = MTACalcGTABuildingDiffuse(VS.Diffuse).a; PS.Diffuse = float4(0.35, 0.35, 0.3, Diffa); return PS; } struct Pixel { float4 Color : COLOR0; float4 Extra : COLOR1; float Depth : DEPTH0; }; Pixel PixelShaderFunction(PSInput PS) { Pixel output; float4 texel = tex2D(Sampler0, PS.TexCoord0); output.Color = float4(0, 0, 0, min(min(texel.a * PS.Diffuse.a, 0.006105), sAlphaMult)); float4 finalColor = texel * PS.Diffuse; float2 scrCoord =(PS.vPosition.xy / PS.vPosition.w) * float2(0.5, -0.5) + 0.5; output.Depth = ((PS.Depth.x * 0.00625 * sProjZMult) / PS.Depth.y); if ((scrCoord.x > 1) || (scrCoord.x < 0) || (scrCoord.y > 1) || (scrCoord.y < 0)) { output.Depth = 1; output.Color = 0; } output.Extra = saturate(finalColor); output.Extra.rgb += output.Extra.rgb * sColorFilter1.rgb * sColorFilter1.a; output.Extra.rgb += output.Extra.rgb * sColorFilter2.rgb * sColorFilter2.a; output.Extra.rgb *= 1.65; output.Extra.a *= sAlphaMult; return output; } technique fx_pre_object_MRT { pass P0 { FogEnable = false; AlphaBlendEnable = true; AlphaRef = 1; SeparateAlphaBlendEnable = true; SrcBlendAlpha = SrcAlpha; DestBlendAlpha = One; VertexShader = compile vs_2_0 VertexShaderFunction(); PixelShader = compile ps_2_0 PixelShaderFunction(); } } technique fallback { pass P0 { } } "
end
local anims = {
  {
    "DEALER",
    "DEALER_IDLE"
  },
  {"GANGS", "leanIDLE"},
  {
    "COP_AMBIENT",
    "Coplook_think"
  },
  {
    "COP_AMBIENT",
    "Coplook_shake"
  },
  {
    "GANGS",
    "prtial_gngtlkA"
  },
  {
    "GANGS",
    "prtial_gngtlkB"
  },
  {"DANCING", "DAN_Loop_A"},
  {"DANCING", "dnce_M_b"},
  {
    "COP_AMBIENT",
    "Coplook_watch"
  }
}
function startCharRender()
  if isElement(charSetPed) then
    destroyElement(charSetPed)
  end
  charSetPed = nil
  if isElement(charPedSrc) then
    destroyElement(charPedSrc)
  end
  charPedSrc = nil
  if isElement(charPedShad) then
    destroyElement(charPedShad)
  end
  charPedShad = nil
  for i = 1, #charSetObjs do
    if isElement(charSetObjs[i]) then
      destroyElement(charSetObjs[i])
    end
    charSetObjs[i] = nil
  end
  for i = 1, #charObjShads do
    if isElement(charObjShads[i]) then
      destroyElement(charObjShads[i])
    end
    charObjShads[i] = nil
  end
  for i = 1, #charPedItems do
    seexports.rl_weapons:processWPSkinBack("self", charPedItems[i], false)
    charPedItems[i] = nil
  end
  charSetPed = createPed(getElementModel(localPlayer), 0, 0, 11, 15 - math.random(-100, 100) / 10)
  local anim = math.random(1, #anims)
  charPedSrc = dxCreateRenderTarget(screenX, screenY, true)
  charPedShad = dxCreateShader(pedPreviewSource, 0, 0, false, "all")
  charObjShads[1] = dxCreateShader(getObjectPreviewSource(), 0, 0, false, "all")
  dxSetShaderValue(charPedShad, "sFov", 70)
  dxSetShaderValue(charPedShad, "sAspect", screenY / screenX)
  dxSetShaderValue(charPedShad, "secondRT", charPedSrc)
  setPedAnimation(charSetPed, anims[anim][1], anims[anim][2], -1, true, false)
  seelangCondHandl0(true)
  engineApplyShaderToWorldTexture(charPedShad, "*", charSetPed)
  setElementCollisionsEnabled(charSetPed, false)
  --[[wardis local objs = seexports.rl_clothesshop:getSelfClothData()
  for i = 1, #objs do
    local model, bone, x, y, z, q, sx, sy, sz, tex, texEl, item = unpack(objs[i])
    local obj = createObject(model, 0, 0, 0, 0, 0, 0)
    table.insert(charSetObjs, obj)
    setElementCollisionsEnabled(obj, false)
    engineApplyShaderToWorldTexture(charObjShads[1], "*", obj)
    if isElement(texEl) then
      local j = #charObjShads + 1
      charObjShads[j] = dxCreateShader(getObjectPreviewSource(true), 0, 0, false, "all")
      dxSetShaderValue(charObjShads[j], "TexInput", texEl)
      engineRemoveShaderFromWorldTexture(charObjShads[1], tex, obj)
      engineApplyShaderToWorldTexture(charObjShads[j], tex, obj)
    end 
    
    if item then
      table.insert(charPedItems, item)
    end
    seexports.pattach:detach(obj)
    seexports.pattach:attach(obj, charSetPed, bone, x, y, z, 0, 0, 0)
    seexports.pattach:setRotationQuaternion(obj, q)
    setObjectScale(obj, sx, sy, sz)
  end
  for i = 1, #charObjShads do
    dxSetShaderValue(charObjShads[i], "sFov", 70)
    dxSetShaderValue(charObjShads[i], "sAspect", screenY / screenX)
    dxSetShaderValue(charObjShads[i], "secondRT", charPedSrc)
  end]]
  local x, y = screenX / 2, screenY / 2
  local sx, sy = 10, 10
  local psx, psy = sx / screenX / 2, sy / screenY / 2
  local ppx, ppy = x / screenX + psx - 0.5, -(y / screenY + psy - 0.5)
  ppx, ppy = 2 * ppx, 2 * ppy
  dxSetShaderValue(charPedShad, "sMoveObject2D", ppx, ppy)
  dxSetShaderValue(charPedShad, "sScaleObject2D", 2 * math.min(psx, psy), 2 * math.min(psx, psy))
  dxSetShaderValue(charPedShad, "sRealScale2D", 2 * psx, 2 * psy)
  for i = 1, #charObjShads do
    dxSetShaderValue(charObjShads[i], "sMoveObject2D", ppx, ppy)
    dxSetShaderValue(charObjShads[i], "sScaleObject2D", 2 * math.min(psx, psy), 2 * math.min(psx, psy))
    dxSetShaderValue(charObjShads[i], "sRealScale2D", 2 * psx, 2 * psy)
  end
end
function renderCharSet()
  setElementInterior(charSetPed, getElementInterior(localPlayer))
  setElementDimension(charSetPed, getElementDimension(localPlayer))
  dxSetRenderTarget(charPedSrc, true)
  dxSetRenderTarget()
  local cameraMatrix = getElementMatrix(getCamera())
  local transformMatrix = createElementMatrix(0, 0, 180)
  local posX, posY, posZ = getPositionFromMatrixOffset(cameraMatrix, 0, 2.5, 0)
  local multipliedMatrix = matrixMultiply(transformMatrix, cameraMatrix)
  local rotX, rotY, rotZ = getEulerAnglesFromMatrix(multipliedMatrix)
  setElementPosition(charSetPed, posX, posY, posZ, false)
  setElementRotation(charSetPed, rotX, rotY, rotZ, "ZXY")
  dxSetShaderValue(charPedShad, "sCameraPosition", cameraMatrix[4])
  dxSetShaderValue(charPedShad, "sCameraForward", cameraMatrix[2])
  dxSetShaderValue(charPedShad, "sCameraUp", cameraMatrix[3])
  for i = 1, #charObjShads do
    dxSetShaderValue(charObjShads[i], "sCameraPosition", cameraMatrix[4])
    dxSetShaderValue(charObjShads[i], "sCameraForward", cameraMatrix[2])
    dxSetShaderValue(charObjShads[i], "sCameraUp", cameraMatrix[3])
  end
end
dashboardLayout[1][1] = {
  name = "accountInfo",
  name = "accountInfo",
  xSize = 2,
  ySize = 1,
  background = "green",
  topLabels = {
    "Hoş geldin ",
    "username!"
  },
  drawFunction = drawAccountInfo,
  insideDraw = charInfoInsideDraw,
  beforeExpand = startCharRender,
  insideDestroy = deleteCharRenderer
}
ppShopPos = {1, 2}
dashboardLayout[1][2] = {
  name = "Premium Mağaza",
  xSize = 2,
  ySize = 1,
  topLabels = {"Premium ", "Mağaza"},
  cornerBcg = "files/pp_bcg.dds",
  centerBcg = "files/pp_bcg_center.dds",
  centerBcgColor = "v4blue",
  ppShop = true,
  drawFunction = drawPremiumInfo,
  insideDraw = ppInsideDraw,
  insideDestroy = ppInsideDestroy
}
dashboardLayout[1][3] = {
  name = "Ayarlar",
  xSize = 1,
  ySize = 1,
  topLabels = {
    "Ayarlar"
  },
  cornerBcg = "files/settings_bcg.dds",
  insideDraw = settingsInsideDraw,
  insideDestroy = settingsInsideDestroy
}
newsPosition = {1, 4}
dashboardLayout[1][4] = {
  name = "Discord",
  xSize = 2,
  ySize = 1,
  background = "news/def.dds",
  topLabels = {"Discord"},
  drawFunction = drawChangelogInfo,
  url = "https"
}
groupsPos = {2, 3}
dashboardLayout[2][3] = {
  name = "Gruplar",
  xSize = 1,
  ySize = 1,
  topLabels = {"Gruplar"},
  cornerBcg = "files/groups_bcg.dds",
  insideDraw = groupsInsideDraw,
  insideDestroy = groupsInsideDestroy,
  checkFunction = checkIfGroupsAvailable
}
interiorPos = {3, 1}
dashboardLayout[3][1] = {
  name = "Interiorok",
  xSize = 2,
  ySize = 2,
  background = "files/inti/interior_render1.dds",
  drawFunction = drawInteriorsInfo,
  insideDraw = interiorsInsideDraw,
  insideDestroy = interiorsInsideDestroy
}
bigRadarPos = {3, 3}
dashboardLayout[3][3] = {
  name = "DÜNYA HARİTASI",
  xSize = 2,
  ySize = 2,
  background = "radar",
  topLabels = {"Dünya", "haritası"}
}
vehsPosition = {5, 1}
dashboardLayout[5][1] = {
  name = "Araçlar",
  xSize = 2,
  ySize = 2,
  background = "files/fado2.dds",
  topLabels = {
    "Araçlar: ",
    "vehicleNum"
  },
  drawFunction = drawVehiclesInfo,
  insideDraw = drawVehiclesInside,
  insideDestroy = vehiclesInsideDestroy,
  beforeExpand = requestPlayerVehicleList
}
dashboardLayout[5][3] = {
  name = "Report, Online adminler",
  xSize = 2,
  ySize = 1,
  topLabels = {
    "Report",
    " / adminler"
  },
  cornerBcg = "files/admins_bcg.dds",
  drawFunction = drawAdminsInfo,
  insideDraw = drawAdminInside,
  insideDestroy = adminInsideDestroy
}
animalsLocation = {5, 4}
dashboardLayout[5][4] = {
  name = "Evcil hayvanlar",
  xSize = 2,
  ySize = 1,
  topLabels = {
    "Evcil hayvanlar: ",
    "animalNum"
  },
  cornerBcg = "files/pets_bcg.dds",
  insideDraw = animalsInsideDraw,
  insideDestroy = animalsInsideDestroy
}
for i in pairs(dashboardLayout) do
  for j, data in pairs(dashboardLayout[i]) do
    local xs = data.xSize
    local ys = data.ySize
    dashboardLayout[i][j].originalSize = {
      oneSize[1] * xs - dashboardPadding[3] * 2,
      oneSize[2] * ys - dashboardPadding[3] * 2
    }
  end
end
animalNum = 0
local animalNumLabel = false
playerAnimals = {}
addEvent("recieveAnimals", true)
addEventHandler("recieveAnimals", getRootElement(), function(data)
  animalNum = #data
  playerAnimals = data
  if dashboardState then
    seexports.rl_gui:setLabelText(animalNumLabel, animalNum)
  end
  if animalMenuDrawn then
    if animalNum < selectedAnimal then
      selectedAnimal = 1
    end
    drawAnimal()
  end
end)
closeButton = false
helpIcon = false
ucpIcon = false
local pageName = false
local shaderSource = " texture texture0; float factor; sampler Sampler0 = sampler_state { Texture = (texture0); AddressU = MIRROR; AddressV = MIRROR; }; struct PSInput { float2 TexCoord : TEXCOORD0; }; float4 PixelShader_Background(PSInput PS) : COLOR0 { float4 sum = tex2D(Sampler0, PS.TexCoord); for (float i = 1; i < 3; i++) { sum += tex2D(Sampler0, float2(PS.TexCoord.x, PS.TexCoord.y + (i * factor))); sum += tex2D(Sampler0, float2(PS.TexCoord.x, PS.TexCoord.y - (i * factor))); sum += tex2D(Sampler0, float2(PS.TexCoord.x - (i * factor), PS.TexCoord.y)); sum += tex2D(Sampler0, float2(PS.TexCoord.x + (i * factor), PS.TexCoord.y)); } sum /= 9; sum.a = 1.0; return sum; } technique complercated { pass P0 { PixelShader = compile ps_2_0 PixelShader_Background(); } } technique simple { pass P0 { Texture[0] = texture0; } } "
local maxFactor = 0.0015
local factor = 0
dashboardState = false
local animatedElements = 0
local vign = false
local nameLabel = false
local nameRect1 = false
local nameRect2 = false
function preRenderDashboard(delta)
  if dashboardState then
    if factor < maxFactor then
      factor = factor + delta * maxFactor / expandTime
      if factor > maxFactor then
        factor = maxFactor
      end
      -- dxSetShaderValue(screenShader, "factor", factor)
    end
  elseif 0 < factor then
    factor = factor - delta * maxFactor / expandTime
    if factor < 0 then
      factor = 0
    end
  end
end
local lastPage = false
openedColorSet = 1
playedMinutes = 0
addEvent("refreshPlayedMinutes", true)
addEventHandler("refreshPlayedMinutes", getRootElement(), function(data)
  playedMinutes = data
end)
playerInteriors = {}
interiorLimit = 0
interiorNum = 0
local interiorNumLabel = false
vehicleNumLabel = false
addEvent("gotInteriorLimitForDashboard", true)
addEventHandler("gotInteriorLimitForDashboard", getRootElement(), function(limit)
  interiorLimit = limit
  if dashboardState then
    seexports.rl_gui:setLabelText(intiLimitLabel, interiorLimit)
    if interiorMenuDrawn then
      drawInteriors()
    end
  end
end)

--[[
  refreshPlayerInteriors - num, data, rentable
  gotInteriorLimitForDashboard - limit
]]


addEvent("refreshPlayerInteriors", true)
addEventHandler("refreshPlayerInteriors", root, function(num, data, rentable)
  interiorRenderList = {}
  interiorNum = num
  playerInteriors = data
  rentableNum = 0
  farms = seexports.rl_farm:getPlayerFarmsForDashboard()
  for i = 1, #playerInteriors do
    table.insert(interiorRenderList, {
      theType = "interior",
      data = playerInteriors[i]
    })
  end
  table.sort(interiorRenderList, function(a, b)
    if a.data.type == b.data.type then
      return a.data.interiorId < b.data.interiorId
    else
      return b.data.type < a.data.type
    end
  end)
  
  for i = 1, #farms do
    table.insert(interiorRenderList, {
      theType = "farm",
      data = farms[i]
    })
  end

  
  rentableNum = rentableNum + #farms
  local paintshops = seexports.rl_paintshop:getPaintshopCache()
  for i = 1, #paintshops do
    table.insert(interiorRenderList, {
      theType = "otherRentable",
      data = paintshops[i]
    })
  end
  rentableNum = rentableNum + #paintshops

  if dashboardState then
    seexports.rl_gui:setLabelText(ownInteriorLabel, interiorNum)
    seexports.rl_gui:setLabelText(intiLimitLabel, interiorLimit)
    seexports.rl_gui:setLabelText(rentableNumLabel, rentableNum)
    if interiorMenuDrawn then
      drawInteriors()
    end
  end
end)
function round2(num, idp)
  return tonumber(string.format("%." .. (idp or 0) .. "f", num))
end
charId = false
if getElementData(localPlayer, "logged") then
  triggerEvent("requestPlayerInteriors", localPlayer)
end
helperColor = {
  255,
  255,
  255
}
function createGuiCache()
  local v4red = seexports.rl_gui:getColorCode("v4red")
  local v4purple = seexports.rl_gui:getColorCode("v4purple")
  helperColor[1] = (v4red[1] + v4purple[1]) / 2
  helperColor[2] = (v4red[2] + v4purple[2]) / 2
  helperColor[3] = (v4red[3] + v4purple[3]) / 2
  local icons = {
    seexports.rl_gui:getFaIconFilename("building", 32, "solid", false, seexports.rl_gui:getColorCodeToColor("v4grey2"), seexports.rl_gui:getColorCodeToColor("v4blue")),
    seexports.rl_gui:getFaIconFilename("dollar-sign", 32, "solid", false, seexports.rl_gui:getColorCodeToColor("v4grey2"), seexports.rl_gui:getColorCodeToColor("v4green")),
    seexports.rl_gui:getFaIconFilename("garage", 32, "solid", false, seexports.rl_gui:getColorCodeToColor("v4grey2"), seexports.rl_gui:getColorCodeToColor("v4blue-second")),
    seexports.rl_gui:getFaIconFilename("hotel", 32, "solid", false, seexports.rl_gui:getColorCodeToColor("v4grey2"), seexports.rl_gui:getColorCodeToColor("v4purple")),
    seexports.rl_gui:getFaIconFilename("sort-circle-up", 32, "solid", false, seexports.rl_gui:getColorCodeToColor("v4grey2"), seexports.rl_gui:getColorCodeToColor("hudwhite")),
    seexports.rl_gui:getFaIconFilename("door-closed", 32, "solid", false, seexports.rl_gui:getColorCodeToColor("v4grey2"), seexports.rl_gui:getColorCodeToColor("hudwhite")),
    seexports.rl_gui:getFaIconFilename("question", 32, "solid", false, seexports.rl_gui:getColorCodeToColor("v4grey2"), seexports.rl_gui:getColorCodeToColor("v4yellow")),
    seexports.rl_gui:getFaIconFilename("chevron-circle-left", 32),
    seexports.rl_gui:getFaIconFilename("users-cog", 32)
  }
  seexports.rl_gui:getFont(bebasSize + 5 .. "/BebasNeueBold.otf")
  seexports.rl_gui:getFont(math.max(15, bebasSize - 5) .. "/BebasNeueRegular.otf")
  seexports.rl_gui:getFont(bebasSize .. "/BebasNeueBold.otf")
  seexports.rl_gui:getFont(bebasSize .. "/BebasNeueLight.otf")
  local grads = {}
  for i = 1, dashboardGridSize[1] do
    for j = 1, dashboardGridSize[2] do
      local data = dashboardLayout[i][j]
      if data then
        local xs = data.xSize
        local ys = data.ySize
        local sx, sy = oneSize[1] * xs - dashboardPadding[3] * 2, oneSize[2] * ys - dashboardPadding[3] * 2
        table.insert(grads, seexports.rl_gui:getGradientFilename(sx, sy, seexports.rl_gui:getColorCode("v4grey2"), seexports.rl_gui:getColorCode("v4grey1")))
        if data.background == "green" then
          table.insert(grads, seexports.rl_gui:getGradientFilename(sx, sy, seexports.rl_gui:getColorCode("v4green-second"), seexports.rl_gui:getColorCode("v4green")))
        end
      end
    end
  end
end
addEvent("dashboardOpenUcp", false)
addEventHandler("dashboardOpenUcp", getRootElement(), function()
  openURL("https://ucp.sg-game.com/v4/")
end)
addEvent("dashboardOpenHelp", false)
addEventHandler("dashboardOpenHelp", getRootElement(), function()
  openURL("https://help.sg-game.com/")
end)
local localUserName = false
addEvent("gotLocalUserName", true)
addEventHandler("gotLocalUserName", getRootElement(), function(user)
  localUserName = user
end)
function createDashboard()
  if not dashboardState then
    showCursor(true)
    showChat(false)
    dashboardState = true
	addEventHandler("onClientPreRender", getRootElement(), preRenderDashboard)
    
	seexports.rl_gui:fadeIn(nameRect2, expandTime)
    local x = dashboardPos[1]
    local y = dashboardPos[2]
    local id = 0
    local id2 = 0
    for i = 1, dashboardGridSize[1] do
      y = dashboardPos[2]
      for j = 1, dashboardGridSize[2] do
        local data = dashboardLayout[i][j]
        if data then
          do
            local xs = data.xSize
            local ys = data.ySize
            dashboardLayout[i][j].originalPosition = {
              x + dashboardPadding[3],
              y + dashboardPadding[3]
            }
            dashboardLayout[i][j].originalSize = {
              oneSize[1] * xs - dashboardPadding[3] * 2,
              oneSize[2] * ys - dashboardPadding[3] * 2
            }
		   local rtg = seexports.rl_gui:createGuiElement("rectangle", dashboardLayout[i][j].originalPosition[1], dashboardLayout[i][j].originalPosition[2] + (j > dashboardGridSize[2] / 2 and screenY or -screenY), dashboardLayout[i][j].originalSize[1], dashboardLayout[i][j].originalSize[2], dashboardGui)
            seexports.rl_gui:setGuiBackground(rtg, "solid", "v4grey1")
            seexports.rl_gui:setGuiHover(rtg, "gradient", {"v4grey2", "v4grey1"}, false, true)

            dashboardLayout[i][j].element = rtg
            dashboardLayout[i][j].labels = {}
            dashboardLayout[i][j].images = {}
            if data.background == "radar" then
              local radarShader = seexports.rl_radar:setBigRadarElement(rtg)  --- blipleri getiren yer
              dashboardLayout[i][j].radarTexture = seexports.rl_gui:createGuiElement("image", 0, 0, screenX, screenY, rtg)
			  seexports.rl_gui:setImageFile(dashboardLayout[i][j].radarTexture, radarShader)
            end 
            animatedElements = animatedElements + 1
              setTimer(playSound, expandTime / 4, 1, "files/sound/Whoo" .. math.random(3, 4) .. ".wav")
              setTimer(function()
                animatedElements = animatedElements - 1
                if animatedElements == 0 then
                  seexports.rl_gui:lockHover(dashboardGui, false)
                  if lastPage then
					expandDashboard(lastPage[1], lastPage[2])
                  end
                end
              end, 2, 1)

            if j > dashboardGridSize[2] / 2 then
              id2 = id2 + 1
            else
              id = id + 1
            end
          end
        end
        y = y + oneSize[2]
      end
      x = x + oneSize[1]
    end
  end
end




function deleteDashboard(justCache)
  if dashboardState then
    dashboardClosing = false
    dashboardState = false
    setElementData(localPlayer, "dashboardState", dashboardState)
    showCursor(false)
    --if not seexports.rl_death:isDeath() then
      -- seexports.rl_hud:setHudEnabled(true, expandTime)
    --end
    seexports.rl_gui:lockHover(dashboardGui, true)
    seexports.rl_gui:fadeOut(vign, expandTime)
    seexports.rl_gui:fadeOut(nameLabel, expandTime)
    seexports.rl_gui:fadeOut(pageName, expandTime)
    seexports.rl_gui:fadeOut(nameRect1, expandTime)
    seexports.rl_gui:fadeOut(nameRect2, expandTime)
    seexports.rl_gui:fadeOut(helpIcon, expandTime)
    seexports.rl_gui:fadeOut(ucpIcon, expandTime)
    animatedElements = 0
    local id = 0
    local id2 = 0
            playSound("files/sound/Whoo" .. math.random(1, 2) .. ".wav")
    for i = 1, dashboardGridSize[1] do
      for j = 1, dashboardGridSize[2] do
        if dashboardLayout[i][j] and dashboardLayout[i][j].element then
          animatedElements = animatedElements + 1
          setTimer(function()
            seexports.rl_gui:setGuiPositionAnimated(dashboardLayout[i][j].element, dashboardLayout[i][j].originalPosition[1], dashboardLayout[i][j].originalPosition[2] + (j > dashboardGridSize[2] / 2 and screenY or -screenY), expandTime / 2, false, "InOutQuad", true)
            setTimer(function()
              animatedElements = animatedElements - 1
              if animatedElements == 0 then
                seexports.rl_radar:setBigRadarElement(false)
                seexports.rl_gui:deleteGuiElement(dashboardGui)
                removeEventHandler("onClientPreRender", getRootElement(), preRenderDashboard)
                dashboardGui = false
                closeButton = false
                helpIcon = false
                ucpIcon = false
                pageName = false
                screenShader = false
                screenSrc = false
                vign = false
                nameLabel = false
                nameRect1 = false
                nameRect2 = false
                if isElement(screenSrc) then
                  destroyElement(screenSrc)
                end
                screenSrc = false
                if isElement(screenShader) then
                  destroyElement(screenShader)
                end
                screenShader = false
                showChat(true)
              end
            end, expandTime / 2, 1)
          end, expandTime / 6 * (j > dashboardGridSize[2] / 2 and id2 or id), 1)
          if j > dashboardGridSize[2] / 2 then
            id2 = id2 + 1
          else
            id = id + 1
          end
        end
      end
    end
  end
end
function getDashboardState()
  return dashboardState
end
local lastDashboardAnimation = 0
dashboardExpanded = false
addEvent("forceCloseDashboard", true)
addEventHandler("forceCloseDashboard", getRootElement(), function()
  closeDashboardKey()
end)
function closeDashboardKey(key, por)
  deletePreview()
  dashboardClosing = true
  local mapOpen = false
  local ppShopOpen = false
  local groupsOpen = false
  if key == "F11" and (dashboardExpanded and (dashboardExpanded[1] ~= bigRadarPos[1] or dashboardExpanded[2] ~= bigRadarPos[2]) or not dashboardExpanded) then
	mapOpen = true
	
  end
  if ppShopOpen then
    if dashboardExpanded then
      local time = closeDashPage()
      setTimer(expandDashboard, time, 1, ppShopPos[1], ppShopPos[2])
    else
      expandDashboard(ppShopPos[1], ppShopPos[2])
    end
  elseif groupsOpen then
    if dashboardExpanded then
      local time = closeDashPage()
      setTimer(expandDashboard, time, 1, groupsPos[1], groupsPos[2])
    else
      expandDashboard(groupsPos[1], groupsPos[2])
    end
  elseif mapOpen then
    if dashboardExpanded then
      local time = closeDashPage()
	  	triggerEvent("zorunlukapat",localPlayer,"kapat")
	  setTimer(expandDashboard, time, 1, bigRadarPos[1], bigRadarPos[2])
    else
      expandDashboard(bigRadarPos[1], bigRadarPos[2])
    end
  elseif dashboardExpanded then
	deleteDashboard()
  else
	if animatedElements <= 0 and getTickCount() - lastDashboardAnimation > expandTime + curtainTime then
        if dashboardExpanded then
          closeDashPage()
        else
          closeDashboardKey(key, por)
        end
    end
  end
end
addEventHandler("onClientKey", getRootElement(), function(key, por)
  if getElementData(localPlayer, "logged") then
    -- if key == "backspace" then
      -- if dashboardState then
        -- if animatedElements <= 0 and getTickCount() - lastDashboardAnimation > expandTime + curtainTime then
          -- if dashboardExpanded then
            -- closeDashPage()
          -- else
            -- closeDashboardKey(key, por)
          -- end
        -- end
        -- cancelEvent()
      -- end
    if (key == "F11") then
      if por and animatedElements <= 0 and getTickCount() - lastDashboardAnimation > expandTime + curtainTime then
        if not dashboardState then
          if key == "F11" then
			triggerEvent("zorunlukapat",localPlayer,"ac")
			lastPage = {
              bigRadarPos[1],
              bigRadarPos[2]
            }
          end
          createDashboard()
          -- triggerEvent("requestPlayerInteriors", localPlayer)
        else
          closeDashboardKey(key, por)
		  triggerEvent("zorunlukapat",localPlayer,"apat")
        end
      end
      cancelEvent()
    end
  end
end)
function setDashboardState(i, j, expand)
  local data = dashboardLayout[i][j]
  if data then
    seexports.rl_gui:guiToFront(dashboardLayout[i][j].element)
    if expand then
      if dashboardLayout[i][j].beforeExpand then
        dashboardLayout[i][j].beforeExpand()
      end
      if dashboardLayout[i][j].radarTexture then
        seexports.rl_gui:setGuiPositionAnimated(dashboardLayout[i][j].radarTexture, dashboardPos[1] + dashboardPadding[3], dashboardPos[2] + dashboardPadding[3], expandTime, false, "InOutQuad", true)
        seexports.rl_radar:setBigRadarOpened(true, expandTime)
      end
      playSound("files/sound/Swipe" .. math.random(3, 4) .. ".wav")
      seexports.rl_gui:setGuiPositionAnimated(dashboardLayout[i][j].element, dashboardPos[1] + dashboardPadding[3], dashboardPos[2] + dashboardPadding[3], expandTime, false, "InOutQuad", true)
      seexports.rl_gui:setGuiSizeAnimated(dashboardLayout[i][j].element, dashSize[1] - dashboardPadding[3] * 2, dashSize[2] - dashboardPadding[3] * 2, expandTime, "dashboardExpandDone", "InOutQuad")
      if dashboardLayout[i][j].greenBcg then
        seexports.rl_gui:fadeOut(dashboardLayout[i][j].greenBcg, expandTime)
      end
      for k = 1, #dashboardLayout[i][j].labels do
        seexports.rl_gui:fadeOut(dashboardLayout[i][j].labels[k], expandTime)
      end
      for k = 1, #dashboardLayout[i][j].images do
        seexports.rl_gui:fadeOut(dashboardLayout[i][j].images[k], expandTime)
      end
    else
      if dashboardLayout[i][j].radarTexture then
        seexports.rl_gui:setGuiPositionAnimated(dashboardLayout[i][j].radarTexture, dashboardLayout[i][j].originalPosition[1], dashboardLayout[i][j].originalPosition[2], expandTime, false, "InOutQuad", true)
        seexports.rl_radar:setBigRadarOpened(false, expandTime)
      end
      playSound("files/sound/Swipe" .. math.random(1, 2) .. ".wav")
      seexports.rl_gui:setGuiPositionAnimated(dashboardLayout[i][j].element, dashboardLayout[i][j].originalPosition[1], dashboardLayout[i][j].originalPosition[2], expandTime, false, "InOutQuad", true)
      seexports.rl_gui:setGuiSizeAnimated(dashboardLayout[i][j].element, dashboardLayout[i][j].originalSize[1], dashboardLayout[i][j].originalSize[2], expandTime, false, "InOutQuad")
      if dashboardLayout[i][j].greenBcg then
        seexports.rl_gui:fadeIn(dashboardLayout[i][j].greenBcg, expandTime)
      end
      for k = 1, #dashboardLayout[i][j].labels do
        seexports.rl_gui:fadeIn(dashboardLayout[i][j].labels[k], expandTime)
      end
      for k = 1, #dashboardLayout[i][j].images do
        seexports.rl_gui:fadeIn(dashboardLayout[i][j].images[k], expandTime)
      end
    end
  end
end
addEvent("dashboardExpandDone", true)
addEventHandler("dashboardExpandDone", getRootElement(), function()
  if dashboardExpanded then
    seexports.rl_gui:lockHover(closeButton, false)
    seexports.rl_gui:lockHover(helpIcon, false)
    seexports.rl_gui:lockHover(ucpIcon, false)
    do
      local i, j = dashboardExpanded[1], dashboardExpanded[2]
      if dashboardLayout[i][j].insideLayer then
        seexports.rl_gui:deleteGuiElement(dashboardLayout[i][j].insideLayer)
        dashboardLayout[i][j].insideLayer = false
      end
      if dashboardLayout[i][j] and dashboardLayout[i][j].insideDraw then
        local x = dashboardPos[1] + dashboardPadding[3]
        local y = dashboardPos[2] + dashboardPadding[3]
        local sx = dashSize[1] - dashboardPadding[3] * 2
        local sy = dashSize[2] - dashboardPadding[3] * 2
        dashboardLayout[i][j].insideLayer = seexports.rl_gui:createGuiElement("null", x, y, sx, sy)
        dashboardLayout[i][j].insideDraw(0, 0, sx, sy, i, j, dashboardLayout[i][j].insideLayer)
        seexports.rl_gui:lockHover(dashboardLayout[i][j].insideLayer, true)
        dashboardLayout[i][j].insideCurtain = seexports.rl_gui:createGuiElement("rectangle", 0, 0, sx, sy, dashboardLayout[i][j].insideLayer)
        seexports.rl_gui:setGuiBackground(dashboardLayout[i][j].insideCurtain, "solid", "v4grey1")
        seexports.rl_gui:fadeOut(dashboardLayout[i][j].insideCurtain, curtainTime)
        setTimer(function()
          seexports.rl_gui:lockHover(dashboardLayout[i][j].insideLayer, false)
        end, curtainTime, 1)
      else
        lastDashboardAnimation = lastDashboardAnimation - curtainTime
      end
    end
  end
end)
function closeDashPage()
  local i, j = dashboardExpanded[1], dashboardExpanded[2]
  if dashboardLayout[i][j] and dashboardLayout[i][j].insideCurtain then
    lastDashboardAnimation = getTickCount()
    seexports.rl_gui:lockHover(dashboardGui, true)
    seexports.rl_gui:lockHover(dashboardLayout[i][j].insideLayer, true)
    seexports.rl_gui:guiToFront(dashboardLayout[i][j].insideCurtain)
    seexports.rl_gui:fadeIn(dashboardLayout[i][j].insideCurtain, curtainTime)
    setTimer(function()
      if dashboardLayout[i][j].insideLayer then
        seexports.rl_gui:deleteGuiElement(dashboardLayout[i][j].insideLayer)
        dashboardLayout[i][j].insideLayer = false
        if dashboardLayout[i][j].insideDestroy then
          dashboardLayout[i][j].insideDestroy()
        end
      end
      setDashboardState(dashboardExpanded[1], dashboardExpanded[2], false)
      dashboardExpanded = false
      seexports.rl_gui:fadeOut(closeButton, expandTime)
      seexports.rl_gui:setGuiPositionAnimated(helpIcon, dashboardPos[1] + dashSize[1] - dashboardPadding[3] - 32, dashboardPos[2] - dashboardPadding[3] - 32, expandTime, false, "InOutQuad")
      seexports.rl_gui:setGuiPositionAnimated(ucpIcon, dashboardPos[1] + dashSize[1] - dashboardPadding[3] - 64, dashboardPos[2] - dashboardPadding[3] - 32, expandTime, false, "InOutQuad")
      seexports.rl_gui:setGuiHoverable(closeButton, false)
      seexports.rl_gui:setLabelText(pageName, " ANA SAYFA")
      seexports.rl_gui:lockHover(dashboardGui, false)
    end, curtainTime, 1)
    return expandTime + curtainTime
  else
    lastDashboardAnimation = getTickCount() - curtainTime
    if dashboardLayout[i][j].insideLayer then
      seexports.rl_gui:deleteGuiElement(dashboardLayout[i][j].insideLayer)
      dashboardLayout[i][j].insideLayer = false
      if dashboardLayout[i][j].insideDestroy then
        dashboardLayout[i][j].insideDestroy()
      end
    end
    setDashboardState(dashboardExpanded[1], dashboardExpanded[2], false)
    dashboardExpanded = false
    seexports.rl_gui:fadeOut(closeButton, expandTime)
    seexports.rl_gui:setGuiPositionAnimated(helpIcon, dashboardPos[1] + dashSize[1] - dashboardPadding[3] - 32, dashboardPos[2] - dashboardPadding[3] - 32, expandTime, false, "InOutQuad")
    seexports.rl_gui:setGuiPositionAnimated(ucpIcon, dashboardPos[1] + dashSize[1] - dashboardPadding[3] - 64, dashboardPos[2] - dashboardPadding[3] - 32, expandTime, false, "InOutQuad")
    seexports.rl_gui:setGuiHoverable(closeButton, false)
    seexports.rl_gui:setLabelText(pageName, " ANA SAYFA")
    seexports.rl_gui:lockHover(dashboardGui, false)
    return expandTime
  end
end
addEvent("dashboardCloseClick", true)
addEventHandler("dashboardCloseClick", getRootElement(), function(button, state, absoluteX, absoluteY, el)
  if getTickCount() - lastDashboardAnimation > expandTime + curtainTime and dashboardExpanded then
    closeDashPage()
  end
end)
function expandDashboard(i, j)
  if dashboardLayout[i][j].url then
    openURL(dashboardLayout[i][j].url)
    return
  end
  if dashboardLayout[i][j].checkFunction and not dashboardLayout[i][j].checkFunction() then
    return
  end
  seexports.rl_gui:lockHover(dashboardGui, true)
  setDashboardState(i, j, true)
  dashboardExpanded = {i, j}
  seexports.rl_gui:setGuiPositionAnimated(helpIcon, dashboardPos[1] + dashSize[1] - dashboardPadding[3] - 32 - 32, dashboardPos[2] - dashboardPadding[3] - 32, expandTime, false, "InOutQuad")
  seexports.rl_gui:setGuiPositionAnimated(ucpIcon, dashboardPos[1] + dashSize[1] - dashboardPadding[3] - 64 - 32, dashboardPos[2] - dashboardPadding[3] - 32, expandTime, false, "InOutQuad")
  seexports.rl_gui:fadeIn(closeButton, expandTime)
  seexports.rl_gui:setGuiHoverable(closeButton, true)
  seexports.rl_gui:setLabelText(pageName, " " .. utf8.upper(dashboardLayout[i][j].name, ""))
  lastDashboardAnimation = getTickCount()
end
addEvent("dashboardElementClick", true)
addEventHandler("dashboardElementClick", getRootElement(), function(button, state, absoluteX, absoluteY, el)
  if getTickCount() - lastDashboardAnimation > expandTime + curtainTime and not dashboardExpanded then
    for i = 1, dashboardGridSize[1] do
      for j = 1, dashboardGridSize[2] do
        if dashboardLayout[i][j] and dashboardLayout[i][j].element == el then
          expandDashboard(i, j)
          break
        end
      end
    end
  end
end)
