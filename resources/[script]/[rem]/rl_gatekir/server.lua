local bomba = {}
local enesep = nil
local affectedByGate = {}

local secretHandle = 'some_shit_that_is_really_secured'

function changeProtectedElementData(thePlayer, index, newvalue)
	setElementData(thePlayer, index, newvalue)
end

function changeProtectedElementDataEx(thePlayer, index, newvalue, sync, nosyncatall)
	if (thePlayer) and (index) then
		setElementData(thePlayer, index, newvalue)
		return true
	end
	return false
end

-- addEventHandler ( "onResourceStart", getRootElement(),function()
	-- for k, theGate in ipairs(getElementsByType("object")) do
-- setElementData(theGate,"gateKapat",0)
-- setElementData(theGate,"bombaP",0)
-- setElementData(theGate,"halatG",0)
-- end
-- end)

function bombaKur(thePlayer)
	local vehicle = getPedOccupiedVehicle( thePlayer )
    if not vehicle then else return  outputChatBox("[!] #f0f0f0Arabanın içinde bomba kuramazsın.", thePlayer, 255, 0, 0, true) end
			if bomba[thePlayer] then
			 outputChatBox("[!]#ffffff Zaten bir adet bomba kurdunuz.", thePlayer, 255, 0, 0, true)
			return end 			
	local posX, posY, posZ = getElementPosition(thePlayer)
	local dimension = getElementDimension(thePlayer)
	for k, theGate in ipairs(getElementsByType("object")) do
		local x, y = getElementPosition(theGate)
		local distance = getDistanceBetweenPoints2D(posX, posY, x, y)
		local cdimension = getElementDimension(theGate)
			local dbid = tonumber(getElementData(theGate, "gate:id"))
		if (distance<=3) and (dimension==cdimension) and dbid then
			if getElementData(theGate,"bombaP") == 1 then
			 outputChatBox("[!]#ffffff Gate zaten patlamış.", thePlayer, 255, 0, 0, true)
			return end 		
			if getElementData(theGate,"halatG") == 1 then
			 outputChatBox("[!]#ffffff Gate zaten patlamış.", thePlayer, 255, 0, 0, true)
			return end 
			outputChatBox("[!] #ffffffBaşrıyla gatenin önüne bombayı kurdun şimdi uzaklaş ve patlat. (Gate ID #" .. dbid .. ") ", thePlayer, 0, 255, 0,true)
			local xx, yy, zz = getElementPosition(thePlayer)
			bomba[thePlayer] = createObject(1654, xx, yy+1, zz-0.60)
			enesep = theGate
			setElementFrozen(thePlayer,true)
			setPedAnimation(thePlayer,"bomber", "bom_plant_loop")
			setElementData(theGate,"bombaP",1)
			setElementData(theGate,"halatG",1)
			setTimer(function()
			exports.rl_global:removeAnimation(thePlayer)	
			setElementFrozen(thePlayer,false)
			end,1200,1)
		
		end
	end
	
end
addEvent("gatekir:bomba", true)
addEventHandler("gatekir:bomba", getRootElement(), bombaKur)

