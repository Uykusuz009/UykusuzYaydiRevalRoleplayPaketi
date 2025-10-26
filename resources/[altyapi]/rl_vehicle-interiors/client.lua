function useVehicleInterior(key, keyState, vehicle)
	unbindKey("enter_exit", "down", useVehicleInterior)
	hideIntName()
	triggerServerEvent("enterVehicleInterior", localPlayer, vehicle)
	cancelEvent()
end

function vehInteriorGUI()
	if (isElement(gInteriorName) and guiGetVisible(gInteriorName)) then
		if isTimer(timer) then
			killTimer(timer)
			timer = nil
		end

		destroyElement(gInteriorName)
		gInteriorName = nil
		
		unbindKey("enter_exit", "down", useVehicleInterior)
	end
	
	local px,py,pz = getElementPosition(localPlayer)
	local x,y,z = getElementPosition(source)

	gInteriorName = guiCreateLabel(0.0, 0.85, 1.0, 0.3, tostring(getVehiclePlateText(source)), true)
	guiSetFont(gInteriorName, "sa-header")
	guiLabelSetHorizontalAlign(gInteriorName, "center", true)
	guiSetAlpha(gInteriorName, 0.0)

	timer = setTimer(fadeMessage, 50, 20, true)
	
	local result = bindKey("enter_exit", "down", useVehicleInterior, source)
end
addEvent("vehicle-interiors:showInteriorGUI", true)
addEventHandler("vehicle-interiors:showInteriorGUI", root, vehInteriorGUI)

function hideVehInteriorGUI()
	unbindKey("enter_exit", "down", useVehicleInterior)
	hideIntName()
end
addEvent("vehicle-interiors:hideInteriorGUI", true)
addEventHandler("vehicle-interiors:hideInteriorGUI", root, hideVehInteriorGUI)

function changeTexture(model)
	if (model == 577) then
		local txd = engineLoadTXD("public/models/at400_interior.txd")
		engineImportTXD(txd,14548)
	elseif (model == 592) then
		local txd = engineLoadTXD("public/models/ab_cargo_int.txd")
		engineImportTXD(txd,14548)			
	else
		local txd = engineLoadTXD("public/models/ab_cargo_int.txd")
		engineImportTXD(txd,14548)		
	end
end
addEvent("vehicle-interiors:changeTextures", true)
addEventHandler("vehicle-interiors:changeTextures", root, changeTexture)

function fadeMessage(fadein)
	if gInteriorName then
		local alpha = guiGetAlpha(gInteriorName)

		if (fadein) and (alpha) then
			local newalpha = alpha + 0.05
			guiSetAlpha(gInteriorName, newalpha)

			if (newalpha>=1.0) then
				timer = setTimer(hideIntName, 4000, 1)
			end
		elseif (alpha) then
			local newalpha = alpha - 0.05
			guiSetAlpha(gInteriorName, newalpha)

			if (gBuyMessage) then
				guiSetAlpha(gBuyMessage, newalpha)
			end

			if (newalpha<=0.0) then
				destroyElement(gInteriorName)
				gInteriorName = nil
			end
		end
	end
end

function hideIntName()
	setTimer(fadeMessage, 50, 20, false)
end

function getPositionFromElementOffset()
	if not getElementData(localPlayer, "isInWindow") then
		local dim = getElementDimension(localPlayer)
		local id = dim - 20000
		local vehicle = nil
		for _, _vehicle in ipairs(getElementsByType("vehicle")) do
			if tonumber(getElementData(_vehicle, "dbid")) == tonumber(id) then
				vehicle = _vehicle
				break
			end
		end
		local offX, offY, offZ = getElementPosition(vehicle)
		local m = getElementMatrix(vehicle)
		local x = offX * m[1][1] + offY * m[2][1] + offZ * m[3][1] + m[4][1]
		local y = offX * m[1][2] + offY * m[2][2] + offZ * m[3][2] + m[4][2]
		local z = offX * m[1][3] + offY * m[2][3] + offZ * m[3][3] + m[4][3]
		
		triggerServerEvent("seeThroughWindows", root, localPlayer, x, y, z)

		addEventHandler("onClientRender", root, function()
			if getElementData(localPlayer, "isInWindow") == true then
				triggerServerEvent("updateWindowsView", root, localPlayer)
			end
		end)
	else
		triggerServerEvent("seeThroughWindows", root, localPlayer)
	end
end