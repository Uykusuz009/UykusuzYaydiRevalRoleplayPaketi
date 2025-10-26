----------------------------------------
--/ Reval Project 20.10.2020       	   | 
--/ Script Yapımcısı: LargeS           |
--/ Pes etmek, cesaretsizlerin işidir. |
----------------------------------------

local mysql = exports["rl_mysql"]

function tuningBasla(localPlayer)
    if getPedOccupiedVehicle(localPlayer) and getElementData(localPlayer, "job") == 7 and getElementInterior(localPlayer) == 24 then
        triggerClientEvent("tuningGoster", localPlayer, localPlayer)
    else
        outputChatBox("[Reval]:#FFFFFF Lütfen tuning yapacağınız Araçın içerisine binin, Araç Mekanikçisi olduğunuzdan emin olun veya Tamirhane interiorunun içine girin.",localPlayer,100,0,255,true)
    end
end
addCommandHandler("tuning", tuningBasla)

function motorset(localPlayer, komut, seviye)
    local araba = getPedOccupiedVehicle(localPlayer)

    if not seviye then
        outputChatBox("[Reval]:#FFFFFF Lütfen ayarlamak istediğiniz seviyeyi giriniz.",localPlayer,100,0,255,true)
    return end

    if exports.rl_integration:isPlayerAdmin1(localPlayer) then
        dbExec(exports.rl_mysql:getConnection(), "UPDATE vehicles SET motor = '"..seviye.."' WHERE id = '"..getElementData(araba,"dbid").."'")
        outputChatBox("[Reval]:#FFFFFF Başarı ile motor seviyesini "..seviye.." olarak ayarladınız.",localPlayer,100,0,255,true)
    end
end
addCommandHandler("motorayarla", motorset)

function turboset(localPlayer, komut, seviye)
    local araba = getPedOccupiedVehicle(localPlayer)

    if not seviye then
        outputChatBox("[Reval]:#FFFFFF Lütfen ayarlamak istediğiniz seviyeyi giriniz.",localPlayer,100,0,255,true)
    return end

    if exports.rl_integration:isPlayerManager(localPlayer) then
        dbExec(exports.rl_mysql:getConnection(), "UPDATE vehicles SET turbo = '"..seviye.."' WHERE id = '"..getElementData(araba,"dbid").."'")       
        outputChatBox("[Reval]:#FFFFFF Başarı ile turbo seviyesini "..seviye.." olarak ayarladınız.",localPlayer,100,0,255,true)
    end
end
addCommandHandler("turboayarla", turboset)

function suspansiyonset(localPlayer, komut, seviye)
    local araba = getPedOccupiedVehicle(localPlayer)

    if not seviye then
        outputChatBox("[Reval]:#FFFFFF Lütfen ayarlamak istediğiniz seviyeyi giriniz.",localPlayer,100,0,255,true)
    return end

    if exports.rl_integration:isPlayerAdmin1(localPlayer) then
        dbExec(exports.rl_mysql:getConnection(), "UPDATE vehicles SET suspansiyon = '"..seviye.."' WHERE id = '"..getElementData(araba,"dbid").."'")
        outputChatBox("[Reval]:#FFFFFF Başarı ile süspansiyon seviyesini "..seviye.." olarak ayarladınız.",localPlayer,100,0,255,true)
    end
end
addCommandHandler("suspansiyonayarla", suspansiyonset)

function frenset(localPlayer, komut, seviye)
    local araba = getPedOccupiedVehicle(localPlayer)

    if not seviye then
        outputChatBox("[Reval]:#FFFFFF Lütfen ayarlamak istediğiniz seviyeyi giriniz.",localPlayer,100,0,255,true)
    return end

    if exports.rl_integration:isPlayerManager(localPlayer) then
        dbExec(exports.rl_mysql:getConnection(), "UPDATE vehicles SET fren = '"..seviye.."' WHERE id = '"..getElementData(araba,"dbid").."'")
        outputChatBox("[Reval]:#FFFFFF Başarı ile fren seviyesini "..seviye.." olarak ayarladınız.",localPlayer,100,0,255,true)
    end
