local screenX, screenY = guiGetScreenSize()

function inArea(x, y, w, h)
    if isCursorShowing() then
        local aX, aY = getCursorPosition()
        aX, aY = aX * screenX, aY * screenY
        if aX > x and aX < x + w and aY > y and aY < y + h then
			exports.rl_cursor:setCursor("all", "pointinghand")
            return true
        else
            return false
        end
    else
        return false
    end
end

animateData = {}

function animate(key, data, duration, animateType)
    if not sourceResource then
        sourceResource = "this"
    end
    local nowTick = getTickCount()
    local duration = duration or 500
    local animateType = animateType or "Linear"

    if not animateData[sourceResource] then
        animateData[sourceResource] = {}
    end

    if not animateData[sourceResource][key] then
        animateData[sourceResource][key] = {
            tick = getTickCount(),
            from = data.from,
            to = data.to,
            lastAction = data.state
        }
    elseif animateData[sourceResource][key].lastAction then
        if data.state ~= animateData[sourceResource][key].lastAction then
            animateData[sourceResource][key].tick = getTickCount()
            animateData[sourceResource][key].from = data.from
            animateData[sourceResource][key].to = data.to
            animateData[sourceResource][key].lastAction = data.state
        end
    end

    animateData[sourceResource][key].lastAction = data.state
    local startTick = animateData[sourceResource][key].tick

    local elapsedTime = nowTick - startTick
    local duration = (startTick + duration) - startTick
    local progress = elapsedTime / duration

    local a, b, c = interpolateBetween(
            animateData[sourceResource][key]["from"][1], animateData[sourceResource][key]["from"][2], animateData[sourceResource][key]["from"][3],
            animateData[sourceResource][key]["to"][1], animateData[sourceResource][key]["to"][2], animateData[sourceResource][key]["to"][3],
            progress, animateType
    )

    return { a, b, c }
end

function resetAnimateData()
    if not sourceResource then
        sourceResource = "this"
    end
    animateData[sourceResource] = {}
end

function resetAnimateKey(key)
    if not key then
        return
    end
    if not sourceResource then
        sourceResource = "this"
    end
    if not animateData[sourceResource] then
        animateData[sourceResource] = {}
    end
    animateData[sourceResource][key] = nil
end