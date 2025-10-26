local cache = {{"broom", 326},}

function stopBroomDamage(attacker, weapon, bodypart)
    if (weapon == 15) then
        cancelEvent()
    end
end
addEventHandler("onClientPlayerDamage", getLocalPlayer(), stopBroomDamage)

addEventHandler("onClientResourceStart", resourceRoot,
    function()
        for k,v in pairs(cache) do
            local txd = engineLoadTXD("cleaner/components/"..v[1]..".txd")
            engineImportTXD(txd, v[2])
            local dff = engineLoadDFF("cleaner/components/"..v[1]..".dff", 0)
            engineReplaceModel (dff, v[2])
        end
    end
)