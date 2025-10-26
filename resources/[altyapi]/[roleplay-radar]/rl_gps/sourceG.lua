nodeIndexes = {}
reRouteDistance = 60
for i = 1, #newNodes do
  local node = newNodes[i]
  if node then
    local x, y = node.x, node.y
    x = math.floor(x / reRouteDistance)
    y = math.floor(y / reRouteDistance)
    if not nodeIndexes[x] then
      nodeIndexes[x] = {}
    end
    if not nodeIndexes[x][y] then
      nodeIndexes[x][y] = {}
    end
    table.insert(nodeIndexes[x][y], i)
  end
end
function findNearestNodeToCoord(px, py)
  local mind = false
  local minNode = false
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
              local d = getDistanceBetweenPoints2D(px, py, node.x, node.y)
              if not mind or mind > d then
                mind = d
                minNode = i
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
        local d = getDistanceBetweenPoints2D(px, py, node.x, node.y)
        if not mind or mind > d then
          mind = d
          minNode = i
        end
      end
    end
  end
  return minNode
end
function getNodeCoord(i)
  if newNodes[i] then
    return newNodes[i].x, newNodes[i].y, newNodes[i].z
  end
end
