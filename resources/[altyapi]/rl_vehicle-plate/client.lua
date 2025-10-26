local plates = {}

local plateFont = exports.rl_fonts:getFont("Lato-Bold", 42)
local plateSize = { w = 320, h = 60 }

local plateTextures = {}
for i = 1, #plateDesigns do
    if fileExists("public/public/images/" .. i .. ".png") then
        table.insert(plateTextures, dxCreateTexture("public/public/images/" .. i .. ".png"))
    end
end

local shader_raw_data = [[
    texture platetex;
    technique TexReplace {
        pass P0 {
            Texture[0] = platetex;
        }
    }
]]

function addCustomPlate(vehicle)
    if not (dxGetStatus()["VideoMemoryFreeForMTA"] > 0) then
        return false
    end

    if not isElement(vehicle) then
        return false
    end

    if not isElementStreamedIn(vehicle) then
        return false
    end

    if not plates[vehicle] then
        plates[vehicle] = {}
    end

    local plateText = getElementData(vehicle, "carshop") and (getElementData(vehicle, "plate") or (getVehiclePlateText(vehicle))) or (getElementData(vehicle, "plate") or (getVehiclePlateText(vehicle) .. "0"))
    local plateDesign = getElementData(vehicle, "plate_design") or 1

    if not plateText then
        return false
    end

    plates[vehicle].backgroundTexture = plateTextures[plateDesign]
    plates[vehicle].renderTarget = dxCreateRenderTarget(plateSize.w, plateSize.h, true)

    local plateData = plateDesigns[plateDesign]
    if not plateData then
        return false
    end

    if not plateData.bottomLeftFix then
        plateData.bottomLeftFix = { w = 0, h = 0, color = { 0, 0, 0 } }
    end

    dxSetRenderTarget(plates[vehicle].renderTarget)
    if plateData.backgroundColor then
        dxDrawRectangle(0, 0, plateSize.w, plateSize.h, tocolor(plateData.backgroundColor[1], plateData.backgroundColor[1], plateData.backgroundColor[1], 255))
        dxDrawRectangle(0, 0, plateData.bottomLeftFix.w, plateSize.h, tocolor(plateData.bottomLeftFix.color[1], plateData.bottomLeftFix.color[2], plateData.bottomLeftFix.color[3], 255))
    end
    dxDrawText(plateText, plateSize.w / 2 + plateData.bottomLeftFix.w / 2, (plateSize.h) / 2 + 0, plateSize.w / 2 + plateData.bottomLeftFix.w / 2, (plateSize.h) / 2, tocolor(plateData.textColor[1], plateData.textColor[2], plateData.textColor[3], 255), 1, plateFont, "center", "center", false, false, false, true)
    dxSetRenderTarget()

    if plates[vehicle].backgroundTexture then
        plates[vehicle].plateShaderBack = dxCreateShader(shader_raw_data, 0, 100, false, "vehicle")
        if plates[vehicle].plateShaderBack then
            dxSetShaderValue(plates[vehicle].plateShaderBack, "platetex", plates[vehicle].backgroundTexture)
            engineApplyShaderToWorldTexture(plates[vehicle].plateShaderBack, "plateback*", vehicle)
        end
    end

    if plates[vehicle].renderTarget then
        plates[vehicle].plateShaderText = dxCreateShader(shader_raw_data, 0, 100, false, "vehicle")
        if plates[vehicle].plateShaderText then
            dxSetShaderValue(plates[vehicle].plateShaderText, "platetex", plates[vehicle].renderTarget)
            engineApplyShaderToWorldTexture(plates[vehicle].plateShaderText, "custom_car_plate", vehicle)
        end
    end
end

addEventHandler("onClientElementDataChange", root, function(data)
    if source.type == "vehicle" and isElementStreamedIn(source) then
        if data == "plate" or data == "plate_design" then
            removeCustomPlate(source)
            addCustomPlate(source)
        end
    end
end)

function removeCustomPlate(vehicle)
    if isElement(vehicle) then
        if plates[vehicle] then
            if isElement(plates[vehicle].plateShaderBack) then
                plates[vehicle].plateShaderBack:destroy()
            end
            if isElement(plates[vehicle].plateShaderText) then
                plates[vehicle].plateShaderText:destroy()
            end
            if isElement(plates[vehicle].renderTarget) then
                plates[vehicle].renderTarget:destroy()
            end

            plates[vehicle] = nil
        end
    end
