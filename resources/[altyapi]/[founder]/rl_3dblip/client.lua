local Bilps = {
    [0] = {"Blips/00.png", true},
    [1] = {"Blips/01.png", true},
    [2] = {"Blips/02.png", true},
    [3] = {"Blips/03.png", true},
    [4] = {"Blips/04.png", true},
    [5] = {"Blips/05.png", true},
    [6] = {"Blips/06.png", true},
    [7] = {"Blips/07.png", true},
    [8] = {"Blips/08.png", true},
    [9] = {"Blips/09.png", true},
    [10] = {"Blips/10.png", true},
    [11] = {"Blips/11.png", true},
    [12] = {"Blips/12.png", true},
    [13] = {"Blips/13.png", true},
    [14] = {"Blips/14.png", true},
    [15] = {"Blips/15.png", true},
    [16] = {"Blips/16.png", true},
    [17] = {"Blips/17.png", true},
    [18] = {"Blips/18.png", true},
    [19] = {"Blips/19.png", true},
    [20] = {"Blips/20.png", true},
    [21] = {"Blips/21.png", true},
    [22] = {"Blips/22.png", true},
    [23] = {"Blips/23.png", true},
    [24] = {"Blips/24.png", true},
    [25] = {"Blips/25.png", true},
    [26] = {"Blips/26.png", true},
    [27] = {"Blips/27.png", true},
    [28] = {"Blips/28.png", true},
    [29] = {"Blips/29.png", true},
    [30] = {"Blips/30.png", true},
    [31] = {"Blips/31.png", true},
    [32] = {"Blips/32.png", true},
    [33] = {"Blips/33.png", true},
    [34] = {"Blips/34.png", true},
    [35] = {"Blips/35.png", true},
    [36] = {"Blips/36.png", true},
    [37] = {"Blips/37.png", true},
    [38] = {"Blips/38.png", true},
    [39] = {"Blips/39.png", true},
    [40] = {"Blips/40.png", true},
    [41] = {"Blips/41.png", true},
    [42] = {"Blips/42.png", true},
    [43] = {"Blips/43.png", true},
    [44] = {"Blips/44.png", true},
    [45] = {"Blips/45.png", true},
    [46] = {"Blips/46.png", true},
    [47] = {"Blips/47.png", true},
    [48] = {"Blips/48.png", true},
    [49] = {"Blips/49.png", true},
    [50] = {"Blips/50.png", true},
    [51] = {"Blips/51.png", true},
    [52] = {"Blips/52.png", true},
    [53] = {"Blips/53.png", true},
    [54] = {"Blips/54.png", true},
    [55] = {"Blips/55.png", true},
    [56] = {"Blips/56.png", true},
    [57] = {"Blips/57.png", true},
    [58] = {"Blips/58.png", true},
    [59] = {"Blips/59.png", true},
    [60] = {"Blips/60.png", true},
    [61] = {"Blips/61.png", true},
    [62] = {"Blips/62.png", true},
    [63] = {"Blips/63.png", true},
}

local settings = {
    IconSize = 28, -- bliplerin ekranda nekadar büyük olacağı 30 idealdir
}

function createBlip3D (x, y, z, icon, color, postGUI, visibleDistance)
    if (type(x) == "number" and type(y) == "number" and type(z) == "number") then
        local icon = icon or 0
        local color = color or tocolor(255,255,255,255)
        local postGUI = postGUI or false
        local visibleDistance = visibleDistance or 16383
        if (Bilps[icon] ~= nil and Bilps[icon][2]) then
            local Element = createElement("Blip3D")
            setElementData(Element,"x", x)
            setElementData(Element,"y", y)
            setElementData(Element,"z", z)
            setElementData(Element,"color", color)
            setElementData(Element,"icon", icon)
            setElementData(Element,"postGUI", postGUI)
            setElementData(Element,"visibleDistance", visibleDistance)
            return Element
        else
            return false
        end
    else
        return false
    end
end
addEvent("create:Blip3D", true)
addEventHandler("create:Blip3D", root, createBlip3D)

function destroyBlip3D (Element)
    if (Element ~= nil) then
        if (isElement(Element) and getElementType(Element) == "Blip3D") then
            destroyElement(Element)
            return true
        else
            return false
        end 
    else
        return false
    end
end
addEvent("destroy:Blip3D", true)
addEventHandler("destroy:Blip3D", root, destroyBlip3D)

function setBlip3DPosition (Element, x, y, z)
    if (Element ~= nil and type(x) == "number" and type(y) == "number" and type(z) == "number") then
        if (isElement(Element) and getElementType(Element) == "Blip3D") then
            setElementData(Element,"x", x)
            setElementData(Element,"y", y)
            setElementData(Element,"z", z)
            return true
        else
            return false
        end 
    else
        return false
    end
end

function getBlip3DPosition (Element)
    if (Element ~= nil) then
        if (isElement(Element) and getElementType(Element) == "Blip3D") then
            return getElementData(Element, "x"), getElementData(Element, "y"), getElementData(Element, "z")
        else
            return false
        end 
    else
        return false
    end
