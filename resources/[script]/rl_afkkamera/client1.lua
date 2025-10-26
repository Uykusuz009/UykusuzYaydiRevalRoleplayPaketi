-- AFK Kamera Sistemi
local tick = 0
local bugFixleme = false  -- Debug kapalı
local ticklimit = 30  -- 30 saniye AFK kalınca kamera moduna geç
local sm = {moov = 0, object1 = nil, object2 = nil}
local afk = nil  -- Ana timer'ı global olarak tanımla

local function removeCamHandler()
    if (sm.moov == 1) then
        sm.moov = 0
    end
end

local function camRender()
    if (sm.moov == 1) then
        local x1,y1,z1 = getElementPosition(sm.object1)
        local x2,y2,z2 = getElementPosition(sm.object2)
        setCameraMatrix(x1, y1, z1, x2, y2, z2)
    else
        removeEventHandler("onClientPreRender", root, camRender)
    end
end

function smoothMoveCamera(x1, y1, z1, x1t, y1t, z1t, x2, y2, z2, x2t, y2t, z2t, time)
    if (sm.moov == 1) then return false end
    sm.object1 = createObject(1337, x1, y1, z1)
    sm.object2 = createObject(1337, x1t, y1t, z1t)
    setElementCollisionsEnabled(sm.object1, false) 
    setElementCollisionsEnabled(sm.object2, false) 
    setElementAlpha(sm.object1, 0)
    setElementAlpha(sm.object2, 0)
    setObjectScale(sm.object1, 0.01)
    setObjectScale(sm.object2, 0.01)
    moveObject(sm.object1, time, x2, y2, z2, 0, 0, 0, "InOutQuad")
    moveObject(sm.object2, time, x2t, y2t, z2t, 0, 0, 0, "InOutQuad")
    sm.moov = 1
    setTimer(removeCamHandler, time, 1)
    setTimer(destroyElement, time, 1, sm.object1)
    setTimer(destroyElement, time, 1, sm.object2)
    addEventHandler("onClientPreRender", root, camRender)
    return true
end

function getPositionInfrontOfElement(element, meters)
    if (not element or not isElement(element)) then return false end
    local meters = (type(meters) == "number" and meters) or 3
    local posX, posY, posZ = getElementPosition(element)
    local _, _, rotation = getElementRotation(element)
    posX = posX - math.sin(math.rad(rotation)) * meters
    posY = posY + math.cos(math.rad(rotation)) * meters
    rot = rotation + math.cos(math.rad(rotation))
    return posX, posY, posZ , rot
end

function getMatrixLeft(m)
    return m[1][1], m[1][2], m[1][3]
end
function getMatrixForward(m)
    return m[2][1], m[2][2], m[2][3]
end
function getMatrixUp(m)
    return m[3][1], m[3][2], m[3][3]
end
function getMatrixPosition(m)
    return m[4][1], m[4][2], m[4][3]
end

function getPositionFromElementOffset(element,offX,offY,offZ) 
    local m = getElementMatrix ( element )
    local x = offX * m[1][1] + offY * m[2][1] + offZ * m[3][1] + m[4][1]
    local y = offX * m[1][2] + offY * m[2][2] + offZ * m[3][2] + m[4][2] 
    local z = offX * m[1][3] + offY * m[2][3] + offZ * m[3][3] + m[4][3] 
    return x, y, z
end 

function getPointFromDistanceRotation(x, y, dist, angle)
    local a = math.rad(90 - angle);
    local dx = math.cos(a) * dist;
    local dy = math.sin(a) * dist;
    return x+dx, y+dy;
end

