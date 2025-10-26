addEvent("marketacdayi", true)
addEventHandler("marketacdayi", root, function()

    executeCommandHandler("market", player)

end)

addEvent("nametagacdayi", true)
addEventHandler("nametagacdayi", root, function()

    executeCommandHandler("nametag", player)

end)

addEvent("hudacdayi", true)
addEventHandler("hudacdayi", root, function()

    executeCommandHandler("hud", player)

end)

addEvent("reportacdayi", true)
addEventHandler("reportacdayi", root, function()

    executeCommandHandler("reportspanels", player)

end)

addEvent("oyundanayrilbroc", true)
addEventHandler("oyundanayrilbroc", root, function()

    triggerServerEvent("oyundanayrilbro", localPlayer)

end)