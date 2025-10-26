local useFakePickups = true
local useFakeRot = false
local streamdistance = 10
local interiorsSpawned = {}
local elevatorsSpawned = {}
local colShapesSpawned = {}
local elevatorsColShapesSpawned = {}
local intsToBeLoaded = {}
local elevatorsToBeLoaded = {}
local fakePickups = {}
local fakePickupsEle = {}
local animFake = {}
local done = 0
local debugmode = false

local theme = exports.rl_ui:useTheme()
local intNameFont = exports.kaisen_fonts:getFont("UbuntuRegular", 11)
local intIconFont = exports.kaisen_fonts:getFont("FontAwesome", 22)
local intIconFont2 = exports.kaisen_fonts:getFont("FontAwesome", 9)

function applyPickupClientConfigSettings()
    local streamerDistance = tonumber(exports.rl_account:loadSavedData("streamer-pickup", "25"))
    if (streamerDistance) then
        streamdistance = streamerDistance
    end
end
addEventHandler("accounts:settings:loadGraphicSettings", root, applyPickupClientConfigSettings)

local lagcatcherenabled = false
local pickupRefreshRate = 1000 
function checkNearbyInteriorPickups(first)
    if first then
        setTimer(checkNearbyInteriorPickups, pickupRefreshRate, 0)
        return 0
    end
    if getElementData(localPlayer, "logged") then
        for interior,_ in pairs(intsToBeLoaded) do
            local dbid = isElement(interior) and getElementData(interior, "dbid") or nil
            if dbid and not interiorsSpawned[dbid] then
                interiorShowPickups(interior)
                intsToBeLoaded[interior] = nil
            end
        end
        return 2
    end
end
setTimer(checkNearbyInteriorPickups, pickupRefreshRate, 1, true)

function checkNearbyElevatorPickups(first)
    if first then
        setTimer(checkNearbyElevatorPickups, pickupRefreshRate, 0)
        return 0
    end
    if getElementData(localPlayer, "logged") then
        for elevator, _ in pairs(elevatorsToBeLoaded) do
            if isElement(elevator) and getElementChildrenCount(elevator) ~= 2 then
                interiorShowPickups(elevator)
                elevatorsToBeLoaded[elevator] = nil
            end
        end
        return 2
    end
end
setTimer(checkNearbyElevatorPickups, math.ceil(pickupRefreshRate+(pickupRefreshRate/2)), 1, true)

function interiorCreateColshape(interiorElement)
    local dbid = getElementData(interiorElement, "dbid")
    if debugmode then
        outputDebugString("interiorCreateColshape running with  " .. tostring(dbid)  .. " " ..  getElementType(interiorElement) == "elevator" and  "(elevator)" or "(interior)")
    end
    local entrance = getElementData(interiorElement, "entrance")

    local outsideColShape = createColSphere (entrance[INTERIOR_X], entrance[INTERIOR_Y], entrance[INTERIOR_Z], 1)

    if getElementType(interiorElement) == "elevator" then
        setElementParent(outsideColShape, elevatorsSpawned[dbid][1])
    else
        setElementParent(outsideColShape, interiorsSpawned[dbid][1])
    end


    setElementInterior(outsideColShape, entrance[INTERIOR_INT])
    setElementDimension(outsideColShape, entrance[INTERIOR_DIM])
    setElementData(outsideColShape, "entrance", true, false)

    local exit = getElementData(interiorElement, "exit")

    local insideColShape = createColSphere (exit[INTERIOR_X], exit[INTERIOR_Y], exit[INTERIOR_Z], 1)
    if getElementType(interiorElement) == "elevator" then
        setElementParent(insideColShape, elevatorsSpawned[dbid][2])
    else
        setElementParent(insideColShape, interiorsSpawned[dbid][2])
    end

    setElementInterior(insideColShape, exit[INTERIOR_INT])
    setElementDimension(insideColShape, exit[INTERIOR_DIM])
    setElementData(insideColShape, "entrance", false, false)

    if getElementType(interiorElement) == "elevator" then
        elevatorsColShapesSpawned[dbid] = { outsideColShape, insideColShape }
    else
        colShapesSpawned[dbid] = { outsideColShape, insideColShape }
    end
    if debugmode then
        outputDebugString("interiorCreateColshape done with  " .. tostring(dbid)  .. " " ..  getElementType(interiorElement) == "elevator" and  "(elevator)" or "(interior)")
    end
