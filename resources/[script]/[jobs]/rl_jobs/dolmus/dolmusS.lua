--[[
function gazeteParaVer(thePlayer)
	if getElementData(thePlayer, "vip") < 1 then
	exports.rl_global:giveMoney(thePlayer, 1000)--500
	outputChatBox("Reval Roleplay:#ffffff Bu turdan 1000$ kazandınız.", thePlayer, 0, 175, 255, true)
	elseif getElementData(thePlayer, "vip") == 1 then
	exports.rl_global:giveMoney(thePlayer, 1100)--600
	outputChatBox("Reval Roleplay:#ffffff VIP 1 olduğunuz için bu turdan 1100$ kazandınız.", thePlayer, 0, 175, 255, true)
	elseif getElementData(thePlayer, "vip") == 2 then
	exports.rl_global:giveMoney(thePlayer, 1200)--700
	outputChatBox("Reval Roleplay:#ffffff VIP 2 olduğunuz için bu turdan 1200$ kazandınız.", thePlayer, 0, 175, 255, true)
	elseif getElementData(thePlayer, "vip") == 3 then
	exports.rl_global:giveMoney(thePlayer, 1300)--800
	outputChatBox("Reval Roleplay:#ffffff VIP 3 olduğunuz için bu turdan 1300$ kazandınız.", thePlayer, 0, 175, 255, true)
	elseif getElementData(thePlayer, "vip") == 4 then
	exports.rl_global:giveMoney(thePlayer, 1400)--900
	outputChatBox("Reval Roleplay:#ffffff VIP 4 olduğunuz için bu turdan 1400$ kazandınız.", thePlayer, 0, 175, 255, true)
	end
end
addEvent("gazeteParaVer", true)
addEventHandler("gazeteParaVer", getRootElement(), gazeteParaVer)

--]]



function gazeteParaVer(thePlayer)
	if getElementData(thePlayer, "vip") < 1 then
	exports.rl_global:giveMoney(thePlayer, 3500)--500
	--outputChatBox("Reval Roleplay:#ffffff Bu turdan 2000$ kazandınız.", thePlayer, 0, 175, 255, true)
	elseif getElementData(thePlayer, "vip") == 1 then
	exports.rl_global:giveMoney(thePlayer, 3600)--600
	--outputChatBox("Reval Roleplay:#ffffff VIP 1 olduğunuz için bu turdan 2100$ kazandınız.", thePlayer, 0, 175, 255, true)
	elseif getElementData(thePlayer, "vip") == 2 then
	exports.rl_global:giveMoney(thePlayer, 3900)--700
	--outputChatBox("Reval Roleplay:#ffffff VIP 2 olduğunuz için bu turdan 2200$ kazandınız.", thePlayer, 0, 175, 255, true)
	elseif getElementData(thePlayer, "vip") == 3 then
	exports.rl_global:giveMoney(thePlayer, 4300)--800
	--outputChatBox("Reval Roleplay:#ffffff VIP 3 olduğunuz için bu turdan 2300$ kazandınız.", thePlayer, 0, 175, 255, true)
	elseif getElementData(thePlayer, "vip") == 4 then
	exports.rl_global:giveMoney(thePlayer, 4400)--900
	--outputChatBox("Reval Roleplay:#ffffff VIP 4 olduğunuz için bu turdan 2400$ kazandınız.", thePlayer, 0, 175, 255, true)
	end
end
addEvent("gazeteParaVer", true)
addEventHandler("gazeteParaVer", getRootElement(), gazeteParaVer)

function gazeteBitir(thePlayer)
	local pedVeh = getPedOccupiedVehicle(thePlayer)
	removePedFromVehicle(thePlayer)
	respawnVehicle(pedVeh)
	setElementPosition(thePlayer, 1767.1943359375, -1903.4404296875, 13.566796302795)
	setElementRotation(thePlayer, 0, 0, 62.669738769531)
end
addEvent("gazeteBitir", true)
addEventHandler("gazeteBitir", getRootElement(), gazeteBitir)