--[[function tabutParaVer(thePlayer)
	if getElementData(thePlayer, "vip") < 1 then
	exports.rl_global:giveMoney(thePlayer, 2000)--500
	outputChatBox("Reval Roleplay:#ffffff Bu turdan 2000$ kazandınız.", thePlayer, 0, 175, 255, true)
	elseif getElementData(thePlayer, "vip") == 1 then
	exports.rl_global:giveMoney(thePlayer, 2100)--600
	outputChatBox("Reval Roleplay:#ffffff VIP 1 olduğunuz için bu turdan 2100$ kazandınız.", thePlayer, 0, 175, 255, true)
	elseif getElementData(thePlayer, "vip") == 2 then
	exports.rl_global:giveMoney(thePlayer, 2200)--700
	outputChatBox("Reval Roleplay:#ffffff VIP 2 olduğunuz için bu turdan 2200$ kazandınız.", thePlayer, 0, 175, 255, true)
	elseif getElementData(thePlayer, "vip") == 3 then
	exports.rl_global:giveMoney(thePlayer, 2300)--800
	outputChatBox("Reval Roleplay:#ffffff VIP 3 olduğunuz için bu turdan 2300$ kazandınız.", thePlayer, 0, 175, 255, true)
	elseif getElementData(thePlayer, "vip") == 4 then
	exports.rl_global:giveMoney(thePlayer, 2400)--900
	outputChatBox("Reval Roleplay:#ffffff VIP 4 olduğunuz için bu turdan 2400$ kazandınız.", thePlayer, 0, 175, 255, true)
	end
end
addEvent("tabutParaVer", true)
addEventHandler("tabutParaVer", getRootElement(), tabutParaVer)]]



function tabutParaVer(thePlayer)
	if getElementData(thePlayer, "vip") < 1 then
	exports.rl_global:giveMoney(thePlayer, 3000)--500
	outputChatBox("Reval Roleplay:#ffffff Bu turdan 1750$ kazandınız.", thePlayer, 0, 175, 255, true)
	elseif getElementData(thePlayer, "vip") == 1 then
	exports.rl_global:giveMoney(thePlayer, 3100)--600
	outputChatBox("Reval Roleplay:#ffffff VIP 1 olduğunuz için bu turdan 1850$ kazandınız.", thePlayer, 0, 175, 255, true)
	elseif getElementData(thePlayer, "vip") == 2 then
	exports.rl_global:giveMoney(thePlayer, 3300)--700
	outputChatBox("Reval Roleplay:#ffffff VIP 2 olduğunuz için bu turdan 1950$ kazandınız.", thePlayer, 0, 175, 255, true)
	elseif getElementData(thePlayer, "vip") == 3 then
	exports.rl_global:giveMoney(thePlayer, 3500)--800
	outputChatBox("Reval Roleplay:#ffffff VIP 3 olduğunuz için bu turdan 2050$ kazandınız.", thePlayer, 0, 175, 255, true)
	elseif getElementData(thePlayer, "vip") == 4 then
	exports.rl_global:giveMoney(thePlayer, 3800)--900
	outputChatBox("Reval Roleplay:#ffffff VIP 4 olduğunuz için bu turdan 2150$ kazandınız.", thePlayer, 0, 175, 255, true)
	end
end
addEvent("tabutParaVer", true)
addEventHandler("tabutParaVer", getRootElement(), tabutParaVer)

--]]

function tabutBitir(thePlayer)
	local pedVeh = getPedOccupiedVehicle(thePlayer)
	removePedFromVehicle(thePlayer)
	respawnVehicle(pedVeh)
	setElementPosition(thePlayer, 2193.69921875, -1973.4306640625, 13.559419631958)
	setElementRotation(thePlayer, 0, 0, 5.0016174316406)
end
addEvent("tabutBitir", true)
addEventHandler("tabutBitir", getRootElement(), tabutBitir)