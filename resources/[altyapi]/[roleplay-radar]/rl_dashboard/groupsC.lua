local seexports = {
  rl_gui = false,
  rl_interiors = false,
  rl_gates = false,
  rl_vehiclenames = false,
  rl_groups = false,
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
local rtg = false
local sx, sy = 0, 0
local inside = false
local menuW = 0
groupModal = false
local groupFonts = {
  "13/BebasNeueBold.otf",
  "16/BebasNeueRegular.otf",
  "22/BebasNeueRegular.otf",
  "14/BebasNeueBold.otf",
  "14/BebasNeueRegular.otf",
  "11/Ubuntu-R.ttf"
}
local groupLoader = false
local groupLoaderIcon = false
addEvent("markGroupVehicle", true)
addEventHandler("markGroupVehicle", getRootElement(), function(button, state, absoluteX, absoluteY, el, id)
  triggerServerEvent("markVehicleOnGPS", localPlayer, id)
end)
function deleteGroupLoader()
  if groupLoader then
    seexports.rl_gui:deleteGuiElement(groupLoader)
  end
  groupLoader = false
  groupLoaderIcon = false
end
function createGroupLoader()
  deleteGroupLoader()
  if groupModal then
    seexports.rl_gui:deleteGuiElement(groupModal)
  end
  groupModal = false
  groupLoader = seexports.rl_gui:createGuiElement("rectangle", 0, 0, sx, sy, rtg)
  seexports.rl_gui:setGuiBackground(groupLoader, "solid", {
    0,
    0,
    0,
    150
  })
  seexports.rl_gui:setGuiHover(groupLoader, "none", false, false, true)
  seexports.rl_gui:setGuiHoverable(groupLoader, true)
  seexports.rl_gui:disableClickTrough(groupLoader, true)
  seexports.rl_gui:disableLinkCursor(groupLoader, true)
  groupLoaderIcon = seexports.rl_gui:createGuiElement("image", sx / 2 - 32, sy / 2 - 32, 64, 64, groupLoader)
  seexports.rl_gui:setImageFile(groupLoaderIcon, seexports.rl_gui:getFaIconFilename("circle-notch", 64))
  seexports.rl_gui:setImageSpinner(groupLoaderIcon, true)
end
local sideMenu = {}
local selectedGroup = false
local groupList = {}
local groupDatas = {}
local groupPanel = false
local selectedMenu = "home"
local menuButtons = {}
local groupDescriptionInput = false
local memberElements = {}
local selectedMember = false
local memberNameLabel = false
local memberFireButton = false
local memberRankLabel = false
local memberRankEdit = false
local memberSalaryLabel = false
local memberLeaderLabel = false
local memberLastOnlineLabel = false
local memberAddedLabel = false
local memberPromotedLabel = false
local perMemberPermissions = {}
local memberPermissionsData = {}
local newMemberInput = false
local groupBalanceInput = false
local newMemberList = {}
local rankCheckboxes = {}
local rankElements = {}
local perRankPermission = {}
local rankPermissionsData = {}
local selectedRank = 1
local rankNumLabel = false
local rankNameLabel = false
local rankSalaryLabel = false
local rankPermissionEdit = false
local rankPermissionEditButton = false
local rankEditButton = false
local rankDeleteButton = false
local rankUpButton = false
local rankDownButton = false
local rankNameInput = false
local rankSalaryInput = false
local rankEditColor = false
local rankEditColorElements = {}
local groupInteriors = {}
local groupGates = {}
local vehicleElements = {}
local selectedVehicle = false
local vehicleNameLabel = false
local vehiclePlateLabel = false
local vehicleSidePanel = false
local vehicleDataBg = false
local vehicleMemberElements = {}
local vehicleMemberList = {}
local vehicleMemberEditButton = false
local vehicleMemberEditing = false
local vehicleMemberButton = false
local vehicleDataButton = false
local interiorElements = {}
local interiorMemberEditButton = false
local interiorNameLabel = false
local interiorTypeLabel = false
local interiorSidePanel = false
local interiorMemberButton = false
local interiorDataButton = false
local selectedInterior = false
local interiorDataBg = false
local interiorMemberEditing = false
local interiorMemberElements = {}
local interiorMemberList = {}
local selectedGate = false
local gateMemberEditing = false
local gatesMembersList = {}
local gateNameLabel = false
local gatePermissionEditButton = false
local gatesElements = {}
local gatesMemberElements = {}
local gatesMemberBg = false
local gatesMemberScrollBar = false
local gatesMemberScroll = 0
local gatesBg = false
local gatesScrollBar = false
local gatesScroll = 0
local interiorMemberBg = false
local interiorMemberScrollBar = false
local interiorMemberScroll = 0
local interiorsBg = false
local interiorsScrollBar = false
local interiorsScroll = 0
local rankBg = false
local rankPermBg = false
local rankScrollbar = false
local rankPermScrollbar = false
local rankScroll = 0
local rankPermScroll = 0
local memberBg = false
local perMemberBg = false
local memberScroll = 0
local perMemberScroll = 0
local memberScrollBar = false
local perMemberScrollBar = false
local vehiclesBg = false
local vehicleMemberBg = false
local vehiclesScroll = 0
local vehicleMemberScroll = 0
local vehiclesScrollBar = false
local vehicleMemberScrollBar = false
function groupPanelScrollKey(key)
  local cx, cy = getCursorPosition()
  if cx then
    cx = cx * screenX
    cy = cy * screenY
    if selectedMenu == "gates" and gatesBg and gatesMemberBg then
      local x, y = seexports.rl_gui:getGuiRealPosition(gatesBg)
      local w, h = seexports.rl_gui:getGuiSize(gatesBg)
      if cx >= x and cy >= y and cx <= x + w and cy <= y + h then
        if key == "mouse_wheel_down" then
          local n = math.max(0, #groupGates - #gatesElements)
          if n > gatesScroll then
            gatesScroll = gatesScroll + 1
            processGroupGates()
          end
        elseif key == "mouse_wheel_up" and 0 < gatesScroll then
          gatesScroll = gatesScroll - 1
          processGroupGates()
        end
        return
      end
      if not seexports.rl_gui:isGuiRenderDisabled(gatesMemberBg) then
        local x, y = seexports.rl_gui:getGuiRealPosition(gatesMemberBg)
        local w, h = seexports.rl_gui:getGuiSize(gatesMemberBg)
        if cx >= x and cy >= y and cx <= x + w and cy <= y + h then
          if key == "mouse_wheel_down" then
            local n = math.max(0, #gatesMembersList - #gatesMemberElements)
            if n > gatesMemberScroll then
              gatesMemberScroll = gatesMemberScroll + 1
              processGroupGatesMemberList()
            end
          elseif key == "mouse_wheel_up" and 0 < gatesMemberScroll then
            gatesMemberScroll = gatesMemberScroll - 1
            processGroupGatesMemberList()
          end
          return
        end
      end
    elseif selectedMenu == "interiors" and interiorsBg and interiorMemberBg then
      local x, y = seexports.rl_gui:getGuiRealPosition(interiorsBg)
      local w, h = seexports.rl_gui:getGuiSize(interiorsBg)
      if cx >= x and cy >= y and cx <= x + w and cy <= y + h then
        if key == "mouse_wheel_down" then
          local n = math.max(0, #groupInteriors - #interiorElements)
          if n > interiorsScroll then
            interiorsScroll = interiorsScroll + 1
            processGroupInteriorList()
          end
        elseif key == "mouse_wheel_up" and 0 < interiorsScroll then
          interiorsScroll = interiorsScroll - 1
          processGroupInteriorList()
        end
        return
      end
      if not seexports.rl_gui:isGuiRenderDisabled(interiorMemberBg) then
        local x, y = seexports.rl_gui:getGuiRealPosition(interiorMemberBg)
        local w, h = seexports.rl_gui:getGuiSize(interiorMemberBg)
        if cx >= x and cy >= y and cx <= x + w and cy <= y + h then
          if key == "mouse_wheel_down" then
            local n = math.max(0, #interiorMemberList - #interiorMemberElements)
            if n > interiorMemberScroll then
              interiorMemberScroll = interiorMemberScroll + 1
              processGroupInteriorMemberList()
            end
          elseif key == "mouse_wheel_up" and 0 < interiorMemberScroll then
            interiorMemberScroll = interiorMemberScroll - 1
            processGroupInteriorMemberList()
          end
          return
        end
      end
    elseif selectedMenu == "vehicles" and vehiclesBg and vehicleMemberBg then
      local x, y = seexports.rl_gui:getGuiRealPosition(vehiclesBg)
      local w, h = seexports.rl_gui:getGuiSize(vehiclesBg)
      if cx >= x and cy >= y and cx <= x + w and cy <= y + h then
        if key == "mouse_wheel_down" then
          local n = math.max(0, #groupDatas[selectedGroup].vehicles - #vehicleElements)
          if n > vehiclesScroll then
            vehiclesScroll = vehiclesScroll + 1
            processGroupVehicleList()
          end
        elseif key == "mouse_wheel_up" and 0 < vehiclesScroll then
          vehiclesScroll = vehiclesScroll - 1
          processGroupVehicleList()
        end
        return
      end
      if not seexports.rl_gui:isGuiRenderDisabled(vehicleMemberBg) then
        local x, y = seexports.rl_gui:getGuiRealPosition(vehicleMemberBg)
        local w, h = seexports.rl_gui:getGuiSize(vehicleMemberBg)
        if cx >= x and cy >= y and cx <= x + w and cy <= y + h then
          if key == "mouse_wheel_down" then
            local n = math.max(0, #vehicleMemberList - #vehicleMemberElements)
            if n > vehicleMemberScroll then
              vehicleMemberScroll = vehicleMemberScroll + 1
              processGroupVehicleMemberList()
            end
          elseif key == "mouse_wheel_up" and 0 < vehicleMemberScroll then
            vehicleMemberScroll = vehicleMemberScroll - 1
            processGroupVehicleMemberList()
          end
          return
        end
      end
    elseif selectedMenu == "members" and perMemberBg and memberBg then
      local x, y = seexports.rl_gui:getGuiRealPosition(perMemberBg)
      local w, h = seexports.rl_gui:getGuiSize(perMemberBg)
      if cx >= x and cy >= y and cx <= x + w and cy <= y + h then
        if key == "mouse_wheel_down" then
          local n = math.max(0, #memberPermissionsData - #perMemberPermissions)
          if n > perMemberScroll then
            perMemberScroll = perMemberScroll + 1
            processSelectedMemberPermissionList()
          end
        elseif key == "mouse_wheel_up" and 0 < perMemberScroll then
          perMemberScroll = perMemberScroll - 1
          processSelectedMemberPermissionList()
        end
        return
      end
      local x, y = seexports.rl_gui:getGuiRealPosition(memberBg)
      local w, h = seexports.rl_gui:getGuiSize(memberBg)
      if cx >= x and cy >= y and cx <= x + w and cy <= y + h then
        if key == "mouse_wheel_down" then
          local n = math.max(0, #groupDatas[selectedGroup].members - #memberElements)
          if n > memberScroll then
            memberScroll = memberScroll + 1
            refreshGroupMemberList()
          end
        elseif key == "mouse_wheel_up" and 0 < memberScroll then
          memberScroll = memberScroll - 1
          refreshGroupMemberList()
        end
        return
      end
    elseif selectedMenu == "ranks" and rankBg and rankPermBg then
      local x, y = seexports.rl_gui:getGuiRealPosition(rankBg)
      local w, h = seexports.rl_gui:getGuiSize(rankBg)
      if cx >= x and cy >= y and cx <= x + w and cy <= y + h then
        if key == "mouse_wheel_down" then
          local n = math.max(0, #groupDatas[selectedGroup].ranks - #rankElements)
          if n > rankScroll then
            rankScroll = rankScroll + 1
            processRanksList()
          end
        elseif key == "mouse_wheel_up" and 0 < rankScroll then
          rankScroll = rankScroll - 1
          processRanksList()
        end
        return
      end
      local x, y = seexports.rl_gui:getGuiRealPosition(rankPermBg)
      local w, h = seexports.rl_gui:getGuiSize(rankPermBg)
      if cx >= x and cy >= y and cx <= x + w and cy <= y + h then
        if key == "mouse_wheel_down" then
          local n = math.max(0, #rankPermissionsData - #perRankPermission)
          if n > rankPermScroll then
            rankPermScroll = rankPermScroll + 1
            processPerRankpermissionList()
          end
        elseif key == "mouse_wheel_up" and 0 < rankPermScroll then
          rankPermScroll = rankPermScroll - 1
          processPerRankpermissionList()
        end
        return
      end
    end
  end
end
function requestSelectedGroup()
  if selectedGroup then
    groupDatas[selectedGroup] = nil
    --print(selectedGroup)
    triggerLatentServerEvent("requestPlayerGroupData", localPlayer, selectedGroup)
  end
end
function groupMemberSort(a, b)
  if a[2] == b[2] then
    if a[6] and b[6] then
      return a[6] > b[6]
    else
      return a[2] > b[2]
    end
  else
    return a[2] < b[2]
  end
end
function groupVehicleMemberSort(a, b)
  if a[4] == b[4] then
    if a[3] == b[3] then
      return a[2] < b[2]
    else
      return a[3] < b[3]
    end
  else
    return (a[4] and 1 or 0) > (b[4] and 1 or 0)
  end
end
function groupVehicleMemberSortEx(a, b)
  if a[3] == b[3] then
    return a[2] < b[2]
  else
    return a[3] < b[3]
  end
end
function groupVehicleSort(a, b)
  if a[2] == b[2] then
    return a[3] < b[3]
  else
    return a[2] < b[2]
  end
end
function groupInteriorSort(a, b)
  if a[3] == b[3] then
    return a[2] < b[2]
  else
    return a[3] < b[3]
  end
end
function processGroupInteriors()
  groupInteriors = {}
  local list = seexports.rl_interiors:getGroupInteriors(selectedGroup)
  for i = 1, #list do
    table.insert(groupInteriors, {
      list[i],
      seexports.rl_interiors:getInteriorName(list[i]),
      seexports.rl_interiors:getInteriorTypeName(seexports.rl_interiors:getInteriorType(list[i]))
    })
  end
  table.sort(groupInteriors, groupInteriorSort)
end
function processGroupGates()
  groupGates = {}
  local list = seexports.rl_gates:getGroupGates(selectedGroup)
  for i = 1, #list do
    table.insert(groupGates, list[i])
  end
  table.sort(groupGates)
end
function processGotVehicles(prefix)
  groupDatas[prefix].vehicles = {}
  for vid, dat in pairs(groupDatas[prefix].gotVehicles) do
    local plate = dat[2] or ""
    local tmp = {}
    plate = split(plate, "-")
    for i = 1, #plate do
      if 1 <= utf8.len(plate[i]) then
        table.insert(tmp, plate[i])
      end
    end
    table.insert(groupDatas[prefix].vehicles, {
      vid,
      seexports.rl_vehiclenames:getCustomVehicleName(dat[1]),
      table.concat(tmp, "-"),
      dat[3]
    })
  end
  --table.sort(groupDatas[selectedGroup].vehicles, groupVehicleSort)
end
function processGotMembers(prefix)
  groupDatas[prefix].members = {}
  for mid, dat in pairs(groupDatas[prefix].gotMembers) do
    table.insert(groupDatas[prefix].members, {
      dat[1],
      dat[2],
      dat[3],
      dat[4],
      dat[5],
      dat[6],
      mid
    })
  end
  table.sort(groupDatas[prefix].members, groupMemberSort)
end
addEvent("refreshPlayerGroupData", true)
addEventHandler("refreshPlayerGroupData", getRootElement(), function(prefix, data)
  if groupDatas[prefix] then
    for k, v in pairs(data) do
      groupDatas[prefix][k] = v
      if k == "gotMembers" then
        processGotMembers(prefix)
      elseif k == "gotVehicles" then
        processGotVehicles(prefix)
      end
    end
   --print(selectedGroup)
    if inside and selectedGroup == prefix then
      drawGroupPanel()
    end
  end
end)
addEvent("refreshPlayerGroupDataParamter", true)
addEventHandler("refreshPlayerGroupDataParamter", getRootElement(), function(prefix, param, data)
  if groupDatas[prefix] then
    for k, v in pairs(data) do
      if not groupDatas[prefix][k] then
        groupDatas[prefix][k] = {}
      end
      if v then
        groupDatas[prefix][k][param] = v
        --iprint(param, v)
      else
        groupDatas[prefix][k][param] = nil
      end
      if k == "gotMembers" then
        processGotMembers(prefix)
      elseif k == "gotVehicles" then
        processGotVehicles(prefix)
      end
    end
    if inside and selectedGroup == prefix then
      drawGroupPanel()
    end
  end
end)
addEvent("gotPlayerGroupData", true)
addEventHandler("gotPlayerGroupData", getRootElement(), function(prefix, data)
  groupDatas[prefix] = data
  processGotMembers(prefix)
  processGotVehicles(prefix)
  processGroupInteriors()
  processGroupGates()
  if inside and selectedGroup == prefix then
    drawGroupPanel()
  end
end)
addEvent("gotPlayerGroupList", true)
addEventHandler("gotPlayerGroupList", getRootElement(), function(list)
  groupList = list
  if inside then
    drawGroupSideMenu()
    if selectedGroup then
      for i = 1, #list do
        if list[i][1] == selectedGroup then
          requestSelectedGroup()
          createGroupLoader()
          return
        end
      end
      groupDatas[selectedGroup] = nil
      selectedGroup = false
      drawGroupPanel()
    end
  end
end)
addEvent("switchGroupPanelGroup", false)
addEventHandler("switchGroupPanelGroup", getRootElement(), function(button, state, absoluteX, absoluteY, el)
  if sideMenu[el] then
    selectedGroup = sideMenu[el]
    setTimer(requestSelectedGroup, math.random(250, 750), 1)
    selectedMenu = "home"
    processSideMenu()
    createGroupLoader()
  end
end)
addEvent("switchGroupPanelMenu", false)
addEventHandler("switchGroupPanelMenu", getRootElement(), function(button, state, absoluteX, absoluteY, el)
  if menuButtons[el] then
    selectedMenu = menuButtons[el]
    drawGroupPanel()
  end
end)
addEvent("doneGroupMOTD", false)
addEventHandler("doneGroupMOTD", getRootElement(), function(button, state, absoluteX, absoluteY, el)
  createGroupLoader()
  triggerServerEvent("editGroupMOTD", localPlayer, selectedGroup, seexports.rl_gui:getInputValue(groupDescriptionInput))
  seexports.rl_gui:setGuiRenderDisabled(groupDescriptionInput, true)
  seexports.rl_gui:setActiveInput(false)
  seexports.rl_gui:deleteGuiElement(el)
end)
addEvent("editGroupMOTD", false)
addEventHandler("editGroupMOTD", getRootElement(), function(button, state, absoluteX, absoluteY, el)
  seexports.rl_gui:setGuiRenderDisabled(groupDescriptionInput, false)
  seexports.rl_gui:setActiveInput(groupDescriptionInput)
  seexports.rl_gui:setClickEvent(el, "doneGroupMOTD")
  seexports.rl_gui:setGuiBackground(el, "solid", "v4green")
  seexports.rl_gui:setGuiHover(el, "gradient", {
    "v4green",
    "v4green-second"
  }, false, true)
  seexports.rl_gui:setButtonIcon(el, seexports.rl_gui:getFaIconFilename("check", 24))
end)
function refreshGroupMemberList()
  local w, h = seexports.rl_gui:getGuiSize(memberBg)
  local n = math.max(0, #groupDatas[selectedGroup].members - #memberElements)
  h = h / (n + 1)
  if n < memberScroll then
    memberScroll = n
  end
  seexports.rl_gui:setGuiSize(memberScrollBar, false, h)
  seexports.rl_gui:setGuiPosition(memberScrollBar, false, h * memberScroll)
  for i = 1, #memberElements do
    if groupDatas[selectedGroup].members[i + memberScroll] then
      local rect = memberElements[i][1]
      if not selectedMember then
        selectedMember = groupDatas[selectedGroup].members[i + memberScroll][7]
      end
      if selectedMember == groupDatas[selectedGroup].members[i + memberScroll][7] then
        seexports.rl_gui:setGuiHoverable(rect, false)
        seexports.rl_gui:setGuiBackground(rect, "solid", "v4grey3")
      else
        seexports.rl_gui:setGuiHoverable(rect, true)
        seexports.rl_gui:setGuiBackground(rect, "solid", "v4grey1")
      end
      local image = memberElements[i][2]
      if isElement(groupDatas[selectedGroup].members[i + memberScroll][4]) then
        seexports.rl_gui:setImageFile(image, seexports.rl_gui:getFaIconFilename("circle", 32))
        seexports.rl_gui:setImageColor(image, "v4green")
        seexports.rl_gui:guiSetTooltip(image, "Jelenleg online")
        seexports.rl_gui:guiSetTooltip(rect, "Jelenleg online")
      else
        seexports.rl_gui:setImageFile(image, seexports.rl_gui:getFaIconFilename("circle", 32, "regular"))
        seexports.rl_gui:setImageColor(image, "v4red")
        local time = getRealTime(groupDatas[selectedGroup].members[i + memberScroll][4])
        seexports.rl_gui:guiSetTooltip(rect, "Utoljára online: " .. string.format("%04d. %02d. %02d. %02d:%02d", time.year + 1900, time.month + 1, time.monthday, time.hour, time.minute))
      end
      local image = memberElements[i][3]
      seexports.rl_gui:setGuiRenderDisabled(image, not groupDatas[selectedGroup].members[i + memberScroll][3])
      local label = memberElements[i][4]
      seexports.rl_gui:setLabelText(label, groupDatas[selectedGroup].members[i + memberScroll][1])
      local w, h = seexports.rl_gui:getGuiSize(rect)
      local label = memberElements[i][5]
      if groupDatas[selectedGroup].members[i + memberScroll][3] then
        seexports.rl_gui:setGuiSize(label, w - h, false)
      else
        seexports.rl_gui:setGuiSize(label, w - dashboardPadding[3] * 2, false)
      end
      seexports.rl_gui:setLabelColor(label, "v4" .. (groupDatas[selectedGroup].rankColors[groupDatas[selectedGroup].members[i + memberScroll][2]] or "blue"))
      local rankText = (groupDatas[selectedGroup].ranks[groupDatas[selectedGroup].members[i + memberScroll][2]] or "N/A") .. " [" .. groupDatas[selectedGroup].members[i + memberScroll][2] .. "]"
      seexports.rl_gui:setLabelText(label, rankText)
    end
  end
end
addEvent("selectGroupPanelMember", false)
addEventHandler("selectGroupPanelMember", getRootElement(), function(button, state, absoluteX, absoluteY, el)
  for i = 1, #memberElements do
    if memberElements[i][1] == el and groupDatas[selectedGroup].members[i + memberScroll] then
      selectedMember = groupDatas[selectedGroup].members[i + memberScroll][7]
      refreshGroupMemberList()
      processSelectedMember()
    end
  end
end)
addEvent("closeGroupModal", false)
addEventHandler("closeGroupModal", getRootElement(), function(button, state, absoluteX, absoluteY, el)
  if groupModal then
    seexports.rl_gui:deleteGuiElement(groupModal)
  end
  groupModal = false
end)
addEvent("stopGroupLoader", true)
addEventHandler("stopGroupLoader", getRootElement(), function()
  deleteGroupLoader()
end)
addEvent("selectGroupMemberNewRank", false)
addEventHandler("selectGroupMemberNewRank", getRootElement(), function(button, state, absoluteX, absoluteY, el)
  for e, i in pairs(rankCheckboxes) do
    if e == el then
      createGroupLoader()
      triggerServerEvent("groupMemberSetRank", localPlayer, selectedGroup, selectedMember, i)
      return
    end
  end
end)
addEvent("changeGroupMemberRank", false)
addEventHandler("changeGroupMemberRank", getRootElement(), function(button, state, absoluteX, absoluteY, el)
  rankCheckboxes = {}
  if selectedMember and groupDatas[selectedGroup].gotMembers[selectedMember] then
    local data = groupDatas[selectedGroup].gotMembers[selectedMember]
    groupModal = seexports.rl_gui:createGuiElement("rectangle", 0, 0, screenX, screenY)
    seexports.rl_gui:setGuiBackground(groupModal, "solid", {
      0,
      0,
      0,
      150
    })
    seexports.rl_gui:setGuiHover(groupModal, "none")
    seexports.rl_gui:setGuiHoverable(groupModal, true)
    seexports.rl_gui:disableClickTrough(groupModal, true)
    seexports.rl_gui:disableLinkCursor(groupModal, true)
    local titlebarHeight = seexports.rl_gui:getTitleBarHeight()
    local n = #groupDatas[selectedGroup].ranks
    local panelWidth = 600
    local panelHeight = titlebarHeight + math.ceil(n / 2) * 32
    local window = seexports.rl_gui:createGuiElement("window", screenX / 2 - panelWidth / 2, -panelHeight, panelWidth, panelHeight, groupModal)
    seexports.rl_gui:setWindowTitle(window, "16/BebasNeueRegular.otf", data[1])
    seexports.rl_gui:setWindowCloseButton(window, "closeGroupModal")
    local x = 0
    local y = titlebarHeight
    local border = seexports.rl_gui:createGuiElement("hr", panelWidth / 2 - 1, y, 2, panelHeight - y, window)
    for j = 1, n do
      local rect = seexports.rl_gui:createGuiElement("rectangle", x, y, panelWidth / 2, 32, window)
      seexports.rl_gui:setGuiBackground(rect, "solid", {
        0,
        0,
        0,
        0
      })
      seexports.rl_gui:setGuiHover(rect, "none")
      local checkbox = seexports.rl_gui:createGuiElement("checkbox", x + 2, y + 2, 28, 28, window)
      seexports.rl_gui:setGuiColorScheme(checkbox, "darker")
      rankCheckboxes[checkbox] = j
      if j == data[2] then
        seexports.rl_gui:setCheckboxChecked(checkbox, true)
        seexports.rl_gui:setGuiHoverable(checkbox, false)
      else
        seexports.rl_gui:setGuiHoverable(rect, true)
        seexports.rl_gui:setGuiBoundingBox(checkbox, rect)
        seexports.rl_gui:setClickEvent(checkbox, "selectGroupMemberNewRank")
      end
      local label = seexports.rl_gui:createGuiElement("label", x + 32, y, 0, 32, window)
      seexports.rl_gui:setLabelFont(label, groupFonts[4])
      seexports.rl_gui:setLabelAlignment(label, "left", "center")
      seexports.rl_gui:setLabelColor(label, "v4" .. (groupDatas[selectedGroup].rankColors[j] or "blue"))
      seexports.rl_gui:setLabelText(label, groupDatas[selectedGroup].ranks[j] .. " [" .. j .. "]")
      local label = seexports.rl_gui:createGuiElement("label", x, y, panelWidth / 2 - dashboardPadding[3] * 2, 32, window)
      seexports.rl_gui:setLabelFont(label, groupFonts[4])
      seexports.rl_gui:setLabelAlignment(label, "right", "center")
      seexports.rl_gui:setLabelColor(label, "v4green")
      seexports.rl_gui:setLabelText(label, seexports.rl_gui:thousandsStepper(groupDatas[selectedGroup].salaries[j] or 0) .. " $")
      y = y + 32
      if j == math.ceil(n / 2) then
        x = x + panelWidth / 2
        y = titlebarHeight
      end
    end
    seexports.rl_gui:setGuiPositionAnimated(window, false, screenY / 2 - panelHeight / 2, 250)
  end
end)
local permValues = {
  vehicle = 1,
  interior = 2,
  skin = 3,
  item = 4,
  permission = 5
}
function sortPermissionData(a, b)
  local av = permValues[a[1]] or 999
  local bv = permValues[b[1]] or 999
  if av == bv then
    return a[2] < b[2]
  else
    return av < bv
  end
end
function sortPermissionDataEx(a, b)
  local av = permValues[a[1]] or 999
  local bv = permValues[b[1]] or 999
  if av == bv then
    local at = a[3] and 1 or 0
    local bt = b[3] and 1 or 0
    if at == bt then
      return a[2] < b[2]
    else
      return at > bt
    end
  else
    return av < bv
  end
end
function processSelectedMemberPermissionList()
  local w, h = seexports.rl_gui:getGuiSize(perMemberBg)
  local n = math.max(0, #memberPermissionsData - #perMemberPermissions)
  h = h / (n + 1)
  if n < perMemberScroll then
    perMemberScroll = n
  end
  seexports.rl_gui:setGuiSize(perMemberScrollBar, false, h)
  seexports.rl_gui:setGuiPosition(perMemberScrollBar, false, h * perMemberScroll)
  for i = 1, #perMemberPermissions do
    if memberPermissionsData[i + perMemberScroll] then
      seexports.rl_gui:setGuiRenderDisabled(perMemberPermissions[i][1], false)
      seexports.rl_gui:setGuiRenderDisabled(perMemberPermissions[i][2], false)
      if perMemberPermissions[i][3] then
        seexports.rl_gui:setGuiRenderDisabled(perMemberPermissions[i][3], false)
      end
      if memberPermissionsData[i + perMemberScroll][1] == "vehicle" then
        seexports.rl_gui:setImageFile(perMemberPermissions[i][1], seexports.rl_gui:getFaIconFilename("car", 32))
        seexports.rl_gui:setImageColor(perMemberPermissions[i][1], "v4green")
        seexports.rl_gui:setLabelColor(perMemberPermissions[i][2], "v4green")
        seexports.rl_gui:setLabelText(perMemberPermissions[i][2], "Jármű #ffffff " .. memberPermissionsData[i + perMemberScroll][2])
      elseif memberPermissionsData[i + perMemberScroll][1] == "gate" then
        seexports.rl_gui:setImageDDS(perMemberPermissions[i][1], ":rl_gates/files/icon.dds")
        seexports.rl_gui:setImageColor(perMemberPermissions[i][1], "v4red")
        seexports.rl_gui:setLabelColor(perMemberPermissions[i][2], "v4red")
        seexports.rl_gui:setLabelText(perMemberPermissions[i][2], "Kapu #ffffff " .. memberPermissionsData[i + perMemberScroll][2])
      elseif memberPermissionsData[i + perMemberScroll][1] == "interior" then
        seexports.rl_gui:setImageFile(perMemberPermissions[i][1], seexports.rl_gui:getFaIconFilename("building", 32))
        seexports.rl_gui:setImageColor(perMemberPermissions[i][1], "v4blue")
        seexports.rl_gui:setLabelColor(perMemberPermissions[i][2], "v4blue")
        seexports.rl_gui:setLabelText(perMemberPermissions[i][2], "Interior #ffffff " .. memberPermissionsData[i + perMemberScroll][2])
      elseif memberPermissionsData[i + perMemberScroll][1] == "skin" then
        seexports.rl_gui:setImageFile(perMemberPermissions[i][1], seexports.rl_gui:getFaIconFilename("user-tie", 32))
        seexports.rl_gui:setImageColor(perMemberPermissions[i][1], "v4purple")
        seexports.rl_gui:setLabelColor(perMemberPermissions[i][2], "v4purple")
        seexports.rl_gui:setLabelText(perMemberPermissions[i][2], "Skin #ffffff" .. memberPermissionsData[i + perMemberScroll][2])
      elseif memberPermissionsData[i + perMemberScroll][1] == "item" then
        seexports.rl_gui:setImageFile(perMemberPermissions[i][1], seexports.rl_gui:getFaIconFilename("box", 32))
        seexports.rl_gui:setImageColor(perMemberPermissions[i][1], "v4orange")
        seexports.rl_gui:setLabelColor(perMemberPermissions[i][2], "v4orange")
        seexports.rl_gui:setLabelText(perMemberPermissions[i][2], "Duty item #ffffff" .. memberPermissionsData[i + perMemberScroll][2])
      elseif memberPermissionsData[i + perMemberScroll][1] == "permission" then
        seexports.rl_gui:setImageFile(perMemberPermissions[i][1], seexports.rl_gui:getFaIconFilename("bolt", 32))
        seexports.rl_gui:setImageColor(perMemberPermissions[i][1], "v4yellow")
        seexports.rl_gui:setLabelColor(perMemberPermissions[i][2], "v4yellow")
        seexports.rl_gui:setLabelText(perMemberPermissions[i][2], "Jog #ffffff" .. memberPermissionsData[i + perMemberScroll][2])
      end
    else
      seexports.rl_gui:setGuiRenderDisabled(perMemberPermissions[i][1], true)
      seexports.rl_gui:setGuiRenderDisabled(perMemberPermissions[i][2], true)
      if perMemberPermissions[i][3] then
        seexports.rl_gui:setGuiRenderDisabled(perMemberPermissions[i][3], true)
      end
    end
  end
end
function processSelectedMember()
  perMemberScroll = 0
  rankCheckboxes = {}
  memberPermissionsData = {}
  if selectedMember and groupDatas[selectedGroup].gotMembers[selectedMember] then
    local member = groupDatas[selectedGroup].gotMembers[selectedMember]
    seexports.rl_gui:setLabelText(memberNameLabel, member[1])
    if memberFireButton then
      if member[3] and not groupDatas[selectedGroup].isLeader then
        seexports.rl_gui:setGuiRenderDisabled(memberFireButton, true)
      else
        seexports.rl_gui:setGuiRenderDisabled(memberFireButton, false)
        local x = seexports.rl_gui:getGuiPosition(memberNameLabel)
        local w = seexports.rl_gui:getLabelTextWidth(memberNameLabel)
        seexports.rl_gui:setGuiPosition(memberFireButton, x + w + dashboardPadding[3], false)
      end
    end
    local rank = member[2]
    seexports.rl_gui:setLabelColor(memberRankLabel, "v4" .. (groupDatas[selectedGroup].rankColors[rank] or "blue"))
    seexports.rl_gui:setLabelText(memberRankLabel, (groupDatas[selectedGroup].ranks[rank] or "N/A") .. " [" .. rank .. "]")
    if memberRankEdit then
      seexports.rl_gui:setGuiRenderDisabled(memberRankEdit, false)
      local x = seexports.rl_gui:getGuiPosition(memberRankLabel)
      local w = seexports.rl_gui:getLabelTextWidth(memberRankLabel)
      seexports.rl_gui:setGuiPosition(memberRankEdit, x + w + dashboardPadding[3], false)
    end
    seexports.rl_gui:setLabelText(memberSalaryLabel, seexports.rl_gui:thousandsStepper(groupDatas[selectedGroup].salaries[rank] or 0) .. " $")
    seexports.rl_gui:setLabelColor(memberLeaderLabel, member[3] and "v4green" or "v4red")
    seexports.rl_gui:setLabelText(memberLeaderLabel, member[3] and "igen" or "nem")
    if isElement(member[4]) then
      seexports.rl_gui:setLabelColor(memberLastOnlineLabel, "v4green")
      seexports.rl_gui:setLabelText(memberLastOnlineLabel, "jelenleg online")
    else
      local time = getRealTime(member[4])
      seexports.rl_gui:setLabelColor(memberLastOnlineLabel, "v4blue")
      seexports.rl_gui:setLabelText(memberLastOnlineLabel, string.format("%04d. %02d. %02d. %02d:%02d", time.year + 1900, time.month + 1, time.monthday, time.hour, time.minute))
    end
    local time = getRealTime(member[5])
    seexports.rl_gui:setLabelText(memberAddedLabel, string.format("%04d. %02d. %02d. %02d:%02d", time.year + 1900, time.month + 1, time.monthday, time.hour, time.minute))
    local time = getRealTime(member[6])
    seexports.rl_gui:setLabelText(memberPromotedLabel, string.format("%04d. %02d. %02d. %02d:%02d", time.year + 1900, time.month + 1, time.monthday, time.hour, time.minute))
    local n = #perMemberPermissions
    if member[3] then
      for i = 1, #perMemberPermissions do
        if i <= 5 then
          seexports.rl_gui:setGuiRenderDisabled(perMemberPermissions[i][1], false)
          seexports.rl_gui:setGuiRenderDisabled(perMemberPermissions[i][2], false)
          if perMemberPermissions[i][3] then
            seexports.rl_gui:setGuiRenderDisabled(perMemberPermissions[i][3], false)
          end
          if i == 1 then
            seexports.rl_gui:setImageFile(perMemberPermissions[i][1], seexports.rl_gui:getFaIconFilename("car", 32))
            seexports.rl_gui:setImageColor(perMemberPermissions[i][1], "v4green")
            seexports.rl_gui:setLabelColor(perMemberPermissions[i][2], "v4green")
            seexports.rl_gui:setLabelText(perMemberPermissions[i][2], "Összes jármű")
          elseif i == 2 then
            seexports.rl_gui:setImageFile(perMemberPermissions[i][1], seexports.rl_gui:getFaIconFilename("building", 32))
            seexports.rl_gui:setImageColor(perMemberPermissions[i][1], "v4blue")
            seexports.rl_gui:setLabelColor(perMemberPermissions[i][2], "v4blue")
            seexports.rl_gui:setLabelText(perMemberPermissions[i][2], "Összes interior")
          elseif i == 3 then
            seexports.rl_gui:setImageFile(perMemberPermissions[i][1], seexports.rl_gui:getFaIconFilename("user-tie", 32))
            seexports.rl_gui:setImageColor(perMemberPermissions[i][1], "v4purple")
            seexports.rl_gui:setLabelColor(perMemberPermissions[i][2], "v4purple")
            seexports.rl_gui:setLabelText(perMemberPermissions[i][2], "Összes skin")
          elseif i == 4 then
            seexports.rl_gui:setImageFile(perMemberPermissions[i][1], seexports.rl_gui:getFaIconFilename("box", 32))
            seexports.rl_gui:setImageColor(perMemberPermissions[i][1], "v4orange")
            seexports.rl_gui:setLabelColor(perMemberPermissions[i][2], "v4orange")
            seexports.rl_gui:setLabelText(perMemberPermissions[i][2], "Összes duty item")
          elseif i == 5 then
            seexports.rl_gui:setImageDDS(perMemberPermissions[i][1], ":rl_gates/files/icon.dds")
            seexports.rl_gui:setImageColor(perMemberPermissions[i][1], "v4red")
            seexports.rl_gui:setLabelColor(perMemberPermissions[i][2], "v4red")
            seexports.rl_gui:setLabelText(perMemberPermissions[i][2], "Összes kapu")
          else
            seexports.rl_gui:setImageFile(perMemberPermissions[i][1], seexports.rl_gui:getFaIconFilename("bolt", 32))
            seexports.rl_gui:setImageColor(perMemberPermissions[i][1], "v4yellow")
            seexports.rl_gui:setLabelColor(perMemberPermissions[i][2], "v4yellow")
            seexports.rl_gui:setLabelText(perMemberPermissions[i][2], "Összes jog")
          end
        else
          seexports.rl_gui:setGuiRenderDisabled(perMemberPermissions[i][1], true)
          seexports.rl_gui:setGuiRenderDisabled(perMemberPermissions[i][2], true)
          if perMemberPermissions[i][3] then
            seexports.rl_gui:setGuiRenderDisabled(perMemberPermissions[i][3], true)
          end
        end
      end
    else
      if groupDatas[selectedGroup].rankPermissions[rank] then
        for perm in pairs(groupDatas[selectedGroup].rankPermissions[rank]) do
          table.insert(memberPermissionsData, {
            "permission",
            seexports.rl_groups:getPermissionName(perm)
          })
        end
      end
      if groupDatas[selectedGroup].rankSkins[rank] then
        for skin in pairs(groupDatas[selectedGroup].rankSkins[rank]) do
          table.insert(memberPermissionsData, {
            "skin",
            seexports.rl_groups:getDutySkinName(selectedGroup, skin)
          })
        end
      end
      if groupDatas[selectedGroup].rankItems[rank] then
        for item in pairs(groupDatas[selectedGroup].rankItems[rank]) do
          if groupDatas[selectedGroup].items[item] and 1 < groupDatas[selectedGroup].items[item][1] then
            table.insert(memberPermissionsData, {
              "item",
              groupDatas[selectedGroup].items[item][1] .. "db " .. seexports.rl_items:getItemName(item) .. " (" .. seexports.rl_gui:thousandsStepper(seexports.rl_groups:getDutyItemPrice(selectedGroup, item)) .. " $/db)"
            })
          else
            table.insert(memberPermissionsData, {
              "item",
              seexports.rl_items:getItemName(item) .. " (" .. seexports.rl_gui:thousandsStepper(seexports.rl_groups:getDutyItemPrice(selectedGroup, item)) .. " $/db)"
            })
          end
        end
      end
      for i = 1, #groupDatas[selectedGroup].vehicles do
        if groupDatas[selectedGroup].vehicleMembers[groupDatas[selectedGroup].vehicles[i][1]][selectedMember] then
          table.insert(memberPermissionsData, {
            "vehicle",
            "[" .. groupDatas[selectedGroup].vehicles[i][1] .. "] " .. groupDatas[selectedGroup].vehicles[i][2] .. " ([color=v4blue]" .. groupDatas[selectedGroup].vehicles[i][3] .. "#ffffff)"
          })
        end
      end
      for i = 1, #groupInteriors do
        if groupDatas[selectedGroup].interiorMembers[groupInteriors[i][1]][selectedMember] then
          table.insert(memberPermissionsData, {
            "interior",
            "[" .. groupInteriors[i][1] .. "] " .. groupInteriors[i][2] .. " (" .. groupInteriors[i][3] .. "#ffffff)"
          })
        end
      end
      for i = 1, #groupGates do
        if groupDatas[selectedGroup].gateMembers[groupGates[i]][selectedMember] then
          table.insert(memberPermissionsData, {
            "gate",
            "[" .. groupGates[i] .. "]"
          })
        end
      end
      table.sort(memberPermissionsData, sortPermissionData)
      processSelectedMemberPermissionList()
    end
  else
    seexports.rl_gui:setLabelText(memberNameLabel, "Válassz tagot!")
    seexports.rl_gui:setLabelText(memberRankLabel, "")
    seexports.rl_gui:setLabelText(memberSalaryLabel, "")
    seexports.rl_gui:setLabelText(memberLeaderLabel, "")
    seexports.rl_gui:setLabelText(memberLastOnlineLabel, "")
    seexports.rl_gui:setLabelText(memberAddedLabel, "")
    if memberRankEdit then
      seexports.rl_gui:setGuiRenderDisabled(memberRankEdit, true)
    end
    if memberFireButton then
      seexports.rl_gui:setGuiRenderDisabled(memberFireButton, true)
    end
    for i = 1, #perMemberPermissions do
      seexports.rl_gui:setGuiRenderDisabled(perMemberPermissions[i][1], true)
      seexports.rl_gui:setGuiRenderDisabled(perMemberPermissions[i][2], true)
      if perMemberPermissions[i][3] then
        seexports.rl_gui:setGuiRenderDisabled(perMemberPermissions[i][3], true)
      end
    end
  end
end
addEvent("finalFireMemberFromGroup", false)
addEventHandler("finalFireMemberFromGroup", getRootElement(), function(button, state, absoluteX, absoluteY, el)
  if groupDatas[selectedGroup] and groupDatas[selectedGroup].gotMembers[selectedMember] then
    createGroupLoader()
    triggerServerEvent("firePlayerFromGroup", localPlayer, selectedGroup, selectedMember)
    selectedMember = false
  end
end)
addEvent("fireMemberFromGroup", false)
addEventHandler("fireMemberFromGroup", getRootElement(), function(button, state, absoluteX, absoluteY, el)
  if groupDatas[selectedGroup] and groupDatas[selectedGroup].gotMembers[selectedMember] then
    groupModal = seexports.rl_gui:createGuiElement("rectangle", 0, 0, screenX, screenY)
    seexports.rl_gui:setGuiBackground(groupModal, "solid", {
      0,
      0,
      0,
      150
    })
    seexports.rl_gui:setGuiHover(groupModal, "none")
    seexports.rl_gui:setGuiHoverable(groupModal, true)
    seexports.rl_gui:disableClickTrough(groupModal, true)
    seexports.rl_gui:disableLinkCursor(groupModal, true)
    local titlebarHeight = seexports.rl_gui:getTitleBarHeight()
    local panelWidth = 375
    local pad = dashboardPadding[3] * 2
    local panelHeight = titlebarHeight + 96
    local window = seexports.rl_gui:createGuiElement("window", screenX / 2 - panelWidth / 2, -panelHeight, panelWidth, panelHeight, groupModal)
    seexports.rl_gui:setWindowTitle(window, "16/BebasNeueRegular.otf", groupDatas[selectedGroup].gotMembers[selectedMember][1] .. " kirúgása")
    local label = seexports.rl_gui:createGuiElement("label", pad, titlebarHeight, panelWidth - pad, panelHeight - titlebarHeight - 24 - pad, window)
    seexports.rl_gui:setLabelFont(label, groupFonts[6])
    seexports.rl_gui:setLabelAlignment(label, "center", "center")
    seexports.rl_gui:setLabelText(label, "Biztosan szeretnéd kirúgni a tagot?")
    local w = (panelWidth - pad * 3) / 2
    local btn = seexports.rl_gui:createGuiElement("button", pad, panelHeight - 24 - pad, w, 24, window)
    seexports.rl_gui:setGuiBackground(btn, "solid", "v4green")
    seexports.rl_gui:setGuiHover(btn, "gradient", {
      "v4green",
      "v4green-second"
    }, false, true)
    seexports.rl_gui:setButtonFont(btn, groupFonts[1])
    seexports.rl_gui:setButtonText(btn, "Igen")
    seexports.rl_gui:setClickEvent(btn, "finalFireMemberFromGroup")
    local btn = seexports.rl_gui:createGuiElement("button", pad + w + pad, panelHeight - 24 - pad, w, 24, window)
    seexports.rl_gui:setGuiBackground(btn, "solid", "v4red")
    seexports.rl_gui:setGuiHover(btn, "gradient", {
      "v4red",
      "v4red-second"
    }, false, true)
    seexports.rl_gui:setButtonFont(btn, groupFonts[1])
    seexports.rl_gui:setButtonText(btn, "Nem")
    seexports.rl_gui:setClickEvent(btn, "closeGroupModal")
    seexports.rl_gui:setGuiPositionAnimated(window, false, screenY / 2 - panelHeight / 2, 250)
  end
end)
addEvent("finalAddGroupMember", false)
addEventHandler("finalAddGroupMember", getRootElement(), function(button, state, absoluteX, absoluteY, el)
  for i = 1, #newMemberList do
    if newMemberList[i][2] == el then
      createGroupLoader()
      triggerServerEvent("addPlayerToGroup", localPlayer, selectedGroup, newMemberList[i][3])
      return
    end
  end
end)
function refreshNewMemberList()
  local players = getElementsByType("player")
  local c = 1
  local value = seexports.rl_gui:getInputValue(newMemberInput) or ""
  for i = 1, #players do
    local cid = getElementData(players[i], "char.ID")
    if cid then
      local pid, name
      local found = true
      if tonumber(value) then
        pid = getElementData(players[i], "playerID")
        found = tonumber(value) == pid
      elseif utf8.len(value) > 0 then
        name = getElementData(players[i], "visibleName"):gsub("_", " ")
        found = utf8.find(utf8.lower(name), utf8.lower(value:gsub("_", " ")))
      end
      if found then
        pid = pid or getElementData(players[i], "playerID")
        name = name or getElementData(players[i], "visibleName"):gsub("_", " ")
        seexports.rl_gui:setGuiRenderDisabled(newMemberList[c][1], false)
        seexports.rl_gui:setGuiRenderDisabled(newMemberList[c][2], false)
        seexports.rl_gui:setLabelText(newMemberList[c][1], "[" .. pid .. "] " .. name)
        local icon = newMemberList[c][2]
        if groupDatas[selectedGroup].gotMembers[cid] then
          seexports.rl_gui:setImageFile(icon, seexports.rl_gui:getFaIconFilename("user-tag", 24))
          seexports.rl_gui:setImageColor(icon, "v4midgrey")
          seexports.rl_gui:setGuiHover(icon, "solid", "v4midgrey")
          seexports.rl_gui:setClickEvent(icon, false)
          seexports.rl_gui:guiSetTooltip(icon, "Jelenleg tag")
          seexports.rl_gui:setLabelColor(newMemberList[c][1], "v4midgrey")
        else
          seexports.rl_gui:setImageFile(icon, seexports.rl_gui:getFaIconFilename("user-plus", 24))
          seexports.rl_gui:setImageColor(icon, "#ffffff")
          seexports.rl_gui:setGuiHover(icon, "solid", "v4green")
          seexports.rl_gui:setClickEvent(icon, "finalAddGroupMember")
          seexports.rl_gui:guiSetTooltip(icon, "Tag felvétele")
          seexports.rl_gui:setLabelColor(newMemberList[c][1], "v4lightgrey")
        end
        newMemberList[c][3] = players[i]
        c = c + 1
        if c > #newMemberList then
          break
        end
      end
    end
  end
  for i = c, #newMemberList do
    seexports.rl_gui:setGuiRenderDisabled(newMemberList[i][1], true)
    seexports.rl_gui:setGuiRenderDisabled(newMemberList[i][2], true)
    newMemberList[c][3] = false
  end
end
addEvent("refreshNewMemberList", true)
addEventHandler("refreshNewMemberList", getRootElement(), refreshNewMemberList)
addEvent("openMemberAddModal", false)
addEventHandler("openMemberAddModal", getRootElement(), function(button, state, absoluteX, absoluteY, el)
  groupModal = seexports.rl_gui:createGuiElement("rectangle", 0, 0, screenX, screenY)
  seexports.rl_gui:setGuiBackground(groupModal, "solid", {
    0,
    0,
    0,
    150
  })
  seexports.rl_gui:setGuiHover(groupModal, "none")
  seexports.rl_gui:setGuiHoverable(groupModal, true)
  seexports.rl_gui:disableClickTrough(groupModal, true)
  seexports.rl_gui:disableLinkCursor(groupModal, true)
  local titlebarHeight = seexports.rl_gui:getTitleBarHeight()
  local panelWidth = 375
  local pad = dashboardPadding[3] * 2
  local panelHeight = titlebarHeight + 160 + pad + 30 + pad
  local window = seexports.rl_gui:createGuiElement("window", screenX / 2 - panelWidth / 2, -panelHeight, panelWidth, panelHeight, groupModal)
  seexports.rl_gui:setWindowTitle(window, "16/BebasNeueRegular.otf", "Tagfelvétel")
  seexports.rl_gui:setWindowCloseButton(window, "closeGroupModal")
  local y = titlebarHeight
  newMemberList = {}
  for i = 1, 5 do
    newMemberList[i] = {}
    local label = seexports.rl_gui:createGuiElement("label", pad, y, 0, 32, window)
    seexports.rl_gui:setLabelFont(label, groupFonts[4])
    seexports.rl_gui:setLabelAlignment(label, "left", "center")
    newMemberList[i][1] = label
    local icon = seexports.rl_gui:createGuiElement("image", panelWidth - 24 - pad, y + 16 - 12, 24, 24, window)
    seexports.rl_gui:setImageFile(icon, seexports.rl_gui:getFaIconFilename("user-plus", 24))
    seexports.rl_gui:setGuiHover(icon, "solid", "v4green")
    seexports.rl_gui:setGuiHoverable(icon, true)
    seexports.rl_gui:setClickEvent(icon, "finalAddGroupMember")
    seexports.rl_gui:guiSetTooltip(icon, "Tag felvétele")
    newMemberList[i][2] = icon
    y = y + 32
    if i < 5 then
      local border = seexports.rl_gui:createGuiElement("hr", pad, y - 1, panelWidth - pad * 2, 2, window)
    end
  end
  y = y + pad
  newMemberInput = seexports.rl_gui:createGuiElement("input", pad, y, panelWidth - pad * 2, 30, window)
  seexports.rl_gui:setInputPlaceholder(newMemberInput, "Játékos neve / ID")
  seexports.rl_gui:setInputMaxLength(newMemberInput, 32)
  seexports.rl_gui:setInputIcon(newMemberInput, "user")
  seexports.rl_gui:setInputChangeEvent(newMemberInput, "refreshNewMemberList")
  refreshNewMemberList()
  seexports.rl_gui:setGuiPositionAnimated(window, false, screenY / 2 - panelHeight / 2, 250)
end)
addEvent("depositGroup", true)
addEventHandler("depositGroup", getRootElement(), function()
  local value = seexports.rl_gui:getInputValue(groupBalanceInput)
  if not tonumber(value) then
    seexports.rl_gui:showInfobox("e", "Érvénytelen összeg!")
    return
  end
  value = tonumber(value)
  if value < 1000 then
    seexports.rl_gui:showInfobox("e", "Minimum kezelhető összeg: 1 000$")
    return
  end
  createGroupLoader()
  triggerEvent("closeGroupModal", localPlayer)
  triggerLatentServerEvent("depositGroupBalance", localPlayer, selectedGroup, value)
end)
addEvent("withdrawGroup", true)
addEventHandler("withdrawGroup", getRootElement(), function()
  local value = seexports.rl_gui:getInputValue(groupBalanceInput)
  if not tonumber(value) then
    seexports.rl_gui:showInfobox("e", "Érvénytelen összeg!")
    return
  end
  value = tonumber(value)
  if value < 1000 then
    seexports.rl_gui:showInfobox("e", "Minimum kezelhető összeg: 1 000$")
    return
  end
  createGroupLoader()
  triggerEvent("closeGroupModal", localPlayer)
  triggerLatentServerEvent("withdrawGroupBalance", localPlayer, selectedGroup, value)
end)
addEvent("refreshGroupBalance", true)
addEventHandler("refreshGroupBalance", getRootElement(), function(prefix, amount)
  groupDatas[prefix].balance = amount
  deleteGroupLoader()
  drawGroupPanel()
end)
addEvent("openGroupBalanceModal", false)
addEventHandler("openGroupBalanceModal", getRootElement(), function(button, state, absoluteX, absoluteY, el)
  groupModal = seexports.rl_gui:createGuiElement("rectangle", 0, 0, screenX, screenY)
  seexports.rl_gui:setGuiBackground(groupModal, "solid", {
    0,
    0,
    0,
    150
  })
  seexports.rl_gui:setGuiHover(groupModal, "none")
  seexports.rl_gui:setGuiHoverable(groupModal, true)
  seexports.rl_gui:disableClickTrough(groupModal, true)
  seexports.rl_gui:disableLinkCursor(groupModal, true)
  local titlebarHeight = seexports.rl_gui:getTitleBarHeight()
  local panelWidth = 375
  local pad = dashboardPadding[3] * 2
  local panelHeight = titlebarHeight + 30 + 60 + pad * 2
  local window = seexports.rl_gui:createGuiElement("window", screenX / 2 - panelWidth / 2, -panelHeight, panelWidth, panelHeight, groupModal)
  seexports.rl_gui:setWindowTitle(window, "16/BebasNeueRegular.otf", "Kasszakezelés")
  seexports.rl_gui:setWindowCloseButton(window, "closeGroupModal")
  local y = titlebarHeight
  local label = seexports.rl_gui:createGuiElement("label", pad, y, 0, 32, window)
  seexports.rl_gui:setLabelFont(label, groupFonts[4])
  seexports.rl_gui:setLabelAlignment(label, "left", "center")
  local label = seexports.rl_gui:createGuiElement("label", pad + 2, y, 0, 0, window)
  seexports.rl_gui:setLabelFont(label, groupFonts[4])
  seexports.rl_gui:setLabelAlignment(label, "left", "top")
  seexports.rl_gui:setLabelText(label, "Egyenleg: ")
  local label = seexports.rl_gui:createGuiElement("label", pad + 2 + seexports.rl_gui:getLabelTextWidth(label), y, 0, 0, window)
  seexports.rl_gui:setLabelFont(label, groupFonts[5])
  seexports.rl_gui:setLabelAlignment(label, "left", "top")
  if 0 <= groupDatas[selectedGroup].balance then
    seexports.rl_gui:setLabelColor(label, "v4green")
  else
    seexports.rl_gui:setLabelColor(label, "v4red")
  end
  seexports.rl_gui:setLabelText(label, seexports.rl_gui:thousandsStepper(groupDatas[selectedGroup].balance) .. " $")
  y = y + pad + seexports.rl_gui:getLabelFontHeight(label)
  groupBalanceInput = seexports.rl_gui:createGuiElement("input", pad, y, panelWidth - pad * 2, 30, window)
  seexports.rl_gui:setInputPlaceholder(groupBalanceInput, "Összeg")
  seexports.rl_gui:setInputMaxLength(groupBalanceInput, 32)
  seexports.rl_gui:setInputIcon(groupBalanceInput, "coins")
  seexports.rl_gui:setInputNumberOnly(groupBalanceInput, true)
  y = y + pad + 30
  local buttonSizeX = (panelWidth - pad * 3) / 2
  local btn = seexports.rl_gui:createGuiElement("button", pad, y, buttonSizeX, 30, window)
  seexports.rl_gui:setGuiBackground(btn, "solid", "v4green")
  seexports.rl_gui:setGuiHover(btn, "gradient", {
    "v4green",
    "v4green-second"
  }, false, true)
  seexports.rl_gui:setButtonFont(btn, groupFonts[1])
  seexports.rl_gui:setButtonText(btn, " Befizetés")
  seexports.rl_gui:setClickEvent(btn, "depositGroup")
  seexports.rl_gui:setButtonIcon(btn, seexports.rl_gui:getFaIconFilename("plus", 24))
  local btn = seexports.rl_gui:createGuiElement("button", pad * 2 + buttonSizeX, y, buttonSizeX, 30, window)
  seexports.rl_gui:setGuiBackground(btn, "solid", "v4red")
  seexports.rl_gui:setGuiHover(btn, "gradient", {
    "v4red",
    "v4red-second"
  }, false, true)
  seexports.rl_gui:setButtonFont(btn, groupFonts[1])
  seexports.rl_gui:setButtonText(btn, " Kifizetés")
  seexports.rl_gui:setClickEvent(btn, "withdrawGroup")
  seexports.rl_gui:setButtonIcon(btn, seexports.rl_gui:getFaIconFilename("minus", 24))
  seexports.rl_gui:setGuiPositionAnimated(window, false, screenY / 2 - panelHeight / 2, 250)
end)
function drawGroupMembers()
  local onlineMembers = 0
  for i = 1, #groupDatas[selectedGroup].members do
    if isElement(groupDatas[selectedGroup].members[i][4]) then
      onlineMembers = onlineMembers + 1
    end
  end
  local label = seexports.rl_gui:createGuiElement("label", dashboardPadding[3] * 4, 40, 0, 48, groupPanel)
  seexports.rl_gui:setLabelFont(label, groupFonts[3])
  seexports.rl_gui:setLabelAlignment(label, "left", "center")
  seexports.rl_gui:setLabelText(label, "Tagok: " .. onlineMembers .. "/" .. #groupDatas[selectedGroup].members)
  local perm = seexports.rl_groups:getPlayerPermissionInGroup(selectedGroup, "hireFire")
  if groupDatas[selectedGroup].isLeader or perm then
    local btn = seexports.rl_gui:createGuiElement("button", dashboardPadding[3] * 4 + seexports.rl_gui:getLabelTextWidth(label) + dashboardPadding[3] * 2, 52, 100, 24, groupPanel)
    seexports.rl_gui:setGuiBackground(btn, "solid", "v4green")
    seexports.rl_gui:setGuiHover(btn, "gradient", {
      "v4green",
      "v4green-second"
    }, false, true)
    seexports.rl_gui:setButtonFont(btn, groupFonts[1])
    seexports.rl_gui:setButtonText(btn, "Tagfelvétel")
    seexports.rl_gui:setClickEvent(btn, "openMemberAddModal")
  end
  local w = math.ceil((sx - menuW) * 0.45)
  local h = sy - 40 - dashboardPadding[3] * 8 - 48
  memberBg = seexports.rl_gui:createGuiElement("rectangle", dashboardPadding[3] * 4, 88 + dashboardPadding[3] * 4, w, h, groupPanel)
  seexports.rl_gui:setGuiBackground(memberBg, "solid", "v4grey1")
  local sbg = seexports.rl_gui:createGuiElement("rectangle", w - 2, 0, 2, h, memberBg)
  seexports.rl_gui:setGuiBackground(sbg, "solid", "v4grey3")
  memberScrollBar = seexports.rl_gui:createGuiElement("rectangle", w - 2, 0, 2, h, memberBg)
  seexports.rl_gui:setGuiBackground(memberScrollBar, "solid", "v4midgrey")
  local n = math.floor(h / 32)
  h = h / n
  memberElements = {}
  y = 0
  for i = 1, n do
    if groupDatas[selectedGroup].members[i] then
      memberElements[i] = {}
      local rect = seexports.rl_gui:createGuiElement("rectangle", 0, y, w - 2, h - 1, memberBg)
      seexports.rl_gui:setGuiBackground(rect, "solid", "v4grey1")
      seexports.rl_gui:setGuiHover(rect, "gradient", {"v4grey1", "v4grey2"}, false, true)
      seexports.rl_gui:setGuiHoverable(rect, true)
      seexports.rl_gui:setClickEvent(rect, "selectGroupPanelMember")
      memberElements[i][1] = rect
      local image = seexports.rl_gui:createGuiElement("image", dashboardPadding[3], dashboardPadding[3] * 2, h - dashboardPadding[3] * 4, h - dashboardPadding[3] * 4, rect)
      memberElements[i][2] = image
      local image = seexports.rl_gui:createGuiElement("image", w - h + dashboardPadding[3] * 2 - 2, dashboardPadding[3] * 2, h - dashboardPadding[3] * 4, h - dashboardPadding[3] * 4, rect)
      seexports.rl_gui:setImageFile(image, seexports.rl_gui:getFaIconFilename("user-shield", 32))
      seexports.rl_gui:setImageColor(image, "v4yellow")
      memberElements[i][3] = image
      local label = seexports.rl_gui:createGuiElement("label", h - dashboardPadding[3] * 2, 0, 0, h, rect)
      seexports.rl_gui:setLabelFont(label, groupFonts[4])
      seexports.rl_gui:setLabelAlignment(label, "left", "center")
      memberElements[i][4] = label
      local label = seexports.rl_gui:createGuiElement("label", 0, 0, w - dashboardPadding[3] * 2 - 2, h, rect)
      seexports.rl_gui:setLabelFont(label, groupFonts[5])
      seexports.rl_gui:setLabelColor(label, "v4blue")
      seexports.rl_gui:setLabelAlignment(label, "right", "center")
      memberElements[i][5] = label
      if i < n then
        local border = seexports.rl_gui:createGuiElement("hr", 0, h - 1, w - 2, 2, rect)
        seexports.rl_gui:setGuiHrColor(border, "v4grey3", "v4grey2")
      end
    end
    y = y + h
  end
  x = dashboardPadding[3] * 4 + w
  y = 88 + dashboardPadding[3] * 4
  local w = sx - menuW - x
  x = x + dashboardPadding[3] * 4
  memberNameLabel = seexports.rl_gui:createGuiElement("label", x, y, w, 0, groupPanel)
  seexports.rl_gui:setLabelFont(memberNameLabel, groupFonts[3])
  seexports.rl_gui:setLabelAlignment(memberNameLabel, "left", "top")
  local perm = seexports.rl_groups:getPlayerPermissionInGroup(selectedGroup, "hireFire")
  if groupDatas[selectedGroup].isLeader or perm then
    local h = seexports.rl_gui:getLabelFontHeight(memberNameLabel)
    memberFireButton = seexports.rl_gui:createGuiElement("image", x, y, h, h, groupPanel)
    seexports.rl_gui:setImageFile(memberFireButton, seexports.rl_gui:getFaIconFilename("user-times", h))
    seexports.rl_gui:setGuiHover(memberFireButton, "solid", "v4red")
    seexports.rl_gui:setGuiHoverable(memberFireButton, true)
    seexports.rl_gui:setClickEvent(memberFireButton, "fireMemberFromGroup")
    seexports.rl_gui:guiSetTooltip(memberFireButton, "Tag kirúgása")
  end
  y = y + seexports.rl_gui:getLabelFontHeight(memberNameLabel) + dashboardPadding[3] * 2
  local label = seexports.rl_gui:createGuiElement("label", x, y, 0, 0, groupPanel)
  seexports.rl_gui:setLabelFont(label, groupFonts[4])
  seexports.rl_gui:setLabelAlignment(label, "left", "top")
  seexports.rl_gui:setLabelText(label, "Rang: ")
  memberRankLabel = seexports.rl_gui:createGuiElement("label", x + seexports.rl_gui:getLabelTextWidth(label), y, 0, 0, groupPanel)
  seexports.rl_gui:setLabelFont(memberRankLabel, groupFonts[5])
  seexports.rl_gui:setLabelAlignment(memberRankLabel, "left", "top")
  seexports.rl_gui:setLabelColor(memberRankLabel, "v4blue")
  local h = seexports.rl_gui:getLabelFontHeight(label)
  local perm = seexports.rl_groups:getPlayerPermissionInGroup(selectedGroup, "promoteDemote")
  if groupDatas[selectedGroup].isLeader or perm then
    memberRankEdit = seexports.rl_gui:createGuiElement("image", x, y, h, h, groupPanel)
    seexports.rl_gui:setImageFile(memberRankEdit, seexports.rl_gui:getFaIconFilename("pen", h))
    seexports.rl_gui:setGuiHover(memberRankEdit, "solid", "v4green")
    seexports.rl_gui:setGuiHoverable(memberRankEdit, true)
    seexports.rl_gui:setClickEvent(memberRankEdit, "changeGroupMemberRank")
    seexports.rl_gui:guiSetTooltip(memberRankEdit, "Tag rangjának szerkesztése")
  else
    memberRankEdit = false
  end
  y = y + h + dashboardPadding[3]
  local label = seexports.rl_gui:createGuiElement("label", x, y, 0, 0, groupPanel)
  seexports.rl_gui:setLabelFont(label, groupFonts[4])
  seexports.rl_gui:setLabelAlignment(label, "left", "top")
  seexports.rl_gui:setLabelText(label, "Fizetés: ")
  memberSalaryLabel = seexports.rl_gui:createGuiElement("label", x + seexports.rl_gui:getLabelTextWidth(label), y, 0, 0, groupPanel)
  seexports.rl_gui:setLabelFont(memberSalaryLabel, groupFonts[5])
  seexports.rl_gui:setLabelAlignment(memberSalaryLabel, "left", "top")
  seexports.rl_gui:setLabelColor(memberSalaryLabel, "v4green")
  y = y + seexports.rl_gui:getLabelFontHeight(label) + dashboardPadding[3]
  local label = seexports.rl_gui:createGuiElement("label", x, y, 0, 0, groupPanel)
  seexports.rl_gui:setLabelFont(label, groupFonts[4])
  seexports.rl_gui:setLabelAlignment(label, "left", "top")
  seexports.rl_gui:setLabelText(label, "Leader: ")
  memberLeaderLabel = seexports.rl_gui:createGuiElement("label", x + seexports.rl_gui:getLabelTextWidth(label), y, 0, 0, groupPanel)
  seexports.rl_gui:setLabelFont(memberLeaderLabel, groupFonts[5])
  seexports.rl_gui:setLabelAlignment(memberLeaderLabel, "left", "top")
  seexports.rl_gui:setLabelColor(memberLeaderLabel, "v4green")
  y = y + seexports.rl_gui:getLabelFontHeight(label) + dashboardPadding[3]
  local label = seexports.rl_gui:createGuiElement("label", x, y, 0, 0, groupPanel)
  seexports.rl_gui:setLabelFont(label, groupFonts[4])
  seexports.rl_gui:setLabelAlignment(label, "left", "top")
  seexports.rl_gui:setLabelText(label, "Utoljára online: ")
  memberLastOnlineLabel = seexports.rl_gui:createGuiElement("label", x + seexports.rl_gui:getLabelTextWidth(label), y, 0, 0, groupPanel)
  seexports.rl_gui:setLabelFont(memberLastOnlineLabel, groupFonts[5])
  seexports.rl_gui:setLabelAlignment(memberLastOnlineLabel, "left", "top")
  seexports.rl_gui:setLabelColor(memberLastOnlineLabel, "v4blue")
  y = y + seexports.rl_gui:getLabelFontHeight(label) + dashboardPadding[3]
  local label = seexports.rl_gui:createGuiElement("label", x, y, 0, 0, groupPanel)
  seexports.rl_gui:setLabelFont(label, groupFonts[4])
  seexports.rl_gui:setLabelAlignment(label, "left", "top")
  seexports.rl_gui:setLabelText(label, "Felvéve a frakcióba: ")
  memberAddedLabel = seexports.rl_gui:createGuiElement("label", x + seexports.rl_gui:getLabelTextWidth(label), y, 0, 0, groupPanel)
  seexports.rl_gui:setLabelFont(memberAddedLabel, groupFonts[5])
  seexports.rl_gui:setLabelAlignment(memberAddedLabel, "left", "top")
  seexports.rl_gui:setLabelColor(memberAddedLabel, "v4blue")
  y = y + seexports.rl_gui:getLabelFontHeight(label) + dashboardPadding[3]
  local label = seexports.rl_gui:createGuiElement("label", x, y, 0, 0, groupPanel)
  seexports.rl_gui:setLabelFont(label, groupFonts[4])
  seexports.rl_gui:setLabelAlignment(label, "left", "top")
  seexports.rl_gui:setLabelText(label, "Rang változtatva: ")
  memberPromotedLabel = seexports.rl_gui:createGuiElement("label", x + seexports.rl_gui:getLabelTextWidth(label), y, 0, 0, groupPanel)
  seexports.rl_gui:setLabelFont(memberPromotedLabel, groupFonts[5])
  seexports.rl_gui:setLabelAlignment(memberPromotedLabel, "left", "top")
  seexports.rl_gui:setLabelColor(memberPromotedLabel, "v4blue")
  y = y + seexports.rl_gui:getLabelFontHeight(label) + dashboardPadding[3] * 4
  local label = seexports.rl_gui:createGuiElement("label", x, y, 0, 0, groupPanel)
  seexports.rl_gui:setLabelFont(label, groupFonts[2])
  seexports.rl_gui:setLabelAlignment(label, "left", "top")
  seexports.rl_gui:setLabelText(label, "Tag jogosultságai:")
  y = y + seexports.rl_gui:getLabelFontHeight(label) + dashboardPadding[3] * 2
  w = w - dashboardPadding[3] * 4 * 2
  local h = sy - y - dashboardPadding[3] * 4
  perMemberBg = seexports.rl_gui:createGuiElement("rectangle", x, y, w, h, groupPanel)
  seexports.rl_gui:setGuiBackground(perMemberBg, "solid", "v4grey1")
  local sbg = seexports.rl_gui:createGuiElement("rectangle", w - 2, 0, 2, h, perMemberBg)
  seexports.rl_gui:setGuiBackground(sbg, "solid", "v4grey3")
  perMemberScrollBar = seexports.rl_gui:createGuiElement("rectangle", w - 2, 0, 2, h, perMemberBg)
  seexports.rl_gui:setGuiBackground(perMemberScrollBar, "solid", "v4midgrey")
  local n = math.floor(h / 32)
  h = h / n
  perMemberPermissions = {}
  for i = 1, n do
    perMemberPermissions[i] = {}
    local image = seexports.rl_gui:createGuiElement("image", x + dashboardPadding[3], y + dashboardPadding[3] * 2, h - dashboardPadding[3] * 4, h - dashboardPadding[3] * 4, groupPanel)
    perMemberPermissions[i][1] = image
    local label = seexports.rl_gui:createGuiElement("label", x + h - dashboardPadding[3] * 2, y, 0, h, groupPanel)
    seexports.rl_gui:setLabelFont(label, groupFonts[4])
    seexports.rl_gui:setLabelAlignment(label, "left", "center")
    perMemberPermissions[i][2] = label
    if i < n then
      local border = seexports.rl_gui:createGuiElement("hr", x, y + h - 1, w - 2, 2, groupPanel)
      seexports.rl_gui:setGuiHrColor(border, "v4grey3", "v4grey2")
      perMemberPermissions[i][3] = border
    end
    y = y + h
  end
  refreshGroupMemberList()
  processSelectedMember()
end
function processSelectedRank()
  rankPermScroll = 0
  rankPermissionEdit = false
  if rankPermissionEditButton then
    seexports.rl_gui:setImageFile(rankPermissionEditButton, seexports.rl_gui:getFaIconFilename("pen", 32))
    seexports.rl_gui:setClickEvent(rankPermissionEditButton, "editRankPermissions")
  end
  if selectedRank and groupDatas[selectedGroup].ranks[selectedRank] then
    seexports.rl_gui:setGuiRenderDisabled(rankEditButton, false)
    seexports.rl_gui:setLabelText(rankNameLabel, "[" .. selectedRank .. "] " .. groupDatas[selectedGroup].ranks[selectedRank])
    seexports.rl_gui:setLabelColor(rankNameLabel, "v4" .. (groupDatas[selectedGroup].rankColors[selectedRank] or "blue"))
    if rankEditButton and rankDeleteButton and rankUpButton and rankDownButton then
      if #groupDatas[selectedGroup].ranks > 1 then
        seexports.rl_gui:setGuiRenderDisabled(rankDeleteButton, false)
      else
        seexports.rl_gui:setGuiRenderDisabled(rankDeleteButton, true)
      end
      local x = seexports.rl_gui:getGuiPosition(rankNameLabel)
      local w = seexports.rl_gui:getLabelTextWidth(rankNameLabel)
      local h = seexports.rl_gui:getLabelFontHeight(rankNameLabel) * 0.75
      seexports.rl_gui:setGuiPosition(rankEditButton, x + w + dashboardPadding[3], false)
      seexports.rl_gui:setGuiPosition(rankDeleteButton, x + w + dashboardPadding[3] + h, false)
      if 1 < selectedRank then
        x = x + h
        seexports.rl_gui:setGuiPosition(rankUpButton, x + w + dashboardPadding[3] + h, false)
        --seexports.rl_gui:setGuiRenderDisabled(rankUpButton, false)
      else
        --seexports.rl_gui:setGuiRenderDisabled(rankUpButton, true)
      end
      if selectedRank < #groupDatas[selectedGroup].ranks then
        x = x + h
        seexports.rl_gui:setGuiPosition(rankDownButton, x + w + dashboardPadding[3] + h, false)
        --seexports.rl_gui:setGuiRenderDisabled(rankDownButton, false)
      else
        --seexports.rl_gui:setGuiRenderDisabled(rankDownButton, true)
      end
    end
    seexports.rl_gui:setLabelText(rankSalaryLabel, seexports.rl_gui:thousandsStepper(groupDatas[selectedGroup].salaries[selectedRank] or 0) .. " $")
    local rankNum = 0
    for i = 1, #groupDatas[selectedGroup].members do
      if groupDatas[selectedGroup].members[i] and groupDatas[selectedGroup].members[i][2] == selectedRank then
        rankNum = rankNum + 1
      end
    end
    rankPermissionsData = {}
    for perm in pairs(groupDatas[selectedGroup].permissions) do
      table.insert(rankPermissionsData, {
        "permission",
        seexports.rl_groups:getPermissionName(perm),
        groupDatas[selectedGroup].rankPermissions[selectedRank][perm],
        perm
      })
    end
    for skin = 1, groupDatas[selectedGroup].skins do
      table.insert(rankPermissionsData, {
        "skin",
        seexports.rl_groups:getDutySkinName(selectedGroup, skin),
        groupDatas[selectedGroup].rankSkins[selectedRank][skin],
        skin
      })
    end
    for item, v in pairs(groupDatas[selectedGroup].items) do
      if 1 < v[1] then
        table.insert(rankPermissionsData, {
          "item",
          v[1] .. "db " .. seexports.rl_items:getItemName(item) .. " (" .. seexports.rl_gui:thousandsStepper(seexports.rl_groups:getDutyItemPrice(selectedGroup, item)) .. " $/db)",
          groupDatas[selectedGroup].rankItems[selectedRank][item],
          item
        })
      else
        table.insert(rankPermissionsData, {
          "item",
          seexports.rl_items:getItemName(item) .. " (" .. seexports.rl_gui:thousandsStepper(seexports.rl_groups:getDutyItemPrice(selectedGroup, item)) .. " $/db)",
          groupDatas[selectedGroup].rankItems[selectedRank][item],
          item
        })
      end
    end
    table.sort(rankPermissionsData, sortPermissionDataEx)
    processPerRankpermissionList()
    seexports.rl_gui:setLabelText(rankNumLabel, rankNum)
  else
    if rankDeleteButton then
      seexports.rl_gui:setGuiRenderDisabled(rankDeleteButton, true)
    end
    if rankEditButton then
      seexports.rl_gui:setGuiRenderDisabled(rankEditButton, true)
    end
    seexports.rl_gui:setLabelText(rankNameLabel, "Válassz rangot!")
    seexports.rl_gui:setLabelText(rankSalaryLabel, "")
    seexports.rl_gui:setLabelText(rankNumLabel, "")
    for i = 1, #perRankPermission do
      seexports.rl_gui:setGuiRenderDisabled(perRankPermission[i][1], true)
      seexports.rl_gui:setGuiRenderDisabled(perRankPermission[i][2], true)
      seexports.rl_gui:setGuiRenderDisabled(perRankPermission[i][3], true)
      if perRankPermission[i][4] then
        seexports.rl_gui:setGuiRenderDisabled(perRankPermission[i][4], true)
      end
    end
  end
end
addEvent("doneRankPermission", false)
addEventHandler("doneRankPermission", getRootElement(), function(button, state, absoluteX, absoluteY, el)
  seexports.rl_gui:deleteGuiElement(el)
  local permissions = {}
  local items = {}
  local skins = {}
  for i = 1, #rankPermissionsData do
    if rankPermissionsData[i][3] then
      if rankPermissionsData[i][1] == "permission" then
        table.insert(permissions, rankPermissionsData[i][4])
      elseif rankPermissionsData[i][1] == "skin" then
        table.insert(skins, rankPermissionsData[i][4])
      elseif rankPermissionsData[i][1] == "item" then
        table.insert(items, rankPermissionsData[i][4])
      end
    end
  end
  createGroupLoader()
  triggerLatentServerEvent("refreshRankPermissions", localPlayer, selectedGroup, selectedRank, permissions, items, skins)

end)
addEvent("editRankPermissions", false)
addEventHandler("editRankPermissions", getRootElement(), function(button, state, absoluteX, absoluteY, el)
  if selectedRank and groupDatas[selectedGroup].ranks[selectedRank] then
    seexports.rl_gui:setImageFile(rankPermissionEditButton, seexports.rl_gui:getFaIconFilename("save", 32))
    seexports.rl_gui:setClickEvent(rankPermissionEditButton, "doneRankPermission")
    rankPermissionEdit = true
    table.sort(rankPermissionsData, sortPermissionData)
    processPerRankpermissionList()
  end
end)
addEvent("selectRankPermissionCheckbox", false)
addEventHandler("selectRankPermissionCheckbox", getRootElement(), function(button, state, absoluteX, absoluteY, el)
  for i = 1, #perRankPermission do
    if rankPermissionsData[i + rankPermScroll] then
      rankPermissionsData[i + rankPermScroll][3] = seexports.rl_gui:isCheckboxChecked(perRankPermission[i][3])
    end
  end
  processPerRankpermissionList()
end)
function processPerRankpermissionList()
  local w, h = seexports.rl_gui:getGuiSize(rankPermBg)
  local n = math.max(0, #rankPermissionsData - #perRankPermission)
  h = h / (n + 1)
  if n < rankPermScroll then
    rankPermScroll = n
  end
  seexports.rl_gui:setGuiSize(rankPermScrollbar, false, h)
  seexports.rl_gui:setGuiPosition(rankPermScrollbar, false, h * rankPermScroll)
  for i = 1, #perRankPermission do
    if rankPermissionsData[i + rankPermScroll] then
      seexports.rl_gui:setGuiRenderDisabled(perRankPermission[i][1], false)
      seexports.rl_gui:setGuiRenderDisabled(perRankPermission[i][2], false)
      local hex = rankPermissionsData[i + rankPermScroll][3] and "#ffffff" or ""
      if rankPermissionsData[i + rankPermScroll][1] == "skin" then
        seexports.rl_gui:setImageFile(perRankPermission[i][1], seexports.rl_gui:getFaIconFilename("user-tie", 32))
        seexports.rl_gui:setLabelText(perRankPermission[i][2], "Skin " .. hex .. rankPermissionsData[i + rankPermScroll][2])
      elseif rankPermissionsData[i + rankPermScroll][1] == "item" then
        seexports.rl_gui:setImageFile(perRankPermission[i][1], seexports.rl_gui:getFaIconFilename("box", 32))
        seexports.rl_gui:setLabelText(perRankPermission[i][2], "Duty item " .. hex .. rankPermissionsData[i + rankPermScroll][2])
      elseif rankPermissionsData[i + rankPermScroll][1] == "permission" then
        seexports.rl_gui:setImageFile(perRankPermission[i][1], seexports.rl_gui:getFaIconFilename("bolt", 32))
        seexports.rl_gui:setLabelText(perRankPermission[i][2], "Jog " .. hex .. rankPermissionsData[i + rankPermScroll][2])
      end
      if not rankPermissionsData[i + rankPermScroll][3] then
        seexports.rl_gui:setImageColor(perRankPermission[i][1], "v4midgrey")
        seexports.rl_gui:setLabelColor(perRankPermission[i][2], "v4midgrey")
      elseif rankPermissionsData[i + rankPermScroll][1] == "skin" then
        seexports.rl_gui:setImageColor(perRankPermission[i][1], "v4purple")
        seexports.rl_gui:setLabelColor(perRankPermission[i][2], "v4purple")
      elseif rankPermissionsData[i + rankPermScroll][1] == "item" then
        seexports.rl_gui:setImageColor(perRankPermission[i][1], "v4orange")
        seexports.rl_gui:setLabelColor(perRankPermission[i][2], "v4orange")
      elseif rankPermissionsData[i + rankPermScroll][1] == "permission" then
        seexports.rl_gui:setImageColor(perRankPermission[i][1], "v4yellow")
        seexports.rl_gui:setLabelColor(perRankPermission[i][2], "v4yellow")
      end
      if perRankPermission[i][4] then
        seexports.rl_gui:setGuiRenderDisabled(perRankPermission[i][4], false)
      end
      if rankPermissionEdit then
        seexports.rl_gui:setGuiRenderDisabled(perRankPermission[i][3], false)
        seexports.rl_gui:setCheckboxChecked(perRankPermission[i][3], rankPermissionsData[i + rankPermScroll][3])
      else
        seexports.rl_gui:setGuiRenderDisabled(perRankPermission[i][3], true)
      end
    else
      seexports.rl_gui:setGuiRenderDisabled(perRankPermission[i][1], true)
      seexports.rl_gui:setGuiRenderDisabled(perRankPermission[i][2], true)
      seexports.rl_gui:setGuiRenderDisabled(perRankPermission[i][3], true)
      if perRankPermission[i][4] then
        seexports.rl_gui:setGuiRenderDisabled(perRankPermission[i][4], true)
      end
    end
  end
end
addEvent("selectGroupRank", false)
addEventHandler("selectGroupRank", getRootElement(), function(button, state, absoluteX, absoluteY, el)
  for i = 1, #rankElements do
    if rankElements[i][1] == el then
      selectedRank = i + rankScroll
      processRanksList()
      processSelectedRank()
      return
    end
  end
end)
addEvent("selectRankColor", false)
addEventHandler("selectRankColor", getRootElement(), function(button, state, absoluteX, absoluteY, el)
  if rankEditColorElements[el] then
    rankEditColor = rankEditColorElements[el]
    seexports.rl_gui:setInputColor(rankNameInput, "v4midgrey", "v4grey2", "v4grey4", "v4grey3", "v4" .. rankEditColor)
  end
end)
addEvent("newGroupRank", false)
addEventHandler("newGroupRank", getRootElement(), function(button, state, absoluteX, absoluteY, el)
  createGroupLoader()
  triggerServerEvent("createNewGroupRank", localPlayer, selectedGroup)
end)
addEvent("moveRankUp", false)
addEventHandler("moveRankUp", getRootElement(), function(button, state, absoluteX, absoluteY, el)
  if groupDatas[selectedGroup] and groupDatas[selectedGroup].ranks[selectedRank] then
    createGroupLoader()
    triggerServerEvent("moveRankUp", localPlayer, selectedGroup, selectedRank)
    selectedRank = selectedRank + 1
  end
end)
addEvent("moveRankDown", false)
addEventHandler("moveRankDown", getRootElement(), function(button, state, absoluteX, absoluteY, el)
  if groupDatas[selectedGroup] and groupDatas[selectedGroup].ranks[selectedRank] then
    if selectedRank > 1 then
      createGroupLoader()
      triggerServerEvent("moveRankDown", localPlayer, selectedGroup, selectedRank)
      selectedRank = selectedRank - 1
    end
  end
end)
addEvent("finalDeleteGroupRank", false)
addEventHandler("finalDeleteGroupRank", getRootElement(), function(button, state, absoluteX, absoluteY, el)
  if groupDatas[selectedGroup] and groupDatas[selectedGroup].ranks[selectedRank] then
    createGroupLoader()
    triggerServerEvent("deleteGroupRank", localPlayer, selectedGroup, selectedRank)
    selectedRank = 1
  end
end)
addEvent("deleteGroupRank", false)
addEventHandler("deleteGroupRank", getRootElement(), function(button, state, absoluteX, absoluteY, el)
  if groupDatas[selectedGroup] and groupDatas[selectedGroup].ranks[selectedRank] then
    groupModal = seexports.rl_gui:createGuiElement("rectangle", 0, 0, screenX, screenY)
    seexports.rl_gui:setGuiBackground(groupModal, "solid", {
      0,
      0,
      0,
      150
    })
    seexports.rl_gui:setGuiHover(groupModal, "none")
    seexports.rl_gui:setGuiHoverable(groupModal, true)
    seexports.rl_gui:disableClickTrough(groupModal, true)
    seexports.rl_gui:disableLinkCursor(groupModal, true)
    local titlebarHeight = seexports.rl_gui:getTitleBarHeight()
    local panelWidth = 375
    local pad = dashboardPadding[3] * 2
    local panelHeight = titlebarHeight + 96
    local window = seexports.rl_gui:createGuiElement("window", screenX / 2 - panelWidth / 2, -panelHeight, panelWidth, panelHeight, groupModal)
    seexports.rl_gui:setWindowTitle(window, "16/BebasNeueRegular.otf", "'" .. (groupDatas[selectedGroup].ranks[selectedRank] or "N/A") .. "' rang törlése")
    local label = seexports.rl_gui:createGuiElement("label", pad, titlebarHeight, panelWidth - pad, panelHeight - titlebarHeight - 24 - pad, window)
    seexports.rl_gui:setLabelFont(label, groupFonts[6])
    seexports.rl_gui:setLabelAlignment(label, "center", "center")
    seexports.rl_gui:setLabelText(label, "Biztosan törölni szeretnéd a rangot?")
    local w = (panelWidth - pad * 3) / 2
    local btn = seexports.rl_gui:createGuiElement("button", pad, panelHeight - 24 - pad, w, 24, window)
    seexports.rl_gui:setGuiBackground(btn, "solid", "v4green")
    seexports.rl_gui:setGuiHover(btn, "gradient", {
      "v4green",
      "v4green-second"
    }, false, true)
    seexports.rl_gui:setButtonFont(btn, groupFonts[1])
    seexports.rl_gui:setButtonText(btn, "Igen")
    seexports.rl_gui:setClickEvent(btn, "finalDeleteGroupRank")
    local btn = seexports.rl_gui:createGuiElement("button", pad + w + pad, panelHeight - 24 - pad, w, 24, window)
    seexports.rl_gui:setGuiBackground(btn, "solid", "v4red")
    seexports.rl_gui:setGuiHover(btn, "gradient", {
      "v4red",
      "v4red-second"
    }, false, true)
    seexports.rl_gui:setButtonFont(btn, groupFonts[1])
    seexports.rl_gui:setButtonText(btn, "Nem")
    seexports.rl_gui:setClickEvent(btn, "closeGroupModal")
    seexports.rl_gui:setGuiPositionAnimated(window, false, screenY / 2 - panelHeight / 2, 250)
  end
end)
addEvent("doneEditingGroupRank", false)
addEventHandler("doneEditingGroupRank", getRootElement(), function(button, state, absoluteX, absoluteY, el)
  local rankName = seexports.rl_gui:getInputValue(rankNameInput) or ""
  local rankSalary = tonumber(seexports.rl_gui:getInputValue(rankSalaryInput)) or 0
  if 100000 < rankSalary then
    seexports.rl_gui:showInfobox("e", "Maximum fizetés: 100 000 $!")
  end
  if rankSalary and 0 <= rankSalary and rankSalary <= 100000 and rankName then
    createGroupLoader()
    triggerServerEvent("editGroupRank", localPlayer, selectedGroup, selectedRank, rankName, rankSalary, rankEditColor)
  end
end)
addEvent("editGroupRank", false)
addEventHandler("editGroupRank", getRootElement(), function(button, state, absoluteX, absoluteY, el)
  if groupDatas[selectedGroup] and groupDatas[selectedGroup].ranks[selectedRank] then
    groupModal = seexports.rl_gui:createGuiElement("rectangle", 0, 0, screenX, screenY)
    seexports.rl_gui:setGuiBackground(groupModal, "solid", {
      0,
      0,
      0,
      150
    })
    seexports.rl_gui:setGuiHover(groupModal, "none")
    seexports.rl_gui:setGuiHoverable(groupModal, true)
    seexports.rl_gui:disableClickTrough(groupModal, true)
    seexports.rl_gui:disableLinkCursor(groupModal, true)
    local titlebarHeight = seexports.rl_gui:getTitleBarHeight()
    local panelWidth = 375
    local pad = dashboardPadding[3] * 2
    local rankColorList = seexports.rl_groups:getRankColorList()
    local w = (panelWidth - pad) / #rankColorList
    local panelHeight = titlebarHeight + pad + (30 + pad) * 2 + w + 24 + pad
    local window = seexports.rl_gui:createGuiElement("window", screenX / 2 - panelWidth / 2, -panelHeight, panelWidth, panelHeight, groupModal)
    seexports.rl_gui:setWindowTitle(window, "16/BebasNeueRegular.otf", "'" .. (groupDatas[selectedGroup].ranks[selectedRank] or "N/A") .. "' rang szerkesztése")
    seexports.rl_gui:setWindowCloseButton(window, "closeGroupModal")
    rankEditColor = groupDatas[selectedGroup].rankColors[selectedRank] or "blue"
    local y = titlebarHeight + pad
    rankNameInput = seexports.rl_gui:createGuiElement("input", pad, y, panelWidth - pad * 2, 30, window)
    seexports.rl_gui:setInputColor(rankNameInput, "v4midgrey", "v4grey2", "v4grey4", "v4grey3", "v4" .. rankEditColor)
    seexports.rl_gui:setInputPlaceholder(rankNameInput, "Rang neve")
    seexports.rl_gui:setInputMaxLength(rankNameInput, 24)
    seexports.rl_gui:setInputIcon(rankNameInput, "id-badge")
    seexports.rl_gui:setInputValue(rankNameInput, groupDatas[selectedGroup].ranks[selectedRank] or "N/A")
    y = y + 30 + pad
    rankEditColorElements = {}
    for i = 1, #rankColorList do
      local rect = seexports.rl_gui:createGuiElement("rectangle", pad + (i - 1) * w, y, w - pad, w - pad, window)
      seexports.rl_gui:setGuiBackground(rect, "solid", "v4" .. rankColorList[i])
      seexports.rl_gui:setGuiHover(rect, "none", false, false, true)
      seexports.rl_gui:setGuiHoverable(rect, true)
      seexports.rl_gui:setClickEvent(rect, "selectRankColor")
      rankEditColorElements[rect] = rankColorList[i]
    end
    y = y + w
    rankSalaryInput = seexports.rl_gui:createGuiElement("input", pad, y, panelWidth - pad * 2, 30, window)
    seexports.rl_gui:setInputColor(rankSalaryInput, "v4midgrey", "v4grey2", "v4grey4", "v4grey3", "v4green")
    seexports.rl_gui:setInputPlaceholder(rankSalaryInput, "Fizetés (Max. 100 000 $)")
    seexports.rl_gui:setInputMaxLength(rankSalaryInput, 20)
    seexports.rl_gui:setInputIcon(rankSalaryInput, "dollar-sign")
    seexports.rl_gui:setInputValue(rankSalaryInput, groupDatas[selectedGroup].salaries[selectedRank] or 0)
    seexports.rl_gui:setInputNumberOnly(rankSalaryInput, true)
    y = y + 30 + pad
    local btn = seexports.rl_gui:createGuiElement("button", pad, y, panelWidth - pad * 2, 24, window)
    seexports.rl_gui:setGuiBackground(btn, "solid", "v4green")
    seexports.rl_gui:setGuiHover(btn, "gradient", {
      "v4green",
      "v4green-second"
    }, false, true)
    seexports.rl_gui:setButtonFont(btn, groupFonts[1])
    seexports.rl_gui:setButtonText(btn, "Szerkesztés")
    seexports.rl_gui:setClickEvent(btn, "doneEditingGroupRank")
    seexports.rl_gui:setGuiPositionAnimated(window, false, screenY / 2 - panelHeight / 2, 250)
  end
end)
function processRanksList()
  local w, h = seexports.rl_gui:getGuiSize(rankBg)
  local n = math.max(0, #groupDatas[selectedGroup].ranks - #rankElements)
  h = h / (n + 1)
  if n < rankScroll then
    rankScroll = n
  end
  seexports.rl_gui:setGuiSize(rankScrollbar, false, h)
  seexports.rl_gui:setGuiPosition(rankScrollbar, false, h * rankScroll)
  for i = 1, #rankElements do
    if groupDatas[selectedGroup].ranks[i + rankScroll] then
      local rect = rankElements[i][1]
      if i + rankScroll == selectedRank then
        seexports.rl_gui:setGuiHoverable(rect, false)
        seexports.rl_gui:setGuiBackground(rect, "solid", "v4grey3")
      else
        seexports.rl_gui:setGuiHoverable(rect, true)
        seexports.rl_gui:setGuiBackground(rect, "solid", "v4grey1")
      end
      local label = rankElements[i][2]
      seexports.rl_gui:setLabelColor(label, "v4" .. (groupDatas[selectedGroup].rankColors[i + rankScroll] or "blue"))
      seexports.rl_gui:setLabelText(label, "[" .. i + rankScroll .. "] " .. groupDatas[selectedGroup].ranks[i + rankScroll])
      local label = rankElements[i][3]
      seexports.rl_gui:setLabelText(label, seexports.rl_gui:thousandsStepper(groupDatas[selectedGroup].salaries[i + rankScroll] or 0) .. " $")
    end
  end
end
function drawGroupRanks()
  local label = seexports.rl_gui:createGuiElement("label", dashboardPadding[3] * 4, 40, 0, 48, groupPanel)
  seexports.rl_gui:setLabelFont(label, groupFonts[3])
  seexports.rl_gui:setLabelAlignment(label, "left", "center")
  seexports.rl_gui:setLabelText(label, "Rangok: " .. #groupDatas[selectedGroup].ranks .. "/" .. seexports.rl_groups:getMaxRanks(selectedGroup))
  if groupDatas[selectedGroup].isLeader and #groupDatas[selectedGroup].ranks < seexports.rl_groups:getMaxRanks(selectedGroup) then
    local btn = seexports.rl_gui:createGuiElement("button", dashboardPadding[3] * 4 + seexports.rl_gui:getLabelTextWidth(label) + dashboardPadding[3] * 2, 52, 100, 24, groupPanel)
    seexports.rl_gui:setGuiBackground(btn, "solid", "v4green")
    seexports.rl_gui:setGuiHover(btn, "gradient", {
      "v4green",
      "v4green-second"
    }, false, true)
    seexports.rl_gui:setButtonFont(btn, groupFonts[1])
    seexports.rl_gui:setButtonText(btn, "Új rang")
    seexports.rl_gui:setClickEvent(btn, "newGroupRank")
  end
  local w = math.ceil((sx - menuW) * 0.45)
  local h = sy - 40 - dashboardPadding[3] * 8 - 48
  rankBg = seexports.rl_gui:createGuiElement("rectangle", dashboardPadding[3] * 4, 88 + dashboardPadding[3] * 4, w, h, groupPanel)
  seexports.rl_gui:setGuiBackground(rankBg, "solid", "v4grey1")
  local sbg = seexports.rl_gui:createGuiElement("rectangle", w - 2, 0, 2, h, rankBg)
  seexports.rl_gui:setGuiBackground(sbg, "solid", "v4grey3")
  rankScrollbar = seexports.rl_gui:createGuiElement("rectangle", w - 2, 0, 2, h, rankBg)
  seexports.rl_gui:setGuiBackground(rankScrollbar, "solid", "v4midgrey")
  local n = math.floor(h / 32)
  h = h / n
  rankElements = {}
  y = 0
  for i = 1, n do
    if groupDatas[selectedGroup].ranks[i] then
      rankElements[i] = {}
      local rect = seexports.rl_gui:createGuiElement("rectangle", 0, y, w - 2, h - 1, rankBg)
      seexports.rl_gui:setGuiBackground(rect, "solid", "v4grey1")
      seexports.rl_gui:setGuiHover(rect, "gradient", {"v4grey1", "v4grey2"}, false, true)
      seexports.rl_gui:setGuiHoverable(rect, true)
      seexports.rl_gui:setClickEvent(rect, "selectGroupRank")
      rankElements[i][1] = rect
      local label = seexports.rl_gui:createGuiElement("label", dashboardPadding[3] * 2, 0, 0, h, rect)
      seexports.rl_gui:setLabelFont(label, groupFonts[4])
      seexports.rl_gui:setLabelAlignment(label, "left", "center")
      rankElements[i][2] = label
      local label = seexports.rl_gui:createGuiElement("label", 0, 0, w - dashboardPadding[3] * 2, h, rect)
      seexports.rl_gui:setLabelFont(label, groupFonts[5])
      seexports.rl_gui:setLabelColor(label, "v4green")
      seexports.rl_gui:setLabelAlignment(label, "right", "center")
      rankElements[i][3] = label
      if i < n then
        local border = seexports.rl_gui:createGuiElement("hr", 0, h - 1, w - 2, 2, rect)
        seexports.rl_gui:setGuiHrColor(border, "v4grey3", "v4grey2")
      end
    end
    y = y + h
  end
  x = dashboardPadding[3] * 4 + w
  y = 88 + dashboardPadding[3] * 4
  local w = sx - menuW - x
  x = x + dashboardPadding[3] * 4
  rankNameLabel = seexports.rl_gui:createGuiElement("label", x, y, w, 0, groupPanel)
  seexports.rl_gui:setLabelFont(rankNameLabel, groupFonts[3])
  seexports.rl_gui:setLabelAlignment(rankNameLabel, "left", "top")
  local h = seexports.rl_gui:getLabelFontHeight(rankNameLabel)
  if groupDatas[selectedGroup].isLeader then
    local ih = h * 0.75
    rankEditButton = seexports.rl_gui:createGuiElement("image", x, y + h / 2 - ih / 2, ih, ih, groupPanel)
    seexports.rl_gui:setImageFile(rankEditButton, seexports.rl_gui:getFaIconFilename("pen", h))
    seexports.rl_gui:setGuiHover(rankEditButton, "solid", "v4green")
    seexports.rl_gui:setGuiHoverable(rankEditButton, true)
    seexports.rl_gui:setClickEvent(rankEditButton, "editGroupRank")
    seexports.rl_gui:guiSetTooltip(rankEditButton, "Rang szerkesztése")
    rankDeleteButton = seexports.rl_gui:createGuiElement("image", x, y + h / 2 - ih / 2, ih, ih, groupPanel)
    seexports.rl_gui:setImageFile(rankDeleteButton, seexports.rl_gui:getFaIconFilename("trash-alt", h))
    seexports.rl_gui:setGuiHover(rankDeleteButton, "solid", "v4red")
    seexports.rl_gui:setGuiHoverable(rankDeleteButton, true)
    seexports.rl_gui:setClickEvent(rankDeleteButton, "deleteGroupRank")
    seexports.rl_gui:guiSetTooltip(rankDeleteButton, "Rang törlése")
    rankUpButton = seexports.rl_gui:createGuiElement("image", x, y + h / 2 - ih / 2, ih, ih, groupPanel)
    seexports.rl_gui:setImageFile(rankUpButton, seexports.rl_gui:getFaIconFilename("level-up-alt", h))
    seexports.rl_gui:setGuiHover(rankUpButton, "solid", "v4green")
    seexports.rl_gui:setGuiHoverable(rankUpButton, true)
    seexports.rl_gui:setClickEvent(rankUpButton, "moveRankUp")
    seexports.rl_gui:guiSetTooltip(rankUpButton, "Rang fentebb mozgatása")
    rankDownButton = seexports.rl_gui:createGuiElement("image", x, y + h / 2 - ih / 2, ih, ih, groupPanel)
    seexports.rl_gui:setImageFile(rankDownButton, seexports.rl_gui:getFaIconFilename("level-down-alt", h))
    seexports.rl_gui:setGuiHover(rankDownButton, "solid", "v4green")
    seexports.rl_gui:setGuiHoverable(rankDownButton, true)
    seexports.rl_gui:setClickEvent(rankDownButton, "moveRankDown")
    seexports.rl_gui:guiSetTooltip(rankDownButton, "Rang lentebb mozgatása")
  else
    rankEditButton = false
    rankDeleteButton = false
    rankUpButton = false
    rankDownButton = false
  end
  y = y + h + dashboardPadding[3] * 2
  local label = seexports.rl_gui:createGuiElement("label", x, y, 0, 0, groupPanel)
  seexports.rl_gui:setLabelFont(label, groupFonts[4])
  seexports.rl_gui:setLabelAlignment(label, "left", "top")
  seexports.rl_gui:setLabelText(label, "Fizetés: ")
  rankSalaryLabel = seexports.rl_gui:createGuiElement("label", x + seexports.rl_gui:getLabelTextWidth(label), y, 0, 0, groupPanel)
  seexports.rl_gui:setLabelFont(rankSalaryLabel, groupFonts[5])
  seexports.rl_gui:setLabelAlignment(rankSalaryLabel, "left", "top")
  seexports.rl_gui:setLabelColor(rankSalaryLabel, "v4green")
  y = y + seexports.rl_gui:getLabelFontHeight(label) + dashboardPadding[3]
  local label = seexports.rl_gui:createGuiElement("label", x, y, 0, 0, groupPanel)
  seexports.rl_gui:setLabelFont(label, groupFonts[4])
  seexports.rl_gui:setLabelAlignment(label, "left", "top")
  seexports.rl_gui:setLabelText(label, "Tagok száma: ")
  rankNumLabel = seexports.rl_gui:createGuiElement("label", x + seexports.rl_gui:getLabelTextWidth(label), y, 0, 0, groupPanel)
  seexports.rl_gui:setLabelFont(rankNumLabel, groupFonts[5])
  seexports.rl_gui:setLabelAlignment(rankNumLabel, "left", "top")
  seexports.rl_gui:setLabelColor(rankNumLabel, "v4green")
  y = y + seexports.rl_gui:getLabelFontHeight(label) + dashboardPadding[3] * 4
  local label = seexports.rl_gui:createGuiElement("label", x, y, 0, 0, groupPanel)
  seexports.rl_gui:setLabelFont(label, groupFonts[2])
  seexports.rl_gui:setLabelAlignment(label, "left", "top")
  seexports.rl_gui:setLabelText(label, "Rang jogosultságai:")
  local h = seexports.rl_gui:getLabelFontHeight(label)
  w = w - dashboardPadding[3] * 4 * 2
  if groupDatas[selectedGroup].isLeader then
    rankPermissionEditButton = seexports.rl_gui:createGuiElement("image", x + w - h, y, h, h, groupPanel)
    seexports.rl_gui:setImageFile(rankPermissionEditButton, seexports.rl_gui:getFaIconFilename("pen", 32))
    seexports.rl_gui:setGuiHover(rankPermissionEditButton, "solid", "v4green")
    seexports.rl_gui:setGuiHoverable(rankPermissionEditButton, true)
    seexports.rl_gui:setClickEvent(rankPermissionEditButton, "editRankPermissions")
    seexports.rl_gui:guiSetTooltip(rankPermissionEditButton, "Rang jogosultságainak szerkesztése")
  else
    rankPermissionEditButton = false
  end
  y = y + h + dashboardPadding[3] * 2
  local h = sy - y - dashboardPadding[3] * 4
  rankPermBg = seexports.rl_gui:createGuiElement("rectangle", x, y, w, h, groupPanel)
  seexports.rl_gui:setGuiBackground(rankPermBg, "solid", "v4grey1")
  local sbg = seexports.rl_gui:createGuiElement("rectangle", w - 2, 0, 2, h, rankPermBg)
  seexports.rl_gui:setGuiBackground(sbg, "solid", "v4grey3")
  rankPermScrollbar = seexports.rl_gui:createGuiElement("rectangle", w - 2, 0, 2, h, rankPermBg)
  seexports.rl_gui:setGuiBackground(rankPermScrollbar, "solid", "v4midgrey")
  local n = math.floor(h / 32)
  h = h / n
  perRankPermission = {}
  for i = 1, n do
    perRankPermission[i] = {}
    local image = seexports.rl_gui:createGuiElement("image", x + dashboardPadding[3], y + dashboardPadding[3] * 2, h - dashboardPadding[3] * 4, h - dashboardPadding[3] * 4, groupPanel)
    perRankPermission[i][1] = image
    local label = seexports.rl_gui:createGuiElement("label", x + h - dashboardPadding[3] * 2 - 2, y, 0, h, groupPanel)
    seexports.rl_gui:setLabelFont(label, groupFonts[4])
    seexports.rl_gui:setLabelAlignment(label, "left", "center")
    perRankPermission[i][2] = label
    local checkbox = seexports.rl_gui:createGuiElement("checkbox", x + w - h - 2, y + 2, h - 4, h - 4, groupPanel)
    seexports.rl_gui:setGuiColorScheme(checkbox, "darker")
    seexports.rl_gui:setClickEvent(checkbox, "selectRankPermissionCheckbox")
    perRankPermission[i][3] = checkbox
    if i < n then
      local border = seexports.rl_gui:createGuiElement("hr", x, y + h - 1, w - 2, 2, groupPanel)
      seexports.rl_gui:setGuiHrColor(border, "v4grey3", "v4grey2")
      perRankPermission[i][4] = border
    end
    y = y + h
  end
  processRanksList()
  processSelectedRank()
end
function processGroupSelectedVehicle()
  vehicleMemberEditing = false
  seexports.rl_gui:setGuiBackground(vehicleMemberButton, "solid", "v4green")
  seexports.rl_gui:setGuiHoverable(vehicleMemberButton, false)
  seexports.rl_gui:setGuiBackground(vehicleDataButton, "solid", "v4grey4")
  seexports.rl_gui:setGuiHoverable(vehicleDataButton, true)
  seexports.rl_gui:setGuiRenderDisabled(vehicleMemberBg, false, true)
  seexports.rl_gui:setGuiRenderDisabled(vehicleDataBg, true, true)
  if selectedVehicle and groupDatas[selectedGroup].gotVehicles[selectedVehicle] then
    vehicleMemberList = {}
    for i = 1, #groupDatas[selectedGroup].members do
      if 1 == 1 then
        member = false
        if groupDatas[selectedGroup].vehicleMembers and groupDatas[selectedGroup].vehicleMembers[selectedVehicle] and groupDatas[selectedGroup].vehicleMembers[selectedVehicle][groupDatas[selectedGroup].members[i][7]] then
          member = true
        end
        table.insert(vehicleMemberList, {
          groupDatas[selectedGroup].members[i][7],
          groupDatas[selectedGroup].members[i][1],
          groupDatas[selectedGroup].members[i][2],
          member
        })
      end
    end
    table.sort(vehicleMemberList, groupVehicleMemberSort)
    local dat = groupDatas[selectedGroup].gotVehicles[selectedVehicle]
    seexports.rl_gui:setLabelText(vehicleNameLabel, "[" .. selectedVehicle .. "] " .. seexports.rl_vehiclenames:getCustomVehicleName(dat[1]))
    local plate = dat[2] or ""
    local tmp = {}
    plate = split(plate, "-")
    for i = 1, #plate do
      if 1 <= utf8.len(plate[i]) then
        table.insert(tmp, plate[i])
      end
    end
    seexports.rl_gui:setLabelText(vehiclePlateLabel, table.concat(tmp, "-"))
    processGroupVehicleMemberList()
  else
    seexports.rl_gui:setLabelText(vehicleNameLabel, "Válassz járművet!")
    seexports.rl_gui:setLabelText(vehiclePlateLabel, "")
    for i = 1, #vehicleMemberElements do
      seexports.rl_gui:setGuiRenderDisabled(vehicleMemberElements[i][1], true)
      seexports.rl_gui:setGuiRenderDisabled(vehicleMemberElements[i][2], true)
      if vehicleMemberElements[i][3] then
        seexports.rl_gui:setGuiRenderDisabled(vehicleMemberElements[i][3], true)
      end
    end
  end
end
function processGroupVehicleList()
  local w, h = seexports.rl_gui:getGuiSize(vehiclesBg)
  local n = math.max(0, #groupDatas[selectedGroup].vehicles - #vehicleElements)
  h = h / (n + 1)
  if n < vehiclesScroll then
    vehiclesScroll = n
  end
  seexports.rl_gui:setGuiSize(vehiclesScrollBar, false, h)
  seexports.rl_gui:setGuiPosition(vehiclesScrollBar, false, h * vehiclesScroll)
  for i = 1, #vehicleElements do
    if groupDatas[selectedGroup].vehicles[i + vehiclesScroll] then
      seexports.rl_gui:setGuiRenderDisabled(vehicleElements[i][1], false)
      seexports.rl_gui:setGuiRenderDisabled(vehicleElements[i][2], false)
      seexports.rl_gui:setGuiRenderDisabled(vehicleElements[i][3], false)
      if vehicleElements[i][4] then
        seexports.rl_gui:setGuiRenderDisabled(vehicleElements[i][4], false)
      end
      if not selectedVehicle then
        selectedVehicle = groupDatas[selectedGroup].vehicles[i + vehiclesScroll][1]
      end
      local rect = vehicleElements[i][1]
      if groupDatas[selectedGroup].vehicles[i + vehiclesScroll][1] == selectedVehicle then
        seexports.rl_gui:setGuiHoverable(rect, true)
        seexports.rl_gui:setGuiHover(rect, "solid", "v4grey3", false, true)
        seexports.rl_gui:setGuiBackground(rect, "solid", "v4grey3")
      else
        seexports.rl_gui:setGuiHoverable(rect, true)
        seexports.rl_gui:setGuiHover(rect, "gradient", {"v4grey1", "v4grey2"}, false, true)
        seexports.rl_gui:setGuiBackground(rect, "solid", "v4grey1")
      end
      local label = vehicleElements[i][2]
      seexports.rl_gui:setLabelText(label, "[" .. groupDatas[selectedGroup].vehicles[i + vehiclesScroll][1] .. "] " .. groupDatas[selectedGroup].vehicles[i + vehiclesScroll][2])
      seexports.rl_gui:setLabelColor(label, groupDatas[selectedGroup].vehicles[i + vehiclesScroll][4] and "v4red-second" or "#ffffff")
      local label = vehicleElements[i][3]
      seexports.rl_gui:setLabelText(label, groupDatas[selectedGroup].vehicles[i + vehiclesScroll][3])
    else
      seexports.rl_gui:setGuiRenderDisabled(vehicleElements[i][1], true)
      seexports.rl_gui:setGuiRenderDisabled(vehicleElements[i][2], true)
      seexports.rl_gui:setGuiRenderDisabled(vehicleElements[i][3], true)
      if vehicleElements[i][4] then
        seexports.rl_gui:setGuiRenderDisabled(vehicleElements[i][4], true)
      end
    end
  end
end

function groupMarker(hit, match)
  if hit == localPlayer and match then
    if getElementData(source, "groupMarker") and getElementData(source, "groupMarker")[1] == localPlayer then
      triggerServerEvent("deleteMark", localPlayer, source, getElementData(source, "groupMarker")[2])
    end
  end
end
-- addEventHandler("onClientMarkerHit", root, groupMarker) --- ramo değiştirdi
addEventHandler("onClientMarkerHit", resourceRoot, groupMarker) --- ramo değiştirdi

addEvent("selectGroupVehicle", false)
addEventHandler("selectGroupVehicle", getRootElement(), function(button, state, absoluteX, absoluteY, el)
  if button == "right" and state == "down" then
    for i = 1, #vehicleElements do
      if vehicleElements[i][1] == el and groupDatas[selectedGroup].vehicles[i + vehiclesScroll] then
        triggerServerEvent("markVehicleOnGPS", localPlayer, groupDatas[selectedGroup].vehicles[i + vehiclesScroll][1])
        return
      end
    end
  else
    for i = 1, #vehicleElements do
      if vehicleElements[i][1] == el and groupDatas[selectedGroup].vehicles[i + vehiclesScroll] then
        selectedVehicle = groupDatas[selectedGroup].vehicles[i + vehiclesScroll][1]
        vehicleMemberScroll = 0
        processGroupVehicleList()
        processGroupSelectedVehicle()
        return
      end
    end
  end
end)
addEvent("setGroupVehicleDataPanel", false)
addEventHandler("setGroupVehicleDataPanel", getRootElement(), function(button, state, absoluteX, absoluteY, el)
  seexports.rl_gui:setGuiBackground(vehicleDataButton, "solid", "v4green")
  seexports.rl_gui:setGuiHoverable(vehicleDataButton, false)
  seexports.rl_gui:setGuiBackground(vehicleMemberButton, "solid", "v4grey4")
  seexports.rl_gui:setGuiHoverable(vehicleMemberButton, true)
  seexports.rl_gui:setGuiRenderDisabled(vehicleDataBg, false, true)
  seexports.rl_gui:setGuiRenderDisabled(vehicleMemberBg, true, true)
  seexports.rl_gui:deleteAllChildren(vehicleDataBg)
  if selectedVehicle then
    createGroupLoader()
    triggerLatentServerEvent("requestVehicleGroupData", localPlayer, selectedGroup, selectedVehicle)
  end
end)
addEvent("gotGroupVehicleDatas", true)
addEventHandler("gotGroupVehicleDatas", getRootElement(), function(vehicleId, datas)
  deleteGroupLoader()
  if vehicleId == selectedVehicle and vehicleDataBg then
    seexports.rl_gui:deleteAllChildren(vehicleDataBg)
    local x = dashboardPadding[3] * 2
    local y = dashboardPadding[3] * 2
    if datas.impounded then
      local label = seexports.rl_gui:createGuiElement("label", x, y, 0, 0, vehicleDataBg)
      seexports.rl_gui:setLabelFont(label, groupFonts[4])
      seexports.rl_gui:setLabelAlignment(label, "left", "top")
      seexports.rl_gui:setLabelText(label, "Lefoglalva: ")
      local label = seexports.rl_gui:createGuiElement("label", x + seexports.rl_gui:getLabelTextWidth(label), y, 0, 0, vehicleDataBg)
      seexports.rl_gui:setLabelFont(label, groupFonts[5])
      seexports.rl_gui:setLabelAlignment(label, "left", "top")
      seexports.rl_gui:setLabelText(label, getVehLabelValue(datas, "impounded"))
      y = y + seexports.rl_gui:getLabelFontHeight(label) + dashboardPadding[3]
    end
    if datas.inService then
      local label = seexports.rl_gui:createGuiElement("label", x, y, 0, 0, vehicleDataBg)
      seexports.rl_gui:setLabelFont(label, groupFonts[4])
      seexports.rl_gui:setLabelAlignment(label, "left", "top")
      seexports.rl_gui:setLabelText(label, "Motor szerviz: ")
      local label = seexports.rl_gui:createGuiElement("label", x + seexports.rl_gui:getLabelTextWidth(label), y, 0, 0, vehicleDataBg)
      seexports.rl_gui:setLabelFont(label, groupFonts[5])
      seexports.rl_gui:setLabelAlignment(label, "left", "top")
      seexports.rl_gui:setLabelText(label, getVehLabelValue(datas, "inService"))
      y = y + seexports.rl_gui:getLabelFontHeight(label) + dashboardPadding[3]
    end
    local label = seexports.rl_gui:createGuiElement("label", x, y, 0, 0, vehicleDataBg)
    seexports.rl_gui:setLabelFont(label, groupFonts[4])
    seexports.rl_gui:setLabelAlignment(label, "left", "top")
    seexports.rl_gui:setLabelText(label, "Motor: ")
    local label = seexports.rl_gui:createGuiElement("label", x + seexports.rl_gui:getLabelTextWidth(label), y, 0, 0, vehicleDataBg)
    seexports.rl_gui:setLabelFont(label, groupFonts[5])
    seexports.rl_gui:setLabelAlignment(label, "left", "top")
    seexports.rl_gui:setLabelText(label, getVehLabelValue(datas, "engine"))
    y = y + seexports.rl_gui:getLabelFontHeight(label) + dashboardPadding[3]
    local label = seexports.rl_gui:createGuiElement("label", x, y, 0, 0, vehicleDataBg)
    seexports.rl_gui:setLabelFont(label, groupFonts[4])
    seexports.rl_gui:setLabelAlignment(label, "left", "top")
    seexports.rl_gui:setLabelText(label, "Akkumulátor: ")
    local label = seexports.rl_gui:createGuiElement("label", x + seexports.rl_gui:getLabelTextWidth(label), y, 0, 0, vehicleDataBg)
    seexports.rl_gui:setLabelFont(label, groupFonts[5])
    seexports.rl_gui:setLabelAlignment(label, "left", "top")
    seexports.rl_gui:setLabelText(label, getVehLabelValue(datas, "battery"))
    y = y + seexports.rl_gui:getLabelFontHeight(label) + dashboardPadding[3]
    local label = seexports.rl_gui:createGuiElement("label", x, y, 0, 0, vehicleDataBg)
    seexports.rl_gui:setLabelFont(label, groupFonts[4])
    seexports.rl_gui:setLabelAlignment(label, "left", "top")
    seexports.rl_gui:setLabelText(label, "Kilóméteróra állása: ")
    local label = seexports.rl_gui:createGuiElement("label", x + seexports.rl_gui:getLabelTextWidth(label), y, 0, 0, vehicleDataBg)
    seexports.rl_gui:setLabelFont(label, groupFonts[5])
    seexports.rl_gui:setLabelAlignment(label, "left", "top")
    seexports.rl_gui:setLabelText(label, getVehLabelValue(datas, "odometer"))
    y = y + seexports.rl_gui:getLabelFontHeight(label) + dashboardPadding[3]
    local label = seexports.rl_gui:createGuiElement("label", x, y, 0, 0, vehicleDataBg)
    seexports.rl_gui:setLabelFont(label, groupFonts[4])
    seexports.rl_gui:setLabelAlignment(label, "left", "top")
    seexports.rl_gui:setLabelText(label, "Üzemanyag: ")
    local label = seexports.rl_gui:createGuiElement("label", x + seexports.rl_gui:getLabelTextWidth(label), y, 0, 0, vehicleDataBg)
    seexports.rl_gui:setLabelFont(label, groupFonts[5])
    seexports.rl_gui:setLabelAlignment(label, "left", "top")
    seexports.rl_gui:setLabelText(label, getVehLabelValue(datas, "fuel"))
    y = y + seexports.rl_gui:getLabelFontHeight(label) + dashboardPadding[3]
    local label = seexports.rl_gui:createGuiElement("label", x, y, 0, 0, vehicleDataBg)
    seexports.rl_gui:setLabelFont(label, groupFonts[4])
    seexports.rl_gui:setLabelAlignment(label, "left", "top")
    seexports.rl_gui:setLabelText(label, "Meghajtás: ")
    local label = seexports.rl_gui:createGuiElement("label", x + seexports.rl_gui:getLabelTextWidth(label), y, 0, 0, vehicleDataBg)
    seexports.rl_gui:setLabelFont(label, groupFonts[5])
    seexports.rl_gui:setLabelAlignment(label, "left", "top")
    seexports.rl_gui:setLabelText(label, getVehLabelValue(datas, "driveType"))
    y = y + seexports.rl_gui:getLabelFontHeight(label) + dashboardPadding[3]
    local label = seexports.rl_gui:createGuiElement("label", x, y, 0, 0, vehicleDataBg)
    seexports.rl_gui:setLabelFont(label, groupFonts[4])
    seexports.rl_gui:setLabelAlignment(label, "left", "top")
    seexports.rl_gui:setLabelText(label, "Motor: ")
    local label = seexports.rl_gui:createGuiElement("label", x + seexports.rl_gui:getLabelTextWidth(label), y, 0, 0, vehicleDataBg)
    seexports.rl_gui:setLabelFont(label, groupFonts[5])
    seexports.rl_gui:setLabelAlignment(label, "left", "top")
    seexports.rl_gui:setLabelText(label, getVehLabelValue(datas, "performance.engine"))
    y = y + seexports.rl_gui:getLabelFontHeight(label) + dashboardPadding[3]
    local label = seexports.rl_gui:createGuiElement("label", x, y, 0, 0, vehicleDataBg)
    seexports.rl_gui:setLabelFont(label, groupFonts[4])
    seexports.rl_gui:setLabelAlignment(label, "left", "top")
    seexports.rl_gui:setLabelText(label, "Turbó: ")
    local label = seexports.rl_gui:createGuiElement("label", x + seexports.rl_gui:getLabelTextWidth(label), y, 0, 0, vehicleDataBg)
    seexports.rl_gui:setLabelFont(label, groupFonts[5])
    seexports.rl_gui:setLabelAlignment(label, "left", "top")
    seexports.rl_gui:setLabelText(label, getVehLabelValue(datas, "performance.turbo"))
    y = y + seexports.rl_gui:getLabelFontHeight(label) + dashboardPadding[3]
    local label = seexports.rl_gui:createGuiElement("label", x, y, 0, 0, vehicleDataBg)
    seexports.rl_gui:setLabelFont(label, groupFonts[4])
    seexports.rl_gui:setLabelAlignment(label, "left", "top")
    seexports.rl_gui:setLabelText(label, "ECU: ")
    local label = seexports.rl_gui:createGuiElement("label", x + seexports.rl_gui:getLabelTextWidth(label), y, 0, 0, vehicleDataBg)
    seexports.rl_gui:setLabelFont(label, groupFonts[5])
    seexports.rl_gui:setLabelAlignment(label, "left", "top")
    seexports.rl_gui:setLabelText(label, getVehLabelValue(datas, "performance.ecu"))
    y = y + seexports.rl_gui:getLabelFontHeight(label) + dashboardPadding[3]
    local label = seexports.rl_gui:createGuiElement("label", x, y, 0, 0, vehicleDataBg)
    seexports.rl_gui:setLabelFont(label, groupFonts[4])
    seexports.rl_gui:setLabelAlignment(label, "left", "top")
    seexports.rl_gui:setLabelText(label, "Váltó: ")
    local label = seexports.rl_gui:createGuiElement("label", x + seexports.rl_gui:getLabelTextWidth(label), y, 0, 0, vehicleDataBg)
    seexports.rl_gui:setLabelFont(label, groupFonts[5])
    seexports.rl_gui:setLabelAlignment(label, "left", "top")
    seexports.rl_gui:setLabelText(label, getVehLabelValue(datas, "performance.transmission"))
    y = y + seexports.rl_gui:getLabelFontHeight(label) + dashboardPadding[3]
    local label = seexports.rl_gui:createGuiElement("label", x, y, 0, 0, vehicleDataBg)
    seexports.rl_gui:setLabelFont(label, groupFonts[4])
    seexports.rl_gui:setLabelAlignment(label, "left", "top")
    seexports.rl_gui:setLabelText(label, "Felfüggesztés: ")
    local label = seexports.rl_gui:createGuiElement("label", x + seexports.rl_gui:getLabelTextWidth(label), y, 0, 0, vehicleDataBg)
    seexports.rl_gui:setLabelFont(label, groupFonts[5])
    seexports.rl_gui:setLabelAlignment(label, "left", "top")
    seexports.rl_gui:setLabelText(label, getVehLabelValue(datas, "performance.suspension"))
    y = y + seexports.rl_gui:getLabelFontHeight(label) + dashboardPadding[3]
    local label = seexports.rl_gui:createGuiElement("label", x, y, 0, 0, vehicleDataBg)
    seexports.rl_gui:setLabelFont(label, groupFonts[4])
    seexports.rl_gui:setLabelAlignment(label, "left", "top")
    seexports.rl_gui:setLabelText(label, "Fék: ")
    local label = seexports.rl_gui:createGuiElement("label", x + seexports.rl_gui:getLabelTextWidth(label), y, 0, 0, vehicleDataBg)
    seexports.rl_gui:setLabelFont(label, groupFonts[5])
    seexports.rl_gui:setLabelAlignment(label, "left", "top")
    seexports.rl_gui:setLabelText(label, getVehLabelValue(datas, "performance.brake"))
    y = y + seexports.rl_gui:getLabelFontHeight(label) + dashboardPadding[3]
    local label = seexports.rl_gui:createGuiElement("label", x, y, 0, 0, vehicleDataBg)
    seexports.rl_gui:setLabelFont(label, groupFonts[4])
    seexports.rl_gui:setLabelAlignment(label, "left", "top")
    seexports.rl_gui:setLabelText(label, "Gumik: ")
    local label = seexports.rl_gui:createGuiElement("label", x + seexports.rl_gui:getLabelTextWidth(label), y, 0, 0, vehicleDataBg)
    seexports.rl_gui:setLabelFont(label, groupFonts[5])
    seexports.rl_gui:setLabelAlignment(label, "left", "top")
    seexports.rl_gui:setLabelText(label, getVehLabelValue(datas, "performance.tire"))
    y = y + seexports.rl_gui:getLabelFontHeight(label) + dashboardPadding[3]
    local label = seexports.rl_gui:createGuiElement("label", x, y, 0, 0, vehicleDataBg)
    seexports.rl_gui:setLabelFont(label, groupFonts[4])
    seexports.rl_gui:setLabelAlignment(label, "left", "top")
    seexports.rl_gui:setLabelText(label, "Súlycsökkentés: ")
    local label = seexports.rl_gui:createGuiElement("label", x + seexports.rl_gui:getLabelTextWidth(label), y, 0, 0, vehicleDataBg)
    seexports.rl_gui:setLabelFont(label, groupFonts[5])
    seexports.rl_gui:setLabelAlignment(label, "left", "top")
    seexports.rl_gui:setLabelText(label, getVehLabelValue(datas, "performance.weightReduction"))
    y = y + seexports.rl_gui:getLabelFontHeight(label) + dashboardPadding[3]
    local label = seexports.rl_gui:createGuiElement("label", x, y, 0, 0, vehicleDataBg)
    seexports.rl_gui:setLabelFont(label, groupFonts[4])
    seexports.rl_gui:setLabelAlignment(label, "left", "top")
    seexports.rl_gui:setLabelText(label, "Hasmagasság: ")
    local label = seexports.rl_gui:createGuiElement("label", x + seexports.rl_gui:getLabelTextWidth(label), y, 0, 0, vehicleDataBg)
    seexports.rl_gui:setLabelFont(label, groupFonts[5])
    seexports.rl_gui:setLabelAlignment(label, "left", "top")
    seexports.rl_gui:setLabelText(label, getVehLabelValue(datas, "rideTuning"))
    y = y + seexports.rl_gui:getLabelFontHeight(label) + dashboardPadding[3]
    local label = seexports.rl_gui:createGuiElement("label", x, y, 0, 0, vehicleDataBg)
    seexports.rl_gui:setLabelFont(label, groupFonts[4])
    seexports.rl_gui:setLabelAlignment(label, "left", "top")
    seexports.rl_gui:setLabelText(label, "Nitro: ")
    local label = seexports.rl_gui:createGuiElement("label", x + seexports.rl_gui:getLabelTextWidth(label), y, 0, 0, vehicleDataBg)
    seexports.rl_gui:setLabelFont(label, groupFonts[5])
    seexports.rl_gui:setLabelAlignment(label, "left", "top")
    seexports.rl_gui:setLabelText(label, getVehLabelValue(datas, "nitro"))
    y = y + seexports.rl_gui:getLabelFontHeight(label) + dashboardPadding[3]
  end
end)
addEvent("setGroupVehicleMemberPanel", false)
addEventHandler("setGroupVehicleMemberPanel", getRootElement(), function(button, state, absoluteX, absoluteY, el)
  seexports.rl_gui:setGuiBackground(vehicleMemberButton, "solid", "v4green")
  seexports.rl_gui:setGuiHoverable(vehicleMemberButton, false)
  seexports.rl_gui:setGuiBackground(vehicleDataButton, "solid", "v4grey4")
  seexports.rl_gui:setGuiHoverable(vehicleDataButton, true)
  seexports.rl_gui:setGuiRenderDisabled(vehicleMemberBg, false, true)
  seexports.rl_gui:setGuiRenderDisabled(vehicleDataBg, true, true)
  processGroupVehicleMemberList()
end)
addEvent("doneEditVehicleMembers", false)
addEventHandler("doneEditVehicleMembers", getRootElement(), function(button, state, absoluteX, absoluteY, el)
  seexports.rl_gui:deleteGuiElement(el)
  createGroupLoader()
  local members = {}
  for i = 1, #vehicleMemberList do
    if vehicleMemberList[i] and vehicleMemberList[i][4] then
      table.insert(members, vehicleMemberList[i][1])
    end
  end
  triggerLatentServerEvent("editGroupVehicleMembers", localPlayer, selectedGroup, selectedVehicle, members)
end)
addEvent("selectVehicleMemberCheckbox", false)
addEventHandler("selectVehicleMemberCheckbox", getRootElement(), function(button, state, absoluteX, absoluteY, el)
  for i = 1, #vehicleMemberElements do
    if vehicleMemberElements[i][3] == el then
      if vehicleMemberList[i + vehicleMemberScroll] then
        vehicleMemberList[i + vehicleMemberScroll][4] = seexports.rl_gui:isCheckboxChecked(el)
        processGroupVehicleMemberList()
      end
      return
    end
  end
end)
addEvent("editVehicleMembers", false)
addEventHandler("editVehicleMembers", getRootElement(), function(button, state, absoluteX, absoluteY, el)
  if selectedVehicle and groupDatas[selectedGroup].gotVehicles[selectedVehicle] then
    seexports.rl_gui:setGuiHoverable(vehicleMemberButton, false)
    seexports.rl_gui:setGuiHoverable(vehicleDataButton, false)
    vehicleMemberEditing = true
    table.sort(vehicleMemberList, groupVehicleMemberSortEx)
    processGroupVehicleMemberList()
    seexports.rl_gui:setImageFile(vehicleMemberEditButton, seexports.rl_gui:getFaIconFilename("save", 32))
    seexports.rl_gui:setClickEvent(vehicleMemberEditButton, "doneEditVehicleMembers")
  end
end)
function processGroupVehicleMemberList()
  local w, h = seexports.rl_gui:getGuiSize(vehicleMemberBg)
  local n = math.max(0, #vehicleMemberList - #vehicleMemberElements)
  h = h / (n + 1)
  if n < vehicleMemberScroll then
    vehicleMemberScroll = n
  end
  seexports.rl_gui:setGuiSize(vehicleMemberScrollBar, false, h)
  seexports.rl_gui:setGuiPosition(vehicleMemberScrollBar, false, h * vehicleMemberScroll)
  for i = 1, #vehicleMemberElements do
    if vehicleMemberList[i + vehicleMemberScroll] then
      local hasPerm = vehicleMemberList[i + vehicleMemberScroll][4]
      seexports.rl_gui:setGuiRenderDisabled(vehicleMemberElements[i][1], false)
      seexports.rl_gui:setGuiRenderDisabled(vehicleMemberElements[i][2], false)
      local label = vehicleMemberElements[i][1]
      seexports.rl_gui:setLabelText(label, vehicleMemberList[i + vehicleMemberScroll][2])
      local w, h = seexports.rl_gui:getGuiSize(label)
      seexports.rl_gui:setLabelColor(label, hasPerm and "#ffffff" or "v4midgrey")
      local label = vehicleMemberElements[i][2]
      local rank = vehicleMemberList[i + vehicleMemberScroll][3]
      seexports.rl_gui:setLabelColor(label, hasPerm and "v4" .. (groupDatas[selectedGroup].rankColors[rank] or "blue") or "v4midgrey")
      seexports.rl_gui:setLabelText(label, (groupDatas[selectedGroup].ranks[rank] or "N/A") .. " [" .. rank .. "]")
      local checkbox = vehicleMemberElements[i][3]
      if vehicleMemberEditing then
        seexports.rl_gui:setGuiRenderDisabled(checkbox, false)
        seexports.rl_gui:setCheckboxChecked(checkbox, hasPerm)
        seexports.rl_gui:setGuiSize(label, w - h, false)
      else
        seexports.rl_gui:setGuiRenderDisabled(checkbox, true)
        seexports.rl_gui:setGuiSize(label, w, false)
      end
      if vehicleMemberElements[i][4] then
        seexports.rl_gui:setGuiRenderDisabled(vehicleMemberElements[i][4], false)
      end
    else
      seexports.rl_gui:setGuiRenderDisabled(vehicleMemberElements[i][1], true)
      seexports.rl_gui:setGuiRenderDisabled(vehicleMemberElements[i][2], true)
      seexports.rl_gui:setGuiRenderDisabled(vehicleMemberElements[i][3], true)
      if vehicleMemberElements[i][4] then
        seexports.rl_gui:setGuiRenderDisabled(vehicleMemberElements[i][4], true)
      end
    end
  end
end
function drawGroupVehicles()
  local label = seexports.rl_gui:createGuiElement("label", dashboardPadding[3] * 4, 40, 0, 48, groupPanel)
  seexports.rl_gui:setLabelFont(label, groupFonts[3])
  seexports.rl_gui:setLabelAlignment(label, "left", "center")
  seexports.rl_gui:setLabelText(label, "Araçlar: " .. #groupDatas[selectedGroup].vehicles)
  local w = math.ceil((sx - menuW) * 0.45)
  local h = sy - 40 - dashboardPadding[3] * 8 - 48
  vehiclesBg = seexports.rl_gui:createGuiElement("rectangle", dashboardPadding[3] * 4, 88 + dashboardPadding[3] * 4, w, h, groupPanel)
  seexports.rl_gui:setGuiBackground(vehiclesBg, "solid", "v4grey1")
  local sbg = seexports.rl_gui:createGuiElement("rectangle", w - 2, 0, 2, h, vehiclesBg)
  seexports.rl_gui:setGuiBackground(sbg, "solid", "v4grey3")
  vehiclesScrollBar = seexports.rl_gui:createGuiElement("rectangle", w - 2, 0, 2, h, vehiclesBg)
  seexports.rl_gui:setGuiBackground(vehiclesScrollBar, "solid", "v4midgrey")
  local n = math.floor(h / 32)
  h = h / n
  vehicleElements = {}
  y = 0
  for i = 1, n do
    if groupDatas[selectedGroup].vehicles[i] then
      vehicleElements[i] = {}
      local rect = seexports.rl_gui:createGuiElement("rectangle", 0, y, w - 2, h - 1, vehiclesBg)
      seexports.rl_gui:setGuiBackground(rect, "solid", "v4grey1")
      seexports.rl_gui:setGuiHover(rect, "gradient", {"v4grey1", "v4grey2"}, false, true)
      seexports.rl_gui:setGuiHoverable(rect, true)
      seexports.rl_gui:setClickEvent(rect, "selectGroupVehicle")
      vehicleElements[i][1] = rect
      local label = seexports.rl_gui:createGuiElement("label", dashboardPadding[3] * 2, 0, 0, h, rect)
      seexports.rl_gui:setLabelFont(label, groupFonts[4])
      seexports.rl_gui:setLabelAlignment(label, "left", "center")
      vehicleElements[i][2] = label
      local label = seexports.rl_gui:createGuiElement("label", 0, 0, w - dashboardPadding[3] * 2, h, rect)
      seexports.rl_gui:setLabelFont(label, groupFonts[5])
      seexports.rl_gui:setLabelColor(label, "v4blue")
      seexports.rl_gui:setLabelAlignment(label, "right", "center")
      vehicleElements[i][3] = label
      if i < n then
        local border = seexports.rl_gui:createGuiElement("hr", 0, h - 1, w - 2, 2, rect)
        seexports.rl_gui:setGuiHrColor(border, "v4grey3", "v4grey2")
        vehicleElements[i][4] = border
      end
    end
    y = y + h
  end
  x = dashboardPadding[3] * 4 + w
  y = 88 + dashboardPadding[3] * 4
  local w = sx - menuW - x
  x = x + dashboardPadding[3] * 4
  vehicleNameLabel = seexports.rl_gui:createGuiElement("label", x, y, w, 0, groupPanel)
  seexports.rl_gui:setLabelFont(vehicleNameLabel, groupFonts[3])
  seexports.rl_gui:setLabelAlignment(vehicleNameLabel, "left", "top")
  y = y + seexports.rl_gui:getLabelFontHeight(label) + dashboardPadding[3] * 2
  local label = seexports.rl_gui:createGuiElement("label", x, y, 0, 0, groupPanel)
  seexports.rl_gui:setLabelFont(label, groupFonts[4])
  seexports.rl_gui:setLabelAlignment(label, "left", "top")
  seexports.rl_gui:setLabelText(label, "Rendszám: ")
  vehiclePlateLabel = seexports.rl_gui:createGuiElement("label", x + seexports.rl_gui:getLabelTextWidth(label), y, 0, 0, groupPanel)
  seexports.rl_gui:setLabelFont(vehiclePlateLabel, groupFonts[5])
  seexports.rl_gui:setLabelAlignment(vehiclePlateLabel, "left", "top")
  seexports.rl_gui:setLabelColor(vehiclePlateLabel, "v4blue")
  y = y + seexports.rl_gui:getLabelFontHeight(label) + dashboardPadding[3]
  y = y + dashboardPadding[3] * 2 + 24
  w = w - dashboardPadding[3] * 4 * 2
  local h = sy - y - dashboardPadding[3] * 4
  vehicleSidePanel = seexports.rl_gui:createGuiElement("rectangle", x, y, w, h, groupPanel)
  seexports.rl_gui:setGuiBackground(vehicleSidePanel, "solid", "v4grey1")
  vehicleMemberButton = seexports.rl_gui:createGuiElement("button", 0, -24, w / 2, 24, vehicleSidePanel)
  seexports.rl_gui:setGuiBackground(vehicleMemberButton, "solid", "v4green")
  seexports.rl_gui:setGuiHover(vehicleMemberButton, "gradient", {"v4grey4", "v4grey3"}, false, true)
  seexports.rl_gui:setGuiHoverable(vehicleMemberButton, false)
  seexports.rl_gui:setButtonFont(vehicleMemberButton, groupFonts[1])
  seexports.rl_gui:setButtonTextColor(vehicleMemberButton, "#ffffff")
  seexports.rl_gui:setButtonText(vehicleMemberButton, " Tagok")
  seexports.rl_gui:setButtonIcon(vehicleMemberButton, seexports.rl_gui:getFaIconFilename("users", 24))
  seexports.rl_gui:setClickEvent(vehicleMemberButton, "setGroupVehicleMemberPanel")
  vehicleDataButton = seexports.rl_gui:createGuiElement("button", w / 2, -24, w / 2, 24, vehicleSidePanel)
  seexports.rl_gui:setGuiBackground(vehicleDataButton, "solid", "v4grey4")
  seexports.rl_gui:setGuiHover(vehicleDataButton, "gradient", {"v4grey4", "v4grey3"}, false, true)
  seexports.rl_gui:setClickEvent(vehicleDataButton, "switchGroupPanelMenu")
  seexports.rl_gui:setButtonFont(vehicleDataButton, groupFonts[1])
  seexports.rl_gui:setButtonTextColor(vehicleDataButton, "#ffffff")
  seexports.rl_gui:setButtonText(vehicleDataButton, " Adatok")
  seexports.rl_gui:setButtonIcon(vehicleDataButton, seexports.rl_gui:getFaIconFilename("list", 24))
  seexports.rl_gui:setClickEvent(vehicleDataButton, "setGroupVehicleDataPanel")
  local n = math.floor(h / 32)
  h = h / n
  n = n - 1
  y = y + h
  vehicleDataBg = seexports.rl_gui:createGuiElement("rectangle", x, y - h, w, h * (n + 1), groupPanel)
  seexports.rl_gui:setGuiBackground(vehicleDataBg, "solid", "v4grey1")
  seexports.rl_gui:setGuiRenderDisabled(vehicleDataBg, true, true)
  vehicleMemberBg = seexports.rl_gui:createGuiElement("rectangle", x, y, w, h * n, groupPanel)
  seexports.rl_gui:setGuiBackground(vehicleMemberBg, "solid", "v4grey1")
  local label = seexports.rl_gui:createGuiElement("label", dashboardPadding[3] * 2, -h, 0, h, vehicleMemberBg)
  seexports.rl_gui:setLabelFont(label, groupFonts[4])
  seexports.rl_gui:setLabelAlignment(label, "left", "center")
  seexports.rl_gui:setLabelText(label, "Tagok:")
  local lh = seexports.rl_gui:getLabelFontHeight(label)
  if groupDatas[selectedGroup].isLeader or seexports.rl_groups:getPlayerPermissionInGroup(selectedGroup, "manageKeysVehicle") then
    vehicleMemberEditButton = seexports.rl_gui:createGuiElement("image", w - h, -h / 2 - lh / 2, lh, lh, vehicleMemberBg)
    seexports.rl_gui:setImageFile(vehicleMemberEditButton, seexports.rl_gui:getFaIconFilename("pen", 32))
    seexports.rl_gui:setGuiHover(vehicleMemberEditButton, "solid", "v4green")
    seexports.rl_gui:setGuiHoverable(vehicleMemberEditButton, true)
    seexports.rl_gui:setClickEvent(vehicleMemberEditButton, "editVehicleMembers")
    seexports.rl_gui:guiSetTooltip(vehicleMemberEditButton, "Jármű jogosultságainak szerkesztése")
  else
    vehicleMemberEditButton = false
  end
  local border = seexports.rl_gui:createGuiElement("hr", 0, -1, w, 2, vehicleMemberBg)
  seexports.rl_gui:setGuiHrColor(border, "v4grey3", "v4grey2")
  local sbg = seexports.rl_gui:createGuiElement("rectangle", w - 2, 0, 2, h * n, vehicleMemberBg)
  seexports.rl_gui:setGuiBackground(sbg, "solid", "v4grey3")
  vehicleMemberScrollBar = seexports.rl_gui:createGuiElement("rectangle", w - 2, 0, 2, h * n, vehicleMemberBg)
  seexports.rl_gui:setGuiBackground(vehicleMemberScrollBar, "solid", "v4midgrey")
  vehicleMemberElements = {}
  y = 0
  for i = 1, n do
    vehicleMemberElements[i] = {}
    local label = seexports.rl_gui:createGuiElement("label", dashboardPadding[3] * 2, y, w - dashboardPadding[3] * 2 - 2, h, vehicleMemberBg)
    seexports.rl_gui:setLabelFont(label, groupFonts[4])
    seexports.rl_gui:setLabelAlignment(label, "left", "center")
    vehicleMemberElements[i][1] = label
    local label = seexports.rl_gui:createGuiElement("label", 0, y, 0, h, vehicleMemberBg)
    seexports.rl_gui:setLabelFont(label, groupFonts[5])
    seexports.rl_gui:setLabelAlignment(label, "right", "center")
    vehicleMemberElements[i][2] = label
    local checkbox = seexports.rl_gui:createGuiElement("checkbox", 0 + w - h - 2, y + 2, h - 4, h - 4, vehicleMemberBg)
    seexports.rl_gui:setGuiColorScheme(checkbox, "darker")
    seexports.rl_gui:setClickEvent(checkbox, "selectVehicleMemberCheckbox")
    vehicleMemberElements[i][3] = checkbox
    if n > i then
      local border = seexports.rl_gui:createGuiElement("hr", 0, y + h - 1, w - 2, 2, vehicleMemberBg)
      seexports.rl_gui:setGuiHrColor(border, "v4grey3", "v4grey2")
      vehicleMemberElements[i][4] = border
    end
    y = y + h
  end
  processGroupVehicleList()
  processGroupSelectedVehicle()
end
function processGroupSelectedInterior()
  interiorMemberEditing = false
  seexports.rl_gui:setGuiBackground(interiorMemberButton, "solid", "v4green")
  seexports.rl_gui:setGuiHoverable(interiorMemberButton, false)
  seexports.rl_gui:setGuiBackground(interiorDataButton, "solid", "v4grey4")
  seexports.rl_gui:setGuiHoverable(interiorDataButton, true)
  seexports.rl_gui:setGuiRenderDisabled(interiorMemberBg, false, true)
  seexports.rl_gui:setGuiRenderDisabled(interiorDataBg, true, true)
  if selectedInterior and groupDatas[selectedGroup].interiorMembers[selectedInterior] then
    interiorMemberList = {}
    for i = 1, #groupDatas[selectedGroup].members do
      if not groupDatas[selectedGroup].members[i][3] then
        table.insert(interiorMemberList, {
          groupDatas[selectedGroup].members[i][7],
          groupDatas[selectedGroup].members[i][1],
          groupDatas[selectedGroup].members[i][2],
          groupDatas[selectedGroup].interiorMembers[selectedInterior][groupDatas[selectedGroup].members[i][7]]
        })
      end
    end
    table.sort(interiorMemberList, groupVehicleMemberSort)
    seexports.rl_gui:setLabelText(interiorNameLabel, "[" .. selectedInterior .. "] " .. seexports.rl_interiors:getInteriorName(selectedInterior))
    seexports.rl_gui:setLabelText(interiorTypeLabel, seexports.rl_interiors:getInteriorTypeName(seexports.rl_interiors:getInteriorType(selectedInterior)))
    processGroupInteriorMemberList()
  else
    seexports.rl_gui:setLabelText(interiorNameLabel, "Válassz interiort!")
    seexports.rl_gui:setLabelText(interiorTypeLabel, "")
    for i = 1, #interiorMemberElements do
      seexports.rl_gui:setGuiRenderDisabled(interiorMemberElements[i][1], true)
      seexports.rl_gui:setGuiRenderDisabled(interiorMemberElements[i][2], true)
      if interiorMemberElements[i][3] then
        seexports.rl_gui:setGuiRenderDisabled(interiorMemberElements[i][3], true)
      end
    end
  end
end
function processGroupInteriorList()
  local w, h = seexports.rl_gui:getGuiSize(interiorsBg)
  local n = math.max(0, #groupInteriors - #interiorElements)
  h = h / (n + 1)
  if n < interiorsScroll then
    interiorsScroll = n
  end
  seexports.rl_gui:setGuiSize(interiorsScrollBar, false, h)
  seexports.rl_gui:setGuiPosition(interiorsScrollBar, false, h * interiorsScroll)
  for i = 1, #interiorElements do
    if groupInteriors[i + interiorsScroll] then
      seexports.rl_gui:setGuiRenderDisabled(interiorElements[i][1], false)
      seexports.rl_gui:setGuiRenderDisabled(interiorElements[i][2], false)
      seexports.rl_gui:setGuiRenderDisabled(interiorElements[i][3], false)
      if interiorElements[i][4] then
        seexports.rl_gui:setGuiRenderDisabled(interiorElements[i][4], false)
      end
      if not selectedInterior then
        selectedInterior = groupInteriors[i + interiorsScroll][1]
      end
      local rect = interiorElements[i][1]
      if groupInteriors[i + interiorsScroll][1] == selectedInterior then
        seexports.rl_gui:setGuiHoverable(rect, false)
        seexports.rl_gui:setGuiBackground(rect, "solid", "v4grey3")
      else
        seexports.rl_gui:setGuiHoverable(rect, true)
        seexports.rl_gui:setGuiBackground(rect, "solid", "v4grey1")
      end
      local label = interiorElements[i][2]
      seexports.rl_gui:setLabelText(label, "[" .. groupInteriors[i + interiorsScroll][1] .. "] " .. groupInteriors[i + interiorsScroll][2])
      local label = interiorElements[i][3]
      seexports.rl_gui:setLabelText(label, groupInteriors[i + interiorsScroll][3])
    else
      seexports.rl_gui:setGuiRenderDisabled(interiorElements[i][1], true)
      seexports.rl_gui:setGuiRenderDisabled(interiorElements[i][2], true)
      seexports.rl_gui:setGuiRenderDisabled(interiorElements[i][3], true)
      if interiorElements[i][4] then
        seexports.rl_gui:setGuiRenderDisabled(interiorElements[i][4], true)
      end
    end
  end
end
addEvent("selectGroupInterior", false)
addEventHandler("selectGroupInterior", getRootElement(), function(button, state, absoluteX, absoluteY, el)
  for i = 1, #interiorElements do
    if interiorElements[i][1] == el and groupInteriors[i + interiorsScroll] then
      selectedInterior = groupInteriors[i + interiorsScroll][1]
      interiorMemberScroll = 0
      processGroupInteriorList()
      processGroupSelectedInterior()
      return
    end
  end
end)
addEvent("setGroupInteriorDataPanel", false)
addEventHandler("setGroupInteriorDataPanel", getRootElement(), function(button, state, absoluteX, absoluteY, el)
  seexports.rl_gui:setGuiBackground(interiorDataButton, "solid", "v4green")
  seexports.rl_gui:setGuiHoverable(interiorDataButton, false)
  seexports.rl_gui:setGuiBackground(interiorMemberButton, "solid", "v4grey4")
  seexports.rl_gui:setGuiHoverable(interiorMemberButton, true)
  seexports.rl_gui:setGuiRenderDisabled(interiorDataBg, false, true)
  seexports.rl_gui:setGuiRenderDisabled(interiorMemberBg, true, true)
  if selectedInterior then
    seexports.rl_gui:deleteAllChildren(interiorDataBg)
    local x = dashboardPadding[3] * 2
    local y = dashboardPadding[3] * 2
    local label = seexports.rl_gui:createGuiElement("label", x, y, 0, 0, interiorDataBg)
    seexports.rl_gui:setLabelFont(label, groupFonts[4])
    seexports.rl_gui:setLabelAlignment(label, "left", "top")
    seexports.rl_gui:setLabelText(label, "Zárva: ")
    local label = seexports.rl_gui:createGuiElement("label", x + seexports.rl_gui:getLabelTextWidth(label), y, 0, 0, interiorDataBg)
    seexports.rl_gui:setLabelFont(label, groupFonts[5])
    seexports.rl_gui:setLabelAlignment(label, "left", "top")
    local locked = seexports.rl_interiors:getInteriorLocked(selectedInterior)
    if locked then
      seexports.rl_gui:setLabelColor(label, "v4green")
      seexports.rl_gui:setLabelText(label, "igen")
    else
      seexports.rl_gui:setLabelColor(label, "v4red")
      seexports.rl_gui:setLabelText(label, "nem")
    end
    y = y + seexports.rl_gui:getLabelFontHeight(label) + dashboardPadding[3]
    local label = seexports.rl_gui:createGuiElement("label", x, y, 0, 0, interiorDataBg)
    seexports.rl_gui:setLabelFont(label, groupFonts[4])
    seexports.rl_gui:setLabelAlignment(label, "left", "top")
    seexports.rl_gui:setLabelText(label, "Szerkeszthető: ")
    local label = seexports.rl_gui:createGuiElement("label", x + seexports.rl_gui:getLabelTextWidth(label), y, 0, 0, interiorDataBg)
    seexports.rl_gui:setLabelFont(label, groupFonts[5])
    seexports.rl_gui:setLabelAlignment(label, "left", "top")
    local editable = seexports.rl_interiors:getInteriorEditable(selectedInterior)
    if editable == "N" then
      seexports.rl_gui:setLabelColor(label, "v4red")
      seexports.rl_gui:setLabelText(label, "nem")
    else
      seexports.rl_gui:setLabelColor(label, "v4green")
      seexports.rl_gui:setLabelText(label, editable)
    end
    y = y + seexports.rl_gui:getLabelFontHeight(label) + dashboardPadding[3] * 2
    local sx, sy = seexports.rl_gui:getGuiSize(interiorDataBg)
    local px, py = x, y
    local pw, ph = sx - x - dashboardPadding[3] * 2, sy - y - dashboardPadding[3] * 2
    local rx, ry = seexports.rl_interiors:getInteriorOutsidePosition(selectedInterior)
    local map = seexports.rl_gui:createGuiElement("radar", px, py, pw, ph, interiorDataBg)
    seexports.rl_gui:setRadarCoords(map, rx, ry, 128)
    local img = seexports.rl_gui:createGuiElement("image", px, py, 16, 16, interiorDataBg)
    seexports.rl_gui:setImageDDS(img, ":rl_dashboard/files/mapcorner.dds")
    seexports.rl_gui:setImageColor(img, "v4grey1")
    local img = seexports.rl_gui:createGuiElement("image", px + pw, py, -16, 16, interiorDataBg)
    seexports.rl_gui:setImageDDS(img, ":rl_dashboard/files/mapcorner.dds")
    seexports.rl_gui:setImageColor(img, "v4grey1")
    local img = seexports.rl_gui:createGuiElement("image", px + 16, py, pw - 32, 16, interiorDataBg)
    seexports.rl_gui:setImageDDS(img, ":rl_dashboard/files/mapside.dds")
    seexports.rl_gui:setImageColor(img, "v4grey1")
    seexports.rl_gui:setImageUV(img, 0, 0, pw - 64, 32)
    local img = seexports.rl_gui:createGuiElement("image", px, py + ph, 16, -16, interiorDataBg)
    seexports.rl_gui:setImageDDS(img, ":rl_dashboard/files/mapcorner.dds")
    seexports.rl_gui:setImageColor(img, "v4grey1")
    local img = seexports.rl_gui:createGuiElement("image", px + pw, py + ph, -16, -16, interiorDataBg)
    seexports.rl_gui:setImageDDS(img, ":rl_dashboard/files/mapcorner.dds")
    seexports.rl_gui:setImageColor(img, "v4grey1")
    local img = seexports.rl_gui:createGuiElement("image", px + 16, py + ph, pw - 32, -16, interiorDataBg)
    seexports.rl_gui:setImageDDS(img, ":rl_dashboard/files/mapside.dds")
    seexports.rl_gui:setImageColor(img, "v4grey1")
    seexports.rl_gui:setImageUV(img, 0, 0, pw - 64, 32)
    local img = seexports.rl_gui:createGuiElement("image", px, py + 16, 16, ph - 32, interiorDataBg)
    seexports.rl_gui:setImageDDS(img, ":rl_dashboard/files/mapside2.dds")
    seexports.rl_gui:setImageColor(img, "v4grey1")
    seexports.rl_gui:setImageUV(img, 0, 0, 32, ph - 64)
    local img = seexports.rl_gui:createGuiElement("image", px + pw, py + 16, -16, ph - 32, interiorDataBg)
    seexports.rl_gui:setImageDDS(img, ":rl_dashboard/files/mapside2.dds")
    seexports.rl_gui:setImageColor(img, "v4grey1")
    seexports.rl_gui:setImageUV(img, 0, 0, 32, ph - 64)
    local cross = seexports.rl_gui:createGuiElement("image", px + pw / 2 - 16, py + ph / 2 - 16, 32, 32, interiorDataBg)
    local theType = seexports.rl_interiors:getInteriorType(selectedInterior)
    if theType == "house" then
      seexports.rl_gui:setImageFile(cross, seexports.rl_gui:getFaIconFilename("building", 32, "solid", false, seexports.rl_gui:getColorCodeToColor("v4grey2"), seexports.rl_gui:getColorCodeToColor("v4blue")))
    elseif theType == "business" then
      seexports.rl_gui:setImageFile(cross, seexports.rl_gui:getFaIconFilename("dollar-sign", 32, "solid", false, seexports.rl_gui:getColorCodeToColor("v4grey2"), seexports.rl_gui:getColorCodeToColor("v4green")))
    elseif theType == "garage" or theType == "garage2" then
      seexports.rl_gui:setImageFile(cross, seexports.rl_gui:getFaIconFilename("garage", 32, "solid", false, seexports.rl_gui:getColorCodeToColor("v4grey2"), seexports.rl_gui:getColorCodeToColor("v4blue-second")))
    elseif theType == "rentable" then
      seexports.rl_gui:setImageFile(cross, seexports.rl_gui:getFaIconFilename("hotel", 32, "solid", false, seexports.rl_gui:getColorCodeToColor("v4grey2"), seexports.rl_gui:getColorCodeToColor("v4purple")))
    elseif theType == "lift" or theType == "stairs" then
      seexports.rl_gui:setImageFile(cross, seexports.rl_gui:getFaIconFilename("sort-circle-up", 32, "solid", false, seexports.rl_gui:getColorCodeToColor("v4grey2"), seexports.rl_gui:getColorCodeToColor("hudwhite")))
    elseif theType == "door" then
      seexports.rl_gui:setImageFile(cross, seexports.rl_gui:getFaIconFilename("door-closed", 32, "solid", false, seexports.rl_gui:getColorCodeToColor("v4grey2"), seexports.rl_gui:getColorCodeToColor("hudwhite")))
    else
      seexports.rl_gui:setImageFile(cross, seexports.rl_gui:getFaIconFilename("question", 32, "solid", false, seexports.rl_gui:getColorCodeToColor("v4grey2"), seexports.rl_gui:getColorCodeToColor("v4yellow")))
    end
  end
end)
addEvent("setGroupInteriorMemberPanel", false)
addEventHandler("setGroupInteriorMemberPanel", getRootElement(), function(button, state, absoluteX, absoluteY, el)
  seexports.rl_gui:setGuiBackground(interiorMemberButton, "solid", "v4green")
  seexports.rl_gui:setGuiHoverable(interiorMemberButton, false)
  seexports.rl_gui:setGuiBackground(interiorDataButton, "solid", "v4grey4")
  seexports.rl_gui:setGuiHoverable(interiorDataButton, true)
  seexports.rl_gui:setGuiRenderDisabled(interiorMemberBg, false, true)
  seexports.rl_gui:setGuiRenderDisabled(interiorDataBg, true, true)
  processGroupInteriorMemberList()
end)
addEvent("doneEditInteriorMembers", false)
addEventHandler("doneEditInteriorMembers", getRootElement(), function(button, state, absoluteX, absoluteY, el)
  seexports.rl_gui:deleteGuiElement(el)
  createGroupLoader()
  local members = {}
  for i = 1, #interiorMemberList do
    if interiorMemberList[i] and interiorMemberList[i][4] then
      table.insert(members, interiorMemberList[i][1])
    end
  end
  triggerLatentServerEvent("editGroupInteriorMembers", localPlayer, selectedGroup, selectedInterior, members)
end)
addEvent("selectInteriorMemberCheckbox", false)
addEventHandler("selectInteriorMemberCheckbox", getRootElement(), function(button, state, absoluteX, absoluteY, el)
  for i = 1, #interiorMemberElements do
    if interiorMemberElements[i][3] == el then
      if interiorMemberList[i + interiorMemberScroll] then
        interiorMemberList[i + interiorMemberScroll][4] = seexports.rl_gui:isCheckboxChecked(el)
        processGroupInteriorMemberList()
      end
      return
    end
  end
end)
addEvent("editInteriorMembers", false)
addEventHandler("editInteriorMembers", getRootElement(), function(button, state, absoluteX, absoluteY, el)
  if selectedInterior and groupDatas[selectedGroup].interiorMembers[selectedInterior] then
    seexports.rl_gui:setGuiHoverable(interiorMemberButton, false)
    seexports.rl_gui:setGuiHoverable(interiorDataButton, false)
    interiorMemberEditing = true
    table.sort(interiorMemberList, groupVehicleMemberSortEx)
    processGroupInteriorMemberList()
    seexports.rl_gui:setImageFile(interiorMemberEditButton, seexports.rl_gui:getFaIconFilename("save", 32))
    seexports.rl_gui:setClickEvent(interiorMemberEditButton, "doneEditInteriorMembers")
  end
end)
function processGroupInteriorMemberList()
  local w, h = seexports.rl_gui:getGuiSize(interiorMemberBg)
  local n = math.max(0, #interiorMemberList - #interiorMemberElements)
  h = h / (n + 1)
  if n < interiorMemberScroll then
    interiorMemberScroll = n
  end
  seexports.rl_gui:setGuiSize(interiorMemberScrollBar, false, h)
  seexports.rl_gui:setGuiPosition(interiorMemberScrollBar, false, h * interiorMemberScroll)
  for i = 1, #interiorMemberElements do
    if interiorMemberList[i + interiorMemberScroll] then
      local hasPerm = interiorMemberList[i + interiorMemberScroll][4]
      seexports.rl_gui:setGuiRenderDisabled(interiorMemberElements[i][1], false)
      seexports.rl_gui:setGuiRenderDisabled(interiorMemberElements[i][2], false)
      local label = interiorMemberElements[i][1]
      seexports.rl_gui:setLabelText(label, interiorMemberList[i + interiorMemberScroll][2])
      local w, h = seexports.rl_gui:getGuiSize(label)
      seexports.rl_gui:setLabelColor(label, hasPerm and "#ffffff" or "v4midgrey")
      local label = interiorMemberElements[i][2]
      local rank = interiorMemberList[i + interiorMemberScroll][3]
      seexports.rl_gui:setLabelColor(label, hasPerm and "v4" .. (groupDatas[selectedGroup].rankColors[rank] or "blue") or "v4midgrey")
      seexports.rl_gui:setLabelText(label, (groupDatas[selectedGroup].ranks[rank] or "N/A") .. " [" .. rank .. "]")
      local checkbox = interiorMemberElements[i][3]
      if interiorMemberEditing then
        seexports.rl_gui:setGuiRenderDisabled(checkbox, false)
        seexports.rl_gui:setCheckboxChecked(checkbox, hasPerm)
        seexports.rl_gui:setGuiSize(label, w - h, false)
      else
        seexports.rl_gui:setGuiRenderDisabled(checkbox, true)
        seexports.rl_gui:setGuiSize(label, w, false)
      end
      if interiorMemberElements[i][4] then
        seexports.rl_gui:setGuiRenderDisabled(interiorMemberElements[i][4], false)
      end
    else
      seexports.rl_gui:setGuiRenderDisabled(interiorMemberElements[i][1], true)
      seexports.rl_gui:setGuiRenderDisabled(interiorMemberElements[i][2], true)
      seexports.rl_gui:setGuiRenderDisabled(interiorMemberElements[i][3], true)
      if interiorMemberElements[i][4] then
        seexports.rl_gui:setGuiRenderDisabled(interiorMemberElements[i][4], true)
      end
    end
  end
end
function drawGroupInteriors()
  local label = seexports.rl_gui:createGuiElement("label", dashboardPadding[3] * 4, 40, 0, 48, groupPanel)
  seexports.rl_gui:setLabelFont(label, groupFonts[3])
  seexports.rl_gui:setLabelAlignment(label, "left", "center")
  seexports.rl_gui:setLabelText(label, "Interiorok: " .. #groupInteriors)
  local w = math.ceil((sx - menuW) * 0.45)
  local h = sy - 40 - dashboardPadding[3] * 8 - 48
  interiorsBg = seexports.rl_gui:createGuiElement("rectangle", dashboardPadding[3] * 4, 88 + dashboardPadding[3] * 4, w, h, groupPanel)
  seexports.rl_gui:setGuiBackground(interiorsBg, "solid", "v4grey1")
  local sbg = seexports.rl_gui:createGuiElement("rectangle", w - 2, 0, 2, h, interiorsBg)
  seexports.rl_gui:setGuiBackground(sbg, "solid", "v4grey3")
  interiorsScrollBar = seexports.rl_gui:createGuiElement("rectangle", w - 2, 0, 2, h, interiorsBg)
  seexports.rl_gui:setGuiBackground(interiorsScrollBar, "solid", "v4midgrey")
  local n = math.floor(h / 32)
  h = h / n
  interiorElements = {}
  y = 0
  for i = 1, n do
    if groupInteriors[i] then
      interiorElements[i] = {}
      local rect = seexports.rl_gui:createGuiElement("rectangle", 0, y, w - 2, h - 1, interiorsBg)
      seexports.rl_gui:setGuiBackground(rect, "solid", "v4grey1")
      seexports.rl_gui:setGuiHover(rect, "gradient", {"v4grey1", "v4grey2"}, false, true)
      seexports.rl_gui:setGuiHoverable(rect, true)
      seexports.rl_gui:setClickEvent(rect, "selectGroupInterior")
      interiorElements[i][1] = rect
      local label = seexports.rl_gui:createGuiElement("label", dashboardPadding[3] * 2, 0, 0, h, rect)
      seexports.rl_gui:setLabelFont(label, groupFonts[4])
      seexports.rl_gui:setLabelAlignment(label, "left", "center")
      interiorElements[i][2] = label
      local label = seexports.rl_gui:createGuiElement("label", 0, 0, w - dashboardPadding[3] * 2, h, rect)
      seexports.rl_gui:setLabelFont(label, groupFonts[5])
      seexports.rl_gui:setLabelAlignment(label, "right", "center")
      interiorElements[i][3] = label
      if i < n then
        local border = seexports.rl_gui:createGuiElement("hr", 0, h - 1, w - 2, 2, rect)
        seexports.rl_gui:setGuiHrColor(border, "v4grey3", "v4grey2")
        interiorElements[i][4] = border
      end
    end
    y = y + h
  end
  x = dashboardPadding[3] * 4 + w
  y = 88 + dashboardPadding[3] * 4
  local w = sx - menuW - x
  x = x + dashboardPadding[3] * 4
  interiorNameLabel = seexports.rl_gui:createGuiElement("label", x, y, w, 0, groupPanel)
  seexports.rl_gui:setLabelFont(interiorNameLabel, groupFonts[3])
  seexports.rl_gui:setLabelAlignment(interiorNameLabel, "left", "top")
  y = y + seexports.rl_gui:getLabelFontHeight(label) + dashboardPadding[3] * 2
  local label = seexports.rl_gui:createGuiElement("label", x, y, 0, 0, groupPanel)
  seexports.rl_gui:setLabelFont(label, groupFonts[4])
  seexports.rl_gui:setLabelAlignment(label, "left", "top")
  seexports.rl_gui:setLabelText(label, "Interior típus: ")
  interiorTypeLabel = seexports.rl_gui:createGuiElement("label", x + seexports.rl_gui:getLabelTextWidth(label), y, 0, 0, groupPanel)
  seexports.rl_gui:setLabelFont(interiorTypeLabel, groupFonts[5])
  seexports.rl_gui:setLabelAlignment(interiorTypeLabel, "left", "top")
  y = y + seexports.rl_gui:getLabelFontHeight(label) + dashboardPadding[3]
  y = y + dashboardPadding[3] * 2 + 24
  w = w - dashboardPadding[3] * 4 * 2
  local h = sy - y - dashboardPadding[3] * 4
  interiorSidePanel = seexports.rl_gui:createGuiElement("rectangle", x, y, w, h, groupPanel)
  seexports.rl_gui:setGuiBackground(interiorSidePanel, "solid", "v4grey1")
  interiorMemberButton = seexports.rl_gui:createGuiElement("button", 0, -24, w / 2, 24, interiorSidePanel)
  seexports.rl_gui:setGuiBackground(interiorMemberButton, "solid", "v4green")
  seexports.rl_gui:setGuiHover(interiorMemberButton, "gradient", {"v4grey4", "v4grey3"}, false, true)
  seexports.rl_gui:setGuiHoverable(interiorMemberButton, false)
  seexports.rl_gui:setButtonFont(interiorMemberButton, groupFonts[1])
  seexports.rl_gui:setButtonTextColor(interiorMemberButton, "#ffffff")
  seexports.rl_gui:setButtonText(interiorMemberButton, " Tagok")
  seexports.rl_gui:setButtonIcon(interiorMemberButton, seexports.rl_gui:getFaIconFilename("users", 24))
  seexports.rl_gui:setClickEvent(interiorMemberButton, "setGroupInteriorMemberPanel")
  interiorDataButton = seexports.rl_gui:createGuiElement("button", w / 2, -24, w / 2, 24, interiorSidePanel)
  seexports.rl_gui:setGuiBackground(interiorDataButton, "solid", "v4grey4")
  seexports.rl_gui:setGuiHover(interiorDataButton, "gradient", {"v4grey4", "v4grey3"}, false, true)
  seexports.rl_gui:setClickEvent(interiorDataButton, "switchGroupPanelMenu")
  seexports.rl_gui:setButtonFont(interiorDataButton, groupFonts[1])
  seexports.rl_gui:setButtonTextColor(interiorDataButton, "#ffffff")
  seexports.rl_gui:setButtonText(interiorDataButton, " Adatok")
  seexports.rl_gui:setButtonIcon(interiorDataButton, seexports.rl_gui:getFaIconFilename("list", 24))
  seexports.rl_gui:setClickEvent(interiorDataButton, "setGroupInteriorDataPanel")
  local n = math.floor(h / 32)
  h = h / n
  n = n - 1
  y = y + h
  interiorDataBg = seexports.rl_gui:createGuiElement("rectangle", x, y - h, w, h * (n + 1), groupPanel)
  seexports.rl_gui:setGuiBackground(interiorDataBg, "solid", "v4grey1")
  seexports.rl_gui:setGuiRenderDisabled(interiorDataBg, true, true)
  interiorMemberBg = seexports.rl_gui:createGuiElement("rectangle", x, y, w, h * n, groupPanel)
  seexports.rl_gui:setGuiBackground(interiorMemberBg, "solid", "v4grey1")
  local label = seexports.rl_gui:createGuiElement("label", dashboardPadding[3] * 2, -h, 0, h, interiorMemberBg)
  seexports.rl_gui:setLabelFont(label, groupFonts[4])
  seexports.rl_gui:setLabelAlignment(label, "left", "center")
  seexports.rl_gui:setLabelText(label, "Tagok:")
  local lh = seexports.rl_gui:getLabelFontHeight(label)
  if groupDatas[selectedGroup].isLeader or seexports.rl_groups:getPlayerPermissionInGroup(selectedGroup, "manageKeysInterior") then
    interiorMemberEditButton = seexports.rl_gui:createGuiElement("image", w - h, -h / 2 - lh / 2, lh, lh, interiorMemberBg)
    seexports.rl_gui:setImageFile(interiorMemberEditButton, seexports.rl_gui:getFaIconFilename("pen", 32))
    seexports.rl_gui:setGuiHover(interiorMemberEditButton, "solid", "v4green")
    seexports.rl_gui:setGuiHoverable(interiorMemberEditButton, true)
    seexports.rl_gui:setClickEvent(interiorMemberEditButton, "editInteriorMembers")
    seexports.rl_gui:guiSetTooltip(interiorMemberEditButton, "Interior jogosultságainak szerkesztése")
  else
    interiorMemberEditButton = false
  end
  local border = seexports.rl_gui:createGuiElement("hr", 0, -1, w, 2, interiorMemberBg)
  seexports.rl_gui:setGuiHrColor(border, "v4grey3", "v4grey2")
  local sbg = seexports.rl_gui:createGuiElement("rectangle", w - 2, 0, 2, h * n, interiorMemberBg)
  seexports.rl_gui:setGuiBackground(sbg, "solid", "v4grey3")
  interiorMemberScrollBar = seexports.rl_gui:createGuiElement("rectangle", w - 2, 0, 2, h * n, interiorMemberBg)
  seexports.rl_gui:setGuiBackground(interiorMemberScrollBar, "solid", "v4midgrey")
  interiorMemberElements = {}
  y = 0
  for i = 1, n do
    interiorMemberElements[i] = {}
    local label = seexports.rl_gui:createGuiElement("label", dashboardPadding[3] * 2, y, w - dashboardPadding[3] * 2 - 2, h, interiorMemberBg)
    seexports.rl_gui:setLabelFont(label, groupFonts[4])
    seexports.rl_gui:setLabelAlignment(label, "left", "center")
    interiorMemberElements[i][1] = label
    local label = seexports.rl_gui:createGuiElement("label", 0, y, 0, h, interiorMemberBg)
    seexports.rl_gui:setLabelFont(label, groupFonts[5])
    seexports.rl_gui:setLabelAlignment(label, "right", "center")
    interiorMemberElements[i][2] = label
    local checkbox = seexports.rl_gui:createGuiElement("checkbox", 0 + w - h - 2, y + 2, h - 4, h - 4, interiorMemberBg)
    seexports.rl_gui:setGuiColorScheme(checkbox, "darker")
    seexports.rl_gui:setClickEvent(checkbox, "selectInteriorMemberCheckbox")
    interiorMemberElements[i][3] = checkbox
    if n > i then
      local border = seexports.rl_gui:createGuiElement("hr", 0, y + h - 1, w - 2, 2, interiorMemberBg)
      seexports.rl_gui:setGuiHrColor(border, "v4grey3", "v4grey2")
      interiorMemberElements[i][4] = border
    end
    y = y + h
  end
  processGroupInteriorList()
  processGroupSelectedInterior()
end
function drawGroupHome()
  local label = seexports.rl_gui:createGuiElement("label", dashboardPadding[3] * 4, 40, 0, 48, groupPanel)
  seexports.rl_gui:setLabelFont(label, groupFonts[3])
  seexports.rl_gui:setLabelAlignment(label, "left", "center")
  seexports.rl_gui:setLabelText(label, groupDatas[selectedGroup].name)
  local x = (sx - menuW) / 2 + dashboardPadding[3] * 4
  local y = 40 + dashboardPadding[3] * 4 + 48
  local label = seexports.rl_gui:createGuiElement("label", x, y, 0, 0, groupPanel)
  seexports.rl_gui:setLabelFont(label, groupFonts[2])
  seexports.rl_gui:setLabelAlignment(label, "left", "top")
  seexports.rl_gui:setLabelText(label, getElementData(localPlayer, "char.name"):gsub("_", " "))
  y = y + seexports.rl_gui:getLabelFontHeight(label) + dashboardPadding[3]
  local label = seexports.rl_gui:createGuiElement("label", x, y, 0, 0, groupPanel)
  seexports.rl_gui:setLabelFont(label, groupFonts[4])
  seexports.rl_gui:setLabelAlignment(label, "left", "top")
  seexports.rl_gui:setLabelText(label, "Rang: ")
  local label = seexports.rl_gui:createGuiElement("label", x + seexports.rl_gui:getLabelTextWidth(label), y, 0, 0, groupPanel)
  seexports.rl_gui:setLabelFont(label, groupFonts[5])
  seexports.rl_gui:setLabelAlignment(label, "left", "top")
  seexports.rl_gui:setLabelColor(label, "v4" .. (groupDatas[selectedGroup].rankColors[groupDatas[selectedGroup].rank] or "blue"))
  seexports.rl_gui:setLabelText(label, (groupDatas[selectedGroup].ranks[groupDatas[selectedGroup].rank] or "N/A") .. " [" .. groupDatas[selectedGroup].rank .. "]")
  y = y + seexports.rl_gui:getLabelFontHeight(label) + dashboardPadding[3]
  local label = seexports.rl_gui:createGuiElement("label", x, y, 0, 0, groupPanel)
  seexports.rl_gui:setLabelFont(label, groupFonts[4])
  seexports.rl_gui:setLabelAlignment(label, "left", "top")
  seexports.rl_gui:setLabelText(label, "Fizetés: ")
  local label = seexports.rl_gui:createGuiElement("label", x + seexports.rl_gui:getLabelTextWidth(label), y, 0, 0, groupPanel)
  seexports.rl_gui:setLabelFont(label, groupFonts[5])
  seexports.rl_gui:setLabelAlignment(label, "left", "top")
  seexports.rl_gui:setLabelColor(label, "v4green")
  seexports.rl_gui:setLabelText(label, seexports.rl_gui:thousandsStepper(groupDatas[selectedGroup].salaries[groupDatas[selectedGroup].rank] or 0) .. " $")
  y = y + seexports.rl_gui:getLabelFontHeight(label) + dashboardPadding[3]
  local label = seexports.rl_gui:createGuiElement("label", x, y, 0, 0, groupPanel)
  seexports.rl_gui:setLabelFont(label, groupFonts[4])
  seexports.rl_gui:setLabelAlignment(label, "left", "top")
  seexports.rl_gui:setLabelText(label, "Leader: ")
  local label = seexports.rl_gui:createGuiElement("label", x + seexports.rl_gui:getLabelTextWidth(label), y, 0, 0, groupPanel)
  seexports.rl_gui:setLabelFont(label, groupFonts[5])
  seexports.rl_gui:setLabelAlignment(label, "left", "top")
  seexports.rl_gui:setLabelColor(label, groupDatas[selectedGroup].isLeader and "v4green" or "v4red")
  seexports.rl_gui:setLabelText(label, groupDatas[selectedGroup].isLeader and "igen" or "nem")
  --iprint(groupDatas[selectedGroup].isLeader)
  y = y + seexports.rl_gui:getLabelFontHeight(label) + dashboardPadding[3]
  local label = seexports.rl_gui:createGuiElement("label", x, y, 0, 0, groupPanel)
  seexports.rl_gui:setLabelFont(label, groupFonts[4])
  seexports.rl_gui:setLabelAlignment(label, "left", "top")
  seexports.rl_gui:setLabelText(label, "Felvéve a frakcióba: ")
  local label = seexports.rl_gui:createGuiElement("label", x + seexports.rl_gui:getLabelTextWidth(label), y, 0, 0, groupPanel)
  seexports.rl_gui:setLabelFont(label, groupFonts[5])
  seexports.rl_gui:setLabelAlignment(label, "left", "top")
  seexports.rl_gui:setLabelColor(label, "v4blue")
  local time = getRealTime(groupDatas[selectedGroup].added)
  seexports.rl_gui:setLabelText(label, string.format("%04d. %02d. %02d. %02d:%02d", time.year + 1900, time.month + 1, time.monthday, time.hour, time.minute))
  y = y + seexports.rl_gui:getLabelFontHeight(label) + dashboardPadding[3]
  local label = seexports.rl_gui:createGuiElement("label", x, y, 0, 0, groupPanel)
  seexports.rl_gui:setLabelFont(label, groupFonts[4])
  seexports.rl_gui:setLabelAlignment(label, "left", "top")
  seexports.rl_gui:setLabelText(label, "Rang változtatva: ")
  local label = seexports.rl_gui:createGuiElement("label", x + seexports.rl_gui:getLabelTextWidth(label), y, 0, 0, groupPanel)
  seexports.rl_gui:setLabelFont(label, groupFonts[5])
  seexports.rl_gui:setLabelAlignment(label, "left", "top")
  seexports.rl_gui:setLabelColor(label, "v4blue")
  local time = getRealTime(groupDatas[selectedGroup].promoted)
  seexports.rl_gui:setLabelText(label, string.format("%04d. %02d. %02d. %02d:%02d", time.year + 1900, time.month + 1, time.monthday, time.hour, time.minute))
  y = y + seexports.rl_gui:getLabelFontHeight(label) + dashboardPadding[3]
  y = 40 + dashboardPadding[3] * 4 + 48
  x = dashboardPadding[3] * 4
  local onlineMembers = 0
  local onlineLeaders = 0
  local leaderCount = 0
  for i = 1, #groupDatas[selectedGroup].members do
    if isElement(groupDatas[selectedGroup].members[i][4]) then
      onlineMembers = onlineMembers + 1
    end
    if groupDatas[selectedGroup].members[i][3] then
      leaderCount = leaderCount + 1
      if isElement(groupDatas[selectedGroup].members[i][4]) then
        onlineLeaders = onlineLeaders + 1
      end
    end
  end
  local label = seexports.rl_gui:createGuiElement("label", x, y, 0, 0, groupPanel)
  seexports.rl_gui:setLabelFont(label, groupFonts[4])
  seexports.rl_gui:setLabelAlignment(label, "left", "top")
  seexports.rl_gui:setLabelText(label, "Tagok száma: ")
  local label = seexports.rl_gui:createGuiElement("label", x + seexports.rl_gui:getLabelTextWidth(label), y, 0, 0, groupPanel)
  seexports.rl_gui:setLabelFont(label, groupFonts[5])
  seexports.rl_gui:setLabelAlignment(label, "left", "top")
  seexports.rl_gui:setLabelColor(label, "v4green")
  seexports.rl_gui:setLabelText(label, #groupDatas[selectedGroup].members)
  y = y + seexports.rl_gui:getLabelFontHeight(label) + dashboardPadding[3]
  local label = seexports.rl_gui:createGuiElement("label", x, y, 0, 0, groupPanel)
  seexports.rl_gui:setLabelFont(label, groupFonts[4])
  seexports.rl_gui:setLabelAlignment(label, "left", "top")
  seexports.rl_gui:setLabelText(label, "Online tagok: ")
  local label = seexports.rl_gui:createGuiElement("label", x + seexports.rl_gui:getLabelTextWidth(label), y, 0, 0, groupPanel)
  seexports.rl_gui:setLabelFont(label, groupFonts[5])
  seexports.rl_gui:setLabelAlignment(label, "left", "top")
  seexports.rl_gui:setLabelColor(label, "v4green")
  seexports.rl_gui:setLabelText(label, onlineMembers)
  y = y + seexports.rl_gui:getLabelFontHeight(label) + dashboardPadding[3]
  local label = seexports.rl_gui:createGuiElement("label", x, y, 0, 0, groupPanel)
  seexports.rl_gui:setLabelFont(label, groupFonts[4])
  seexports.rl_gui:setLabelAlignment(label, "left", "top")
  seexports.rl_gui:setLabelText(label, "Leaderek száma: ")
  local label = seexports.rl_gui:createGuiElement("label", x + seexports.rl_gui:getLabelTextWidth(label), y, 0, 0, groupPanel)
  seexports.rl_gui:setLabelFont(label, groupFonts[5])
  seexports.rl_gui:setLabelAlignment(label, "left", "top")
  seexports.rl_gui:setLabelColor(label, "v4green")
  seexports.rl_gui:setLabelText(label, leaderCount)
  y = y + seexports.rl_gui:getLabelFontHeight(label) + dashboardPadding[3]
  local label = seexports.rl_gui:createGuiElement("label", x, y, 0, 0, groupPanel)
  seexports.rl_gui:setLabelFont(label, groupFonts[4])
  seexports.rl_gui:setLabelAlignment(label, "left", "top")
  seexports.rl_gui:setLabelText(label, "Online leaderek: ")
  local label = seexports.rl_gui:createGuiElement("label", x + seexports.rl_gui:getLabelTextWidth(label), y, 0, 0, groupPanel)
  seexports.rl_gui:setLabelFont(label, groupFonts[5])
  seexports.rl_gui:setLabelAlignment(label, "left", "top")
  seexports.rl_gui:setLabelColor(label, "v4green")
  seexports.rl_gui:setLabelText(label, onlineLeaders)
  y = y + seexports.rl_gui:getLabelFontHeight(label) + dashboardPadding[3]
  local label = seexports.rl_gui:createGuiElement("label", x, y, 0, 0, groupPanel)
  seexports.rl_gui:setLabelFont(label, groupFonts[4])
  seexports.rl_gui:setLabelAlignment(label, "left", "top")
  seexports.rl_gui:setLabelText(label, "Dutyban levő tagok: ")
  local label = seexports.rl_gui:createGuiElement("label", x + seexports.rl_gui:getLabelTextWidth(label), y, 0, 0, groupPanel)
  seexports.rl_gui:setLabelFont(label, groupFonts[5])
  seexports.rl_gui:setLabelAlignment(label, "left", "top")
  seexports.rl_gui:setLabelColor(label, "v4blue")
  seexports.rl_gui:setLabelText(label, groupDatas[selectedGroup].dutyCount)
  y = y + seexports.rl_gui:getLabelFontHeight(label) + dashboardPadding[3]
  local label = seexports.rl_gui:createGuiElement("label", x, y, 0, 0, groupPanel)
  seexports.rl_gui:setLabelFont(label, groupFonts[4])
  seexports.rl_gui:setLabelAlignment(label, "left", "top")
  seexports.rl_gui:setLabelText(label, "Védett rádiófrekvencia: ")
  local label = seexports.rl_gui:createGuiElement("label", x + seexports.rl_gui:getLabelTextWidth(label), y, 0, 0, groupPanel)
  seexports.rl_gui:setLabelFont(label, groupFonts[5])
  seexports.rl_gui:setLabelAlignment(label, "left", "top")
  seexports.rl_gui:setLabelColor(label, groupDatas[selectedGroup].protectedRadio and "v4green" or "v4red")
  seexports.rl_gui:setLabelText(label, groupDatas[selectedGroup].protectedRadio or "nincs")
  y = y + seexports.rl_gui:getLabelFontHeight(label) + dashboardPadding[3]
  local label = seexports.rl_gui:createGuiElement("label", x, y, 0, 0, groupPanel)
  seexports.rl_gui:setLabelFont(label, groupFonts[4])
  seexports.rl_gui:setLabelAlignment(label, "left", "top")
  seexports.rl_gui:setLabelText(label, "Voice rádió: ")
  local label = seexports.rl_gui:createGuiElement("label", x + seexports.rl_gui:getLabelTextWidth(label), y, 0, 0, groupPanel)
  seexports.rl_gui:setLabelFont(label, groupFonts[5])
  seexports.rl_gui:setLabelAlignment(label, "left", "top")
  seexports.rl_gui:setLabelColor(label, groupDatas[selectedGroup].voiceRadio and "v4green" or "v4red")
  seexports.rl_gui:setLabelText(label, groupDatas[selectedGroup].voiceRadio and "van" or "nincs")
  y = y + seexports.rl_gui:getLabelFontHeight(label) + dashboardPadding[3]
  local label = seexports.rl_gui:createGuiElement("label", x, y, 0, 0, groupPanel)
  seexports.rl_gui:setLabelFont(label, groupFonts[4])
  seexports.rl_gui:setLabelAlignment(label, "left", "top")
  seexports.rl_gui:setLabelText(label, "Araç sayısı: ")
  local label = seexports.rl_gui:createGuiElement("label", x + seexports.rl_gui:getLabelTextWidth(label), y, 0, 0, groupPanel)
  seexports.rl_gui:setLabelFont(label, groupFonts[5])
  seexports.rl_gui:setLabelAlignment(label, "left", "top")
  seexports.rl_gui:setLabelColor(label, "v4blue")
  seexports.rl_gui:setLabelText(label, #groupDatas[selectedGroup].vehicles)
  y = y + seexports.rl_gui:getLabelFontHeight(label) + dashboardPadding[3]
  local label = seexports.rl_gui:createGuiElement("label", x, y, 0, 0, groupPanel)
  seexports.rl_gui:setLabelFont(label, groupFonts[4])
  seexports.rl_gui:setLabelAlignment(label, "left", "top")
  seexports.rl_gui:setLabelText(label, "Interiorok száma: ")
  local label = seexports.rl_gui:createGuiElement("label", x + seexports.rl_gui:getLabelTextWidth(label), y, 0, 0, groupPanel)
  seexports.rl_gui:setLabelFont(label, groupFonts[5])
  seexports.rl_gui:setLabelAlignment(label, "left", "top")
  seexports.rl_gui:setLabelColor(label, "v4blue")
  seexports.rl_gui:setLabelText(label, #groupInteriors)
  y = y + seexports.rl_gui:getLabelFontHeight(label) + dashboardPadding[3]
  if groupDatas[selectedGroup].isLeader or seexports.rl_groups:getPlayerPermissionInGroup(selectedGroup, "manageGroupBalance") then
    y = y + dashboardPadding[3] * 2
    local label = seexports.rl_gui:createGuiElement("label", x, y, 0, 0, groupPanel)
    seexports.rl_gui:setLabelFont(label, groupFonts[2])
    seexports.rl_gui:setLabelAlignment(label, "left", "top")
    seexports.rl_gui:setLabelText(label, "Pénzügyek")
    y = y + seexports.rl_gui:getLabelFontHeight(label) + dashboardPadding[3]
    y = y + dashboardPadding[3]
    local label = seexports.rl_gui:createGuiElement("label", x, y, 0, 0, groupPanel)
    seexports.rl_gui:setLabelFont(label, groupFonts[4])
    seexports.rl_gui:setLabelAlignment(label, "left", "top")
    seexports.rl_gui:setLabelText(label, "Egyenleg: ")
    local x2 = x + seexports.rl_gui:getLabelTextWidth(label)
    local label = seexports.rl_gui:createGuiElement("label", x2, y, 0, 0, groupPanel)
    seexports.rl_gui:setLabelFont(label, groupFonts[5])
    seexports.rl_gui:setLabelAlignment(label, "left", "top")
    if groupDatas[selectedGroup].balance and 0 <= groupDatas[selectedGroup].balance then
      seexports.rl_gui:setLabelColor(label, "v4green")
    else
      seexports.rl_gui:setLabelColor(label, "v4red")
    end
    seexports.rl_gui:setLabelText(label, seexports.rl_gui:thousandsStepper(groupDatas[selectedGroup].balance or 0) .. " $")
    local fh = seexports.rl_gui:getLabelFontHeight(label)
    local btn = seexports.rl_gui:createGuiElement("button", x2 + 6 + seexports.rl_gui:getLabelTextWidth(label), y + fh / 2 - 12, 24, 24, groupPanel)
    seexports.rl_gui:setGuiBackground(btn, "solid", "v4green")
    seexports.rl_gui:setGuiHover(btn, "gradient", {
      "v4green",
      "v4green-second"
    }, false, true)
    seexports.rl_gui:setButtonFont(btn, groupFonts[1])
    seexports.rl_gui:guiSetTooltip(btn, "Kasszakezelés")
    seexports.rl_gui:setClickEvent(btn, "openGroupBalanceModal")
    seexports.rl_gui:setButtonIcon(btn, seexports.rl_gui:getFaIconFilename("coins", 24))
    y = y + fh + dashboardPadding[3]
    local label = seexports.rl_gui:createGuiElement("label", x, y, 0, 0, groupPanel)
    seexports.rl_gui:setLabelFont(label, groupFonts[4])
    seexports.rl_gui:setLabelAlignment(label, "left", "top")
    seexports.rl_gui:setLabelText(label, "Állami támogatás: ")
    local label = seexports.rl_gui:createGuiElement("label", x + seexports.rl_gui:getLabelTextWidth(label), y, 0, 0, groupPanel)
    seexports.rl_gui:setLabelFont(label, groupFonts[5])
    seexports.rl_gui:setLabelAlignment(label, "left", "top")
    seexports.rl_gui:setLabelColor(label, "v4green")
    seexports.rl_gui:setLabelText(label, seexports.rl_gui:thousandsStepper(groupDatas[selectedGroup].aid or 0) .. " $ / online tag / óra")
    y = y + seexports.rl_gui:getLabelFontHeight(label) + dashboardPadding[3]
    local label = seexports.rl_gui:createGuiElement("label", x, y, 0, 0, groupPanel)
    seexports.rl_gui:setLabelFont(label, groupFonts[4])
    seexports.rl_gui:setLabelAlignment(label, "left", "top")
    seexports.rl_gui:setLabelText(label, "Adó: ")
    local label = seexports.rl_gui:createGuiElement("label", x + seexports.rl_gui:getLabelTextWidth(label), y, 0, 0, groupPanel)
    seexports.rl_gui:setLabelFont(label, groupFonts[5])
    seexports.rl_gui:setLabelAlignment(label, "left", "top")
    seexports.rl_gui:setLabelColor(label, "v4red")
    seexports.rl_gui:setLabelText(label, seexports.rl_gui:thousandsStepper(groupDatas[selectedGroup].tax or 0) .. " $ / óra")
    y = y + dashboardPadding[3]
  end
  y = y + dashboardPadding[3] * 4
  local border = seexports.rl_gui:createGuiElement("hr", (sx - menuW) / 2 - 1, 88 + dashboardPadding[3] * 2, 2, y - 40 - 48 - dashboardPadding[3] * 2, groupPanel)
  y = y + dashboardPadding[3] * 4
  local border = seexports.rl_gui:createGuiElement("hr", dashboardPadding[3] * 4, y - 1, sx - menuW - dashboardPadding[3] * 8, 2, groupPanel)
  y = y + dashboardPadding[3] * 6
  local label = seexports.rl_gui:createGuiElement("label", x, y, 0, 0, groupPanel)
  seexports.rl_gui:setLabelFont(label, groupFonts[2])
  seexports.rl_gui:setLabelAlignment(label, "left", "top")
  seexports.rl_gui:setLabelText(label, "Leírás")
  y = y + seexports.rl_gui:getLabelFontHeight(label) + dashboardPadding[3] * 2
  local w, h = sx - menuW - dashboardPadding[3] * 4 * 2, sy - y - dashboardPadding[3] * 4
  local rect = seexports.rl_gui:createGuiElement("rectangle", dashboardPadding[3] * 4, y, w, h, groupPanel)
  seexports.rl_gui:setGuiBackground(rect, "solid", "v4grey1")
  local label = seexports.rl_gui:createGuiElement("label", dashboardPadding[3], dashboardPadding[3], w - dashboardPadding[3] * 2, h - dashboardPadding[3] * 2, rect)
  seexports.rl_gui:setLabelFont(label, groupFonts[6])
  seexports.rl_gui:setLabelAlignment(label, "left", "top")
  seexports.rl_gui:setLabelWordBreak(label, true)
  seexports.rl_gui:setLabelText(label, groupDatas[selectedGroup].motd)
  if groupDatas[selectedGroup].isLeader then
    groupDescriptionInput = seexports.rl_gui:createGuiElement("input", 0, 0, w, h, rect)
    seexports.rl_gui:setInputFont(groupDescriptionInput, groupFonts[6])
    seexports.rl_gui:setInputPlaceholder(groupDescriptionInput, "Leírás")
    seexports.rl_gui:setInputMaxLength(groupDescriptionInput, 1000)
    seexports.rl_gui:setInputMultiline(groupDescriptionInput, true)
    seexports.rl_gui:setInputFontPaddingHeight(groupDescriptionInput, 32)
    seexports.rl_gui:disableClickTrough(groupDescriptionInput, true)
    seexports.rl_gui:setInputValue(groupDescriptionInput, groupDatas[selectedGroup].motd)
    seexports.rl_gui:setGuiRenderDisabled(groupDescriptionInput, true)
    local btn = seexports.rl_gui:createGuiElement("button", w - 24, h - 24, 24, 24, rect)
    seexports.rl_gui:setGuiBackground(btn, "solid", "v4blue")
    seexports.rl_gui:setGuiHover(btn, "gradient", {
      "v4blue",
      "v4blue-second"
    }, false, true)
    seexports.rl_gui:setButtonFont(btn, groupFonts[1])
    seexports.rl_gui:disableClickTrough(btn, true)
    seexports.rl_gui:setButtonIcon(btn, seexports.rl_gui:getFaIconFilename("pen", 24))
    seexports.rl_gui:setClickEvent(btn, "editGroupMOTD")
    seexports.rl_gui:guiSetTooltip(btn, "Leírás szerkesztése")
  end
end
addEvent("doneGatesMembersEdit", false)
addEventHandler("doneGatesMembersEdit", getRootElement(), function(button, state, absoluteX, absoluteY, el)
  seexports.rl_gui:deleteGuiElement(el)
  createGroupLoader()
  local members = {}
  for i = 1, #gatesMembersList do
    if gatesMembersList[i] and gatesMembersList[i][4] then
      table.insert(members, gatesMembersList[i][1])
    end
  end
  triggerLatentServerEvent("editGroupGatesMembers", localPlayer, selectedGroup, selectedGate, members)
end)
addEvent("selectGatesMemberCheckbox", false)
addEventHandler("selectGatesMemberCheckbox", getRootElement(), function(button, state, absoluteX, absoluteY, el)
  for i = 1, #gatesMemberElements do
    if gatesMemberElements[i][3] == el then
      if gatesMembersList[i + gatesMemberScroll] then
        gatesMembersList[i + gatesMemberScroll][4] = seexports.rl_gui:isCheckboxChecked(el)
        processGroupGatesMemberList()
      end
      return
    end
  end
end)
addEvent("editGatesPermissions", false)
addEventHandler("editGatesPermissions", getRootElement(), function(button, state, absoluteX, absoluteY, el)
  if not selectedGate then
    return
  else
    local found = false
    for i = 1, #groupGates do
      if groupGates[i] == selectedGate then
        found = true
        break
      end
    end
    if not found then
      return
    end
  end
  gateMemberEditing = true
  table.sort(interiorMemberList, groupVehicleMemberSortEx)
  processGroupGatesMemberList()
  seexports.rl_gui:setImageFile(gatePermissionEditButton, seexports.rl_gui:getFaIconFilename("save", 32))
  seexports.rl_gui:setClickEvent(gatePermissionEditButton, "doneGatesMembersEdit")
end)
function processGroupGatesMemberList()
  local w, h = seexports.rl_gui:getGuiSize(gatesMemberBg)
  local n = math.max(0, #gatesMembersList - #gatesMemberElements)
  h = h / (n + 1)
  if n < gatesMemberScroll then
    gatesMemberScroll = n
  end
  seexports.rl_gui:setGuiSize(gatesMemberScrollBar, false, h)
  seexports.rl_gui:setGuiPosition(gatesMemberScrollBar, false, h * gatesMemberScroll)
  for i = 1, #gatesMemberElements do
    if gatesMembersList[i + gatesMemberScroll] then
      local hasPerm = gatesMembersList[i + gatesMemberScroll][4]
      seexports.rl_gui:setGuiRenderDisabled(gatesMemberElements[i][1], false)
      seexports.rl_gui:setGuiRenderDisabled(gatesMemberElements[i][2], false)
      local label = gatesMemberElements[i][1]
      seexports.rl_gui:setLabelText(label, gatesMembersList[i + gatesMemberScroll][2])
      local w, h = seexports.rl_gui:getGuiSize(label)
      seexports.rl_gui:setLabelColor(label, hasPerm and "#ffffff" or "v4midgrey")
      local label = gatesMemberElements[i][2]
      local rank = gatesMembersList[i + gatesMemberScroll][3]
      seexports.rl_gui:setLabelColor(label, hasPerm and "v4" .. (groupDatas[selectedGroup].rankColors[rank] or "blue") or "v4midgrey")
      seexports.rl_gui:setLabelText(label, (groupDatas[selectedGroup].ranks[rank] or "N/A") .. " [" .. rank .. "]")
      local checkbox = gatesMemberElements[i][3]
      if gateMemberEditing then
        seexports.rl_gui:setGuiRenderDisabled(checkbox, false)
        seexports.rl_gui:setCheckboxChecked(checkbox, hasPerm)
        seexports.rl_gui:setGuiSize(label, w - h, false)
      else
        seexports.rl_gui:setGuiRenderDisabled(checkbox, true)
        seexports.rl_gui:setGuiSize(label, w, false)
      end
      if gatesMemberElements[i][4] then
        seexports.rl_gui:setGuiRenderDisabled(gatesMemberElements[i][4], false)
      end
    else
      seexports.rl_gui:setGuiRenderDisabled(gatesMemberElements[i][1], true)
      seexports.rl_gui:setGuiRenderDisabled(gatesMemberElements[i][2], true)
      seexports.rl_gui:setGuiRenderDisabled(gatesMemberElements[i][3], true)
      if gatesMemberElements[i][4] then
        seexports.rl_gui:setGuiRenderDisabled(gatesMemberElements[i][4], true)
      end
    end
  end
end
addEvent("selectGroupGate", false)
addEventHandler("selectGroupGate", getRootElement(), function(button, state, absoluteX, absoluteY, el)
  for i = 1, #gatesElements do
    if gatesElements[i][1] == el and groupGates[i + gatesScroll] then
      selectedGate = groupGates[i + gatesScroll]
      gatesMemberScroll = 0
      processGroupGatesList()
      processSelectedGate()
      return
    end
  end
end)
function processSelectedGate()
  gateMemberEditing = false
  if selectedGate then
    for i = 1, #groupGates do
      if groupGates[i] == selectedGate then
        gatesMembersList = {}
        for i = 1, #groupDatas[selectedGroup].members do
          if not groupDatas[selectedGroup].members[i][3] then
            table.insert(gatesMembersList, {
              groupDatas[selectedGroup].members[i][7],
              groupDatas[selectedGroup].members[i][1],
              groupDatas[selectedGroup].members[i][2],
              groupDatas[selectedGroup].gateMembers[selectedGate][groupDatas[selectedGroup].members[i][7]]
            })
          end
        end
        table.sort(gatesMembersList, groupVehicleMemberSort)
        seexports.rl_gui:setLabelText(gateNameLabel, "Kapu #" .. selectedGate)
        processGroupGatesMemberList()
        return
      end
    end
  end
  seexports.rl_gui:setLabelText(gateNameLabel, "Válassz kaput!")
  for i = 1, #gatesMemberElements do
    seexports.rl_gui:setGuiRenderDisabled(gatesMemberElements[i][1], true)
    seexports.rl_gui:setGuiRenderDisabled(gatesMemberElements[i][2], true)
    if gatesMemberElements[i][3] then
      seexports.rl_gui:setGuiRenderDisabled(gatesMemberElements[i][3], true)
    end
  end
end
function processGroupGatesList()
  local w, h = seexports.rl_gui:getGuiSize(gatesBg)
  local n = math.max(0, #groupGates - #interiorElements)
  h = h / (n + 1)
  if n < gatesScroll then
    gatesScroll = n
  end
  seexports.rl_gui:setGuiSize(gatesScrollBar, false, h)
  seexports.rl_gui:setGuiPosition(gatesScrollBar, false, h * gatesScroll)
  for i = 1, #gatesElements do
    if groupGates[i + gatesScroll] then
      seexports.rl_gui:setGuiRenderDisabled(gatesElements[i][1], false)
      seexports.rl_gui:setGuiRenderDisabled(gatesElements[i][2], false)
      if gatesElements[i][3] then
        seexports.rl_gui:setGuiRenderDisabled(gatesElements[i][3], false)
      end
      if not selectedGate then
        selectedGate = groupGates[i + gatesScroll]
      end
      local rect = gatesElements[i][1]
      if groupGates[i + gatesScroll] == selectedGate then
        seexports.rl_gui:setGuiHoverable(rect, false)
        seexports.rl_gui:setGuiBackground(rect, "solid", "v4grey3")
      else
        seexports.rl_gui:setGuiHoverable(rect, true)
        seexports.rl_gui:setGuiBackground(rect, "solid", "v4grey1")
      end
      local label = gatesElements[i][2]
      seexports.rl_gui:setLabelText(label, "Kapu #" .. groupGates[i + gatesScroll])
    else
      seexports.rl_gui:setGuiRenderDisabled(gatesElements[i][1], true)
      seexports.rl_gui:setGuiRenderDisabled(gatesElements[i][2], true)
      if gatesElements[i][3] then
        seexports.rl_gui:setGuiRenderDisabled(gatesElements[i][3], true)
      end
    end
  end
end
function drawGroupGates()
  local label = seexports.rl_gui:createGuiElement("label", dashboardPadding[3] * 4, 40, 0, 48, groupPanel)
  seexports.rl_gui:setLabelFont(label, groupFonts[3])
  seexports.rl_gui:setLabelAlignment(label, "left", "center")
  seexports.rl_gui:setLabelText(label, "Kapuk: " .. #groupGates)
  local w = math.ceil((sx - menuW) * 0.45)
  local h = sy - 40 - dashboardPadding[3] * 8 - 48
  gatesBg = seexports.rl_gui:createGuiElement("rectangle", dashboardPadding[3] * 4, 88 + dashboardPadding[3] * 4, w, h, groupPanel)
  seexports.rl_gui:setGuiBackground(gatesBg, "solid", "v4grey1")
  local sbg = seexports.rl_gui:createGuiElement("rectangle", w - 2, 0, 2, h, gatesBg)
  seexports.rl_gui:setGuiBackground(sbg, "solid", "v4grey3")
  gatesScrollBar = seexports.rl_gui:createGuiElement("rectangle", w - 2, 0, 2, h, gatesBg)
  seexports.rl_gui:setGuiBackground(gatesScrollBar, "solid", "v4midgrey")
  local n = math.floor(h / 32)
  h = h / n
  gatesElements = {}
  y = 0
  for i = 1, n do
    if groupGates[i] then
      gatesElements[i] = {}
      local rect = seexports.rl_gui:createGuiElement("rectangle", 0, y, w - 2, h - 1, gatesBg)
      seexports.rl_gui:setGuiBackground(rect, "solid", "v4grey1")
      seexports.rl_gui:setGuiHover(rect, "gradient", {"v4grey1", "v4grey2"}, false, true)
      seexports.rl_gui:setGuiHoverable(rect, true)
      seexports.rl_gui:setClickEvent(rect, "selectGroupGate")
      gatesElements[i][1] = rect
      local label = seexports.rl_gui:createGuiElement("label", dashboardPadding[3] * 2, 0, 0, h, rect)
      seexports.rl_gui:setLabelFont(label, groupFonts[4])
      seexports.rl_gui:setLabelAlignment(label, "left", "center")
      gatesElements[i][2] = label
      if i < n then
        local border = seexports.rl_gui:createGuiElement("hr", 0, h - 1, w - 2, 2, rect)
        seexports.rl_gui:setGuiHrColor(border, "v4grey3", "v4grey2")
        gatesElements[i][3] = border
      end
    end
    y = y + h
  end
  x = dashboardPadding[3] * 4 + w
  y = 88 + dashboardPadding[3] * 4
  local w = sx - menuW - x
  x = x + dashboardPadding[3] * 4
  gateNameLabel = seexports.rl_gui:createGuiElement("label", x, y, w, 0, groupPanel)
  seexports.rl_gui:setLabelFont(gateNameLabel, groupFonts[3])
  seexports.rl_gui:setLabelAlignment(gateNameLabel, "left", "top")
  y = y + seexports.rl_gui:getLabelFontHeight(label) + dashboardPadding[3] * 4
  local label = seexports.rl_gui:createGuiElement("label", x, y, 0, 0, groupPanel)
  seexports.rl_gui:setLabelFont(label, groupFonts[2])
  seexports.rl_gui:setLabelAlignment(label, "left", "top")
  seexports.rl_gui:setLabelText(label, "Kapu jogosultságai:")
  local h = seexports.rl_gui:getLabelFontHeight(label)
  w = w - dashboardPadding[3] * 4 * 2
  if groupDatas[selectedGroup].isLeader or seexports.rl_groups:getPlayerPermissionInGroup(selectedGroup, "manageKeysGate") then
    gatePermissionEditButton = seexports.rl_gui:createGuiElement("image", x + w - h, y, h, h, groupPanel)
    seexports.rl_gui:setImageFile(gatePermissionEditButton, seexports.rl_gui:getFaIconFilename("pen", 32))
    seexports.rl_gui:setGuiHover(gatePermissionEditButton, "solid", "v4green")
    seexports.rl_gui:setGuiHoverable(gatePermissionEditButton, true)
    seexports.rl_gui:setClickEvent(gatePermissionEditButton, "editGatesPermissions")
    seexports.rl_gui:guiSetTooltip(gatePermissionEditButton, "Kapu jogosultságainak szerkesztése")
  else
    gatePermissionEditButton = false
  end
  y = y + h + dashboardPadding[3] * 2
  local h = sy - y - dashboardPadding[3] * 4
  local n = math.floor(h / 32)
  h = h / n
  gatesMemberBg = seexports.rl_gui:createGuiElement("rectangle", x, y, w, h * n, groupPanel)
  seexports.rl_gui:setGuiBackground(gatesMemberBg, "solid", "v4grey1")
  local border = seexports.rl_gui:createGuiElement("hr", 0, -1, w, 2, gatesMemberBg)
  seexports.rl_gui:setGuiHrColor(border, "v4grey3", "v4grey2")
  local sbg = seexports.rl_gui:createGuiElement("rectangle", w - 2, 0, 2, h * n, gatesMemberBg)
  seexports.rl_gui:setGuiBackground(sbg, "solid", "v4grey3")
  gatesMemberScrollBar = seexports.rl_gui:createGuiElement("rectangle", w - 2, 0, 2, h * n, gatesMemberBg)
  seexports.rl_gui:setGuiBackground(gatesMemberScrollBar, "solid", "v4midgrey")
  gatesMemberElements = {}
  y = 0
  for i = 1, n do
    gatesMemberElements[i] = {}
    local label = seexports.rl_gui:createGuiElement("label", dashboardPadding[3] * 2, y, w - dashboardPadding[3] * 2 - 2, h, gatesMemberBg)
    seexports.rl_gui:setLabelFont(label, groupFonts[4])
    seexports.rl_gui:setLabelAlignment(label, "left", "center")
    gatesMemberElements[i][1] = label
    local label = seexports.rl_gui:createGuiElement("label", 0, y, 0, h, gatesMemberBg)
    seexports.rl_gui:setLabelFont(label, groupFonts[5])
    seexports.rl_gui:setLabelAlignment(label, "right", "center")
    gatesMemberElements[i][2] = label
    local checkbox = seexports.rl_gui:createGuiElement("checkbox", 0 + w - h - 2, y + 2, h - 4, h - 4, gatesMemberBg)
    seexports.rl_gui:setGuiColorScheme(checkbox, "darker")
    seexports.rl_gui:setClickEvent(checkbox, "selectGatesMemberCheckbox")
    gatesMemberElements[i][3] = checkbox
    if n > i then
      local border = seexports.rl_gui:createGuiElement("hr", 0, y + h - 1, w - 2, 2, gatesMemberBg)
      seexports.rl_gui:setGuiHrColor(border, "v4grey3", "v4grey2")
      gatesMemberElements[i][4] = border
    end
    y = y + h
  end
  processGroupGatesList()
  processSelectedGate()
end
function drawGroupPanel()
  deleteGroupLoader()
  if groupModal then
    seexports.rl_gui:deleteGuiElement(groupModal)
  end
  groupModal = false
  if groupPanel then
    seexports.rl_gui:deleteGuiElement(groupPanel)
  end
  groupDescriptionInput = false
  menuButtons = {}
  if selectedGroup and groupDatas[selectedGroup] then
    groupPanel = seexports.rl_gui:createGuiElement("null", menuW, 0, sx - menuW, sy, inside)
    local x = 0
    local w = (sx - menuW) / 6
    local btn = seexports.rl_gui:createGuiElement("button", x, 0, w, 40, groupPanel)
    if selectedMenu == "home" then
      seexports.rl_gui:setGuiBackground(btn, "solid", "v4green")
      seexports.rl_gui:setGuiHoverable(btn, false)
    else
      seexports.rl_gui:setGuiBackground(btn, "solid", "v4grey1")
      seexports.rl_gui:setGuiHover(btn, "gradient", {"v4grey2", "v4grey1"}, false, true)
      seexports.rl_gui:setClickEvent(btn, "switchGroupPanelMenu")
    end
    seexports.rl_gui:setButtonFont(btn, groupFonts[1])
    seexports.rl_gui:setButtonTextColor(btn, "#ffffff")
    seexports.rl_gui:setButtonText(btn, " Ana sayfa")
    seexports.rl_gui:setButtonIcon(btn, seexports.rl_gui:getFaIconFilename("home", 40))
    menuButtons[btn] = "home"
    x = x + w
    local btn = seexports.rl_gui:createGuiElement("button", x, 0, w, 40, groupPanel)
    if selectedMenu == "members" then
      seexports.rl_gui:setGuiBackground(btn, "solid", "v4green")
      seexports.rl_gui:setGuiHoverable(btn, false)
    else
      seexports.rl_gui:setGuiBackground(btn, "solid", "v4grey1")
      seexports.rl_gui:setGuiHover(btn, "gradient", {"v4grey2", "v4grey1"}, false, true)
      seexports.rl_gui:setClickEvent(btn, "switchGroupPanelMenu")
    end
    seexports.rl_gui:setButtonFont(btn, groupFonts[1])
    seexports.rl_gui:setButtonTextColor(btn, "#ffffff")
    seexports.rl_gui:setButtonText(btn, " Tagok")
    seexports.rl_gui:setButtonIcon(btn, seexports.rl_gui:getFaIconFilename("users", 40))
    menuButtons[btn] = "members"
    x = x + w
    local btn = seexports.rl_gui:createGuiElement("button", x, 0, w, 40, groupPanel)
    if selectedMenu == "ranks" then
      seexports.rl_gui:setGuiBackground(btn, "solid", "v4green")
      seexports.rl_gui:setGuiHoverable(btn, false)
    else
      seexports.rl_gui:setGuiBackground(btn, "solid", "v4grey1")
      seexports.rl_gui:setGuiHover(btn, "gradient", {"v4grey2", "v4grey1"}, false, true)
      seexports.rl_gui:setClickEvent(btn, "switchGroupPanelMenu")
    end
    seexports.rl_gui:setButtonFont(btn, groupFonts[1])
    seexports.rl_gui:setButtonTextColor(btn, "#ffffff")
    seexports.rl_gui:setButtonText(btn, " Rangok")
    seexports.rl_gui:setButtonIcon(btn, seexports.rl_gui:getFaIconFilename("id-badge", 40))
    menuButtons[btn] = "ranks"
    x = x + w
    local btn = seexports.rl_gui:createGuiElement("button", x, 0, w, 40, groupPanel)
    if selectedMenu == "vehicles" then
      seexports.rl_gui:setGuiBackground(btn, "solid", "v4green")
      seexports.rl_gui:setGuiHoverable(btn, false)
    else
      seexports.rl_gui:setGuiBackground(btn, "solid", "v4grey1")
      seexports.rl_gui:setGuiHover(btn, "gradient", {"v4grey2", "v4grey1"}, false, true)
      seexports.rl_gui:setClickEvent(btn, "switchGroupPanelMenu")
    end
    seexports.rl_gui:setButtonFont(btn, groupFonts[1])
    seexports.rl_gui:setButtonTextColor(btn, "#ffffff")
    seexports.rl_gui:setButtonText(btn, " Araçlar")
    seexports.rl_gui:setButtonIcon(btn, seexports.rl_gui:getFaIconFilename("car", 40))
    menuButtons[btn] = "vehicles"
    x = x + w
    local btn = seexports.rl_gui:createGuiElement("button", x, 0, w, 40, groupPanel)
    if selectedMenu == "interiors" then
      seexports.rl_gui:setGuiBackground(btn, "solid", "v4green")
      seexports.rl_gui:setGuiHoverable(btn, false)
    else
      seexports.rl_gui:setGuiBackground(btn, "solid", "v4grey1")
      seexports.rl_gui:setGuiHover(btn, "gradient", {"v4grey2", "v4grey1"}, false, true)
      seexports.rl_gui:setClickEvent(btn, "switchGroupPanelMenu")
    end
    seexports.rl_gui:setButtonFont(btn, groupFonts[1])
    seexports.rl_gui:setButtonTextColor(btn, "#ffffff")
    seexports.rl_gui:setButtonText(btn, " Interiorok")
    seexports.rl_gui:setButtonIcon(btn, seexports.rl_gui:getFaIconFilename("building", 40))
    menuButtons[btn] = "interiors"
    x = x + w
    local btn = seexports.rl_gui:createGuiElement("button", x, 0, w, 40, groupPanel)
    if selectedMenu == "gates" then
      seexports.rl_gui:setGuiBackground(btn, "solid", "v4green")
      seexports.rl_gui:setGuiHoverable(btn, false)
    else
      seexports.rl_gui:setGuiBackground(btn, "solid", "v4grey1")
      seexports.rl_gui:setGuiHover(btn, "gradient", {"v4grey2", "v4grey1"}, false, true)
      seexports.rl_gui:setClickEvent(btn, "switchGroupPanelMenu")
    end
    seexports.rl_gui:setButtonFont(btn, groupFonts[1])
    seexports.rl_gui:setButtonTextColor(btn, "#ffffff")
    seexports.rl_gui:setButtonText(btn, " Kapuk")
    seexports.rl_gui:setButtonIconDDS(btn, ":rl_gates/files/icon.dds")
    menuButtons[btn] = "gates"
    if selectedMenu == "home" then
      drawGroupHome()
    elseif selectedMenu == "members" then
      drawGroupMembers()
    elseif selectedMenu == "ranks" then
      drawGroupRanks()
    elseif selectedMenu == "vehicles" then
      drawGroupVehicles()
    elseif selectedMenu == "interiors" then
      drawGroupInteriors()
    elseif selectedMenu == "gates" then
      drawGroupGates()
    end
  else
    groupPanel = false
  end
end
function processSideMenu()
  for el, group in pairs(sideMenu) do
    if selectedGroup == group then
      seexports.rl_gui:setGuiBackground(el, "solid", "v4grey2")
      seexports.rl_gui:setGuiHoverable(el, false)
    else
      seexports.rl_gui:setGuiBackground(el, "solid", "v4grey1")
      seexports.rl_gui:setGuiHoverable(el, true)
      seexports.rl_gui:setClickEvent(el, "switchGroupPanelGroup")
    end
  end
end
function drawGroupSideMenu()
  for el in pairs(sideMenu) do
    if el then
      seexports.rl_gui:deleteGuiElement(el)
    end
  end
  sideMenu = {}
  local n = math.max(10, #groupList)
  local h = sy / n
  if not selectedGroup then
    selectedGroup = groupList[1] and groupList[1][1]
    requestSelectedGroup()
    selectedMenu = "home"
    processSideMenu()
    createGroupLoader()
  end
  for i = 1, n do
    if groupList[i] then
      local bcg = seexports.rl_gui:createGuiElement("rectangle", 0, (i - 1) * h, menuW, h, inside)
      seexports.rl_gui:setGuiHover(bcg, "gradient", {"v4grey4", "v4grey1"}, false, true)
      if selectedGroup == groupList[i][1] then
        seexports.rl_gui:setGuiBackground(bcg, "solid", "v4grey4")
      else
        seexports.rl_gui:setGuiBackground(bcg, "solid", "v4grey1")
        seexports.rl_gui:setGuiHoverable(bcg, true)
        seexports.rl_gui:setClickEvent(bcg, "switchGroupPanelGroup")
      end
      sideMenu[bcg] = groupList[i][1]
      local label = seexports.rl_gui:createGuiElement("label", 0, 0, menuW, h, bcg)
      seexports.rl_gui:setLabelFont(label, groupFonts[2])
      seexports.rl_gui:setLabelAlignment(label, "center", "center")
      if seexports.rl_gui:getTextWidthFont(groupList[i][2], groupFonts[2]) > menuW - 16 then
        seexports.rl_gui:setLabelText(label, groupList[i][1])
      else
        seexports.rl_gui:setLabelText(label, groupList[i][2])
      end
    end
  end
end
function drawGroups()
  menuW = math.floor(sx * 0.27)
  if inside then
    seexports.rl_gui:deleteGuiElement(inside)
  end
  inside = seexports.rl_gui:createGuiElement("null", 0, 0, sx, sy, rtg)
  local rect = seexports.rl_gui:createGuiElement("rectangle", menuW, 0, sx - menuW, sy, inside)
  seexports.rl_gui:setGuiBackground(rect, "solid", "v4grey2")
  local rect = seexports.rl_gui:createGuiElement("rectangle", 0, 0, menuW, sy, inside)
  seexports.rl_gui:setGuiBackground(rect, "solid", "v4grey1")
  drawGroupSideMenu()
  drawGroupPanel()
end
function resetGroupGuiValues()
  groupDescriptionInput = false
  groupLoader = false
  groupLoaderIcon = false
  groupModal = false
  groupPanel = false
  interiorDataBg = false
  interiorDataButton = false
  interiorMemberBg = false
  interiorMemberButton = false
  interiorMemberEditButton = false
  interiorMemberScrollBar = false
  interiorNameLabel = false
  interiorsBg = false
  interiorSidePanel = false
  interiorsScrollBar = false
  interiorTypeLabel = false
  memberAddedLabel = false
  memberBg = false
  memberFireButton = false
  memberLastOnlineLabel = false
  memberLeaderLabel = false
  memberNameLabel = false
  memberPromotedLabel = false
  memberRankEdit = false
  memberRankLabel = false
  memberSalaryLabel = false
  memberScrollBar = false
  newMemberInput = false
  groupBalanceInput = false
  perMemberBg = false
  perMemberScrollBar = false
  rankBg = false
  rankDeleteButton = false
  rankUpButton = false
  rankDownButton = false
  rankEditButton = false
  rankNameInput = false
  rankNameLabel = false
  rankNumLabel = false
  rankPermBg = false
  rankPermissionEditButton = false
  rankPermScrollbar = false
  rankSalaryInput = false
  rankSalaryLabel = false
  rankScrollbar = false
  vehicleDataBg = false
  vehicleDataButton = false
  vehicleMemberBg = false
  vehicleMemberButton = false
  vehicleMemberEditButton = false
  vehicleMemberScrollBar = false
  vehicleNameLabel = false
  vehiclePlateLabel = false
  vehiclesBg = false
  vehicleSidePanel = false
  vehiclesScrollBar = false
  gateMemberEditing = false
  gateNameLabel = false
  gatePermissionEditButton = false
end
function resetGroupGuiValues2()
  sideMenu = {}
  memberElements = {}
  rankElements = {}
  rankEditColorElements = {}
  vehicleElements = {}
  vehicleMemberElements = {}
  interiorElements = {}
  interiorMemberElements = {}
  gatesElements = {}
  gatesMemberElements = {}
end
function groupsInsideDestroy()
  inside = false
  rtg = false
  resetGroupGuiValues()
  resetGroupGuiValues2()
  removeEventHandler("onClientKey", getRootElement(), groupPanelScrollKey)
end
function groupsInsideDraw(x, y, isx, isy, i, j, irtg)
  rtg = irtg
  sx, sy = isx, isy
  addEventHandler("onClientKey", getRootElement(), groupPanelScrollKey)
  drawGroups()
  createGroupLoader()
  triggerServerEvent("requestPlayerGroupList", localPlayer)
end
