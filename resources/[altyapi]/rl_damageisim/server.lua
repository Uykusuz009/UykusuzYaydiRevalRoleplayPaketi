addEventHandler("onPlayerDamage", root, function(attacker, weapon, bodypart, loss)
	
    if attacker and getElementType(attacker) == "player" and attacker ~= source then

        local damage = tonumber(loss)
        local armor = getPedArmor(source)
        local health = getElementHealth(source)
        
        if damage <= armor then
            damage = damage-armor
            triggerClientEvent(attacker, "damage:info", attacker, armor, source, weapon, bodypart, loss, "armor", "attacker")
            triggerClientEvent(source, "damage:info", source, armor, attacker, weapon, bodypart, loss, "armor", "damaged")
        end
        

        if damage <= health and damage > 0 then
            damage = health-armor
            triggerClientEvent(attacker, "damage:info", attacker, health, source, weapon, bodypart, loss, "health", "attacker")
            triggerClientEvent(source, "damage:info", source, health, attacker, weapon, bodypart, loss, "health", "damaged")
        end

    end

end)


