--37: İşlenmemiş ekstazi. / 676: İşlenmiş ekstazi. / 2121: Siyah kimyasal eldiven.

function ekstaziAFKengel(thePlayer, cmd, code)
    local random = thePlayer:getData("ekstaziafkrandom") or 0

    if not thePlayer:getData("ekstaziafk") then exports["rl_bildirim"]:addNotification(thePlayer, "Zaten doğrulama kodu girmişsiniz.", "error") return end

    if tonumber(code) == tonumber(random) then
        thePlayer:setData("ekstaziafk", false)
        thePlayer:setData("ekstaziaradi", 0)
        exports["rl_bildirim"]:addNotification(thePlayer, "Doğrulama kodunu doğru girdiniz ekstazi toplamaya devam edebilirsiniz.", "success")
    else
        exports["rl_bildirim"]:addNotification(thePlayer, "Yanlış doğrulama kodu girdiniz.", "error")
    end
end
addCommandHandler("ekstazionay", ekstaziAFKengel)

local ekstazimalzemecol = createColSphere(1547.171875, 31.9912109375, 24.140625, 2)

function ekstazimalzeme(thePlayer)
    if not (thePlayer:isWithinColShape(ekstazimalzemecol)) then exports["rl_bildirim"]:addNotification(thePlayer, "Gerekli alanda değilsiniz.", "error") return end
        
        local playerTeam = thePlayer:getTeam()
        local playerTeamType = playerTeam:getData("type")
        if not playerTeam then
                exports["rl_bildirim"]:addNotification(thePlayer, "Herhangi bir birliğiniz yok.", "error")
            return false
        end

        if not playerTeamType == 0 then
                exports["rl_bildirim"]:addNotification(thePlayer, "İllegal birlikte değilsiniz.", "error")
            return 
        end

        local money = thePlayer:getData("money")
        if not (money >= 15000) then exports["rl_bildirim"]:addNotification(thePlayer, "Malzeme alabilmek için gerekli ücretin yok. (15000₺)", "error") return end   
        
        exports["rl_bildirim"]:addNotification(thePlayer, "Başarıyla ekstazi için gerekli eldiveni satın aldınız.", "success")
        exports.rl_global:takeMoney(thePlayer,15000)
        exports.rl_global:giveItem(thePlayer,2121,1)
    end
addCommandHandler("ekstazimalzeme", ekstazimalzeme)

local ekstazipaketicol = createColSphere(1566.5869140625, 18.1376953125, 24.1640625, 2)

function ekstazipaketi(thePlayer)
    if not (thePlayer:isWithinColShape(ekstazipaketicol)) then exports["rl_bildirim"]:addNotification(thePlayer, "Gerekli alanda değilsiniz.", "error") return end
        
        local playerTeam = thePlayer:getTeam()
        local playerTeamType = playerTeam:getData("type")
        if not playerTeam then
                exports["rl_bildirim"]:addNotification(thePlayer, "Herhangi bir birliğiniz yok.", "error")
            return false
        end

        if not playerTeamType == 0 then
                exports["rl_bildirim"]:addNotification(thePlayer, "İllegal birlikte değilsiniz.", "error")
            return 
        end

        local money = thePlayer:getData("money")
        if not (money >= 1000) then exports["rl_bildirim"]:addNotification(thePlayer, "Malzeme alabilmek için gerekli ücretin yok. (1000₺)", "error") return end   
        
        exports["rl_bildirim"]:addNotification(thePlayer, "Başarıyla ekstazi için gerekli eldiveni satın aldınız.", "success")
        exports.rl_global:takeMoney(thePlayer,1000)
        exports.rl_global:giveItem(thePlayer,675,1)
    end
addCommandHandler("ekstazipaketi", ekstazipaketi)

local ekstaziaracol = createColSphere(1439.4091796875, -90.328125, 19.037771224976, 15)

function ekstaziara(thePlayer)
    if not (thePlayer:isWithinColShape(ekstaziaracol)) then exports["rl_bildirim"]:addNotification(thePlayer, "Gerekli alanda değilsiniz.", "error") return end

        local ekstaziaradimuch = thePlayer:getData("ekstaziaradi") or 0
        
        local kactabirafk = math.random(10,20)

        if ekstaziaradimuch > kactabirafk then
                thePlayer:outputChat("[!] #ffffffEkstazi aramaya devam edebilmek için aşağıda belirtilen parametreyi girin.", 0, 0, 255, true)

                local random = math.random(1000,9999)
                thePlayer:outputChat("[!] #ffffff/ekstazionay "..random.."", 0, 0, 255, true)
                thePlayer:setData("ekstaziafk", true)
                thePlayer:setData("ekstaziafkrandom", random)
            return
        end

        local playerTeam = thePlayer:getTeam()
        local playerTeamType = playerTeam:getData("type")
        if not playerTeam then
                exports["rl_bildirim"]:addNotification(thePlayer, "Herhangi bir birliğiniz yok.", "error")
            return false
        end

        if not playerTeamType == 0 then
                exports["rl_bildirim"]:addNotification(thePlayer, "İllegal birlikte değilsiniz.", "error")
            return 
        end
        
        if thePlayer:getData("ekstaziariyor") then exports["rl_bildirim"]:addNotification(thePlayer, "Şuan zaten ekstazi aramaktasınız, lütfen bekleyin.", "error") return end
        
        if thePlayer:isInVehicle() then exports["rl_bildirim"]:addNotification(thePlayer, "Araçtayken bu işlemi gerçekleştiremezsiniz.", "error") return end

        if not (exports.rl_global:hasItem(thePlayer,2121)) then exports["rl_bildirim"]:addNotification(thePlayer, "Ekstazi toplamak için gerekli malzemelerin bulunmuyor.", "error") return end  
        
        thePlayer:setData("ekstaziariyor", true)

        setPedAnimation(thePlayer, "bomber", "bom_plant_crouch_out", 10000, true, false, false, false)

        setTimer(function()
            thePlayer:setData("ekstaziariyor", false)
            thePlayer:setData("ekstaziaradi", ekstaziaradimuch+1)
        end, 11000, 1 )
        
        local skill = thePlayer:getData("ekstaziyetenek") or 0

        local vrandomverkrsmbnm = math.random(1,2)
        
        if (skill >= 0) then
            if vrandomverkrsmbnm == 1 then
    
                exports["rl_bildirim"]:addNotification(thePlayer, "Ekstazi toplanıyor...", "warning")

                setTimer(function()
                exports.rl_global:giveItem(thePlayer, 37, 1)
                exports["rl_bildirim"]:addNotification(thePlayer, "Başarıyla bir adet ekstazi topladın.", "success")
                thePlayer:setData("ekstaziyetenek", skill+1)
                end, 10000, 1 )
            elseif vrandomverkrsmbnm == 2 then
    
                exports["rl_bildirim"]:addNotification(thePlayer, "Ekstazi toplanıyor...", "warning")

                setTimer(function()
                exports["rl_bildirim"]:addNotification(thePlayer, "Ekstazi toplamada başarısız oldun.", "error")
                end, 10000, 1 )
            end
        end
    end
