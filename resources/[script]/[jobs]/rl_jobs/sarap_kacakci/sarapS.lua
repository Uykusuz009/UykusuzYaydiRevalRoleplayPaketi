--[[function sarapParaVer(thePlayer)
	if getElementData(thePlayer, "vip") < 1 then
	exports.rl_global:giveMoney(thePlayer, 3500)--1355
	outputChatBox("Reval Roleplay:#ffffff Bu turdan 3500₺ kazandınız.", thePlayer, 0, 175, 255, true)
	elseif getElementData(thePlayer, "vip") == 1 then
	exports.rl_global:giveMoney(thePlayer, 3600)--1455
	outputChatBox("Reval Roleplay:#ffffff VIP 1 olduğunuz için bu turdan 3600₺ kazandınız.", thePlayer, 0, 175, 255, true)
	elseif getElementData(thePlayer, "vip") == 2 then
	exports.rl_global:giveMoney(thePlayer, 3700)--1555
	outputChatBox("Reval Roleplay:#ffffff VIP 2 olduğunuz için bu turdan 3700₺ kazandınız.", thePlayer, 0, 175, 255, true)
	elseif getElementData(thePlayer, "vip") == 3 then
	exports.rl_global:giveMoney(thePlayer, 3800)--1655
	outputChatBox("Reval Roleplay:#ffffff VIP 3 olduğunuz için bu turdan 3800₺ kazandınız.", thePlayer, 0, 175, 255, true)
	elseif getElementData(thePlayer, "vip") == 4 then
	exports.rl_global:giveMoney(thePlayer, 3900)--1755
	outputChatBox("Reval Roleplay:#ffffff VIP 4 olduğunuz için bu turdan 3900₺ kazandınız.", thePlayer, 0, 175, 255, true)
	end
end
addEvent("sarapParaVer", true)
addEventHandler("sarapParaVer", getRootElement(), sarapParaVer)]]


function sarapParaVer(thePlayer)
	if getElementData(thePlayer, "vip") < 1 then
	exports.rl_global:giveMoney(thePlayer, 3000)--1355
	outputChatBox("Reval Roleplay:#ffffff Bu turdan 4000₺ kazandınız.", thePlayer, 0, 175, 255, true)
	elseif getElementData(thePlayer, "vip") == 1 then
	exports.rl_global:giveMoney(thePlayer, 3100)--1455
	outputChatBox("Reval Roleplay:#ffffff VIP 1 olduğunuz için bu turdan 4100₺ kazandınız.", thePlayer, 0, 175, 255, true)
	elseif getElementData(thePlayer, "vip") == 2 then
	exports.rl_global:giveMoney(thePlayer, 3200)--1555
	outputChatBox("Reval Roleplay:#ffffff VIP 2 olduğunuz için bu turdan 4200₺ kazandınız.", thePlayer, 0, 175, 255, true)
	elseif getElementData(thePlayer, "vip") == 3 then
	exports.rl_global:giveMoney(thePlayer, 3300)--1655
	outputChatBox("Reval Roleplay:#ffffff VIP 3 olduğunuz için bu turdan 4300₺ kazandınız.", thePlayer, 0, 175, 255, true)
	elseif getElementData(thePlayer, "vip") == 4 then
	exports.rl_global:giveMoney(thePlayer, 3400)--1755
	outputChatBox("Reval Roleplay:#ffffff VIP 4 olduğunuz için bu turdan 4400₺ kazandınız.", thePlayer, 0, 175, 255, true)
	end
end
addEvent("sarapParaVer", true)
addEventHandler("sarapParaVer", getRootElement(), sarapParaVer)
--]]

function sarapBitir(thePlayer)
	local pedVeh = getPedOccupiedVehicle(thePlayer)
	removePedFromVehicle(thePlayer)
	respawnVehicle(pedVeh)
	setElementPosition(thePlayer, 2576.0498046875, -2420.3515625, 13.63582611084)
	setElementRotation(thePlayer, 0, 0, 270.95169067383)
end
addEvent("sarapBitir", true)
addEventHandler("sarapBitir", getRootElement(), sarapBitir)