end
addCommandHandler("frenayarla", frenset)

function motorKontrol(localPlayer)
    local veh = getPedOccupiedVehicle(localPlayer)
    if not veh then return end

    local query = dbQuery(exports.rl_mysql:getConnection(), "SELECT `motor` FROM `vehicles` WHERE `id`=?", getElementData(veh, "dbid"))
    local result = dbPoll(query, -1)
    if not result or #result == 0 then return end

    local motorvar = tonumber(result[1].motor)

    if getElementData(veh, "motorok") or getElementData(veh, "motorok2") or getElementData(veh, "motorok3") then
        return
    end

    if motorvar == 1 then
        setElementData(veh, "motorok", true)
        setVehicleHandling(veh, "dragCoeff", (getVehicleHandling(veh).dragCoeff) - 0.1)
		setVehicleHandling(veh, "maxVelocity", (getVehicleHandling(veh).maxVelocity) + 10)
    elseif motorvar == 2 then
        setElementData(veh, "motorok2", true)
        setVehicleHandling(veh, "dragCoeff", (getVehicleHandling(veh).dragCoeff) - 0.3)
		setVehicleHandling(veh, "maxVelocity", (getVehicleHandling(veh).maxVelocity) + 25)
    elseif motorvar == 3 then
        setElementData(veh, "motorok3", true)
		setElementData(veh, "egzozluke", true)
        setVehicleHandling(veh, "dragCoeff", (getVehicleHandling(veh).dragCoeff) - 0.5)
		setVehicleHandling(veh, "maxVelocity", (getVehicleHandling(veh).maxVelocity ) + 40)
    end
end
addEventHandler("onVehicleEnter", getRootElement(), motorKontrol)

function turboKontrol(localPlayer)
    local veh = getPedOccupiedVehicle(localPlayer)
    if not veh then return end

    local query = dbQuery(exports.rl_mysql:getConnection(), "SELECT `turbo` FROM `vehicles` WHERE `id`=?", getElementData(veh, "dbid"))
    local result = dbPoll(query, -1)
    if not result or #result == 0 then return end

    local turbovar = tonumber(result[1].turbo)

    if getElementData(veh, "turbook") or getElementData(veh, "turbook2") or getElementData(veh, "turbook3") then
        return
    end

    if turbovar == 1 then
        setElementData(veh, "turbook", true)
        setVehicleHandling(veh, "engineAcceleration", (getVehicleHandling(veh).engineAcceleration) + 2)
    elseif turbovar == 2 then
        setElementData(veh, "turbook2", true)
        setVehicleHandling(veh, "engineAcceleration", (getVehicleHandling(veh).engineAcceleration) + 5)
    elseif turbovar == 3 then
        setElementData(veh, "turbook3", true)
        setElementData(veh, "turboluke", true)
        setVehicleHandling(veh, "engineAcceleration", (getVehicleHandling(veh).engineAcceleration) + 7)
    end
end
addEventHandler("onVehicleEnter", getRootElement(), turboKontrol)

function suspansiyonKontrol(localPlayer)
    local veh = getPedOccupiedVehicle(localPlayer)
    if not veh then return end

    local query = dbQuery(exports.rl_mysql:getConnection(), "SELECT `suspansiyon` FROM `vehicles` WHERE `id`=?", getElementData(veh, "dbid"))
    local result = dbPoll(query, -1)
    if not result or #result == 0 then return end

    local susvar = tonumber(result[1].suspansiyon)

    if getElementData(veh, "susok") or getElementData(veh, "susok2") or getElementData(veh, "susok3") then
        return
    end

    if susvar == 1 then
        setElementData(veh, "susok", true)
        setVehicleHandling(veh, "suspensionLowerLimit", (getVehicleHandling(veh).suspensionLowerLimit) + 0.07)
    elseif susvar == 2 then
        setElementData(veh, "susok2", true)
        setVehicleHandling(veh, "suspensionLowerLimit", (getVehicleHandling(veh).suspensionLowerLimit) + 0.09)
    elseif susvar == 3 then
        setElementData(veh, "susok3", true)
        setVehicleHandling(veh, "suspensionLowerLimit", (getVehicleHandling(veh).suspensionLowerLimit) + 0.11)
    end
