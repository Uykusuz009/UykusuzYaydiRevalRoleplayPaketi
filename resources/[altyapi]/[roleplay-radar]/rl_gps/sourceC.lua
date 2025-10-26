local seexports = {
  rl_gui = false,
  rl_radar = false,
  rl_chat = false
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
  if seelangStaticImageToc[0] and seelangStaticImageToc[1] and seelangStaticImageToc[2] then
    seelangStatImgHand = false
    removeEventHandler("onClientPreRender", getRootElement(), seelangStatImgPre)
  end
end
processSeelangStaticImage[0] = function()
  if not isElement(seelangStaticImage[0]) then
    seelangStaticImageToc[0] = false
    seelangStaticImage[0] = dxCreateTexture("files/arrow.dds", "argb", true)
  end
  if not seelangStatImgHand then
    seelangStatImgHand = true
    addEventHandler("onClientPreRender", getRootElement(), seelangStatImgPre, true, "high+999999999")
  end
end
processSeelangStaticImage[1] = function()
  if not isElement(seelangStaticImage[1]) then
    seelangStaticImageToc[1] = false
    seelangStaticImage[1] = dxCreateTexture("files/3d.dds", "argb", true)
  end
  if not seelangStatImgHand then
    seelangStatImgHand = true
    addEventHandler("onClientPreRender", getRootElement(), seelangStatImgPre, true, "high+999999999")
  end
end
processSeelangStaticImage[2] = function()
  if not isElement(seelangStaticImage[2]) then
    seelangStaticImageToc[2] = false
    seelangStaticImage[2] = dxCreateTexture("files/circ.dds", "argb", true)
  end
  if not seelangStatImgHand then
    seelangStatImgHand = true
    addEventHandler("onClientPreRender", getRootElement(), seelangStatImgPre, true, "high+999999999")
  end
end
local seelangGuiRefreshColors = function()
  local res = getResourceFromName("rl_gui")
  if res and getResourceState(res) == "running" then
    guiRefreshColors()
  end
end
addEventHandler("onGuiRefreshColors", getRootElement(), seelangGuiRefreshColors)
addEventHandler("onClientResourceStart", getResourceRootElement(), seelangGuiRefreshColors)
local soundPack = "w"
function getGpsSoundPack()
  if soundPack == "w" then
    return "Női"
  elseif soundPack == "m" then
    return "Férfi"
  else
    return "Kikapcsolva"
  end
end
local gpsSound = false
function setGpsSoundPack(pack)
  if pack == "Női" then
    soundPack = "w"
  elseif pack == "Férfi" then
    soundPack = "m"
  else
    soundPack = false
  end
  if isElement(gpsSound) then
    destroyElement(gpsSound)
  end
  gpsSound = nil
end
local soundPackDistances = {
  w = {
    200,
    300,
    400,
    500
  },
  m = {200, 500}
}
local closeCallout = false
local soundCallout = false
local soundQueue = {}
local currentGPSSound = false
addEventHandler("onClientSoundStopped", getRootElement(), function(reason)
  if source == gpsSound and reason == "finished" then
    playSoundQueue()
  end
end)
function playSingleGPSSound(sound)
  if soundPack then
    if sound == "ding" then
      soundQueue = {}
      if isElement(gpsSound) then
        destroyElement(gpsSound)
      end
      gpsSound = playSound("files/sound/ding.mp3")
      currentGPSSound = "ding"
    elseif sound == "dong" then
      soundQueue = {}
      if isElement(gpsSound) then
        destroyElement(gpsSound)
      end
      gpsSound = playSound("files/sound/dong.mp3")
      currentGPSSound = "dong"
    else
      soundQueue = {"ding", sound}
      playSoundQueue()
    end
  end
end
function playSoundQueue()
  if soundPack and 1 <= #soundQueue then
    if isElement(gpsSound) then
      destroyElement(gpsSound)
    end
    if soundQueue[1] == "ding" then
      gpsSound = playSound("files/sound/ding.mp3")
      currentGPSSound = "ding"
    else
      -- gpsSound = playSound("files/sound/" .. soundPack .. "/" .. soundQueue[1] .. ".mp3")
      currentGPSSound = soundQueue[1]
    end
    table.remove(soundQueue, 1)
  end
end
local screenX, screenY = guiGetScreenSize()
seelangStaticImageUsed[0] = true
if seelangStaticImageToc[0] then
  processSeelangStaticImage[0]()
end
seelangStaticImageUsed[1] = true
if seelangStaticImageToc[1] then
  processSeelangStaticImage[1]()
end
local col = false
local linec = false
local backgroundColor = false
local font = false
local fontScale = false
function guiRefreshColors()
  col = seexports.rl_gui:getColorCode("v4blue")
  linec = tocolor(col[1], col[2], col[3])
  backgroundColor = seexports.rl_gui:getColorCode("v4grey1")
  -- font = seexports.rl_gui:getFont("12/Ubuntu-R.ttf")
  font = exports.staris_fonts:getFont("bebas",1)
  fontScale = 0.55555556
  print(font)
end
function drawRoadArrows(x, y, z, x2, y2, z2, a)
  local d = getDistanceBetweenPoints3D(x, y, z, x2, y2, z2)
  seelangStaticImageUsed[0] = true
  if seelangStaticImageToc[0] then
    processSeelangStaticImage[0]()
  end
  dxDrawMaterialSectionLine3D(x, y, z, x2, y2, z2, 0, 0, 256, 256 * math.floor(d / 1 * 1.35 + 0.5), seelangStaticImage[0], 1, tocolor(col[1], col[2], col[3], a * 255), (x + x2) / 2, (y + y2) / 2, (z + z2) / 2 + 1)
end
function drawRoadArrowsPercentage(x, y, z, x2, y2, z2, p)
  local d = getDistanceBetweenPoints3D(x, y, z, x2, y2, z2)
  local h = 256 * math.floor(d / 1 * 1.35 + 0.5)
  x = x - x2
  y = y - y2
  z = z - z2
  local x, y, z = x2 + x * p, y2 + y * p, z2 + z * p
  seelangStaticImageUsed[0] = true
  if seelangStaticImageToc[0] then
    processSeelangStaticImage[0]()
  end
  dxDrawMaterialSectionLine3D(x, y, z, x2, y2, z2, 0, h * (1 - p), 256, h * p, seelangStaticImage[0], 1, tocolor(col[1], col[2], col[3]), (x + x2) / 2, (y + y2) / 2, (z + z2) / 2 + 1)
end
local startNode = false
local currentNode = false
local targetNode = false
local targetX, targetY, targetZ
function calculateHCost(i)
  return getDistanceBetweenPoints2D(targetX, targetY, newNodes[i].x, newNodes[i].y)
end
local gpsAlive = false
local loopCount = 0
local pathfindingAlive = false
local prePathfindingAlive = false
local lastReRoute = 0
local lastTurnaround = 0
local hCosts = {}
local gCosts = {}
local fCosts = {}
local parentNode = {}
local closedSet = {}
local openSet = {}
local openLowest = false
local theRoute = {}
local routeDone = {}
function resetPathfinding()
  if pathfindingAlive or gpsAlive or prePathfindingAlive then
    pathfindingAlive = false
    prePathfindingAlive = false
    hCosts = {}
    gCosts = {}
    fCosts = {}
    parentNode = {}
    closedSet = {}
    openSet = {}
    theRoute = {}
    routeDone = {}
    gpsAlive = false
    processGPSWidget()
    seexports.rl_radar:forceRadarToRender()
  end
  if currentGPSSound ~= "finish" and currentGPSSound ~= "nincskapcs" then
    for i = 1, #soundQueue do
      if soundQueue[i] == "finish" or soundQueue[i] == "nincskapcs" then
        return
      end
    end
    if isElement(gpsSound) then
      destroyElement(gpsSound)
    end
    gpsSound = nil
  end
end
function toClosed(node)
  if openLowest == node then
    openLowest = false
    for i in pairs(openSet) do
      if not openLowest or fCosts[i] < fCosts[openLowest] then
        openLowest = i
      end
    end
  end
  openSet[node] = nil
  closedSet[node] = true
end
function pushOpenSet(i)
  openSet[i] = true
  if not openLowest or fCosts[i] < fCosts[openLowest] then
    openLowest = i
  end
end
function setNodeG(node, g)
  if not hCosts[node] then
    hCosts[node] = calculateHCost(node)
  end
  gCosts[node] = g
  fCosts[node] = gCosts[node] + hCosts[node]
end
local targetIntersections = {}
function initPathfinding(from, to)
  if targetNode ~= to then
    resetPathfinding()
  end
  startNode = from
  currentNode = from
  targetNode = to
  parentNode = {}
  closedSet = {}
  openSet = {}
  theRoute = {}
  routeDone = {}
  loopCount = 0
  targetX, targetY, targetZ = newNodes[targetNode].x, newNodes[targetNode].y, newNodes[targetNode].z
  openLowest = currentNode
  setNodeG(currentNode, 0)
  pushOpenSet(currentNode)
  pathfindingAlive = true
  processGPSWidget()
  targetIntersections = {}
  seexports.rl_radar:forceRadarToRender()
  if not newNodes[targetNode].intersection then
    for j = 1, #newNodes[targetNode].intersectionLinksFrom do
      if targetIntersections[newNodes[targetNode].intersectionLinksFrom[j][1]] then
        if newNodes[targetNode].intersectionLinksFrom[j][3] < targetIntersections[newNodes[targetNode].intersectionLinksFrom[j][1]] then
          targetIntersections[newNodes[targetNode].intersectionLinksFrom[j][1]] = newNodes[targetNode].intersectionLinksFrom[j][3]
        end
      else
        targetIntersections[newNodes[targetNode].intersectionLinksFrom[j][1]] = newNodes[targetNode].intersectionLinksFrom[j][3]
      end
    end
  end
end
function insertRoadArrowsBezier(tbl, k, l, x, y, z, x2, y2, z2, x3, y3, z3)
  for t = 1, 0, -0.2 do
    pz = z + (z2 - z) * t
    px = x * t ^ 2 + x2 * 2 * t * (1 - t) + x3 * (1 - t) ^ 2
    py = y * t ^ 2 + y2 * 2 * t * (1 - t) + y3 * (1 - t) ^ 2
    k = k + 1
    if not tbl[k] then
      tbl[k] = {}
    end
    tbl[k][l] = {
      px,
      py,
      pz
    }
  end
  return k
end
function lineLineIntersection(Ax, Ay, Bx, By, Cx, Cy, Dx, Dy)
  local a1 = By - Ay
  local b1 = Ax - Bx
  local c1 = a1 * Ax + b1 * Ay
  local a2 = Dy - Cy
  local b2 = Cx - Dx
  local c2 = a2 * Cx + b2 * Cy
  local determinant = a1 * b2 - a2 * b1
  if determinant == 0 then
    return (Ax + Bx + Cx + Dx) / 4, (Ay + By + Cy + Dy) / 4
  else
    local x = (b2 * c1 - b1 * c2) / determinant
    local y = (a1 * c2 - a2 * c1) / determinant
    return x, y
  end
end
local nextSignData = false
local currentSignData = false
local lastSignData = false
local currentSign = 0
function processRoute()
  local tmp = {}
  for i = #theRoute - 1, 1, -1 do
    local id = theRoute[i + 1]
    local id2 = theRoute[i]
    table.insert(tmp, id)
    local node = newNodes[id]
    if node then
      for j = 1, #node.links do
        if node.links[j][1] == id2 then
          local navi = node.links[j][2]
          local a = node.links[j][4]
          local left = a <= math.pi / 2 or a >= math.pi / 2 * 3
          table.insert(tmp, {navi, left})
          break
        end
      end
    end
  end
  routeDone = {}
  local k = 0
  local s = 0
  local tpi = math.pi * 0.075
  local dpi = (math.pi - tpi) / 3
  currentSign = 0
  currentSignData = false
  nextSignData = false
  lastSignData = false
  local signId = 0
  for i = 1, #tmp do
    local dat = tmp[i]
    if tonumber(dat) then
      local node = newNodes[dat]
      local nextDat = tmp[i + 1]
      local nextNavi = nextDat and not tonumber(nextDat) and newNavis[nextDat[1]]
      local prevDat, prevNavi
      if not nextNavi or node.intersection then
        prevDat = tmp[i - 1]
        prevNavi = prevDat and not tonumber(prevDat) and newNavis[prevDat[1]]
      end
      if not nextNavi then
        nextDat = prevDat
        nextNavi = prevNavi
      end
      if node.intersection and prevNavi then
        local l1 = (prevDat[2] and prevNavi.ll or prevNavi.rl) - 1
        local l2 = (nextDat[2] and nextNavi.ll or nextNavi.rl) - 1
        local pvx, pvy = prevNavi.x - node.x, prevNavi.y - node.y
        local nvx, nvy = node.x - nextNavi.x, node.y - nextNavi.y
        local diff = math.abs(math.atan2(pvx * nvy - pvy * nvx, pvx * nvx + pvy * nvy))
        if diff <= tpi * 2 then
          k = k + 1
          routeDone[k] = {}
          local dx, dy = nextNavi.dx, nextNavi.dy
          local lx, ly = nextNavi.lx, nextNavi.ly
          local left = nextDat[2]
          for l = 0, math.max(0, (left and nextNavi.ll or nextNavi.rl) - 1) do
            if left then
              routeDone[k][l] = {
                node.x + lx - dy * l,
                node.y + ly + dx * l,
                node.z
              }
            else
              local lane = nextNavi.rl - (1 + l)
              routeDone[k][l] = {
                node.x + lx - dy * (nextNavi.ll + lane),
                node.y + ly + dx * (nextNavi.ll + lane),
                node.z
              }
            end
          end
        else
          local ko = k
          s = s + 1
          signId = signId + 1
          for li = 0, math.max(0, l1, l2) do
            local px, py
            local dx, dy = prevNavi.dx, prevNavi.dy
            local lx, ly = prevNavi.lx, prevNavi.ly
            local l = math.min(li, l1)
            if prevDat[2] then
              px, py = lx - dy * l, ly + dx * l
            else
              local lane = prevNavi.rl - (1 + l)
              px, py = lx - dy * (prevNavi.ll + lane), ly + dx * (prevNavi.ll + lane)
            end
            local nx, ny
            local dx, dy = nextNavi.dx, nextNavi.dy
            local lx, ly = nextNavi.lx, nextNavi.ly
            local l = math.min(li, l2)
            if nextDat[2] then
              nx, ny = lx - dy * l, ly + dx * l
            else
              local lane = nextNavi.rl - (1 + l)
              nx, ny = lx - dy * (nextNavi.ll + lane), ly + dx * (nextNavi.ll + lane)
            end
            vx = (px + nx) / 2
            vy = (py + ny) / 2
            local x2, y2, z2 = prevNavi.x + px, prevNavi.y + py, node.z
            local x3, y3, z3 = nextNavi.x + nx, nextNavi.y + ny, node.z
            local x, y = lineLineIntersection(x2, y2, x2 + pvx, y2 + pvy, x3, y3, x3 + nvx, y3 + nvy)
            local z = node.z
            ko = insertRoadArrowsBezier(routeDone, k, li, x2, y2, z2, x, y, z, x3, y3, z3)
            local nx, ny = x2 - x, y2 - y
            local len = math.sqrt(nx * nx + ny * ny)
            local u, v = false, false
            local pvx, pvy = x2 - x, y2 - y
            local nvx, nvy = x - x3, y - y3
            local diff = math.atan2(pvx * nvy - pvy * nvx, pvx * nvx + pvy * nvy)
            local inv = 0 < diff
            diff = math.abs(diff)
            if diff > tpi * 2 then
              if diff >= dpi * 2 then
                u, v = 256, 512
              elseif dpi <= diff then
                u, v = 0, 256
              else
                u, v = 0, 512
              end
              routeDone[math.floor((k + ko) / 2)][li][7] = {
                x,
                y,
                z + 1,
                nx / len,
                ny / len,
                u,
                v,
                inv,
                signId
              }
            end
          end
          k = ko
        end
      elseif nextNavi then
        k = k + 1
        routeDone[k] = {}
        local dx, dy = nextNavi.dx, nextNavi.dy
        local lx, ly = nextNavi.lx, nextNavi.ly
        local left = nextDat[2]
        for l = 0, math.max(0, (left and nextNavi.ll or nextNavi.rl) - 1) do
          if left then
            routeDone[k][l] = {
              node.x + lx - dy * l,
              node.y + ly + dx * l,
              node.z
            }
          else
            local lane = nextNavi.rl - (1 + l)
            routeDone[k][l] = {
              node.x + lx - dy * (nextNavi.ll + lane),
              node.y + ly + dx * (nextNavi.ll + lane),
              node.z
            }
          end
        end
      end
    end
  end
  for i = 1, #routeDone - 1 do
    for li = 0, math.max(#routeDone[i], #routeDone[i + 1]) do
      local l = math.min(li, #routeDone[i])
      local l2 = math.min(li, #routeDone[i + 1])
      routeDone[i][l][5] = getDistanceBetweenPoints2D(routeDone[i][l][1], routeDone[i][l][2], routeDone[i + 1][l2][1], routeDone[i + 1][l2][2])
      routeDone[i][l][6] = getDistanceBetweenPoints3D(routeDone[i][l][1], routeDone[i][l][2], routeDone[i][l][3], routeDone[i + 1][l2][1], routeDone[i + 1][l2][2], routeDone[i + 1][l2][3])
    end
  end
  if routeDone[#routeDone] and routeDone[#routeDone - 1] then
    for li = 0, math.max(#routeDone[#routeDone], #routeDone[#routeDone - 1]) do
      local l = math.min(li, #routeDone[#routeDone])
      local l2 = math.min(li, #routeDone[#routeDone - 1])
      local x, y, z = routeDone[#routeDone][l][1], routeDone[#routeDone][l][2], routeDone[#routeDone][l][3]
      local x2, y2, z2 = routeDone[#routeDone - 1][l2][1], routeDone[#routeDone - 1][l2][2], routeDone[#routeDone - 1][l2][3]
      local nx, ny = x2 - x, y2 - y
      local len = math.sqrt(nx * nx + ny * ny)
      routeDone[#routeDone][l][7] = {
        x,
        y,
        z + 1,
        nx / len,
        ny / len,
        256,
        768,
        false,
        signId + 1,
        true
      }
    end
  end
  gpsAlive = true
  processGPSWidget()
end
function pushNodeUntilEx(tmp, node, untilNode)
  table.insert(tmp, node)
  if node == untilNode then
    return
  end
  local minD = false
  local minJ = false
  for j = 1, #newNodes[node].intersectionLinks do
    if newNodes[node].intersectionLinks[j][1] == untilNode and (not minD or minD > newNodes[node].intersectionLinks[j][3]) then
      minD = newNodes[node].intersectionLinks[j][3]
      minJ = j
    end
  end
  if minJ then
    pushNodeUntilEx(tmp, newNodes[node].intersectionLinks[minJ][2], untilNode)
  end
end
function pushNodeUntil(tmp, node, untilNode)
  if node == untilNode then
    pushNode(tmp, untilNode)
    return
  end
  table.insert(tmp, node)
  if node == startNode then
    return
  end
  local minD = false
  local minJ = false
  for j = 1, #newNodes[node].intersectionLinksFrom do
    if newNodes[node].intersectionLinksFrom[j][1] == untilNode and (not minD or minD > newNodes[node].intersectionLinksFrom[j][3]) then
      minD = newNodes[node].intersectionLinksFrom[j][3]
      minJ = j
    end
  end
  if minJ then
    pushNodeUntil(tmp, newNodes[node].intersectionLinksFrom[minJ][2], untilNode)
  end
end
function pushNode(tmp, node)
  table.insert(tmp, node)
  if node == startNode then
    return
  end
  if parentNode[node] then
    local minD = false
    local minJ = false
    for j = 1, #newNodes[node].intersectionLinksFrom do
      if newNodes[node].intersectionLinksFrom[j][1] == parentNode[node] and (not minD or minD > newNodes[node].intersectionLinksFrom[j][3]) then
        minD = newNodes[node].intersectionLinksFrom[j][3]
        minJ = j
      end
    end
    if minJ then
      pushNodeUntil(tmp, newNodes[node].intersectionLinksFrom[minJ][2], parentNode[node])
      return
    end
    pushNode(tmp, parentNode[node])
  end
end
function pathLoop()
  currentNode = openLowest
  toClosed(currentNode)
  loopCount = loopCount + 1
  if currentNode == targetNode then
    pathfindingAlive = false
    theRoute = {}
    pushNode(theRoute, targetNode)
    if not newNodes[theRoute[#theRoute]].intersection then
      local from = theRoute[#theRoute]
      table.remove(theRoute, #theRoute)
      local to = theRoute[#theRoute]
      table.remove(theRoute, #theRoute)
      local tmp = {}
      pushNodeUntilEx(tmp, from, to)
      for i = #tmp, 1, -1 do
        table.insert(theRoute, tmp[i])
      end
    end
    processRoute()
    seexports.rl_radar:forceRadarToRender()
  end
  local node = newNodes[currentNode]
  if node then
    for j = 1, #node.intersectionLinks do
      local id = node.intersectionLinks[j][1]
      if not closedSet[id] then
        local d = node.intersectionLinks[j][3] + gCosts[currentNode]
        if not openSet[id] or d < gCosts[id] then
          setNodeG(id, d)
          parentNode[id] = currentNode
          if not openSet[id] then
            pushOpenSet(id)
          end
        end
      end
    end
  end
  if targetIntersections[currentNode] then
    local id = targetNode
    if not closedSet[id] then
      local d = targetIntersections[currentNode] + gCosts[currentNode]
      if not openSet[id] or d < gCosts[id] then
        setNodeG(id, d)
        parentNode[id] = currentNode
        if not openSet[id] then
          pushOpenSet(id)
        end
      end
    end
  end
end
local enteredGPS = false
local veh = false
function enteredGPSPreRender()
  if veh and enteredGPS and prePathfindingAlive then
    local node = findNearestNodeToVeh(veh)
    if node then
      initPathfinding(node, enteredGPS)
    else
      return
    end
  end
  enteredGPS = false
  removeEventHandler("onClientPreRender", getRootElement(), enteredGPSPreRender)
end
function enterVeh(v)
  resetPathfinding()
  veh = v
  local target = getElementData(veh, "gpsTarget")
  if target then
    local node = findNearestNodeToVeh(veh)
    if node then
      initPathfinding(node, target)
    else
      prePathfindingAlive = true
      processGPSWidget()
      seexports.rl_radar:forceRadarToRender()
      targetX, targetY, targetZ = newNodes[target].x, newNodes[target].y, newNodes[target].z
      if not enteredGPS then
        addEventHandler("onClientPreRender", getRootElement(), enteredGPSPreRender)
      end
      enteredGPS = target
    end
  end
end
addEventHandler("onClientPlayerVehicleEnter", localPlayer, function(v)
  local vt = getVehicleType(v)
  if vt == "Automobile" or vt == "Quad" or vt == "Bike" then
    enterVeh(v)
  elseif veh then
    exitGPSVehicle()
  end
end)
addEventHandler("onClientPlayerVehicleExit", localPlayer, function()
  exitGPSVehicle()
end)
function exitGPSVehicle()
  resetPathfinding()
  veh = false
end
addEventHandler("onClientElementDataChange", getRootElement(), function(data, old, new)
  if source == veh and data == "gpsTarget" then
    if new and newNodes[new] then
      local node = findNearestNodeToVeh(veh)
      if node then
        initPathfinding(node, new)
      else
        prePathfindingAlive = true
        processGPSWidget()
        seexports.rl_radar:forceRadarToRender()
        targetX, targetY, targetZ = newNodes[new].x, newNodes[new].y, newNodes[new].z
        if not enteredGPS then
          addEventHandler("onClientPreRender", getRootElement(), enteredGPSPreRender)
        end
        enteredGPS = new
      end
      playSingleGPSSound("uticel")
    else
      resetPathfinding()
    end
  end
end)
function findNearestNodeToVeh(veh)
  local px, py, pz = getElementPosition(veh)
  local rx, ry, rz = getElementRotation(veh)
  rz = math.rad(rz)
  local minNode = false
  local mind = false
  local x = math.floor(px / reRouteDistance)
  local y = math.floor(py / reRouteDistance)
  for l = x - 1, x + 1 do
    if nodeIndexes[l] then
      for j = y - 1, y + 1 do
        if nodeIndexes[l][j] then
          for k = 1, #nodeIndexes[l][j] do
            local i = nodeIndexes[l][j][k]
            local node = newNodes[i]
            if node then
              local d = getDistanceBetweenPoints3D(px, py, pz, node.x, node.y, node.z)
              if d < reRouteDistance then
                for j = 1, #node.links do
                  local a = node.links[j][5] - rz
                  a = (a + math.pi) % (math.pi * 2) - math.pi
                  if a < 0 then
                    if not mind or mind > d then
                      mind = d
                      minNode = i
                    end
                    break
                  end
                end
              end
            end
          end
        end
      end
    end
  end
  if not minNode then
    for i = 1, #newNodes do
      local node = newNodes[i]
      if node then
        local d = getDistanceBetweenPoints3D(px, py, pz, node.x, node.y, node.z)
        if not mind or mind > d then
          mind = d
          minNode = i
        end
      end
    end
  end
  return minNode
end
function navigateToCoords(x, y)
  x = tonumber(x)
  y = tonumber(y)
  if veh then
    if x and y then
      local node = findNearestNodeToCoord(x, y)
      if node then
        setElementData(veh, "gpsTarget", node)
        -- seexports.rl_chat:localActionC(localPlayer, "beállított egy úticélt a GPS-ben.")
      else
        playSingleGPSSound("masikuticel")
      end
    else
      setElementData(veh, "gpsTarget", nil)
    end
  end
end
addCommandHandler("gpsto", function(commandName, x, y)
  if not tonumber(x) then
    x = tostring(x or "")
    y = tostring(y or "")
    dat = x .. y
    dat = split(dat, ",")
    x = dat[1]
    y = dat[2]
  end
  x = tonumber(x)
  y = tonumber(y)
  if not x or not y then
    outputChatBox("[color=v4blue][V4Mod - Használat]: #FFFFFF/" .. commandName .. " [x] [y]", 255, 255, 255, true)
  else
    navigateToCoords(x, y)
  end
end)
function pDistance(x, y, x1, y1, x2, y2)
  local A = x - x1
  local B = y - y1
  local C = x2 - x1
  local D = y2 - y1
  local dot = A * C + B * D
  local len_sq = C * C + D * D
  local param = -1
  if len_sq ~= 0 then
    param = dot / len_sq
  end
  return param, x1 + math.min(1, param) * C, y1 + math.min(1, param) * D
end
function drawGPSSign(x, y, z, nx, ny, u, v, inverse, a)
  local c = tocolor(col[1], col[2], col[3], 255 * a)
  local s = 2
  seelangStaticImageUsed[1] = true
  if seelangStaticImageToc[1] then
    processSeelangStaticImage[1]()
  end
  dxDrawMaterialSectionLine3D(x, y, z + s * 2.1, x, y, z + s * 1.1, 256, 0, 256, 256, seelangStaticImage[1], s, tocolor(255, 255, 255), x + nx, y + ny, z)
  seelangStaticImageUsed[1] = true
  if seelangStaticImageToc[1] then
    processSeelangStaticImage[1]()
  end
  dxDrawMaterialSectionLine3D(x, y, z + s * 2.1, x, y, z + s * 1.1, 0, 0, 256, 256, seelangStaticImage[1], s, c, x + nx, y + ny, z)
  seelangStaticImageUsed[1] = true
  if seelangStaticImageToc[1] then
    processSeelangStaticImage[1]()
  end
  dxDrawMaterialSectionLine3D(x + nx * 0.05, y + ny * 0.05, z + s * 2.1, x + nx * 0.05, y + ny * 0.05, z + s * 1.1, u + (inverse and 256 or 0), v, inverse and -256 or 256, 256, seelangStaticImage[1], s, tocolor(255, 255, 255), x + nx, y + ny, z)
  seelangStaticImageUsed[1] = true
  if seelangStaticImageToc[1] then
    processSeelangStaticImage[1]()
  end
  dxDrawMaterialSectionLine3D(x, y, z + s, x, y, z, 0, 768, 256, 256, seelangStaticImage[1], s / 5, c, x + nx, y + ny, z)
end
local laneIn, minPerc
function formatCalloutDistance(dist)
  if 10000 <= dist then
    return math.floor(dist / 1000 + 0.5) .. " km"
  elseif 1000 <= dist then
    return math.floor(dist / 1000 * 10 + 0.5) / 10 .. " km"
  elseif 500 <= dist then
    return math.floor(dist / 50 + 0.5) * 50 .. " m"
  elseif 50 <= dist then
    return math.floor(dist / 10 + 0.5) * 10 .. " m"
  else
    return math.ceil(dist / 5) * 5 .. " m"
  end
end
local nextDist = 0
local radarPos = {0, 0}
local radarSize = {0, 0}
local radarWidgetState = false
local gpsWidgetPos = {0, 0}
local gpsWidgetSize = {0, 0}
local gpsWidgetState = false
local signSwitchTime = false
local turnAround = false
function drawGPSInstructions(x, y, sx, sy, base, bg)
  local now = getTickCount()
  local fs = base / 32 * 0.425
  local fh = dxGetFontHeight(fontScale * fs, font)
  local base2 = base - fh
  base = base2 / 1.5
  if pathfindingAlive or prePathfindingAlive then
    local w = tocolor(255, 255, 255)
    local r = now / 5 % 360
    local ix = x + sx / 2 - base2 / 2
    local iy = y + sy - base2 - fh - 8
    if bg then
      local c = tocolor(col[1], col[2], col[3])
      local b = tocolor(0, 0, 0)
      seelangStaticImageUsed[1] = true
      if seelangStaticImageToc[1] then
        processSeelangStaticImage[1]()
      end
      dxDrawImageSection(ix, iy, base2, base2, 256, 0, 256, 256, seelangStaticImage[1], 0, 0, 0, w)
      seelangStaticImageUsed[1] = true
      if seelangStaticImageToc[1] then
        processSeelangStaticImage[1]()
      end
      dxDrawImageSection(ix, iy, base2, base2, 0, 0, 256, 256, seelangStaticImage[1], 0, 0, 0, c)
      seelangStaticImageUsed[1] = true
      if seelangStaticImageToc[1] then
        processSeelangStaticImage[1]()
      end
      dxDrawImageSection(ix + 1, iy + 1, base2, base2, 256, 256, 256, 256, seelangStaticImage[1], r, 0, 0, b)
    end
    seelangStaticImageUsed[1] = true
    if seelangStaticImageToc[1] then
      processSeelangStaticImage[1]()
    end
    dxDrawImageSection(ix, iy, base2, base2, 256, 256, 256, 256, seelangStaticImage[1], r, 0, 0, w)
  elseif turnAround then
    local w = tocolor(255, 255, 255)
    local ix = x + sx / 2 - base2 / 2
    local iy = y + sy - base2 - fh - 8
    if bg then
      local c = tocolor(col[1], col[2], col[3])
      local b = tocolor(0, 0, 0)
      seelangStaticImageUsed[1] = true
      if seelangStaticImageToc[1] then
        processSeelangStaticImage[1]()
      end
      dxDrawImageSection(ix, iy, base2, base2, 256, 0, 256, 256, seelangStaticImage[1], 0, 0, 0, w)
      seelangStaticImageUsed[1] = true
      if seelangStaticImageToc[1] then
        processSeelangStaticImage[1]()
      end
      dxDrawImageSection(ix, iy, base2, base2, 0, 0, 256, 256, seelangStaticImage[1], 0, 0, 0, c)
      seelangStaticImageUsed[1] = true
      if seelangStaticImageToc[1] then
        processSeelangStaticImage[1]()
      end
      dxDrawImageSection(ix + 1, iy + 1, base2, base2, 0, 1024, 256, 256, seelangStaticImage[1], 0, 0, 0, b)
    end
    seelangStaticImageUsed[1] = true
    if seelangStaticImageToc[1] then
      processSeelangStaticImage[1]()
    end
    dxDrawImageSection(ix, iy, base2, base2, 0, 1024, 256, 256, seelangStaticImage[1], 0, 0, 0, w)
  elseif signSwitchTime and lastSignData then
    local p = (now - signSwitchTime) / 500
    local a2 = 0
    if 2 <= p then
      signSwitchTime = false
      a2 = 255
      p = 1
    elseif 1 <= p then
      a2 = 255 * getEasingValue(p - 1, "OutQuad")
      p = 1
    end
    local a = 255 * getEasingValue(1 - p, "InQuad")
    p = getEasingValue(p, "OutQuad")
    local w = tocolor(255, 255, 255, a)
    local ix = x + sx / 2 - base2 / 2
    local iy = y + sy - base2 - fh - 8
    local u, v, inv = lastSignData[1], lastSignData[2], lastSignData[3]
    if bg then
      local c = tocolor(col[1], col[2], col[3], a)
      local b = tocolor(0, 0, 0, a)
      seelangStaticImageUsed[1] = true
      if seelangStaticImageToc[1] then
        processSeelangStaticImage[1]()
      end
      dxDrawImageSection(ix, iy, base2, base2, 256, 0, 256, 256, seelangStaticImage[1], 0, 0, 0, w)
      seelangStaticImageUsed[1] = true
      if seelangStaticImageToc[1] then
        processSeelangStaticImage[1]()
      end
      dxDrawImageSection(ix, iy, base2, base2, 0, 0, 256, 256, seelangStaticImage[1], 0, 0, 0, c)
      seelangStaticImageUsed[1] = true
      if seelangStaticImageToc[1] then
        processSeelangStaticImage[1]()
      end
      dxDrawImageSection(ix + 1, iy + 1, base2, base2, u + (inv and 256 or 0), v, 256 * (inv and -1 or 1), 256, seelangStaticImage[1], 0, 0, 0, b)
    end
    seelangStaticImageUsed[1] = true
    if seelangStaticImageToc[1] then
      processSeelangStaticImage[1]()
    end
    dxDrawImageSection(ix, iy, base2, base2, u + (inv and 256 or 0), v, 256 * (inv and -1 or 1), 256, seelangStaticImage[1], 0, 0, 0, w)
    if currentSignData then
      w = tocolor(255, 255, 255)
      local s = base + (base2 - base) * p
      ix = x + sx / 2 + base - (base + base2 / 2) * p
      iy = y + sy - base - fh - 8 - (base2 - base) * p
      local u, v, inv = currentSignData[1], currentSignData[2], currentSignData[3]
      if bg then
        c = tocolor(col[1], col[2], col[3])
        b = tocolor(0, 0, 0)
        seelangStaticImageUsed[1] = true
        if seelangStaticImageToc[1] then
          processSeelangStaticImage[1]()
        end
        dxDrawImageSection(ix, iy, s, s, 256, 0, 256, 256, seelangStaticImage[1], 0, 0, 0, w)
        seelangStaticImageUsed[1] = true
        if seelangStaticImageToc[1] then
          processSeelangStaticImage[1]()
        end
        dxDrawImageSection(ix, iy, s, s, 0, 0, 256, 256, seelangStaticImage[1], 0, 0, 0, c)
        seelangStaticImageUsed[1] = true
        if seelangStaticImageToc[1] then
          processSeelangStaticImage[1]()
        end
        dxDrawImageSection(ix + 1, iy + 1, s, s, u + (inv and 256 or 0), v, 256 * (inv and -1 or 1), 256, seelangStaticImage[1], 0, 0, 0, b)
      end
      seelangStaticImageUsed[1] = true
      if seelangStaticImageToc[1] then
        processSeelangStaticImage[1]()
      end
      dxDrawImageSection(ix, iy, s, s, u + (inv and 256 or 0), v, 256 * (inv and -1 or 1), 256, seelangStaticImage[1], 0, 0, 0, w)
      w = tocolor(255, 255, 255, 255 * p)
      local tx, ty = x + sx / 2, y + sy - fh - 8
      local text = formatCalloutDistance(nextDist)
      if bg then
        b = tocolor(0, 0, 0, 255 * p)
        for x = -1, 1, 2 do
          for y = -1, 1, 2 do
            dxDrawText(text, tx + x, ty + y, tx + x, 0, b, fontScale * fs, font, "center", "top")
          end
        end
      end
      dxDrawText(text, tx, ty, tx, 0, w, fontScale * fs, font, "center", "top")
    end
    if nextSignData then
      w = tocolor(255, 255, 255, a2)
      local u, v, inv = nextSignData[6], nextSignData[7], nextSignData[8]
      ix = x + sx / 2 + base
      iy = y + sy - base - fh - 8
      if bg then
        c = tocolor(col[1], col[2], col[3], a2)
        b = tocolor(0, 0, 0, a2)
        seelangStaticImageUsed[1] = true
        if seelangStaticImageToc[1] then
          processSeelangStaticImage[1]()
        end
        dxDrawImageSection(ix, iy, base, base, 256, 0, 256, 256, seelangStaticImage[1], 0, 0, 0, w)
        seelangStaticImageUsed[1] = true
        if seelangStaticImageToc[1] then
          processSeelangStaticImage[1]()
        end
        dxDrawImageSection(ix, iy, base, base, 0, 0, 256, 256, seelangStaticImage[1], 0, 0, 0, c)
        seelangStaticImageUsed[1] = true
        if seelangStaticImageToc[1] then
          processSeelangStaticImage[1]()
        end
        dxDrawImageSection(ix + 1, iy + 1, base, base, u + (inv and 256 or 0), v, 256 * (inv and -1 or 1), 256, seelangStaticImage[1], 0, 0, 0, b)
      end
      seelangStaticImageUsed[1] = true
      if seelangStaticImageToc[1] then
        processSeelangStaticImage[1]()
      end
      dxDrawImageSection(ix, iy, base, base, u + (inv and 256 or 0), v, 256 * (inv and -1 or 1), 256, seelangStaticImage[1], 0, 0, 0, w)
    end
  elseif currentSignData then
    local w = tocolor(255, 255, 255)
    local b = tocolor(0, 0, 0)
    local c = tocolor(col[1], col[2], col[3])
    local ix = x + sx / 2 - base2 / 2
    local iy = y + sy - base2 - fh - 8
    local u, v, inv = currentSignData[1], currentSignData[2], currentSignData[3]
    if bg then
      seelangStaticImageUsed[1] = true
      if seelangStaticImageToc[1] then
        processSeelangStaticImage[1]()
      end
      dxDrawImageSection(ix, iy, base2, base2, 256, 0, 256, 256, seelangStaticImage[1], 0, 0, 0, w)
      seelangStaticImageUsed[1] = true
      if seelangStaticImageToc[1] then
        processSeelangStaticImage[1]()
      end
      dxDrawImageSection(ix, iy, base2, base2, 0, 0, 256, 256, seelangStaticImage[1], 0, 0, 0, c)
      seelangStaticImageUsed[1] = true
      if seelangStaticImageToc[1] then
        processSeelangStaticImage[1]()
      end
      dxDrawImageSection(ix + 1, iy + 1, base2, base2, u + (inv and 256 or 0), v, 256 * (inv and -1 or 1), 256, seelangStaticImage[1], 0, 0, 0, b)
    end
    seelangStaticImageUsed[1] = true
    if seelangStaticImageToc[1] then
      processSeelangStaticImage[1]()
    end
    dxDrawImageSection(ix, iy, base2, base2, u + (inv and 256 or 0), v, 256 * (inv and -1 or 1), 256, seelangStaticImage[1], 0, 0, 0, w)
    local tx, ty = x + sx / 2, y + sy - fh - 8
    local text = formatCalloutDistance(nextDist)
    if bg then
      for x = -1, 1, 2 do
        for y = -1, 1, 2 do
          dxDrawText(text, tx + x, ty + y, tx + x, 0, b, fontScale * fs, font, "center", "top")
        end
      end
    end
    dxDrawText(text, tx, ty, tx, 0, w, fontScale * fs, font, "center", "top")
    if nextSignData then
      local u, v, inv = nextSignData[6], nextSignData[7], nextSignData[8]
      ix = x + sx / 2 + base
      iy = y + sy - base - fh - 8
      if bg then
        seelangStaticImageUsed[1] = true
        if seelangStaticImageToc[1] then
          processSeelangStaticImage[1]()
        end
        dxDrawImageSection(ix, iy, base, base, 256, 0, 256, 256, seelangStaticImage[1], 0, 0, 0, w)
        seelangStaticImageUsed[1] = true
        if seelangStaticImageToc[1] then
          processSeelangStaticImage[1]()
        end
        dxDrawImageSection(ix, iy, base, base, 0, 0, 256, 256, seelangStaticImage[1], 0, 0, 0, c)
        seelangStaticImageUsed[1] = true
        if seelangStaticImageToc[1] then
          processSeelangStaticImage[1]()
        end
        dxDrawImageSection(ix + 1, iy + 1, base, base, u + (inv and 256 or 0), v, 256 * (inv and -1 or 1), 256, seelangStaticImage[1], 0, 0, 0, b)
      end
      seelangStaticImageUsed[1] = true
      if seelangStaticImageToc[1] then
        processSeelangStaticImage[1]()
      end
      dxDrawImageSection(ix, iy, base, base, u + (inv and 256 or 0), v, 256 * (inv and -1 or 1), 256, seelangStaticImage[1], 0, 0, 0, w)
    end
  end
end
function renderGPSInstructions()
  local base = 64
  local x, y = 0, 0
  local sx, sy = 0, 0
  if gpsWidgetState then
    x, y = gpsWidgetPos[1], gpsWidgetPos[2]
    sx, sy = gpsWidgetSize[1], gpsWidgetSize[2]
    base = sy - 8
  elseif radarWidgetState then
    x, y = radarPos[1], radarPos[2]
    sx, sy = radarSize[1], radarSize[2]
  end
  drawGPSInstructions(x, y, sx, sy, base, true)
end
local gpsInstructionHandled = false
local gpsHandled = false
function processGPSWidget()
  local tmp = not (radarWidgetState or gpsWidgetState) or gpsAlive or pathfindingAlive or prePathfindingAlive
  if tmp ~= gpsInstructionHandled then
    gpsInstructionHandled = tmp
    if gpsInstructionHandled then
      addEventHandler("onClientRender", getRootElement(), renderGPSInstructions, true, "low-1")
    else
      removeEventHandler("onClientRender", getRootElement(), renderGPSInstructions)
    end
  end
  local tmp = gpsAlive or pathfindingAlive
  if gpsHandled ~= tmp then
    gpsHandled = tmp
    if gpsHandled then
      addEventHandler("onClientPreRender", getRootElement(), preRenderGPS)
    else
      removeEventHandler("onClientPreRender", getRootElement(), preRenderGPS)
    end
  end
end
addEvent("hudWidgetState:radar", true)
addEventHandler("hudWidgetState:radar", getRootElement(), function(state)
  if radarWidgetState ~= state then
    radarWidgetState = state
    processGPSWidget()
  end
end)
addEvent("hudWidgetPosition:radar", true)
addEventHandler("hudWidgetPosition:radar", getRootElement(), function(pos, final)
  radarPos = pos
end)
addEvent("hudWidgetSize:radar", true)
addEventHandler("hudWidgetSize:radar", getRootElement(), function(size, final)
  radarSize = size
end)
addEvent("hudWidgetState:gps", true)
addEventHandler("hudWidgetState:gps", getRootElement(), function(state)
  if gpsWidgetState ~= state then
    gpsWidgetState = state
    processGPSWidget()
  end
end)
addEvent("hudWidgetPosition:gps", true)
addEventHandler("hudWidgetPosition:gps", getRootElement(), function(pos, final)
  gpsWidgetPos = pos
end)
addEvent("hudWidgetSize:gps", true)
addEventHandler("hudWidgetSize:gps", getRootElement(), function(size, final)
  gpsWidgetSize = size
end)
triggerEvent("requestWidgetDatas", localPlayer, "radar")
triggerEvent("requestWidgetDatas", localPlayer, "gps")
function preRenderGPS(delta)
  local px, py, pz = getElementPosition(localPlayer)
  if pathfindingAlive then
    for i = 1, math.max(1, math.ceil(1 / delta * 100)) do
      pathLoop()
    end
  end
  if veh ~= getPedOccupiedVehicle(localPlayer) then
    exitGPSVehicle()
    return
  end
  if not pathfindingAlive then
    laneIn = 0
    local vx, vy, vz = getElementPosition(veh)
    local minDist = false
    minPerc = false
    local minAng = false
    if routeDone[1] and routeDone[2] then
      for l = 0, #routeDone[1] do
        local l2 = math.min(l, #routeDone[2])
        if 0 >= routeDone[1][l][5] then
          minPerc = -1
          break
        end
        local dp, x, y = pDistance(vx, vy, routeDone[2][l2][1], routeDone[2][l2][2], routeDone[1][l][1], routeDone[1][l][2])
        local d = getDistanceBetweenPoints2D(vx, vy, x, y)
        if not minDist or minDist > d then
          minDist = d
          minPerc = dp
          laneIn = l
          minAng = math.atan2(routeDone[2][l2][2] - routeDone[1][l][2], routeDone[2][l2][1] - routeDone[1][l][1]) + math.pi / 2 * 3
        end
      end
      if minPerc < 0 then
        table.remove(routeDone, 1)
        minPerc = 1
        seexports.rl_radar:forceRadarToRender()
      end
      if #routeDone < 3 then
        playSingleGPSSound("finish")
        resetPathfinding()
        setElementData(veh, "gpsTarget", nil)
        minPerc = false
      end
    end
    if minPerc and (0 < getElementDimension(veh) or 0 < getElementInterior(veh)) then
      playSingleGPSSound("nincskapcs")
      resetPathfinding()
      setElementData(veh, "gpsTarget", nil)
      minPerc = false
    end
    if minPerc then
      local now = getTickCount()
      if minDist and minDist > reRouteDistance then
        prePathfindingAlive = true
        if 15000 < now - lastReRoute then
          local node = findNearestNodeToVeh(veh)
          if node then
            playSingleGPSSound("dong")
            initPathfinding(node, targetNode)
            seexports.rl_radar:forceRadarToRender()
            lastReRoute = now
            return
          end
        end
      else
        prePathfindingAlive = false
      end
      local rx, ry, rz = getElementRotation(veh)
      local a = ((minAng or 0) - math.rad(rz) + math.pi) % (math.pi * 2) - math.pi
      local tmp = math.abs(a) > math.pi * 0.75
      if tmp ~= turnAround then
        turnAround = tmp
        if tmp then
          if 1000 < now - lastTurnaround then
            playSingleGPSSound("forduljvissza")
          end
        else
          soundCallout = false
        end
        lastTurnaround = now
      end
      minPerc = math.min(1, minPerc)
      local lane = math.min(laneIn, #routeDone[2])
      nextDist = getDistanceBetweenPoints2D(routeDone[2][lane][1], routeDone[2][lane][2], vx, vy)
      local found = false
      nextSignData = false
      for i = 2, #routeDone - 1 do
        local l1 = math.min(#routeDone[i], lane)
        lane = math.min(#routeDone[i + 1], l1)
        if not found then
          nextDist = nextDist + routeDone[i][l1][6]
          if routeDone[i + 1][lane][7] then
            found = routeDone[i + 1][lane][7]
          end
        elseif routeDone[i + 1][lane][7] then
          nextSignData = routeDone[i + 1][lane][7]
          break
        end
      end
      if found and currentSign ~= found[9] then
        lastSignData = currentSignData
        currentSignData = {
          found[6],
          found[7],
          found[8]
        }
        currentSign = found[9]
        if lastSignData then
          signSwitchTime = now
        end
        closeCallout = false
        soundCallout = false
      end
      if soundPack and not found[10] then
        if nextDist <= 40 then
          if not closeCallout then
            closeCallout = true
            playSingleGPSSound(found[8] and "balra" or "jobbra")
          end
        elseif not soundCallout then
          for i = 1, #soundPackDistances[soundPack] do
            if nextDist <= soundPackDistances[soundPack][i] and nextDist >= soundPackDistances[soundPack][i] - 50 then
              soundQueue = {
                "ding",
                "menj",
                soundPackDistances[soundPack][i],
                "metert",
                "majd",
                found[8] and "balra" or "jobbra"
              }
              soundCallout = true
              playSoundQueue()
              break
            end
          end
        end
      end
      lane = laneIn
      local td = {}
      for i = 1, #routeDone do
        lane = math.min(#routeDone[i], lane)
        td[i] = getDistanceBetweenPoints2D(routeDone[i][lane][1], routeDone[i][lane][2], vx, vy)
        if td[i] < 250 and not routeDone[i][lane][4] then
          local hit, hx, hy, hz = processLineOfSight(routeDone[i][lane][1], routeDone[i][lane][2], routeDone[i][lane][3] + 3, routeDone[i][lane][1], routeDone[i][lane][2], routeDone[i][lane][3] - 3, true, false, false, true, false)
          if hit then
            routeDone[i][lane][4] = hz
          end
        end
      end
      local lane = laneIn
      local l = math.min(#routeDone[1], lane)
      lane = math.min(#routeDone[2], lane)
      drawRoadArrowsPercentage(routeDone[1][l][1], routeDone[1][l][2], (routeDone[1][l][4] or routeDone[1][l][3]) + 0.3, routeDone[2][lane][1], routeDone[2][lane][2], (routeDone[2][lane][4] or routeDone[2][lane][3]) + 0.3, minPerc)
      for i = 3, #routeDone do
        local l = math.min(#routeDone[i - 1], lane)
        lane = math.min(#routeDone[i], lane)
        local d = td[i]
        local a = 0
        if d < 250 then
          if 200 < d then
            a = 1 - (d - 200) / 50
          else
            a = 1
          end
        end
        if 0 < a then
          if routeDone[i - 1][l][4] and routeDone[i][lane][4] then
            drawRoadArrows(routeDone[i - 1][l][1], routeDone[i - 1][l][2], routeDone[i - 1][l][4] + 0.3, routeDone[i][lane][1], routeDone[i][lane][2], routeDone[i][lane][4] + 0.3, a)
          end
          if routeDone[i][lane][7] then
            drawGPSSign(routeDone[i][lane][7][1], routeDone[i][lane][7][2], routeDone[i][lane][7][3], routeDone[i][lane][7][4], routeDone[i][lane][7][5], routeDone[i][lane][7][6], routeDone[i][lane][7][7], routeDone[i][lane][7][8], a)
          end
        end
      end
    end
  end
end
function convertRadarCoords(x, y, cx, cy, opx, opy, zoom, sin, cos)
  local pointX = x - opx
  local pointY = opy - y
  pointX = pointX / 6000 * 3072 * zoom
  pointY = pointY / 6000 * 3072 * zoom
  if sin then
    local x, y = pointX, pointY
    pointX = x * cos - y * sin
    pointY = x * sin + y * cos
  end
  return cx + pointX, cy + pointY
end
function convertMapCoords(x, y, idX, idY, radarTS)
  x = x - (idX - 1) * 500
  y = -y - (idY - 1) * 500
  x = (x + 3000) / 6000 * 12 * radarTS
  y = (y + 3000) / 6000 * 12 * radarTS
  return x, y
end
function drawMapRoute(idX, idY, nx, ny, radarTS)
  if minPerc and gpsAlive then
    local lane = laneIn
    local s = 14 * radarTS / 256
    local n = #routeDone
    for i = 3, n do
      local l = math.min(#routeDone[i - 1], lane)
      lane = math.min(#routeDone[i], lane)
      local fx, fy = convertMapCoords(routeDone[i - 1][l][1], routeDone[i - 1][l][2], idX, idY, radarTS)
      local tx, ty = convertMapCoords(routeDone[i][lane][1], routeDone[i][lane][2], idX, idY, radarTS)
      if (0 <= fx or 0 <= fy or 0 <= tx or 0 <= ty) and (fx <= nx * radarTS or fy <= ny * radarTS or tx <= nx * radarTS or ty <= ny * radarTS) then
        dxDrawLine(fx, fy, tx, ty, linec, s)
        seelangStaticImageUsed[2] = true
        if seelangStaticImageToc[2] then
          processSeelangStaticImage[2]()
        end
        dxDrawImage(tx - s / 2, ty - s / 2, s, s, seelangStaticImage[2], 0, 0, 0, linec)
      end
    end
    return true
  elseif pathfindingAlive or prePathfindingAlive then
    return true
  end
end
function drawRadioRoute(c, rs, opx, opy, zoom, sin, cos, linec)
  if pathfindingAlive or prePathfindingAlive then
    return true
  elseif gpsAlive then
    local lane = laneIn
    local s = zoom * 14
    local l = math.min(#routeDone[1], lane)
    lane = math.min(#routeDone[2], lane)
    local fx, fy = routeDone[1][l][1], routeDone[1][l][2]
    local tx, ty = routeDone[2][lane][1], routeDone[2][lane][2]
    fx = fx - tx
    fy = fy - ty
    fx, fy = tx + fx * minPerc, ty + fy * minPerc
    fx, fy = convertRadarCoords(fx, fy, c, c, opx, opy, zoom, sin, cos)
    tx, ty = convertRadarCoords(tx, ty, c, c, opx, opy, zoom, sin, cos)
    dxDrawLine(fx, fy, tx, ty, linec, s)
    seelangStaticImageUsed[2] = true
    if seelangStaticImageToc[2] then
      processSeelangStaticImage[2]()
    end
    dxDrawImage(tx - s / 2, ty - s / 2, s, s, seelangStaticImage[2], 0, 0, 0, linec)
    local n = #routeDone
    local ltx, lty
    for i = 3, #routeDone do
      local l = math.min(#routeDone[i - 1], lane)
      lane = math.min(#routeDone[i], lane)
      local fx, fy = convertRadarCoords(routeDone[i - 1][l][1], routeDone[i - 1][l][2], c, c, opx, opy, zoom, sin, cos)
      local tx, ty = convertRadarCoords(routeDone[i][lane][1], routeDone[i][lane][2], c, c, opx, opy, zoom, sin, cos)
      if (0 <= fx or 0 <= fy or 0 <= tx or 0 <= ty) and (rs >= fx or rs >= fy or rs >= tx or rs >= ty) then
        dxDrawLine(fx, fy, tx, ty, linec, s)
        seelangStaticImageUsed[2] = true
        if seelangStaticImageToc[2] then
          processSeelangStaticImage[2]()
        end
        dxDrawImage(tx - s / 2, ty - s / 2, s, s, seelangStaticImage[2], 0, 0, 0, linec)
      end
      ltx, lty = tx, ty
    end
    local i = #routeDone
    local s = zoom * 24
    seelangStaticImageUsed[1] = true
    if seelangStaticImageToc[1] then
      processSeelangStaticImage[1]()
    end
    dxDrawImageSection(ltx - s, lty - s, s * 2, s * 2, 0, 0, 256, 256, seelangStaticImage[1], 0, 0, 0, linec)
    return true
  end
end
function drawSmallRadarRoute(c, rs, opx, opy, zoom, sin, cos)
  if minPerc and routeDone and 3 <= #routeDone and gpsAlive then
    local lane = laneIn
    local s = zoom * 14
    local l = math.min(#routeDone[1], lane)
    lane = math.min(#routeDone[2], lane)
    local fx, fy = routeDone[1][l][1], routeDone[1][l][2]
    local tx, ty = routeDone[2][lane][1], routeDone[2][lane][2]
    fx = fx - tx
    fy = fy - ty
    fx, fy = tx + fx * minPerc, ty + fy * minPerc
    fx, fy = convertRadarCoords(fx, fy, c, c, opx, opy, zoom, sin, cos)
    tx, ty = convertRadarCoords(tx, ty, c, c, opx, opy, zoom, sin, cos)
    dxDrawLine(fx, fy, tx, ty, linec, s)
    seelangStaticImageUsed[2] = true
    if seelangStaticImageToc[2] then
      processSeelangStaticImage[2]()
    end
    dxDrawImage(tx - s / 2, ty - s / 2, s, s, seelangStaticImage[2], 0, 0, 0, linec)
    local n = #routeDone
    local ltx, lty
    for i = 3, n do
      lane = math.min(#routeDone[i], lane)
      if i == n then
        ltx, lty = convertRadarCoords(routeDone[i][lane][1], routeDone[i][lane][2], c, c, opx, opy, zoom, sin, cos)
      end
    end
    local i = #routeDone
    local s = zoom * 24
    seelangStaticImageUsed[1] = true
    if seelangStaticImageToc[1] then
      processSeelangStaticImage[1]()
    end
    dxDrawImageSection(ltx - s, lty - s, s * 2, s * 2, 0, 0, 256, 256, seelangStaticImage[1], 0, 0, 0, linec)
  end
end
function lineDistance(x, y, x1, y1, x2, y2)
  local A = x - x1
  local B = y - y1
  local C = x2 - x1
  local D = y2 - y1
  local dot = A * C + B * D
  local len_sq = C * C + D * D
  local param = -1
  if len_sq ~= 0 then
    param = dot / len_sq
  end
  if 0 <= param and param <= 1 then
    return math.sqrt(math.pow(x - (x1 + param * C), 2) + math.pow(y - (y1 + param * D), 2))
  end
  return math.huge
end
function drawBigRadar(cx, cy, sx, sy, opx, opy, zoom, cursorX, cursorY)
  if pathfindingAlive or prePathfindingAlive then
    local s = math.max(16, math.floor(24 * zoom))
    local sx, sy = convertRadarCoords(targetX, targetY, cx, cy, opx, opy, zoom)
    seelangStaticImageUsed[1] = true
    if seelangStaticImageToc[1] then
      processSeelangStaticImage[1]()
    end
    dxDrawImageSection(sx - s, sy - s, s * 2, s * 2, 256, 0, 256, 256, seelangStaticImage[1])
    seelangStaticImageUsed[1] = true
    if seelangStaticImageToc[1] then
      processSeelangStaticImage[1]()
    end
    dxDrawImageSection(sx - s, sy - s, s * 2, s * 2, 0, 0, 256, 256, seelangStaticImage[1], 0, 0, 0, linec)
    local r = getTickCount() / 5 % 360
    seelangStaticImageUsed[1] = true
    if seelangStaticImageToc[1] then
      processSeelangStaticImage[1]()
    end
    dxDrawImageSection(sx - s, sy - s, s * 2, s * 2, 256, 256, 256, 256, seelangStaticImage[1], r)
    if cursorX and s > math.sqrt(math.pow(cursorX - sx, 2) + math.pow(cursorY - sy, 2)) then
      return true
    end
  elseif minPerc and gpsAlive then
    local lane = laneIn
    local s = zoom * 14
    local l = math.min(#routeDone[1], lane)
    lane = math.min(#routeDone[2], lane)
    local fx, fy = routeDone[1][l][1], routeDone[1][l][2]
    local tx, ty = routeDone[2][lane][1], routeDone[2][lane][2]
    fx = fx - tx
    fy = fy - ty
    fx, fy = tx + fx * minPerc, ty + fy * minPerc
    fx, fy = convertRadarCoords(fx, fy, cx, cy, opx, opy, zoom)
    tx, ty = convertRadarCoords(tx, ty, cx, cy, opx, opy, zoom)
    dxDrawLine(fx, fy, tx, ty, linec, s)
    seelangStaticImageUsed[2] = true
    if seelangStaticImageToc[2] then
      processSeelangStaticImage[2]()
    end
    dxDrawImage(tx - s / 2, ty - s / 2, s, s, seelangStaticImage[2], 0, 0, 0, linec)
    local hover = cursorX and lineDistance(cursorX, cursorY, fx, fy, tx, ty) <= s / 2
    lane = laneIn
    local s = math.max(16, math.floor(24 * zoom))
    for i = 1, #routeDone do
      lane = math.min(#routeDone[i], lane)
      if routeDone[i][lane][7] then
        local sx, sy = convertRadarCoords(routeDone[i][lane][7][1], routeDone[i][lane][7][2], cx, cy, opx, opy, zoom)
        local inv = routeDone[i][lane][7][8]
        seelangStaticImageUsed[1] = true
        if seelangStaticImageToc[1] then
          processSeelangStaticImage[1]()
        end
        dxDrawImageSection(sx - s, sy - s, s * 2, s * 2, 256, 0, 256, 256, seelangStaticImage[1])
        seelangStaticImageUsed[1] = true
        if seelangStaticImageToc[1] then
          processSeelangStaticImage[1]()
        end
        dxDrawImageSection(sx - s, sy - s, s * 2, s * 2, 0, 0, 256, 256, seelangStaticImage[1], 0, 0, 0, linec)
        seelangStaticImageUsed[1] = true
        if seelangStaticImageToc[1] then
          processSeelangStaticImage[1]()
        end
        dxDrawImageSection(sx - s, sy - s, s * 2, s * 2, routeDone[i][lane][7][6] + (inv and 256 or 0), routeDone[i][lane][7][7], inv and -256 or 256, 256, seelangStaticImage[1])
        if not hover and cursorX and s > math.sqrt(math.pow(cursorX - sx, 2) + math.pow(cursorY - sy, 2)) then
          hover = true
        end
      end
    end
    if not hover and cursorX then
      for i = 3, #routeDone do
        local l = math.min(#routeDone[i - 1], lane)
        lane = math.min(#routeDone[i], lane)
        local fx, fy = convertRadarCoords(routeDone[i - 1][l][1], routeDone[i - 1][l][2], cx, cy, opx, opy, zoom)
        local tx, ty = convertRadarCoords(routeDone[i][lane][1], routeDone[i][lane][2], cx, cy, opx, opy, zoom)
        if (0 <= fx or 0 <= fy or 0 <= tx or 0 <= ty) and (sx >= fx or sy >= fy or sx >= tx or sy >= ty) and lineDistance(cursorX, cursorY, fx, fy, tx, ty) <= s / 2 then
          hover = true
          break
        end
      end
    end
    return hover
  end
end
local pv = getPedOccupiedVehicle(localPlayer)
if pv then
  local vt = getVehicleType(pv)
  if vt == "Automobile" or vt == "Quad" or vt == "Bike" then
    enterVeh(pv)
  end
end
