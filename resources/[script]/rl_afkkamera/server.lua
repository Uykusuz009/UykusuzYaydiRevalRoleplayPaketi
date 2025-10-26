-- AFK durumunu sunucuda kaydetmek ve diğer oyunculara bildirmek için bir event oluşturuyoruz
addEvent("onPlayerAFKStatusChange", true)
addEventHandler("onPlayerAFKStatusChange", root, function(isAFK)
    local playerName = getPlayerName(client)
    if isAFK then
        outputChatBox(playerName .. " AFK moduna geçti.", root, 255, 255, 0)
    else
        outputChatBox(playerName .. " AFK modundan çıktı.", root, 0, 255, 0)
    end
    -- AFK durumunu sunucuda kaydediyoruz
    setElementData(client, "isAFK", isAFK)
end)

-- Sunucudan oyuncuya AFK durumunu kontrol etmek için bir komut
addCommandHandler("checkafk", function(player)
    local isAFK = getElementData(player, "isAFK") or false
    if isAFK then
        outputChatBox("Şu anda AFK modundasınız.", player, 255, 255, 0)
    else
        outputChatBox("Şu anda AFK modunda değilsiniz.", player, 0, 255, 0)
    end
end)

-- Oyuncu sunucudan ayrıldığında AFK durumunu sıfırlıyoruz
addEventHandler("onPlayerQuit", root, function()
    if getElementData(source, "isAFK") then
        setElementData(source, "isAFK", false)
    end
end)