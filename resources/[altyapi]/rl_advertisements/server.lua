local advertisementMessages = { "samp", "arıyorum", "aranır", "istiyom", "istiyorum", "SA-MP", "oyuncak", "boncuk", "silah", "peynir", "baharat", "deagle",  "colt", "mp", "ak", "roleplay", "ananı", "sikeyim", "sikerim", "orospu", "evladı", "Kye", "arena", "Arina", "rina", "vendetta", "vandetta", "shodown", "Vedic", "vedic","ventro","Ventro", "server", "sincityrp", "ls-rp", "sincity", "tri0n3", "mta", "mta-sa", "query", "Query", "inception", "p2win", "pay to win", "anani" }
local adverts = {}
local timers = {}

addEvent("adverts:receive", true)
addEventHandler("adverts:receive", root,
    function(player, message)
        -- Ramo AC protection - check if client is the source
        if client ~= source then 
            kickPlayer(client,"Event->Abuse")
            print("event->abuse")
            return 
        end

        if isTimer(timers[getElementData(player, "dbid")]) then
            outputChatBox("Yalnıza 5 dakikada bir reklam atabilirsiniz.", player, 255, 255, 255, true)
            return
        end

        local vipLevel = getElementData(player, "vipLevel") or 0 -- Oyuncunun VIP seviyesini al, eğer veri yoksa 0 olarak kabul et

        local advertCost = 1000 -- Varsayılan reklam maliyeti
        if vipLevel < 3 then
            advertCost = 1500 -- VIP seviyesi 3'ten küçükse maliyeti 1500 olarak ayarla
        end

        if exports.rl_global:hasMoney(player, advertCost) then
            timers[getElementData(player, "dbid")] = setTimer(function() end, 1000*60*5, 1)
            for k,v in ipairs(advertisementMessages) do
                local found = string.find(string.lower(message), "%s" .. tostring(v))
                local found2 = string.find(string.lower(message), tostring(v) .. "%s")
                if (found) or (found2) or (string.lower(message)==tostring(v)) then
                    exports.rl_global:sendMessageToAdmins("[ADVERT]: " .. tostring(getPlayerName(player)) .. " reklam verirken tehlikeli kelimelere rastlandı.")
                    exports.rl_global:sendMessageToAdmins("[ADVERT]: Reklam mesajı: " .. tostring(message))
                    outputChatBox(">>#f9f9f9 Reklam verirken hatalı kelimelere rastlandı, silip tekrar reklam atınız.", player, 255, 0, 0, true)
                    return
                end
            end

            local upperCount = 0
            for i=1, #message do
                local message = message:sub(i, i+1)
                if message == message:upper() then
                    upperCount = upperCount + 1
                end
            end

            if (upperCount >= #message) then
                message = message:lower()
                message = tostring(message):gsub("^%l", string.upper)
            end

            advertID = #adverts + 1;
            adverts[advertID] = player:getData("dbid");
            exports.rl_global:takeMoney(player, advertCost)
            outputChatBox(">>#f9f9f9 Reklamınız başarıyla verildi, 30 saniye içinde yayınlanacak.", player, 0, 255, 0, true)
            outputChatBox(">>#f9f9f9 Reklam iptali için: /reklamiptal "..advertID, player, 0, 255, 0, true)   
            exports.rl_global:sendMessageToAdmins("[ADVERT]: "..getPlayerName(player):gsub("_", " ").." reklam verdi:")
            exports.rl_global:sendMessageToAdmins("[ADVERT]: Reklam içeriği: "..message.." - Reklam iptali için /reklamiptal "..advertID)

            Timer(
                function(adID, plr)
                    if isElement(player) then
                        if adverts[advertID] then
                            for _, arrPlayer in ipairs(getElementsByType("player")) do
                                if not getElementData(arrPlayer, "togNews") and getElementData(arrPlayer, "logged") then
                                    local playeridbuba = getElementData(player, "id")
                                    outputChatBox("[REKLAM]#F9F9F9 "..message, arrPlayer, 50, 125, 168, true)
                                    outputChatBox("[REKLAM]#F9F9F9 İletişim:#ffffff "..playeridbuba.." // "..getPlayerName(player):gsub("_", " "), arrPlayer, 50, 125, 168, true)
                                end
                            end
                        else
                            exports.rl_global:giveMoney(player, advertCost)
                        end
                    end
                end,
            30 * 1000, 1, advertID, plr)
        
            
        else
            outputChatBox(">>#F9F9F9 Reklam oluşturabilmek için "..advertCost.."$ gerekiyor.", player, 255, 0, 0, true)
        end
    end
)

addCommandHandler("reklamiptal",
    function(player, cmd, id)
        id = tonumber(id)
        if id and exports.rl_integration:isPlayerTrialAdmin(player) or adverts[id] == player:getData("dbid") and adverts[id] and id and adverts[id] then
            adverts[(id)] = false
            outputChatBox(">>#F9F9F9 Reklam başarıyla iptal edildi.", player, 0, 255, 0, true)
            exports.rl_global:sendMessageToAdmins("[ADVERT]: "..player.name.." son reklamı iptal etti, yayınlanmayacak.")
        end
    end
)