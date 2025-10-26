--[[function koliParaVer(thePlayer)
	if getElementData(thePlayer, "vip") < 1 then
	exports.rl_global:giveMoney(thePlayer, 1250)--365
	outputChatBox("Reval Roleplay:#ffffff Bu turdan 1250$ kazandınız.", thePlayer, 0, 175, 255, true)
	elseif getElementData(thePlayer, "vip") == 1 then
	exports.rl_global:giveMoney(thePlayer, 1350)--465
	outputChatBox("Reval Roleplay:#ffffff VIP 1 olduğunuz için bu turdan 1350$ kazandınız.", thePlayer, 0, 175, 255, true)
	elseif getElementData(thePlayer, "vip") == 2 then
	exports.rl_global:giveMoney(thePlayer, 1450)--565
	outputChatBox("Reval Roleplay:#ffffff VIP 2 olduğunuz için bu turdan 1450$ kazandınız.", thePlayer, 0, 175, 255, true)
	elseif getElementData(thePlayer, "vip") == 3 then
	exports.rl_global:giveMoney(thePlayer, 1550)--665
	outputChatBox("Reval Roleplay:#ffffff VIP 3 olduğunuz için bu turdan 1550$ kazandınız.", thePlayer, 0, 175, 255, true)
	elseif getElementData(thePlayer, "vip") == 4 then
	exports.rl_global:giveMoney(thePlayer, 1650)--765
	outputChatBox("Reval Roleplay:#ffffff VIP 4 olduğunuz için bu turdan 1650$ kazandınız.", thePlayer, 0, 175, 255, true)
	end
end
addEvent("koliParaVer", true)
addEventHandler("koliParaVer", getRootElement(), koliParaVer)]]



function koliParaVer(thePlayer)
	if getElementData(thePlayer, "vip") < 1 then
	exports.rl_global:giveMoney(thePlayer, 800)--365
	outputChatBox("Reval Roleplay:#ffffff Bu turdan 800$ kazandınız.", thePlayer, 0, 175, 255, true)
	elseif getElementData(thePlayer, "vip") == 1 then
	exports.rl_global:giveMoney(thePlayer, 900)--465
	outputChatBox("Reval Roleplay:#ffffff VIP 1 olduğunuz için bu turdan 900$ kazandınız.", thePlayer, 0, 175, 255, true)
	elseif getElementData(thePlayer, "vip") == 2 then
	exports.rl_global:giveMoney(thePlayer, 1000)--565
	outputChatBox("Reval Roleplay:#ffffff VIP 2 olduğunuz için bu turdan 1000$ kazandınız.", thePlayer, 0, 175, 255, true)
	elseif getElementData(thePlayer, "vip") == 3 then
	exports.rl_global:giveMoney(thePlayer, 1100)--665
	outputChatBox("Reval Roleplay:#ffffff VIP 3 olduğunuz için bu turdan 1100$ kazandınız.", thePlayer, 0, 175, 255, true)
	elseif getElementData(thePlayer, "vip") == 4 then
	exports.rl_global:giveMoney(thePlayer, 1200)--765
	outputChatBox("Reval Roleplay:#ffffff VIP 4 olduğunuz için bu turdan 1200$ kazandınız.", thePlayer, 0, 175, 255, true)
	end
end
addEvent("koliParaVer", true)
addEventHandler("koliParaVer", getRootElement(), koliParaVer)

--]]

function koliBitir(thePlayer)
	local pedVeh = getPedOccupiedVehicle(thePlayer)
	removePedFromVehicle(thePlayer)
	respawnVehicle(pedVeh)
	setElementPosition(thePlayer, 2284.607421875, -2364.970703125, 13.546875)
	setElementRotation(thePlayer, 0, 0, 228.91737365723)
end
addEvent("koliBitir", true)
addEventHandler("koliBitir", getRootElement(), koliBitir)