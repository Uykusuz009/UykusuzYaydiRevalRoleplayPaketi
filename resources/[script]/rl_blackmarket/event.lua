addEventHandler('onResourceStop', resourceRoot, function(res)
    if res == getThisResource() then
        for k=1, #peds do
            destroyElement(ped[k])
        end
    end
end)

addEvent('bmarket:silah',true)
addEventHandler('bmarket:silah',root,function(price,id)
    if exports.rl_global:hasMoney(source, price) then
        dbid = tonumber(getElementData(source, 'dbid'))
        serial = exports.rl_global:createWeaponSerial( 1, tonumber(id)*2, dbid)
        give, error = exports.rl_global:giveItem(source, 115, tonumber(id)..":"..serial..":"..getWeaponNameFromID(tonumber(id)).."::")
        if give then
            exports.rl_global:takeMoney(source, price)
            outputChatBox('#FFFFFFBaşarıyla '..getWeaponNameFromID(tonumber(id))..' adlı silahı satın aldın.',source,127,127,127,true)
        else
             outputChatBox('#FFFFFFÜstünde yeterli yer yok.',source,127,127,127,true)
        end
    end
end)

addEvent('bmarket:uyusturucu',true)
addEventHandler('bmarket:uyusturucu',root,function(name,price,id)
    if exports.rl_global:hasMoney(source, tonumber(price)) then
        give, error = exports.rl_global:giveItem(source, tonumber(id), 1)
        if give then
            exports.rl_global:takeMoney(source, tonumber(price))
            outputChatBox('#FFFFFFBaşarıyla '..name..' adlı uyuşturucuyu satın aldın.',source,127,127,127,true)
        else
            outputChatBox('#FFFFFFÜstünde yeterli yer yok.',source,127,127,127,true)
        end
    end
end)

addEvent('bmarket:diger',true)
addEventHandler('bmarket:diger',root,function(name,price,id)
    if exports.rl_global:hasMoney(source, tonumber(price)) then
        give, error = exports.rl_global:giveItem(source, tonumber(id), 1)
        if give then
            exports.rl_global:takeMoney(source, tonumber(price))
             outputChatBox('#FFFFFFBaşarıyla '..name..' adlı eşyayı satın aldın.',source,127,127,127,true)
        else
             outputChatBox('#FFFFFFÜstünde yeterli yer yok.',source,127,127,127,true)
        end
    end
end)