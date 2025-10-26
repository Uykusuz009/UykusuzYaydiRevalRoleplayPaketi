function sendTopRightNotification(thePlayer, contentArray, widthNew, posXOffset, posYOffset, cooldown) --Server-side
	triggerClientEvent(thePlayer, "hud.drawOverlayTopRight", thePlayer, contentArray, widthNew, posXOffset, posYOffset, cooldown)
end

addEvent("hud.saveSettings", true)
addEventHandler("hud.saveSettings", root, function(settings)
    if not client or not settings then return end

    setElementData(client, "hud_settings", settings)

end)

addEvent("nametag.saveSettings", true)
addEventHandler("nametag.saveSettings", root, function(dataTable)
    if not client or not dataTable then return end

    setElementData(client, "nametag_settings", dataTable)

end)

--[[addEventHandler("onPlayerJoin", root, function()
    setElementData(source, "hud_settings", {
        hud = 1,
        speedo = 1,
        radar = 1,
        killMessage = 1
    })
end)]]
