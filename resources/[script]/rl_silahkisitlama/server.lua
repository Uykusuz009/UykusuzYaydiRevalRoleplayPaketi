-- Server Side Script
-- MTA:SA Kolluk Kuvvetleri Silah Kısıtlama

local restrictedWeapons = {30, 31, 25} -- AK-47 (30) ve M4 (31) ve pompalı 25

-- Silah eline alındığında tetiklenen fonksiyon
function onPlayerPickupWeapon(player, weaponID)
    -- Kısıtlı silah kontrolü
    for _, restrictedID in ipairs(restrictedWeapons) do
        if weaponID == restrictedID then
            -- Chat'e uyarı mesajı gönder
            outputChatBox("Bu silahı sadece kolluk kuvvetleri kullanabilir!", player, 255, 0, 0)
            return false
        end
    end
end

-- Event handler'ı kaydet
addEventHandler("onPlayerPickupWeapon", root, onPlayerPickupWeapon)

-- Script yüklendiğinde bilgi mesajı
--outputServerLog("Kolluk Kuvvetleri Silah Kısıtlama Scripti yüklendi - AK-47 ve M4 kısıtlı")