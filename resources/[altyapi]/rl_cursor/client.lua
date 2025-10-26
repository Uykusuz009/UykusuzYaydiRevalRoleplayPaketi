local availableCursors = {
    ["pointer"] = {
        path = "public/svgs/pointer.svg",
        width = 32,
        height = 32,
        offsetX = -4,
        invertColors = true,
    },
    ["notallowed"] = {
        path = "public/svgs/notallowed.svg",
        width = 32,
        height = 32,
        invertColors = true,
        offsetX = -4,
    },
    ["openhand"] = {
        path = "public/svgs/openhand.svg",
        width = 32,
        height = 32,
        invertColors = false,
        offsetX = -3.5,
    },
    ["closedhand"] = {
        path = "public/svgs/closedhand.svg",
        width = 32,
        height = 32,
        invertColors = false,
        offsetX = -3.5,
        offsetY = -3.5,
    },
    ["ibeam"] = {
        path = "public/svgs/ibeam.svg",
        width = 32,
        height = 32,
        invertColors = false,
        offsetX = -7.5,
        offsetY = -8,
    },
    ["pointinghand"] = {
        path = "public/svgs/pointinghand.svg",
        width = 32,
        height = 32,
        invertColors = false,
        offsetX = -3.5,
    },
    ["tooltip"] = {
        path = "public/svgs/tooltip.svg",
        width = 32,
        height = 32,
        invertColors = true,
        offsetX = -8.5,
        offsetY = -7,
    },
}

local guiCursorTypes = {
    ["gui-edit"] = "ibeam",
    ["gui-memo"] = "ibeam",
    ["gui-button"] = "pointinghand",
    ["gui-checkbox"] = "pointinghand",
}

local _showCursor = showCursor

local cursorEnabledResources = {}
local requestesCursors = {}

local cursorColor = tocolor(255, 255, 255, 255)
local cursorEnabled = true
local activeGUI = nil

local sX, sY = guiGetScreenSize()
local scale = ((sX / 1920) + (sY / 1080)) / 2
if (scale < 0.5) then
    scale = 0.5
end

for cursorName, cursorData in pairs(availableCursors) do
    cursorData.width = math.floor(cursorData.width * scale)
    cursorData.height = math.floor(cursorData.height * scale)
    cursorData.offsetX = cursorData.offsetX and cursorData.offsetX * scale or 0
    cursorData.offsetY = cursorData.offsetY and cursorData.offsetY * scale or 0
    availableCursors[cursorName].image = svgCreate(cursorData.width, cursorData.height, cursorData.path)
end

local function isTableEmpty(tbl)
    for i, v in pairs(tbl) do
        return false
    end
    return true
end

local function isCursorVisible()
    return isCursorShowing()
end

local function getActiveCursor()
    if (#requestesCursors == 0) then
        return availableCursors["pointer"]
    end

    return availableCursors[requestesCursors[#requestesCursors][1]]
end

local function showCursorInternal(cursorVisible, resource)
    cursorEnabled = cursorVisible
end

local function setCursorInternal(user, cursorName, resource)
    if (user == "all") then
        for i = #requestesCursors, 1, -1 do
            if (requestesCursors[i][2] == resource) then
                table.remove(requestesCursors, i)
            end
        end
    else
        for i = #requestesCursors, 1, -1 do
            if (requestesCursors[i][2] == resource and requestesCursors[i][3] == user) then
                table.remove(requestesCursors, i)
                break
            end
        end
    end
    
	if (not cursorName) then
        return true
    end

    if (not availableCursors[cursorName]) then
        return false
    end
	
    requestesCursors[#requestesCursors + 1] = { cursorName, resource, user }
end

addEventHandler("onClientRender", root, function()
	local defaultCursorNeedsVisible = isMainMenuActive() or isConsoleActive() or isChatBoxInputActive()
    if (isCursorVisible()) and not defaultCursorNeedsVisible then

        setCursorAlpha(defaultCursorNeedsVisible and 255 or 0)
        local cursorData = getActiveCursor()
        local cX, cY = getCursorPosition()
        cX, cY = cX * sX, cY * sY

        if cursorData.image then
            dxDrawImage(math.floor(cX + cursorData.offsetX), math.floor(cY + cursorData.offsetY), cursorData.width, cursorData.height, cursorData.image, 0, 0, 0, cursorColor, true)
			
			if cursorData.path ~= "public/svgs/pointer.svg" and not isElement(activeGUI) then
				setCursorInternal("all", "pointer")
			end
        else
            setCursorAlpha(255)
        end
    else
        setCursorAlpha(255)
    end
end, true, "low-9999999")

addEventHandler("onClientMouseEnter", root, function()
    local type = getElementType(source)
    if guiCursorTypes[type] then
        activeGUI = source
		setCursorInternal("all", guiCursorTypes[type])
    end    
end)

addEventHandler("onClientMouseLeave",root,function()
    local type = getElementType(source)
    if guiCursorTypes[type] then
        activeGUI = nil
		setCursorInternal("all", "pointer")
    end  
end)

addEventHandler("onClientResourceStop", root, function(resource)
	setCursorInternal("all", nil, resource)
    showCursorInternal(false, resource)
end)

function setCursor(user, cursorName)
    setCursorInternal(user, cursorName, sourceResource)
end

function showCursor(cursorVisible)
    showCursorInternal(cursorVisible, sourceResource)
end

function setCustomCursorAlpha(alpha)
    cursorColor = tocolor(255, 255, 255, alpha)
end

bindKey("m", "down", function()
    _showCursor(not isCursorShowing())
end)