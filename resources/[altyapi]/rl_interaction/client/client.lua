local screenWidth, screenHeight = guiGetScreenSize()

local state

function dxDrawRoundedRectangle(x, y, width, height, radius, color)
    dxDrawRectangle(x + radius, y, width - 2 * radius, height, color)
    dxDrawRectangle(x, y + radius, radius, height - 2 * radius, color)
    dxDrawRectangle(x + width - radius, y + radius, radius, height - 2 * radius, color)

    dxDrawCircle(x + radius, y + radius, radius, 180, 270, color, color)
    dxDrawCircle(x + width - radius, y + radius, radius, 270, 360, color, color)
    dxDrawCircle(x + radius, y + height - radius, radius, 90, 180, color, color)
    dxDrawCircle(x + width - radius, y + height - radius, radius, 0, 90, color, color)
end

function reMap(value, low1, high1, low2, high2)
	return low2 + (value - low1) * (high2 - low2) / (high1 - low1)
end

local responsiveMultiplier = reMap(screenWidth, 1024, 1920, 0.75, 1)

function getResponsiveMultiplier()
	return responsiveMultiplier
end

local screenX, screenY = guiGetScreenSize()
local responsiveMultipler = getResponsiveMultiplier()

function loadFonts()
    fonts = {
        Roboto14 = exports.kaisen_fonts:getFont("UbuntuBold", 12), 
        Roboto11 = exports.kaisen_fonts:getFont("UbuntuRegular", 10), 
    }
end

local registerEvent = function(eventName, element, func)
	addEvent(eventName, true)
	addEventHandler(eventName, element, func)
end

addEventHandler("onAssetsLoaded", root, function()
	loadFonts()
end)

addEventHandler("onClientResourceStart", resourceRoot, function()
	loadFonts()
end)

function resp(value)
    return value * responsiveMultipler
end

function respc(value)
    return math.ceil(value * responsiveMultipler)
end

Interaction = {}

local selectedElement = nil
local elementInteractions = {}

local panelW, panelH = respc(200), respc(65)
local panelX, panelY

local scrollbarW = respc(12)

local rowW, rowH = panelW, respc(40)
local rowX

local iconW, iconH = respc(40), respc(40)

local actionTextX

local maxRow = 6

local interactionActive = false

local cursorX, cursorY = 0, 0

function updateCursorPos()
    if isCursorShowing() then
        cursorX, cursorY = getCursorPosition()
        cursorX, cursorY = cursorX * screenX, cursorY * screenY
        panelX, panelY = cursorX, cursorY + 100
        rowX = panelX
    end
end

Interaction.Show = function(element)
	if not interactionActive then
		if getElementType(element) == "ped" and not getElementData(element, "name") then
		else
			updateCursorPos()
			elementInteractions = getInteractions(element)
			selectedElement = element
			interactionActive = true
			addEventHandler("onClientRender", root, Interaction.Render)
		end
	else
		elementInteractions = {}
		interactionActive = false
		destroyElementOutlineEffect(selectedElement)
		effectOn = false
		removeEventHandler("onClientRender", root, Interaction.Render)
	end
end

Interaction.Close = function()
    elementInteractions = {}
    interactionActive = false
    destroyElementOutlineEffect(selectedElement)
    effectOn = false
    removeEventHandler("onClientRender", root, Interaction.Render)
end

Interaction.Render = function()
    if interactionActive then
        Interaction.Panel(elementInteractions)
    end
end

