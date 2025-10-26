bindKey("F12", "down", function()
    setTimer(function()
        hours = getRealTime().hour
        minutes = getRealTime().minute
        seconds = getRealTime().second
        day = getRealTime().monthday
        month = getRealTime().month+1
        year = getRealTime().year+1900
        outputChatBox("[!] #ffffffReval Roleplay | Ekran Görüntüsü | Tarih: ["..string.format("%02d.%02d.%02d", day, month, year).."] | Saat: ["..string.format("%02d:%02d:%02d", hours, minutes, seconds).."]", 0, 255, 0, true)
    end, 1000, 1)
end)