function afkCAMERA()    
    local x,y,z = getElementPosition(getLocalPlayer())
    if getPedOccupiedVehicle( getLocalPlayer() ) then 
        local veh = getPedOccupiedVehicle( getLocalPlayer() )
        local x,y,z = getElementPosition(veh)
        local xx,yy,zz = getPositionFromElementOffset(veh,-1.5,5,0.3)
    
        local xxxx,yyyy,zzzz = getElementPosition(veh)
        local xxx,yyy,zzz = getPositionFromElementOffset(veh,-2.5,-4,1.3)
        smoothMoveCamera(xx,yy,zz,x,y,z,xxx,yyy,zzz,xxxx,yyyy,zzzz,13000)
    else
        local x,y,z = getElementPosition(getLocalPlayer())
        local xx,yy,zz = getPositionInfrontOfElement( getLocalPlayer(),3)
        smoothMoveCamera(x,y,z,x,y,z,xx+2,yy+2,zz+1,x,y,z,3500)
        setPedAnimation(localPlayer,'dealer','dealer_idle',-1,true,false,false,false)
    end
    
    timamk = setTimer(function ()
        if getPedOccupiedVehicle( getLocalPlayer() ) and getElementData(localPlayer,'isAFK') == true then
            local veh = getPedOccupiedVehicle( getLocalPlayer() )
            local x,y,z = getElementPosition(veh)
            local xx,yy,zz = getPositionFromElementOffset(veh,0,0,3)
        
            local xxxx,yyyy,zzzz = getPositionFromElementOffset(veh,0,0,0)
            local xxx,yyy,zzz = getPositionFromElementOffset(veh,0,5,1)
            smoothMoveCamera(xx,yy,zz,x,y,z,xxx,yyy,zzz,xxxx,yyyy,zzzz,10000)
            
            timamk2 = setTimer(function ()
                local veh = getPedOccupiedVehicle( getLocalPlayer() )
                local x,y,z = getPositionFromElementOffset(veh,0,-0.03,-20)
                local xx,yy,zz = getPositionFromElementOffset(veh,0,0,2)
           
                local xxxx,yyyy,zzzz = getElementPosition(veh)
                local xxx,yyy,zzz = getPositionFromElementOffset(veh,0,2.2,2)
                smoothMoveCamera(xx,yy,zz,x,y,z,xxx,yyy,zzz,xxxx,yyyy,zzzz-9000,9000)
                
                setTimer(function ()
                    isik()
                end,4500,1)

                timeamk3 = setTimer(function ()
                    arasahne2amk()
                end,10000,1)
            end,10000,1)
        end
    end,13000,1)
end

function arasahne2amk()
    if getPedOccupiedVehicle( getLocalPlayer() ) and getElementData(localPlayer,'isAFK') == true then
        local veh = getPedOccupiedVehicle( getLocalPlayer() )
        local x,y,z = getElementPosition(veh)
        local xx,yy,zz = getPositionFromElementOffset(veh,1.5,3,0.3)

        local xxxx,yyyy,zzzz = getPositionFromElementOffset(veh,-2,-4,-0.4)
        local xxx,yyy,zzz = getPositionFromElementOffset(veh,1.5,-1,0.3)
        smoothMoveCamera(xx,yy,zz,x,y,z,xxx,yyy,zzz,xxxx,yyyy,zzzz,9000)
        ddd = setTimer(function ()
            arasahne3amk()
        end,9000,1)
    end
end

function arasahne3amk()
    if getPedOccupiedVehicle( getLocalPlayer() ) and getElementData(localPlayer,'isAFK') == true then
        local veh = getPedOccupiedVehicle( getLocalPlayer() )
        local x,y,z = getElementPosition(veh)
        local xx,yy,zz = getPositionFromElementOffset(veh,1.5,3,0.3)

        local xxxx,yyyy,zzzz = getPositionFromElementOffset(veh,2,1,-0)
        local xxx,yyy,zzz = getPositionFromElementOffset(veh,-2,5,0.1)
        smoothMoveCamera(xx,yy,zz,x,y,z,xxx,yyy,zzz,xxxx,yyyy,zzzz,9400)
        fdfd = setTimer(function ()
            arasahne4amk()
        end,9600,1)
    end
end

function arasahne4amk()
    if getPedOccupiedVehicle( getLocalPlayer() ) and getElementData(localPlayer,'isAFK') == true then
        local veh = getPedOccupiedVehicle( getLocalPlayer() )
        local x,y,z = getElementPosition(veh)
        local xx,yy,zz = getPositionFromElementOffset(veh,-1.6,-4,1)

        local xxxx,yyyy,zzzz = getPositionFromElementOffset(veh,0,1,0)
        local xxx,yyy,zzz = getPositionFromElementOffset(veh,0.6,-4,-0.1)
        smoothMoveCamera(xx,yy,zz,x,y,z,xxx,yyy,zzz,xxxx,yyyy,zzzz,9400)
        dsds = setTimer(function ()
            afkCAMERA()
        end,6400,1)
    end
end

function isik()
    st = 0
    setTimer(function ()
        if st == 0 then
            local veh = getPedOccupiedVehicle( localPlayer )
            setVehicleOverrideLights ( veh, 2 )
            st = 1
        elseif st == 1 then
            local veh = getPedOccupiedVehicle( localPlayer )
            setVehicleOverrideLights ( veh, 0 )
            st = 0
        end
    end,500,9)
end

