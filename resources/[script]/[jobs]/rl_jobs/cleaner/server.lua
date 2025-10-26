addCommandHandler('süpür', function(player, cmd)
    if player:getData('job') == 4 then
        if isPedInVehicle(player) then else
            if not player:getData('job.cleaning') then
                player:setData('job.cleaning', true)
                giveWeapon(player, 15, 1, true)
                player.weaponSlot = 1
                player:setAnimation('POLICE', 'CopTraf_Left', -1, true, false, false, false)
                setTimer(function(thePlayer)
                    thePlayer:setAnimation()
                    thePlayer:setData('job.cleaning', false)
                    takeWeapon(thePlayer, 15)
                    exports.rl_global:giveMoney(thePlayer, 100)
                    thePlayer:outputChat('►#D0D0D0 Bu meslek turundan 100₺ para kazandınız.',195,184,116,true)
                end, 7500, 1, player)
            end
        end
    end
end)