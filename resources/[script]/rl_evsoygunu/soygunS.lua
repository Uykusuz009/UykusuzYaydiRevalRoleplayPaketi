local evYeri = createMarker(2516.4306640625, -1225.4970703125, 39.015625, "cylinder", 1.1, 0,175,255,0, source)
local evdenCikis = createMarker(2807.5224609375, -1174.39453125, 1025.5703125, "cylinder", 1.1, 0,175,255,0, source)
local dolapYeri = createMarker(2818.556640625, -1166.2216796875, 1025.5777587891, "cylinder", 1.1, 0,175,255,0, source)
local televizyonYeri = createMarker(2811.7333984375, -1165.94140625, 1025.5703125, "cylinder", 1.1, 0,175,255,0, source)
local muziksetiYeri = createMarker(2806.375, -1165.6943359375, 1025.5703125, "cylinder", 1.1, 0,175,255,0, source)
local etkilesimbolge = createMarker(2036.359375, -1774.7529296875, 13.55327796936, "cylinder", 1.1, 0,175,255,0, source)

local gun1 =86800 -- 1 gun saniye olarak = 43400
local sureler = {}

-------------------------------------
local rolexid = 23423
local televizyonid = 23424
local muziksetid = 23425
-------------------------------------

-------------------------------------
ped = createPed(293,2036.359375, -1774.7529296875, 13.55327796936)
setElementRotation(ped,0,0,178.86285400391)
setElementFrozen(ped, true)
-------------------------------------

local satisyap = { 10000,12000,14000,16000,18000,20000 }

function evsoy(thePlayer,cmd)
	if getElementData(root,"giris:yapildi") == 1 then
	exports["rl_bildirim"]:addNotification(thePlayer, "Evin içerisinde zaten biri varken soygun yapamazsın.", "warning")
	else
	if not isElementWithinMarker(thePlayer,evYeri) then
		exports["rl_bildirim"]:addNotification(thePlayer, "Burada soyulacak bir ev yok.", "error")
	return end
	local serial = getPlayerSerial(thePlayer)
	local suan = getRealTime().timestamp
	if sureler[serial] and sureler[serial] > suan then
		local b = getRealTime(sureler[serial])
		exports["rl_bildirim"]:addNotification(thePlayer, "48 saatte bir ev soygunu yapabilirsiniz.", "warning")
		return 	
	end
	sureler[serial] = suan + gun1*2 -- oyuncunun serialine göre ek 2 gün ekledik tabloya
	setElementPosition(thePlayer,2807.5341796875, -1173.2451171875, 1025.5703125)
	setElementDimension(thePlayer, 997)
	setElementInterior(thePlayer, 8)
	setElementData(root,"giris:yapildi",1)
	setElementData(thePlayer,"bugengelev",true)
	triggerClientEvent ( thePlayer, "evsoygun:render", thePlayer, 1 )
	end
end
addCommandHandler("evegir",evsoy)

function getirSayi(thePlayer, id)
    return tonumber(exports["rl_items"]:countItems(thePlayer, id, 1))
end

function cekmeceara(thePlayer)
	if not getElementData(thePlayer, "bugengelev") then
		exports["rl_bildirim"]:addNotification(thePlayer, "Aynen bro.", "warning")
	return end
	if getirSayi(thePlayer, rolexid) <= 1 then
	else
		exports["rl_bildirim"]:addNotification(thePlayer, "24 saatte iki kez çekmece arayabilirsin.", "warning")
	return end
	if not isElementWithinMarker(thePlayer,dolapYeri) then
		exports["rl_bildirim"]:addNotification(thePlayer, "Burada soyulacak bir eşya yok.", "error")
	return end
	if getElementData(thePlayer,"soyuyor") then
		exports["rl_bildirim"]:addNotification(thePlayer, "Zaten soyuyorsunuz.", "error")
	return end
	setElementData(thePlayer, "soyuyor", true)
	setPedAnimation(thePlayer, "bomber", "bom_plant")
	exports["rl_bildirim"]:addNotification(thePlayer, "Çekmeceleri inceliyorsunuz, bu işlem 10 saniye sürecektir.", "success")
	exports.rl_global:sendLocalMeAction(thePlayer,"Sağ ve sol elleri ile yavaşça çekmeceleri açıp incelemeye başlar.")
	
    setTimer(function()
	exports["rl_bildirim"]:addNotification(thePlayer, "Tebrikler, bir adet Rolex marka saat buldunuz.", "success")
	exports["rl_items"]:giveItem(thePlayer,rolexid,1)
	setPedAnimation(thePlayer)
	setElementData(thePlayer, "soyuyor", false)
    end, 10000, 1)