function afkEventi(durum)
    if durum == true then
        fadeCamera(false,1.5)
        setTimer(function ()
            fadeCamera(true,1.5)
            if getElementData(localPlayer,'isAFK') == true then
                afkCAMERA()
            end
        end,1500,1)
    else
        -- Tüm timer'ları durdur
        if isTimer(timamk) then killTimer(timamk) end
        if isTimer(timamk2) then killTimer(timamk2) end
        if isTimer(timeamk3) then killTimer(timeamk3) end
        if isTimer(dsds) then killTimer(dsds) end
        if isTimer(ddd) then killTimer(ddd) end
        if isTimer(fdfd) then killTimer(fdfd) end
        
        -- Kamera kontrolünü sıfırla
        setCameraTarget(localPlayer)
        removeEventHandler("onClientPreRender", root, camRender)
        setPedAnimation(localPlayer)
    end
end

function baslatAFK()
    -- Önceki timer'ı durdur (eğer varsa)
    if isTimer(afk) then killTimer(afk) end
    
    afk = setTimer(function ()
        -- Hareket kontrolü
        local vehicle = getPedOccupiedVehicle(localPlayer)
        local isMoving = false
        
        -- Araç sürülüyor mu kontrol et
        if vehicle then
            local vx, vy, vz = getElementVelocity(vehicle)
            local speed = math.sqrt(vx^2 + vy^2 + vz^2) * 100 -- km/h'ye çevir
            if speed > 1 then -- 1 km/h'den fazla hareket ediyorsa
                isMoving = true
            end
        else
            -- Yürürken hareket kontrolü
            local vx, vy, vz = getElementVelocity(localPlayer)
            local speed = math.sqrt(vx^2 + vy^2 + vz^2) * 100
            if speed > 0.5 then -- 0.5 km/h'den fazla hareket ediyorsa
                isMoving = true
            end
        end
        
        -- Hareket etmiyorsa tick artır
        if not isMoving then
            tick = tick + 1
            printattirmafalan(tick)
            if tick > ticklimit then
                if getElementData(localPlayer,'isAFK') ~= true then
                    afkEventi(true)
                    setElementData(localPlayer,'isAFK',true)
                    printattirmafalan("AFK")
                end
            end
        else
            -- Hareket ediyorsa tick'i sıfırla
            tick = 0
        end
    end,1000,0)
end

function durdurAFK()
    tick = 0
    if getElementData(localPlayer,'isAFK') == true then
        setElementData(localPlayer,'isAFK',false)
        printattirmafalan("AFKLIKTAN ÇIKTI")
        afkEventi(false)
        
        -- Ana timer'ı durdur ve yeniden başlat
        if isTimer(afk) then killTimer(afk) end
        if isTimer(timeramk) then killTimer(timeramk) end
        
        -- AFK'dan çıktıktan sonra 2 saniye bekle, sonra tekrar başlat
        timeramk = setTimer(function ()
            baslatAFK()
        end,2000,1)
    end
end

function printattirmafalan(msg)
    if bugFixleme == true then
        print(msg)
    end
end

function afkCameraAc()
    fadeCamera(false,1.5)
    setTimer(function ()
        fadeCamera(true,1.5)
        afkCAMERA()
        setElementData(localPlayer,'isAFK',true)
    end,1500,1)
end

-- Event handler'lar
addEventHandler('onClientKey',root,function ()
    if getElementData(localPlayer,'isAFK') == true then
        printattirmafalan('AFK DURDURULDU SEBEP KLAVYE '..tick)
        durdurAFK()
    end
    tick = 0 -- Her tuşa basışta tick'i sıfırla
end)

addEventHandler('onClientMouseMove',root,function ()
    if getElementData(localPlayer,'isAFK') == true then
        printattirmafalan('AFK DURDURULDU SEBEP MOUSE HARAKET '..tick)
        durdurAFK()
    end
    tick = 0 -- Her mouse hareketinde tick'i sıfırla
end)

addEventHandler('onClientClick',root,function ()
    if getElementData(localPlayer,'isAFK') == true then
        printattirmafalan('AFK DURDURULDU SEBEP MOUSE TIKLAMA '..tick)
        durdurAFK()
    end
    tick = 0 -- Her tıklamada tick'i sıfırla
end)

addEventHandler('onClientCursorMove',root,function ()
    if getElementData(localPlayer,'isAFK') == true then
        printattirmafalan('AFK DURDURULDU SEBEP MOUSE HARAKET '..tick)
        durdurAFK()
    end
    tick = 0 -- Her cursor hareketinde tick'i sıfırla
end)

-- Hareket event'leri
addEventHandler('onClientPlayerWasted', root, function()
    if getElementData(localPlayer,'isAFK') == true then
        durdurAFK()
    end
end)

addEventHandler('onClientPlayerDamage', root, function()
    if getElementData(localPlayer,'isAFK') == true then
        durdurAFK()
    end
end)

addCommandHandler('afkkamera',afkCameraAc)

-- Element data'yı başlat
setElementData(localPlayer,'isAFK',false)

-- AFK sistemini başlat
baslatAFK()