end

function setBlip3DIcon (Element, icon)
    if (Element ~= nil and Bilps[icon] ~= nil and Bilps[icon][2]) then
        if (isElement(Element) and getElementType(Element) == "Blip3D") then
            setElementData(Element,"icon", icon)
            return true
        else
            return false
        end 
    else
        return false
    end
end

function getBlip3DIcon (Element)
    if (Element ~= nil) then
        if (isElement(Element) and getElementType(Element) == "Blip3D") then
            return getElementData(Element,"icon")
        else
            return false
        end 
    else
        return false
    end
end

function setBlip3Dcolor (Element, color)
    if (Element ~= nil and color ~= nil) then
        if (isElement(Element) and getElementType(Element) == "Blip3D") then
            setElementData(Element,"color", color)
            return true
        else
            return false
        end 
    else
        return false
    end
end

function getBlip3Dcolor (Element)
    if (Element ~= nil) then
        if (isElement(Element) and getElementType(Element) == "Blip3D") then
            return getElementData(Element,"color")
        else
            return false
        end 
    else
        return false
    end
end

function setBlip3DpostGUI (Element, postGUI)
    if (Element ~= nil and type(postGUI) == "boolean") then
        if (isElement(Element) and getElementType(Element) == "Blip3D") then
            setElementData(Element,"postGUI", postGUI)
            return true
        else
            return false
        end 
    else
        return false
    end
end

function getBlip3DpostGUI (Element)
    if (Element ~= nil) then
        if (isElement(Element) and getElementType(Element) == "Blip3D") then
            return getElementData(Element,"postGUI")
        else
            return false
        end 
    else
        return false
    end
end

function setBlip3DvisibleDistance (Element, visibleDistance)
    if (Element ~= nil and type(visibleDistance) == "number") then
        if (isElement(Element) and getElementType(Element) == "Blip3D") then
            setElementData(Element,"visibleDistance", visibleDistance)
            return true
        else
            return false
        end 
    else
        return false
    end
end

function getBlip3DvisibleDistance (Element)
    if (Element ~= nil) then
        if (isElement(Element) and getElementType(Element) == "Blip3D") then
            return getElementData(Element,"visibleDistance")
        else
            return false
        end 
    else
        return false
    end
end

addEventHandler ( "onClientRender", getRootElement(),
function ()
    local PX, PY, PZ = getElementPosition(getLocalPlayer())
    for id,Element in ipairs(getElementsByType("Blip3D")) do
        local EX, EY, EZ = getElementData(Element, "x"), getElementData(Element, "y"), getElementData(Element, "z")
        local Ecolor = getElementData(Element, "color")
        local Eicon = getElementData(Element, "icon")
        local EpostGUI = getElementData(Element, "postGUI")
        local EvisibleDistance = getElementData(Element, "visibleDistance")
        local Distance = getDistanceBetweenPoints3D (EX, EY, EZ, PX, PY, PZ)
        if (Distance <= EvisibleDistance) then
            local SX, SY = getScreenFromWorldPosition (EX, EY, EZ)
            if (SX and SY) then
                dxDrawImage (SX-(settings.IconSize/2), SY, settings.IconSize, settings.IconSize, Bilps[Eicon][1], 0, 0, 0, Ecolor, EpostGUI)
                dxDrawText (math.floor(Distance).." m", (SX-15)+2, ((SY+15)+settings.IconSize)+2, (SX+15)+2, ((SY+15)+settings.IconSize)+2, tocolor(0,0,0,200), 1.5, "default-bold", "center", "center", false, false, EpostGUI)
                dxDrawText (math.floor(Distance).." m", (SX-15)+2, ((SY+15)+settings.IconSize)-2, (SX+15)+2, ((SY+15)+settings.IconSize)-2, tocolor(0,0,0,200), 1.5, "default-bold", "center", "center", false, false, EpostGUI)
                dxDrawText (math.floor(Distance).." m", (SX-15)-2, ((SY+15)+settings.IconSize)+2, (SX+15)-2, ((SY+15)+settings.IconSize)+2, tocolor(0,0,0,200), 1.5, "default-bold", "center", "center", false, false, EpostGUI)
                dxDrawText (math.floor(Distance).." m", (SX-15)-2, ((SY+15)+settings.IconSize)-2, (SX+15)-2, ((SY+15)+settings.IconSize)-2, tocolor(0,0,0,200), 1.5, "default-bold", "center", "center", false, false, EpostGUI)
                dxDrawText (math.floor(Distance).." m", SX-15, (SY+15)+settings.IconSize, SX+15, (SY+15)+settings.IconSize, tocolor(255,255,255,200), 1.5, "default-bold", "center", "center", false, false, EpostGUI)
				
				if Distance and tonumber(Distance) <= 12 then --Mesafeye gore silme
					destroyBlip3D(Element)
				end
            end
        end
    end
end)

--createBlip3D(2751.47241, -1121.47717, 69.57813,1)




