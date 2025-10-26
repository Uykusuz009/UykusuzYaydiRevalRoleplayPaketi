function arac(thePlayer,cmd,komut4)
if komut4 == "arac" then

if not isElementWithinColShape(thePlayer,aracalan) then
exports["rl_bildirim"]:addNotification(thePlayer, "Burdan araç satın alamazsın !!!!", "info")
return end

if getElementData (thePlayer,"arac:al") then
exports["rl_bildirim"]:addNotification(thePlayer, "Zaten parçalayacak aracın var!", "info")
return end

exports.rl_global:takeMoney(thePlayer,aracpara)
exports["rl_bildirim"]:addNotification(thePlayer, "Başarıyla araç satın aldınız.", "info")
setElementData(thePlayer,"arac:al",true)

end
end
addCommandHandler("satınal",arac)

function arac2(thePlayer,cmd,komut5)
if komut5 == "sıfırla" then
outputChatBox("Sıfırlama işlemi başarılı",thePlayer,255,0,0,true)
setElementData (thePlayer ,"arac:al",nil)
end
end
addCommandHandler("hurda",arac2)