depo_1=createColSphere(2228.30,-2253.51,14.57,2) -- ilk ü.ç burası
depo_2=createColSphere(2213.52,-2268.5,14.57,2) -- petrol burası

local player_dorse={}
local totalTempVehicles = 0

addEvent("lojistik_create",true)
addEventHandler("lojistik_create",getRootElement(),function(deger)
setElementData(source,"lojistik_isci",true)
setElementData(source,"lojistik_is",tonumber(deger))
outputChatBox("Lojistik: #ffffffİşe başladınız depoya geri geri yanaşın ve talimatları izleyin.",source,44,44,44,true)
end)

function depo_1_girdi(thePlayer,_)
if getElementType(thePlayer)=="player" then else return end
local p_tiri = getPedOccupiedVehicle(thePlayer)
if p_tiri then else return end
if (getElementModel(p_tiri)==403) or (getElementModel(p_tiri)==514) or (getElementModel(p_tiri)==515) then else return end
if getElementData(thePlayer,"lojistik_isci") then else return end
tir_rx,tir_ry,tir_rz=getElementRotation(getPedOccupiedVehicle(thePlayer))
if tir_rz > 40 and tir_rz < 46 then else outputChatBox("Lojistik: #ffffffLütfen depoya geri geri yanaşın!",thePlayer,44,44,44,true) return end
if tonumber(getElementData(thePlayer,"lojistik_is")) == 4 then outputChatBox("Lojistik: #ffffffYolculuğunuz #888888Shell Ana Bayi #ffffffyakıt tankeri için yan depoya yanaşınız!",thePlayer,44,44,44,true) return end
if isElement(player_dorse[thePlayer]) then outputChatBox("Lojistik: #ffffffZaten bir dorseniz var!",thePlayer,44,44,44,true) return end
fadeCamera(thePlayer,false,1)
setElementFrozen(p_tiri,true)
setTimer(function(thePlayer) triggerClientEvent(thePlayer,"depo_1_senaryo",thePlayer)
setElementPosition(p_tiri,2219.77,-2243.90,14.56)
setElementRotation(p_tiri,0,0,40.57)
totalTempVehicles = totalTempVehicles+1
local dbid = (-totalTempVehicles)
player_dorse[thePlayer] = createVehicle(435,2227.62,-2252.88,13.5,0,0,43,getPlayerName(thePlayer))
exports.rl_pool:allocateElement(player_dorse[thePlayer],dbid)
setElementData(player_dorse[thePlayer],"dbid",dbid)
setElementData(player_dorse[thePlayer],"faction",-1)
setElementData(player_dorse[thePlayer],"owner",-1,false)
setElementData(player_dorse[thePlayer],"handbrake",0,true)
setElementData(player_dorse[thePlayer],"Impounded",0)
setElementData(player_dorse[thePlayer],"show_plate",1)
setElementData(player_dorse[thePlayer],"plate",getPlayerName(thePlayer))
fadeCamera(thePlayer,true,1)
end,1000,1,thePlayer)
setTimer(function(thePlayer) fadeCamera(thePlayer,false,1) end,3000,1,thePlayer)
setTimer(function(thePlayer) setElementFrozen(p_tiri,false) fadeCamera(thePlayer,true,1) attachTrailerToVehicle(p_tiri,player_dorse[thePlayer]) outputChatBox("Lojistik: #ffffffDorsenize hasar gelmesi durumunda /dorse komutunu kullanınız!",thePlayer,44,44,44,true) outputChatBox("Lojistik: #ffffffHedef GPS'inizde 'KIRMIZI' Bayrak olarak gözükmektedir.!",thePlayer,44,44,44,true)
if tonumber(getElementData(thePlayer,"lojistik_is")) == 1 then
triggerClientEvent(thePlayer,"dorse_started",thePlayer,atx,aty,atz,atx,aty,audi_fiyat)
setElementData(p_tiri, "gpsDestination", {atx,aty})
konumm = createBlip(atx, aty, atz,62)
local v = thePlayer
setElementVisibleTo(konumm,root,false)
setElementVisibleTo(konumm,v,true)
elseif tonumber(getElementData(thePlayer,"lojistik_is")) == 2 then
triggerClientEvent(thePlayer,"dorse_started",thePlayer,ltx,lty,ltz,ltx,lty,lays_fiyat)
konumm = createBlip(ltx, lty, ltz,62)
local v = thePlayer
setElementVisibleTo(konumm,root,false)
setElementVisibleTo(konumm,v,true)
elseif tonumber(getElementData(thePlayer,"lojistik_is")) == 3 then
triggerClientEvent(thePlayer,"dorse_started",thePlayer,ptx,pty,ptz,ptx,pty,pepsi_fiyat)
setElementData(p_tiri, "gpsDestination", {ptx,pty})
konumm = createBlip(ptx, pty, ptz,62)
local v = thePlayer
setElementVisibleTo(konumm,root,false)
setElementVisibleTo(konumm,v,true)
end
end,5000,1,thePlayer)
end
addEventHandler("onColShapeHit",depo_1,depo_1_girdi)

