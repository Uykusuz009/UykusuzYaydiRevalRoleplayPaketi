local sudakPara = 70
local denizPara = 75
local derePara = 80
local dagPara = 85
local istPara = 400

local kirmiziPara = 5000
local maviPara = 3000
local beyazPara = 1000

local yemx, yemy, yemz = 355.09765625, -2027.5849609375, 7.8359375
local yemCol = createColSphere(yemx, yemy, yemz, 5)
local balikCol = createColPolygon(360.2646484375, -2047.708984375, 349.84375, -2047.708984375, 349.8466796875, -2088.7978515625, 409.24609375, -2088.7978515625, 409.25390625, -2047.7099609375, 399.392578125, -2047.7099609375, 399.513671875, -2048.248046875, 408.4306640625, -2048.2607421875, 408.322265625, -2087.6474609375, 350.8984375, -2087.5585937, 350.7744140625, -2048.453125, 360.427734375, -2048.681640625, 360.2431640625, -2047.709960937)

function balikYardim(player)
	if isElementWithinColShape(player, yemCol) then
		outputChatBox("==================================================", player, 255, 255, 255)
		outputChatBox("[!] #ffffffYem Almak İçin /yemal",player,0,255,0, true)
        outputChatBox("[!] #ffffffBalık Satmak İçin /baliksat",player,0,255,0, true)
        outputChatBox("[!] #ffffffİstiridyelerinizi açmak isterseniz /istiridye",player,0,255,0, true)
		outputChatBox("[!] #ffffffYem ve Balık Bilgileriniz İçin /balikdurum",player,0,255,0, true)
		outputChatBox("==================================================", player, 255, 255, 255)
	end
end
addCommandHandler("balikyardim", balikYardim)
addCommandHandler("balikbilgi", balikYardim)

addCommandHandler("baliktut", 
	function(player, cmd)
		if isElementWithinColShape(player, balikCol) then
			if (not getElementData(player, "balikTutuyor")) then
				local toplamyem = getElementData(player, "toplamyem") or 0
				if toplamyem > 0 then
					--triggerEvent("artifacts:toggle", player, player, "rod")
					exports.rl_global:applyAnimation(player, "SWORD", "sword_IDLE", -1, false, true, true, false)
					setElementData(player, "balikTutuyor", true)
					exports.rl_global:sendLocalMeAction(player, "oltasını denize doğru sallar.", false, true)
					outputChatBox("#03c03c[!] #ffffffBalık tutuyorsunuz, lütfen bekleyin!", player, 10, 10, 255, true)
					setElementData(player, "toplamyem", toplamyem - 1)
					setTimer(function(player) 
						local rastgeleSayi = math.random(1,2)
						if rastgeleSayi == 1 then
							local balikTipi1 = yuzdelikOran(50)
							local balikTipi2 = yuzdelikOran(50)
							local balikTipi3 = yuzdelikOran(50)
							local balikTipi4 = yuzdelikOran(50)
							if balikTipi3 then
								exports["rl_items"]:giveItem(player, 239, 1) 
								outputChatBox("#03c03c[!] #ffffffTebrikler, bir adet 'Sudak Balığı' tuttunuz!", player, 0, 255, 0, true)					
							elseif balikTipi2 then
								exports["rl_items"]:giveItem(player, 236, 1)
								outputChatBox("#03c03c[!] #ffffffTebrikler, bir adet 'Dağ Alabalığı' tuttunuz!", player, 0, 255, 0, true)
							elseif balikTipi1 then
								exports["rl_items"]:giveItem(player, 237, 1)
								outputChatBox("#03c03c[!] #ffffffTebrikler, bir adet 'Deniz Alabalığı' tuttunuz!", player, 0, 255, 0, true)		
							elseif balikTipi4 then
								exports["rl_items"]:giveItem(player, 342, 1)
								outputChatBox("#03c03c[!] #ffffffTebrikler, bir adet 'İstiridye' tuttunuz!", player, 0, 255, 0, true)		
							else -- Hiçbiri Vurmazsa, (Değeri en düşük balık.)
								exports["rl_items"]:giveItem(player, 238, 1)
								outputChatBox("#03c03c[!] #ffffffTebrikler, bir adet 'Dere Alabalığı' tuttunuz!", player, 0, 255, 0, true)		
							end
						elseif rastgeleSayi >= 2 then
							outputChatBox("#ff2400[!] #ffffffMalesef, balık tutamadınız.", player, 255, 0, 0, true)
						end
						exports.rl_global:removeAnimation(player)
						--triggerEvent("artifacts:toggle", player, player, "rod")
						setElementData(player, "balikTutuyor", false)
					end, 10000, 1, player)
				else
					outputChatBox("#ff2400[!] #ffffffMalesef, üzerinizde yem kalmadı.", player, 255, 0, 0, true)
				end
			end
		end
	end
)

