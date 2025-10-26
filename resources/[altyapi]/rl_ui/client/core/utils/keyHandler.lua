lastClick = 0
pressedKeys = {}
local keyTimers = {}

addEventHandler("onClientKey", root, function(key, state)
    if key == "mouse1" then
        return
    end
    if isTimer(keyTimers[key]) then
        killTimer(keyTimers[key])
    end

    pressedKeys[key] = state
    keyTimers[key] = setTimer(function()
        pressedKeys[key] = nil
    end, 5, 1)
end)

function isKeyClicked(key)
    return pressedKeys[key]
end

function isKeyPressed(key)
    if isConsoleActive() or isMainMenuActive() then
        return false
    end
    return isKeyClicked(key)
end

function isMouseClicked()
    return pressedKeys.mouse1
end

setTimer(function()
    if getKeyState("mouse1") and lastClick + 200 <= getTickCount() then
        lastClick = getTickCount()
        pressedKeys.mouse1 = true
    else
        pressedKeys.mouse1 = false
    end

end, 0, 0)