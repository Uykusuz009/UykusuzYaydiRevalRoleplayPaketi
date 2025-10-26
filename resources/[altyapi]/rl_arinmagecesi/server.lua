local mp3 = "sesler/arinma.mp3"

local function mp3Oynat()
    for _, oyuncu in ipairs(getElementsByType("player")) do
        triggerClientEvent(oyuncu, "oynatSes", resourceRoot, mp3)
    end
end

addCommandHandler("arinmabaslat", function(player)
    if exports.rl_integration:isPlayerDeveloper(player) then
        mp3Oynat() 
        outputChatBox(">> #D0D0D0Arınma gecesi an itibari ile başladı.", root, 0,0,255, true)
        outputChatBox(">> #D0D0D0Bütün suçlar an itibari ile yasaldır.", root, 0,0,255, true)
    else
        outputChatBox(">> Bu komudu kullanmaya iznin yok.", root, 255, 0, 0, true)
    end
end)