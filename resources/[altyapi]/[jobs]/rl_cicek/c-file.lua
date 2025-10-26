sx , sy = guiGetScreenSize()
local dgfont = dxCreateFont("fonts.ttf",10)

function ebind()
    if getElementData(localPlayer, "cicek:e") and not isPedInVehicle(localPlayer) then
        -- dxDraw'ları ekranın daha aşağısına taşıdık
        dxDrawRoundedRectangle(sx*0.41, sy*0.85, sx*0.18, sy*0.04, tocolor(10,10,10, 235), { 0.4, 0.4, 0.4, 0.4 })
        dxDrawText(" Çiçek "..getElementData(localPlayer, "cicek:tur").." için [E] basınız." , 0, sy*0.86, sx, sy , tocolor(255,255,255) , 1 , dgfont, "center")
    end
end
setTimer(ebind, 0,0)

local ciceksure = 0
local toplamaAktif = false

function cicek_toplama(t)
    -- Eğer oyuncu arabadaysa toplama işlemini iptal et
    if isPedInVehicle(localPlayer) then
        outputChatBox("Araçtayken çiçek toplayamazsınız!", 255, 0, 0)
        toplamaAktif = false
        setElementData(localPlayer, "cicek:top", false)
        setElementData(localPlayer, "bind:engel", false)
        return
    end
    
    ciceksure = 0
    toplamaAktif = true
    setTimer(function()
        if not toplamaAktif then return end
        
        -- Toplama sırasında araç binme kontrolü
        if isPedInVehicle(localPlayer) then
            outputChatBox("Araçtayken çiçek toplayamazsınız!", 255, 0, 0)
            toplamaAktif = false
            setElementData(localPlayer, "cicek:top", false)
            setElementData(localPlayer, "bind:engel", false)
            return
        end
        
        ciceksure = ciceksure + 0.02
        if ciceksure >= 10 then
            toplamaAktif = false
            triggerServerEvent("cicek:ver", localPlayer, localPlayer)
            setElementData(localPlayer, "cicek:top", false)
            setElementData(localPlayer, "bind:engel", false)
        end
    end, 10, 501)
end
addEvent("cicek:toplama", true)
addEventHandler("cicek:toplama", getLocalPlayer(), cicek_toplama)

function drawNiceBar(x, y, w, h, progress)
    -- Kenarlık
    dxDrawRectangle(x-2, y-2, w+4, h+4, tocolor(30,30,30,200))
    -- Arka plan
    dxDrawRectangle(x, y, w, h, tocolor(0,0,0,180))
    -- Renk geçişli bar
    local r1, g1, b1 = 100, 200, 100
    local r2, g2, b2 = 255, 255, 100
    local progW = w * progress
    for i=0, progW do
        local t = i / w
        local r = r1 + (r2 - r1) * t
        local g = g1 + (g2 - g1) * t
        local b = b1 + (b2 - b1) * t
        dxDrawRectangle(x+i, y, 1, h, tocolor(r, g, b, 220))
    end
end

function cicekdurum() 
    if getElementData(localPlayer, "cicek:top") and toplamaAktif then
        local barW, barH = sx*0.25, sy*0.03
        local barX, barY = (sx-barW)/2, sy*0.91
        drawNiceBar(barX, barY, barW, barH, math.min(ciceksure/10,1))
        dxDrawText("Çiçek Toplanıyor...", barX, barY-25, barX+barW, barY, tocolor(255,255,255,220), 1, dgfont, "center", "bottom")
    end
end 
setTimer(cicekdurum, 0,0)

function roundedRectangle(x, y, w, h, borderColor, bgColor, postGUI)
    if (x and y and w and h) then
        if (not borderColor) then
            borderColor = tocolor(0, 0, 0, 200);
        end
        
        if (not bgColor) then
            bgColor = borderColor;
        end
        
        --> Background
        dxDrawRectangle(x, y, w, h, bgColor, postGUI);
        
        --> Border
        dxDrawRectangle(x + 2, y - 1, w - 4, 1, borderColor, postGUI); -- top
        dxDrawRectangle(x + 2, y + h, w - 4, 1, borderColor, postGUI); -- bottom
        dxDrawRectangle(x - 1, y + 2, 1, h - 4, borderColor, postGUI); -- left
        dxDrawRectangle(x + w, y + 2, 1, h - 4, borderColor, postGUI); -- right
    end
end

setElementData(localPlayer, "cicek:top", false)
setElementData(localPlayer, "bind:engel", false)