Interaction.Panel = function(interactions, durum)
    if interactionActive then
        local px, py, pz = getElementPosition(localPlayer)
        local ex, ey, ez = getElementPosition(selectedElement)
        if getDistanceBetweenPoints3D(px, py, pz, ex, ey, ez) > getElementRadius(selectedElement) * 6 then
            Interaction.Close()
            return
        end
		
        local adjustH = #interactions
        if #interactions > 6 then
            adjustH = maxRow
        end

        if getElementType(selectedElement) == "vehicle" then
			local vehicle = exports.rl_global:getVehicleName(selectedElement)
            local textW = dxGetTextWidth(vehicle, 1, fonts.Roboto14)
            panelW = textW + respc(60)
            rowW = textW + respc(60)
        end

        dxDrawRoundedRectangle(panelX, panelY - 100, panelW, panelH + (rowH * adjustH)+5, 10, tocolor(17, 17, 17, 200))

        if getElementType(selectedElement) == "vehicle" then
			local vehicle = exports.rl_global:getVehicleName(selectedElement)
            dxDrawText(vehicle, panelX, panelY - 100 + respc(13), panelW + panelX, panelH + panelY - 100, tocolor(255, 255, 255, 255), 1, fonts.Roboto14, "center", "top")
    	elseif getElementType(selectedElement) == "player" then
            dxDrawText(getPlayerName(selectedElement):gsub("_", " "), panelX, panelY - 100 + respc(13), panelW + panelX, panelH + panelY - 100, tocolor(255, 255, 255, 255), 1, fonts.Roboto14, "center", "top")
        elseif getElementType(selectedElement) == "ped" then
            dxDrawText(getElementData(selectedElement, "name"):gsub("_", " ") or "N/A", panelX, panelY - 100 + respc(13), panelW + panelX, panelH + panelY - 100, tocolor(255, 255, 255, 255), 1, fonts.Roboto14, "center", "top")
        elseif getElementType(selectedElement) == "object" then
            dxDrawText(getElementData(selectedElement, "object.name"):gsub("_", " "), panelX, panelY - 100 + respc(13), panelW + panelX, panelH + panelY - 100, tocolor(255, 255, 255, 255), 1, fonts.Roboto14, "center", "top")
        end

        if selectedElement == localPlayer then
            dxDrawText("(Kullanıcı Arayüzü)", panelX, panelY - 100 + respc(13) + dxGetFontHeight(1, fonts.Roboto14), panelW + panelX, panelH + panelY - 100, tocolor(255, 255, 255, 255), 1, fonts.Roboto11, "center", "top")
        elseif getElementType(selectedElement) == "vehicle" then
            dxDrawText("(Araç)",  panelX, panelY - 100 + respc(16) + dxGetFontHeight(1, fonts.Roboto14), panelW + panelX, panelH + panelY - 100, tocolor(255, 255, 255, 255), 1, fonts.Roboto11, "center", "top")
		elseif getElementType(selectedElement) == "player" then
            dxDrawText("(Oyuncu)", panelX, panelY - 100 + respc(16) + dxGetFontHeight(1, fonts.Roboto14), panelW + panelX, panelH + panelY - 100, tocolor(255, 255, 255, 255), 1, fonts.Roboto11, "center", "top")
        elseif getElementType(selectedElement) == "ped" then
            dxDrawText("(NPC)", panelX, panelY - 100 + respc(16) + dxGetFontHeight(1, fonts.Roboto14), panelW + panelX, panelH + panelY - 100, tocolor(255, 255, 255, 255), 1, fonts.Roboto11, "center", "top")
        elseif getElementType(selectedElement) == "object" then
            dxDrawText("(Obje)", panelX, panelY - 100 + respc(16) + dxGetFontHeight(1, fonts.Roboto14), panelW + panelX, panelH + panelY - 100, tocolor(255, 255, 255, 255), 1, fonts.Roboto11, "center", "top")
        end
        
        local interactionOffset = scrollData["interactionOffset"] or 0

        local calculatedRowW = rowW
        if #interactions > adjustH then
            calculatedRowW = rowW
        end

        for i = 1, adjustH do
            local interaction = interactions[i + interactionOffset]

            if interaction then
	            local rowY = panelY - 100 + panelH + (rowH * (i - 1))
	            dxDrawInteractionButton("interaction:" .. i, interaction[1], rowX, rowY, calculatedRowW, rowH - 2, {0, 0, 0, 0}, {0, 0, 0, 0}, {0, 0, 0}, fonts.Roboto11, "left", "center", interaction[2], iconW, iconH, {0, 0, 0})
	        end
        end

        activeButtonChecker()
    end
end