end

function interiorRemoveColshape(interiorElement)
    local dbid = getElementData(interiorElement, "dbid")
    if debugmode then
        outputDebugString("interiorRemoveColshape running with  " .. tostring(dbid)  .. " " ..  getElementType(interiorElement) == "elevator" and  "(elevator)" or "(interior)")
    end
    if getElementType(interiorElement) == "interior" then
        if not colShapesSpawned[dbid] then
            return
        end
        if isElement(colShapesSpawned[dbid][1]) then
            destroyElement(colShapesSpawned[dbid][1])
        end
        if isElement(colShapesSpawned[dbid][2]) then
            destroyElement(colShapesSpawned[dbid][2])
        end
            colShapesSpawned[dbid] = false
    elseif getElementType(interiorElement) == "elevator" then
        if not elevatorsColShapesSpawned[dbid] then
            return
        end
        destroyElement(elevatorsColShapesSpawned[dbid][1])
        destroyElement(elevatorsColShapesSpawned[dbid][2])
        elevatorsColShapesSpawned[dbid] = false
    end
end

function interiorShowPickups(interiorElement)

    local dbid = getElementData(interiorElement, "dbid")
    if debugmode then
        outputDebugString("interiorShowPickups running with  " .. tostring(dbid)  .. " " ..  getElementType(interiorElement) == "elevator" and  "(elevator)" or "(interior)")
    end
    if getElementType(interiorElement) == "elevator" then
        if getElementChildrenCount(interiorElement) == 2 then --if elevatorsSpawned[dbid] then
            if debugmode then
            outputDebugString("interiorShowPickups returning with  " .. tostring(dbid)  .. ": false, 1")
            end
            return false, 1
        end
    else
        if interiorsSpawned[dbid] then
            if debugmode then
            outputDebugString("interiorShowPickups returning with  " .. tostring(dbid)  .. ": false, 2")
            end
            return false, 2
        end
    end

    local entrance = getElementData(interiorElement, "entrance")
    local exit = getElementData(interiorElement, "exit")
    local int = getElementData(interiorElement, "status")

    if not entrance  then
        if debugmode then
            outputDebugString("interiorShowPickups returning with  " .. tostring(dbid)  .. ": false, 3")
        end
        return false, 3
    end

    if not exit  then
        if debugmode then
            outputDebugString("interiorShowPickups returning with  " .. tostring(dbid)  .. ": false, 4")
        end
        return false, 4
    end

    if not int  then
        if debugmode then
            outputDebugString("interiorShowPickups returning with  " .. tostring(dbid)  .. ": false, 5")
        end
        return false, 5
    end

    local tpObjectModel =  1318--1316 --1559 --

    local r, g, b = 179, 115, 5 -- House

    if int[INTERIOR_DISABLED] then
        r, g, b = 255, 0, 0
    elseif int[INTERIOR_TYPE] == 2 then
        r, g, b = 0, 133, 204 -- Devlet
    end

    if getElementType(interiorElement) == "elevator" then
        r, g, b = 45, 45, 45 -- Elevator
    end

    --local outsidePickup = createPickup(entrance[INTERIOR_X], entrance[INTERIOR_Y], entrance[INTERIOR_Z], 3, int[INTERIOR_DISABLED] and 1314 or (getElementType(interiorElement) == "elevator" and tpObjectModel or (int[INTERIOR_TYPE] == 2 and tpObjectModel  or (int[INTERIOR_OWNER] < 1 and int[INTERIOR_FACTION] < 1 and (int[INTERIOR_TYPE] == 1 and 1272 or 1273) or tpObjectModel ))))
    local outsidePickup = exports.rl_marker:createCustomMarker(entrance[INTERIOR_X], entrance[INTERIOR_Y], entrance[INTERIOR_Z]-1, "cylinder", 0.75, r, g, b, int[INTERIOR_DISABLED] and (int[INTERIOR_TYPE] == 2 and 'business' or (int[INTERIOR_OWNER] < 1 and int[INTERIOR_FACTION] < 1 and (int[INTERIOR_TYPE] == 1 and 'business_sale' or 'house_sale') or 'house') or 'arrow') or (getElementType(interiorElement) == "elevator" and 'arrow' or (int[INTERIOR_TYPE] == 2 and 'business'  or (int[INTERIOR_OWNER] < 1 and int[INTERIOR_FACTION] < 1 and (int[INTERIOR_TYPE] == 1 and 'business_sale' or 'house_sale') or 'house'))), {name = getElementData(interiorElement, "name"), id = getElementData(interiorElement, "dbid")})
   
	setElementDoubleSided(outsidePickup, true)

    setElementParent(outsidePickup, interiorElement)
    setElementInterior(outsidePickup, entrance[INTERIOR_INT])
    setElementDimension(outsidePickup, entrance[INTERIOR_DIM])
    setElementData(outsidePickup, "dim", entrance[INTERIOR_DIM], false)

    if useFakePickups then
        if not isPickupStreamable(outsidePickup) then
            local fakeHelper = createObject(int[INTERIOR_DISABLED] and 1314 or (getElementType(interiorElement) == "elevator" and tpObjectModel or (int[INTERIOR_TYPE] == 2 and tpObjectModel  or (int[INTERIOR_OWNER] < 1 and (int[INTERIOR_TYPE] == 1 and 1272 or 1273) or tpObjectModel ))), entrance[INTERIOR_X], entrance[INTERIOR_Y], entrance[INTERIOR_Z])
            setElementParent(fakeHelper, interiorElement)
            fakePickups[tonumber(exit[INTERIOR_DIM])] = fakeHelper
            table.insert(animFake, fakeHelper)
            setElementInterior(fakeHelper, entrance[INTERIOR_INT])
            setElementDimension(fakeHelper, entrance[INTERIOR_DIM])
            setElementCollisionsEnabled(fakeHelper, false)
            local fakeModel = getElementModel(fakeHelper)
            local fakeScale = 1.0
            if(fakeModel == 1272 or fakeModel == 1273) then
                fakeScale = 2.0
            end
            setObjectScale(fakeHelper, fakeScale)
        end
    end
	
    --local insidePickup = createPickup(exit[INTERIOR_X], exit[INTERIOR_Y], exit[INTERIOR_Z], 3, tpObjectModel)
    local insidePickup = exports.rl_marker:createCustomMarker(exit[INTERIOR_X], exit[INTERIOR_Y], exit[INTERIOR_Z]-1, "cylinder", 0.75, r, g, b, 'arrow', {name = "", id = ""})
    setElementDoubleSided(insidePickup, true)
    setElementParent(insidePickup, interiorElement)
    setElementInterior(insidePickup, exit[INTERIOR_INT])
    setElementDimension(insidePickup, exit[INTERIOR_DIM])
    setElementData(insidePickup, "dim", exit[INTERIOR_DIM], false)

    setElementData(insidePickup, "other", outsidePickup, false)
    setElementData(outsidePickup, "other", insidePickup, false)

    if getElementType(interiorElement) == "elevator" then
        elevatorsSpawned[dbid] = { outsidePickup, insidePickup }
    else
        interiorsSpawned[dbid] = { outsidePickup, insidePickup }
    end
    interiorCreateColshape(interiorElement)
    done = done + 1
    if debugmode then
        outputDebugString("interiorShowPickups returning with  " .. tostring(dbid)  .. ": true, " .. getElementType(interiorElement) == "interior" and 1 or 2)
    end
    return true, getElementType(interiorElement) == "interior" and 1 or 2