function bombaKur(thePlayer )
if getElementData(enesep,"bombaP") == 1 then
	-- if isPedInVehicle(thePlayer) then return false end
			local bx, by, bz = getElementPosition(bomba[thePlayer])
			createExplosion ( bx, by, bz, 11, thePlayer )
			if isElement(bomba[thePlayer]) then
			destroyElement(bomba[thePlayer])
			bomba[thePlayer] = false
		end
				if not secondtime then
		secondtime = false
	end
	--exports.rl_anticheat:changeProtectedElementDataEx(enesep, "gate:busy", false, false)
	local isGateBusy = getElementData(enesep, "gate:busy")
	if not (isGateBusy) or (secondtime) then
		--exports.rl_anticheat:changeProtectedElementDataEx(enesep, "gate:busy", true, false)
		local gateParameters = getElementData(enesep, "gate:parameters")	
		local dbid = tonumber(getElementData(enesep, "gate:id"))
		local newX, newY, newZ, offsetRX, offsetRY, offsetRZ, movementTime, autocloseTime
		local startPosition = gateParameters["startPosition"]
		local endPosition = gateParameters["endPosition"]
		if not gateParameters["state"] then 
			newX = endPosition[1]
			newY = endPosition[2]
			newZ = endPosition[3]
			offsetRX = startPosition[4] - endPosition[4] 
			offsetRY = startPosition[5] - endPosition[5] 
			offsetRZ = startPosition[6] - endPosition[6] 
			gateParameters["state"] = true
			local x, y, z = getElementPosition(enesep)
			local int = getElementInterior(enesep)
			local dim = getElementDimension(enesep)
			movementTime = gateParameters["movementTime"] * 100
			setElementData(enesep,"gateKapat",1)
			logkaydet(source,dbid)

		offsetRX = fixRotation(offsetRX)
		offsetRY = fixRotation(offsetRY)
		offsetRZ = fixRotation(offsetRZ)
		
		moveObject ( enesep, movementTime, newX, newY, newZ, offsetRX, offsetRY, offsetRZ )
			
		end		
	end
	else
	outputChatBox("[!] #ffffffİlk önce bomba kurunuz!",source,255,0,0,true)
end
end
addEvent("gatekir:patlat", true)
addEventHandler("gatekir:patlat", getRootElement(), bombaKur)

function kapatGate()
if getElementData(enesep,"gateKapat") == 1 then
				if not secondtime then
		secondtime = false
	end
	local isGateBusy = getElementData(enesep, "gate:busy")
	if (isGateBusy) or (secondtime) then
		--exports.rl_anticheat:changeProtectedElementDataEx(enesep, "gate:busy", true, false)
		local gateParameters = getElementData(enesep, "gate:parameters")
		
		local newX, newY, newZ, offsetRX, offsetRY, offsetRZ, movementTime, autocloseTime
		
		local startPosition = gateParameters["startPosition"]
		local endPosition = gateParameters["endPosition"]
		local enes = gateParameters["state"]
		if not gateParameters["state"] then 
			newX = startPosition[1]
			newY = startPosition[2]
			newZ = startPosition[3]
			offsetRX = endPosition[4] - startPosition[4] 
			offsetRY = endPosition[5] - startPosition[5] 
			offsetRZ = endPosition[6] - startPosition[6] 
			gateParameters["state"] = false
			local x, y, z = getElementPosition(enesep)
			local int = getElementInterior(enesep)
			local dim = getElementDimension(enesep)
		movementTime = gateParameters["movementTime"] * 100
		offsetRX = fixRotation(offsetRX)
		offsetRY = fixRotation(offsetRY)
		offsetRZ = fixRotation(offsetRZ)
		setElementData(enesep,"gateKapat",0)
		setElementData(enesep,"halatG",0)
		setElementData(enesep,"bombaP",0)
		
		
		moveObject ( enesep, movementTime, newX, newY, newZ, offsetRX, offsetRY, offsetRZ )
			
			end		
		end
		else
		outputChatBox("[!] #ffffffİlk önce gate kapısını kır.",source,255,0,0,true)
	end
end
addEvent("gatekir:kapat", true)
addEventHandler("gatekir:kapat", getRootElement(), kapatGate)

function halatkir(thePlayer)
				if not secondtime then
		secondtime = false
	end
	--exports.rl_anticheat:changeProtectedElementDataEx(enesep, "gate:busy", false, false)
	local isGateBusy = getElementData(enesep, "gate:busy")
	if not (isGateBusy) or (secondtime) then
		--exports.rl_anticheat:changeProtectedElementDataEx(enesep, "gate:busy", true, false)
		local gateParameters = getElementData(enesep, "gate:parameters")	
		local dbid = tonumber(getElementData(enesep, "gate:id"))
		local newX, newY, newZ, offsetRX, offsetRY, offsetRZ, movementTime, autocloseTime
		local startPosition = gateParameters["startPosition"]
		local endPosition = gateParameters["endPosition"]
		if not gateParameters["state"] then 
			newX = endPosition[1]
			newY = endPosition[2]
			newZ = endPosition[3]
			offsetRX = startPosition[4] - endPosition[4] 
			offsetRY = startPosition[5] - endPosition[5] 
			offsetRZ = startPosition[6] - endPosition[6] 
			gateParameters["state"] = true
			local x, y, z = getElementPosition(enesep)
			local int = getElementInterior(enesep)
			local dim = getElementDimension(enesep)
			movementTime = gateParameters["movementTime"] * 100
			setElementData(enesep,"gateKapat",1)
			logkaydet (thePlayer,dbid)

		offsetRX = fixRotation(offsetRX)
		offsetRY = fixRotation(offsetRY)
		offsetRZ = fixRotation(offsetRZ)
		
		moveObject ( enesep, movementTime, newX, newY, newZ, offsetRX, offsetRY, offsetRZ )
		end
	end
