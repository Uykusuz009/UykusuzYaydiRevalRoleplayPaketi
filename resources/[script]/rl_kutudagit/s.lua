function surprizkutu(thePlayer)
local Ssans = math.random( 1 , 100)
local gSsans = tonumber(ssans)
if not (exports.rl_global:hasItem(thePlayer, 5555))then
               -- outputChatBox("#FF0000[!]#FFFFFFHediye kutun olmadan açamazsın.",thePlayer,0, 0, 0, true)
                exports["rl_bildirim"]:addNotification(thePlayer, "Hediye kutun olmadan açamazsın.", "error")
		return
	end
if ( Ssans == 5 or Ssans <= 5 ) then 
exports.rl_global:takeItem(thePlayer, 5555 , 1)
exports.rl_global:giveMoney(thePlayer, 100000)
exports["rl_bildirim"]:addNotification(thePlayer, "Tebrikler hediye kutusundan 100.000₺ kazandın.", "success")

elseif ( Ssans >= 6 and Ssans <= 45 ) or ( Ssans == 6 and Ssans == 45 )then 
exports.rl_global:takeItem(thePlayer, 5555 , 1)
exports.rl_global:giveMoney(thePlayer, 75000)
exports["rl_bildirim"]:addNotification(thePlayer, "Tebrikler hediye kutusundan 75.000₺ kazandın.", "success")



elseif ( Ssans >= 46 and Ssans <= 60 ) or ( Ssans ==46 and Ssans == 60 )then 
exports.rl_global:takeItem(thePlayer, 5555 , 1)
exports.rl_global:giveMoney(thePlayer, 50000)
exports["rl_bildirim"]:addNotification(thePlayer, "Tebrikler hediye kutusundan 50.000₺ kazandın.", "success")


elseif ( Ssans >= 61 and Ssans <= 100 ) or ( Ssans ==61 and Ssans == 100 )then 
exports.rl_global:takeItem(thePlayer, 5555 , 1)
exports.rl_global:giveMoney(thePlayer, 25000)
exports["rl_bildirim"]:addNotification(thePlayer, "Tebrikler hediye kutusundan 25.000₺ kazandın.", "success")
end
end
addCommandHandler("kutuac", surprizkutu)