end

function interiorRemovePickups(interiorElement)
    local dbid = getElementData(interiorElement, "dbid")

    if debugmode then
        outputDebugString("interiorRemovePickups running with  " .. tostring(dbid)  .. " " ..  getElementType(interiorElement) == "elevator" and  "(elevator)" or "(interior)")
    end

    if getElementType(interiorElement) == "interior" then
        if not interiorsSpawned[dbid] then
            if debugmode then
                outputDebugString("interiorRemovePickups returning with  " .. tostring(dbid)  .. ": false,  1")
            end
            return false, 1
        end

        destroyElement(interiorsSpawned[dbid][1])
        destroyElement(interiorsSpawned[dbid][2])
        if useFakePickups then
            if (fakePickups[dbid]) then
                destroyElement(fakePickups[dbid])
                fakePickups[dbid] = nil
            end
        end
        interiorsSpawned[dbid] = false
        done = done - 1
        if debugmode then
            outputDebugString("interiorRemovePickups finished resulting on  " .. tostring(dbid)  .. " true, 1")
        end

        return true, 1
    elseif getElementType(interiorElement) == "elevator" then
        if getElementChildrenCount(interiorElement) == 2 then
            if debugmode then
                outputDebugString("interiorRemovePickups returning with  " .. tostring(dbid)  .. ": false,  2")
            end
            return false, 2
        end

        destroyElement(elevatorsSpawned[dbid][1])
        destroyElement(elevatorsSpawned[dbid][2])
        if (fakePickupsEle[dbid]) then
            destroyElement(fakePickupsEle[dbid])
            fakePickupsEle[dbid] = nil
        end
        elevatorsSpawned[dbid] = false
        done = done - 1
        if debugmode then
            outputDebugString("interiorRemovePickups finished resulting on  " .. tostring(dbid)  .. " true, 2")
        end
        return true, 2
    else
        outputDebugString(" interiorRemovePickupsFail? ")
        outputDebugString("---")
        outputDebugString(tostring(interiorElement))
        outputDebugString(tostring(getElementType(interiorElement)))
        outputDebugString(tostring(dbid))
        outputDebugString("---")
    end

    if debugmode then
        outputDebugString("interiorRemovePickups finished without result on  " .. tostring(dbid))
    end
    return true
