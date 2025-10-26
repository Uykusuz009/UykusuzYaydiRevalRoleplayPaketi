
addEventHandler("onClientPlayerWeaponSwitch", localPlayer, 
    function(previousWeaponID, currentWeaponID)
        local dim = getElementDimension(localPlayer)
        local faction = getElementData(localPlayer, "faction") or 0
        if (dim == 104 or dim == 135) and currentWeaponID ~= 0 and faction ~= 1 then
            cancelEvent()
        end
    end
)

function showAndCopyDiscord()
    local discordLink = "discord.gg/Revalroleplay"
    outputChatBox("#00FF00[!] #FFFFFFDiscord Adresimiz: " .. discordLink .. " (Otomatik kopyalandı!)", 255, 255, 255, true)
    setClipboard(discordLink)
    outputChatBox("#00FF00[!] #FFFFFFDiscord adresi panoya kopyalandı!", 255, 255, 255, true)
end
addCommandHandler("discord", showAndCopyDiscord)
