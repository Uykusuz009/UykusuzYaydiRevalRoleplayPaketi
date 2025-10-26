local vehicles = {}

local viewDistance = 10
local heightOffset = 1.6

local playerID = 0

local renderTimers = {}

local basePlateSize = {
    x = 1024,
    y = 512
}

function createRender(funcName, func, tick)
    if not tick then
        tick = 0
    end

    if not renderTimers[funcName] then
        renderTimers[funcName] = setTimer(func, tick, 0)
    end
end

function checkRender(funcName)
    return renderTimers[funcName]
end

function destroyRender(funcName)
    if renderTimers[funcName] then
        killTimer(renderTimers[funcName])
        renderTimers[funcName] = nil
        collectgarbage("collect")
    end
end

addEventHandler("onClientResourceStart", resourceRoot, function()
    bindKey("lalt", "down", function()
        if not localPlayer:getData("logged") then
            return
        end

		if not checkRender("showText") then
			refreshNearByVehs()
			createRender("showText", showText)
		end
    end)

    bindKey("lalt", "up", function()
        if not localPlayer:getData("logged") then
            return
        end
		
		if checkRender("showText") then
			destroyRender("showText")
		end
    end)

    bindKey("ralt", "down", function()
        if not localPlayer:getData("logged") then
            return
        end
		
        if checkRender("showText") then
            destroyRender("showText")
        else
            refreshNearByVehs()
            createRender("showText", showText)
        end
    end)
end)

