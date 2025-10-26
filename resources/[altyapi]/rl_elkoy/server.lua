function takegun(player, targetPlayer, weaponSerial)
        if not targetPlayer then
            return outputChatBox("[!] #ffffffKarşı oyuncu bulunamadı.", player, 255, 0, 0, true)
        end
        local itemSlot =  exports['rl_items']:getItems(targetPlayer)
        for i, v in ipairs(itemSlot) do         
                if explode(":", v[2])[2] and (explode(":", v[2])[2] == weaponSerial) then
                
                    exports['rl_items']:takeItem(targetPlayer, 115, v[2])
                    local silahHak = #tostring(explode(":", v[2])[6])>0 and tonumber(explode(":", v[2])[6]) or 3
                    if (silahHak-1) >= 1 then
                        exports['rl_items']:giveItem(targetPlayer, 115, tonumber(explode(":", v[2])[1])..":"..tostring(explode(":", v[2])[2])..":"..tostring(explode(":", v[2])[3])..":"..tostring(explode(":", v[2])[4])..":"..tostring(explode(":", v[2])[5])..":"..tostring(silahHak-1))
                        
       
                        outputChatBox("[!] #ffffff"..(targetPlayer.name:gsub('_',' ')).." adlı kişinin, "..explode(":", v[2])[3].." silahına el koydunuz. Kalan silah hakkı: "..(silahHak-1).."", player, 0, 55, 255, true)
                        outputChatBox("[!] #ffffff"..(player.name:gsub('_',' ')).." adlı kişi, "..explode(":", v[2])[3].." silahınıza el koydu. Kalan silah hakkınız: "..(silahHak-1).."", targetPlayer, 0, 55, 255, true)
                        return
                    else
                        outputChatBox("[!] #ffffff"..(targetPlayer.name:gsub('_',' ')).." adlı kişinin, "..explode(":", v[2])[3].." silahına el koydunuz. Silah silindi.", player, 0, 55, 255, true)      
                        outputChatBox("[!] #ffffff"..(player.name:gsub('_',' ')).." adlı kişi, "..explode(":", v[2])[3].." silahınıza el koydu. Silah silindi.", targetPlayer, 0, 55, 255, true)     
                        return
                    end
        end
    end
end
addEvent(getResourceName(getThisResource())..' >> takeGun', true)
addEventHandler(getResourceName(getThisResource())..' >> takeGun', root, takegun)

function takeLicense(player, targetPlayer, license)
    dbExec(exports.rl_mysql:getConnection(), "UPDATE characters SET "..(license).."_license='0' WHERE id = "..(getElementData(targetPlayer, "dbid")).." LIMIT 1") -- sql'den değiştiriyor.
    setElementData(targetPlayer, "license."..license,0)
    if license == "car" then
        license = "Arac"
    elseif license == "bike" then
        license = "Motor"
    end
    outputChatBox('[!]#D6D6D6 '..(player.name:gsub('_',' '))..', tarafından '..license..' ehliyetinize el konuldu.',targetPlayer, 180, 0, 0, true) 
    outputChatBox('[!]#D6D6D6 '..(targetPlayer.name:gsub('_',' '))..', isimli oyuncunun '..license..' ehliyetine el konuldu.',player, 0, 180, 0, true)  
end
addEvent(getResourceName(getThisResource())..' >> takeLicense', true)
addEventHandler(getResourceName(getThisResource())..' >> takeLicense', root, takeLicense)

function command(player,cmd,targetPlayer)
    local targetPlayer, targetPlayerName = exports.rl_global:findPlayerByPartialNick(targetPlayer, targetPlayer)
    if not targetPlayer then
        outputChatBox('[!]#D6D6D6 Komut kullanımı:/'..cmd..' [Oyuncu ismi & ID]',player, 0, 0, 255, true)
        return false
    end
    if tonumber(getElementData(player,'faction')) ~= 1 then
    	outputChatBox('[!]#ffffff Bu komutu kullanmak için LSPD üyesi olmalısın.',player, 255, 0, 0, true)
    	return false
    end
    if getDistanceBetweenPoints3D(player.position,targetPlayer.position) > 10 then
        outputChatBox('[!]#D6D6D6 '..targetPlayerName..' isimli oyuncudan çok uzaktasın',player, 180, 0, 0, true)
        return false
    end
   triggerClientEvent ( player, getResourceName(getThisResource())..' >> loadedWeapon', player, targetPlayer, exports['rl_items']:getItems(targetPlayer))
end
addCommandHandler('elkoy',command)