end

function halatBagla(thePlayer)
local vehicle = getPedOccupiedVehicle( thePlayer )
if vehicle then else return  outputChatBox("[!] #f0f0f0Arabanın içinde olmalısın.", thePlayer, 255, 0, 0, true) end
	local posX, posY, posZ = getElementPosition(thePlayer)
	local dimension = getElementDimension(thePlayer)
	for k, theGate in ipairs(getElementsByType("object")) do
		if getElementData(theGate,"halatG") == 0 then
		local x, y = getElementPosition(theGate)
		local distance = getDistanceBetweenPoints2D(posX, posY, x, y)
		local cdimension = getElementDimension(theGate)
			local dbid = tonumber(getElementData(theGate, "gate:id"))
		if (distance<=10) and (dimension==cdimension) and dbid then
	if getElementData(thePlayer,"faction") == 1 then else return end

			local vehid = getElementModel ( vehicle )
	if tonumber(vehid) == 528 or tonumber(vehid) == 427 then
			local x, y, z = getElementPosition(thePlayer)
			local alan = createColSphere ( x, y, z, 5)
			outputChatBox("[!] #ffffffHalatı bağladın şimdi gaza bas ve kapıyı kır!",thePlayer,0,0,255,true)
			enesep = theGate

addEventHandler ( "onColShapeLeave", alan, function()
outputChatBox("[!] #ffffffHalatı başarıyla kopardın!",thePlayer,0,255,0,true)
setElementData(theGate,"bombaP",1)
destroyElement(alan)
halatkir(thePlayer)
end)
				else
				outputChatBox("[!] #ffffffBu işlemi yapabilmek için zırhlı bir araçda olman gerek",thePlayer,255,0,0,true)
				end
			end
		end
	end
end
addEvent("gatekir:halat", true)
addEventHandler("gatekir:halat", getRootElement(), halatBagla)




function fixRotation(value)
	local invert = true
	if value < 0 then
		--invert = true
		--value = value - value - value
		while value < -360 do
			value = value + 360
		end
		if value < -180 then
			value = value + 180
			value = value - value - value
		end
	else
		while value > 360 do
			value = value - 360
		end
		if value > 180 then
			value = value - 180
			value = value - value - value
		end
	end

	return value
end



---------------------------------
function logkaydet (oyuncu,id)
-------------- LOG SISTEMI --------------
	local hours = getRealTime().hour
	local minutes = getRealTime().minute
	local seconds = getRealTime().second
	local day = getRealTime().monthday
	local month = getRealTime().month+1
	local year = getRealTime().year+1900
	local dosyaismi = "/log.txt"
	local dosya = olusturulmus_txt(dosyaismi)
	local size = fileGetSize(dosya)
	fileSetPos(dosya, size)
	fileWrite(dosya, "Hesap : ".. getPlayerName(oyuncu) .." | Gate ID : ".. id .."  | Tarih : ".. day .."."..month.."."..year.." ")
	fileFlush(dosya)
	fileClose(dosya)
end


 function olusturulmus_txt(dosyaismi)
	local dosya = nil
	if fileExists ( dosyaismi ) then
		dosya = fileOpen(dosyaismi)
	else
		dosya = fileCreate(dosyaismi)
	end
	return dosya
end