end
addCommandHandler("cekmeceara",cekmeceara)

function televizyonal(thePlayer)
	if not getElementData(thePlayer, "bugengelev") then
		exports["rl_bildirim"]:addNotification(thePlayer, "Aynen bro.", "warning")
	return end
	if getirSayi(thePlayer, televizyonid) <= 0 then
	else
	exports["rl_bildirim"]:addNotification(thePlayer, "24 saatte bir televizyon çalabilirsin.", "warning")
	return end
	if not isElementWithinMarker(thePlayer,televizyonYeri) then
		exports["rl_bildirim"]:addNotification(thePlayer, "Burada soyulacak bir eşya yok.", "error")
	return end
	if getElementData(thePlayer,"soyuyor") then
		exports["rl_bildirim"]:addNotification(thePlayer, "Zaten soyuyorsunuz.", "error")
	return end
	setElementData(thePlayer, "soyuyor", true)
	setPedAnimation(thePlayer, "bomber", "bom_plant")
	exports["rl_bildirim"]:addNotification(thePlayer, "Televizyonu yavaşça çantaya koyuyorsunuz, bu işlem 10 saniye sürecektir.", "success")
	exports.rl_global:sendLocalMeAction(thePlayer,"Sağ ve sol elleri ile yavaşça televizyonu alıp çantaya koyar.")
	
    setTimer(function()
	exports["rl_bildirim"]:addNotification(thePlayer, "Tebrikler, çantanıza koydunuz.", "success")
	exports["rl_items"]:giveItem(thePlayer,televizyonid,1)
	setPedAnimation(thePlayer)
	setElementData(thePlayer, "soyuyor", false)
    end, 10000, 1)

end
addCommandHandler("televizyoncal",televizyonal)

function muziksetial(thePlayer)
	if not getElementData(thePlayer, "bugengelev") then
		exports["rl_bildirim"]:addNotification(thePlayer, "Aynen bro.", "warning")
	return end
	if getirSayi(thePlayer, muziksetid) <= 0 then
	else
	exports["rl_bildirim"]:addNotification(thePlayer, "24 saatte bir müzik seti çalabilirsin.", "warning")
	return end
	if not isElementWithinMarker(thePlayer,muziksetiYeri) then
		exports["rl_bildirim"]:addNotification(thePlayer, "Burada soyulacak bir eşya yok.", "error")
	return end
	if getElementData(thePlayer,"soyuyor") then
		exports["rl_bildirim"]:addNotification(thePlayer, "Zaten soyuyorsunuz.", "error")
	return end
	setElementData(thePlayer, "soyuyor", true)
	setPedAnimation(thePlayer, "bomber", "bom_plant")
	exports["rl_bildirim"]:addNotification(thePlayer, "Müzik setini yavaşça çantaya koyuyorsunuz, bu işlem 10 saniye sürecektir.", "success")
	exports.rl_global:sendLocalMeAction(thePlayer,"Sağ ve sol elleri ile yavaşça müzik setini alıp çantaya koyar.")
	
    setTimer(function()
	exports["rl_bildirim"]:addNotification(thePlayer, "Tebrikler, müzik setini çantanıza attınız.", "success")
	exports["rl_items"]:giveItem(thePlayer,muziksetid,1)
	setPedAnimation(thePlayer)
	setElementData(thePlayer, "soyuyor", false)
    end, 10000, 1)

end
addCommandHandler("muziksetical",muziksetial)

