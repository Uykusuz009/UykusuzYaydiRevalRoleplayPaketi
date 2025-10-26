silahSesi = {}

function giveMessage(weapon)
    if silahSesi[source] == true then return end
	silahSesi[source] = true
    x, y, z = getElementPosition(source)
    players = getElementsWithinRange(x, y, z, 25)
	silah = getWeaponNameFromID(weapon)
	setTimer(sifirla, 25000, 1, source)
    for i, v in ipairs(players) do
        outputChatBox("Bölge IC: Çevreden silah sesleri duyabilirsiniz. (("..getPlayerName(source):gsub("_", " ")..")) ", v,  255, 255, 255, true)
    end
end
addEventHandler("onPlayerWeaponFire", root, giveMessage)

function sifirla(element)
    silahSesi[element] = false
end