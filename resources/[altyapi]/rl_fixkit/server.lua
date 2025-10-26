local fixTimers = {}

function fixWithKit(thePlayer)
	local theVehicle = getNearestVehicle(thePlayer)
	if (theVehicle) then
		if getPedOccupiedVehicle(thePlayer) then
			outputChatBox("[!]#FFFFFF Araçtayken bu işlevi gerçekleştiremezsiniz.", thePlayer, 255, 0, 0, true)
			playSoundFrontEnd(thePlayer, 4)
			return
		end
		
		if isTimer(fixTimers[thePlayer]) then
			outputChatBox("[!]#FFFFFF Zaten tamir işlemi yapıyorsunuz.", thePlayer, 255, 0, 0, true)
			playSoundFrontEnd(thePlayer, 4)
			return
		end
		
		if exports.rl_global:hasItem(thePlayer, 221) then 
			local currVehHp = getElementHealth(theVehicle)
			if currVehHp >= 1000 then
				outputChatBox("[!]#FFFFFF Aracın tamir edilmesine ihtiyaç yok.", thePlayer, 255, 0, 0, true)
				playSoundFrontEnd(thePlayer, 4)
				return
			end
			
			setElementFrozen(thePlayer, true)
			outputChatBox("[!]#FFFFFF Araç tamir ediliyor.", thePlayer, 0, 0, 255, true)
			exports.rl_global:applyAnimation(thePlayer, "bomber", "bom_plant", 7000, true, true, false)
			fixTimers[thePlayer] = setTimer(function()
				outputChatBox("[!]#FFFFFF Aracı başarıyla tamir ettiniz.", thePlayer, 0, 255, 0, true)
				exports.rl_global:removeAnimation(thePlayer)
				setElementData(theVehicle, "enginebroke", 0)
				if currVehHp + 200 >= 1000 then 
					setElementHealth(theVehicle, 1000)
				end
				setElementHealth(theVehicle, currVehHp + 200)
				fixVehicle(theVehicle) -- Araçtaki tüm hasarları kaldır
				setVehicleWheelStates(theVehicle, 0, 0, 0, 0) -- Tüm tekerlekleri düzelt
				setVehicleEngineState(theVehicle, true) -- Motoru aç
				-- Eğer oyuncunun dead değeri 1 ise frozen false yapma
				if getElementData(thePlayer, "dead") ~= 1 then
					setElementFrozen(thePlayer, false)
				end
			end, 7000, 1)
		else
			outputChatBox("[!]#FFFFFF Tamir kiti olmadan bu işlemi yapamazsınız.", thePlayer, 255, 0, 0, true)
			playSoundFrontEnd(thePlayer, 4)
		end
    else
        outputChatBox("[!]#FFFFFF Yanınızda bir araç olmadan bu komutu kullanamazsınız.", thePlayer, 255, 0, 0, true)
		playSoundFrontEnd(thePlayer, 4)
    end
end
addCommandHandler("tamirkit", fixWithKit, false, false)

function getNearestVehicle(thePlayer)  
    local x, y, z = getElementPosition(thePlayer)  
    local prevDistance  
    local nearestVehicle  
    for i, v in ipairs( getElementsByType( "vehicle" ) ) do  
        local distance = getDistanceBetweenPoints3D( x, y, z, getElementPosition( v ) )  
        if (distance <= 5) then
            prevDistance = distance  
            nearestVehicle = v 
        end  
    end  
    return nearestVehicle or false  
end

-- Tamir Kit Satıcı Pedini Oluştur
local kitPed = createPed(120, 318.287109375, -106.365234375, 1011.0078125, 180.18125915527)
setElementDimension(kitPed, 135)
setElementInterior(kitPed, 40)
setElementFrozen(kitPed, true)

function handleKitAlCommand(thePlayer, cmd, arg)
    local px, py, pz = getElementPosition(thePlayer)
    local pedx, pedy, pedz = getElementPosition(kitPed)
    local dist = getDistanceBetweenPoints3D(px, py, pz, pedx, pedy, pedz)
    if getElementDimension(thePlayer) ~= getElementDimension(kitPed) or getElementInterior(thePlayer) ~= getElementInterior(kitPed) or dist > 3 then
        outputChatBox("[!]#FFFFFF Tamir kiti satıcısına daha yakın olmalısınız.", thePlayer, 255, 0, 0, true)
        return
    end

    if not arg then
        outputChatBox("===================================", thePlayer, 176, 176, 176, true)
        outputChatBox(" Tamir Kit (Sınırsız Kullanım) - 75.000$", thePlayer, 255, 255, 255, true)
        outputChatBox("===================================", thePlayer, 176, 176, 176, true)
        outputChatBox("Kullanım: /kital tamir", thePlayer, 255, 255, 255, true)
        return
    end

    if arg == "tamir" then
        if exports.rl_global:hasItem(thePlayer, 221) then
            outputChatBox("[!]#FFFFFF Üzerinizde zaten bir tamir kiti var.", thePlayer, 255, 0, 0, true)
            return
        end
        if exports.rl_global:hasMoney(thePlayer, 75000) then
            exports.rl_global:takeMoney(thePlayer, 75000)
            exports.rl_global:giveItem(thePlayer, 221, 1)
            outputChatBox("[!]#FFFFFF Sınırsız Kullanmlı Tamir Kiti satın aldınız. Arabanın yakınına gidip /tamirkit yazarak kullanabilirsiniz.", thePlayer, 0, 255, 0, true)
        else
            outputChatBox("[!]#FFFFFF Yeterli paranız yok.", thePlayer, 255, 0, 0, true)
        end
        return
    end
end
addCommandHandler("kital", handleKitAlCommand, false, false)

