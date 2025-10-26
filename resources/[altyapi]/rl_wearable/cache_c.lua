local self = {}
self.usings = {}

local playerWearables = {}
local shownAccesories = false

local sx, sy = guiGetScreenSize()
local font = exports.rl_fonts:getFont("sf-regular", 9)
local currentRow, maxRow = 1, 11
local lastClick = 0
local selectedIndex = 0

addEventHandler("onClientPreRender", root, function()
    if localPlayer:getData("logged") then
        if localPlayer:getData("playerWearables") and #localPlayer:getData("playerWearables") > 0 then
            for index, value in ipairs(localPlayer:getData("playerWearables")) do
                self.object = value["object"]
                if not isElement(self.object) then
                    break
                end
                if getElementInterior(self.object) ~= getElementInterior(localPlayer) then
                    triggerServerEvent("wearable.updatePosition", resourceRoot, self.object, getElementInterior(localPlayer), getElementDimension(localPlayer))
                    setElementInterior(self.object, getElementInterior(localPlayer))
                end
                if getElementDimension(self.object) ~= getElementDimension(localPlayer) then
                    triggerServerEvent("wearable.updatePosition", resourceRoot, self.object, getElementInterior(localPlayer), getElementDimension(localPlayer))
                    setElementInterior(self.object, getElementDimension(localPlayer))
                end
            end
        end
    end
end)

addEventHandler("onClientResourceStart", resourceRoot, function()
    localPlayer:setData("playerWearables", {})
    if localPlayer:getData("logged") then
        triggerServerEvent("wearable.loadMyWearables", root, localPlayer)
    end
end)

addEventHandler("onClientElementDataChange", localPlayer, function(dataName, oldValue, newValue)
    if (source ~= localPlayer) then
        return
    end
	
    if dataName == "logged" then
        local data = getElementData(source, dataName)
        if data then
            triggerServerEvent("wearable.loadMyWearables", root, source)
        end
    end
end)

addEvent("wearable.loadWearables", true)
addEventHandler("wearable.loadWearables", root, function(_playerWearables)
    playerWearables = _playerWearables
end)

addCommandHandler("aksesuar", function(cmd)
    if localPlayer:getData("logged") then
        shownAccesories = not shownAccesories
        if shownAccesories then
			triggerServerEvent("wearable.loadMyWearables", root, localPlayer)
        end
    end
end)

