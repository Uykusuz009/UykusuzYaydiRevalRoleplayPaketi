local sx, sy = guiGetScreenSize()
local font = exports['rl_fonts']:getFont('Roboto', 32)
local smallFont = exports['rl_fonts']:getFont('Roboto', 14)

local pvpTime = false
local lastPvpTime = false
local shakeTick = 0
local shakeDuration = 200 -- ms

local minusEffects = {}

-- Fade out için değişkenler
local fadeOut = false
local fadeStartTick = 0
local fadeDuration = 700 -- ms

addEvent("pvpTable", true)
addEventHandler("pvpTable", root, function(time)
    if pvpTime and time < pvpTime then
        -- -1 efekti ekle
        table.insert(minusEffects, {tick=getTickCount(), y=sy*0.08, alpha=255})
        shakeTick = getTickCount()
    end
    if time == 0 and pvpTime and pvpTime > 0 then
        fadeOut = true
        fadeStartTick = getTickCount()
    else
        fadeOut = false
    end
    lastPvpTime = pvpTime
    pvpTime = time
end)

addEventHandler("onClientRender", root, function()
    local x = sx / 2
    local baseY = sy * 0.08

    -- Fade out aktifse
    if fadeOut then
        local elapsed = getTickCount() - fadeStartTick
        local alpha = 255 * (1 - (elapsed / fadeDuration))
        if alpha < 0 then alpha = 0 end

        -- Daha hafif gölge efekti (sadece 1px ve daha düşük alpha)
        for dx = -1, 1 do
            for dy = -1, 1 do
                if not (dx == 0 and dy == 0) then
                    dxDrawText("0", x+dx, baseY+dy, x+dx, baseY+dy, tocolor(0,0,0,10 * (alpha/255)), 1, font, "center", "top")
                end
            end
        end
        dxDrawText("0", x, baseY, x, baseY, tocolor(255,255,255,alpha), 1, font, "center", "top")

        if elapsed > fadeDuration then
            fadeOut = false
            pvpTime = false
        end
    elseif pvpTime and pvpTime > 0 then
        -- Sallanma efekti
        local shakeOffset = 0
        if shakeTick > 0 then
            local elapsed = getTickCount() - shakeTick
            if elapsed < shakeDuration then
                shakeOffset = math.sin(elapsed / 20) * 3
            else
                shakeTick = 0
            end
        end

        -- Daha hafif gölge efekti
        for dx = -1, 1 do
            for dy = -1, 1 do
                if not (dx == 0 and dy == 0) then
                    dxDrawText(tostring(pvpTime), x+dx+shakeOffset, baseY+dy, x+dx+shakeOffset, baseY+dy, tocolor(0,0,0,15), 1, font, "center", "top")
                end
            end
        end
        -- Ana sayı
        dxDrawText(tostring(pvpTime), x+shakeOffset, baseY, x+shakeOffset, baseY, tocolor(255,255,255,255), 1, font, "center", "top")
    else
        return
    end

    -- -1 efektleri (beyaz)
    local now = getTickCount()
    for i = #minusEffects, 1, -1 do
        local eff = minusEffects[i]
        local progress = (now - eff.tick) / 600
        if progress > 1 then
            table.remove(minusEffects, i)
        else
            local y = eff.y - 30 * progress
            local alpha = 255 * (1 - progress)
            dxDrawText("-1", x, y, x, y, tocolor(255,255,255,alpha), 1, smallFont, "center", "top")
        end
    end
end)