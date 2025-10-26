function hurda2 (thePlayer,cmd,komut1)
if komut1=="kapı" then 
if not isElementWithinColShape (thePlayer,hurda3) then
exports["rl_bildirim"]:addNotification(thePlayer, "Burda söküm yapamazsın!", "info")
return end
    
  
 if not getElementData(thePlayer,"arac:al")then
 exports["rl_bildirim"]:addNotification(thePlayer, "İşlemi yapmak için parçalayacak araç almalısın!", "info")
 return end 
 if  exports.rl_global:hasItem(thePlayer,893) then 
 exports["rl_bildirim"]:addNotification(thePlayer, "Zaten aracın kapısını söktün!", "info")
setElementData(thePlayer,"kapı:basla",false)
return end
  
if getElementData(thePlayer,"lastik:basla")then
exports["rl_bildirim"]:addNotification(thePlayer, "Zaten aracın lastiğini söktün!", "info")
return end

if getElementData(thePlayer,"kapı:basla")then

exports["rl_bildirim"]:addNotification(thePlayer, "Zaten kapı söküyorsun!", "info")

return end

if getElementData(thePlayer,"kaporta:basla") then
exports["rl_bildirim"]:addNotification(thePlayer, "Zaten kaporta söküyorsun!", "info")
return end


exports["rl_bildirim"]:addNotification(thePlayer, "Kapı sökmeye başladınız!", "info")
triggerClientEvent(thePlayer,"ses:ac",thePlayer)
setElementFrozen(thePlayer, true)
exports.rl_global:applyAnimation(thePlayer, "CAR_CHAT", "car_talkm_loop", -1, true, false, false)
setElementData(thePlayer,"kapı:basla",true)






    
setTimer(function()
exports["rl_items"]:giveItem(thePlayer,893,1)
setElementData(thePlayer,"kapı:basla",nil)
setElementFrozen(thePlayer, false)
exports["rl_bildirim"]:addNotification(thePlayer, "Sökümü başarılı bir şekilde yaptınız!", "succes")

exports.rl_global:removeAnimation(thePlayer)
    
    
 end,sure,1)
 end
 end
 
 addCommandHandler("sok",hurda2)
 
 
 
 

function bilgiver (thePlayer)
outputChatBox("/sok [kapı,lastik,kaporta] yazarak sökme işlemini yapabilirsin.",thePlayer,255,0,0,true)
outputChatBox("Merhaba",thePlayer,255,0,0,true)
outputChatBox("Merhaba",thePlayer,255,0,0,true)
end
addCommandHandler("hurdabilgi",bilgiver)