addEventHandler("onClientRender", root, function()
    if not shownAccesories then return end
    w, h = 420, 350
    x, y = sx/2-w/2, sy/2-h/2
    dxDrawRectangle(x, y, w, h, tocolor(0, 0, 0, 80))
    x, y, w, h = x+2, y+2, w-4, h-4
	dxDrawRectangle(x, y, w, h, tocolor(0, 0, 0, 80))
	dxDrawRectangle(x, y, w, 25, tocolor(0, 0, 0, 80))
    dxDrawRectangle(x+w-25, y, 25, 25, tocolor(255, 0, 0, 100))
    dxDrawRectangle(x+w-23, y+2, 21, 21, tocolor(0, 0, 0, 100))
    dxDrawText("x", x+w-25, y, 25+(x+w-25), y+25, tocolor(255, 255, 255), 1, font, "center", "center")
    dxDrawText("Aksesuarlarım - (" .. #localPlayer:getData("playerWearables") .. "/4)", x, y, w+x, 25+y, tocolor(255, 255, 255), 1, font, "center", "center")
    if exports.rl_ui:inArea(x+w-25, y, 25, 25) then
        dxDrawRectangle(x+w-25, y, 25, 25, tocolor(232, 65, 24, 50))
        if getKeyState("mouse1") and lastClick+200 <= getTickCount() then
            lastClick = getTickCount()
            currentRow = 1
            selectedIndex = 0
            shownAccesories = false
        end
    end
    y, h = y+26, h-28
	x, w = x+2, w-4
	x, y, w, h = x+2, y+2, w-4, h-4
    dxDrawRectangle(x, y, w, h, tocolor(0, 0, 0, 60))

	local index = 0
	for i = 1, 11 do
		if i % 2 ~= 0 then
			dxDrawRectangle(x, y+(index*25), w, 25, tocolor(0, 0, 0, 160))
		else
			dxDrawRectangle(x, y+(index*25), w, 25, tocolor(0, 0, 0, 120))
		end
		if exports.rl_ui:inArea(x, y+(index*25), w, 25) then
			dxDrawRectangle(x, y+(index*25), w, 25, tocolor(0, 0, 0, 50))
		end
		index = index + 1
    end
    dxDrawRectangle(x+w-3, y, 3, 25, tocolor(85, 155, 255))
    local y = y - 25
    local latestRow = currentRow + maxRow - 1
    local i = 1
    if #playerWearables > 0 then
        for index, value in ipairs(playerWearables) do
            if index >= currentRow and index <= latestRow then
            	index = index - currentRow + 1
                if exports.rl_ui:inArea(x, y+(index*25), w, 25) then
                    _, checkIt = self:checkUsingModel(value.id)
                    dxDrawText("• " .. self:findThenModelName(value.model) .. " (" .. self:checkUsingModel(value.id) .. ")", x+5, y+(index*25), w+5, 25+(y+(index*25)), tocolor(85, 155, 255), 1, font, "left", "center")
                    if getKeyState("mouse1") and lastClick+200 <= getTickCount() then
                        lastClick = getTickCount()
                        if selectedIndex ~= index then
                            selectedIndex = index
                        else
                            --selectedIndex = 0
                            if checkIt == true then
                                triggerServerEvent("wearable.detachArtifact", localPlayer, localPlayer, playerWearables[index])
                            else
                                if #(localPlayer:getData("playerWearables")) < 4 then
                                    triggerServerEvent("wearable.useArtifact", localPlayer, localPlayer, playerWearables[index])
                                else
                                    outputChatBox("#ff2400[!]#FFFFFF Aynı anda en fazla 4 aksesuar takabilirsiniz.", 255, 0, 0, true)
                                end
                            end
                        end
                    end
                else
                    if selectedIndex == index then
                        dxDrawText("• " .. self:findThenModelName(value.model) .. " (" .. self:checkUsingModel(value.id) .. ")", x+5, y+(index*25), w+5, 25+(y+(index*25)), tocolor(85, 155, 255), 1, font, "left", "center")
                    else
                        dxDrawText("• " .. self:findThenModelName(value.model) .. " (" .. self:checkUsingModel(value.id) .. ")", x+5, y+(index*25), w+5, 25+(y+(index*25)), tocolor(225, 225, 225), 1, font, "left", "center")
                    end
                end
                --index = index + 1
            end
        end
        i = i + 1
    end
    y = y+(12*25)+6
	w = w/2-4
	dxDrawRectangle(x, y, w, 25, tocolor(0, 255, 0, 100))
	dxDrawRectangle(x+2, y+2, w-4, 21, tocolor(0, 0, 0, 100))
	if exports.rl_ui:inArea(x, y, w, 25) then
		dxDrawRectangle(x, y, w, 25, tocolor(0, 255, 0, 50))
		if getKeyState("mouse1") and lastClick+200 <= getTickCount() then
			lastClick = getTickCount()
            if selectedIndex ~= 0 then
                _, checkIt = self:checkUsingModel(playerWearables[selectedIndex]['id'])
                if checkIt then
                    triggerServerEvent("wearable.detachArtifact", localPlayer, localPlayer, playerWearables[selectedIndex])
                end
                moving_object(playerWearables[selectedIndex]['model'], playerWearables[selectedIndex]['id'])
                shownAccesories = false
            end
		end
	end
	dxDrawText("Seçilenin Yerini Ayarla", x, y, w+x, 25+y, tocolor(255, 255, 255), 1, font, "center", "center")
	
	x = x+w+4
	dxDrawRectangle(x, y, w, 25, tocolor(255, 0, 0, 100))
	dxDrawRectangle(x+2, y+2, w-4, 21, tocolor(0, 0, 0, 100))
	if exports.rl_ui:inArea(x, y, w, 25) then
		dxDrawRectangle(x, y, w, 25, tocolor(255, 0, 0, 50))
		if getKeyState("mouse1") and lastClick+200 <= getTickCount() then
            lastClick = getTickCount()
            if selectedIndex == 0 then
                currentRow = 1
                selectedIndex = 0
                shownAccesories = false
            else
                triggerServerEvent("wearable.delete", localPlayer, localPlayer, playerWearables[selectedIndex]['id'])
                currentRow = 1
                selectedIndex = 0
                shownAccesories = false
            end
		end
    end
    if selectedIndex == 0 then
        dxDrawText("Arayüzü Kapat", x, y, w+x, 25+y, tocolor(255, 255, 255), 1, font, "center", "center")
    else
        dxDrawText("Seçilen Aksesuarı Sil", x, y, w+x, 25+y, tocolor(255, 255, 255), 1, font, "center", "center")
    end
end)

bindKey("mouse_wheel_down", "down", function()
	if shownAccesories then
		if not getElementData(localPlayer, "logged") then
			return
		end

		if currentRow < #playerWearables - (maxRow - 1) then
			currentRow = currentRow + 1
		end
	end
end)

bindKey("mouse_wheel_up", "down", function()
	if shownAccesories then
		if not getElementData(localPlayer, "logged") then
			return
		end
		
		if currentRow > 1 then
			currentRow = currentRow - 1
		end
	end
end)

bindKey("pgdn", "down", function()
	if shownAccesories then
		if not getElementData(localPlayer, "logged") then
			return
		end

		if currentRow < #playerWearables - (maxRow - 1) then
			currentRow = currentRow + 1
		end
	end
end)

bindKey("pgup", "down", function()
	if shownAccesories then
		if not getElementData(localPlayer, "logged") then
			return
		end
		
		if currentRow > 1 then
			currentRow = currentRow - 1
		end
	end
end)

function self:findThenModelName(modelID)
    local name = ""
    for index, value in ipairs(getWearables()) do
        for _, data in ipairs(value['list']) do
            if tonumber(data['modelid']) == tonumber(modelID) then
                return data['dff']
            end
        end
    end
    return name
end

function self:checkUsingModel(dbid)
    for index, data in ipairs(localPlayer:getData('playerWearables')) do
        if (tonumber(data['id']) == tonumber(dbid)) then
            return "✔", true
        end
    end
    return "-", false
end

function findThemBonePosition(modelID)
    for index, value in ipairs(getWearables()) do
        for _, data in ipairs(value['list']) do
            if tonumber(data['modelid']) == tonumber(modelID) then
                return value['position'], value['bone']
            end
        end
    end
    return {0, 0, 0, 0, 0, 0, 1, 1, 1}, 1
end