end


function deleteInteriorElement(databaseID)
    if debugmode then
        outputDebugString("interiorRemovePickups running with  " .. tostring(databaseID)  .. " " ..  getElementType(source) == "elevator" and  "(elevator)" or "(interior)")
    end
    if getElementType(source) == "interior" then
        interiorRemovePickups(source)
        interiorRemoveColshape(source)
        interiorsSpawned[databaseID] = nil
        colShapesSpawned[databaseID] = nil
    elseif getElementType(source) == "elevator" then
        interiorRemovePickups(source)
        interiorRemoveColshape(source)
        elevatorsSpawned[databaseID] = nil
        elevatorsColShapesSpawned[databaseID] = nil
    end
end
addEvent("deleteInteriorElement", true)
addEventHandler("deleteInteriorElement", root, deleteInteriorElement)

local lastSource = nil
local lastCol = nil
local lastSourceIsEntrance = false

function enterInterior()
    local localElement = localPlayer
    local localDimension = getElementDimension(localPlayer)
    local vehicleElement = false
    local theVehicle = getPedOccupiedVehicle(localPlayer)
    if theVehicle and getVehicleOccupant (theVehicle, 0) == localPlayer then
        vehicleElement = theVehicle
    end
    local found, foundInterior, foundColShape, foundIsEntrance = false
    for _, interior in ipairs(getElementsByType('interior')) do
        local dbid = getElementData(interior, "dbid")
        local intEntrance = getElementData(interior, "entrance")
        local intExit = getElementData(interior, "exit")
        if colShapesSpawned[dbid] then
            if (isElementWithinColShape (localElement, colShapesSpawned[dbid][1]) or vehicleElement and isElementWithinColShape (vehicleElement, colShapesSpawned[dbid][1])) and localDimension == intEntrance[INTERIOR_DIM] then
                found = true
                foundInterior = interior
                foundColShape = colShapesSpawned[dbid][1]
                foundIsEntrance = true
                break
            elseif (isElementWithinColShape (localElement, colShapesSpawned[dbid][2]) or vehicleElement and isElementWithinColShape (vehicleElement, colShapesSpawned[dbid][1])) and localDimension == intExit[INTERIOR_DIM] then
                found = true
                foundInterior = interior
                foundColShape = colShapesSpawned[dbid][2]
                foundIsEntrance = false
                break
            end
        end
    end

    if not found then
        for _, elevator in ipairs(getElementsByType('elevator')) do
            local dbid = getElementData(elevator, "dbid")
            local eleEntrance = getElementData(elevator, "entrance")
            local eleExit = getElementData(elevator, "exit")
            if elevatorsColShapesSpawned[dbid] then
                if (isElementWithinColShape (localElement, elevatorsColShapesSpawned[dbid][1]) or vehicleElement and isElementWithinColShape (vehicleElement, elevatorsColShapesSpawned[dbid][1])) and localDimension == eleEntrance[INTERIOR_DIM] then
                    found = true
                    foundInterior = elevator
                    foundColShape = elevatorsColShapesSpawned[dbid][1]
                    foundIsEntrance = true
                    break
                elseif (isElementWithinColShape (localElement, elevatorsColShapesSpawned[dbid][2]) or vehicleElement and isElementWithinColShape (vehicleElement, elevatorsColShapesSpawned[dbid][2])) and localDimension == eleExit[INTERIOR_DIM] then
                    found = true
                    foundInterior = elevator
                    foundColShape = elevatorsColShapesSpawned[dbid][2]
                    foundIsEntrance = false
                    break
                end
            end
        end
    end

    if not found then
        return
    end

    local interiorID = getElementData(foundInterior, "dbid")
    if interiorID then
        local interiorEntrance = getElementData(foundInterior, "entrance")
        local interiorExit = getElementData(foundInterior, "exit")

        local canEnter, errorCode, errorMsg = canEnterInterior(foundInterior)
        if canEnter or isInteriorForSale(foundInterior) then
            if getElementType(foundInterior) == "interior" then
                if not vehicleElement then
                    triggerServerEvent("interior:enter", foundInterior)
                end
            else
                triggerServerEvent("elevator:enter", foundInterior, foundIsEntrance)
            end
        else
            outputChatBox("[!]#FFFFFF " .. errorMsg, 255, 0, 0, true)
			playSoundFrontEnd(4)
        end
    end