end

addEventHandler("onClientResourceStart", resourceRoot, function()
    for _, vehicle in ipairs(getElementsByType("vehicle")) do
        if isElementStreamedIn(vehicle) then
            addCustomPlate(vehicle)
        end
    end
end)

addEventHandler("onClientElementStreamIn", root, function()
    if source.type == "vehicle" then
        addCustomPlate(source)
    end
end)

addEventHandler("onClientElementStreamOut", root, function()
    if source.type == "vehicle" then
        removeCustomPlate(source)
    end
end)

addEventHandler("onClientElementDestroy", root, function()
    if source.type == "vehicle" then
        removeCustomPlate(source)
    end
end)

addEventHandler("onClientRestore", root, function()
    for _, vehicle in ipairs(getElementsByType("vehicle")) do
        if isElementStreamedIn(vehicle) then
            removeCustomPlate(vehicle)
            addCustomPlate(vehicle)
        end
    end
end)

addEvent("plateDesign.showList", true)
addEventHandler("plateDesign.showList", root, function()
	if isElement(plateDesignGUI) then
		return
	end	
	
	plateDesignGUI = guiCreateWindow(0, 0, 400, 500, "Özel Plaka Tasarımı", false)
	guiWindowSetSizable(plateDesignGUI, false)
	exports.rl_global:centerWindow(plateDesignGUI)
	
	gridlist = guiCreateGridList(9, 21, 400, 185, false, plateDesignGUI)
	guiGridListAddColumn(gridlist, "Tasarım", 0.85)
	for i, v in pairs(plateDesigns) do
		local row = guiGridListAddRow(gridlist)
		guiGridListSetItemText(gridlist, row, 1, v.name, false, false)
		guiGridListSetItemData(gridlist, row, 1, i, false, false)
	end
	guiGridListSetSortingEnabled(gridlist, false)
	
	image = guiCreateStaticImage(9, 210, 400, 606/3, "public/images/1.png", false, plateDesignGUI)
	
	vehicleID = guiCreateEdit(85, 425, 560, 28, "", false, plateDesignGUI)
	
	label = guiCreateLabel(4, 425, 81, 28, "Araba ID:", false, plateDesignGUI)
	guiSetFont(label, "default-bold-small")
	guiLabelSetHorizontalAlign(label, "center", false)
	guiLabelSetVerticalAlign(label, "center")
	
	ok = guiCreateButton(9, 455, 190, 32, "Satın Al (40 TL)", false, plateDesignGUI)
	close = guiCreateButton(210, 455, 200, 31, "Kapat", false, plateDesignGUI)
	
	addEventHandler("onClientGUIClick", root, function(b)
		if (b == "left") then
			if (source == gridlist) then
				local selectedPlateDesign = guiGridListGetSelectedItem(gridlist)
				if not selectedPlateDesign or selectedPlateDesign == -1 then return end
				local designPlateIndex = guiGridListGetItemData(gridlist, selectedPlateDesign, 1)
				guiStaticImageLoadImage(image, "public/images/" .. designPlateIndex .. ".png")
			elseif (source == close) then
				destroyElement(plateDesignGUI)
				guiSetInputEnabled(false)
				showCursor(false)
			elseif (source == ok) then
				if guiGetText(vehicleID) == "" or not tonumber(guiGetText(vehicleID)) then
					outputChatBox("[!]#FFFFFF Aracınızın ID numarasını hatalı girdiniz.", 255, 0, 0, true)
					return
				end
				local vehicleID = guiGetText(vehicleID)
				local selectedPlateDesign = guiGridListGetSelectedItem(gridlist)
				local designPlateIndex = guiGridListGetItemData(gridlist, selectedPlateDesign, 1)
				if not selectedPlateDesign or selectedPlateDesign == -1 then
					outputChatBox("[!]#FFFFFF Herhangi bir tasarım seçmediniz.", 255, 0, 0, true)
					return
				end
				guiSetInputEnabled(false)
				showCursor(false)
				destroyElement(plateDesignGUI)
				triggerServerEvent("market.buyVehicleDesignPlate", localPlayer, vehicleID, designPlateIndex, 40)
			end
		end
	end)
end)