function evdencik(thePlayer,cmd)
	if not getElementData(thePlayer, "bugengelev") then
		exports["rl_bildirim"]:addNotification(thePlayer, "Aynen bro.", "warning")
	return end
	if not isElementWithinMarker(thePlayer,evdenCikis) then
		exports["rl_bildirim"]:addNotification(thePlayer, "Buradayken evden çıkamazsın.", "error")
	return end
	setElementPosition(thePlayer,2516.5419921875, -1225.33203125, 39.015625)
	setElementDimension(thePlayer, 0)
	setElementInterior(thePlayer, 0)
	setElementData(root,"giris:yapildi",0)
	setElementData(thePlayer,"bugengelev",false)
	triggerClientEvent ( thePlayer, "evsoygun:render", thePlayer, 0 )
end
addCommandHandler("evdencik",evdencik)

function malzemelerisat(thePlayer,cmd)
	temp = 0
	if not isElementWithinMarker(thePlayer,etkilesimbolge) then
		exports["rl_bildirim"]:addNotification(thePlayer, "Buradayken eşyaları satamazsın.", "error")
	return end
	if getElementData(thePlayer,"satiyor") then
		exports["rl_bildirim"]:addNotification(thePlayer, "Zaten satıyorsunuz.", "error")
	return end
	setElementData(thePlayer, "satiyor", true)
	exports["rl_bildirim"]:addNotification(thePlayer, "Biraz bekleyin malzemeleri satıyorsunuz.", "warning")
	setTimer(function()
	if exports.rl_global:hasItem(thePlayer,rolexid) then
		exports.rl_global:takeItem(thePlayer,rolexid)
		local rastgeleparaver = math.random(1,#satisyap)
		exports["rl_global"]:giveMoney(thePlayer, satisyap[rastgeleparaver])
		outputChatBox("[İllegal Satıcı] #ffffffBir adet Rolex karşılığında "..satisyap[rastgeleparaver].."₺ almayı hakettin.",thePlayer,255,0,0,true)
		temp = temp + satisyap[rastgeleparaver]
	end
	if exports.rl_global:hasItem(thePlayer,rolexid) then
		exports.rl_global:takeItem(thePlayer,rolexid)
		local rastgeleparaver = math.random(1,#satisyap)
		exports["rl_global"]:giveMoney(thePlayer, satisyap[rastgeleparaver])
		outputChatBox("[İllegal Satıcı] #ffffffBir adet Rolex karşılığında "..satisyap[rastgeleparaver].."₺ almayı hakettin.",thePlayer,255,0,0,true)
		temp = temp + satisyap[rastgeleparaver]
	end
	if exports.rl_global:hasItem(thePlayer,televizyonid) then
		exports.rl_global:takeItem(thePlayer,televizyonid)
		local rastgeleparaver = math.random(1,#satisyap)
		exports["rl_global"]:giveMoney(thePlayer, satisyap[rastgeleparaver])
		outputChatBox("[İllegal Satıcı] #ffffffBir adet TV karşılığında "..satisyap[rastgeleparaver].."₺ almayı hakettin.",thePlayer,255,0,0,true)
		temp = temp + satisyap[rastgeleparaver]
	end
	if exports.rl_global:hasItem(thePlayer,muziksetid) then
		exports.rl_global:takeItem(thePlayer,muziksetid)
		local rastgeleparaver = math.random(1,#satisyap)
		exports["rl_global"]:giveMoney(thePlayer, satisyap[rastgeleparaver])
		outputChatBox("[İllegal Satıcı] #ffffffBir adet müzik seti karşılığında "..satisyap[rastgeleparaver].."₺ almayı hakettin.",thePlayer,255,0,0,true)
		temp = temp + satisyap[rastgeleparaver]
	end
	outputChatBox("[!] #ffffffEşyaları Başarıyla Sattın.",thePlayer,0,255,0,true)
	setElementData(thePlayer, "satiyor", false)
	end, 5000, 1)
end
addCommandHandler("esyalarisat",malzemelerisat)

function soygunihbar() 
	for k , v in ipairs(getElementsByType("player")) do
		if getElementData(v , "faction") == 1 or getElementData(v , "faction") == 376 then  
      		outputChatBox("[SOYGUN]: #ffffffWilson Pavyonu yakınında bir evde soygun başladı!", v, 100,0,255, true)
		end
	end
end
addEvent("evsoygun:ihbar", true)
addEventHandler("evsoygun:ihbar", root, soygunihbar)