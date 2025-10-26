function hurda1 (thePlayer,cmd,komut)
if komut=="lastik" then 
if not isElementWithinColShape (thePlayer,hurda3) then
exports["rl_bildirim"]:addNotification(thePlayer, "Burda söküm yapamazsın!", "error")
return end
    
if  exports.rl_global:hasItem(thePlayer,894) then 
 exports["rl_bildirim"]:addNotification(thePlayer, "Zaten aracın lastiğini söktüyorsunuz!", "error")
setElementData(thePlayer,"kapı:basla",false)
return end
 if not getElementData(thePlayer,"arac:al")then
 exports["rl_bildirim"]:addNotification(thePlayer, "İşlemi yapmak için parçalayacak araç almalısın!", "info")
 return end 

if getElementData(thePlayer,"lastik:basla")then

exports["rl_bildirim"]:addNotification(thePlayer, "Zaten aracın lastiğini söktün!", "error")
return end

if getElementData(thePlayer,"kapı:basla")then

exports["rl_bildirim"]:addNotification(thePlayer, "Zaten kapı söküyorsun!", "error")

return end

if getElementData(thePlayer,"kaporta:basla") then
exports["rl_bildirim"]:addNotification(thePlayer, "Zaten kaporta söküyorsun!", "error")
return end
triggerClientEvent(thePlayer,"ses:ac",thePlayer)
setElementFrozen(thePlayer, true)
exports.rl_global:applyAnimation(thePlayer, "CAR_CHAT", "car_talkm_loop", -1, true, false, false)
exports["rl_bildirim"]:addNotification(thePlayer, "Lastik sökmeye başladınız!", "info")
setElementData(thePlayer,"lastik:basla",true)

setTimer(function()
exports["rl_items"]:giveItem(thePlayer,894,1)
setElementData(thePlayer,"lastik:basla",nil)
setElementFrozen(thePlayer, false)
exports.rl_global:removeAnimation(thePlayer)
exports["rl_bildirim"]:addNotification(thePlayer, "Sökümü başarılı bir şekilde yaptınız!", "succes")
    
    
end,sure,1)
    


	 
    
end   
end
 addCommandHandler("sok",hurda1)
 