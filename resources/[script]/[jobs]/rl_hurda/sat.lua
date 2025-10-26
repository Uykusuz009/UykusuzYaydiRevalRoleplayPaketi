function sat5(thePlayer,cmd,sat6)
if sat6 == "sat" then

if not isElementWithinColShape(thePlayer,sat1) then
outputChatBox("[Reval] #FFFFFFBurada satış yapamazsın.",thePlayer,255,0,0,true)
return end

setElementData(thePlayer,"parca:sat",true)

if not exports.rl_global:hasItem(thePlayer,893) then outputChatBox("[Reval] #FFFFFFÜzerinde araç kapısı bulunmamakta!",thePlayer,255,0,0,true) return end
if not exports.rl_global:hasItem(thePlayer,892) then outputChatBox("[Reval] #FFFFFFÜzerinde araç kaportası bulunmamakta!",thePlayer,255,0,0,true) return end
if not exports.rl_global:hasItem(thePlayer,894) then outputChatBox("[Reval] #FFFFFFÜzerinde araç lastiği bulunmamakta!",thePlayer,255,0,0,true) return end

exports["rl_items"]:takeItem(thePlayer,893)
exports["rl_items"]:takeItem(thePlayer,892)
exports["rl_items"]:takeItem(thePlayer,894)

exports.rl_global:giveMoney(thePlayer,sat)
exports["rl_bildirim"]:addNotification(thePlayer, "Başarılı şekilde araç parçalarını sattınız.", "succes")
exports["rl_bildirim"]:addNotification(thePlayer, "500TL Kazandınız.", "buy")
end
end
addCommandHandler("parca",sat5)