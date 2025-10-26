function kenevirAFKengel(thePlayer, cmd, code)
    local random = thePlayer:getData("kenevirafkrandom") or 0

    if not thePlayer:getData("kenevirafk") then exports.rl_infobox:addBox(thePlayer, "error", "Zaten doğrulama kodu girmişsiniz.") return end

    if tonumber(code) == tonumber(random) then
        thePlayer:setData("kenevirafk", false)
        thePlayer:setData("keneviraradi", 0)
        exports.rl_infobox:addBox(thePlayer, "success", "Doğrulama kodunu doğru girdiniz kenevir toplamaya devam edebilirsiniz.")
    else
        exports.rl_infobox:addBox(thePlayer, "error", "Yanlış doğrulama kodu girdiniz.")
    end
end
addCommandHandler("kenevironay", kenevirAFKengel)

local kenevirmalzemecol = createColSphere(-10.138671875, 54.8828125, 3.1171875, 2)

function kenevirmalzeme(thePlayer)
    if not (thePlayer:isWithinColShape(kenevirmalzemecol)) then exports.rl_infobox:addBox(thePlayer, "error", "Gerekli alanda değilsiniz.") return end
        
        local playerTeam = thePlayer:getTeam()
        local playerTeamType = playerTeam:getData("type")
        if not playerTeam then
                exports.rl_infobox:addBox(thePlayer, "error", "Herhangi bir birliğiniz yok.")
            return false
        end

        if not playerTeamType == 0 then
                exports.rl_infobox:addBox(thePlayer, "error", "İllegal birlikte değilsiniz.")
            return 
        end

        local money = thePlayer:getData("money")
        if not (money >= 15000) then exports.rl_infobox:addBox(thePlayer, "error", "Malzeme alabilmek için gerekli ücretin yok. (15000₺)") return end   
        
        exports.rl_infobox:addBox(thePlayer, "success", "Başarıyla kenevir için gerekli eldiveni satın aldınız.")
        exports.rl_global:takeMoney(thePlayer,15000)
        exports.rl_global:giveItem(thePlayer,369,1)
    end
addCommandHandler("kenevirmalzeme", kenevirmalzeme)

-- Toplama noktası: marker ve toplama alanını aynı merkez ve yarıçap ile tanımla
local COLLECT_X, COLLECT_Y, COLLECT_Z = -9.4619140625, -25.541015625, 3.1171875
local COLLECT_RADIUS = 9
local kenevirToplamaMarker = nil
local keneviraracol = createColSphere(COLLECT_X, COLLECT_Y, COLLECT_Z, COLLECT_RADIUS)

local function handleCollectKey(player)
    if isElement(player) and getElementType(player) == "player" and isElementWithinColShape(player, keneviraracol) then
        kenevirara(player)
    end
end

-- Event handler'lar resource start'ta tanımlanacak

addEvent("kenevir.topla", true)
addEventHandler("kenevir.topla", root, function()
    if client and isElement(client) then
        if getElementData(client, "kenevir:yakinda") then
            kenevirara(client)
        end
    end
end)

function kenevirara(thePlayer)
    if not (thePlayer:isWithinColShape(keneviraracol)) then exports.rl_infobox:addBox(thePlayer, "error", "Gerekli alanda değilsiniz.") return end

        local playerTeam = thePlayer:getTeam()
        local playerTeamType = playerTeam and playerTeam:getData("type") or nil
        if not playerTeam then
                exports.rl_infobox:addBox(thePlayer, "error", "Herhangi bir birliğiniz yok.")
            return false
        end

        if not playerTeamType == 0 then
                exports.rl_infobox:addBox(thePlayer, "error", "İllegal birlikte değilsiniz.")
            return 
        end
        
        if thePlayer:getData("kenevirariyor") then exports.rl_infobox:addBox(thePlayer, "error", "Şuan zaten kenevir topluyorsunuz, lütfen bekleyin.") return end
        
        if thePlayer:isInVehicle() then exports.rl_infobox:addBox(thePlayer, "error", "Araçtayken bu işlemi gerçekleştiremezsiniz.") return end

        if not (exports.rl_global:hasItem(thePlayer,369)) then exports.rl_infobox:addBox(thePlayer, "error", "Kenevir toplamak için gerekli malzemelerin bulunmuyor.") return end  
        
        thePlayer:setData("kenevirariyor", true)
        exports.rl_infobox:addBox(thePlayer, "warning", "Kenevir toplanıyor...")

        -- Oyuncuyu freeze et
        setElementFrozen(thePlayer, true)
        setPedAnimation(thePlayer, "bomber", "bom_plant_crouch_out", 10000, true, false, false, false)

        setTimer(function()
            thePlayer:setData("kenevirariyor", false)
            -- Oyuncuyu unfreeze et
            setElementFrozen(thePlayer, false)
            exports.rl_global:giveItem(thePlayer, 367, 1)
            local skill = thePlayer:getData("keneviryetenek") or 0
            thePlayer:setData("keneviryetenek", skill+1)
            exports.rl_infobox:addBox(thePlayer, "success", "Başarıyla bir adet kenevir topladın.")
        end, 10000, 1 )
    end

