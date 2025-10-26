dutyRegion = ColShape.Sphere(605.7490234375, -21.80859375, 1000.9014892578, 2.5)
dutyRegion.interior = 24

fixvehRegion = ColShape.Sphere(624.744140625, -22.6806640625, 1002.0377197266, 2.5)
fixvehRegion.interior = 24

sprayRegion = ColShape.Sphere(605.4267578125, -21.1845703125, 1000.8994140625, 2.5)
sprayRegion.interior = 24

addCommandHandler('mekanikver', function(thePlayer, cmd, targetPlayer)
    if integration:isPlayerDeveloper(thePlayer) then
        if (targetPlayer) then
            local targetPlayer, targetPlayerName = global:findPlayerByPartialNick(thePlayer, targetPlayer)
            if targetPlayer then
                if targetPlayer:getData('mekanik') == 1 then
                    targetPlayer:setData('mekanik', tonumber(0))
                    dbExec(connection:getConnection(), "UPDATE `characters` SET mekanik='0' WHERE id='"..targetPlayer:getData('dbid').."'")
                    thePlayer:outputChat('[!]#D0D0D0 '..targetPlayer.name..' isimili oyuncunun mekanik yetkisini aldınız!',0,255,0,true)
                    targetPlayer:outputChat('[!]#D0D0D0 '..thePlayer.name..' isimili yetkili mekanik yetkinizi aldı!',0,255,0,true)
                else
                    targetPlayer:setData('mekanik', tonumber(1))
                    dbExec(connection:getConnection(), "UPDATE `characters` SET mekanik='1' WHERE id='"..targetPlayer:getData('dbid').."'")
                    thePlayer:outputChat('[!]#D0D0D0 '..targetPlayer.name..' isimili oyuncuya mekanik yetkisi verdiniz!',0,255,0,true)
                    targetPlayer:outputChat('[!]#D0D0D0 '..thePlayer.name..' isimili yetkili size mekanik yetkisi verdi!',0,255,0,true)
                end
            end
        else
            thePlayer:outputChat('[!]#D0D0D0 /'..cmd..' [ID/Partial Nick]',0,255,0,true)
        end
    end
end)

addCommandHandler('isbasi', function(thePlayer, cmd)
    if thePlayer:getData('mekanik') == 1 then
        if thePlayer:isWithinColShape(dutyRegion) then
            if thePlayer:getData('mekanik.duty') then
                thePlayer:outputChat('[!]#D0D0D0 Tamirci işbaşı bıraktınız.',0,255,0,true)
                thePlayer:setData('mekanik.duty', false)
            else
                thePlayer:outputChat('[!]#D0D0D0 Tamirci işbaşı yaptınız.',0,255,0,true)
                thePlayer.model = 50
                thePlayer:setData('mekanik.duty', true)
            end
            global:updateNametagColor(thePlayer)
        end
    end
end)

addCommandHandler('tamiret', function(thePlayer, cmd)
    if thePlayer:getData('mekanik') == 1 then
        if thePlayer:getData('mekanik.duty') then
            if thePlayer:isWithinColShape(fixvehRegion) then
                local vehicle = thePlayer.vehicle
                if vehicle then
                    fixVehicle(vehicle)
                    vehicle:setData('enginebroke', 0)
                    fixVehicle(vehicle)

                    exports.rl_infobox:addBox(thePlayer, "success", "Başarıyla Aracı Tamir Ettin.")

                end
            end
        else
            exports.rl_infobox:addBox(thePlayer, "error", "Önce Tamirci İşbaşı Yapmalısın.")
            -- thePlayer:outputChat('[!]#D0D0D0 Önce tamirci işbaşı yapmalısınız.',0,255,0,true)
        end
    end
end)

addCommandHandler('spreyal', function(thePlayer, cmd, weaponId)
    if thePlayer:getData('mekanik') == 1 then
        if thePlayer:getData('mekanik.duty') then
            if thePlayer:isWithinColShape(sprayRegion) then
                local weaponID = 41
                local weaponID = tonumber(weaponID)
                local characterid = tonumber(getElementData(thePlayer, "dbid"))
                local weaponSerial = exports["rl_global"]:createWeaponSerial(1, characterid)
                
                exports["rl_items"]:giveItem(thePlayer, 115, weaponID ..":".. weaponSerial ..":" .. getWeaponNameFromID (weaponID) .. " (T)")

                -- exports.rl_infobox:addBox(thePlayer, "succes", "Bir Sprey Aldınız.")
                thePlayer:outputChat('[!]#D0D0D0 Bir Sprey Aldınız.',0,255,0,true)
            else
                -- thePlayer:outputChat('[!]#D0D0D0 Sprey almak için 600₺ ödemeniz gerekli.',0,255,0,true)
            end
        else
            -- exports.rl_infobox:addBox(thePlayer, "error", "Önce Tamirci İşbaşı Yapmalısın.")
            thePlayer:outputChat('[!]#D0D0D0 Önce tamirci işbaşı yapmalısınız.',0,255,0,true)
        end
    end
end)

addCommandHandler('tamirci', function(thePlayer, cmd)
    if thePlayer:getData('logged') then
        thePlayer:outputChat('[!]#D0D0D0 Aktif Tamirciler Listeleniyor:',0,255,0,true)
        for _, player in ipairs(Element.getAllByType('player')) do
            if player:getData('mekanik') == 1 then
                local duty = 'Kapalı'
                if player:getData('mekanik.duty') then
                    duty = 'Açık'
                end
                local playerItems = exports["rl_items"]:getItems(player)
				local pnumber = " Yok"
				for k, v in ipairs(playerItems) do
					if v[1] == 2 then
						pnumber = v[2]
					end
				end
                thePlayer:outputChat('[!]#D0D0D0 İsim: '..player.name..' / Numara: '..pnumber..' / Durum: '..duty..'',0,255,0,true)
            end
        end
    end
end)