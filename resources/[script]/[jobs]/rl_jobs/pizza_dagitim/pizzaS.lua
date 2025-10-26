--[[function pizzaParaVer(thePlayer)
	if getElementData(thePlayer, "vip") < 1 then
	exports.rl_global:giveMoney(thePlayer, 1500)--500
	outputChatBox("Reval Roleplay:#ffffff Bu turdan 1500₺ kazandınız.", thePlayer, 0, 175, 255, true)
	elseif getElementData(thePlayer, "vip") == 1 then
	exports.rl_global:giveMoney(thePlayer, 1600)--600
	outputChatBox("Reval Roleplay:#ffffff VIP 1 olduğunuz için bu turdan 1600₺ kazandınız.", thePlayer, 0, 175, 255, true)
	elseif getElementData(thePlayer, "vip") == 2 then
	exports.rl_global:giveMoney(thePlayer, 1700)--700
	outputChatBox("Reval Roleplay:#ffffff VIP 2 olduğunuz için bu turdan 1700₺ kazandınız.", thePlayer, 0, 175, 255, true)
	elseif getElementData(thePlayer, "vip") == 3 then
	exports.rl_global:giveMoney(thePlayer, 1800)--800
	outputChatBox("Reval Roleplay:#ffffff VIP 3 olduğunuz için bu turdan 1800₺ kazandınız.", thePlayer, 0, 175, 255, true)
	elseif getElementData(thePlayer, "vip") == 4 then
	exports.rl_global:giveMoney(thePlayer, 1900)--900
	outputChatBox("Reval Roleplay:#ffffff VIP 4 olduğunuz için bu turdan 1900₺ kazandınız.", thePlayer, 0, 175, 255, true)
	end
end
addEvent("pizzaParaVer", true)
addEventHandler("pizzaParaVer", getRootElement(), pizzaParaVer)]]
sunucu = "Reval"
function msg(msg,oyuncu,r,g,b)
	outputChatBox(sunucu..": #FFFFFF"..msg,oyuncu, r,g,b,true)
end

paraControle = {}
function pizzaParaVer(thePlayer)
	if isTimer(paraControle[thePlayer]) then 
		msg("Meslek bug'u yapmaya çalıştığın loglara düştü. 10 saniye içinde sunucudan banlanacaksın!", thePlayer, 255, 0, 0)
	return end
	paraControle[thePlayer] = setTimer(function()  end, 1000, 1) 
	if getElementData(thePlayer, "vip") < 1 then
	exports.rl_global:giveMoney(thePlayer, 900*2)--500
	-- outputChatBox("Reval Roleplay:#ffffff Bu turdan 900₺ kazandınız.", thePlayer, 0, 175, 255, true)
	elseif getElementData(thePlayer, "vip") == 1 then
	exports.rl_global:giveMoney(thePlayer, 1100*2)--600
	-- outputChatBox("Reval Roleplay:#ffffff VIP 1 olduğunuz için bu turdan 1000₺ kazandınız.", thePlayer, 0, 175, 255, true)
	elseif getElementData(thePlayer, "vip") == 2 then
	exports.rl_global:giveMoney(thePlayer, 1200*2)--700
	-- outputChatBox("Reval Roleplay:#ffffff VIP 2 olduğunuz için bu turdan 1100₺ kazandınız.", thePlayer, 0, 175, 255, true)
	elseif getElementData(thePlayer, "vip") == 3 then
	exports.rl_global:giveMoney(thePlayer, 1300*2)--800
	-- outputChatBox("Reval Roleplay:#ffffff VIP 3 olduğunuz için bu turdan 1200₺ kazandınız.", thePlayer, 0, 175, 255, true)
	elseif getElementData(thePlayer, "vip") == 4 then
	exports.rl_global:giveMoney(thePlayer, 1400*2)--900
	-- outputChatBox("Reval Roleplay:#ffffff VIP 4 olduğunuz için bu turdan 1300₺ kazandınız.", thePlayer, 0, 175, 255, true)
	end
end
addEvent("pizzaParaVer", true)
addEventHandler("pizzaParaVer", getRootElement(), pizzaParaVer)

--]]

function pizzaBitir(thePlayer)
	local pedVeh = getPedOccupiedVehicle(thePlayer)
	removePedFromVehicle(thePlayer)
	respawnVehicle(pedVeh)
	setElementPosition(thePlayer, 2088.0244140625, -1800.9013671875, 13.3828125)
	setElementRotation(thePlayer, 0, 0, 228.91737365723)
end
addEvent("pizzaBitir", true)
addEventHandler("pizzaBitir", getRootElement(), pizzaBitir)