function surprizkutudagit(thePlayer) 
    if getElementData(thePlayer, "admin_level") >= 6 then
        for _, oyuncu in ipairs(exports.rl_pool:getPoolElementsByType("player")) do
	     local itemid = 5555 
             gitemid = tonumber(itemid)
            exports.rl_global:giveItem(oyuncu, itemid , 1)
            outputChatBox("#FF0000[!]#ffffff Reval Roleplay tarafından sana 1 tane hediye kutusu verildi, /kutuac yazarak ne kazandığına bakabilirsin!", oyuncu, 0, 255, 0, true)  
            exports['rl_discord_log']:sendMessage("admin-cmd-log", ""..getPlayerName(thePlayer)..", herkese kutu dağıttı." )
        end
    else
        outputChatBox("[!]#ffffff Bu işlemi yapmak için yetkiniz yok.", thePlayer, 255, 0, 0, true)
    end
end
addCommandHandler("kutudagit", surprizkutudagit)