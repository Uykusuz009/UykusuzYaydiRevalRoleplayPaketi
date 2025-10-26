-- Create a table to store last post times for each player
local lastPostTimes = {}

addEvent("darkweb.sendPost", true)
addEventHandler("darkweb.sendPost", root, function(text)
    if client ~= source then
        exports.rl_ac:banForEventAbuse(client, eventName)
        return
    end
    
    -- Check cooldown
    local currentTime = getTickCount()
    local lastPostTime = lastPostTimes[client] or 0
    local timePassed = (currentTime - lastPostTime) / 1000  -- Convert to seconds
    
    if timePassed < 300 then  -- 300 seconds = 5 minutes
        local remainingTime = math.ceil(300 - timePassed)
        exports.rl_infobox:addBox(client, "error", "Her 5 dakikada bir gönderi atabilirsiniz. Kalan süre: "..remainingTime.." saniye")
        return
    end
    
    if exports.rl_global:hasMoney(client, 500) then
        if string.len(text) > 0 then
            if not getElementData(client, "adminjailed") then
                exports.rl_global:takeMoney(client, 500)
                triggerClientEvent(client, "playSuccessfulSound", client)
                
                -- Update last post time
                lastPostTimes[client] = currentTime
                
                for _, player in pairs(getElementsByType("player")) do
                    if getElementData(player, "logged") then
                        local playerName = getPlayerName(client):gsub("_", " ")
                        if exports.rl_global:getPlayerMaskState(client) then
                            playerName = "Gizli [>" .. getElementData(client, "dbid") .. "]"
                        end
                        
                        outputChatBox("[DarkWeb]#FFFFFF " .. text .. " @" .. playerName, player, 18, 18, 18, true)
                    end
                end
            else
                exports.rl_infobox:addBox(client, "error", "Jailde iken gönderi atamazsınız.")
            end
        else
            exports.rl_infobox:addBox(client, "error", "İçerik boş bırakılamaz.")
        end
    else
        exports.rl_infobox:addBox(client, "error", "Gönderi atmak için yeterli paranız yok.")
    end
end)

-- Clean up the table when player quits
addEventHandler("onPlayerQuit", root, function()
    lastPostTimes[source] = nil
end)