end
addEventHandler("onVehicleEnter", getRootElement(), suspansiyonKontrol)

function frenKontrol(localPlayer)
    local veh = getPedOccupiedVehicle(localPlayer)
    if not veh then return end

    local query = dbQuery(exports.rl_mysql:getConnection(), "SELECT `fren` FROM `vehicles` WHERE `id`=?", getElementData(veh, "dbid"))
    local result = dbPoll(query, -1)
    if not result or #result == 0 then return end

    local frenvar = tonumber(result[1].fren)

    if getElementData(veh, "frenok") or getElementData(veh, "frenok2") or getElementData(veh, "frenok3") then
        return
    end

    if frenvar == 1 then
        setElementData(veh, "frenok", true)
        setVehicleHandling(veh, "brakeDeceleration", (getVehicleHandling(veh).brakeDeceleration) + 10)
    elseif frenvar == 2 then
        setElementData(veh, "frenok2", true)
        setVehicleHandling(veh, "brakeDeceleration", (getVehicleHandling(veh).brakeDeceleration) + 20)
    elseif frenvar == 3 then
        setElementData(veh, "frenok3", true)
        setVehicleHandling(veh, "brakeDeceleration", (getVehicleHandling(veh).brakeDeceleration) + 30)
    end
end
addEventHandler("onVehicleEnter", getRootElement(), frenKontrol)

function motor1Set()
    local araba = getPedOccupiedVehicle(source)
    local para = exports.rl_global:getMoney(source)
    if para < 100000 then
        outputChatBox("[Reval]:#FFFFFF Bu parçayı Araça takabilmeniz için yeterli para üzerinizde bulunmamaktadır.",source,100,0,255,true)
    return end

    outputChatBox("[Reval]:#FFFFFFStreet Pack Motor adlı ürünü başarı ile Araça taktınız.",source,100,0,255,true)
    exports.rl_global:takeMoney(source, 100000)
    dbExec(exports.rl_mysql:getConnection(),"UPDATE vehicles SET motor = '1' WHERE id = '"..getElementData(araba,"dbid").."'")
end
addEvent( "motorvar1", true )
addEventHandler( "motorvar1", getRootElement(), motor1Set )

function motor2Set()
    local araba = getPedOccupiedVehicle(source)
    local para = exports.rl_global:getMoney(source)
    if para < 250000 then
        outputChatBox("[Reval]:#FFFFFF Bu parçayı Araça takabilmeniz için yeterli para üzerinizde bulunmamaktadır.",source,100,0,255,true)
    return end

    dbExec(exports.rl_mysql:getConnection(), "UPDATE vehicles SET motor = '2' WHERE id = '"..getElementData(araba,"dbid").."'")
    exports.rl_global:takeMoney(source, 250000)
    outputChatBox("[Reval]:#FFFFFFPro Pack Motor adlı ürünü başarı ile Araça taktınız.",source,100,0,255,true)
end
addEvent( "motorvar2", true )
addEventHandler( "motorvar2", getRootElement(), motor2Set )

function motor3Set()
    local araba = getPedOccupiedVehicle(source)
    local para = exports.rl_global:getMoney(source)
    if para < 500000 then
        outputChatBox("[Reval]:#FFFFFF Bu parçayı Araça takabilmeniz için yeterli para üzerinizde bulunmamaktadır.",source,100,0,255,true)
    return end

    outputChatBox("[Reval]:#FFFFFFExtreme Pack Motor adlı ürünü başarı ile Araça taktınız.",source,100,0,255,true)
    dbExec(exports.rl_mysql:getConnection(),"UPDATE vehicles SET motor = '3' WHERE id = '"..getElementData(araba,"dbid").."'")
    exports.rl_global:takeMoney(source, 500000)
end
addEvent( "motorvar3", true )
addEventHandler( "motorvar3", getRootElement(), motor3Set )