end

function bindKeys()
    bindKey("f", "down", enterInterior)
    toggleControl("enter_exit", false)
end

function unbindKeys()
    unbindKey("f", "down", enterInterior)
    toggleControl("enter_exit", true)
end

function checkLeavePickupStart(var1)
    if var1 then
        --bindKeys( source)
        --lastSource = source
    end
end
--addEventHandler("displayInteriorName", root, checkLeavePickupStart)

local isLastSourceInterior = nil
function hitInteriorPickup(theElement, matchingdimension)
    local colshape = getElementParent(getElementParent(source))
    if getElementType(colshape) == "interior" or getElementType(colshape) == "elevator" then
        local isVehicle = false
        local theVehicle = getPedOccupiedVehicle(localPlayer)
        if theVehicle and theVehicle == theElement and getVehicleOccupant (theVehicle, 0) == localPlayer then
            isVehicle = true
        end

        if matchingdimension and (theElement == localPlayer or isVehicle)  then
            if getElementType(colshape) == "interior" or getElementType(colshape) == "elevator" then
                lastSource = false
                --triggerServerEvent("interior:requestHUD", colshape)
                baslangic = getTickCount()
                bindKeys()
                lastSourceIsEntrance = getElementData(source,"entrance") or false
                lastCol = source
                setElementData(localPlayer,"integirdi",1)
                setElementData(localPlayer,"intdbid",getElementData(source,"dbid"))
                setElementData(localPlayer,"intmoneyo",getElementData(source,"intmoneyo"))
                setElementData(localPlayer,"intowner",getElementData(source,"owner"))
                setElementData(localPlayer,"intemlak",getElementData(source,"emlak"))

                if getElementType(colshape) == "interior" then
                   isLastSourceInterior = true
                else
                    isLastSourceInterior = nil
                end
            end
        end
        cancelEvent()
    end
