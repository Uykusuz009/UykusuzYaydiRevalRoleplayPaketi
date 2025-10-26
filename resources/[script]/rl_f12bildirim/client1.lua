antiSpam = {}

bindKey("F12", "down", function()
    if isTimer(antiSpam[localPlayer]) then return end
    antiSpam[localPlayer] = setTimer(function(thePlayer) antiSpam[localPlayer] = nil end, 1000, 1, localPlayer)

    hours = getRealTime().hour
    minutes = getRealTime().minute
    seconds = getRealTime().second
    day = getRealTime().monthday
    month = getRealTime().month+1
    year = getRealTime().year+1900
    outputChatBox("[!] #ffffffReval Roleplay | Ekran Görüntüsü | Tarih: ["..string.format("%02d.%02d.%02d", day, month, year).."] | Saat: ["..string.format("%02d:%02d:%02d", hours, minutes, seconds).."]", 0, 255, 0, true)
end)