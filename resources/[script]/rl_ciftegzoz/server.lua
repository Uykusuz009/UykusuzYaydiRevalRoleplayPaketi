function setAutomaticCiftEgzoz(player, seat, jacked)
    local araba = getPedOccupiedVehicle(player)
    if araba then
        local modelID = getElementModel(araba)  -- Aracın model ID'sini alıyoruz
        
        -- Burada model ID'lerini kontrol ediyoruz, 445 (Banshee), 491 (Cheetah) ve 411 (Infernus) için çift egzoz ekliyoruz
        if modelID == 445 or modelID == 491 then
            setVehicleHandling(araba, "modelFlags", 0x00002000)  -- Çift egzoz flag'ini ekliyoruz
            --outputChatBox("[Reval]:#FFFFFF Bu araçta otomatik olarak çift egzoz aktif edildi!", player, 149, 22, 36, true)
        end
    end
end

addEventHandler("onVehicleEnter", root, setAutomaticCiftEgzoz)