end
addEventHandler("onClientColShapeHit", root, hitInteriorPickup)

function leaveInteriorPickup(thePlayer, matchingdimension)
    if lastSource and lastCol == source then
        lastSource = false
    end
end
addEventHandler("onClientColShapeLeave", root, leaveInteriorPickup)
addEvent("manual-onClientColShapeLeave", true)
addEventHandler("manual-onClientColShapeLeave", root, leaveInteriorPickup)

local robotoFont = "default"
local BizNoteFont = "default-bold"
local scrWidth, scrHeight = guiGetScreenSize()
local yOffset = scrHeight-110
local margin = 3
local textShadowDistance = 3

local sx,sy = guiGetScreenSize()
local x,y = 350,110
local ox,oy = (sx-x)/2,(sy-y)/1

local w,h = 200,80
local wx,wy = (sx-w)/2,(sy-h)/1-20

local font = exports.kaisen_fonts:getFont("UbuntuBold", 10)
local fontex = exports.kaisen_fonts:getFont("UbuntuBold", 8)

function removeIntPanel()
    local int = lastCol
    if (getElementData(localPlayer,"panelacik")) then
        if not isElementWithinColShape(localPlayer,int) then
            triggerEvent("removeIntPanel",localPlayer)
        end
    end
end
setTimer(removeIntPanel, 5, 0)

function removeData()
    local int = lastCol
    if (getElementData(localPlayer,"integirdi") == 1) then
        if not isElementWithinColShape(localPlayer,int) then
            setElementData(localPlayer,"integirdi",0)
            setElementData(localPlayer,"intdbid",0)
            setElementData(localPlayer,"intmoneyo",0)
            setElementData(localPlayer,"intowner",0)
            setElementData(localPlayer,"intemlak",0)
        end
    end
end
setTimer(removeData, 5, 0)

function renderInteriorName()
    local theInterior = lastCol
    if theInterior and isElement(theInterior) and isElementWithinColShape (localPlayer, theInterior) then
        local intStatus = getElementData(theInterior, "status")
        local intName = "Kapı"
        local intId = getElementData(theInterior, "dbid")
        local intFee = getElementData(theInterior, "intfee") or 0
        local intMoney = getElementData(theInterior, "money") or 0
        local emlak = getElementData(theInterior, "emlak")
        
        local interiorStatus = getElementData(theInterior, "status")
        data = interiorStatus[INTERIOR_LOCKED]
        typeint = interiorStatus[INTERIOR_TYPE]
        
        if isLastSourceInterior then
            intName = "[#" .. intId .. "] " .. getElementData(theInterior, "name")
        end

        local textColor = tocolor(255, 255, 255, 255)
        local protectedText, inactiveText = nil
        if true or canPlayerKnowInteriorOwner(theInterior) or canPlayerSeeInteriorID(theInterior) then
            local protected, details = isProtected(theInterior)
            if protected then
                textColor = tocolor(0, 255, 0,255)
                protectedText = "[Inactivity protection remaining: " .. details .. "]"
            else
                local active, details2 = isActive(theInterior)
                if not active then
                    textColor = tocolor(150,150,150,255)
                    inactiveText = "[" .. details2 .. "]"
                end
            end
        end
        
        local intType = intStatus[INTERIOR_TYPE]
        local intwidth = dxGetTextWidth(intName, 1, intNameFont)
        
        kapiIcon = ""
        kr, kg, kb = 255, 0, 0

        if (data) then
            kapiIcon = ""
            kr, kg, kb = 227, 56, 57
        else
            kapiIcon = ""
            kr, kg, kb = 46, 204, 113
        end
        
        dxDrawRectangle(wx - intwidth / 2, wy, w + 5 + intwidth, h, tocolor(33, 33, 33, 200))
        dxDrawRectangle(wx - intwidth / 2, wy, w - 120, h, exports.rl_ui:rgba(theme.GRAY[900]))
        
		dxDrawText(kapiIcon, wx + 94 - intwidth / 2, wy + 105, wx + w, wy, tocolor(kr, kg, kb, 255), 1, intIconFont2, "left", "center")

        if intType == 0 then
			dxDrawText(intName or "?", wx + 92 - intwidth / 2, wy + 57, wx + w, wy, tocolor(255, 255, 255, 255), 1, intNameFont, "left", "center")
			dxDrawText("", wx - 120 - intwidth, wy + 78, wx + w, wy, tocolor(255, 255, 255, 255), 1, intIconFont, "center", "center")
        else
			dxDrawText(intName or "?", wx + 92 - intwidth / 2, wy + 57, wx + w, wy, tocolor(255, 255, 255, 255), 1, intNameFont, "left", "center")
			dxDrawText("", wx - 120 - intwidth, wy + 78, wx + w, wy, tocolor(255, 255, 255, 255), 1, intIconFont, "center", "center")
        end
    else
        unbindKeys()
    end