function balikdurum(player, cmd)
		local yem = getElementData(player, "toplamyem") or 0
		--local balik = getElementData(player, "toplambalik") or 0
        local toplamBalik = exports["rl_items"]:countItems(player, 239, 1) + exports["rl_items"]:countItems(player, 236, 1) + exports["rl_items"]:countItems(player, 237, 1)  + exports["rl_items"]:countItems(player, 238, 1)
        local toplamIstiridye = exports["rl_items"]:countItems(player,342,1)
		outputChatBox("-----------------------------------------", player, 255, 255, 255)
        outputChatBox("[!] #ffffffToplam Balık: " .. tostring(toplamBalik) ,player,0,0,255, true)
        outputChatBox("[!] #ffffffToplam İstiridye: " .. tostring(toplamIstiridye), player,0,0,255, true)
		outputChatBox("[!] #ffffffToplam Yem: " .. tostring(yem), player,0,0,255, true)
		outputChatBox("-----------------------------------------", player, 255, 255, 255)
	end
addCommandHandler('balikdurum',balikdurum)
addCommandHandler('toplambalik',balikdurum)
addCommandHandler('balik',balikdurum)

function yemAl(player, cmd)
	local para = exports.rl_global:getMoney(player)
	if para >= 50 then
		if isElementWithinColShape(player, yemCol) then
			local toplamyem = getElementData(player, "toplamyem") or 0
			if toplamyem >= 10 then
				outputChatBox("[!] #ffffffMalesef, daha fazla yem alamazsınız.", player, 255, 0, 0, true)
				return
			elseif toplamyem <= 10 then
				exports.rl_global:takeMoney(player, 50)
				if (toplamyem + 10) <= 10 then
					setElementData(player, "toplamyem", toplamyem + 10)
					outputChatBox("#03c03c[!] #ffffff10 Adet yem aldınız.", player, 10, 10, 255, true)
				elseif (toplamyem + 10) >= 10 then
					alinamayanYem = toplamyem + 10 - 10
					alinanYem = 10 - alinamayanYem
					setElementData(player, "toplamyem", 10)
					outputChatBox("#03c03c[!] #ffffff" .. tostring(alinanYem) .. " Adet yem aldınız.", player, 10, 10, 255, true)
				end
			end
		end
	else
		outputChatBox("#ff2400[!] #ffffffYem fiyatları arttı, yemler artık 50$ ahbap.", player, 255, 0, 0, true)
		outputChatBox("#ff2400[!] #ffffffYem almak için yeterli paranız yok.", player, 255, 0, 0, true)
	end
end
addCommandHandler("yemal", yemAl)

function balikSat(player, cmd)
	local denizMiktar = exports["rl_items"]:countItems(player, 237, 1)
	local dagMiktar = exports["rl_items"]:countItems(player, 236, 1)
	local dereMiktar = exports["rl_items"]:countItems(player, 238, 1)
    local sudakMiktar = exports["rl_items"]:countItems(player, 239, 1)
    local istiridyeMiktar = exports["rl_items"]:countItems(player, 342, 1)
    local kirmizi = exports["rl_items"]:countItems(player, 344, 1)
    local mavi = exports["rl_items"]:countItems(player, 343, 1)
    local beyaz = exports["rl_items"]:countItems(player, 345, 1)

	if isElementWithinColShape(player, yemCol) then
		local toplambalik = denizMiktar + dagMiktar + dereMiktar + sudakMiktar + istiridyeMiktar + kirmizi + mavi + beyaz
		if toplambalik <= 0 then
			outputChatBox("#ff2400[!] #ffffffSatacak balığınız yok!", player, 255, 0, 0, true)
			return
		else
			verilecekPara = (denizMiktar * denizPara) + (dagMiktar * dagPara) + (dereMiktar * derePara) + (sudakMiktar * sudakPara) + (istiridyeMiktar * istPara) + (kirmizi * kirmiziPara) + (mavi * maviPara) + (beyaz * beyazPara)
			exports.rl_global:giveMoney(player, verilecekPara)
			for i = 0, denizMiktar do
				exports["rl_items"]:takeItem(player, 237, 1)
			end
			for i = 0, dagMiktar do
				exports["rl_items"]:takeItem(player, 236, 1)
			end
			for i = 0, dereMiktar do
				exports["rl_items"]:takeItem(player, 238, 1)
			end
			for i = 0, sudakMiktar do
				exports["rl_items"]:takeItem(player, 239, 1)
            end
            for i = 0, istiridyeMiktar do
				exports["rl_items"]:takeItem(player, 342, 1)
            end
            for i = 0, kirmizi do
				exports["rl_items"]:takeItem(player, 344, 1)
            end
            for i = 0, mavi do
				exports["rl_items"]:takeItem(player, 343, 1)
            end
            for i = 0, beyaz do
				exports["rl_items"]:takeItem(player, 345, 1)
			end
			outputChatBox("#03c03c[!] #ffffff" .. tostring(toplambalik) .. " tane balık & istiridyeden toplam $" .. tostring(verilecekPara) .. " kazandınız!", player, 0, 255, 0, true)
			outputChatBox("[!] #ffffff '" .. tostring(sudakMiktar) .. "' Alabalık Balığı '$" .. tostring(sudakMiktar * sudakPara) .. " kazandınız.", player, 0,255,0, true)
			outputChatBox("[!] #ffffff '" .. tostring(dereMiktar) .. "' Dere Alabalığından '$" .. tostring(dereMiktar * derePara) .. " kazandınız.", player, 0,255,0, true)
			outputChatBox("[!] #ffffff '" .. tostring(denizMiktar) .. "' Deniz Alabalığından '$" .. tostring(denizMiktar * denizPara) .. " kazandınız.", player, 0,255,0, true)
           outputChatBox("[!] #ffffff '" .. tostring(dagMiktar) .. "' Dağ Alabalığından '$" .. tostring(dagMiktar * dagPara) .. " kazandınız.", player, 0,255,0, true)
            outputChatBox("#03c03c[!] #ffffff '" .. tostring(kirmizi) .. "' Kırmızı İnciden '$" .. tostring(kirmizi * kirmiziPara) .. " kazandınız.", player, 255,0,0, true)
            outputChatBox("#03c03c[!] #ffffff '" .. tostring(mavi) .. "' Mavi İnciden '$" .. tostring(mavi * maviPara) .. " kazandınız.", player, 53,48,196, true)
            outputChatBox("#03c03c[!] #ffffff '" .. tostring(beyaz) .. "' Beyaz İnciden '$" .. tostring(beyaz * beyazPara) .. " kazandınız.", player, 99,99,99, true)
		end
	end
