function raporVerYetkili(thePlayer, cmd)
    local username = getElementData(thePlayer, "account_username")
	if (exports.rl_integration:isPlayerDeveloper(thePlayer)) then
        for _, targetPlayer in ipairs(getElementsByType("player")) do
            if exports.rl_integration:isPlayerTrialAdmin(targetPlayer) then
                triggerClientEvent(targetPlayer, "admin:raporShow", thePlayer)
                setTimer(function()
                    triggerClientEvent(targetPlayer, "admin:noRapor", thePlayer)
                end, 5000, 1)

                outputChatBox(username.." isimli yetkili rapor bakılmasını söyledi. RAPOR BAK AMK", targetPlayer, 0, 255, 0)
            end
        end
        outputChatBox("Yetkililere rapor bakılmasını söyledin.", thePlayer, 0, 255, 0)
    else
        outputChatBox("Bu komutu kullanma yetkiniz yok.", thePlayer, 255, 0, 0)
    end
end
addCommandHandler("raporbak", raporVerYetkili)