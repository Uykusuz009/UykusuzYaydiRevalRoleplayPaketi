
ekpara = 0
local sudakPara = 220 + ekpara
local denizPara = 220 + ekpara
local derePara = 220 +  ekpara
local dagPara = 220 + ekpara


-- BURADAN AŞAĞIDAKİLERİ EDITLEMEYIN.
local yemx, yemy, yemz = 356.31640625, -2028.1455078125, 7.8359375
local yemCol = createColSphere(yemx, yemy, yemz, 2)
local balikCol = createColPolygon(349.8935546875, -2053.3544921875, 7.8359375, -2047.708984375, 349.8466796875, -2088.7978515625, 409.24609375, -2088.7978515625, 409.25390625, -2047.7099609375, 399.392578125, -2047.7099609375, 399.513671875, -2048.248046875, 408.4306640625, -2048.2607421875, 408.322265625, -2087.6474609375, 350.8984375, -2087.5585937, 350.7744140625, -2048.453125, 360.427734375, -2048.681640625, 360.2431640625, -2047.709960937)

function fixle(thePlayer,cmd,komut)
	if not komut then
	outputChatBox("[-]#ffffff Hatalı komut kullanımı, şunları deneyebilirsiniz: #ffaa00/balik fix",thePlayer,215,0,0,true)
	end
	if komut == "fix" then
		outputChatBox("[+]#ffffff Olan hatalar fixlenmiştir, tekrar deneyebilirsiniz.",thePlayer,0,215,0,true)
	end
end
addCommandHandler("balik",fixle)

function balikYardim(thePlayer)
	if isElementWithinColShape(thePlayer, yemCol) then
		outputChatBox("============================================",thePlayer,201,201,201,true)
		outputChatBox("[!]#ffffff Yem almak için #ffaa00/yemal",thePlayer,201,201,201,true)
		outputChatBox("[!]#ffffff Balık satmak için #ffaa00/baliksat",thePlayer,201,201,201,true)
		outputChatBox("[!]#ffffff Yem ve balık bilgileriniz için #ffaa00/balikdurum",thePlayer,201,201,201,true)
		outputChatBox("[!]#ffffff Herhangi bir hata ile karşılaşırsanız #ffaa00/balik fix",thePlayer,201,201,201,true)
		outputChatBox("============================================",thePlayer,201,201,201,true)
	end
end
addCommandHandler("balikyardim", balikYardim)

--[[addCommandHandler("baliktut", 
	function(thePlayer, cmd)
		if isElementWithinColShape(thePlayer, balikCol) then
			if (not getElementData(thePlayer, "balikTutuyor2")) then
				local toplamyem = getElementData(thePlayer, "toplamyem") or 0
				if toplamyem > 0 then
					triggerEvent("artifacts:toggle", thePlayer, thePlayer, "rod")
					exports.rl_global:applyAnimation(thePlayer, "SWORD", "sword_IDLE", -1, false, true, true, false)
					setElementData(thePlayer, "balikTutuyor2", true)
					exports.rl_global:sendLocalMeAction(thePlayer, "oltasını denize doğru sallar.", false, true)
					outputChatBox("[!] #ffffffBalık tutuyorsunuz, lütfen bekleyin!", thePlayer, 10, 10, 255, true)
					setElementData(thePlayer, "toplamyem", toplamyem - 1)
					
					setTimer(function(thePlayer) 
						--local toplambalik = getElementData(thePlayer, "toplambalik") or 0
						local rastgeleSayi = math.random(1, 2)
						if rastgeleSayi == 1 then
							local balikTipi1 = yuzdelikOran(80)
							local balikTipi2 = yuzdelikOran(50)
							local balikTipi3 = yuzdelikOran(30)
							
							-- ORANI EN DÜŞÜKTEN BAŞLAYARAK SIRALANMALIDIR.
							if balikTipi3 then
								exports["rl_items"]:giveItem(thePlayer, 276, 1) -- SUDAK BALIĞI
								outputChatBox("[!] #ffffffTebrikler, bir adet 'Sudak Balığı' tuttunuz!", thePlayer, 0, 255, 0, true)					
							elseif balikTipi2 then
								exports["rl_items"]:giveItem(thePlayer, 274, 1) -- DAĞ ALABALIĞI
								outputChatBox("[!] #ffffffTebrikler, bir adet 'Dağ Alabalığı' tuttunuz!", thePlayer, 0, 255, 0, true)
							elseif balikTipi1 then
								exports["rl_items"]:giveItem(thePlayer, 275, 1) -- DENİZ ALABALIĞI
								outputChatBox("[!] #ffffffTebrikler, bir adet 'Deniz Alabalığı' tuttunuz!", thePlayer, 0, 255, 0, true)		
							else -- Hiçbiri Vurmazsa, (Değeri en düşük balık.)
								exports["rl_items"]:giveItem(thePlayer, 277, 1) -- DERE ALABALIĞI
								outputChatBox("[!] #ffffffTebrikler, bir adet 'Deniz Alabalığı' tuttunuz!", thePlayer, 0, 255, 0, true)		
							end
							--setElementData(thePlayer, "toplambalik", toplambalik + 1)
						elseif rastgeleSayi >= 2 then
							outputChatBox("[!] #ffffffMalesef, balık tutamadınız.", thePlayer, 255, 0, 0, true)
						end
						exports.rl_global:removeAnimation(thePlayer)
						triggerEvent("artifacts:toggle", thePlayer, thePlayer, "rod")
						setElementData(thePlayer, "balikTutuyor2", false)
					end, 20000, 1, thePlayer)
				else
					outputChatBox("[!] #ffffffMalesef, üzerinizde yem kalmadı.", thePlayer, 255, 0, 0, true)
				end
			end
		end
	end
)]]--

