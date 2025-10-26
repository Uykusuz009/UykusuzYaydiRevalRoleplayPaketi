endMarker = createMarker(-1968.28467, -2434.79688, 29, 'checkpoint',4.0, 0, 255,	0, 0)
addEventHandler("onMarkerHit",endMarker,function(element)
    if element.type == 'player' then
        if element.vehicle then
            if element.vehicle.model == 422 and element.vehicle:getData('job') == 1 then
                if vehData[element.vehicle].tree >= 1 then
                    for i,v in ipairs ( getAttachedElements ( element.vehicle ) ) do
                        if v.type ~= 'marker' then
                            destroyElement(v)
                        end
                    end
                    element:outputChat('►#D6D6D6 '..vehData[element.vehicle].tree..' adet odun sattınız karşılığında '..vehData[element.vehicle].tree*moneyPerVIP[tonumber((element:getData("vip") or 0))]..'$ para aldınız.', 0, 180, 0, true)
                    exports.rl_global:giveMoney(element,vehData[element.vehicle].tree*moneyPerVIP[tonumber((element:getData("vip") or 0))])
                    vehData[element.vehicle].tree = 0
                else
                    element:outputChat('►#D6D6D6 Aracında hiç kütük yok', 180, 0, 0, true)
                end
            end
        end
    end
end)

function startTree()
    for i, v in ipairs(treePositions) do
       local tree = Object(654,v[1],v[2],v[3] - 1)
       treeTable[tree] = {
           ['owner'] = -1,
           ['hp']    =  0,
           ['tree']  =  6,
       }
       tree:setData('tree >> text',( treeTable[tree]['hp'])..'/6')
    end
end
addEventHandler('onResourceStart',getResourceRootElement(getThisResource()),startTree)

addEventHandler('onVehicleEnter', root, function(player)
    if objCache[player] then
        player:outputChat('►#D6D6D6 Elinde odun varken araca binemezsin', 180, 0, 0, true)
        cancelEvent()
    elseif source.model == 422 and source:getData('job') == 1 then
        if source:getData('jobowner') and source:getData('jobowner') ~= (player:getData('dbid') or 0) then
            player:outputChat('►#D6D6D6 Bu meslek aracını başkası kullanıyor.', 180, 0, 0, true)
            removePedFromVehicle(player)
        else
            if not vehData[source] then
                vehData[source] = {
                    tree = 0,
                    marker = false,
                }
            end
            source:setData('jobowner', (player:getData('dbid') or 0))
            playerData[player] = {}
            playerData[player].veh = player.vehicle 
            local x,y,z = getElementPosition(source)
            vehData[source].marker = createMarker(x, y, z, "cylinder", 2, 255,0,0,0)
            vehData[source].marker:setData('marker >> vehicle', source)
            attachElements(vehData[source].marker,source,0,-3.7,0,0,0,0)
            addEventHandler("onMarkerHit",vehData[source].marker,function(element)
                if element.type == 'player' then
                    if (source:getData('marker >> vehicle'):getData('jobowner') or 0) == (element:getData('dbid') or 0) then
                        if objCache[element] then
                            setPedAnimation(player , 'carry', 'putdwn', -1 , false , false)
                            Timer(setPedAnimation, 1000, 1,player)
                            setCustomControl(element,true)
                            addVehicleTree(element, source:getData('marker >> vehicle'))
                        end
                    end
                end
            end)
        end
    end
end)

addEvent(getResourceName(getThisResource())..' >> damageTree', true)
addEventHandler(getResourceName(getThisResource())..' >> damageTree',root,function(player, tree)
    if treeTable[tree]['owner'] == -1 then
        treeTable[tree]['owner'] = (player:getData('dbid') or 20)
        treeTable[tree]['hp']    = treeTable[tree]['hp'] + 1
        tree:setData('tree >> text',( treeTable[tree]['hp'])..'/6')
    elseif treeTable[tree]['owner']  == (player:getData('dbid') or 20) then
        if (treeTable[tree]['hp'] + 1) > 6 then return end
        treeTable[tree]['hp']    = treeTable[tree]['hp'] + 1
        tree:setData('tree >> text',( treeTable[tree]['hp'])..'/6')
        if (treeTable[tree]['hp']) == 6 then
            triggerClientEvent(root , getResourceName(getThisResource())..' >> fallTree', root , tree)
            tree:setData('tree >> text','Kalan kütük sayısı: '..treeTable[tree]['tree'])
        return false end
    elseif treeTable[tree]['owner'] ~= (player:getData('dbid') or 20) and treeTable[tree]['owner'] ~= -1 then
        player:outputChat('►#D6D6D6 Bu ağaçın sahibi sen olmadığın için, hasar veremezsin.', 180, 0, 0, true)
    end
end)


