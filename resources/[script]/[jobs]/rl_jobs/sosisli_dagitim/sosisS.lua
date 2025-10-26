function sosisliciParaVer(thePlayer)
	if getElementData(thePlayer, "vip") < 1 then
	exports.rl_global:giveMoney(thePlayer, 1850)--665
	outputChatBox("Reval Roleplay:#ffffff Bu turdan 1850₺ kazandınız.", thePlayer, 0, 175, 255, true)
	elseif getElementData(thePlayer, "vip") == 1 then
	exports.rl_global:giveMoney(thePlayer, 1950)--765
	outputChatBox("Reval Roleplay:#ffffff VIP 1 olduğunuz için bu turdan 1950₺ kazandınız.", thePlayer, 0, 175, 255, true)
	elseif getElementData(thePlayer, "vip") == 2 then
	exports.rl_global:giveMoney(thePlayer, 2050)--865
	outputChatBox("Reval Roleplay:#ffffff VIP 2 olduğunuz için bu turdan 2050₺ kazandınız.", thePlayer, 0, 175, 255, true)
	elseif getElementData(thePlayer, "vip") == 3 then
	exports.rl_global:giveMoney(thePlayer, 2150)--965
	outputChatBox("Reval Roleplay:#ffffff VIP 3 olduğunuz için bu turdan 2150₺ kazandınız.", thePlayer, 0, 175, 255, true)
	elseif getElementData(thePlayer, "vip") == 4 then
	exports.rl_global:giveMoney(thePlayer, 2250)--1065
	outputChatBox("Reval Roleplay:#ffffff VIP 4 olduğunuz için bu turdan 2250₺ kazandınız.", thePlayer, 0, 175, 255, true)
	end
end
addEvent("sosisliciParaVer", true)
addEventHandler("sosisliciParaVer", getRootElement(), sosisliciParaVer)

function sosisliciBitir(thePlayer)
	local pedVeh = getPedOccupiedVehicle(thePlayer)
	removePedFromVehicle(thePlayer)
	respawnVehicle(pedVeh)
	setElementPosition(thePlayer, 1025.3671875, -1340.0888671875, 13.7265625)
	setElementRotation(thePlayer, 0, 0, 3.5129089355469)
end
addEvent("sosisliciBitir", true)
addEventHandler("sosisliciBitir", getRootElement(), sosisliciBitir)