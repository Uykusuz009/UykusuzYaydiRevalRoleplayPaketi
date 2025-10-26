local marker_ = createMarker(1210.7744140625, 5.017578125, 1000.0,"cylinder",1,255,215,0,150)
marker_:setInterior(2)
marker_:setDimension(36)

local poledanceAmount = 500
local blowjobAmount = 800
local sex1Amount = 1000
local sex2Amount = 2000

x,y = guiGetScreenSize()
g,u = 800,400
a,b = (x/2)-(g/2),(y/2)-(u/2)

addEventHandler("onClientMarkerHit",marker_,function(_,__)
if _ == localPlayer then else return end
if getLocalPlayer():getDimension() == 36 then
if isElement(e_window) then return end
e_window = guiCreateStaticImage(a,b,g,u,"background.png",false)
e_info = guiCreateLabel(a+340,b-20,200,50,"",false) e_info:setColor(255,255,255) e_info:setFont("default-bold-small")
e_close = guiCreateLabel(a+780,b-20,200,50,"X",false) e_close:setColor(255,255,255) e_close:setFont("default-bold-small")
e_one = guiCreateButton(3,372,191,26,"",false,e_window)
e_two = guiCreateButton(203,372,191,26,"",false,e_window)
e_tree = guiCreateButton(405,372,191,26,"",false,e_window)
e_fo = guiCreateButton(605,372,191,26,"",false,e_window)
e_one:setAlpha(0) e_two:setAlpha(0) e_tree:setAlpha(0) e_fo:setAlpha(0)
end
end)

orospu={}