end
setTimer(renderInteriorName, 0, 0)

function canPlayerKnowInteriorOwner(theInterior)
    return (getElementData(theInterior, "status")[INTERIOR_OWNER] == 0) or (exports.rl_integration:isPlayerTrialAdmin(localPlayer) and (getElementData(localPlayer, "duty_admin"))) or (getElementData(localPlayer, "dbid") == getElementData(theInterior, "status")[INTERIOR_OWNER])
end

function canPlayerSeeInteriorID(theInterior)
    return getElementData(localPlayer, "faction") == 1 or getElementData(localPlayer, "faction") == 2 or getElementData(localPlayer, "faction") == 3 or (exports.rl_integration:isPlayerTrialAdmin(localPlayer) and (getElementData(localPlayer, "duty_admin")))
end

local lagCatcherWindow, lagCatcherMessage = nil
function showLagCatcher()
end

function hideLagCatcher(step)
    if step < 3 then
        setTimer(hideLagCatcher, 1000, 1, step+1)
        return
    end
    lagcatcherenabled = false
    destroyElement(lagCatcherMessage)
    destroyElement(lagCatcherWindow)
end

function isPickupStreamable(pickup)
    local x,y,z = getElementPosition(pickup)
    if (x > 4092 or x < -4092 or y > 4092 or y < -4092) then
        return false
    end
    return true
end

function stopFakeRotation()
    killTimer(rotateFakeTimer)
    rotateFakeTimer = nil
    outputChatBox("FakeRot timer stopped.")
end
addCommandHandler("stopfakerot", stopFakeRotation)

