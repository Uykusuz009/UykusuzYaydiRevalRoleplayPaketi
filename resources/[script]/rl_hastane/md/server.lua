local region = createColSphere(1592.228515625, 1798.484375, 2083.376953125, 3)
setElementInterior(region, 0)
setElementDimension(region, 104)

addCommandHandler("tedaviol", function(player)
    if not getElementData(player, "logged") then
        outputChatBox("#FF0000[!] #FFFFFFGiriş yapmamışsınız.", player, 255, 255, 255, true)
        return
    end
    
    if not isElementWithinColShape(player, region) then
        outputChatBox("#FF0000[!] #FFFFFFTedavi bölgesinde olmalısınız.", player, 255, 255, 255, true)
        return
    end
    
    local can = getElementHealth(player)
    local injured = getElementData(player, "injured") or 0
    local rk = getElementData(player, "rk") or 0
    local faction = getElementData(player, "faction") or 0
    
    if injured ~= 1 and can > 70 and rk ~= 1 then
        outputChatBox("#FF0000[!] #FFFFFFYaralı olmadığınız için tedavi olamadınız.", player, 255, 255, 255, true)
        return
    end
    
    local vip = getElementData(player, "vip") or 0
    
    if faction == 1 then
        outputChatBox("#00FF00[!] #FFFFFFDevlet görevlisi olduğunuz için tedaviniz ücretsiz yapılmıştır.", player, 255, 255, 255, true)
        setElementHealth(player, 100)
        setElementData(player, "injured", nil)
        setElementData(player, "rk", 0)
        -- triggerEvent("player.injure.stop", player)
        return
    end
    
    -- VIP kontrolü
    if vip >= 1 then
        outputChatBox("#00FF00[!] #FFFFFFVIP olduğunuz için ücretsiz tedavi oldunuz.", player, 255, 255, 255, true)
        setElementHealth(player, 100)
        setElementData(player, "injured", nil)
        setElementData(player, "rk", 0)
        -- triggerEvent("player.injure.stop", player)
    else
        if exports.rl_global:takeMoney(player, 750) then
            outputChatBox("#00FF00► #FFFFFF750$ ödeyerek tedavi oldunuz.", player, 255, 255, 255, true)
            setElementHealth(player, 100)
            setElementData(player, "injured", nil)
            setElementData(player, "rk", 0)
            -- triggerEvent("player.injure.stop", player)
        else
            outputChatBox("#FF0000[!] #FFFFFFTedavi olabilmeniz için 250$ ödeme yapmanız gerekmektedir.", player, 255, 255, 255, true)
        end
    end
end)