function medkit(thePlayer)
    local oyuncu_can = getElementHealth(thePlayer)
    local currentTime = getTickCount()

    if exports.rl_items:hasItem(thePlayer, 70) or getElementData(thePlayer, "limitedMedkit") == 1 then
        if oyuncu_can == 100 then
            setElementData(thePlayer, "medkitbasiyorum", false)
            exports.rl_infobox:addBox(localPlayer, "Sağlığında problem yok!", "info")

              
                    setElementData(thePlayer, "medkitbasiyorum", true)
                    triggerClientEvent(thePlayer, "medkitbasiyor", thePlayer)
                    setTimer(function()
                        setPedWeaponSlot(thePlayer, 0)
                    end, 0, 90)

                    setTimer(function()
                        if getElementData(thePlayer, "limitedMedkit") == 0 then
                            outputChatBox(">> #d0d0d0Üzerinde toplam "..exports.rl_items:countItems(thePlayer, 70).." adet medkit kaldı.", thePlayer, 0, 155, 255, true)
                        else
                            outputChatBox(">> #d0d0d0Sınırsız medKit'e sahip olduğunuz için iteminiz eksilmedi.", thePlayer, 0, 155, 255, true)
                        end
                    end, 3000, 1) -- Bu kısım eksik gibi duruyor, bu yüzden ben buraya ekledim.
                else
                    exports.rl_infobox:addBox(thePlayer, "Zaten medkit basıyorsun!", "error")
                end
            else
                outputChatBox("[!] #ffffff15 saniye içinde tekrar medkit basamazsın.", thePlayer, 255, 0, 0, true)
            end
        end
    else
        exports.rl_infobox:addBox(thePlayer, "Medkit basmak için medkit'e ihtiyacın var dostum!", "info")
    end
end
addEvent("medkit.bas", true)
addEventHandler("medkit.bas", root, medkit)
addCommandHandler("medkit", medkit)