function turbo1Set()
    local araba = getPedOccupiedVehicle(source)
    local para = exports.rl_global:getMoney(source)
    if para < 50000 then
        outputChatBox("[Reval]:#FFFFFF Bu parçayı Araça takabilmeniz için yeterli para üzerinizde bulunmamaktadır.",source,100,0,255,true)
    return end

    outputChatBox("[Reval]:#FFFFFFStreet Pack Turbo adlı ürünü başarı ile Araça taktınız.",source,100,0,255,true)
    exports.rl_global:takeMoney(source, 50000)
    dbExec(exports.rl_mysql:getConnection(),"UPDATE vehicles SET turbo = '1' WHERE id = '"..getElementData(araba,"dbid").."'")
end
addEvent( "turbovar1", true )
addEventHandler( "turbovar1", getRootElement(), turbo1Set )

function turbo2Set()
    local araba = getPedOccupiedVehicle(source)
    local para = exports.rl_global:getMoney(source)
    if para < 100000 then
        outputChatBox("[Reval]:#FFFFFF Bu parçayı Araça takabilmeniz için yeterli para üzerinizde bulunmamaktadır.",source,100,0,255,true)
    return end

    dbExec(exports.rl_mysql:getConnection(), "UPDATE vehicles SET turbo = '2' WHERE id = '"..getElementData(araba,"dbid").."'")
    exports.rl_global:takeMoney(source, 100000)
    outputChatBox("[Reval]:#FFFFFFPro Pack Turbo adlı ürünü başarı ile Araça taktınız.",source,100,0,255,true)
end
addEvent( "turbovar2", true )
addEventHandler( "turbovar2", getRootElement(), turbo2Set )

function turbo3Set()
    local araba = getPedOccupiedVehicle(source)
    local para = exports.rl_global:getMoney(source)
    if para < 150000 then
        outputChatBox("[Reval]:#FFFFFF Bu parçayı Araça takabilmeniz için yeterli para üzerinizde bulunmamaktadır.",source,100,0,255,true)
    return end

    outputChatBox("[Reval]:#FFFFFFExtreme Pack Turbo adlı ürünü başarı ile Araça taktınız.",source,100,0,255,true)
    dbExec(exports.rl_mysql:getConnection(),"UPDATE vehicles SET turbo = '3' WHERE id = '"..getElementData(araba,"dbid").."'")
    exports.rl_global:takeMoney(source, 150000)
end
addEvent( "turbovar3", true )
addEventHandler( "turbovar3", getRootElement(), turbo3Set )

function suspansiyon1Set()
    local araba = getPedOccupiedVehicle(source)
    local para = exports.rl_global:getMoney(source)
    if para < 5000 then
        outputChatBox("[Reval]:#FFFFFF Bu parçayı Araça takabilmeniz için yeterli para üzerinizde bulunmamaktadır.",source,100,0,255,true)
    return end

    outputChatBox("[Reval]:#FFFFFFStreet Pack Suspansiyon adlı ürünü başarı ile Araça taktınız.",source,100,0,255,true)
    dbExec(exports.rl_mysql:getConnection(),"UPDATE vehicles SET suspansiyon = '1' WHERE id = '"..getElementData(araba,"dbid").."'")
    exports.rl_global:takeMoney(source, 5000)
end
addEvent( "suspansiyonvar1", true )
addEventHandler( "suspansiyonvar1", getRootElement(), suspansiyon1Set )

function suspansiyon2Set()
    local araba = getPedOccupiedVehicle(source)
    local para = exports.rl_global:getMoney(source)
    if para < 10000 then
        outputChatBox("[Reval]:#FFFFFF Bu parçayı Araça takabilmeniz için yeterli para üzerinizde bulunmamaktadır.",source,100,0,255,true)
    return end
    outputChatBox("[Reval]:#FFFFFFPro Pack Suspansiyon adlı ürünü başarı ile Araça taktınız.",source,100,0,255,true)
     dbExec(exports.rl_mysql:getConnection(),"UPDATE vehicles SET suspansiyon = '2' WHERE id = '"..getElementData(araba,"dbid").."'")
    exports.rl_global:takeMoney(source, 10000)
end
addEvent( "suspansiyonvar2", true )
addEventHandler( "suspansiyonvar2", getRootElement(), suspansiyon2Set )

