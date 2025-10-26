function hurda (thePlayer,cmd,komut2)
if komut2=="kaporta" then 
if not isElementWithinColShape (thePlayer,hurda3) then
exports["rl_bildirim"]:addNotification(thePlayer, "Burda söküm yapamazsın!", "error")
return end


 if  exports.rl_global:hasItem(thePlayer,892) then 
 exports["rl_bildirim"]:addNotification(thePlayer, "Zaten aracın kaportasını söktün!", "error")
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
exports["rl_bildirim"]:addNotification(thePlayer, "Kaporta sökmeye başladınız!", "info")
setElementData(thePlayer,"kaporta:basla",true)

setTimer(function()
exports["rl_items"]:giveItem(thePlayer,892,1)
setElementData(thePlayer,"kaporta:basla",nil)
setElementFrozen(thePlayer, false)
exports.rl_global:removeAnimation(thePlayer)
exports["rl_bildirim"]:addNotification(thePlayer, "Sökümü başarılı bir şekilde yaptınız!", "succes")




end,sure,1)


end 
end
addCommandHandler("sok",hurda)