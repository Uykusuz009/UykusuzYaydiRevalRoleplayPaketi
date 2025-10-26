local markerX, markerY, markerZ = 2568.5693359375, -2425.8095703125, 12.63266658783
local marker = createMarker(markerX, markerY, markerZ, "cylinder", 1, 0, 0, 0, 150)

-- Marker'a tıklama olayı yerine sadece /aracal komutunu kullanacağız
addCommandHandler("aracalsarap", function(player)
    -- Marker içindeyken komut kullanılabilir
    local playerX, playerY, playerZ = getElementPosition(player)
    local distance = getDistanceBetweenPoints3D(playerX, playerY, playerZ, markerX, markerY, markerZ)

    -- Eğer oyuncu marker içerisinde değilse, komut geçerli olmasın
    if distance > 2 then  -- 2 birim mesafe sınırı belirledik
        outputChatBox("►#ffffff Bu komutu sadece marker içerisinde kullanabilirsiniz.", player, 255, 0, 0, true)
        return
    end

    -- Marker içerisinde isen, araç oluşturulacak
    local x, y, z = 2566.6494140625, -2418.3876953125, 13.634009361267
    local vehicleID = 456  -- 478 ID'li araç (Bunu istediğiniz başka bir araçla değiştirebilirsiniz)

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
    outputChatBox("►#ffffff Başarıyla araç oluşturuldu. /sarapbasla komutunu kullanmayı unutmayın.", player, 0, 255, 0, true)

    -- Oyuncuyu araca bindir
    warpPedIntoVehicle(player, veh)

    -- Araçtan inildiğinde otomatik silinmesini sağlamak
    addEventHandler("onVehicleExit", veh, function(player)
        -- Eğer oyuncu araçtan indikten sonra, araç otomatik olarak silinsin
        if isElement(veh) then
            destroyElement(veh)
            -- Oyuncu belirli konuma gitsin
            setElementPosition(player, 2576.0498046875, -2420.3515625, 13.63582611084)
            outputChatBox("►#ffffff Araç silindi ve belirli konuma geri gönderildiniz.", player, 255, 0, 0, true)
        end
    end)
end)