local kenevirisletcol = createColSphere(-25.052734375, -7.935546875, 3.1171875, 2)
local kenevirIslemeMarker = nil

local function handleProcessKey(player)
    if isElement(player) and getElementType(player) == "player" and isElementWithinColShape(player, kenevirisletcol) then
        kenevirislet(player)
    end
end

function kenevirislet(thePlayer)
    if not (thePlayer:isWithinColShape(kenevirisletcol)) then exports.rl_infobox:addBox(thePlayer, "error", "Gerekli alanda değilsiniz.") return end

        local keneviraradimuch = thePlayer:getData("keneviraradi") or 0
        
        local kactabirafk = math.random(10,20)

        if keneviraradimuch > kactabirafk then
                thePlayer:outputChat("[!] #ffffffKenevir aramaya devam edebilmek için aşağıda belirtilen parametreyi girin.", 0, 0, 255, true)

                local random = math.random(1000,9999)
                thePlayer:outputChat("[!] #ffffff/kenevironay "..random.."", 0, 0, 255, true)
                thePlayer:setData("kenevirafk", true)
                thePlayer:setData("kenevirafkrandom", random)
            return
        end

        local playerTeam = thePlayer:getTeam()
        local playerTeamType = playerTeam:getData("type")
        if not playerTeam then
                exports.rl_infobox:addBox(thePlayer, "error", "Herhangi bir birliğiniz yok.")
            return false
        end

        if not playerTeamType == 0 then
                exports.rl_infobox:addBox(thePlayer, "error", "İllegal birlikte değilsiniz.")
            return 
        end
        
        if thePlayer:getData("kenevirisletiyor") then exports.rl_infobox:addBox(thePlayer, "error", "Şuan zaten bir kenevir işletmektesiniz , lütfen bekleyin.") return end

        if not (exports.rl_global:hasItem(thePlayer,367)) then exports.rl_infobox:addBox(thePlayer, "error", "Kenevir işletmek için gerekli malzemelerin bulunmuyor.") return end      

        thePlayer:setData("kenevirisletiyor", true)
        exports.rl_infobox:addBox(thePlayer, "warning", "Kenevir işleniyor...")

        -- Oyuncuyu freeze et
        setElementFrozen(thePlayer, true)
        setPedAnimation(thePlayer, "bomber", "bom_plant_crouch_out", 6000, true, false, false, false)

        local vrandomverkrsmbnm = math.random(1,2)

        if vrandomverkrsmbnm == 1 then
            setTimer(function()
                thePlayer:setData("kenevirisletiyor", false)
                -- Oyuncuyu unfreeze et
                setElementFrozen(thePlayer, false)
                thePlayer:setData("keneviraradi", keneviraradimuch+1)
                
                if not (exports.rl_global:hasItem(thePlayer,367)) then exports.rl_infobox:addBox(thePlayer, "error", "Kenevir işletmek için gerekli malzemelerin bulunmuyor.") return end
                exports.rl_global:takeItem(thePlayer,367, 1)
                exports.rl_global:giveItem(thePlayer, 368, 1)
                exports.rl_infobox:addBox(thePlayer, "success", "Başarıyla bir adet keneviri işlettin.")
            end, 6000, 1 )
        elseif vrandomverkrsmbnm == 2 then
            setTimer(function()
                thePlayer:setData("kenevirisletiyor", false)
                -- Oyuncuyu unfreeze et
                setElementFrozen(thePlayer, false)
                thePlayer:setData("keneviraradi", keneviraradimuch+1)
                
                if not (exports.rl_global:hasItem(thePlayer,367)) then exports.rl_infobox:addBox(thePlayer, "error", "Kenevir işletmek için gerekli malzemelerin bulunmuyor.") return end
                exports.rl_global:takeItem(thePlayer,367, 1)
                exports.rl_infobox:addBox(thePlayer, "error", "Kenevir işleme işleminde başarısız oldun.")
            end, 6000, 1 )
        end
        end
