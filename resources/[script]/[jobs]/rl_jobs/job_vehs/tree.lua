local markerX2, markerY2, markerZ2 = -1295.880859375, -2161.296875, 21.553789901733
local marker2 = createMarker(markerX2, markerY2, markerZ2, "cylinder", 1, 0, 0, 0, 150)

local playerVehicles = {} -- Hangi oyuncuların araç aldığı bilgisini tutan bir tablo

-- Marker'a tıklama olayı
addEventHandler("onMarkerHit", marker2, function(player)
    -- Marker'a giren oyuncuya, /aracal komutunu kullanması gerektiğini hatırlatalım
    outputChatBox("►#ffffff Bu marker üzerinden araç almak için /aracalodun komutunu yazın.", player, 255, 255, 0, true)
end)

-- /aracal komutunu ekleyelim
addCommandHandler("aracalodun", function(player)
    -- Eğer oyuncu daha önce araç almışsa, tekrar araç verilmesin
    if playerVehicles[player] then
        outputChatBox("►#ffffff Bu marker üzerinden zaten bir araç aldınız.", player, 255, 0, 0, true)
        return
    end

    -- Oyuncunun mevcut parasını al
    local playerMoney = getElementData(player, "money")
    
    -- Eğer oyuncunun parası 200 TL'den azsa, araç verilmiyor
    if playerMoney < 200 then
        outputChatBox("►#ffffff Yeterli paranız yok. Araç almak için 200 TL gerekiyor.", player, 255, 0, 0, true)
        return
    end

    -- 200 TL'yi oyuncudan kes
    local newMoney = playerMoney - 200
    setElementData(player, "money", newMoney)

    -- 422 ID'li aracı spawn et
    local vehicleID = 422  -- 422 ID'li araç
    local r = getPedRotation(player)
    local x, y, z = getElementPosition(player)
    x = x + ( ( math.cos ( math.rad ( r ) ) ) * 5 )
    y = y + ( ( math.sin ( math.rad ( r ) ) ) * 5 )

    -- Araç oluşturuluyor
    local plate = tostring(getElementData(player, "account:id"))
    if #plate < 8 then
        plate = " " .. plate
        while #plate < 8 do
            plate = string.char(math.random(string.byte('A'), string.byte('Z'))) .. plate
        end
    end

    local veh = createVehicle(vehicleID, x, y, z, 0, 0, r, plate)

    -- Eğer araç oluşturulamazsa, hata mesajı
    if not veh then
        outputChatBox("►#ffffff Araç oluşturulamadı, yeniden deneyin.", player, 255, 0, 0, true)
        return
    end

    -- Araç özellikleri
    setElementInterior(veh, getElementInterior(player))
    setElementDimension(veh, getElementDimension(player))
    setVehicleOverrideLights(veh, 1)
    setVehicleEngineState(veh, false)  -- Araç motoru kapalı olarak başlasın
    setVehicleFuelTankExplodable(veh, false)
    setElementData(veh, "faction", -1)
    setElementData(veh, "owner", getElementData(player, "dbid"))

    -- Başarı mesajı
    outputChatBox("►#ffffff Başarıyla aracı aldınız. 200 TL kesildi.", player, 0, 255, 0, true)

    -- Aracın 10 dakika sonra silinmesini sağlayacak zamanlayıcı
    local timer = setTimer(function()
        -- Eğer oyuncu hala araçta değilse aracı sil
        if not isElement(veh) then
            return
        end
        -- Araç 10 dakika sonra siliniyor
        destroyElement(veh)
        outputChatBox("►#ffffff 10 dakika içerisinde araca binmediniz, araç silindi.", player, 255, 0, 0, true)
    end, 600000, 1)  -- 600000 ms = 10 dakika

    -- Aracın sahibine 9 dakika sonra, yani son 1 dakikada uyarı
    setTimer(function()
        -- Eğer oyuncu hala araçta değilse, uyarı ver
        if isElement(veh) then
            outputChatBox("►#ffffff Araca 1 dakika içinde binmezseniz araç silinecektir.", player, 255, 255, 0, true)
        end
    end, 540000, 1)  -- 540000 ms = 9 dakika (10 dakikadan 1 dakika önce)

    -- Oyuncuya bu araç aldığını hatırlatmak için kaydediyoruz
    playerVehicles[player] = veh  -- Bu oyuncu araç aldı
end)

-- /oduniptal komutunu ekleyelim
addCommandHandler("oduniptal", function(player)
    if playerVehicles[player] then
        local vehicle = playerVehicles[player]
        destroyElement(vehicle)  -- Araç silinir
        playerVehicles[player] = nil  -- Araç kaydını sil
        outputChatBox("►#ffffff Aracınız silindi. Artık tekrar araç alabilirsiniz.", player, 0, 255, 0, true)
    else
        outputChatBox("►#ffffff Herhangi bir aracınız yok.", player, 255, 0, 0, true)
    end
end)

-- Araçtan inildiğinde oyuncuya 10 dakika uyarısı
addEventHandler("onVehicleExit", root, function(player)
    -- Eğer araç oyuncuya aitse
    if playerVehicles[player] and source == playerVehicles[player] then
        outputChatBox("►#ffffff 10 dakika içinde binmezseniz aracınız silinecektir.", player, 255, 255, 0, true)

        -- Aracın 9. dakikasına bir uyarı daha ekleyelim
        local veh = playerVehicles[player]
        setTimer(function()
            if isElement(veh) then
                outputChatBox("►#ffffff Araca 1 dakika içinde binmezseniz araç silinecektir.", player, 255, 255, 0, true)
            end
        end, 540000, 1)  -- 540000 ms = 9 dakika (10 dakikadan 1 dakika önce)
    end
end)
