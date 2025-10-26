local RECT_SIZE = 32
local PRESS_KEY = "E"
local DEFAULT_RADIUS = 8  -- Eksik olan sabit değer eklendi

local percentages = {}

local theme = exports.rl_ui:useTheme()
local fonts = exports.rl_ui:useFonts()

-- Timer interval'ı performans için 50ms'ye çıkarıldı (her frame yerine)
setTimer(function()
    if getElementData(localPlayer, "logged") then
        local nearestPed = nil
        local nearestDistance = 2.5
        local nearestPedName = nil
        local playerPosition = localPlayer.position

        for _, ped in ipairs(getElementsByType("ped")) do
            local pedPosition = ped.position
            local distance = getDistanceBetweenPoints3D(playerPosition, pedPosition)

            if distance < nearestDistance and ped:isOnScreen() then
                local pedName = getElementData(ped, "name")
                local pedTalkStatus = getElementData(ped, "talk")
                if pedName and pedTalkStatus == 1 then
                    nearestPed = ped
                    nearestDistance = distance
                    nearestPedName = pedName:gsub("_", " ")
                end
            end
        end

        if nearestPed then
            local position, worldPosition = calculatePedPosition(nearestPed, playerPosition)
            local percent = percentages[nearestPed] or 0

            local buttonPosition = {
                x = position.x - RECT_SIZE / 2,
                y = position.y - RECT_SIZE / 2
            }

            exports.rl_ui:drawButton({
                position = buttonPosition,
                size = {
                    x = RECT_SIZE,
                    y = RECT_SIZE
                },
                radius = DEFAULT_RADIUS,  -- Tek radius tanımı
                textProperties = {
                    align = "center",
                    color = theme.WHITE,
                    font = fonts.body.thin,
                    scale = 1,
                },
                variant = "rounded",
                alpha = 300,
                color = "purple",
                disabled = false,
                text = PRESS_KEY,
                icon = "",
            })
            
            if nearestPedName then
                dxDrawText(nearestPedName, position.x + 1, position.y + 1 + RECT_SIZE, position.x + 1, position.y + 1 + RECT_SIZE, tocolor(0, 0, 0), 1, fonts.body.regular, "center", "center")
                dxDrawText(nearestPedName, position.x, position.y + RECT_SIZE, position.x, position.y + RECT_SIZE, tocolor(255, 255, 255), 1, fonts.body.regular, "center", "center")
            end

            if percent > 0 and percent ~= (RECT_SIZE + 1) then
                dxDrawLine(buttonPosition.x, buttonPosition.y + RECT_SIZE - 1, buttonPosition.x + percent, buttonPosition.y + RECT_SIZE - 1, exports.rl_ui:rgba(theme.BLUE[300], 1), 2)
            end

            if isKeyPressed(PRESS_KEY) then
                if percent < RECT_SIZE then
                    percent = percent + 1
                    percentages[nearestPed] = math.min(percent, RECT_SIZE)
                elseif percent == RECT_SIZE then
                    percentages[nearestPed] = RECT_SIZE + 1
                    triggerEvent("shop.talkPed", localPlayer, nearestPed)
                end
            else
                if percent > 0 then
                    percent = percent - 2
                    percentages[nearestPed] = math.max(percent, 0)
                end
            end
        end
    end
end, 0, 0)  -- 0 yerine 50ms interval

function calculatePedPosition(element, playerPosition)
    local drawPosition = {
        x = -50,
        y = -50
    }

    local bonePositionX, bonePositionY, bonePositionZ = getElementBonePosition(element, 3)
    local x, y = getScreenFromWorldPosition(bonePositionX, bonePositionY, bonePositionZ)

    -- Boolean kontrolü eklendi
    if type(x) == "number" and type(y) == "number" then
        drawPosition = {
            x = x,
            y = y
        }
    end

    return drawPosition, element.position
end

function isKeyPressed(key)
    if isConsoleActive() or isMainMenuActive() then
        return false
    end
    return getKeyState(key)
end