function depo_2_girdi(thePlayer,_)
if getElementType(thePlayer)=="player" then else return end
local p_tiri = getPedOccupiedVehicle(thePlayer)
if p_tiri then else return end
if (getElementModel(p_tiri)==403) or (getElementModel(p_tiri)==514) or (getElementModel(p_tiri)==515) then else return end
if getElementData(thePlayer,"lojistik_isci") then else return end
if tonumber(getElementData(thePlayer,"lojistik_is")) == 4 then else outputChatBox("Lojistik: #ffffffLütfen yan depoya yanaşın! Bu depo sadece benzinlikler için.",thePlayer,44,44,44,true) return end
tir_rx,tir_ry,tir_rz=getElementRotation(getPedOccupiedVehicle(thePlayer))
if tir_rz > 40 and tir_rz < 46 then else outputChatBox("Lojistik: #ffffffLütfen depoya geri geri yanaşın!",thePlayer,44,44,44,true) return end
if isElement(player_dorse[thePlayer]) then outputChatBox("Lojistik: #ffffffZaten bir dorseniz var!",thePlayer,44,44,44,true) return end
fadeCamera(thePlayer,false,1)
setElementFrozen(p_tiri,true)
setTimer(function(thePlayer) triggerClientEvent(thePlayer,"depo_2_senaryo",thePlayer)
setElementPosition(p_tiri,2205.400390625, -2259.6650390625, 14.528525352478)
setElementRotation(p_tiri,0,0,42.2)
totalTempVehicles = totalTempVehicles+1
local dbid = (-totalTempVehicles)
player_dorse[thePlayer] = createVehicle(435,2213.84,-2268.73,14,0,0,43,getPlayerName(thePlayer))
exports.rl_pool:allocateElement(player_dorse[thePlayer],dbid)
setElementData(player_dorse[thePlayer],"dbid",dbid)
setElementData(player_dorse[thePlayer],"faction",-1)
setElementData(player_dorse[thePlayer],"owner",-1,false)
setElementData(player_dorse[thePlayer],"handbrake",0,true)
setElementData(player_dorse[thePlayer],"Impounded",0)
setElementData(player_dorse[thePlayer],"show_plate",1)
setElementData(player_dorse[thePlayer],"plate",getPlayerName(thePlayer))
fadeCamera(thePlayer,true,1)
end,1000,1,thePlayer)
setTimer(function(thePlayer) fadeCamera(thePlayer,false,1) end,3000,1,thePlayer)
setTimer(function(thePlayer) setElementFrozen(p_tiri,false) fadeCamera(thePlayer,true,1) attachTrailerToVehicle(p_tiri,player_dorse[thePlayer]) outputChatBox("Lojistik: #ffffffDorsenize hasar gelmesi durumunda dorseye yakınlaşarak /dorse komutunu kullanınız!",thePlayer,44,44,44,true) outputChatBox("Lojistik: #ffffffHedef GPS'inizde 'KIRMIZI' Bayrak olarak gözükmektedir.!",thePlayer,44,44,44,true)
if tonumber(getElementData(thePlayer,"lojistik_is")) == 4 then
triggerClientEvent(thePlayer,"dorse_started",thePlayer,bx,by,bz,bx,by,benzinlik_fiyat) 
--setElementData(p_tiri, "gpsDestination", {bx,by})
konumm = createBlip(bx, by, bz,62)
local v = thePlayer
setElementVisibleTo(konumm,root,false)
setElementVisibleTo(konumm,v,true)
end 
end,5000,1,thePlayer)
end
addEventHandler("onColShapeHit",depo_2,depo_2_girdi)