function clickTree( theButton, theState, player )
    if theButton == "left" and theState == "down" then
       if source.type == "object" then
            if source.model == 654 then
                if treeTable[source]['owner'] == (player:getData('dbid') or 20) then
                    if getDistanceBetweenPoints3D(player.position, source.position) < 3 then
                    if (treeTable[source]['hp']) > 5 then
                        if objCache[player] then
                            player:outputChat('►#D6D6D6 Zaten elinde odun bulunmakta', 180, 0, 0, true)
                            return false
                        end
                        if not playerData[player] then
                            playerData[player] = {}
                        end
                        if isTimer(playerData[player]['timer']) then
                            player:outputChat('►#D6D6D6 Zaten şuanda odun topluyorsun', 180, 0, 0, true)
                            return false
                        end
                        setPedAnimation(player , "camera", "camcrch_idleloop", -1 , true , false)
                        if (treeTable[source]['tree'] - 1) == 0 then
                            source:destroy()
                        end
                        treeTable[source]['tree'] = treeTable[source]['tree'] - 1
                        if isElement(source) then
                            source:setData('tree >> text','Kalan kütük sayısı: '..(treeTable[source]['tree'] or 0))
                        end
                        playerData[player]['timer'] = Timer(function()
                        setPedAnimation(player)
                        syncHandWoods(player)
                        setPedAnimation(player,"CARRY","crry_prtial",0,true,true,false,true) 
                        setCustomControl(player,false)
                        end, 4000, 1)
                        end
                    end
                end
            end
        end
    end
end
addEventHandler( "onElementClicked", root, clickTree ) 

function syncHandWoods(p)
    if not objCache[p] then
        local obj = createObject(1463, p.position, 0, 0, 0)
        setObjectScale(obj, 0.4)
        objCache[p] = obj
        exports.rl_bone_attach:attach(obj, p, 12, 0.25, 0.05, 0.15, -90, 0, -20)
    end
end

function deSyncHandWoods(p)
    if objCache[p] then
        objCache[p]:destroy()
        objCache[p] = nil
        collectgarbage("collect")
    end
end


function setCustomControl(player,val)
    toggleControl(player,"jump", val)
    toggleControl(player,"fire", val)
    toggleControl(player,"action", val)
    toggleControl(player,"crouch", val)
    toggleControl(player,"sprint", val)
end

local offsets = {
    {-0.5,-0.8,0}, -- 1
    {0,-0.8,0}, -- 2
    {0.5,-0.8,0}, -- 3
    {0.25,-1.5,0}, -- 4
    {-0.25,-1.5,0}, -- 5
    {-0.5,-2.1,0}, -- 6
    {0,-2.1,0}, -- 7
    {0.5,-2.1,0}, -- 8
    {-0.25,-1.1,0.15,180}, -- 9
    {0.25,-1.1,0.15,180}, -- 10
    {-0.25,-1.8,0.15,180}, -- 11
    {0.25,-1.8,0.15,180}, -- 12
}

function addVehicleTree(player,vehicle)
    if (vehData[vehicle].tree) == 18 then
        player:outputChat('►#D6D6D6 Araç tamamen dolu olduğu için daha fazla odun koyamazsın', 180, 0, 0, true)
        return false
    end
    if (vehData[vehicle].tree + 1) > #offsets then
        vehData[vehicle].tree = vehData[vehicle].tree + 1
        deSyncHandWoods(player)
        return false
    end

    obj = createObject(1463, vehicle.position, 0, 0, 0)
    obj.collisions = false
    if vehData[vehicle].tree  == 0 then
        obj:attach(vehicle, unpack(offsets[1]))
        setObjectScale(obj, 0.4)
        vehData[vehicle].tree = vehData[vehicle].tree + 1
        deSyncHandWoods(player)
    return end
    obj:attach(vehicle, unpack(offsets[vehData[vehicle].tree]))
    setObjectScale(obj, 0.4)
    vehData[vehicle].tree = vehData[vehicle].tree + 1
    deSyncHandWoods(player)
end

addEvent("jobtree.giveaxe", true)
addEventHandler("jobtree.giveaxe", getRootElement(), function(player)
    local weaponid = 12
    local mySerial = exports.rl_global:createWeaponSerial( 1, getElementData(player, "dbid"), getElementData(player, "dbid"))
    if exports.rl_global:giveItem(player, 115, weaponid..":"..mySerial..":"..getWeaponNameFromID(weaponid).."::") then
        outputChatBox("►#ffffff Başarıyla baltanızı aldınız.",player,0,255,0,true)
    else
        outputChatBox("►#ffffff Bir hata oluştu yeniden deneyin.",player,0,255,0,true)
    end
end)