addEventHandler("onClientClick", root, function(button, state, absoluteX, absoluteY, worldX, worldY, worldZ, clickedElement)
    if button == "right" and state == "down" then
        if not interactionActive then
            local cameraX, cameraY, cameraZ = getCameraMatrix()

            worldX, worldY, worldZ = (worldX - cameraX) * 200, (worldY - cameraY) * 200, (worldZ - cameraZ) * 200

            local _, _, _, _, hitElement = processLineOfSight(cameraX, cameraY, cameraZ, worldX + cameraX, worldY + cameraY, worldZ + cameraZ, false, true, true, true, false, false, false, false, localPlayer)
            if hitElement then
                clickedElement = hitElement
            end

            if isElement(clickedElement) then
                if clickedElement ~= localPlayer then
                    if getElementData(clickedElement, "isInteractable") or getElementType(clickedElement) == "vehicle" or getElementType(clickedElement) == "player" or getElementType(clickedElement) == "ped" then
                        if inDistance3D(clickedElement, localPlayer, getElementRadius(clickedElement) * 4) then
                            if clickedElement ~= selectedElement then
                                destroyElementOutlineEffect(selectedElement)
                                effectOn = false
                            end
							if getElementType(clickedElement) == "ped" and not getElementData(clickedElement, "name") then
							else
								effectOn = true
								createElementOutlineEffect(clickedElement, true)
								Interaction.Show(clickedElement)
							end
                        end
                    end
                end
            end	
        end
    elseif button == "left" and state == "down" then
        if interactionActive then
            for i = 1, #elementInteractions do
                if activeButton == "interaction:" .. i then
                    local k = i + scrollData["interactionOffset"]
                    if elementInteractions[k][3] then 
                        if type(elementInteractions[k][3]) == "string" then
                            triggerEvent(elementInteractions[k][3], localPlayer, selectedElement, i - 1)
                        else
                            elementInteractions[k][3](localPlayer, selectedElement, i - 1)
                        end
                    end
                    Interaction.Close()
                end
            end
        end
    end
end)

addEventHandler("onClientKey", root, function(key, press)
    if interactionActive then
        if press then
            local offset = scrollData["interactionOffset"] or 0

            if key == "mouse_wheel_down" and offset < #elementInteractions - maxRow then
                offset = offset + 1
            elseif key == "mouse_wheel_up" and offset > 0 then
                offset = offset - 1
            end
            scrollData["interactionOffset"] = offset
        end
    end
end)

function getVehicleName(vehicle)
	return exports.rl_global:getVehicleName(vehicle)
end

function inDistance3D(element1, element2, distance)
	if isElement(element1) and isElement(element2) then
	    local x1, y1, z1 = getElementPosition(element1)
	    local x2, y2, z2 = getElementPosition(element2)
	    local distance2 = getDistanceBetweenPoints3D(x1, y1, z1, x2, y2, z2)

	    if distance2 <= distance then
	        return true, distance2
	    end
	end

    return false, 99999
end

rounded = function(x, y, width, height, radius, color, postGUI, subPixelPositioning)
    dxDrawRectangle(x+radius, y+radius, width-(radius*2), height-(radius*2), color, postGUI, subPixelPositioning)
    dxDrawCircle(x+radius, y+radius, radius, 180, 270, color, color, 16, 1, postGUI)
    dxDrawCircle(x+radius, (y+height)-radius, radius, 90, 180, color, color, 16, 1, postGUI)
    dxDrawCircle((x+width)-radius, (y+height)-radius, radius, 0, 90, color, color, 16, 1, postGUI)
    dxDrawCircle((x+width)-radius, y+radius, radius, 270, 360, color, color, 16, 1, postGUI)
    dxDrawRectangle(x, y+radius, radius, height-(radius*2), color, postGUI, subPixelPositioning)
    dxDrawRectangle(x+radius, y+height-radius, width-(radius*2), radius, color, postGUI, subPixelPositioning)
    dxDrawRectangle(x+width-radius, y+radius, radius, height-(radius*2), color, postGUI, subPixelPositioning)
    dxDrawRectangle(x+radius, y, width-(radius*2), radius, color, postGUI, subPixelPositioning)
end