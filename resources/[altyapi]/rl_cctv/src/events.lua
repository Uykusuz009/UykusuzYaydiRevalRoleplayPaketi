local boneAttach = exports.rl_bones
local objects = {}
local region = createColSphere(1556.4794921875, -1685.1123046875, 16.1953125, 7)

addCommandHandler('cctv', function(player, command)
    if isElementWithinColShape(player, region) then
        if player:getData('faction') == 1 then
            player.frozen = true
            if not objects[player] then
                objects[player] = createObject(2886, 0, 0, 0)
            end
--            boneAttach:attach(objects[player], player, 12, -0.05, 0.02, 0.02, 20, -90, -10)
          --  triggerClientEvent(player,'mdc.anim',player, player,true)
            triggerClientEvent(player,'cctv.display',player)
        end
    end
end)



addEvent('cctv.stop', true)
addEventHandler('cctv.stop', root, function()
    if source then
--        boneAttach:detach(objects[source])
        if isElement(objects[source]) then
            objects[source]:destroy()
        end
        objects[source] = nil
        setCameraTarget(source)
        source.frozen = false
        source:setPosition(1556.4794921875, -1685.1123046875, 16.1953125)
    end
end)