function showText()
    local plateFont = exports.kaisen_fonts:getFont("sf-bold", 10)
    local plateFontBig = exports.kaisen_fonts:getFont("license", 14)
	local bebasNeueRegular = exports.kaisen_fonts:getFont("BebasNeueRegular", 12)

    for i = 1, #vehicles, 1 do
        local row = vehicles[i]
        local vehicle = row.vehicle
        if row and vehicle and isElement(vehicle) then
            local x, y, z = getElementPosition(vehicle)
            local cx, cy, cz = getCameraMatrix()
            if getDistanceBetweenPoints3D(cx, cy, cz, x, y, z) <= viewDistance then
                local px, py = getScreenFromWorldPosition(x, y, z + heightOffset, 0.05)
                if (getElementDimension(localPlayer) == getElementDimension(vehicle)) and px and isLineOfSightClear(cx, cy, cz, x, y, z, true, false, false, true, true, false, false) then
                    local plate = tostring(row.plate):upper()

                    local containerWidth = 300
                    local textColor = tocolor(255, 255, 255, 255)

                    local grids = {}

                    if row.carshop then
                        local price = row.carshopcost or 0
                        local taxes = row.carshoptax or 0

                        table.insert(grids, {
                            title = "Galerİ FİyatI",
                            value = "$" .. exports.rl_global:formatMoney(price)
                        })

                        table.insert(grids, {
                            title = "Vergİ",
                            value = "$" .. exports.rl_global:formatMoney(taxes)
                        })
                    else
                        table.insert(grids, {
                            title = "AraÇ ID",
                            value = row.dbid
                        })
						
                        local vowner = row.owner or -1
                        local vfaction = row.faction or -1
                        if vowner == playerID or exports.rl_global:isAdminOnDuty(localPlayer) then
                            local ownerName = "Bilinmiyor"
                            if vowner > 0 then
                                ownerName = exports.rl_cache:getCharacterNameFromID(vowner)
                            elseif vfaction > 0 then
                                ownerName = exports.rl_cache:getFactionNameFromId(vfaction)
                            end

                            table.insert(grids, {
                                title = "Sahİbİ",
                                value = ownerName,
                                loading = not ownerName or ownerName == ""
                            })
                        end
                    end

                    px = px - (containerWidth / 2)

                    local plateOneLineHeight = dxGetFontHeight(1, plateFont)
                    local plateFontWidth = dxGetTextWidth(plate, 1, plateFontBig)

                    local plateW, plateH = basePlateSize.x / 9, basePlateSize.y / 9
                    if existsSpecialFile then
                        plateW, plateH = 180, 39
                    end
                    if plateW < plateFontWidth then
                        plateW = plateFontWidth + 20
                    end

                    local r, g, b = 11, 29, 141
                    if exports["rl_vehicle-plate"]:getPlateDesigns()[row.plateDesign] then
                        local plateDesign = row.plateDesign
                        r, g, b = unpack(exports["rl_vehicle-plate"]:getPlateDesigns()[plateDesign].textColor)
                        backgroundImage = ":rl_vehicle-plate/public/images/" .. plateDesign .. ".png"
                    else
                        r, g, b = 0, 0, 0
                        backgroundImage = ":rl_vehicle-plate/public/images/1.png"
                    end

                    if getVehicleType(vehicle) ~= "BMX" then
                        local platePosition = {
                            x = px + (containerWidth - plateW) / 2,
                            y = py - plateH,
                        }
                        dxDrawImage(platePosition.x, platePosition.y, plateW, plateH, backgroundImage)

                        if existsSpecialFile then
                            py = row.faction == 1 and py - 18 or py - 20
                            px = px + 5
                        end
                        dxDrawText(plate, platePosition.x, platePosition.y - 5, plateW + platePosition.x, plateH + platePosition.y - 5, tocolor(r, g, b, 255), 1, plateFontBig, "center", "bottom")

                        py = py + 5
                    end

                    dxDrawRectangle(px, py, containerWidth, 30, exports.rl_ui:rgba("#121214", 0.8))
                    dxDrawText(row.name, px + 10, py, 0, 30 + py, exports.rl_ui:rgba("#e1e1e6", 0.8), 1, bebasNeueRegular, "left", "center")
                    py = py + 30

                    for i = 1, #grids do
                        local grid = grids[i]
                        local title = grid.title
                        local value = grid.value
                        local loading = grid.loading

                        dxDrawRectangle(px, py, containerWidth, 30, exports.rl_ui:rgba(i % 2 == 0 and "#29292e" or "#202024", 0.8))
                        dxDrawText(title:upper(), px + 10, py, 0, 30 + py, exports.rl_ui:rgba("#ace8f5"), 1, bebasNeueRegular, "left", "center")
                        if not loading then
                            dxDrawText(value, px - 10, py, px + containerWidth - 10, 30 + py, exports.rl_ui:rgba("#666666", 0.8), 1, bebasNeueRegular, "right", "center")
                        else
                            exports.rl_ui:drawSpinner({
                                position = {
                                    x = px + containerWidth - 25,
                                    y = py + 15 / 2,
                                },
                                size = 15,

                                speed = 2,

                                variant = "soft",
                                color = "gray",
                            })
                        end

                        py = py + 30
                    end
                end
            end
        end
    end
end

function refreshNearByVehs()
    playerID = getElementData(localPlayer, "dbid")
    for index, vehicle in ipairs(getElementsWithinRange(localPlayer.position, 30, "vehicle", localPlayer.interior, localPlayer.dimension)) do
        if isElement(vehicle) and vehicle:getData("dbid") then
            vehicles[index] = {
                vehicle = vehicle,
                dbid = vehicle:getData("dbid"),
                plate = vehicle:getData("carshop") and (vehicle:getData("plate") or (getVehiclePlateText(vehicle))) or (vehicle:getData("plate") or (getVehiclePlateText(vehicle) .. "0")),
                plateDesign = vehicle:getData("plate_design") or 1,

                carshop = vehicle:getData("carshop"),
                carshopcost = vehicle:getData("carshop:cost") or 0,
                carshoptax = vehicle:getData("carshop:taxcost") or 0,

                owner = vehicle:getData("owner"),
                faction = vehicle:getData("faction"),

                name = exports.rl_global:getVehicleName(vehicle)
            }
        end
    end
end