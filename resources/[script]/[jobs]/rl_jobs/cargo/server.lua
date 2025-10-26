local deliveryPoint = Marker(2734.646484375, -2466.0380859375, 15.5, 'arrow', 2, 28, 28, 125, 255)
local regions = {}
local object = {}
local zones = {
    {2781.681640625, -2448.3583984375, 13.635155677795},
    {2782.5849609375, -2463.841796875, 13.634934425354},
    {2790.7197265625, -2463.958984375, 13.632947921753},
    {2790.8271484375, -2448.568359375, 13.632921218872},
    {2796.3896484375, -2448.4326171875, 13.631563186646},
    {2793.0908203125, -2448.3583984375, 13.632369041443},
    {2793.0908203125, -2463.609375, 13.632369041443},
    {2784.9189453125, -2463.7041015625, 13.634364128113},
    {2784.91796875, -2448.4384765625, 13.634364128113},
}

for index, value in ipairs(zones) do
    local i = #regions + 1
    if not regions[i] then
        regions[i] = {}
    end
    regions[i][1] = ColShape.Sphere(value[1], value[2], value[3], 2.5)
end

addCommandHandler('paketle', function(player, cmd)
        for index, value in ipairs(regions) do
            if player:isWithinColShape(value[1]) then
                if not player:getData('job.packed') then
                    if player:getData('job.packeded') then return false end
                    local controls = {'sprint', 'jump', 'action', 'next_weapon', 'previous_weapon', 'aim_weapon', 'fire'}
                    for _, v in ipairs(controls) do
                        toggleControl(player, v, false)
                    end
                    player:setData('job.packed', true)
                    player:setAnimation('CASINO', 'dealone', -1, true, false, false, false)
                    setTimer(function(thePlayer)
                        thePlayer:outputChat('►#D0D0D0 Kargo kutusunu paketlediniz, lütfen teslim noktasına bırakın.',195,184,116,true)
                        thePlayer:setAnimation()
                        thePlayer:setData('job.packed', false)
                        thePlayer:setData('job.packeded', true)
                        thePlayer:setAnimation('CARRY', 'crry_prtial', 0, true, false, true, true)
                        object[thePlayer] = Object(935, thePlayer.position.x, thePlayer.position.y, thePlayer.position.z)
                        object[thePlayer].scale = 0.6
                        attachElements(object[thePlayer], thePlayer, 0, 0.4, 0.2)
                        object[thePlayer].collisions = false
                    end, 10000, 1, player)
                end
            end
        end
end)

addEventHandler("onMarkerHit", deliveryPoint, function(hitElement)
    if hitElement.type == 'player' then
            if hitElement:getData('job.packeded') then
                hitElement:setAnimation('bomber', 'bom_plant', -1, false, false, false, false)
                hitElement:outputChat('►#D0D0D0 Kargo kutusunu teslim noktasına bıraktınız.',195,184,116,true)
                hitElement:setData('job.packeded', false)
				exports.rl_global:giveMoney(hitElement, 750)
                if isElement(object[hitElement]) then
                    object[hitElement]:destroy()
                end
                local controls = {'sprint', 'jump', 'action', 'next_weapon', 'previous_weapon', 'aim_weapon', 'fire'}
                for _, v in ipairs(controls) do
                    toggleControl(hitElement, v, true)
                end
            end
    end
end)