addCommandHandler("balikdurum", 
	function(thePlayer, cmd)
		local yem = getElementData(thePlayer, "toplamyem") or 0
		
		local toplamBalik = exports["rl_items"]:countItems(thePlayer, 236, 1) + exports["rl_items"]:countItems(thePlayer, 237, 1) + exports["rl_items"]:countItems(thePlayer, 238, 1) + exports["rl_items"]:countItems(thePlayer, 239, 1)
		outputChatBox("================================",thePlayer,201,201,201,true)
		outputChatBox("[!] Toplam Balık: #ffaa00" .. tostring(toplamBalik), thePlayer,201,201,201,true)
		outputChatBox("[!] Toplam Yem: #ffaa00" .. tostring(yem), thePlayer,201,201,201,true)
		outputChatBox("================================",thePlayer,201,201,201,true)
	end
)

function yemAl(thePlayer, cmd)
	local para = exports.rl_global:getMoney(thePlayer)
	if para >= 1 then
		if isElementWithinColShape(thePlayer, yemCol) then
			local toplamyem = getElementData(thePlayer, "toplamyem") or 0
			if toplamyem >= 20 then
				outputChatBox("[-] #ffffffMalesef, daha fazla yem alamazsınız.", thePlayer, 215, 0, 0, true)
				return
			elseif toplamyem <= 20 then
				exports.rl_global:takeMoney(thePlayer, 1)
				if (toplamyem + 10) <= 20 then
					setElementData(thePlayer, "toplamyem", toplamyem + 10)
					outputChatBox("[+]#ffffff Başarıyla#ffaa00 10 adet#ffffff yem aldınız.", thePlayer, 0, 215, 0, true)
				elseif (toplamyem + 10) >= 20 then
					alinamayanYem = toplamyem + 10 - 20
					alinanYem = 10 - alinamayanYem
					setElementData(thePlayer, "toplamyem", 20)
					outputChatBox("[+] #ffffff" .. tostring(alinanYem) .. " Adet yem aldınız.", thePlayer, 0, 215, 0, true)
				end
			end
		end
	else
		outputChatBox("[-] #ffffffYem almak için paranız yok.", thePlayer, 215, 0, 0, true)
	end
end
addCommandHandler("yemal", yemAl)

function balikSat(thePlayer, cmd)
	local denizMiktar = exports["rl_items"]:countItems(thePlayer, 275, 1) or 0
	local dagMiktar = exports["rl_items"]:countItems(thePlayer, 274, 1) or 0
	local dereMiktar = exports["rl_items"]:countItems(thePlayer, 276, 1) or 0
	local sudakMiktar = exports["rl_items"]:countItems(thePlayer, 277, 1) or 0
	
	if isElementWithinColShape(thePlayer, yemCol) then
		local toplambalik = denizMiktar + dagMiktar + dereMiktar + sudakMiktar
		if toplambalik <= 0 then
			outputChatBox("[-] #ffffffSatacak balığınız yok!", thePlayer, 215, 0, 0, true)
			return
		else
			verilecekPara = (denizMiktar * denizPara) + (dagMiktar * dagPara) + (dereMiktar * derePara) + (sudakMiktar * sudakPara)
			exports.rl_global:giveMoney(thePlayer, verilecekPara)
			for i = 0, denizMiktar do
				exports["rl_items"]:takeItem(thePlayer, 275, 1)
			end
			for i = 0, dagMiktar do
				exports["rl_items"]:takeItem(thePlayer, 274, 1)
			end
			for i = 0, dereMiktar do
				exports["rl_items"]:takeItem(thePlayer, 276, 1)
			end
			for i = 0, sudakMiktar do
				exports["rl_items"]:takeItem(thePlayer, 277, 1)
			end
			outputChatBox("[!] #ffffff" .. tostring(toplambalik) .. " tane balıktan toplam ₺" .. tostring(verilecekPara) .. " kazandınız!", thePlayer, 0, 255, 0, true)
			outputChatBox("[!] #ffffffTuttugunuz Baliklar;", thePlayer, 0, 0, 255, true)
			outputChatBox("[!] #ffffff '" .. tostring(sudakMiktar) .. "' Sudak Balığı '₺" .. tostring(sudakMiktar * sudakPara) .. " kazandınız.", thePlayer, 0, 0, 255, true)
			outputChatBox("[!] #ffffff '" .. tostring(dereMiktar) .. "' Dere Alabalığından '₺" .. tostring(dereMiktar * derePara) .. " kazandınız.", thePlayer, 0, 0, 255, true)
			outputChatBox("[!] #ffffff '" .. tostring(denizMiktar) .. "' Deniz Alabalığından '₺" .. tostring(denizMiktar * denizPara) .. " kazandınız.", thePlayer, 0, 0, 255, true)
			outputChatBox("[!] #ffffff '" .. tostring(dagMiktar) .. "' Dağ Alabalığından '₺" .. tostring(dagMiktar * dagPara) .. " kazandınız.", thePlayer, 0, 0, 255, true)
			
			--setElementData(thePlayer, "toplambalik", 0)
		end
	end
end
addCommandHandler("baliksat", balikSat)

function yuzdelikOran (percent)
	assert(percent >= 0 and percent <= 100) 
	return percent >= math.random(50, 100)
end