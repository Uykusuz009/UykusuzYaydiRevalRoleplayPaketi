local screen = Vector2(guiGetScreenSize())
local w, h = 450, 500
local x, y = (screen.x - w) / 2, (screen.y - h) / 2
local x2, y2 = (screen.x - w) / 2, (screen.y - h) * 2
local bold = dxCreateFont('assets/sfbold.ttf', 13)
local bold2 = exports.kaisen_fonts:getFont("sf-regular", 12)
local bold3 = exports.kaisen_fonts:getFont("sf-regular", 12)
local bold4 = exports.kaisen_fonts:getFont("sf-bold", 11)
local bold5 = exports.kaisen_fonts:getFont("sf-bold", 12)
local maxScroll = 0
local playerData = {}
local maxShowing = 15
local scroll = 0


local fadeDurumSekli = "hidden"
local fadeBaslangic = 0
local fadeSure = 180
local fadeSeffaflik = 0

function ratheusTab(name)
    -- Blur efekti fade animasyonuna bağlı alpha ile çizilsin
    if fadeDurumSekli == "fadein" or fadeDurumSekli == "visible" then
        exports.kaisen_blur:bluredRectangle(0, 0, screen.x, screen.y, tocolor(255, 255, 255, fadeSeffaflik))
    end

    local now = getTickCount()
    if fadeDurumSekli == "fadein" then
        local progress = math.min((now - fadeBaslangic) / fadeSure, 1)
        fadeSeffaflik = math.floor(250 * progress)
        if progress >= 1 then
            fadeDurumSekli = "visible"
            fadeSeffaflik = 250
        end
    elseif fadeDurumSekli == "fadeout" then
        local progress = math.min((now - fadeBaslangic) / fadeSure, 1)
        fadeSeffaflik = math.floor(250 * (1 - progress))
        if progress >= 1 then
            fadeDurumSekli = "hidden"
            fadeSeffaflik = 0
            if isTimer(render) then killTimer(render) end
            showChat(true) -- Show chat after scoreboard closes
            return
        end
    elseif fadeDurumSekli == "hidden" then
        return
    else
        fadeSeffaflik = 250
    end

    local alpha = fadeSeffaflik
    local alpha1 = math.floor(150 * (alpha / 250))
    
    local players = getElementsByType("player")
    playerData = {}

    for k, player in ipairs(players) do
        playerData[k] = player
    end

    table.sort(playerData, function(a, b)
        if a ~= localPlayer and b ~= localPlayer and getElementData(a, "id") and getElementData(b, "id") then
            return getElementData(a, "id") < getElementData(b, "id")
        end
    end)

    maxScroll = math.max(0, #playerData - maxShowing)
    counter = 0
    count = 0
    counts = 0

    local para = exports.rl_global:formatMoney(exports.rl_global:getMoney(getLocalPlayer()) or 0)
    dxDrawImage(0, 0, screen.x, screen.y, "bg.png", 0, 0, 0, tocolor(255, 255, 255, alpha1))
    dxDrawImage(x+160,y-180,w-300,h-350, ":rl_ui2/public/images/logo.png", 0, 0, 0, tocolor(255, 255, 255, math.floor(220 * (alpha / 250))))
    dxDrawText(#players .. " online", x + 380, y - 30, w, h, tocolor(0, 238, 0, alpha), 1, bold4)
    dxDrawText("Reval", x + 30, y - 40, w, h, tocolor(255,255,255,math.floor(200 * (alpha / 250))), 1, bold)
    dxDrawText("Roleplay", x + 30, y - 20, w, h, tocolor(255,255,255,math.floor(150 * (alpha / 250))), 0.90, bold3)
    dxDrawText("ID       İsim                                                   Saat               Ping", x + 30, y +17, w, h, tocolor(255, 255, 255, math.floor(200 * (alpha / 250))), 0.80, bold5)

    for index, player in ipairs(playerData) do
        if index > scroll and counter < maxShowing then
            local r, g, b = getPlayerNametagColor(player)
            local name = getPlayerName(player):gsub("_"," ") or 'Giriş yapmadı'
            local ping = getPlayerPing(player) or 0 
            local saat = getElementData(player, "hours_played") or 0
            local vip = getElementData(player, "vip") or 0
            local id = getElementData(player, "id") or 0
            if ping < 75 then
                r3, g3, b3 = 255, 255, 255
            elseif ping > 75 and ping < 150 then
                r3, g3, b3 = 255, 255, 255
            else
                r3, g3, b3 = 255, 255, 255
            end

            dxDrawText(id, x + 32, y+100 + counts, x + 32, y , tocolor(r, g, b, alpha), 0.8, bold2, "left", "center")

            if getElementData(player, "account:loggedin") and exports.rl_global:isStaffOnDuty(localPlayer) then
                dxDrawText(name .. "  (" .. getElementData(player, "account:username") .. ")", x + 72, y+100  + counts, x + 72, y + 0, tocolor(r, g, b, alpha), 0.8, bold2, "left", "center")
            else
                dxDrawText(name, x + 72, y + counts, x + 72, y- 105 + 207, tocolor(r, g, b, alpha), 0.8, bold2, "left", "center")
            end

            dxDrawText(saat, x + 230, y+100 + counts, x + 413, y , tocolor(r, g, b, alpha), 0.8, bold2, "center", "center")
            dxDrawText(ping, x + 360, y+100 + counts, x + 469, y , tocolor(r, g, b , alpha), 0.8, bold2, "center", "center")

            count = count + 30
            counts = counts + 60
            counter = counter + 1
        end
    end


end

local render
local scrollSpeed = 50 -- Ayarlamak istediğiniz kaydırma hızı (milisaniye cinsinden)

function open()
    if fadeDurumSekli == "hidden" then
        if not isTimer(render) then
            render = setTimer(ratheusTab, 0, 0)
        end
        fadeDurumSekli = "fadein"
        fadeBaslangic = getTickCount()
        hover1 = getTickCount()
        scroll = 0
        bindKey("mouse_wheel_down", "down", wheelDown)
        bindKey("mouse_wheel_up", "down", wheelUp)
        showChat(false) -- Hide chat when scoreboard opens
    end
end

addEventHandler("onClientKey", root, function(button, press) 
    if button == "tab" then
        if press then
            open()
            setElementData(localPlayer,"hudkapa",true)
        else
            setElementData(localPlayer,"hudkapa",false)
            if fadeDurumSekli == "visible" or fadeDurumSekli == "fadein" then
                fadeDurumSekli = "fadeout"
                fadeBaslangic = getTickCount()
            end
        end
    end
end)

local canScroll = true
--Huso
function wheelDown()
    if canScroll and scroll < maxScroll then
        canScroll = false
        setTimer(function() canScroll = true end, scrollSpeed, 1) -- İzin verilen tekrar süresi
        scroll = scroll + 1
    end
end

function wheelUp()
    if canScroll and scroll > 0 then
        canScroll = false
        setTimer(function() canScroll = true end, scrollSpeed, 1) -- İzin verilen tekrar süresi
        scroll = scroll - 1
    end
end
