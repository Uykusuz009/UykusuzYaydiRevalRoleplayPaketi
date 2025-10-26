addEvent("faction.createBackup", true)
addEventHandler("faction.createBackup", root,
    function(thePlayer)
        triggerLatentClientEvent(root, "faction.createBackup", 50000, false, thePlayer, thePlayer)
    end
)

addEvent("faction.destroyBackup", true)
addEventHandler("faction.destroyBackup", root,
    function(thePlayer)
        triggerLatentClientEvent(root, "faction.destroyBackup", 50000, false, thePlayer)
    end
)