end
addCommandHandler("baliksat", balikSat)

function istiridyeOpen(player)
if exports.rl_global:hasItem(player,342,1) then 
    local rastgeleSayi = math.random(1,2)
    if rastgeleSayi == 1 then
        local istiridye1 = yuzdelikOran(50)
        local istiridye2 = yuzdelikOran(50)
        local istiridye3 = yuzdelikOran(50)
        local istiridye4 = yuzdelikOran(50)
        if istiridye3 then
            exports.rl_global:takeItem(player,342,1)
            exports.rl_global:sendLocalDoAction(player, "istiridyesini açtı, içi boş.", false, true)	
            outputChatBox("#ff2400[!] #ffffffÜzgünüm, istiridyenin için boş çıktı.", player, 255, 0, 0, true)
        elseif istiridye2 then
            exports.rl_global:takeItem(player,342,1)
            exports.rl_global:giveItem(player,345,1)
            exports.rl_global:sendLocalDoAction(player, "istiridyesini açtı, içinden ( Beyaz İnci ) çıktı.", false, true)	
            outputChatBox("#03c03c[!] #FFFFFFTebrikler, istiridyenin içinden #999999Beyaz #FFFFFFİnci çıktı.", player, 99,99,99, true)
        elseif istiridye1 then
            exports.rl_global:takeItem(player,342,1)
            exports.rl_global:giveItem(player,343,1)
            exports.rl_global:sendLocalDoAction(player, "istiridyesini açtı, içinden ( Mavi İnci ) çıktı.", false, true)	
            outputChatBox("#03c03c[!] #FFFFFFTebrikler, istiridyenin içinden #3530c4Mavi #FFFFFFİnci çıktı.", player, 53,48,196, true)
        elseif istiridye4 then
            exports.rl_global:takeItem(player,342,1)
            exports.rl_global:giveItem(player,344,1)
            exports.rl_global:sendLocalDoAction(player, "istiridyesini açtı, içinden ( Kırmızı İnci ) çıktı.", false, true)	
            outputChatBox("#03c03c[!] #FFFFFFTebrikler, istiridyenin içinden #FF0000Kırmızı #FFFFFFİnci çıktı.", player, 0,255,0, true)
        else 
            exports.rl_global:takeItem(player,342,1)
            exports.rl_global:sendLocalDoAction(player, "istiridyesini açtı, içi boş.", false, true)
            outputChatBox("#03c03c[!] #ffffffÜzgünüm, istiridyenin için boş çıktı.", player, 255, 0, 0, true)
        end
    elseif rastgeleSayi >= 2 then
        exports.rl_global:takeItem(player,342,1)
        exports.rl_global:sendLocalDoAction(player, "istiridyesini açtı, içi boş.", false, true)
        outputChatBox("#ff2400[!] #ffffffÜzgünüm, istiridyenin için boş çıktı.", player, 255, 0, 0, true)
    end
else
    outputChatBox("#ff2400[!]#F9F9F9 Üzerinde açabiliceğin bir istiridye yok!",player,255,0,0,true)
end
end
addCommandHandler('istiridyeac',istiridyeOpen)
addCommandHandler('istiridye',istiridyeOpen)

function yemsat(player)
    setElementData(player, "toplamyem", 20)
end
addCommandHandler('yemsat',yemsat)

function yuzdelikOran (percent)
	assert(percent >= 0 and percent <= 100) 
	return percent >= math.random(1, 100)
end

--[[
local hillArea = createColSphere ( 372.34045, -2048.40552, 7.83594, 60 )
function hill_Enter (player)
triggerClientEvent(player,'fish:true',player)
end
addEventHandler ( "onColShapeHit", hillArea, hill_Enter )
--]]