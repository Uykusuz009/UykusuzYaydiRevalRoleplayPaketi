newsTitle, newsDate, newsBadge, newsImageHash = "", "", {}, false
addEvent("extraLoadStart:loadingNews", false)
addEventHandler("extraLoadStart:loadingNews", getRootElement(), function()
  --triggerLatentServerEvent("requestNewsData", localPlayer)
end)
function loadedNews()
  backgroundSizes["news/latest.dds"] = nil
  local i, j = unpack(newsPosition)
  --dashboardLayout[i][j].background = "news/latest.dds"
  setTimer(triggerEvent, 250, 1, "extraLoaderDone", localPlayer, "loadingNews")
end
addEvent("gotNewsImage", true)
addEventHandler("gotNewsImage", getRootElement(), function(data)
  if fileExists("news/latest.dds") then
    fileDelete("news/latest.dds")
  end
  local file = fileCreate("news/latest.dds")
  if file then
    fileWrite(file, data)
    fileClose(file)
  end
  loadedNews()
end)
addEvent("gotNewsData", true)
addEventHandler("gotNewsData", getRootElement(), function(title, date, badge, hash)
  newsTitle = title
  newsDate = date
  newsBadge = badge
  if fileExists("news/latest.dds") then
    local file = fileOpen("news/latest.dds")
    if file then
      local data = fileRead(file, fileGetSize(file))
      fileClose(file)
      if utf8.lower(sha256(data)) == utf8.lower(hash) then
        loadedNews()
      else
      --  triggerLatentServerEvent("requestNewsImage", localPlayer)
      end
      data = nil
      collectgarbage("collect")
    else
 --     triggerLatentServerEvent("requestNewsImage", localPlayer)
    end
  else
  --  triggerLatentServerEvent("requestNewsImage", localPlayer)
  end
end)
addEventHandler("onClientResourceStart", getResourceRootElement(), function()
  if getElementData(localPlayer, "logged") then
  -- triggerLatentServerEvent("requestNewsData", localPlayer)
  end
end)