function debugGetNotLoadedInts()
    outputChatBox("intsToBeLoaded " .. tostring(#intsToBeLoaded))
    outputChatBox("elevatorsToBeLoaded: " .. tostring(#elevatorsToBeLoaded))
    outputChatBox("interiorsSpawned: " .. tostring(#interiorsSpawned))
    outputChatBox("elevatorsSpawned: " .. tostring(#elevatorsSpawned))
end
addCommandHandler("getloaded", debugGetNotLoadedInts)

addEventHandler("onClientResourceStart", root, function()
    for _, interior in ipairs(getElementsByType("interior")) do
        intsToBeLoaded[interior] = true
    end

    for _, elevator in ipairs(getElementsByType("elevator")) do
        elevatorsToBeLoaded[elevator] = true
    end
end)

function initializePickupLoading()
    for _, interior in ipairs(getElementsByType("interior")) do
        intsToBeLoaded[interior] = true
    end

    for _, elevator in ipairs(getElementsByType("elevator")) do
        elevatorsToBeLoaded[elevator] = true
    end
end

function schedulePickupLoading(element)
    outputDebugString("schedulePickupLoading(" .. tostring(element) .. ")")
    local pickupType = getElementType(element)
    if (pickupType == "interior") then
        if not intsToBeLoaded[element] then
            intsToBeLoaded[element] = true
        end
    elseif (pickupType == "elevator") then
        if not elevatorsToBeLoaded[element] then
            elevatorsToBeLoaded[element] = true
        end
    end
end
addEvent("interior:schedulePickupLoading",true)
addEventHandler("interior:schedulePickupLoading",root,schedulePickupLoading)

function clearElevators()
    elevatorsToBeLoaded = {}
    elevatorsSpawned = {}
end
addEvent("interior:clearElevators",true)
addEventHandler("interior:clearElevators",root,clearElevators)

addEventHandler("onClientResourceStop", getResourceRootElement(getResourceFromName("rl_elevator")), function(stoppedRes)
    clearElevators()
end)

function forcePickupSpawn()
    if exports.rl_integration:isPlayerDeveloper(localPlayer) then
        initializeSoFar()
    end
end
addCommandHandler("forcepickupspawn", forcePickupSpawn)

local curInteriors, maxInteriors, showingInterior, lastUpdateInterior = 0, 1, false, 0
local curElevators, maxElevators, showingElevator, lastUpdateElevator = 0, 1, false, 0

function showInteriorLoadingNotifier()
    showingInterior = true
    if getElementData(localPlayer, "logged") then
        local x, y, w, h = 410, 374, 470, 85
        local xoffset = (scrWidth-x)/2-x
        local yoffset = -y+10

    end

    if curInteriors >= maxInteriors or getTickCount() - lastUpdateInterior > 20000 then
        hideInteriorLoadingNotifier()
    end
end

function hideInteriorLoadingNotifier()
    if showingInterior then
        removeEventHandler("onClientPreRender", root, showInteriorLoadingNotifier)
        curInteriors, maxInteriors, showingInterior = 0, 1, false
    end
end

function interior_initializeSoFar(cur, max)
    for _, interior in ipairs(getElementsByType("interior")) do
        local dbid = tonumber(getElementData(interior, "dbid")) or 0
        if not intsToBeLoaded[interior] and not interiorsSpawned[dbid] then
            intsToBeLoaded[interior] = true
        end
    end

    if not showingInterior then
        addEventHandler("onClientPreRender", root, showInteriorLoadingNotifier)
    end
    curInteriors, maxInteriors = cur, max
    lastUpdateInterior = getTickCount()
end
addEvent("interior:initializeSoFar",true)
addEventHandler("interior:initializeSoFar",root,interior_initializeSoFar)

function showElevatorLoadingNotifier()
    showingElevator = true
    if getElementData(localPlayer, "logged") then
        local x, y, w, h = 410, 374, 470, 85
        local xoffset = (scrWidth-x)/2-x
        local yoffset = -y+10
        if showingInterior then
            yoffset = yoffset + 85+10
        end
	end

    if curElevators >= maxElevators or getTickCount() - lastUpdateElevator > 20000 then
        hideElevatorLoadingNotifier()
    end
end

function hideElevatorLoadingNotifier()
    if showingElevator then
        removeEventHandler("onClientPreRender", root, showElevatorLoadingNotifier)
        curElevators, maxElevators, showingElevator = 0, 1, false
    end
end

function elevator_initializeSoFar(cur, max)
    for _, elevator in ipairs(getElementsByType("elevator")) do
        local dbid = tonumber(getElementData(elevator, "dbid")) or 0
        if not elevatorsToBeLoaded[elevator] and not elevatorsSpawned[dbid] then
            elevatorsToBeLoaded[elevator] = true
        end
    end

    if not showingElevator then
        addEventHandler("onClientPreRender", root, showElevatorLoadingNotifier)
    end
    curElevators, maxElevators = cur, max
    lastUpdateElevator = getTickCount()
end
addEvent("elevator:initializeSoFar",true)
addEventHandler("elevator:initializeSoFar",root,elevator_initializeSoFar)

function roundedRectangle(x, y, width, height, radius, color, postGUI, subPixelPositioning)
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