function suspansiyon3Set()
    local araba = getPedOccupiedVehicle(source)
    local para = exports.rl_global:getMoney(source)
    if para < 15000 then
        outputChatBox("[Reval]:#FFFFFF Bu parçayı Araça takabilmeniz için yeterli para üzerinizde bulunmamaktadır.",source,100,0,255,true)
    return end
     dbExec(exports.rl_mysql:getConnection(),"UPDATE vehicles SET suspansiyon = '3' WHERE id = '"..getElementData(araba,"dbid").."'")
    exports.rl_global:takeMoney(source, 15000)
    outputChatBox("[Reval]:#FFFFFFExtreme Pack Suspansiyon adlı ürünü başarı ile Araça taktınız.",source,100,0,255,true)
end
addEvent( "suspansiyonvar3", true )
addEventHandler( "suspansiyonvar3", getRootElement(), suspansiyon3Set )

function fren1Set()
    local araba = getPedOccupiedVehicle(source)
    local para = exports.rl_global:getMoney(source)
    if para < 30000 then
        outputChatBox("[Reval]:#FFFFFF Bu parçayı Araça takabilmeniz için yeterli para üzerinizde bulunmamaktadır.",source,100,0,255,true)
    return end
    outputChatBox("[Reval]:#FFFFFFStreet Pack Fren adlı ürünü başarı ile Araça taktınız.",source,100,0,255,true)
     dbExec(exports.rl_mysql:getConnection(),"UPDATE vehicles SET fren = '1' WHERE id = '"..getElementData(araba,"dbid").."'")
    exports.rl_global:takeMoney(source, 30000)
end
addEvent( "frenvar1", true )
addEventHandler( "frenvar1", getRootElement(), fren1Set )

function fren2Set()
    local araba = getPedOccupiedVehicle(source)
    local para = exports.rl_global:getMoney(source)
    if para < 60000 then
        outputChatBox("[Reval]:#FFFFFF Bu parçayı Araça takabilmeniz için yeterli para üzerinizde bulunmamaktadır.",source,100,0,255,true)
    return end
    
    outputChatBox("[Reval]:#FFFFFFPro Pack Fren adlı ürünü başarı ile Araça taktınız.",source,100,0,255,true)
     dbExec(exports.rl_mysql:getConnection(),"UPDATE vehicles SET fren = '2' WHERE id = '"..getElementData(araba,"dbid").."'")
    exports.rl_global:takeMoney(source, 60000)
end
addEvent( "frenvar2", true )
addEventHandler( "frenvar2", getRootElement(), fren2Set )

function fren3Set()
    local araba = getPedOccupiedVehicle(source)
    local para = exports.rl_global:getMoney(source)
    if para < 100000 then
        outputChatBox("[Reval]:#FFFFFF Bu parçayı Araça takabilmeniz için yeterli para üzerinizde bulunmamaktadır.",source,100,0,255,true)
    return end

    outputChatBox("[Reval]:#FFFFFFExtreme Pack Fren adlı ürünü başarı ile Araça taktınız.",source,100,0,255,true)
     dbExec(exports.rl_mysql:getConnection(),"UPDATE vehicles SET fren = '3' WHERE id = '"..getElementData(araba,"dbid").."'")
    exports.rl_global:takeMoney(source, 100000)
end
addEvent( "frenvar3", true )
addEventHandler( "frenvar3", getRootElement(), fren3Set )

