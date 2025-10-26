local altinBolge = createColSphere (-2000.3720703125, -1566.6884765625, 85.875045776367, 40, 3, 81)
addCommandHandler("altin", function(plr, cmd,komut)

local Kazma = 361
local AltinFiyati = (1120+80)*2
local IslenmisAltin = 356

local SunucuAdi = "Reval"

if not isElementWithinColShape(plr, altinBolge) then
outputChatBox("["..SunucuAdi.."]#ffffff Burada altın kazıması yapamazsın.",plr,255,0,0,true)
return end

if not exports.rl_global:hasItem(plr,Kazma) then outputChatBox("["..SunucuAdi.."]#ffffff Bakır kazabilmek için 'Kazma' satın almalısın.",plr,255,194,14,true) return end
--if exports.rl_global:hasItem(plr,IslenmisAltin) then outputChatBox("[!]#ffffff Envanterinde işlenmiş altın taşıyorken altın kazamazsın.",plr,255,194,14,true) return end
if getElementData(plr, "altin:durum") then
	exports['rl_bildirim']:addNotification(plr, "Altın kazabilmen için 5 dakika beklemen gerekiyor.", "error")
	--outputChatBox("["..SunucuAdi.."]#ffffff Altın kazabilmen için 5 dakika beklemen gerekiyor.",plr,255,0,0,true)
return end

	if not komut then
		outputChatBox("["..SunucuAdi.."]#FFFFFF /"..cmd.." [kaz] yazarak toplayabilirsiniz.",plr,255,194,14,true)
	return end
	
if komut == "kaz" then
local randomdeger = math.random(1,1)
	exports['rl_bildirim']:addNotification(plr, "Altın kazmaya başladın.", "info")
	--outputChatBox("["..SunucuAdi.."]#ffffff Altın toplamaya başladın..",plr,0,255,0,true)
	setElementData(plr, "altin:durum", true)
	exports.rl_global:applyAnimation(plr, "BASEBALL", "bat_4", -1, true, false, false)	
	setTimer(function()
for i=1, randomdeger, 1 do
	exports["rl_items"]:giveItem(plr,IslenmisAltin,1)
end
		exports['rl_bildirim']:addNotification(plr, "Tebrikler, işlenmiş madeninizi artık kuyumcuda satabilirsiniz.", "info")
		--outputChatBox("["..SunucuAdi.."]#ffffff Tebrikler, işlenmiş madeninizi artık kuyumcuda satabilirsiniz.",plr,0,255,0,true)
		exports.rl_global:removeAnimation(plr)		
		setTimer(function()
		outputChatBox("["..SunucuAdi.."]#ffffff Süren doldu, yeniden altın toplayabilirsin.",plr,0,255,0,true)
			setElementData(plr, "altin:durum", nil)
		end, 300000, 1)
	end, 10000, 1)

end

end)