--[[
function yumurtaciParaVer(thePlayer)
	if getElementData(thePlayer, "vip") < 1 then
	exports.rl_global:giveMoney(thePlayer, 1250)--665
	outputChatBox("Reval Roleplay:#ffffff Bu turdan 1250$ kazandınız.", thePlayer, 0, 175, 255, true)
	elseif getElementData(thePlayer, "vip") == 1 then
	exports.rl_global:giveMoney(thePlayer, 1350)--765
	outputChatBox("Reval Roleplay:#ffffff VIP 1 olduğunuz için bu turdan 1350$ kazandınız.", thePlayer, 0, 175, 255, true)
	elseif getElementData(thePlayer, "vip") == 2 then
	exports.rl_global:giveMoney(thePlayer, 1450)--865
	outputChatBox("Reval Roleplay:#ffffff VIP 2 olduğunuz için bu turdan 1450$ kazandınız.", thePlayer, 0, 175, 255, true)
	elseif getElementData(thePlayer, "vip") == 3 then
	exports.rl_global:giveMoney(thePlayer, 1550)--965
	outputChatBox("Reval Roleplay:#ffffff VIP 3 olduğunuz için bu turdan 1550$ kazandınız.", thePlayer, 0, 175, 255, true)
	elseif getElementData(thePlayer, "vip") == 4 then
	exports.rl_global:giveMoney(thePlayer, 1650)--1065
	outputChatBox("Reval Roleplay:#ffffff VIP 4 olduğunuz için bu turdan 1650$ kazandınız.", thePlayer, 0, 175, 255, true)
	end
end
addEvent("yumurtaciParaVer", true)
addEventHandler("yumurtaciParaVer", getRootElement(), yumurtaciParaVer)
--]]


function yumurtaciParaVer(thePlayer)
	if getElementData(thePlayer, "vip") < 1 then
	exports.rl_global:giveMoney(thePlayer, 1100*2)--665
	outputChatBox("Reval Roleplay:#ffffff Bu turdan 1100TL kazandınız.", thePlayer, 0, 175, 255, true)
	elseif getElementData(thePlayer, "vip") == 1 then
	exports.rl_global:giveMoney(thePlayer, 1300*2)--765
	outputChatBox("Reval Roleplay:#ffffff VIP 1 olduğunuz için bu turdan 1300TL kazandınız.", thePlayer, 0, 175, 255, true)
	elseif getElementData(thePlayer, "vip") == 2 then
	exports.rl_global:giveMoney(thePlayer, 1400*2)--865
	outputChatBox("Reval Roleplay:#ffffff VIP 2 olduğunuz için bu turdan 1400TL kazandınız.", thePlayer, 0, 175, 255, true)
	elseif getElementData(thePlayer, "vip") == 3 then
	exports.rl_global:giveMoney(thePlayer, 1500*2)--965
	outputChatBox("Reval Roleplay:#ffffff VIP 3 olduğunuz için bu turdan 1500TL kazandınız.", thePlayer, 0, 175, 255, true)
	elseif getElementData(thePlayer, "vip") == 4 then
	exports.rl_global:giveMoney(thePlayer, 1600*2)--1065
	outputChatBox("Reval Roleplay:#ffffff VIP 4 olduğunuz için bu turdan 1600TL kazandınız.", thePlayer, 0, 175, 255, true)
	end
end
addEvent("yumurtaciParaVer", true)
addEventHandler("yumurtaciParaVer", getRootElement(), yumurtaciParaVer)

function yumurtaciBitir(thePlayer)
	local pedVeh = getPedOccupiedVehicle(thePlayer)
	removePedFromVehicle(thePlayer)
	respawnVehicle(pedVeh)
	setElementPosition(thePlayer, 2336.8251953125, -2083.0732421875, 13.546875)
	setElementRotation(thePlayer, 0, 0, 81.198455810547)
end
addEvent("yumurtaciBitir", true)
addEventHandler("yumurtaciBitir", getRootElement(), yumurtaciBitir)