function modifiyeGoster(localPlayer)
    local araba = getPedOccupiedVehicle(localPlayer)

    if not araba then
        outputChatBox("[Reval]:#FFFFFF Menüyü görüntüleyebilmek için lütfen aracın içerisine binin.", localPlayer, 100,0,255, true)
        return
    end

    local aracID = getElementData(araba, "dbid")
    if not aracID then
        outputChatBox("[Reval]:#FFFFFF Araç veritabanı kimliği bulunamadı.", localPlayer, 100,0,255, true)
        return
    end

    -- Retrieve values from the database
    local query = dbQuery(exports.rl_mysql:getConnection(), "SELECT `motor`, `turbo`, `suspansiyon`, `camber`, `fren` FROM `vehicles` WHERE `id`=?", aracID)
    local results, numRows = dbPoll(query, -1)

    if numRows > 0 then
        local data = results[1]
		local motor = tonumber(data["motor"]) or 0
        local turbo = tonumber(data["turbo"]) or 0
        local suspansiyon = tonumber(data["suspansiyon"]) or 0
		local camber = tonumber(data["camber"]) or 0
        local fren = tonumber(data["fren"]) or 0


        outputChatBox("[Reval]:#FFFFFF Reval Tuning Menüsüne Hoşgeldiniz!", localPlayer, 100,0,255, true)
		outputChatBox("[Reval]:#FFFFFF Motor: " .. motor, localPlayer, 100,0,255, true)
        outputChatBox("[Reval]:#FFFFFF Turbo: " .. turbo, localPlayer, 100,0,255, true)
        outputChatBox("[Reval]:#FFFFFF Süspansiyon: " .. suspansiyon, localPlayer, 100,0,255, true)
		outputChatBox("[Reval]:#FFFFFF Camber: " .. camber, localPlayer, 100,0,255, true)
        outputChatBox("[Reval]:#FFFFFF Fren: " .. fren, localPlayer, 100,0,255, true)
    else
        outputChatBox("[Reval]:#FFFFFF Araç bilgileri veritabanında bulunamadı.", localPlayer, 100,0,255, true)
    end
end
addCommandHandler("tuningler", modifiyeGoster)

function getVehicleRPM(vehicle)
    local vehicleRPM = 0
        if (vehicle) then  
            if (getVehicleEngineState(vehicle) == true) then
                if getVehicleCurrentGear(vehicle) > 0 then             
                    vehicleRPM = math.floor(((getElementSpeed(vehicle, "km/h") / getVehicleCurrentGear(vehicle)) * 160) + 0.5) 
                    if (vehicleRPM < 650) then
                        vehicleRPM = math.random(650, 750)
                    elseif (vehicleRPM >= 9000) then
                        vehicleRPM = math.random(9000, 9900)
                    end
                else
                    vehicleRPM = math.floor((getElementSpeed(vehicle, "km/h") * 160) + 0.5)
                    if (vehicleRPM < 650) then
                        vehicleRPM = math.random(650, 750)
                    elseif (vehicleRPM >= 9000) then
                        vehicleRPM = math.random(9000, 9900)
                    end
                end
            else
                vehicleRPM = 0
            end
    
            return tonumber(vehicleRPM)
        else
            return 0
        end
    end

function getElementSpeed(theElement, unit)
    assert(isElement(theElement), "Bad argument 1 @ getElementSpeed (element expected, got " .. type(theElement) .. ")")
    local elementType = getElementType(theElement)
    assert(elementType == "player" or elementType == "ped" or elementType == "object" or elementType == "vehicle" or elementType == "projectile", "Invalid element type @ getElementSpeed (player/ped/object/vehicle/projectile expected, got " .. elementType .. ")")
    assert((unit == nil or type(unit) == "string" or type(unit) == "number") and (unit == nil or (tonumber(unit) and (tonumber(unit) == 0 or tonumber(unit) == 1 or tonumber(unit) == 2)) or unit == "m/s" or unit == "km/h" or unit == "mph"), "Bad argument 2 @ getElementSpeed (invalid speed unit)")
    unit = unit == nil and 0 or ((not tonumber(unit)) and unit or tonumber(unit))
    local mult = (unit == 0 or unit == "m/s") and 50 or ((unit == 1 or unit == "km/h") and 180 or 111.84681456)
    return (Vector3(getElementVelocity(theElement)) * mult).length
end

function sesVeriliyorGeriEgzoz()
    triggerClientEvent("egzozsesgeldi", client, root)
end
addEvent( "egzozsesyollabakam", true )
addEventHandler( "egzozsesyollabakam", getRootElement(), sesVeriliyorGeriEgzoz )

function sesVeriliyorGeriTurbo()
    triggerClientEvent("turbosesgeldi", client, root)
end
addEvent( "turbosesyollabakam", true )
addEventHandler( "turbosesyollabakam", getRootElement(), sesVeriliyorGeriTurbo )