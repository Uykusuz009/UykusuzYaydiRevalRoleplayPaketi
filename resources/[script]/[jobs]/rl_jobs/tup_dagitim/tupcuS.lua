--[[function tupcuParaVer(thePlayer)
	if getElementData(thePlayer, "vip") < 1 then
	exports.rl_global:giveMoney(thePlayer, 1650)--665
	outputChatBox("Reval Roleplay:#ffffff Bu turdan 1650$ kazandınız.", thePlayer, 0, 175, 255, true)
	elseif getElementData(thePlayer, "vip") == 1 then
	exports.rl_global:giveMoney(thePlayer, 2000)--765
	outputChatBox("Reval Roleplay:#ffffff VIP 1 olduğunuz için bu turdan 2000$ kazandınız.", thePlayer, 0, 175, 255, true)
	elseif getElementData(thePlayer, "vip") == 2 then
	exports.rl_global:giveMoney(thePlayer, 2100)--865
	outputChatBox("Reval Roleplay:#ffffff VIP 2 olduğunuz için bu turdan 2100$ kazandınız.", thePlayer, 0, 175, 255, true)
	elseif getElementData(thePlayer, "vip") == 3 then
	exports.rl_global:giveMoney(thePlayer, 2200)--965
	outputChatBox("Reval Roleplay:#ffffff VIP 3 olduğunuz için bu turdan 2200$ kazandınız.", thePlayer, 0, 175, 255, true)
	elseif getElementData(thePlayer, "vip") == 4 then
	exports.rl_global:giveMoney(thePlayer, 2300)--1065
	outputChatBox("Reval Roleplay:#ffffff VIP 4 olduğunuz için bu turdan 2300$ kazandınız.", thePlayer, 0, 175, 255, true)
	end
end
addEvent("tupcuParaVer", true)
addEventHandler("tupcuParaVer", getRootElement(), tupcuParaVer)]]


function tupcuParaVer(thePlayer)
	if getElementData(thePlayer, "vip") < 1 then
	exports.rl_global:giveMoney(thePlayer, 1750*2)--665
	outputChatBox("Reval Roleplay:#ffffff Bu turdan 1750TL kazandınız.", thePlayer, 0, 175, 255, true)
	elseif getElementData(thePlayer, "vip") == 1 then
	exports.rl_global:giveMoney(thePlayer, 1850*2)--765
	outputChatBox("Reval Roleplay:#ffffff VIP 1 olduğunuz için bu turdan 1850TL kazandınız.", thePlayer, 0, 175, 255, true)
	elseif getElementData(thePlayer, "vip") == 2 then
	exports.rl_global:giveMoney(thePlayer, 1950*2)--865
	outputChatBox("Reval Roleplay:#ffffff VIP 2 olduğunuz için bu turdan 1950TL kazandınız.", thePlayer, 0, 175, 255, true)
	elseif getElementData(thePlayer, "vip") == 3 then
	exports.rl_global:giveMoney(thePlayer, 2050*2)--965
	outputChatBox("Reval Roleplay:#ffffff VIP 3 olduğunuz için bu turdan 2050TL kazandınız.", thePlayer, 0, 175, 255, true)
	elseif getElementData(thePlayer, "vip") == 4 then
	exports.rl_global:giveMoney(thePlayer, 2150*2)--1065
	outputChatBox("Reval Roleplay:#ffffff VIP 4 olduğunuz için bu turdan 2150TL kazandınız.", thePlayer, 0, 175, 255, true)
	end
end
addEvent("tupcuParaVer", true)
addEventHandler("tupcuParaVer", getRootElement(), tupcuParaVer)
--]]

function tupBitir(thePlayer)
	local pedVeh = getPedOccupiedVehicle(thePlayer)
	removePedFromVehicle(thePlayer)
	respawnVehicle(pedVeh)
	setElementPosition(thePlayer, 2072.7958984375, -1899.2138671875, 13.539096832275)
	setElementRotation(thePlayer, 0, 0, 268.58959960938)
end
addEvent("tupBitir", true)
addEventHandler("tupBitir", getRootElement(), tupBitir)