addCommandHandler("ekstaziara", ekstaziara)

local ekstazipaketlecol = createColSphere(1545.73046875, 16.5830078125, 24.132335662842, 2)

function ekstazipaketle(thePlayer)
    if not (thePlayer:isWithinColShape(ekstazipaketlecol)) then exports["rl_bildirim"]:addNotification(thePlayer, "Gerekli alanda değilsiniz.", "error") return end
        
        local playerTeam = thePlayer:getTeam()
        local playerTeamType = playerTeam:getData("type")
        if not playerTeam then
                exports["rl_bildirim"]:addNotification(thePlayer, "Herhangi bir birliğiniz yok.", "error")
            return false
        end

        if not playerTeamType == 0 then
                exports["rl_bildirim"]:addNotification(thePlayer, "İllegal birlikte değilsiniz.", "error")
            return 
        end

        local gerekli = exports.rl_global:hasItem(thePlayer, 37)
		local gerekli2 = exports.rl_global:hasItem(thePlayer, 675)
        if not (gerekli) or not (gerekli2) then exports["rl_bildirim"]:addNotification(thePlayer, "Ekstazi Paketlemek için gerekli malzemen bulunmuyor.", "error") return end   
        
        exports.rl_global:takeItem(thePlayer,37)
		exports.rl_global:takeItem(thePlayer,675)
		exports.rl_global:giveItem(thePlayer,676, 1)
        exports["rl_bildirim"]:addNotification(thePlayer, "Başarıyla bir adet ekstazi paketledin.", "success")
    end
addCommandHandler("ekstazipaketle", ekstazipaketle)

local ekstazisatcol = createColSphere(1565.9326171875, 23.41796875, 24.1640625, 3)

function ekstazisat(thePlayer)
    if not (thePlayer:isWithinColShape(ekstazisatcol)) then exports["rl_bildirim"]:addNotification(thePlayer, "Gerekli alanda değilsiniz.", "error") return end
        
        local playerTeam = thePlayer:getTeam()
        local playerTeamType = playerTeam:getData("type")
        if not playerTeam then
                exports["rl_bildirim"]:addNotification(thePlayer, "Herhangi bir birliğiniz yok.", "error")
            return false
        end

        if not playerTeamType == 0 then
                exports["rl_bildirim"]:addNotification(thePlayer, "İllegal birlikte değilsiniz.", "error")
            return 
        end

        local gerekli = exports.rl_global:hasItem(thePlayer, 676)
        if not (gerekli) then exports["rl_bildirim"]:addNotification(thePlayer, "Ekstazi satmak için gerekli eşyaların bulunmuyor.", "error") return end   
        
        exports.rl_global:takeItem(thePlayer,676)
        exports.rl_global:giveMoney(thePlayer,3500)
        exports["rl_bildirim"]:addNotification(thePlayer, "Başarıyla bir adet ekstazi sattın.", "success")
    end
addCommandHandler("ekstazisat", ekstazisat)

function ekstaziseviye(thePlayer)
        local belirleyen = thePlayer:getData("ekstaziyetenek")

        if (belirleyen >= 0) then
            exports["rl_bildirim"]:addNotification(thePlayer, "Ekstazi mesleğinde birinci seviyesiniz. ("..belirleyen.." tane ekstazi toplamışsınız.)", "info")
        elseif (belirleyen >= 500) then
            exports["rl_bildirim"]:addNotification(thePlayer, "Ekstazi mesleğinde ikinci seviyesiniz. ("..belirleyen.." tane ekstazi toplamışsınız.)", "info")
        elseif (belirleyen >= 1000) then
            exports["rl_bildirim"]:addNotification(thePlayer, "Ekstazi mesleğinde üçüncü seviyesiniz. ("..belirleyen.." tane ekstazi toplamışsınız.)", "info")
        end
    end
addCommandHandler("ekstaziseviye", ekstaziseviye)