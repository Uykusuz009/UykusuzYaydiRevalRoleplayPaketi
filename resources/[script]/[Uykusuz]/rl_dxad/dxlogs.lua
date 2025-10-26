addEvent("notifyAdminsAboutDxHack", true)
addEventHandler("notifyAdminsAboutDxHack", root, function()
    local hackerPlayer = source
    local hackerName = getPlayerName(hackerPlayer)
    local hackerSerial = getPlayerSerial(hackerPlayer)
    local hackerIP = getPlayerIP(hackerPlayer)
    for _, player in ipairs(getElementsByType("player")) do
        local adminLevel = getElementData(player, "admin_level") or 0
        if adminLevel > 0 then
            outputChatBox("#FF0000[!] HACK TESPİT EDİLDİ: #FFFFFF" .. hackerName .. " isimli oyuncu DX Log sisteminin render kısmına yetkisiz erişim sağladı!", player, 255, 0, 0, true)
            outputChatBox("#FF0000[!] Oyuncu Bilgileri: #FFFFFFSerial: " .. hackerSerial .. " | IP: " .. hackerIP, player, 255, 0, 0, true)
            outputChatBox("#FF0000[!] Bu oyuncu kesinlikle hile kullanıyor, lütfen gerekli işlemi yapın!", player, 255, 0, 0, true)
        end
    end
end)