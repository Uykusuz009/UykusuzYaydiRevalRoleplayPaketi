addEventHandler("onClientPlayerDamage",root,function(attacker)
    if isElement(attacker) and getElementType(attacker) == "player" then
        if getElementData(attacker,"hours_played") < 5 then 
            cancelEvent() 
            if attacker == localPlayer then
                exports.rl_infobox:addBox("error", "Oyun saatiniz '5' saatin altındayken oyunculara zarar veremezsiniz.")
            end
        end
    end
end)

addEventHandler("onClientPlayerWeaponSwitch", localPlayer, function()
    local hours = getElementData(source, "hours_played") or 0
	if hours < 5 then
		setPedWeaponSlot(localPlayer, 0)
        exports.rl_infobox:addBox("error", "Silah çekebilmek için 5 saat oynaman gerekiyor.")
	end
end)