addCommandHandler("kenevirislet", kenevirislet)

local kenevirsatcol = createColSphere(-2184.71484375, 2412.73046875, 5.15625, 3)

function kenevirsat(thePlayer)
    if not (thePlayer:isWithinColShape(kenevirsatcol)) then exports.rl_infobox:addBox(thePlayer, "error", "Gerekli alanda değilsiniz.") return end
        
        local playerTeam = thePlayer:getTeam()
        local playerTeamType = playerTeam:getData("type")
        if not playerTeam then
                exports.rl_infobox:addBox(thePlayer, "error", "Herhangi bir birliğiniz yok.")
            return false
        end

        if not playerTeamType == 0 then
                exports.rl_infobox:addBox(thePlayer, "error", "İllegal birlikte değilsiniz.")
            return 
        end

        local gerekli = exports.rl_global:hasItem(thePlayer, 368)
        if not (gerekli) then exports.rl_infobox:addBox(thePlayer, "error", "Kenevir satmak için gerekli eşyaların bulunmuyor.") return end   
        
        exports.rl_global:takeItem(thePlayer, 368, 1)
        exports.rl_global:giveMoney(thePlayer, 2000)
        exports.rl_infobox:addBox(thePlayer, "success", "Başarıyla bir adet kenevir sattın. (2.000₺)")
    end
addCommandHandler("kenevirsat", kenevirsat)

function kenevirseviye(thePlayer)
        local belirleyen = thePlayer:getData("keneviryetenek")

        if (belirleyen >= 0) then
            exports.rl_infobox:addBox(thePlayer, "info", "Kenevir mesleğinde birinci seviyesiniz. ("..belirleyen.." tane kenevir toplamışsınız.)")
        elseif (belirleyen >= 500) then
            exports.rl_infobox:addBox(thePlayer, "info", "Kenevir mesleğinde ikinci seviyesiniz. ("..belirleyen.." tane kenevir toplamışsınız.)")
        elseif (belirleyen >= 1000) then
            exports.rl_infobox:addBox(thePlayer, "info", "Kenevir mesleğinde üçüncü seviyesiniz. ("..belirleyen.." tane kenevir toplamışsınız.)")
        end
    end
addCommandHandler("kenevirseviye", kenevirseviye)


-- Resource başladığında marker'ları oluştur
addEventHandler("onResourceStart", resourceRoot, function()
    -- Toplama marker'ı oluştur
    kenevirToplamaMarker = exports.rl_marker:createCustomMarker(COLLECT_X, COLLECT_Y, COLLECT_Z-1, "cylinder", COLLECT_RADIUS, 139, 69, 10, "arrow", 90)
    
    -- İşleme marker'ı oluştur  
    kenevirIslemeMarker = exports.rl_marker:createCustomMarker(-25.052734375, -7.935546875, 3.1171875-1, "cylinder", 1.5, 160, 82, 45, "arrow", 160)
    
    if kenevirToplamaMarker and kenevirIslemeMarker then
        -- Event handler'ları marker'lar oluşturulduktan sonra ekle
        addEventHandler("onMarkerHit", kenevirToplamaMarker, function(hitElement, matchingDimension)
            if getElementType(hitElement) ~= "player" or not matchingDimension then return end
            setElementData(hitElement, "kenevir:yakinda", true)
            exports.rl_infobox:addBox(hitElement, "info", "Kenevir toplamak için E'ye basın.")
            bindKey(hitElement, "e", "down", handleCollectKey)
        end)

        addEventHandler("onMarkerHit", kenevirIslemeMarker, function(hitElement, matchingDimension)
            if getElementType(hitElement) ~= "player" or not matchingDimension then return end
            setElementData(hitElement, "kenevir:isleme_yakinda", true)
            exports.rl_infobox:addBox(hitElement, "info", "Kenevir işlemek için E'ye basın.")
            bindKey(hitElement, "e", "down", handleProcessKey)
        end)

        addEventHandler("onMarkerLeave", kenevirToplamaMarker, function(hitElement, matchingDimension)
            if getElementType(hitElement) ~= "player" or not matchingDimension then return end
            setElementData(hitElement, "kenevir:yakinda", false)
            unbindKey(hitElement, "e", "down", handleCollectKey)
        end)

        addEventHandler("onMarkerLeave", kenevirIslemeMarker, function(hitElement, matchingDimension)
            if getElementType(hitElement) ~= "player" or not matchingDimension then return end
            setElementData(hitElement, "kenevir:isleme_yakinda", false)
            unbindKey(hitElement, "e", "down", handleProcessKey)
        end)
        
    end
end)