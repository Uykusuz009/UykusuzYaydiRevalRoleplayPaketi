local markerX, markerY, markerZ = 2335.2626953125, -2079.775390625, 12.553783416748
local marker = createMarker(markerX, markerY, markerZ, "cylinder", 1, 0, 0, 0, 150)

-- Marker'a tıklama olayı yerine sadece /aracal komutunu kullanacağız
addCommandHandler("aracalyumurta", function(player)
    -- Marker içindeyken komut kullanılabilir
    local playerX, playerY, playerZ = getElementPosition(player)
    local distance = getDistanceBetweenPoints3D(playerX, playerY, playerZ, markerX, markerY, markerZ)

    -- Eğer oyuncu marker içerisinde değilse, komut geçerli olmasın
    if distance > 2 then  -- 2 birim mesafe sınırı belirledik
        outputChatBox("►#ffffff Bu komutu sadece marker içerisinde kullanabilirsiniz.", player, 255, 0, 0, true)
        return
    end

    -- Marker içerisinde isen, araç oluşturulacak
    local x, y, z = 2325.630859375, -2086.583984375, 13.546875
    local vehicleID = 478  -- 478 ID'li araç (Bunu istediğiniz başka bir araçla değiştirebilirsiniz)

    -- Aracın oluşturulması
    local r = getPedRotation(player)
    local veh = createVehicle(vehicleID, x, y, z, 0, 0, r)

    -- Eğer araç oluşturulamazsa, hata mesajı
    if not veh then
        outputChatBox("►#ffffff Araç oluşturulamadı, yeniden deneyin.", player, 255, 0, 0, true)
        return
    end

    -- Araç özellikleri
    setElementInterior(veh, getElementInterior(player))
    setElementDimension(veh, getElementDimension(player))
    setVehicleOverrideLights(veh, 1)
    setVehicleEngineState(veh, true)  -- Araç motoru çalışacak şekilde başlasın
    setVehicleFuelTankExplodable(veh, false)
    setElementData(veh, "faction", -1)
    setElementData(veh, "owner", getElementData(player, "dbid"))

    -- Başarı mesajı
    outputChatBox("►#ffffff Başarıyla araç oluşturuldu. /yumurtabasla komutunu kullanmayı unutmayın.", player, 0, 255, 0, true)

    -- Oyuncuyu araca bindir
    warpPedIntoVehicle(player, veh)

    -- Araçtan inildiğinde otomatik silinmesini sağlamak
    addEventHandler("onVehicleExit", veh, function(player)
        -- Eğer oyuncu araçtan indikten sonra, araç otomatik olarak silinsin
        if isElement(veh) then
            destroyElement(veh)
            -- Oyuncu belirli konuma gitsin
            setElementPosition(player, 2325.630859375, -2086.583984375, 13.546875)
            outputChatBox("►#ffffff Araç silindi ve belirli konuma geri gönderildiniz.", player, 255, 0, 0, true)
        end
    end)
end)
