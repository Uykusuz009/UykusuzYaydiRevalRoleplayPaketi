mysql = exports.rl_mysql
connection = mysql:getConnection()

pvp = {}

-- Oyuncu ateş ettiğinde kontrol et
addEventHandler("onPlayerWeaponFire", root, function(weapon)
    -- Sadece silahlar için (mermi atanlar)
    if weapon >= 22 and weapon <= 34 then
        local target = getPedTarget(source) -- Vurulan hedefi al
        
        -- Eğer hedef bir oyuncuysa ve kendisi değilse
        if target and getElementType(target) == "player" and target ~= source then
            -- PvP modunu aktif et
            if not pvp[source] or pvp[source] <= 0 then
                pvp[source] = 40
                setElementData(source, "player.pvp", true)
            else
                pvp[source] = pvp[source] + 1
            end
        end
    end
end)

-- PvP süresini azaltan timer
setTimer(function()
    for _, player in ipairs(getElementsByType("player")) do 
        if pvp[player] and player:getData("logged") then
            if pvp[player] <= 0 then
                pvp[player] = nil
                setElementData(player, "player.pvp", false)
                triggerClientEvent(player, "pvpTable", player, 0)
            else
                pvp[player] = pvp[player] - 1
                triggerClientEvent(player, "pvpTable", player, pvp[player])
            end
        elseif not pvp[player] then
            setElementData(player, "player.pvp", false)
            triggerClientEvent(player, "pvpTable", player, 0)
        end
    end
end, 1000, 0)