addEventHandler("onClientGUIClick",getRootElement(),function()
if source == e_close then
if isElement(e_window) then destroyElement(e_window) destroyElement(e_info) destroyElement(e_close) end
elseif source == e_two then
if isElement(e_window) then destroyElement(e_window) destroyElement(e_info) destroyElement(e_close) end

if getLocalPlayer():getDimension() == 36 then else outputChatBox('[!]#ffffff Lütfen başka bir hizmete başlamak için Interiordan çıkıp tekrar girin.', 255, 0, 0, true) return end

money = getLocalPlayer():getData('money')
if tonumber(money) > tonumber(blowjobAmount) then else outputChatBox('[!]#ffffff Yeterli paranız yok. ['..blowjobAmount..'₺]', 255, 0, 0, true) return end
triggerServerEvent('take.escort.money', getLocalPlayer(), blowjobAmount)

randombro = math.random(5000,7500)
getLocalPlayer():setPosition(2206.4228515625, -1073.527734375, 1050.084375)
getLocalPlayer():setRotation(0,0,180)
getLocalPlayer():setInterior(1)
getLocalPlayer():setDimension(randombro)
orospu[getLocalPlayer()] = createPed(299,2206.4228515625, -1074.327734375, 1050.35,0)
orospu[getLocalPlayer()]:setInterior(1)
orospu[getLocalPlayer()]:setDimension(randombro)
orospu[getLocalPlayer()]:setFrozen(true)
getLocalPlayer():setAnimation("BLOWJOBZ","BJ_Couch_Start_P",-1,false,false,false)
orospu[getLocalPlayer()]:setAnimation("BLOWJOBZ","BJ_Stand_Start_W",-1,true,false,false)
setTimer(function() orospu[getLocalPlayer()]:setAnimation("BLOWJOBZ","BJ_Couch_Loop_W",-1,true,false,false) end,1700,1)
local sound = playSound("blowjob.mp3")
sound:setVolume(0.5)
setTimer(function() sound:stop() destroyElement(orospu[getLocalPlayer()]) orospu[getLocalPlayer()] = nil getLocalPlayer():setAnimation(false) getLocalPlayer():setInterior(2) getLocalPlayer():setDimension(36) getLocalPlayer():setPosition(1210.7841796875, 3.0517578125, 1000.92187) end,60000,1)
elseif source == e_fo then
if isElement(e_window) then destroyElement(e_window) destroyElement(e_info) destroyElement(e_close) end

if getLocalPlayer():getDimension() == 36 then else outputChatBox('[!]#ffffff Lütfen başka bir hizmete başlamak için Interiordan çıkıp tekrar girin.', 255, 0, 0, true) return end

money = getLocalPlayer():getData('money')
if tonumber(money) > tonumber(sex2Amount) then else outputChatBox('[!]#ffffff Yeterli paranız yok. ['..sex2Amount..'₺]', 255, 0, 0, true) return end
triggerServerEvent('take.escort.money', getLocalPlayer(), sex2Amount)

randombro = math.random(5000,7500)
getLocalPlayer():setPosition(2206.3798828125, -1072.2673828125, 1049)
getLocalPlayer():setRotation(0,0,0)
getLocalPlayer():setInterior(1)
getLocalPlayer():setDimension(randombro)
orospu[getLocalPlayer()] = createPed(299,2206.3798828125, -1071.2, 1051,180)
orospu[getLocalPlayer()]:setInterior(1)
orospu[getLocalPlayer()]:setDimension(randombro)
orospu[getLocalPlayer()]:setFrozen(true)
getLocalPlayer():setAnimation("SEX","SEX_1_Cum_P",-1,true,false,false)
orospu[getLocalPlayer()]:setAnimation("SEX","SEX_1_Cum_W",-1,true,false,false)
local sound = playSound("sex2.wav")
sound:setVolume(0.5)
setTimer(function() sound:stop() destroyElement(orospu[getLocalPlayer()]) orospu[getLocalPlayer()] = nil getLocalPlayer():setAnimation(false) getLocalPlayer():setInterior(2) getLocalPlayer():setDimension(36) getLocalPlayer():setPosition(1210.7841796875, 3.0517578125, 1000.92187) end,120000,1)
elseif source == e_one then
if isElement(e_window) then destroyElement(e_window) destroyElement(e_info) destroyElement(e_close) end

if getLocalPlayer():getDimension() == 36 then else outputChatBox('[!]#ffffff Lütfen başka bir hizmete başlamak için Interiordan çıkıp tekrar girin.', 255, 0, 0, true) return end

money = getLocalPlayer():getData('money')
if tonumber(money) > tonumber(poledanceAmount) then else outputChatBox('[!]#ffffff Yeterli paranız yok. ['..poledanceAmount..'₺]', 255, 0, 0, true) return end
triggerServerEvent('take.escort.money', getLocalPlayer(), poledanceAmount)

randombro = math.random(5000,7500)
getLocalPlayer():setPosition(2206.4228515625, -1073.527734375, 1050.084375)
getLocalPlayer():setRotation(0,0,180)
getLocalPlayer():setInterior(1)
getLocalPlayer():setDimension(randombro)
orospu[getLocalPlayer()] = createPed(299,2206.416015625, -1073.8876953125, 1049.49,0)
orospu[getLocalPlayer()]:setInterior(1)
orospu[getLocalPlayer()]:setDimension(randombro)
orospu[getLocalPlayer()]:setFrozen(true)
getLocalPlayer():setAnimation("BLOWJOBZ","BJ_Couch_Loop_P",-1,true,false,false)
orospu[getLocalPlayer()]:setAnimation("lapdan3","lapdan_d",-1,true,false,false)
setTimer(function() destroyElement(orospu[getLocalPlayer()]) orospu[getLocalPlayer()] = nil getLocalPlayer():setAnimation(false) getLocalPlayer():setInterior(2) getLocalPlayer():setDimension(36) getLocalPlayer():setPosition(1210.7841796875, 3.0517578125, 1000.921875) end,30000,1)
elseif source == e_tree then
if isElement(e_window) then destroyElement(e_window) destroyElement(e_info) destroyElement(e_close) end

if getLocalPlayer():getDimension() == 36 then else outputChatBox('[!]#ffffff Lütfen başka bir hizmete başlamak için Interiordan çıkıp tekrar girin.', 255, 0, 0, true) return end

money = getLocalPlayer():getData('money')
if tonumber(money) > tonumber(sex1Amount) then else outputChatBox('[!]#ffffff Yeterli paranız yok. ['..sex1Amount..'₺]', 255, 0, 0, true) return end
triggerServerEvent('take.escort.money', getLocalPlayer(), sex1Amount)

randombro = math.random(5000,7500)
getLocalPlayer():setPosition(2211.014453125, -1073.796875, 1050.3)
getLocalPlayer():setRotation(0,0,270)
getLocalPlayer():setInterior(1)
getLocalPlayer():setDimension(randombro)
orospu[getLocalPlayer()] = createPed(299,2211.6514453125, -1073.796875, 1049.57,270)
orospu[getLocalPlayer()]:setInterior(1)
orospu[getLocalPlayer()]:setDimension(randombro)
orospu[getLocalPlayer()]:setFrozen(true)
getLocalPlayer():setAnimation("PAULNMAC","Piss_loop",-1,true,false,false)
orospu[getLocalPlayer()]:setAnimation("LOWRIDER", "lrgirl_l4_bnce",-1,true,false,false)
local sound = playSound("sex1.mp3")
sound:setVolume(0.5)
setTimer(function() sound:stop() destroyElement(orospu[getLocalPlayer()]) orospu[getLocalPlayer()] = nil getLocalPlayer():setAnimation(false) getLocalPlayer():setInterior(2) getLocalPlayer():setDimension(36) getLocalPlayer():setPosition(1210.7841796875, 3.0517578125, 1000.92187) end,60000,1)
end
end)