function round(num, idp)
	local mult = 10 ^ (idp or 0)
	return math.floor(num * mult + 0.5) / mult
end

function saveVehicle(source)
	local dbid = tonumber(getElementData(source, "dbid")) or -1
	
	if isElement(source) and getElementType(source) == "vehicle" and dbid > 0 then
		local x, y, z = getElementPosition(source)
		local rx, ry, rz = getElementRotation(source)
		local fuel = getElementData(source, "fuel")
		local engine = getElementData(source, "engine")
		local odometer = getElementData(source, "odometer") or 0
		local locked = isVehicleLocked(source) and 1 or 0
		local lights = getVehicleOverrideLights(source)
		local sirens = getVehicleSirensOn(source) and 1 or 0
		local Impounded = getElementData(source, "Impounded") or 0
		local handbrake = getElementData(source, "handbrake") or 0
		local health = getElementHealth(source)
		local dimension = getElementDimension(source)
		local interior = getElementInterior(source)

		local wheel1, wheel2, wheel3, wheel4 = getVehicleWheelStates(source)
		local wheelState = toJSON({ wheel1, wheel2, wheel3, wheel4 })
		
		local panel0 = getVehiclePanelState(source, 0)
		local panel1 = getVehiclePanelState(source, 1)
		local panel2 = getVehiclePanelState(source, 2)
		local panel3 = getVehiclePanelState(source, 3)
		local panel4 = getVehiclePanelState(source, 4)
		local panel5 = getVehiclePanelState(source, 5)
		local panel6 = getVehiclePanelState(source, 6)
		local panelState = toJSON({ panel0, panel1, panel2, panel3, panel4, panel5, panel6 })
		
		local door0 = getVehicleDoorState(source, 0)
		local door1 = getVehicleDoorState(source, 1)
		local door2 = getVehicleDoorState(source, 2)
		local door3 = getVehicleDoorState(source, 3)
		local door4 = getVehicleDoorState(source, 4)
		local door5 = getVehicleDoorState(source, 5)
		local doorState = toJSON({ door0, door1, door2, door3, door4, door5 })
		
		dbExec(exports.rl_mysql:getConnection(), "UPDATE vehicles SET fuel = ?, engine = ?, locked = ?, lights = ?, hp = ?, sirens = ?, Impounded = ?, handbrake = ?, currx = ?, curry = ?, currz = ?, currrx = ?, currry = ?, currrz = ?, panelStates = ?, wheelStates = ?, doorStates = ?, odometer = ?, lastUsed = NOW() WHERE id = ?", fuel, engine, locked, lights, health, sirens, tonumber(Impounded), tonumber(handbrake), x, y, z, rx, ry, rz, panelState, wheelState, doorState, tonumber(odometer), dbid)
	end
end

local function saveVehicleOnExit(thePlayer, seat)
	saveVehicle(source)
end
addEventHandler("onVehicleExit", root, saveVehicleOnExit)

function saveVehicleMods(source)
	local dbid = tonumber(getElementData(source, "dbid")) or -1
	local owner = tonumber(getElementData(source, "owner")) or -1
	if isElement(source) and getElementType(source) == "vehicle" and dbid >= 0 then
		local col = { getVehicleColor(source, true) }
		if getElementData(source, "oldcolors") then
			col = unpack(getElementData(source, "oldcolors"))
		end
		
		local color1 = toJSON({col[1], col[2], col[3]})
		local color2 = toJSON({col[4], col[5], col[6]})
		local color3 = toJSON({col[7], col[8], col[9]})
		local color4 = toJSON({col[10], col[11], col[12]})
		
		local hcol1, hcol2, hcol3 = getVehicleHeadLightColor(source)
		if getElementData(source, "oldheadcolors") then
			hcol1, hcol2, hcol3 = unpack(getElementData(source, "oldheadcolors"))
		end
		local headLightColors = toJSON({ hcol1, hcol2, hcol3 })
		
		local upgrades = {}
		for i = 0, 16 do
			upgrades[i] = getElementData(source, "oldupgrade" .. i) or getVehicleUpgradeOnSlot(source, i)
		end
		local upgradesJSON = toJSON(upgrades)
		
		local paintjob = getElementData(source, "oldpaintjob") or getVehiclePaintjob(source)
		local variant1, variant2 = getVehicleVariant(source)
		
		dbExec(exports.rl_mysql:getConnection(), "UPDATE vehicles SET upgrades = ?, paintjob = ?, color1 = ?, color2 = ?, color3 = ?, color4 = ?, headlights = ?, variant1 = ?, variant2 = ? WHERE id = ?", upgradesJSON, paintjob, color1, color2, color3, color4, headLightColors, variant1, variant2, dbid)
	end
end