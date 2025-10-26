-- Günlük istatistikler için değişkenler
local dailyStats = {
    maxPlayers = 0,
    uniqueAccounts = {},
    lastReset = nil
}

-- Günlük sıfırlama fonksiyonu
local function resetDailyStats()
    local currentDay = os.date("%Y-%m-%d")
    
    if dailyStats.lastReset ~= currentDay then
        dailyStats.maxPlayers = 0
        dailyStats.uniqueAccounts = {}
        dailyStats.lastReset = currentDay
        
        -- Günlük istatistikleri dosyaya kaydet
        saveDailyStats()
    end
end

-- İstatistikleri dosyaya kaydet
function saveDailyStats()
    local file = fileCreate("daily_stats.txt")
    if file then
        fileWrite(file, tostring(dailyStats.maxPlayers) .. "\n")
        fileWrite(file, tostring(#dailyStats.uniqueAccounts) .. "\n")
        fileWrite(file, tostring(dailyStats.lastReset) .. "\n")
        fileClose(file)
    end
end

-- İstatistikleri dosyadan yükle
function loadDailyStats()
    local file = fileOpen("daily_stats.txt")
    if file then
        local maxPlayers = tonumber(fileRead(file, 10))
        local uniqueCount = tonumber(fileRead(file, 10))
        local lastReset = fileRead(file, 20)
        fileClose(file)
        
        if maxPlayers and uniqueCount and lastReset then
            dailyStats.maxPlayers = maxPlayers
            dailyStats.lastReset = lastReset:gsub("\n", "")
            -- Unique accounts sayısını koruyoruz ama listesini yeniden oluşturacağız
        end
    end
end

-- Oyuncu giriş yaptığında
addEventHandler("onPlayerJoin", root, function()
    resetDailyStats()
    
    -- Maksimum oyuncu sayısını güncelle
    local currentPlayers = getPlayerCount()
    if currentPlayers > dailyStats.maxPlayers then
        dailyStats.maxPlayers = currentPlayers
        saveDailyStats()
    end
    
    -- Hesap bilgisini al ve unique listeye ekle
    local account = getPlayerAccount(source)
    if account and not isGuestAccount(account) then
        local accountName = getAccountName(account)
        if accountName and not dailyStats.uniqueAccounts[accountName] then
            dailyStats.uniqueAccounts[accountName] = true
            saveDailyStats()
        end
    end
end)

-- Oyuncu çıktığında maksimum oyuncu sayısını güncelle
addEventHandler("onPlayerQuit", root, function()
    resetDailyStats()
    
    local currentPlayers = getPlayerCount()
    if currentPlayers > dailyStats.maxPlayers then
        dailyStats.maxPlayers = currentPlayers
        saveDailyStats()
    end
end)

-- Günlük değerlendirme komutu (Manager korumalı)
addCommandHandler("gunlukdegerlendirme", function(player, command)
    -- Manager kontrolü (yalnızca bu eklendi)
    if not exports.rl_integration or not exports.rl_integration:isPlayerManager(player) then
        if exports.rl_infobox then
            exports.rl_infobox:addBox(player, "error", "Bu komutu kullanmak için Manager yetkisi gerekir.")
        else
            outputChatBox("Bu komutu kullanmak için Manager yetkisi gerekir.", player, 255, 0, 0)
        end
        return
    end

    resetDailyStats()
    
    local uniqueAccountCount = 0
    for _ in pairs(dailyStats.uniqueAccounts) do
        uniqueAccountCount = uniqueAccountCount + 1
    end
    
    -- Reval prefix'i ile mesajları gönder
    outputChatBox("Reval: Günlük Değerlendirme :", player, 255, 0, 255) -- Magenta renk
    outputChatBox("Reval: Oyuncu : " .. dailyStats.maxPlayers .. " oyuncu aynı anda oyundaydı.", player, 255, 255, 255) -- Beyaz renk
    outputChatBox("Reval: Hesap : " .. uniqueAccountCount .. " ayrı kullanıcı hesabına giriş yaptı.", player, 255, 255, 255) -- Beyaz renk
end)

-- Sunucu başladığında istatistikleri yükle
addEventHandler("onResourceStart", resourceRoot, function()
    loadDailyStats()
    resetDailyStats()
end)

-- Her 5 dakikada bir istatistikleri kaydet
setTimer(function()
    saveDailyStats()
end, 300000, 0) -- 5 dakika = 300000 ms