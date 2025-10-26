local hasBackup = false 
local backupBlip = false
local playerElement = false

function backupCommand(cmd, ...)
    if localPlayer:getData("loggedin") then 
       -- if hasPlayerPermission(localPlayer, cmd) then 
            if not ... then 
                if not hasBackup then 
                   -- local syntax = exports["cr_core"]:getServerSyntax(false, "lightyellow")
                    return outputChatBox("/"..cmd.." [sebep]", 255, 154, 0, true)
                else 
                    --local syntax = exports["cr_core"]:getServerSyntax("Backup", "red")
                    local serverHex = exports["rl_coloration"]:getServerColor("blue", true)

                    hasBackup = false 

                    --exports["cr_dashboard"]:sendMessageToFaction(2, syntax..serverHex..exports["cr_admin"]:getAdminName(localPlayer).."#ffffff lemondta az erősítést.")

                    destroyBackup()

                    triggerLatentServerEvent("faction.destroyBackup", 5000, false, localPlayer, localPlayer)
                end
            else 
                local reason = table.concat({...}, " ")
               -- local syntax = exports["cr_core"]:getServerSyntax("Backup", "red")
                local serverHex = exports["rl_coloration"]:getServerColor("blue", true)

                if not hasBackup then 
                    hasBackup = true 

                  --  exports["cr_dashboard"]:sendMessageToFaction(2, syntax..serverHex..exports["cr_admin"]:getAdminName(localPlayer).."#ffffff erősítést kért. Indok: "..serverHex..reason)

                    triggerLatentServerEvent("faction.createBackup", 5000, false, localPlayer, localPlayer)
                else 
                    hasBackup = false 

                   -- exports["cr_dashboard"]:sendMessageToFaction(2, syntax..serverHex..exports["cr_admin"]:getAdminName(localPlayer).."#ffffff lemondta az erősítést.")

                    destroyBackup()

                    triggerLatentServerEvent("faction.destroyBackup", 5000, false, localPlayer, localPlayer)
               -- end
            end
        end
    end
end
addCommandHandler("backup", backupCommand, false, false)

function createBackup(thePlayer)
    if not isElement(backupBlip) and isElement(thePlayer) then 
--        if hasPlayerPermission(localPlayer, "backup") then 
            backupBlip = Blip(thePlayer.position, 0, 2, 255, 0, 0, 255, 0, 0)
            backupBlip:attach(thePlayer)
            playerElement = thePlayer

            exports["rl_interface"]:createStayBlip("Erősítés", backupBlip, 0, "target", 24, 24, 255, 87, 87)
        --end
    end
end
addEvent("faction.createBackup", true)
addEventHandler("faction.createBackup", root, createBackup)

function destroyBackup()
    if isElement(backupBlip) then 
        backupBlip:destroy()
        exports["rl_interface"]:destroyStayBlip("Erősítés")

        playerElement = nil

        collectgarbage("collect")
    end
end
addEvent("faction.destroyBackup", true)
addEventHandler("faction.destroyBackup", root, destroyBackup)

addEventHandler("onClientPlayerQuit", root,
    function()
        if playerElement and playerElement == source then 
            destroyBackup()
        end
    end
)