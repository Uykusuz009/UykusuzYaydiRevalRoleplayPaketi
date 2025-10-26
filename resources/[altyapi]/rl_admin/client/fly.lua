local noclip = false
local defaultSpeed = 2
local keys = {
    ileri = "d",
    geri = "a",
    sol = "s",
    sag = "w",
    yukari = "q",
    asagi = "e"
}

local function adminMi()
    return exports.rl_integration:isPlayerTrialAdmin(localPlayer)
end

function noclipHareket()
    if not noclip then return end

    local x, y, z = getElementPosition(localPlayer)
    local _, _, kameraAci = getElementRotation(getCamera())
    local hareketX, hareketY, hareketZ = 0, 0, 0

    local hiz = defaultSpeed
    if getKeyState("lalt") or getKeyState("ralt") then
        hiz = 0.25
    elseif getKeyState("lshift") or getKeyState("rshift") then
        hiz = 10
    end

    if getKeyState(keys.ileri) then hareketY = hareketY + 1 end
    if getKeyState(keys.geri) then hareketY = hareketY - 1 end
    if getKeyState(keys.sol) then hareketX = hareketX - 1 end
    if getKeyState(keys.sag) then hareketX = hareketX + 1 end
    if getKeyState(keys.yukari) then hareketZ = hareketZ + 1 end
    if getKeyState(keys.asagi) then hareketZ = hareketZ - 1 end

    local radyan = math.rad(kameraAci)
    local dx = (hareketY * math.cos(radyan) + hareketX * math.sin(-radyan)) * hiz
    local dy = (hareketY * math.sin(radyan) + hareketX * math.cos(radyan)) * hiz
    local dz = hareketZ * hiz

    setElementPosition(localPlayer, x + dx, y + dy, z + dz)
    setElementRotation(localPlayer, 0, 0, (kameraAci + 180) % 360)
end

local screen = Vector2(guiGetScreenSize())
local sx, sy = guiGetScreenSize()
local psx, psy = (sx / 1920), (sy / 1080)
local w, h = 500 * psx, 85 * psy
local x, y = screen.x/2 - w/2 - 200 * psx, screen.y/2 - h/2 - 100 * psy

function drawNoclip()
    if not noclip then return end
    dxDrawImage(screen.x/2 + 255 * psx, screen.y/2 + 330 * psy, 700 * psx, 350 * psy, "public/sounds/information.png", 0, 0, 0, tocolor(255, 255, 255, 255), false)
end

local rounded = {}
function roundedDraw(id, x, y, w, h, radius, color, post)
    if not rounded[id] then
        rounded[id] = {}
    end
    if not rounded[id][w] then
        rounded[id][w] = {}
    end
    if not rounded[id][w][h] then
        local path = string.format([[<svg width="%s" height="%s" viewBox="0 0 %s %s" fill="none" xmlns="http://www.w3.org/2000/svg"><rect opacity="1" width="%s" height="%s" rx="%s" fill="#FFFFFF"/></svg>]], w, h, w, h, w, h, radius)
        rounded[id][w][h] = svgCreate(w, h, path)
    end
    if rounded[id][w][h] then
        dxDrawImage(x, y, w, h, rounded[id][w][h], 0, 0, 0, color, (post or false))
    end
end

local function noclipToggle()
    if not adminMi() then return end

    noclip = not noclip
    setElementCollisionsEnabled(localPlayer, not noclip)
    if noclip then
        setElementAlpha(localPlayer, 0)
    else
        setElementAlpha(localPlayer, 255)
        local _, _, kameraAci = getElementRotation(getCamera())
        setElementRotation(localPlayer, 0, 0, (kameraAci + 0) % 360)
    end

    if noclip then
        addEventHandler("onClientPreRender", root, noclipHareket)
        addEventHandler("onClientRender", root, drawNoclip)
    else
        removeEventHandler("onClientPreRender", root, noclipHareket)
        removeEventHandler("onClientRender", root, drawNoclip)
    end
end

addCommandHandler("fly", noclipToggle)