addEvent("dorse_started",true)
addEventHandler("dorse_started",getRootElement(),function(tir,fiyat)
if getElementData(source,"lojistik_isci") then else return end
if player_dorse[source] then else outputChatBox("Tırında dorse takılı değil veya takılı olan dorse sana ait değil!",source,255,0,0,true) return end
if (getVehicleTowedByVehicle(tir) == player_dorse[source]) then
local truck_plate = getElementData(player_dorse[source],"plate")
if truck_plate == getPlayerName(source) then
fadeCamera(source,false,1)
setTimer(function(source) destroyElement(player_dorse[source]) player_dorse[source] = nil end,1000,1,source)
setTimer(function(source) fadeCamera(source,true,1) exports['rl_bildirim']:create(source,"success","Başarıyla dorseyi hedefe ulaştırdın.") setElementData(tir, "gpsDestination", {2209.271484375, -2243.982421875}) triggerClientEvent(source,"truck_donus",source,fiyat) end,1700,1,source)
destroyElement(konumm)
end
end
end)

addEvent("truckFinish",true)
addEventHandler("truckFinish",getRootElement(),function(fiyat)
if getElementData(source,"lojistik_isci") then else return end
exports['rl_bildirim']:create(source,"success","Başarıyla mesleği bitirdin ve hakkın olan "..fiyat.."₺ kazandın!")
exports.rl_global:giveMoney(source,fiyat)
setElementData(source,"lojistik_isci",false)
setElementData(source,"lojistik_is",0)

destroyElement(konumm)
end)

function dorse_reattach(thePlayer)
if getElementData(thePlayer,"lojistik_isci") then else return end
if isElement(player_dorse[thePlayer]) then else return end
local p_tiri = getPedOccupiedVehicle(thePlayer)
local xt,yt,zt=getElementPosition(p_tiri)
local xtt,ytt,ztt=getElementPosition(player_dorse[thePlayer])
local dist = getDistanceBetweenPoints3D(xt,yt,zt,xtt,ytt,ztt)
if dist < 20 then else exports["rl_bildirim"]:create(thePlayer,"info","Dorsenize çok uzaktasınız!") return end
attachTrailerToVehicle(p_tiri,player_dorse[thePlayer])
end
addCommandHandler("dorse",dorse_reattach)

function dorse_mission_cancel(thePlayer)
local p_tiri = getPedOccupiedVehicle(thePlayer)
if p_tiri then else return end
if getElementData(thePlayer,"lojistik_isci") then else return end
if isElement(player_dorse[thePlayer]) then else return end
fadeCamera(thePlayer,false,1)
triggerClientEvent(thePlayer,"client_clear",thePlayer)
setTimer(function(thePlayer) removePedFromVehicle(thePlayer) setElementData(thePlayer,"lojistik_isci",false) setElementData(thePlayer,"lojistik_is",0) destroyElement(player_dorse[thePlayer]) player_dorse[thePlayer] = nil end,1500,1,thePlayer)
setTimer(function(thePlayer) setElementPosition(p_tiri,2160.90625, -2294.609375, 13.48912525177) setElementPosition(thePlayer,2190.2900390625, -2251.6142578125, 13.493664741516) end,2200,1,thePlayer)
setTimer(function(thePlayer) fadeCamera(thePlayer,true,1) end,3000,1,thePlayer)
destroyElement(konumm)
end
addCommandHandler("dorseiptal",dorse_mission_cancel)

function quit_j(_)
local p_tiri = getPedOccupiedVehicle(source)
if p_tiri then else return end
if getElementData(source,"lojistik_isci") then else return end
if isElement(player_dorse[source]) then else return end
destroyElement(player_dorse[source]) player_dorse[source] = nil
setElementPosition(p_tiri,2267.984375, -2168.3955078125, 6.0625)
destroyElement(konumm)
end
addEventHandler("onPlayerQuit",getRootElement(),quit_j)

addEventHandler("onTrailerAttach",getRootElement(),function(truck)
local player = getVehicleOccupant(truck)
if getElementData(player,"lojistik_isci") then
local truck_plate = getElementData(source,"plate")
if truck_plate == getPlayerName(player) then else
exports['rl_bildirim']:create(player,"error","Bu dorse sana ait değil!")
setTimer(detachTrailer,200,1,truck,source)
end
end
end)

function detachTrailer(theTruck,trailer)
if (isElement(theTruck) and isElement(trailer)) then detachTrailerFromVehicle(theTruck,trailer) end
end