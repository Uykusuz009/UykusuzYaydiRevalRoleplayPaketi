--[[function tavukcuParaVer(thePlayer)
	if getElementData(thePlayer, "vip") < 1 then
	exports.rl_global:giveMoney(thePlayer, 3500)--1355
	outputChatBox("Reval Roleplay:#ffffff Bu turdan 3500$ kazandınız.", thePlayer, 0, 175, 255, true)
	elseif getElementData(thePlayer, "vip") == 1 then
	exports.rl_global:giveMoney(thePlayer, 3600)--1455
	outputChatBox("Reval Roleplay:#ffffff VIP 1 olduğunuz için bu turdan 3600$ kazandınız.", thePlayer, 0, 175, 255, true)
	elseif getElementData(thePlayer, "vip") == 2 then
	exports.rl_global:giveMoney(thePlayer, 3700)--1555
	outputChatBox("Reval Roleplay:#ffffff VIP 2 olduğunuz için bu turdan 3700$ kazandınız.", thePlayer, 0, 175, 255, true)
	elseif getElementData(thePlayer, "vip") == 3 then
	exports.rl_global:giveMoney(thePlayer, 3800)--1655
	outputChatBox("Reval Roleplay:#ffffff VIP 3 olduğunuz için bu turdan 3800$ kazandınız.", thePlayer, 0, 175, 255, true)
	elseif getElementData(thePlayer, "vip") == 4 then
	exports.rl_global:giveMoney(thePlayer, 3900)--1755
	outputChatBox("Reval Roleplay:#ffffff VIP 4 olduğunuz için bu turdan 3900$ kazandınız.", thePlayer, 0, 175, 255, true)
	end
end
addEvent("tavukcuParaVer", true)
addEventHandler("tavukcuParaVer", getRootElement(), tavukcuParaVer)]]


function tavukcuParaVer(thePlayer)
	if getElementData(thePlayer, "vip") < 1 then
	exports.rl_global:giveMoney(thePlayer, 750*2)--1355
	outputChatBox("Reval Roleplay:#ffffff Bu turdan 750$ kazandınız.", thePlayer, 0, 175, 255, true)
	elseif getElementData(thePlayer, "vip") == 1 then
	exports.rl_global:giveMoney(thePlayer, 850*2)--1455
	outputChatBox("Reval Roleplay:#ffffff VIP 1 olduğunuz için bu turdan 2100$ kazandınız.", thePlayer, 0, 175, 255, true)
	elseif getElementData(thePlayer, "vip") == 2 then
	exports.rl_global:giveMoney(thePlayer, 950*2)--1555
	outputChatBox("Reval Roleplay:#ffffff VIP 2 olduğunuz için bu turdan 2200$ kazandınız.", thePlayer, 0, 175, 255, true)
	elseif getElementData(thePlayer, "vip") == 3 then
	exports.rl_global:giveMoney(thePlayer, 1050*2)--1655
	outputChatBox("Reval Roleplay:#ffffff VIP 3 olduğunuz için bu turdan 2300$ kazandınız.", thePlayer, 0, 175, 255, true)
	elseif getElementData(thePlayer, "vip") == 4 then
	exports.rl_global:giveMoney(thePlayer, 1150*2)--1755
	outputChatBox("Reval Roleplay:#ffffff VIP 4 olduğunuz için bu turdan 2400$ kazandınız.", thePlayer, 0, 175, 255, true)
	end
end
addEvent("tavukcuParaVer", true)
addEventHandler("tavukcuParaVer", getRootElement(), tavukcuParaVer)
--]]

function tavukcuBitir(thePlayer)
	local pedVeh = getPedOccupiedVehicle(thePlayer)
	removePedFromVehicle(thePlayer)
	respawnVehicle(pedVeh)
	setElementPosition(thePlayer, -77.126953125, -1136.6533203125, 1.078125)
	setElementRotation(thePlayer, 0, 0, 68.932037353516)
end
addEvent("tavukcuBitir", true)
addEventHandler("tavukcuBitir", getRootElement(), tavukcuBitir)